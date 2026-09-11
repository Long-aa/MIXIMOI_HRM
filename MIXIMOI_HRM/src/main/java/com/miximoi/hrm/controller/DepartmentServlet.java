package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.model.Department;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản lý phòng ban.
 * URL: /departments
 */
@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {

    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                request.getRequestDispatcher("/WEB-INF/views/department/department-form.jsp")
                       .forward(request, response);
                break;
            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("department", departmentDAO.findById(id));
                request.getRequestDispatcher("/WEB-INF/views/department/department-form.jsp")
                       .forward(request, response);
                break;
            }
            default:
                request.setAttribute("departments", departmentDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/department/department-list.jsp")
                       .forward(request, response);
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
                Department dept = new Department();
                dept.setName(request.getParameter("name"));
                dept.setDescription(request.getParameter("description"));
                departmentDAO.insert(dept);
                response.sendRedirect(request.getContextPath() + "/departments?success=added");
                break;
            }
            case "update": {
                Department dept = new Department();
                dept.setId(Integer.parseInt(request.getParameter("id")));
                dept.setName(request.getParameter("name"));
                dept.setDescription(request.getParameter("description"));
                departmentDAO.update(dept);
                response.sendRedirect(request.getContextPath() + "/departments?success=updated");
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                departmentDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/departments?success=deleted");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/departments");
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
