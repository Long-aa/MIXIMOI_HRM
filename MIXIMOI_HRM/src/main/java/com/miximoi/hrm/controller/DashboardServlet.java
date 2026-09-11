package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.LeaveDAO;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.EmployeeService;
import com.miximoi.hrm.service.PayrollService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

/**
 * Servlet hiển thị Dashboard tổng quan.
 * URL: /dashboard
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final EmployeeService employeeService = new EmployeeService();
    private final PayrollService  payrollService  = new PayrollService();
    private final LeaveDAO        leaveDAO        = new LeaveDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LocalDate today = LocalDate.now();
        int month = today.getMonthValue();
        int year  = today.getYear();

        // Thống kê tổng quan
        request.setAttribute("totalEmployees",  employeeService.countActive());
        request.setAttribute("pendingLeaves",   leaveDAO.countPending());
        request.setAttribute("totalPayroll",    payrollService.getTotalPayroll(month, year));
        request.setAttribute("currentMonth",    month);
        request.setAttribute("currentYear",     year);

        request.getRequestDispatcher("/WEB-INF/views/dashboard/dashboard.jsp")
               .forward(request, response);
    }
}
