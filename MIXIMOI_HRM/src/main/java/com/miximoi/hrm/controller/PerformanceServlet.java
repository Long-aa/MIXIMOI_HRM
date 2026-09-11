package com.miximoi.hrm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản lý KPI & Đánh giá hiệu suất toàn diện:
 * URL: /performance, /kpi
 */
@WebServlet({"/performance", "/kpi"})
public class PerformanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "performance");
        request.getRequestDispatcher("/WEB-INF/views/performance/performance-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("approve_kpi".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/performance?success=approved");
            return;
        } else if ("update_score".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/performance?success=score_updated");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/performance?success=true");
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
