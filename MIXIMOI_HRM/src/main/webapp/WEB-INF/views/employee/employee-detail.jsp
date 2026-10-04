<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ: ${employee.fullName} — MIXIMOI HRM & PAYROLL</title>
    <meta name="description" content="Hồ sơ nhân sự ${employee.fullName} - Mã ${employee.employeeCode}">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/employee-detail.css">
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
                        <div class="profile-avatar-xl" style="overflow:hidden; display:flex; align-items:center; justify-content:center;">
                            <c:choose>
                                <c:when test="${not empty employee.avatarUrl}">
                                    <img src="${employee.avatarUrl.startsWith('http') ? employee.avatarUrl : pageContext.request.contextPath.concat(employee.avatarUrl)}" 
                                         alt="${employee.fullName}" style="width:100%; height:100%; object-fit:cover;">
                                </c:when>
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

                <!-- 5 TABS 360 PROFILE -->
                <div class="profile-hero-tabs">
                    <button type="button" class="profile-tab active" data-tab="tabProfile">
                        <i class="bi bi-person-vcard me-1"></i> 1. Hồ sơ &amp; Liên hệ
                    </button>
                    <button type="button" class="profile-tab" data-tab="tabContract">
                        <i class="bi bi-file-earmark-text-fill me-1"></i> 2. Hợp đồng &amp; Phụ lục
                        <span class="badge rounded-pill bg-light text-primary ms-1" style="font-size:0.72rem; font-weight:700;">${not empty contracts ? contracts.size() : 0}</span>
                    </button>
                    <button type="button" class="profile-tab" data-tab="tabAttendance">
                        <i class="bi bi-calendar-check-fill me-1"></i> 3. Chấm công &amp; Phép
                        <span class="badge rounded-pill bg-success-subtle text-success ms-1" style="font-size:0.72rem; font-weight:700;">${remainingLeaveDays} ngày phép</span>
                    </button>
                    <button type="button" class="profile-tab" data-tab="tabPayroll">
                        <i class="bi bi-cash-stack me-1"></i> 4. Lương &amp; Thuế TNCN
                        <span class="badge rounded-pill bg-light text-primary ms-1" style="font-size:0.72rem; font-weight:700;">${not empty payrolls ? payrolls.size() : 0}</span>
                    </button>
                    <button type="button" class="profile-tab" data-tab="tabDiscipline">
                        <i class="bi bi-shield-exclamation me-1"></i> 5. KPI &amp; Kỷ luật
                        <span class="badge rounded-pill bg-warning-subtle text-warning ms-1" style="font-size:0.72rem; font-weight:700;">${not empty disciplines ? disciplines.size() : 0}</span>
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

                    <!-- Identity Documents & Attachments -->
                    <div class="row g-3 mt-1">
                        <div class="col-12">
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-header-title">
                                        <i class="bi bi-folder-check"></i>
                                        <span class="info-card-title">Giấy tờ tùy thân & Hồ sơ đính kèm</span>
                                    </div>
                                </div>
                                <div class="info-card-body">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="info-row">
                                                <span class="info-label">Số CCCD / Hộ chiếu</span>
                                                <span class="info-value fw-bold text-dark">${not empty employee.identityNumber ? employee.identityNumber : 'Chưa cập nhật'}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Ngày cấp</span>
                                                <span class="info-value">${not empty employee.identityDate ? employee.identityDate : '—'}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Nơi cấp</span>
                                                <span class="info-value">${not empty employee.identityPlace ? employee.identityPlace : '—'}</span>
                                            </div>
                                        </div>

                                        <!-- CCCD Scans & Resume -->
                                        <div class="col-md-8">
                                            <div class="d-flex flex-wrap gap-3 align-items-center">
                                                <!-- Mặt trước CCCD -->
                                                <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:10px; text-align:center; min-width:140px;">
                                                    <div style="font-size:0.75rem; font-weight:600; color:#475569; margin-bottom:6px;">Mặt trước CCCD</div>
                                                    <c:choose>
                                                        <c:when test="${not empty employee.idCardFrontUrl}">
                                                            <a href="${employee.idCardFrontUrl.startsWith('http') ? employee.idCardFrontUrl : pageContext.request.contextPath.concat(employee.idCardFrontUrl)}" target="_blank" class="d-inline-block text-decoration-none">
                                                                <img src="${employee.idCardFrontUrl.startsWith('http') ? employee.idCardFrontUrl : pageContext.request.contextPath.concat(employee.idCardFrontUrl)}" 
                                                                     alt="Mặt trước CCCD" style="max-height:60px; max-width:120px; object-fit:contain; border-radius:6px; border:1px solid #cbd5e1;"
                                                                     onerror="this.style.display='none'; this.nextElementSibling.classList.remove('d-none');">
                                                                <div class="d-none"><i class="bi bi-file-earmark-image text-primary" style="font-size:1.8rem;"></i></div>
                                                                <div class="mt-1 text-primary" style="font-size:0.72rem; font-weight:600;"><i class="bi bi-box-arrow-up-right me-1"></i>Xem tệp</div>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-muted fst-italic" style="font-size:0.75rem; padding:15px 0;">Chưa tải lên</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Mặt sau CCCD -->
                                                <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:10px; text-align:center; min-width:140px;">
                                                    <div style="font-size:0.75rem; font-weight:600; color:#475569; margin-bottom:6px;">Mặt sau CCCD</div>
                                                    <c:choose>
                                                        <c:when test="${not empty employee.idCardBackUrl}">
                                                            <a href="${employee.idCardBackUrl.startsWith('http') ? employee.idCardBackUrl : pageContext.request.contextPath.concat(employee.idCardBackUrl)}" target="_blank" class="d-inline-block text-decoration-none">
                                                                <img src="${employee.idCardBackUrl.startsWith('http') ? employee.idCardBackUrl : pageContext.request.contextPath.concat(employee.idCardBackUrl)}" 
                                                                     alt="Mặt sau CCCD" style="max-height:60px; max-width:120px; object-fit:contain; border-radius:6px; border:1px solid #cbd5e1;"
                                                                     onerror="this.style.display='none'; this.nextElementSibling.classList.remove('d-none');">
                                                                <div class="d-none"><i class="bi bi-file-earmark-image text-primary" style="font-size:1.8rem;"></i></div>
                                                                <div class="mt-1 text-primary" style="font-size:0.72rem; font-weight:600;"><i class="bi bi-box-arrow-up-right me-1"></i>Xem tệp</div>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-muted fst-italic" style="font-size:0.75rem; padding:15px 0;">Chưa tải lên</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Sơ yếu lý lịch / CV -->
                                                <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:10px; text-align:center; min-width:150px;">
                                                    <div style="font-size:0.75rem; font-weight:600; color:#475569; margin-bottom:6px;">Sơ yếu lý lịch / CV</div>
                                                    <c:choose>
                                                        <c:when test="${not empty employee.resumeUrl}">
                                                            <a href="${employee.resumeUrl.startsWith('http') ? employee.resumeUrl : pageContext.request.contextPath.concat(employee.resumeUrl)}" target="_blank" class="btn btn-outline-primary btn-sm px-2 py-1" style="font-size:0.75rem; border-radius:8px;">
                                                                <i class="bi bi-file-earmark-pdf-fill me-1 text-danger"></i> Tải / Mở tệp
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-muted fst-italic" style="font-size:0.75rem; padding:15px 0;">Chưa đính kèm</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
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
                                                            <a href="${pageContext.request.contextPath}/contracts?action=print&id=${c.id}" class="btn btn-primary btn-sm px-2 py-1 me-1 text-white" style="border-radius:7px; font-size:0.78rem; background:#2563eb;" title="Xem và in văn bản Hợp đồng A4" target="_blank">
                                                                <i class="bi bi-printer me-1"></i> In HĐ
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/contracts?keyword=${c.contractCode}" class="btn btn-light btn-sm border px-2 py-1" style="border-radius:7px; font-size:0.78rem;" title="Xem tại danh sách Hợp đồng">
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

                <!-- ==================== TAB 3: CHẤM CÔNG & PHÉP NĂM ==================== -->
                <div class="profile-tab-pane" id="tabAttendance">
                    <div class="row g-3 mb-3">
                        <div class="col-md-3">
                            <div class="info-card p-3 text-center">
                                <div class="text-muted small fw-semibold">Hạn mức phép tiêu chuẩn</div>
                                <div class="fs-3 fw-bold text-primary">${standardLeaveDays} <span class="fs-6 text-muted">ngày/năm</span></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="info-card p-3 text-center">
                                <div class="text-muted small fw-semibold">Thâm niên thưởng thêm</div>
                                <div class="fs-3 fw-bold text-info">+${seniorityLeaveDays} <span class="fs-6 text-muted">ngày (+5 năm/1 ngày)</span></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="info-card p-3 text-center">
                                <div class="text-muted small fw-semibold">Đã sử dụng trong năm</div>
                                <div class="fs-3 fw-bold text-danger">${approvedDaysTaken} <span class="fs-6 text-muted">ngày đã duyệt</span></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="info-card p-3 text-center" style="background: #f0fdf4; border-color: #86efac;">
                                <div class="text-success small fw-bold">Số dư phép khả dụng</div>
                                <div class="fs-3 fw-bold text-success">${remainingLeaveDays} <span class="fs-6 text-success">ngày phép còn lại</span></div>
                            </div>
                        </div>
                    </div>

                    <div class="info-card">
                        <div class="info-card-header d-flex justify-content-between align-items-center">
                            <div class="info-card-header-title">
                                <i class="bi bi-clock-history"></i>
                                <span class="info-card-title">Nhật ký chấm công gần nhất (30 ca gần nhất)</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/timesheet" class="btn btn-outline-primary btn-sm" style="font-size:0.78rem;">
                                <i class="bi bi-box-arrow-up-right me-1"></i> Xem bảng công tổng hợp
                            </a>
                        </div>
                        <div class="info-card-body p-0">
                            <c:choose>
                                <c:when test="${empty attendances}">
                                    <div class="text-center py-4 text-muted small">
                                        <i class="bi bi-calendar-x fs-3 d-block mb-1"></i>
                                        Chưa ghi nhận dữ liệu chấm công nào của nhân sự này.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0" style="font-size:0.85rem;">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="ps-3">Ngày công</th>
                                                    <th>Giờ vào</th>
                                                    <th>Giờ ra</th>
                                                    <th>Tổng số giờ</th>
                                                    <th>Trạng thái</th>
                                                    <th>Phương thức</th>
                                                    <th>Ghi chú</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${attendances}" var="att">
                                                    <tr>
                                                        <td class="ps-3 fw-bold font-monospace">${att.workDate}</td>
                                                        <td class="text-primary font-monospace">${att.checkIn != null ? att.checkIn : '—'}</td>
                                                        <td class="text-primary font-monospace">${att.checkOut != null ? att.checkOut : '—'}</td>
                                                        <td class="fw-bold">${att.totalHours != null ? att.totalHours : '0'}h</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${att.status == 'ON_TIME'}"><span class="badge bg-success-subtle text-success">Đúng giờ</span></c:when>
                                                                <c:when test="${att.status == 'LATE'}"><span class="badge bg-warning-subtle text-warning">Đi trễ</span></c:when>
                                                                <c:when test="${att.status == 'EARLY_LEAVE'}"><span class="badge bg-warning-subtle text-warning">Về sớm</span></c:when>
                                                                <c:when test="${att.status == 'ABSENT'}"><span class="badge bg-danger-subtle text-danger">Vắng mặt</span></c:when>
                                                                <c:otherwise><span class="badge bg-info-subtle text-info">${att.status}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><span class="badge bg-light text-dark border">${att.method != null ? att.method : 'GPS/Vân tay'}</span></td>
                                                        <td class="text-muted small">${att.notes != null ? att.notes : '—'}</td>
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

                <!-- ==================== TAB 4: LƯƠNG & THUẾ TNCN ==================== -->
                <div class="profile-tab-pane" id="tabPayroll">
                    <div class="row g-3 mb-3">
                        <div class="col-md-4">
                            <div class="info-card p-3">
                                <div class="text-muted small">Lương cơ bản thỏa thuận</div>
                                <div class="fs-4 fw-bold text-primary">
                                    <fmt:formatNumber value="${employee.baseSalary}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </div>
                                <small class="text-muted">Căn cứ theo hợp đồng đang hiệu lực</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="info-card p-3">
                                <div class="text-muted small">Tài khoản thụ hưởng</div>
                                <div class="fs-5 fw-bold text-dark font-monospace">${not empty employee.bankAccount ? employee.bankAccount : 'Chưa cập nhật'}</div>
                                <small class="text-muted">Ngân hàng: ${not empty employee.bankName ? employee.bankName : '—'} (${not empty employee.bankBranch ? employee.bankBranch : 'Hội sở'})</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="info-card p-3">
                                <div class="text-muted small">Mã số thuế cá nhân &amp; BHXH</div>
                                <div class="fs-6 fw-bold text-dark font-monospace">MST: ${not empty employee.taxCode ? employee.taxCode : 'Chưa đăng ký'}</div>
                                <small class="text-muted font-monospace">BHXH: ${not empty employee.insuranceNumber ? employee.insuranceNumber : 'Chưa có'}</small>
                            </div>
                        </div>
                    </div>

                    <div class="info-card">
                        <div class="info-card-header d-flex justify-content-between align-items-center">
                            <div class="info-card-header-title">
                                <i class="bi bi-wallet2"></i>
                                <span class="info-card-title">Lịch sử diễn biến tiền lương &amp; Phiếu chi</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/payroll" class="btn btn-outline-primary btn-sm" style="font-size:0.78rem;">
                                <i class="bi bi-box-arrow-up-right me-1"></i> Bảng tính lương tổng
                            </a>
                        </div>
                        <div class="info-card-body p-0">
                            <c:choose>
                                <c:when test="${empty payrolls}">
                                    <div class="text-center py-4 text-muted small">
                                        <i class="bi bi-cash-stack fs-3 d-block mb-1"></i>
                                        Chưa có kỳ bảng lương nào được phát hành cho nhân sự này.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0" style="font-size:0.85rem;">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="ps-3">Kỳ lương</th>
                                                    <th>Lương cơ bản</th>
                                                    <th>Công thực tế</th>
                                                    <th>Tăng ca (OT)</th>
                                                    <th>Phụ cấp &amp; Thưởng</th>
                                                    <th>Khấu trừ &amp; Thuế</th>
                                                    <th class="text-success fw-bold">Thực lĩnh (Net)</th>
                                                    <th>Trạng thái</th>
                                                    <th class="text-end pe-3">Phiếu lương</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${payrolls}" var="pr">
                                                    <tr>
                                                        <td class="ps-3 fw-bold">Tháng ${pr.payMonth}/${pr.payYear}</td>
                                                        <td><fmt:formatNumber value="${pr.baseSalary}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                                        <td>${pr.workingDays} / ${pr.standardDays}</td>
                                                        <td class="text-primary">+<fmt:formatNumber value="${pr.overtimeAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                                        <td>+<fmt:formatNumber value="${pr.allowance + pr.bonus}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                                        <td class="text-danger">-<fmt:formatNumber value="${pr.deduction}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                                        <td class="text-success fw-bold fs-6"><fmt:formatNumber value="${pr.netSalary}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${pr.status == 'PAID'}"><span class="badge bg-success">Đã chi trả</span></c:when>
                                                                <c:when test="${pr.status == 'APPROVED'}"><span class="badge bg-primary">Đã duyệt</span></c:when>
                                                                <c:otherwise><span class="badge bg-warning text-dark">${pr.status}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end pe-3">
                                                            <a href="${pageContext.request.contextPath}/payslip?id=${pr.id}" target="_blank" class="btn btn-sm btn-outline-secondary" style="font-size:0.75rem;">
                                                                <i class="bi bi-file-earmark-spreadsheet me-1"></i> Xem Phiếu
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

                <!-- ==================== TAB 5: KPI & KHEN THƯỞNG - KỶ LUẬT ==================== -->
                <div class="profile-tab-pane" id="tabDiscipline">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <div class="info-card p-3">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div class="fw-bold text-dark">Chỉ số Hiệu suất &amp; Đánh giá năng lực (KPI)</div>
                                    <span class="badge bg-primary text-white">Xuất sắc (A+)</span>
                                </div>
                                <div class="progress mb-2" style="height: 10px;">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: 95%;"></div>
                                </div>
                                <div class="d-flex justify-content-between text-muted small">
                                    <span>Tỷ lệ hoàn thành mục tiêu: 95%</span>
                                    <span>Đánh giá kỳ gần nhất: Q1/2026</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-card p-3">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div class="fw-bold text-dark">Khen thưởng &amp; Kỷ luật lao động</div>
                                    <span class="badge ${empty disciplines ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-warning'}">
                                        ${empty disciplines ? 'Không có vi phạm' : disciplines.size() += ' sự vụ ghi nhận'}
                                    </span>
                                </div>
                                <p class="text-muted small mb-0">
                                    Ghi nhận toàn bộ quyết định tuyên dương, khiển trách hoặc xử lý kỷ luật theo đúng Nội quy lao động và Bộ luật Lao động 2019.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="info-card">
                        <div class="info-card-header d-flex justify-content-between align-items-center">
                            <div class="info-card-header-title">
                                <i class="bi bi-shield-exclamation text-danger"></i>
                                <span class="info-card-title">Hồ sơ Vi phạm &amp; Quyết định Kỷ luật (${not empty disciplines ? disciplines.size() : 0})</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/disciplines" class="btn btn-outline-danger btn-sm" style="font-size:0.78rem;">
                                <i class="bi bi-plus-circle me-1"></i> Quản lý module Kỷ luật
                            </a>
                        </div>
                        <div class="info-card-body p-0">
                            <c:choose>
                                <c:when test="${empty disciplines}">
                                    <div class="text-center py-5">
                                        <div style="width:56px; height:56px; border-radius:50%; background:#f0fdf4; color:#16a34a; display:flex; align-items:center; justify-content:center; margin:0 auto 0.75rem; font-size:1.6rem;">
                                            <i class="bi bi-patch-check-fill"></i>
                                        </div>
                                        <h6 class="fw-bold text-dark mb-1">Lý lịch nhân sự trong sạch</h6>
                                        <p class="text-muted small mb-0">Nhân viên tuân thủ nghiêm túc nội quy công ty, không có tiền án kỷ luật hoặc vi phạm nào.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0" style="font-size:0.85rem;">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="ps-3">Mã vi phạm</th>
                                                    <th>Ngày phát sinh</th>
                                                    <th>Hành vi vi phạm</th>
                                                    <th>Mức độ</th>
                                                    <th>Hình thức xử lý</th>
                                                    <th>Người xử lý</th>
                                                    <th class="text-end pe-3">Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${disciplines}" var="disc">
                                                    <tr>
                                                        <td class="ps-3 font-monospace fw-bold text-danger">${disc.violationCode}</td>
                                                        <td>${disc.violationDate}</td>
                                                        <td style="max-width:280px;" class="text-dark">${disc.behavior}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${disc.severity eq 'HIGH'}"><span class="badge bg-danger">Nghiêm trọng</span></c:when>
                                                                <c:when test="${disc.severity eq 'MEDIUM'}"><span class="badge bg-warning text-dark">Trung bình</span></c:when>
                                                                <c:otherwise><span class="badge bg-info text-white">Nhẹ</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="fw-semibold text-secondary">${not empty disc.decisionForm ? disc.decisionForm : 'Đang điều tra'}</td>
                                                        <td>${not empty disc.handlerName ? disc.handlerName : 'Ban Nhân Sự'}</td>
                                                        <td class="text-end pe-3">
                                                            <c:choose>
                                                                <c:when test="${disc.status eq 'RESOLVED'}"><span class="badge bg-success">Đã giải quyết</span></c:when>
                                                                <c:when test="${disc.status eq 'INVESTIGATING'}"><span class="badge bg-primary">Đang xác minh</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">${disc.status}</span></c:otherwise>
                                                            </c:choose>
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
<script src="${pageContext.request.contextPath}/assets/js/employee-detail.js"></script>
</body>
</html>
