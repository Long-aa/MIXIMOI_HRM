package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.TimesheetSummary;
import com.miximoi.hrm.model.User;
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
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * Servlet quản lý chấm công.
 * URL: /attendance
 */
@WebServlet({"/attendance"})
public class AttendanceServlet extends HttpServlet {

    private final AttendanceDAO   attendanceDAO   = new AttendanceDAO();
    private final EmployeeDAO     employeeDAO     = new EmployeeDAO();
    private final DepartmentDAO   departmentDAO   = new DepartmentDAO();

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
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.trim().isEmpty()) ? Integer.parseInt(mStr.trim()) : today.getMonthValue();
        int year  = (yStr != null && !yStr.trim().isEmpty()) ? Integer.parseInt(yStr.trim()) : today.getYear();

        String keyword      = request.getParameter("keyword");
        String deptStr      = request.getParameter("departmentId");
        String status       = request.getParameter("status");
        String tab          = request.getParameter("tab");
        Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.parseInt(deptStr.trim()) : null;

        User user = (User) request.getSession().getAttribute("currentUser");

        List<Attendance> attendances;
        if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
            // Employee role: show their personal monthly attendance
            attendances = attendanceDAO.findByEmployeeAndMonth(user.getEmployeeId(), month, year);

            // Personal today status
            Attendance todayAtt = attendanceDAO.findByEmployeeAndDate(user.getEmployeeId(), today);
            if (todayAtt != null) {
                request.setAttribute("todayCheckIn", todayAtt.getCheckIn() != null ? todayAtt.getCheckIn().toString() : null);
                request.setAttribute("todayCheckOut", todayAtt.getCheckOut() != null ? todayAtt.getCheckOut().toString() : null);
                request.setAttribute("todayHours", todayAtt.getTotalHours() > 0 ? (todayAtt.getTotalHours() + "h") : "0h 00m");
            }
            request.setAttribute("workDaysThisMonth", attendances != null ? attendances.size() : 0);

        } else if (user.isAccountant() && !user.isAdmin()) {
            // Accountant role: view monthly timesheet summary
            List<TimesheetSummary> summary = attendanceDAO.getTimesheetSummary(month, year);
            request.setAttribute("timesheetSummary", summary);
            attendances = attendanceDAO.search(keyword, departmentId, status, null, month, year);

        } else if (user.isManager() && !user.isAdmin() && !user.isHr()) {
            // Manager role: view department's attendance
            Integer managerDeptId = null;
            if (user.getEmployeeId() > 0) {
                Employee mgrEmp = employeeDAO.findById(user.getEmployeeId());
                if (mgrEmp != null) managerDeptId = mgrEmp.getDepartmentId();
            }
            if (managerDeptId != null && managerDeptId > 0) {
                departmentId = managerDeptId;
            }
            attendances = attendanceDAO.search(keyword, departmentId, status, null, month, year);

            Map<String, Integer> todayStats = attendanceDAO.getTodayStats(today);
            request.setAttribute("deptTotalToday", todayStats.get("totalEmployeesToday"));
            request.setAttribute("deptCheckedIn", todayStats.get("checkedInCount"));
            request.setAttribute("deptLateCount", todayStats.get("lateEarlyCount"));
            request.setAttribute("pendingApprovals", 3);

        } else {
            // Admin & HR: full management — Tự động seed nếu hôm nay chưa có dữ liệu
            attendanceDAO.autoSeedTodayData(today);
            LocalDate queryDate = "daily".equalsIgnoreCase(tab) ? today : null;
            attendances = attendanceDAO.search(keyword, departmentId, status, queryDate, month, year);

            Map<String, Integer> todayStats = attendanceDAO.getTodayStats(today);
            int totalEmp = todayStats.getOrDefault("totalEmployeesToday", 0);
            int checkedIn = todayStats.getOrDefault("checkedInCount", 0);
            int lateEarly = todayStats.getOrDefault("lateEarlyCount", 0);
            int absent = todayStats.getOrDefault("absentCount", 0);
            int wfh = todayStats.getOrDefault("wfhCount", 0);
            request.setAttribute("totalEmployeesToday", totalEmp);
            request.setAttribute("checkedInCount", checkedIn);
            request.setAttribute("lateEarlyCount", lateEarly);
            request.setAttribute("absentCount", absent);
            request.setAttribute("wfhCount", wfh);
            request.setAttribute("activeCaShift", 3);
            request.setAttribute("lateEarlyDiff", 2);
            request.setAttribute("absentApproved", Math.max(0, absent - 1));
            request.setAttribute("absentUnapproved", absent > 0 ? 1 : 0);
            request.setAttribute("deviceOnline", true);
            request.setAttribute("deviceCount", 4);
            request.setAttribute("anomalyCount", lateEarly + absent);

            List<TimesheetSummary> summary = attendanceDAO.getTimesheetSummary(month, year);
            request.setAttribute("timesheetSummary", summary);
        }

        int totalAttendances = attendances != null ? attendances.size() : 0;
        int pageSize = 10;
        int totalPages = Math.max(1, (int) Math.ceil((double) totalAttendances / pageSize));
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Math.max(1, Math.min(Integer.parseInt(pageStr.trim()), totalPages));
            } catch (NumberFormatException ignored) {}
        }
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalAttendances);
        List<Attendance> pagedAttendances = (attendances != null && fromIndex < totalAttendances)
                ? attendances.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        request.setAttribute("todayDisplay", today.format(dtf));
        request.setAttribute("attendances", pagedAttendances);
        request.setAttribute("totalAttendances", totalAttendances);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/WEB-INF/views/attendance/attendance-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        User user = (User) request.getSession().getAttribute("currentUser");

        switch (action) {
            case "checkin": {
                int empId = user.getEmployeeId() > 0 ? user.getEmployeeId() : 1;
                // Hỗ trợ chấm công bằng FaceID, vân tay (Fingerprint), GPS
                String method = request.getParameter("method");
                if (method == null || method.isEmpty()) method = "FaceID";
                attendanceDAO.checkInWithMethod(empId, LocalDate.now(), LocalTime.now(), method);
                response.sendRedirect(request.getContextPath() + "/attendance?success=checkin&method=" + method);
                break;
            }
            case "checkout": {
                int empId = user.getEmployeeId() > 0 ? user.getEmployeeId() : 1;
                attendanceDAO.checkOut(empId, LocalDate.now(), LocalTime.now());
                response.sendRedirect(request.getContextPath() + "/attendance?success=checkout");
                break;
            }
            case "manual": {
                // Admin / HR manual entry or adjustment
                String empStr = request.getParameter("employeeId");
                int empId = (empStr != null && !empStr.trim().isEmpty()) ? Integer.parseInt(empStr.trim()) : user.getEmployeeId();
                String dateStr = request.getParameter("workDate");
                LocalDate workDate = (dateStr != null && !dateStr.trim().isEmpty()) ? LocalDate.parse(dateStr.trim()) : LocalDate.now();

                String inStr = request.getParameter("checkIn");
                LocalTime checkIn = (inStr != null && !inStr.trim().isEmpty()) ? LocalTime.parse(inStr.trim()) : null;

                String outStr = request.getParameter("checkOut");
                LocalTime checkOut = (outStr != null && !outStr.trim().isEmpty()) ? LocalTime.parse(outStr.trim()) : null;

                String st = request.getParameter("status");
                String notes = request.getParameter("notes");

                attendanceDAO.upsertManual(empId, workDate, checkIn, checkOut, st, notes);
                response.sendRedirect(request.getContextPath() + "/attendance?success=manual_saved");
                break;
            }
            case "update": {
                // Admin / HR update record by ID
                int id = Integer.parseInt(request.getParameter("id"));
                String inStr = request.getParameter("checkIn");
                LocalTime checkIn = (inStr != null && !inStr.trim().isEmpty()) ? LocalTime.parse(inStr.trim()) : null;

                String outStr = request.getParameter("checkOut");
                LocalTime checkOut = (outStr != null && !outStr.trim().isEmpty()) ? LocalTime.parse(outStr.trim()) : null;

                String st = request.getParameter("status");
                String notes = request.getParameter("notes");

                attendanceDAO.update(id, checkIn, checkOut, st, notes);
                response.sendRedirect(request.getContextPath() + "/attendance?success=updated");
                break;
            }
            case "approveExplain": {
                int id = Integer.parseInt(request.getParameter("id"));
                attendanceDAO.approveExplain(id);
                response.sendRedirect(request.getContextPath() + "/attendance?success=approved");
                break;
            }
            case "explain": {
                int id = Integer.parseInt(request.getParameter("attendanceId"));
                String notes = request.getParameter("notes");
                Attendance a = attendanceDAO.findById(id);
                if (a != null) {
                    attendanceDAO.update(id, a.getCheckIn(), a.getCheckOut(), a.getStatus(), notes);
                }
                response.sendRedirect(request.getContextPath() + "/attendance?success=explained");
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                attendanceDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/attendance?success=deleted");
                break;
            }
            case "bulkMarkOnTime": {
                String[] idsArr = request.getParameterValues("ids");
                if (idsArr != null && idsArr.length > 0) {
                    List<Integer> ids = new java.util.ArrayList<>();
                    for (String sid : idsArr) {
                        try { ids.add(Integer.parseInt(sid.trim())); } catch (NumberFormatException ignored) {}
                    }
                    attendanceDAO.bulkMarkStatus(ids, "ON_TIME");
                }
                response.sendRedirect(request.getContextPath() + "/attendance?success=marked_ontime");
                break;
            }
            case "bulkDelete": {
                String[] idsArr = request.getParameterValues("ids");
                if (idsArr != null && idsArr.length > 0) {
                    List<Integer> ids = new java.util.ArrayList<>();
                    for (String sid : idsArr) {
                        try { ids.add(Integer.parseInt(sid.trim())); } catch (NumberFormatException ignored) {}
                    }
                    attendanceDAO.bulkDelete(ids);
                }
                response.sendRedirect(request.getContextPath() + "/attendance?success=deleted");
                break;
            }
            case "bulkExport": {
                String[] idsArr = request.getParameterValues("ids");
                List<Attendance> list;
                if (idsArr != null && idsArr.length > 0) {
                    List<Integer> ids = new java.util.ArrayList<>();
                    for (String sid : idsArr) {
                        try { ids.add(Integer.parseInt(sid.trim())); } catch (NumberFormatException ignored) {}
                    }
                    list = attendanceDAO.findByIds(ids);
                } else {
                    String keyword      = request.getParameter("keyword");
                    String deptStr      = request.getParameter("departmentId");
                    String status       = request.getParameter("status");
                    String mStr         = request.getParameter("month");
                    String yStr         = request.getParameter("year");
                    Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.parseInt(deptStr.trim()) : null;
                    Integer month        = (mStr != null && !mStr.trim().isEmpty()) ? Integer.parseInt(mStr.trim()) : LocalDate.now().getMonthValue();
                    Integer year         = (yStr != null && !yStr.trim().isEmpty()) ? Integer.parseInt(yStr.trim()) : LocalDate.now().getYear();
                    list = attendanceDAO.search(keyword, departmentId, status, null, month, year);
                }
                writeAttendanceCsv(response, list);
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/attendance");
        }
    }

    private void exportAttendanceToCsv(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword      = request.getParameter("keyword");
        String deptStr      = request.getParameter("departmentId");
        String status       = request.getParameter("status");
        String mStr         = request.getParameter("month");
        String yStr         = request.getParameter("year");

        Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.parseInt(deptStr.trim()) : null;
        Integer month        = (mStr != null && !mStr.trim().isEmpty()) ? Integer.parseInt(mStr.trim()) : LocalDate.now().getMonthValue();
        Integer year         = (yStr != null && !yStr.trim().isEmpty()) ? Integer.parseInt(yStr.trim()) : LocalDate.now().getYear();

        List<Attendance> list = attendanceDAO.search(keyword, departmentId, status, null, month, year);
        writeAttendanceCsv(response, list);
    }

    private void writeAttendanceCsv(HttpServletResponse response, List<Attendance> list) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"cham_cong_" + LocalDate.now() + ".csv\"");

        PrintWriter writer = response.getWriter();
        writer.write('\uFEFF'); // UTF-8 BOM
        writer.println("STT,Mã Nhân Viên,Họ Và Tên,Phòng Ban,Chức Vụ,Ngày Chấm Công,Giờ Vào,Giờ Ra,Tổng Giờ,Trạng Thái,Ghi Chú");

        int stt = 1;
        for (Attendance a : list) {
            StringBuilder sb = new StringBuilder();
            sb.append(stt++).append(",");
            sb.append(escapeCsv(a.getEmployeeCode())).append(",");
            sb.append(escapeCsv(a.getEmployeeName())).append(",");
            sb.append(escapeCsv(a.getDepartmentName() != null ? a.getDepartmentName() : "")).append(",");
            sb.append(escapeCsv(a.getPositionName() != null ? a.getPositionName() : "")).append(",");
            sb.append(a.getWorkDate() != null ? a.getWorkDate().toString() : "").append(",");
            sb.append(a.getCheckIn() != null ? a.getCheckIn().toString() : "").append(",");
            sb.append(a.getCheckOut() != null ? a.getCheckOut().toString() : "").append(",");
            sb.append(a.getTotalHours()).append(",");
            sb.append(escapeCsv(a.getStatus())).append(",");
            sb.append(escapeCsv(a.getNotes() != null ? a.getNotes() : ""));
            writer.println(sb.toString());
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
