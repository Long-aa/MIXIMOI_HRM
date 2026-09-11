<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Danh sách chức vụ — MIXIMOI HRM & PAYROLL</title>
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

        <!-- Position List Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Action -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-person-badge text-primary"></i> Quản lý chức vụ
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Danh sách chức vụ</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/positions?action=new" class="btn-action-primary text-decoration-none">
                    <i class="bi bi-plus-circle-fill"></i> Thêm chức vụ mới
                </a>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'added'}">Thêm chức vụ mới thành công!</c:when>
                        <c:when test="${param.success eq 'updated'}">Cập nhật chức vụ thành công!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Đã xóa chức vụ thành công.</c:when>
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

            <c:set var="posCount" value="${not empty positions ? fn:length(positions) : 0}" />

            <!-- Table Card -->
            <div class="table-custom-container">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width: 80px;">STT</th>
                                <th>Tên chức danh / Chức vụ</th>
                                <th>Mô tả trách nhiệm</th>
                                <th class="text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty positions}">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-5">
                                            <i class="bi bi-person-badge fs-1 d-block mb-2 text-secondary"></i>
                                            Chưa có dữ liệu chức vụ nào trong hệ thống.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="pos" items="${positions}" varStatus="loop">
                                        <tr>
                                            <td><span class="text-muted font-monospace">${loop.index + 1}</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="kpi-icon-box" style="width: 36px; height: 36px; font-size: 1rem;">
                                                        <i class="bi bi-person-badge"></i>
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold text-dark"><c:out value="${pos.name}"/></div>
                                                        <div class="text-muted" style="font-size:0.75rem">Mã vị trí: POS-${pos.id}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="text-secondary" style="font-size:0.86rem">
                                                    <c:choose>
                                                        <c:when test="${not empty pos.description}">
                                                            <c:out value="${pos.description}"/>
                                                        </c:when>
                                                        <c:otherwise><em class="text-muted">Chưa có mô tả</em></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/positions?action=edit&id=${pos.id}"
                                                       class="btn btn-light border text-primary" title="Chỉnh sửa">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-light border text-danger"
                                                            title="Xóa chức vụ"
                                                            data-id="${pos.id}"
                                                            data-name="<c:out value='${pos.name}'/>"
                                                            onclick="confirmDeletePos(this)">
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

                <c:if test="${not empty positions}">
                    <div class="px-4 py-3 bg-white border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem">
                        <span class="text-muted">Tổng cộng: <strong>${posCount}</strong> chức danh</span>
                        <div class="text-muted">MIXIMOI Job Hierarchy</div>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<!-- Modal xác nhận xóa -->
<div class="modal fade" id="deletePosModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0">
                <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> Xác nhận xóa
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-3 text-secondary" style="font-size: 0.88rem;">
                Bạn có chắc chắn muốn xóa chức vụ <strong id="deletePosName" class="text-dark"></strong>?
            </div>
            <div class="modal-footer border-top-0 pt-0">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/positions">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deletePosId">
                    <button type="submit" class="btn btn-danger btn-sm px-3">Xóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    function confirmDeletePos(btnOrId, maybeName) {
        let id, name;
        if (typeof btnOrId === 'object' && btnOrId !== null) {
            id = btnOrId.getAttribute('data-id');
            name = btnOrId.getAttribute('data-name');
        } else {
            id = btnOrId;
            name = maybeName;
        }
        document.getElementById('deletePosId').value = id;
        document.getElementById('deletePosName').textContent = name;
        new bootstrap.Modal(document.getElementById('deletePosModal')).show();
    }
</script>

</body>
</html>
