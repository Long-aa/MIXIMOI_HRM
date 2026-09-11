package com.miximoi.hrm.controller;

import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.LeaveService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

/**
 * Servlet quản lý nghỉ phép.
 * URL: /leave
 */
@WebServlet("/leave")
public class LeaveServlet extends HttpServlet {

    private final LeaveService leaveService = new LeaveService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User currentUser = getCurrentUser(request);
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                request.getRequestDispatcher("/WEB-INF/views/leave/leave-form.jsp")
                       .forward(request, response);
                break;
            case "detail": {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("leaveRequest", leaveService.getById(id));
                request.getRequestDispatcher("/WEB-INF/views/leave/leave-detail.jsp")
                       .forward(request, response);
                break;
            }
            default: {
                // HR / ADMIN / MANAGER thấy tất cả; EMPLOYEE chỉ thấy của mình
                if ("EMPLOYEE".equals(currentUser.getRole())) {
                    request.setAttribute("leaveRequests",
                            leaveService.getByEmployee(currentUser.getEmployeeId()));
                } else {
                    request.setAttribute("leaveRequests", leaveService.getAll());
                }
                request.getRequestDispatcher("/WEB-INF/views/leave/leave-list.jsp")
                       .forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentUser(request);
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "submit": {
                LeaveRequest lr = new LeaveRequest();
                lr.setEmployeeId(currentUser.getEmployeeId());
                lr.setLeaveType(request.getParameter("leaveType"));
                String sd = request.getParameter("startDate");
                String ed = request.getParameter("endDate");
                if (sd != null && !sd.isEmpty()) lr.setStartDate(LocalDate.parse(sd));
                if (ed != null && !ed.isEmpty()) lr.setEndDate(LocalDate.parse(ed));
                lr.setReason(request.getParameter("reason"));
                String error = leaveService.createLeaveRequest(lr);
                if (error != null) {
                    request.setAttribute("error", error);
                    request.getRequestDispatcher("/WEB-INF/views/leave/leave-form.jsp")
                           .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/leave?success=submitted");
                }
                break;
            }
            case "approve": {
                int id = Integer.parseInt(request.getParameter("id"));
                leaveService.approve(id, currentUser.getEmployeeId());
                response.sendRedirect(request.getContextPath() + "/leave?success=approved");
                break;
            }
            case "reject": {
                int id = Integer.parseInt(request.getParameter("id"));
                String reason = request.getParameter("rejectReason");
                leaveService.reject(id, currentUser.getEmployeeId(), reason);
                response.sendRedirect(request.getContextPath() + "/leave?success=rejected");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/leave");
        }
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

    private User getCurrentUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("currentUser");
    }
}
