package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.PositionDAO;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.EmployeeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

/**
 * Servlet quản lý nhân viên.
 * URL: /employees
 *
 * GET  /employees          → danh sách nhân viên
 * GET  /employees?action=new  → form thêm mới
 * GET  /employees?action=edit&id=X → form sửa
 * GET  /employees?action=detail&id=X → chi tiết
 * POST /employees?action=add  → thêm nhân viên
 * POST /employees?action=update → cập nhật nhân viên
 * POST /employees?action=delete → vô hiệu hóa nhân viên
 */
@WebServlet("/employees")
public class EmployeeServlet extends HttpServlet {

    private final EmployeeService employeeService = new EmployeeService();
    private final DepartmentDAO   departmentDAO   = new DepartmentDAO();
    private final PositionDAO     positionDAO     = new PositionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                prepareFormData(request);
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                       .forward(request, response);
                break;
            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee emp = employeeService.getById(id);
                request.setAttribute("employee", emp);
                prepareFormData(request);
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                       .forward(request, response);
                break;
            }
            case "detail": {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("employee", employeeService.getById(id));
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-detail.jsp")
                       .forward(request, response);
                break;
            }
            default: {
                String keyword    = request.getParameter("keyword");
                String deptStr    = request.getParameter("departmentId");
                String posStr     = request.getParameter("positionId");
                String status     = request.getParameter("status");
                Integer deptId    = (deptStr != null && !deptStr.isEmpty()) ? Integer.parseInt(deptStr) : null;
                Integer posId     = (posStr != null && !posStr.isEmpty()) ? Integer.parseInt(posStr) : null;

                request.setAttribute("employees",    employeeService.search(keyword, deptId, posId, status));
                request.setAttribute("departments",  departmentDAO.findAll());
                request.setAttribute("positions",    positionDAO.findAll());
                request.setAttribute("keyword",      keyword);
                request.setAttribute("departmentId", deptId);
                request.setAttribute("positionId",   posId);
                request.setAttribute("status",       status);
                // KPI Stats
                request.setAttribute("statsTotal",    employeeService.countTotal());
                request.setAttribute("statsActive",   employeeService.countByStatus("ACTIVE"));
                request.setAttribute("statsOnLeave",  employeeService.countByStatus("ON_LEAVE"));
                request.setAttribute("statsInactive", employeeService.countByStatus("INACTIVE"));
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-list.jsp")
                       .forward(request, response);
            }
        }
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
                Employee emp = bindEmployee(request, new Employee());
                String error = employeeService.addEmployee(emp);
                if (error != null) {
                    request.setAttribute("error", error);
                    request.setAttribute("employee", emp);
                    prepareFormData(request);
                    request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                           .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/employees?success=added");
                }
                break;
            }
            case "update": {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee emp = employeeService.getById(id);
                bindEmployee(request, emp);
                String error = employeeService.updateEmployee(emp);
                if (error != null) {
                    request.setAttribute("error", error);
                    request.setAttribute("employee", emp);
                    prepareFormData(request);
                    request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                           .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/employees?success=updated");
                }
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                employeeService.deactivate(id);
                response.sendRedirect(request.getContextPath() + "/employees?success=deleted");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/employees");
        }
    }

    // ===== Helpers =====

    private boolean checkAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private void prepareFormData(HttpServletRequest request) {
        request.setAttribute("departments",    departmentDAO.findAll());
        request.setAttribute("positions",      positionDAO.findAll());
    }

    private Employee bindEmployee(HttpServletRequest req, Employee emp) {
        emp.setFullName(req.getParameter("fullName"));
        emp.setEmployeeCode(req.getParameter("employeeCode"));
        String dob = req.getParameter("dateOfBirth");
        if (dob != null && !dob.isEmpty()) emp.setDateOfBirth(LocalDate.parse(dob));
        emp.setGender(req.getParameter("gender"));
        emp.setPhone(req.getParameter("phone"));
        emp.setEmail(req.getParameter("email"));
        emp.setAddress(req.getParameter("address"));
        String deptId = req.getParameter("departmentId");
        if (deptId != null && !deptId.isEmpty()) emp.setDepartmentId(Integer.parseInt(deptId));
        String posId = req.getParameter("positionId");
        if (posId != null && !posId.isEmpty()) emp.setPositionId(Integer.parseInt(posId));
        String typeId = req.getParameter("employeeTypeId");
        if (typeId != null && !typeId.isEmpty()) emp.setEmployeeTypeId(Integer.parseInt(typeId));
        String sd = req.getParameter("startDate");
        if (sd != null && !sd.isEmpty()) emp.setStartDate(LocalDate.parse(sd));
        emp.setStatus(req.getParameter("status"));
        return emp;
    }
}
