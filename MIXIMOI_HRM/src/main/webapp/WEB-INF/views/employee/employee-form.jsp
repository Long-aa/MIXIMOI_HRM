<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty employee or employee.id == 0 ? 'Thêm nhân viên mới' : 'Chỉnh sửa nhân viên'} — MIXIMOI HRM</title>
    <meta name="description" content="Quy trình tiếp nhận nhân sự MIXIMOI - Onboarding nhân viên mới theo định biên và tiêu chuẩn 4 bước">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <!-- Page-specific CSS for Employee Form -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/employee-form.css">
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="employees" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Toast Container for modern dynamic notifications -->
            <div class="toast-container-custom" id="toastContainer"></div>

            <!-- Page Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-3">
                <div>
                    <div class="page-pretitle">
                        <span>QUY TRÌNH TIẾP NHẬN NHÂN SỰ</span>
                        <span>•</span>
                        <span id="headerFormId">
                            <c:choose>
                                <c:when test="${not empty employee and employee.id > 0}">MÃ NV: <c:out value="${employee.employeeCode}" /></c:when>
                                <c:otherwise>HỒ SƠ MỚI: <c:out value="${nextEmployeeCode}" /></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <h1 class="page-title" id="pageHeaderTitle">
                        ${empty employee or employee.id == 0 ? 'Thêm nhân viên mới' : 'Chỉnh sửa nhân viên'}
                    </h1>
                    <p class="page-subtitle">
                        Khởi tạo hồ sơ nhân sự điện tử chuẩn hóa theo định biên phòng ban tập đoàn MIXIMOI
                    </p>
                </div>
                <div class="badge-status-pill" id="badgeProgressStatus">
                    <span class="pulse-dot"></span>
                    <span id="badgeProgressText">Đang soạn thảo hồ sơ</span>
                </div>
            </div>

            <!-- Server-side alert error message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-3" style="border-radius:12px; font-size:0.875rem;" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <strong>Lỗi:</strong> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty candidateSource}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3 d-flex align-items-center gap-2" style="border-radius:12px; font-size:0.875rem;" role="alert">
                    <i class="bi bi-person-check-fill fs-5 text-success"></i>
                    <div>
                        Tiếp nhận ứng viên <strong><c:out value="${candidateSource.fullName}"/></strong> (<c:out value="${candidateSource.candidateCode}"/>) vào biên chế chính thức. Thông tin và tệp CV đã được đồng bộ tự động.
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Draft Restored Banner (Hidden by default) -->
            <div id="draftAlertBanner" class="alert alert-info alert-dismissible fade show border-0 shadow-sm mb-3 d-none" style="border-radius:12px; font-size:0.85rem;" role="alert">
                <i class="bi bi-info-circle-fill me-2 text-primary"></i>
                <span id="draftAlertText">Phát hiện dữ liệu nháp đã lưu trên trình duyệt này.</span>
                <button type="button" class="btn btn-sm btn-primary ms-3 py-0 px-2" style="font-size:0.75rem;" onclick="restoreDraftData()">Khôi phục dữ liệu</button>
                <button type="button" class="btn btn-sm btn-outline-danger ms-1 py-0 px-2" style="font-size:0.75rem;" onclick="clearDraft()">Xóa bản nháp</button>
                <button type="button" class="btn btn-sm btn-outline-secondary ms-1 py-0 px-2" style="font-size:0.75rem;" onclick="dismissDraft()">Bỏ qua</button>
            </div>

            <!-- Stepper Navigation (4 Steps) -->
            <div class="wizard-stepper">
                <button type="button" class="stepper-tab active" id="stepperTab1" onclick="jumpToStep(1)">
                    <div class="stepper-num" id="stepperNum1">01</div>
                    <div class="stepper-content">
                        <div class="stepper-badge-label" id="stepperBadge1">BƯỚC 1 • ĐANG THỰC HIỆN</div>
                        <div class="stepper-title">Thông tin cá nhân &amp; Liên lạc</div>
                    </div>
                </button>
                <button type="button" class="stepper-tab pending" id="stepperTab2" onclick="jumpToStep(2)">
                    <div class="stepper-num" id="stepperNum2">02</div>
                    <div class="stepper-content">
                        <div class="stepper-badge-label" id="stepperBadge2">BƯỚC 2</div>
                        <div class="stepper-title">Công việc &amp; Định biên</div>
                    </div>
                </button>
                <button type="button" class="stepper-tab pending" id="stepperTab3" onclick="jumpToStep(3)">
                    <div class="stepper-num" id="stepperNum3">03</div>
                    <div class="stepper-content">
                        <div class="stepper-badge-label" id="stepperBadge3">BƯỚC 3</div>
                        <div class="stepper-title">Lương &amp; Phúc lợi</div>
                    </div>
                </button>
                <button type="button" class="stepper-tab pending" id="stepperTab4" onclick="jumpToStep(4)">
                    <div class="stepper-num" id="stepperNum4">04</div>
                    <div class="stepper-content">
                        <div class="stepper-badge-label" id="stepperBadge4">BƯỚC 4</div>
                        <div class="stepper-title">Hợp đồng &amp; Bảo hiểm</div>
                    </div>
                </button>
            </div>

            <!-- FORM START -->
            <form method="post" action="${pageContext.request.contextPath}/employees" id="employeeForm" enctype="multipart/form-data" novalidate>
                <!-- Client-side validation message bar -->
                <div id="clientValidationAlert" class="alert alert-danger border-0 shadow-sm d-none mb-3" role="alert" aria-live="polite"></div>

                <input type="hidden" name="action" value="${empty employee or employee.id == 0 ? 'add' : 'update'}">
                <c:if test="${not empty employee and employee.id > 0}">
                    <input type="hidden" name="id" id="employeeId" value="${employee.id}">
                </c:if>

                <!-- Avatar URL Resolution -->
                <c:choose>
                    <c:when test="${not empty employee.avatarUrl}">
                        <c:choose>
                            <c:when test="${employee.avatarUrl.startsWith('http')}">
                                <c:set var="avatarSrc" value="${employee.avatarUrl}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="avatarSrc" value="${pageContext.request.contextPath}${employee.avatarUrl}" />
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${not empty employee.fullName}">
                        <c:set var="avatarSrc" value="https://ui-avatars.com/api/?name=${employee.fullName}&amp;background=2563eb&amp;color=fff" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="avatarSrc" value="https://ui-avatars.com/api/?name=NV&amp;background=e2e8f0&amp;color=64748b" />
                    </c:otherwise>
                </c:choose>

                <!-- 2-COLUMN WIZARD LAYOUT -->
                <div class="wizard-layout">

                    <!-- ============================================================ -->
                    <!-- LEFT COLUMN: Dynamic Context Sidebar                         -->
                    <!-- ============================================================ -->
                    <div>
                        <!-- PANEL STEP 1 SIDEBAR -->
                        <div id="sidePanelStep1">
                            <div class="sidebar-card">
                                <div class="sidebar-card-body text-center">
                                    <div class="avatar-upload-box upload-drop-zone" id="avatarDropZone" data-upload-input="avatarFileInput" onclick="triggerAvatarUpload(event)">
                                        <img id="avatarPreviewImg" src="${avatarSrc}" class="avatar-img-preview" alt="Avatar">
                                        <input type="file" id="avatarFileInput" name="avatarFile" accept=".jpg,.jpeg,.png,.webp,image/*" class="file-input-hidden" onchange="previewAvatar(this)">
                                        <input type="hidden" name="avatarUrl" id="avatarUrlHidden" value="${not empty employee.avatarUrl ? employee.avatarUrl : ''}">
                                    </div>
                                    <label for="avatarFileInput" class="avatar-upload-btn" data-upload-input="avatarFileInput" style="cursor:pointer;" onclick="triggerAvatarUpload(event)">
                                        <i class="bi bi-camera-fill"></i> Tải ảnh chân dung (3x4 / 4x6)
                                    </label>
                                    <div style="font-size:0.7rem; color:#94a3b8; margin-top:6px;">
                                        Hỗ trợ JPG, PNG. Kích thước tối đa 5MB. Ảnh rõ nét, nền sáng màu.
                                    </div>

                                    <!-- System info card -->
                                    <div class="sys-info-box text-start">
                                        <div class="sys-info-header">
                                            <span class="sys-info-title">Thông tin hệ thống</span>
                                            <span class="sys-info-tag">Tự động sinh</span>
                                        </div>
                                        <div class="sys-info-row">
                                            <span class="sys-info-label">Mã nhân viên</span>
                                            <span class="sys-info-val text-primary font-monospace" id="sysInfoCode">
                                                <c:out value="${empty employee.employeeCode ? nextEmployeeCode : employee.employeeCode}" />
                                            </span>
                                        </div>
                                        <div class="sys-info-row">
                                            <span class="sys-info-label">Trạng thái tạo</span>
                                            <span class="sys-badge-draft">${empty employee or employee.id == 0 ? 'Mới khởi tạo' : 'Đang cập nhật'}</span>
                                        </div>
                                        <div class="sys-info-row">
                                            <span class="sys-info-label">Quyền truy cập</span>
                                            <span class="sys-info-val">Cổng thông tin NV</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Progress & Guideline Card -->
                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span style="font-size:0.78rem; font-weight:700; color:#1e293b;">Tiến độ Bước 1</span>
                                        <span style="font-size:0.85rem; font-weight:800; color:#2563eb;" id="step1Pct">${empty employee or employee.id == 0 ? '0%' : '100%'}</span>
                                    </div>
                                    <div class="progress" style="height:7px; border-radius:999px; background:#e2e8f0;">
                                        <div class="progress-bar bg-primary" id="step1ProgressBar" style="width:${empty employee or employee.id == 0 ? '0%' : '100%'}; border-radius:999px;"></div>
                                    </div>
                                    <div style="font-size:0.72rem; color:#94a3b8; margin-top:8px;">
                                        Vui lòng hoàn thiện các trường đánh dấu sao (<span class="text-danger">*</span>) để mở khóa tiếp tục sang bước Công việc.
                                    </div>

                                    <div style="background:#f8fafc; border:1px solid #f1f5f9; border-radius:10px; padding:10px; margin-top:12px;">
                                        <div style="font-size:0.75rem; font-weight:700; color:#1e293b; display:flex; align-items:center; gap:6px; margin-bottom:5px;">
                                            <i class="bi bi-shield-check text-primary"></i> Quy chuẩn dữ liệu nhân sự
                                        </div>
                                        <ul style="font-size:0.72rem; color:#64748b; margin:0; padding-left:1.1rem; line-height:1.5;">
                                            <li>CCCD/Hộ chiếu phải còn hiệu lực ít nhất <strong>6 tháng</strong>.</li>
                                            <li>Email cá nhân được dùng để kích hoạt tài khoản và nhận phiếu lương.</li>
                                            <li>Địa chỉ thường trú ghi đầy đủ theo căn cước công dân.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- PANEL STEP 2 SIDEBAR -->
                        <div id="sidePanelStep2" style="display:none;">
                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="profile-summary-header">
                                        <img src="${avatarSrc}" class="profile-summary-avatar" alt="Avatar" id="sideProfileAvatar2">
                                        <div>
                                            <div class="profile-summary-name" id="sideProfileName2">
                                                <c:out value="${not empty employee.fullName ? employee.fullName : 'Chưa nhập họ tên'}" />
                                            </div>
                                            <span class="profile-summary-code" id="sideProfileCode2">
                                                <c:out value="${not empty employee.employeeCode ? employee.employeeCode : nextEmployeeCode}" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="profile-summary-details">
                                        <div><i class="bi bi-envelope"></i> <span id="sideProfileEmail2"><c:out value="${not empty employee.email ? employee.email : 'Chưa có email'}" /></span></div>
                                        <div><i class="bi bi-telephone"></i> <span id="sideProfilePhone2"><c:out value="${not empty employee.phone ? employee.phone : 'Chưa có SĐT'}" /></span></div>
                                        <div><i class="bi bi-geo-alt"></i> <span id="sideProfileAddr2"><c:out value="${not empty employee.address ? employee.address : 'Chưa có địa chỉ'}" /></span></div>
                                    </div>
                                </div>
                            </div>

                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="checklist-title">
                                        <span>Checklist Onboarding</span>
                                        <span class="badge bg-primary-subtle text-primary" style="font-size:0.65rem;">3 Hạng mục</span>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked disabled>
                                        <div>
                                            <div class="c-title">Chuẩn bị thiết bị làm việc</div>
                                            <div class="c-desc">Laptop &amp; phụ kiện IT phòng kỹ thuật bàn giao</div>
                                        </div>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked disabled>
                                        <div>
                                            <div class="c-title">Cấp tài khoản SSO &amp; Email</div>
                                            <div class="c-desc">Kích hoạt tài khoản @miximoi.vn ngày nhận việc</div>
                                        </div>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked disabled>
                                        <div>
                                            <div class="c-title">Cấu hình FaceID chấm công</div>
                                            <div class="c-desc">Đồng bộ máy quét chấm công tầng 6 Landmark 81</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="checklist-title">
                                        <span>Sơ đồ tổ chức nhân sự</span>
                                        <span class="badge bg-success-subtle text-success" style="font-size:0.65rem;">Báo cáo</span>
                                    </div>
                                    <div class="p-2 rounded bg-light border" style="font-size:0.75rem;">
                                        <div class="text-muted mb-1"><i class="bi bi-diagram-3 me-1 text-primary"></i> Quản lý trực tiếp:</div>
                                        <div class="fw-bold text-dark" id="sideReportingManager">
                                            <c:out value="${not empty employee.lineManager ? employee.lineManager : 'Theo phân bổ phòng ban'}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- PANEL STEP 3 SIDEBAR -->
                        <div id="sidePanelStep3" style="display:none;">
                            <!-- Profile Mini Summary -->
                            <div class="sidebar-card mb-2">
                                <div class="sidebar-card-body p-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <img src="${avatarSrc}" class="profile-summary-avatar rounded-circle" style="width:38px; height:38px; object-fit:cover;" alt="Avatar" id="sideStep3Avatar">
                                        <div>
                                            <div style="font-weight:800; font-size:0.88rem; color:#0f172a;" id="sideStep3Name">
                                                <c:out value="${not empty employee.fullName ? employee.fullName : 'Nhân sự mới'}" />
                                            </div>
                                            <div style="font-size:0.72rem; color:#64748b;" id="sideStep3Pos">
                                                <c:out value="${not empty employee.employeeCode ? employee.employeeCode : nextEmployeeCode}" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Net Salary Live Estimator -->
                            <div class="salary-est-card">
                                <div style="font-size:0.72rem; font-weight:800; color:#64748b; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:10px;">
                                    ƯỚC TÍNH DỰ KIẾN • Thu nhập thực nhận
                                </div>
                                <div class="salary-est-banner">
                                    <div class="banner-top">
                                        <span>ƯỚC TÍNH THỰC LĨNH (NET)</span>
                                        <span class="badge bg-white text-primary" style="font-size:0.65rem;" id="calcNetPct">89.5% Gross</span>
                                    </div>
                                    <div class="banner-amount" id="calcNetDisplay">~ 0 đ</div>
                                    <div class="banner-sub">Tạm tính sau BHXH bắt buộc (10.5%) &amp; Thuế TNCN (0 NPT)</div>
                                </div>

                                <div class="salary-breakdown-row">
                                    <span style="color:#64748b;">• Lương cơ bản:</span>
                                    <strong id="calcBaseDisplay">0 đ</strong>
                                </div>
                                <div class="salary-breakdown-row">
                                    <span style="color:#64748b;">• Tổng phụ cấp cố định:</span>
                                    <strong style="color:#059669;" id="calcAllowanceDisplay">+ 2.500.000 đ</strong>
                                </div>
                                <div class="salary-breakdown-row" style="border-top:1px solid #e2e8f0; font-weight:700;">
                                    <span>Tổng Gross thu nhập:</span>
                                    <span style="color:var(--primary);" id="calcGrossDisplay">2.500.000 đ</span>
                                </div>
                                <div class="salary-breakdown-row" style="font-size:0.75rem; color:#dc2626;">
                                    <span>Trừ BHXH bắt buộc (10.5%):</span>
                                    <span id="calcInsuranceDisplay">- 0 đ</span>
                                </div>
                                <div class="salary-breakdown-row" style="font-size:0.75rem; color:#dc2626;">
                                    <span>Tạm khấu trừ thuế TNCN:</span>
                                    <span id="calcTaxDisplay">- 0 đ</span>
                                </div>

                                <div class="donut-container">
                                    <div class="donut-circle">
                                        <span class="donut-text" id="donutNetPct">90%</span>
                                    </div>
                                    <div style="font-size:0.73rem; color:#64748b; line-height:1.4;">
                                        Tỷ lệ thực nhận đạt mức cạnh tranh thị trường theo thang bảng lương MIXIMOI.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- PANEL STEP 4 SIDEBAR -->
                        <div id="sidePanelStep4" style="display:none;">
                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="profile-summary-header">
                                        <img src="${avatarSrc}" class="profile-summary-avatar" alt="Avatar" id="sideProfileAvatar4">
                                        <div>
                                            <div class="profile-summary-name" id="sideProfileName4">
                                                <c:out value="${not empty employee.fullName ? employee.fullName : 'Chưa nhập họ tên'}" />
                                            </div>
                                            <span class="profile-summary-code" id="sideProfileCode4">
                                                <c:out value="${not empty employee.employeeCode ? employee.employeeCode : nextEmployeeCode}" />
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="checklist-title">
                                        <span>Checklist Onboarding</span>
                                        <span class="badge bg-primary-subtle text-primary" style="font-size:0.65rem;">3 Hạng mục</span>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked disabled>
                                        <div>
                                            <div class="c-title">Chuẩn bị thiết bị làm việc</div>
                                            <div class="c-desc">Laptop &amp; phụ kiện IT phòng kỹ thuật bàn giao</div>
                                        </div>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked disabled>
                                        <div>
                                            <div class="c-title">Cấp tài khoản SSO &amp; Email</div>
                                            <div class="c-desc">Kích hoạt tài khoản @miximoi.vn ngày nhận việc</div>
                                        </div>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked disabled>
                                        <div>
                                            <div class="c-title">Cấu hình FaceID chấm công</div>
                                            <div class="c-desc">Đồng bộ máy quét chấm công tầng 6 Landmark 81</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- END LEFT COLUMN -->

                    <!-- ============================================================ -->
                    <!-- RIGHT COLUMN: Step Panels                                    -->
                    <!-- ============================================================ -->
                    <div>

                        <!-- ======================================================== -->
                        <!-- BƯỚC 1: Thông tin cá nhân & Liên lạc                     -->
                        <!-- ======================================================== -->
                        <div class="wizard-step-panel active" id="panelStep1">

                            <!-- Section 1.1: Định danh cá nhân -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon"><i class="bi bi-person-vcard"></i></div>
                                        <div>
                                            <h3 class="form-section-title">1. Thông tin định danh cá nhân</h3>
                                            <div class="form-section-desc">Thông tin pháp lý đối chiếu với cơ sở dữ liệu định danh quốc gia</div>
                                        </div>
                                    </div>
                                    <span class="form-section-badge">BẮT BUỘC ĐIỀN ĐỦ</span>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <!-- Họ và tên -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Họ và tên đầy đủ <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom step1-input"
                                                   name="fullName" id="fullName" required
                                                   placeholder="VD: Nguyễn Văn An"
                                                   value="<c:out value='${employee.fullName}'/>"
                                                   oninput="handleFullNameChange(this.value)">
                                        </div>

                                        <!-- Mã nhân viên (TỰ ĐỘNG SINH) -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Mã nhân viên <span class="req">*</span></span>
                                                <span class="text-primary fw-normal" style="font-size:0.72rem; cursor:pointer;" onclick="toggleEditEmpCode()">
                                                    <i class="bi bi-pencil-square"></i> Đổi mã khác
                                                </span>
                                            </label>
                                            <div class="auto-code-wrap">
                                                <input type="text" class="form-control form-control-custom step1-input"
                                                       name="employeeCode" id="employeeCode" required
                                                       value="${empty employee.employeeCode ? nextEmployeeCode : employee.employeeCode}"
                                                       placeholder="NV001" readonly>
                                                <button type="button" class="auto-code-badge-btn" onclick="regenerateEmployeeCode()" title="Tự động sinh mã mới nhất">
                                                    <i class="bi bi-magic"></i> Tự sinh mã
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Ngày sinh -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Ngày sinh <span class="req">*</span></label>
                                            <input type="date" class="form-control form-control-custom step1-input"
                                                   name="dateOfBirth" id="dateOfBirth" required
                                                   value="${not empty employee.dateOfBirth ? employee.dateOfBirth : ''}"
                                                   onchange="calculateAge()">
                                        </div>

                                        <!-- Giới tính -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Giới tính <span class="req">*</span></label>
                                            <div class="pill-radio-group">
                                                <div class="pill-radio-option">
                                                    <input type="radio" name="gender" id="genderMale" value="MALE"
                                                           required ${empty employee.gender or employee.gender eq 'MALE' ? 'checked' : ''}
                                                           onchange="updateGenderDisplay()">
                                                    <label for="genderMale"><i class="bi bi-gender-male me-1"></i> Nam</label>
                                                </div>
                                                <div class="pill-radio-option">
                                                    <input type="radio" name="gender" id="genderFemale" value="FEMALE"
                                                           ${employee.gender eq 'FEMALE' ? 'checked' : ''}
                                                           onchange="updateGenderDisplay()">
                                                    <label for="genderFemale"><i class="bi bi-gender-female me-1"></i> Nữ</label>
                                                </div>
                                                <div class="pill-radio-option">
                                                    <input type="radio" name="gender" id="genderOther" value="OTHER"
                                                           ${employee.gender eq 'OTHER' ? 'checked' : ''}
                                                           onchange="updateGenderDisplay()">
                                                    <label for="genderOther">Khác</label>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Số CCCD -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Số CCCD / Hộ chiếu (12 số) <span class="req">*</span></label>
                                            <div class="position-relative">
                                                <input type="text" class="form-control form-control-custom step1-input"
                                                       name="identityNumber" id="idNumber" required
                                                       placeholder="Nhập số CCCD 12 chữ số"
                                                       maxlength="12" pattern="[0-9]{9,12}"
                                                       value="<c:out value='${employee.identityNumber}'/>"
                                                       oninput="validateCccd(this)">
                                                <i class="bi bi-check-circle-fill text-success position-absolute" id="cccdValidIcon"
                                                   style="right:12px; top:50%; transform:translateY(-50%); font-size:1rem; display:none;"></i>
                                            </div>
                                        </div>

                                        <!-- Ngày cấp CCCD -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Ngày cấp CCCD <span class="req">*</span></label>
                                            <input type="date" class="form-control form-control-custom step1-input"
                                                   name="identityDate" id="idIssueDate" required
                                                   value="<c:out value='${employee.identityDate}'/>">
                                        </div>

                                        <!-- Nơi cấp -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">Nơi cấp <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom step1-input"
                                                   name="identityPlace" id="idIssuePlace" required
                                                   placeholder="Cục Cảnh sát Quản lý hành chính về trật tự xã hội"
                                                   value="${empty employee.identityPlace ? 'Cục Cảnh sát QLHC về TTXH' : employee.identityPlace}">
                                        </div>

                                        <!-- Dân tộc & Tôn giáo & Quốc tịch & Hôn nhân -->
                                        <div class="col-md-3">
                                            <label class="form-label-custom">Dân tộc</label>
                                            <input type="text" class="form-control form-control-custom" name="ethnicity" id="ethnicity"
                                                   placeholder="Kinh" value="${empty employee.ethnicity ? 'Kinh' : employee.ethnicity}">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label-custom">Tôn giáo</label>
                                            <input type="text" class="form-control form-control-custom" name="religion" id="religion"
                                                   placeholder="Không" value="${empty employee.religion ? 'Không' : employee.religion}">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label-custom">Quốc tịch</label>
                                            <input type="text" class="form-control form-control-custom" name="nationality" id="nationality"
                                                   placeholder="Việt Nam" value="${empty employee.nationality ? 'Việt Nam' : employee.nationality}">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label-custom">Tình trạng hôn nhân</label>
                                            <select class="form-select form-select-custom" name="maritalStatus" id="maritalStatus">
                                                <option value="SINGLE" ${empty employee.maritalStatus or employee.maritalStatus eq 'SINGLE' ? 'selected' : ''}>Độc thân</option>
                                                <option value="MARRIED" ${employee.maritalStatus eq 'MARRIED' ? 'selected' : ''}>Đã kết hôn</option>
                                                <option value="DIVORCED" ${employee.maritalStatus eq 'DIVORCED' ? 'selected' : ''}>Ly hôn</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 1.2: Thông tin liên lạc & Địa chỉ cư trú -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon"><i class="bi bi-geo-alt"></i></div>
                                        <div>
                                            <h3 class="form-section-title">2. Thông tin liên lạc &amp; Địa chỉ cư trú</h3>
                                            <div class="form-section-desc">Kênh thông báo công việc, gửi phiếu lương và liên hệ khẩn cấp</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <!-- Email cá nhân -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Email cá nhân <span class="req">*</span></label>
                                            <input type="email" class="form-control form-control-custom step1-input"
                                                   name="email" id="email" required
                                                   placeholder="nguyenvanan.95@gmail.com"
                                                   value="<c:out value='${employee.email}'/>"
                                                   oninput="handleEmailInput(this.value)">
                                        </div>

                                        <!-- Email công ty dự kiến (TỰ ĐỘNG SINH) -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Email công ty dự kiến</span>
                                                <span class="badge bg-primary-subtle text-primary" style="font-size:0.65rem;">Tự động tạo</span>
                                            </label>
                                            <c:set var="empEmailPrefix" value="" />
                                            <c:if test="${not empty employee.email}">
                                                <c:choose>
                                                    <c:when test="${employee.email.contains('@')}">
                                                        <c:set var="empEmailPrefix" value="${employee.email.substring(0, employee.email.indexOf('@'))}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="empEmailPrefix" value="${employee.email}" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                            <div class="input-group">
                                                <input type="text" class="form-control form-control-custom"
                                                       name="companyEmailPrefix" id="companyEmailPrefix"
                                                       placeholder="vd: an.nv"
                                                       style="border-radius:10px 0 0 10px; border-right:none;"
                                                       value="<c:out value='${empEmailPrefix}'/>">
                                                <span class="input-group-text" style="border-radius:0 10px 10px 0; background:#f1f5f9; font-size:0.85rem; font-weight:700; color:#2563eb; border-color:#e2e8f0;">@miximoi.vn</span>
                                            </div>
                                        </div>

                                        <!-- Số điện thoại chính -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Số điện thoại chính <span class="req">*</span></label>
                                            <input type="tel" class="form-control form-control-custom step1-input"
                                                   name="phone" id="phone" required
                                                   placeholder="0912 345 678"
                                                   value="<c:out value='${employee.phone}'/>"
                                                   oninput="handlePhoneInput(this.value)">
                                        </div>

                                        <!-- SĐT liên hệ phụ / Zalo -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Số điện thoại phụ / Zalo</label>
                                            <input type="tel" class="form-control form-control-custom"
                                                   name="secondaryPhone" id="secondaryPhone"
                                                   placeholder="0987 654 321"
                                                   value="<c:out value='${employee.secondaryPhone}'/>">
                                        </div>

                                        <!-- Địa chỉ thường trú -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">Địa chỉ thường trú (Ghi rõ theo CCCD) <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom step1-input"
                                                   name="address" id="address" required
                                                   autocomplete="street-address"
                                                   placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"
                                                   value="<c:out value='${employee.address}'/>"
                                                   oninput="handleAddressInput(this.value)">
                                        </div>

                                        <!-- Địa chỉ tạm trú -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">
                                                <span>Địa chỉ tạm trú / Nơi ở hiện nay</span>
                                                <label style="font-weight:500; font-size:0.75rem; color:#475569; cursor:pointer; display:flex; align-items:center; gap:4px;">
                                                    <input type="checkbox" id="sameAddressCheck" onchange="toggleSameAddress(this)">
                                                    Giống địa chỉ thường trú
                                                </label>
                                            </label>
                                            <input type="text" class="form-control form-control-custom"
                                                   name="tempAddress" id="tempAddress"
                                                   placeholder="Nơi ở hiện tại (nếu khác địa chỉ thường trú)"
                                                   value="<c:out value='${employee.tempAddress}'/>">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 1.3: Hồ sơ đính kèm & Bản quét giấy tờ -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon"><i class="bi bi-folder-check"></i></div>
                                        <div>
                                            <h3 class="form-section-title">3. Hồ sơ đính kèm &amp; Bản quét giấy tờ</h3>
                                            <div class="form-section-desc">Tải lên định dạng PDF, PNG, JPG (Tối đa 10MB/tệp)</div>
                                        </div>
                                    </div>
                                    <span class="badge bg-secondary-subtle text-secondary" id="uploadedDocCountBadge" style="font-size:0.68rem;">Tùy chọn tải lên</span>
                                </div>
                                <div class="form-section-body">
                                    <div class="doc-upload-grid">
                                        <!-- Mặt trước CCCD -->
                                        <div class="doc-upload-card upload-drop-zone d-flex flex-column justify-content-center align-items-center"
                                             id="cccdFrontDropZone" data-upload-input="cccdFrontInput"
                                             onclick="triggerDocUpload('cccdFrontInput', event)"
                                             style="min-height:140px; cursor:pointer;">
                                            <c:choose>
                                                <c:when test="${not empty employee.idCardFrontUrl}">
                                                    <img id="cccdFrontPreview" src="${employee.idCardFrontUrl.startsWith('http') ? employee.idCardFrontUrl : pageContext.request.contextPath.concat(employee.idCardFrontUrl)}"
                                                         class="doc-upload-preview" alt="Mặt trước CCCD" style="max-height:75px; object-fit:contain; border-radius:6px; margin-bottom:6px;">
                                                    <i class="bi bi-card-heading text-primary d-none" id="cccdFrontIcon" style="font-size:1.8rem; margin-bottom:4px;"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-card-heading text-primary" id="cccdFrontIcon" style="font-size:1.8rem; margin-bottom:4px;"></i>
                                                    <img id="cccdFrontPreview" src="" class="doc-upload-preview d-none" alt="Mặt trước CCCD" style="max-height:75px; object-fit:contain; border-radius:6px; margin-bottom:6px;">
                                                </c:otherwise>
                                            </c:choose>
                                            <input type="file" id="cccdFrontInput" name="cccdFrontFile" accept=".jpg,.jpeg,.png,.webp,.pdf,image/*" class="file-input-hidden" onchange="handleDocFile(this, 'cccdFrontPreview', 'cccdFrontName')">
                                            <input type="hidden" name="idCardFrontUrl" id="idCardFrontUrlHidden" value="<c:out value='${employee.idCardFrontUrl}'/>">
                                            <div class="doc-upload-title"><span>Mặt trước CCCD</span></div>
                                            <div class="d-flex justify-content-between align-items-center mt-2" style="font-size:0.7rem; width:100%;">
                                                <span class="text-truncate text-muted" id="cccdFrontName" style="max-width:120px;">
                                                    ${not empty employee.idCardFrontUrl ? 'Đã có file • Bấm đổi' : 'Bấm để tải tệp'}
                                                </span>
                                                <span class="text-danger fw-bold ${empty employee.idCardFrontUrl ? 'd-none' : ''}" id="cccdFrontDel" onclick="event.preventDefault(); event.stopPropagation(); clearDocUpload('cccdFrontPreview', 'cccdFrontName')">Xóa</span>
                                            </div>
                                        </div>

                                        <!-- Mặt sau CCCD -->
                                        <div class="doc-upload-card upload-drop-zone d-flex flex-column justify-content-center align-items-center"
                                             id="cccdBackDropZone" data-upload-input="cccdBackInput"
                                             onclick="triggerDocUpload('cccdBackInput', event)"
                                             style="min-height:140px; cursor:pointer;">
                                            <c:choose>
                                                <c:when test="${not empty employee.idCardBackUrl}">
                                                    <img id="cccdBackPreview" src="${employee.idCardBackUrl.startsWith('http') ? employee.idCardBackUrl : pageContext.request.contextPath.concat(employee.idCardBackUrl)}"
                                                         class="doc-upload-preview" alt="Mặt sau CCCD" style="max-height:75px; object-fit:contain; border-radius:6px; margin-bottom:6px;">
                                                    <i class="bi bi-card-text text-primary d-none" id="cccdBackIcon" style="font-size:1.8rem; margin-bottom:4px;"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-card-text text-primary" id="cccdBackIcon" style="font-size:1.8rem; margin-bottom:4px;"></i>
                                                    <img id="cccdBackPreview" src="" class="doc-upload-preview d-none" alt="Mặt sau CCCD" style="max-height:75px; object-fit:contain; border-radius:6px; margin-bottom:6px;">
                                                </c:otherwise>
                                            </c:choose>
                                            <input type="file" id="cccdBackInput" name="cccdBackFile" accept=".jpg,.jpeg,.png,.webp,.pdf,image/*" class="file-input-hidden" onchange="handleDocFile(this, 'cccdBackPreview', 'cccdBackName')">
                                            <input type="hidden" name="idCardBackUrl" id="idCardBackUrlHidden" value="<c:out value='${employee.idCardBackUrl}'/>">
                                            <div class="doc-upload-title"><span>Mặt sau CCCD</span></div>
                                            <div class="d-flex justify-content-between align-items-center mt-2" style="font-size:0.7rem; width:100%;">
                                                <span class="text-truncate text-muted" id="cccdBackName" style="max-width:120px;">
                                                    ${not empty employee.idCardBackUrl ? 'Đã có file • Bấm đổi' : 'Bấm để tải tệp'}
                                                </span>
                                                <span class="text-danger fw-bold ${empty employee.idCardBackUrl ? 'd-none' : ''}" id="cccdBackDel" onclick="event.preventDefault(); event.stopPropagation(); clearDocUpload('cccdBackPreview', 'cccdBackName')">Xóa</span>
                                            </div>
                                        </div>

                                        <!-- Sơ yếu lý lịch / Khám SK -->
                                        <div class="doc-upload-card upload-drop-zone d-flex flex-column justify-content-center align-items-center"
                                             id="resumeDropZone" data-upload-input="resumeInput"
                                             onclick="triggerDocUpload('resumeInput', event)"
                                             style="min-height:140px; cursor:pointer;">
                                            <i class="bi bi-file-earmark-arrow-up text-primary" style="font-size:1.8rem; margin-bottom:4px;"></i>
                                            <input type="file" id="resumeInput" name="resumeFile" accept=".pdf,.docx,.doc" class="file-input-hidden" onchange="handleResumeFile(this)">
                                            <input type="hidden" name="resumeUrl" id="resumeUrlHidden" value="<c:out value='${employee.resumeUrl}'/>">
                                            <div class="doc-upload-title" id="resumeTitle">
                                                <c:choose>
                                                    <c:when test="${not empty employee.resumeUrl}">
                                                        <span class="text-truncate d-inline-block" style="max-width:140px;">${employee.resumeUrl.substring(employee.resumeUrl.lastIndexOf('/') + 1)}</span>
                                                    </c:when>
                                                    <c:otherwise>Sơ yếu lí lịch / Khám SK</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="doc-upload-sub" id="resumeSub">
                                                <c:choose>
                                                    <c:when test="${not empty employee.resumeUrl}">
                                                        <span class="text-success fw-bold"><i class="bi bi-check-circle"></i> Đã đính kèm CV</span>
                                                    </c:when>
                                                    <c:otherwise>Kéo thả tệp hoặc bấm để chọn</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mt-2" style="font-size:0.7rem; width:100%;">
                                                <span class="badge bg-light text-muted border" id="resumeBadge" style="font-size:0.65rem;">PDF, DOCX &lt;= 10MB</span>
                                                <span class="text-danger fw-bold ${empty employee.resumeUrl ? 'd-none' : ''}" id="resumeFileDel" onclick="event.preventDefault(); event.stopPropagation(); clearResumeUpload();">Xóa</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>



                        </div><!-- END PANEL STEP 1 -->


                        <!-- ======================================================== -->
                        <!-- BƯỚC 2: Công việc & Vị trí (Định biên phòng ban)          -->
                        <!-- ======================================================== -->
                        <div class="wizard-step-panel" id="panelStep2">

                            <!-- Section 2.1: Tổ chức & Định biên nhân sự -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon green"><i class="bi bi-building"></i></div>
                                        <div>
                                            <h3 class="form-section-title">1. Thông tin Tổ chức &amp; Định biên nhân sự</h3>
                                            <div class="form-section-desc">Phân bổ cấu trúc phòng ban và định biên nhân sự tập đoàn</div>
                                        </div>
                                    </div>
                                    <span class="badge bg-success-subtle text-success" id="deptFilterBadge" style="font-size:0.72rem;">Định biên chuẩn</span>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <!-- Phòng ban trực thuộc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Phòng ban trực thuộc <span class="req">*</span></span>
                                                <span class="text-muted fw-normal" style="font-size:0.72rem;">Có giới hạn định biên</span>
                                            </label>
                                            <select class="form-select form-select-custom" name="departmentId" id="departmentId" required
                                                    onchange="handleDepartmentChange(this.value)">
                                                <option value="">— Chọn phòng ban —</option>
                                                <c:forEach var="dept" items="${departments}">
                                                    <option value="${dept.id}" ${employee.departmentId == dept.id ? 'selected' : ''}>
                                                        <c:out value="${dept.name}" />
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Khối / Chi nhánh -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Khối / Chi nhánh làm việc <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="workLocation" id="workLocation">
                                                <option value="HO" ${empty employee.workLocation or employee.workLocation eq 'HO' ? 'selected' : ''}>Trụ sở chính Landmark 81, TP. HCM</option>
                                                <option value="HN" ${employee.workLocation eq 'HN' ? 'selected' : ''}>Chi nhánh Hà Nội (Keangnam Landmark 72)</option>
                                                <option value="DN" ${employee.workLocation eq 'DN' ? 'selected' : ''}>Chi nhánh Đà Nẵng</option>
                                                <option value="REMOTE" ${employee.workLocation eq 'REMOTE' ? 'selected' : ''}>Làm việc từ xa (Remote)</option>
                                            </select>
                                        </div>

                                        <!-- Quota Banner Widget -->
                                        <div class="col-12">
                                            <div class="quota-banner has-dept" id="deptQuotaBanner">
                                                <div class="quota-header">
                                                    <div>
                                                        <div style="font-weight:800; font-size:0.9rem; color:#0f172a;" id="quotaDeptName">
                                                            🏢 Vui lòng chọn phòng ban để tải định biên
                                                        </div>
                                                        <div style="font-size:0.75rem; color:#64748b;" id="quotaDeptDesc">
                                                            Nghiệp vụ: Quản lý nhân sự theo định biên phê duyệt
                                                        </div>
                                                    </div>
                                                    <span class="quota-badge-vacant" id="quotaVacantBadge">
                                                        <i class="bi bi-person-plus-fill"></i> Sẵn sàng tuyển dụng
                                                    </span>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                                    <span style="font-weight:700; color:#1e293b;" id="quotaRatioText">Hiện có 0 / 15 nhân sự</span>
                                                    <span style="font-weight:800; color:#2563eb;" id="quotaPctText">Đang cập nhật</span>
                                                </div>
                                                <div class="quota-progress">
                                                    <div class="quota-progress-bar" id="quotaProgressBar" style="width:50%;"></div>
                                                </div>
                                                <div style="font-size:0.72rem; color:#64748b; margin-top:4px;" id="quotaRecruitHint">
                                                    <i class="bi bi-info-circle me-1 text-primary"></i> Đang mở cổng tiếp nhận ứng viên cho vị trí chuyên môn.
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Chức danh / Vị trí chuyên môn -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Chức danh / Vị trí chuyên môn <span class="req">*</span></span>
                                                <span class="text-primary fw-normal" style="font-size:0.72rem;" id="posFilterNote">
                                                    <i class="bi bi-funnel-fill"></i> Đã lọc theo phòng ban
                                                </span>
                                            </label>
                                            <select class="form-select form-select-custom" name="positionId" id="positionId" required
                                                    onchange="handlePositionChange(this.value)">
                                                <option value="">— Chọn chức vụ phù hợp —</option>
                                                <c:forEach var="p" items="${positions}">
                                                    <option value="${p.id}" ${employee.positionId == p.id ? 'selected' : ''} data-department-id="${p.departmentId}">
                                                        <c:out value="${p.name}" />
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div id="positionVacantAlert" class="position-vacant-info d-none">
                                                <i class="bi bi-bell-fill"></i>
                                                <span id="positionVacantMsg">Vị trí này đang còn chỉ tiêu định biên.</span>
                                            </div>
                                        </div>

                                        <!-- Cấp bậc nhân sự (Level) -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Cấp bậc nhân sự (Level) <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="employeeLevel" id="employeeLevel" required>
                                                <option value="L1" ${employee.employeeLevel eq 'L1' ? 'selected' : ''}>Level 1 - Junior Associate</option>
                                                <option value="L2" ${employee.employeeLevel eq 'L2' ? 'selected' : ''}>Level 2 - Specialist (Chuyên viên)</option>
                                                <option value="L3" ${empty employee.employeeLevel or employee.employeeLevel eq 'L3' ? 'selected' : ''}>Level 3 - Senior Specialist (Chuyên gia)</option>
                                                <option value="L4" ${employee.employeeLevel eq 'L4' ? 'selected' : ''}>Level 4 - Lead / Principal Specialist</option>
                                                <option value="L5" ${employee.employeeLevel eq 'L5' ? 'selected' : ''}>Level 5 - Manager / Director</option>
                                            </select>
                                        </div>

                                        <!-- Quản lý trực tiếp -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Quản lý trực tiếp (Direct Manager)</label>
                                            <input type="text" class="form-control form-control-custom" name="lineManager" id="lineManager"
                                                   placeholder="VD: Trưởng bộ phận phụ trách"
                                                   value="<c:out value='${employee.lineManager}'/>">
                                        </div>

                                        <!-- Người hướng dẫn -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Người hướng dẫn (Mentor / Buddy Onboarding)</label>
                                            <input type="text" class="form-control form-control-custom" name="mentorName" id="mentorName"
                                                   placeholder="VD: Chuyên viên hướng dẫn hội nhập"
                                                   value="<c:out value='${employee.mentorName}'/>">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 2.2: Chế độ làm việc & Thời gian -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon green"><i class="bi bi-clock-history"></i></div>
                                        <div>
                                            <h3 class="form-section-title">2. Chế độ làm việc &amp; Thời gian</h3>
                                            <div class="form-section-desc">Lịch công tác, thời gian thử việc và hình thức chấm công</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <!-- Hình thức làm việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Hình thức làm việc <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="employeeTypeId" id="employeeTypeId" required>
                                                <option value="1" ${empty employee.employeeTypeId or employee.employeeTypeId == 1 ? 'selected' : ''}>Toàn thời gian (Full-time)</option>
                                                <option value="2" ${employee.employeeTypeId == 2 ? 'selected' : ''}>Nhân viên thử việc</option>
                                                <option value="3" ${employee.employeeTypeId == 3 ? 'selected' : ''}>Nhân viên thời vụ</option>
                                                <option value="4" ${employee.employeeTypeId == 4 ? 'selected' : ''}>Cộng tác viên (Part-time)</option>
                                            </select>
                                        </div>

                                        <!-- Ca làm việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Ca làm việc áp dụng <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="defaultShift" id="defaultShift" required>
                                                <option value="1" selected>Ca hành chính: 08:00 - 17:30 (Nghỉ trưa 12:00 - 13:30)</option>
                                                <option value="2">Ca linh hoạt (Flexible: 08:30 - 18:00)</option>
                                                <option value="3">Ca ca kíp (Theo phân công tổ chức)</option>
                                            </select>
                                        </div>

                                        <!-- Ngày bắt đầu nhận việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Ngày bắt đầu nhận việc (Onboarding) <span class="req">*</span></label>
                                            <c:set var="initStartDate" value="${not empty employee.startDate ? employee.startDate : ''}" />
                                            <c:if test="${empty initStartDate}">
                                                <c:set var="initStartDate" value="<%= java.time.LocalDate.now().toString() %>" />
                                            </c:if>
                                            <input type="date" class="form-control form-control-custom" name="startDate" id="startDate" required
                                                   value="${initStartDate}">
                                        </div>

                                        <!-- Thời gian thử việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Thời gian thử việc <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="probationDuration" id="probationDuration" required>
                                                <option value="2" selected>02 tháng (85% - 100% lương theo thoả thuận)</option>
                                                <option value="1">01 tháng (85% lương)</option>
                                                <option value="0">Không thử việc (Ký chính thức ngay)</option>
                                            </select>
                                        </div>

                                        <!-- Trạng thái nhân sự -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Trạng thái hồ sơ nhân sự <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="status" id="empStatus" onchange="handleStatusChange(this.value)">
                                                <option value="ACTIVE" ${empty employee.status or employee.status eq 'ACTIVE' ? 'selected' : ''}>Đang làm việc (Active)</option>
                                                <option value="ON_LEAVE" ${employee.status eq 'ON_LEAVE' ? 'selected' : ''}>Nghỉ tạm thời / Thai sản (On Leave)</option>
                                                <option value="INACTIVE" ${employee.status eq 'INACTIVE' ? 'selected' : ''}>Đã thôi việc (Inactive)</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6 ${employee.status eq 'INACTIVE' ? '' : 'd-none'}" id="terminationFields">
                                            <label class="form-label-custom">Ngày thôi việc &amp; Lý do</label>
                                            <div class="row g-2">
                                                <div class="col-6">
                                                    <input type="date" class="form-control form-control-custom" name="endDate" id="empEndDate" value="${employee.endDate}">
                                                </div>
                                                <div class="col-6">
                                                    <input type="text" class="form-control form-control-custom" name="terminationReason" id="terminationReason" placeholder="Lý do nghỉ" value="<c:out value='${employee.terminationReason}'/>">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- END Section 2.2 form-section-card -->

                            <!-- Section 2.3: Thiết lập Tài khoản & Quyền truy cập -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon green"><i class="bi bi-shield-lock"></i></div>
                                        <div>
                                            <h3 class="form-section-title">3. Thiết lập Tài khoản &amp; Quyền truy cập</h3>
                                            <div class="form-section-desc">Cấp tài khoản đăng nhập hệ thống và phân quyền bảo mật</div>
                                        </div>
                                    </div>
                                    <span class="badge bg-primary-subtle text-primary" style="font-size:0.72rem;">Đồng bộ SSO</span>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <!-- Email công ty dự kiến -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Email công ty dự kiến <span class="req">*</span></label>
                                            <div class="input-group">
                                                <c:set var="companyEmailVal" value="" />
                                                <c:if test="${not empty employee.email and employee.email.endsWith('@miximoi.vn')}">
                                                    <c:set var="companyEmailVal" value="${employee.email}" />
                                                </c:if>
                                                <input type="email" class="form-control form-control-custom"
                                                       name="companyEmail" id="step2CompanyEmail"
                                                       placeholder="vd: an.nguyen@miximoi.vn"
                                                       value="<c:out value='${companyEmailVal}'/>">
                                            </div>
                                        </div>

                                        <!-- Tên tài khoản đăng nhập (SSO) -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tên tài khoản đăng nhập (SSO) <span class="req">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text" style="background:#f1f5f9; border-color:#e2e8f0; font-size:0.85rem;"><i class="bi bi-person-fill text-muted"></i></span>
                                                <input type="text" class="form-control form-control-custom font-monospace"
                                                       name="ssoUsername" id="ssoUsername"
                                                       placeholder="vd: an.nguyen hoặc mã NV"
                                                       value="<c:out value='${not empty userAccount ? userAccount.username : \"\"}'/>">
                                            </div>
                                        </div>

                                        <!-- Quyền truy cập hệ thống -->
                                        <div class="col-12">
                                            <label class="form-label-custom">Quyền truy cập hệ thống phân cấp</label>
                                            <div class="d-flex flex-wrap gap-4 p-3 bg-light rounded-3 border">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="accessPortal" name="accessRoles" value="PORTAL" checked disabled>
                                                    <label class="form-check-label fw-bold" for="accessPortal" style="font-size:0.82rem; cursor:pointer;">
                                                        Cổng nhân viên (Employee Portal)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="accessAttendance" name="accessRoles" value="ATTENDANCE" checked disabled>
                                                    <label class="form-check-label fw-bold" for="accessAttendance" style="font-size:0.82rem; cursor:pointer;">
                                                        Chấm công &amp; Xem ca
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="accessPayslips" name="accessRoles" value="PAYSLIP" checked disabled>
                                                    <label class="form-check-label fw-bold" for="accessPayslips" style="font-size:0.82rem; cursor:pointer;">
                                                        Xem phiếu lương điện tử
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>



                        </div><!-- END PANEL STEP 2 -->


                        <!-- ======================================================== -->
                        <!-- BƯỚC 3: Lương & Phúc lợi                                 -->
                        <!-- ======================================================== -->
                        <div class="wizard-step-panel" id="panelStep3">

                            <!-- Section 3.1: Mức lương & Chế độ chi trả -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon purple"><i class="bi bi-cash-stack"></i></div>
                                        <div>
                                            <h3 class="form-section-title">1. Mức lương &amp; Chế độ chi trả</h3>
                                            <div class="form-section-desc">Căn cứ tính đơn giá ngày công và trích lập bảo hiểm bắt buộc</div>
                                        </div>
                                    </div>
                                    <span class="badge bg-purple-subtle text-purple" id="posSalarySuggestionBadge" style="font-size:0.72rem; color:#7c3aed; background:#f5f3ff;">
                                        Đề xuất theo chức vụ
                                    </span>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <!-- Mức lương cơ bản -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Mức lương cơ bản thỏa thuận <span class="req">*</span></label>
                                            <div class="position-relative">
                                                <c:set var="formattedBaseSalary" value="" />
                                                <c:if test="${not empty employee.baseSalary and employee.baseSalary > 0}">
                                                    <fmt:formatNumber var="formattedBaseSalary" value="${employee.baseSalary}" pattern="#,##0" />
                                                </c:if>
                                                <input type="text" class="form-control form-control-custom fw-bold text-primary fs-6"
                                                       name="baseSalary" id="baseSalary" required
                                                       value="${formattedBaseSalary}"
                                                       placeholder="VD: 15.000.000"
                                                       oninput="formatSalaryInput(this)">
                                                <span class="position-absolute end-0 top-50 translate-middle-y me-3 text-muted fw-bold" style="font-size:0.78rem;">VNĐ / Tháng</span>
                                            </div>
                                            <div style="font-size:0.72rem; color:#94a3b8; margin-top:4px;" id="salaryRangeHint">
                                                Khung dải lương tham chiếu: 15.000.000 – 35.000.000 VNĐ
                                            </div>
                                        </div>

                                        <!-- Tỷ lệ hưởng lương thử việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tỷ lệ hưởng lương thử việc <span class="req">*</span></label>
                                            <div class="pill-radio-group" style="grid-template-columns: 1fr 1fr;">
                                                <div class="pill-radio-option">
                                                    <input type="radio" name="probationSalaryRate" id="rate85" value="85" checked onchange="recalcCompensation()">
                                                    <label for="rate85"><i class="bi bi-check-circle-fill me-1"></i> 85% lương</label>
                                                </div>
                                                <div class="pill-radio-option">
                                                    <input type="radio" name="probationSalaryRate" id="rate100" value="100" onchange="recalcCompensation()">
                                                    <label for="rate100">100% lương</label>
                                                </div>
                                            </div>
                                            <div style="font-size:0.72rem; color:#64748b; margin-top:4px;" id="probationSubText">
                                                Thử việc 2 tháng theo Luật Lao Động 2019
                                            </div>
                                        </div>

                                        <!-- Cơ sở trích đóng BHXH -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">Cơ sở trích đóng Bảo hiểm xã hội &amp; Y tế bắt buộc <span class="req">*</span></label>
                                            <div class="row g-2">
                                                <div class="col-md-6">
                                                    <div class="p-3 border rounded-3 bg-light d-flex align-items-center gap-2">
                                                        <input type="radio" name="insuranceBasis" id="ib1" value="ACTUAL" checked onchange="recalcCompensation()">
                                                        <label for="ib1" style="font-size:0.8rem; font-weight:700; cursor:pointer;">
                                                            Đóng theo lương thực tế thỏa thuận
                                                            <div style="font-size:0.7rem; font-weight:400; color:#64748b;">Trích đóng dựa trên mức lương cơ bản</div>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="p-3 border rounded-3 bg-light d-flex align-items-center gap-2">
                                                        <input type="radio" name="insuranceBasis" id="ib2" value="CAP" onchange="recalcCompensation()">
                                                        <label for="ib2" style="font-size:0.8rem; font-weight:700; cursor:pointer;">
                                                            Đóng theo trần quy định Nhà nước
                                                            <div style="font-size:0.7rem; font-weight:400; color:#64748b;">Giới hạn tối đa 20 lần mức lương cơ sở</div>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 3.2: Các khoản Phụ cấp cố định hàng tháng -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon purple"><i class="bi bi-gift"></i></div>
                                        <div>
                                            <h3 class="form-section-title">2. Các khoản Phụ cấp cố định hàng tháng</h3>
                                            <div class="form-section-desc">Phụ cấp hỗ trợ chế độ đãi ngộ theo quy chế tập đoàn MIXIMOI</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section-body">
                                    <!-- Phụ cấp ăn trưa -->
                                    <div class="allowance-box-item active" id="allowanceRowLunch">
                                        <div class="allowance-left">
                                            <input type="checkbox" class="form-check-input mt-0" id="alLunch" checked onchange="toggleAllowanceRow(this, 1000000)">
                                            <div>
                                                <div class="allowance-name">Phụ cấp ăn trưa <span class="badge bg-success-subtle text-success ms-1" style="font-size:0.65rem;">Cố định</span></div>
                                                <div class="allowance-sub">Hỗ trợ bữa ăn ca làm việc hàng ngày</div>
                                            </div>
                                        </div>
                                        <div class="allowance-amount">1.000.000 đ / tháng</div>
                                    </div>

                                    <!-- Phụ cấp xăng xe -->
                                    <div class="allowance-box-item active" id="allowanceRowGas">
                                        <div class="allowance-left">
                                            <input type="checkbox" class="form-check-input mt-0" id="alGas" checked onchange="toggleAllowanceRow(this, 1000000)">
                                            <div>
                                                <div class="allowance-name">Phụ cấp xăng xe / đi lại <span class="badge bg-info-subtle text-info ms-1" style="font-size:0.65rem;">Hỗ trợ</span></div>
                                                <div class="allowance-sub">Chi phí công tác, nhiên liệu di chuyển cá nhân</div>
                                            </div>
                                        </div>
                                        <div class="allowance-amount">1.000.000 đ / tháng</div>
                                    </div>

                                    <!-- Phụ cấp điện thoại -->
                                    <div class="allowance-box-item active" id="allowanceRowPhone">
                                        <div class="allowance-left">
                                            <input type="checkbox" class="form-check-input mt-0" id="alPhone" checked onchange="toggleAllowanceRow(this, 500000)">
                                            <div>
                                                <div class="allowance-name">Phụ cấp điện thoại / liên lạc <span class="badge bg-primary-subtle text-primary ms-1" style="font-size:0.65rem;">Viễn thông</span></div>
                                                <div class="allowance-sub">Gói cước 4G và thoại phục vụ liên lạc công việc</div>
                                            </div>
                                        </div>
                                        <div class="allowance-amount">500.000 đ / tháng</div>
                                    </div>
                                </div>
                            </div>



                        </div><!-- END PANEL STEP 3 -->


                        <!-- ======================================================== -->
                        <!-- BƯỚC 4: Hợp đồng & Bảo hiểm                             -->
                        <!-- ======================================================== -->
                        <div class="wizard-step-panel" id="panelStep4">

                            <!-- Section 4.1: Hợp đồng lao động -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon orange"><i class="bi bi-file-earmark-text"></i></div>
                                        <div>
                                            <h3 class="form-section-title">1. Hợp đồng lao động</h3>
                                            <div class="form-section-desc">Loại hợp đồng, thời hạn và số hiệu lưu trữ điện tử</div>
                                        </div>
                                    </div>
                                    <span class="form-section-badge" style="background:#fffbeb; color:#d97706; border-color:#fde68a;">BẮT BUỘC ĐIỀN ĐỦ</span>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <!-- Loại hợp đồng -->
                                        <div class="col-12">
                                            <label class="form-label-custom">Loại hợp đồng <span class="req">*</span></label>
                                            <div class="contract-card-grid">
                                                <div class="contract-card-opt">
                                                    <input type="radio" name="contractType" id="ctIndefinite" value="INDEFINITE"
                                                           ${empty contract or contract.contractType eq 'INDEFINITE' ? 'checked' : ''}>
                                                    <label for="ctIndefinite">
                                                        <i class="bi bi-infinity text-success"></i>
                                                        <span class="c-name">Không xác định</span>
                                                        <span class="c-sub">Dài hạn, ổn định</span>
                                                    </label>
                                                </div>
                                                <div class="contract-card-opt">
                                                    <input type="radio" name="contractType" id="ctFixed" value="FIXED_TERM"
                                                           ${contract.contractType eq 'FIXED_TERM' ? 'checked' : ''}>
                                                    <label for="ctFixed">
                                                        <i class="bi bi-calendar-range text-primary"></i>
                                                        <span class="c-name">Xác định thời hạn</span>
                                                        <span class="c-sub">1–3 năm</span>
                                                    </label>
                                                </div>
                                                <div class="contract-card-opt">
                                                    <input type="radio" name="contractType" id="ctSeasonal" value="SEASONAL"
                                                           ${contract.contractType eq 'SEASONAL' ? 'checked' : ''}>
                                                    <label for="ctSeasonal">
                                                        <i class="bi bi-sun text-warning"></i>
                                                        <span class="c-name">Thời vụ</span>
                                                        <span class="c-sub">Ngắn hạn</span>
                                                    </label>
                                                </div>
                                                <div class="contract-card-opt">
                                                    <input type="radio" name="contractType" id="ctProbation" value="PROBATION"
                                                           ${contract.contractType eq 'PROBATION' ? 'checked' : ''}>
                                                    <label for="ctProbation">
                                                        <i class="bi bi-hourglass-split text-purple"></i>
                                                        <span class="c-name">Thử việc</span>
                                                        <span class="c-sub">Tối đa 60 ngày</span>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Mã số hợp đồng (TỰ ĐỘNG SINH) -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Mã số hợp đồng <span class="req">*</span></span>
                                                <span class="text-primary fw-normal" style="font-size:0.72rem; cursor:pointer;" onclick="toggleEditContractCode()">
                                                    <i class="bi bi-pencil-square"></i> Đổi mã khác
                                                </span>
                                            </label>
                                            <div class="auto-code-wrap">
                                                <input type="text" class="form-control form-control-custom" name="contractCode" id="contractCode" required
                                                       value="${not empty contract ? contract.contractCode : (empty nextContractCode ? 'HD001' : nextContractCode)}"
                                                       placeholder="HD001" readonly>
                                                <button type="button" class="auto-code-badge-btn" onclick="regenerateContractCode()" title="Tự động sinh mã hợp đồng">
                                                    <i class="bi bi-magic"></i> Tự sinh mã
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Ngày ký hợp đồng -->
                                        <div class="col-md-3">
                                            <label class="form-label-custom">Ngày ký hợp đồng <span class="req">*</span></label>
                                            <c:set var="initSignDate" value="${not empty contract and not empty contract.startDate ? contract.startDate : (not empty employee.startDate ? employee.startDate : '')}" />
                                            <c:if test="${empty initSignDate}">
                                                <c:set var="initSignDate" value="<%= java.time.LocalDate.now().toString() %>" />
                                            </c:if>
                                            <input type="date" class="form-control form-control-custom" name="contractSignDate" id="contractSignDate" required
                                                   value="${initSignDate}">
                                        </div>

                                        <!-- Ngày hết hạn -->
                                        <div class="col-md-3">
                                            <label class="form-label-custom">Ngày hết hạn <small class="text-muted">(Nếu có)</small></label>
                                            <input type="date" class="form-control form-control-custom" name="contractEndDate" id="contractEndDate"
                                                   value="${not empty contract and not empty contract.endDate ? contract.endDate : ''}">
                                        </div>

                                        <!-- File Hợp đồng đính kèm -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">File hợp đồng ký kết / Scan (PDF, DOCX)</label>
                                            <input type="file" class="form-control form-control-custom" name="contractFile" id="contractFile" accept=".pdf,.doc,.docx">
                                            <small class="text-muted" style="font-size:0.75rem;">Hỗ trợ PDF, Word (.doc, .docx). Tối đa 10MB</small>
                                            <c:if test="${not empty contract and not empty contract.contractFileUrl}">
                                                <div class="mt-2 d-flex align-items-center gap-2">
                                                    <a href="${pageContext.request.contextPath}${contract.contractFileUrl}" target="_blank" class="btn btn-sm btn-outline-danger" style="font-size:0.75rem; border-radius:6px;">
                                                        <i class="bi bi-file-earmark-pdf"></i> Tải / Xem file hợp đồng hiện tại
                                                    </a>
                                                    <span class="text-success" style="font-size:0.75rem;"><i class="bi bi-check-circle-fill"></i> Đã đính kèm</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 4.2: Bảo hiểm, Thuế & Ngân hàng -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon orange"><i class="bi bi-shield-lock"></i></div>
                                        <div>
                                            <h3 class="form-section-title">2. Đăng ký Bảo hiểm, Thuế &amp; Ngân hàng</h3>
                                            <div class="form-section-desc">Mã số BHXH, mã số thuế cá nhân và tài khoản nhận lương</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Mã số BHXH</span>
                                                <span class="text-primary fw-normal" style="font-size:0.72rem; cursor:pointer;" onclick="autoGenBhxh()">
                                                    <i class="bi bi-magic"></i> Gợi ý mã
                                                </span>
                                            </label>
                                            <input type="text" class="form-control form-control-custom font-monospace" name="insuranceNumber" id="bhxhCode"
                                                   placeholder="VD: 0101988234" value="<c:out value='${employee.insuranceNumber}'/>">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Mã số thuế cá nhân (MST)</span>
                                                <span class="text-primary fw-normal" style="font-size:0.72rem; cursor:pointer;" onclick="autoGenTaxCode()">
                                                    <i class="bi bi-magic"></i> Gợi ý mã
                                                </span>
                                            </label>
                                            <input type="text" class="form-control form-control-custom font-monospace" name="taxCode" id="taxCode"
                                                   placeholder="VD: 8492019482" value="<c:out value='${employee.taxCode}'/>">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tài khoản ngân hàng chi trả lương</label>
                                            <div class="input-group">
                                                <select class="form-select form-select-custom" style="max-width:130px;" name="bankName">
                                                    <option value="VCB" ${empty employee.bankName or employee.bankName eq 'VCB' ? 'selected' : ''}>Vietcombank</option>
                                                    <option value="TCB" ${employee.bankName eq 'TCB' ? 'selected' : ''}>Techcombank</option>
                                                    <option value="MB" ${employee.bankName eq 'MB' ? 'selected' : ''}>MB Bank</option>
                                                    <option value="ACB" ${employee.bankName eq 'ACB' ? 'selected' : ''}>ACB</option>
                                                    <option value="BIDV" ${employee.bankName eq 'BIDV' ? 'selected' : ''}>BIDV</option>
                                                    <option value="CTG" ${employee.bankName eq 'CTG' ? 'selected' : ''}>VietinBank</option>
                                                </select>
                                                <input type="text" class="form-control form-control-custom" name="bankAccount" id="bankAccount"
                                                       placeholder="Số tài khoản ngân hàng" value="<c:out value='${employee.bankAccount}'/>">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">Chi nhánh ngân hàng mở tài khoản</label>
                                            <input type="text" class="form-control form-control-custom" name="bankBranch" id="bankBranch"
                                                   placeholder="VD: Chi nhánh TP. Hồ Chí Minh" value="<c:out value='${employee.bankBranch}'/>">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 4.3: Liên hệ khẩn cấp -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon orange"><i class="bi bi-telephone-inbound"></i></div>
                                        <div>
                                            <h3 class="form-section-title">3. Liên hệ khẩn cấp</h3>
                                            <div class="form-section-desc">Người thân liên lạc khi có sự cố khẩn cấp tại nơi làm việc</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Họ tên người liên hệ</label>
                                            <input type="text" class="form-control form-control-custom" name="emergencyContactName" id="emergencyContactName"
                                                   placeholder="VD: Nguyễn Thị Bình" value="<c:out value='${employee.emergencyContactName}'/>">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Số điện thoại liên hệ</label>
                                            <input type="tel" class="form-control form-control-custom" name="emergencyContactPhone" id="emergencyContactPhone"
                                                   placeholder="VD: 0901234567" value="<c:out value='${employee.emergencyContactPhone}'/>">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Mối quan hệ</label>
                                            <select class="form-select form-select-custom" name="emergencyContactRelation" id="emergencyContactRelation">
                                                <option value="">— Chọn mối quan hệ —</option>
                                                <option value="Vợ/Chồng" ${employee.emergencyContactRelation eq 'Vợ/Chồng' ? 'selected' : ''}>Vợ / Chồng</option>
                                                <option value="Bố/Mẹ" ${employee.emergencyContactRelation eq 'Bố/Mẹ' ? 'selected' : ''}>Bố / Mẹ</option>
                                                <option value="Con" ${employee.emergencyContactRelation eq 'Con' ? 'selected' : ''}>Con</option>
                                                <option value="Anh/Chị/Em" ${employee.emergencyContactRelation eq 'Anh/Chị/Em' ? 'selected' : ''}>Anh / Chị / Em</option>
                                                <option value="Bạn bè" ${employee.emergencyContactRelation eq 'Bạn bè' ? 'selected' : ''}>Bạn bè</option>
                                                <option value="Khác" ${employee.emergencyContactRelation eq 'Khác' ? 'selected' : ''}>Khác</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Final Confirmation Box -->
                            <div class="mt-4">
                                <div style="background: linear-gradient(135deg, #f0fdf4, #dcfce7); border:1.5px solid #86efac; border-radius:12px; padding:1.1rem 1.25rem;">
                                    <div style="font-size:0.9rem; font-weight:800; color:#15803d; margin-bottom:4px; display:flex; align-items:center; gap:8px;">
                                        <i class="bi bi-check-circle-fill fs-5"></i> Xác nhận hoàn tất &amp; ${empty employee or employee.id == 0 ? 'Lưu hồ sơ nhân viên' : 'Cập nhật hồ sơ nhân sự'}
                                    </div>
                                    <div style="font-size:0.8rem; color:#166534; line-height:1.5;">
                                        Tôi xác nhận rằng toàn bộ thông tin kê khai trên là hoàn toàn chính xác, đúng pháp lý và đã đối chiếu với giấy tờ gốc. Dữ liệu nhân viên và hợp đồng lao động sẽ được đồng bộ ngay lập tức vào cơ sở dữ liệu MIXIMOI HRM.
                                    </div>
                                    <div class="mt-2 pt-2 border-top border-success-subtle">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="confirmAccuracy" name="confirmAccuracy" value="true">
                                            <label class="form-check-label fw-bold text-success" for="confirmAccuracy" style="font-size:0.82rem; cursor:pointer;">
                                                ${empty employee or employee.id == 0 ? 'Tôi đã kiểm tra kỹ và xác nhận lưu hồ sơ nhân sự này' : 'Tôi đã kiểm tra kỹ và xác nhận cập nhật hồ sơ nhân sự này'} <span class="text-danger">*</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Panel Step 4 Navigation Footer -->
                            <div class="step-nav-footer mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                                <button type="button" class="btn btn-outline-secondary px-3 py-2 d-inline-flex align-items-center gap-1"
                                        data-wizard-prev onclick="prevStep(); return false;">
                                    <i class="bi bi-arrow-left"></i> <span>Quay lại Bước 3</span>
                                </button>
                                <button type="submit" class="btn btn-success px-4 py-2 fw-bold fs-6 d-inline-flex align-items-center gap-2">
                                    <i class="bi bi-check2-all fs-5"></i>
                                    <span>${empty employee or employee.id == 0 ? 'Hoàn tất &amp; Lưu hồ sơ' : 'Lưu cập nhật hồ sơ'}</span>
                                </button>
                            </div>

                        </div><!-- END PANEL STEP 4 -->

                    </div><!-- END RIGHT COLUMN -->

                </div><!-- END WIZARD LAYOUT -->

                <!-- ============================================================ -->
                <!-- STICKY ACTION BAR                                            -->
                <!-- ============================================================ -->
                <div class="wizard-action-bar">
                    <div style="font-size:0.78rem; color:#64748b; display:flex; align-items:center; gap:8px;">
                        <a href="${pageContext.request.contextPath}/employees" class="btn btn-sm btn-light border text-muted px-2"
                           style="font-size:0.75rem;" onclick="return confirmDiscard();">
                            <i class="bi bi-x-circle me-1"></i>Hủy bỏ
                        </a>
                        <i class="bi bi-cloud-check text-success fs-6 ms-2"></i>
                        <span>Đã lưu nháp: <strong id="autoSaveTimer">Vừa xong</strong></span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <button type="button" class="btn-prev-step" id="btnPrev" data-wizard-prev onclick="prevStep(); return false;" disabled>
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </button>
                        <c:choose>
                            <c:when test="${not empty employee and employee.id > 0}">
                                <button type="submit" class="btn btn-primary" style="height:42px; border-radius:10px; font-weight:700; font-size:0.85rem; padding: 0 1.25rem;">
                                    <i class="bi bi-check2-all me-1"></i> Lưu thay đổi ngay
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn btn-outline-secondary" style="height:42px; border-radius:10px; font-weight:600; font-size:0.85rem;" onclick="saveDraft()">
                                    <i class="bi bi-floppy me-1"></i> Lưu bản nháp
                                </button>
                            </c:otherwise>
                        </c:choose>
                        <button type="button" class="btn-next-step" id="btnNext" data-wizard-next onclick="nextStep(); return false;">
                            <span id="btnNextText">Tiếp tục: Bước 2 (Công việc &amp; Vị trí)</span>
                            <i class="bi bi-arrow-right"></i>
                        </button>
                        <button type="submit" class="btn-submit-step" id="btnSubmit" style="display:none;">
                            <i class="bi bi-check2-all fs-5"></i>
                            <span>${empty employee or employee.id == 0 ? 'Hoàn tất & Lưu hồ sơ' : 'Lưu thay đổi'}</span>
                        </button>
                    </div>
                </div>

            </form>
            <!-- FORM END -->

        </div><!-- END .app-content -->
    </main>
</div>

<!-- Core and Page JS -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/employee-form.js"></script>

<script>
    function handleFullNameChange(val) {
        if (window.updateSummary) updateSummary();
        const code = document.getElementById('employeeCode')?.value || '';
        if (document.getElementById('sysInfoCode')) {
            document.getElementById('sysInfoCode').innerText = code;
        }
    }
    function handleEmailInput(val) {
        if (document.getElementById('sideProfileEmail')) document.getElementById('sideProfileEmail').innerText = val || 'Chưa nhập';
        if (document.getElementById('sideProfileEmail2')) document.getElementById('sideProfileEmail2').innerText = val || 'Chưa nhập';
        if (document.getElementById('companyEmailPrefix') && !document.getElementById('companyEmailPrefix').value && val.includes('@')) {
            document.getElementById('companyEmailPrefix').value = val.split('@')[0];
        }
    }
    function handlePhoneInput(val) {
        if (document.getElementById('sideProfilePhone')) document.getElementById('sideProfilePhone').innerText = val || 'Chưa nhập';
        if (document.getElementById('sideProfilePhone2')) document.getElementById('sideProfilePhone2').innerText = val || 'Chưa nhập';
    }
    function handleAddressInput(val) {
        if (document.getElementById('sideProfileAddr')) document.getElementById('sideProfileAddr').innerText = val || 'Chưa nhập';
        if (document.getElementById('sideProfileAddr2')) document.getElementById('sideProfileAddr2').innerText = val || 'Chưa nhập';
        if (document.getElementById('sameAddressCheck')?.checked && document.getElementById('tempAddress')) {
            document.getElementById('tempAddress').value = val;
        }
    }
    function calculateAge() {
        const dob = document.getElementById('dateOfBirth')?.value;
        if (!dob) return;
        const birthDate = new Date(dob);
        const ageDifMs = Date.now() - birthDate.getTime();
        const ageDate = new Date(ageDifMs);
        const age = Math.abs(ageDate.getUTCFullYear() - 1970);
        const genderEl = document.querySelector('input[name="gender"]:checked');
        const genderTxt = genderEl ? (genderEl.value === 'MALE' ? 'Nam' : genderEl.value === 'FEMALE' ? 'Nữ' : 'Khác') : '';
        if (document.getElementById('sideProfileAgeGender')) {
            document.getElementById('sideProfileAgeGender').innerText = `${age} tuổi • ${genderTxt}`;
        }
    }
    function updateGenderDisplay() {
        calculateAge();
    }
    function validateCccd(input) {
        const icon = document.getElementById('cccdValidIcon');
        if (!icon) return;
        if (/^\d{12}$/.test(input.value.trim())) {
            icon.style.display = 'block';
        } else {
            icon.style.display = 'none';
        }
    }
    function confirmDiscard() {
        return confirm('Bạn có chắc muốn rời khỏi trang này? Những thay đổi chưa lưu sẽ bị mất.');
    }
</script>

</body>
</html>