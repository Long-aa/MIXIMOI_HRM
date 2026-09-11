<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty position or empty position.id or position.id == 0 ? 'Thêm chức vụ mới' : 'Chỉnh sửa chức vụ'} — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
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
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi ${empty position or empty position.id or position.id == 0 ? 'bi-person-plus-fill' : 'bi-person-gear'} text-primary"></i>
                        ${empty position or empty position.id or position.id == 0 ? 'Thêm chức vụ mới' : 'Chỉnh sửa chức danh'}
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/positions" class="text-decoration-none">Chức vụ</a></li>
                            <li class="breadcrumb-item active" aria-current="page">
                                ${empty position or empty position.id or position.id == 0 ? 'Thêm mới' : 'Cập nhật'}
                            </li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/positions" class="btn-action-light text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <!-- Form Card -->
            <div class="row justify-content-center">
                <div class="col-lg-7">
                    <div class="app-card">
                        <form method="post" action="${pageContext.request.contextPath}/positions" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="${empty position or empty position.id or position.id == 0 ? 'add' : 'update'}">
                            <c:if test="${not empty position and position.id > 0}">
                                <input type="hidden" name="id" value="${position.id}">
                            </c:if>

                            <div class="form-section">
                                <div class="form-section-header">
                                    <div class="form-section-icon">
                                        <i class="bi bi-person-badge"></i>
                                    </div>
                                    <div>
                                        <h6 class="form-section-title">Thông tin chức vụ</h6>
                                        <p class="form-section-desc">Khai báo tên chức danh vị trí và mô tả yêu cầu vai trò</p>
                                    </div>
                                </div>

                                <div class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label-custom">
                                            Tên chức danh <span class="required-mark">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-custom" 
                                               name="name" required placeholder="VD: Kỹ sư Phần mềm Cao cấp, Chuyên viên Tuyển dụng..."
                                               value="${position.name}">
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng nhập tên chức vụ.</div>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label-custom">Mô tả vai trò & trách nhiệm</label>
                                        <textarea class="form-control form-control-custom" name="description" rows="4"
                                                  placeholder="Mô tả tóm tắt trách nhiệm, phạm vi công việc và báo cáo...">${position.description}</textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Bar -->
                            <div class="d-flex justify-content-end align-items-center gap-3 pt-3">
                                <a href="${pageContext.request.contextPath}/positions" class="btn-action-light text-decoration-none">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn-action-primary border-0">
                                    <i class="bi bi-check2-circle"></i>
                                    ${empty position or empty position.id or position.id == 0 ? 'Tạo chức vụ' : 'Lưu thay đổi'}
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
