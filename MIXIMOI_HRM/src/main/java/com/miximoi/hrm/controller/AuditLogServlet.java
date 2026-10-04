package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AuditLogDAO;
import com.miximoi.hrm.model.AuditLog;
import com.miximoi.hrm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller hiển thị và tra cứu Nhật ký kiểm toán hệ thống (Audit Trail).
 * URL: /audit-logs (Chỉ ADMIN)
 */
@WebServlet("/audit-logs")
public class AuditLogServlet extends HttpServlet {

    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        String keyword = request.getParameter("keyword");
        String actionFilter = request.getParameter("actionFilter");
        String moduleFilter = request.getParameter("moduleFilter");

        List<AuditLog> auditLogs = auditLogDAO.search(keyword, actionFilter, moduleFilter, 150);
        request.setAttribute("auditLogs", auditLogs);
        request.setAttribute("keyword", keyword);
        request.setAttribute("actionFilter", actionFilter);
        request.setAttribute("moduleFilter", moduleFilter);
        request.setAttribute("activeMenu", "audit_logs");
        request.getRequestDispatcher("/WEB-INF/views/admin/audit-logs.jsp")
               .forward(request, response);
    }
}
