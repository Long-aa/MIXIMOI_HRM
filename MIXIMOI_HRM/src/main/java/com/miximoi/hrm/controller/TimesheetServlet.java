package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.TimesheetDayColumn;
import com.miximoi.hrm.model.TimesheetItem;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.TimesheetService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

/**
 * Servlet quản lý Bảng công & Chấm công tháng.
 * URL: /timesheet
 */
@WebServlet({"/timesheet"})
public class TimesheetServlet extends HttpServlet {

    private final TimesheetService timesheetService = new TimesheetService();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "timesheet");

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        // Lấy tháng và năm (Mặc định là Tháng 09/2026 hoặc tháng hiện tại)
        LocalDate now = LocalDate.now();
        String mParam = request.getParameter("month");
        String yParam = request.getParameter("year");
        int month = (mParam != null && !mParam.isEmpty()) ? Integer.parseInt(mParam) : 9;
        int year = (yParam != null && !yParam.isEmpty()) ? Integer.parseInt(yParam) : 2026;

        // Các bộ lọc
        String deptParam = request.getParameter("departmentId");
        Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
        String statusFilter = request.getParameter("status");
        String shiftType = request.getParameter("shiftType");
        String keyword = request.getParameter("keyword");

        // Đồng bộ dữ liệu chấm công thực tế của tháng nếu chưa có
        attendanceDAO.autoSeedMonthAttendance(month, year);

        // Lấy danh sách ma trận chấm công theo quyền hạn của Role
        List<TimesheetItem> matrix = timesheetService.getTimesheetMatrix(
                currentUser, month, year, departmentId, statusFilter, shiftType, keyword);

        boolean isLocked = timesheetService.isTimesheetLocked(month, year);
        List<Department> departments = departmentDAO.findAll();

        int daysInMonth = YearMonth.of(year, month).lengthOfMonth();
        List<TimesheetDayColumn> dayColumns = new java.util.ArrayList<>();
        for (int d = 1; d <= daysInMonth; d++) {
            LocalDate dDate = LocalDate.of(year, month, d);
            java.time.DayOfWeek dow = dDate.getDayOfWeek();
            boolean isWeekend = (dow == java.time.DayOfWeek.SATURDAY || dow == java.time.DayOfWeek.SUNDAY);
            String dayTxt = switch (dow) {
                case MONDAY -> "T2";
                case TUESDAY -> "T3";
                case WEDNESDAY -> "T4";
                case THURSDAY -> "T5";
                case FRIDAY -> "T6";
                case SATURDAY -> "T7";
                case SUNDAY -> "CN";
            };
            boolean isToday = (d == now.getDayOfMonth() && month == now.getMonthValue() && year == now.getYear());
            dayColumns.add(new TimesheetDayColumn(d, dayTxt, isWeekend, isToday));
        }

        // Đưa dữ liệu sang JSP
        request.setAttribute("matrix", matrix);
        request.setAttribute("totalEmployees", matrix.size());
        request.setAttribute("isLocked", isLocked);
        request.setAttribute("departments", departments);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedDeptId", departmentId);
        request.setAttribute("selectedStatus", statusFilter);
        request.setAttribute("selectedShift", shiftType);
        request.setAttribute("keyword", keyword);
        request.setAttribute("dayColumns", dayColumns);
        request.setAttribute("daysInMonth", daysInMonth);
        request.setAttribute("todayDay", now.getDayOfMonth());
        request.setAttribute("isCurrentMonth", (month == now.getMonthValue() && year == now.getYear()));

        // Các cảnh báo giải trình và thiết bị
        request.setAttribute("anomalies", timesheetService.getAnomalyReminders());

        request.getRequestDispatcher("/WEB-INF/views/attendance/timesheet.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");
        if (action == null) action = "";

        int month = 9;
        int year = 2026;
        try {
            if (request.getParameter("month") != null) month = Integer.parseInt(request.getParameter("month"));
            if (request.getParameter("year") != null) year = Integer.parseInt(request.getParameter("year"));
        } catch (NumberFormatException ignored) {}

        switch (action) {
            case "lock": {
                // Chỉ Admin hoặc HR mới có quyền khóa/mở bảng công
                if (currentUser.isAdmin() || currentUser.isHr()) {
                    boolean currentLock = timesheetService.isTimesheetLocked(month, year);
                    Integer empId = currentUser.getEmployeeId() > 0 ? currentUser.getEmployeeId() : null;
                    String note = !currentLock ? "Đã khóa bảng công bởi " + currentUser.getFullName()
                                               : "Mở khóa bảng công bởi " + currentUser.getFullName();
                    timesheetService.setTimesheetLocked(month, year, !currentLock, empId, note);
                    String msg = !currentLock ? "locked" : "unlocked";
                    response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=" + msg);
                    return;
                }
                break;
            }
            case "sync": {
                // Admin hoặc HR đồng bộ máy chấm công / nạp tự động dữ liệu hôm nay
                if (currentUser.isAdmin() || currentUser.isHr()) {
                    attendanceDAO.autoSeedTodayData(LocalDate.now());
                    response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=synced");
                    return;
                }
                break;
            }
            case "remind": {
                // Gửi nhắc nhở giải trình
                response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=reminded");
                return;
            }
            case "export": {
                // Xuất file CSV ma trận chấm công với UTF-8 BOM chuẩn Excel
                List<TimesheetItem> matrix = timesheetService.getTimesheetMatrix(
                        currentUser, month, year, null, null, null, null);
                exportTimesheetToCsv(response, matrix, month, year);
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year);
    }

    private void exportTimesheetToCsv(HttpServletResponse response, List<TimesheetItem> matrix, int month, int year)
            throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String fileName = "bang_cong_T" + String.format("%02d", month) + "_" + year + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        PrintWriter writer = response.getWriter();
        // UTF-8 BOM để Excel hiển thị tiếng Việt có dấu chuẩn xác
        writer.write('\uFEFF');

        int daysInMonth = YearMonth.of(year, month).lengthOfMonth();

        // Header CSV
        StringBuilder sb = new StringBuilder();
        sb.append("Mã NV,Họ và tên,Chức vụ,Phòng ban");
        for (int d = 1; d <= daysInMonth; d++) {
            sb.append(",").append(String.format("%02d", d));
        }
        sb.append(",Công TT,Giờ OT,Trễ/Sớm (phút),Nghỉ phép,Trạng thái\n");
        writer.write(sb.toString());

        // Body CSV
        for (TimesheetItem item : matrix) {
            StringBuilder row = new StringBuilder();
            row.append(escapeCsv(item.getEmployeeCode())).append(",");
            row.append(escapeCsv(item.getEmployeeName())).append(",");
            row.append(escapeCsv(item.getPositionName())).append(",");
            row.append(escapeCsv(item.getDepartmentName()));

            for (int d = 1; d <= daysInMonth; d++) {
                row.append(",").append(escapeCsv(item.getDayStatus(d)));
            }

            row.append(",").append(item.getActualWorkDays());
            row.append(",").append(item.getOtHours());
            row.append(",").append(item.getLateEarlyMinutes());
            row.append(",").append(escapeCsv(item.getLeaveDaysDisplay()));
            row.append(",").append(escapeCsv(item.getStatusDisplay()));
            row.append("\n");
            writer.write(row.toString());
        }
        writer.flush();
    }

    private String escapeCsv(String val) {
        if (val == null) return "";
        if (val.contains(",") || val.contains("\"") || val.contains("\n")) {
            return "\"" + val.replace("\"", "\"\"") + "\"";
        }
        return val;
    }

    private boolean checkAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
