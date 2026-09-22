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
        List<Payroll> allPayrolls;
        if ("EMPLOYEE".equals(user.getRole())) {
            Payroll pr = payrollDAO.findByEmployeeAndPeriod(user.getEmployeeId(), month, year);
            allPayrolls = pr != null ? new java.util.ArrayList<>(List.of(pr)) : new java.util.ArrayList<>();
        } else {
            allPayrolls = payrollDAO.findByPeriod(month, year);
            if (allPayrolls == null) allPayrolls = new java.util.ArrayList<>();
        }

        // Tính tổng lương
        java.math.BigDecimal totalPayroll = allPayrolls.stream()
                .filter(p -> p.getNetSalary() != null)
                .map(Payroll::getNetSalary)
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);

        // Phân trang 10 bản ghi/trang
        int pageSize = 10;
        int totalRecords = allPayrolls.size();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        int fromIdx = (page - 1) * pageSize;
        int toIdx   = Math.min(fromIdx + pageSize, totalRecords);
        List<Payroll> payrollList = (totalRecords > 0) ? allPayrolls.subList(fromIdx, toIdx) : allPayrolls;

        request.setAttribute("activeMenu", "payroll");
        request.setAttribute("payrollList", payrollList);
        request.setAttribute("totalPayroll", totalPayroll);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", pageSize);
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
