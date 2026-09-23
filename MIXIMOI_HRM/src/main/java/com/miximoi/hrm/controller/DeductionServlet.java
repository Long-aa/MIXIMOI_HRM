package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.dao.SalaryDeductionDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.model.SalaryDeduction;
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
 * Servlet quản lý các khoản khấu trừ lương: BHXH, BHYT, BHTN, thuế TNCN và tạm ứng.
 * URL: /deductions
 */
@WebServlet("/deductions")
public class DeductionServlet extends HttpServlet {

    // Tỷ lệ bảo hiểm bắt buộc
    private static final double BHXH_RATE = 0.08;
    private static final double BHYT_RATE = 0.015;
    private static final double BHTN_RATE = 0.01;

    private final SalaryDeductionDAO deductionDAO  = new SalaryDeductionDAO();
    private final PayrollDAO         payrollDAO    = new PayrollDAO();
    private final DepartmentDAO      departmentDAO = new DepartmentDAO();
    private final EmployeeDAO        employeeDAO   = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User user = (User) request.getSession().getAttribute("currentUser");
        if (!user.isAdmin() && !user.isAccountant() && !user.isHr()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        LocalDate now = LocalDate.now();
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.isEmpty()) ? Integer.parseInt(mStr) : now.getMonthValue();
        int year  = (yStr != null && !yStr.isEmpty()) ? Integer.parseInt(yStr) : now.getYear();

        String keyword   = request.getParameter("keyword");
        String deptParam = request.getParameter("deptId");
        Integer deptId   = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;

        // Danh sách khấu trừ (tạm ứng, vi phạm…)
        List<SalaryDeduction> deductionList = deductionDAO.findByPeriod(month, year, deptId, keyword);

        // Danh sách bảng lương chi tiết cho tháng (để hiển thị bảng chi tiết khấu trừ từng nhân sự)
        List<Payroll> payrolls = payrollDAO.search(month, year, deptId, null, keyword, 0, 0);

        // KPI: tính BHXH/BHYT/BHTN từ tổng lương cơ bản trong kỳ
        BigDecimal totalNetSalary = payrollDAO.sumNetSalaryByPeriod(month, year);
        // Ước tính BHXH/BHYT/BHTN: dùng tổng net salary làm proxy (đây là tổng đóng phía NLĐ)
        BigDecimal totalBhxh = totalNetSalary.multiply(BigDecimal.valueOf(BHXH_RATE)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal totalBhyt = totalNetSalary.multiply(BigDecimal.valueOf(BHYT_RATE)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal totalBhtn = totalNetSalary.multiply(BigDecimal.valueOf(BHTN_RATE)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal totalInsurance = totalBhxh.add(totalBhyt).add(totalBhtn);

        // Tổng tạm ứng từ salary_deductions
        BigDecimal totalAdvance = deductionDAO.sumAdvanceByPeriod(month, year);
        int        advanceCases = deductionDAO.countAdvanceCases(month, year);

        // Tổng tất cả khoản khấu trừ trong kỳ: ưu tiên lấy từ thực tế bảng lương nếu đã có
        BigDecimal totalPayrollDeduction = payrollDAO.sumDeductionByPeriod(month, year);
        BigDecimal totalAllDeductions;
        if (totalPayrollDeduction != null && totalPayrollDeduction.compareTo(BigDecimal.ZERO) > 0) {
            totalAllDeductions = totalPayrollDeduction;
        } else {
            totalAllDeductions = totalInsurance.add(totalAdvance);
        }

        List<Department> departments = departmentDAO.findAll();
        List<Employee>   employees   = employeeDAO.findAll();

        request.setAttribute("activeMenu",        "deductions");
        request.setAttribute("deductionList",     deductionList);
        request.setAttribute("payrolls",          payrolls);
        request.setAttribute("totalBhxh",         totalBhxh);
        request.setAttribute("totalBhyt",         totalBhyt);
        request.setAttribute("totalBhtn",         totalBhtn);
        request.setAttribute("totalInsurance",    totalInsurance);
        request.setAttribute("totalAdvance",      totalAdvance);
        request.setAttribute("advanceCases",      advanceCases);
        request.setAttribute("totalAllDeductions", totalAllDeductions);
        request.setAttribute("bhxhRate",          (int)(BHXH_RATE * 100));
        request.setAttribute("bhytRate",          (BHYT_RATE * 100));
        request.setAttribute("bhtnRate",          (int)(BHTN_RATE * 100));
        request.setAttribute("departments",       departments);
        request.setAttribute("employees",         employees);
        request.setAttribute("selectedMonth",     month);
        request.setAttribute("selectedYear",      year);
        request.setAttribute("selectedDeptId",    deptId);
        request.setAttribute("keyword",           keyword);

        String success = request.getParameter("success");
        if (success != null) request.setAttribute("successMsg", success);

        request.getRequestDispatcher("/WEB-INF/views/payroll/deductions.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User user = (User) request.getSession().getAttribute("currentUser");
        if (!user.isAdmin() && !user.isAccountant() && !user.isHr()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "add";

        LocalDate now = LocalDate.now();
        int month = now.getMonthValue(), year = now.getYear();
        try {
            String m = request.getParameter("month"), y = request.getParameter("year");
            if (m != null && !m.isEmpty()) month = Integer.parseInt(m);
            if (y != null && !y.isEmpty()) year  = Integer.parseInt(y);
        } catch (Exception ignored) {}

        try {
            if ("add".equalsIgnoreCase(action)) {
                String empIdStr = request.getParameter("employeeId");
                String dtype = request.getParameter("deductionType");
                String amtStr = request.getParameter("amount");

                if (empIdStr == null || empIdStr.isEmpty() || dtype == null || dtype.trim().isEmpty() || amtStr == null) {
                    response.sendRedirect(request.getContextPath() + "/deductions?month=" + month + "&year=" + year + "&error=missing_fields");
                    return;
                }

                BigDecimal amount = new BigDecimal(amtStr.replaceAll("[^0-9]", ""));
                if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                    response.sendRedirect(request.getContextPath() + "/deductions?month=" + month + "&year=" + year + "&error=invalid_amount");
                    return;
                }

                SalaryDeduction d = new SalaryDeduction();
                d.setEmployeeId(Integer.parseInt(empIdStr));
                d.setDeductionType(dtype.trim());
                d.setAmount(amount);
                d.setPayMonth(month);
                d.setPayYear(year);
                d.setDescription(request.getParameter("description"));
                deductionDAO.insert(d);
                response.sendRedirect(request.getContextPath()
                        + "/deductions?month=" + month + "&year=" + year + "&success=added");
            } else if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                deductionDAO.delete(id);
                response.sendRedirect(request.getContextPath()
                        + "/deductions?month=" + month + "&year=" + year + "&success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/deductions");
            }
        } catch (Exception e) {
            System.err.println("DeductionServlet doPost error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/deductions");
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
