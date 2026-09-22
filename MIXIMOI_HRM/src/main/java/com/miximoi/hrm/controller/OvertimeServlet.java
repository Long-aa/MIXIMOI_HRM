package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.OvertimeDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Overtime;
import com.miximoi.hrm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

/**
 * Servlet quản lý Tăng ca & Làm thêm giờ (OT).
 * URL: /overtime
 */
@WebServlet({"/overtime"})
public class OvertimeServlet extends HttpServlet {

    private final OvertimeDAO overtimeDAO = new OvertimeDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "overtime");

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        int month = 9;
        int year = 2026;
        try {
            if (request.getParameter("month") != null) month = Integer.parseInt(request.getParameter("month"));
            if (request.getParameter("year") != null) year = Integer.parseInt(request.getParameter("year"));
        } catch (NumberFormatException ignored) {}

        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) tab = "all";

        String deptParam = request.getParameter("departmentId");
        Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
        String otType = request.getParameter("otType");
        String project = request.getParameter("project");
        String keyword = request.getParameter("keyword");

        // Lấy danh sách đơn OT theo phân quyền Role
        List<Overtime> allOvertimes = overtimeDAO.findByFilters(
                currentUser, month, year, tab, departmentId, otType, project, keyword);
        if (allOvertimes == null) allOvertimes = new java.util.ArrayList<>();

        Map<String, Integer> counts = overtimeDAO.getCountsByTab(currentUser, month, year);
        List<Map<String, Object>> topEmployees = overtimeDAO.getTopOvertimeEmployees(month, year);
        List<Employee> employees = employeeDAO.findAll();
        List<Department> departments = departmentDAO.findAll();

        // Phân trang 10/trang
        int pageSize = 10;
        int totalRecords = allOvertimes.size();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        int fromIdx = (page - 1) * pageSize;
        int toIdx   = Math.min(fromIdx + pageSize, totalRecords);
        List<Overtime> overtimes = (totalRecords > 0) ? allOvertimes.subList(fromIdx, toIdx) : allOvertimes;

        request.setAttribute("overtimes", overtimes);
        request.setAttribute("counts", counts);
        request.setAttribute("activeTab", tab);
        request.setAttribute("topEmployees", topEmployees);
        request.setAttribute("employees", employees);
        request.setAttribute("departments", departments);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedDeptId", departmentId);
        request.setAttribute("selectedOtType", otType);
        request.setAttribute("selectedProject", project);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/WEB-INF/views/attendance/overtime.jsp")
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

        switch (action) {
            case "create": {
                // Tạo đơn đăng ký tăng ca mới
                try {
                    int empId = currentUser.getEmployeeId() > 0 ? currentUser.getEmployeeId() : 1;
                    // Nếu là Admin, HR, Manager thì có thể chọn nhân viên khác
                    if (currentUser.isAdmin() || currentUser.isHr() || currentUser.isManager()) {
                        String empParam = request.getParameter("employeeId");
                        if (empParam != null && !empParam.isEmpty()) {
                            empId = Integer.parseInt(empParam);
                        }
                    }

                    Employee emp = employeeDAO.findById(empId);
                    String empName = emp != null ? emp.getFullName() : currentUser.getFullName();
                    String empCode = emp != null ? emp.getEmployeeCode() : "NV001";
                    String deptName = emp != null ? emp.getDepartmentName() : "CNTT & Sản phẩm";
                    String posName = emp != null ? emp.getPositionName() : "Nhân viên";

                    String projectName = request.getParameter("projectName");
                    String dateStr = request.getParameter("overtimeDate");
                    LocalDate otDate = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr) : LocalDate.now();

                    String startStr = request.getParameter("startTime");
                    String endStr = request.getParameter("endTime");
                    LocalTime startTime = (startStr != null && !startStr.isEmpty()) ? LocalTime.parse(startStr) : LocalTime.of(18, 0);
                    LocalTime endTime = (endStr != null && !endStr.isEmpty()) ? LocalTime.parse(endStr) : LocalTime.of(21, 30);

                    // Tính số giờ
                    long minutes = Duration.between(startTime, endTime).toMinutes();
                    double hours = Math.max(0.5, Math.round((minutes / 60.0) * 10.0) / 10.0);

                    String coeffStr = request.getParameter("coefficient");
                    double coefficient = 1.5;
                    if (coeffStr != null && !coeffStr.isEmpty()) {
                        coefficient = Double.parseDouble(coeffStr);
                    }

                    String otType = "REGULAR";
                    if (coefficient >= 3.0) otType = "HOLIDAY";
                    else if (coefficient >= 2.0) otType = "WEEKEND";

                    String reason = request.getParameter("reason");
                    String leadName = request.getParameter("leadApproverName");

                    Overtime ot = new Overtime();
                    ot.setEmployeeId(empId);
                    ot.setEmployeeName(empName);
                    ot.setEmployeeCode(empCode);
                    ot.setDepartmentName(deptName);
                    ot.setPositionName(posName);
                    ot.setProjectName(projectName != null && !projectName.isEmpty() ? projectName : "Dự án hệ thống");
                    ot.setOvertimeDate(otDate);
                    ot.setStartTime(startTime);
                    ot.setEndTime(endTime);
                    ot.setHours(hours);
                    ot.setCoefficient(coefficient);
                    ot.setOtType(otType);
                    ot.setAmount(BigDecimal.valueOf((long) (hours * coefficient * 150000)));
                    ot.setReason(reason);
                    ot.setLeadApproverName(leadName != null && !leadName.isEmpty() ? leadName : "Trần Tuấn Hưng (CTO)");

                    overtimeDAO.insert(ot);
                    response.sendRedirect(request.getContextPath() + "/overtime?success=created");
                    return;
                } catch (Exception e) {
                    System.err.println("OvertimeServlet.create error: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/overtime?error=create_failed");
                    return;
                }
            }
            case "approve_lead": {
                // Quản lý / Lead phê duyệt Cấp 1
                if (currentUser.isManager() || currentUser.isAdmin() || currentUser.isHr()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    overtimeDAO.approveLead(id, currentUser.getEmployeeId(), currentUser.getFullName());
                    response.sendRedirect(request.getContextPath() + "/overtime?success=lead_approved");
                    return;
                }
                break;
            }
            case "approve_hr": {
                // HR Lead phê duyệt Cấp 2 (Hoàn tất)
                if (currentUser.isHr() || currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    overtimeDAO.approveHr(id, currentUser.getEmployeeId(), currentUser.getFullName());
                    response.sendRedirect(request.getContextPath() + "/overtime?success=hr_approved");
                    return;
                }
                break;
            }
            case "reject": {
                // Từ chối đơn
                if (currentUser.isManager() || currentUser.isHr() || currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String rejectReason = request.getParameter("rejectReason");
                    overtimeDAO.reject(id, currentUser.getEmployeeId(), currentUser.getFullName(), rejectReason);
                    response.sendRedirect(request.getContextPath() + "/overtime?success=rejected");
                    return;
                }
                break;
            }
        }

        response.sendRedirect(request.getContextPath() + "/overtime");
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
