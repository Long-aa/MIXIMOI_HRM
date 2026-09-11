<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — MIXIMOI HRM</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #1a237e 0%, #0d47a1 50%, #1565c0 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: rgba(255,255,255,0.97);
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 2.5rem;
            width: 100%;
            max-width: 420px;
        }
        .brand-logo {
            background: linear-gradient(135deg, #1a237e, #1565c0);
            color: white;
            border-radius: 12px;
            padding: 12px 20px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 1.5rem;
        }
        .brand-logo i { font-size: 1.6rem; }
        .brand-name { font-size: 1.1rem; font-weight: 700; line-height: 1.2; }
        .brand-sub  { font-size: 0.72rem; opacity: 0.85; }
        .form-control:focus {
            border-color: #1565c0;
            box-shadow: 0 0 0 0.2rem rgba(21,101,192,0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #1a237e, #1565c0);
            border: none;
            padding: 0.7rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .btn-login:hover { opacity: 0.92; transform: translateY(-1px); }
    </style>
</head>
<body>
<div class="login-card">
    <div class="text-center">
        <div class="brand-logo">
            <i class="bi bi-building-gear"></i>
            <div>
                <div class="brand-name">MIXIMOI HRM</div>
                <div class="brand-sub">Human Resource Management</div>
            </div>
        </div>
    </div>

    <h5 class="text-center text-muted mb-4">Đăng nhập hệ thống</h5>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
        <div class="mb-3">
            <label for="username" class="form-label fw-semibold">Tên đăng nhập</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-person"></i></span>
                <input type="text" class="form-control" id="username" name="username"
                       placeholder="Nhập tên đăng nhập" autofocus required>
            </div>
        </div>
        <div class="mb-4">
            <label for="password" class="form-label fw-semibold">Mật khẩu</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="Nhập mật khẩu" required>
            </div>
        </div>
        <button type="submit" class="btn btn-login btn-primary w-100">
            <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập
        </button>
    </form>

    <p class="text-center text-muted mt-4 mb-0" style="font-size:0.8rem;">
        &copy; 2026 MixiMoi Company — HRM System v1.0
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
