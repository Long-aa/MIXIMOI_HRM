package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.OvertimeDAO;
import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.model.Employee;
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
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý danh sách phiếu lương nhân viên và xem chi tiết phiếu lương điện tử A4
 * URL: /payslip, /payslip?action=detail&id={payrollId}
 */
@WebServlet("/payslip")
public class PayslipServlet extends HttpServlet {

    private final PayrollDAO  payrollDAO  = new PayrollDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final ContractDAO contractDAO = new ContractDAO();
    private final OvertimeDAO overtimeDAO = new OvertimeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User user  = (User) request.getSession().getAttribute("currentUser");
        String action = request.getParameter("action");

        if ("detail".equalsIgnoreCase(action)) {
            showDetail(request, response, user);
            return;
        }

        // ===== List view =====
        LocalDate now = LocalDate.now();
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.isEmpty()) ? Integer.parseInt(mStr) : now.getMonthValue();
        int year  = (yStr != null && !yStr.isEmpty()) ? Integer.parseInt(yStr) : now.getYear();

        List<Payroll> payrollList;
        if ("EMPLOYEE".equals(user.getRole())) {
            Payroll pr = payrollDAO.findByEmployeeAndPeriod(user.getEmployeeId(), month, year);
            payrollList = pr != null ? List.of(pr) : List.of();
        } else {
            payrollList = payrollDAO.findByPeriod(month, year);
            if (payrollList == null) payrollList = List.of();
        }

        // KPI: tổng phiếu, số đã PAID, số chưa gửi
        int totalSlips  = payrollList.size();
        int countPaid   = (int) payrollList.stream().filter(p -> "PAID".equals(p.getStatus())).count();
        int countPending = (int) payrollList.stream()
                .filter(p -> "PENDING".equals(p.getStatus()) || "DRAFT".equals(p.getStatus())).count();

        request.setAttribute("activeMenu",     "payslip");
        request.setAttribute("payrollList",    payrollList);
        request.setAttribute("totalSlips",     totalSlips);
        request.setAttribute("countPaid",      countPaid);
        request.setAttribute("countPending",   countPending);
        request.setAttribute("selectedMonth",  month);
        request.setAttribute("selectedYear",   year);
        request.getRequestDispatcher("/WEB-INF/views/payroll/payslip-list.jsp")
               .forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        // Tìm payroll record: ưu tiên id, fallback về code hoặc kỳ tháng hiện tại của user
        Payroll payroll = null;
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try { payroll = payrollDAO.findById(Integer.parseInt(idStr)); } catch (Exception ignored) {}
        }
        if (payroll == null && "EMPLOYEE".equalsIgnoreCase(user.getRole())) {
            LocalDate now = LocalDate.now();
            payroll = payrollDAO.findByEmployeeAndPeriod(user.getEmployeeId(),
                    now.getMonthValue(), now.getYear());
        }

        // BẢO MẬT: Chặn nhân viên xem trộm phiếu lương của người khác qua ID
        if (payroll != null && "EMPLOYEE".equalsIgnoreCase(user.getRole())) {
            if (payroll.getEmployeeId() != user.getEmployeeId()) {
                Payroll ownPayroll = payrollDAO.findByEmployeeAndPeriod(user.getEmployeeId(),
                        payroll.getPayMonth(), payroll.getPayYear());
                if (ownPayroll != null) {
                    payroll = ownPayroll;
                } else {
                    response.sendRedirect(request.getContextPath() + "/payslip?error=access_denied");
                    return;
                }
            }
        }

        // Lấy Employee và Contract info
        Employee emp     = null;
        Contract contract = null;
        if (payroll != null) {
            emp      = employeeDAO.findById(payroll.getEmployeeId());
            contract = contractDAO.findLatestByEmployee(payroll.getEmployeeId());
        }

        // Tính toán breakdown BHXH/BHYT/BHTN từ lương cơ bản của payroll
        BigDecimal bhxh = BigDecimal.ZERO;
        BigDecimal bhyt = BigDecimal.ZERO;
        BigDecimal bhtn = BigDecimal.ZERO;
        BigDecimal grossIncome = BigDecimal.ZERO;
        if (payroll != null && payroll.getBaseSalary() != null) {
            BigDecimal base = payroll.getBaseSalary();
            bhxh = base.multiply(BigDecimal.valueOf(0.08)).setScale(0, RoundingMode.HALF_UP);
            bhyt = base.multiply(BigDecimal.valueOf(0.015)).setScale(0, RoundingMode.HALF_UP);
            bhtn = base.multiply(BigDecimal.valueOf(0.01)).setScale(0, RoundingMode.HALF_UP);
            grossIncome = base
                    .add(payroll.getOvertimeAmount() != null ? payroll.getOvertimeAmount() : BigDecimal.ZERO)
                    .add(payroll.getAllowance() != null ? payroll.getAllowance() : BigDecimal.ZERO)
                    .add(payroll.getBonus() != null ? payroll.getBonus() : BigDecimal.ZERO);
        }

        // Mã phiếu lương: dạng PL-YYYYMM-id
        String slipCode = payroll != null
                ? String.format("PL-%d%02d-%03d", payroll.getPayYear(), payroll.getPayMonth(), payroll.getId())
                : "PL-000000-000";

        request.setAttribute("activeMenu",  "payslip");
        request.setAttribute("payroll",     payroll);
        request.setAttribute("employee",    emp);
        request.setAttribute("contract",    contract);
        request.setAttribute("bhxh",        bhxh);
        request.setAttribute("bhyt",        bhyt);
        request.setAttribute("bhtn",        bhtn);
        request.setAttribute("grossIncome", grossIncome);
        request.setAttribute("slipCode",    slipCode);
        request.getRequestDispatcher("/WEB-INF/views/payroll/payslip-detail.jsp")
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
        if ("send_all".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/payslip?success=sent_all");
            return;
        } else if ("send_single".equalsIgnoreCase(action)) {
            String id = request.getParameter("id");
            response.sendRedirect(request.getContextPath()
                    + "/payslip?action=detail&id=" + (id != null ? id : "") + "&success=sent");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/payslip");
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
