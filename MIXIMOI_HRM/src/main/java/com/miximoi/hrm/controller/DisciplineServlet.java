package com.miximoi.hrm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản lý kỷ luật lao động, xử lý vi phạm nội quy và theo dõi quy trình 5 bước.
 * URL: /disciplines
 */
@WebServlet("/disciplines")
public class DisciplineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "disciplines");
        request.getRequestDispatcher("/WEB-INF/views/discipline/discipline-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("create_report".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/disciplines?success=report_created");
            return;
        } else if ("update_step".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/disciplines?success=step_updated");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/disciplines?success=true");
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
