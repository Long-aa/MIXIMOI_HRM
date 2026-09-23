package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.BonusDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Bonus;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
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
import java.util.Map;

/**
 * Servlet quản lý chính sách khen thưởng & thưởng hiệu suất KPI.
 * URL: /bonuses
 */
@WebServlet({"/bonuses", "/rewards"})
public class BonusServlet extends HttpServlet {

    private final BonusDAO      bonusDAO      = new BonusDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final EmployeeDAO   employeeDAO   = new EmployeeDAO();

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
        int year  = now.getYear();
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.isEmpty()) ? Integer.parseInt(mStr) : now.getMonthValue();
        if (yStr != null && !yStr.isEmpty()) year = Integer.parseInt(yStr);

        String keyword = request.getParameter("keyword");
        String deptParam = request.getParameter("deptId");
        Integer deptId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;

        // Dữ liệu bảng danh sách
        List<Bonus> bonusList = bonusDAO.findByPeriod(month, year, deptId, keyword);

        // KPI Stats
        BigDecimal totalBonusYear    = bonusDAO.sumTotalYear(year);
        BigDecimal totalBonusMonth   = bonusDAO.sumTotalByPeriod(month, year);
        int        bonusEmpCount     = bonusDAO.countBonusEmployees(month, year);

        // Phân bổ theo phòng ban cho Chart.js
        Map<String, BigDecimal> deptDistribution = bonusDAO.getBonusDistributionByDepartment(month, year);

        List<Department> departments = departmentDAO.findAll();
        List<Employee>   employees   = employeeDAO.findAll();

        request.setAttribute("activeMenu",        "bonuses");
        request.setAttribute("bonusList",         bonusList);
        request.setAttribute("totalBonusYear",    totalBonusYear);
        request.setAttribute("totalBonusMonth",   totalBonusMonth);
        request.setAttribute("bonusEmpCount",     bonusEmpCount);
        request.setAttribute("deptDistribution",  deptDistribution);
        request.setAttribute("departments",       departments);
        request.setAttribute("employees",         employees);
        request.setAttribute("selectedMonth",     month);
        request.setAttribute("selectedYear",      year);
        request.setAttribute("selectedDeptId",    deptId);
        request.setAttribute("keyword",           keyword);

        String success = request.getParameter("success");
        if (success != null) request.setAttribute("successMsg", success);

        request.getRequestDispatcher("/WEB-INF/views/payroll/bonuses.jsp")
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
                String name = request.getParameter("name");
                String amtStr = request.getParameter("amount");

                if (empIdStr == null || empIdStr.isEmpty() || name == null || name.trim().isEmpty() || amtStr == null) {
                    response.sendRedirect(request.getContextPath() + "/bonuses?month=" + month + "&year=" + year + "&error=missing_fields");
                    return;
                }

                BigDecimal amount = new BigDecimal(amtStr.replaceAll("[^0-9]", ""));
                if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                    response.sendRedirect(request.getContextPath() + "/bonuses?month=" + month + "&year=" + year + "&error=invalid_amount");
                    return;
                }

                Bonus b = new Bonus();
                b.setEmployeeId(Integer.parseInt(empIdStr));
                b.setName(name.trim());
                b.setAmount(amount);
                String dateStr = request.getParameter("bonusDate");
                b.setBonusDate(dateStr != null && !dateStr.isEmpty() ? LocalDate.parse(dateStr) : LocalDate.now());
                b.setPayMonth(month);
                b.setPayYear(year);
                b.setNotes(request.getParameter("notes"));
                bonusDAO.insert(b);
                response.sendRedirect(request.getContextPath()
                        + "/bonuses?month=" + month + "&year=" + year + "&success=added");
            } else if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                bonusDAO.delete(id);
                response.sendRedirect(request.getContextPath()
                        + "/bonuses?month=" + month + "&year=" + year + "&success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/bonuses");
            }
        } catch (Exception e) {
            System.err.println("BonusServlet doPost error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/bonuses");
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
