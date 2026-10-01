package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.LeaveDAO;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Holiday;
import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.User;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Service xử lý nghiệp vụ nghỉ phép & nghỉ lễ.
 * Tuân thủ quy tắc MVC + DAO + Service Layer:
 * - Kiểm tra tính hợp lệ & giới hạn số dư ngày phép (Quota & Accrual)
 * - Tự động loại trừ Thứ 7, Chủ Nhật và Ngày Lễ/Tết Quốc Gia
 * - Ngăn chặn trùng lặp thời gian đơn nghỉ phép
 * - Quy trình phê duyệt 2 cấp: Trưởng phòng (Cấp 1) -> Nhân sự (Cấp 2)
 * - Cảnh báo tỷ lệ vắng mặt phòng ban (Department Capacity Guard > 30%)
 * - Đồng bộ và hoàn tác dữ liệu sang bảng chấm công (Attendance)
 */
public class LeaveService {

    private final LeaveDAO leaveDAO = new LeaveDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    public List<LeaveRequest> getAll() {
        return leaveDAO.findAll();
    }

    public List<LeaveRequest> getByEmployee(int employeeId) {
        return leaveDAO.findByEmployeeId(employeeId);
    }

    public List<LeaveRequest> getPending() {
        return leaveDAO.findByStatus("PENDING");
    }

    public List<LeaveRequest> getByFilters(User user, String status, Integer departmentId,
                                          String leaveType, String keyword) {
        return leaveDAO.findByFilters(user, status, departmentId, leaveType, keyword);
    }

    public LeaveRequest getById(int id) {
        return leaveDAO.findById(id);
    }

    public int countPending() {
        return leaveDAO.countPending();
    }

    /**
     * Lấy danh sách ngày nghỉ lễ theo năm
     */
    public List<Holiday> getHolidays(int year) {
        return leaveDAO.getHolidaysByYear(year);
    }

    /**
     * Tính số ngày làm việc thực tế giữa 2 mốc thời gian:
     * - Tự động loại trừ Thứ Bảy và Chủ Nhật.
     * - Tự động loại trừ các ngày Lễ/Tết quốc gia theo Luật Lao Động (bảng holidays).
     */
    public double calculateActualWorkingDays(LocalDate start, LocalDate end, boolean isHalfDay) {
        if (start == null || end == null || end.isBefore(start)) {
            return 0.0;
        }
        Set<LocalDate> holidays = new HashSet<>();
        holidays.addAll(leaveDAO.getHolidayDates(start.getYear()));
        if (end.getYear() != start.getYear()) {
            holidays.addAll(leaveDAO.getHolidayDates(end.getYear()));
        }

        if (isHalfDay) {
            // Nửa ngày chỉ áp dụng cho 1 ngày cụ thể
            if (start.getDayOfWeek() == DayOfWeek.SATURDAY || start.getDayOfWeek() == DayOfWeek.SUNDAY || holidays.contains(start)) {
                return 0.0;
            }
            return 0.5;
        }
        double count = 0.0;
        LocalDate curr = start;
        while (!curr.isAfter(end)) {
            if (curr.getDayOfWeek() != DayOfWeek.SATURDAY && curr.getDayOfWeek() != DayOfWeek.SUNDAY && !holidays.contains(curr)) {
                count += 1.0;
            }
            curr = curr.plusDays(1);
        }
        return count;
    }

    /**
     * Tính tỷ lệ vắng mặt cao nhất của phòng ban trong khoảng thời gian xin nghỉ
     */
    public double getMaxDepartmentAbsenceRate(int departmentId, LocalDate start, LocalDate end, Integer excludeId) {
        if (departmentId <= 0 || start == null || end == null) return 0.0;
        double maxRate = 0.0;
        LocalDate curr = start;
        while (!curr.isAfter(end)) {
            if (curr.getDayOfWeek() != DayOfWeek.SATURDAY && curr.getDayOfWeek() != DayOfWeek.SUNDAY) {
                double rate = leaveDAO.getDepartmentAbsenceRateOnDate(departmentId, curr, excludeId);
                if (rate > maxRate) {
                    maxRate = rate;
                }
            }
            curr = curr.plusDays(1);
        }
        return maxRate;
    }

    /**
     * Tính tiền thanh toán phép năm chưa nghỉ khi nghỉ việc theo Luật Lao Động 2019 (Điều 113)
     * Công thức: Số ngày phép còn lại * (Lương cơ bản / 26)
     */
    public double calculateLeaveEncashment(int employeeId, int year, double baseSalary) {
        Employee emp = employeeDAO.findById(employeeId);
        int startYear = (emp != null && emp.getStartDate() != null) ? emp.getStartDate().getYear() : year;
        double balance = leaveDAO.calculateLeaveBalance(employeeId, year, startYear);
        if (balance <= 0 || baseSalary <= 0) return 0.0;
        return (double) Math.round(balance * (baseSalary / 26.0));
    }

    /**
     * Tạo đơn xin nghỉ phép có kiểm soát logic nghiệp vụ chặt chẽ.
     */
    public String createLeaveRequest(LeaveRequest lr) {
        if (lr.getStartDate() == null || lr.getEndDate() == null)
            return "Vui lòng chọn ngày bắt đầu và ngày kết thúc.";
        if (lr.getEndDate().isBefore(lr.getStartDate()))
            return "Ngày kết thúc không được trước ngày bắt đầu.";
        if (lr.getReason() == null || lr.getReason().trim().isEmpty())
            return "Vui lòng nhập lý do xin nghỉ phép.";

        // Nếu là nghỉ nửa ngày: ngày kết thúc luôn bằng ngày bắt đầu
        if (lr.isHalfDay()) {
            lr.setEndDate(lr.getStartDate());
        }

        // 1. Tính toán số ngày làm việc thực tế loại trừ ngày cuối tuần & ngày lễ
        double workingDays = calculateActualWorkingDays(lr.getStartDate(), lr.getEndDate(), lr.isHalfDay());
        if (workingDays <= 0) {
            return "Khoảng thời gian bạn chọn rơi vào ngày nghỉ cuối tuần hoặc ngày lễ. Vui lòng chọn ngày làm việc trong tuần.";
        }
        lr.setDays(workingDays);

        // 2. Kiểm tra trùng lặp khoảng thời gian với các đơn đã nộp trước đó (PENDING, MANAGER_APPROVED hoặc APPROVED)
        if (leaveDAO.hasOverlappingLeave(lr.getEmployeeId(), lr.getStartDate(), lr.getEndDate(), lr.getId() > 0 ? lr.getId() : null)) {
            return "Bạn đã có đơn nghỉ phép (Chờ duyệt hoặc Đã duyệt) trùng với khoảng thời gian từ " 
                    + lr.getStartDate() + " đến " + lr.getEndDate() + ". Vui lòng kiểm tra lại.";
        }

        // 3. Kiểm tra số dư phép năm (Quota) nếu là nghỉ phép thường niên (ANNUAL)
        if ("ANNUAL".equalsIgnoreCase(lr.getLeaveType())) {
            int year = lr.getStartDate().getYear();
            Employee emp = employeeDAO.findById(lr.getEmployeeId());
            int startYear = (emp != null && emp.getStartDate() != null) ? emp.getStartDate().getYear() : year;
            double available = leaveDAO.calculateLeaveBalance(lr.getEmployeeId(), year, startYear);
            if (lr.getDays() > available) {
                return String.format("Số ngày nghỉ phép năm yêu cầu (%.1f ngày) vượt quá số dư khả dụng hiện tại (%.1f ngày). Vui lòng chọn loại nghỉ Không lương (UNPAID) hoặc điều chỉnh lại thời gian.", lr.getDays(), available);
            }
        }

        // 4. Sinh mã đơn tuần tự chuyên nghiệp (LP-YYYY-XXX)
        if (lr.getLeaveCode() == null || lr.getLeaveCode().trim().isEmpty()) {
            lr.setLeaveCode(leaveDAO.generateNextLeaveCode(lr.getStartDate()));
        }

        boolean ok = leaveDAO.insert(lr);
        return ok ? null : "Lỗi khi lưu đơn xin nghỉ phép vào hệ thống.";
    }

    /**
     * Cấp 1: Phê duyệt từ Quản lý / Trưởng phòng
     */
    public boolean managerApprove(int id, int managerId, String note) {
        return leaveDAO.managerApprove(id, managerId, note);
    }

    /**
     * Cấp 2: Phê duyệt từ Nhân sự (HR) - Hoàn tất quy trình & đồng bộ bảng công
     */
    public boolean hrApprove(int id, int hrId) {
        boolean ok = leaveDAO.hrApprove(id, hrId);
        if (ok) {
            syncLeaveToAttendance(id);
        }
        return ok;
    }

    /**
     * Duyệt đơn trực tiếp (dùng cho HR / Admin)
     */
    public boolean approve(int id, int approvedById) {
        return hrApprove(id, approvedById);
    }

    public boolean reject(int id, int rejectedById, String reason) {
        LeaveRequest lr = leaveDAO.findById(id);
        boolean ok = leaveDAO.reject(id, rejectedById, reason);
        if (ok && lr != null) {
            // Hoàn tác dữ liệu chấm công nếu đơn từng được đồng bộ
            attendanceDAO.removeSystemLeaveAttendance(lr.getEmployeeId(), lr.getStartDate(), lr.getEndDate());
        }
        return ok;
    }

    public boolean cancelLeave(int leaveId, int employeeId) {
        LeaveRequest lr = leaveDAO.findById(leaveId);
        boolean ok = leaveDAO.cancelLeave(leaveId, employeeId);
        if (ok && lr != null) {
            // Thu hồi bản ghi chấm công tự động nếu đơn đã được phê duyệt trước khi hủy
            attendanceDAO.removeSystemLeaveAttendance(lr.getEmployeeId(), lr.getStartDate(), lr.getEndDate());
        }
        return ok;
    }

    public int bulkApprove(List<Integer> ids, int approvedById) {
        int count = leaveDAO.bulkApprove(ids, approvedById);
        if (ids != null) {
            for (Integer id : ids) {
                syncLeaveToAttendance(id);
            }
        }
        return count;
    }

    public int bulkReject(List<Integer> ids, int rejectedById, String reason) {
        if (ids != null) {
            for (Integer id : ids) {
                LeaveRequest lr = leaveDAO.findById(id);
                if (lr != null) {
                    attendanceDAO.removeSystemLeaveAttendance(lr.getEmployeeId(), lr.getStartDate(), lr.getEndDate());
                }
            }
        }
        return leaveDAO.bulkReject(ids, rejectedById, reason);
    }

    public int bulkDelete(List<Integer> ids) {
        if (ids != null) {
            for (Integer id : ids) {
                LeaveRequest lr = leaveDAO.findById(id);
                if (lr != null) {
                    attendanceDAO.removeSystemLeaveAttendance(lr.getEmployeeId(), lr.getStartDate(), lr.getEndDate());
                }
            }
        }
        return leaveDAO.bulkDelete(ids);
    }

    public List<LeaveRequest> findByIds(List<Integer> ids) {
        return leaveDAO.findByIds(ids);
    }

    /**
     * Tự động đồng bộ các ngày trong đơn nghỉ phép đã duyệt sang bảng chấm công (attendance)
     * - Trừ Thứ Bảy, Chủ Nhật và ngày lễ/Tết.
     * - Dữ liệu nửa ngày (0.5 ngày) đồng bộ trạng thái HALF_DAY với 4.0 giờ làm việc.
     * - Dữ liệu cả ngày đồng bộ trạng thái ON_LEAVE với 8.0 giờ làm việc.
     */
    private void syncLeaveToAttendance(int leaveRequestId) {
        try {
            LeaveRequest lr = leaveDAO.findById(leaveRequestId);
            if (lr != null && lr.getStartDate() != null && lr.getEndDate() != null) {
                Set<LocalDate> holidays = new HashSet<>();
                holidays.addAll(leaveDAO.getHolidayDates(lr.getStartDate().getYear()));
                if (lr.getEndDate().getYear() != lr.getStartDate().getYear()) {
                    holidays.addAll(leaveDAO.getHolidayDates(lr.getEndDate().getYear()));
                }

                LocalDate today = LocalDate.now();
                if (lr.isHalfDay()) {
                    if (!lr.getStartDate().isAfter(today) &&
                        lr.getStartDate().getDayOfWeek() != DayOfWeek.SATURDAY && 
                        lr.getStartDate().getDayOfWeek() != DayOfWeek.SUNDAY &&
                        !holidays.contains(lr.getStartDate())) {
                        attendanceDAO.recordHalfDayLeave(
                                lr.getEmployeeId(), lr.getStartDate(), lr.getLeaveSession(), lr.getLeaveType(), lr.getReason()
                        );
                    }
                } else {
                    LocalDate curr = lr.getStartDate();
                    LocalDate endSync = lr.getEndDate().isAfter(today) ? today : lr.getEndDate();
                    while (!curr.isAfter(endSync)) {
                        if (curr.getDayOfWeek() != DayOfWeek.SATURDAY && 
                            curr.getDayOfWeek() != DayOfWeek.SUNDAY &&
                            !holidays.contains(curr)) {
                            attendanceDAO.recordLeaveAttendance(
                                    lr.getEmployeeId(), curr, lr.getLeaveType(), lr.getReason()
                            );
                        }
                        curr = curr.plusDays(1);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("LeaveService.syncLeaveToAttendance lỗi: " + e.getMessage());
        }
    }
}
