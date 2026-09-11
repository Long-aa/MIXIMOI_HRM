<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Danh sách phòng ban — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="departments" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Department List Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Action -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-building text-primary"></i> Quản lý phòng ban
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Danh sách phòng ban</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/departments?action=new" class="btn-action-primary text-decoration-none">
                    <i class="bi bi-plus-circle-fill"></i> Thêm phòng ban
                </a>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'added'}">Thêm phòng ban mới thành công!</c:when>
                        <c:when test="${param.success eq 'updated'}">Cập nhật thông tin phòng ban thành công!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Đã xóa phòng ban thành công.</c:when>
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

            <!-- Department KPI Cards Summary -->
            <c:set var="totalEmployeesInDepts" value="0" />
            <c:forEach var="dept" items="${departments}">
                <c:set var="totalEmployeesInDepts" value="${totalEmployeesInDepts + (not empty dept.employeeCount ? dept.employeeCount : 0)}" />
            </c:forEach>
            <c:set var="deptCount" value="${not empty departments ? fn:length(departments) : 0}" />

            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-lg-4">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">TỔNG SỐ PHÒNG BAN</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">${deptCount}</span>
                                    <span class="kpi-unit">bộ phận</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box">
                                <i class="bi bi-buildings"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span>Phân bổ cơ cấu tổ chức</span>
                            <span class="trend-badge positive"><i class="bi bi-check2"></i> Hoạt động</span>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-4">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">NHÂN SỰ TRỰC THUỘC</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">${totalEmployeesInDepts}</span>
                                    <span class="kpi-unit">nhân viên</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box text-success" style="background:#ecfdf5">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span>Nhân sự đang công tác</span>
                            <span class="text-muted">Tính theo phòng ban</span>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-4">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">TRUNG BÌNH QUY MÔ</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">
                                        <c:choose>
                                            <c:when test="${deptCount > 0}">
                                                <fmt:formatNumber value="${(totalEmployeesInDepts * 1.0) / deptCount}" maxFractionDigits="1" minFractionDigits="0"/>
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit">người / phòng</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box text-warning" style="background:#fffbeb">
                                <i class="bi bi-pie-chart-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span>Quy mô trung bình</span>
                            <span class="text-primary fw-medium">Chuẩn tối ưu</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Department Data Table -->
            <div class="table-custom-container">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width: 80px;">STT</th>
                                <th>Tên phòng ban</th>
                                <th>Mô tả chức năng</th>
                                <th class="text-center">Số lượng nhân sự</th>
                                <th class="text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty departments}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-5">
                                            <i class="bi bi-building fs-1 d-block mb-2 text-secondary"></i>
                                            Chưa có dữ liệu phòng ban nào trong hệ thống.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="dept" items="${departments}" varStatus="loop">
                                        <tr>
                                            <td>
                                                <span class="text-muted font-monospace">${loop.index + 1}</span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="kpi-icon-box" style="width: 36px; height: 36px; font-size: 1rem;">
                                                        <i class="bi bi-building"></i>
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold text-dark"><c:out value="${dept.name}"/></div>
                                                        <div class="text-muted" style="font-size: 0.75rem;">Mã bộ phận: DEPT-0${dept.id}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="text-secondary" style="font-size:0.86rem">
                                                    <c:choose>
                                                        <c:when test="${not empty dept.description}">
                                                            <c:out value="${dept.description}"/>
                                                        </c:when>
                                                        <c:otherwise><em class="text-muted">Chưa có mô tả</em></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/employees?departmentId=${dept.id}" 
                                                   class="badge bg-primary-subtle text-primary border text-decoration-none px-3 py-2"
                                                   title="Nhấn để xem danh sách nhân sự phòng này">
                                                    <i class="bi bi-people me-1"></i> ${not empty dept.employeeCount ? dept.employeeCount : 0} nhân sự
                                                </a>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/employees?departmentId=${dept.id}"
                                                       class="btn btn-light border text-secondary" title="Xem danh sách nhân viên">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/departments?action=edit&id=${dept.id}"
                                                       class="btn btn-light border text-primary" title="Chỉnh sửa">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-light border text-danger"
                                                            title="Xóa phòng ban"
                                                            data-id="${dept.id}"
                                                            data-name="<c:out value='${dept.name}'/>"
                                                            data-emp-count="${not empty dept.employeeCount ? dept.employeeCount : 0}"
                                                            onclick="confirmDeleteDept(this)">
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
                
                <c:if test="${not empty departments}">
                    <div class="px-4 py-3 bg-white border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem">
                        <span class="text-muted">Tổng cộng: <strong>${deptCount}</strong> phòng ban</span>
                        <div class="text-muted">MIXIMOI Organization Structure</div>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<!-- Delete Confirm Modal -->
<div class="modal fade" id="deleteDeptModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0">
                <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> Xác nhận xóa
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-3 text-secondary" style="font-size: 0.88rem;">
                Bạn có chắc chắn muốn xóa phòng ban <strong id="deleteDeptName" class="text-dark"></strong>?
                <div id="deptWarning" class="alert alert-warning py-1 px-2 mt-2 mb-0 d-none" style="font-size: 0.75rem;">
                    <i class="bi bi-info-circle me-1"></i> Phòng ban này đang có nhân viên trực thuộc!
                </div>
            </div>
            <div class="modal-footer border-top-0 pt-0">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/departments" id="deleteDeptForm">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteDeptId">
                    <button type="submit" class="btn btn-danger btn-sm px-3">Xác nhận xóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    function confirmDeleteDept(btnOrId, maybeName, maybeEmpCount) {
        let id, name, empCount;
        if (typeof btnOrId === 'object' && btnOrId !== null) {
            id = btnOrId.getAttribute('data-id');
            name = btnOrId.getAttribute('data-name');
            empCount = parseInt(btnOrId.getAttribute('data-emp-count') || '0', 10);
        } else {
            id = btnOrId;
            name = maybeName;
            empCount = maybeEmpCount || 0;
        }
        document.getElementById('deleteDeptId').value = id;
        document.getElementById('deleteDeptName').textContent = name;
        const warning = document.getElementById('deptWarning');
        if (empCount > 0) {
            warning.classList.remove('d-none');
        } else {
            warning.classList.add('d-none');
        }
        new bootstrap.Modal(document.getElementById('deleteDeptModal')).show();
    }
</script>

</body>
</html>
