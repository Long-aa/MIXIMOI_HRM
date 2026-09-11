package com.miximoi.hrm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản lý Cài đặt hệ thống doanh nghiệp và Cài đặt tài khoản cá nhân / bảo mật:
 * - /settings (hoặc /settings?view=system): Thiết lập hệ thống doanh nghiệp (Mockup 2)
 * - /settings?view=profile: Cài đặt tài khoản cá nhân, Giao diện & Bảo mật (Mockup 4)
 */
@WebServlet("/settings")
public class SettingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "settings");
        String view = request.getParameter("view");

        if ("profile".equalsIgnoreCase(view) || "account".equalsIgnoreCase(view)) {
            request.setAttribute("activeSubMenu", "profile");
            request.getRequestDispatcher("/WEB-INF/views/settings/settings-account.jsp")
                   .forward(request, response);
            return;
        }

        request.setAttribute("activeSubMenu", "system");
        request.getRequestDispatcher("/WEB-INF/views/settings/settings-system.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String view = request.getParameter("view");
        String redirectUrl = request.getContextPath() + "/settings";

        if ("save_system".equalsIgnoreCase(action)) {
            redirectUrl += "?view=system&success=system_saved";
        } else if ("save_profile".equalsIgnoreCase(action)) {
            redirectUrl += "?view=profile&success=profile_saved";
        } else if ("change_password".equalsIgnoreCase(action)) {
            redirectUrl += "?view=profile&success=password_changed";
        } else if (view != null) {
            redirectUrl += "?view=" + view + "&success=saved";
        } else {
            redirectUrl += "?success=saved";
        }

        response.sendRedirect(redirectUrl);
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
