<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý hợp đồng lao động — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="contracts" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Contract List Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Action -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-file-earmark-text text-primary"></i> Quản lý hợp đồng lao động
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Hợp đồng lao động</li>
                        </ol>
                    </nav>
                </div>
                <button type="button" class="btn-action-primary" data-bs-toggle="modal" data-bs-target="#newContractModal">
                    <i class="bi bi-file-earmark-plus-fill"></i> Tạo hợp đồng mới
                </button>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'added'}">Thêm hợp đồng lao động mới thành công!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Đã xóa hợp đồng thành công.</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${expiringCount > 0}">
                <div class="alert alert-warning border-0 shadow-sm mb-4 d-flex align-items-center justify-content-between" role="alert">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-exclamation-triangle-fill fs-5 text-warning"></i>
                        <span>Hiện có <strong>${expiringCount}</strong> hợp đồng sắp hết hạn trong 30 ngày tới. Vui lòng kiểm tra và tái ký kịp thời!</span>
                    </div>
                </div>
            </c:if>

            <!-- Table Card -->
            <div class="table-custom-container">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Nhân viên ký kết</th>
                                <th>Loại hợp đồng</th>
                                <th>Hiệu lực từ ngày</th>
                                <th>Ngày kết thúc</th>
                                <th class="text-end">Mức lương cơ bản</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty contracts}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-5">
                                            <i class="bi bi-file-earmark-text fs-1 d-block mb-2 text-secondary"></i>
                                            Chưa có hợp đồng nào trong hệ thống.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${contracts}">
                                        <tr>
                                            <td>
                                                <span class="badge bg-light text-dark border font-monospace px-2 py-1">
                                                    ${c.contractCode}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="table-user-cell">
                                                    <div class="table-user-avatar">
                                                        ${c.employeeName != null ? c.employeeName.substring(0, 1).toUpperCase() : 'NV'}
                                                    </div>
                                                    <div>
                                                        <div class="table-user-name">${c.employeeName}</div>
                                                        <div class="table-user-email">${c.employeeCode}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.contractType eq 'INDEFINITE'}">
                                                        <span class="badge bg-primary-subtle text-primary border">Không xác định thời hạn</span>
                                                    </c:when>
                                                    <c:when test="${c.contractType eq 'FIXED_TERM'}">
                                                        <span class="badge bg-info-subtle text-info-emphasis border">Xác định thời hạn</span>
                                                    </c:when>
                                                    <c:when test="${c.contractType eq 'SEASONAL'}">
                                                        <span class="badge bg-warning-subtle text-warning-emphasis border">Thời vụ</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border">Cộng tác viên</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span class="text-dark fw-medium">${c.startDate}</span></td>
                                            <td><span class="text-muted">${c.endDate != null ? c.endDate : 'Vô thời hạn'}</span></td>
                                            <td class="text-end">
                                                <span class="fw-bold text-dark font-monospace">
                                                    <fmt:formatNumber value="${c.baseSalary}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${c.status eq 'ACTIVE'}">
                                                        <span class="status-pill active">
                                                            <i class="bi bi-check-circle-fill"></i> Hiệu lực
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${c.status eq 'EXPIRING_SOON'}">
                                                        <span class="status-pill expiring">
                                                            <i class="bi bi-exclamation-circle-fill"></i> Sắp hết hạn
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill inactive">
                                                            <i class="bi bi-x-circle-fill"></i> Hết hạn
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <form method="post" action="${pageContext.request.contextPath}/contracts" class="d-inline"
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa hợp đồng ${c.contractCode}?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${c.id}">
                                                    <button type="submit" class="btn btn-sm btn-light border text-danger" title="Xóa hợp đồng">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${not empty contracts}">
                    <div class="px-4 py-3 bg-white border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem">
                        <span class="text-muted">Tổng cộng <strong>${contracts.size()}</strong> hợp đồng lao động</span>
                        <div class="text-muted">MIXIMOI Legal Compliance</div>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<!-- Modal tạo hợp đồng mới -->
<div class="modal fade" id="newContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow">
            <form method="post" action="${pageContext.request.contextPath}/contracts" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="add">

                <div class="modal-header">
                    <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-file-earmark-plus-fill text-primary"></i> Tạo hợp đồng lao động mới
                    </h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Mã hợp đồng <span class="required-mark">*</span></label>
                            <input type="text" class="form-control form-control-custom font-monospace" name="contractCode" required placeholder="VD: HD012">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Nhân viên ký kết <span class="required-mark">*</span></label>
                            <select class="form-select form-select-custom" name="employeeId" required>
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Loại hợp đồng <span class="required-mark">*</span></label>
                            <select class="form-select form-select-custom" name="contractType" required>
                                <option value="INDEFINITE">Không xác định thời hạn</option>
                                <option value="FIXED_TERM">Xác định thời hạn (1 - 3 năm)</option>
                                <option value="SEASONAL">Hợp đồng thời vụ</option>
                                <option value="COLLABORATOR">Hợp đồng cộng tác viên</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Mức lương cơ bản (VNĐ) <span class="required-mark">*</span></label>
                            <input type="number" class="form-control form-control-custom" name="baseSalary" required placeholder="VD: 15000000" min="0" step="500000">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Ngày bắt đầu hiệu lực <span class="required-mark">*</span></label>
                            <input type="date" class="form-control form-control-custom" name="startDate" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Ngày kết thúc (nếu có)</label>
                            <input type="date" class="form-control form-control-custom" name="endDate">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Trạng thái hợp đồng</label>
                            <select class="form-select form-select-custom" name="status">
                                <option value="ACTIVE">Đang có hiệu lực (ACTIVE)</option>
                                <option value="EXPIRING_SOON">Sắp hết hạn (EXPIRING_SOON)</option>
                                <option value="EXPIRED">Đã hết hạn (EXPIRED)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Ghi chú bổ sung</label>
                            <input type="text" class="form-control form-control-custom" name="notes" placeholder="Điều khoản phụ lục, phúc lợi...">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary px-3">Lưu hợp đồng</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
