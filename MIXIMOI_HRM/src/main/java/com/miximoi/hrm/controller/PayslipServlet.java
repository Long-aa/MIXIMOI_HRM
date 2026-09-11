package com.miximoi.hrm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản lý danh sách phiếu lương nhân viên và xem chi tiết phiếu lương điện tử A4
 * URL: /payslip, /payslip?action=detail
 */
@WebServlet("/payslip")
public class PayslipServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        String action = request.getParameter("action");
        if ("detail".equalsIgnoreCase(action)) {
            request.setAttribute("activeMenu", "payslip");
            request.setAttribute("empCode", request.getParameter("code") != null ? request.getParameter("code") : "NV001");
            request.getRequestDispatcher("/WEB-INF/views/payroll/payslip-detail.jsp")
                   .forward(request, response);
            return;
        }

        request.setAttribute("activeMenu", "payslip");
        request.getRequestDispatcher("/WEB-INF/views/payroll/payslip-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("send_all".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/payslip?success=sent_all");
            return;
        } else if ("send_single".equalsIgnoreCase(action)) {
            String code = request.getParameter("code");
            response.sendRedirect(request.getContextPath() + "/payslip?action=detail&code=" + (code != null ? code : "NV001") + "&success=sent");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/payslip?success=true");
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
