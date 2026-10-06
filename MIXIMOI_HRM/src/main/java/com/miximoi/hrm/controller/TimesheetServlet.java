package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.AuditLogDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.NotificationDAO;
import com.miximoi.hrm.dao.UserDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Notification;
import com.miximoi.hrm.model.TimesheetDayColumn;
import com.miximoi.hrm.model.TimesheetItem;
import com.miximoi.hrm.model.TimesheetKpiStats;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.EmailService;
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
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.util.Map;

/**
 * Servlet quản lý Bảng công & Chấm công tháng.
 * URL: /timesheet
 */
@WebServlet(urlPatterns = {"/timesheet", "/timesheets"})
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

        // Lấy tháng và năm (Mặc định là tháng hiện tại)
        LocalDate now = LocalDate.now();
        String mParam = request.getParameter("month");
        String yParam = request.getParameter("year");
        int month = (mParam != null && !mParam.isEmpty()) ? Integer.parseInt(mParam) : now.getMonthValue();
        int year = (yParam != null && !yParam.isEmpty()) ? Integer.parseInt(yParam) : now.getYear();

        // Các bộ lọc
        String deptParam = request.getParameter("departmentId");
        Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.valueOf(deptParam) : null;
        String statusFilter = request.getParameter("status");
        String shiftType = request.getParameter("shiftType");
        String keyword = request.getParameter("keyword");

        // Đồng bộ dữ liệu chấm công thực tế của tháng nếu chưa có
        attendanceDAO.autoSeedMonthAttendance(month, year);

        // Lấy danh sách ma trận chấm công theo quyền hạn của Role
        List<TimesheetItem> allMatrix = timesheetService.getTimesheetMatrix(
                currentUser, month, year, departmentId, statusFilter, shiftType, keyword);
        if (allMatrix == null) allMatrix = new java.util.ArrayList<>();

        if ("export".equalsIgnoreCase(request.getParameter("action"))) {
            exportTimesheetToCsv(response, allMatrix, month, year);
            return;
        }

        boolean isLocked = timesheetService.isTimesheetLocked(month, year);
        List<Department> departments = departmentDAO.findAll();

        // Phân trang 15 nhân sự / trang
        int pageSize = 15;
        int totalEmployees = allMatrix.size();
        int totalPages = (int) Math.ceil((double) totalEmployees / pageSize);
        int page = 1;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException ignored) {}
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        int fromIdx = (page - 1) * pageSize;
        int toIdx = Math.min(fromIdx + pageSize, totalEmployees);
        List<TimesheetItem> matrix = (totalEmployees > 0) ? allMatrix.subList(fromIdx, toIdx) : allMatrix;

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
        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("fromIdx", totalEmployees > 0 ? (fromIdx + 1) : 0);
        request.setAttribute("toIdx", toIdx);
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

        // 4 Thẻ KPI Chỉ số tổng hợp động (tính trên toàn bộ tập dữ liệu)
        TimesheetKpiStats kpiStats = timesheetService.calculateKpiStats(allMatrix, month, year);
        request.setAttribute("kpiStats", kpiStats);

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

        LocalDate postNow = LocalDate.now();
        int month = postNow.getMonthValue();
        int year = postNow.getYear();
        try {
            if (request.getParameter("month") != null) month = Integer.parseInt(request.getParameter("month"));
            if (request.getParameter("year") != null) year = Integer.parseInt(request.getParameter("year"));
        } catch (NumberFormatException ignored) {}

        switch (action) {
            case "lock" -> {
                // Chỉ Admin hoặc HR mới có quyền khóa/mở bảng công
                if (currentUser.isAdmin() || currentUser.isHr()) {
                    boolean currentLock = timesheetService.isTimesheetLocked(month, year);
                    Integer empId = currentUser.getEmployeeId() > 0 ? currentUser.getEmployeeId() : null;
                    String note = !currentLock ? "Đã khóa bảng công bởi " + currentUser.getFullName()
                                               : "Mở khóa bảng công bởi " + currentUser.getFullName();
                    timesheetService.setTimesheetLocked(month, year, !currentLock, empId, note);
                    AuditLogDAO.logAction(request, !currentLock ? "LOCK_TIMESHEET" : "UNLOCK_TIMESHEET", "TIMESHEET", null, note + " (Kỳ " + month + "/" + year + ")");
                    String msg = !currentLock ? "locked" : "unlocked";
                    response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=" + msg);
                    return;
                }
            }
            case "sync" -> {
                // Admin hoặc HR đồng bộ dữ liệu chấm công toàn tháng
                if (currentUser.isAdmin() || currentUser.isHr()) {
                    // Đồng bộ tháng đang xem
                    attendanceDAO.autoSeedMonthAttendance(month, year);
                    // Nếu đang xem tháng hiện tại, seed thêm hôm nay để đảm bảo realtime
                    LocalDate today2 = LocalDate.now();
                    if (month == today2.getMonthValue() && year == today2.getYear()) {
                        attendanceDAO.autoSeedTodayData(today2);
                    }
                    response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=synced");
                    return;
                }
            }
            case "remind" -> {
                String xreq = request.getHeader("X-Requested-With");
                boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(xreq) || "json".equalsIgnoreCase(request.getParameter("format"));
                try {
                    String target = request.getParameter("target");
                    if (target == null || target.trim().isEmpty()) {
                        target = "ALL";
                    }

                    final int fMonth = month;
                    final int fYear = year;
                    NotificationDAO notifDAO = new NotificationDAO();
                    UserDAO uDAO = new UserDAO();
                    int notifCount = 0;
                    int skipCount = 0;

                    if ("ALL".equalsIgnoreCase(target)) {
                        List<Map<String, String>> anomalies = timesheetService.getAnomalyReminders();
                        if (anomalies != null && !anomalies.isEmpty()) {
                            for (Map<String, String> anom : anomalies) {
                                String code = anom.get("code");
                                User targetUser = uDAO.findOrCreateUserByEmployeeCode(code);
                                if (targetUser == null) {
                                    System.out.println("[TimesheetServlet] remind: Không tìm thấy user cho mã NV: " + code + " — bỏ qua.");
                                    skipCount++;
                                    continue;
                                }
                                // Kiểm tra đã gửi hôm nay chưa để tránh spam
                                if (notifDAO.hasReminderSentToday(targetUser.getId(), "ATTENDANCE")) {
                                    System.out.println("[TimesheetServlet] remind: Đã gửi nhắc nhở hôm nay cho " + code + " — bỏ qua.");
                                    skipCount++;
                                    continue;
                                }
                                Notification n = new Notification();
                                n.setUserId(targetUser.getId());
                                n.setTitle("⚠️ Nhắc nhở giải trình chấm công tháng " + fMonth + "/" + fYear);
                                n.setMessage("Phòng Nhân sự nhắc bạn kiểm tra bảng công, hoàn tất bù công / giải trình " + anom.get("issue") + " (" + anom.get("date") + ") trước hạn chốt.");
                                n.setType("WARNING");
                                n.setModule("ATTENDANCE");
                                n.setLinkUrl("/timesheet?month=" + fMonth + "&year=" + fYear);
                                n.setCreatedAt(LocalDateTime.now());
                                n.setRead(false);
                                boolean inserted = notifDAO.insert(n);
                                if (inserted) {
                                    notifCount++;
                                    if (targetUser.getEmail() != null && !targetUser.getEmail().isEmpty()) {
                                        final String toEmail = targetUser.getEmail();
                                        final String toName = targetUser.getFullName();
                                        final String nMsg = n.getMessage();
                                        new Thread(() -> EmailService.sendBroadcastAlert(toEmail, toName, "Nhắc nhở giải trình công tháng " + fMonth + "/" + fYear, nMsg)).start();
                                    }
                                } else {
                                    System.err.println("[TimesheetServlet] remind: insert notification thất bại cho user " + targetUser.getId());
                                }
                            }
                        }
                    } else {
                        User targetUser = uDAO.findOrCreateUserByEmployeeCode(target);
                        if (targetUser == null) {
                            try {
                                targetUser = uDAO.findByEmployeeId(Integer.parseInt(target));
                            } catch (NumberFormatException ignored) {}
                        }
                        if (targetUser == null) {
                            targetUser = uDAO.findByUsername(target);
                        }
                        if (targetUser == null) {
                            System.out.println("[TimesheetServlet] remind: Không tìm thấy tài khoản người dùng cho mã NV/ID: " + target);
                        } else {
                            Notification n = new Notification();
                            n.setUserId(targetUser.getId());
                            n.setTitle("⚠️ Lời nhắc giải trình chấm công Tháng " + fMonth + "/" + fYear);
                            n.setMessage("Phòng Nhân sự nhắc nhở: Vui lòng kiểm tra bảng công Tháng " + fMonth + "/" + fYear + ", bổ sung bù công hoặc giải trình các ngày thiếu công / đi muộn trước hạn chốt kỳ lương.");
                            n.setType("WARNING");
                            n.setModule("ATTENDANCE");
                            n.setLinkUrl("/timesheet?month=" + fMonth + "&year=" + fYear);
                            n.setCreatedAt(LocalDateTime.now());
                            n.setRead(false);
                            boolean inserted = notifDAO.insert(n);
                            if (inserted) {
                                notifCount++;
                                if (targetUser.getEmail() != null && !targetUser.getEmail().isEmpty()) {
                                    final String toEmail = targetUser.getEmail();
                                    final String toName = targetUser.getFullName();
                                    final String nMsg = n.getMessage();
                                    new Thread(() -> EmailService.sendBroadcastAlert(toEmail, toName, "Nhắc nhở giải trình công tháng " + fMonth + "/" + fYear, nMsg)).start();
                                }
                            } else {
                                System.err.println("[TimesheetServlet] remind: insert notification thất bại cho user " + targetUser.getId());
                            }
                        }
                    }

                    AuditLogDAO.logAction(request, "REMIND_TIMESHEET", "ATTENDANCE", null,
                            "Gửi nhắc nhở giải trình công tháng " + month + "/" + year + " tới " + target
                            + " — Đã gửi: " + notifCount + ", Bỏ qua: " + skipCount);

                    if (isAjax) {
                        response.setContentType("application/json;charset=UTF-8");
                        String msg;
                        boolean success = true;
                        if (notifCount > 0) {
                            msg = "Đã gửi " + notifCount + " thông báo nhắc nhở thành công!"
                                + (skipCount > 0 ? " (" + skipCount + " trường hợp bỏ qua do đã gửi hôm nay)" : "");
                        } else if (skipCount > 0) {
                            msg = "Tất cả nhân sự trong danh sách đã được nhắc nhở hôm nay rồi. Không gửi thêm để tránh làm phiền.";
                        } else {
                            success = false;
                            msg = "Không tìm thấy thông tin nhân sự phù hợp hoặc không có dữ liệu bất thường cần nhắc nhở tháng " + month + "/" + year + ".";
                        }
                        String cleanMsg = msg.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ");
                        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + cleanMsg + "\",\"notifCount\":" + notifCount + ",\"skipCount\":" + skipCount + "}");
                        return;
                    }

                    response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=reminded");
                    return;
                } catch (Exception t) {
                    getServletContext().log("TimesheetServlet: Lỗi gửi nhắc nhở giải trình", t);
                    if (isAjax) {
                        response.setContentType("application/json;charset=UTF-8");
                        String err = t.getMessage() != null ? t.getMessage() : "Lỗi hệ thống không xác định";
                        String cleanErr = err.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ");
                        response.getWriter().write("{\"success\":false,\"message\":\"Lỗi máy chủ khi gửi nhắc nhở: " + cleanErr + "\"}");
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&error=server_error");
                    return;
                }
            }
            case "export" -> {
                // Xuất file CSV ma trận chấm công với UTF-8 BOM chuẩn Excel
                List<TimesheetItem> matrix = timesheetService.getTimesheetMatrix(
                        currentUser, month, year, null, null, null, null);
                exportTimesheetToCsv(response, matrix, month, year);
                return;
            }
            case "missing_punch" -> {
                // Quy trình Giải trình chấm công bù (Missing check-in adjustment)
                int empId = currentUser.getEmployeeId() > 0 ? currentUser.getEmployeeId() : 1;
                String empParam = request.getParameter("employeeId");
                if (empParam != null && !empParam.isEmpty() && (currentUser.isAdmin() || currentUser.isHr() || currentUser.isManager())) {
                    try {
                        empId = Integer.parseInt(empParam);
                    } catch (NumberFormatException ignored) {}
                }
                String dateStr = request.getParameter("workDate");
                LocalDate workDate = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr) : LocalDate.now();
                String checkInStr = request.getParameter("checkIn");
                String checkOutStr = request.getParameter("checkOut");
                String reason = request.getParameter("reason");

                java.time.LocalTime inTime = (checkInStr != null && !checkInStr.isEmpty()) ? java.time.LocalTime.parse(checkInStr) : java.time.LocalTime.of(8, 30);
                java.time.LocalTime outTime = (checkOutStr != null && !checkOutStr.isEmpty()) ? java.time.LocalTime.parse(checkOutStr) : java.time.LocalTime.of(17, 30);

                attendanceDAO.recordMissingPunch(empId, workDate, inTime, outTime, reason);
                AuditLogDAO.logAction(request, "MISSING_PUNCH_ADJUST", "ATTENDANCE", empId, "Giải trình bù công ngày " + workDate + ": " + reason);
                response.sendRedirect(request.getContextPath() + "/timesheet?month=" + workDate.getMonthValue() + "&year=" + workDate.getYear() + "&success=adjusted");
                return;
            }
            default -> {}
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
            String xreq = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equalsIgnoreCase(xreq) || "json".equalsIgnoreCase(request.getParameter("format"))) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"Phiên làm việc đã hết hạn. Vui lòng tải lại trang và đăng nhập lại.\"}");
                return false;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
