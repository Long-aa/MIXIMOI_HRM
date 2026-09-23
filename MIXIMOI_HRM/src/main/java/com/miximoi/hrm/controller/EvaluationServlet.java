package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.PerformanceDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.PerformanceEvaluation;
import com.miximoi.hrm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet quản lý Đánh giá hiệu suất nhân sự chu kỳ Q3/2026:
 * URL: /evaluations, /performance-evaluations
 */
@WebServlet({"/evaluations", "/performance-evaluations"})
public class EvaluationServlet extends HttpServlet {

    private final PerformanceDAO performanceDAO = new PerformanceDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "evaluations");

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
        String search = request.getParameter("search");

        List<PerformanceEvaluation> evaluations = performanceDAO.findEvaluations(quarter, deptId, status, search);
        request.setAttribute("evaluations", evaluations);

        // Thống kê nhanh
        int totalEmployees = evaluations.size();
        int completedCount = 0;
        int pendingCount = 0;
        double sumScore = 0.0;

        for (PerformanceEvaluation ev : evaluations) {
            if (ev.getFinalScore() != null) sumScore += ev.getFinalScore().doubleValue();
            if ("CONFIRMED".equalsIgnoreCase(ev.getStatus())) completedCount++;
            else pendingCount++;
        }

        double avgScore = totalEmployees > 0 ? (sumScore / totalEmployees) : 8.6;

        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("avgScore", Math.round(avgScore * 10.0) / 10.0);

        List<Department> departments = departmentDAO.findAll();
        List<Employee> employees = employeeDAO.findAll();
        request.setAttribute("departments", departments);
        request.setAttribute("employees", employees);

        request.getRequestDispatcher("/WEB-INF/views/performance/performance-evaluations.jsp")
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
        String evalCode = request.getParameter("evalCode");

        if ("auto_calculate".equalsIgnoreCase(action)) {
            String quarter = request.getParameter("quarter");
            if (quarter == null || quarter.isEmpty()) quarter = "Q3/2026";
            Integer evaluatorId = (currentUser != null && currentUser.getEmployeeId() > 0) ? currentUser.getEmployeeId() : 1;
            int count = performanceDAO.autoCalculateAndSyncEvaluations(quarter, evaluatorId);
            response.sendRedirect(request.getContextPath() + "/evaluations?quarter=" + java.net.URLEncoder.encode(quarter, "UTF-8") + "&success=auto_calculated&count=" + count);
            return;
        }

        if ("confirm".equalsIgnoreCase(action) || "submit".equalsIgnoreCase(action) || "draft".equalsIgnoreCase(action)) {
            try {
                String empIdStr = request.getParameter("employeeId");
                int empId = (empIdStr != null && !empIdStr.isEmpty()) ? Integer.parseInt(empIdStr) : 4;
                String quarter = request.getParameter("quarter");
                if (quarter == null || quarter.isEmpty()) quarter = "Q3/2026";

                PerformanceEvaluation ev = new PerformanceEvaluation();
                ev.setEvaluationCode(evalCode != null && !evalCode.isEmpty() ? evalCode : "EVAL-Q3-" + String.format("%03d", empId));
                ev.setEmployeeId(empId);
                if (currentUser != null && currentUser.getEmployeeId() > 0) {
                    ev.setEvaluatorId(currentUser.getEmployeeId());
                } else {
                    ev.setEvaluatorId(1);
                }
                ev.setQuarter(quarter);

                String kpiStr = request.getParameter("kpiScore");
                String compStr = request.getParameter("competencyScore");
                String cultStr = request.getParameter("cultureScore");
                String innoStr = request.getParameter("innovationScore");
                String feedback = request.getParameter("feedback");

                ev.setKpiScore(kpiStr != null && !kpiStr.isEmpty() ? new BigDecimal(kpiStr) : new BigDecimal("9.4"));
                ev.setCompetencyScore(compStr != null && !compStr.isEmpty() ? new BigDecimal(compStr) : new BigDecimal("8.8"));
                ev.setCultureScore(cultStr != null && !cultStr.isEmpty() ? new BigDecimal(cultStr) : new BigDecimal("9.0"));
                ev.setInnovationScore(innoStr != null && !innoStr.isEmpty() ? new BigDecimal(innoStr) : new BigDecimal("7.6"));
                ev.setFeedback(feedback != null ? feedback : "Hoàn thành tốt nhiệm vụ chu kỳ");

                if ("confirm".equalsIgnoreCase(action)) {
                    ev.setStatus("CONFIRMED");
                } else if ("submit".equalsIgnoreCase(action)) {
                    ev.setStatus("SUBMITTED");
                } else {
                    ev.setStatus("DRAFT");
                }

                performanceDAO.saveEvaluation(ev);
                response.sendRedirect(request.getContextPath() + "/evaluations?success=" + action);
                return;
            } catch (Exception ex) {
                System.err.println("Lỗi lưu thẩm định: " + ex.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/evaluations?success=true");
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
