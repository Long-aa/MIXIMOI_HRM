package com.miximoi.hrm.controller;

import com.miximoi.hrm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet cho phép chuyển đổi vai trò nhanh để kiểm thử và trải nghiệm UI theo từng role:
 * 1. ADMIN: Quản trị toàn bộ hệ thống
 * 2. HR: Quản lý nhân sự, hợp đồng, chấm công, nghỉ phép
 * 3. ACCOUNTANT: Quản lý bảng lương, tính lương, thanh toán
 * 4. MANAGER: Theo dõi nhân sự và phê duyệt nghiệp vụ
 * 5. EMPLOYEE: Xem thông tin cá nhân, chấm công, nghỉ phép, phiếu lương
 */
@WebServlet("/switch-role")
public class SwitchRoleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String roleParam = request.getParameter("role");
        String redirect = request.getParameter("redirect");

        if (roleParam == null || roleParam.trim().isEmpty()) {
            roleParam = "ADMIN";
        }
        roleParam = roleParam.trim().toUpperCase();

        User user = new User();
        switch (roleParam) {
            case "HR":
                user.setId(2);
                user.setUsername("hr_mai");
                user.setFullName("Trần Ngọc Mai");
                user.setEmail("mai.tn@miximoi.vn");
                user.setRole("HR");
                user.setEmployeeId(2);
                user.setActive(true);
                break;

            case "ACCOUNTANT":
                user.setId(3);
                user.setUsername("ketoan_nga");
                user.setFullName("Phạm Thanh Nga");
                user.setEmail("nga.pt@miximoi.vn");
                user.setRole("ACCOUNTANT");
                user.setEmployeeId(3);
                user.setActive(true);
                break;

            case "MANAGER":
                user.setId(4);
                user.setUsername("tp_tuan");
                user.setFullName("Hoàng Minh Tuấn");
                user.setEmail("tuan.hm@miximoi.vn");
                user.setRole("MANAGER");
                user.setEmployeeId(4);
                user.setActive(true);
                break;

            case "EMPLOYEE":
                user.setId(5);
                user.setUsername("nv_hoang");
                user.setFullName("Lê Văn Hoàng");
                user.setEmail("hoang.lv@miximoi.vn");
                user.setRole("EMPLOYEE");
                user.setEmployeeId(5);
                user.setActive(true);
                break;

            case "ADMIN":
            default:
                user.setId(1);
                user.setUsername("admin");
                user.setFullName("Nguyễn Văn Admin");
                user.setEmail("admin@miximoi.vn");
                user.setRole("ADMIN");
                user.setEmployeeId(1);
                user.setActive(true);
                break;
        }

        session.setAttribute("currentUser", user);

        if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("login") && !redirect.contains("logout")) {
            response.sendRedirect(redirect);
        } else {
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.contains("login") && !referer.contains("logout")) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/leave");
            }
        }
    }
}
