<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>500 — Lỗi máy chủ — MIXIMOI HRM</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body class="bg-pattern">

<div class="error-page-wrapper">
    <div class="app-card border-0 shadow-lg p-5" style="max-width: 580px;">
        <div class="error-code-badge" style="background: linear-gradient(135deg, #ef4444, #dc2626); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
            500
        </div>
        <h4 class="fw-bold text-dark mb-2">Đã xảy ra sự cố hệ thống</h4>
        <p class="text-muted mb-4" style="font-size: 0.95rem; line-height: 1.6;">
            Máy chủ đã gặp lỗi không mong muốn trong quá trình xử lý yêu cầu của bạn. Quản trị viên hệ thống đã được ghi nhận nhật ký lỗi này.
        </p>
        <c:if test="${not empty pageContext.exception}">
            <div class="alert alert-danger text-start p-3 mb-4 font-monospace" style="font-size:0.78rem; max-height: 120px; overflow-y: auto;">
                ${pageContext.exception.message}
            </div>
        </c:if>
        <div class="d-flex justify-content-center gap-3">
            <a href="javascript:location.reload()" class="btn-action-light text-decoration-none">
                <i class="bi bi-arrow-clockwise"></i> Tải lại trang
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-action-primary text-decoration-none">
                <i class="bi bi-house-door-fill"></i> Về Dashboard
            </a>
        </div>
        <div class="mt-4 pt-3 border-top text-muted" style="font-size: 0.78rem;">
            MIXIMOI HRM & PAYROLL Server Engine
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
