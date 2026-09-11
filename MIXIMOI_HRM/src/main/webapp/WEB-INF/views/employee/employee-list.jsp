<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Danh sách nhân viên — MIXIMOI HRM & PAYROLL</title>
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

        <!-- Employee List Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Action -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-people text-primary"></i> Quản lý nhân viên
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Danh sách nhân viên</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/employees?action=new" class="btn-action-primary text-decoration-none">
                    <i class="bi bi-person-plus-fill"></i> Thêm nhân viên
                </a>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'added'}">Thêm nhân viên mới thành công!</c:when>
                        <c:when test="${param.success eq 'updated'}">Cập nhật thông tin nhân viên thành công!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Đã vô hiệu hóa nhân viên thành công.</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    <c:out value="${param.error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:set var="empCount" value="${not empty employees ? fn:length(employees) : 0}" />

            <!-- Search & Filter Card -->
            <div class="app-card mb-4">
                <form method="get" action="${pageContext.request.contextPath}/employees" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-muted mb-1" style="font-size:0.8rem">TÌM KIẾM NHANH</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control border-start-0 bg-light" name="keyword"
                                   placeholder="Họ tên, mã NV, email, SĐT..."
                                   value="<c:out value='${keyword}'/>">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold text-muted mb-1" style="font-size:0.8rem">PHÒNG BAN</label>
                        <select class="form-select bg-light" name="departmentId">
                            <option value="">-- Tất cả phòng ban --</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.id}" ${departmentId == dept.id ? 'selected' : ''}><c:out value="${dept.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-semibold text-muted mb-1" style="font-size:0.8rem">TRẠNG THÁI</label>
                        <select class="form-select bg-light" name="status">
                            <option value="">-- Tất cả --</option>
                            <option value="ACTIVE" ${status eq 'ACTIVE' ? 'selected' : ''}>Đang làm</option>
                            <option value="INACTIVE" ${status eq 'INACTIVE' ? 'selected' : ''}>Đã nghỉ</option>
                            <option value="ON_LEAVE" ${status eq 'ON_LEAVE' ? 'selected' : ''}>Nghỉ tạm</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn-action-primary border-0 w-100 justify-content-center">
                            <i class="bi bi-funnel"></i> Lọc dữ liệu
                        </button>
                        <a href="${pageContext.request.contextPath}/employees" class="btn-action-light" title="Đặt lại bộ lọc">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </a>
                    </div>
                </form>
            </div>

            <!-- Employee Data Table -->
            <div class="table-custom-container">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Mã NV</th>
                                <th>Nhân viên</th>
                                <th>Phòng ban</th>
                                <th>Chức vụ</th>
                                <th>Số điện thoại</th>
                                <th>Ngày vào làm</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty employees}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-5">
                                            <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                            Chưa có dữ liệu nhân viên phù hợp với bộ lọc tìm kiếm.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="emp" items="${employees}">
                                        <tr>
                                            <td>
                                                <span class="badge bg-light text-dark border px-2 py-1 font-monospace">
                                                    <c:out value="${emp.employeeCode}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="table-user-cell">
                                                    <div class="table-user-avatar">
                                                        <c:choose>
                                                            <c:when test="${not empty emp.fullName and fn:length(fn:trim(emp.fullName)) > 0}">
                                                                ${fn:toUpperCase(fn:substring(fn:trim(emp.fullName), 0, 1))}
                                                            </c:when>
                                                            <c:otherwise>NV</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div>
                                                        <div class="table-user-name"><c:out value="${emp.fullName}"/></div>
                                                        <div class="table-user-email"><c:out value="${emp.email}"/></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="fw-medium"><c:out value="${emp.departmentName}"/></span></td>
                                            <td><span class="text-muted"><c:out value="${emp.positionName}"/></span></td>
                                            <td><span><c:out value="${emp.phone}"/></span></td>
                                            <td><span class="text-muted"><c:out value="${emp.startDate}"/></span></td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${emp.status eq 'ACTIVE'}">
                                                        <span class="status-pill active">
                                                            <i class="bi bi-check-circle-fill"></i> Đang làm
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${emp.status eq 'INACTIVE'}">
                                                        <span class="status-pill inactive">
                                                            <i class="bi bi-dash-circle-fill"></i> Đã nghỉ
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill leave">
                                                            <i class="bi bi-pause-circle-fill"></i> Nghỉ tạm
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/employees?action=detail&id=${emp.id}"
                                                       class="btn btn-light border text-secondary" title="Xem chi tiết">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/employees?action=edit&id=${emp.id}"
                                                       class="btn btn-light border text-primary" title="Chỉnh sửa">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-light border text-danger"
                                                            title="Vô hiệu hóa"
                                                            data-id="${emp.id}"
                                                            data-name="<c:out value='${emp.fullName}'/>"
                                                            onclick="confirmDelete(this)">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                
                <c:if test="${not empty employees}">
                    <div class="px-4 py-3 bg-white border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem">
                        <span class="text-muted">Hiển thị <strong>${empCount}</strong> nhân sự</span>
                        <div class="text-muted">MIXIMOI HRM Database System</div>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<!-- Delete Confirm Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0">
                <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> Xác nhận xóa
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-3 text-secondary" style="font-size: 0.88rem;">
                Bạn có chắc chắn muốn vô hiệu hóa nhân viên <strong id="deleteEmpName" class="text-dark"></strong>?
            </div>
            <div class="modal-footer border-top-0 pt-0">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/employees" id="deleteForm">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteEmpId">
                    <button type="submit" class="btn btn-danger btn-sm px-3">Xác nhận</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    function confirmDelete(btnOrId, maybeName) {
        let id, name;
        if (typeof btnOrId === 'object' && btnOrId !== null) {
            id = btnOrId.getAttribute('data-id');
            name = btnOrId.getAttribute('data-name');
        } else {
            id = btnOrId;
            name = maybeName;
        }
        document.getElementById('deleteEmpId').value = id;
        document.getElementById('deleteEmpName').textContent = name;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }
</script>

</body>
</html>
