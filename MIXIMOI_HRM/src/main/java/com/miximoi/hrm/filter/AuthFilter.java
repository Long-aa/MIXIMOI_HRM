package com.miximoi.hrm.filter;

import com.miximoi.hrm.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter bảo vệ tài nguyên và phân quyền theo Role.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = "/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());

        // Bỏ qua các tài nguyên tĩnh và trang đăng nhập
        if (path.startsWith("/assets/") || path.startsWith("/css/") || path.startsWith("/js/")
                || path.startsWith("/images/") || path.equals("/login") || path.equals("/logout")
                || path.equals("/") || path.equals("/index.jsp")) {
            chain.doFilter(req, res);
            return;
        }

        // Kiểm tra session đăng nhập
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra phân quyền truy cập theo URL
        String role = currentUser.getRole() != null ? currentUser.getRole().toUpperCase() : "EMPLOYEE";

        // Chỉ ADMIN được vào /users và /settings
        if (path.startsWith("/users") || path.startsWith("/settings")) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        // Chỉ ADMIN và HR được vào /recruitment, /positions, /contracts
        if (path.startsWith("/recruitment") || path.startsWith("/positions") || path.startsWith("/contracts")) {
            if (!"ADMIN".equals(role) && !"HR".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        // Chỉ ADMIN, HR, MANAGER được vào /employees
        if (path.startsWith("/employees")) {
            if (!"ADMIN".equals(role) && !"HR".equals(role) && !"MANAGER".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        // Chỉ ADMIN và ACCOUNTANT được vào các trang quản lý lương công ty
        if (path.startsWith("/salary-config") || path.startsWith("/payroll")
                || path.startsWith("/allowances") || path.startsWith("/bonuses")
                || path.startsWith("/deductions") || path.startsWith("/payment")) {
            if (!"ADMIN".equals(role) && !"ACCOUNTANT".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
