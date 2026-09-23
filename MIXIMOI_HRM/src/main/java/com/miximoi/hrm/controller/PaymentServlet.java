package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.model.User;
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
 * Servlet quản lý thanh toán &amp; lệnh chi lương.
 * URL: /payment
 */
@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private final PayrollDAO payrollDAO = new PayrollDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

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
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        User user = (User) request.getSession().getAttribute("currentUser");
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
                // Đánh dấu tất cả APPROVED → PAID
                List<Payroll> list = payrollDAO.findByPeriod(month, year);
                if (list != null) {
                    for (Payroll pr : list) {
                        if ("APPROVED".equals(pr.getStatus())) {
                            payrollDAO.updateStatus(pr.getId(), "PAID", userId);
                        }
                    }
                }
                response.sendRedirect(request.getContextPath()
                        + "/payment?month=" + month + "&year=" + year + "&success=batch_disbursed");
                return;
            }
            case "pay_single": {
                int id = Integer.parseInt(request.getParameter("id"));
                payrollDAO.updateStatus(id, "PAID", userId);
                response.sendRedirect(request.getContextPath()
                        + "/payment?month=" + month + "&year=" + year + "&success=paid");
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
