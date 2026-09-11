package com.miximoi.hrm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản lý Đánh giá hiệu suất nhân sự chu kỳ Q3/2026:
 * URL: /evaluations, /performance-evaluations
 */
@WebServlet({"/evaluations", "/performance-evaluations"})
public class EvaluationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "evaluations");
        request.getRequestDispatcher("/WEB-INF/views/performance/performance-evaluations.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("confirm".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/evaluations?success=confirmed");
            return;
        } else if ("submit".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/evaluations?success=submitted");
            return;
        } else if ("draft".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/evaluations?success=draft_saved");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/evaluations?success=true");
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
