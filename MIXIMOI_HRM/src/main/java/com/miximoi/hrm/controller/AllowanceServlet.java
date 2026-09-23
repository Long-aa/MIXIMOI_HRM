package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AllowanceDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Allowance;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
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

@WebServlet("/allowances")
public class AllowanceServlet extends HttpServlet {

    private final AllowanceDAO allowanceDAO = new AllowanceDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear();

        String keyword = request.getParameter("keyword");
        String deptParam = request.getParameter("deptId");
        Integer deptId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;

        List<Allowance> allowanceList = allowanceDAO.findByPeriod(month, year, deptId, keyword);
        int totalTypes = allowanceDAO.countTypes();
        int totalBenefited = allowanceDAO.countBenefitedEmployees();
        BigDecimal totalAmount = allowanceDAO.sumTotalAmount();

        List<Department> departmentList = departmentDAO.findAll();
        List<Employee> employeeList = employeeDAO.findAll();

        request.setAttribute("activeMenu", "allowances");
        request.setAttribute("allowanceList", allowanceList);
        request.setAttribute("totalAllowanceTypes", totalTypes);
        request.setAttribute("totalBenefited", totalBenefited);
        request.setAttribute("totalAllowanceAmount", totalAmount);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);
        request.setAttribute("departments", departmentList);
        request.setAttribute("employees", employeeList);
        request.setAttribute("selectedDeptId", deptId);
        request.setAttribute("keyword", keyword);

        String success = request.getParameter("success");
        if (success != null) request.setAttribute("successMsg", success);

        request.getRequestDispatcher("/WEB-INF/views/payroll/allowances.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "add";

        try {
            if ("add".equalsIgnoreCase(action)) {
                Allowance a = new Allowance();
                a.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
                a.setName(request.getParameter("name"));
                a.setAmount(new BigDecimal(request.getParameter("amount").replaceAll("[^0-9]", "")));
                String startStr = request.getParameter("startDate");
                a.setStartDate(startStr != null && !startStr.isEmpty() ? LocalDate.parse(startStr) : LocalDate.now());
                String endStr = request.getParameter("endDate");
                if (endStr != null && !endStr.isEmpty()) a.setEndDate(LocalDate.parse(endStr));
                a.setActive(true);

                allowanceDAO.insert(a);
                response.sendRedirect(request.getContextPath() + "/allowances?success=added");
                return;
            } else if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                allowanceDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/allowances?success=deleted");
                return;
            } else if ("toggle".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                allowanceDAO.toggleActive(id);
                response.sendRedirect(request.getContextPath() + "/allowances?success=updated");
                return;
            }
        } catch (Exception e) {
            System.err.println("AllowanceServlet doPost error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/allowances");
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
