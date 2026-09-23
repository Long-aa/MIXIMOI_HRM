<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <jsp:include page="/WEB-INF/views/common/head.jsp">
                    <jsp:param name="title" value="Cài đặt Tài khoản, Giao diện & Bảo mật - MIXIMOI HRM" />
                </jsp:include>
                <style>
                    .setting-section-card {
                        background: #ffffff;
                        border: 1px solid #e2e8f0;
                        border-radius: 12px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
                        margin-bottom: 1.5rem;
                        overflow: hidden;
                        scroll-margin-top: 90px;
                    }

                    .setting-section-header {
                        padding: 1rem 1.25rem;
                        background: #ffffff;
                        border-bottom: 1px solid #edf2f7;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .setting-section-body {
                        padding: 1.25rem;
                    }

                    .profile-hero-card {
                        background: linear-gradient(135deg, #f8fafc 0%, #eff6ff 100%);
                        border: 1px solid #dbeafe;
                        border-radius: 10px;
                        padding: 1.25rem;
                        margin-bottom: 1.25rem;
                    }

                    .profile-avatar-box {
                        width: 76px;
                        height: 76px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #2563eb, #1d4ed8);
                        color: #ffffff;
                        font-size: 1.75rem;
                        font-weight: 700;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-shadow: 0 4px 10px rgba(37, 99, 235, 0.25);
                        border: 3px solid #ffffff;
                    }

                    .device-session-item {
                        border: 1px solid #e2e8f0;
                        border-radius: 8px;
                        padding: 0.85rem 1rem;
                        margin-bottom: 0.65rem;
                        background: #ffffff;
                        transition: all 0.2s ease;
                    }

                    .device-session-item:hover {
                        border-color: #cbd5e1;
                        background: #f8fafc;
                    }

                    .device-session-item.current {
                        border-color: #93c5fd;
                        background: #eff6ff;
                    }

                    .notification-toggle-row {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: 0.85rem 0;
                        border-bottom: 1px solid #f1f5f9;
                    }

                    .notification-toggle-row:last-child {
                        border-bottom: none;
                        padding-bottom: 0;
                    }

                    .password-strength-bar {
                        height: 6px;
                        border-radius: 3px;
                        background: #e2e8f0;
                        overflow: hidden;
                        margin-top: 0.4rem;
                    }

                    .password-strength-fill {
                        width: 100%;
                        height: 100%;
                        background: #10b981;
                        border-radius: 3px;
                    }

                    .api-key-box {
                        background: #0f172a;
                        color: #38bdf8;
                        font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
                        padding: 0.65rem 1rem;
                        border-radius: 8px;
                        font-size: 0.85rem;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        gap: 1rem;
                    }
                </style>
            </head>

            <body class="hrm-app-body">
                <div class="app-layout">
                    <!-- Sidebar -->
                    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

                    <div class="app-main">
                        <!-- Topbar -->
                        <jsp:include page="/WEB-INF/views/common/topbar.jsp" />

                        <!-- Main Content Area -->
                        <main class="app-content p-3 p-lg-4">
                            <!-- Toast notification if action done -->
                            <c:if test="${param.success eq 'profile_saved' || param.success eq 'saved'}">
                                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3 shadow-sm"
                                    role="alert">
                                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                                    <div><strong>Thao tác thành công!</strong> Đã lưu thay đổi cấu hình tài khoản và hệ
                                        thống thành công.</div>
                                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${param.success eq 'password_changed'}">
                                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3 shadow-sm"
                                    role="alert">
                                    <i class="bi bi-shield-check fs-5 text-success"></i>
                                    <div><strong>Cập nhật bảo mật!</strong> Mật khẩu mới đã được xác lập an toàn cho tài
                                        khoản quản trị.</div>
                                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <!-- Page Header -->
                            <div
                                class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                                <div>
                                    <div class="d-flex align-items-center gap-2 mb-1">
                                        <h1 class="h3 fw-bold text-dark mb-0">Cài đặt hệ thống</h1>
                                        <span
                                            class="badge bg-primary-subtle text-primary font-monospace fw-bold">ENTERPRISE
                                            v4.2</span>
                                    </div>
                                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                                        Quản lý hồ sơ cá nhân, giao diện người dùng, chính sách bảo mật đa yếu tố và cấu
                                        hình kỹ thuật.
                                    </p>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/settings?view=system"
                                        class="btn btn-outline-secondary d-flex align-items-center gap-2">
                                        <i class="bi bi-arrow-left"></i>
                                        <span>Cài đặt Doanh nghiệp</span>
                                    </a>
                                    <button type="submit" form="profileSettingsForm"
                                        class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                                        <i class="bi bi-floppy-fill"></i>
                                        <span>Lưu thay đổi</span>
                                    </button>
                                </div>
                            </div>

                            <!-- Two-Column Layout: Settings Navigation Sidebar + Form Content -->
                            <div class="row g-4">
                                <!-- Col-3: Vertical Settings Tabs Navigation -->
                                <div class="col-12 col-lg-3">
                                    <div class="settings-nav-card position-sticky" style="top: 80px;">
                                        <div class="fw-bold text-muted small px-3 py-2 text-uppercase"
                                            style="font-size: 0.68rem; letter-spacing: 0.5px;">
                                            DANH MỤC THIẾT LẬP
                                        </div>
                                        <a href="#sec-profile" class="settings-nav-link active">
                                            <i class="bi bi-person-circle text-primary"></i>
                                            <span>1. Hồ sơ tài khoản</span>
                                        </a>
                                        <a href="#sec-appearance" class="settings-nav-link">
                                            <i class="bi bi-palette text-warning"></i>
                                            <span>2. Giao diện</span>
                                        </a>
                                        <a href="#sec-notifications" class="settings-nav-link">
                                            <i class="bi bi-bell text-danger"></i>
                                            <span>3. Thông báo</span>
                                        </a>
                                        <a href="#sec-security-sessions" class="settings-nav-link">
                                            <i class="bi bi-shield-lock text-success"></i>
                                            <span>4. Bảo mật & Phiên</span>
                                        </a>
                                        <a href="#sec-datetime" class="settings-nav-link">
                                            <i class="bi bi-clock-history text-info"></i>
                                            <span>5. Ngày & Giờ</span>
                                        </a>
                                        <a href="#sec-smtp" class="settings-nav-link">
                                            <i class="bi bi-envelope-at text-primary"></i>
                                            <span>6. Cấu hình Email SMTP</span>
                                        </a>
                                        <a href="#sec-api-integrations" class="settings-nav-link">
                                            <i class="bi bi-cpu text-purple"></i>
                                            <span>7. Tích hợp & RESTful API</span>
                                        </a>
                                        <a href="#sec-backup" class="settings-nav-link">
                                            <i class="bi bi-cloud-arrow-up text-success"></i>
                                            <span>8. Sao lưu dữ liệu tự động</span>
                                        </a>

                                        <div class="pt-2 border-top mt-2">
                                            <a href="${pageContext.request.contextPath}/settings?view=system"
                                                class="btn btn-outline-primary btn-sm w-100 d-flex align-items-center justify-content-center gap-2">
                                                <i class="bi bi-building-gear"></i>
                                                <span>Thiết lập Doanh nghiệp</span>
                                            </a>
                                        </div>

                                        <!-- Server Infrastructure Card (AWS Cloud) -->
                                        <div class="p-3 bg-light rounded-3 mt-3 border" style="font-size: 0.74rem;">
                                            <div class="d-flex align-items-center justify-content-between mb-1">
                                                <span class="fw-bold text-dark">Máy chủ AWS Cloud</span>
                                                <span
                                                    class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                                    <span class="vssid-status-dot"></span> Online
                                                </span>
                                            </div>
                                            <div class="text-muted mb-1">Khu vực: <strong>ap-southeast-1</strong></div>
                                            <div class="text-muted mb-2">Uptime hệ thống: <strong
                                                    class="text-success">99.98%</strong></div>
                                            <div class="progress" style="height: 4px;">
                                                <div class="progress-bar bg-success" role="progressbar"
                                                    style="width: 99.98%"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Col-9: Settings Form Body -->
                                <div class="col-12 col-lg-9">
                                    <form id="profileSettingsForm" action="${pageContext.request.contextPath}/settings"
                                        method="post">
                                        <input type="hidden" name="action" value="save_profile">
                                        <input type="hidden" name="view" value="profile">

                                        <!-- ==========================================
                             1. HỒ SƠ TÀI KHOẢN
                             ========================================== -->
                                        <div class="setting-section-card" id="sec-profile">
                                            <div class="setting-section-header">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-person-circle fs-5 text-primary"></i>
                                                    <h2 class="h6 fw-bold mb-0 text-dark">1. Hồ sơ tài khoản cá nhân
                                                    </h2>
                                                </div>
                                                <span class="badge bg-primary-subtle text-primary">Super Admin</span>
                                            </div>
                                            <div class="setting-section-body">
                                                <!-- Profile Hero Banner -->
                                                <div
                                                    class="profile-hero-card d-flex flex-column flex-sm-row align-items-center gap-3">
                                                    <div class="profile-avatar-box">
                                                        <c:choose>
                                                            <c:when test="${not empty sessionScope.currentUser.fullName}">
                                                                ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
                                                            </c:when>
                                                            <c:otherwise>A</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="text-center text-sm-start flex-grow-1">
                                                        <div
                                                            class="d-flex flex-wrap align-items-center justify-content-center justify-content-sm-start gap-2 mb-1">
                                                            <h3 class="h5 fw-bold text-dark mb-0">
                                                                <c:choose>
                                                                    <c:when test="${not empty sessionScope.currentUser.fullName}">
                                                                        ${sessionScope.currentUser.fullName}
                                                                    </c:when>
                                                                    <c:otherwise>${sessionScope.currentUser.username}</c:otherwise>
                                                                </c:choose>
                                                            </h3>
                                                            <span
                                                                class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                                                <i class="bi bi-patch-check-fill"></i> Đã xác thực
                                                            </span>
                                                            <span class="role-badge-superadmin">
                                                                <i class="bi bi-shield-shaded"></i> ${sessionScope.currentUser.roleDisplayName}
                                                            </span>
                                                        </div>
                                                        <div class="text-muted small mb-2">
                                                            <span>${sessionScope.currentUser.email}</span> • <span>Mã NV:
                                                                ${sessionScope.currentUser.employeeCode}</span> • <span>${sessionScope.currentUser.departmentName}</span>
                                                        </div>
                                                        <div
                                                            class="d-flex flex-wrap gap-2 justify-content-center justify-content-sm-start">
                                                            <button type="button"
                                                                class="btn btn-sm btn-light border shadow-sm d-flex align-items-center gap-1"
                                                                onclick="alert('Vui lòng chọn ảnh đại diện định dạng PNG, JPG (tối đa 2MB)');">
                                                                <i class="bi bi-camera"></i> Tải ảnh mới
                                                            </button>
                                                            <button type="button"
                                                                class="btn btn-sm btn-outline-danger d-flex align-items-center gap-1"
                                                                onclick="alert('Đã khôi phục avatar mặc định');">
                                                                <i class="bi bi-trash"></i> Xóa ảnh
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Form Grid -->
                                                <div class="row g-3">
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Họ và tên
                                                            <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="fullName"
                                                            value="${sessionScope.currentUser.fullName}" required>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Email hệ
                                                            thống <span class="text-danger">*</span></label>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-light"><i
                                                                    class="bi bi-envelope"></i></span>
                                                            <input type="email" class="form-control" name="email"
                                                                value="${sessionScope.currentUser.email}" required>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Số điện
                                                            thoại liên hệ</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-light">+84</span>
                                                            <input type="text" class="form-control" name="phone"
                                                                value="0908 123 456">
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Mã nhân
                                                            sự</label>
                                                        <input type="text" class="form-control bg-light font-monospace"
                                                            value="${sessionScope.currentUser.employeeCode}" readonly>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Phòng ban</label>
                                                        <input type="text" class="form-control bg-light"
                                                            value="${sessionScope.currentUser.departmentName}" readonly>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Chức vụ / Chức danh</label>
                                                        <input type="text" class="form-control bg-light"
                                                            value="${sessionScope.currentUser.positionName}" readonly>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ==========================================
                             2. GIAO DIỆN & HIỂN THỊ
                             ========================================== -->
                                        <div class="setting-section-card" id="sec-appearance">
                                            <div class="setting-section-header">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-palette fs-5 text-warning"></i>
                                                    <h2 class="h6 fw-bold mb-0 text-dark">2. Tùy chọn giao diện & Trải
                                                        nghiệm</h2>
                                                </div>
                                                <span class="text-muted small">Theme & Layout</span>
                                            </div>
                                            <div class="setting-section-body">
                                                <div class="mb-3">
                                                    <label
                                                        class="form-label small fw-semibold text-dark d-block mb-2">Chủ
                                                        đề hiển thị (Theme Mode)</label>
                                                    <div class="row g-3">
                                                        <!-- Light Mode Card -->
                                                        <div class="col-12 col-md-4">
                                                            <div class="theme-option-card active"
                                                                onclick="selectTheme(this, 'light')">
                                                                <div class="theme-preview-box"
                                                                    style="background: #f8fafc; border: 1px solid #cbd5e1; display: flex; overflow: hidden;">
                                                                    <div
                                                                        style="width: 25%; background: #ffffff; border-right: 1px solid #e2e8f0;">
                                                                    </div>
                                                                    <div style="flex-grow: 1; padding: 4px;">
                                                                        <div
                                                                            style="height: 6px; width: 60%; background: #2563eb; border-radius: 2px; margin-bottom: 4px;">
                                                                        </div>
                                                                        <div
                                                                            style="height: 4px; width: 80%; background: #e2e8f0; border-radius: 2px;">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div
                                                                    class="d-flex align-items-center justify-content-between">
                                                                    <div class="fw-bold small text-dark">Sáng (Light)
                                                                    </div>
                                                                    <span class="badge bg-primary text-white"
                                                                        style="font-size: 0.65rem;">Đang chọn</span>
                                                                </div>
                                                                <small class="text-muted"
                                                                    style="font-size: 0.72rem;">Giao diện chuẩn, tương
                                                                    phản cao, tối ưu hiển thị văn phòng.</small>
                                                            </div>
                                                        </div>
                                                        <!-- Dark Mode Card -->
                                                        <div class="col-12 col-md-4">
                                                            <div class="theme-option-card"
                                                                onclick="selectTheme(this, 'dark')">
                                                                <div class="theme-preview-box"
                                                                    style="background: #0f172a; border: 1px solid #334155; display: flex; overflow: hidden;">
                                                                    <div
                                                                        style="width: 25%; background: #1e293b; border-right: 1px solid #334155;">
                                                                    </div>
                                                                    <div style="flex-grow: 1; padding: 4px;">
                                                                        <div
                                                                            style="height: 6px; width: 60%; background: #38bdf8; border-radius: 2px; margin-bottom: 4px;">
                                                                        </div>
                                                                        <div
                                                                            style="height: 4px; width: 80%; background: #334155; border-radius: 2px;">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div
                                                                    class="d-flex align-items-center justify-content-between">
                                                                    <div class="fw-bold small text-dark">Tối (Dark)
                                                                    </div>
                                                                </div>
                                                                <small class="text-muted"
                                                                    style="font-size: 0.72rem;">Giảm mỏi mắt ban đêm,
                                                                    phong cách lập trình viên hiện đại.</small>
                                                            </div>
                                                        </div>
                                                        <!-- System Mode Card -->
                                                        <div class="col-12 col-md-4">
                                                            <div class="theme-option-card"
                                                                onclick="selectTheme(this, 'system')">
                                                                <div class="theme-preview-box"
                                                                    style="background: linear-gradient(135deg, #f8fafc 50%, #0f172a 50%); border: 1px solid #cbd5e1;">
                                                                </div>
                                                                <div
                                                                    class="d-flex align-items-center justify-content-between">
                                                                    <div class="fw-bold small text-dark">Hệ thống
                                                                        (System)</div>
                                                                </div>
                                                                <small class="text-muted" style="font-size: 0.72rem;">Tự
                                                                    động chuyển đổi chế độ sáng/tối theo hệ điều hành
                                                                    máy tính.</small>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row g-3 pt-2 border-top">
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Kiểu thanh
                                                            bên (Sidebar Style)</label>
                                                        <select class="form-select">
                                                            <option value="expanded" selected>Mở rộng đầy đủ (Khuyến
                                                                nghị 260px)</option>
                                                            <option value="collapsed">Thu gọn dạng biểu tượng (Mini Icon
                                                                72px)</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Ngôn ngữ
                                                            hiển thị (Language)</label>
                                                        <select class="form-select">
                                                            <option value="vi" selected>Tiếng Việt (Mặc định)</option>
                                                            <option value="en">English (US)</option>
                                                            <option value="ja">日本語 (Japanese)</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Cỡ chữ hệ
                                                            thống (Font Size)</label>
                                                        <select class="form-select">
                                                            <option value="14" selected>Tiêu chuẩn (14px)</option>
                                                            <option value="15">Trung bình (15px)</option>
                                                            <option value="16">Lớn (16px)</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Mật độ
                                                            hiển thị bảng biểu (Density)</label>
                                                        <select class="form-select">
                                                            <option value="comfortable" selected>Rộng rãi, dễ đọc
                                                                (Comfortable)</option>
                                                            <option value="compact">Thu gọn, nhiều dữ liệu (Compact)
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ==========================================
                             3. CẤU HÌNH THÔNG BÁO
                             ========================================== -->
                                        <div class="setting-section-card" id="sec-notifications">
                                            <div class="setting-section-header">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-bell fs-5 text-danger"></i>
                                                    <h2 class="h6 fw-bold mb-0 text-dark">3. Cấu hình thông báo & Cảnh
                                                        báo tự động</h2>
                                                </div>
                                                <span class="badge bg-danger-subtle text-danger">7 Kênh thông báo</span>
                                            </div>
                                            <div class="setting-section-body">
                                                <p class="text-muted small mb-3">
                                                    Tùy chỉnh các thông báo tức thì bạn muốn nhận qua Email, trình duyệt
                                                    hoặc thiết bị di động.
                                                </p>

                                                <div class="notification-toggle-row">
                                                    <div>
                                                        <div class="fw-bold small text-dark">1. Thông báo qua Email
                                                            (Email Digest)</div>
                                                        <div class="text-muted" style="font-size: 0.75rem;">Nhận báo cáo
                                                            tổng hợp tuần/tháng và cảnh báo bảo mật khẩn cấp từ hệ
                                                            thống.</div>
                                                    </div>
                                                    <div class="form-check form-switch mb-0">
                                                        <input class="form-check-input" type="checkbox" checked
                                                            id="notifEmail">
                                                    </div>
                                                </div>

                                                <div class="notification-toggle-row">
                                                    <div>
                                                        <div class="fw-bold small text-dark">2. Thông báo Push trên
                                                            trình duyệt (Web Push)</div>
                                                        <div class="text-muted" style="font-size: 0.75rem;">Nhận cảnh
                                                            báo trực tiếp ngay khi đang mở ứng dụng MIXIMOI HRM trên màn
                                                            hình.</div>
                                                    </div>
                                                    <div class="form-check form-switch mb-0">
                                                        <input class="form-check-input" type="checkbox" checked
                                                            id="notifPush">
                                                    </div>
                                                </div>

                                                <div class="notification-toggle-row">
                                                    <div>
                                                        <div class="fw-bold small text-dark">3. Cảnh báo Hợp đồng lao
                                                            động sắp hết hạn</div>
                                                        <div class="text-muted" style="font-size: 0.75rem;">Thông báo
                                                            trước 30 ngày và 15 ngày khi hợp đồng thử việc hoặc xác định
                                                            thời hạn của nhân sự sắp đáo hạn.</div>
                                                    </div>
                                                    <div class="form-check form-switch mb-0">
                                                        <input class="form-check-input" type="checkbox" checked
                                                            id="notifContract">
                                                    </div>
                                                </div>

                                                <div class="notification-toggle-row">
                                                    <div>
                                                        <div class="fw-bold small text-dark">4. Đơn xin nghỉ phép & Giải
                                                            trình chấm công</div>
                                                        <div class="text-muted" style="font-size: 0.75rem;">Gửi cảnh báo
                                                            ngay khi nhân sự nộp đơn nghỉ phép hoặc yêu cầu giải trình
                                                            quên chấm công.</div>
                                                    </div>
                                                    <div class="form-check form-switch mb-0">
                                                        <input class="form-check-input" type="checkbox" checked
                                                            id="notifLeave">
                                                    </div>
                                                </div>

                                                <div class="notification-toggle-row">
                                                    <div>
                                                        <div class="fw-bold small text-dark">5. Phát hành Phiếu lương &
                                                            Quyết toán thuế</div>
                                                        <div class="text-muted" style="font-size: 0.75rem;">Nhận thông
                                                            báo khi phòng Nhân sự phê duyệt và chốt bảng lương định kỳ
                                                            tháng.</div>
                                                    </div>
                                                    <div class="form-check form-switch mb-0">
                                                        <input class="form-check-input" type="checkbox" checked
                                                            id="notifPayroll">
                                                    </div>
                                                </div>

                                                <div class="notification-toggle-row">
                                                    <div>
                                                        <div class="fw-bold small text-dark">6. Thông báo Tuyển dụng &
                                                            Lịch phỏng vấn</div>
                                                        <div class="text-muted" style="font-size: 0.75rem;">Cập nhật hồ
                                                            sơ ứng viên mới và nhắc nhở lịch phỏng vấn tiếp theo trong
                                                            tuần.</div>
                                                    </div>
                                                    <div class="form-check form-switch mb-0">
                                                        <input class="form-check-input" type="checkbox"
                                                            id="notifRecruit">
                                                    </div>
                                                </div>

                                                <div class="notification-toggle-row">
                                                    <div>
                                                        <div class="fw-bold small text-dark">7. Đánh giá hiệu suất định
                                                            kỳ (KPI / OKRs)</div>
                                                        <div class="text-muted" style="font-size: 0.75rem;">Nhắc nhở mở
                                                            chu kỳ đánh giá Q3/2026 và thông báo phê duyệt thẩm định kết
                                                            quả nhân sự.</div>
                                                    </div>
                                                    <div class="form-check form-switch mb-0">
                                                        <input class="form-check-input" type="checkbox" checked
                                                            id="notifKpi">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ==========================================
                             4. BẢO MẬT & PHIÊN LÀM VIỆC
                             ========================================== -->
                                        <div class="setting-section-card" id="sec-security-sessions">
                                            <div class="setting-section-header">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-shield-lock fs-5 text-success"></i>
                                                    <h2 class="h6 fw-bold mb-0 text-dark">4. Bảo mật tài khoản & Quản lý
                                                        phiên làm việc</h2>
                                                </div>
                                                <span class="badge bg-success-subtle text-success">2FA Active</span>
                                            </div>
                                            <div class="setting-section-body">
                                                <!-- 2FA Section -->
                                                <div class="p-3 bg-light rounded-3 border mb-4">
                                                    <div
                                                        class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-2 mb-2">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <i class="bi bi-shield-fill-check fs-4 text-success"></i>
                                                            <div>
                                                                <div class="fw-bold text-dark small">Xác thực hai yếu tố
                                                                    (2FA TOTP)</div>
                                                                <div class="text-muted" style="font-size: 0.74rem;">Bảo
                                                                    vệ tài khoản với ứng dụng Google Authenticator hoặc
                                                                    Microsoft Authenticator.</div>
                                                            </div>
                                                        </div>
                                                        <span class="badge bg-success text-white px-2 py-1">ĐANG BẬT BẢO
                                                            VỆ</span>
                                                    </div>
                                                    <div class="d-flex flex-wrap gap-2 mt-2">
                                                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                                            onclick="alert('Mã QR xác thực 2FA mới đã được gửi tới email quản trị.');">
                                                            <i class="bi bi-qr-code me-1"></i> Thiết lập lại mã 2FA
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                                            onclick="alert('Danh sách 10 mã dự phòng đã được tạo thành công.');">
                                                            <i class="bi bi-key me-1"></i> Mã khôi phục dự phòng
                                                        </button>
                                                    </div>
                                                </div>

                                                <!-- Change Password -->
                                                <div class="mb-4">
                                                    <h3 class="h6 fw-bold text-dark mb-2">Đổi mật khẩu tài khoản</h3>
                                                    <div class="row g-3">
                                                        <div class="col-12 col-md-4">
                                                            <label class="form-label small fw-semibold text-dark">Mật
                                                                khẩu hiện tại</label>
                                                            <input type="password" class="form-control"
                                                                name="currentPassword" placeholder="••••••••">
                                                        </div>
                                                        <div class="col-12 col-md-4">
                                                            <label class="form-label small fw-semibold text-dark">Mật
                                                                khẩu mới</label>
                                                            <input type="password" class="form-control"
                                                                name="newPassword" value="Miximoi@2026Sec!">
                                                            <div class="password-strength-bar">
                                                                <div class="password-strength-fill"></div>
                                                            </div>
                                                            <div class="d-flex justify-content-between mt-1"
                                                                style="font-size: 0.68rem;">
                                                                <span class="text-success fw-bold">Rất mạnh
                                                                    (12/12)</span>
                                                                <span class="text-muted">A-Z, a-z, 0-9, #!</span>
                                                            </div>
                                                        </div>
                                                        <div class="col-12 col-md-4">
                                                            <label class="form-label small fw-semibold text-dark">Xác
                                                                nhận mật khẩu mới</label>
                                                            <input type="password" class="form-control"
                                                                name="confirmPassword" value="Miximoi@2026Sec!">
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Active Devices & Sessions -->
                                                <div>
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <h3 class="h6 fw-bold text-dark mb-0">Phiên đăng nhập thiết bị
                                                            gần đây</h3>
                                                        <button type="button"
                                                            class="btn btn-sm btn-link text-danger text-decoration-none p-0"
                                                            onclick="alert('Đã đăng xuất toàn bộ các thiết bị ngoại vi khác.');">
                                                            <i class="bi bi-box-arrow-right me-1"></i> Đăng xuất tất cả
                                                            thiết bị khác
                                                        </button>
                                                    </div>

                                                    <!-- Session 1: Current Device -->
                                                    <div
                                                        class="device-session-item current d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-2">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="p-2 bg-white rounded border text-primary">
                                                                <i class="bi bi-laptop fs-4"></i>
                                                            </div>
                                                            <div>
                                                                <div
                                                                    class="fw-bold text-dark small d-flex align-items-center gap-2">
                                                                    <span>MacBook Pro 14" M1 (macOS Sonoma)</span>
                                                                    <span class="badge bg-primary text-white"
                                                                        style="font-size: 0.65rem;">Phiên hiện
                                                                        tại</span>
                                                                </div>
                                                                <div class="text-muted" style="font-size: 0.72rem;">
                                                                    <span>TP. Hồ Chí Minh, Việt Nam</span> • <span>IP:
                                                                        14.161.42.88</span> • <span>Chrome 128.0</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <span
                                                            class="badge bg-success-subtle text-success border border-success-subtle">Trực
                                                            tuyến</span>
                                                    </div>

                                                    <!-- Session 2: Mobile Device -->
                                                    <div
                                                        class="device-session-item d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-2">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="p-2 bg-light rounded border text-secondary">
                                                                <i class="bi bi-phone fs-4"></i>
                                                            </div>
                                                            <div>
                                                                <div class="fw-bold text-dark small">iPhone 15 Pro Max
                                                                    (iOS 18.0)</div>
                                                                <div class="text-muted" style="font-size: 0.72rem;">
                                                                    <span>Hà Nội, Việt Nam</span> • <span>IP:
                                                                        113.190.23.41</span> • <span>Safari
                                                                        Mobile</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <span class="text-muted small" style="font-size: 0.72rem;">3
                                                                giờ trước</span>
                                                            <button type="button" class="btn btn-sm btn-outline-danger"
                                                                style="font-size: 0.72rem; padding: 0.2rem 0.5rem;"
                                                                onclick="this.closest('.device-session-item').remove(); alert('Đã thu hồi phiên đăng nhập thiết bị thành công!');">
                                                                Đăng xuất
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ==========================================
                             5. NGÀY & GIỜ, ĐỊNH DẠNG VÙNG
                             ========================================== -->
                                        <div class="setting-section-card" id="sec-datetime">
                                            <div class="setting-section-header">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-clock-history fs-5 text-info"></i>
                                                    <h2 class="h6 fw-bold mb-0 text-dark">5. Ngày, Giờ & Định dạng vùng
                                                        (Localization)</h2>
                                                </div>
                                                <span class="badge bg-info-subtle text-info">GMT+7 (ICT)</span>
                                            </div>
                                            <div class="setting-section-body">
                                                <div class="row g-3">
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Múi giờ hệ
                                                            thống (Timezone)</label>
                                                        <select class="form-select">
                                                            <option value="Asia/Ho_Chi_Minh" selected>(GMT+07:00)
                                                                Bangkok, Hanoi, Jakarta (ICT)</option>
                                                            <option value="Asia/Singapore">(GMT+08:00) Singapore, Kuala
                                                                Lumpur</option>
                                                            <option value="Asia/Tokyo">(GMT+09:00) Tokyo, Seoul</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Định dạng
                                                            ngày (Date Format)</label>
                                                        <select class="form-select">
                                                            <option value="dd/MM/yyyy" selected>DD/MM/YYYY (Ví dụ:
                                                                12/09/2026)</option>
                                                            <option value="yyyy-MM-dd">YYYY-MM-DD (Chuẩn ISO:
                                                                2026-09-12)</option>
                                                            <option value="MM/dd/yyyy">MM/DD/YYYY (Chuẩn Mỹ: 09/12/2026)
                                                            </option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Định dạng
                                                            thời gian (Time Format)</label>
                                                        <select class="form-select">
                                                            <option value="24" selected>24 Giờ (Ví dụ: 14:30:00)
                                                            </option>
                                                            <option value="12">12 Giờ (Ví dụ: 02:30:00 PM)</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Đơn vị
                                                            tiền tệ chính (Currency)</label>
                                                        <select class="form-select">
                                                            <option value="VND" selected>VND - Đồng Việt Nam (₫)
                                                            </option>
                                                            <option value="USD">USD - United States Dollar ($)</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ==========================================
                             6. CẤU HÌNH EMAIL SMTP GATEWAY
                             ========================================== -->
                                        <div class="setting-section-card" id="sec-smtp">
                                            <div class="setting-section-header">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-envelope-at fs-5 text-primary"></i>
                                                    <h2 class="h6 fw-bold mb-0 text-dark">6. Cấu hình Email SMTP Gateway
                                                        Doanh nghiệp</h2>
                                                </div>
                                                <span class="badge bg-success-subtle text-success">SendGrid TLS</span>
                                            </div>
                                            <div class="setting-section-body">
                                                <p class="text-muted small mb-3">
                                                    Cấu hình máy chủ SMTP chịu trách nhiệm gửi email tự động (Mã xác
                                                    thực OTP, Phiếu lương PDF, Thông báo HĐLĐ).
                                                </p>
                                                <div class="row g-3">
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Máy chủ
                                                            SMTP (Host) <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="smtpHost"
                                                            value="smtp.sendgrid.net">
                                                    </div>
                                                    <div class="col-12 col-md-3">
                                                        <label class="form-label small fw-semibold text-dark">Cổng
                                                            (Port) <span class="text-danger">*</span></label>
                                                        <input type="number" class="form-control" name="smtpPort"
                                                            value="587">
                                                    </div>
                                                    <div class="col-12 col-md-3">
                                                        <label class="form-label small fw-semibold text-dark">Phương
                                                            thức mã hóa</label>
                                                        <select class="form-select" name="smtpEncryption">
                                                            <option value="TLS" selected>TLS / STARTTLS</option>
                                                            <option value="SSL">SSL</option>
                                                            <option value="NONE">Không mã hóa</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Tài khoản
                                                            SMTP (Username)</label>
                                                        <input type="text" class="form-control" name="smtpUsername"
                                                            value="apikey">
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Mật khẩu /
                                                            Khóa API SMTP</label>
                                                        <input type="password" class="form-control" name="smtpPassword"
                                                            value="SG.eK892jklA91kdLm98273hjs98123jkasd">
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Email
                                                            người gửi mặc định</label>
                                                        <input type="email" class="form-control" name="smtpSenderEmail"
                                                            value="notification@miximoi.vn">
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <label class="form-label small fw-semibold text-dark">Tên hiển
                                                            thị người gửi</label>
                                                        <input type="text" class="form-control" name="smtpSenderName"
                                                            value="MIXIMOI HRM Enterprise Notification">
                                                    </div>
                                                </div>
                                                <div
                                                    class="d-flex flex-wrap align-items-center justify-content-between gap-2 mt-3 pt-3 border-top">
                                                    <div class="d-flex align-items-center gap-2 text-success small">
                                                        <i class="bi bi-check-circle-fill"></i>
                                                        <span>Kết nối máy chủ SMTP hoạt động bình thường (Độ trễ:
                                                            42ms)</span>
                                                    </div>
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                        onclick="alert('Đã gửi email thử nghiệm thành công tới admin@miximoi.vn!');">
                                                        <i class="bi bi-send me-1"></i> Gửi email thử nghiệm (Test)
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ==========================================
                             7. TÍCH HỢP & RESTFUL API
                             ========================================== -->
                                        <div class="setting-section-card" id="sec-api-integrations">
                                            <div class="setting-section-header">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-cpu fs-5 text-purple"></i>
                                                    <h2 class="h6 fw-bold mb-0 text-dark">7. Tích hợp Hệ thống Ngoại vi
                                                        & RESTful API</h2>
                                                </div>
                                                <span class="badge bg-primary-subtle text-primary">API v3.0</span>
                                            </div>
                                            <div class="setting-section-body">
                                                <!-- Production API Key -->
                                                <div class="mb-4">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <label class="form-label small fw-semibold text-dark mb-0">Khóa
                                                            Live Production API Key</label>
                                                        <span class="badge bg-success-subtle text-success">Read/Write
                                                            Scope</span>
                                                    </div>
                                                    <div class="text-muted small mb-2" style="font-size: 0.72rem;">Dùng
                                                        để kết nối ứng dụng di động iOS/Android và đồng bộ với hệ thống
                                                        kế toán MISA/SAP.</div>
                                                    <div class="api-key-box mb-2">
                                                        <span
                                                            id="apiKeyText">mxm_live_9a8bcd02ea9871fc3e54721089ad1</span>
                                                        <div class="d-flex gap-2">
                                                            <button type="button"
                                                                class="btn btn-sm btn-dark text-white p-1"
                                                                title="Sao chép"
                                                                onclick="navigator.clipboard.writeText('mxm_live_9a8bcd02ea9871fc3e54721089ad1'); alert('Đã sao chép API Key vào clipboard!');">
                                                                <i class="bi bi-clipboard"></i> Sao chép
                                                            </button>
                                                            <button type="button"
                                                                class="btn btn-sm btn-dark text-warning p-1"
                                                                title="Tạo lại"
                                                                onclick="confirm('Bạn có chắc chắn muốn thu hồi và tạo mới API Key?') && alert('Đã tái tạo API Key mới thành công!');">
                                                                <i class="bi bi-arrow-repeat"></i> Tạo mới
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Hardware Biometric Device (ZKTeco) -->
                                                <div class="p-3 bg-light rounded-3 border mb-3">
                                                    <div
                                                        class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-2">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <i class="bi bi-fingerprint fs-4 text-primary"></i>
                                                            <div>
                                                                <div class="fw-bold text-dark small">Máy chấm công vân
                                                                    tay & FaceID (ZKTeco BioTime 8.5)</div>
                                                                <div class="text-muted" style="font-size: 0.72rem;">IP
                                                                    Nội bộ: <code>192.168.1.200:8088</code> • Địa điểm:
                                                                    Trụ sở Landmark 81</div>
                                                            </div>
                                                        </div>
                                                        <span
                                                            class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                                            <span class="vssid-status-dot"></span> Đã kết nối
                                                        </span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top"
                                                        style="font-size: 0.74rem;">
                                                        <span class="text-muted">Đồng bộ lần cuối: 10 phút trước (3.240
                                                            logs)</span>
                                                        <button type="button" class="btn btn-sm btn-outline-primary"
                                                            style="font-size: 0.72rem;"
                                                            onclick="alert('Đang đồng bộ dữ liệu chấm công từ ZKTeco BioTime...');">
                                                            <i class="bi bi-arrow-repeat me-1"></i> Đồng bộ ngay
                                                        </button>
                                                    </div>
                                                </div>

                                                <!-- Slack / Microsoft Teams Webhook -->
                                                <div class="p-3 bg-light rounded-3 border">
                                                    <div
                                                        class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-2">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <i class="bi bi-slack fs-4 text-warning"></i>
                                                            <div>
                                                                <div class="fw-bold text-dark small">Kênh Webhook cảnh
                                                                    báo (Slack #hrm-alerts)</div>
                                                                <div class="text-muted" style="font-size: 0.72rem;">Gửi
                                                                    cảnh báo đơn xin nghỉ phép khẩn cấp và biến động
                                                                    nhân sự vào kênh chung.</div>
                                                            </div>
                                                        </div>
                                                        <span
                                                            class="badge bg-success-subtle text-success border border-success-subtle">Hoạt
                                                            động tốt</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top"
                                                        style="font-size: 0.74rem;">
                                                        <span class="text-muted">URL:
                                                            <code>https://hooks.slack.com/services/T0123...</code></span>
                                                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                                            style="font-size: 0.72rem;"
                                                            onclick="alert('Đã gửi thông điệp kiểm tra tới kênh Slack #hrm-alerts!');">
                                                            <i class="bi bi-broadcast me-1"></i> Kiểm tra Webhook
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ==========================================
                             8. SAO LƯU DỮ LIỆU TỰ ĐỘNG (AWS S3)
                             ========================================== -->
                                        <div class="setting-section-card" id="sec-backup">
                                            <div class="setting-section-header">
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-cloud-arrow-up fs-5 text-success"></i>
                                                    <h2 class="h6 fw-bold mb-0 text-dark">8. Sao lưu dữ liệu tự động &
                                                        Khôi phục thảm họa</h2>
                                                </div>
                                                <span class="badge bg-success-subtle text-success">AWS S3
                                                    Encrypted</span>
                                            </div>
                                            <div class="setting-section-body">
                                                <div class="row g-3 mb-3">
                                                    <div class="col-12 col-md-4">
                                                        <div class="p-3 bg-light rounded-3 border text-center">
                                                            <div class="text-muted small" style="font-size: 0.72rem;">
                                                                DUNG LƯỢNG CSDL HIỆN TẠI</div>
                                                            <div class="fs-4 fw-bold text-dark my-1">1.42 GB</div>
                                                            <span class="badge bg-primary-subtle text-primary"
                                                                style="font-size: 0.68rem;">MySQL 8.0 + Files</span>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-md-4">
                                                        <div class="p-3 bg-light rounded-3 border text-center">
                                                            <div class="text-muted small" style="font-size: 0.72rem;">
                                                                LỊCH SAO LƯU TỰ ĐỘNG</div>
                                                            <div class="fs-4 fw-bold text-success my-1">03:00 AM</div>
                                                            <span class="badge bg-success-subtle text-success"
                                                                style="font-size: 0.68rem;">Hàng ngày (Daily)</span>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-md-4">
                                                        <div class="p-3 bg-light rounded-3 border text-center">
                                                            <div class="text-muted small" style="font-size: 0.72rem;">
                                                                BẢN SAO LƯU GẦN NHẤT</div>
                                                            <div class="fs-4 fw-bold text-primary my-1">12/09/2026</div>
                                                            <span class="badge bg-info-subtle text-info"
                                                                style="font-size: 0.68rem;">Snapshot Success</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="p-3 bg-light rounded-3 border mb-3"
                                                    style="font-size: 0.78rem;">
                                                    <div class="d-flex align-items-center gap-2 fw-bold text-dark mb-1">
                                                        <i class="bi bi-shield-check text-success fs-5"></i>
                                                        <span>Tiêu chuẩn Tuân thủ & An toàn dữ liệu</span>
                                                    </div>
                                                    <div class="text-muted mb-2">
                                                        Toàn bộ dữ liệu nhân sự, bảng lương và hợp đồng được tự động mã
                                                        hóa chuẩn <strong>AES-256 GCM</strong> và sao chép đa vùng
                                                        (Multi-Region Replication) trên AWS S3 Singapore, đáp ứng đầy đủ
                                                        tiêu chuẩn quốc tế <strong>ISO 27001</strong> và <strong>SOC 2
                                                            Type II</strong>.
                                                    </div>
                                                    <div class="d-flex flex-wrap gap-3">
                                                        <span><i class="bi bi-check-circle-fill text-success me-1"></i>
                                                            Bucket: <code>miximoi-hrm-backup-encrypted</code></span>
                                                        <span><i class="bi bi-check-circle-fill text-success me-1"></i>
                                                            Khóa mã hóa: <code>KMS Key ID: 89ab-cd12-78fe</code></span>
                                                    </div>
                                                </div>

                                                <div class="d-flex flex-wrap gap-2">
                                                    <button type="button"
                                                        class="btn btn-sm btn-primary shadow-sm d-flex align-items-center gap-1"
                                                        onclick="alert('Bắt đầu tiến trình tạo Snapshot CSDL tức thì...');">
                                                        <i class="bi bi-cloud-arrow-up-fill"></i> Sao lưu ngay lập tức
                                                        (Snapshot)
                                                    </button>
                                                    <button type="button"
                                                        class="btn btn-sm btn-outline-secondary d-flex align-items-center gap-1"
                                                        onclick="alert('Đang tải tệp miximoi_backup_20260912_0300.sql.gz (1.42 GB)...');">
                                                        <i class="bi bi-download"></i> Tải bản sao lưu gần nhất (1.42
                                                        GB)
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Sticky Footer Save Bar -->
                                        <div
                                            class="settings-sticky-footer d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                                            <span class="text-muted small">
                                                <i class="bi bi-info-circle me-1 text-primary"></i>
                                                Các thay đổi cài đặt tài khoản và giao diện sẽ được áp dụng ngay lập tức
                                                cho phiên làm việc.
                                            </span>
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/settings?view=profile"
                                                    class="btn btn-outline-secondary btn-sm">Hủy thay đổi</a>
                                                <button type="submit"
                                                    class="btn btn-primary btn-sm shadow-sm d-flex align-items-center gap-2">
                                                    <i class="bi bi-floppy-fill"></i>
                                                    <span>Lưu thay đổi</span>
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </main>

                        <!-- Footer -->
                        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
                <script>
                    function selectTheme(element, themeName) {
                        document.querySelectorAll('.theme-option-card').forEach(card => card.classList.remove('active'));
                        element.classList.add('active');
                        if (window.selectAppTheme) {
                            window.selectAppTheme(themeName);
                        }
                    }

                    // Highlight active card on page load
                    document.addEventListener('DOMContentLoaded', () => {
                        const curTheme = localStorage.getItem('miximoi_theme') || 'light';
                        document.querySelectorAll('.theme-option-card').forEach(card => {
                            if (card.getAttribute('onclick') && card.getAttribute('onclick').includes("'" + curTheme + "'")) {
                                document.querySelectorAll('.theme-option-card').forEach(c => c.classList.remove('active'));
                                card.classList.add('active');
                            }
                        });
                    });
                </script>
            </body>

            </html>