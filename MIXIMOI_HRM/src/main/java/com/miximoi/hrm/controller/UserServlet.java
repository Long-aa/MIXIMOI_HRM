package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.UserDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet quản lý Tài khoản người dùng & Phân quyền theo vai trò (RBAC v3.5).
 * URL: /users
 */
@WebServlet("/users")
public class UserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "users");

        String keyword = request.getParameter("keyword");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        Integer deptId = null;
        try {
            String deptParam = request.getParameter("dept");
            if (deptParam != null && !deptParam.trim().isEmpty()) {
                deptId = Integer.parseInt(deptParam.trim());
            }
        } catch (NumberFormatException ignored) {}

        List<User> users = userDAO.findAllFiltered(keyword, role, deptId, status);
        request.setAttribute("users", users);

        int totalUsers = users.size();
        int activeUsers = 0;
        int lockedUsers = 0;
        for (User u : users) {
            if (u.isActive()) activeUsers++;
            else lockedUsers++;
        }

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("lockedUsers", lockedUsers);

        List<Department> departments = departmentDAO.findAll();
        List<Employee> employees = employeeDAO.findAll();
        request.setAttribute("departments", departments);
        request.setAttribute("employees", employees);

        request.getRequestDispatcher("/WEB-INF/views/user/user-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("create".equalsIgnoreCase(action)) {
            try {
                String username = request.getParameter("username");
                String role = request.getParameter("role");
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                String email = request.getParameter("email");

                if (username != null && !username.trim().isEmpty()) {
                    User u = new User();
                    u.setUsername(username.trim().toLowerCase());
                    u.setPassword(PasswordUtil.hash("miximoi@2026")); // Mật khẩu khởi tạo mặc định
                    u.setRole(role != null ? role.toUpperCase() : "EMPLOYEE");
                    u.setEmployeeId(employeeId);
                    u.setActive(true);
                    userDAO.insert(u);
                }
                response.sendRedirect(request.getContextPath() + "/users?success=created");
                return;
            } catch (Exception e) {
                System.err.println("Lỗi tạo user: " + e.getMessage());
            }
        } else if ("toggle_status".equalsIgnoreCase(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                userDAO.toggleStatus(userId);
                response.sendRedirect(request.getContextPath() + "/users?success=status_updated");
                return;
            } catch (Exception ignored) {}
        } else if ("resend_invite".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/users?success=invite_sent");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/users?success=true");
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
