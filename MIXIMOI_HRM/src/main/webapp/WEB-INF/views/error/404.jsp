<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>404 — Không tìm thấy trang — MIXIMOI HRM</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body class="bg-pattern">

<div class="error-page-wrapper">
    <div class="app-card border-0 shadow-lg p-5" style="max-width: 540px;">
        <div class="error-code-badge">
            404
        </div>
        <h4 class="fw-bold text-dark mb-2">Trang không tồn tại</h4>
        <p class="text-muted mb-4" style="font-size: 0.95rem; line-height: 1.6;">
            Đường dẫn bạn vừa truy cập không tồn tại, đã bị xóa hoặc tạm thời không khả dụng trên hệ thống.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="javascript:history.back()" class="btn-action-light text-decoration-none">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-action-primary text-decoration-none">
                <i class="bi bi-house-door-fill"></i> Về Dashboard
            </a>
        </div>
        <div class="mt-4 pt-3 border-top text-muted" style="font-size: 0.78rem;">
            MIXIMOI HRM & PAYROLL • Error Routing
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
