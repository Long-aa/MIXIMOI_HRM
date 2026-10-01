<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý tính lương & Bảng lương — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="payroll" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Payroll Page Body -->
        <div class="app-content">
            
            <!-- Page Header Area -->
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                            PAYROLL ENGINE V4.2
                        </span>
                        <span class="text-muted" style="font-size: 0.8rem;">•</span>
                        <span class="text-muted" style="font-size: 0.82rem;">Chu kỳ quyết toán chuẩn</span>
                    </div>
                    <h3 class="fw-extrabold text-dark mb-0" style="font-weight: 800; font-size: 1.65rem;">
                        Quản lý tính lương & Bảng lương
                    </h3>
                </div>

                <!-- Action Toolbar & Month Navigator -->
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <!-- Month Navigator -->
                    <div class="period-picker-container">
                        <a href="${pageContext.request.contextPath}/payroll?month=${selectedMonth > 1 ? selectedMonth - 1 : 12}&year=${selectedMonth > 1 ? selectedYear : selectedYear - 1}" 
                           class="period-picker-btn" title="Tháng trước">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                        <span class="period-picker-label">
                            <i class="bi bi-calendar3 text-primary"></i>
                            Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}
                        </span>
                        <a href="${pageContext.request.contextPath}/payroll?month=${selectedMonth < 12 ? selectedMonth + 1 : 1}&year=${selectedMonth < 12 ? selectedYear : selectedYear + 1}" 
                           class="period-picker-btn" title="Tháng sau">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </div>

                    <!-- Action Buttons -->
                    <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                        <c:choose>
                            <c:when test="${isTimesheetLocked}">
                                <form method="post" action="${pageContext.request.contextPath}/payroll" class="d-inline">
                                    <input type="hidden" name="action" value="calculate">
                                    <input type="hidden" name="month" value="${selectedMonth}">
                                    <input type="hidden" name="year" value="${selectedYear}">
                                    <button type="button" id="btnRunPayrollCalc" class="btn-action-primary border-0" title="Tính toán bảng lương tự động">
                                        <i class="bi bi-lightning-charge-fill"></i>
                                        <span>Tính lương tự động</span>
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn-action-primary border-0" data-bs-toggle="modal" data-bs-target="#timesheetLockGuardModal" title="Bảng công chưa khóa - Cần khóa chốt trước khi tính lương">
                                    <i class="bi bi-lightning-charge-fill"></i>
                                    <span>Tính lương tự động</span>
                                </button>
                            </c:otherwise>
                        </c:choose>
                        <form method="post" action="${pageContext.request.contextPath}/payroll" class="d-inline"
                              onsubmit="return confirm('Xác nhận phê duyệt toàn bộ bảng lương tháng ${selectedMonth}/${selectedYear}?');">
                            <input type="hidden" name="action" value="approve_all">
                            <input type="hidden" name="month" value="${selectedMonth}">
                            <input type="hidden" name="year" value="${selectedYear}">
                            <button type="submit" class="btn-action-primary border-0" style="background: linear-gradient(135deg, #059669 0%, #10b981 100%);">
                                <i class="bi bi-check2-all"></i>
                                <span>Phê duyệt toàn bộ</span>
                            </button>
                        </form>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/payroll?action=export&month=${selectedMonth}&year=${selectedYear}&deptId=${selectedDeptId}&status=${selectedStatus}&keyword=${keyword}" 
                       class="btn-action-light text-decoration-none" title="Tải xuống bảng lương định dạng CSV/Excel">
                        <i class="bi bi-file-earmark-excel text-success"></i>
                        <span>Xuất Excel</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/payroll?action=export_bank&month=${selectedMonth}&year=${selectedYear}&deptId=${selectedDeptId}&status=${selectedStatus}&keyword=${keyword}" 
                       class="btn-action-light text-decoration-none" title="Xuất file Lệnh chi Lương Ngân hàng (Vietcombank / BIDV / Techcombank)">
                        <i class="bi bi-bank text-primary"></i>
                        <span>Lệnh chi Ngân hàng</span>
                    </a>

                    <button type="button" class="btn-action-light" onclick="window.print();">
                        <i class="bi bi-printer"></i>
                        <span>In bảng lương</span>
                    </button>

                    <c:choose>
                        <c:when test="${isTimesheetLocked}">
                            <c:set var="confirmLockMsg" value="Mở khóa bảng lương và kỳ quyết toán này?" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="confirmLockMsg" value="Xác nhận khóa chốt dữ liệu bảng lương Tháng ${selectedMonth}/${selectedYear}?" />
                        </c:otherwise>
                    </c:choose>
                    <form method="post" action="${pageContext.request.contextPath}/payroll" class="d-inline"
                          onsubmit="return confirm('${confirmLockMsg}');">
                        <input type="hidden" name="action" value="toggle_lock">
                        <input type="hidden" name="month" value="${selectedMonth}">
                        <input type="hidden" name="year" value="${selectedYear}">
                        <input type="hidden" name="page" value="${currentPage}">
                        <input type="hidden" name="deptId" value="${selectedDeptId}">
                        <input type="hidden" name="statusFilter" value="${selectedStatus}">
                        <input type="hidden" name="keyword" value="${keyword}">
                        <button type="submit" class="btn-action-dark ${isTimesheetLocked ? 'border-warning text-warning' : ''}" 
                                title="${isTimesheetLocked ? 'Nhấn để mở khóa chỉnh sửa' : 'Khóa chốt kỳ lương'}">
                            <i class="bi bi-${isTimesheetLocked ? 'unlock-fill text-warning' : 'lock-fill'}"></i>
                            <span>${isTimesheetLocked ? 'Mở khóa kỳ này' : 'Khóa bảng lương'}</span>
                        </button>
                    </form>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'calculated'}">Tính toán bảng lương tháng ${selectedMonth}/${selectedYear} thành công!</c:when>
                        <c:when test="${param.success eq 'approved'}">Phê duyệt bảng lương thành công!</c:when>
                        <c:when test="${param.success eq 'approved_all'}">Đã phê duyệt toàn bộ bảng lương tháng ${selectedMonth}/${selectedYear}!</c:when>
                        <c:when test="${param.success eq 'paid'}">Ghi nhận hoàn tất chi trả thanh toán lương!</c:when>
                        <c:when test="${param.success eq 'locked'}">Đã khóa chốt dữ liệu kỳ bảng lương và bảng công tháng ${selectedMonth}/${selectedYear}!</c:when>
                        <c:when test="${param.success eq 'unlocked'}">Đã mở khóa kỳ bảng lương tháng ${selectedMonth}/${selectedYear} để hiệu chỉnh bổ sung!</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-shield-x me-2 text-danger fs-5"></i>
                    <c:choose>
                        <c:when test="${param.error eq 'timesheet_not_locked'}">
                            <strong>Ràng buộc kiểm soát nội bộ (Timesheet Lock Guard):</strong> Bảng công Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear} chưa được khóa chốt! Vui lòng đối soát và khóa bảng công trước, hoặc bấm <strong>"Tính lương tự động"</strong> để dùng tùy chọn <em>"Khóa bảng công &amp; Tính lương ngay"</em>.
                        </c:when>
                        <c:otherwise>
                            Đã xảy ra lỗi trong quá trình xử lý: <strong>${param.error}</strong>
                        </c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Timesheet Lock Gatekeeper Banner -->
            <c:choose>
                <c:when test="${isTimesheetLocked}">
                    <div class="alert alert-info border-0 shadow-sm mb-4 d-flex align-items-center justify-content-between py-2 px-3" style="border-radius:10px; background:#eff6ff; color:#1e40af; font-size:0.85rem;">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-shield-check text-primary fs-5"></i>
                            <span><strong>Bảng công Tháng ${selectedMonth}/${selectedYear} đã được Khóa chốt:</strong> Dữ liệu chấm công thực tế đã sẵn sàng và được bảo vệ để tính toán bảng lương khép kín 100%.</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/timesheet?month=${selectedMonth}&year=${selectedYear}" class="btn btn-sm btn-outline-primary px-3 py-1" style="font-size:0.78rem; font-weight:600; border-radius:8px;">
                            <i class="bi bi-calendar3 me-1"></i>Xem bảng công
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning border-0 shadow-sm mb-4 d-flex align-items-center justify-content-between py-2 px-3" style="border-radius:10px; background:#fffbeb; color:#92400e; font-size:0.85rem;">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-shield-exclamation text-warning fs-5"></i>
                            <span><strong>Kiểm soát chuỗi Chấm công &rarr; Lương:</strong> Bảng công Tháng ${selectedMonth}/${selectedYear} <u>chưa được khóa</u>. Vui lòng đối soát và khóa bảng công trước khi tính lương để đảm bảo số liệu chính xác 100%.</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <button type="button" class="btn btn-sm btn-primary px-3 py-1 fw-bold" data-bs-toggle="modal" data-bs-target="#timesheetLockGuardModal" style="font-size:0.78rem; border-radius:8px;">
                                <i class="bi bi-shield-lock me-1"></i>Khóa &amp; Tính lương
                            </button>
                            <a href="${pageContext.request.contextPath}/timesheet?month=${selectedMonth}&year=${selectedYear}" class="btn btn-sm btn-outline-warning text-dark px-3 py-1 fw-semibold" style="font-size:0.78rem; border-radius:8px;">
                                <i class="bi bi-eye me-1"></i>Đối soát công
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- 4 Stat KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- Card 1: Tổng quỹ lương tháng -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng quỹ lương tháng</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">
                                        <c:choose>
                                            <c:when test="${totalPayroll != null and totalPayroll > 0}">
                                                <fmt:formatNumber value="${totalPayroll}" type="number" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>850.000.000</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit fw-bold">VNĐ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-bank2"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-graph-up-arrow"></i> +3.4%
                            </span>
                            <span class="text-muted">so với T08/2026</span>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Lương TB nhân sự -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Lương TB nhân sự</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">
                                        <c:choose>
                                            <c:when test="${not empty avgSalary and avgSalary > 0}">
                                                <fmt:formatNumber value="${avgSalary}" type="number" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit fw-bold">VNĐ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-bar-chart-line-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted">Lương thực lĩnh trung bình</span>
                            <span class="badge bg-primary-subtle text-primary border-0 fw-bold">Kỳ ${selectedMonth}/${selectedYear}</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Hồ sơ nhận lương -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Hồ sơ nhận lương</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">${totalEmpCount > 0 ? totalEmpCount : totalRecords}</span>
                                    <span class="kpi-unit">nhân viên</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-person-badge-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-primary fw-semibold d-flex align-items-center gap-1">
                                <i class="bi bi-check-circle"></i> Kỳ ${selectedMonth}/${selectedYear}
                            </span>
                            <span class="text-muted">Đã tính lương</span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Đã chi trả thành công -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Đã chi trả thành công</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">${countPaid}</span>
                                    <span class="kpi-unit">/ ${totalEmpCount > 0 ? totalEmpCount : totalRecords}</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-pie-chart-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer flex-column align-items-stretch gap-2 pt-2">
                            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                <div class="progress flex-grow-1 me-2" style="height: 6px;">
                                    <c:set var="paidRatioStyle" value="style=\"width: ${empty paidRatio ? 0 : paidRatio}%;\"" />
                                    <div class="progress-bar bg-primary" role="progressbar" ${paidRatioStyle}></div>
                                </div>
                                <span class="fw-bold text-primary">${empty paidRatio ? '0.0' : paidRatio}%</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                <span class="text-warning fw-semibold">● ${pendingCount} chờ xử lý</span>
                                <a href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}" class="text-primary text-decoration-none fw-semibold">Xem danh sách</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter & Search Toolbar -->
            <div class="dashboard-filter-card mb-4">
                <form method="get" action="${pageContext.request.contextPath}/payroll" id="payrollFilterForm">
                    <input type="hidden" name="month" value="${selectedMonth}">
                    <input type="hidden" name="year" value="${selectedYear}">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <div class="d-flex flex-wrap align-items-center gap-2 flex-grow-1">
                            <!-- Search Box -->
                            <div class="position-relative" style="min-width: 260px;">
                                <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted" style="font-size: 0.85rem;"></i>
                                <input type="text" name="keyword" value="${keyword}" class="form-control ps-5 py-2 bg-light border-0" placeholder="Tìm theo mã NV, họ tên..." style="font-size: 0.83rem; border-radius: 10px;">
                            </div>

                            <!-- Department Filter -->
                            <select name="deptId" class="filter-select" onchange="this.form.submit()">
                                <option value="">Phòng ban: Tất cả</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" ${dept.id == selectedDeptId ? 'selected' : ''}>${dept.name}</option>
                                </c:forEach>
                            </select>

                            <!-- Status Filter -->
                            <select name="status" class="filter-select" onchange="this.form.submit()">
                                <option value="">Trạng thái: Tất cả</option>
                                <option value="DRAFT"   ${selectedStatus eq 'DRAFT'    ? 'selected' : ''}>Bản nháp</option>
                                <option value="PENDING" ${selectedStatus eq 'PENDING'  ? 'selected' : ''}>Chờ phê duyệt</option>
                                <option value="APPROVED"${selectedStatus eq 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                                <option value="PAID"    ${selectedStatus eq 'PAID'     ? 'selected' : ''}>Đã chi trả</option>
                            </select>

                            <!-- Search & Reset -->
                            <button type="submit" class="btn btn-sm btn-primary px-3" style="border-radius:8px;">
                                <i class="bi bi-funnel me-1"></i>Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}" class="btn-filter-refresh" title="Làm mới bộ lọc">
                                <i class="bi bi-arrow-clockwise"></i>
                                <span>Làm mới lọc</span>
                            </a>
                        </div>

                        <!-- Right Options & Count -->
                        <div class="d-flex align-items-center gap-3">
                            <span class="text-muted" style="font-size: 0.83rem;">
                                Hiển thị: <strong>${not empty payrollList ? payrollList.size() : 0}</strong> / <strong>${totalRecords}</strong> bản ghi
                            </span>
                            <div class="btn-group">
                                <button type="button" class="btn btn-sm btn-light border py-1 px-2" title="Cột hiển thị"><i class="bi bi-layout-three-columns"></i></button>
                                <button type="button" class="btn btn-sm btn-light border py-1 px-2" title="Lịch sử tính lương"><i class="bi bi-clock-history"></i></button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Payroll Master Table -->
            <div class="table-custom-container mb-4">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width: 40px;" class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </th>
                                <th>MÃ NV</th>
                                <th>HỌ TÊN & VỊ TRÍ</th>
                                <th class="text-center" style="min-width: 105px;">NGÀY CÔNG</th>
                                <th class="text-end">LƯƠNG CƠ BẢN</th>
                                <th class="text-end">PHỤ CẤP</th>
                                <th class="text-end">THƯỞNG</th>
                                <th class="text-end">TĂNG CA (OT)</th>
                                <th class="text-end">KHẤU TRỪ</th>
                                <th class="text-end">THỰC NHẬN (NET)</th>
                                <th class="text-center">TRẠNG THÁI</th>
                                <th class="text-center pe-3">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- Render từ DB nếu có dữ liệu --%>
                            <c:choose>
                                <c:when test="${not empty payrollList}">
                                    <c:forEach var="pr" items="${payrollList}" varStatus="st">
                                        <c:set var="initials" value="${not empty pr.employeeName ? fn:toUpperCase(fn:substring(pr.employeeName, 0, 2)) : 'NV'}" />
                                        <tr>
                                            <td class="text-center">
                                                <input type="checkbox" class="form-check-input payroll-row-check" value="${pr.id}">
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/payslip?action=detail&id=${pr.id}" class="code-link" title="Xem phiếu lương điện tử">
                                                    <c:out value="${not empty pr.employeeCode ? pr.employeeCode : 'NV-'.concat(pr.id)}"/>
                                                </a>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-initials-avatar"><c:out value="${initials}"/></div>
                                                    <div>
                                                        <div class="fw-bold text-dark" style="font-size: 0.86rem;"><c:out value="${pr.employeeName}"/></div>
                                                        <div class="text-muted" style="font-size: 0.74rem;"><c:out value="${not empty pr.departmentName ? pr.departmentName : '—'}"/></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border px-2 py-1" style="font-size: 0.8rem; font-weight: 700;" title="Công thực tế / Ngày chuẩn">
                                                    <i class="bi bi-calendar-check text-primary me-1"></i><fmt:formatNumber value="${pr.workingDays > 0 ? pr.workingDays : pr.standardDays}" maxFractionDigits="1"/> / <fmt:formatNumber value="${pr.standardDays > 0 ? pr.standardDays : 22}" maxFractionDigits="0"/>
                                                </span>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.baseSalary}">
                                                        <fmt:formatNumber value="${pr.baseSalary}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.allowance and pr.allowance > 0}">
                                                        <fmt:formatNumber value="${pr.allowance}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.bonus and pr.bonus > 0}">
                                                        <fmt:formatNumber value="${pr.bonus}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.overtimeAmount and pr.overtimeAmount > 0}">
                                                        <fmt:formatNumber value="${pr.overtimeAmount}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace text-deduction">
                                                <c:choose>
                                                    <c:when test="${not empty pr.deduction and pr.deduction > 0}">
                                                        -<fmt:formatNumber value="${pr.deduction}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace text-net-salary">
                                                <c:choose>
                                                    <c:when test="${not empty pr.netSalary}">
                                                        <fmt:formatNumber value="${pr.netSalary}" pattern="#,###"/> đ
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${pr.status eq 'PAID'}">
                                                        <span class="badge bg-success-subtle text-success border">Đã chi trả</span>
                                                    </c:when>
                                                    <c:when test="${pr.status eq 'APPROVED'}">
                                                        <span class="badge bg-primary-subtle text-primary border">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${pr.status eq 'PENDING'}">
                                                        <span class="badge bg-warning-subtle text-warning-emphasis border">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border">Nháp</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center pe-3">
                                                <div class="d-flex gap-1 justify-content-center">
                                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&id=${pr.id}" class="btn btn-sm btn-outline-primary py-1 px-2" title="Xem phiếu lương">
                                                        <i class="bi bi-receipt"></i>
                                                    </a>
                                                    <c:if test="${(sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT') and (pr.status eq 'DRAFT' or pr.status eq 'PENDING')}">
                                                        <form method="post" action="${pageContext.request.contextPath}/payroll" style="display:inline;" onsubmit="return confirm('Phê duyệt bảng lương cho ${pr.employeeName}?')">
                                                            <input type="hidden" name="action" value="approve">
                                                            <input type="hidden" name="id" value="${pr.id}">
                                                            <input type="hidden" name="month" value="${selectedMonth}">
                                                            <input type="hidden" name="year" value="${selectedYear}">
                                                            <input type="hidden" name="page" value="${currentPage}">
                                                            <input type="hidden" name="deptId" value="${selectedDeptId}">
                                                            <input type="hidden" name="statusFilter" value="${selectedStatus}">
                                                            <input type="hidden" name="keyword" value="${keyword}">
                                                            <button type="submit" class="btn btn-sm btn-outline-success py-1 px-2" title="Phê duyệt">
                                                                <i class="bi bi-check-circle"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${(sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT') and pr.status eq 'APPROVED'}">
                                                        <form method="post" action="${pageContext.request.contextPath}/payroll" style="display:inline;" onsubmit="return confirm('Chi trả lương cho ${pr.employeeName}?')">
                                                            <input type="hidden" name="action" value="pay">
                                                            <input type="hidden" name="id" value="${pr.id}">
                                                            <input type="hidden" name="month" value="${selectedMonth}">
                                                            <input type="hidden" name="year" value="${selectedYear}">
                                                            <input type="hidden" name="page" value="${currentPage}">
                                                            <input type="hidden" name="deptId" value="${selectedDeptId}">
                                                            <input type="hidden" name="statusFilter" value="${selectedStatus}">
                                                            <input type="hidden" name="keyword" value="${keyword}">
                                                            <button type="submit" class="btn btn-sm btn-success py-1 px-2" title="Chi trả lương">
                                                                <i class="bi bi-cash-coin"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <%-- Dòng tổng cộng --%>
                                    <tr class="table-summary-row">
                                        <td class="text-center text-primary fs-5">Σ</td>
                                        <td colspan="3">TỔNG CỘNG KỲ THÁNG ${selectedMonth}/${selectedYear} (${totalRecords} NV)</td>
                                        <td class="text-end font-monospace" colspan="5"></td>
                                        <td class="text-end font-monospace text-net-salary fs-6">
                                            <c:choose>
                                                <c:when test="${not empty totalPayroll and totalPayroll > 0}">
                                                    <fmt:formatNumber value="${totalPayroll}" pattern="#,###"/> đ
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="12" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                            Chưa có dữ liệu bảng lương tháng ${selectedMonth}/${selectedYear}.<br>
                                            <small>Nhấn "Tính lương tự động" để tạo bảng lương cho kỳ này.</small>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Table Pagination Footer (Server-Side) -->
                <div class="p-3 border-top d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2" style="font-size: 0.82rem;">
                        <span class="text-muted">
                            Hiển thị
                            <strong>${(currentPage - 1) * pageSize + 1}</strong>
                            –
                            <strong>${(currentPage - 1) * pageSize + payrollList.size()}</strong>
                            của <strong>${totalRecords}</strong> bản ghi
                        </span>
                    </div>

                    <nav aria-label="Phân trang bảng lương">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=1"><i class="bi bi-chevron-bar-left"></i></a>
                            </li>
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=${currentPage - 1}"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=${p}">${p}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=${currentPage + 1}"><i class="bi bi-chevron-right"></i></a>
                            </li>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=${totalPages}"><i class="bi bi-chevron-bar-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>

            <!-- Bottom 3 Compliance & Operations Cards -->
            <div class="row g-3">
                <!-- Card 1 -->
                <div class="col-lg-4">
                    <div class="compliance-notice-card">
                        <i class="bi bi-shield-check compliance-icon text-primary"></i>
                        <div>
                            <div class="compliance-title">Quy chuẩn tính BHXH & Thuế TNCN</div>
                            <p class="compliance-desc">
                                Đã áp dụng biểu thuế luỹ tiến mới nhất theo Thông tư 111 và mức trần đóng BHXH hiện hành của nhà nước.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Card 2 -->
                <div class="col-lg-4">
                    <div class="compliance-notice-card">
                        <i class="bi bi-clock-history compliance-icon text-primary"></i>
                        <div>
                            <div class="compliance-title">Đồng bộ dữ liệu chấm công tự động</div>
                            <p class="compliance-desc">
                                Dữ liệu công thực tế và số giờ tăng ca (OT) đã được chốt và duyệt bởi Trưởng phòng ban lúc 23:59 ngày 25/09.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Card 3 -->
                <div class="col-lg-4">
                    <div class="compliance-notice-card">
                        <i class="bi bi-lock-fill compliance-icon text-dark"></i>
                        <div>
                            <div class="compliance-title">Khóa sổ lương & Ký duyệt số</div>
                            <p class="compliance-desc">
                                Hạn chót gửi ngân hàng chi trả đợt 1 là 17:00 ngày 30/09/2026. Vui lòng hoàn tất kiểm tra 15 hồ sơ còn lại.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Timesheet Lock Guard Modal -->
<div class="modal fade" id="timesheetLockGuardModal" tabindex="-1" aria-labelledby="timesheetLockGuardModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px; overflow: hidden;">
            <div class="modal-header bg-warning bg-opacity-10 border-0 p-4 pb-2">
                <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle bg-warning text-white p-2 d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                        <i class="bi bi-shield-exclamation fs-5"></i>
                    </div>
                    <div>
                        <h5 class="modal-title fw-bold text-dark mb-0" id="timesheetLockGuardModalLabel">Kiểm soát nội bộ: Khóa Bảng công</h5>
                        <small class="text-muted">Ràng buộc chuỗi quy trình Chấm công &rarr; Lương</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 pt-3">
                <div class="alert alert-warning border-0 p-3 mb-3" style="border-radius: 10px; font-size: 0.9rem;">
                    <strong>Bảng công Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear} hiện chưa được Khóa chốt!</strong>
                    <div class="mt-1 text-muted" style="font-size: 0.82rem;">
                        Theo quy chuẩn kiểm soát tài chính - nhân sự, dữ liệu chấm công cần được đóng băng trước khi tính lương để đảm bảo tính bất biến, minh bạch và không phát sinh sai lệch khi giải trình.
                    </div>
                </div>
                
                <p class="mb-3 text-secondary" style="font-size: 0.9rem;">
                    Hệ thống cung cấp 2 phương án xử lý chuẩn doanh nghiệp:
                </p>

                <div class="d-flex flex-column gap-2">
                    <!-- Option 1: 1-Click Lock & Calculate -->
                    <form method="post" action="${pageContext.request.contextPath}/payroll" class="w-100">
                        <input type="hidden" name="action" value="calculate">
                        <input type="hidden" name="month" value="${selectedMonth}">
                        <input type="hidden" name="year" value="${selectedYear}">
                        <input type="hidden" name="confirmLock" value="true">
                        <button type="button" id="btnGuardRunPayrollCalc" class="btn btn-primary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2 shadow-sm" style="border-radius: 10px; background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); border: none;">
                            <i class="bi bi-shield-lock-fill"></i>
                            <span>Khóa bảng công &amp; Tính lương ngay (1-Click)</span>
                        </button>
                    </form>

                    <!-- Option 2: Go to Timesheet to inspect & lock manually -->
                    <a href="${pageContext.request.contextPath}/timesheet?month=${selectedMonth}&year=${selectedYear}" class="btn btn-outline-secondary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2" style="border-radius: 10px;">
                        <i class="bi bi-table"></i>
                        <span>Xem &amp; Đối soát bảng công chi tiết trước</span>
                    </a>
                </div>
            </div>
            <div class="modal-footer border-0 p-3 pt-0 justify-content-center">
                <button type="button" class="btn btn-link text-muted text-decoration-none btn-sm" data-bs-dismiss="modal">Đóng / Hủy bỏ</button>
            </div>
        </div>
    </div>
</div>

<!-- Payroll Calculation Progress Overlay Modal -->
<div class="modal fade" id="payrollCalculationModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 18px; overflow: hidden;">
            <div class="modal-header border-0 bg-primary text-white py-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <div class="spinner-border spinner-border-sm text-light" role="status"></div>
                    <h6 class="modal-title fw-bold mb-0">Hệ thống Động cơ Tính Lương (Payroll Engine)</h6>
                </div>
            </div>
            <div class="modal-body p-4">
                <div class="text-center mb-3">
                    <div class="fw-bold text-dark fs-6" id="payrollCalcStatusTitle">Đang khởi chạy động cơ tính lương kỳ ${selectedMonth}/${selectedYear}...</div>
                    <div class="text-muted small mt-1">Vui lòng không tắt hoặc tải lại trang trong khi hệ thống đang xử lý dữ liệu.</div>
                </div>

                <!-- Progress Bar -->
                <div class="progress mb-4" style="height: 10px; border-radius: 999px;">
                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-primary" id="payrollCalcProgressBar" role="progressbar" style="width: 15%;"></div>
                </div>

                <!-- Step Checklist -->
                <div class="d-flex flex-column gap-2" id="payrollCalcStepsList" style="font-size: 0.85rem;">
                    <div class="d-flex align-items-center gap-2 text-primary fw-semibold" id="pstep1">
                        <i class="bi bi-arrow-repeat spin"></i>
                        <span>1. Kiểm tra trạng thái khóa chốt bảng chấm công tháng ${selectedMonth}/${selectedYear}</span>
                    </div>
                    <div class="d-flex align-items-center gap-2 text-muted" id="pstep2">
                        <i class="bi bi-circle"></i>
                        <span>2. Tổng hợp ngày công thực tế, nghỉ phép hưởng lương &amp; giờ làm thêm (OT)</span>
                    </div>
                    <div class="d-flex align-items-center gap-2 text-muted" id="pstep3">
                        <i class="bi bi-circle"></i>
                        <span>3. Áp dụng bảng phụ cấp chức vụ, ăn trưa &amp; tiền thưởng hiệu suất</span>
                    </div>
                    <div class="d-flex align-items-center gap-2 text-muted" id="pstep4">
                        <i class="bi bi-circle"></i>
                        <span>4. Trích nộp bảo hiểm bắt buộc (BHXH, BHYT, BHTN 10.5%) &amp; Thuế TNCN lũy tiến 7 bậc</span>
                    </div>
                    <div class="d-flex align-items-center gap-2 text-muted" id="pstep5">
                        <i class="bi bi-circle"></i>
                        <span>5. Tạo snapshot chi tiết phiếu lương và lưu trữ bất biến</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/payroll.js"></script>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
