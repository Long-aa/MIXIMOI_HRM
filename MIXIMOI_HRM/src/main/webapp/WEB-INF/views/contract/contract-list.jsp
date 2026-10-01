<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý hợp đồng lao động — MIXIMOI HRM &amp; PAYROLL</title>
    <meta name="description" content="Quản lý hợp đồng lao động, theo dõi thời hạn, phân loại hợp đồng và tuân thủ Điều 20 Bộ luật Lao động 2019 — MIXIMOI HRM">
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

            <%-- Khai báo quyền hạn một lần duy nhất --%>
            <c:set var="isEmpOnly" value="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}"/>
            <c:set var="canManage" value="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}"/>
            <c:set var="canViewSalary" value="${sessionScope.currentUser.admin or sessionScope.currentUser.hr or sessionScope.currentUser.accountant}"/>
            <c:set var="isAdmin" value="${sessionScope.currentUser.admin}"/>

            <%-- ============================================================
                 1. BANNER DÀNH CHO NHÂN VIÊN (EMPLOYEE ONLY)
                 ============================================================ --%>
            <c:if test="${isEmpOnly}">
                <div class="emp-contract-banner">
                    <div class="emp-contract-banner-icon"><i class="bi bi-person-lines-fill"></i></div>
                    <div>
                        <h1 style="font-size:1.25rem; font-weight:800; color:#0f172a; margin-bottom:4px;">
                            Hợp đồng lao động của tôi
                        </h1>
                        <p style="font-size:0.84rem; color:#475569; margin:0;">
                            Xem thông tin hợp đồng, điều khoản làm việc và chứng thực số cá nhân của bạn
                        </p>
                    </div>
                </div>
            </c:if>

            <%-- ============================================================
                 2. HEADER & KPI CARDS CHO CÁC VAI TRÒ QUẢN LÝ
                 ============================================================ --%>
            <c:if test="${not isEmpOnly}">
                <!-- Page Header Section -->
                <div class="page-header-section">
                    <div>
                        <h1 style="font-size:1.4rem; font-weight:800; color:#0f172a; margin-bottom:4px;">
                            Hợp đồng lao động
                            <span class="page-header-badge">
                                <i class="bi bi-file-earmark-text"></i> ${totalFiltered} hợp đồng
                            </span>
                        </h1>
                        <p style="font-size:0.83rem; color:#64748b; margin:0;">
                            Quản lý hợp đồng lao động, theo dõi thời hạn và kiểm soát tuân thủ Điều 20 Bộ luật Lao động 2019
                        </p>
                    </div>
                    <div class="action-bar">
                        <c:if test="${canManage}">
                            <button type="button" class="btn-add-contract" data-bs-toggle="modal" data-bs-target="#newContractModal">
                                <i class="bi bi-plus-lg"></i> Thêm hợp đồng
                            </button>
                        </c:if>
                        <c:if test="${canViewSalary}">
                            <a href="${pageContext.request.contextPath}/contracts?action=export" class="btn-action-outline">
                                <i class="bi bi-file-earmark-excel text-success"></i> Xuất CSV / Excel
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Glassmorphism Stat Cards -->
                <div class="contract-stats-grid">
                    <div class="contract-stat-card glass-stat-card">
                        <div class="cstat-icon blue"><i class="bi bi-file-earmark-text-fill"></i></div>
                        <div>
                            <div class="cstat-label">Tổng hợp đồng</div>
                            <div class="cstat-value">${totalContracts}</div>
                            <div class="cstat-meta"><span class="text-success fw-bold">● ${activeCount}</span> đang hiệu lực</div>
                        </div>
                    </div>
                    <div class="contract-stat-card glass-stat-card">
                        <div class="cstat-icon violet"><i class="bi bi-infinity"></i></div>
                        <div>
                            <div class="cstat-label">Không xác định TH</div>
                            <div class="cstat-value">${indefiniteCount}</div>
                            <div class="cstat-meta">⟷ Thời hạn lâu dài chính thức</div>
                        </div>
                    </div>
                    <div class="contract-stat-card glass-stat-card">
                        <div class="cstat-icon cyan"><i class="bi bi-calendar-range-fill"></i></div>
                        <div>
                            <div class="cstat-label">Có xác định TH</div>
                            <div class="cstat-value">${fixedCount}</div>
                            <div class="cstat-meta">📅 Tuân thủ tối đa 2 lần (BLLĐ 2019)</div>
                        </div>
                    </div>
                    <div class="contract-stat-card glass-stat-card ${expiringCount > 0 ? 'expiring-alert' : ''}">
                        <div class="cstat-icon amber"><i class="bi bi-clock-history"></i></div>
                        <div>
                            <div class="cstat-label">Sắp hết hạn 30 ngày</div>
                            <div class="cstat-value">${expiringCount}</div>
                            <div class="cstat-meta">
                                <c:choose>
                                    <c:when test="${expiringCount > 0}"><span style="color:#dc2626; font-weight:700;">● Cần tái ký / chuyển đổi</span></c:when>
                                    <c:otherwise><span style="color:#059669; font-weight:600;">✓ Không có HĐ sắp hết hạn</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Expiring Warning Notification Bar -->
                <c:if test="${expiringCount > 0}">
                    <div class="notify-bar">
                        <div class="d-flex align-items-center gap-3">
                            <div class="notify-icon"><i class="bi bi-robot"></i></div>
                            <span>
                                <i class="bi bi-stars text-warning me-1"></i>
                                <strong>Hệ thống tự động cảnh báo:</strong>
                                Có <strong>${expiringCount}</strong> hợp đồng lao động sắp hết hạn trong 30 ngày tới. Vui lòng kiểm tra và xử lý gia hạn hoặc chuyển đổi sang HĐ không xác định thời hạn.
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/contracts?status=EXPIRING_SOON" class="text-primary fw-bold text-decoration-none" style="font-size:0.82rem; white-space:nowrap;">
                            Xem danh sách sắp hết hạn →
                        </a>
                    </div>
                </c:if>

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
                                    <option value="PROBATION" ${contractType eq 'PROBATION' ? 'selected' : ''}>HĐ Thử việc</option>
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
                                    <option value="TERMINATED" ${status eq 'TERMINATED' ? 'selected' : ''}>Đã thanh lý</option>
                                </select>
                            </div>
                            <c:if test="${not empty departments}">
                                <div class="col-md-2">
                                    <select class="form-select filter-select" name="departmentId" id="filterDept">
                                        <option value="">Tất cả phòng ban</option>
                                        <c:forEach var="dept" items="${departments}">
                                            <option value="${dept.id}" ${departmentId == dept.id ? 'selected' : ''}>${dept.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </c:if>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="pageSize" id="filterPageSize" onchange="this.form.submit()">
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 dòng / trang</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 dòng / trang</option>
                                    <option value="100" ${pageSize == 100 ? 'selected' : ''}>100 dòng / trang</option>
                                    <option value="all" ${pageSize >= totalFiltered && totalFiltered > 0 ? 'selected' : ''}>Hiển thị tất cả</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex gap-2">
                                <button type="submit" class="btn-filter-primary flex-fill justify-content-center" id="btnFilter">
                                    <i class="bi bi-funnel-fill"></i> Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/contracts" class="btn-filter-reset" title="Đặt lại bộ lọc" id="btnReset">
                                    <i class="bi bi-arrow-counterclockwise"></i>
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Bulk Actions Toolbar (Admin/HR) -->
                <c:if test="${canManage}">
                    <div id="bulkToolbar" class="d-none align-items-center gap-2 mb-2 px-3 py-2"
                         style="background:linear-gradient(90deg,#eff6ff,#f0fdf4); border-radius:10px; border:1px solid #bfdbfe; flex-wrap:wrap;">
                        <span style="font-size:0.83rem; color:#1e40af; font-weight:700;">
                            <i class="bi bi-check2-square me-1"></i>
                            Đã chọn <strong id="bulkCount">0</strong> hợp đồng
                        </span>
                        <div class="d-flex gap-2 ms-auto">
                            <c:if test="${isAdmin}">
                                <button type="button" class="btn btn-sm btn-danger px-3" onclick="bulkDelete()"
                                        style="border-radius:8px; font-weight:600; font-size:0.8rem;">
                                    <i class="bi bi-trash me-1"></i> Xóa hàng loạt
                                </button>
                            </c:if>
                            <button type="button" class="btn btn-sm btn-success px-3" onclick="bulkExport()"
                                    style="border-radius:8px; font-weight:600; font-size:0.8rem;">
                                <i class="bi bi-file-earmark-excel me-1"></i> Xuất danh sách chọn
                            </button>
                            <button type="button" class="btn btn-sm btn-light px-3" onclick="clearContractSelection()"
                                    style="border-radius:8px; font-size:0.8rem;">
                                <i class="bi bi-x-lg me-1"></i> Bỏ chọn
                            </button>
                        </div>
                    </div>
                </c:if>
            </c:if>

            <%-- ============================================================
                 3. BẢNG DANH SÁCH HỢP ĐỒNG ĐỒNG BỘ TOÀN HỆ THỐNG
                 ============================================================ --%>
            <div class="contract-table-card">
                <div class="table-responsive">
                    <table class="contract-table" id="contractTable">
                        <thead>
                            <tr>
                                <c:if test="${not isEmpOnly}">
                                    <th style="width:42px; padding-left:1.25rem;">
                                        <input type="checkbox" id="checkAll" class="form-check-input" style="width:15px;height:15px;">
                                    </th>
                                </c:if>
                                <th class="${isEmpOnly ? 'ps-4' : ''}">Số HĐ</th>
                                <c:if test="${not isEmpOnly}">
                                    <th>Nhân viên</th>
                                </c:if>
                                <th>Loại hợp đồng &amp; Tuân thủ luật</th>
                                <th>Thời hạn HĐ</th>
                                <c:if test="${canViewSalary}">
                                    <th class="text-end">Mức lương HĐ</th>
                                </c:if>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center">File</th>
                                <c:if test="${isEmpOnly}">
                                    <th>Ghi chú</th>
                                </c:if>
                                <th style="padding-right:1.25rem; text-align:center;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty contracts}">
                                    <tr id="emptyRow">
                                        <td colspan="${isEmpOnly ? 6 : (canViewSalary ? 9 : 8)}" class="text-center text-muted py-5">
                                            <i class="bi bi-file-earmark-text" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i>
                                            <div style="font-weight:600; font-size:0.95rem; color:#64748b;">Chưa có hợp đồng nào phù hợp</div>
                                            <c:if test="${canManage}">
                                                <div style="font-size:0.82rem; margin-top:4px;">
                                                    <a href="#" class="text-primary" data-bs-toggle="modal" data-bs-target="#newContractModal">Tạo hợp đồng mới →</a>
                                                </div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${contracts}">
                                        <c:set var="fixedCountForEmp" value="${fixedTermCountMap[c.employeeId] != null ? fixedTermCountMap[c.employeeId] : 0}"/>
                                        <tr class="contract-row ${c.status eq 'EXPIRING_SOON' ? 'row-expiring' : c.status eq 'EXPIRED' ? 'row-expired' : ''}"
                                            data-keyword="${fn:toLowerCase(c.contractCode)} ${fn:toLowerCase(c.employeeName)} ${fn:toLowerCase(c.employeeCode)}"
                                            data-type="${c.contractType}"
                                            data-status="${c.status}"
                                            data-dept="${not empty c.departmentName ? fn:toLowerCase(c.departmentName) : ''}"
                                            data-id="${c.id}">
                                            
                                            <c:if test="${not isEmpOnly}">
                                                <td style="padding-left:1.25rem;">
                                                    <input type="checkbox" class="form-check-input row-check" value="${c.id}" style="width:15px;height:15px;">
                                                </td>
                                            </c:if>

                                            <td class="${isEmpOnly ? 'ps-4' : ''}">
                                                <a href="${pageContext.request.contextPath}/contracts?action=view&id=${c.id}" class="contract-code-badge">${c.contractCode}</a>
                                            </td>

                                            <c:if test="${not isEmpOnly}">
                                                <td>
                                                    <div class="emp-cell">
                                                        <div class="emp-avatar gen-n">${c.employeeName != null ? c.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                                        <div>
                                                            <div class="emp-name">${c.employeeName}</div>
                                                            <div class="emp-code">${c.employeeCode} · ${not empty c.departmentName ? c.departmentName : 'Chưa phân bổ'}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </c:if>

                                            <td>
                                                <div class="d-flex flex-column align-items-start gap-1">
                                                    <c:choose>
                                                        <c:when test="${c.contractType eq 'INDEFINITE'}">
                                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">Không xác định thời hạn</span>
                                                            <span class="law-badge indefinite"><i class="bi bi-shield-check"></i> Vô thời hạn chuẩn luật</span>
                                                        </c:when>
                                                        <c:when test="${c.contractType eq 'FIXED_TERM'}">
                                                            <span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">Xác định thời hạn</span>
                                                            <c:choose>
                                                                <c:when test="${fixedCountForEmp >= 2}">
                                                                    <span class="law-badge term-limit" title="Đã ký tối đa 2 lần HĐ có thời hạn theo Điều 20 BLLĐ 2019">
                                                                        <i class="bi bi-exclamation-octagon-fill"></i> Lần ${fixedCountForEmp}/2 (Cần chuyển Vô TH)
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${fixedCountForEmp == 1}">
                                                                    <span class="law-badge term-2" title="Đã ký 1 lần HĐ xác định thời hạn">
                                                                        <i class="bi bi-info-circle"></i> Lần 1/2 (Được ký thêm 1 lần)
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="law-badge term-1">
                                                                        <i class="bi bi-check-circle"></i> Lần 1/2
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:when test="${c.contractType eq 'PROBATION'}">
                                                            <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">Hợp đồng thử việc</span>
                                                        </c:when>
                                                        <c:when test="${c.contractType eq 'SEASONAL'}">
                                                            <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">Thời vụ</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Cộng tác viên</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
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

                                            <c:if test="${canViewSalary}">
                                                <td class="text-end">
                                                    <span class="salary-display">
                                                        <fmt:formatNumber value="${c.baseSalary}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                    </span>
                                                </td>
                                            </c:if>

                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${c.status eq 'ACTIVE'}">
                                                        <span class="status-pill active"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Còn hiệu lực</span>
                                                    </c:when>
                                                    <c:when test="${c.status eq 'EXPIRING_SOON'}">
                                                        <span class="status-pill expiring"><i class="bi bi-exclamation-circle-fill"></i> Sắp hết hạn</span>
                                                    </c:when>
                                                    <c:when test="${c.status eq 'TERMINATED'}">
                                                        <span class="status-pill terminated"><i class="bi bi-dash-circle-fill"></i> Đã thanh lý</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill expired"><i class="bi bi-x-circle-fill"></i> Hết hạn</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${not empty c.contractFileUrl}">
                                                        <a href="${pageContext.request.contextPath}${c.contractFileUrl}" target="_blank" class="action-btn" title="Tải file HĐ" style="color:#dc2626; border-color:#fca5a5; background:#fef2f2;">
                                                            <i class="bi bi-file-pdf"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted" style="font-size:0.8rem;">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <c:if test="${isEmpOnly}">
                                                <td>
                                                    <span class="text-muted" style="font-size:0.82rem;">${not empty c.notes ? c.notes : '—'}</span>
                                                </td>
                                            </c:if>

                                            <td style="padding-right:1.25rem; text-align:center;">
                                                <div class="action-btn-group justify-content-center">
                                                    <!-- Xem chi tiết -->
                                                    <a href="${pageContext.request.contextPath}/contracts?action=view&id=${c.id}" class="action-btn" title="Xem chi tiết">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    
                                                    <!-- In hợp đồng chuẩn pháp lý -->
                                                    <a href="${pageContext.request.contextPath}/contracts?action=print&id=${c.id}" class="action-btn print" title="In hợp đồng & Dấu số">
                                                        <i class="bi bi-printer"></i>
                                                    </a>

                                                    <!-- Thao tác chỉ dành cho HR & Admin -->
                                                    <c:if test="${canManage}">
                                                        <c:if test="${empty c.signedDate or c.status ne 'ACTIVE'}">
                                                            <a href="${pageContext.request.contextPath}/contracts?action=sign&id=${c.id}" class="action-btn sign" title="Ký chính thức hợp đồng">
                                                                <i class="bi bi-pen"></i>
                                                            </a>
                                                        </c:if>

                                                        <!-- 1-Click Chuyển sang HĐ chính thức nếu là Thử việc -->
                                                        <c:if test="${c.contractType eq 'PROBATION' or fn:contains(fn:toLowerCase(c.notes), 'thử việc')}">
                                                            <button type="button" class="action-btn probation" title="Chuyển HĐ Thử việc lên HĐ Chính thức"
                                                                    data-id="${c.id}"
                                                                    data-code="${c.contractCode}"
                                                                    data-name="${c.employeeName}"
                                                                    data-salary="${c.baseSalary}"
                                                                    onclick="openTransitionProbationModal(this)">
                                                                <i class="bi bi-award-fill"></i>
                                                            </button>
                                                        </c:if>

                                                        <!-- Chỉnh sửa -->
                                                        <button type="button" class="action-btn edit" title="Chỉnh sửa hợp đồng"
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

                                                        <c:if test="${c.status ne 'TERMINATED'}">
                                                            <!-- Gia hạn HĐ -->
                                                            <button type="button" class="action-btn" title="Gia hạn hợp đồng"
                                                                    data-id="${c.id}"
                                                                    data-code="${c.contractCode}"
                                                                    data-end="${c.endDate}"
                                                                    data-salary="${c.baseSalary}"
                                                                    onclick="openRenewModal(this)"
                                                                    style="color:#d97706; border-color:#fde68a; background:#fffbeb;">
                                                                <i class="bi bi-arrow-repeat"></i>
                                                            </button>
                                                            <!-- Thanh lý HĐ -->
                                                            <button type="button" class="action-btn" title="Thanh lý hợp đồng"
                                                                    data-id="${c.id}"
                                                                    data-code="${c.contractCode}"
                                                                    onclick="openTerminateModal(this)"
                                                                    style="color:#dc2626; border-color:#fca5a5; background:#fef2f2;">
                                                                <i class="bi bi-slash-circle"></i>
                                                            </button>
                                                        </c:if>

                                                        <!-- Xóa hợp đồng (Admin only) -->
                                                        <c:if test="${isAdmin}">
                                                            <button type="button" class="action-btn del"
                                                                    title="Xóa hợp đồng"
                                                                    data-id="${c.id}"
                                                                    data-code="${c.contractCode}"
                                                                    onclick="confirmDeleteContract(this)">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </c:if>
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

                <!-- Table Footer & Pagination -->
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

        </div><!-- end app-content -->
    </main>
</div>

<%-- ============================================================
     MODALS QUẢN TRỊ (ADMIN & HR ONLY)
     ============================================================ --%>
<c:if test="${canManage}">

<!-- Modal: Tạo hợp đồng mới -->
<div class="modal fade" id="newContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/contracts" class="needs-validation" novalidate id="contractForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="modal-header border-0" style="background: linear-gradient(135deg, #eff6ff, #f0fdf4); padding:1.25rem 1.5rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-file-earmark-plus-fill text-primary" style="font-size:1.1rem;"></i>
                            Tạo hợp đồng lao động mới
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Hệ thống tự động kiểm soát Điều 20 Bộ luật Lao động 2019</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <!-- Dynamic Legal Notice Box -->
                    <div id="newContractLawAlert" class="alert alert-info py-2 px-3 mb-3 d-flex align-items-center gap-2" style="font-size:0.83rem;">
                        <i class="bi bi-info-circle-fill fs-5 text-primary flex-shrink-0"></i>
                        <div>Chọn nhân viên để xem số lần ký hợp đồng và kiểm soát quy định pháp lý Điều 20 BLLĐ 2019.</div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Số hợp đồng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control font-monospace" name="contractCode" required
                                   value="${nextContractCode}" placeholder="VD: HD047" style="border-radius:9px; font-size:0.875rem;">
                            <div class="invalid-feedback">Vui lòng nhập số hợp đồng</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Nhân viên ký kết <span class="text-danger">*</span></label>
                            <select class="form-select" name="employeeId" required id="newContractEmpSelect" style="border-radius:9px; font-size:0.875rem;">
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="emp" items="${employees}">
                                    <c:set var="fc" value="${fixedTermCountMap[emp.id] != null ? fixedTermCountMap[emp.id] : 0}"/>
                                    <option value="${emp.id}" data-fixed-count="${fc}">
                                        ${emp.fullName} (${emp.employeeCode}) — Đã ký ${fc}/2 HĐ có thời hạn
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn nhân viên</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Loại hợp đồng <span class="text-danger">*</span></label>
                            <select class="form-select" name="contractType" required id="contractTypeSelect" style="border-radius:9px; font-size:0.875rem;" onchange="toggleEndDate(this.value)">
                                <option value="INDEFINITE">Không xác định thời hạn (Lâu dài)</option>
                                <option value="FIXED_TERM">Xác định thời hạn (1 - 3 năm)</option>
                                <option value="PROBATION">Hợp đồng thử việc (1 - 2 tháng)</option>
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
                            <small class="text-muted" style="font-size:0.75rem;">Tự động khóa nếu chọn Không xác định thời hạn</small>
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
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">File văn bản hợp đồng (PDF)</label>
                            <input type="file" class="form-control" name="contractFile" accept=".pdf,.doc,.docx" style="border-radius:9px; font-size:0.875rem;">
                            <small class="text-muted" style="font-size:0.75rem;">Hỗ trợ PDF, DOC, DOCX. Tối đa 10MB</small>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ghi chú / Điều khoản bổ sung</label>
                            <textarea class="form-control" name="notes" rows="2"
                                      placeholder="Phụ lục hợp đồng, điều khoản đãi ngộ, chế độ đặc thù..."
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

<!-- Modal: Chỉnh sửa HĐ -->
<div class="modal fade" id="editContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/contracts" class="needs-validation" novalidate id="editContractForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editContractId">

                <div class="modal-header border-0" style="background: linear-gradient(135deg, #eff6ff, #fefce8); padding:1.25rem 1.5rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-pencil-square text-primary" style="font-size:1.1rem;"></i>
                            Cập nhật hợp đồng lao động
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Điều chỉnh thời hạn, mức lương hoặc điều khoản hợp đồng</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Số hợp đồng</label>
                            <input type="text" class="form-control font-monospace" name="contractCode" id="editContractCode" readonly
                                   style="border-radius:9px; font-size:0.875rem; background:#f8fafc;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Loại hợp đồng <span class="text-danger">*</span></label>
                            <select class="form-select" name="contractType" required id="editContractTypeSelect" style="border-radius:9px; font-size:0.875rem;" onchange="toggleEndDate(this.value, 'Edit')">
                                <option value="INDEFINITE">Không xác định thời hạn</option>
                                <option value="FIXED_TERM">Xác định thời hạn (1 - 3 năm)</option>
                                <option value="PROBATION">Hợp đồng thử việc</option>
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

<!-- Modal: Gia hạn HĐ -->
<div class="modal fade" id="renewContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:500px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/contracts">
                <input type="hidden" name="action" value="renew">
                <input type="hidden" name="id" id="renewContractId">

                <div class="modal-header border-0" style="background:linear-gradient(135deg, #eff6ff, #fffbeb); padding:1.25rem 1.5rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-arrow-repeat text-warning" style="font-size:1.1rem;"></i>
                            Gia hạn hợp đồng lao động
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Hợp đồng: <strong id="renewContractCode" class="text-primary font-monospace"></strong></p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ngày kết thúc mới <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="endDate" id="renewEndDate" required style="border-radius:9px; font-size:0.875rem;">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Mức lương mới (VNĐ) <small class="text-muted">(Để trống nếu giữ nguyên)</small></label>
                            <input type="number" class="form-control" name="baseSalary" id="renewSalary" min="0" step="500000" style="border-radius:9px; font-size:0.875rem;">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ghi chú gia hạn</label>
                            <textarea class="form-control" name="notes" rows="2" placeholder="VD: Tái ký hợp đồng tiếp theo theo thỏa thuận..." style="border-radius:9px; font-size:0.875rem;"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pb-4 gap-2" style="background:#f8fafc;">
                    <button type="button" class="btn btn-light px-3" data-bs-dismiss="modal" style="border-radius:8px;">Hủy</button>
                    <button type="submit" class="btn btn-warning px-4 fw-semibold text-dark" style="border-radius:8px;">
                        <i class="bi bi-check2-circle me-1"></i> Xác nhận gia hạn
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Chuyển HĐ Thử việc lên Chính thức (1-Click) -->
<div class="modal fade" id="transitionProbationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:520px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/contracts">
                <input type="hidden" name="action" value="transition_probation">
                <input type="hidden" name="id" id="transProbationId">

                <div class="modal-header border-0" style="background:linear-gradient(135deg, #f0fdf4, #eff6ff); padding:1.25rem 1.5rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-success d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-award-fill"></i>
                            Chuyển sang Hợp đồng Chính thức
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Hợp đồng thử việc: <strong id="transProbationCode" class="text-dark font-monospace"></strong></p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="p-3 mb-3 rounded" style="background:#f0fdf4; border:1px solid #bbf7d0; font-size:0.84rem; color:#166534;">
                        <i class="bi bi-check-circle-fill me-1"></i>
                        Nhân viên <strong id="transProbationName"></strong> đã hoàn thành giai đoạn thử việc. Hệ thống sẽ thanh lý hợp đồng thử việc và tự động phát hành <strong>Hợp đồng lao động chính thức</strong> (Thời hạn 01 năm hoặc Không thời hạn theo Điều 20 BLLĐ 2019).
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Mức lương chính thức (100%) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="baseSalary" id="transProbationSalary" required min="0" step="500000" style="border-radius:9px; font-size:0.875rem;">
                        <small class="text-muted" style="font-size:0.75rem;">Hệ thống đã tự động quy đổi từ 85% lương thử việc lên 100%.</small>
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pb-4 gap-2" style="background:#f8fafc;">
                    <button type="button" class="btn btn-light px-3" data-bs-dismiss="modal" style="border-radius:8px;">Hủy bỏ</button>
                    <button type="submit" class="btn btn-success px-4 fw-semibold" style="border-radius:8px;">
                        <i class="bi bi-check2-all me-1"></i> Phê duyệt chuyển chính thức
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Thanh lý HĐ -->
<div class="modal fade" id="terminateContractModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:450px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/contracts">
                <input type="hidden" name="action" value="terminate">
                <input type="hidden" name="id" id="terminateContractId">

                <div class="modal-header border-0" style="background:#fef2f2; padding:1.25rem 1.5rem 0.75rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-slash-circle"></i> Thanh lý / Chấm dứt hợp đồng
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Hợp đồng: <strong id="terminateContractCode" class="text-dark font-monospace"></strong></p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Lý do thanh lý / chấm dứt <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="reason" rows="3" required placeholder="VD: Hết hạn hợp đồng, Thỏa thuận chấm dứt HĐLĐ, Nhân viên chuyển công tác..." style="border-radius:9px; font-size:0.875rem;"></textarea>
                    </div>
                    <div class="p-2 rounded" style="background:#f8fafc; font-size:0.8rem; color:#64748b;">
                        <i class="bi bi-info-circle me-1"></i> Trạng thái hợp đồng sẽ chuyển sang <strong>Đã thanh lý</strong>.
                    </div>
                </div>
                <div class="modal-footer border-0 px-4 pt-0 pb-4 gap-2">
                    <button type="button" class="btn btn-light btn-sm px-3" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-danger btn-sm px-4 fw-semibold">
                        <i class="bi bi-slash-circle me-1"></i> Xác nhận thanh lý
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Xóa HĐ (Admin only) -->
<c:if test="${isAdmin}">
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
                Bạn có chắc muốn xóa hợp đồng <strong id="deleteContractCode" class="text-dark font-monospace"></strong>?
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
</c:if>

</c:if>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- External Contract Scripts -->
<script src="${pageContext.request.contextPath}/assets/js/contract.js"></script>

</body>
</html>
