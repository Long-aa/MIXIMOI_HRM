<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>403 — Không có quyền truy cập — MIXIMOI HRM</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body class="bg-pattern">

<div class="error-page-wrapper">
    <div class="app-card border-0 shadow-lg p-5" style="max-width: 540px;">
        <div class="error-code-badge" style="background: linear-gradient(135deg, #f59e0b, #ef4444); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
            403
        </div>
        <h4 class="fw-bold text-dark mb-2">Truy cập bị từ chối</h4>
        <p class="text-muted mb-4" style="font-size: 0.95rem; line-height: 1.6;">
            Rất tiếc! Tài khoản của bạn không có đủ thẩm quyền hoặc phân quyền cần thiết để truy cập tài nguyên này.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="javascript:history.back()" class="btn-action-light text-decoration-none">
                <i class="bi bi-arrow-left"></i> Quay lại trang trước
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-action-primary text-decoration-none">
                <i class="bi bi-house-door-fill"></i> Về Dashboard
            </a>
        </div>
        <div class="mt-4 pt-3 border-top text-muted" style="font-size: 0.78rem;">
            MIXIMOI HRM & PAYROLL Security Firewall
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
