package com.miximoi.hrm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản trị tuyển dụng toàn diện:
 * - /recruitment : Tuyển dụng tổng quan & Phễu tuyển dụng (Mockup 2)
 * - /recruitment?view=jobs : Quản lý Vị trí tuyển dụng & Xem trước JD (Mockup 3)
 * - /recruitment?view=candidates : Quản lý Hồ sơ ứng viên & ATS Kanban (Mockup 4)
 */
@WebServlet("/recruitment")
public class RecruitmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "recruitment");
        String view = request.getParameter("view");

        if ("jobs".equalsIgnoreCase(view)) {
            request.setAttribute("activeSubMenu", "jobs");
            request.getRequestDispatcher("/WEB-INF/views/recruitment/recruitment-jobs.jsp")
                   .forward(request, response);
            return;
        } else if ("candidates".equalsIgnoreCase(view)) {
            request.setAttribute("activeSubMenu", "candidates");
            request.getRequestDispatcher("/WEB-INF/views/recruitment/recruitment-candidates.jsp")
                   .forward(request, response);
            return;
        }

        request.setAttribute("activeSubMenu", "overview");
        request.getRequestDispatcher("/WEB-INF/views/recruitment/recruitment-overview.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String view = request.getParameter("view");
        String redirectTarget = request.getContextPath() + "/recruitment";

        if ("create_job".equalsIgnoreCase(action)) {
            redirectTarget += "?view=jobs&success=job_created";
        } else if ("send_offer".equalsIgnoreCase(action)) {
            redirectTarget += "?view=candidates&success=offer_sent";
        } else if ("add_candidate".equalsIgnoreCase(action)) {
            redirectTarget += "?view=candidates&success=candidate_added";
        } else if (view != null) {
            redirectTarget += "?view=" + view + "&success=true";
        } else {
            redirectTarget += "?success=true";
        }

        response.sendRedirect(redirectTarget);
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
