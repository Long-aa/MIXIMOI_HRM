package com.miximoi.hrm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản lý Tài khoản người dùng & Phân quyền theo vai trò (RBAC v3.5).
 * URL: /users
 */
@WebServlet("/users")
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "users");
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
            response.sendRedirect(request.getContextPath() + "/users?success=created");
            return;
        } else if ("toggle_status".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/users?success=status_updated");
            return;
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
