<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý hợp đồng lao động — MIXIMOI HRM &amp; PAYROLL</title>
    <meta name="description" content="Quản lý hợp đồng lao động, theo dõi thời hạn, loại hình hợp đồng và cảnh báo tự động MIXIMOI HRM">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <!-- External Contract Module Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/contract.css">
</head>
<body>

<div class="app-container">
    <c:set var="activeMenu" value="contracts" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <%-- ============================================================
                 EMPLOYEE ROLE: Chỉ xem hợp đồng cá nhân
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">

                <!-- Emp Banner -->
                <div class="emp-contract-banner">
                    <div class="emp-contract-banner-icon"><i class="bi bi-person-lines-fill"></i></div>
                    <div>
                        <h1 style="font-size:1.25rem; font-weight:800; color:#0f172a; margin-bottom:4px;">
                            Hợp đồng lao động của tôi
                        </h1>
                        <p style="font-size:0.84rem; color:#475569; margin:0;">
                            Xem thông tin hợp đồng và điều khoản làm việc cá nhân của bạn
                        </p>
                    </div>
                </div>

                <!-- Contracts Table (read-only for employee) -->
                <div class="contract-table-card">
                    <div class="table-responsive">
                        <table class="contract-table">
                            <thead>
                                <tr>
                                    <th style="padding-left:1.25rem;">Số HĐ</th>
                                    <th>Loại hợp đồng</th>
                                    <th>Thời hạn HĐ</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th style="padding-right:1.25rem;">Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty contracts}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-5">
                                                <i class="bi bi-file-earmark-text" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i>
                                                <div style="font-weight:600; font-size:0.95rem; color:#64748b;">Chưa có hợp đồng nào</div>
                                                <div style="font-size:0.82rem; margin-top:4px;">Vui lòng liên hệ phòng nhân sự để được hỗ trợ</div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="c" items="${contracts}">
                                            <tr class="${c.status eq 'EXPIRING_SOON' ? 'row-expiring' : c.status eq 'EXPIRED' ? 'row-expired' : ''}">
                                                <td style="padding-left:1.25rem;">
                                                    <span class="contract-code-badge">${c.contractCode}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.contractType eq 'INDEFINITE'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle">Không xác định thời hạn</span></c:when>
                                                        <c:when test="${c.contractType eq 'FIXED_TERM'}"><span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">Xác định thời hạn</span></c:when>
                                                        <c:when test="${c.contractType eq 'SEASONAL'}"><span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">Thời vụ</span></c:when>
                                                        <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Cộng tác viên</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="deadline-box">
                                                        <div class="deadline-date">${c.startDate} → ${c.endDate != null ? c.endDate : 'Vô thời hạn'}</div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${c.status eq 'ACTIVE'}"><span class="status-pill active"><i class="bi bi-check-circle-fill"></i> Còn hiệu lực</span></c:when>
                                                        <c:when test="${c.status eq 'EXPIRING_SOON'}"><span class="status-pill expiring"><i class="bi bi-exclamation-circle-fill"></i> Sắp hết hạn</span></c:when>
                                                        <c:otherwise><span class="status-pill expired"><i class="bi bi-x-circle-fill"></i> Hết hạn</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding-right:1.25rem;">
                                                    <span class="text-muted" style="font-size:0.82rem;">${not empty c.notes ? c.notes : '—'}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </c:if>

            <%-- ============================================================
                 MANAGER ROLE: Xem HĐ nhân viên phòng ban mình (read-only)
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">

                <!-- Page Header -->
                <div class="page-header-section">
                    <div>
                        <h1 style="font-size:1.4rem; font-weight:800; color:#0f172a; margin-bottom:4px;">
                            Hợp đồng lao động
                            <span class="page-header-badge"><i class="bi bi-file-earmark-text"></i> ${contracts.size()} hợp đồng</span>
                        </h1>
                        <p style="font-size:0.83rem; color:#64748b; margin:0;">Xem hợp đồng nhân viên trong phòng ban của bạn</p>
                    </div>
                </div>

                <!-- Filter Card -->
                <div class="filter-card">
                    <form method="get" action="${pageContext.request.contextPath}/contracts">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-5">
                                <div class="filter-search-wrap">
                                    <i class="bi bi-search"></i>
                                    <input type="text" name="keyword" placeholder="Tìm theo số HĐ, tên nhân viên..." value="${keyword}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select filter-select" name="contractType">
                                    <option value="">Tất cả loại HĐ</option>
                                    <option value="INDEFINITE" ${contractType eq 'INDEFINITE' ? 'selected' : ''}>Không xác định TH</option>
                                    <option value="FIXED_TERM" ${contractType eq 'FIXED_TERM' ? 'selected' : ''}>Xác định thời hạn</option>
                                    <option value="SEASONAL" ${contractType eq 'SEASONAL' ? 'selected' : ''}>Thời vụ</option>
                                    <option value="COLLABORATOR" ${contractType eq 'COLLABORATOR' ? 'selected' : ''}>Cộng tác viên</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="status">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="ACTIVE" ${status eq 'ACTIVE' ? 'selected' : ''}>Còn hiệu lực</option>
                                    <option value="EXPIRING_SOON" ${status eq 'EXPIRING_SOON' ? 'selected' : ''}>Sắp hết hạn</option>
                                    <option value="EXPIRED" ${status eq 'EXPIRED' ? 'selected' : ''}>Đã hết hạn</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex gap-2">
                                <button type="submit" class="btn-filter-primary flex-fill justify-content-center"><i class="bi bi-funnel-fill"></i> Lọc</button>
                                <a href="${pageContext.request.contextPath}/contracts" class="btn-filter-reset" title="Đặt lại"><i class="bi bi-arrow-counterclockwise"></i></a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Table (Manager: read-only, no salary) -->
                <div class="contract-table-card">
                    <div class="table-responsive">
                        <table class="contract-table">
                            <thead>
                                <tr>
                                    <th style="padding-left:1.25rem;">Số HĐ</th>
                                    <th>Nhân viên</th>
                                    <th>Loại hợp đồng</th>
                                    <th>Thời hạn HĐ</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th style="padding-right:1.25rem; text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty contracts}">
                                        <tr><td colspan="6" class="text-center text-muted py-5"><i class="bi bi-inbox" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i><div style="font-weight:600; color:#64748b;">Không có hợp đồng phù hợp</div></td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="c" items="${contracts}">
                                            <tr class="${c.status eq 'EXPIRING_SOON' ? 'row-expiring' : c.status eq 'EXPIRED' ? 'row-expired' : ''}">
                                                <td style="padding-left:1.25rem;"><span class="contract-code-badge">${c.contractCode}</span></td>
                                                <td>
                                                    <div class="emp-cell">
                                                        <div class="emp-avatar gen-n">${c.employeeName != null ? c.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                                        <div><div class="emp-name">${c.employeeName}</div><div class="emp-code">${c.employeeCode}</div></div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.contractType eq 'INDEFINITE'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle">Không xác định TH</span></c:when>
                                                        <c:when test="${c.contractType eq 'FIXED_TERM'}"><span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">Xác định thời hạn</span></c:when>
                                                        <c:when test="${c.contractType eq 'SEASONAL'}"><span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">Thời vụ</span></c:when>
                                                        <c:otherwise><span class="badge bg-secondary-subtle text-secondary border">Cộng tác viên</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="deadline-box">
                                                        <div class="deadline-date">${c.startDate} → ${c.endDate != null ? c.endDate : 'Vô thời hạn'}</div>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${c.status eq 'ACTIVE'}"><span class="status-pill active"><i class="bi bi-check-circle-fill"></i> Còn hiệu lực</span></c:when>
                                                        <c:when test="${c.status eq 'EXPIRING_SOON'}"><span class="status-pill expiring"><i class="bi bi-exclamation-circle-fill"></i> Sắp hết hạn</span></c:when>
                                                        <c:otherwise><span class="status-pill expired"><i class="bi bi-x-circle-fill"></i> Hết hạn</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding-right:1.25rem; text-align:center;">
                                                    <div class="action-btn-group justify-content-center">
                                                        <a href="${pageContext.request.contextPath}/contracts?action=view&id=${c.id}" class="action-btn" title="Xem chi tiết"><i class="bi bi-eye"></i></a>
                                                        <a href="${pageContext.request.contextPath}/contracts?action=print&id=${c.id}" class="action-btn print" title="In hợp đồng"><i class="bi bi-printer"></i></a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${not empty contracts}">
                        <div class="table-footer-bar">
                            <span class="text-muted">Hiển thị <strong>${contracts.size()}</strong> trên tổng số <strong>${totalContracts}</strong> hợp đồng</span>
                            <div class="pagination-row">
                                <a href="#" class="page-btn"><i class="bi bi-chevron-left" style="font-size:0.7rem;"></i></a>
                                <a href="#" class="page-btn active">1</a>
                                <a href="#" class="page-btn"><i class="bi bi-chevron-right" style="font-size:0.7rem;"></i></a>
                            </div>
                        </div>
                    </c:if>
                </div>

            </c:if>

            <%-- ============================================================
                 ACCOUNTANT ROLE: Xem danh sách + mức lương (read-only)
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.accountant and not sessionScope.currentUser.admin}">

                <!-- Page Header -->
                <div class="page-header-section">
                    <div>
                        <h1 style="font-size:1.4rem; font-weight:800; color:#0f172a; margin-bottom:4px;">
                            Hợp đồng lao động
                            <span class="page-header-badge"><i class="bi bi-file-earmark-text"></i> ${contracts.size()} hợp đồng</span>
                        </h1>
                        <p style="font-size:0.83rem; color:#64748b; margin:0;">Xem thông tin mức lương hợp đồng phục vụ tính lương</p>
                    </div>
                    <div class="action-bar">
                        <a href="${pageContext.request.contextPath}/contracts?action=export" class="btn-action-outline">
                            <i class="bi bi-file-earmark-excel text-success"></i> Xuất báo cáo
                        </a>
                    </div>
                </div>

                <!-- Filter Card -->
                <div class="filter-card">
                    <form method="get" action="${pageContext.request.contextPath}/contracts">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-4">
                                <div class="filter-search-wrap">
                                    <i class="bi bi-search"></i>
                                    <input type="text" name="keyword" placeholder="Tìm theo số HĐ, tên nhân viên, mã NV..." value="${keyword}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="contractType">
                                    <option value="">Tất cả loại HĐ</option>
                                    <option value="INDEFINITE" ${contractType eq 'INDEFINITE' ? 'selected' : ''}>Không xác định TH</option>
                                    <option value="FIXED_TERM" ${contractType eq 'FIXED_TERM' ? 'selected' : ''}>Xác định thời hạn</option>
                                    <option value="SEASONAL" ${contractType eq 'SEASONAL' ? 'selected' : ''}>Thời vụ</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="status">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="ACTIVE" ${status eq 'ACTIVE' ? 'selected' : ''}>Còn hiệu lực</option>
                                    <option value="EXPIRING_SOON" ${status eq 'EXPIRING_SOON' ? 'selected' : ''}>Sắp hết hạn</option>
                                    <option value="EXPIRED" ${status eq 'EXPIRED' ? 'selected' : ''}>Đã hết hạn</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="departmentId">
                                    <option value="">Tất cả phòng ban</option>
                                    <c:forEach var="dept" items="${departments}">
                                        <option value="${dept.id}" ${departmentId == dept.id ? 'selected' : ''}>${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex gap-2">
                                <button type="submit" class="btn-filter-primary flex-fill justify-content-center"><i class="bi bi-funnel-fill"></i> Lọc</button>
                                <a href="${pageContext.request.contextPath}/contracts" class="btn-filter-reset"><i class="bi bi-arrow-counterclockwise"></i></a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Table (Accountant: show salary, read-only) -->
                <div class="contract-table-card">
                    <div class="table-responsive">
                        <table class="contract-table">
                            <thead>
                                <tr>
                                    <th style="padding-left:1.25rem;">Số HĐ</th>
                                    <th>Nhân viên</th>
                                    <th>Loại hợp đồng</th>
                                    <th>Thời hạn HĐ</th>
                                    <th class="text-end">Mức lương HĐ</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th style="padding-right:1.25rem; text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty contracts}">
                                        <tr><td colspan="7" class="text-center text-muted py-5"><i class="bi bi-inbox" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i><div style="font-weight:600; color:#64748b;">Không có dữ liệu</div></td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="c" items="${contracts}">
                                            <tr class="${c.status eq 'EXPIRING_SOON' ? 'row-expiring' : c.status eq 'EXPIRED' ? 'row-expired' : ''}">
                                                <td style="padding-left:1.25rem;"><span class="contract-code-badge">${c.contractCode}</span></td>
                                                <td>
                                                    <div class="emp-cell">
                                                        <div class="emp-avatar gen-n">${c.employeeName != null ? c.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                                        <div><div class="emp-name">${c.employeeName}</div><div class="emp-code">${c.employeeCode}</div></div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.contractType eq 'INDEFINITE'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle">Không xác định TH</span></c:when>
                                                        <c:when test="${c.contractType eq 'FIXED_TERM'}"><span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">Xác định thời hạn</span></c:when>
                                                        <c:when test="${c.contractType eq 'SEASONAL'}"><span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">Thời vụ</span></c:when>
                                                        <c:otherwise><span class="badge bg-secondary-subtle text-secondary border">Cộng tác viên</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="deadline-box">
                                                        <div class="deadline-date">${c.startDate} → ${c.endDate != null ? c.endDate : 'Vô thời hạn'}</div>
                                                    </div>
                                                </td>
                                                <td class="text-end">
                                                    <span class="salary-display">
                                                        <fmt:formatNumber value="${c.baseSalary}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${c.status eq 'ACTIVE'}"><span class="status-pill active"><i class="bi bi-check-circle-fill"></i> Còn hiệu lực</span></c:when>
                                                        <c:when test="${c.status eq 'EXPIRING_SOON'}"><span class="status-pill expiring"><i class="bi bi-exclamation-circle-fill"></i> Sắp hết hạn</span></c:when>
                                                        <c:otherwise><span class="status-pill expired"><i class="bi bi-x-circle-fill"></i> Hết hạn</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding-right:1.25rem; text-align:center;">
                                                    <div class="action-btn-group justify-content-center">
                                                        <a href="${pageContext.request.contextPath}/contracts?action=view&id=${c.id}" class="action-btn" title="Xem chi tiết"><i class="bi bi-eye"></i></a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${not empty contracts}">
                        <div class="table-footer-bar">
                            <span class="text-muted">
                                Hiển thị <strong style="color:#1e293b;">${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalFiltered ? totalFiltered : currentPage * pageSize}</strong>
                                trên tổng số <strong style="color:#1e293b;">${totalFiltered}</strong> hợp đồng
                            </span>
                            <c:if test="${totalPages > 1}">
                                <div class="pagination-row">
                                    <a href="${pageContext.request.contextPath}/contracts?page=${currentPage - 1}&keyword=${keyword}&contractType=${contractType}&status=${status}&departmentId=${departmentId}"
                                       class="page-btn ${currentPage <= 1 ? 'disabled' : ''}">
                                        <i class="bi bi-chevron-left" style="font-size:0.7rem;"></i>
                                    </a>
                                    <c:forEach begin="1" end="${totalPages}" var="pg">
                                        <a href="${pageContext.request.contextPath}/contracts?page=${pg}&keyword=${keyword}&contractType=${contractType}&status=${status}&departmentId=${departmentId}"
                                           class="page-btn ${pg == currentPage ? 'active' : ''}">${pg}</a>
                                    </c:forEach>
                                    <a href="${pageContext.request.contextPath}/contracts?page=${currentPage + 1}&keyword=${keyword}&contractType=${contractType}&status=${status}&departmentId=${departmentId}"
                                       class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <i class="bi bi-chevron-right" style="font-size:0.7rem;"></i>
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </div>

            </c:if>

            <%-- ============================================================
                 ADMIN / HR ROLE: Toàn quyền quản lý hợp đồng
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">

                <!-- Alerts -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                        <i class="bi bi-check-circle-fill me-2 text-success"></i>
                        <c:choose>
                            <c:when test="${param.success eq 'added'}">Thêm hợp đồng lao động mới thành công!</c:when>
                            <c:when test="${param.success eq 'updated'}">Cập nhật hợp đồng thành công!</c:when>
                            <c:when test="${param.success eq 'deleted'}">Đã xóa hợp đồng thành công.</c:when>
                            <c:when test="${param.success eq 'signed'}">Đã ký chính thức hợp đồng thành công!</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Page Header -->
                <div class="page-header-section">
                    <div>
                        <h1 style="font-size:1.4rem; font-weight:800; color:#0f172a; margin-bottom:4px;">
                            Quản lý hợp đồng lao động
                            <span class="page-header-badge"><i class="bi bi-file-earmark-text"></i> ${totalContracts} hợp đồng</span>
                        </h1>
                        <p style="font-size:0.83rem; color:#64748b; margin:0;">
                            Theo dõi thời hạn, phụ lục, loại hình hợp đồng và cảnh báo gia hạn hợp đồng tự động
                        </p>
                    </div>
                    <div class="action-bar">
                        <a href="${pageContext.request.contextPath}/contracts?action=export" class="btn-action-outline">
                            <i class="bi bi-file-earmark-excel text-success"></i> Xuất báo cáo HĐ
                        </a>
                        <c:if test="${expiringCount > 0}">
                            <button type="button" class="btn-danger-outline" data-bs-toggle="modal" data-bs-target="#expiringModal">
                                <i class="bi bi-exclamation-triangle-fill"></i> Cảnh báo hết hạn (${expiringCount})
                            </button>
                        </c:if>
                        <button type="button" class="btn-add-contract" data-bs-toggle="modal" data-bs-target="#newContractModal">
                            <i class="bi bi-file-earmark-plus-fill"></i> + Tạo hợp đồng mới
                        </button>
                    </div>
                </div>

                <!-- Stats Grid -->
                <div class="contract-stats-grid">
                    <div class="contract-stat-card">
                        <div class="cstat-icon blue"><i class="bi bi-file-earmark-check-fill"></i></div>
                        <div>
                            <div class="cstat-label">HĐ Hiệu lực</div>
                            <div class="cstat-value">${activeCount}</div>
                            <div class="cstat-meta"><span style="color:#059669; font-weight:700;">${totalContracts > 0 ? activeCount * 100 / totalContracts : 0}%</span> nhân sự chính thức toàn công ty</div>
                        </div>
                    </div>
                    <div class="contract-stat-card">
                        <div class="cstat-icon violet"><i class="bi bi-infinity"></i></div>
                        <div>
                            <div class="cstat-label">Không xác định TH</div>
                            <div class="cstat-value">${indefiniteCount}</div>
                            <div class="cstat-meta">⟷ Thời hạn vô thời hạn (Lâu năm)</div>
                        </div>
                    </div>
                    <div class="contract-stat-card">
                        <div class="cstat-icon cyan"><i class="bi bi-calendar-range-fill"></i></div>
                        <div>
                            <div class="cstat-label">Có xác định TH</div>
                            <div class="cstat-value">${fixedCount}</div>
                            <div class="cstat-meta">📅 Thời hạn từ 1 đến 3 năm</div>
                        </div>
                    </div>
                    <div class="contract-stat-card ${expiringCount > 0 ? 'expiring-alert' : ''}">
                        <div class="cstat-icon amber"><i class="bi bi-clock-history"></i></div>
                        <div>
                            <div class="cstat-label">Sắp hết hạn 30 ngày</div>
                            <div class="cstat-value">${expiringCount}</div>
                            <div class="cstat-meta">
                                <c:if test="${expiringCount > 0}"><span style="color:#dc2626; font-weight:600;">● Cần chuẩn bị gia hạn / chuyển đổi</span></c:if>
                                <c:if test="${expiringCount == 0}"><span style="color:#059669;">✓ Không có HĐ sắp hết hạn</span></c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Notification Bar (Auto-notify) -->
                <div class="notify-bar">
                    <div class="d-flex align-items-center gap-3">
                        <div class="notify-icon"><i class="bi bi-robot"></i></div>
                        <span>
                            <i class="bi bi-stars text-warning me-1"></i>
                            <strong>Hệ thống tự động thông báo:</strong>
                            Đã gửi <strong>${expiringCount}</strong> cảnh báo hợp đồng lao động đến quản lý trực tiếp và từng viên qua Email &amp; Zalo ZNS trước 30 ngày.
                        </span>
                    </div>
                    <a href="#" class="text-primary fw-semibold text-decoration-none" style="font-size:0.8rem; white-space:nowrap;">Xem quy định tự động →</a>
                </div>

                <!-- Filter Card -->
                <div class="filter-card">
                    <form method="get" action="${pageContext.request.contextPath}/contracts">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-4">
                                <div class="filter-search-wrap">
                                    <i class="bi bi-search"></i>
                                    <input type="text" name="keyword" id="contractSearch"
                                           placeholder="Tìm theo số HĐ, tên nhân viên, mã NV..."
                                           value="${keyword}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="contractType" id="filterType">
                                    <option value="">Tất cả loại HĐ</option>
                                    <option value="INDEFINITE" ${contractType eq 'INDEFINITE' ? 'selected' : ''}>Không xác định TH</option>
                                    <option value="FIXED_TERM" ${contractType eq 'FIXED_TERM' ? 'selected' : ''}>Xác định thời hạn</option>
                                    <option value="SEASONAL" ${contractType eq 'SEASONAL' ? 'selected' : ''}>Thời vụ</option>
                                    <option value="COLLABORATOR" ${contractType eq 'COLLABORATOR' ? 'selected' : ''}>Cộng tác viên</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="status" id="filterStatus">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="ACTIVE" ${status eq 'ACTIVE' ? 'selected' : ''}>Còn hiệu lực</option>
                                    <option value="EXPIRING_SOON" ${status eq 'EXPIRING_SOON' ? 'selected' : ''}>Sắp hết hạn</option>
                                    <option value="EXPIRED" ${status eq 'EXPIRED' ? 'selected' : ''}>Đã hết hạn</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="departmentId" id="filterDept">
                                    <option value="">Tất cả phòng ban</option>
                                    <c:forEach var="dept" items="${departments}">
                                        <option value="${dept.id}" ${departmentId == dept.id ? 'selected' : ''}>${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex gap-2">
                                <button type="submit" class="btn-filter-primary flex-fill justify-content-center" id="btnFilter">
                                    <i class="bi bi-funnel-fill"></i> Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/contracts" class="btn-filter-reset" title="Đặt lại bộ lọc" id="btnReset">
                                    <i class="bi bi-arrow-counterclockwise"></i> Đặt lại
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Bulk Action Toolbar -->
                <div id="bulkToolbar" class="d-none align-items-center gap-2 mb-2 px-1 py-2"
                     style="background:linear-gradient(90deg,#eff6ff,#f0fdf4);border-radius:10px;border:1px solid #bfdbfe;flex-wrap:wrap;">
                    <span style="font-size:0.83rem;color:#1e40af;font-weight:700;">
                        <i class="bi bi-check2-square me-1"></i>
                        Đã chọn <strong id="bulkCount">0</strong> hợp đồng
                    </span>
                    <div class="d-flex gap-2 ms-auto">
                        <button type="button" class="btn btn-sm btn-danger px-3" onclick="bulkDelete()"
                                style="border-radius:8px;font-weight:600;font-size:0.8rem;">
                            <i class="bi bi-trash me-1"></i> Xóa hàng loạt
                        </button>
                        <button type="button" class="btn btn-sm btn-success px-3" onclick="bulkExport()"
                                style="border-radius:8px;font-weight:600;font-size:0.8rem;">
                            <i class="bi bi-file-earmark-excel me-1"></i> Xuất danh sách chọn
                        </button>
                        <button type="button" class="btn btn-sm btn-light px-3" onclick="clearContractSelection()"
                                style="border-radius:8px;font-size:0.8rem;">
                            <i class="bi bi-x-lg me-1"></i> Bỏ chọn
                        </button>
                    </div>
                </div>

                <!-- Contracts Table (Full management) -->
                <div class="contract-table-card">
                    <div class="table-responsive">
                        <table class="contract-table" id="contractTable">
                            <thead>
                                <tr>
                                    <th style="width:42px; padding-left:1.25rem;">
                                        <input type="checkbox" id="checkAll" class="form-check-input" style="width:15px;height:15px;">
                                    </th>
                                    <th>Số HĐ</th>
                                    <th>Nhân viên</th>
                                    <th>Loại hợp đồng</th>
                                    <th>Thời hạn HĐ</th>
                                    <th class="text-end">Mức lương HĐ</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">File</th>
                                    <th style="padding-right:1.25rem; text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty contracts}">
                                        <tr id="emptyRow">
                                            <td colspan="9" class="text-center text-muted py-5">
                                                <i class="bi bi-file-earmark-text" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i>
                                                <div style="font-weight:600; font-size:0.95rem; color:#64748b;">Chưa có hợp đồng nào trong hệ thống</div>
                                                <div style="font-size:0.82rem; margin-top:4px;">
                                                    <a href="#" class="text-primary" data-bs-toggle="modal" data-bs-target="#newContractModal">Tạo hợp đồng đầu tiên →</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="c" items="${contracts}">
                                            <tr class="contract-row ${c.status eq 'EXPIRING_SOON' ? 'row-expiring' : c.status eq 'EXPIRED' ? 'row-expired' : ''}"
                                                data-keyword="${fn:toLowerCase(c.contractCode)} ${fn:toLowerCase(c.employeeName)} ${fn:toLowerCase(c.employeeCode)}"
                                                data-type="${c.contractType}"
                                                data-status="${c.status}"
                                                data-dept="${not empty c.departmentName ? fn:toLowerCase(c.departmentName) : ''}"
                                                data-id="${c.id}">
                                                <td style="padding-left:1.25rem;">
                                                    <input type="checkbox" class="form-check-input row-check" value="${c.id}" style="width:15px;height:15px;">
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/contracts?action=view&id=${c.id}" class="contract-code-badge">${c.contractCode}</a>
                                                </td>
                                                <td>
                                                    <div class="emp-cell">
                                                        <div class="emp-avatar gen-n">${c.employeeName != null ? c.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                                        <div>
                                                            <div class="emp-name">${c.employeeName}</div>
                                                            <div class="emp-code">${c.employeeCode} · ${c.departmentName}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.contractType eq 'INDEFINITE'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle">Không xác định thời hạn</span></c:when>
                                                        <c:when test="${c.contractType eq 'FIXED_TERM'}"><span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">Xác định thời hạn</span></c:when>
                                                        <c:when test="${c.contractType eq 'SEASONAL'}"><span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">Thời vụ</span></c:when>
                                                        <c:otherwise><span class="badge bg-secondary-subtle text-secondary border">Cộng tác viên</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="deadline-box">
                                                        <div class="deadline-date">
                                                            ${c.startDate}
                                                            <span style="color:#94a3b8;"> → </span>
                                                            ${c.endDate != null ? c.endDate : 'Vô thời hạn'}
                                                        </div>
                                                        <c:if test="${not empty c.daysRemaining}">
                                                            <div class="deadline-remaining ${c.daysRemaining < 30 ? 'danger' : c.daysRemaining < 90 ? 'warning' : 'ok'}">
                                                                Còn ${c.daysRemaining} ngày
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td class="text-end">
                                                    <span class="salary-display">
                                                        <fmt:formatNumber value="${c.baseSalary}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${c.status eq 'ACTIVE'}"><span class="status-pill active"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Còn hiệu lực</span></c:when>
                                                        <c:when test="${c.status eq 'EXPIRING_SOON'}"><span class="status-pill expiring"><i class="bi bi-exclamation-circle-fill"></i> Sắp hết hạn</span></c:when>
                                                        <c:when test="${c.status eq 'TERMINATED'}"><span class="status-pill terminated"><i class="bi bi-dash-circle-fill"></i> Đã thanh lý</span></c:when>
                                                        <c:otherwise><span class="status-pill expired"><i class="bi bi-x-circle-fill"></i> Hết hạn</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${not empty c.fileUrl}">
                                                            <a href="${c.fileUrl}" class="action-btn" title="Tải file HĐ" style="color:#dc2626; border-color:#fca5a5; background:#fef2f2;">
                                                                <i class="bi bi-file-pdf"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted" style="font-size:0.8rem;">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding-right:1.25rem; text-align:center;">
                                                    <div class="action-btn-group justify-content-center">
                                                        <a href="${pageContext.request.contextPath}/contracts?action=view&id=${c.id}" class="action-btn" title="Xem chi tiết"><i class="bi bi-eye"></i></a>
                                                        <button type="button" class="action-btn edit" title="Chỉnh sửa"
                                                                data-id="${c.id}"
                                                                data-code="${c.contractCode}"
                                                                data-empid="${c.employeeId}"
                                                                data-type="${c.contractType}"
                                                                data-start="${c.startDate}"
                                                                data-end="${c.endDate}"
                                                                data-salary="${c.baseSalary}"
                                                                data-status="${c.status}"
                                                                data-notes="<c:out value='${c.notes}'/>"
                                                                onclick="openEditContractModal(this)">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                        <a href="${pageContext.request.contextPath}/contracts?action=print&id=${c.id}" class="action-btn print" title="In hợp đồng"><i class="bi bi-printer"></i></a>
                                                        <c:if test="${sessionScope.currentUser.admin}">
                                                            <button type="button" class="action-btn del"
                                                                    title="Xóa hợp đồng"
                                                                    data-id="${c.id}"
                                                                    data-code="${c.contractCode}"
                                                                    onclick="confirmDeleteContract(this)">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Table Footer -->
                    <c:if test="${not empty contracts}">
                        <div class="table-footer-bar">
                            <span class="text-muted">
                                Hiển thị <strong style="color:#1e293b;">${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalFiltered ? totalFiltered : currentPage * pageSize}</strong>
                                trên tổng số <strong style="color:#1e293b;">${totalFiltered}</strong> hợp đồng lao động
                            </span>
                            <c:if test="${totalPages > 1}">
                                <div class="pagination-row">
                                    <a href="${pageContext.request.contextPath}/contracts?page=${currentPage - 1}&keyword=${keyword}&contractType=${contractType}&status=${status}&departmentId=${departmentId}"
                                       class="page-btn ${currentPage <= 1 ? 'disabled' : ''}">
                                        <i class="bi bi-chevron-left" style="font-size:0.7rem;"></i>
                                    </a>
                                    <c:forEach begin="1" end="${totalPages}" var="pg">
                                        <a href="${pageContext.request.contextPath}/contracts?page=${pg}&keyword=${keyword}&contractType=${contractType}&status=${status}&departmentId=${departmentId}"
                                           class="page-btn ${pg == currentPage ? 'active' : ''}">${pg}</a>
                                    </c:forEach>
                                    <a href="${pageContext.request.contextPath}/contracts?page=${currentPage + 1}&keyword=${keyword}&contractType=${contractType}&status=${status}&departmentId=${departmentId}"
                                       class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <i class="bi bi-chevron-right" style="font-size:0.7rem;"></i>
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </div>

            </c:if>
            <%-- end Admin/HR block --%>

        </div><!-- end app-content -->
    </main>
</div>

<%-- ============================================================
     MODAL: Tạo hợp đồng mới (Admin/HR only)
     ============================================================ --%>
<c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
<div class="modal fade" id="newContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/contracts" class="needs-validation" novalidate id="contractForm">
                <input type="hidden" name="action" value="add">

                <div class="modal-header border-0" style="background: linear-gradient(135deg, #eff6ff, #f0fdf4); padding:1.25rem 1.5rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-file-earmark-plus-fill text-primary" style="font-size:1.1rem;"></i>
                            Tạo hợp đồng lao động mới
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Điền đầy đủ thông tin hợp đồng và điều khoản làm việc</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Số hợp đồng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="contractCode" required
                                   placeholder="VD: HĐ-2026-001" style="border-radius:9px; font-size:0.875rem; font-family:monospace;">
                            <div class="invalid-feedback">Vui lòng nhập số hợp đồng</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Nhân viên ký kết <span class="text-danger">*</span></label>
                            <select class="form-select" name="employeeId" required style="border-radius:9px; font-size:0.875rem;">
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn nhân viên</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Loại hợp đồng <span class="text-danger">*</span></label>
                            <select class="form-select" name="contractType" required id="contractTypeSelect" style="border-radius:9px; font-size:0.875rem;" onchange="toggleEndDate(this.value)">
                                <option value="INDEFINITE">Không xác định thời hạn</option>
                                <option value="FIXED_TERM">Xác định thời hạn (1 - 3 năm)</option>
                                <option value="SEASONAL">Hợp đồng thời vụ</option>
                                <option value="COLLABORATOR">Hợp đồng cộng tác viên</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Mức lương cơ bản (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="baseSalary" required
                                   placeholder="VD: 15000000" min="0" step="500000" style="border-radius:9px; font-size:0.875rem;">
                            <div class="invalid-feedback">Vui lòng nhập mức lương</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ngày bắt đầu hiệu lực <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="startDate" required style="border-radius:9px; font-size:0.875rem;">
                            <div class="invalid-feedback">Vui lòng chọn ngày bắt đầu</div>
                        </div>
                        <div class="col-md-6" id="endDateGroup">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ngày kết thúc</label>
                            <input type="date" class="form-control" name="endDate" style="border-radius:9px; font-size:0.875rem;">
                            <small class="text-muted" style="font-size:0.75rem;">Để trống nếu không xác định thời hạn</small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Trạng thái hợp đồng</label>
                            <select class="form-select" name="status" style="border-radius:9px; font-size:0.875rem;">
                                <option value="ACTIVE">Đang có hiệu lực</option>
                                <option value="EXPIRING_SOON">Sắp hết hạn</option>
                                <option value="EXPIRED">Đã hết hạn</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">File hợp đồng (PDF)</label>
                            <input type="file" class="form-control" name="contractFile" accept=".pdf,.doc,.docx" style="border-radius:9px; font-size:0.875rem;">
                            <small class="text-muted" style="font-size:0.75rem;">Hỗ trợ PDF, DOC, DOCX. Tối đa 10MB</small>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ghi chú / Điều khoản bổ sung</label>
                            <textarea class="form-control" name="notes" rows="2"
                                      placeholder="Điều khoản phụ lục, phúc lợi đặc biệt, thỏa thuận riêng..."
                                      style="border-radius:9px; font-size:0.875rem;"></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 gap-2" style="background:#f8fafc;">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal" style="border-radius:9px;">Hủy</button>
                    <button type="submit" class="btn btn-primary px-4 fw-semibold" style="border-radius:9px;">
                        <i class="bi bi-check2-circle me-1"></i> Lưu hợp đồng
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Chỉnh sửa HĐ -->
<div class="modal fade" id="editContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/contracts" class="needs-validation" novalidate id="editContractForm">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editContractId">

                <div class="modal-header border-0" style="background: linear-gradient(135deg, #eff6ff, #fefce8); padding:1.25rem 1.5rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-pencil-square text-primary" style="font-size:1.1rem;"></i>
                            Cập nhật hợp đồng lao động
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Chỉnh sửa điều khoản, mức lương hoặc thời hạn hợp đồng</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Số hợp đồng</label>
                            <input type="text" class="form-control" name="contractCode" id="editContractCode" readonly
                                   style="border-radius:9px; font-size:0.875rem; font-family:monospace; background:#f8fafc;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Loại hợp đồng <span class="text-danger">*</span></label>
                            <select class="form-select" name="contractType" required id="editContractTypeSelect" style="border-radius:9px; font-size:0.875rem;" onchange="toggleEndDate(this.value, 'Edit')">
                                <option value="INDEFINITE">Không xác định thời hạn</option>
                                <option value="FIXED_TERM">Xác định thời hạn (1 - 3 năm)</option>
                                <option value="SEASONAL">Hợp đồng thời vụ</option>
                                <option value="COLLABORATOR">Hợp đồng cộng tác viên</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Mức lương cơ bản (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="baseSalary" id="editBaseSalary" required
                                   min="0" step="500000" style="border-radius:9px; font-size:0.875rem;">
                            <div class="invalid-feedback">Vui lòng nhập mức lương</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ngày bắt đầu hiệu lực <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="startDate" id="editStartDate" required style="border-radius:9px; font-size:0.875rem;">
                            <div class="invalid-feedback">Vui lòng chọn ngày bắt đầu</div>
                        </div>
                        <div class="col-md-6" id="endDateGroupEdit">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ngày kết thúc</label>
                            <input type="date" class="form-control" name="endDate" id="editEndDate" style="border-radius:9px; font-size:0.875rem;">
                            <small class="text-muted" style="font-size:0.75rem;">Để trống nếu không xác định thời hạn</small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Trạng thái hợp đồng</label>
                            <select class="form-select" name="status" id="editStatus" style="border-radius:9px; font-size:0.875rem;">
                                <option value="ACTIVE">Đang có hiệu lực</option>
                                <option value="EXPIRING_SOON">Sắp hết hạn</option>
                                <option value="EXPIRED">Đã hết hạn</option>
                                <option value="TERMINATED">Đã thanh lý</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ghi chú / Điều khoản bổ sung</label>
                            <textarea class="form-control" name="notes" id="editNotes" rows="2"
                                      placeholder="Điều khoản phụ lục, phúc lợi đặc biệt, thỏa thuận riêng..."
                                      style="border-radius:9px; font-size:0.875rem;"></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 gap-2" style="background:#f8fafc;">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal" style="border-radius:9px;">Hủy</button>
                    <button type="submit" class="btn btn-primary px-4 fw-semibold" style="border-radius:9px;">
                        <i class="bi bi-check2-circle me-1"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Xóa HĐ -->
<div class="modal fade" id="deleteContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <div class="modal-header border-0" style="background:#fef2f2; padding:1.25rem 1.5rem 0.75rem;">
                <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> Xác nhận xóa hợp đồng
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body px-4 py-3 text-secondary" style="font-size:0.9rem;">
                Bạn có chắc muốn xóa hợp đồng <strong id="deleteContractCode" class="text-dark"></strong>?
                <div class="mt-2 p-2 rounded" style="background:#f8fafc; font-size:0.8rem; color:#64748b;">
                    <i class="bi bi-info-circle me-1"></i>Hành động này không thể hoàn tác. Dữ liệu lịch sử liên quan sẽ bị ảnh hưởng.
                </div>
            </div>
            <div class="modal-footer border-0 px-4 pt-0 pb-4 gap-2">
                <button type="button" class="btn btn-light btn-sm px-3" data-bs-dismiss="modal">Hủy bỏ</button>
                <form method="post" action="${pageContext.request.contextPath}/contracts" id="deleteContractForm" class="d-inline">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteContractId">
                    <button type="submit" class="btn btn-danger btn-sm px-4">
                        <i class="bi bi-trash me-1"></i> Xác nhận xóa
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Cảnh báo hết hạn -->
<c:if test="${expiringCount > 0}">
<div class="modal fade" id="expiringModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-md">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <div class="modal-header border-0" style="background:linear-gradient(135deg,#fffbeb,#fef3c7); padding:1.25rem 1.5rem;">
                <h6 class="modal-title fw-bold text-warning-emphasis d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill text-warning fs-5"></i>
                    Cảnh báo hợp đồng sắp hết hạn
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body px-4 py-3">
                <p class="text-muted mb-3" style="font-size:0.85rem;">
                    Có <strong class="text-danger">${expiringCount}</strong> hợp đồng sắp hết hạn trong 30 ngày tới. Vui lòng gia hạn hoặc chuyển đổi loại hợp đồng kịp thời.
                </p>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/contracts?status=EXPIRING_SOON" class="btn btn-warning btn-sm fw-semibold" style="border-radius:8px;">
                        <i class="bi bi-eye me-1"></i> Xem danh sách sắp hết hạn
                    </a>
                    <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal" style="border-radius:8px;">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</div>
</c:if>

</c:if>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- External Contract Scripts -->
<script src="${pageContext.request.contextPath}/assets/js/contract.js"></script>

</body>
</html>
