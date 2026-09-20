package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý hợp đồng lao động.
 * URL: /contracts
 */
@WebServlet("/contracts")
public class ContractServlet extends HttpServlet {

    private final ContractDAO   contractDAO   = new ContractDAO();
    private final EmployeeDAO   employeeDAO   = new EmployeeDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("export".equalsIgnoreCase(action)) {
            exportContractsToCsv(request, response);
            return;
        }
        if ("view".equalsIgnoreCase(action) || "print".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr.trim());
                Contract contract = contractDAO.findById(id);
                if (contract != null) {
                    Employee emp = employeeDAO.findById(contract.getEmployeeId());
                    request.setAttribute("contract", contract);
                    request.setAttribute("employee", emp);
                    request.getRequestDispatcher("/WEB-INF/views/contract/contract-print.jsp").forward(request, response);
                    return;
                }
            }
        }

        User user = (User) request.getSession().getAttribute("currentUser");

        String keyword      = request.getParameter("keyword");
        String contractType = request.getParameter("contractType");
        String status       = request.getParameter("status");
        String deptStr      = request.getParameter("departmentId");
        Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.parseInt(deptStr.trim()) : null;

        List<Contract> contracts;
        if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
            // Employee only sees their own contracts
            int empId = user.getEmployeeId();
            contracts = contractDAO.findByEmployeeId(empId);
        } else {
            // Admin, HR, Accountant, Manager
            contracts = contractDAO.search(keyword, contractType, status, departmentId);
        }

        // Stats calculation
        int totalContracts   = contractDAO.countTotal();
        int activeCount      = contractDAO.countActive();
        int indefiniteCount  = contractDAO.countByType("INDEFINITE");
        int fixedCount       = contractDAO.countByType("FIXED_TERM");
        int expiringCount    = contractDAO.countExpiringSoon(30);

        request.setAttribute("contracts",        contracts);
        request.setAttribute("employees",        employeeDAO.findAll());
        request.setAttribute("departments",      departmentDAO.findAll());
        request.setAttribute("nextContractCode", contractDAO.getNextContractCode());

        request.setAttribute("totalContracts",   totalContracts);
        request.setAttribute("activeCount",      activeCount);
        request.setAttribute("indefiniteCount",  indefiniteCount);
        request.setAttribute("fixedCount",       fixedCount);
        request.setAttribute("expiringCount",    expiringCount);

        request.setAttribute("keyword",          keyword);
        request.setAttribute("contractType",     contractType);
        request.setAttribute("status",           status);
        request.setAttribute("departmentId",     departmentId);

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
                if (sd != null && !sd.trim().isEmpty()) c.setStartDate(LocalDate.parse(sd.trim()));
                if (ed != null && !ed.trim().isEmpty()) c.setEndDate(LocalDate.parse(ed.trim()));
                String sal = request.getParameter("baseSalary");
                if (sal != null && !sal.trim().isEmpty()) {
                    String clean = sal.replace(".", "").replace(",", "").trim();
                    c.setBaseSalary(new BigDecimal(clean));
                } else {
                    c.setBaseSalary(BigDecimal.ZERO);
                }
                c.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "ACTIVE");
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
            case "update": {
                int id = Integer.parseInt(request.getParameter("id"));
                Contract c = contractDAO.findById(id);
                if (c != null) {
                    c.setContractType(request.getParameter("contractType"));
                    String sd = request.getParameter("startDate");
                    String ed = request.getParameter("endDate");
                    if (sd != null && !sd.trim().isEmpty()) c.setStartDate(LocalDate.parse(sd.trim()));
                    if (ed != null && !ed.trim().isEmpty()) c.setEndDate(LocalDate.parse(ed.trim()));
                    else c.setEndDate(null);

                    String sal = request.getParameter("baseSalary");
                    if (sal != null && !sal.trim().isEmpty()) {
                        String clean = sal.replace(".", "").replace(",", "").trim();
                        c.setBaseSalary(new BigDecimal(clean));
                    }
                    String st = request.getParameter("status");
                    if (st != null && !st.trim().isEmpty()) c.setStatus(st.trim());
                    c.setNotes(request.getParameter("notes"));
                    contractDAO.update(c);
                }
                response.sendRedirect(request.getContextPath() + "/contracts?success=updated");
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

    private void exportContractsToCsv(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword      = request.getParameter("keyword");
        String contractType = request.getParameter("contractType");
        String status       = request.getParameter("status");
        String deptStr      = request.getParameter("departmentId");
        Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.parseInt(deptStr.trim()) : null;

        List<Contract> list = contractDAO.search(keyword, contractType, status, departmentId);

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"danh_sach_hop_dong_" + LocalDate.now() + ".csv\"");

        PrintWriter writer = response.getWriter();
        // Ghi UTF-8 BOM để Excel hiển thị đúng dấu tiếng Việt
        writer.write('\uFEFF');
        writer.println("STT,Số Hợp Đồng,Mã Nhân Viên,Họ Và Tên,Phòng Ban,Loại Hợp Đồng,Ngày Bắt Đầu,Ngày Hết Hạn,Lương Cơ Bản,Trạng Thái,Ghi Chú");

        int stt = 1;
        for (Contract c : list) {
            StringBuilder sb = new StringBuilder();
            sb.append(stt++).append(",");
            sb.append(escapeCsv(c.getContractCode())).append(",");
            sb.append(escapeCsv(c.getEmployeeCode())).append(",");
            sb.append(escapeCsv(c.getEmployeeName())).append(",");
            sb.append(escapeCsv(c.getDepartmentName() != null ? c.getDepartmentName() : "")).append(",");
            sb.append(escapeCsv(c.getContractType())).append(",");
            sb.append(c.getStartDate() != null ? c.getStartDate().toString() : "").append(",");
            sb.append(c.getEndDate() != null ? c.getEndDate().toString() : "Không thời hạn").append(",");
            sb.append(c.getBaseSalary() != null ? c.getBaseSalary().toPlainString() : "0").append(",");
            sb.append(escapeCsv(c.getStatus())).append(",");
            sb.append(escapeCsv(c.getNotes() != null ? c.getNotes() : ""));
            writer.println(sb.toString());
        }
        writer.flush();
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
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
