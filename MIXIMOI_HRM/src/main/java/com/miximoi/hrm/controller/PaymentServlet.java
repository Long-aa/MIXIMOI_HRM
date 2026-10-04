package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AuditLogDAO;
import com.miximoi.hrm.dao.PaymentDAO;
import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.model.Payment;
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
import java.io.PrintWriter;
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
    private final PaymentDAO     paymentDAO     = new PaymentDAO();
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

        String bankCode = request.getParameter("bank");
        if ("export_unc".equalsIgnoreCase(request.getParameter("action")) || "export_bank".equalsIgnoreCase(request.getParameter("action"))) {
            exportBankSchedule(response, allPayrolls, month, year, bankCode);
            return;
        }

        // Lấy lịch sử giao dịch đã thanh toán
        List<Payment> paymentHistory = paymentDAO.findByPeriod(month, year);
        if (paymentHistory == null) paymentHistory = List.of();

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
        request.setAttribute("paymentHistory",  paymentHistory);
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
        } catch (NumberFormatException ignored) {}

        switch (action) {
            case "batch_disburse" -> {
                String paymentMethod = request.getParameter("paymentMethod");
                if (paymentMethod == null || paymentMethod.isEmpty()) paymentMethod = "BANK_TRANSFER";
                int count = payrollService.batchDisburse(month, year, userId, paymentMethod);
                AuditLogDAO.logAction(request, "DISBURSE_BATCH", "PAYMENT", null, 
                        "Giải ngân hàng loạt kỳ " + month + "/" + year + ": " + count + " nhân viên, hình thức: " + paymentMethod);
                response.sendRedirect(request.getContextPath()
                        + "/payment?month=" + month + "&year=" + year + "&success=batch_disbursed&count=" + count);
            }
            case "pay_single" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                String paymentMethod = request.getParameter("paymentMethod");
                if (paymentMethod == null || paymentMethod.isEmpty()) paymentMethod = "BANK_TRANSFER";
                String notes = request.getParameter("notes");
                boolean ok = payrollService.payPayrollSingle(id, userId, paymentMethod, notes);
                if (ok) {
                    AuditLogDAO.logAction(request, "DISBURSE_SINGLE", "PAYMENT", id, 
                            "Thanh toán phiếu lương ID " + id + " hình thức: " + paymentMethod + (notes != null && !notes.isEmpty() ? " (" + notes + ")" : ""));
                    response.sendRedirect(request.getContextPath()
                            + "/payment?month=" + month + "&year=" + year + "&success=paid");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/payment?month=" + month + "&year=" + year + "&error=pay_failed");
                }
            }
            default -> response.sendRedirect(request.getContextPath()
                    + "/payment?month=" + month + "&year=" + year);
        }
    }

    private void exportBankSchedule(HttpServletResponse response, List<Payroll> payrollList, int month, int year, String bankCode)
            throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String prefix = (bankCode != null && !bankCode.isEmpty()) ? bankCode.toUpperCase() : "BATCH";
        String fileName = "lenh_chi_" + prefix + "_T" + String.format("%02d", month) + "_" + year + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        PrintWriter writer = response.getWriter();
        writer.write('\uFEFF'); // UTF-8 BOM

        // Header CSV chuẩn ngân hàng: Số tài khoản nhận, Tên người thụ hưởng, Mã ngân hàng, Số tiền thực lĩnh, Nội dung chi lương
        writer.write("STT,Số tài khoản nhận,Tên người thụ hưởng,Mã ngân hàng,Số tiền thực lĩnh,Nội dung chi lương\n");

        int stt = 1;
        for (Payroll p : payrollList) {
            String stk = (p.getBankAccount() != null && !p.getBankAccount().isEmpty()) ? p.getBankAccount() : ("10" + String.format("%08d", p.getEmployeeId()));
            String name = (p.getEmployeeName() != null) ? p.getEmployeeName().toUpperCase() : "NHAN VIEN";
            String bCode = (bankCode != null && !bankCode.isEmpty()) ? bankCode.toUpperCase() : (p.getBankName() != null && !p.getBankName().isEmpty() ? p.getBankName().toUpperCase() : "VCB");
            String net = (p.getNetSalary() != null) ? p.getNetSalary().setScale(0, java.math.RoundingMode.HALF_UP).toPlainString() : "0";
            String content = "MIXIMOI CHI LUONG T" + String.format("%02d", month) + "/" + year + " " + p.getEmployeeCode();
            writer.println(String.format("%d,\"%s\",\"%s\",\"%s\",%s,\"%s\"", stt++, escapeCsv(stk), escapeCsv(name), escapeCsv(bCode), net, escapeCsv(content)));
        }
        writer.flush();
    }

    private String escapeCsv(String val) {
        if (val == null) return "";
        if (val.contains(",") || val.contains("\"") || val.contains("\n")) {
            return "\"" + val.replace("\"", "\"\"") + "\"";
        }
        return val;
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
