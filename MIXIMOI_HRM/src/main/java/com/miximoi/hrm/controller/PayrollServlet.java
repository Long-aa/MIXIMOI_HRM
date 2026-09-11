package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.PayrollService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý bảng lương.
 * URL: /payroll
 */
@WebServlet("/payroll")
public class PayrollServlet extends HttpServlet {

    private final PayrollService payrollService = new PayrollService();
    private final PayrollDAO     payrollDAO     = new PayrollDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        LocalDate now = LocalDate.now();
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.isEmpty()) ? Integer.parseInt(mStr) : now.getMonthValue();
        int year = (yStr != null && !yStr.isEmpty()) ? Integer.parseInt(yStr) : now.getYear();

        User user = (User) request.getSession().getAttribute("currentUser");
        List<Payroll> payrollList;
        if ("EMPLOYEE".equals(user.getRole())) {
            Payroll pr = payrollDAO.findByEmployeeAndPeriod(user.getEmployeeId(), month, year);
            payrollList = pr != null ? List.of(pr) : List.of();
        } else {
            payrollList = payrollDAO.findByPeriod(month, year);
        }

        request.setAttribute("activeMenu", "payroll");
        request.setAttribute("payrollList", payrollList);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);
        request.getRequestDispatcher("/WEB-INF/views/payroll/payroll-list.jsp")
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
        int userId = user.getId();

        switch (action) {
            case "calculate": {
                int month = Integer.parseInt(request.getParameter("month"));
                int year = Integer.parseInt(request.getParameter("year"));
                payrollService.calculatePayrollForPeriod(month, year, userId);
                response.sendRedirect(request.getContextPath() + "/payroll?month=" + month + "&year=" + year + "&success=calculated");
                break;
            }
            case "approve": {
                int id = Integer.parseInt(request.getParameter("id"));
                payrollDAO.updateStatus(id, "APPROVED", userId);
                response.sendRedirect(request.getContextPath() + "/payroll?success=approved");
                break;
            }
            case "pay": {
                int id = Integer.parseInt(request.getParameter("id"));
                payrollDAO.updateStatus(id, "PAID", userId);
                response.sendRedirect(request.getContextPath() + "/payroll?success=paid");
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/payroll");
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
}
