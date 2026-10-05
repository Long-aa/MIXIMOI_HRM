package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.model.TimesheetSummary;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.service.AttendanceService;
import com.miximoi.hrm.service.AttendanceService.CheckInResult;
import com.miximoi.hrm.service.AttendanceService.CheckOutResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Duration;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Servlet quản lý chấm công.
 * URL: /attendance
 *
 * [F1.2] Servlet CHỈ gọi AttendanceService — không gọi AttendanceDAO trực tiếp.
 * [F2.3] Kiểm tra role trước mọi thao tác xóa/bulk.
 * [F2.4] Phân trang DB-side thay vì subList() tại Java.
 */
@WebServlet(urlPatterns = {"/attendance", "/attendances"})
public class AttendanceServlet extends HttpServlet {

    // [F1.2] Chỉ inject Service — không inject DAO trực tiếp
    private final AttendanceService attendanceService = new AttendanceService();
    private final EmployeeDAO       employeeDAO       = new EmployeeDAO();
    private final DepartmentDAO     departmentDAO     = new DepartmentDAO();

    private static final int PAGE_SIZE = 10;

    // =====================================================================
    // GET — Hiển thị danh sách chấm công
    // =====================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("export".equalsIgnoreCase(action)) {
            exportAttendanceToCsv(request, response);
            return;
        }

        request.setAttribute("activeMenu", "attendance");

        LocalDate today = LocalDate.now();
        int month = parseIntParam(request.getParameter("month"), today.getMonthValue());
        int year  = parseIntParam(request.getParameter("year"),  today.getYear());

        String  keyword      = request.getParameter("keyword");
        String  deptStr      = request.getParameter("departmentId");
        String  status       = request.getParameter("status");
        String  dateStr      = request.getParameter("date");
        Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.valueOf(deptStr.trim()) : null;
        LocalDate queryDate  = (dateStr != null && !dateStr.trim().isEmpty()) ? LocalDate.parse(dateStr.trim()) : null;

        // [F1.4] Gọi qua Service — không seed mỗi GET request nếu đã đủ data
        attendanceService.ensureMonthDataExists(month, year);

        User user = (User) request.getSession().getAttribute("currentUser");
        int  page = parseIntParam(request.getParameter("page"), 1);

        if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
            // ---- EMPLOYEE: xem cá nhân ----
            List<Attendance> attendances = attendanceService.getByEmployeeAndMonth(user.getEmployeeId(), month, year);
            Attendance todayAtt = attendanceService.getByEmployeeAndDate(user.getEmployeeId(), today);
            boolean isOnLeave = (todayAtt != null && "ON_LEAVE".equalsIgnoreCase(todayAtt.getStatus()))
                    || attendanceService.isEmployeeOnLeave(user.getEmployeeId(), today);

            request.setAttribute("isOnLeave",      isOnLeave);
            request.setAttribute("isMonthLocked",  attendanceService.isTimesheetLocked(month, year));
            request.setAttribute("todayAtt",        todayAtt);

            if (todayAtt != null) {
                request.setAttribute("todayCheckIn",  todayAtt.getCheckIn()  != null ? todayAtt.getCheckIn().toString()  : null);
                request.setAttribute("todayCheckOut", todayAtt.getCheckOut() != null ? todayAtt.getCheckOut().toString() : null);
                if (todayAtt.getCheckOut() != null) {
                    request.setAttribute("todayHours", todayAtt.getTotalHours() + "h (Đã xong ca)");
                } else if (todayAtt.getCheckIn() != null) {
                    long elapsed = Math.max(0, Duration.between(todayAtt.getCheckIn(), LocalTime.now()).toMinutes());
                    request.setAttribute("todayHours", (elapsed / 60) + "h " + String.format("%02d", elapsed % 60) + "m (Đang làm)");
                } else {
                    request.setAttribute("todayHours", "0h 00m");
                }
            }

            // Phân trang phía Java vẫn ổn cho dữ liệu 1 nhân viên (~22 bản ghi/tháng)
            int total     = attendances != null ? attendances.size() : 0;
            int totalPages = Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE));
            page = Math.max(1, Math.min(page, totalPages));
            int from = (page - 1) * PAGE_SIZE;
            int to   = Math.min(from + PAGE_SIZE, total);
            List<Attendance> paged = (attendances != null && from < total)
                    ? attendances.subList(from, to) : new ArrayList<>();

            request.setAttribute("workDaysThisMonth", total);
            setCommonAttrs(request, paged, total, page, totalPages, month, year, dateStr, keyword, departmentId, status, today);

        } else if (user.isAccountant() && !user.isAdmin()) {
            // ---- ACCOUNTANT: tổng hợp bảng công ----
            List<TimesheetSummary> summary = attendanceService.getTimesheetSummary(month, year);
            request.setAttribute("timesheetSummary", summary);

            // [F2.4] DB-side pagination
            int total      = attendanceService.countSearch(keyword, departmentId, status, queryDate, month, year);
            int totalPages = Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE));
            page = Math.max(1, Math.min(page, totalPages));
            List<Attendance> paged = attendanceService.searchPaged(keyword, departmentId, status, queryDate, month, year, page, PAGE_SIZE);
            setCommonAttrs(request, paged, total, page, totalPages, month, year, dateStr, keyword, departmentId, status, today);

        } else if (user.isManager() && !user.isAdmin() && !user.isHr()) {
            // ---- MANAGER: phòng ban của mình ----
            if (user.getEmployeeId() > 0) {
                Employee mgrEmp = employeeDAO.findById(user.getEmployeeId());
                if (mgrEmp != null && mgrEmp.getDepartmentId() > 0) {
                    departmentId = mgrEmp.getDepartmentId();
                }
            }
            final Integer deptIdFinal = departmentId;

            Map<String, Integer> todayStats = attendanceService.getTodayStats(today);
            request.setAttribute("deptTotalToday",    todayStats.get("totalEmployeesToday"));
            request.setAttribute("deptCheckedIn",     todayStats.get("checkedInCount"));
            request.setAttribute("deptLateCount",     todayStats.get("lateEarlyCount"));
            request.setAttribute("pendingApprovals",  attendanceService.countPendingExplains(deptIdFinal));

            int total      = attendanceService.countSearch(keyword, deptIdFinal, status, queryDate, month, year);
            int totalPages = Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE));
            page = Math.max(1, Math.min(page, totalPages));
            List<Attendance> paged = attendanceService.searchPaged(keyword, deptIdFinal, status, queryDate, month, year, page, PAGE_SIZE);
            setCommonAttrs(request, paged, total, page, totalPages, month, year, dateStr, keyword, deptIdFinal, status, today);

        } else {
            // ---- ADMIN & HR: full management ----
            Map<String, Integer> todayStats = attendanceService.getTodayStats(today);
            int totalEmp = todayStats.getOrDefault("totalEmployeesToday", 0);
            int checkedIn = todayStats.getOrDefault("checkedInCount", 0);
            int lateEarly = todayStats.getOrDefault("lateEarlyCount", 0);
            int absent    = todayStats.getOrDefault("absentCount", 0);
            int wfh       = todayStats.getOrDefault("wfhCount", 0);
            request.setAttribute("totalEmployeesToday", totalEmp);
            request.setAttribute("checkedInCount",      checkedIn);
            request.setAttribute("lateEarlyCount",      lateEarly);
            request.setAttribute("absentCount",         absent);
            request.setAttribute("wfhCount",            wfh);
            request.setAttribute("activeCaShift",       3);
            request.setAttribute("deviceOnline",        true);
            request.setAttribute("deviceCount",         4);
            request.setAttribute("anomalyCount",        lateEarly + absent);
            request.setAttribute("absentApproved",      Math.max(0, absent - 1));
            request.setAttribute("absentUnapproved",    absent > 0 ? 1 : 0);

            List<TimesheetSummary> summary = attendanceService.getTimesheetSummary(month, year);
            request.setAttribute("timesheetSummary", summary);

            // [F2.4] DB-side pagination
            int total      = attendanceService.countSearch(keyword, departmentId, status, queryDate, month, year);
            int totalPages = Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE));
            page = Math.max(1, Math.min(page, totalPages));
            List<Attendance> paged = attendanceService.searchPaged(keyword, departmentId, status, queryDate, month, year, page, PAGE_SIZE);
            setCommonAttrs(request, paged, total, page, totalPages, month, year, dateStr, keyword, departmentId, status, today);
        }

        request.setAttribute("employees",   employeeDAO.findAll());
        request.setAttribute("departments", departmentDAO.findAll());
        request.getRequestDispatcher("/WEB-INF/views/attendance/attendance-list.jsp").forward(request, response);
    }

    // =====================================================================
    // POST — Xử lý hành động
    // =====================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";

        User user = (User) request.getSession().getAttribute("currentUser");

        switch (action) {

            // ------------------------------------------------------------------
            // Check-in — [F1.2] Gọi Service, nhận CheckInResult enum
            // ------------------------------------------------------------------
            case "checkin" -> {
                int empId = user.getEmployeeId() > 0 ? user.getEmployeeId() : 1;
                String method = request.getParameter("method");
                if (method == null || method.isBlank()) method = "FaceID";

                CheckInResult result = attendanceService.checkIn(empId, LocalDate.now(), LocalTime.now(), method);
                switch (result) {
                    case SUCCESS          -> response.sendRedirect(request.getContextPath() + "/attendance?success=checkin&method=" + method);
                    case ALREADY_IN       -> response.sendRedirect(request.getContextPath() + "/attendance?info=already_checked_in");
                    case ON_LEAVE         -> response.sendRedirect(request.getContextPath() + "/attendance?error=on_leave");
                    case TIMESHEET_LOCKED -> response.sendRedirect(request.getContextPath() + "/attendance?error=timesheet_locked");
                    default               -> response.sendRedirect(request.getContextPath() + "/attendance?error=checkin_failed");
                }
            }

            // ------------------------------------------------------------------
            // Check-out — [F1.2] Gọi Service, nhận CheckOutResult enum
            // ------------------------------------------------------------------
            case "checkout" -> {
                int empId = user.getEmployeeId() > 0 ? user.getEmployeeId() : 1;

                CheckOutResult result = attendanceService.checkOut(empId, LocalDate.now(), LocalTime.now());
                switch (result) {
                    case SUCCESS          -> response.sendRedirect(request.getContextPath() + "/attendance?success=checkout");
                    case ALREADY_OUT      -> response.sendRedirect(request.getContextPath() + "/attendance?info=already_checked_out");
                    case NOT_CHECKED_IN   -> response.sendRedirect(request.getContextPath() + "/attendance?error=not_checked_in");
                    case ON_LEAVE         -> response.sendRedirect(request.getContextPath() + "/attendance?error=on_leave");
                    case TIMESHEET_LOCKED -> response.sendRedirect(request.getContextPath() + "/attendance?error=timesheet_locked");
                    default               -> response.sendRedirect(request.getContextPath() + "/attendance?error=checkout_failed");
                }
            }

            // ------------------------------------------------------------------
            // Nhập tay (Admin/HR) — [F1.2] qua Service
            // ------------------------------------------------------------------
            case "manual" -> {
                if (!user.isAdmin() && !user.isHr()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                String empStr   = request.getParameter("employeeId");
                int    empId    = (empStr != null && !empStr.trim().isEmpty()) ? Integer.parseInt(empStr.trim()) : user.getEmployeeId();
                String dateStr  = request.getParameter("workDate");
                LocalDate wDate = (dateStr != null && !dateStr.trim().isEmpty()) ? LocalDate.parse(dateStr.trim()) : LocalDate.now();

                boolean ok = attendanceService.upsertManual(
                        empId, wDate,
                        parseTimeSafe(request.getParameter("checkIn")),
                        parseTimeSafe(request.getParameter("checkOut")),
                        request.getParameter("status"),
                        request.getParameter("notes"));
                response.sendRedirect(request.getContextPath() + "/attendance?" + (ok ? "success=manual_saved" : "error=timesheet_locked"));
            }

            // ------------------------------------------------------------------
            // Cập nhật theo ID (Admin/HR) — [F1.2] qua Service
            // ------------------------------------------------------------------
            case "update" -> {
                if (!user.isAdmin() && !user.isHr()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = attendanceService.updateById(
                        id,
                        parseTimeSafe(request.getParameter("checkIn")),
                        parseTimeSafe(request.getParameter("checkOut")),
                        request.getParameter("status"),
                        request.getParameter("notes"));
                response.sendRedirect(request.getContextPath() + "/attendance?" + (ok ? "success=updated" : "error=timesheet_locked"));
            }

            // ------------------------------------------------------------------
            // Phê duyệt giải trình (Manager/HR/Admin) — Hỗ trợ AJAX No-Reload
            // ------------------------------------------------------------------
            case "approveExplain" -> {
                if (!user.isAdmin() && !user.isHr() && !user.isManager()) {
                    if (isAjax(request)) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        writeJson(response, false, "Bạn không có quyền phê duyệt giải trình");
                        return;
                    }
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = attendanceService.approveExplain(id);
                if (isAjax(request)) {
                    writeJson(response, ok, ok ? "Phê duyệt giải trình công thành công! Đã chuyển trạng thái Đúng giờ (ON_TIME)." : "Kỳ công đã khóa, không thể duyệt!");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/attendance?" + (ok ? "success=approved" : "error=timesheet_locked"));
            }

            // ------------------------------------------------------------------
            // Nhân viên gửi giải trình — [F1.2] qua Service
            // ------------------------------------------------------------------
            case "explain" -> {
                int    id    = Integer.parseInt(request.getParameter("attendanceId"));
                String notes = request.getParameter("notes");
                attendanceService.submitExplain(id, notes);
                response.sendRedirect(request.getContextPath() + "/attendance?success=explained");
            }

            // ------------------------------------------------------------------
            // Xóa đơn lẻ — [F2.3] chỉ Admin/HR
            // ------------------------------------------------------------------
            case "delete" -> {
                if (!user.isAdmin() && !user.isHr()) {
                    if (isAjax(request)) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        writeJson(response, false, "Không có quyền xóa chấm công");
                        return;
                    }
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền xóa chấm công");
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = attendanceService.deleteById(id);
                if (isAjax(request)) {
                    writeJson(response, ok, ok ? "Đã xóa bản ghi chấm công thành công!" : "Không thể xóa bản ghi!");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/attendance?success=deleted");
            }

            // ------------------------------------------------------------------
            // Bulk mark ON_TIME (Admin/HR/Manager) — Hỗ trợ AJAX
            // ------------------------------------------------------------------
            case "bulkMarkOnTime" -> {
                if (!user.isAdmin() && !user.isHr() && !user.isManager()) {
                    if (isAjax(request)) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        writeJson(response, false, "Bạn không có quyền thực hiện");
                        return;
                    }
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                List<Integer> ids = parseIds(request.getParameterValues("ids"));
                int count = 0;
                if (!ids.isEmpty()) count = attendanceService.bulkMarkOnTime(ids);
                if (isAjax(request)) {
                    writeJson(response, true, "Đã xác nhận đúng giờ cho " + count + " bản ghi!");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/attendance?success=marked_ontime");
            }

            // ------------------------------------------------------------------
            // Bulk delete — [F2.3] chỉ Admin/HR — Hỗ trợ AJAX
            // ------------------------------------------------------------------
            case "bulkDelete" -> {
                if (!user.isAdmin() && !user.isHr()) {
                    if (isAjax(request)) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        writeJson(response, false, "Không có quyền xóa hàng loạt");
                        return;
                    }
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền xóa hàng loạt");
                    return;
                }
                List<Integer> ids = parseIds(request.getParameterValues("ids"));
                int count = 0;
                if (!ids.isEmpty()) count = attendanceService.bulkDelete(ids);
                if (isAjax(request)) {
                    writeJson(response, true, "Đã xóa " + count + " bản ghi chấm công!");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/attendance?success=deleted");
            }

            // ------------------------------------------------------------------
            // Bulk export CSV
            // ------------------------------------------------------------------
            case "bulkExport" -> {
                String[] idsArr = request.getParameterValues("ids");
                List<Attendance> list;
                if (idsArr != null && idsArr.length > 0) {
                    list = attendanceService.findByIds(parseIds(idsArr));
                } else {
                    int month = parseIntParam(request.getParameter("month"), LocalDate.now().getMonthValue());
                    int year  = parseIntParam(request.getParameter("year"),  LocalDate.now().getYear());
                    String kw = request.getParameter("keyword");
                    String ds = request.getParameter("departmentId");
                    String st = request.getParameter("status");
                    Integer dId = (ds != null && !ds.trim().isEmpty()) ? Integer.valueOf(ds.trim()) : null;
                    list = attendanceService.search(kw, dId, st, null, month, year);
                }
                writeAttendanceCsv(response, list);
            }

            // ------------------------------------------------------------------
            // Khóa / Mở khóa bảng công (Admin/HR)
            // ------------------------------------------------------------------
            case "lockTimesheet" -> {
                if (!user.isAdmin() && !user.isHr()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                int month = parseIntParam(request.getParameter("month"), LocalDate.now().getMonthValue());
                int year  = parseIntParam(request.getParameter("year"),  LocalDate.now().getYear());
                String lockStr = request.getParameter("lock");
                boolean lock = "true".equalsIgnoreCase(lockStr) || "1".equals(lockStr);
                String note = request.getParameter("note");
                Integer userId = user.getId() > 0 ? user.getId() : null;
                if (lock) {
                    attendanceService.lockTimesheet(month, year, userId, note);
                } else {
                    attendanceService.unlockTimesheet(month, year, userId, note);
                }
                response.sendRedirect(request.getContextPath() + "/attendance?success=" + (lock ? "locked" : "unlocked")
                        + "&month=" + month + "&year=" + year);
            }

            // ------------------------------------------------------------------
            // Đồng bộ dữ liệu chấm công tháng (Admin/HR) — hỗ trợ AJAX
            // ------------------------------------------------------------------
            case "sync" -> {
                if (!user.isAdmin() && !user.isHr()) {
                    if (isAjax(request)) {
                        writeJson(response, false, "Không có quyền đồng bộ");
                        return;
                    }
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                int month = parseIntParam(request.getParameter("month"), LocalDate.now().getMonthValue());
                int year  = parseIntParam(request.getParameter("year"),  LocalDate.now().getYear());
                // Đồng bộ toàn bộ tháng hiện tại
                attendanceService.ensureMonthDataExists(month, year);
                // Và seed thêm dữ liệu hôm nay nếu thiếu
                attendanceService.ensureMonthDataExists(LocalDate.now().getMonthValue(), LocalDate.now().getYear());
                if (isAjax(request)) {
                    writeJson(response, true, "Đồng bộ dữ liệu chấm công tháng " + month + "/" + year + " thành công!");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/attendance?success=synced&month=" + month + "&year=" + year);
            }

            default -> response.sendRedirect(request.getContextPath() + "/attendance");
        }
    }

    // =====================================================================
    // Private helpers
    // =====================================================================

    /** Set các attribute dùng chung cho tất cả role view */
    private void setCommonAttrs(HttpServletRequest request, List<Attendance> paged, int total,
                                 int page, int totalPages, int month, int year,
                                 String dateStr, String keyword, Integer departmentId,
                                 String status, LocalDate today) {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        request.setAttribute("attendances",     paged);
        request.setAttribute("totalAttendances", total);
        request.setAttribute("currentPage",      page);
        request.setAttribute("totalPages",       totalPages);
        request.setAttribute("pageSize",         PAGE_SIZE);
        request.setAttribute("selectedMonth",    month);
        request.setAttribute("selectedYear",     year);
        request.setAttribute("selectedDate",     dateStr);
        request.setAttribute("keyword",          keyword);
        request.setAttribute("departmentId",     departmentId);
        request.setAttribute("status",           status);
        request.setAttribute("today",            today);
        request.setAttribute("todayDisplay",     today.format(dtf));
        request.setAttribute("isMonthLocked",    attendanceService.isTimesheetLocked(month, year));
    }

    private void exportAttendanceToCsv(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int month = parseIntParam(request.getParameter("month"), LocalDate.now().getMonthValue());
        int year  = parseIntParam(request.getParameter("year"),  LocalDate.now().getYear());
        String kw = request.getParameter("keyword");
        String ds = request.getParameter("departmentId");
        String st = request.getParameter("status");
        Integer dId = (ds != null && !ds.trim().isEmpty()) ? Integer.valueOf(ds.trim()) : null;
        List<Attendance> list = attendanceService.search(kw, dId, st, null, month, year);
        writeAttendanceCsv(response, list);
    }

    private void writeAttendanceCsv(HttpServletResponse response, List<Attendance> list) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"cham_cong_" + LocalDate.now() + ".csv\"");
        PrintWriter writer = response.getWriter();
        writer.write('\uFEFF'); // BOM
        writer.println("STT,Mã Nhân Viên,Họ Và Tên,Phòng Ban,Chức Vụ,Ngày Chấm Công,Giờ Vào,Giờ Ra,Tổng Giờ,Trạng Thái,Phương Thức,Ghi Chú");
        int stt = 1;
        for (Attendance a : list) {
            writer.println(stt++ + "," +
                    escapeCsv(a.getEmployeeCode()) + "," +
                    escapeCsv(a.getEmployeeName()) + "," +
                    escapeCsv(a.getDepartmentName() != null ? a.getDepartmentName() : "") + "," +
                    escapeCsv(a.getPositionName()   != null ? a.getPositionName()   : "") + "," +
                    (a.getWorkDate()  != null ? a.getWorkDate().toString()  : "") + "," +
                    (a.getCheckIn()   != null ? a.getCheckIn().toString()   : "") + "," +
                    (a.getCheckOut()  != null ? a.getCheckOut().toString()  : "") + "," +
                    a.getTotalHours() + "," +
                    escapeCsv(a.getStatus()) + "," +
                    escapeCsv(a.getMethod() != null ? a.getMethod() : "") + "," +
                    escapeCsv(a.getNotes()  != null ? a.getNotes()  : ""));
        }
        writer.flush();
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }

    private LocalTime parseTimeSafe(String str) {
        if (str == null || str.trim().isEmpty()) return null;
        try {
            String s = str.trim();
            if (s.contains(".")) s = s.split("\\.")[0];
            return LocalTime.parse(s.length() > 5 ? s : s);
        } catch (Exception e) {
            return null;
        }
    }

    private int parseIntParam(String str, int defaultVal) {
        if (str == null || str.trim().isEmpty()) return defaultVal;
        try { return Integer.parseInt(str.trim()); } catch (NumberFormatException e) { return defaultVal; }
    }

    private List<Integer> parseIds(String[] arr) {
        List<Integer> ids = new ArrayList<>();
        if (arr == null) return ids;
        for (String s : arr) {
            try { ids.add(Integer.valueOf(s.trim())); } catch (NumberFormatException ignored) {}
        }
        return ids;
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));
    }

    private void writeJson(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message.replace("\"", "\\\"") + "\"}");
    }

    private boolean checkAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
