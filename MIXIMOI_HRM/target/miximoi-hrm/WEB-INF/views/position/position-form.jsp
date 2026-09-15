<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty position or empty position.id or position.id == 0 ? 'Thêm chức vụ mới' : 'Chỉnh sửa chức vụ'} — MIXIMOI HRM &amp; PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        /* ===== Root & Form Styling ===== */
        :root {
            --pos-primary: #2563eb;
            --pos-primary-hover: #1d4ed8;
            --pos-border: #e5e7eb;
            --pos-text-main: #111827;
            --pos-text-sub: #6b7280;
        }

        .pos-form-header {
            display: flex;
            flex-wrap: wrap;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 24px;
        }
        .pos-form-title {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--pos-text-main);
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 4px;
            letter-spacing: -0.02em;
        }
        .pos-form-subtitle {
            font-size: 0.84rem;
            color: var(--pos-text-sub);
            margin: 0;
        }
        .btn-back-list {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 16px;
            border: 1px solid #d1d5db;
            border-radius: 9px;
            background: #ffffff;
            color: #374151;
            font-size: 0.84rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.15s;
        }
        .btn-back-list:hover {
            background: #f9fafb;
            border-color: #9ca3af;
            color: #111827;
            transform: translateY(-1px);
        }

        /* 2-Column Layout */
        .pos-form-layout {
            display: grid;
            grid-template-columns: 290px 1fr;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 960px) {
            .pos-form-layout {
                grid-template-columns: 1fr;
            }
        }

        /* Left Side Preview Cards */
        .pos-left-panel {
            display: flex;
            flex-direction: column;
            gap: 18px;
            position: sticky;
            top: 80px;
        }
        .pos-preview-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 24px 20px;
            text-align: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
        }
        .pos-avatar-ring {
            width: 80px;
            height: 80px;
            border-radius: 18px;
            background: linear-gradient(135deg, #2563eb, #7c3aed);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin: 0 auto 16px;
            box-shadow: 0 6px 18px rgba(37, 99, 235, 0.28);
        }
        .pos-prev-name {
            font-size: 1.05rem;
            font-weight: 700;
            color: #111827;
            margin-bottom: 6px;
            line-height: 1.3;
        }
        .pos-prev-code {
            font-family: 'SFMono-Regular', Consolas, monospace;
            font-size: 0.78rem;
            font-weight: 700;
            color: #2563eb;
            background: #eff6ff;
            padding: 3px 10px;
            border-radius: 6px;
            display: inline-block;
            margin-bottom: 12px;
        }
        .pos-prev-level {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.76rem;
            font-weight: 600;
            background: #dbeafe;
            color: #1d4ed8;
        }

        .pos-spec-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 18px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
        }
        .pos-spec-title {
            font-size: 0.76rem;
            font-weight: 800;
            letter-spacing: 0.05em;
            color: #6b7280;
            text-transform: uppercase;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .pos-spec-row {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 9px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        .pos-spec-row:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .pos-spec-icon {
            width: 28px;
            height: 28px;
            border-radius: 7px;
            background: #eff6ff;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.82rem;
            flex-shrink: 0;
        }
        .pos-spec-label {
            font-size: 0.72rem;
            color: #6b7280;
        }
        .pos-spec-val {
            font-size: 0.83rem;
            color: #111827;
            font-weight: 600;
        }

        .pos-guide-card {
            background: linear-gradient(135deg, #eff6ff, #f0fdf4);
            border: 1px solid #bfdbfe;
            border-radius: 14px;
            padding: 18px;
        }
        .pos-guide-title {
            font-size: 0.8rem;
            font-weight: 700;
            color: #1d4ed8;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .pos-guide-item {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            margin-bottom: 8px;
            font-size: 0.78rem;
            color: #374151;
            line-height: 1.4;
        }
        .pos-guide-item:last-child {
            margin-bottom: 0;
        }
        .pos-guide-item i {
            color: #2563eb;
            flex-shrink: 0;
            margin-top: 1px;
        }

        /* Right Side Form Card */
        .pos-form-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
        }
        .pos-form-section {
            padding: 24px;
        }
        .pos-section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 22px;
            padding-bottom: 16px;
            border-bottom: 1px solid #f3f4f6;
        }
        .pos-section-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            background: #eff6ff;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        .pos-section-title {
            font-size: 1rem;
            font-weight: 700;
            color: #111827;
            margin: 0;
        }
        .pos-section-desc {
            font-size: 0.78rem;
            color: #6b7280;
            margin: 2px 0 0;
        }

        .form-label-custom {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }
        .form-label-custom .req {
            color: #ef4444;
            margin-left: 2px;
        }
        .form-label-custom .hint {
            font-size: 0.72rem;
            color: #9ca3af;
            font-weight: 400;
            margin-left: 6px;
        }
        .form-control-custom, .form-select-custom {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #e5e7eb;
            border-radius: 9px;
            font-size: 0.87rem;
            color: #111827;
            background: #fafafa;
            outline: none;
            transition: all 0.15s;
            box-sizing: border-box;
            font-family: inherit;
        }
        .form-control-custom:focus, .form-select-custom:focus {
            border-color: #2563eb;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }
        .form-control-custom::placeholder {
            color: #9ca3af;
        }

        /* Action Bar */
        .pos-form-action-bar {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            padding: 18px 24px;
            background: #f9fafb;
            border-top: 1px solid #e5e7eb;
        }
        .btn-cancel-action {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 9px 20px;
            border: 1px solid #d1d5db;
            border-radius: 9px;
            background: #ffffff;
            color: #374151;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.15s;
        }
        .btn-cancel-action:hover {
            background: #f3f4f6;
            border-color: #9ca3af;
            color: #111827;
        }
        .btn-submit-action {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 24px;
            border-radius: 9px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            font-size: 0.87rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
            transition: all 0.2s;
        }
        .btn-submit-action:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
        }
    </style>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="positions" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Position Form Content Body -->
        <div class="app-content">

            <!-- Page Header Breadcrumbs & Action -->
            <div class="pos-form-header">
                <div>
                    <h1 class="pos-form-title">
                        <i class="bi ${empty position or empty position.id or position.id == 0 ? 'bi-person-plus-fill' : 'bi-person-gear'} text-primary"></i>
                        ${empty position or empty position.id or position.id == 0 ? 'Thêm chức vụ mới' : 'Chỉnh sửa chức danh'}
                    </h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/positions" class="text-decoration-none">Chức vụ &amp; Cấp bậc</a></li>
                            <li class="breadcrumb-item active" aria-current="page">
                                ${empty position or empty position.id or position.id == 0 ? 'Thêm mới' : 'Cập nhật'}
                            </li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/positions" class="btn-back-list">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <!-- 2-Column Form Layout -->
            <div class="pos-form-layout">

                <!-- Left Column: Dynamic Preview Cards -->
                <div class="pos-left-panel">
                    <!-- Position Identity Card -->
                    <div class="pos-preview-card">
                        <div class="pos-avatar-ring">
                            <i class="bi bi-person-badge"></i>
                        </div>
                        <div class="pos-prev-name" id="prevPosName">
                            ${not empty position.name ? position.name : 'Tên chức danh vị trí'}
                        </div>
                        <div class="pos-prev-code" id="prevPosCode">
                            ${not empty position.code ? position.code : 'CV-TECH-01'}
                        </div>
                        <div>
                            <span class="pos-prev-level" id="prevPosLevel">
                                <i class="bi bi-award-fill me-1"></i>
                                ${not empty position.level ? position.level : 'Level 3 (Senior)'}
                            </span>
                        </div>
                    </div>

                    <!-- Quick Overview Card -->
                    <div class="pos-spec-card">
                        <div class="pos-spec-title">
                            <i class="bi bi-info-circle text-primary"></i>
                            Thông số chuẩn chức danh
                        </div>
                        <div class="pos-spec-row">
                            <div class="pos-spec-icon"><i class="bi bi-building"></i></div>
                            <div>
                                <div class="pos-spec-label">Phòng ban phụ trách</div>
                                <div class="pos-spec-val" id="prevDeptName">
                                    ${not empty position.departmentName ? position.departmentName : 'Công nghệ thông tin'}
                                </div>
                            </div>
                        </div>
                        <div class="pos-spec-row">
                            <div class="pos-spec-icon"><i class="bi bi-coin"></i></div>
                            <div>
                                <div class="pos-spec-label">Khung thu nhập cơ bản</div>
                                <div class="pos-spec-val text-success" id="prevSalaryRange">
                                    ${not empty position.salaryRangeFormatted ? position.salaryRangeFormatted : '20.000.000 – 35.000.000 đ'}
                                </div>
                            </div>
                        </div>
                        <div class="pos-spec-row">
                            <div class="pos-spec-icon"><i class="bi bi-shield-check"></i></div>
                            <div>
                                <div class="pos-spec-label">Trạng thái định biên</div>
                                <div class="pos-spec-val text-primary">Đang áp dụng (ISO-HR)</div>
                            </div>
                        </div>
                    </div>

                    <!-- ISO Guidelines Card -->
                    <div class="pos-guide-card">
                        <div class="pos-guide-title">
                            <i class="bi bi-lightbulb"></i> Chuẩn chức danh ISO-HR
                        </div>
                        <div class="pos-guide-item">
                            <i class="bi bi-check2-circle"></i>
                            <span>Tên chức vụ nên đặt theo cấu trúc [Vai trò] + [Lĩnh vực] + [Cấp bậc].</span>
                        </div>
                        <div class="pos-guide-item">
                            <i class="bi bi-check2-circle"></i>
                            <span>Khung lương cơ bản cần phản ánh đúng trách nhiệm và mặt bằng thị trường.</span>
                        </div>
                        <div class="pos-guide-item">
                            <i class="bi bi-check2-circle"></i>
                            <span>Cấp bậc L1 - L6 quyết định quyền hạn phê duyệt và thẩm quyền ký quyết định.</span>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Form Fields -->
                <div class="pos-form-card">
                    <form method="post" action="${pageContext.request.contextPath}/positions" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="${empty position or empty position.id or position.id == 0 ? 'add' : 'update'}">
                        <c:if test="${not empty position and position.id > 0}">
                            <input type="hidden" name="id" value="${position.id}">
                        </c:if>

                        <div class="pos-form-section">
                            <!-- Section Header -->
                            <div class="pos-section-header">
                                <div class="pos-section-icon">
                                    <i class="bi bi-person-lines-fill"></i>
                                </div>
                                <div>
                                    <h2 class="pos-section-title">Khai báo thông tin chức danh</h2>
                                    <p class="pos-section-desc">Định nghĩa chi tiết tiêu chuẩn chức vụ, cấp bậc và khung đãi ngộ</p>
                                </div>
                            </div>

                            <div class="row g-3">
                                <!-- Position Name -->
                                <div class="col-md-8">
                                    <label class="form-label-custom">
                                        Tên chức danh <span class="req">*</span>
                                        <span class="hint">VD: Senior Software Engineer, Trưởng phòng Kinh doanh...</span>
                                    </label>
                                    <input type="text" class="form-control-custom" id="posNameInput"
                                           name="name" required
                                           placeholder="Nhập tên chức danh công việc..."
                                           value="${position.name}"
                                           oninput="updatePreviewName(this.value)">
                                    <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng nhập tên chức vụ.</div>
                                </div>

                                <!-- Position Code -->
                                <div class="col-md-4">
                                    <label class="form-label-custom">
                                        Mã chức danh <span class="hint">(Hệ thống)</span>
                                    </label>
                                    <input type="text" class="form-control-custom font-monospace" id="posCodeInput"
                                           name="code" placeholder="CV-TECH-01"
                                           value="${position.code}"
                                           oninput="updatePreviewCode(this.value)">
                                </div>

                                <!-- Level Dropdown -->
                                <div class="col-md-6">
                                    <label class="form-label-custom">
                                        Cấp bậc (Level) <span class="req">*</span>
                                    </label>
                                    <select class="form-select-custom" id="posLevelSelect" name="level" onchange="updatePreviewLevel(this.value)">
                                        <option value="Level 1 (Intern)" ${position.level eq 'Level 1 (Intern)' ? 'selected' : ''}>Level 1 (Intern) — Thực tập sinh / Học việc</option>
                                        <option value="Level 2 (Mid)" ${position.level eq 'Level 2 (Mid)' ? 'selected' : ''}>Level 2 (Mid) — Chuyên viên / Kỹ sư</option>
                                        <option value="Level 3 (Senior)" ${(empty position.level or position.level eq 'Level 3 (Senior)') ? 'selected' : ''}>Level 3 (Senior) — Cao cấp / Chuyên gia</option>
                                        <option value="Level 3 (Specialist)" ${position.level eq 'Level 3 (Specialist)' ? 'selected' : ''}>Level 3 (Specialist) — Chuyên viên chính</option>
                                        <option value="Level 4 (Lead)" ${position.level eq 'Level 4 (Lead)' ? 'selected' : ''}>Level 4 (Lead) — Trưởng nhóm / Tech Lead</option>
                                        <option value="Level 4 (Manager)" ${position.level eq 'Level 4 (Manager)' ? 'selected' : ''}>Level 4 (Manager) — Trưởng phòng / Quản lý</option>
                                        <option value="Level 5 (Director)" ${position.level eq 'Level 5 (Director)' ? 'selected' : ''}>Level 5 (Director) — Giám đốc khối / Khối trưởng</option>
                                        <option value="Level 6 (C-Level)" ${position.level eq 'Level 6 (C-Level)' ? 'selected' : ''}>Level 6 (C-Level) — Ban Điều hành cấp cao (CxO)</option>
                                    </select>
                                </div>

                                <!-- Department Dropdown -->
                                <div class="col-md-6">
                                    <label class="form-label-custom">
                                        Phòng ban áp dụng <span class="req">*</span>
                                    </label>
                                    <select class="form-select-custom" id="posDeptSelect" name="departmentName" onchange="updatePreviewDept(this.value)">
                                        <option value="Công nghệ thông tin" ${(empty position.departmentName or position.departmentName eq 'Công nghệ thông tin') ? 'selected' : ''}>Công nghệ thông tin</option>
                                        <option value="Phát triển Kinh doanh" ${position.departmentName eq 'Phát triển Kinh doanh' ? 'selected' : ''}>Phát triển Kinh doanh</option>
                                        <option value="Quản trị Nhân sự" ${position.departmentName eq 'Quản trị Nhân sự' ? 'selected' : ''}>Quản trị Nhân sự</option>
                                        <option value="Tài chính - Kế toán" ${position.departmentName eq 'Tài chính - Kế toán' ? 'selected' : ''}>Tài chính - Kế toán</option>
                                        <option value="Marketing" ${position.departmentName eq 'Marketing' ? 'selected' : ''}>Marketing</option>
                                        <option value="Vận hành" ${position.departmentName eq 'Vận hành' ? 'selected' : ''}>Vận hành</option>
                                        <option value="Ban Điều hành" ${position.departmentName eq 'Ban Điều hành' ? 'selected' : ''}>Ban Điều hành</option>
                                        <option value="Pháp chế" ${position.departmentName eq 'Pháp chế' ? 'selected' : ''}>Pháp chế</option>
                                    </select>
                                </div>

                                <!-- Salary Min & Max -->
                                <div class="col-md-6">
                                    <label class="form-label-custom">
                                        Lương sàn tối thiểu (VNĐ) <span class="hint">Theo thang bảng lương</span>
                                    </label>
                                    <input type="number" class="form-control-custom" id="posMinSalary"
                                           name="minSalary" step="1000000"
                                           placeholder="VD: 20000000"
                                           value="${position.minSalary > 0 ? position.minSalary : 20000000}"
                                           oninput="updatePreviewSalary()">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label-custom">
                                        Lương trần tối đa (VNĐ) <span class="hint">Theo thang bảng lương</span>
                                    </label>
                                    <input type="number" class="form-control-custom" id="posMaxSalary"
                                           name="maxSalary" step="1000000"
                                           placeholder="VD: 35000000"
                                           value="${position.maxSalary > 0 ? position.maxSalary : 35000000}"
                                           oninput="updatePreviewSalary()">
                                </div>

                                <!-- KPI Checkbox -->
                                <div class="col-12">
                                    <div class="form-check form-switch pt-1">
                                        <input class="form-check-input" type="checkbox" role="switch" id="hasKpiCheck" name="hasKpi" value="true" ${position.hasKpi ? 'checked' : ''}>
                                        <label class="form-check-label fw-semibold text-dark" for="hasKpiCheck" style="font-size:0.85rem">
                                            Chức danh này được áp dụng chế độ thưởng hoa hồng / thưởng chỉ tiêu KPI theo tháng
                                        </label>
                                    </div>
                                </div>

                                <!-- Description -->
                                <div class="col-12">
                                    <label class="form-label-custom">Mô tả vai trò &amp; Trách nhiệm chính</label>
                                    <textarea class="form-control-custom" name="description" rows="4"
                                              placeholder="Mô tả tóm tắt phạm vi công việc, sản phẩm đầu ra và tuyến báo cáo trực tiếp...">${position.description}</textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Action Bar -->
                        <div class="pos-form-action-bar">
                            <a href="${pageContext.request.contextPath}/positions" class="btn-cancel-action">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn-submit-action">
                                <i class="bi bi-check2-circle"></i>
                                ${empty position or empty position.id or position.id == 0 ? 'Tạo chức vụ' : 'Lưu thay đổi'}
                            </button>
                        </div>
                    </form>
                </div>

            </div>

        </div>
    </main>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    (function () {
        'use strict'
        const forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    function updatePreviewName(val) {
        document.getElementById('prevPosName').textContent = val || 'Tên chức danh vị trí';
        if (!document.getElementById('posCodeInput').value) {
            const code = generateAutoCode(val);
            document.getElementById('prevPosCode').textContent = code;
        }
    }

    function updatePreviewCode(val) {
        document.getElementById('prevPosCode').textContent = val || 'CV-TECH-01';
    }

    function updatePreviewLevel(val) {
        document.getElementById('prevPosLevel').innerHTML = '<i class="bi bi-award-fill me-1"></i> ' + val;
    }

    function updatePreviewDept(val) {
        document.getElementById('prevDeptName').textContent = val;
    }

    function updatePreviewSalary() {
        const min = parseInt(document.getElementById('posMinSalary').value) || 0;
        const max = parseInt(document.getElementById('posMaxSalary').value) || 0;
        if (min > 0 && max > 0) {
            document.getElementById('prevSalaryRange').textContent = 
                min.toLocaleString('vi-VN') + ' – ' + max.toLocaleString('vi-VN') + ' đ';
        }
    }

    function generateAutoCode(name) {
        if (!name) return 'CV-TECH-01';
        const n = name.toLowerCase();
        if (n.includes('software') || n.includes('developer') || n.includes('tech') || n.includes('ui/ux')) return 'CV-TECH-01';
        if (n.includes('kinh doanh') || n.includes('sales') || n.includes('b2b')) return 'CV-SALES-01';
        if (n.includes('nhân sự') || n.includes('hr') || n.includes('tuyển dụng')) return 'CV-HR-01';
        if (n.includes('kế toán') || n.includes('tài chính') || n.includes('thuế')) return 'CV-ACC-01';
        return 'CV-GEN-01';
    }
</script>

</body>
</html>
