<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect về login hoặc dashboard tùy session
    if (session != null && session.getAttribute("currentUser") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
