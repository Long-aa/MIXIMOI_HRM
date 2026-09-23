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
                        <span id="headerFormId">
                            <c:choose>
                                <c:when test="${not empty employee and employee.id > 0}">MÃ NV: <c:out value="${employee.employeeCode}"/></c:when>
                                <c:otherwise>HỒ SƠ MỚI: <c:out value="${nextEmployeeCode}"/></c:otherwise>
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
                                        <img id="avatarPreviewImg" src="${not empty employee.avatarUrl ? employee.avatarUrl : (not empty employee.fullName ? ('https://ui-avatars.com/api/?name=' += employee.fullName += '&background=2563eb&color=fff') : 'https://ui-avatars.com/api/?name=NV&background=e2e8f0&color=64748b')}"
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
                                            <span class="sys-info-label">Mã nhân viên</span>
                                            <span class="sys-info-val text-primary font-monospace" id="sideEmpCodeDisplay"><c:out value="${empty employee.employeeCode ? nextEmployeeCode : employee.employeeCode}"/></span>
                                        </div>
                                        <div class="sys-info-row">
                                            <span class="sys-info-label">Ngày khởi tạo</span>
                                            <span class="sys-info-val" id="sideCreatedDate">
                                                <c:choose>
                                                    <c:when test="${not empty employee and not empty employee.createdAt}"><c:out value="${employee.createdAt.toLocalDate()}"/></c:when>
                                                    <c:otherwise>Hôm nay</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="sys-info-row">
                                            <span class="sys-info-label">Trạng thái hồ sơ</span>
                                            <span class="sys-badge-draft">${empty employee or employee.id == 0 ? 'Tạo mới (Bản nháp)' : employee.status}</span>
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
                                        <img src="${not empty employee.avatarUrl ? employee.avatarUrl : (not empty employee.fullName ? ('https://ui-avatars.com/api/?name=' += employee.fullName += '&background=2563eb&color=fff') : 'https://ui-avatars.com/api/?name=NV&background=e2e8f0&color=64748b')}"
                                             class="profile-summary-avatar" alt="Avatar" id="sideProfileAvatar">
                                        <div>
                                            <div class="profile-summary-name" id="sideProfileName"><c:out value="${not empty employee.fullName ? employee.fullName : 'Chưa nhập họ tên'}"/></div>
                                            <span class="profile-summary-code" id="sideProfileCode"><c:out value="${not empty employee.employeeCode ? employee.employeeCode : nextEmployeeCode}"/></span>
                                            <div style="font-size:0.72rem; color:#64748b; margin-top:2px;" id="sideProfileAgeGender">
                                                <c:choose>
                                                    <c:when test="${not empty employee}">
                                                        <c:out value="${employee.gender eq 'MALE' ? 'Nam' : employee.gender eq 'FEMALE' ? 'Nữ' : 'Khác'}"/>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="profile-summary-details">
                                        <div><i class="bi bi-envelope"></i> <span id="sideProfileEmail"><c:out value="${not empty employee.email ? employee.email : 'Chưa có email'}"/></span></div>
                                        <div><i class="bi bi-telephone"></i> <span id="sideProfilePhone"><c:out value="${not empty employee.phone ? employee.phone : 'Chưa có SĐT'}"/></span></div>
                                        <div><i class="bi bi-geo-alt"></i> <span id="sideProfileAddr"><c:out value="${not empty employee.address ? employee.address : 'Chưa có địa chỉ'}"/></span></div>
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
                                            <div class="c-desc">Laptop &amp; phụ kiện IT</div>
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
                                            <div class="c-desc">Đồng bộ máy quét chấm công</div>
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
                                        <img src="${not empty employee.avatarUrl ? employee.avatarUrl : (not empty employee.fullName ? ('https://ui-avatars.com/api/?name=' += employee.fullName += '&background=2563eb&color=fff') : 'https://ui-avatars.com/api/?name=NV&background=e2e8f0&color=64748b')}"
                                             class="profile-summary-avatar rounded-circle" style="width:38px; height:38px; object-fit:cover;" alt="Avatar" id="sideStep3Avatar">
                                        <div>
                                            <div style="font-weight:800; font-size:0.88rem; color:#0f172a;" id="sideStep3Name"><c:out value="${not empty employee.fullName ? employee.fullName : 'Nhân sự mới'}"/></div>
                                            <div style="font-size:0.72rem; color:#64748b;" id="sideStep3Pos">
                                                <c:choose>
                                                    <c:when test="${not empty employee.positionName}"><c:out value="${employee.positionName}"/> • <c:out value="${employee.departmentName}"/></c:when>
                                                    <c:otherwise>Vị trí &amp; Phòng ban đang chọn</c:otherwise>
                                                </c:choose>
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
                                                   value="${not empty employee.dateOfBirth ? employee.dateOfBirth : ''}"
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
                                                       name="identityNumber" id="idNumber" required placeholder="Nhập số CCCD 12 số"
                                                       maxlength="12" pattern="[0-9]{9,12}" value="<c:out value='${employee.identityNumber}'/>"
                                                       oninput="validateCccd(this)">
                                                <i class="bi bi-check-circle-fill text-success position-absolute" id="cccdValidIcon"
                                                   style="right:12px; top:50%; transform:translateY(-50%); font-size:1rem; display:none;"></i>
                                            </div>
                                        </div>

                                        <!-- Ngày cấp CCCD -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Ngày cấp CCCD <span class="req">*</span></label>
                                            <input type="date" class="form-control form-control-custom step1-input"
                                                   name="identityDate" id="idIssueDate" required value="<c:out value='${employee.identityDate}'/>">
                                        </div>

                                        <!-- Nơi cấp -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">Nơi cấp <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom step1-input"
                                                   name="identityPlace" id="idIssuePlace" required
                                                   placeholder="Cục Cảnh sát Quản lý hành chính về trật tự xã hội"
                                                   value="${employee.identityPlace}">
                                        </div>

                                        <!-- Dân tộc -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Dân tộc</label>
                                            <select class="form-select form-select-custom" name="ethnicity" id="ethnicity">
                                                <option value="Kinh" ${empty employee.ethnicity or employee.ethnicity eq 'Kinh' ? 'selected' : ''}>Kinh</option>
                                                <option value="Tày" ${employee.ethnicity eq 'Tày' ? 'selected' : ''}>Tày</option>
                                                <option value="Thái" ${employee.ethnicity eq 'Thái' ? 'selected' : ''}>Thái</option>
                                                <option value="Mường" ${employee.ethnicity eq 'Mường' ? 'selected' : ''}>Mường</option>
                                                <option value="Khác" ${employee.ethnicity eq 'Khác' ? 'selected' : ''}>Khác</option>
                                            </select>
                                        </div>

                                        <!-- Tôn giáo -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tôn giáo</label>
                                            <input type="text" class="form-control form-control-custom" name="religion"
                                                   id="religion" placeholder="Không" value="<c:out value='${not empty employee.religion ? employee.religion : \"Không\"}'/>">
                                        </div>

                                        <!-- Quốc tịch -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Quốc tịch</label>
                                            <input type="text" class="form-control form-control-custom" name="nationality"
                                                   id="nationality" value="<c:out value='${not empty employee.nationality ? employee.nationality : \"Việt Nam\"}'/>">
                                        </div>

                                        <!-- Tình trạng hôn nhân -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tình trạng hôn nhân</label>
                                            <select class="form-select form-select-custom" name="maritalStatus" id="maritalStatus">
                                                <option value="SINGLE" ${empty employee.maritalStatus or employee.maritalStatus eq 'SINGLE' ? 'selected' : ''}>Độc thân</option>
                                                <option value="MARRIED" ${employee.maritalStatus eq 'MARRIED' ? 'selected' : ''}>Đã kết hôn</option>
                                                <option value="OTHER" ${employee.maritalStatus eq 'OTHER' ? 'selected' : ''}>Khác</option>
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
                                                       placeholder="vd: an.nv" style="border-radius:10px 0 0 10px; border-right:none;"
                                                       value="<c:out value='${empEmailPrefix}'/>">
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
                                            <label class="form-label-custom">Liên hệ khẩn cấp (Họ tên • SĐT • Quan hệ)</label>
                                            <div class="row g-1">
                                                <div class="col-md-5">
                                                    <input type="text" class="form-control form-control-custom"
                                                           name="emergencyContactName" id="emergencyContactName"
                                                           placeholder="Họ tên"
                                                           value="<c:out value='${employee.emergencyContactName}'/>"> 
                                                </div>
                                                <div class="col-md-4">
                                                    <input type="text" class="form-control form-control-custom"
                                                           name="emergencyContactPhone" id="emergencyContactPhone"
                                                           placeholder="SĐT"
                                                           value="<c:out value='${employee.emergencyContactPhone}'/>"> 
                                                </div>
                                                <div class="col-md-3">
                                                    <input type="text" class="form-control form-control-custom"
                                                           name="emergencyContactRelation" id="emergencyContactRelation"
                                                           placeholder="Quan hệ"
                                                           value="<c:out value='${employee.emergencyContactRelation}'/>"> 
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Địa chỉ thường trú -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">Địa chỉ thường trú (Ghi rõ theo CCCD) <span class="req">*</span></label>
                                            <input type="text" class="form-control form-control-custom step1-input"
                                                   name="address" id="address" required
                                                   placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"
                                                   value="<c:out value='${employee.address}'/>"
                                                   oninput="document.getElementById('sideProfileAddr').innerText = this.value || 'Chưa nhập'">
                                        </div>

                                        <!-- Địa chỉ tạm trú -->
                                        <div class="col-md-12">
                                            <label class="form-label-custom">
                                                <span>Địa chỉ tạm trú / Nơi ở hiện nay</span>
                                                <label style="font-weight:500; font-size:0.75rem; color:#475569; cursor:pointer; display:flex; align-items:center; gap:4px;">
                                                    <input type="checkbox" id="sameAddressCheck" onchange="toggleSameAddress(this)"> Giống địa chỉ thường trú
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
                                        <div class="doc-upload-card d-flex flex-column justify-content-center align-items-center" style="min-height:140px;" onclick="triggerDocUpload('cccdFrontInput')">
                                            <i class="bi bi-card-heading text-primary" id="cccdFrontIcon" style="font-size:1.8rem; margin-bottom:4px;"></i>
                                            <img id="cccdFrontPreview" src="" class="doc-upload-preview d-none" alt="Mặt trước CCCD">
                                            <input type="file" id="cccdFrontInput" accept="image/*,.pdf" style="display:none;" onchange="handleDocFile(this, 'cccdFrontPreview', 'cccdFrontName')">
                                            <div class="doc-upload-title">
                                                <span>Mặt trước CCCD</span>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mt-2" style="font-size:0.7rem; width:100%;">
                                                <span class="text-truncate text-muted" id="cccdFrontName" style="max-width:120px;">Bấm để tải tệp</span>
                                                <span class="text-danger fw-bold d-none" id="cccdFrontDel" onclick="event.stopPropagation(); clearDocUpload('cccdFrontPreview', 'cccdFrontName')">Xóa</span>
                                            </div>
                                        </div>

                                        <!-- Mặt sau CCCD -->
                                        <div class="doc-upload-card d-flex flex-column justify-content-center align-items-center" style="min-height:140px;" onclick="triggerDocUpload('cccdBackInput')">
                                            <i class="bi bi-card-text text-primary" id="cccdBackIcon" style="font-size:1.8rem; margin-bottom:4px;"></i>
                                            <img id="cccdBackPreview" src="" class="doc-upload-preview d-none" alt="Mặt sau CCCD">
                                            <input type="file" id="cccdBackInput" accept="image/*,.pdf" style="display:none;" onchange="handleDocFile(this, 'cccdBackPreview', 'cccdBackName')">
                                            <div class="doc-upload-title">
                                                <span>Mặt sau CCCD</span>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mt-2" style="font-size:0.7rem; width:100%;">
                                                <span class="text-truncate text-muted" id="cccdBackName" style="max-width:120px;">Bấm để tải tệp</span>
                                                <span class="text-danger fw-bold d-none" id="cccdBackDel" onclick="event.stopPropagation(); clearDocUpload('cccdBackPreview', 'cccdBackName')">Xóa</span>
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

                            <!-- Panel Step 1 Navigation Footer -->
                            <div class="step-nav-footer mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                                <span class="text-muted small"><i class="bi bi-info-circle text-primary me-1"></i> Điền các thông tin cơ bản để tiếp tục chuyển bước.</span>
                                <button type="button" class="btn btn-primary px-4 py-2 fw-bold d-inline-flex align-items-center gap-2" onclick="nextStep()">
                                    <span>Tiếp tục: Bước 2 (Công việc &amp; Định biên)</span>
                                    <i class="bi bi-arrow-right"></i>
                                </button>
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
                                                <c:forEach var="p" items="${positions}">
                                                    <option value="${p.id}" ${employee.positionId == p.id ? 'selected' : ''} data-department-id="${p.departmentId}">
                                                        <c:out value="${p.name}"/>
                                                    </option>
                                                </c:forEach>
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
                                            <label class="form-label-custom">Quản lý trực tiếp (Direct Manager)</label>
                                            <input type="text" class="form-control form-control-custom" name="lineManager"
                                                   id="lineManager" placeholder="VD: Trưởng bộ phận phụ trách"
                                                   value="">
                                        </div>

                                        <!-- Người hướng dẫn -->
                                        <div class="col-md-6">
                                            <label class="form-label-custom">Người hướng dẫn (Mentor / Buddy Onboarding)</label>
                                            <input type="text" class="form-control form-control-custom" name="mentorName"
                                                   id="mentorName" placeholder="VD: Chuyên viên hướng dẫn hội nhập"
                                                   value="">
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
                                                   id="startDate" required value="${not empty employee.startDate ? employee.startDate : ''}">
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
                                            <div class="input-group">
                                                <input type="date" class="form-control form-control-custom" name="endDate" id="endDate" value="${employee.endDate}" style="max-width:160px;">
                                                <input type="text" class="form-control form-control-custom" name="terminationReason" id="terminationReason" placeholder="Lý do thôi việc..." value="<c:out value='${employee.terminationReason}'/>">
                                            </div>
                                        </div>
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
                                            <label class="form-label-custom">Email công ty đề xuất</label>
                                            <div class="position-relative">
                                                <input type="text" class="form-control form-control-custom" id="step2CompanyEmail"
                                                       value="${not empty employee.email ? employee.email : ''}" placeholder="Chờ nhập ở Bước 1" readonly style="padding-right:32px;">
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

                            <!-- Panel Step 2 Navigation Footer -->
                            <div class="step-nav-footer mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                                <button type="button" class="btn btn-outline-secondary px-3 py-2 d-inline-flex align-items-center gap-1" onclick="prevStep()">
                                    <i class="bi bi-arrow-left"></i> <span>Quay lại Bước 1</span>
                                </button>
                                <button type="button" class="btn btn-primary px-4 py-2 fw-bold d-inline-flex align-items-center gap-2" onclick="nextStep()">
                                    <span>Tiếp tục: Bước 3 (Lương &amp; Phúc lợi)</span>
                                    <i class="bi bi-arrow-right"></i>
                                </button>
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
                                                <c:set var="formattedBaseSalary" value="" />
                                                <c:if test="${not empty employee.baseSalary and employee.baseSalary > 0}">
                                                    <fmt:formatNumber var="formattedBaseSalary" value="${employee.baseSalary}" pattern="#,##0"/>
                                                </c:if>
                                                <input type="text" class="form-control form-control-custom fw-bold text-primary fs-6"
                                                       name="baseSalary" id="baseSalary" required
                                                       value="${formattedBaseSalary}"
                                                       placeholder="VD: 15.000.000"
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

                            <!-- Panel Step 3 Navigation Footer -->
                            <div class="step-nav-footer mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                                <button type="button" class="btn btn-outline-secondary px-3 py-2 d-inline-flex align-items-center gap-1" onclick="prevStep()">
                                    <i class="bi bi-arrow-left"></i> <span>Quay lại Bước 2</span>
                                </button>
                                <button type="button" class="btn btn-primary px-4 py-2 fw-bold d-inline-flex align-items-center gap-2" onclick="nextStep()">
                                    <span>Tiếp tục: Bước 4 (Hợp đồng &amp; Bảo hiểm)</span>
                                    <i class="bi bi-arrow-right"></i>
                                </button>
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
                                                   name="contractSignDate" id="contractSignDate" required value="${not empty employee.startDate ? employee.startDate : ''}">
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
                                                   name="insuranceNumber" id="bhxhCode" placeholder="VD: 0101988234" value="<c:out value='${employee.insuranceNumber}'/>">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">
                                                <span>Mã số thuế cá nhân (MST)</span>
                                                <span class="text-primary fw-normal" style="font-size:0.72rem; cursor:pointer;" onclick="autoGenTaxCode()">
                                                    <i class="bi bi-magic"></i> Gợi ý mã
                                                </span>
                                            </label>
                                            <input type="text" class="form-control form-control-custom font-monospace"
                                                   name="taxCode" id="taxCode" placeholder="VD: 8492019482" value="<c:out value='${employee.taxCode}'/>">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">Nơi đăng ký KCB ban đầu</label>
                                            <input type="text" class="form-control form-control-custom"
                                                   name="kcbPlace" id="kcbPlace" placeholder="VD: Bệnh viện Nhân dân Gia Định"
                                                   value="">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">Tài khoản ngân hàng chi trả lương</label>
                                            <div class="input-group">
                                                <select class="form-select form-select-custom" style="max-width:130px;" name="bankName">
                                                    <option value="VCB" ${empty employee.bankName or employee.bankName eq 'VCB' ? 'selected' : ''}>VCB</option>
                                                    <option value="TCB" ${employee.bankName eq 'TCB' ? 'selected' : ''}>Techcombank</option>
                                                    <option value="MB" ${employee.bankName eq 'MB' ? 'selected' : ''}>MB Bank</option>
                                                    <option value="ACB" ${employee.bankName eq 'ACB' ? 'selected' : ''}>ACB</option>
                                                    <option value="BIDV" ${employee.bankName eq 'BIDV' ? 'selected' : ''}>BIDV</option>
                                                    <option value="CTG" ${employee.bankName eq 'CTG' ? 'selected' : ''}>VietinBank</option>
                                                </select>
                                                <input type="text" class="form-control form-control-custom" name="bankAccount"
                                                       id="bankAccount" placeholder="Số tài khoản ngân hàng" value="<c:out value='${employee.bankAccount}'/>">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label-custom">Chi nhánh ngân hàng mở tài khoản</label>
                                            <input type="text" class="form-control form-control-custom" name="bankBranch"
                                                   id="bankBranch" placeholder="VD: Chi nhánh TP. Hồ Chí Minh" value="<c:out value='${employee.bankBranch}'/>">
                                        </div>
                                        <input type="hidden" name="avatarUrl" id="avatarUrlHidden" value="<c:out value='${employee.avatarUrl}'/>">

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
                                            <input type="text" class="form-control form-control-custom"
                                                   name="emergencyContactName" id="emergencyContactName"
                                                   placeholder="VD: Nguyễn Thị Bình"
                                                   value="<c:out value='${employee.emergencyContactName}'/>">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Số điện thoại liên hệ</label>
                                            <input type="tel" class="form-control form-control-custom"
                                                   name="emergencyContactPhone" id="emergencyContactPhone"
                                                   placeholder="VD: 0901234567"
                                                   value="<c:out value='${employee.emergencyContactPhone}'/>">
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

                            <!-- Section 4.4: Trạng thái nhân viên (chỉ hiện khi chỉnh sửa) -->
                            <c:if test="${not empty employee and employee.id > 0}">
                            <div class="form-section-card">
                                <div class="form-section-header">
                                    <div class="form-section-title-wrap">
                                        <div class="form-section-icon orange"><i class="bi bi-toggle-on"></i></div>
                                        <div>
                                            <h3 class="form-section-title">4. Trạng thái nhân viên</h3>
                                            <div class="form-section-desc">Cập nhật tình trạng công tác hiện tại của nhân viên</div>
                                        </div>
                                    </div>
                                    <span class="badge bg-warning-subtle text-warning border border-warning-subtle" style="font-size:0.72rem;">Chỉ HR / Admin</span>
                                </div>
                                <div class="form-section-body">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label-custom">Trạng thái công tác <span class="req">*</span></label>
                                            <select class="form-select form-select-custom" name="status" id="employeeStatus"
                                                    onchange="toggleStatusFields(this.value)">
                                                <option value="ACTIVE"   ${employee.status eq 'ACTIVE'   ? 'selected' : ''}>✅ Đang làm việc (Active)</option>
                                                <option value="ON_LEAVE" ${employee.status eq 'ON_LEAVE' ? 'selected' : ''}>🟡 Nghỉ tạm thời (On Leave)</option>
                                                <option value="INACTIVE" ${employee.status eq 'INACTIVE' ? 'selected' : ''}>🔴 Đã nghỉ việc (Inactive)</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4" id="endDateField" style="${employee.status eq 'INACTIVE' or employee.status eq 'ON_LEAVE' ? '' : 'display:none;'}">
                                            <label class="form-label-custom">Ngày nghỉ việc / Ngày kết thúc</label>
                                            <input type="date" class="form-control form-control-custom"
                                                   name="endDate" id="endDate"
                                                   value="${not empty employee.endDate ? employee.endDate : ''}">
                                        </div>
                                        <div class="col-md-4" id="terminationField" style="${employee.status eq 'INACTIVE' ? '' : 'display:none;'}">
                                            <label class="form-label-custom">Lý do nghỉ việc</label>
                                            <select class="form-select form-select-custom" name="terminationReason" id="terminationReason">
                                                <option value="">— Chọn lý do —</option>
                                                <option value="Tự nguyện xin nghỉ" ${employee.terminationReason eq 'Tự nguyện xin nghỉ' ? 'selected' : ''}>Tự nguyện xin nghỉ</option>
                                                <option value="Hết hạn hợp đồng" ${employee.terminationReason eq 'Hết hạn hợp đồng' ? 'selected' : ''}>Hết hạn hợp đồng</option>
                                                <option value="Sa thải" ${employee.terminationReason eq 'Sa thải' ? 'selected' : ''}>Sa thải</option>
                                                <option value="Nghỉ hưu" ${employee.terminationReason eq 'Nghỉ hưu' ? 'selected' : ''}>Nghỉ hưu</option>
                                                <option value="Chuyển công tác" ${employee.terminationReason eq 'Chuyển công tác' ? 'selected' : ''}>Chuyển công tác</option>
                                                <option value="Khác" ${employee.terminationReason eq 'Khác' ? 'selected' : ''}>Khác</option>
                                            </select>
                                        </div>
                                        <c:if test="${not empty employee.terminationReason and employee.terminationReason ne 'Tự nguyện xin nghỉ' and employee.terminationReason ne 'Hết hạn hợp đồng' and employee.terminationReason ne 'Sa thải' and employee.terminationReason ne 'Nghỉ hưu' and employee.terminationReason ne 'Chuyển công tác'}">
                                        <div class="col-12" id="terminationNoteField">
                                            <label class="form-label-custom">Ghi chú lý do nghỉ việc</label>
                                            <input type="text" class="form-control form-control-custom"
                                                   name="terminationNote" placeholder="Mô tả thêm lý do nghỉ..."
                                                   value="<c:out value='${employee.terminationReason}'/>">
                                        </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            </c:if>


                            <div class="step-nav-footer mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                                <button type="button" class="btn btn-outline-secondary px-3 py-2 d-inline-flex align-items-center gap-1" onclick="prevStep()">
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
                        <button type="button" class="btn-next-step" id="btnNext" onclick="nextStep()">
                            <span id="btnNextText">Tiếp tục: Bước 2 (Công việc &amp; Vị trí)</span>
                            <i class="bi bi-arrow-right"></i>
                        </button>
                        <button type="submit" class="btn-submit-step" id="btnSubmit" style="display:none;">
                            <i class="bi bi-check2-all fs-5"></i>
                            <span>${empty employee or employee.id == 0 ? 'Hoàn tất & Lưu hồ sơ' : 'Lưu thay đổi'}</span>
                        </button>
                    </div>
                </div>

            </form><!-- END FORM -->

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    window.IS_EDIT_MODE = ${not empty employee and employee.id > 0 ? 'true' : 'false'};
    window.CURRENT_EMP_POS_ID = "${not empty employee ? employee.positionId : ''}";
    window.CURRENT_EMP_SALARY = "${formattedBaseSalary}";
    window.CURRENT_EMP_NAME = "<c:out value='${employee.fullName}'/>";
    window.CURRENT_EMP_CODE = "<c:out value='${employee.employeeCode}'/>";

    function toggleStatusFields(status) {
        const endDateField = document.getElementById('endDateField');
        const terminationField = document.getElementById('terminationField');
        if (!endDateField || !terminationField) return;
        if (status === 'INACTIVE' || status === 'ON_LEAVE') {
            endDateField.style.display = '';
        } else {
            endDateField.style.display = 'none';
        }
        if (status === 'INACTIVE') {
            terminationField.style.display = '';
        } else {
            terminationField.style.display = 'none';
        }
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/employee-form.js"></script>
</body>
</html>
