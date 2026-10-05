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

        // Bỏ qua các tài nguyên tĩnh, trang đăng nhập và chuyển đổi role
        if (path.startsWith("/assets/") || path.startsWith("/css/") || path.startsWith("/js/")
                || path.startsWith("/images/") || path.equals("/login") || path.equals("/logout")
                || path.startsWith("/switch-role") || path.equals("/") || path.equals("/index.jsp")) {
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

        // 1. Chỉ ADMIN được vào /users, /settings và /audit-logs
        if (path.startsWith("/users") || path.startsWith("/settings") || path.startsWith("/audit-logs")) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        // Phân quyền cho Quản lý tuyển dụng
        if (path.startsWith("/recruitment")) {
            if (!"ADMIN".equals(role) && !"HR".equals(role)) {
                String viewParam = request.getParameter("view");
                String actionParam = request.getParameter("action");
                boolean isInternalAccess = "internal".equalsIgnoreCase(viewParam)
                        || "internal_apply".equalsIgnoreCase(actionParam)
                        || "refer_candidate".equalsIgnoreCase(actionParam);

                if (!isInternalAccess) {
                    // Nhân viên mọi chức danh được tự do xem tuyển dụng nội bộ & giới thiệu ứng viên
                    response.sendRedirect(request.getContextPath() + "/recruitment?view=internal");
                    return;
                }
            }
        }

        // 2. Chỉ ADMIN và HR được vào /positions, /contracts, /disciplines
        if (path.startsWith("/positions") || path.startsWith("/contracts") 
                || path.startsWith("/disciplines")) {
            if (!"ADMIN".equals(role) && !"HR".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        // 3. Quản lý hồ sơ nhân sự, phòng ban, KPI & Đánh giá hiệu suất: ADMIN, HR, MANAGER
        if (path.startsWith("/employees") || path.startsWith("/departments") || path.startsWith("/department")
                || path.startsWith("/performance") 
                || path.startsWith("/kpi") || path.startsWith("/evaluations")
                || path.startsWith("/performance-evaluations")) {
            if (!"ADMIN".equals(role) && !"HR".equals(role) && !"MANAGER".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        // 4. Tài chính, Lương, Phụ cấp, Thưởng, Khấu trừ, Lệnh chi: Chỉ ADMIN và ACCOUNTANT
        if (path.startsWith("/salary-config") || path.startsWith("/payroll")
                || path.startsWith("/allowances") || path.startsWith("/bonuses")
                || path.startsWith("/deductions") || path.startsWith("/payment")) {
            if (!"ADMIN".equals(role) && !"ACCOUNTANT".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        // 5. Nhân viên thông thường (EMPLOYEE): Chặn các quyền quản trị công ty
        if ("EMPLOYEE".equals(role)) {
            if (path.startsWith("/reports")) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
