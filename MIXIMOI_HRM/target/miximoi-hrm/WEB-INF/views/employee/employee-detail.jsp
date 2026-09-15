<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ: ${employee.fullName} — MIXIMOI HRM & PAYROLL</title>
    <meta name="description" content="Hồ sơ nhân sự ${employee.fullName} - Mã ${employee.employeeCode}">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        .profile-hero {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 60%, #3b82f6 100%);
            border-radius: 18px; padding: 2rem 2rem 0; margin-bottom: 0;
            position: relative; overflow: hidden;
        }
        .profile-hero::before {
            content: ""; position: absolute; top: -40%; right: -10%; width: 380px; height: 380px;
            background: radial-gradient(circle, rgba(255,255,255,0.1), transparent 70%);
            border-radius: 50%;
        }
        .profile-avatar-xl {
            width: 88px; height: 88px; border-radius: 50%;
            background: linear-gradient(135deg, #60a5fa, #93c5fd);
            color: #fff; font-size: 2.2rem; font-weight: 800;
            display: flex; align-items: center; justify-content: center;
            border: 4px solid rgba(255,255,255,0.4);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .profile-hero-body {
            display: flex; align-items: flex-end; gap: 1.5rem;
            justify-content: space-between; flex-wrap: wrap;
        }
        .profile-hero-name { color: #fff; font-size: 1.6rem; font-weight: 800; margin: 0; line-height: 1.1; }
        .profile-hero-code {
            background: rgba(255,255,255,0.18); color: #e0e7ff;
            border-radius: 6px; padding: 2px 10px; font-size: 0.82rem;
            font-weight: 700; font-family: monospace; border: 1px solid rgba(255,255,255,0.25);
        }
        .profile-hero-role { color: #bfdbfe; font-size: 0.9rem; margin-top: 4px; }
        .profile-hero-tabs {
            display: flex; gap: 6px; margin-top: 1.5rem;
        }
        .profile-tab {
            padding: 10px 22px; border-radius: 10px 10px 0 0;
            font-size: 0.86rem; font-weight: 600; color: rgba(255,255,255,0.72);
            cursor: pointer; transition: all 0.2s ease; border: none; background: transparent;
            text-decoration: none; display: inline-flex; align-items: center; outline: none;
        }
        .profile-tab.active {
            background: #fff; color: #1e3a8a; font-weight: 700;
            box-shadow: 0 -4px 14px rgba(0,0,0,0.06);
        }
        .profile-tab:hover:not(.active) {
            background: rgba(255,255,255,0.14); color: #fff;
        }

        .profile-tab-pane {
            display: none;
            opacity: 0;
            transform: translateY(6px);
            transition: opacity 0.22s ease, transform 0.22s ease;
        }
        .profile-tab-pane.active {
            display: block;
            opacity: 1;
            transform: translateY(0);
        }

        /* Info row */
        .info-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            box-shadow: 0 2px 10px rgba(15,23,42,0.04); overflow: hidden; margin-bottom: 1rem;
        }
        .info-card-header {
            background: #f8fafc; padding: 0.85rem 1.25rem;
            border-bottom: 1px solid #f1f5f9;
            display: flex; align-items: center; justify-content: space-between;
        }
        .info-card-header-title {
            display: flex; align-items: center; gap: 10px;
        }
        .info-card-header i { color: #2563eb; font-size: 1.05rem; }
        .info-card-title { font-weight: 700; font-size: 0.9rem; color: #1e293b; }
        .info-card-body { padding: 1.1rem 1.25rem; }
        .info-row {
            display: flex; align-items: flex-start; gap: 0.5rem;
            padding: 0.55rem 0; border-bottom: 1px solid #f8fafc; font-size: 0.875rem;
        }
        .info-row:last-child { border-bottom: none; padding-bottom: 0; }
        .info-label { flex: 0 0 170px; color: #64748b; font-size: 0.82rem; }
        .info-value { flex: 1; color: #1e293b; font-weight: 500; }

        /* Status pills */
        .sp-active   { display:inline-flex; align-items:center; gap:5px; background:#ecfdf5; color:#059669; border:1px solid #a7f3d0; border-radius:999px; padding:4px 14px; font-size:0.82rem; font-weight:700; }
        .sp-onleave  { display:inline-flex; align-items:center; gap:5px; background:#fffbeb; color:#d97706; border:1px solid #fde68a; border-radius:999px; padding:4px 14px; font-size:0.82rem; font-weight:700; }
        .sp-inactive { display:inline-flex; align-items:center; gap:5px; background:#fef2f2; color:#dc2626; border:1px solid #fecaca; border-radius:999px; padding:4px 14px; font-size:0.82rem; font-weight:700; }

        .badge-dept {
            background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
            border-radius: 7px; padding: 2px 10px; font-size: 0.8rem; font-weight: 600;
        }

        /* Contract Type Badges */
        .badge-contract-indefinite { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; font-size: 0.76rem; padding: 3px 10px; border-radius: 6px; font-weight: 600; }
        .badge-contract-fixed      { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; font-size: 0.76rem; padding: 3px 10px; border-radius: 6px; font-weight: 600; }
        .badge-contract-probation  { background: #fffbeb; color: #b45309; border: 1px solid #fde68a; font-size: 0.76rem; padding: 3px 10px; border-radius: 6px; font-weight: 600; }
        .badge-contract-seasonal   { background: #f5f3ff; color: #6d28d9; border: 1px solid #ddd6fe; font-size: 0.76rem; padding: 3px 10px; border-radius: 6px; font-weight: 600; }
    </style>
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="employees" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Breadcrumb & Actions -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-3">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" style="font-size:0.82rem;">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employees" class="text-decoration-none">Nhân viên</a></li>
                        <li class="breadcrumb-item active">${employee.fullName} (${employee.employeeCode})</li>
                    </ol>
                </nav>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/employees" class="btn btn-light btn-sm border px-3" style="border-radius:9px; font-size:0.83rem;">
                        <i class="bi bi-arrow-left me-1"></i> Quay lại
                    </a>
                    <button type="button" class="btn btn-light btn-sm border px-3" style="border-radius:9px; font-size:0.83rem;" onclick="window.print()">
                        <i class="bi bi-printer me-1"></i> In hồ sơ
                    </button>
                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                        <a href="${pageContext.request.contextPath}/employees?action=edit&id=${employee.id}"
                           class="btn btn-primary btn-sm px-3" style="border-radius:9px; font-size:0.83rem;">
                            <i class="bi bi-pencil-square me-1"></i> Chỉnh sửa hồ sơ
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${param.success eq 'contract_added'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    Đã lập hợp đồng lao động mới thành công cho nhân sự <strong>${employee.fullName}</strong>!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Profile Hero Banner -->
            <div class="profile-hero mb-3">
                <div class="profile-hero-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="profile-avatar-xl">
                            <c:choose>
                                <c:when test="${not empty employee.fullName}">${employee.fullName.substring(0,1).toUpperCase()}</c:when>
                                <c:otherwise>NV</c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <div class="d-flex align-items-center gap-2 flex-wrap">
                                <h2 class="profile-hero-name">${employee.fullName}</h2>
                                <span class="profile-hero-code">${employee.employeeCode}</span>
                            </div>
                            <div class="profile-hero-role">
                                <i class="bi bi-briefcase me-1"></i>${employee.positionName}
                                &nbsp;•&nbsp;
                                <i class="bi bi-building me-1"></i>${employee.departmentName}
                            </div>
                        </div>
                    </div>
                    <div class="mb-2">
                        <c:choose>
                            <c:when test="${employee.status eq 'ACTIVE'}">
                                <span class="sp-active"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Đang công tác</span>
                            </c:when>
                            <c:when test="${employee.status eq 'ON_LEAVE'}">
                                <span class="sp-onleave"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Nghỉ tạm thời</span>
                            </c:when>
                            <c:otherwise>
                                <span class="sp-inactive"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Đã nghỉ việc</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 3 TABS -->
                <div class="profile-hero-tabs">
                    <button type="button" class="profile-tab active" data-tab="tabProfile">
                        <i class="bi bi-person-circle me-1"></i> Hồ sơ cá nhân
                    </button>
                    <button type="button" class="profile-tab" data-tab="tabJob">
                        <i class="bi bi-briefcase-fill me-1"></i> Công tác & Vị trí
                    </button>
                    <button type="button" class="profile-tab" data-tab="tabContract">
                        <i class="bi bi-file-earmark-text-fill me-1"></i> Hợp đồng
                        <span class="badge rounded-pill bg-light text-primary ms-1" style="font-size:0.72rem; font-weight:700;">${not empty contracts ? contracts.size() : 0}</span>
                    </button>
                </div>
            </div>

            <!-- TAB CONTENT CONTAINER -->
            <div class="profile-tab-content-container">

                <!-- ==================== TAB 1: HỒ SƠ CÁ NHÂN ==================== -->
                <div class="profile-tab-pane active" id="tabProfile">
                    <div class="row g-3">
                        <!-- Personal Info -->
                        <div class="col-lg-6">
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-header-title">
                                        <i class="bi bi-person-vcard-fill"></i>
                                        <span class="info-card-title">Thông tin lý lịch cá nhân</span>
                                    </div>
                                </div>
                                <div class="info-card-body">
                                    <div class="info-row">
                                        <span class="info-label">Mã định danh hệ thống</span>
                                        <span class="info-value" style="font-family:monospace; color:#2563eb; font-weight:700;">EMP-#${employee.id}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Mã nhân viên</span>
                                        <span class="info-value fw-bold text-dark">${employee.employeeCode}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Họ và tên đầy đủ</span>
                                        <span class="info-value fw-bold">${employee.fullName}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Ngày sinh</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${employee.dateOfBirth != null}">${employee.dateOfBirth}</c:when>
                                                <c:otherwise><span class="text-muted fst-italic">Chưa cập nhật</span></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Giới tính</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${employee.gender eq 'MALE'}"><i class="bi bi-gender-male text-primary me-1"></i>Nam</c:when>
                                                <c:when test="${employee.gender eq 'FEMALE'}"><i class="bi bi-gender-female text-danger me-1"></i>Nữ</c:when>
                                                <c:otherwise><i class="bi bi-gender-ambiguous text-info me-1"></i>Khác</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Thời điểm tiếp nhận</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${employee.createdAt != null}">${employee.createdAt}</c:when>
                                                <c:otherwise>${employee.startDate}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Contact Info -->
                        <div class="col-lg-6">
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-header-title">
                                        <i class="bi bi-telephone-fill"></i>
                                        <span class="info-card-title">Thông tin liên lạc & Địa chỉ</span>
                                    </div>
                                </div>
                                <div class="info-card-body">
                                    <div class="info-row">
                                        <span class="info-label">Email làm việc</span>
                                        <span class="info-value">
                                            <a href="mailto:${employee.email}" class="text-primary text-decoration-none">
                                                <i class="bi bi-envelope me-1"></i>${employee.email}
                                            </a>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Số điện thoại liên hệ</span>
                                        <span class="info-value">
                                            <a href="tel:${employee.phone}" class="text-primary text-decoration-none">
                                                <i class="bi bi-telephone-outbound me-1"></i>${employee.phone}
                                            </a>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Địa chỉ cư trú thường trú</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty employee.address}">${employee.address}</c:when>
                                                <c:otherwise><span class="text-muted fst-italic">Chưa cập nhật</span></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Cập nhật lần cuối</span>
                                        <span class="info-value text-muted" style="font-size:0.83rem;">
                                            <c:choose>
                                                <c:when test="${employee.updatedAt != null}">${employee.updatedAt}</c:when>
                                                <c:otherwise>Chưa có thay đổi</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ==================== TAB 2: CÔNG TÁC & VỊ TRÍ ==================== -->
                <div class="profile-tab-pane" id="tabJob">
                    <div class="row g-3">
                        <!-- Job & Org Info -->
                        <div class="col-lg-6">
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-header-title">
                                        <i class="bi bi-building-gear"></i>
                                        <span class="info-card-title">Vị trí & Tổ chức công tác</span>
                                    </div>
                                </div>
                                <div class="info-card-body">
                                    <div class="info-row">
                                        <span class="info-label">Phòng ban công tác</span>
                                        <span class="info-value">
                                            <span class="badge-dept">${employee.departmentName}</span>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Chức vụ đảm nhiệm</span>
                                        <span class="info-value fw-bold text-dark">${employee.positionName}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Loại hình nhân sự</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${employee.employeeTypeId == 1}">Nhân viên chính thức</c:when>
                                                <c:when test="${employee.employeeTypeId == 2}">Nhân viên thử việc</c:when>
                                                <c:when test="${employee.employeeTypeId == 3}">Nhân viên thời vụ</c:when>
                                                <c:otherwise>Cộng tác viên</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Ngày vào công ty</span>
                                        <span class="info-value fw-bold text-primary">${employee.startDate}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Trạng thái công tác</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${employee.status eq 'ACTIVE'}"><span class="sp-active" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Đang làm việc bình thường</span></c:when>
                                                <c:when test="${employee.status eq 'ON_LEAVE'}"><span class="sp-onleave" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Đang nghỉ tạm thời</span></c:when>
                                                <c:otherwise><span class="sp-inactive" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Đã chấm dứt hợp đồng</span></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Stats & Danger Zone -->
                        <div class="col-lg-6">
                            <!-- Quick Stats -->
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-header-title">
                                        <i class="bi bi-bar-chart-fill"></i>
                                        <span class="info-card-title">Thống kê công tác & Ngày phép</span>
                                    </div>
                                </div>
                                <div class="info-card-body">
                                    <div class="row g-2">
                                        <div class="col-6">
                                            <div style="background:#f8fafc; border-radius:12px; padding:1rem; text-align:center; border:1px solid #f1f5f9;">
                                                <div style="font-size:1.6rem; font-weight:800; color:#2563eb;">${not empty remainingLeaveDays ? remainingLeaveDays : 12}</div>
                                                <div style="font-size:0.75rem; color:#64748b; font-weight:600; margin-top:2px;">Ngày nghỉ phép còn lại</div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div style="background:#f8fafc; border-radius:12px; padding:1rem; text-align:center; border:1px solid #f1f5f9;">
                                                <div style="font-size:1.6rem; font-weight:800; color:#059669;">${not empty monthsOfService ? monthsOfService : 0}</div>
                                                <div style="font-size:0.75rem; color:#64748b; font-weight:600; margin-top:2px;">Số tháng thâm niên</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Danger Zone -->
                            <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                <div class="info-card" style="border-color:#fecaca;">
                                    <div class="info-card-header" style="background:#fef2f2; border-bottom-color:#fecaca;">
                                        <div class="info-card-header-title">
                                            <i class="bi bi-shield-exclamation text-danger"></i>
                                            <span class="info-card-title" style="color:#dc2626;">Tác vụ quản trị nhân sự</span>
                                        </div>
                                    </div>
                                    <div class="info-card-body">
                                        <p class="text-muted mb-3" style="font-size:0.83rem;">
                                            Vô hiệu hóa sẽ chuyển nhân viên này sang trạng thái <em>Đã nghỉ việc</em>. Dữ liệu lịch sử lương và công vẫn được lưu trữ nguyên vẹn.
                                        </p>
                                        <button type="button" class="btn btn-outline-danger btn-sm px-3" style="border-radius:9px; font-size:0.83rem; font-weight:600;" onclick="confirmDeactivate()">
                                            <i class="bi bi-person-x me-1"></i> Vô hiệu hóa nhân viên
                                        </button>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- ==================== TAB 3: HỢP ĐỒNG ==================== -->
                <div class="profile-tab-pane" id="tabContract">
                    <div class="info-card">
                        <div class="info-card-header">
                            <div class="info-card-header-title">
                                <i class="bi bi-file-earmark-text-fill"></i>
                                <span class="info-card-title">Hợp đồng lao động (${not empty contracts ? contracts.size() : 0})</span>
                            </div>
                            <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                <button type="button" class="btn btn-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#addContractModal" style="border-radius:8px; font-weight:600; font-size:0.82rem;">
                                    <i class="bi bi-plus-lg me-1"></i> Tạo hợp đồng mới
                                </button>
                            </c:if>
                        </div>
                        <div class="info-card-body p-0">
                            <c:choose>
                                <c:when test="${empty contracts}">
                                    <!-- Empty state -->
                                    <div class="text-center py-5">
                                        <div style="width:68px; height:68px; border-radius:50%; background:#eff6ff; color:#2563eb; display:flex; align-items:center; justify-content:center; margin:0 auto 1.1rem; font-size:2rem;">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </div>
                                        <h6 class="fw-bold text-dark mb-1">Chưa có hợp đồng lao động</h6>
                                        <p class="text-muted" style="font-size:0.83rem; max-width:420px; margin:0 auto 1.25rem;">
                                            Nhân sự <strong>${employee.fullName}</strong> hiện chưa có thông tin hợp đồng lao động chính thức nào trong hồ sơ.
                                        </p>
                                        <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                            <button type="button" class="btn btn-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#addContractModal" style="border-radius:9px; font-weight:600;">
                                                <i class="bi bi-plus-lg me-1"></i> Tạo hợp đồng ngay
                                            </button>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Contracts Table -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0" style="font-size:0.86rem;">
                                            <thead style="background:#f8fafc; font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px; color:#64748b;">
                                                <tr>
                                                    <th class="ps-4">Mã Hợp Đồng</th>
                                                    <th>Loại Hợp Đồng</th>
                                                    <th>Thời Hạn Hiệu Lực</th>
                                                    <th>Lương Cơ Bản</th>
                                                    <th>Trạng Thái</th>
                                                    <th>Ghi Chú</th>
                                                    <th class="text-end pe-4">Thao Tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="c" items="${contracts}">
                                                    <tr>
                                                        <td class="ps-4">
                                                            <div class="fw-bold text-primary" style="font-family:monospace;">${c.contractCode}</div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${c.contractType eq 'INDEFINITE'}">
                                                                    <span class="badge-contract-indefinite">HĐ Không xác định thời hạn</span>
                                                                </c:when>
                                                                <c:when test="${c.contractType eq 'FIXED_TERM'}">
                                                                    <span class="badge-contract-fixed">HĐ Xác định thời hạn</span>
                                                                </c:when>
                                                                <c:when test="${c.contractType eq 'PROBATION'}">
                                                                    <span class="badge-contract-probation">HĐ Thử việc</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge-contract-seasonal">HĐ Thời vụ / CTV</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="fw-semibold text-dark">${c.startDate}</div>
                                                            <div class="text-muted" style="font-size:0.75rem;">
                                                                <c:choose>
                                                                    <c:when test="${c.endDate != null}">đến ${c.endDate}</c:when>
                                                                    <c:otherwise>Vô thời hạn</c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="fw-bold text-success">
                                                                <fmt:formatNumber value="${c.baseSalary}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${c.status eq 'ACTIVE'}">
                                                                    <span class="sp-active" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Đang hiệu lực</span>
                                                                </c:when>
                                                                <c:when test="${c.status eq 'EXPIRING_SOON'}">
                                                                    <span class="sp-onleave" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Sắp hết hạn</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="sp-inactive" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Đã kết thúc</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-muted" style="font-size:0.8rem; max-width:180px;">
                                                            ${not empty c.notes ? c.notes : '—'}
                                                        </td>
                                                        <td class="text-end pe-4">
                                                            <a href="${pageContext.request.contextPath}/contracts" class="btn btn-light btn-sm border px-2 py-1" style="border-radius:7px; font-size:0.78rem;" title="Xem tại danh sách Hợp đồng">
                                                                <i class="bi bi-box-arrow-up-right me-1"></i> Quản lý
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>

<!-- Add Contract Modal for this Employee -->
<div class="modal fade" id="addContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <div class="modal-header border-0 pb-0" style="background:#f8fafc; padding:1.25rem 1.5rem;">
                <div>
                    <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-file-earmark-plus-fill text-primary" style="font-size:1.15rem;"></i>
                        Tạo hợp đồng lao động mới
                    </h6>
                    <p class="text-muted mb-0" style="font-size:0.8rem;">
                        Nhân sự: <strong>${employee.fullName}</strong> (${employee.employeeCode}) — ${employee.departmentName}
                    </p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/contracts">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="employeeId" value="${employee.id}">
                <input type="hidden" name="from" value="employeeDetail">

                <div class="modal-body px-4 py-3">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.82rem;">Số / Mã Hợp Đồng <span class="text-danger">*</span></label>
                            <input type="text" name="contractCode" class="form-control form-control-sm" value="${not empty nextContractCode ? nextContractCode : 'HD001'}" required style="border-radius:8px;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.82rem;">Loại Hợp Đồng <span class="text-danger">*</span></label>
                            <select name="contractType" class="form-select form-select-sm" required style="border-radius:8px;">
                                <option value="INDEFINITE">Hợp đồng không xác định thời hạn</option>
                                <option value="FIXED_TERM" selected>Hợp đồng xác định thời hạn (1 - 3 năm)</option>
                                <option value="PROBATION">Hợp đồng thử việc</option>
                                <option value="SEASONAL">Hợp đồng thời vụ / CTV</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.82rem;">Ngày Bắt Đầu Hiệu Lực <span class="text-danger">*</span></label>
                            <input type="date" name="startDate" class="form-control form-control-sm" value="${employee.startDate}" required style="border-radius:8px;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.82rem;">Ngày Kết Thúc (để trống nếu vô thời hạn)</label>
                            <input type="date" name="endDate" class="form-control form-control-sm" style="border-radius:8px;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.82rem;">Lương Cơ Bản (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" name="baseSalary" class="form-control form-control-sm" placeholder="VD: 15000000" min="0" step="100000" required style="border-radius:8px;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.82rem;">Trạng Thái Hợp Đồng <span class="text-danger">*</span></label>
                            <select name="status" class="form-select form-select-sm" style="border-radius:8px;">
                                <option value="ACTIVE" selected>Đang hiệu lực (ACTIVE)</option>
                                <option value="EXPIRING_SOON">Sắp hết hạn (EXPIRING_SOON)</option>
                                <option value="EXPIRED">Đã hết hạn (EXPIRED)</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold" style="font-size:0.82rem;">Ghi Chú & Điều Khoản Đặc Biệt</label>
                            <textarea name="notes" class="form-control form-control-sm" rows="2" placeholder="Nhập ghi chú thêm nếu có..." style="border-radius:8px;"></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 gap-2">
                    <button type="button" class="btn btn-light btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm px-4" style="border-radius:9px; font-weight:600;">
                        <i class="bi bi-check-lg me-1"></i> Lưu Hợp Đồng
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Deactivate Modal -->
<div class="modal fade" id="deactivateModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:400px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;">
            <div class="modal-header border-0" style="background:#fef2f2; padding:1.25rem 1.5rem 0.75rem;">
                <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> Xác nhận vô hiệu hóa
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body px-4 py-3" style="font-size:0.88rem;">
                Bạn có chắc muốn vô hiệu hóa nhân sự <strong>${employee.fullName}</strong> (${employee.employeeCode})?
            </div>
            <div class="modal-footer border-0 px-4 pb-4 gap-2">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/employees" class="d-inline">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${employee.id}">
                    <button type="submit" class="btn btn-danger btn-sm px-4">Xác nhận vô hiệu hóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    function confirmDeactivate() {
        new bootstrap.Modal(document.getElementById('deactivateModal')).show();
    }

    // Tab switching functionality
    function switchTab(tabId) {
        // Toggle tab buttons
        document.querySelectorAll('.profile-tab').forEach(btn => {
            if (btn.getAttribute('data-tab') === tabId) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        // Toggle panes
        document.querySelectorAll('.profile-tab-pane').forEach(pane => {
            if (pane.id === tabId) {
                pane.style.display = 'block';
                setTimeout(() => pane.classList.add('active'), 10);
            } else {
                pane.classList.remove('active');
                pane.style.display = 'none';
            }
        });

        if (history.replaceState) {
            history.replaceState(null, null, '#' + tabId);
        }
    }

    document.querySelectorAll('.profile-tab').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const tabId = this.getAttribute('data-tab');
            switchTab(tabId);
        });
    });

    // Check hash on load
    window.addEventListener('DOMContentLoaded', () => {
        const hash = window.location.hash ? window.location.hash.substring(1) : '';
        if (hash && document.getElementById(hash)) {
            switchTab(hash);
        }
    });
</script>
</body>
</html>
