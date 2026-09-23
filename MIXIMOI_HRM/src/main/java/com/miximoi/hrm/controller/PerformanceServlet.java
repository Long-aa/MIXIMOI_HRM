package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.PerformanceDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.KpiMetric;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý KPI & Đánh giá hiệu suất toàn diện:
 * URL: /performance, /kpi
 */
@WebServlet({"/performance", "/kpi"})
public class PerformanceServlet extends HttpServlet {

    private final PerformanceDAO performanceDAO = new PerformanceDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "performance");

        String quarter = request.getParameter("quarter");
        if (quarter == null || quarter.trim().isEmpty()) quarter = "Q3/2026";

        Integer deptId = null;
        try {
            String deptParam = request.getParameter("deptId");
            if (deptParam != null && !deptParam.trim().isEmpty()) {
                deptId = Integer.parseInt(deptParam.trim());
            }
        } catch (NumberFormatException ignored) {}

        String status = request.getParameter("status");
        String rating = request.getParameter("rating");
        String search = request.getParameter("search");

        List<KpiMetric> kpis = performanceDAO.findKpis(quarter, deptId, status, rating, search);
        request.setAttribute("kpis", kpis);

        // Thống kê nhanh từ list KPI
        int totalKpi = kpis.size();
        int achievedCount = 0;
        int inProgressCount = 0;
        int failedCount = 0;
        double sumProgress = 0.0;

        for (KpiMetric k : kpis) {
            double p = k.getProgressPct();
            sumProgress += p;
            if ("APPROVED".equalsIgnoreCase(k.getStatus()) || p >= 90.0) achievedCount++;
            else if ("OVERDUE".equalsIgnoreCase(k.getStatus()) || p < 70.0) failedCount++;
            else inProgressCount++;
        }

        double avgPerformance = totalKpi > 0 ? (sumProgress / totalKpi) : 91.4;

        request.setAttribute("totalKpi", totalKpi);
        request.setAttribute("achievedCount", achievedCount);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("failedCount", failedCount);
        request.setAttribute("avgPerformance", Math.round(avgPerformance * 10.0) / 10.0);

        // Danh sách phòng ban & nhân viên cho modal tạo KPI
        List<Department> departments = departmentDAO.findAll();
        List<Employee> employees = employeeDAO.findAll();
        request.setAttribute("departments", departments);
        request.setAttribute("employees", employees);

        request.getRequestDispatcher("/WEB-INF/views/performance/performance-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("approve_kpi".equalsIgnoreCase(action)) {
            String kpiCode = request.getParameter("kpiCode");
            if (kpiCode != null && !kpiCode.trim().isEmpty()) {
                performanceDAO.approveKpi(kpiCode.trim());
            }
            response.sendRedirect(request.getContextPath() + "/performance?success=approved");
            return;
        } else if ("create_kpi".equalsIgnoreCase(action)) {
            try {
                KpiMetric m = new KpiMetric();
                String title = request.getParameter("title");
                int empId = Integer.parseInt(request.getParameter("employeeId"));
                String deptStr = request.getParameter("departmentId");
                Integer deptId = (deptStr != null && !deptStr.isEmpty()) ? Integer.parseInt(deptStr) : null;
                String quarter = request.getParameter("quarter");
                if (quarter == null || quarter.isEmpty()) quarter = "Q3/2026";
                String targetStr = request.getParameter("targetValue");
                String currentStr = request.getParameter("currentValue");
                String unit = request.getParameter("unit");
                String weightStr = request.getParameter("weightPct");
                String deadlineStr = request.getParameter("deadline");
                String notes = request.getParameter("notes");

                m.setTitle(title);
                m.setEmployeeId(empId);
                m.setDepartmentId(deptId);
                m.setQuarter(quarter);
                if (targetStr != null && !targetStr.isEmpty()) m.setTargetValue(new BigDecimal(targetStr));
                if (currentStr != null && !currentStr.isEmpty()) m.setCurrentValue(new BigDecimal(currentStr));
                if (unit != null && !unit.isEmpty()) m.setUnit(unit);
                if (weightStr != null && !weightStr.isEmpty()) m.setWeightPct(new BigDecimal(weightStr));
                if (deadlineStr != null && !deadlineStr.isEmpty()) m.setDeadline(LocalDate.parse(deadlineStr));
                m.setNotes(notes);

                String deptCode = "GEN";
                if (deptId != null) {
                    Department d = departmentDAO.findById(deptId);
                    if (d != null && d.getCode() != null) deptCode = d.getCode();
                }
                m.setKpiCode(performanceDAO.generateNextKpiCode(deptCode));

                performanceDAO.insertKpi(m);
                response.sendRedirect(request.getContextPath() + "/performance?success=created");
                return;
            } catch (Exception ex) {
                System.err.println("Lỗi tạo KPI: " + ex.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/performance?success=true");
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
