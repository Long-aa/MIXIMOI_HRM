<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý nhân viên — MIXIMOI HRM & PAYROLL</title>
    <meta name="description" content="Danh sách nhân viên MIXIMOI HRM - Quản lý hồ sơ nhân sự, theo dõi chức vụ, phòng ban và phân quyền hệ thống">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/employee-list.css">
</head>
<body>

<div class="app-container">
    <c:set var="activeMenu" value="employees" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Page Header -->
            <div class="page-header-section">
                <div>
                    <h1 style="font-size:1.4rem; font-weight:800; color:#0f172a; margin-bottom:4px;">
                        Quản lý nhân viên
                        <span class="page-header-badge">
                            <i class="bi bi-person-fill"></i> ${statsTotal} hồ sơ
                        </span>
                    </h1>
                    <p style="font-size:0.83rem; color:#64748b; margin:0;">
                        Quản lý danh mục nhân sự, theo dõi chức vụ, phòng ban và phân quyền hệ thống
                        <strong style="color:#2563eb;">MIXIMOI HRM & PAYROLL</strong>
                    </p>
                </div>
                <div class="action-bar">
                    <a href="${pageContext.request.contextPath}/employees?action=export${not empty keyword ? '&keyword=' : ''}${keyword}${not empty departmentId ? '&departmentId=' : ''}${departmentId}${not empty positionId ? '&positionId=' : ''}${positionId}${not empty status ? '&status=' : ''}${status}" class="btn-action-outline" title="Xuất danh sách nhân viên ra file Excel/CSV">
                        <i class="bi bi-file-earmark-excel text-success"></i> Xuất Excel
                    </a>
                    <button type="button" class="btn-action-outline" data-bs-toggle="modal" data-bs-target="#importModal" title="Nhập danh sách nhân viên từ file CSV">
                        <i class="bi bi-upload text-primary"></i> Nhập từ file
                    </button>
                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                        <a href="${pageContext.request.contextPath}/employees?action=new" class="btn-add-emp">
                            <i class="bi bi-person-plus-fill"></i> Thêm nhân viên
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'added'}">
                            Thêm nhân viên mới thành công!
                            <c:if test="${not empty param.contractId}">
                                Hợp đồng lao động đã được tự động sinh. 
                                <a href="${pageContext.request.contextPath}/contracts?action=print&id=${param.contractId}" target="_blank" class="alert-link fw-bold ms-1 text-decoration-underline">
                                    <i class="bi bi-printer me-1"></i>Xem &amp; In hợp đồng lao động ngay
                                </a>
                            </c:if>
                        </c:when>
                        <c:when test="${param.success eq 'updated'}">Cập nhật thông tin nhân viên thành công!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Đã vô hiệu hóa nhân viên thành công.</c:when>
                        <c:when test="${param.success eq 'imported'}">
                            Nhập dữ liệu thành công! Đã thêm <strong>${not empty param.count ? param.count : 0}</strong> nhân sự vào hệ thống.
                            <c:if test="${not empty param.errors and param.errors gt 0}">
                                <span class="text-danger ms-2">(${param.errors} dòng bị bỏ qua do dữ liệu không hợp lệ)</span>
                            </c:if>
                        </c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.importError}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    ${not empty sessionScope.importErrorMessage ? sessionScope.importErrorMessage : 'Có lỗi xảy ra khi xử lý file dữ liệu.'}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    <c:out value="${param.error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- KPI Stats Cards -->
            <div class="emp-stats-grid">
                <div class="emp-stat-card">
                    <div class="emp-stat-icon blue"><i class="bi bi-people-fill"></i></div>
                    <div>
                        <div class="emp-stat-label">Tổng nhân sự</div>
                        <div class="emp-stat-value">${statsTotal}</div>
                        <div class="emp-stat-meta">Toàn bộ hồ sơ trong hệ thống</div>
                    </div>
                </div>
                <div class="emp-stat-card">
                    <div class="emp-stat-icon green"><i class="bi bi-person-check-fill"></i></div>
                    <div>
                        <div class="emp-stat-label">Đang làm việc</div>
                        <div class="emp-stat-value">${statsActive}</div>
                        <div class="emp-stat-meta">
                            <c:choose>
                                <c:when test="${statsTotal > 0}">
                                    <c:set var="pct" value="${statsActive * 100 / statsTotal}"/>
                                    <span style="color:#059669; font-weight:700;">${fn:substringBefore(pct.toString(), '.')}%</span> so với tổng
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="emp-stat-card">
                    <div class="emp-stat-icon amber"><i class="bi bi-hourglass-split"></i></div>
                    <div>
                        <div class="emp-stat-label">Đang nghỉ phép</div>
                        <div class="emp-stat-value">${statsOnLeave}</div>
                        <div class="emp-stat-meta">Quý hiện tại</div>
                    </div>
                </div>
                <div class="emp-stat-card">
                    <div class="emp-stat-icon slate"><i class="bi bi-person-dash-fill"></i></div>
                    <div>
                        <div class="emp-stat-label">Nghỉ việc / Lưu trữ</div>
                        <div class="emp-stat-value">${statsInactive}</div>
                        <div class="emp-stat-meta">Hồ sơ đã kết thúc</div>
                    </div>
                </div>
            </div>

            <!-- Search & Filter -->
            <div class="filter-card">
                <form method="get" action="${pageContext.request.contextPath}/employees">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-4">
                            <div class="filter-search-wrap">
                                <i class="bi bi-search"></i>
                                <input type="text" class="form-control filter-search-wrap" name="keyword"
                                       placeholder="Tìm kiếm theo tên nhân viên, mã NV, email hoặc số điện thoại..."
                                       value="<c:out value='${keyword}'/>">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <select class="form-select filter-select" name="departmentId">
                                <option value="">Tất cả phòng ban</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" ${departmentId == dept.id ? 'selected' : ''}><c:out value="${dept.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select class="form-select filter-select" name="positionId">
                                <option value="">Tất cả chức vụ</option>
                                <c:forEach var="pos" items="${positions}">
                                    <option value="${pos.id}" ${positionId == pos.id ? 'selected' : ''}><c:out value="${pos.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select class="form-select filter-select" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="ACTIVE"   ${status eq 'ACTIVE'   ? 'selected' : ''}>Đang làm việc</option>
                                <option value="ON_LEAVE" ${status eq 'ON_LEAVE' ? 'selected' : ''}>Đang nghỉ phép</option>
                                <option value="INACTIVE" ${status eq 'INACTIVE' ? 'selected' : ''}>Đã nghỉ việc</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn-filter-primary flex-fill justify-content-center">
                                <i class="bi bi-funnel-fill"></i> Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/employees" class="btn-filter-reset" title="Đặt lại bộ lọc">
                                <i class="bi bi-arrow-counterclockwise"></i> Đặt lại
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Employee Table -->
            <div class="emp-table-card">
                <div class="table-responsive">
                    <table class="emp-table">
                        <thead>
                            <tr>
                                <th style="width:42px; padding-left:1.25rem;">
                                    <input type="checkbox" id="checkAll" class="form-check-input" style="width:16px;height:16px;">
                                </th>
                                <th>Avatar & Họ tên</th>
                                <th>Mã NV</th>
                                <th>Phòng ban</th>
                                <th>Chức vụ</th>
                                <th>Liên hệ</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-end" style="padding-right:1.25rem;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty employees}">
                                    <tr>
                                        <td colspan="8" style="text-align:center; padding:3.5rem 1rem; color:#94a3b8;">
                                            <i class="bi bi-inbox" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i>
                                            <div style="font-weight:600; font-size:0.95rem; color:#64748b;">Không tìm thấy nhân viên phù hợp</div>
                                            <div style="font-size:0.82rem; margin-top:4px;">Thử thay đổi tiêu chí tìm kiếm hoặc <a href="${pageContext.request.contextPath}/employees" class="text-primary">xem tất cả</a></div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="emp" items="${employees}">
                                        <tr>
                                            <td style="padding-left:1.25rem;">
                                                <input type="checkbox" class="form-check-input row-check" value="${emp.id}" style="width:16px;height:16px;">
                                            </td>
                                            <td>
                                                <div class="emp-avatar-cell">
                                                    <div class="emp-avatar ${emp.gender eq 'FEMALE' ? 'avatar-f' : 'avatar-m'}">
                                                        <c:choose>
                                                            <c:when test="${not empty emp.fullName}">
                                                                ${fn:toUpperCase(fn:substring(fn:trim(emp.fullName), 0, 1))}
                                                            </c:when>
                                                            <c:otherwise>NV</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div>
                                                        <div class="emp-name"><c:out value="${emp.fullName}"/></div>
                                                        <c:if test="${not empty emp.employeeTypeName}">
                                                            <span class="emp-type-badge"><c:out value="${emp.employeeTypeName}"/></span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="emp-code-badge"><c:out value="${emp.employeeCode}"/></span>
                                            </td>
                                            <td>
                                                <div class="emp-dept"><c:out value="${emp.departmentName}"/></div>
                                            </td>
                                            <td>
                                                <div class="emp-pos"><c:out value="${emp.positionName}"/></div>
                                            </td>
                                            <td>
                                                <div class="emp-contact">
                                                    <div class="emp-email"><i class="bi bi-envelope me-1" style="font-size:0.7rem;"></i><c:out value="${emp.email}"/></div>
                                                    <div class="emp-phone"><i class="bi bi-telephone me-1" style="font-size:0.7rem;"></i><c:out value="${emp.phone}"/></div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${emp.status eq 'ACTIVE'}">
                                                        <span class="status-pill active"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Đang làm việc</span>
                                                    </c:when>
                                                    <c:when test="${emp.status eq 'ON_LEAVE'}">
                                                        <span class="status-pill on-leave"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Nghỉ phép</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill inactive"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Đã nghỉ việc</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding-right:1.25rem;">
                                                <div class="action-btn-group">
                                                    <a href="${pageContext.request.contextPath}/employees?action=detail&id=${emp.id}"
                                                       class="action-btn" title="Xem hồ sơ">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                                        <a href="${pageContext.request.contextPath}/employees?action=edit&id=${emp.id}"
                                                           class="action-btn edit" title="Chỉnh sửa">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <button type="button" class="action-btn del"
                                                                title="Vô hiệu hóa"
                                                                data-id="${emp.id}"
                                                                data-name="<c:out value='${emp.fullName}'/>"
                                                                onclick="confirmDelete(this)">
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

                <!-- Table Footer / Pagination -->
                <c:if test="${not empty employees}">
                    <div class="table-footer-bar">
                        <div style="color:#64748b;">
                            Hiển thị <strong style="color:#1e293b;">${fn:length(employees)}</strong> nhân sự
                            <c:if test="${not empty keyword or not empty departmentId or not empty status}">
                                (đang lọc)
                            </c:if>
                        </div>
                        <div class="pagination-row">
                            <a href="#" class="page-btn"><i class="bi bi-chevron-left" style="font-size:0.7rem;"></i></a>
                            <a href="#" class="page-btn active">1</a>
                            <a href="#" class="page-btn" style="color:#94a3b8; cursor:not-allowed;">···</a>
                            <a href="#" class="page-btn"><i class="bi bi-chevron-right" style="font-size:0.7rem;"></i></a>
                        </div>
                    </div>
                </c:if>
            </div>

        </div><!-- end app-content -->
    </main>
</div>

<!-- Delete Confirm Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <div class="modal-header border-0" style="background:#fef2f2; padding:1.25rem 1.5rem 0.75rem;">
                <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> Xác nhận vô hiệu hóa
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body px-4 py-3 text-secondary" style="font-size:0.9rem;">
                Bạn có chắc muốn vô hiệu hóa nhân viên <strong id="deleteEmpName" class="text-dark"></strong>?
                <div class="mt-2 p-2 rounded" style="background:#f8fafc; font-size:0.8rem; color:#64748b;">
                    <i class="bi bi-info-circle me-1"></i>Nhân viên sẽ bị đánh dấu trạng thái <em>Đã nghỉ việc</em>. Dữ liệu lịch sử vẫn được lưu trữ.
                </div>
            </div>
            <div class="modal-footer border-0 px-4 pt-0 pb-4 gap-2">
                <button type="button" class="btn btn-light btn-sm px-3" data-bs-dismiss="modal">Hủy bỏ</button>
                <form method="post" action="${pageContext.request.contextPath}/employees" id="deleteForm" class="d-inline">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteEmpId">
                    <button type="submit" class="btn btn-danger btn-sm px-4">
                        <i class="bi bi-trash me-1"></i> Xác nhận vô hiệu hóa
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Nhập từ file CSV -->
<div class="modal fade" id="importModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <div class="modal-header border-0 pb-0" style="background:#f8fafc; padding:1.25rem 1.5rem;">
                <div>
                    <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-cloud-arrow-up-fill text-primary" style="font-size:1.2rem;"></i>
                        Nhập danh sách nhân viên từ file
                    </h6>
                    <p class="text-muted mb-0" style="font-size:0.8rem;">
                        Tải lên file danh sách nhân sự định dạng CSV / Excel UTF-8 để nhập hàng loạt vào hệ thống.
                    </p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/employees?action=import" enctype="multipart/form-data" id="importForm">
                <div class="modal-body px-4 py-3">
                    <!-- Instruction & Download Template Card -->
                    <div class="p-3 mb-3 rounded-3 border d-flex flex-wrap align-items-center justify-content-between gap-2" style="background:#f0fdf4; border-color:#bbf7d0 !important;">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-info-circle-fill text-success" style="font-size:1.1rem;"></i>
                            <div style="font-size:0.82rem; color:#166534;">
                                Chưa có file theo mẫu chuẩn? Hãy tải file biểu mẫu CSV UTF-8 để điền thông tin.
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/employees?action=template" class="btn btn-sm btn-success px-3" style="border-radius:8px; font-weight:600;">
                            <i class="bi bi-download me-1"></i> Tải file mẫu CSV
                        </a>
                    </div>

                    <!-- File Drop Area -->
                    <div class="rounded-3 p-4 text-center mb-3" id="dropArea" style="border:2px dashed #cbd5e1; background:#f8fafc; cursor:pointer; transition:all 0.2s;">
                        <input type="file" name="file" id="fileInput" accept=".csv, .txt" class="d-none" required>
                        <div class="mb-2">
                            <i class="bi bi-filetype-csv text-primary" style="font-size:2.4rem;"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-1" id="fileLabelTitle">Nhấn để chọn file hoặc kéo thả vào đây</h6>
                        <p class="text-muted mb-0" style="font-size:0.8rem;" id="fileLabelDesc">Hỗ trợ file định dạng CSV, TXT (UTF-8, dung lượng tối đa 10MB)</p>
                    </div>

                    <!-- Live Preview Box -->
                    <div id="previewContainer" class="d-none">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="fw-bold text-dark" style="font-size:0.83rem;">
                                <i class="bi bi-table me-1 text-primary"></i> Xem trước dữ liệu (<span id="previewCount">0</span> dòng)
                            </span>
                            <button type="button" class="btn btn-link btn-sm text-danger text-decoration-none p-0" id="btnRemoveFile" style="font-size:0.8rem;">
                                <i class="bi bi-x-circle me-1"></i> Chọn file khác
                            </button>
                        </div>
                        <div class="table-responsive border rounded-3" style="max-height:200px; font-size:0.78rem;">
                            <table class="table table-sm table-hover mb-0" id="previewTable">
                                <thead class="table-light">
                                    <tr id="previewThead"></tr>
                                </thead>
                                <tbody id="previewTbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 gap-2">
                    <button type="button" class="btn btn-light btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm px-4" id="btnSubmitImport" disabled style="border-radius:9px; font-weight:600;">
                        <i class="bi bi-cloud-arrow-up me-1"></i> Bắt đầu nhập dữ liệu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/employee-list.js"></script>
</body>
</html>
