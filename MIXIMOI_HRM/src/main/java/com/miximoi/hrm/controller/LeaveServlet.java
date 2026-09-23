package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.LeaveService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý Nghỉ phép & Nghỉ lễ.
 * URL: /leave
 */
@WebServlet("/leave")
public class LeaveServlet extends HttpServlet {

    private final LeaveService leaveService = new LeaveService();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "leave");
        User currentUser = getCurrentUser(request);

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                request.setAttribute("employees", employeeDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/leave/leave-form.jsp")
                       .forward(request, response);
                break;
            case "detail": {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("leaveRequest", leaveService.getById(id));
                request.getRequestDispatcher("/WEB-INF/views/leave/leave-detail.jsp")
                       .forward(request, response);
                break;
            }
            case "export": {
                exportLeaveRequestsCSV(request, response, currentUser);
                break;
            }
            default: {
                String tab = request.getParameter("tab");
                if (tab == null) tab = "requests";

                String status = request.getParameter("status");
                String deptParam = request.getParameter("departmentId");
                Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
                String leaveType = request.getParameter("leaveType");
                String keyword = request.getParameter("keyword");

                List<LeaveRequest> list = leaveService.getByFilters(
                        currentUser, status, departmentId, leaveType, keyword);

                int totalLeaves = list != null ? list.size() : 0;
                int pageSize = 10;
                int totalPages = Math.max(1, (int) Math.ceil((double) totalLeaves / pageSize));
                int page = 1;
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    try {
                        page = Math.max(1, Math.min(Integer.parseInt(pageStr.trim()), totalPages));
                    } catch (NumberFormatException ignored) {}
                }
                int fromIndex = (page - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, totalLeaves);
                List<LeaveRequest> pagedLeaves = (list != null && fromIndex < totalLeaves)
                        ? list.subList(fromIndex, toIndex)
                        : new java.util.ArrayList<>();

                List<Department> departments = departmentDAO.findAll();
                List<Employee> employees = employeeDAO.findAll();

                request.setAttribute("leaveRequests", pagedLeaves);
                request.setAttribute("totalLeaves",   totalLeaves);
                request.setAttribute("currentPage",   page);
                request.setAttribute("totalPages",    totalPages);
                request.setAttribute("pageSize",      pageSize);
                request.setAttribute("departments", departments);
                request.setAttribute("employees", employees);
                request.setAttribute("selectedStatus", status);
                request.setAttribute("selectedDeptId", departmentId);
                request.setAttribute("selectedLeaveType", leaveType);
                request.setAttribute("keyword", keyword);
                request.setAttribute("activeTab", tab);

                // ===== KPI ĐỘNG theo Role =====
                int currentYear = java.time.LocalDate.now().getYear();
                com.miximoi.hrm.dao.LeaveDAO leaveDAO = new com.miximoi.hrm.dao.LeaveDAO();
                int[] typeStats = leaveDAO.getLeaveStatsByType(currentYear); // [annual, sick, personal, maternity, unpaid, total]
                int totalUsedDays = typeStats[5];

                // KPI chung cho Admin/HR
                int todayOnLeaveCount = leaveDAO.countOnLeaveToday();
                int totalEmpCount = employees != null ? employees.size() : 1;
                double todayOnLeavePct = totalEmpCount > 0 ? Math.round((double) todayOnLeaveCount / totalEmpCount * 1000.0) / 10.0 : 0.0;
                int pendingCount = leaveDAO.countPending();
                int pending24hCount = leaveDAO.countPending24h();
                int companyQuota = totalEmpCount * 12;

                request.setAttribute("todayOnLeaveCount", todayOnLeaveCount);
                request.setAttribute("todayOnLeavePct",   todayOnLeavePct);
                request.setAttribute("pendingCount",      pendingCount);
                request.setAttribute("pending24hCount",   pending24hCount);
                request.setAttribute("totalUsedDays",     totalUsedDays);
                request.setAttribute("companyQuota",      companyQuota);

                // KPI loại nghỉ phép (cho thẻ biểu đồ cơ cấu)
                int annualDays   = typeStats[0];
                int sickDays     = typeStats[1];
                int personalDays = typeStats[2];
                int maternityDays= typeStats[3];
                int unpaidDays   = typeStats[4];
                int annualPct    = totalUsedDays > 0 ? (int) Math.round((double) annualDays    / totalUsedDays * 100) : 0;
                int sickPct      = totalUsedDays > 0 ? (int) Math.round((double) sickDays      / totalUsedDays * 100) : 0;
                int personalPct  = totalUsedDays > 0 ? (int) Math.round((double) personalDays  / totalUsedDays * 100) : 0;
                int maternityPct = totalUsedDays > 0 ? (int) Math.round((double) maternityDays / totalUsedDays * 100) : 0;
                int unpaidPct    = totalUsedDays > 0 ? (int) Math.round((double) unpaidDays    / totalUsedDays * 100) : 0;

                request.setAttribute("annualDays",    annualDays);
                request.setAttribute("sickDays",      sickDays);
                request.setAttribute("personalDays",  personalDays);
                request.setAttribute("maternityDays", maternityDays);
                request.setAttribute("unpaidDays",    unpaidDays);
                request.setAttribute("annualPct",     annualPct);
                request.setAttribute("sickPct",       sickPct);
                request.setAttribute("personalPct",   personalPct);
                request.setAttribute("maternityPct",  maternityPct);
                request.setAttribute("unpaidPct",     unpaidPct);

                // KPI cá nhân (Employee view)
                String displayName = currentUser.getFullName();
                if (displayName == null || displayName.trim().isEmpty() || "admin".equalsIgnoreCase(displayName)) {
                    displayName = currentUser.getUsername() != null ? currentUser.getUsername() : "Tài khoản hệ thống";
                }
                request.setAttribute("userLeaveName", displayName);

                int empId = currentUser.getEmployeeId();
                double usedLeaveDays = 0.0;
                double standardLeaveDays = 12.0;
                double seniorityLeaveDays = 0.0;
                double carryOverLeaveDays = 0.0;
                double availableLeaveDays = 12.0;
                int empPendingCount = 0;
                String latestPendingCode = null;

                if (empId > 0) {
                    usedLeaveDays = leaveDAO.countUsedDaysByEmployee(empId, currentYear);
                    empPendingCount = leaveDAO.countPendingByEmployee(empId);
                    latestPendingCode = leaveDAO.getLatestPendingCode(empId);

                    // Tính thâm niên theo Điều 114 BLLĐ 2019: cứ đủ 5 năm thêm 1 ngày
                    Employee empObj = employeeDAO.findById(empId);
                    if (empObj != null && empObj.getStartDate() != null) {
                        long yearsOfService = java.time.temporal.ChronoUnit.YEARS.between(empObj.getStartDate(), java.time.LocalDate.now());
                        seniorityLeaveDays = Math.floor((double) yearsOfService / 5);
                        // Phép tồn (giả sử tối đa 5 ngày, lấy theo số năm)
                        carryOverLeaveDays = Math.min(yearsOfService > 0 ? 3.0 : 0.0, 5.0);
                    }
                    availableLeaveDays = standardLeaveDays + seniorityLeaveDays + carryOverLeaveDays - usedLeaveDays;
                    if (availableLeaveDays < 0) availableLeaveDays = 0;
                }

                request.setAttribute("standardLeaveDays",   standardLeaveDays);
                request.setAttribute("seniorityLeaveDays",  seniorityLeaveDays);
                request.setAttribute("carryOverLeaveDays",  carryOverLeaveDays);
                request.setAttribute("usedLeaveDays",       usedLeaveDays);
                request.setAttribute("availableLeaveDays",  availableLeaveDays);
                request.setAttribute("empPendingCount",     empPendingCount);
                request.setAttribute("latestPendingCode",   latestPendingCode);

                // KPI Manager: thống kê phòng ban
                if (currentUser.isManager() && !currentUser.isAdmin() && !currentUser.isHr()) {
                    Employee managerEmp = empId > 0 ? employeeDAO.findById(empId) : null;
                    int mgrDeptId = managerEmp != null ? managerEmp.getDepartmentId() : 0;
                    if (mgrDeptId > 0) {
                        int deptOnLeaveToday = leaveDAO.countOnLeaveTodayByDepartment(mgrDeptId);
                        int deptPendingCount = leaveDAO.countPendingByDepartment(mgrDeptId);
                        // Đếm tổng nhân viên phòng ban
                        long deptTotalEmp = employees != null ? employees.stream()
                                .filter(e -> e.getDepartmentId() == mgrDeptId).count() : 1;
                        double deptAbsencePct = deptTotalEmp > 0
                                ? Math.round((double) deptOnLeaveToday / deptTotalEmp * 1000.0) / 10.0 : 0.0;
                        double deptAttendancePct = 100.0 - deptAbsencePct;

                        request.setAttribute("deptOnLeaveToday",   deptOnLeaveToday);
                        request.setAttribute("deptTotalEmp",        (int) deptTotalEmp);
                        request.setAttribute("deptPendingCount",    deptPendingCount);
                        request.setAttribute("deptAttendancePct",   deptAttendancePct);
                        request.setAttribute("deptAbsencePct",      deptAbsencePct);
                    }
                }

                // ===== Weekly Absences & Schedule cho Lịch tuần =====
                java.time.LocalDate todayDate = java.time.LocalDate.now();
                java.time.LocalDate weekStart = todayDate
                        .with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
                java.time.LocalDate weekEnd = weekStart.plusDays(4); // T2 -> T6
                java.util.Map<java.time.LocalDate, Integer> weeklyAbsences =
                        leaveDAO.getWeeklyAbsences(weekStart, weekEnd);
                request.setAttribute("weeklyAbsences", weeklyAbsences);

                int weekNum = todayDate.get(java.time.temporal.WeekFields.of(java.util.Locale.getDefault()).weekOfWeekBasedYear());
                java.time.format.DateTimeFormatter df = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                request.setAttribute("weekStartFmt", weekStart.format(df));
                request.setAttribute("weekEndFmt", weekEnd.format(df));
                request.setAttribute("weekNum", weekNum);

                java.util.List<java.util.Map<String, Object>> weeklySchedule = new java.util.ArrayList<>();
                String[] dayLabels = {"T2", "T3", "T4", "T5", "T6"};
                for (int i = 0; i < 5; i++) {
                    java.time.LocalDate curDate = weekStart.plusDays(i);
                    java.util.Map<String, Object> dayMap = new java.util.HashMap<>();
                    dayMap.put("dayLabel", dayLabels[i]);
                    dayMap.put("dayNum", curDate.getDayOfMonth());
                    dayMap.put("dateStr", curDate.format(df));
                    dayMap.put("isToday", curDate.equals(todayDate));
                    int count = (weeklyAbsences != null) ? weeklyAbsences.getOrDefault(curDate, 0) : 0;
                    dayMap.put("absenceCount", count);
                    weeklySchedule.add(dayMap);
                }
                request.setAttribute("weeklySchedule", weeklySchedule);

                // ===== Tab Balance: Tồn phép nhân viên =====
                if ("balance".equalsIgnoreCase(tab)) {
                    java.util.List<com.miximoi.hrm.model.EmployeeLeaveBalance> leaveBalances =
                            leaveDAO.getAllLeaveBalances(currentYear);
                    request.setAttribute("leaveBalances", leaveBalances);
                }

                request.getRequestDispatcher("/WEB-INF/views/leave/leave-list.jsp")
                       .forward(request, response);

            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentUser(request);
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "submit": {
                LeaveRequest lr = new LeaveRequest();
                int empId = currentUser.getEmployeeId() > 0 ? currentUser.getEmployeeId() : 1;
                if (currentUser.isAdmin() || currentUser.isHr() || currentUser.isManager()) {
                    String empParam = request.getParameter("employeeId");
                    if (empParam != null && !empParam.isEmpty()) {
                        empId = Integer.parseInt(empParam);
                    }
                }
                lr.setEmployeeId(empId);

                Employee emp = employeeDAO.findById(empId);
                lr.setEmployeeName(emp != null ? emp.getFullName() : currentUser.getFullName());
                lr.setEmployeeCode(emp != null ? emp.getEmployeeCode() : "NV001");
                lr.setDepartmentName(emp != null ? emp.getDepartmentName() : "Khối R&D");
                lr.setPositionName(emp != null ? emp.getPositionName() : "Nhân viên");

                lr.setLeaveType(request.getParameter("leaveType"));
                String sd = request.getParameter("startDate");
                String ed = request.getParameter("endDate");
                if (sd != null && !sd.isEmpty()) lr.setStartDate(LocalDate.parse(sd));
                if (ed != null && !ed.isEmpty()) lr.setEndDate(LocalDate.parse(ed));

                String daysStr = request.getParameter("days");
                if (daysStr != null && !daysStr.isEmpty()) {
                    lr.setDays(Double.parseDouble(daysStr));
                }

                lr.setReason(request.getParameter("reason"));
                lr.setHandoverPerson(request.getParameter("handoverPerson"));

                String error = leaveService.createLeaveRequest(lr);
                if (error != null) {
                    response.sendRedirect(request.getContextPath() + "/leave?error=" + java.net.URLEncoder.encode(error, "UTF-8"));
                } else {
                    response.sendRedirect(request.getContextPath() + "/leave?success=submitted");
                }
                break;
            }
            case "approve": {
                if (currentUser.isManager() || currentUser.isHr() || currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    leaveService.approve(id, currentUser.getEmployeeId());

                    // Đồng bộ sang bảng chấm công: Ghi nhận ngày nghỉ phép ON_LEAVE
                    LeaveRequest lr = leaveService.getById(id);
                    if (lr != null && lr.getStartDate() != null && lr.getEndDate() != null) {
                        LocalDate d = lr.getStartDate();
                        while (!d.isAfter(lr.getEndDate())) {
                            attendanceDAO.upsertManual(lr.getEmployeeId(), d, null, null, "ON_LEAVE", "Nghỉ phép theo đơn " + lr.getLeaveCode());
                            d = d.plusDays(1);
                        }
                    }

                    response.sendRedirect(request.getContextPath() + "/leave?success=approved");
                    return;
                }
                break;
            }
            case "reject": {
                if (currentUser.isManager() || currentUser.isHr() || currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String reason = request.getParameter("rejectReason");
                    leaveService.reject(id, currentUser.getEmployeeId(), reason);
                    response.sendRedirect(request.getContextPath() + "/leave?success=rejected");
                    return;
                }
                break;
            }
            case "bulkApprove": {
                if (currentUser.isManager() || currentUser.isHr() || currentUser.isAdmin()) {
                    String[] idsArr = request.getParameterValues("ids");
                    if (idsArr != null && idsArr.length > 0) {
                        List<Integer> ids = new java.util.ArrayList<>();
                        for (String sid : idsArr) {
                            try { ids.add(Integer.parseInt(sid.trim())); } catch (NumberFormatException ignored) {}
                        }
                        leaveService.bulkApprove(ids, currentUser.getEmployeeId());
                        // Đồng bộ sang chấm công
                        for (int id : ids) {
                            LeaveRequest lr = leaveService.getById(id);
                            if (lr != null && lr.getStartDate() != null && lr.getEndDate() != null) {
                                LocalDate d = lr.getStartDate();
                                while (!d.isAfter(lr.getEndDate())) {
                                    attendanceDAO.upsertManual(lr.getEmployeeId(), d, null, null, "ON_LEAVE", "Nghỉ phép theo đơn " + lr.getLeaveCode());
                                    d = d.plusDays(1);
                                }
                            }
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/leave?success=approved");
                    return;
                }
                break;
            }
            case "bulkReject": {
                if (currentUser.isManager() || currentUser.isHr() || currentUser.isAdmin()) {
                    String[] idsArr = request.getParameterValues("ids");
                    if (idsArr != null && idsArr.length > 0) {
                        List<Integer> ids = new java.util.ArrayList<>();
                        for (String sid : idsArr) {
                            try { ids.add(Integer.parseInt(sid.trim())); } catch (NumberFormatException ignored) {}
                        }
                        String reason = request.getParameter("rejectReason");
                        leaveService.bulkReject(ids, currentUser.getEmployeeId(), reason);
                    }
                    response.sendRedirect(request.getContextPath() + "/leave?success=rejected");
                    return;
                }
                break;
            }
            case "bulkDelete": {
                if (currentUser.isAdmin() || currentUser.isHr()) {
                    String[] idsArr = request.getParameterValues("ids");
                    if (idsArr != null && idsArr.length > 0) {
                        List<Integer> ids = new java.util.ArrayList<>();
                        for (String sid : idsArr) {
                            try { ids.add(Integer.parseInt(sid.trim())); } catch (NumberFormatException ignored) {}
                        }
                        leaveService.bulkDelete(ids);
                    }
                    response.sendRedirect(request.getContextPath() + "/leave?success=deleted");
                    return;
                }
                break;
            }
            case "bulkExport": {
                String[] idsArr = request.getParameterValues("ids");
                List<LeaveRequest> list;
                if (idsArr != null && idsArr.length > 0) {
                    List<Integer> ids = new java.util.ArrayList<>();
                    for (String sid : idsArr) {
                        try { ids.add(Integer.parseInt(sid.trim())); } catch (NumberFormatException ignored) {}
                    }
                    list = leaveService.findByIds(ids);
                } else {
                    String status = request.getParameter("status");
                    String deptParam = request.getParameter("departmentId");
                    Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
                    String leaveType = request.getParameter("leaveType");
                    String keyword = request.getParameter("keyword");
                    list = leaveService.getByFilters(currentUser, status, departmentId, leaveType, keyword);
                }
                writeLeaveCsv(response, list);
                return;
            }
            case "export": {
                exportLeaveRequestsCSV(request, response, currentUser);
                return;
            }
            case "cancel": {
                // Nhân viên hủy đơn của mình (chỉ khi còn PENDING)
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    int leaveId = Integer.parseInt(idStr);
                    int cancelEmpId = currentUser.getEmployeeId();
                    if (cancelEmpId > 0) {
                        com.miximoi.hrm.dao.LeaveDAO leaveDAO2 = new com.miximoi.hrm.dao.LeaveDAO();
                        boolean cancelled = leaveDAO2.cancelLeave(leaveId, cancelEmpId);
                        if (cancelled) {
                            response.sendRedirect(request.getContextPath() + "/leave?success=cancelled");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/leave?error=Không thể hủy đơn. Đơn đã được xử lý hoặc không thuộc về bạn.");
                        }
                        return;
                    }
                }
                response.sendRedirect(request.getContextPath() + "/leave?error=Yêu cầu hủy không hợp lệ.");
                return;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/leave");
        }
    }

    /** Xuất danh sách đơn xin nghỉ phép ra định dạng CSV (UTF-8 BOM hỗ trợ Excel tiếng Việt) */
    private void exportLeaveRequestsCSV(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        String status = request.getParameter("status");
        String deptParam = request.getParameter("departmentId");
        Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
        String leaveType = request.getParameter("leaveType");
        String keyword = request.getParameter("keyword");

        List<LeaveRequest> list = leaveService.getByFilters(currentUser, status, departmentId, leaveType, keyword);
        writeLeaveCsv(response, list);
    }

    private void writeLeaveCsv(HttpServletResponse response, List<LeaveRequest> list) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"MIXIMOI_Leave_Requests_" + LocalDate.now() + ".csv\"");

        try (OutputStream os = response.getOutputStream()) {
            // Ghi UTF-8 BOM
            os.write(new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF});

            StringBuilder sb = new StringBuilder();
            sb.append("Mã Đơn,Mã NV,Họ Tên Nhân Viên,Phòng Ban,Chức Vụ,Loại Nghỉ Phép,Từ Ngày,Đến Ngày,Số Ngày Nghỉ,Lý Do,Trạng Thái,Người Duyệt,Ngày Tạo\n");

            for (LeaveRequest lr : list) {
                sb.append("\"").append(safe(lr.getLeaveCode())).append("\",");
                sb.append("\"").append(safe(lr.getEmployeeCode())).append("\",");
                sb.append("\"").append(safe(lr.getEmployeeName())).append("\",");
                sb.append("\"").append(safe(lr.getDepartmentName())).append("\",");
                sb.append("\"").append(safe(lr.getPositionName())).append("\",");
                sb.append("\"").append(getLeaveTypeName(lr.getLeaveType())).append("\",");
                sb.append("\"").append(lr.getStartDate() != null ? lr.getStartDate().toString() : "").append("\",");
                sb.append("\"").append(lr.getEndDate() != null ? lr.getEndDate().toString() : "").append("\",");
                sb.append("\"").append(lr.getDays()).append("\",");
                sb.append("\"").append(safe(lr.getReason())).append("\",");
                sb.append("\"").append(getStatusName(lr.getStatus())).append("\",");
                sb.append("\"").append(safe(lr.getApprovedByName())).append("\",");
                sb.append("\"").append(lr.getCreatedAt() != null ? lr.getCreatedAt().toString() : "").append("\"\n");
            }

            os.write(sb.toString().getBytes(StandardCharsets.UTF_8));
            os.flush();
        }
    }

    private String safe(String val) {
        return val != null ? val.replace("\"", "\"\"") : "";
    }

    private String getLeaveTypeName(String type) {
        if (type == null) return "Nghỉ phép";
        switch (type.toUpperCase()) {
            case "ANNUAL": return "Phép năm (AL)";
            case "SICK": return "Nghỉ ốm (SL)";
            case "PERSONAL": return "Việc riêng hưởng lương";
            case "WEDDING": return "Kết hôn";
            case "MATERNITY": return "Thai sản";
            case "UNPAID": return "Nghỉ không lương (UL)";
            default: return type;
        }
    }

    private String getStatusName(String status) {
        if (status == null) return "Chờ duyệt";
        switch (status.toUpperCase()) {
            case "APPROVED": return "Đã phê duyệt";
            case "REJECTED": return "Từ chối";
            case "CANCELLED": return "Đã hủy";
            default: return "Chờ duyệt";
        }
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

    private User getCurrentUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("currentUser");
    }
}
