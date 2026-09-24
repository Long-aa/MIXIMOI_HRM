package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DashboardDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.model.Department;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;

/**
 * Servlet hiển thị Dashboard tổng quan và xử lý bộ lọc dữ liệu thời gian thực.
 * URL: /dashboard
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 1. Xác định khoảng ngày mặc định: Đầu tháng hiện tại đến ngày hiện tại
        LocalDate today = LocalDate.now();
        LocalDate defaultStartDate = today.withDayOfMonth(1);
        LocalDate defaultEndDate = today;

        LocalDate startDate = defaultStartDate;
        LocalDate endDate = defaultEndDate;

        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");

        if (startDateParam != null && !startDateParam.trim().isEmpty()) {
            try {
                startDate = LocalDate.parse(startDateParam.trim());
            } catch (DateTimeParseException e) {
                startDate = defaultStartDate;
            }
        }

        if (endDateParam != null && !endDateParam.trim().isEmpty()) {
            try {
                endDate = LocalDate.parse(endDateParam.trim());
            } catch (DateTimeParseException e) {
                endDate = defaultEndDate;
            }
        }

        // Đảm bảo startDate <= endDate
        if (startDate.isAfter(endDate)) {
            LocalDate temp = startDate;
            startDate = endDate;
            endDate = temp;
        }

        // 2. Tham số bộ lọc phòng ban và trạng thái
        Integer departmentId = null;
        String deptParam = request.getParameter("departmentId");
        if (deptParam != null && !deptParam.trim().isEmpty() && !"all".equalsIgnoreCase(deptParam)) {
            try {
                departmentId = Integer.parseInt(deptParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        String status = request.getParameter("status");
        if (status != null && (status.trim().isEmpty() || "all".equalsIgnoreCase(status.trim()))) {
            status = null;
        }

        // 3. Lấy dữ liệu danh mục phòng ban phục vụ dropdown filter
        List<Department> departmentList = departmentDAO.findAll();
        request.setAttribute("departmentList", departmentList);

        // 4. Lấy toàn bộ dữ liệu thống kê thực tế từ DB qua DashboardDAO
        Map<String, Object> kpiStats = dashboardDAO.getKpiStats(startDate, endDate, departmentId, status);
        Map<String, Object> attendanceSummary = dashboardDAO.getAttendanceSummary(startDate, endDate, departmentId);
        Map<String, Object> leaveSummary = dashboardDAO.getLeaveSummary(startDate, endDate, departmentId);
        Map<String, Object> urgentTasks = dashboardDAO.getUrgentTasks(startDate, endDate, departmentId);
        Map<String, Object> payrollSummary = dashboardDAO.getPayrollSummary(startDate, endDate, departmentId);
        Map<String, Object> recruitmentStats = dashboardDAO.getRecruitmentStats(startDate, endDate, departmentId);
        Map<String, Object> personnelStructure = dashboardDAO.getPersonnelStructure(departmentId);
        Map<String, Object> monthlyGrowthTrend = dashboardDAO.getMonthlyGrowthTrend();
        List<Map<String, Object>> departmentKpis = dashboardDAO.getDepartmentKpis(departmentId);
        List<Map<String, Object>> recentActivities = dashboardDAO.getRecentActivities();

        // 5. Gán thuộc tính vào request scope
        request.setAttribute("startDate", startDate.toString());
        request.setAttribute("endDate", endDate.toString());
        request.setAttribute("selectedDepartmentId", departmentId);
        request.setAttribute("selectedStatus", status);

        request.setAttribute("kpiStats", kpiStats);
        request.setAttribute("attendanceSummary", attendanceSummary);
        request.setAttribute("leaveSummary", leaveSummary);
        request.setAttribute("urgentTasks", urgentTasks);
        request.setAttribute("payrollSummary", payrollSummary);
        request.setAttribute("recruitmentStats", recruitmentStats);
        request.setAttribute("personnelStructure", personnelStructure);
        request.setAttribute("monthlyGrowthTrend", monthlyGrowthTrend);
        request.setAttribute("departmentKpis", departmentKpis);
        request.setAttribute("recentActivities", recentActivities);

        // Các thuộc tính backward compatibility nếu có
        request.setAttribute("totalEmployees", kpiStats.get("totalEmployees"));
        request.setAttribute("pendingLeaves", kpiStats.get("pendingLeaves"));
        request.setAttribute("totalPayroll", kpiStats.get("totalPayroll"));
        request.setAttribute("currentMonth", today.getMonthValue());
        request.setAttribute("currentYear", today.getYear());

        request.getRequestDispatcher("/WEB-INF/views/dashboard/dashboard.jsp")
               .forward(request, response);
    }
}

