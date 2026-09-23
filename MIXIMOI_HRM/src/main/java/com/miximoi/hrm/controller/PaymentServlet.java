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
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý thanh toán & lệnh chi lương.
 * URL: /payment
 */
@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private final PayrollDAO     payrollDAO     = new PayrollDAO();
    private final PayrollService payrollService = new PayrollService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User user = (User) request.getSession().getAttribute("currentUser");
        if (!user.isAdmin() && !user.isAccountant()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        LocalDate now = LocalDate.now();
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.isEmpty()) ? Integer.parseInt(mStr) : now.getMonthValue();
        int year  = (yStr != null && !yStr.isEmpty()) ? Integer.parseInt(yStr) : now.getYear();

        // Chỉ lấy payroll đã APPROVED hoặc PAID để thanh toán
        List<Payroll> allPayrolls = payrollDAO.findByPeriod(month, year);
        if (allPayrolls == null) allPayrolls = List.of();

        // KPI cho trang thanh toán
        BigDecimal totalPayroll  = payrollDAO.sumNetSalaryByPeriod(month, year);
        int        countApproved = payrollDAO.countByStatus(month, year, "APPROVED");
        int        countPaid     = payrollDAO.countByStatus(month, year, "PAID");
        int        countPending  = payrollDAO.countByStatus(month, year, "PENDING");
        int        countDraft    = payrollDAO.countByStatus(month, year, "DRAFT");
        int        totalCount    = allPayrolls.size();

        // Tổng số tiền cần chi trả (các bản APPROVED chưa PAID)
        BigDecimal totalDisbursed = allPayrolls.stream()
                .filter(p -> "APPROVED".equals(p.getStatus()) || "PAID".equals(p.getStatus()))
                .filter(p -> p.getNetSalary() != null)
                .map(Payroll::getNetSalary)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        request.setAttribute("activeMenu",      "payment");
        request.setAttribute("payrollList",     allPayrolls);
        request.setAttribute("totalPayroll",    totalPayroll);
        request.setAttribute("totalDisbursed",  totalDisbursed);
        request.setAttribute("countApproved",   countApproved);
        request.setAttribute("countPaid",       countPaid);
        request.setAttribute("countPending",    countPending);
        request.setAttribute("countDraft",      countDraft);
        request.setAttribute("totalCount",      totalCount);
        request.setAttribute("selectedMonth",   month);
        request.setAttribute("selectedYear",    year);
        request.getRequestDispatcher("/WEB-INF/views/payroll/payment.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User user = (User) request.getSession().getAttribute("currentUser");
        if (!user.isAdmin() && !user.isAccountant()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        int userId = user.getId();

        LocalDate now = LocalDate.now();
        int month = now.getMonthValue(), year = now.getYear();
        try {
            String m = request.getParameter("month"), y = request.getParameter("year");
            if (m != null && !m.isEmpty()) month = Integer.parseInt(m);
            if (y != null && !y.isEmpty()) year  = Integer.parseInt(y);
        } catch (Exception ignored) {}

        switch (action) {
            case "batch_disburse": {
                int count = payrollService.batchDisburse(month, year, userId);
                response.sendRedirect(request.getContextPath()
                        + "/payment?month=" + month + "&year=" + year + "&success=batch_disbursed&count=" + count);
                return;
            }
            case "pay_single": {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = payrollService.payPayrollSingle(id, userId, "BANK_TRANSFER", null);
                if (ok) {
                    response.sendRedirect(request.getContextPath()
                            + "/payment?month=" + month + "&year=" + year + "&success=paid");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/payment?month=" + month + "&year=" + year + "&error=pay_failed");
                }
                return;
            }
            default:
                response.sendRedirect(request.getContextPath()
                        + "/payment?month=" + month + "&year=" + year);
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
