<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <c:set var="activeMenu" value="employees" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Toast Container -->
            <div class="toast-container-custom" id="toastContainer"></div>

            <!-- Page Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-3">
                <div>
                    <div class="page-pretitle">
                        <span>QUY TRÌNH TIẾP NHẬN NHÂN SỰ</span>
                        <span>•</span>
                        <span id="headerFormId">FORM ID: #REC-2026-089</span>
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

            <!-- Server-side alert message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-3" style="border-radius:12px; font-size:0.875rem;" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Lỗi:</strong> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Draft Restored Banner (Hidden by default) -->
            <div id="draftAlertBanner" class="alert alert-info alert-dismissible fade show border-0 shadow-sm mb-3 d-none" style="border-radius:12px; font-size:0.85rem;" role="alert">
                <i class="bi bi-info-circle-fill me-2 text-primary"></i>
                <span id="draftAlertText">Phát hiện dữ liệu nháp đã lưu trước đó.</span>
                <button type="button" class="btn btn-sm btn-primary ms-3 py-0 px-2" style="font-size:0.75rem;" onclick="restoreDraftData()">Khôi phục dữ liệu</button>
                <button type="button" class="btn btn-sm btn-outline-danger ms-1 py-0 px-2" style="font-size:0.75rem;" onclick="clearDraft()">Xóa bản nháp</button>
                <button type="button" class="btn btn-sm btn-outline-secondary ms-1 py-0 px-2" style="font-size:0.75rem;" onclick="dismissDraft()">Bỏ qua</button>
            </div>

            <!-- Stepper Navigation -->
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

            <!-- FORM START (Standard POST for clean parameter binding) -->
            <form method="post" action="${pageContext.request.contextPath}/employees" id="employeeForm">
                <input type="hidden" name="action" value="${empty employee or employee.id == 0 ? 'add' : 'update'}">
                <c:if test="${not empty employee and employee.id > 0}">
                    <input type="hidden" name="id" value="${employee.id}">
                </c:if>

                <div class="wizard-layout">

                    <!-- ============================================================ -->
                    <!-- LEFT COLUMN: Dynamic Context Sidebar                         -->
                    <!-- ============================================================ -->
                    <div>
                        <!-- PANEL STEP 1 SIDEBAR -->
                        <div id="sidePanelStep1">
                            <div class="sidebar-card">
                                <div class="sidebar-card-body text-center">
                                    <div class="avatar-upload-box" onclick="triggerAvatarUpload()">
                                        <img id="avatarPreviewImg" src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80"
                                             class="avatar-img-preview" alt="Avatar">
                                        <input type="file" id="avatarFileInput" accept="image/*" style="display:none;" onchange="previewAvatar(this)">
                                    </div>
                                    <button type="button" class="avatar-upload-btn" onclick="triggerAvatarUpload()">
                                        <i class="bi bi-camera-fill"></i> Tải ảnh chân dung (3x4 / 4x6)
                                    </button>
                                    <div style="font-size:0.7rem; color:#94a3b8; margin-top:6px;">
                                        Hỗ trợ JPG, PNG. Kích thước tối đa 5MB. Ảnh rõ nét, nền trơn sáng màu.
                                    </div>

                                    <!-- System info card -->
                                    <div class="sys-info-box text-start">
                                        <div class="sys-info-header">
                                            <span class="sys-info-title">Thông tin hệ thống cấp</span>
                                            <span class="sys-info-tag">Tự động sinh</span>
                                        </div>
                                        <div class="sys-info-row">
                                            <span class="sys-info-label">Mã nhân viên đề xuất</span>
                                            <span class="sys-info-val text-primary font-monospace" id="sideEmpCodeDisplay">${empty nextEmployeeCode ? 'NV014' : nextEmployeeCode}</span>
                                        </div>
                                        <div class="sys-info-row">
                                            <span class="sys-info-label">Ngày khởi tạo</span>
                                            <span class="sys-info-val" id="sideCreatedDate">14/09/2026</span>
                                        </div>
                                        <div class="sys-info-row">
                                            <span class="sys-info-label">Trạng thái hồ sơ</span>
                                            <span class="sys-badge-draft">Tạo mới (Bản nháp)</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Progress & Guideline Card -->
                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span style="font-size:0.78rem; font-weight:700; color:#1e293b;">Tiến độ Bước 1</span>
                                        <span style="font-size:0.85rem; font-weight:800; color:#2563eb;" id="step1Pct">75%</span>
                                    </div>
                                    <div class="progress" style="height:7px; border-radius:999px; background:#e2e8f0;">
                                        <div class="progress-bar bg-primary" id="step1ProgressBar" style="width:75%; border-radius:999px;"></div>
                                    </div>
                                    <div style="font-size:0.72rem; color:#94a3b8; margin-top:8px;">
                                        Vui lòng hoàn thiện các trường đánh dấu sao (<span class="text-danger">*</span>) để mở khóa tiếp tục sang bước Công việc.
                                    </div>

                                    <div style="background:#f8fafc; border:1px solid #f1f5f9; border-radius:10px; padding:10px; margin-top:12px;">
                                        <div style="font-size:0.75rem; font-weight:700; color:#1e293b; display:flex; align-items:center; gap:6px; margin-bottom:5px;">
                                            <i class="bi bi-shield-check text-primary"></i> Quy chuẩn dữ liệu nhân sự
                                        </div>
                                        <ul style="font-size:0.72rem; color:#64748b; margin:0; padding-left:1.1rem; line-height:1.5;">
                                            <li>CCCD/Hộ chiếu phải còn hiệu lực ít nhất <strong>6 tháng</strong> tính đến ngày ký tiếp nhận.</li>
                                            <li>Email công ty (@miximoi.vn) sẽ được dùng để kích hoạt tài khoản SSO và nhận phiếu lương hàng tháng.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- PANEL STEP 2 SIDEBAR -->
                        <div id="sidePanelStep2" style="display:none;">
                            <!-- Profile Summary Card -->
                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="profile-summary-header">
                                        <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80"
                                             class="profile-summary-avatar" alt="Avatar">
                                        <div>
                                            <div class="profile-summary-name" id="sideProfileName">Nguyễn Văn An</div>
                                            <span class="profile-summary-code" id="sideProfileCode">MÃ NV: NV014</span>
                                            <div style="font-size:0.72rem; color:#64748b; margin-top:2px;" id="sideProfileAgeGender">Nam, 28 tuổi</div>
                                        </div>
                                    </div>
                                    <div class="profile-summary-details">
                                        <div><i class="bi bi-envelope"></i> <span id="sideProfileEmail">an.nguyen98@gmail.com</span></div>
                                        <div><i class="bi bi-telephone"></i> <span id="sideProfilePhone">0903 888 123</span></div>
                                        <div><i class="bi bi-geo-alt"></i> <span id="sideProfileAddr">Bình Thạnh, TP.HCM</span></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Onboarding Checklist -->
                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div class="checklist-title">
                                        <span>Checklist Onboarding</span>
                                        <span class="badge bg-primary-subtle text-primary" style="font-size:0.65rem;">3 Hạng mục</span>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked>
                                        <div>
                                            <div class="c-title">Chuẩn bị thiết bị làm việc</div>
                                            <div class="c-desc">Laptop MacBook Pro M3 &amp; phụ kiện IT</div>
                                        </div>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked>
                                        <div>
                                            <div class="c-title">Cấp tài khoản M365 &amp; Slack</div>
                                            <div class="c-desc">SSO tự động kích hoạt ngày nhận việc</div>
                                        </div>
                                    </div>
                                    <div class="checklist-item">
                                        <input class="form-check-input" type="checkbox" checked>
                                        <div>
                                            <div class="c-title">Cấu hình FaceID chấm công</div>
                                            <div class="c-desc">Đồng bộ máy quét cửa Văn phòng Tầng 6</div>
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
                                        <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80"
                                             class="profile-summary-avatar rounded-circle" style="width:38px; height:38px; object-fit:cover;" alt="Avatar">
                                        <div>
                                            <div style="font-weight:800; font-size:0.88rem; color:#0f172a;" id="sideStep3Name">Nguyễn Văn An</div>
                                            <div style="font-size:0.72rem; color:#64748b;" id="sideStep3Pos">Kỹ sư phần mềm • Phòng Kỹ thuật</div>
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
                                        <span>ƯỚC TÍNH NET (VND)</span>
                                        <span class="badge bg-white text-primary" style="font-size:0.65rem;" id="calcNetPct">87.7% Gross</span>
                                    </div>
                                    <div class="banner-amount" id="calcNetDisplay">~ 27.200.000 đ</div>
                                    <div class="banner-sub">Tạm tính sau BHXH (10.5%) &amp; Thuế TNCN (0 NPT)</div>
                                </div>

                                <div class="salary-breakdown-row">
                                    <span style="color:#64748b;">• Lương cơ bản:</span>
                                    <strong id="calcBaseDisplay">28.500.000 đ</strong>
                                </div>
                                <div class="salary-breakdown-row">
                                    <span style="color:#64748b;">• Tổng phụ cấp:</span>
                                    <strong style="color:#059669;" id="calcAllowanceDisplay">+ 2.500.000 đ</strong>
                                </div>
                                <div class="salary-breakdown-row" style="border-top:1px solid #e2e8f0; font-weight:700;">
                                    <span>Tổng Gross hợp đồng:</span>
                                    <span id="calcGrossDisplay">31.000.000 đ</span>
                                </div>
                                <div class="salary-breakdown-row" style="font-size:0.74rem;">
                                    <span style="color:#64748b;">Khấu trừ BHXH, BHYT, BHTN (10.5%):</span>
                                    <span style="color:#ef4444;" id="calcBhxhDisplay">- 2.992.500 đ</span>
                                </div>
                                <div class="salary-breakdown-row" style="font-size:0.74rem;">
                                    <span style="color:#64748b;">Thuế TNCN tạm tính:</span>
                                    <span style="color:#ef4444;" id="calcTaxDisplay">- 807.500 đ</span>
                                </div>

                                <div class="donut-container">
                                    <div class="donut-circle">
                                        <span class="donut-text" id="calcDonutPct">88%</span>
                                    </div>
                                    <div>
                                        <div style="font-size:0.73rem; font-weight:800; color:#1e293b;">TỶ LỆ GIỮ LƯƠNG THỰC TẾ</div>
                                        <div style="font-size:0.68rem; color:#64748b; line-height:1.3;">
                                            Nhân viên nhận xấp xỉ 88% tổng chi phí nhân sự cơ bản theo quy chế pháp lý.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- PANEL STEP 4 SIDEBAR -->
                        <div id="sidePanelStep4" style="display:none;">
                            <div class="sidebar-card">
                                <div class="sidebar-card-body">
                                    <div style="font-size:0.72rem; font-weight:800; color:#64748b; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:8px;">
                                        TỔNG KẾT HỒ SƠ ONBOARDING
                                    </div>
                                    <div class="d-flex align-items-center gap-2 mb-3">
                                        <div class="form-section-icon green"><i class="bi bi-check2-circle"></i></div>
                                        <div>
                                            <div style="font-size:0.86rem; font-weight:800; color:#0f172a;">Hồ sơ sẵn sàng nộp</div>
                                            <div style="font-size:0.72rem; color:#059669; font-weight:600;">Đã hoàn thành 3/4 bước</div>
                                        </div>
                                    </div>
                                    <div class="sys-info-row">
                                        <span class="sys-info-label">Mã nhân viên:</span>
                                        <strong id="finalEmpCode" class="text-primary font-monospace">NV014</strong>
                                    </div>
                                    <div class="sys-info-row">
                                        <span class="sys-info-label">Mã hợp đồng:</span>
                                        <strong id="finalContractCode" class="text-success font-monospace">HD012</strong>
                                    </div>
                                    <div class="sys-info-row">
                                        <span class="sys-info-label">Chức danh:</span>
                                        <strong id="finalPosition">Kỹ sư phần mềm</strong>
                                    </div>
                                    <div class="sys-info-row">
                                        <span class="sys-info-label">Mức lương:</span>
                                        <strong id="finalSalary">28.500.000 đ</strong>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- ============================================================ -->
                    <!-- RIGHT COLUMN: STEP PANELS                                    -->
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
                                                   name="fullName" id="fullName" required placeholder="VD: Nguyễn Văn An"
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
                                                       placeholder="NV014" readonly>
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
                                                   value="${empty employee.dateOfBirth ? '1996-08-20' : employee.dateOfBirth}"
                                                   onchange="calculateAge()">
                                        </div>

                                        <!-- Giới tính -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Giới tính <span class="req">*</span></label>
                                            <div class="pill-radio-group">
                                                <div class="pill-radio-option">
                                                    <input type="radio" name="gender" id="genderMale" value="MALE"
                                                           ${empty employee.gender or employee.gender eq 'MALE' ? 'checked' : ''} onchange="updateGenderDisplay()">
                                                    <label for="genderMale"><i class="bi bi-gender-male me-1"></i> Nam</label>
                                                </div>
                                                <div class="pill-radio-option">
                                                    <input type="radio" name="gender" id="genderFemale" value="FEMALE"
                                                           ${employee.gender eq 'FEMALE' ? 'checked' : ''} onchange="updateGenderDisplay()">
                                                    <label for="genderFemale"><i class="bi bi-gender-female me-1"></i> Nữ</label>
                                                </div>
                                                <div class="pill-radio-option">
                                                    <input type="radio" name="gender" id="genderOther" value="OTHER"
                                                           ${employee.gender eq 'OTHER' ? 'checked' : ''} onchange="updateGenderDisplay()">
                                                    <label for="genderOther">Khác</label>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Số CCCD -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Số CCCD / Hộ chiếu (12 số) <span class="req">*</span></label>
                                            <div class="position-relative">
                                                <input type="text" class="form-control form-control-custom step1-input"
                                                       name="idNumber" id="idNumber" required placeholder="001095012345"
                                                       maxlength="12" pattern="[0-9]{9,12}" value="001095012345"
                                                       oninput="validateCccd(this)">
                                                <i class="bi bi-check-circle-fill text-success position-absolute" id="cccdValidIcon"
                                                   style="right:12px; top:50%; transform:translateY(-50%); font-size:1rem; display:block;"></i>
                                            </div>
                                        </div>

                                        <!-- Ngày cấp CCCD -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Ngày cấp CCCD <span class="req">*</span></label>
                                            <input type="date" class="form-control form-control-custom step1-input"
                                                   name="idIssueDate" id="idIssueDate" required value="2021-05-10">
                                        </div>

                                        <!-- Nơi cấp -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">Nơi cấp <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom step1-input"
                                                   name="idIssuePlace" id="idIssuePlace" required
                                                   placeholder="Cục Cảnh sát Quản lý hành chính về trật tự xã hội"
                                                   value="Cục Cảnh sát Quản lý hành chính về trật tự xã hội">
                                        </div>

                                        <!-- Dân tộc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Dân tộc</label>
                                            <select class="form-select form-select-custom" name="ethnicity" id="ethnicity">
                                                <option value="Kinh" selected>Kinh</option>
                                                <option value="Tày">Tày</option>
                                                <option value="Thái">Thái</option>
                                                <option value="Mường">Mường</option>
                                                <option value="Khác">Khác</option>
                                            </select>
                                        </div>

                                        <!-- Tôn giáo -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tôn giáo</label>
                                            <input type="text" class="form-control form-control-custom" name="religion"
                                                   id="religion" placeholder="Không" value="Không">
                                        </div>

                                        <!-- Quốc tịch -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Quốc tịch</label>
                                            <input type="text" class="form-control form-control-custom" name="nationality"
                                                   id="nationality" value="Việt Nam">
                                        </div>

                                        <!-- Tình trạng hôn nhân -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tình trạng hôn nhân</label>
                                            <select class="form-select form-select-custom" name="maritalStatus">
                                                <option value="SINGLE" selected>Độc thân</option>
                                                <option value="MARRIED">Đã kết hôn</option>
                                                <option value="OTHER">Khác</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 1.2: Liên lạc & Địa chỉ cư trú -->
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
                                                   name="email" id="email" required placeholder="nguyenvanan.95@gmail.com"
                                                   value="<c:out value='${employee.email}'/>"
                                                   oninput="document.getElementById('sideProfileEmail').innerText = this.value || 'Chưa nhập'">
                                        </div>

                                        <!-- Email công ty dự kiến (TỰ ĐỘNG SINH) -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Email công ty dự kiến <span class="req">*</span></span>
                                                <span class="badge bg-primary-subtle text-primary" style="font-size:0.65rem;">Tự động tạo</span>
                                            </label>
                                            <div class="input-group">
                                                <input type="text" class="form-control form-control-custom"
                                                       name="companyEmailPrefix" id="companyEmailPrefix"
                                                       placeholder="an.nv" style="border-radius:10px 0 0 10px; border-right:none;"
                                                       value="an.nv">
                                                <span class="input-group-text" style="border-radius:0 10px 10px 0; background:#f1f5f9; font-size:0.85rem; font-weight:700; color:#2563eb; border-color:#e2e8f0;">@miximoi.vn</span>
                                            </div>
                                        </div>

                                        <!-- Số điện thoại chính -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Số điện thoại chính <span class="req">*</span></label>
                                            <input type="tel" class="form-control form-control-custom step1-input"
                                                   name="phone" id="phone" required placeholder="0912 345 678"
                                                   value="<c:out value='${employee.phone}'/>"
                                                   oninput="document.getElementById('sideProfilePhone').innerText = this.value || 'Chưa nhập'">
                                        </div>

                                        <!-- Liên hệ khẩn cấp -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Liên hệ khẩn cấp (Họ tên + SĐT + Quan hệ) <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom"
                                                   name="emergencyContact" id="emergencyContact"
                                                   placeholder="Nguyễn Văn Bình (Bố) - 0988 112 233"
                                                   value="Nguyễn Văn Bình (Bố) - 0988 112 233">
                                        </div>

                                        <!-- Địa chỉ thường trú -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">Địa chỉ thường trú (Ghi rõ theo CCCD) <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom step1-input"
                                                   name="address" id="address" required
                                                   placeholder="Số 45, Đường Lê Duẩn, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh"
                                                   value="<c:out value='${employee.address}'/>"
                                                   oninput="document.getElementById('sideProfileAddr').innerText = this.value || 'Chưa nhập'">
                                        </div>

                                        <!-- Địa chỉ tạm trú -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">
                                                <span>Địa chỉ tạm trú / Nơi ở hiện nay <span class="req">*</span></span>
                                                <label style="font-weight:500; font-size:0.75rem; color:#475569; cursor:pointer; display:flex; align-items:center; gap:4px;">
                                                    <input type="checkbox" id="sameAddressCheck" onchange="toggleSameAddress(this)"> Giống địa chỉ thường trú
                                                </label>
                                            </label>
                                            <input type="text" class="form-control form-control-custom"
                                                   name="tempAddress" id="tempAddress"
                                                   placeholder="Tòa Landmark 2, KĐT Vinhomes Central Park, 208 Nguyễn Hữu Cảnh, Q. Bình Thạnh, TP.HCM"
                                                   value="Tòa Landmark 2, KĐT Vinhomes Central Park, 208 Nguyễn Hữu Cảnh, Q. Bình Thạnh, TP.HCM">
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
                                    <span class="badge bg-secondary-subtle text-secondary" id="uploadedDocCountBadge" style="font-size:0.68rem;">Đã tải lên 2/3 tệp</span>
                                </div>
                                <div class="form-section-body">
                                    <div class="doc-upload-grid">
                                        <!-- Mặt trước CCCD -->
                                        <div class="doc-upload-card" onclick="triggerDocUpload('cccdFrontInput')">
                                            <img id="cccdFrontPreview" src="https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=300&auto=format&fit=crop&q=80"
                                                 class="doc-upload-preview" alt="Mặt trước CCCD">
                                            <input type="file" id="cccdFrontInput" accept="image/*,.pdf" style="display:none;" onchange="handleDocFile(this, 'cccdFrontPreview', 'cccdFrontName')">
                                            <div class="doc-upload-title">
                                                <span>Mặt trước CCCD</span>
                                                <i class="bi bi-check-circle-fill text-primary"></i>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mt-2" style="font-size:0.7rem;">
                                                <span class="text-truncate" id="cccdFrontName" style="max-width:90px;">cccd_mat_truoc.pdf</span>
                                                <span class="text-danger fw-bold" onclick="event.stopPropagation(); clearDocUpload('cccdFrontPreview', 'cccdFrontName')">Xóa</span>
                                            </div>
                                        </div>

                                        <!-- Mặt sau CCCD -->
                                        <div class="doc-upload-card" onclick="triggerDocUpload('cccdBackInput')">
                                            <img id="cccdBackPreview" src="https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=300&auto=format&fit=crop&q=80"
                                                 class="doc-upload-preview" alt="Mặt sau CCCD">
                                            <input type="file" id="cccdBackInput" accept="image/*,.pdf" style="display:none;" onchange="handleDocFile(this, 'cccdBackPreview', 'cccdBackName')">
                                            <div class="doc-upload-title">
                                                <span>Mặt sau CCCD</span>
                                                <i class="bi bi-check-circle-fill text-primary"></i>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mt-2" style="font-size:0.7rem;">
                                                <span class="text-truncate" id="cccdBackName" style="max-width:90px;">cccd_mat_sau.pdf</span>
                                                <span class="text-danger fw-bold" onclick="event.stopPropagation(); clearDocUpload('cccdBackPreview', 'cccdBackName')">Xóa</span>
                                            </div>
                                        </div>

                                        <!-- Sơ yếu lý lịch / Khám SK -->
                                        <div class="doc-upload-card d-flex flex-column justify-content-center align-items-center" style="min-height:140px;" onclick="triggerDocUpload('resumeInput')">
                                            <i class="bi bi-file-earmark-arrow-up text-primary" style="font-size:1.8rem; margin-bottom:4px;"></i>
                                            <input type="file" id="resumeInput" accept=".pdf,.docx,.doc" style="display:none;" onchange="handleResumeFile(this)">
                                            <div class="doc-upload-title" id="resumeTitle">Sơ yếu lí lịch / Khám SK</div>
                                            <div class="doc-upload-sub" id="resumeSub">Kéo thả tệp hoặc bấm để chọn</div>
                                            <span class="badge bg-light text-muted mt-2" id="resumeBadge" style="font-size:0.65rem;">PDF, DOCX &lt;= 10MB</span>
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
                                            <div class="form-section-desc">Phân bổ cấu trúc phòng ban và lọc các vị trí thiếu phù hợp với nghiệp vụ</div>
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
                                                        <c:out value="${dept.name}"/>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Khối / Chi nhánh -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Khối / Chi nhánh làm việc <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="workLocation" id="workLocation">
                                                <option value="HO" selected>Trụ sở chính Landmark 81, TP. HCM</option>
                                                <option value="HN">Chi nhánh Hà Nội (Keangnam Landmark 72)</option>
                                                <option value="DN">Chi nhánh Đà Nẵng</option>
                                                <option value="REMOTE">Làm việc từ xa (Remote)</option>
                                            </select>
                                        </div>

                                        <!-- Quota Banner Widget (Hiển thị định biên & vị trí còn thiếu) -->
                                        <div class="col-12">
                                            <div class="quota-banner has-dept" id="deptQuotaBanner">
                                                <div class="quota-header">
                                                    <div>
                                                        <div style="font-weight:800; font-size:0.9rem; color:#0f172a;" id="quotaDeptName">
                                                            🏢 Phòng Kỹ thuật (Kỹ thuật phần mềm &amp; Hệ thống)
                                                        </div>
                                                        <div style="font-size:0.75rem; color:#64748b;" id="quotaDeptDesc">
                                                            Nghiệp vụ: Phát triển và duy trì hệ sinh thái sản phẩm công nghệ MIXIMOI
                                                        </div>
                                                    </div>
                                                    <span class="quota-badge-vacant" id="quotaVacantBadge">
                                                        <i class="bi bi-person-plus-fill"></i> Còn thiếu 11 chỉ tiêu
                                                    </span>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                                    <span style="font-weight:700; color:#1e293b;" id="quotaRatioText">Hiện có 4 / 15 nhân sự</span>
                                                    <span style="font-weight:800; color:#2563eb;" id="quotaPctText">27% định biên</span>
                                                </div>
                                                <div class="quota-progress">
                                                    <div class="quota-progress-bar" id="quotaProgressBar" style="width:27%;"></div>
                                                </div>
                                                <div style="font-size:0.72rem; color:#64748b; margin-top:4px;" id="quotaRecruitHint">
                                                    <i class="bi bi-info-circle me-1 text-primary"></i> Đang mở cổng tuyển dụng để bổ sung nhân sự cho các vị trí chuyên môn còn thiếu.
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Chức danh / Vị trí chuyên môn (LỌC THEO PHÒNG BAN) -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Chức danh / Vị trí chuyên môn <span class="req">*</span></span>
                                                <span class="text-primary fw-normal" style="font-size:0.72rem;" id="posFilterNote">
                                                    <i class="bi bi-funnel-fill"></i> Đã lọc theo nghiệp vụ phòng
                                                </span>
                                            </label>
                                            <select class="form-select form-select-custom" name="positionId" id="positionId" required
                                                    onchange="handlePositionChange(this.value)">
                                                <option value="">— Chọn chức vụ phù hợp —</option>
                                                <!-- Populated dynamically via JS matching department -->
                                            </select>
                                            <div id="positionVacantAlert" class="position-vacant-info d-none">
                                                <i class="bi bi-bell-fill"></i>
                                                <span id="positionVacantMsg">Vị trí này đang thiếu 7 nhân sự so với chỉ tiêu định biên.</span>
                                            </div>
                                        </div>

                                        <!-- Cấp bậc nhân sự (Level) -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Cấp bậc nhân sự (Level) <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="employeeLevel" id="employeeLevel">
                                                <option value="L1">Level 1 - Junior Associate</option>
                                                <option value="L2">Level 2 - Specialist (Chuyên viên)</option>
                                                <option value="L3" selected>Level 3 - Senior Specialist (Chuyên gia)</option>
                                                <option value="L4">Level 4 - Lead / Principal Specialist</option>
                                                <option value="L5">Level 5 - Manager / Director</option>
                                            </select>
                                        </div>

                                        <!-- Quản lý trực tiếp -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Quản lý trực tiếp (Direct Manager) <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom" name="lineManager"
                                                   id="lineManager" placeholder="Lê Hoàng Nam (NV002) - Giám đốc Công nghệ"
                                                   value="Lê Hoàng Nam (NV002) - Giám đốc Công nghệ">
                                        </div>

                                        <!-- Người hướng dẫn -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Người hướng dẫn (Mentor / Buddy Onboarding)</label>
                                            <input type="text" class="form-control form-control-custom" name="mentorName"
                                                   id="mentorName" placeholder="Vũ Quỳnh Chi (NV034) - Principal Staff Engineer"
                                                   value="Vũ Quỳnh Chi (NV034) - Principal Staff Engineer">
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
                                            <select class="form-select form-select-custom" name="employeeTypeId" id="employeeTypeId">
                                                <option value="1" ${empty employee.employeeTypeId or employee.employeeTypeId == 1 ? 'selected' : ''}>Toàn thời gian (Full-time)</option>
                                                <option value="2" ${employee.employeeTypeId == 2 ? 'selected' : ''}>Nhân viên thử việc</option>
                                                <option value="3" ${employee.employeeTypeId == 3 ? 'selected' : ''}>Nhân viên thời vụ</option>
                                                <option value="4" ${employee.employeeTypeId == 4 ? 'selected' : ''}>Cộng tác viên (Part-time)</option>
                                            </select>
                                        </div>

                                        <!-- Ca làm việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Ca làm việc áp dụng <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="defaultShift" id="defaultShift">
                                                <option value="1" selected>Ca hành chính: 08:00 - 17:30 (Nghỉ trưa 12:00 - 13:30)</option>
                                                <option value="2">Ca linh hoạt (Flexible: 08:30 - 18:00)</option>
                                                <option value="3">Ca ca kíp (Theo phân công tổ chức)</option>
                                            </select>
                                        </div>

                                        <!-- Ngày bắt đầu nhận việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Ngày bắt đầu nhận việc (Onboarding) <span class="req">*</span></label>
                                            <input type="date" class="form-control form-control-custom" name="startDate"
                                                   id="startDate" required value="2026-09-15">
                                        </div>

                                        <!-- Thời gian thử việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Thời gian thử việc <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="probationDuration" id="probationDuration">
                                                <option value="2" selected>02 tháng (85% - 100% lương theo thoả thuận)</option>
                                                <option value="1">01 tháng (85% lương)</option>
                                                <option value="0">Không thử việc (Ký chính thức ngay)</option>
                                            </select>
                                        </div>

                                        <!-- Địa điểm & Cấu hình chấm công -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">Địa điểm &amp; Cấu hình chấm công <span class="req">*</span></label>
                                            <div class="p-3 border rounded-3 bg-light d-flex align-items-center justify-content-between">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="form-section-icon blue"><i class="bi bi-geo-alt-fill"></i></div>
                                                    <div>
                                                        <div style="font-weight:700; font-size:0.85rem; color:#0f172a;">Văn phòng chính - Tầng 6 Tháp A Landmark 81</div>
                                                        <div style="font-size:0.72rem; color:#64748b;">BSSID: MIXIMOI_CORP_5G • GPS Bán kính: 150m</div>
                                                    </div>
                                                </div>
                                                <span class="badge bg-success-subtle text-success" style="font-size:0.72rem;">
                                                    <i class="bi bi-check-circle me-1"></i>Tích hợp FaceID &amp; WiFi ID
                                                </span>
                                            </div>
                                        </div>

                                        <!-- Trạng thái ẩn -->
                                        <input type="hidden" name="status" id="empStatus" value="ACTIVE">
                                    </div>
                                </div>
                            </div>

                            <!-- Section 2.3: Thiết lập Tài nguyên & Công cụ -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon green"><i class="bi bi-laptop"></i></div>
                                        <div>
                                            <h3 class="form-section-title">3. Thiết lập Tài nguyên &amp; Công cụ làm việc</h3>
                                            <div class="form-section-desc">Cấp quyền truy cập hệ thống và đăng ký tài sản CNTT</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Email công ty đề xuất <span class="req">*</span></label>
                                            <div class="position-relative">
                                                <input type="text" class="form-control form-control-custom" id="step2CompanyEmail"
                                                       value="an.nv@miximoi.vn" readonly style="padding-right:32px;">
                                                <i class="bi bi-check-circle-fill text-success position-absolute" style="right:10px; top:50%; transform:translateY(-50%);"></i>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Phân quyền hệ thống HRM <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="systemRole">
                                                <option value="EMPLOYEE" selected>Nhân viên thông thường (Self-service Portal)</option>
                                                <option value="MANAGER">Quản lý phê duyệt (Line Manager)</option>
                                                <option value="HR">Chuyên viên Nhân sự (HR Officer)</option>
                                            </select>
                                        </div>

                                        <div class="col-md-12">
                                            <label class="form-label-custom">Yêu cầu cấp phát trang thiết bị (IT Asset Request)</label>
                                            <div class="row g-2">
                                                <div class="col-md-4">
                                                    <div class="p-2 border rounded-2 bg-light d-flex align-items-center gap-2">
                                                        <input type="checkbox" class="form-check-input mt-0" checked>
                                                        <div>
                                                            <div style="font-weight:700; font-size:0.78rem;">MacBook Pro 16"</div>
                                                            <div style="font-size:0.68rem; color:#64748b;">M3 Pro / 36GB / 512GB</div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="p-2 border rounded-2 bg-light d-flex align-items-center gap-2">
                                                        <input type="checkbox" class="form-check-input mt-0" checked>
                                                        <div>
                                                            <div style="font-weight:700; font-size:0.78rem;">Màn hình Dell UltraSharp</div>
                                                            <div style="font-size:0.68rem; color:#64748b;">27" 4K IPS USB-C Hub</div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="p-2 border rounded-2 bg-light d-flex align-items-center gap-2">
                                                        <input type="checkbox" class="form-check-input mt-0" checked>
                                                        <div>
                                                            <div style="font-weight:700; font-size:0.78rem;">Thẻ từ &amp; Tag ra vào</div>
                                                            <div style="font-size:0.68rem; color:#64748b;">Thẻ nhân viên bảo mật NFC</div>
                                                        </div>
                                                    </div>
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
                                            <div class="form-section-desc">Căn cứ tính đơn giá ngày công và chính sách trích lập bắt buộc</div>
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
                                                <input type="text" class="form-control form-control-custom fw-bold text-primary fs-6"
                                                       name="baseSalary" id="baseSalary" required
                                                       value="28.500.000" placeholder="28.500.000"
                                                       oninput="formatSalaryInput(this)">
                                                <span class="position-absolute end-0 top-50 translate-middle-y me-3 text-muted fw-bold" style="font-size:0.78rem;">VNĐ / Tháng</span>
                                            </div>
                                            <div style="font-size:0.72rem; color:#94a3b8; margin-top:4px;" id="salaryRangeHint">
                                                Khung dải lương vị trí: 25.000.000 – 35.000.000 VNĐ
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
                                                Thử việc 2 tháng: 24.225.000 VNĐ/tháng
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
                                                            <div style="font-size:0.7rem; font-weight:400; color:#64748b;">Trích đóng dựa trên 100% lương cơ bản</div>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="p-3 border rounded-3 bg-light d-flex align-items-center gap-2">
                                                        <input type="radio" name="insuranceBasis" id="ib2" value="CAP" onchange="recalcCompensation()">
                                                        <label for="ib2" style="font-size:0.8rem; font-weight:700; cursor:pointer;">
                                                            Đóng theo trần quy định Nhà nước
                                                            <div style="font-size:0.7rem; font-weight:400; color:#64748b;">Giới hạn tối đa 20 lần mức lương cơ sở (36.000.000 VNĐ)</div>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Chu kỳ trả lương -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Chu kỳ trả lương định kỳ</label>
                                            <div class="position-relative">
                                                <input type="text" class="form-control form-control-custom" value="Hàng tháng vào ngày 05 tháng tiếp theo" readonly>
                                                <i class="bi bi-calendar-check position-absolute end-0 top-50 translate-middle-y me-3 text-muted"></i>
                                            </div>
                                        </div>

                                        <!-- Quy chuẩn số ngày làm việc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Quy chuẩn số ngày làm việc chuẩn</label>
                                            <div class="position-relative">
                                                <input type="text" class="form-control form-control-custom" value="Theo ngày làm việc thực tế trong tháng (T2 - T6)" readonly>
                                                <i class="bi bi-info-circle position-absolute end-0 top-50 translate-middle-y me-3 text-muted"></i>
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
                                            <div class="form-section-desc">Phụ cấp không chịu thuế theo quy định thỏa ước lao động tập thể</div>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-outline-primary" style="font-size:0.75rem; border-radius:8px;" onclick="addCustomAllowance()">
                                        <i class="bi bi-plus-circle me-1"></i>Thêm phụ cấp khác
                                    </button>
                                </div>
                                <div class="form-section-body" id="allowanceListContainer">
                                    <!-- Phụ cấp ăn trưa -->
                                    <div class="allowance-box-item active" id="allowanceRowLunch">
                                        <div class="allowance-left">
                                            <input type="checkbox" class="form-check-input mt-0" id="alLunch" checked onchange="toggleAllowanceRow(this, 1000000)">
                                            <div>
                                                <div class="allowance-name">Phụ cấp ăn trưa <span class="badge bg-success-subtle text-success ms-1" style="font-size:0.65rem;">Miễn thuế TNCN</span></div>
                                                <div class="allowance-sub">Hỗ trợ suất ăn giữa ca làm việc hàng ngày</div>
                                            </div>
                                        </div>
                                        <div class="allowance-amount">1.000.000 đ / tháng</div>
                                    </div>

                                    <!-- Phụ cấp xăng xe -->
                                    <div class="allowance-box-item active" id="allowanceRowGas">
                                        <div class="allowance-left">
                                            <input type="checkbox" class="form-check-input mt-0" id="alGas" checked onchange="toggleAllowanceRow(this, 1000000)">
                                            <div>
                                                <div class="allowance-name">Phụ cấp xăng xe / đi lại <span class="badge bg-info-subtle text-info ms-1" style="font-size:0.65rem;">Hỗ trợ di chuyển</span></div>
                                                <div class="allowance-sub">Chi phí công tác, nhiên liệu phương tiện cá nhân</div>
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
                                                <div class="allowance-sub">Gói cước 4G và thoại phục vụ công việc chuyên môn</div>
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
                                                    <input type="radio" name="contractType" id="ctIndefinite" value="INDEFINITE" checked>
                                                    <label for="ctIndefinite">
                                                        <i class="bi bi-infinity text-success"></i>
                                                        <span class="c-name">Không xác định</span>
                                                        <span class="c-sub">Dài hạn, ổn định</span>
                                                    </label>
                                                </div>
                                                <div class="contract-card-opt">
                                                    <input type="radio" name="contractType" id="ctFixed" value="FIXED_TERM">
                                                    <label for="ctFixed">
                                                        <i class="bi bi-calendar-range text-primary"></i>
                                                        <span class="c-name">Xác định thời hạn</span>
                                                        <span class="c-sub">1–3 năm</span>
                                                    </label>
                                                </div>
                                                <div class="contract-card-opt">
                                                    <input type="radio" name="contractType" id="ctSeasonal" value="SEASONAL">
                                                    <label for="ctSeasonal">
                                                        <i class="bi bi-sun text-warning"></i>
                                                        <span class="c-name">Thời vụ</span>
                                                        <span class="c-sub">Ngắn hạn</span>
                                                    </label>
                                                </div>
                                                <div class="contract-card-opt">
                                                    <input type="radio" name="contractType" id="ctProbation" value="PROBATION">
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
                                                <input type="text" class="form-control form-control-custom"
                                                       name="contractCode" id="contractCode" required
                                                       value="${empty nextContractCode ? 'HD012' : nextContractCode}"
                                                       placeholder="HD012" readonly>
                                                <button type="button" class="auto-code-badge-btn" onclick="regenerateContractCode()" title="Tự động sinh mã hợp đồng">
                                                    <i class="bi bi-magic"></i> Tự sinh mã
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Ngày ký hợp đồng -->
                                        <div class="col-md-3">
                                            <label class="form-label-custom">Ngày ký hợp đồng <span class="req">*</span></label>
                                            <input type="date" class="form-control form-control-custom"
                                                   name="contractSignDate" id="contractSignDate" required value="2026-09-15">
                                        </div>

                                        <!-- Ngày hết hạn -->
                                        <div class="col-md-3">
                                            <label class="form-label-custom">Ngày hết hạn <small class="text-muted">(Nếu có)</small></label>
                                            <input type="date" class="form-control form-control-custom"
                                                   name="contractEndDate" id="contractEndDate">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section 4.2: Bảo hiểm & Thuế -->
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon orange"><i class="bi bi-shield-lock"></i></div>
                                        <div>
                                            <h3 class="form-section-title">2. Đăng ký Bảo hiểm &amp; Thuế</h3>
                                            <div class="form-section-desc">Mã số BHXH, mã số thuế cá nhân và nơi đăng ký KCB</div>
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
                                            <input type="text" class="form-control form-control-custom font-monospace"
                                                   name="bhxhCode" id="bhxhCode" placeholder="0101988234" value="0101988234">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Mã số thuế cá nhân (MST)</span>
                                                <span class="text-primary fw-normal" style="font-size:0.72rem; cursor:pointer;" onclick="autoGenTaxCode()">
                                                    <i class="bi bi-magic"></i> Gợi ý mã
                                                </span>
                                            </label>
                                            <input type="text" class="form-control form-control-custom font-monospace"
                                                   name="taxCode" id="taxCode" placeholder="8492019482" value="8492019482">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">Nơi đăng ký KCB ban đầu</label>
                                            <input type="text" class="form-control form-control-custom"
                                                   name="kcbPlace" id="kcbPlace" placeholder="Bệnh viện Nhân dân Gia Định"
                                                   value="Bệnh viện Nhân dân Gia Định - TP.HCM">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tài khoản ngân hàng chi trả lương</label>
                                            <div class="input-group">
                                                <select class="form-select form-select-custom" style="max-width:130px;" name="bankName">
                                                    <option value="VCB" selected>VCB</option>
                                                    <option value="TCB">Techcombank</option>
                                                    <option value="MB">MB Bank</option>
                                                    <option value="ACB">ACB</option>
                                                </select>
                                                <input type="text" class="form-control form-control-custom" name="bankAccount"
                                                       id="bankAccount" placeholder="Số TK: 1029384829" value="1029384829">
                                            </div>
                                        </div>

                                        <!-- Final Confirmation Box -->
                                        <div class="col-12 mt-2">
                                            <div style="background: linear-gradient(135deg, #f0fdf4, #dcfce7); border:1.5px solid #86efac; border-radius:12px; padding:1.1rem 1.25rem;">
                                                <div style="font-size:0.9rem; font-weight:800; color:#15803d; margin-bottom:4px; display:flex; align-items:center; gap:8px;">
                                                    <i class="bi bi-check-circle-fill fs-5"></i> Xác nhận hoàn tất &amp; Lưu hồ sơ nhân viên
                                                </div>
                                                <div style="font-size:0.8rem; color:#166534; line-height:1.5;">
                                                    Tôi xác nhận rằng toàn bộ thông tin kê khai trên là hoàn toàn chính xác, đúng pháp lý và đã đối chiếu với giấy tờ gốc. Dữ liệu nhân viên và hợp đồng lao động sẽ được đồng bộ ngay lập tức vào cơ sở dữ liệu MIXIMOI HRM.
                                                </div>
                                                <div class="mt-2 pt-2 border-top border-success-subtle">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox" id="confirmAccuracy" required checked>
                                                        <label class="form-check-label fw-bold text-success" for="confirmAccuracy" style="font-size:0.82rem; cursor:pointer;">
                                                            Tôi đã kiểm tra kỹ và xác nhận lưu hồ sơ nhân sự này <span class="text-danger">*</span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div><!-- END PANEL STEP 4 -->

                    </div><!-- END RIGHT COLUMN -->

                </div><!-- END WIZARD LAYOUT -->

                <!-- ============================================================ -->
                <!-- STICKY ACTION BAR                                            -->
                <!-- ============================================================ -->
                <div class="wizard-action-bar">
                    <div style="font-size:0.78rem; color:#64748b; display:flex; align-items:center; gap:8px;">
                        <a href="${pageContext.request.contextPath}/employees" class="btn btn-sm btn-light border text-muted px-2" style="font-size:0.75rem;" onclick="return confirmDiscard();">
                            <i class="bi bi-x-circle me-1"></i>Hủy bỏ
                        </a>
                        <i class="bi bi-cloud-check text-success fs-6 ms-2"></i>
                        <span>Đã lưu nháp: <strong id="autoSaveTimer">Vừa xong</strong></span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <button type="button" class="btn-prev-step" id="btnPrev" onclick="prevStep()" disabled>
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </button>
                        <button type="button" class="btn btn-outline-secondary" style="height:42px; border-radius:10px; font-weight:600; font-size:0.85rem;" onclick="saveDraft()">
                            <i class="bi bi-floppy me-1"></i> Lưu bản nháp
                        </button>
                        <button type="button" class="btn-next-step" id="btnNext" onclick="nextStep()">
                            <span id="btnNextText">Tiếp tục: Bước 2 (Công việc &amp; Vị trí)</span>
                            <i class="bi bi-arrow-right"></i>
                        </button>
                        <button type="submit" class="btn-submit-step" id="btnSubmit" style="display:none;">
                            <i class="bi bi-check2-all fs-5"></i>
                            <span>Hoàn tất &amp; Lưu hồ sơ</span>
                        </button>
                    </div>
                </div>

            </form><!-- END FORM -->

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- ==========================================================================
     CLIENT JAVASCRIPT: ENTERPRISE LOGIC & HEADCOUNT QUOTA MANAGEMENT
     ========================================================================== -->
<script>
    // =========================================================================
    // 1. DATA DICTIONARY: DEPARTMENT QUOTAS & SUITABLE POSITIONS
    // =========================================================================
    // Quota definition for each department and its matching professional positions
    const DEPARTMENT_DATA = {
        "1": { // Ban Giám đốc
            name: "Ban Giám đốc",
            desc: "Lãnh đạo và điều hành toàn diện chiến lược tập đoàn",
            targetCount: 4,
            currentCount: 3,
            manager: "Nguyễn Văn An (NV001) - Tổng Giám đốc",
            positions: [
                { id: 1, name: "Giám đốc", quota: 2, current: 1, vacant: 1, level: "L5", defaultSalary: "50.000.000", salaryRange: "45.000.000 – 70.000.000 VNĐ" },
                { id: 2, name: "Phó Giám đốc", quota: 2, current: 1, vacant: 1, level: "L5", defaultSalary: "40.000.000", salaryRange: "35.000.000 – 50.000.000 VNĐ" },
                { id: 3, name: "Trưởng phòng (Văn phòng HĐQT)", quota: 1, current: 0, vacant: 1, level: "L4", defaultSalary: "30.000.000", salaryRange: "25.000.000 – 35.000.000 VNĐ" }
            ]
        },
        "2": { // Phòng Nhân sự
            name: "Phòng Nhân sự (HR & Tuyển dụng)",
            desc: "Quản trị nguồn nhân lực, tuyển dụng, đào tạo & C&B",
            targetCount: 5,
            currentCount: 2,
            manager: "Trần Thị Bình (NV002) - Trưởng phòng Nhân sự",
            positions: [
                { id: 3, name: "Trưởng phòng Nhân sự", quota: 1, current: 1, vacant: 0, level: "L4", defaultSalary: "35.000.000", salaryRange: "30.000.000 – 40.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Nhân sự", quota: 1, current: 0, vacant: 1, level: "L3", defaultSalary: "26.000.000", salaryRange: "22.000.000 – 30.000.000 VNĐ" },
                { id: 8, name: "Chuyên viên HR (C&B / Tuyển dụng)", quota: 3, current: 1, vacant: 2, level: "L2", defaultSalary: "18.000.000", salaryRange: "15.000.000 – 22.000.000 VNĐ" },
                { id: 5, name: "Nhân viên Nhân sự", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "12.000.000", salaryRange: "10.000.000 – 14.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh HR", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "6.000.000", salaryRange: "5.000.000 – 7.000.000 VNĐ" }
            ]
        },
        "3": { // Phòng Kế toán
            name: "Phòng Kế toán (Tài chính & Kế toán)",
            desc: "Quản trị dòng tiền, thuế, kế toán doanh nghiệp & báo cáo tài chính",
            targetCount: 6,
            currentCount: 3,
            manager: "Lê Văn Cường (NV003) - Kế toán trưởng",
            positions: [
                { id: 3, name: "Trưởng phòng Kế toán (Kế toán trưởng)", quota: 1, current: 1, vacant: 0, level: "L4", defaultSalary: "35.000.000", salaryRange: "30.000.000 – 45.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Kế toán", quota: 1, current: 1, vacant: 0, level: "L3", defaultSalary: "25.000.000", salaryRange: "20.000.000 – 28.000.000 VNĐ" },
                { id: 9, name: "Kế toán viên (Tổng hợp / Thuế / Công nợ)", quota: 4, current: 1, vacant: 3, level: "L2", defaultSalary: "18.000.000", salaryRange: "14.000.000 – 22.000.000 VNĐ" },
                { id: 5, name: "Nhân viên Kế toán kho", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "12.000.000", salaryRange: "10.000.000 – 14.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh Kế toán", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "6.000.000", salaryRange: "5.000.000 – 7.000.000 VNĐ" }
            ]
        },
        "4": { // Phòng Kinh doanh
            name: "Phòng Kinh doanh (Sales & Khách hàng)",
            desc: "Phát triển thị trường, bán hàng B2B/B2C và chăm sóc khách hàng",
            targetCount: 10,
            currentCount: 2,
            manager: "Phạm Thị Dung (NV004) - Giám đốc Kinh doanh",
            positions: [
                { id: 3, name: "Trưởng phòng Kinh doanh", quota: 1, current: 0, vacant: 1, level: "L4", defaultSalary: "32.000.000", salaryRange: "28.000.000 – 40.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Kinh doanh", quota: 1, current: 0, vacant: 1, level: "L3", defaultSalary: "24.000.000", salaryRange: "20.000.000 – 28.000.000 VNĐ" },
                { id: 10, name: "Chuyên viên kinh doanh (Senior Sales)", quota: 8, current: 1, vacant: 7, level: "L2", defaultSalary: "18.000.000", salaryRange: "15.000.000 – 25.000.000 VNĐ" },
                { id: 5, name: "Nhân viên Telesales / CSKH", quota: 4, current: 0, vacant: 4, level: "L1", defaultSalary: "12.000.000", salaryRange: "10.000.000 – 15.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh Kinh doanh", quota: 3, current: 0, vacant: 3, level: "L1", defaultSalary: "6.000.000", salaryRange: "5.000.000 – 8.000.000 VNĐ" }
            ]
        },
        "5": { // Phòng Marketing
            name: "Phòng Marketing (Truyền thông & Thương hiệu)",
            desc: "Quảng bá thương hiệu, tiếp thị số, tổ chức sự kiện & Media",
            targetCount: 6,
            currentCount: 1,
            manager: "Hoàng Văn Em (NV005) - Trưởng phòng Marketing",
            positions: [
                { id: 3, name: "Trưởng phòng Marketing (CMO)", quota: 1, current: 0, vacant: 1, level: "L4", defaultSalary: "35.000.000", salaryRange: "30.000.000 – 45.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Marketing", quota: 1, current: 0, vacant: 1, level: "L3", defaultSalary: "25.000.000", salaryRange: "20.000.000 – 30.000.000 VNĐ" },
                { id: 5, name: "Chuyên viên Digital Marketing / Content", quota: 4, current: 1, vacant: 3, level: "L2", defaultSalary: "18.000.000", salaryRange: "15.000.000 – 22.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh Marketing / Design", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "6.000.000", salaryRange: "5.000.000 – 8.000.000 VNĐ" }
            ]
        },
        "6": { // Phòng Kỹ thuật
            name: "Phòng Kỹ thuật (Công nghệ thông tin & R&D)",
            desc: "Phát triển và duy trì hệ sinh thái sản phẩm công nghệ MIXIMOI",
            targetCount: 15,
            currentCount: 4,
            manager: "Lê Hoàng Nam (NV002) - Giám đốc Công nghệ (CTO)",
            positions: [
                { id: 3, name: "Trưởng phòng Kỹ thuật (Technical Lead)", quota: 1, current: 0, vacant: 1, level: "L4", defaultSalary: "40.000.000", salaryRange: "35.000.000 – 50.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Kỹ thuật", quota: 1, current: 0, vacant: 1, level: "L3", defaultSalary: "32.000.000", salaryRange: "28.000.000 – 38.000.000 VNĐ" },
                { id: 7, name: "Kỹ sư phần mềm (Backend/Frontend/Fullstack)", quota: 10, current: 3, vacant: 7, level: "L3", defaultSalary: "28.500.000", salaryRange: "22.000.000 – 35.000.000 VNĐ" },
                { id: 5, name: "Kỹ sư QA / QC Tester", quota: 3, current: 0, vacant: 3, level: "L2", defaultSalary: "18.000.000", salaryRange: "15.000.000 – 22.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh Lập trình viên (Fresher/Intern)", quota: 3, current: 1, vacant: 2, level: "L1", defaultSalary: "8.000.000", salaryRange: "6.000.000 – 10.000.000 VNĐ" }
            ]
        }
    };

    // =========================================================================
    // 2. WIZARD ENGINE & STATE
    // =========================================================================
    let currentStep = 1;
    const TOTAL_STEPS = 4;

    const stepHeaders = [
        "",
        "Thêm nhân viên mới",
        "Thêm nhân viên - Bước 2: Công việc & Định biên",
        "Thêm nhân viên - Bước 3: Thiết lập Lương & Phúc lợi",
        "Thêm nhân viên - Bước 4: Hợp đồng & Bảo hiểm"
    ];

    const stepButtons = [
        "",
        "Tiếp tục: Bước 2 (Công việc & Vị trí)",
        "Tiếp tục: Bước 3 (Lương & Phúc lợi)",
        "Tiếp tục: Bước 4 (Hợp đồng & Bảo hiểm)",
        "Hoàn tất & Lưu hồ sơ"
    ];

    // Initialize on Load
    document.addEventListener("DOMContentLoaded", function() {
        const today = new Date();
        const formattedDate = String(today.getDate()).padStart(2, '0') + '/' +
                              String(today.getMonth() + 1).padStart(2, '0') + '/' +
                              today.getFullYear();
        const dateEl = document.getElementById("sideCreatedDate");
        if (dateEl) dateEl.innerText = formattedDate;

        // Check for saved local draft
        checkSavedDraft();

        // Default department: Phòng Kỹ thuật (ID 6) if not selected
        const deptSelect = document.getElementById("departmentId");
        if (deptSelect && !deptSelect.value) {
            deptSelect.value = "6";
        }
        handleDepartmentChange(deptSelect ? deptSelect.value : "6");

        // Calculations
        recalcCompensation();
        calculateAge();

        // Start auto-save timer
        startAutoSaveInterval();
    });

    // Toast Notification helper
    function showToast(message, type = "success") {
        const container = document.getElementById("toastContainer");
        const toast = document.createElement("div");
        toast.className = `toast-custom ${type}`;
        let icon = "bi-check-circle-fill text-success";
        if (type === "warning") icon = "bi-exclamation-triangle-fill text-warning";
        if (type === "danger") icon = "bi-x-circle-fill text-danger";

        toast.innerHTML = `<i class="bi ${icon} fs-5"></i><div>${message}</div>`;
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = "0";
            toast.style.transform = "translateX(50px)";
            toast.style.transition = "all 0.3s ease";
            setTimeout(() => toast.remove(), 300);
        }, 3500);
    }

    // =========================================================================
    // 3. DEPARTMENT & POSITION FILTERING WITH HEADCOUNT LIMITS
    // =========================================================================
    function handleDepartmentChange(deptId) {
        const data = DEPARTMENT_DATA[deptId];
        const banner = document.getElementById("deptQuotaBanner");
        const posSelect = document.getElementById("positionId");

        if (!data) {
            banner.classList.remove("has-dept");
            banner.innerHTML = `<div class="text-muted" style="font-size:0.8rem;">Vui lòng chọn một phòng ban để xem chỉ tiêu định biên và các vị trí phù hợp.</div>`;
            posSelect.innerHTML = `<option value="">— Chọn chức vụ —</option>`;
            return;
        }

        banner.classList.add("has-dept");
        const vacantCount = Math.max(0, data.targetCount - data.currentCount);
        const pct = Math.min(100, Math.round((data.currentCount / data.targetCount) * 100));

        let badgeHtml = "";
        let barColor = "linear-gradient(90deg, #2563eb, #38bdf8)";
        if (vacantCount > 0) {
            badgeHtml = `<span class="quota-badge-vacant"><i class="bi bi-person-plus-fill"></i> Còn thiếu ${vacantCount} chỉ tiêu</span>`;
            barColor = "linear-gradient(90deg, #059669, #34d399)";
        } else {
            badgeHtml = `<span class="quota-badge-full"><i class="bi bi-exclamation-circle-fill"></i> Đã đủ định biên (${data.currentCount}/${data.targetCount})</span>`;
            barColor = "linear-gradient(90deg, #dc2626, #f87171)";
        }

        banner.innerHTML = `
            <div class="quota-header">
                <div>
                    <div style="font-weight:800; font-size:0.9rem; color:#0f172a;">
                        🏢 ${data.name}
                    </div>
                    <div style="font-size:0.75rem; color:#64748b;">
                        Nghiệp vụ: ${data.desc}
                    </div>
                </div>
                ${badgeHtml}
            </div>
            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                <span style="font-weight:700; color:#1e293b;">Hiện có ${data.currentCount} / ${data.targetCount} nhân sự</span>
                <span style="font-weight:800; color:#2563eb;">${pct}% định biên</span>
            </div>
            <div class="quota-progress">
                <div class="quota-progress-bar" style="width:${pct}%; background:${barColor};"></div>
            </div>
            <div style="font-size:0.72rem; color:#64748b; margin-top:4px;">
                <i class="bi bi-shield-check me-1 text-primary"></i> Quản lý trực tiếp phụ trách: <strong>${data.manager}</strong>
            </div>
        `;

        // Update default line manager
        const managerInput = document.getElementById("lineManager");
        if (managerInput && data.manager) {
            managerInput.value = data.manager;
        }

        // Populate positions matching this department
        posSelect.innerHTML = `<option value="">— Chọn chức vụ phù hợp (${data.positions.length} vị trí) —</option>`;
        data.positions.forEach(p => {
            const vacantNote = p.vacant > 0 ? `(Đang thiếu ${p.vacant} vị trí)` : `(Đã đủ định biên ${p.current}/${p.quota})`;
            const opt = document.createElement("option");
            opt.value = p.id;
            opt.innerText = `${p.name} ${vacantNote}`;
            opt.dataset.level = p.level;
            opt.dataset.salary = p.defaultSalary;
            opt.dataset.salaryRange = p.salaryRange;
            opt.dataset.vacant = p.vacant;
            posSelect.appendChild(opt);
        });

        // Select first position by default
        if (data.positions.length > 0) {
            posSelect.selectedIndex = 1;
            handlePositionChange(data.positions[0].id);
        }

        updateStep2Summary();
    }

    function handlePositionChange(posId) {
        const posSelect = document.getElementById("positionId");
        const selectedOpt = posSelect.options[posSelect.selectedIndex];
        if (!selectedOpt || !selectedOpt.value) return;

        const level = selectedOpt.dataset.level || "L3";
        const defSalary = selectedOpt.dataset.salary || "28.500.000";
        const salaryRange = selectedOpt.dataset.salaryRange || "25.000.000 – 35.000.000 VNĐ";
        const vacant = parseInt(selectedOpt.dataset.vacant || "1");

        // Update Level dropdown
        const levelSelect = document.getElementById("employeeLevel");
        if (levelSelect) levelSelect.value = level;

        // Update Position vacant alert
        const alertBox = document.getElementById("positionVacantAlert");
        const msgSpan = document.getElementById("positionVacantMsg");
        if (alertBox && msgSpan) {
            alertBox.classList.remove("d-none");
            if (vacant > 0) {
                alertBox.className = "position-vacant-info";
                msgSpan.innerHTML = `Vị trí <strong>${selectedOpt.text.split('(')[0].trim()}</strong> đang thiếu <strong>${vacant} nhân sự</strong> so với kế hoạch định biên.`;
            } else {
                alertBox.className = "position-vacant-info bg-warning-subtle text-warning border-warning";
                msgSpan.innerHTML = `Vị trí <strong>${selectedOpt.text.split('(')[0].trim()}</strong> đã đạt đủ chỉ tiêu định biên. Vui lòng cân nhắc khi tuyển thêm.`;
            }
        }

        // Suggest salary in Step 3
        const salaryInput = document.getElementById("baseSalary");
        if (salaryInput) {
            salaryInput.value = defSalary;
            recalcCompensation();
        }
        const salaryHint = document.getElementById("salaryRangeHint");
        if (salaryHint) {
            salaryHint.innerText = "Khung dải lương vị trí: " + salaryRange;
        }

        updateStep2Summary();
    }

    // =========================================================================
    // 4. STEPPER NAVIGATION & VALIDATION
    // =========================================================================
    function jumpToStep(target) {
        if (target === currentStep) return;
        if (target > currentStep && !validateCurrentStep()) return;
        goToStep(target);
    }

    function nextStep() {
        if (!validateCurrentStep()) return;
        if (currentStep < TOTAL_STEPS) {
            goToStep(currentStep + 1);
        }
    }

    function prevStep() {
        if (currentStep > 1) {
            goToStep(currentStep - 1);
        }
    }

    function goToStep(step) {
        currentStep = step;

        // Update header & title
        document.getElementById("pageHeaderTitle").innerText = stepHeaders[step];
        document.getElementById("badgeProgressText").innerText = "Tiến trình hồ sơ: " + (step * 25) + "% Hoàn thành";

        // Show right panel
        for (let i = 1; i <= TOTAL_STEPS; i++) {
            const panel = document.getElementById("panelStep" + i);
            if (panel) {
                if (i === step) panel.classList.add("active");
                else panel.classList.remove("active");
            }
        }

        // Show left panel
        for (let i = 1; i <= TOTAL_STEPS; i++) {
            const sidePanel = document.getElementById("sidePanelStep" + i);
            if (sidePanel) {
                sidePanel.style.display = (i === step) ? "block" : "none";
            }
        }

        // Update Steppers
        for (let i = 1; i <= TOTAL_STEPS; i++) {
            const tab = document.getElementById("stepperTab" + i);
            const badge = document.getElementById("stepperBadge" + i);
            const num = document.getElementById("stepperNum" + i);

            tab.className = "stepper-tab";
            if (i < step) {
                tab.classList.add("done");
                badge.innerText = "BƯỚC " + i + " • HOÀN TẤT";
                num.innerHTML = '<i class="bi bi-check-lg"></i>';
            } else if (i === step) {
                tab.classList.add("active");
                badge.innerText = "BƯỚC " + i + " • ĐANG THỰC HIỆN";
                num.innerText = "0" + i;
            } else {
                tab.classList.add("pending");
                badge.innerText = "BƯỚC " + i;
                num.innerText = "0" + i;
            }
        }

        // Update Buttons
        const btnPrev = document.getElementById("btnPrev");
        const btnNext = document.getElementById("btnNext");
        const btnSubmit = document.getElementById("btnSubmit");
        const btnNextText = document.getElementById("btnNextText");

        btnPrev.disabled = (step === 1);

        if (step === TOTAL_STEPS) {
            btnNext.style.display = "none";
            btnSubmit.style.display = "inline-flex";
            updateFinalSummary();
        } else {
            btnNext.style.display = "inline-flex";
            btnSubmit.style.display = "none";
            btnNextText.innerText = stepButtons[step];
        }

        // Smooth scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Step Validation
    function validateCurrentStep() {
        const currentPanel = document.getElementById("panelStep" + currentStep);
        if (!currentPanel) return true;

        const inputs = currentPanel.querySelectorAll("input[required], select[required]");
        let valid = true;

        inputs.forEach(input => {
            if (!input.value || !input.value.trim()) {
                input.classList.add("is-invalid");
                valid = false;
            } else {
                input.classList.remove("is-invalid");
            }
        });

        if (!valid) {
            showToast("Vui lòng điền đầy đủ các thông tin bắt buộc (*) trước khi tiếp tục.", "warning");
        }
        return valid;
    }

    // =========================================================================
    // 5. AUTO GENERATION LOGIC (MÃ NV, MÃ HĐ, EMAIL, MST, BHXH)
    // =========================================================================
    function removeVietnameseTones(str) {
        str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
        str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
        str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
        str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
        str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
        str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
        str = str.replace(/đ/g, "d");
        str = str.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g, "A");
        str = str.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g, "E");
        str = str.replace(/Ì|Í|Ị|Ỉ|Ĩ/g, "I");
        str = str.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g, "O");
        str = str.replace(/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g, "U");
        str = str.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g, "Y");
        str = str.replace(/Đ/g, "D");
        return str;
    }

    function handleFullNameChange(name) {
        if (!name) return;

        // Update profile summaries
        const pName = document.getElementById("sideProfileName");
        const s3Name = document.getElementById("sideStep3Name");
        if (pName) pName.innerText = name;
        if (s3Name) s3Name.innerText = name;

        // Auto-generate company email prefix: "Nguyễn Văn An" -> "an.nv"
        const clean = removeVietnameseTones(name.trim().toLowerCase());
        const parts = clean.split(/\s+/).filter(Boolean);
        if (parts.length > 0) {
            let prefix = "";
            if (parts.length === 1) {
                prefix = parts[0];
            } else {
                const firstName = parts[parts.length - 1];
                let initials = "";
                for (let i = 0; i < parts.length - 1; i++) {
                    initials += parts[i][0];
                }
                prefix = firstName + "." + initials;
            }

            const prefixInput = document.getElementById("companyEmailPrefix");
            if (prefixInput) prefixInput.value = prefix;

            const step2Email = document.getElementById("step2CompanyEmail");
            if (step2Email) step2Email.value = prefix + "@miximoi.vn";
        }
    }

    function regenerateEmployeeCode() {
        const input = document.getElementById("employeeCode");
        const current = input.value.trim();
        let nextNum = 15;
        if (current.startsWith("NV")) {
            const n = parseInt(current.substring(2));
            if (!isNaN(n)) nextNum = n + 1;
        }
        const newCode = "NV" + String(nextNum).padStart(3, '0');
        input.value = newCode;

        // Update badges
        const sideCode = document.getElementById("sideEmpCodeDisplay");
        if (sideCode) sideCode.innerText = newCode;
        const profileCode = document.getElementById("sideProfileCode");
        if (profileCode) profileCode.innerText = "MÃ NV: " + newCode;

        showToast(`Đã tự động sinh mã nhân viên mới: ${newCode}`, "success");
    }

    function toggleEditEmpCode() {
        const input = document.getElementById("employeeCode");
        if (input.hasAttribute("readonly")) {
            input.removeAttribute("readonly");
            input.focus();
            input.select();
            showToast("Đã mở khóa để nhập mã nhân viên tùy chỉnh.", "warning");
        } else {
            input.setAttribute("readonly", "true");
        }
    }

    function regenerateContractCode() {
        const input = document.getElementById("contractCode");
        const current = input.value.trim();
        let nextNum = 13;
        if (current.startsWith("HD")) {
            const n = parseInt(current.substring(2));
            if (!isNaN(n)) nextNum = n + 1;
        }
        const newCode = "HD" + String(nextNum).padStart(3, '0');
        input.value = newCode;
        showToast(`Đã sinh mã hợp đồng mới: ${newCode}`, "success");
    }

    function toggleEditContractCode() {
        const input = document.getElementById("contractCode");
        if (input.hasAttribute("readonly")) {
            input.removeAttribute("readonly");
            input.focus();
            input.select();
        } else {
            input.setAttribute("readonly", "true");
        }
    }

    function autoGenBhxh() {
        const randomDigits = Math.floor(1000000000 + Math.random() * 9000000000);
        const code = "0" + String(randomDigits).substring(1);
        document.getElementById("bhxhCode").value = code;
        showToast(`Đã gợi ý mã số BHXH: ${code}`, "success");
    }

    function autoGenTaxCode() {
        const randomDigits = Math.floor(1000000000 + Math.random() * 9000000000);
        const code = "8" + String(randomDigits).substring(1);
        document.getElementById("taxCode").value = code;
        showToast(`Đã gợi ý mã số thuế cá nhân: ${code}`, "success");
    }

    function validateCccd(input) {
        const icon = document.getElementById("cccdValidIcon");
        if (input.value.length >= 9 && input.value.length <= 12) {
            icon.style.display = "block";
        } else {
            icon.style.display = "none";
        }
    }

    function toggleSameAddress(checkbox) {
        const addr = document.getElementById("address").value;
        const tempInput = document.getElementById("tempAddress");
        if (checkbox.checked) {
            tempInput.value = addr;
            tempInput.setAttribute("readonly", "true");
            showToast("Đã đồng bộ địa chỉ thường trú sang tạm trú.", "success");
        } else {
            tempInput.removeAttribute("readonly");
        }
    }

    function calculateAge() {
        const dobVal = document.getElementById("dateOfBirth").value;
        if (!dobVal) return;
        const dob = new Date(dobVal);
        const diff = Date.now() - dob.getTime();
        const age = Math.abs(new Date(diff).getUTCFullYear() - 1970);
        const gender = document.querySelector('input[name="gender"]:checked')?.value === 'FEMALE' ? 'Nữ' : 'Nam';
        const display = document.getElementById("sideProfileAgeGender");
        if (display) display.innerText = gender + ", " + age + " tuổi";
    }

    function updateGenderDisplay() {
        calculateAge();
    }

    function updateStep2Summary() {
        const deptSelect = document.getElementById("departmentId");
        const posSelect = document.getElementById("positionId");
        const posName = posSelect.options[posSelect.selectedIndex]?.text.split('(')[0].trim() || "Kỹ sư phần mềm";
        const deptName = deptSelect.options[deptSelect.selectedIndex]?.text.trim() || "Phòng Kỹ thuật";

        const s3Pos = document.getElementById("sideStep3Pos");
        if (s3Pos) s3Pos.innerText = posName + " • " + deptName;

        const finalPos = document.getElementById("finalPosition");
        if (finalPos) finalPos.innerText = posName;
    }

    function updateFinalSummary() {
        document.getElementById("finalEmpCode").innerText = document.getElementById("employeeCode").value;
        document.getElementById("finalContractCode").innerText = document.getElementById("contractCode").value;
        const posSelect = document.getElementById("positionId");
        document.getElementById("finalPosition").innerText = posSelect.options[posSelect.selectedIndex]?.text.split('(')[0].trim() || "Kỹ sư phần mềm";
        document.getElementById("finalSalary").innerText = document.getElementById("baseSalary").value + " đ";
    }

    // =========================================================================
    // 6. PHOTO & DOCUMENT ATTACHMENTS
    // =========================================================================
    function triggerAvatarUpload() {
        document.getElementById("avatarFileInput").click();
    }

    function previewAvatar(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById("avatarPreviewImg").src = e.target.result;
                const summaries = document.querySelectorAll(".profile-summary-avatar");
                summaries.forEach(img => img.src = e.target.result);
                showToast("Đã tải ảnh chân dung xem trước thành công.", "success");
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    function triggerDocUpload(inputId) {
        document.getElementById(inputId).click();
    }

    function handleDocFile(input, imgId, nameId) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            document.getElementById(nameId).innerText = file.name;
            if (file.type.startsWith("image/")) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById(imgId).src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
            showToast(`Đã đính kèm tệp: ${file.name}`, "success");
            updateUploadedCount();
        }
    }

    function clearDocUpload(imgId, nameId) {
        document.getElementById(nameId).innerText = "Chưa có tệp";
        document.getElementById(imgId).src = "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=300&auto=format&fit=crop&q=80";
        showToast("Đã xóa tệp đính kèm.", "warning");
        updateUploadedCount();
    }

    function handleResumeFile(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            document.getElementById("resumeTitle").innerText = file.name;
            document.getElementById("resumeSub").innerText = (file.size / 1024 / 1024).toFixed(2) + " MB • Đã sẵn sàng";
            document.getElementById("resumeBadge").className = "badge bg-success-subtle text-success mt-2";
            document.getElementById("resumeBadge").innerText = "Tệp hợp lệ";
            showToast(`Đã tải lên hồ sơ: ${file.name}`, "success");
            updateUploadedCount();
        }
    }

    function updateUploadedCount() {
        let count = 0;
        if (document.getElementById("cccdFrontInput").files.length > 0) count++;
        if (document.getElementById("cccdBackInput").files.length > 0) count++;
        if (document.getElementById("resumeInput").files.length > 0) count++;
        document.getElementById("uploadedDocCountBadge").innerText = `Đã tải lên ${count}/3 tệp`;
    }

    // =========================================================================
    // 7. REAL-TIME SALARY & COMPENSATION CALCULATOR
    // =========================================================================
    function formatSalaryInput(input) {
        let val = input.value.replace(/\D/g, "");
        if (val) {
            input.value = Number(val).toLocaleString("vi-VN").replace(/,/g, ".");
        } else {
            input.value = "";
        }
        recalcCompensation();
    }

    function getNumericSalary() {
        const raw = document.getElementById("baseSalary").value.replace(/\./g, "").replace(/,/g, "").trim();
        return Number(raw) || 0;
    }

    let allowancesTotal = 2500000;

    function toggleAllowanceRow(checkbox, amount) {
        const parent = checkbox.closest(".allowance-box-item");
        if (checkbox.checked) {
            parent.classList.add("active");
            allowancesTotal += amount;
        } else {
            parent.classList.remove("active");
            allowancesTotal -= amount;
        }
        recalcCompensation();
    }

    function recalcCompensation() {
        const base = getNumericSalary();
        const gross = base + allowancesTotal;

        // BHXH 10.5% (NLĐ: 8% BHXH, 1.5% BHYT, 1% BHTN)
        const bhxh = Math.round(base * 0.105);

        // Thuế TNCN (tạm tính đơn giản giảm trừ 11tr)
        const taxable = Math.max(0, gross - bhxh - 11000000);
        let tax = 0;
        if (taxable > 0 && taxable <= 5000000) tax = taxable * 0.05;
        else if (taxable > 5000000 && taxable <= 10000000) tax = 250000 + (taxable - 5000000) * 0.10;
        else if (taxable > 10000000) tax = 750000 + (taxable - 10000000) * 0.15;

        const net = Math.max(0, gross - bhxh - tax);
        const netPct = gross > 0 ? Math.round((net / gross) * 100) : 88;

        // Update displays
        document.getElementById("calcBaseDisplay").innerText = base.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcAllowanceDisplay").innerText = "+ " + allowancesTotal.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcGrossDisplay").innerText = gross.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcBhxhDisplay").innerText = "- " + bhxh.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcTaxDisplay").innerText = "- " + tax.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcNetDisplay").innerText = "~ " + net.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcNetPct").innerText = netPct + "% Gross";
        document.getElementById("calcDonutPct").innerText = netPct + "%";

        // Update probation note
        const rate = document.getElementById("rate85").checked ? 0.85 : 1.0;
        const probSalary = Math.round(base * rate);
        document.getElementById("probationSubText").innerText =
            "Thử việc 2 tháng: " + probSalary.toLocaleString("vi-VN") + " VNĐ/tháng";
    }

    function addCustomAllowance() {
        const name = prompt("Nhập tên khoản phụ cấp mới (VD: Phụ cấp trách nhiệm dự án):");
        if (!name) return;
        const amountStr = prompt("Nhập số tiền phụ cấp (VNĐ/tháng, VD: 1500000):", "1000000");
        const amount = parseInt(amountStr) || 0;
        if (amount <= 0) return;

        const container = document.getElementById("allowanceListContainer");
        const newDiv = document.createElement("div");
        newDiv.className = "allowance-box-item active";
        newDiv.innerHTML = `
            <div class="allowance-left">
                <input type="checkbox" class="form-check-input mt-0" checked onchange="toggleAllowanceRow(this, ${amount})">
                <div>
                    <div class="allowance-name">${name} <span class="badge bg-primary-subtle text-primary ms-1" style="font-size:0.65rem;">Tùy chỉnh</span></div>
                    <div class="allowance-sub">Hỗ trợ theo quyết định phân công nhiệm vụ</div>
                </div>
            </div>
            <div class="allowance-amount">${amount.toLocaleString("vi-VN")} đ / tháng</div>
        `;
        container.appendChild(newDiv);
        allowancesTotal += amount;
        recalcCompensation();
        showToast(`Đã thêm khoản phụ cấp "${name}": ${amount.toLocaleString("vi-VN")} đ`, "success");
    }

    // =========================================================================
    // 8. DRAFT SAVING & RESTORING (LOCALSTORAGE)
    // =========================================================================
    function saveDraft() {
        const data = {
            fullName: document.getElementById("fullName").value,
            employeeCode: document.getElementById("employeeCode").value,
            dateOfBirth: document.getElementById("dateOfBirth").value,
            gender: document.querySelector('input[name="gender"]:checked')?.value || 'MALE',
            idNumber: document.getElementById("idNumber").value,
            idIssueDate: document.getElementById("idIssueDate").value,
            idIssuePlace: document.getElementById("idIssuePlace").value,
            email: document.getElementById("email").value,
            companyEmailPrefix: document.getElementById("companyEmailPrefix").value,
            phone: document.getElementById("phone").value,
            emergencyContact: document.getElementById("emergencyContact").value,
            address: document.getElementById("address").value,
            tempAddress: document.getElementById("tempAddress").value,
            departmentId: document.getElementById("departmentId").value,
            positionId: document.getElementById("positionId").value,
            employeeLevel: document.getElementById("employeeLevel").value,
            lineManager: document.getElementById("lineManager").value,
            mentorName: document.getElementById("mentorName").value,
            baseSalary: document.getElementById("baseSalary").value,
            contractCode: document.getElementById("contractCode").value,
            savedAt: new Date().toLocaleTimeString()
        };

        localStorage.setItem("miximoi_employee_draft", JSON.stringify(data));
        showToast(`Đã lưu bản nháp hồ sơ thành công (${data.savedAt})`, "success");
        document.getElementById("autoSaveTimer").innerText = "Vừa xong";
    }

    function checkSavedDraft() {
        const draftStr = localStorage.getItem("miximoi_employee_draft");
        if (draftStr) {
            try {
                const draft = JSON.parse(draftStr);
                if (draft.fullName || draft.employeeCode) {
                    const banner = document.getElementById("draftAlertBanner");
                    const text = document.getElementById("draftAlertText");
                    text.innerText = `Phát hiện bản nháp của "${draft.fullName || draft.employeeCode}" đã lưu lúc ${draft.savedAt}. Bạn có muốn khôi phục không?`;
                    banner.classList.remove("d-none");
                }
            } catch (e) {}
        }
    }

    function restoreDraftData() {
        const draftStr = localStorage.getItem("miximoi_employee_draft");
        if (!draftStr) return;
        const draft = JSON.parse(draftStr);

        if (draft.fullName) document.getElementById("fullName").value = draft.fullName;
        if (draft.employeeCode) document.getElementById("employeeCode").value = draft.employeeCode;
        if (draft.dateOfBirth) document.getElementById("dateOfBirth").value = draft.dateOfBirth;
        if (draft.idNumber) document.getElementById("idNumber").value = draft.idNumber;
        if (draft.idIssueDate) document.getElementById("idIssueDate").value = draft.idIssueDate;
        if (draft.idIssuePlace) document.getElementById("idIssuePlace").value = draft.idIssuePlace;
        if (draft.email) document.getElementById("email").value = draft.email;
        if (draft.companyEmailPrefix) document.getElementById("companyEmailPrefix").value = draft.companyEmailPrefix;
        if (draft.phone) document.getElementById("phone").value = draft.phone;
        if (draft.emergencyContact) document.getElementById("emergencyContact").value = draft.emergencyContact;
        if (draft.address) document.getElementById("address").value = draft.address;
        if (draft.tempAddress) document.getElementById("tempAddress").value = draft.tempAddress;
        if (draft.departmentId) {
            document.getElementById("departmentId").value = draft.departmentId;
            handleDepartmentChange(draft.departmentId);
        }
        if (draft.positionId) {
            document.getElementById("positionId").value = draft.positionId;
        }
        if (draft.baseSalary) document.getElementById("baseSalary").value = draft.baseSalary;
        if (draft.contractCode) document.getElementById("contractCode").value = draft.contractCode;

        handleFullNameChange(draft.fullName);
        calculateAge();
        recalcCompensation();

        dismissDraft();
        showToast("Đã khôi phục toàn bộ dữ liệu từ bản nháp!", "success");
    }

    function dismissDraft() {
        document.getElementById("draftAlertBanner").classList.add("d-none");
    }

    function startAutoSaveInterval() {
        let count = 0;
        setInterval(() => {
            count++;
            if (count % 60 === 0) {
                saveDraft();
            } else {
                const mins = Math.floor(count / 60);
                if (mins > 0) {
                    document.getElementById("autoSaveTimer").innerText = `${mins} phút trước`;
                } else {
                    document.getElementById("autoSaveTimer").innerText = `${count} giây trước`;
                }
            }
        }, 1000);
    }

    function confirmDiscard() {
        return confirm("Bạn có chắc chắn muốn hủy bỏ? Mọi thông tin chưa lưu sẽ được lưu tạm trong bản nháp.");
    }
</script>
</body>
</html>
