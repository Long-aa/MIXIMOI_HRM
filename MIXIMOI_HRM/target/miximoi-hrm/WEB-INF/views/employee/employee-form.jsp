<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty employee or employee.id == 0 ? 'Thêm nhân viên mới' : 'Chỉnh sửa nhân viên'} — MIXIMOI HRM</title>
    <meta name="description" content="Quy trình tiếp nhận nhân sự MIXIMOI - Onboarding nhân viên mới theo tiêu chuẩn 4 bước">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        /* ====== Multi-Step Wizard Stepper ====== */
        .wizard-stepper {
            display: flex; align-items: center; gap: 0; margin-bottom: 2rem;
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            padding: 1.1rem 1.5rem; box-shadow: 0 2px 10px rgba(15,23,42,0.04);
            overflow-x: auto;
        }
        .step-item { display: flex; align-items: center; flex: 1; min-width: 0; }
        .step-item:last-child { flex: none; }
        .step-number-wrap { display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
        .step-number {
            width: 34px; height: 34px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.82rem; font-weight: 800; flex-shrink: 0;
            transition: all 0.25s;
        }
        .step-number.done    { background: #059669; color: #fff; }
        .step-number.active  { background: #2563eb; color: #fff; box-shadow: 0 0 0 4px rgba(37,99,235,0.18); }
        .step-number.pending { background: #f1f5f9; color: #94a3b8; border: 2px solid #e2e8f0; }
        .step-label { min-width: 0; }
        .step-label-title {
            font-size: 0.7rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.5px; margin-bottom: 2px;
        }
        .step-label-title.done    { color: #059669; }
        .step-label-title.active  { color: #2563eb; }
        .step-label-title.pending { color: #94a3b8; }
        .step-label-desc { font-size: 0.78rem; font-weight: 500; color: #475569; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 130px; }
        .step-connector {
            flex: 1; height: 2px; background: #e2e8f0; margin: 0 12px; min-width: 20px;
        }
        .step-connector.done { background: #10b981; }

        /* ====== Two-column form layout ====== */
        .wizard-body { display: grid; grid-template-columns: 300px 1fr; gap: 1.5rem; }
        @media (max-width: 900px) { .wizard-body { grid-template-columns: 1fr; } }

        /* ====== Left panel ====== */
        .left-panel-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            box-shadow: 0 2px 10px rgba(15,23,42,0.04); overflow: hidden;
        }
        .left-panel-top { padding: 1.5rem 1.25rem; border-bottom: 1px solid #f1f5f9; }

        /* Avatar upload */
        .avatar-upload-zone {
            width: 120px; height: 120px; border-radius: 50%;
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            border: 3px dashed #93c5fd;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            cursor: pointer; transition: all 0.2s; margin: 0 auto 1rem;
            position: relative; overflow: hidden;
        }
        .avatar-upload-zone:hover { border-color: #2563eb; background: #dbeafe; }
        .avatar-upload-zone .upload-icon { font-size: 2rem; color: #3b82f6; margin-bottom: 4px; }
        .avatar-upload-zone .upload-text { font-size: 0.72rem; color: #64748b; text-align: center; line-height: 1.3; }
        .avatar-preview-img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        #avatarFile { display: none; }

        .system-info-card {
            background: #f8fafc; border-radius: 10px;
            padding: 0.85rem 1rem; margin-top: 1rem;
        }
        .system-info-label { font-size: 0.7rem; font-weight: 700; letter-spacing: 0.5px; color: #94a3b8; text-transform: uppercase; margin-bottom: 8px; }
        .system-info-row {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 6px; font-size: 0.82rem;
        }
        .system-info-key { color: #64748b; }
        .system-info-val { font-weight: 700; color: #1e293b; font-family: monospace; }
        .badge-new { background: #fef9c3; color: #92400e; border-radius: 5px; padding: 1px 7px; font-size: 0.72rem; font-weight: 600; }

        /* Progress bar */
        .progress-section { padding: 1rem 1.25rem; border-top: 1px solid #f1f5f9; }
        .progress-label-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
        .progress-label { font-size: 0.78rem; font-weight: 600; color: #475569; }
        .progress-pct { font-size: 0.82rem; font-weight: 800; color: #2563eb; }
        .custom-progress { height: 8px; border-radius: 999px; background: #e2e8f0; overflow: hidden; }
        .custom-progress-fill { height: 100%; background: linear-gradient(90deg, #2563eb, #60a5fa); border-radius: 999px; transition: width 0.5s ease; }
        .progress-hint { font-size: 0.72rem; color: #94a3b8; margin-top: 8px; }

        /* Guidelines */
        .guideline-card {
            background: #fffbeb; border: 1px solid #fde68a; border-radius: 10px;
            padding: 0.75rem 0.9rem; margin: 1rem 1.25rem 0;
        }
        .guideline-card h6 { font-size: 0.75rem; font-weight: 700; color: #92400e; margin-bottom: 6px; }
        .guideline-card ul { margin: 0; padding-left: 1.1rem; }
        .guideline-card li { font-size: 0.75rem; color: #78350f; margin-bottom: 3px; }
        .guideline-card a { color: #2563eb; }

        /* ====== Right panel form ====== */
        .form-section-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            box-shadow: 0 2px 10px rgba(15,23,42,0.04); margin-bottom: 1rem; overflow: hidden;
        }
        .form-section-header {
            display: flex; align-items: center; gap: 12px;
            padding: 0.9rem 1.25rem; border-bottom: 1px solid #f8fafc; background: #f8fafc;
        }
        .form-section-num {
            width: 30px; height: 30px; border-radius: 8px;
            background: linear-gradient(135deg, #2563eb, #60a5fa);
            color: #fff; display: flex; align-items: center; justify-content: center;
            font-size: 0.82rem; font-weight: 800; flex-shrink: 0;
        }
        .form-section-title { font-size: 0.92rem; font-weight: 700; color: #1e293b; margin: 0; }
        .form-section-subtitle { font-size: 0.75rem; color: #64748b; margin: 0; }
        .form-section-body { padding: 1.25rem; }
        .form-section-badge {
            margin-left: auto;
            background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0;
            border-radius: 999px; padding: 2px 10px; font-size: 0.72rem; font-weight: 700;
        }

        /* Form fields */
        .form-label-custom { font-size: 0.8rem; font-weight: 600; color: #374151; margin-bottom: 4px; display: block; }
        .req { color: #ef4444; }
        .form-control-custom, .form-select-custom {
            height: 40px; border-radius: 9px;
            border: 1.5px solid #e2e8f0; font-size: 0.875rem;
            background: #f8fafc; transition: all 0.15s;
        }
        .form-control-custom:focus, .form-select-custom:focus {
            background: #fff; border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.09);
        }
        textarea.form-control-custom { height: auto; min-height: 72px; }

        /* Gender toggle pills */
        .gender-toggle { display: flex; gap: 8px; }
        .gender-option { position: relative; }
        .gender-option input[type=radio] { display: none; }
        .gender-option label {
            display: inline-flex; align-items: center; gap: 5px;
            height: 38px; padding: 0 16px;
            border: 1.5px solid #e2e8f0; border-radius: 9px;
            font-size: 0.85rem; font-weight: 500; color: #64748b;
            cursor: pointer; transition: all 0.15s; background: #f8fafc;
        }
        .gender-option input:checked + label {
            background: #eff6ff; border-color: #2563eb; color: #1d4ed8; font-weight: 700;
        }
        .gender-option input:checked + label i { color: #2563eb; }

        /* CCCD number input */
        .cccd-wrap { position: relative; }
        .cccd-verified { position: absolute; right: 10px; top: 50%; transform: translateY(-50%); color: #059669; font-size: 1rem; }

        /* Sticky action bar */
        .wizard-action-bar {
            position: sticky; bottom: 0; z-index: 100;
            background: #fff; border-top: 1.5px solid #f1f5f9;
            margin: 0 -1.5rem; padding: 0.85rem 1.5rem;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 -4px 16px rgba(15,23,42,0.06);
        }
        .btn-wizard-prev {
            height: 40px; padding: 0 1.25rem;
            background: #f1f5f9; color: #475569; border: none;
            border-radius: 10px; font-size: 0.875rem; font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px;
            transition: all 0.15s; text-decoration: none;
        }
        .btn-wizard-prev:hover { background: #e2e8f0; color: #1e293b; }
        .btn-wizard-save {
            height: 40px; padding: 0 1.25rem;
            background: #f8fafc; color: #475569;
            border: 1.5px solid #e2e8f0; border-radius: 10px;
            font-size: 0.875rem; font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px;
            transition: all 0.15s;
        }
        .btn-wizard-save:hover { background: #f1f5f9; color: #1e293b; }
        .btn-wizard-next {
            height: 40px; padding: 0 1.5rem;
            background: #2563eb; color: #fff; border: none;
            border-radius: 10px; font-size: 0.875rem; font-weight: 700;
            display: inline-flex; align-items: center; gap: 6px;
            box-shadow: 0 4px 12px rgba(37,99,235,0.25);
            transition: all 0.15s;
        }
        .btn-wizard-next:hover { background: #1d4ed8; transform: translateY(-1px); box-shadow: 0 6px 16px rgba(37,99,235,0.32); }
        .autosave-hint { font-size: 0.76rem; color: #94a3b8; }
    </style>
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="employees" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Page Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
                <div>
                    <div style="font-size:0.75rem; color:#94a3b8; font-weight:500; margin-bottom:4px;">
                        QUY TRÌNH TIẾP NHẬN NHÂN SỰ
                    </div>
                    <h1 style="font-size:1.4rem; font-weight:800; color:#0f172a; margin:0;">
                        ${empty employee or employee.id == 0 ? 'Thêm nhân viên mới' : 'Chỉnh sửa nhân viên'}
                    </h1>
                    <p style="font-size:0.82rem; color:#64748b; margin:4px 0 0;">
                        Khởi tạo hồ sơ nhân sự điện tử chuẩn hóa cho toàn hệ thống tập đoàn MIXIMOI
                    </p>
                </div>
                <div style="font-size:0.8rem; color:#64748b; background:#f8fafc; border:1px solid #e2e8f0; border-radius:9px; padding:6px 14px;">
                    <i class="bi bi-save2 me-1 text-primary"></i> Đang soạn thảo hồ sơ
                </div>
            </div>

            <!-- Error -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 shadow-sm mb-3" style="border-radius:10px; font-size:0.875rem;">
                    <i class="bi bi-exclamation-circle-fill me-2"></i> <strong>Lỗi lưu:</strong> ${error}
                </div>
            </c:if>

            <!-- Stepper -->
            <div class="wizard-stepper">
                <div class="step-item">
                    <div class="step-number-wrap">
                        <div class="step-number active">01</div>
                        <div class="step-label">
                            <div class="step-label-title active">BƯỚC 1 • ĐANG THỰC HIỆN</div>
                            <div class="step-label-desc">Thông tin cá nhân & Liên lạc</div>
                        </div>
                    </div>
                    <div class="step-connector"></div>
                </div>
                <div class="step-item">
                    <div class="step-number-wrap">
                        <div class="step-number pending">02</div>
                        <div class="step-label">
                            <div class="step-label-title pending">BƯỚC 2</div>
                            <div class="step-label-desc">Công việc & Vị trí</div>
                        </div>
                    </div>
                    <div class="step-connector"></div>
                </div>
                <div class="step-item">
                    <div class="step-number-wrap">
                        <div class="step-number pending">03</div>
                        <div class="step-label">
                            <div class="step-label-title pending">BƯỚC 3</div>
                            <div class="step-label-desc">Lương & Phúc lợi</div>
                        </div>
                    </div>
                    <div class="step-connector"></div>
                </div>
                <div class="step-item">
                    <div class="step-number-wrap">
                        <div class="step-number pending">04</div>
                        <div class="step-label">
                            <div class="step-label-title pending">BƯỚC 4</div>
                            <div class="step-label-desc">Hợp đồng & Bảo hiểm</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Form (two columns) -->
            <form method="post" action="${pageContext.request.contextPath}/employees" id="employeeForm" enctype="multipart/form-data" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="${empty employee or employee.id == 0 ? 'add' : 'update'}">
                <c:if test="${not empty employee and employee.id > 0}">
                    <input type="hidden" name="id" value="${employee.id}">
                </c:if>

                <div class="wizard-body">

                    <!-- LEFT PANEL -->
                    <div>
                        <div class="left-panel-card">
                            <div class="left-panel-top text-center">
                                <!-- Avatar Upload -->
                                <div class="avatar-upload-zone" onclick="document.getElementById('avatarFile').click()" id="avatarZone">
                                    <img id="avatarPreview" src="" class="avatar-preview-img" style="display:none;">
                                    <div id="avatarPlaceholder">
                                        <i class="bi bi-camera-fill upload-icon"></i>
                                        <div class="upload-text">Tải ảnh<br>chân dung (3x4/4x6)</div>
                                    </div>
                                </div>
                                <input type="file" id="avatarFile" name="avatar" accept=".jpg,.jpeg,.png,.webp">
                                <div style="font-size:0.72rem; color:#94a3b8; margin-top:4px;">
                                    Hỗ trợ JPG, PNG. Kích thước tối đa 5MB. Ảnh rõ nét, nền trắng sáng màu.
                                </div>

                                <!-- System Info -->
                                <div class="system-info-card text-start">
                                    <div class="system-info-label">Thông tin hệ thống cấp <span style="color:#2563eb;float:right;font-weight:500;font-size:0.7rem;cursor:pointer;">Tự động sinh</span></div>
                                    <div class="system-info-row">
                                        <span class="system-info-key">Mã nhân viên đề xuất</span>
                                        <span class="system-info-val" style="color:#2563eb;">${empty employee.employeeCode ? 'NV0__' : employee.employeeCode}</span>
                                    </div>
                                    <div class="system-info-row">
                                        <span class="system-info-key">Ngày khởi tạo</span>
                                        <span class="system-info-val" id="todayDate"></span>
                                    </div>
                                    <div class="system-info-row" style="margin-bottom:0;">
                                        <span class="system-info-key">Trạng thái hồ sơ</span>
                                        <span class="badge-new">Tạo mới (Bản nháp)</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Progress -->
                            <div class="progress-section">
                                <div class="progress-label-row">
                                    <span class="progress-label">Tiến độ Bước 1</span>
                                    <span class="progress-pct" id="progressPct">0%</span>
                                </div>
                                <div class="custom-progress">
                                    <div class="custom-progress-fill" id="progressFill" style="width:0%"></div>
                                </div>
                                <div class="progress-hint">Vui lòng hoàn thiện các trường đánh dấu <span style="color:#ef4444;">*</span> để mở khóa tiếp tục sang bước Công việc.</div>
                            </div>

                            <!-- Guidelines -->
                            <div class="guideline-card">
                                <h6><i class="bi bi-shield-check me-1"></i> Quy chuẩn dữ liệu nhập hệ thống</h6>
                                <ul>
                                    <li>CCCD/Hộ chiếu phải còn hiệu lực ít nhất <strong>6 tháng</strong> tính đến ngày ký tiếp nhận.</li>
                                    <li>Email công ty (@miximoi.vn) sẽ được dùng để kích hoạt tài khoản SSO và nhận phiếu lương hàng tháng.</li>
                                </ul>
                            </div>
                            <div style="height:1rem;"></div>
                        </div>
                    </div>

                    <!-- RIGHT PANEL: Form Sections -->
                    <div>

                        <!-- Section 1: Thông tin định danh -->
                        <div class="form-section-card">
                            <div class="form-section-header">
                                <div class="form-section-num">1</div>
                                <div>
                                    <div class="form-section-title">Thông tin định danh cá nhân</div>
                                    <div class="form-section-subtitle">Thông tin pháp lý đối chiếu với cơ sở dữ liệu định danh quốc gia</div>
                                </div>
                                <span class="form-section-badge">BẮT BUỘC ĐIỀN ĐỦ</span>
                            </div>
                            <div class="form-section-body">
                                <div class="row g-3">
                                    <div class="col-md-8">
                                        <label class="form-label-custom">Họ và tên đầy đủ <span class="req">*</span></label>
                                        <input type="text" class="form-control form-control-custom"
                                               name="fullName" required placeholder="VD: Nguyễn Văn An"
                                               value="<c:out value='${employee.fullName}'/>">
                                        <div class="invalid-feedback" style="font-size:0.75rem;">Vui lòng nhập họ và tên đầy đủ.</div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label-custom">Ngày sinh <span class="req">*</span></label>
                                        <input type="date" class="form-control form-control-custom"
                                               name="dateOfBirth" value="${employee.dateOfBirth}" required>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label-custom">Giới tính <span class="req">*</span></label>
                                        <div class="gender-toggle">
                                            <div class="gender-option">
                                                <input type="radio" name="gender" id="genderMale" value="MALE" ${empty employee.gender or employee.gender eq 'MALE' ? 'checked' : ''} required>
                                                <label for="genderMale"><i class="bi bi-gender-male"></i> Nam</label>
                                            </div>
                                            <div class="gender-option">
                                                <input type="radio" name="gender" id="genderFemale" value="FEMALE" ${employee.gender eq 'FEMALE' ? 'checked' : ''}>
                                                <label for="genderFemale"><i class="bi bi-gender-female"></i> Nữ</label>
                                            </div>
                                            <div class="gender-option">
                                                <input type="radio" name="gender" id="genderOther" value="OTHER" ${employee.gender eq 'OTHER' ? 'checked' : ''}>
                                                <label for="genderOther"><i class="bi bi-gender-ambiguous"></i> Khác</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label-custom">Mã nhân viên <span class="req">*</span></label>
                                        <input type="text" class="form-control form-control-custom font-monospace fw-bold"
                                               name="employeeCode" required placeholder="VD: NV011"
                                               value="<c:out value='${employee.employeeCode}'/>">
                                        <div class="invalid-feedback" style="font-size:0.75rem;">Mã nhân viên không được để trống (không trùng lặp).</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label-custom">Dân tộc</label>
                                        <input type="text" class="form-control form-control-custom" name="ethnicity" placeholder="VD: Kinh">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 2: Liên lạc & Địa chỉ -->
                        <div class="form-section-card">
                            <div class="form-section-header">
                                <div class="form-section-num">2</div>
                                <div>
                                    <div class="form-section-title">Thông tin liên lạc & Địa chỉ cư trú</div>
                                    <div class="form-section-subtitle">Kênh thông báo công việc, gửi phiếu lương và liên hệ khi khẩn cấp</div>
                                </div>
                            </div>
                            <div class="form-section-body">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label-custom">Email cá nhân <span class="req">*</span></label>
                                        <input type="email" class="form-control form-control-custom"
                                               name="email" required placeholder="VD: nguyenan@gmail.com"
                                               value="<c:out value='${employee.email}'/>">
                                        <div class="invalid-feedback" style="font-size:0.75rem;">Địa chỉ email không hợp lệ.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label-custom">Email công ty dự kiến</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control form-control-custom" name="companyEmailPrefix"
                                                   placeholder="ten.nv" style="border-right:none; border-radius:9px 0 0 9px;">
                                            <span class="input-group-text" style="background:#f1f5f9; border:1.5px solid #e2e8f0; border-left:none; border-radius:0 9px 9px 0; font-size:0.83rem; color:#64748b;">@miximoi.vn</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label-custom">Số điện thoại chính <span class="req">*</span></label>
                                        <input type="tel" class="form-control form-control-custom"
                                               name="phone" required placeholder="09xxxxxxxx"
                                               value="<c:out value='${employee.phone}'/>">
                                        <div class="invalid-feedback" style="font-size:0.75rem;">SĐT không hợp lệ.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label-custom">Liên hệ khẩn cấp (Họ tên + SĐT + Quan hệ)</label>
                                        <input type="text" class="form-control form-control-custom" name="emergencyContact"
                                               placeholder="VD: Nguyễn Văn B (Bố) - 0988 112 233">
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label-custom">Địa chỉ thường trú (ghi rõ theo CCCD) <span class="req">*</span></label>
                                        <input type="text" class="form-control form-control-custom"
                                               name="address" required placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/TP"
                                               value="<c:out value='${employee.address}'/>">
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label-custom">
                                            Địa chỉ tạm trú / Nơi ở hiện nay
                                            <label style="float:right; font-size:0.75rem; font-weight:400; color:#64748b; cursor:pointer; display:flex; align-items:center; gap:4px;">
                                                <input type="checkbox" id="sameAddr" onchange="copySameAddr(this)"> Giống địa chỉ thường trú
                                            </label>
                                        </label>
                                        <input type="text" class="form-control form-control-custom" id="tempAddr" name="tempAddress"
                                               placeholder="Để trống nếu giống thường trú">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 3: Vị trí & Công việc -->
                        <div class="form-section-card">
                            <div class="form-section-header">
                                <div class="form-section-num">3</div>
                                <div>
                                    <div class="form-section-title">Vị trí & Tổ chức công tác</div>
                                    <div class="form-section-subtitle">Phòng ban phân công, chức danh chuyên môn và phân loại nhân sự</div>
                                </div>
                            </div>
                            <div class="form-section-body">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label-custom">Phòng ban trực thuộc <span class="req">*</span></label>
                                        <select class="form-select form-select-custom" name="departmentId" required>
                                            <option value="">— Chọn phòng ban —</option>
                                            <c:forEach var="dept" items="${departments}">
                                                <option value="${dept.id}" ${employee.departmentId == dept.id ? 'selected' : ''}><c:out value="${dept.name}"/></option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback" style="font-size:0.75rem;">Vui lòng chọn phòng ban.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label-custom">Chức vụ bổ nhiệm <span class="req">*</span></label>
                                        <select class="form-select form-select-custom" name="positionId" required>
                                            <option value="">— Chọn chức vụ —</option>
                                            <c:forEach var="pos" items="${positions}">
                                                <option value="${pos.id}" ${employee.positionId == pos.id ? 'selected' : ''}><c:out value="${pos.name}"/></option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback" style="font-size:0.75rem;">Vui lòng chọn chức vụ.</div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label-custom">Hình thức nhân viên</label>
                                        <select class="form-select form-select-custom" name="employeeTypeId">
                                            <option value="1" ${employee.employeeTypeId == 1 ? 'selected' : ''}>Nhân viên chính thức</option>
                                            <option value="2" ${employee.employeeTypeId == 2 ? 'selected' : ''}>Nhân viên thử việc</option>
                                            <option value="3" ${employee.employeeTypeId == 3 ? 'selected' : ''}>Nhân viên thời vụ</option>
                                            <option value="4" ${employee.employeeTypeId == 4 ? 'selected' : ''}>Cộng tác viên</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label-custom">Ngày bắt đầu làm việc <span class="req">*</span></label>
                                        <input type="date" class="form-control form-control-custom"
                                               name="startDate" required value="${employee.startDate}">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label-custom">Trạng thái công tác <span class="req">*</span></label>
                                        <select class="form-select form-select-custom" name="status" required>
                                            <option value="ACTIVE"   ${empty employee.status or employee.status eq 'ACTIVE'   ? 'selected' : ''}>Đang làm việc</option>
                                            <option value="ON_LEAVE" ${employee.status eq 'ON_LEAVE' ? 'selected' : ''}>Nghỉ tạm thời</option>
                                            <option value="INACTIVE" ${employee.status eq 'INACTIVE' ? 'selected' : ''}>Đã nghỉ việc</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sticky action bar -->
                        <div class="wizard-action-bar">
                            <div class="autosave-hint">
                                <i class="bi bi-cloud-check me-1 text-success"></i> Hệ thống tự động lưu nháp sau 1 phút
                            </div>
                            <div class="d-flex gap-2 align-items-center">
                                <a href="${pageContext.request.contextPath}/employees" class="btn-wizard-prev">
                                    <i class="bi bi-arrow-left"></i> Hủy bỏ & Quay lại
                                </a>
                                <button type="button" class="btn-wizard-save" onclick="document.getElementById('employeeForm').submit();">
                                    <i class="bi bi-floppy"></i> Lưu bản nháp
                                </button>
                                <button type="submit" class="btn-wizard-next">
                                    <i class="bi bi-check2-circle"></i>
                                    ${empty employee or employee.id == 0 ? 'Tiếp tục: Bước 2 (Công việc & Vị trí)' : 'Lưu cập nhật nhân viên'}
                                    <i class="bi bi-arrow-right"></i>
                                </button>
                            </div>
                        </div>

                    </div><!-- end right panel -->
                </div><!-- end wizard-body -->
            </form>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    // Today date
    const today = new Date();
    document.getElementById('todayDate').textContent =
        String(today.getDate()).padStart(2,'0') + '/' +
        String(today.getMonth()+1).padStart(2,'0') + '/' + today.getFullYear();

    // Avatar preview
    document.getElementById('avatarFile').addEventListener('change', function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = e => {
                document.getElementById('avatarPreview').src = e.target.result;
                document.getElementById('avatarPreview').style.display = 'block';
                document.getElementById('avatarPlaceholder').style.display = 'none';
            };
            reader.readAsDataURL(file);
        }
    });

    // Copy same address
    function copySameAddr(cb) {
        const permanentAddr = document.querySelector('input[name="address"]');
        const tempAddr = document.getElementById('tempAddr');
        if (cb.checked) {
            tempAddr.value = permanentAddr.value;
            tempAddr.disabled = true;
        } else {
            tempAddr.disabled = false;
        }
    }

    // Progress tracking
    const requiredFields = document.querySelectorAll('[required]');
    function updateProgress() {
        let filled = 0;
        requiredFields.forEach(f => {
            if (f.type === 'radio') {
                const group = document.querySelectorAll(`[name="${f.name}"]:checked`);
                if (group.length > 0) filled++;
            } else if (f.value.trim()) {
                filled++;
            }
        });
        // Count unique radio groups
        const radioGroups = new Set([...requiredFields].filter(f => f.type==='radio').map(f => f.name));
        const total = requiredFields.length - document.querySelectorAll('[type=radio]').length + radioGroups.size;
        const uniqueFilled = new Set([...document.querySelectorAll('[required]:not([type=radio])')]
            .filter(f => f.value.trim()).concat([...document.querySelectorAll('[required][type=radio]:checked')]));
        const pct = Math.round((uniqueFilled.size / total) * 100);
        document.getElementById('progressFill').style.width = pct + '%';
        document.getElementById('progressPct').textContent = pct + '%';
    }
    requiredFields.forEach(f => f.addEventListener('input', updateProgress));
    requiredFields.forEach(f => f.addEventListener('change', updateProgress));
    updateProgress();

    // Bootstrap form validation
    (function() {
        'use strict';
        document.getElementById('employeeForm').addEventListener('submit', function(e) {
            if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
            this.classList.add('was-validated');
        });
    })();
</script>
</body>
</html>
