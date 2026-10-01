package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.model.TimesheetSummary;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

/**
 * Service xử lý nghiệp vụ chấm công.
 * <p>
 * MỌI business rule (giờ chuẩn, trạng thái, validation) đều tập trung tại đây.
 * Servlet CHỈ được gọi Service — không gọi AttendanceDAO trực tiếp.
 * </p>
 *
 * Giờ chuẩn thống nhất: Vào 08:30 / Ra 17:30 / Ân hạn 15 phút (theo quy chế).
 */
public class AttendanceService {

    // =====================================================================
    // Hằng số nghiệp vụ — NGUỒN DUY NHẤT cho toàn hệ thống
    // =====================================================================
    /** Giờ bắt đầu ca hành chính (08:30) */
    public static final LocalTime STANDARD_IN  = LocalTime.of(8, 30);
    /** Giờ kết thúc ca hành chính (17:30) */
    public static final LocalTime STANDARD_OUT = LocalTime.of(17, 30);
    /**
     * Ân hạn muộn (phút): trễ dưới GRACE_MIN phút không bị đánh LATE.
     * Tối đa 3 lần/tháng — logic phạt chi tiết ở countWorkingDays().
     */
    public static final int GRACE_MIN = 15;

    // =====================================================================
    // Enum kết quả — thay cho boolean mơ hồ
    // =====================================================================

    /** Kết quả thao tác Check-in */
    public enum CheckInResult {
        SUCCESS,          // Check-in thành công
        ALREADY_IN,       // Đã check-in trước đó trong ngày
        ON_LEAVE,         // Nhân viên đang trong kỳ nghỉ đã duyệt
        TIMESHEET_LOCKED, // Bảng công tháng đã bị khóa
        FAILED            // Lỗi DB hoặc lỗi không xác định
    }

    /** Kết quả thao tác Check-out */
    public enum CheckOutResult {
        SUCCESS,          // Check-out thành công
        NOT_CHECKED_IN,   // Chưa check-in → không cho checkout
        ALREADY_OUT,      // Đã check-out trong ngày
        ON_LEAVE,         // Nhân viên đang nghỉ phép
        TIMESHEET_LOCKED, // Bảng công đã khóa
        FAILED            // Lỗi DB
    }

    // =====================================================================
    // Dependencies
    // =====================================================================
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final EmployeeDAO   employeeDAO   = new EmployeeDAO();

    // =====================================================================
    // Check-in / Check-out — đầy đủ validation
    // =====================================================================

    /**
     * Chấm công vào ca — tập trung toàn bộ validation nghiệp vụ.
     *
     * @param employeeId ID nhân viên
     * @param date       Ngày làm việc
     * @param time       Giờ check-in thực tế
     * @param method     Phương thức: FaceID | Fingerprint | GPS | Manual
     * @return CheckInResult enum
     */
    public CheckInResult checkIn(int employeeId, LocalDate date, LocalTime time, String method) {
        // 1. Kiểm tra bảng công tháng đã bị khóa chưa
        if (attendanceDAO.isTimesheetLocked(date.getMonthValue(), date.getYear())) {
            return CheckInResult.TIMESHEET_LOCKED;
        }

        // 2. Kiểm tra nhân viên có trong kỳ nghỉ phép đã duyệt không
        Attendance existing = attendanceDAO.findByEmployeeAndDate(employeeId, date);
        boolean isLeaveRecord = existing != null && "ON_LEAVE".equalsIgnoreCase(existing.getStatus());
        if (isLeaveRecord || attendanceDAO.isEmployeeOnLeave(employeeId, date)) {
            return CheckInResult.ON_LEAVE;
        }

        // 3. Kiểm tra đã check-in trước đó chưa
        if (existing != null && existing.getCheckIn() != null) {
            return CheckInResult.ALREADY_IN;
        }

        // 4. Xác định trạng thái (business rule duy nhất)
        String status = determineCheckInStatus(time);
        String methodLabel = (method != null && !method.isBlank()) ? method : "FaceID";
        String notes = "Check-in bằng " + methodLabel + " lúc " + formatTime(time);

        // 5. Delegate DAO
        boolean ok = attendanceDAO.checkInRaw(employeeId, date, time, methodLabel, status, notes);
        return ok ? CheckInResult.SUCCESS : CheckInResult.FAILED;
    }

    /**
     * Chấm công ra ca — tập trung toàn bộ validation nghiệp vụ.
     *
     * @param employeeId ID nhân viên
     * @param date       Ngày làm việc
     * @param time       Giờ check-out thực tế
     * @return CheckOutResult enum
     */
    public CheckOutResult checkOut(int employeeId, LocalDate date, LocalTime time) {
        // 1. Kiểm tra bảng công đã khóa chưa
        if (attendanceDAO.isTimesheetLocked(date.getMonthValue(), date.getYear())) {
            return CheckOutResult.TIMESHEET_LOCKED;
        }

        // 2. Kiểm tra đang nghỉ phép
        Attendance existing = attendanceDAO.findByEmployeeAndDate(employeeId, date);
        if ((existing != null && "ON_LEAVE".equalsIgnoreCase(existing.getStatus()))
                || attendanceDAO.isEmployeeOnLeave(employeeId, date)) {
            return CheckOutResult.ON_LEAVE;
        }

        // 3. Bắt buộc phải có check-in trước
        if (existing == null || existing.getCheckIn() == null) {
            return CheckOutResult.NOT_CHECKED_IN;
        }

        // 4. Ngăn check-out nhiều lần
        if (existing.getCheckOut() != null) {
            return CheckOutResult.ALREADY_OUT;
        }

        // 5. Tính hours & status rồi delegate DAO
        boolean ok = attendanceDAO.checkOut(employeeId, date, time);
        return ok ? CheckOutResult.SUCCESS : CheckOutResult.FAILED;
    }

    // =====================================================================
    // Auto-seed — CHỈ chạy khi thực sự thiếu data
    // =====================================================================

    /**
     * Đảm bảo dữ liệu chấm công tháng/năm tồn tại.
     * Gọi từ Servlet khi load trang. KHÔNG seed nếu đã đủ data.
     */
    public void ensureMonthDataExists(int month, int year) {
        int activeCount = employeeDAO.countActive();
        if (activeCount <= 0) return;
        if (!attendanceDAO.hasEnoughDataForMonth(month, year, activeCount)) {
            attendanceDAO.autoSeedMonthAttendance(month, year);
        }
    }

    // =====================================================================
    // Manual upsert (Admin/HR)
    // =====================================================================

    /**
     * Ghi chấm công thủ công hoặc điều chỉnh.
     * Chỉ Admin/HR được gọi — role check thực hiện ở Servlet.
     */
    public boolean upsertManual(int employeeId, LocalDate date,
                                 LocalTime checkIn, LocalTime checkOut,
                                 String status, String notes) {
        if (attendanceDAO.isTimesheetLocked(date.getMonthValue(), date.getYear())) {
            return false;
        }
        return attendanceDAO.upsertManual(employeeId, date, checkIn, checkOut, status, notes);
    }

    /**
     * Cập nhật bản ghi chấm công theo ID.
     * Kiểm tra timesheet lock trước khi cập nhật.
     */
    public boolean updateById(int id, LocalTime checkIn, LocalTime checkOut, String status, String notes) {
        Attendance a = attendanceDAO.findById(id);
        if (a != null && a.getWorkDate() != null
                && attendanceDAO.isTimesheetLocked(a.getWorkDate().getMonthValue(), a.getWorkDate().getYear())) {
            return false;
        }
        return attendanceDAO.update(id, checkIn, checkOut, status, notes);
    }

    /**
     * Phê duyệt giải trình — chuyển sang ON_TIME.
     */
    public boolean approveExplain(int id) {
        Attendance a = attendanceDAO.findById(id);
        if (a != null && a.getWorkDate() != null
                && attendanceDAO.isTimesheetLocked(a.getWorkDate().getMonthValue(), a.getWorkDate().getYear())) {
            return false;
        }
        return attendanceDAO.approveExplain(id);
    }

    /**
     * Nhân viên gửi giải trình — chỉ cập nhật notes.
     */
    public boolean submitExplain(int attendanceId, String reason) {
        Attendance a = attendanceDAO.findById(attendanceId);
        if (a == null) return false;
        // Ghi đè notes bằng lý do giải trình của nhân viên
        return attendanceDAO.update(attendanceId, a.getCheckIn(), a.getCheckOut(), a.getStatus(), reason);
    }

    // =====================================================================
    // Timesheet lock
    // =====================================================================

    public boolean lockTimesheet(int month, int year, Integer userId, String note) {
        return attendanceDAO.setTimesheetLocked(month, year, true, userId, note);
    }

    public boolean unlockTimesheet(int month, int year, Integer userId, String note) {
        return attendanceDAO.setTimesheetLocked(month, year, false, userId, note);
    }

    public boolean isTimesheetLocked(int month, int year) {
        return attendanceDAO.isTimesheetLocked(month, year);
    }

    // =====================================================================
    // Bulk operations (Admin/HR only — Servlet đảm bảo role check)
    // =====================================================================

    public int bulkMarkOnTime(List<Integer> ids) {
        return attendanceDAO.bulkMarkStatus(ids, "ON_TIME");
    }

    public int bulkDelete(List<Integer> ids) {
        return attendanceDAO.bulkDelete(ids);
    }

    // =====================================================================
    // Queries — delegates to DAO
    // =====================================================================

    public Attendance getById(int id) {
        return attendanceDAO.findById(id);
    }

    public List<Attendance> getByEmployeeAndMonth(int employeeId, int month, int year) {
        return attendanceDAO.findByEmployeeAndMonth(employeeId, month, year);
    }

    public List<Attendance> getByMonth(int month, int year) {
        return attendanceDAO.findByMonth(month, year);
    }

    public List<Attendance> search(String keyword, Integer deptId, String status,
                                    LocalDate date, Integer month, Integer year) {
        return attendanceDAO.search(keyword, deptId, status, date, month, year);
    }

    /** DB-side pagination — không load toàn bộ vào RAM */
    public List<Attendance> searchPaged(String keyword, Integer deptId, String status,
                                         LocalDate date, Integer month, Integer year,
                                         int page, int pageSize) {
        return attendanceDAO.searchPaged(keyword, deptId, status, date, month, year, page, pageSize);
    }

    public int countSearch(String keyword, Integer deptId, String status,
                            LocalDate date, Integer month, Integer year) {
        return attendanceDAO.countSearch(keyword, deptId, status, date, month, year);
    }

    public Attendance getByEmployeeAndDate(int employeeId, LocalDate date) {
        return attendanceDAO.findByEmployeeAndDate(employeeId, date);
    }

    public Map<String, Integer> getTodayStats(LocalDate date) {
        return attendanceDAO.getTodayStats(date);
    }

    public List<TimesheetSummary> getTimesheetSummary(int month, int year) {
        return attendanceDAO.getTimesheetSummary(month, year);
    }

    public int countPendingExplains(Integer deptId) {
        return attendanceDAO.countPendingExplains(deptId);
    }

    public boolean deleteById(int id) {
        return attendanceDAO.delete(id);
    }

    public List<Attendance> findByIds(List<Integer> ids) {
        return attendanceDAO.findByIds(ids);
    }

    public double countWorkingDays(int employeeId, int month, int year) {
        return attendanceDAO.countWorkingDays(employeeId, month, year);
    }

    public boolean isEmployeeOnLeave(int employeeId, LocalDate date) {
        return attendanceDAO.isEmployeeOnLeave(employeeId, date);
    }

    // =====================================================================
    // Business rule helpers — NGUỒN DUY NHẤT
    // =====================================================================

    /**
     * Xác định trạng thái check-in dựa trên giờ vào.
     * Dùng STANDARD_IN = 08:30 và GRACE_MIN = 15 phút.
     */
    public static String determineCheckInStatus(LocalTime checkIn) {
        if (checkIn == null) return "ABSENT";
        // Trễ nếu vào sau 08:30 + GRACE_MIN (= 08:45)
        return checkIn.isAfter(STANDARD_IN.plusMinutes(GRACE_MIN)) ? "LATE" : "ON_TIME";
    }

    /**
     * Xác định trạng thái đầy đủ khi checkout.
     * - Giữ LATE nếu đã trễ buổi sáng
     * - EARLY_LEAVE nếu về trước 17:30 - GRACE_MIN (= 17:15)
     * - OVERTIME nếu ra sau 18:00
     * - Mặc định ON_TIME
     */
    public static String determineCheckOutStatus(String currentStatus, LocalTime checkIn, LocalTime checkOut) {
        if ("LATE".equalsIgnoreCase(currentStatus)) return "LATE";
        if (checkOut == null) return currentStatus != null ? currentStatus : "ON_TIME";
        if (checkOut.isBefore(STANDARD_OUT.minusMinutes(GRACE_MIN))) return "EARLY_LEAVE";
        if (checkOut.isAfter(STANDARD_OUT.plusMinutes(30)))           return "OVERTIME";
        return "ON_TIME";
    }

    /**
     * Tính tổng giờ làm thực tế.
     * Trừ 60 phút nghỉ trưa nếu làm từ 5 tiếng trở lên. Tối đa 8.0h.
     */
    public static double calculateWorkHours(LocalTime checkIn, LocalTime checkOut) {
        if (checkIn == null || checkOut == null) return 0.0;
        if (!checkOut.isAfter(checkIn)) return 0.5;
        long minutes = Duration.between(checkIn, checkOut).toMinutes();
        if (minutes >= 300) minutes = Math.max(0, minutes - 60);
        double hours = Math.round((minutes / 60.0) * 10.0) / 10.0;
        return Math.min(8.0, Math.max(0.1, hours));
    }

    private static String formatTime(LocalTime t) {
        if (t == null) return "";
        String s = t.toString();
        return s.length() >= 5 ? s.substring(0, 5) : s;
    }
}
