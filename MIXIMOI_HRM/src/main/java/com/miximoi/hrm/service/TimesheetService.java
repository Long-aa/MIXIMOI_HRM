package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.OvertimeDAO;
import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Overtime;
import com.miximoi.hrm.model.TimesheetItem;
import com.miximoi.hrm.model.User;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.*;

/**
 * Service xử lý Bảng tổng hợp công tháng & Ma trận chấm công chi tiết (/timesheet).
 * Hỗ trợ lưu trữ trạng thái khóa bảng công vào PostgreSQL và trích xuất ma trận thời gian thực.
 */
public class TimesheetService {

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final OvertimeDAO overtimeDAO = new OvertimeDAO();

    /**
     * Kiểm tra trạng thái khóa kỳ quyết toán từ DB.
     */
    public boolean isTimesheetLocked(int month, int year) {
        return attendanceDAO.isTimesheetLocked(month, year);
    }

    /**
     * Khóa hoặc mở khóa kỳ quyết toán công tháng.
     */
    public void setTimesheetLocked(int month, int year, boolean locked) {
        attendanceDAO.setTimesheetLocked(month, year, locked, null, locked ? "Khóa bảng công" : "Mở khóa bảng công");
    }

    public void setTimesheetLocked(int month, int year, boolean locked, Integer userId, String note) {
        attendanceDAO.setTimesheetLocked(month, year, locked, userId, note);
    }

    /**
     * Lấy danh sách nhân viên trong ma trận chấm công theo quyền Role và bộ lọc,
     * tổng hợp từ dữ liệu chấm công thực tế trong CSDL.
     */
    public List<TimesheetItem> getTimesheetMatrix(User user, int month, int year,
                                                 Integer departmentId, String statusFilter,
                                                 String shiftType, String keyword) {
        List<TimesheetItem> result = new ArrayList<>();
        // Đảm bảo dữ liệu chấm công tháng trong CSDL luôn đầy đủ realtime
        attendanceDAO.autoSeedMonthAttendance(month, year);

        List<Employee> allEmployees = employeeDAO.findAll();
        boolean isLocked = isTimesheetLocked(month, year);

        // Danh sách nhân sự mẫu giàu chi tiết làm fallback nếu DB chưa có dữ liệu nhân sự
        Map<String, TimesheetItem> sampleMap = buildRichSampleTimesheet();

        if (allEmployees.isEmpty()) {
            result.addAll(sampleMap.values());
        } else {
            // Lấy toàn bộ bản ghi chấm công của tháng từ DB
            List<Attendance> monthlyAttendances = attendanceDAO.search(null, null, null, null, month, year);
            Map<Integer, Map<Integer, Attendance>> attByEmpMap = new HashMap<>();
            for (Attendance a : monthlyAttendances) {
                if (a.getWorkDate() != null) {
                    attByEmpMap.computeIfAbsent(a.getEmployeeId(), k -> new HashMap<>())
                               .put(a.getWorkDate().getDayOfMonth(), a);
                }
            }

            int daysInMonth = YearMonth.of(year, month).lengthOfMonth();
            LocalDate today = LocalDate.now();

            for (Employee emp : allEmployees) {
                TimesheetItem item = new TimesheetItem();
                item.setEmployeeId(emp.getId());
                item.setEmployeeCode(emp.getEmployeeCode());
                item.setEmployeeName(emp.getFullName());
                item.setPositionName(emp.getPositionName() != null ? emp.getPositionName() : "Nhân viên");
                item.setDepartmentId(emp.getDepartmentId());
                item.setDepartmentName(emp.getDepartmentName() != null ? emp.getDepartmentName() : "Hành chính");
                if (emp.getAvatarUrl() != null && !emp.getAvatarUrl().isEmpty()) {
                    item.setAvatar(emp.getAvatarUrl());
                } else if (emp.getFullName() != null && !emp.getFullName().isEmpty()) {
                    item.setAvatar(emp.getFullName().substring(0, 1).toUpperCase());
                }

                Map<Integer, Attendance> empDays = attByEmpMap.getOrDefault(emp.getId(), Collections.emptyMap());
                double actualWorkDays = 0.0;
                int lateEarlyMinutes = 0;
                double leaveDays = 0.0;
                int unexcusedAbsent = 0;

                for (int d = 1; d <= daysInMonth; d++) {
                    LocalDate date = LocalDate.of(year, month, d);
                    DayOfWeek dow = date.getDayOfWeek();
                    boolean isWeekend = (dow == DayOfWeek.SATURDAY || dow == DayOfWeek.SUNDAY);

                    Attendance att = empDays.get(d);
                    if (att != null) {
                        String st = att.getStatus() != null ? att.getStatus().toUpperCase() : "ON_TIME";
                        if ("ON_LEAVE".equals(st)) {
                            item.setDayStatus(d, "P");
                            leaveDays += 1.0;
                            actualWorkDays += 1.0;
                        } else if ("LATE".equals(st) || "EARLY_LEAVE".equals(st)) {
                            item.setDayStatus(d, "M");
                            actualWorkDays += 1.0;
                            lateEarlyMinutes += 15;
                        } else if ("WFH".equals(st)) {
                            item.setDayStatus(d, "1.0");
                            actualWorkDays += 1.0;
                        } else if ("ABSENT".equals(st)) {
                            item.setDayStatus(d, "V");
                            unexcusedAbsent += 1;
                        } else if ("HALF_DAY".equals(st)) {
                            item.setDayStatus(d, "0.5");
                            actualWorkDays += 0.5;
                            leaveDays += 0.5;
                        } else if ("BUSINESS_TRIP".equals(st) || "MISSION".equals(st)) {
                            item.setDayStatus(d, "CT");
                            actualWorkDays += 1.0;
                        } else {
                            // ON_TIME, COMPLETE, WORKING
                            item.setDayStatus(d, "1.0");
                            actualWorkDays += 1.0;
                        }
                    } else {
                        // Không có bản ghi chấm công
                        if (isWeekend) {
                            item.setDayStatus(d, "O");
                        } else {
                            if (date.isAfter(today)) {
                                item.setDayStatus(d, "O"); // Ngày chưa tới
                            } else {
                                item.setDayStatus(d, "V"); // Ngày quá khứ không đi làm
                                unexcusedAbsent += 1;
                            }
                        }
                    }
                }

                // Tổng hợp giờ OT trong tháng
                List<Overtime> otList = overtimeDAO.findByEmployeeAndMonth(emp.getId(), month, year);
                double otHours = 0.0;
                if (otList != null) {
                    for (Overtime ot : otList) otHours += ot.getHours();
                }

                item.setActualWorkDays(Math.round(actualWorkDays * 10.0) / 10.0);
                item.setOtHours(Math.round(otHours * 10.0) / 10.0);
                item.setLateEarlyMinutes(lateEarlyMinutes);

                if (leaveDays > 0 && unexcusedAbsent > 0) {
                    item.setLeaveDaysDisplay(leaveDays + " (" + unexcusedAbsent + "V)");
                } else if (leaveDays > 0) {
                    item.setLeaveDaysDisplay(String.valueOf(leaveDays));
                } else if (unexcusedAbsent > 0) {
                    item.setLeaveDaysDisplay(unexcusedAbsent + " (V)");
                } else {
                    item.setLeaveDaysDisplay("0");
                }

                if (isLocked) {
                    item.setStatus("APPROVED_LOCK");
                } else if (unexcusedAbsent > 0 || lateEarlyMinutes > 30) {
                    item.setStatus("UNEXPLAINED");
                } else {
                    item.setStatus("PENDING_CONFIRM");
                }

                result.add(item);
            }
        }

        // 2. Phân quyền theo Role
        if (user != null) {
            if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
                // Employee: CHỈ xem bảng công của chính mình
                int empId = user.getEmployeeId();
                result.removeIf(item -> item.getEmployeeId() != empId &&
                        !(user.getUsername() != null && user.getUsername().equalsIgnoreCase(item.getEmployeeCode())));
                if (result.isEmpty() && !sampleMap.isEmpty()) {
                    result.add(sampleMap.values().iterator().next());
                }
            } else if (user.isManager() && !user.isAdmin() && !user.isHr()) {
                // Manager: Chỉ xem nhân viên cùng phòng ban của mình
                int managerDeptId = 0;
                for (Employee e : allEmployees) {
                    if (e.getId() == user.getEmployeeId()) {
                        managerDeptId = e.getDepartmentId();
                        break;
                    }
                }
                final int deptFilter = managerDeptId;
                if (deptFilter > 0) {
                    result.removeIf(item -> item.getDepartmentId() > 0 && item.getDepartmentId() != deptFilter);
                }
            }
            // Admin, HR, Kế toán: Thấy toàn bộ công ty
        }

        // 3. Lọc theo tham số tìm kiếm
        if (departmentId != null && departmentId > 0) {
            result.removeIf(item -> item.getDepartmentId() > 0 && item.getDepartmentId() != departmentId);
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            result.removeIf(item -> !item.getStatus().equalsIgnoreCase(statusFilter.trim()));
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            result.removeIf(item ->
                (item.getEmployeeName() == null || !item.getEmployeeName().toLowerCase().contains(kw)) &&
                (item.getEmployeeCode() == null || !item.getEmployeeCode().toLowerCase().contains(kw)) &&
                (item.getDepartmentName() == null || !item.getDepartmentName().toLowerCase().contains(kw))
            );
        }

        return result;
    }

    /**
     * Dữ liệu mẫu chuẩn đối ứng UI khi cơ sở dữ liệu chưa nạp nhân viên.
     */
    private Map<String, TimesheetItem> buildRichSampleTimesheet() {
        Map<String, TimesheetItem> map = new LinkedHashMap<>();

        TimesheetItem it1 = new TimesheetItem();
        it1.setEmployeeId(1);
        it1.setEmployeeCode("NV001");
        it1.setEmployeeName("Đặng Hoàng Long");
        it1.setPositionName("Giám đốc Công nghệ");
        it1.setDepartmentId(6);
        it1.setDepartmentName("CNTT");
        populateSampleDays(it1, 8.5, 0, "0", "APPROVED_LOCK");
        it1.setDayStatus(8, "CT");
        map.put("NV001", it1);

        TimesheetItem it2 = new TimesheetItem();
        it2.setEmployeeId(2);
        it2.setEmployeeCode("NV002");
        it2.setEmployeeName("Trần Ngọc Mai");
        it2.setPositionName("Trưởng phòng Nhân sự");
        it2.setDepartmentId(2);
        it2.setDepartmentName("HR");
        populateSampleDays(it2, 0, 18, "0", "PENDING_CONFIRM");
        it2.setDayStatus(3, "M");
        map.put("NV002", it2);

        TimesheetItem it3 = new TimesheetItem();
        it3.setEmployeeId(3);
        it3.setEmployeeCode("NV003");
        it3.setEmployeeName("Phạm Quốc Bảo");
        it3.setPositionName("Kỹ sư Frontend");
        it3.setDepartmentId(6);
        it3.setDepartmentName("CNTT");
        populateSampleDays(it3, 14.0, 0, "2.0", "APPROVED_LOCK");
        it3.setDayStatus(2, "P");
        it3.setDayStatus(3, "P");
        it3.setActualWorkDays(20.0);
        map.put("NV003", it3);

        TimesheetItem it4 = new TimesheetItem();
        it4.setEmployeeId(4);
        it4.setEmployeeCode("NV004");
        it4.setEmployeeName("Lê Thị Thanh Huyền");
        it4.setPositionName("Chuyên viên Kinh Doanh");
        it4.setDepartmentId(4);
        it4.setDepartmentName("Kinh Doanh");
        populateSampleDays(it4, 0, 0, "0.5", "APPROVED_LOCK");
        it4.setDayStatus(4, "0.5");
        it4.setActualWorkDays(21.5);
        map.put("NV004", it4);

        TimesheetItem it5 = new TimesheetItem();
        it5.setEmployeeId(5);
        it5.setEmployeeCode("NV005");
        it5.setEmployeeName("Vũ Minh Tuấn");
        it5.setPositionName("Chuyên viên Marketing");
        it5.setDepartmentId(5);
        it5.setDepartmentName("Marketing");
        populateSampleDays(it5, 0, 0, "1.0 (V)", "UNEXPLAINED");
        it5.setDayStatus(9, "V");
        it5.setActualWorkDays(21.0);
        map.put("NV005", it5);

        return map;
    }

    private void populateSampleDays(TimesheetItem item, double otHours, int lateMins, String leaveDays, String status) {
        for (int d = 1; d <= 30; d++) {
            LocalDate dt = LocalDate.of(2026, 9, d);
            DayOfWeek dow = dt.getDayOfWeek();
            if (dow == DayOfWeek.SATURDAY || dow == DayOfWeek.SUNDAY) {
                item.setDayStatus(d, "O");
            } else if (d > 29) {
                item.setDayStatus(d, "O"); // Ngày chưa tới
            } else {
                item.setDayStatus(d, "1.0");
            }
        }
        item.setActualWorkDays(21.0);
        item.setOtHours(otHours);
        item.setLateEarlyMinutes(lateMins);
        item.setLeaveDaysDisplay(leaveDays);
        item.setStatus(status);
    }

    /**
     * Lấy các cảnh báo giải trình thực tế từ CSDL hoặc mẫu đối ứng UI.
     */
    public List<Map<String, String>> getAnomalyReminders() {
        List<Map<String, String>> list = new ArrayList<>();
        LocalDate today = LocalDate.now();
        List<Attendance> anomalies = attendanceDAO.search(null, null, null, null, today.getMonthValue(), today.getYear());

        if (anomalies != null) {
            for (Attendance a : anomalies) {
                if (("LATE".equalsIgnoreCase(a.getStatus()) || "EARLY_LEAVE".equalsIgnoreCase(a.getStatus()) || "ABSENT".equalsIgnoreCase(a.getStatus()))
                    && (a.getNotes() == null || !a.getNotes().contains("[Đã duyệt giải trình]"))) {
                    Map<String, String> m = new HashMap<>();
                    m.put("code", a.getEmployeeCode() != null ? a.getEmployeeCode() : "NV");
                    m.put("name", a.getEmployeeName() != null ? a.getEmployeeName() : "Nhân viên");
                    String issue = "LATE".equalsIgnoreCase(a.getStatus()) ? "Đi muộn"
                                 : "EARLY_LEAVE".equalsIgnoreCase(a.getStatus()) ? "Về sớm" : "Vắng chưa phép";
                    m.put("issue", issue);
                    m.put("date", a.getWorkDate() != null ? "Ngày " + String.format("%02d/%02d", a.getWorkDate().getDayOfMonth(), a.getWorkDate().getMonthValue()) : "Hôm nay");
                    list.add(m);
                    if (list.size() >= 5) break;
                }
            }
        }

        if (list.isEmpty()) {
            Map<String, String> a1 = new HashMap<>();
            a1.put("code", "NV005");
            a1.put("name", "Vũ Minh Tuấn");
            a1.put("issue", "Vắng không báo trước");
            a1.put("date", "Ngày 09/09");
            list.add(a1);

            Map<String, String> a2 = new HashMap<>();
            a2.put("code", "NV042");
            a2.put("name", "Hoàng Văn Đức");
            a2.put("issue", "Quên Check-out");
            a2.put("date", "Ngày 11/09");
            list.add(a2);

            Map<String, String> a3 = new HashMap<>();
            a3.put("code", "NV019");
            a3.put("name", "Lê Ngọc Diệp");
            a3.put("issue", "Đi muộn 42 phút");
            a3.put("date", "Chưa xác nhận");
            list.add(a3);
        }

        return list;
    }
}
