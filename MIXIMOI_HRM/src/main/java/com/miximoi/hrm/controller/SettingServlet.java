package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.SystemSettingDAO;
import com.miximoi.hrm.dao.UserDAO;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet quản lý Cài đặt hệ thống doanh nghiệp và Cài đặt tài khoản cá nhân / bảo mật:
 * - /settings (hoặc /settings?view=system): Thiết lập hệ thống doanh nghiệp (Mockup 2)
 * - /settings?view=profile: Cài đặt tài khoản cá nhân, Giao diện & Bảo mật (Mockup 4)
 */
@WebServlet("/settings")
public class SettingServlet extends HttpServlet {

    private final SystemSettingDAO settingDAO = new SystemSettingDAO();
    private final AuthService authService = new AuthService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "settings");
        String view = request.getParameter("view");

        Map<String, String> settings = settingDAO.getAllSettings();
        request.setAttribute("settings", settings);

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

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String action = request.getParameter("action");
        String view = request.getParameter("view");
        String redirectUrl = request.getContextPath() + "/settings";

        if ("save_system".equalsIgnoreCase(action)) {
            Map<String, String> newSettings = new HashMap<>();
            Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                if (!"action".equals(paramName) && !"view".equals(paramName)) {
                    newSettings.put(paramName, request.getParameter(paramName));
                }
            }
            settingDAO.saveAll(newSettings);
            // Đồng bộ tức thì vào applicationScope để toàn hệ thống (sidebar, topbar, báo cáo) thay đổi ngay lập tức
            getServletContext().setAttribute("systemSettings", settingDAO.getAllSettings());
            redirectUrl += "?view=system&success=system_saved";
        } else if ("save_profile".equalsIgnoreCase(action)) {
            if (currentUser != null) {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                if (fullName != null && !fullName.trim().isEmpty()) {
                    currentUser.setFullName(fullName.trim());
                }
                if (email != null && !email.trim().isEmpty()) {
                    currentUser.setEmail(email.trim());
                }
                // Lưu vào CSDL
                userDAO.updateUserProfile(currentUser.getId(), currentUser.getEmployeeId(), currentUser.getFullName(), currentUser.getEmail(), phone);
                // Cập nhật lại session
                session.setAttribute("currentUser", currentUser);
            }
            redirectUrl += "?view=profile&success=profile_saved";
        } else if ("save_theme".equalsIgnoreCase(action)) {
            String theme = request.getParameter("theme");
            if (theme != null && !theme.trim().isEmpty()) {
                session.setAttribute("appTheme", theme.trim());
            }
            redirectUrl += "?view=profile&success=theme_saved";
        } else if ("change_password".equalsIgnoreCase(action)) {
            String oldPass = request.getParameter("oldPassword");
            String newPass = request.getParameter("newPassword");
            String confirmPass = request.getParameter("confirmPassword");

            if (currentUser != null && newPass != null && newPass.equals(confirmPass)) {
                boolean ok = authService.changePassword(currentUser.getId(), oldPass, newPass);
                if (ok) {
                    redirectUrl += "?view=profile&success=password_changed";
                } else {
                    redirectUrl += "?view=profile&error=wrong_password";
                }
            } else {
                redirectUrl += "?view=profile&error=password_mismatch";
            }
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
