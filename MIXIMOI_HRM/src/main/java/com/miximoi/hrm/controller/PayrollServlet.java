package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.model.Department;
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
import java.math.RoundingMode;
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
    private final DepartmentDAO  departmentDAO  = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User user = (User) request.getSession().getAttribute("currentUser");
        if (user.isEmployee()) {
            response.sendRedirect(request.getContextPath() + "/payslip");
            return;
        }
        if (!user.isAdmin() && !user.isAccountant()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        LocalDate now = LocalDate.now();
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.isEmpty()) ? Integer.parseInt(mStr) : now.getMonthValue();
        int year  = (yStr != null && !yStr.isEmpty()) ? Integer.parseInt(yStr) : now.getYear();

        String keyword = request.getParameter("keyword");
        String deptParam = request.getParameter("deptId");
        Integer deptId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
        String status = request.getParameter("status");

        // Lấy danh sách bảng lương theo bộ lọc
        List<Payroll> allPayrolls = payrollDAO.search(month, year, deptId, status, keyword, 0, 0);
        if (allPayrolls == null) allPayrolls = new java.util.ArrayList<>();

        // ===== KPI Stats =====
        BigDecimal totalPayroll  = payrollDAO.sumNetSalaryByPeriod(month, year);
        BigDecimal avgSalary     = payrollDAO.avgNetSalaryByPeriod(month, year)
                                             .setScale(0, RoundingMode.HALF_UP);
        int        totalEmpCount = payrollDAO.countEmployeesByPeriod(month, year);
        int        countPaid     = payrollDAO.countByStatus(month, year, "PAID");
        int        countApproved = payrollDAO.countByStatus(month, year, "APPROVED");
        int        countPending  = payrollDAO.countByStatus(month, year, "PENDING");
        int        countDraft    = payrollDAO.countByStatus(month, year, "DRAFT");

        // Tỉ lệ hoàn thành chi trả
        double paidRatio    = totalEmpCount > 0 ? (double) countPaid / totalEmpCount * 100.0 : 0;
        int    pendingCount = countPending + countDraft;

        // Phân trang 15 bản ghi/trang
        int pageSize    = 15;
        int totalRecords = allPayrolls.size();
        int totalPages  = (int) Math.ceil((double) totalRecords / pageSize);

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        int fromIdx = (page - 1) * pageSize;
        int toIdx   = Math.min(fromIdx + pageSize, totalRecords);
        List<Payroll> payrollList = (totalRecords > 0) ? allPayrolls.subList(fromIdx, toIdx) : allPayrolls;

        List<Department> departments = departmentDAO.findAll();

        // ===== Attributes =====
        request.setAttribute("activeMenu",      "payroll");
        request.setAttribute("payrollList",     payrollList);
        request.setAttribute("totalPayroll",    totalPayroll);
        request.setAttribute("avgSalary",       avgSalary);
        request.setAttribute("totalEmpCount",   totalEmpCount);
        request.setAttribute("countPaid",       countPaid);
        request.setAttribute("countApproved",   countApproved);
        request.setAttribute("countPending",    countPending);
        request.setAttribute("pendingCount",    pendingCount);
        request.setAttribute("paidRatio",       String.format("%.1f", paidRatio));
        request.setAttribute("selectedMonth",   month);
        request.setAttribute("selectedYear",    year);
        request.setAttribute("currentPage",     page);
        request.setAttribute("totalPages",      totalPages);
        request.setAttribute("totalRecords",    totalRecords);
        request.setAttribute("pageSize",        pageSize);
        request.setAttribute("departments",     departments);
        request.setAttribute("keyword",         keyword);
        request.setAttribute("selectedDeptId",  deptId);
        request.setAttribute("selectedStatus",  status);

        String success = request.getParameter("success");
        if (success != null) request.setAttribute("successMsg", success);

        request.getRequestDispatcher("/WEB-INF/views/payroll/payroll-list.jsp")
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
        int month = now.getMonthValue();
        int year  = now.getYear();
        try {
            String mStr = request.getParameter("month");
            String yStr = request.getParameter("year");
            if (mStr != null && !mStr.isEmpty()) month = Integer.parseInt(mStr);
            if (yStr != null && !yStr.isEmpty()) year  = Integer.parseInt(yStr);
        } catch (Exception ignored) {}

        switch (action) {
            case "calculate": {
                payrollService.calculatePayrollForPeriod(month, year, userId);
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=calculated");
                break;
            }
            case "approve": {
                int id = Integer.parseInt(request.getParameter("id"));
                payrollService.approve(id, userId);
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=approved");
                break;
            }
            case "approve_all": {
                payrollService.approveAll(month, year, userId);
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=approved_all");
                break;
            }
            case "pay": {
                int id = Integer.parseInt(request.getParameter("id"));
                payrollService.payPayrollSingle(id, userId, "BANK_TRANSFER", null);
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=paid");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year);
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
