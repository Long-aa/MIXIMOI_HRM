<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Phòng ban — MIXIMOI HRM &amp; PAYROLL</title>
    <meta name="description" content="Quản lý cơ cấu tổ chức, sơ đồ phòng ban và phân bổ nhân sự — MIXIMOI HRM">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/department.css">
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="departments" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>
        <div class="app-content">

            <%-- ===== THÔNG BÁO ===== --%>
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'added'}">Thêm phòng ban mới thành công!</c:when>
                        <c:when test="${param.success eq 'updated'}">Cập nhật thông tin phòng ban thành công!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Đã xóa phòng ban thành công.</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    <c:out value="${param.error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                </div>
            </c:if>

            <%-- ===== TÍNH TOÁN KPI ===== --%>
            <c:set var="totalEmp" value="0"/>
            <c:set var="deptSource" value="${not empty allDepartments ? allDepartments : departments}"/>
            <c:set var="deptCount" value="${not empty deptSource ? fn:length(deptSource) : 0}"/>
            <c:forEach var="dept" items="${deptSource}">
                <c:set var="totalEmp" value="${totalEmp + (not empty dept.employeeCount ? dept.employeeCount : 0)}"/>
            </c:forEach>
            <c:set var="maxEmpCount" value="1"/>
            <c:forEach var="dept" items="${deptSource}">
                <c:if test="${dept.employeeCount > maxEmpCount}">
                    <c:set var="maxEmpCount" value="${dept.employeeCount}"/>
                </c:if>
            </c:forEach>

            <%-- ===== PAGE HEADER ===== --%>
            <div class="dept-page-header">
                <div>
                    <h1 class="dept-page-title">
                        <i class="bi bi-buildings text-primary"></i>
                        Quản lý Phòng ban
                        <span class="badge-count">${deptCount} phòng ban</span>
                    </h1>
                    <p class="dept-page-subtitle">Quản lý cơ cấu tổ chức, phân bổ nhân sự và sơ đồ phòng ban — MIXIMOI HRM</p>
                </div>
                <div class="dept-header-actions">
                    <a href="${pageContext.request.contextPath}/departments?action=export" class="btn-export" title="Xuất danh sách phòng ban">
                        <i class="bi bi-download"></i> Xuất Excel
                    </a>
                    <button class="btn-org-chart" onclick="alert('Sơ đồ tổ chức đang phát triển')">
                        <i class="bi bi-diagram-3"></i> Sơ đồ tổ chức
                    </button>
                    <%-- Chỉ Admin và HR được thêm phòng ban --%>
                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                        <a href="${pageContext.request.contextPath}/departments?action=new" class="btn-add-dept" id="btnAddDept">
                            <i class="bi bi-plus-circle-fill"></i> Thêm phòng ban
                        </a>
                    </c:if>
                </div>
            </div>

            <%-- ===== KPI CARDS ===== --%>
            <div class="dept-kpi-grid">
                <div class="dept-kpi-card">
                    <div class="dept-kpi-top">
                        <div>
                            <div class="dept-kpi-label">Tổng số phòng ban</div>
                            <div class="dept-kpi-value-row">
                                <span class="dept-kpi-value">${deptCount}</span>
                            </div>
                        </div>
                        <div class="dept-kpi-icon"><i class="bi bi-buildings"></i></div>
                    </div>
                    <div class="dept-kpi-footer">
                        <span class="dept-kpi-footer-main"><i class="bi bi-arrow-up-circle-fill text-success me-1"></i>Toàn bộ hệ thống</span>
                        <span class="dept-kpi-badge-pos"><i class="bi bi-check2"></i> Hoạt động</span>
                    </div>
                </div>
                <div class="dept-kpi-card green">
                    <div class="dept-kpi-top">
                        <div>
                            <div class="dept-kpi-label">Tổng nhân sự trực thuộc</div>
                            <div class="dept-kpi-value-row">
                                <span class="dept-kpi-value">${totalEmp}</span>
                                <span class="dept-kpi-unit">nhân viên</span>
                            </div>
                        </div>
                        <div class="dept-kpi-icon green"><i class="bi bi-people-fill"></i></div>
                    </div>
                    <div class="dept-kpi-footer">
                        <span class="dept-kpi-footer-main">Tổng nhân lực toàn công ty</span>
                        <span class="dept-kpi-badge-neutral">Đang làm việc</span>
                    </div>
                </div>
                <div class="dept-kpi-card amber">
                    <div class="dept-kpi-top">
                        <div>
                            <div class="dept-kpi-label">Quy mô trung bình</div>
                            <div class="dept-kpi-value-row">
                                <span class="dept-kpi-value">
                                    <c:choose>
                                        <c:when test="${deptCount > 0}"><fmt:formatNumber value="${totalEmp / deptCount}" maxFractionDigits="1"/></c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="dept-kpi-unit">NV/phòng</span>
                            </div>
                        </div>
                        <div class="dept-kpi-icon amber"><i class="bi bi-pie-chart-fill"></i></div>
                    </div>
                    <div class="dept-kpi-footer">
                        <span class="dept-kpi-footer-main">Phân bổ đồng đều</span>
                        <span class="dept-kpi-badge-neutral">Chuẩn tối ưu</span>
                    </div>
                </div>
                <div class="dept-kpi-card violet">
                    <div class="dept-kpi-top">
                        <div>
                            <div class="dept-kpi-label">Phòng ban lớn nhất</div>
                            <div class="dept-kpi-value-row">
                                <span class="dept-kpi-value">${maxEmpCount}</span>
                                <span class="dept-kpi-unit">NV</span>
                            </div>
                        </div>
                        <div class="dept-kpi-icon violet"><i class="bi bi-person-badge-fill"></i></div>
                    </div>
                    <div class="dept-kpi-footer">
                        <span class="dept-kpi-footer-main">Đơn vị quy mô tối đa</span>
                        <span class="dept-kpi-badge-neutral">Đủ lãnh đạo</span>
                    </div>
                </div>
            </div>

            <%-- ===== TÌM KIẾM & BỘ LỌC ===== --%>
            <div class="dept-search-bar">
                <div class="dept-search-input-wrap">
                    <i class="bi bi-search"></i>
                    <input type="text" class="dept-search-input" id="deptSearchInput"
                           placeholder="Tìm theo tên phòng ban, mã PB..."
                           oninput="filterDeptTable()">
                </div>
                <select class="dept-search-select" id="deptStatusFilter" onchange="filterDeptTable()">
                    <option value="">Tất cả trạng thái</option>
                    <option value="active">Hoạt động</option>
                    <option value="restructure">Tái cơ cấu</option>
                    <option value="inactive">Ngừng hoạt động</option>
                </select>
                <select class="dept-search-select" id="deptSizeFilter" onchange="filterDeptTable()">
                    <option value="">Tất cả quy mô</option>
                    <option value="small">Nhỏ (&lt; 20 NV)</option>
                    <option value="medium">Vừa (20–50 NV)</option>
                    <option value="large">Lớn (&gt; 50 NV)</option>
                </select>
                <button class="btn-reset-filter" onclick="resetFilter()">
                    <i class="bi bi-arrow-counterclockwise"></i> Đặt lại
                </button>
            </div>

            <%-- ===== BULK ACTION BAR ===== --%>
            <div id="bulkActionBar" class="d-none align-items-center gap-2 mb-2 px-3 py-2"
                 style="background:linear-gradient(90deg,#fef3c7,#fffbeb);border-radius:10px;border:1px solid #fde68a;flex-wrap:wrap;">
                <span style="font-size:0.83rem;color:#92400e;font-weight:700;">
                    <i class="bi bi-check2-square me-1"></i>
                    Đã chọn <strong id="selectedCount">0</strong> phòng ban
                </span>
                <div class="d-flex gap-2 ms-auto">
                    <button type="button" onclick="bulkDeleteDepts()"
                            class="btn btn-sm btn-danger px-3" style="border-radius:8px;font-weight:600;font-size:0.8rem;">
                        <i class="bi bi-trash me-1"></i> Xóa hàng loạt
                    </button>
                    <button type="button" onclick="clearDeptSelection()"
                            class="btn btn-sm btn-light px-3" style="border-radius:8px;font-size:0.8rem;">
                        <i class="bi bi-x-lg me-1"></i> Bỏ chọn
                    </button>
                </div>
            </div>

            <%-- ===== BẢNG DANH SÁCH ===== --%>
            <div class="dept-table-wrap">
                <div class="dept-table-header-bar">
                    <div>
                        <span class="dept-table-title">Danh sách cơ cấu phòng ban</span>
                        <span class="dept-table-subtitle">/ Hiển thị phân bổ nguồn lực &amp; nhân sự chủ chốt</span>
                    </div>
                    <span class="dept-cols-badge"><i class="bi bi-layout-three-columns me-1"></i>8 cột dữ liệu</span>
                </div>
                <div class="table-responsive">
                    <table class="dept-table" id="deptTable">
                        <thead>
                            <tr>
                                <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                    <th><input type="checkbox" class="dept-cb" id="checkAll" onchange="toggleAll(this)"></th>
                                </c:if>
                                <th>Mã PB</th>
                                <th>Tên phòng ban &amp; khối nghiệp vụ</th>
                                <th>Trưởng phòng / Quản lý</th>
                                <th>Nhân viên / Tỷ trọng</th>
                                <th>Ngày thành lập</th>
                                <th>Trạng thái</th>
                                <th style="text-align:right">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="deptTableBody">
                            <c:choose>
                                <c:when test="${empty departments}">
                                    <tr>
                                        <td colspan="8">
                                            <div class="dept-empty-state">
                                                <div class="dept-empty-icon"><i class="bi bi-buildings"></i></div>
                                                <div class="dept-empty-title">Chưa có phòng ban nào</div>
                                                <div class="dept-empty-desc">Hệ thống chưa có dữ liệu phòng ban. Hãy thêm phòng ban đầu tiên!</div>
                                                <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                                    <a href="${pageContext.request.contextPath}/departments?action=new" class="btn-add-dept mt-3" style="display:inline-flex">
                                                        <i class="bi bi-plus-circle-fill"></i> Thêm phòng ban đầu tiên
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="dept" items="${departments}" varStatus="loop">
                                        <c:set var="pct" value="${maxEmpCount > 0 ? (dept.employeeCount * 100) / maxEmpCount : 0}"/>
                                        <c:set var="ck" value="${loop.index % 8}"/>
                                        <c:set var="deptStatus" value="${dept.employeeCount > 0 ? 'active' : 'restructure'}"/>
                                        <tr class="dept-row"
                                            data-name="${fn:toLowerCase(dept.name)}"
                                            data-code="${fn:toLowerCase(not empty dept.code ? dept.code : ('pb' += (loop.index + 1)))}"
                                            data-status="${deptStatus}"
                                            data-emp="${dept.employeeCount}"
                                            data-id="${dept.id}">
                                            <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                                <td><input type="checkbox" class="dept-cb row-cb" value="${dept.id}" onchange="updateBulkActions()"></td>
                                            </c:if>
                                            <td>
                                                <span class="dept-code-badge ${ck == 0 ? 'dept-code-blue' : ck == 1 ? 'dept-code-green' : ck == 2 ? 'dept-code-purple' : ck == 3 ? 'dept-code-amber' : ck == 4 ? 'dept-code-pink' : ck == 5 ? 'dept-code-teal' : ck == 6 ? 'dept-code-red' : 'dept-code-slate'}">
                                                    ${not empty dept.code ? dept.code : ('PB' += (loop.index < 9 ? '0' : '') += (loop.index + 1))}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="dept-name-cell">
                                                    <div class="dept-icon-circle"
                                                         style="${ck % 4 == 0 ? 'background:#eff6ff;color:#2563eb' : ck % 4 == 1 ? 'background:#f0fdf4;color:#16a34a' : ck % 4 == 2 ? 'background:#f5f3ff;color:#7c3aed' : 'background:#fffbeb;color:#d97706'}">
                                                        <c:out value="${fn:toUpperCase(fn:substring(dept.name, 0, 2))}"/>
                                                    </div>
                                                    <div>
                                                        <div class="dept-name-main"><c:out value="${dept.name}"/></div>
                                                        <div class="dept-name-meta">
                                                            <c:choose>
                                                                <c:when test="${not empty dept.description}">
                                                                    <c:out value="${fn:substring(dept.description, 0, 50)}"/>
                                                                    <c:if test="${fn:length(dept.description) > 50}">...</c:if>
                                                                </c:when>
                                                                <c:otherwise>Chưa có mô tả</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty dept.managerName}">
                                                        <div class="dept-manager-cell">
                                                            <div class="dept-manager-avatar">
                                                                <c:out value="${fn:toUpperCase(fn:substring(dept.managerName, 0, 2))}"/>
                                                            </div>
                                                            <div>
                                                                <div class="dept-manager-name"><c:out value="${dept.managerName}"/></div>
                                                                <div class="dept-manager-title">Trưởng đơn vị — <c:out value="${fn:substring(dept.name,0,20)}"/></div>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${dept.employeeCount > 0}">
                                                        <div class="dept-manager-cell">
                                                            <div class="dept-manager-avatar">QL</div>
                                                            <div>
                                                                <div class="dept-manager-name" style="color:var(--text-muted);font-style:italic">Chưa chỉ định</div>
                                                                <div class="dept-manager-title">Trực thuộc BGD</div>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="dept-manager-vacant">
                                                            <i class="bi bi-person-dash"></i> Đang tuyển dụng
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/employees?departmentId=${dept.id}" style="text-decoration:none">
                                                    <span class="dept-emp-count">${dept.employeeCount}</span>
                                                    <span class="dept-emp-unit"> NV</span>
                                                </a>
                                                <fmt:formatNumber var="pctFill" value="${pct}" maxFractionDigits="0"/>
                                                <div class="dept-progress-bar">
                                                    <div class="dept-progress-fill" style="width: ${pctFill}%;"></div>
                                                </div>
                                                <div class="dept-progress-pct"><fmt:formatNumber value="${pct}" maxFractionDigits="1"/>%</div>
                                            </td>
                                            <td>
                                                <div class="dept-date">
                                                    <c:choose>
                                                        <c:when test="${not empty dept.createdAt}">
                                                            <fmt:formatDate value="${dept.createdAt}" pattern="dd/MM/yyyy" type="date"/>
                                                        </c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${dept.employeeCount == 0}">
                                                        <span class="status-pill status-pill-restructure">
                                                            <span class="status-dot dot-restructure"></span>Tái cơ cấu
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-pill-active">
                                                            <span class="status-dot dot-active"></span>Hoạt động
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="dept-actions">
                                                    <%-- Tất cả role đều có thể xem nhân viên phòng ban --%>
                                                    <a href="${pageContext.request.contextPath}/employees?departmentId=${dept.id}"
                                                       class="dept-action-btn" title="Xem nhân viên">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <%-- Chỉ Admin và HR được sửa/xóa --%>
                                                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                                        <a href="${pageContext.request.contextPath}/departments?action=edit&id=${dept.id}"
                                                           class="dept-action-btn edit" title="Chỉnh sửa">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <button class="dept-action-btn del" title="Xóa phòng ban"
                                                                data-id="${dept.id}"
                                                                data-name="<c:out value='${dept.name}'/>"
                                                                data-emp-count="${dept.employeeCount}"
                                                                onclick="confirmDeleteDept(this)">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <%-- Dòng hiển thị khi bộ lọc không có kết quả --%>
                                    <tr id="deptEmptyFilterRow" style="display:none">
                                        <td colspan="8" style="padding:32px;text-align:center;color:#6b7280;font-size:0.85rem">
                                            <i class="bi bi-search me-2"></i>Không tìm thấy phòng ban phù hợp với bộ lọc.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                <c:if test="${not empty departments}">
                    <div class="dept-table-footer d-flex align-items-center justify-content-between flex-wrap gap-2 py-3 px-3">
                        <span style="color:#64748b; font-size:0.84rem;">
                            Hiển thị <strong style="color:#1e293b;">${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalDepartments ? totalDepartments : currentPage * pageSize}</strong>
                            trên tổng số <strong style="color:#1e293b;" id="visibleCount">${totalDepartments}</strong> phòng ban
                        </span>
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-row">
                                <a href="${pageContext.request.contextPath}/departments?page=${currentPage - 1}"
                                   class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" title="Trang trước">
                                    <i class="bi bi-chevron-left" style="font-size:0.7rem;"></i>
                                </a>
                                <c:forEach begin="1" end="${totalPages}" var="pg">
                                    <a href="${pageContext.request.contextPath}/departments?page=${pg}"
                                       class="page-btn ${pg == currentPage ? 'active' : ''}">${pg}</a>
                                </c:forEach>
                                <a href="${pageContext.request.contextPath}/departments?page=${currentPage + 1}"
                                   class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" title="Trang sau">
                                    <i class="bi bi-chevron-right" style="font-size:0.7rem;"></i>
                                </a>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<%-- ===== MODAL XÁC NHẬN XÓA ===== --%>
<div class="modal fade" id="deleteDeptModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:420px">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;overflow:hidden">
            <div style="background:linear-gradient(135deg,#fef2f2,#fee2e2);padding:24px 24px 16px">
                <div style="display:flex;align-items:center;gap:12px">
                    <div style="width:44px;height:44px;border-radius:12px;background:#fee2e2;display:flex;align-items:center;justify-content:center;font-size:1.3rem;color:#dc2626;border:2px solid #fca5a5">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                    </div>
                    <div>
                        <h6 style="font-weight:700;color:#991b1b;margin:0">Xác nhận xóa phòng ban</h6>
                        <p style="font-size:0.78rem;color:#b91c1c;margin:0">Thao tác này không thể hoàn tác</p>
                    </div>
                </div>
            </div>
            <div class="modal-body" style="padding:20px 24px">
                <p style="font-size:0.87rem;color:#374151;margin-bottom:12px">
                    Bạn có chắc chắn muốn xóa phòng ban <strong id="deleteDeptName" class="text-dark"></strong>?
                </p>
                <div id="deptWarning" class="d-none" style="background:#fffbeb;border:1px solid #fbbf24;border-radius:8px;padding:10px 14px;font-size:0.78rem;color:#92400e">
                    <i class="bi bi-info-circle-fill me-2 text-warning"></i>
                    Phòng ban này đang có nhân viên trực thuộc! Hãy chuyển nhân viên trước khi xóa.
                </div>
            </div>
            <div class="modal-footer" style="padding:16px 24px;border-top:1px solid #f3f4f6;gap:10px">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal" style="border-radius:8px">Hủy bỏ</button>
                <form method="post" action="${pageContext.request.contextPath}/departments" id="deleteDeptForm" style="margin:0">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteDeptId">
                    <button type="submit" class="btn btn-danger" style="border-radius:8px;font-weight:600">
                        <i class="bi bi-trash me-1"></i> Xác nhận xóa
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<%-- ===== BULK DELETE MODAL ===== --%>
<div class="modal fade" id="bulkDeleteDeptModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:440px">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;overflow:hidden">
            <div style="background:linear-gradient(135deg,#fef2f2,#fee2e2);padding:24px 24px 16px">
                <div style="display:flex;align-items:center;gap:12px">
                    <div style="width:44px;height:44px;border-radius:12px;background:#fee2e2;display:flex;align-items:center;justify-content:center;font-size:1.3rem;color:#dc2626;border:2px solid #fca5a5">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                    </div>
                    <div>
                        <h6 style="font-weight:700;color:#991b1b;margin:0">Xác nhận xóa hàng loạt</h6>
                        <p style="font-size:0.78rem;color:#b91c1c;margin:0">Chỉ phòng ban không có nhân viên mới được xóa</p>
                    </div>
                </div>
            </div>
            <div class="modal-body" style="padding:20px 24px">
                <p style="font-size:0.87rem;color:#374151;margin-bottom:8px">
                    Bạn đã chọn <strong id="bulkDeptCount" class="text-danger">0</strong> phòng ban để xóa.
                </p>
                <div style="background:#fffbeb;border:1px solid #fbbf24;border-radius:8px;padding:10px 14px;font-size:0.78rem;color:#92400e">
                    <i class="bi bi-info-circle-fill me-2 text-warning"></i>
                    Phòng ban còn nhân viên hoạt động sẽ được bỏ qua tự động.
                </div>
            </div>
            <div class="modal-footer" style="padding:16px 24px;border-top:1px solid #f3f4f6;gap:10px">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal" style="border-radius:8px">Hủy bỏ</button>
                <form method="post" action="${pageContext.request.contextPath}/departments" id="bulkDeleteDeptForm" style="margin:0">
                    <input type="hidden" name="action" value="bulkDelete">
                    <button type="button" class="btn btn-danger" onclick="confirmBulkDeleteDepts()" style="border-radius:8px;font-weight:600">
                        <i class="bi bi-trash me-1"></i> Xác nhận xóa
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/department.js"></script>
</body>
</html>
