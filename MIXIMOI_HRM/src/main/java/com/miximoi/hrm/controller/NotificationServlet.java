package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AuditLogDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.NotificationDAO;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Notification;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Servlet điều phối thông báo & Cảnh báo toàn hệ thống (/notifications).
 * Hỗ trợ phát thông báo khẩn cấp (Center-screen Alert), đồng bộ qua Email SMTP,
 * và hiển thị Toast tức thời cho nhân viên.
 */
@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "mark_read" -> {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    try {
                        int id = Integer.parseInt(idStr);
                        notificationDAO.markAsRead(id);
                    } catch (NumberFormatException ignored) {}
                }
                String redirect = request.getParameter("redirect");
                if (redirect != null && !redirect.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + (redirect.startsWith("/") ? redirect : "/" + redirect));
                } else {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\":true}");
                }
            }
            case "unread_toast" -> {
                response.setContentType("application/json;charset=UTF-8");
                List<Notification> recents = notificationDAO.findRecent(currentUser.getId(), 5);
                Notification targetToast = null;
                if (recents != null) {
                    for (Notification n : recents) {
                        if (!n.isRead()) {
                            targetToast = n;
                            break;
                        }
                    }
                }
                if (targetToast != null) {
                    String json = String.format(
                        "{\"hasToast\":true,\"id\":%d,\"title\":\"%s\",\"message\":\"%s\",\"type\":\"%s\",\"linkUrl\":\"%s\"}",
                        targetToast.getId(),
                        escapeJson(targetToast.getTitle()),
                        escapeJson(targetToast.getMessage()),
                        targetToast.getType(),
                        targetToast.getLinkUrl() != null ? escapeJson(targetToast.getLinkUrl()) : "/timesheet"
                    );
                    response.getWriter().write(json);
                } else {
                    response.getWriter().write("{\"hasToast\":false}");
                }
            }
            case "poll" -> {
                response.setContentType("application/json;charset=UTF-8");
                int unread = notificationDAO.countUnread(currentUser.getId());
                response.getWriter().write("{\"success\":true,\"unreadCount\":" + unread + "}");
            }
            default -> response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "broadcast" -> {
                // Chỉ Admin và HR được quyền phát cảnh báo toàn công ty
                if (!currentUser.isAdmin() && !currentUser.isHr()) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
                    return;
                }

                String title = request.getParameter("title");
                String message = request.getParameter("message");
                String type = request.getParameter("type"); // WARNING, DANGER, INFO
                String linkUrl = request.getParameter("linkUrl");
                boolean sendEmail = "on".equalsIgnoreCase(request.getParameter("sendEmail"))
                                 || "true".equalsIgnoreCase(request.getParameter("sendEmail"));

                if (title != null && !title.trim().isEmpty() && message != null && !message.trim().isEmpty()) {
                    Notification n = new Notification();
                    n.setTitle(title.trim());
                    n.setMessage(message.trim());
                    n.setType(type != null ? type.toUpperCase() : "WARNING");
                    n.setLinkUrl(linkUrl != null && !linkUrl.trim().isEmpty() ? linkUrl.trim() : "/dashboard");
                    n.setModule("BROADCAST");
                    n.setCreatedAt(LocalDateTime.now());
                    n.setRead(false);

                    notificationDAO.broadcast(n);

                    // Đưa thông báo vào application context để hiển thị giữa màn hình khi nhân viên đăng nhập
                    getServletContext().setAttribute("activeBroadcastAlert", n);

                    // Ghi vết nhật ký kiểm toán
                    AuditLogDAO.logAction(request, "BROADCAST_ALERT", "NOTIFICATION", n.getId(),
                            "Phát cảnh báo toàn thể nhân sự: " + title);

                    // Gửi Email thông báo tự động nếu được chọn
                    if (sendEmail) {
                        List<Employee> allEmployees = employeeDAO.findAll();
                        for (Employee emp : allEmployees) {
                            if (emp.getEmail() != null && !emp.getEmail().trim().isEmpty()) {
                                EmailService.sendBroadcastAlert(emp.getEmail(), emp.getFullName(), title, message);
                            }
                        }
                    }
                }

                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer + (referer.contains("?") ? "&" : "?") + "success=broadcast_sent");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?success=broadcast_sent");
                }
            }
            case "mark_all_read" -> {
                notificationDAO.markAllAsRead(currentUser.getId());
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":true}");
            }
            case "mark_read" -> {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    try {
                        notificationDAO.markAsRead(Integer.parseInt(idStr));
                    } catch (NumberFormatException ignored) {}
                }
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":true}");
            }
            case "dismiss_alert" -> {
                String alertId = request.getParameter("alertId");
                if (session != null) {
                    session.setAttribute("alert_dismissed_" + (alertId != null ? alertId : "latest"), Boolean.TRUE);
                }
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":true}");
            }
            default -> response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
