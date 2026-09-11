<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ nhân viên: ${employee.fullName} — MIXIMOI HRM & PAYROLL</title>
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

        <!-- Employee Detail Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Quick Actions -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-person-bounding-box text-primary"></i> Chi tiết hồ sơ nhân sự
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employees" class="text-decoration-none">Nhân viên</a></li>
                            <li class="breadcrumb-item active" aria-current="page">${employee.fullName} (${employee.employeeCode})</li>
                        </ol>
                    </nav>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/employees" class="btn-action-light text-decoration-none">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                    <button type="button" class="btn-action-light" onclick="window.print()">
                        <i class="bi bi-printer"></i> In hồ sơ
                    </button>
                    <a href="${pageContext.request.contextPath}/employees?action=edit&id=${employee.id}" class="btn-action-primary text-decoration-none">
                        <i class="bi bi-pencil-square"></i> Chỉnh sửa
                    </a>
                </div>
            </div>

            <!-- Profile Overview Header Card -->
            <div class="profile-header-card">
                <div class="profile-cover"></div>
                <div class="profile-header-body">
                    <div class="profile-avatar-row">
                        <div class="d-flex align-items-end gap-3">
                            <div class="profile-avatar-large">
                                ${employee.fullName.substring(0, 1).toUpperCase()}
                            </div>
                            <div class="mb-1">
                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                    <h4 class="fw-bold text-dark mb-0">${employee.fullName}</h4>
                                    <span class="badge bg-light text-dark border font-monospace px-2 py-1">
                                        ${employee.employeeCode}
                                    </span>
                                </div>
                                <div class="text-muted mt-1" style="font-size: 0.9rem;">
                                    <i class="bi bi-briefcase text-primary me-1"></i> ${employee.positionName} 
                                    <span class="mx-2">•</span> 
                                    <i class="bi bi-building text-info me-1"></i> ${employee.departmentName}
                                </div>
                            </div>
                        </div>

                        <div>
                            <c:choose>
                                <c:when test="${employee.status eq 'ACTIVE'}">
                                    <span class="status-pill active fs-6 px-3 py-2">
                                        <i class="bi bi-check-circle-fill"></i> Đang công tác
                                    </span>
                                </c:when>
                                <c:when test="${employee.status eq 'INACTIVE'}">
                                    <span class="status-pill inactive fs-6 px-3 py-2">
                                        <i class="bi bi-dash-circle-fill"></i> Đã nghỉ việc
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-pill leave fs-6 px-3 py-2">
                                        <i class="bi bi-pause-circle-fill"></i> Nghỉ tạm
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Detailed Tabs/Sections -->
            <div class="row g-4">
                <!-- Column 1: Personal Info -->
                <div class="col-lg-6">
                    <div class="app-card">
                        <div class="app-card-header">
                            <div>
                                <h6 class="app-card-title">
                                    <i class="bi bi-person-lines-fill text-primary"></i> Thông tin cá nhân
                                </h6>
                                <p class="app-card-subtitle">Chi tiết hồ sơ liên hệ và cư trú</p>
                            </div>
                        </div>

                        <div class="detail-info-row">
                            <span class="detail-info-label">Mã định danh hệ thống</span>
                            <span class="detail-info-value font-monospace">EMP-#${employee.id}</span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Giới tính</span>
                            <span class="detail-info-value">
                                <c:choose>
                                    <c:when test="${employee.gender eq 'MALE'}">Nam</c:when>
                                    <c:when test="${employee.gender eq 'FEMALE'}">Nữ</c:when>
                                    <c:otherwise>Khác</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Ngày sinh</span>
                            <span class="detail-info-value">${employee.dateOfBirth != null ? employee.dateOfBirth : 'Chưa cập nhật'}</span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Số điện thoại</span>
                            <span class="detail-info-value">
                                <a href="tel:${employee.phone}" class="text-decoration-none text-primary">
                                    <i class="bi bi-telephone-outbound me-1"></i> ${employee.phone}
                                </a>
                            </span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Email làm việc</span>
                            <span class="detail-info-value">
                                <a href="mailto:${employee.email}" class="text-decoration-none text-primary">
                                    <i class="bi bi-envelope me-1"></i> ${employee.email}
                                </a>
                            </span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Địa chỉ liên hệ</span>
                            <span class="detail-info-value">${employee.address != null ? employee.address : 'Chưa cập nhật'}</span>
                        </div>
                    </div>
                </div>

                <!-- Column 2: Job & Organization -->
                <div class="col-lg-6">
                    <div class="app-card">
                        <div class="app-card-header">
                            <div>
                                <h6 class="app-card-title">
                                    <i class="bi bi-building-gear text-primary"></i> Vị trí & Công tác
                                </h6>
                                <p class="app-card-subtitle">Thông tin bộ phận và phân công công việc</p>
                            </div>
                        </div>

                        <div class="detail-info-row">
                            <span class="detail-info-label">Phòng ban</span>
                            <span class="detail-info-value">
                                <span class="badge bg-primary-subtle text-primary border px-2 py-1">
                                    ${employee.departmentName}
                                </span>
                            </span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Chức danh / Chức vụ</span>
                            <span class="detail-info-value fw-bold text-dark">${employee.positionName}</span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Loại nhân sự</span>
                            <span class="detail-info-value">
                                <c:choose>
                                    <c:when test="${employee.employeeTypeId == 1}">Nhân viên chính thức</c:when>
                                    <c:when test="${employee.employeeTypeId == 2}">Nhân viên thử việc</c:when>
                                    <c:when test="${employee.employeeTypeId == 3}">Nhân viên thời vụ</c:when>
                                    <c:otherwise>Cộng tác viên</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Ngày vào công ty</span>
                            <span class="detail-info-value">${employee.startDate}</span>
                        </div>
                        <div class="detail-info-row">
                            <span class="detail-info-label">Trạng thái làm việc</span>
                            <span class="detail-info-value">
                                <c:choose>
                                    <c:when test="${employee.status eq 'ACTIVE'}">Đang hoạt động bình thường</c:when>
                                    <c:when test="${employee.status eq 'INACTIVE'}">Đã chấm dứt hợp đồng</c:when>
                                    <c:otherwise>Đang trong kỳ nghỉ tạm</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Danger Zone -->
            <div class="app-card mt-4 border-danger-subtle bg-white">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div>
                        <h6 class="fw-bold text-danger mb-1">
                            <i class="bi bi-shield-exclamation me-1"></i> Tác vụ nguy hiểm
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.83rem">
                            Vô hiệu hóa tài khoản và chuyển trạng thái nhân viên này sang ngừng công tác.
                        </p>
                    </div>
                    <button type="button" class="btn btn-outline-danger btn-sm px-3" onclick="confirmDeactivate()">
                        <i class="bi bi-person-x"></i> Vô hiệu hóa nhân viên
                    </button>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Deactivate Modal -->
<div class="modal fade" id="deactivateModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0">
                <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> Xác nhận vô hiệu hóa
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-3 text-secondary" style="font-size: 0.88rem;">
                Bạn có chắc chắn muốn vô hiệu hóa nhân sự <strong>${employee.fullName}</strong> (${employee.employeeCode})?
            </div>
            <div class="modal-footer border-top-0 pt-0">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/employees">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${employee.id}">
                    <button type="submit" class="btn btn-danger btn-sm px-3">Xác nhận</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    function confirmDeactivate() {
        new bootstrap.Modal(document.getElementById('deactivateModal')).show();
    }
</script>

</body>
</html>
