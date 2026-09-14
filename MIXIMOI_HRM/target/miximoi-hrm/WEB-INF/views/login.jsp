<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — MIXIMOI HRM & PAYROLL</title>
    <!-- Google Fonts: Plus Jakarta Sans -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --dark-navy: #0b132b;
            --surface-navy: #1c2541;
            --card-bg: #ffffff;
        }
        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background: radial-gradient(circle at 10% 20%, #1e293b 0%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
            margin: 0;
            color: #0f172a;
        }
        .login-wrapper {
            width: 100%;
            max-width: 960px;
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.4);
            overflow: hidden;
            display: flex;
            flex-direction: row;
        }
        .login-hero {
            flex: 1;
            background: linear-gradient(145deg, #1e3a8a 0%, #1d4ed8 50%, #2563eb 100%);
            padding: 3.5rem 3rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: #ffffff;
            position: relative;
        }
        .login-hero::before {
            content: "";
            position: absolute;
            top: -20%;
            right: -20%;
            width: 320px;
            height: 320px;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 70%);
            border-radius: 50%;
        }
        .hero-brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .hero-brand-logo {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(8px);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 1.35rem;
            color: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .hero-brand-title {
            font-weight: 800;
            font-size: 1.25rem;
            letter-spacing: 0.5px;
            line-height: 1.1;
        }
        .hero-brand-sub {
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 1.2px;
            opacity: 0.85;
            text-transform: uppercase;
        }
        .hero-headline {
            margin-top: 2.5rem;
        }
        .hero-headline h2 {
            font-weight: 800;
            font-size: 2rem;
            line-height: 1.25;
            margin-bottom: 1rem;
        }
        .hero-headline p {
            color: #bfdbfe;
            font-size: 0.95rem;
            line-height: 1.6;
        }
        .hero-features {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-top: 1.5rem;
        }
        .hero-feature-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.88rem;
            color: #e0e7ff;
        }
        .hero-feature-item i {
            color: #93c5fd;
            font-size: 1.1rem;
        }
        .hero-footer {
            font-size: 0.8rem;
            color: #93c5fd;
            margin-top: 2rem;
        }

        /* Form Area */
        .login-form-panel {
            width: 460px;
            padding: 3rem 2.75rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: #ffffff;
        }
        .form-title {
            font-weight: 800;
            font-size: 1.5rem;
            color: #0f172a;
            margin-bottom: 0.35rem;
        }
        .form-subtitle {
            font-size: 0.88rem;
            color: #64748b;
            margin-bottom: 1.5rem;
        }
        .form-label {
            font-size: 0.82rem;
            font-weight: 600;
            color: #334155;
            margin-bottom: 0.4rem;
        }
        .input-group-custom {
            position: relative;
            margin-bottom: 1.15rem;
        }
        .input-group-custom i.icon-prefix {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 1rem;
            z-index: 5;
        }
        .input-group-custom .form-control {
            height: 46px;
            padding-left: 42px;
            border-radius: 10px;
            border: 1.5px solid #e2e8f0;
            font-size: 0.9rem;
            transition: all 0.2s ease;
            background-color: #f8fafc;
        }
        .input-group-custom .form-control:focus {
            background-color: #ffffff;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }
        .btn-submit {
            height: 46px;
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }
        .btn-submit:hover {
            background: #1d4ed8;
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.35);
            transform: translateY(-1px);
        }

        /* Demo Role Quick Picker */
        .demo-roles-container {
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px dashed #e2e8f0;
        }
        .demo-roles-title {
            font-size: 0.76rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 0.65rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .demo-roles-badge {
            background: #eff6ff;
            color: #2563eb;
            font-size: 0.7rem;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 999px;
        }
        .demo-roles-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 6px;
        }
        .demo-role-btn {
            border: 1px solid #e2e8f0;
            background: #f8fafc;
            border-radius: 8px;
            padding: 7px 10px;
            font-size: 0.78rem;
            text-align: left;
            transition: all 0.15s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            color: #1e293b;
            user-select: none;
        }
        .demo-role-btn:hover, .demo-role-btn.selected {
            border-color: #2563eb;
            background: #eff6ff;
            color: #1d4ed8;
            font-weight: 600;
        }
        .demo-role-btn i {
            font-size: 0.9rem;
            color: #3b82f6;
        }

        @media (max-width: 860px) {
            .login-hero { display: none; }
            .login-form-panel { width: 100%; padding: 2.25rem 1.75rem; }
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <!-- Left Hero Banner -->
    <div class="login-hero">
        <div>
            <div class="hero-brand">
                <div class="hero-brand-logo">M</div>
                <div>
                    <div class="hero-brand-title">MIXIMOI</div>
                    <div class="hero-brand-sub">HRM & PAYROLL SYSTEM</div>
                </div>
            </div>
            <div class="hero-headline">
                <h2>Quản trị nhân sự & tiền lương thế hệ mới</h2>
                <p>Nền tảng quản lý hồ sơ nhân viên, quy trình tiếp nhận, chấm công ca kíp, tính lương tự động và phân quyền phân cấp bảo mật cao cấp.</p>
            </div>
            <div class="hero-features">
                <div class="hero-feature-item">
                    <i class="bi bi-shield-check"></i> Phân quyền chuyên sâu theo 5 vai trò (Admin, HR, Accountant, Manager, Employee)
                </div>
                <div class="hero-feature-item">
                    <i class="bi bi-person-lines-fill"></i> Quản lý hồ sơ nhân sự chuẩn hóa quy trình tiếp nhận Onboarding 4 bước
                </div>
                <div class="hero-feature-item">
                    <i class="bi bi-speedometer2"></i> Tự động đồng bộ chấm công FaceID, bảng lương và báo cáo trực quan
                </div>
            </div>
        </div>

        <div class="hero-footer">
            &copy; 2026 MIXIMOI Corp. Toàn quyền bảo lưu hệ thống quản trị.
        </div>
    </div>

    <!-- Right Login Form Panel -->
    <div class="login-form-panel">
        <div class="form-title">Đăng nhập hệ thống</div>
        <div class="form-subtitle">Nhập thông tin xác thực để bắt đầu phiên làm việc</div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center py-2 px-3 mb-3" role="alert" style="font-size: 0.85rem; border-radius: 10px;">
                <i class="bi bi-exclamation-circle-fill me-2 text-danger fs-6"></i>
                <div>${error}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="padding: 0.85rem;"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
            <div class="mb-1">
                <label class="form-label" for="usernameInput">Tên đăng nhập</label>
                <div class="input-group-custom">
                    <i class="bi bi-person icon-prefix"></i>
                    <input type="text" class="form-control" id="usernameInput" name="username"
                           placeholder="admin, hr01, accountant..." required autofocus>
                </div>
            </div>

            <div class="mb-2">
                <div class="d-flex justify-content-between align-items-center">
                    <label class="form-label" for="passwordInput">Mật khẩu</label>
                    <span class="text-muted" style="font-size:0.75rem;">Mặc định: miximoi@2026</span>
                </div>
                <div class="input-group-custom">
                    <i class="bi bi-lock icon-prefix"></i>
                    <input type="password" class="form-control" id="passwordInput" name="password"
                           placeholder="Nhập mật khẩu" required value="miximoi@2026">
                </div>
            </div>

            <button type="submit" class="btn btn-submit w-100 mt-2">
                <i class="bi bi-box-arrow-in-right me-2"></i> Đăng nhập vào hệ thống
            </button>
        </form>

        <!-- Quick Demo Account Switcher -->
        <div class="demo-roles-container">
            <div class="demo-roles-title">
                <span>Chọn nhanh tài khoản Demo theo Role:</span>
                <span class="demo-roles-badge">1-Chạm</span>
            </div>
            <div class="demo-roles-grid">
                <div class="demo-role-btn" onclick="selectRole('admin', 'ADMIN: Toàn quyền hệ thống')">
                    <i class="bi bi-shield-shaded text-danger"></i>
                    <div>
                        <strong>Admin</strong>
                        <div class="text-muted" style="font-size:0.68rem;">admin</div>
                    </div>
                </div>

                <div class="demo-role-btn" onclick="selectRole('hr01', 'HR: Quản lý nhân sự & tuyển dụng')">
                    <i class="bi bi-people-fill text-primary"></i>
                    <div>
                        <strong>Nhân sự (HR)</strong>
                        <div class="text-muted" style="font-size:0.68rem;">hr01</div>
                    </div>
                </div>

                <div class="demo-role-btn" onclick="selectRole('accountant', 'ACCOUNTANT: Bảng lương & phụ cấp')">
                    <i class="bi bi-cash-stack text-success"></i>
                    <div>
                        <strong>Kế toán</strong>
                        <div class="text-muted" style="font-size:0.68rem;">accountant</div>
                    </div>
                </div>

                <div class="demo-role-btn" onclick="selectRole('manager01', 'MANAGER: Quản lý & KPI')">
                    <i class="bi bi-briefcase-fill text-warning"></i>
                    <div>
                        <strong>Quản lý</strong>
                        <div class="text-muted" style="font-size:0.68rem;">manager01</div>
                    </div>
                </div>

                <div class="demo-role-btn" style="grid-column: span 2;" onclick="selectRole('nv004', 'EMPLOYEE: Chấm công & phiếu lương của tôi')">
                    <i class="bi bi-person-fill text-info"></i>
                    <div>
                        <strong>Nhân viên thông thường (Self-service Portal)</strong>
                        <div class="text-muted" style="font-size:0.68rem;">Tài khoản nv004 - Xem chấm công, gửi nghỉ phép & phiếu lương của tôi</div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    function selectRole(username, description) {
        document.getElementById('usernameInput').value = username;
        document.getElementById('passwordInput').value = 'miximoi@2026';
        
        // Highlight active btn
        document.querySelectorAll('.demo-role-btn').forEach(btn => btn.classList.remove('selected'));
        if (event && event.currentTarget) {
            event.currentTarget.classList.add('selected');
        }
    }
</script>

</body>
</html>
