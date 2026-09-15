package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Contract;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Servlet quản lý hợp đồng lao động.
 * URL: /contracts
 */
@WebServlet("/contracts")
public class ContractServlet extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("contracts", contractDAO.findAll());
        request.setAttribute("employees", employeeDAO.findAll());
        request.setAttribute("expiringCount", contractDAO.findExpiringSoon(30).size());

        request.getRequestDispatcher("/WEB-INF/views/contract/contract-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add": {
                Contract c = new Contract();
                c.setContractCode(request.getParameter("contractCode"));
                c.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
                c.setContractType(request.getParameter("contractType"));
                String sd = request.getParameter("startDate");
                String ed = request.getParameter("endDate");
                if (sd != null && !sd.isEmpty()) c.setStartDate(LocalDate.parse(sd));
                if (ed != null && !ed.isEmpty()) c.setEndDate(LocalDate.parse(ed));
                String sal = request.getParameter("baseSalary");
                if (sal != null && !sal.isEmpty()) c.setBaseSalary(new BigDecimal(sal));
                c.setStatus(request.getParameter("status"));
                c.setNotes(request.getParameter("notes"));
                contractDAO.insert(c);
                String from = request.getParameter("from");
                if ("employeeDetail".equals(from)) {
                    response.sendRedirect(request.getContextPath() + "/employees?action=detail&id=" + c.getEmployeeId() + "&success=contract_added#tabContract");
                } else {
                    response.sendRedirect(request.getContextPath() + "/contracts?success=added");
                }
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                contractDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/contracts?success=deleted");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/contracts");
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
