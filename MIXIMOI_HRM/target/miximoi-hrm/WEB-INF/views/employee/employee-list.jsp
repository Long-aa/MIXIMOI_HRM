<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý nhân viên — MIXIMOI HRM & PAYROLL</title>
    <meta name="description" content="Danh sách nhân viên MIXIMOI HRM - Quản lý hồ sơ nhân sự, theo dõi chức vụ, phòng ban và phân quyền hệ thống">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        /* KPI Stats Cards */
        .emp-stats-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 1rem; margin-bottom: 1.5rem; }
        .emp-stat-card {
            background: #fff;
            border-radius: 14px;
            border: 1.5px solid #f1f5f9;
            padding: 1.15rem 1.3rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            box-shadow: 0 2px 10px rgba(15,23,42,0.04);
            transition: box-shadow 0.2s, transform 0.15s;
            cursor: default;
        }
        .emp-stat-card:hover { box-shadow: 0 6px 24px rgba(37,99,235,0.09); transform: translateY(-2px); }
        .emp-stat-icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0; font-size: 1.4rem;
        }
        .emp-stat-icon.blue  { background: #eff6ff; color: #2563eb; }
        .emp-stat-icon.green { background: #ecfdf5; color: #059669; }
        .emp-stat-icon.amber { background: #fffbeb; color: #d97706; }
        .emp-stat-icon.slate { background: #f1f5f9; color: #64748b; }
        .emp-stat-label { font-size: 0.73rem; font-weight: 700; letter-spacing: 0.5px; color: #94a3b8; text-transform: uppercase; margin-bottom: 2px; }
        .emp-stat-value { font-size: 1.75rem; font-weight: 800; color: #0f172a; line-height: 1; margin-bottom: 2px; }
        .emp-stat-meta { font-size: 0.75rem; color: #64748b; }

        /* Search & Filter Card */
        .filter-card {
            background: #fff;
            border-radius: 14px;
            border: 1.5px solid #f1f5f9;
            padding: 1rem 1.25rem;
            margin-bottom: 1.25rem;
            box-shadow: 0 2px 10px rgba(15,23,42,0.04);
        }
        .filter-search-wrap {
            position: relative;
        }
        .filter-search-wrap .bi-search {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: #94a3b8; font-size: 0.95rem;
        }
        .filter-search-wrap input {
            padding-left: 36px;
            height: 40px;
            border-radius: 9px;
            border: 1.5px solid #e2e8f0;
            font-size: 0.875rem;
            background: #f8fafc;
            transition: all 0.15s;
        }
        .filter-search-wrap input:focus { background: #fff; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.08); }
        .filter-select {
            height: 40px;
            border-radius: 9px;
            border: 1.5px solid #e2e8f0;
            font-size: 0.875rem;
            background: #f8fafc;
            transition: all 0.15s;
        }
        .filter-select:focus { background: #fff; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.08); }
        .btn-filter-primary {
            height: 40px;
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 9px;
            padding: 0 1.1rem;
            font-size: 0.875rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.15s;
        }
        .btn-filter-primary:hover { background: #1d4ed8; transform: translateY(-1px); }
        .btn-filter-reset {
            height: 40px;
            background: #f1f5f9;
            color: #475569;
            border: 1.5px solid #e2e8f0;
            border-radius: 9px;
            padding: 0 1rem;
            font-size: 0.875rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.15s;
            text-decoration: none;
        }
        .btn-filter-reset:hover { background: #e2e8f0; color: #1e293b; }

        /* Table */
        .emp-table-card {
            background: #fff;
            border-radius: 14px;
            border: 1.5px solid #f1f5f9;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(15,23,42,0.04);
        }
        .emp-table { width: 100%; border-collapse: collapse; }
        .emp-table thead { background: #f8fafc; border-bottom: 2px solid #f1f5f9; }
        .emp-table thead th {
            padding: 0.7rem 1rem;
            font-size: 0.73rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: #64748b;
            white-space: nowrap;
        }
        .emp-table tbody tr {
            border-bottom: 1px solid #f8fafc;
            transition: background 0.12s;
        }
        .emp-table tbody tr:hover { background: #f8fafc; }
        .emp-table tbody tr:last-child { border-bottom: none; }
        .emp-table td { padding: 0.75rem 1rem; vertical-align: middle; font-size: 0.875rem; }

        /* Employee avatar cell */
        .emp-avatar-cell { display: flex; align-items: center; gap: 10px; }
        .emp-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.95rem; font-weight: 700; color: #fff; flex-shrink: 0;
            background: linear-gradient(135deg, #2563eb, #60a5fa);
        }
        .emp-avatar.avatar-f { background: linear-gradient(135deg, #ec4899, #f9a8d4); }
        .emp-avatar.avatar-m { background: linear-gradient(135deg, #2563eb, #93c5fd); }
        .emp-name { font-weight: 600; color: #1e293b; font-size: 0.88rem; line-height: 1.2; }
        .emp-type-badge {
            font-size: 0.68rem; color: #64748b;
            background: #f1f5f9;
            border-radius: 4px;
            padding: 1px 6px;
            font-weight: 500;
            margin-top: 2px;
            display: inline-block;
        }
        .emp-code-badge {
            font-family: 'JetBrains Mono', monospace;
            background: #eff6ff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
            border-radius: 6px;
            padding: 2px 8px;
            font-size: 0.78rem;
            font-weight: 700;
        }
        .emp-dept { font-weight: 600; color: #1e293b; }
        .emp-pos { color: #64748b; font-size: 0.82rem; }
        .emp-contact { font-size: 0.82rem; }
        .emp-email { color: #2563eb; font-size: 0.78rem; }
        .emp-phone { color: #1e293b; }

        /* Status pills */
        .status-pill {
            display: inline-flex; align-items: center; gap: 5px;
            border-radius: 999px; padding: 3px 10px;
            font-size: 0.75rem; font-weight: 600; white-space: nowrap;
        }
        .status-pill.active   { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .status-pill.on-leave { background: #fffbeb; color: #d97706; border: 1px solid #fde68a; }
        .status-pill.inactive { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

        /* Action buttons */
        .action-btn-group { display: flex; gap: 4px; justify-content: flex-end; }
        .action-btn {
            width: 32px; height: 32px;
            border-radius: 8px;
            border: 1.5px solid #e2e8f0;
            background: #f8fafc;
            color: #64748b;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 0.85rem;
            transition: all 0.15s;
            text-decoration: none; cursor: pointer;
        }
        .action-btn:hover { background: #eff6ff; border-color: #93c5fd; color: #2563eb; }
        .action-btn.edit:hover { background: #fefce8; border-color: #fde047; color: #ca8a04; }
        .action-btn.del:hover { background: #fef2f2; border-color: #fca5a5; color: #dc2626; }

        /* Action header */
        .page-header-section {
            display: flex; align-items: flex-start; justify-content: space-between;
            flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem;
        }
        .page-header-badge {
            display: inline-flex; align-items: center; gap: 6px;
            background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
            border-radius: 999px; padding: 3px 12px;
            font-size: 0.78rem; font-weight: 700;
            margin-left: 10px; vertical-align: middle;
        }
        .action-bar { display: flex; gap: 8px; align-items: center; }
        .btn-action-outline {
            height: 38px;
            border: 1.5px solid #e2e8f0;
            background: #fff;
            color: #475569;
            border-radius: 9px;
            padding: 0 1rem;
            font-size: 0.84rem;
            font-weight: 500;
            display: inline-flex; align-items: center; gap: 6px;
            transition: all 0.15s; cursor: pointer; text-decoration: none;
        }
        .btn-action-outline:hover { background: #f8fafc; border-color: #cbd5e1; color: #1e293b; }
        .btn-add-emp {
            height: 38px;
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 9px;
            padding: 0 1.1rem;
            font-size: 0.84rem;
            font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px;
            box-shadow: 0 4px 10px rgba(37,99,235,0.22);
            transition: all 0.15s; text-decoration: none;
        }
        .btn-add-emp:hover { background: #1d4ed8; color: #fff; transform: translateY(-1px); box-shadow: 0 6px 16px rgba(37,99,235,0.28); }

        /* Pagination */
        .table-footer-bar {
            padding: 0.85rem 1.25rem;
            border-top: 1px solid #f1f5f9;
            display: flex; align-items: center; justify-content: space-between;
            font-size: 0.82rem;
        }
        .pagination-row { display: flex; gap: 4px; align-items: center; }
        .page-btn {
            width: 30px; height: 30px;
            border-radius: 7px;
            border: 1.5px solid #e2e8f0;
            background: #fff;
            color: #64748b;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 0.82rem; font-weight: 600;
            transition: all 0.15s; text-decoration: none; cursor: pointer;
        }
        .page-btn.active { background: #2563eb; color: #fff; border-color: #2563eb; }
        .page-btn:hover:not(.active) { background: #f1f5f9; color: #1e293b; }

        @media (max-width: 900px) {
            .emp-stats-grid { grid-template-columns: repeat(2,1fr); }
        }
        @media (max-width: 576px) {
            .emp-stats-grid { grid-template-columns: 1fr; }
        }
    </style>
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
                    <a href="#" class="btn-action-outline">
                        <i class="bi bi-file-earmark-excel"></i> Xuất Excel
                    </a>
                    <a href="#" class="btn-action-outline">
                        <i class="bi bi-upload"></i> Nhập từ file
                    </a>
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
                        <c:when test="${param.success eq 'added'}">Thêm nhân viên mới thành công!</c:when>
                        <c:when test="${param.success eq 'updated'}">Cập nhật thông tin nhân viên thành công!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Đã vô hiệu hóa nhân viên thành công.</c:when>
                    </c:choose>
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

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    // Check all rows
    document.getElementById('checkAll').addEventListener('change', function() {
        document.querySelectorAll('.row-check').forEach(cb => cb.checked = this.checked);
    });

    function confirmDelete(btn) {
        const id   = btn.getAttribute('data-id');
        const name = btn.getAttribute('data-name');
        document.getElementById('deleteEmpId').value = id;
        document.getElementById('deleteEmpName').textContent = name;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }
</script>
</body>
</html>
