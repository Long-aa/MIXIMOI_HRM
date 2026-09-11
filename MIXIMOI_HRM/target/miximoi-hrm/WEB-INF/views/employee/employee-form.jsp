<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty employee or empty employee.id or employee.id == 0 ? 'Thêm nhân viên mới' : 'Chỉnh sửa nhân viên'} — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="employees" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Employee Form Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Actions -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi ${empty employee or empty employee.id or employee.id == 0 ? 'bi-person-plus-fill' : 'bi-pencil-square'} text-primary"></i>
                        ${empty employee or empty employee.id or employee.id == 0 ? 'Thêm nhân viên mới' : 'Chỉnh sửa thông tin nhân viên'}
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employees" class="text-decoration-none">Nhân viên</a></li>
                            <li class="breadcrumb-item active" aria-current="page">
                                ${empty employee or empty employee.id or employee.id == 0 ? 'Thêm mới' : 'Cập nhật NV'}
                            </li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/employees" class="btn-action-light text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <!-- Error Alert -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    <strong>Không thể lưu:</strong> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Form Card -->
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="app-card">
                        <form method="post" action="${pageContext.request.contextPath}/employees" id="employeeForm" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="${empty employee or empty employee.id or employee.id == 0 ? 'add' : 'update'}">
                            <c:if test="${not empty employee and employee.id > 0}">
                                <input type="hidden" name="id" value="${employee.id}">
                            </c:if>

                            <!-- Section 1: Thông tin cơ bản -->
                            <div class="form-section">
                                <div class="form-section-header">
                                    <div class="form-section-icon">
                                        <i class="bi bi-person-badge"></i>
                                    </div>
                                    <div>
                                        <h6 class="form-section-title">Thông tin định danh & Cá nhân</h6>
                                        <p class="form-section-desc">Các thông tin pháp lý và thông tin liên lạc cá nhân của nhân sự</p>
                                    </div>
                                </div>

                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label-custom">
                                            Mã nhân viên <span class="required-mark">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-custom font-monospace fw-bold" 
                                               name="employeeCode" required placeholder="VD: NV011"
                                               value="${employee.employeeCode}">
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng nhập mã nhân viên (không trùng lặp).</div>
                                    </div>

                                    <div class="col-md-5">
                                        <label class="form-label-custom">
                                            Họ và tên đầy đủ <span class="required-mark">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-custom" 
                                               name="fullName" required placeholder="VD: Nguyễn Văn A"
                                               value="${employee.fullName}">
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng nhập họ và tên nhân viên.</div>
                                    </div>

                                    <div class="col-md-3">
                                        <label class="form-label-custom">
                                            Giới tính <span class="required-mark">*</span>
                                        </label>
                                        <select class="form-select form-select-custom" name="gender" required>
                                            <option value="MALE" ${employee.gender eq 'MALE' ? 'selected' : ''}>Nam</option>
                                            <option value="FEMALE" ${employee.gender eq 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                            <option value="OTHER" ${employee.gender eq 'OTHER' ? 'selected' : ''}>Khác</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label-custom">Ngày sinh</label>
                                        <input type="date" class="form-control form-control-custom" 
                                               name="dateOfBirth" value="${employee.dateOfBirth}">
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label-custom">
                                            Số điện thoại <span class="required-mark">*</span>
                                        </label>
                                        <input type="tel" class="form-control form-control-custom" 
                                               name="phone" required placeholder="09xxxxxxxx"
                                               value="${employee.phone}">
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label-custom">
                                            Email công việc <span class="required-mark">*</span>
                                        </label>
                                        <input type="email" class="form-control form-control-custom" 
                                               name="email" required placeholder="example@miximoi.vn"
                                               value="${employee.email}">
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label-custom">Địa chỉ thường trú</label>
                                        <input type="text" class="form-control form-control-custom" 
                                               name="address" placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/TP"
                                               value="${employee.address}">
                                    </div>
                                </div>
                            </div>

                            <!-- Section 2: Vị trí & Công việc -->
                            <div class="form-section">
                                <div class="form-section-header">
                                    <div class="form-section-icon">
                                        <i class="bi bi-briefcase"></i>
                                    </div>
                                    <div>
                                        <h6 class="form-section-title">Vị trí & Tổ chức công tác</h6>
                                        <p class="form-section-desc">Phòng ban phân công, chức danh và phân loại nhân viên</p>
                                    </div>
                                </div>

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label-custom">
                                            Phòng ban trực thuộc <span class="required-mark">*</span>
                                        </label>
                                        <select class="form-select form-select-custom" name="departmentId" required>
                                            <option value="">-- Chọn phòng ban --</option>
                                            <c:forEach var="dept" items="${departments}">
                                                <option value="${dept.id}" ${employee.departmentId == dept.id ? 'selected' : ''}>
                                                    ${dept.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label-custom">
                                            Chức vụ bổ nhiệm <span class="required-mark">*</span>
                                        </label>
                                        <select class="form-select form-select-custom" name="positionId" required>
                                            <option value="">-- Chọn chức vụ --</option>
                                            <c:forEach var="pos" items="${positions}">
                                                <option value="${pos.id}" ${employee.positionId == pos.id ? 'selected' : ''}>
                                                    ${pos.name}
                                                </option>
                                            </c:forEach>
                                        </select>
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
                                        <label class="form-label-custom">
                                            Ngày bắt đầu làm việc <span class="required-mark">*</span>
                                        </label>
                                        <input type="date" class="form-control form-control-custom" 
                                               name="startDate" required value="${employee.startDate}">
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label-custom">
                                            Trạng thái công tác <span class="required-mark">*</span>
                                        </label>
                                        <select class="form-select form-select-custom" name="status" required>
                                            <option value="ACTIVE" ${empty employee.status or employee.status eq 'ACTIVE' ? 'selected' : ''}>Đang làm việc (ACTIVE)</option>
                                            <option value="ON_LEAVE" ${employee.status eq 'ON_LEAVE' ? 'selected' : ''}>Nghỉ tạm thời (ON_LEAVE)</option>
                                            <option value="INACTIVE" ${employee.status eq 'INACTIVE' ? 'selected' : ''}>Đã nghỉ việc (INACTIVE)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Bar -->
                            <div class="d-flex justify-content-end align-items-center gap-3 pt-3">
                                <a href="${pageContext.request.contextPath}/employees" class="btn-action-light text-decoration-none">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn-action-primary border-0">
                                    <i class="bi bi-check2-circle"></i>
                                    ${empty employee or empty employee.id or employee.id == 0 ? 'Thêm nhân viên' : 'Lưu cập nhật'}
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    // Bootstrap form validation
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
</script>

</body>
</html>
