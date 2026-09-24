<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Dashboard Tổng Quan — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <!-- Chart.js 4.4 for high-performance interactive analytics -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
    <style>
        .filter-date-item {
            display: flex;
            align-items: center;
            gap: 0.45rem;
        }
        .filter-date-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #475569;
            white-space: nowrap;
            margin-bottom: 0;
        }
        .filter-input-date {
            height: 38px;
            padding: 0.35rem 0.65rem;
            font-size: 0.82rem;
            font-weight: 600;
            color: #1e293b;
            background-color: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            outline: none;
            transition: all 0.15s ease;
        }
        .filter-input-date:hover {
            border-color: #94a3b8;
        }
        .filter-input-date:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }
        .filter-select {
            -webkit-appearance: none !important;
            -moz-appearance: none !important;
            appearance: none !important;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%2364748b' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e") !important;
            background-repeat: no-repeat !important;
            background-position: right 0.75rem center !important;
            background-size: 12px 10px !important;
            padding-right: 2.2rem !important;
        }
        .filter-select::-ms-expand {
            display: none !important;
        }
        .btn-filter-submit {
            height: 38px;
            padding: 0.35rem 1.15rem;
            font-size: 0.82rem;
            font-weight: 600;
            color: #ffffff;
            background: #2563eb;
            border: none;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .btn-filter-submit:hover {
            background: #1d4ed8;
            box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25);
        }
    </style>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="dashboard" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Dashboard Page Body -->
        <div class="app-content">
            
            <!-- 1. Welcome Banner Card -->
            <div class="welcome-banner">
                <div>
                    <div class="welcome-title">
                        Xin chào, 
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.fullName}">
                                ${sessionScope.currentUser.fullName}
                            </c:when>
                            <c:when test="${not empty sessionScope.currentUser.username}">
                                ${sessionScope.currentUser.username}
                            </c:when>
                            <c:otherwise>Admin</c:otherwise>
                        </c:choose>
                        <span>👋</span>
                        <span class="welcome-version-badge">Executive Suite 2026</span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.88rem;">
                        Chúc bạn một ngày làm việc hiệu quả. Dưới đây là tổng quan tình hình toàn bộ hệ thống doanh nghiệp.
                    </p>
                </div>

                <div class="welcome-actions ms-auto">
                    <button class="btn-action-light" type="button" id="btnExportReport" title="Xuất báo cáo định dạng Excel / PDF">
                        <i class="bi bi-box-arrow-up text-primary"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <button class="btn-action-primary" type="button" id="btnGenerateComposite" title="Tạo báo cáo tổng hợp hệ thống">
                        <i class="bi bi-file-earmark-text"></i>
                        <span>Tạo báo cáo tổng hợp</span>
                    </button>
                </div>
            </div>

            <!-- 2. Multi-Criteria Filter Bar (Bộ lọc theo khoảng ngày, phòng ban, trạng thái) -->
            <form id="dashboardFilterForm" method="GET" action="${pageContext.request.contextPath}/dashboard" class="dashboard-filter-card">
                <div class="filter-row-top">
                    <div class="filter-controls-group">
                        <!-- Chọn Từ ngày -->
                        <div class="filter-date-item">
                            <label for="filterStartDate" class="filter-date-label">
                                <i class="bi bi-calendar-event text-primary me-1"></i>Từ ngày:
                            </label>
                            <input type="date" class="filter-input-date" id="filterStartDate" name="startDate" value="${startDate}" required>
                        </div>

                        <!-- Chọn Đến ngày -->
                        <div class="filter-date-item">
                            <label for="filterEndDate" class="filter-date-label">
                                <i class="bi bi-calendar-check text-primary me-1"></i>Đến ngày:
                            </label>
                            <input type="date" class="filter-input-date" id="filterEndDate" name="endDate" value="${endDate}" required>
                        </div>

                        <!-- Lọc Phòng ban -->
                        <select class="filter-select" id="filterDepartment" name="departmentId" style="min-width: 175px;">
                            <option value="all">Tất cả phòng ban</option>
                            <c:forEach items="${departmentList}" var="dept">
                                <option value="${dept.id}" ${selectedDepartmentId == dept.id ? 'selected' : ''}>${dept.name}</option>
                            </c:forEach>
                        </select>

                        <!-- Lọc Trạng thái -->
                        <select class="filter-select" id="filterStatus" name="status">
                            <option value="all" ${selectedStatus == null || selectedStatus == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                            <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Đang làm việc</option>
                            <option value="ON_LEAVE" ${selectedStatus == 'ON_LEAVE' ? 'selected' : ''}>Đang nghỉ phép</option>
                            <option value="INACTIVE" ${selectedStatus == 'INACTIVE' ? 'selected' : ''}>Đã nghỉ việc</option>
                        </select>
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <!-- Nút Lọc dữ liệu -->
                        <button type="submit" class="btn-filter-submit" id="btnApplyFilter" title="Áp dụng bộ lọc thời gian thực">
                            <i class="bi bi-funnel-fill"></i>
                            <span>Lọc dữ liệu</span>
                        </button>

                        <!-- Nút Làm mới -->
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn-filter-refresh text-decoration-none" id="btnRefreshFilters" title="Làm mới bộ lọc về mặc định">
                            <i class="bi bi-arrow-clockwise"></i>
                            <span>Làm mới</span>
                        </a>
                    </div>
                </div>
            </form>

            <!-- 3. Eight Stat KPI Cards (2 Rows of 4 Cards) -->
            <!-- Row 1 of KPI Cards -->
            <div class="row g-3 mb-3">
                <!-- KPI 1: Tổng nhân viên -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng nhân viên</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">${kpiStats.totalEmployees}</span>
                                    <span class="kpi-unit">nhân sự</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-shield-check"></i> Toàn hệ thống
                            </span>
                            <span class="text-muted">Nhân sự hiện hữu</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2: Nhân viên đang làm việc -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Nhân viên đang làm việc</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">${kpiStats.activeEmployees}</span>
                                    <span class="kpi-unit">nhân sự</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-person-check-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-check-circle"></i> Đang hoạt động
                            </span>
                            <span class="text-muted">Trạng thái ACTIVE</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3: Nhân viên mới -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Nhân viên mới</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">${kpiStats.newHires}</span>
                                    <span class="kpi-unit">tuyển mới</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-person-plus-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge" style="background:#eff6ff; color:#2563eb;">
                                <i class="bi bi-calendar-event"></i> Trong kỳ lọc
                            </span>
                            <span class="text-muted">Gia nhập gần đây</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4: Nhân viên nghỉ việc -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Nhân viên nghỉ việc</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">${kpiStats.inactiveEmployees}</span>
                                    <span class="kpi-unit">nghỉ việc</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box coral">
                                <i class="bi bi-person-dash-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge text-secondary" style="background:#f1f5f9;">
                                <i class="bi bi-person-x"></i> Đã thôi việc
                            </span>
                            <span class="text-muted">Trạng thái INACTIVE</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Row 2 of KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 5: Phòng ban -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Phòng ban</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">${kpiStats.departmentCount}</span>
                                    <span class="kpi-unit">đơn vị</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-buildings-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="kpi-chip-soft">Đang vận hành</span>
                            <span class="text-muted">Cơ cấu tổ chức</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 6: Tổng quỹ lương -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng quỹ lương</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-primary">
                                        <fmt:formatNumber value="${payrollSummary.totalNet}" type="number" groupingUsed="true"/>
                                    </span>
                                    <span class="kpi-unit text-primary fw-bold">đ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-wallet2"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge" style="background:#eff6ff; color:#2563eb;">
                                <i class="bi bi-cash-stack"></i> Thực chi trả
                            </span>
                            <span class="text-muted">Theo kỳ lọc</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 7: Hợp đồng sắp hết hạn -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Hợp đồng sắp hết hạn</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-warning" style="color: #ea580c !important;">
                                        <fmt:formatNumber value="${kpiStats.expiringContracts}" minIntegerDigits="2"/>
                                    </span>
                                    <span class="kpi-unit">hợp đồng</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box amber">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="kpi-chip-warning">
                                <i class="bi bi-dot fs-5 p-0"></i> Cần rà soát
                            </span>
                            <span class="text-muted">Trong 30 ngày tới</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 8: Đơn nghỉ phép chờ duyệt -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Đơn nghỉ phép chờ duyệt</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-primary">${kpiStats.pendingLeaves}</span>
                                    <span class="kpi-unit">yêu cầu</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-clipboard2-check-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="kpi-chip-soft">Chờ duyệt</span>
                            <span class="text-danger fw-semibold">Cần xử lý</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. Main Charts Row: Biến động nhân sự & Cơ cấu nhân sự -->
            <div class="row g-3 mb-4">
                <!-- Left: Biến động nhân sự (8 Columns) -->
                <div class="col-lg-8">
                    <div class="app-card">
                        <div class="app-card-header flex-wrap gap-2">
                            <div>
                                <div class="app-card-title">
                                    <span>Biến động nhân sự</span>
                                    <i class="bi bi-info-circle text-muted fs-6" title="Xu hướng biến động quy mô nhân sự qua các tháng" style="cursor:help;"></i>
                                </div>
                                <p class="app-card-subtitle">Xu hướng biến động quy mô nhân sự 6 tháng gần nhất</p>
                            </div>

                            <div class="d-flex align-items-center gap-3 flex-wrap">
                                <!-- Legend Indicators -->
                                <div class="chart-header-badges">
                                    <span><span class="badge-dot-indicator" style="background-color: #2563eb;"></span>Tổng NS (${kpiStats.totalEmployees})</span>
                                    <span><span class="badge-dot-indicator" style="background-color: #10b981;"></span>Mới (+${kpiStats.newHires})</span>
                                    <span><span class="badge-dot-indicator" style="background-color: #ef4444;"></span>Nghỉ (-${kpiStats.inactiveEmployees})</span>
                                </div>
                            </div>
                        </div>

                        <div style="height: 285px; position: relative;" class="mt-2">
                            <canvas id="personnelGrowthChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Right: Cơ cấu nhân sự (4 Columns) -->
                <div class="col-lg-4">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header mb-1">
                                <div>
                                    <div class="app-card-title">Cơ cấu nhân sự</div>
                                    <p class="app-card-subtitle">Phân bố ${personnelStructure.totalEmployees} nhân sự trong công ty</p>
                                </div>

                                <!-- Toggle Tabs -->
                                <div class="card-filter-pills">
                                    <button type="button" class="filter-pill active" data-donut-tab="dept">Phòng ban</button>
                                    <button type="button" class="filter-pill" data-donut-tab="gender">Giới tính</button>
                                    <button type="button" class="filter-pill" data-donut-tab="age">Độ tuổi</button>
                                </div>
                            </div>

                            <!-- Donut Wrapper with Centered Indicator -->
                            <div class="donut-chart-wrapper my-2">
                                <canvas id="departmentDonutChart" width="185" height="185"></canvas>
                                <div class="donut-center-info">
                                    <div class="donut-center-val">${personnelStructure.totalEmployees}</div>
                                    <div class="donut-center-label">Tổng nhân sự</div>
                                </div>
                            </div>
                        </div>

                        <!-- 2-Column Legend Grid Dynamically Rendered -->
                        <div class="donut-legend-row" id="donutDynamicLegend">
                            <c:forEach items="${personnelStructure.deptList}" var="dept">
                                <div class="donut-legend-item">
                                    <span class="legend-label">
                                        <span class="color-square" style="background-color: ${dept.color};"></span>
                                        ${dept.name}
                                    </span>
                                    <span class="legend-val">${dept.percent}% <span class="text-muted fw-normal">(${dept.count})</span></span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 5. Three Columns Widget: Chấm công, Nghỉ phép, Việc cần xử lý gấp -->
            <div class="row g-3 mb-4">
                <!-- Col 1: Tình hình chấm công hôm nay -->
                <div class="col-lg-4">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">Tình hình chấm công</div>
                                    <p class="app-card-subtitle">Tổng số lượt chấm công theo kỳ: <strong>${attendanceSummary.totalRecords}</strong></p>
                                </div>
                                <span class="badge bg-success-subtle text-success px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    ● Dữ liệu kỳ lọc
                                </span>
                            </div>

                            <!-- Stacked Progress Bar -->
                            <div class="attendance-stacked-bar">
                                <div class="attendance-stacked-segment" style="width: ${attendanceSummary.onTimePct}%; background-color: #10b981;" title="Đúng giờ: ${attendanceSummary.onTimePct}%"></div>
                                <div class="attendance-stacked-segment" style="width: ${attendanceSummary.latePct}%; background-color: #f59e0b;" title="Đi muộn/Về sớm: ${attendanceSummary.latePct}%"></div>
                                <div class="attendance-stacked-segment" style="width: ${attendanceSummary.onLeavePct}%; background-color: #3b82f6;" title="Nghỉ phép: ${attendanceSummary.onLeavePct}%"></div>
                                <div class="attendance-stacked-segment" style="width: ${attendanceSummary.absentPct}%; background-color: #ef4444;" title="Vắng không phép: ${attendanceSummary.absentPct}%"></div>
                            </div>

                            <!-- Breakdown Items -->
                            <div class="attendance-breakdown-list">
                                <div class="attendance-item">
                                    <span class="attendance-item-label">
                                        <span class="badge-dot-indicator" style="background-color: #10b981;"></span>
                                        Đi làm đúng giờ
                                    </span>
                                    <span class="attendance-item-val text-success">${attendanceSummary.onTimeCount} lượt (${attendanceSummary.onTimePct}%)</span>
                                </div>
                                <div class="attendance-item">
                                    <span class="attendance-item-label">
                                        <span class="badge-dot-indicator" style="background-color: #f59e0b;"></span>
                                        Đi muộn / Về sớm
                                    </span>
                                    <span class="attendance-item-val text-warning" style="color:#d97706 !important;">${attendanceSummary.lateCount} lượt (${attendanceSummary.latePct}%)</span>
                                </div>
                                <div class="attendance-item">
                                    <span class="attendance-item-label">
                                        <span class="badge-dot-indicator" style="background-color: #3b82f6;"></span>
                                        Nghỉ phép có lương
                                    </span>
                                    <span class="attendance-item-val text-primary">${attendanceSummary.onLeaveCount} lượt (${attendanceSummary.onLeavePct}%)</span>
                                </div>
                                <div class="attendance-item">
                                    <span class="attendance-item-label">
                                        <span class="badge-dot-indicator" style="background-color: #ef4444;"></span>
                                        Vắng mặt không phép
                                    </span>
                                    <span class="attendance-item-val text-danger">${attendanceSummary.absentCount} lượt (${attendanceSummary.absentPct}%)</span>
                                </div>
                            </div>
                        </div>

                        <div class="pt-3 mt-3 border-top">
                            <a href="${pageContext.request.contextPath}/attendance" class="text-primary fw-bold text-decoration-none d-flex align-items-center justify-content-between" style="font-size:0.83rem;">
                                <span>Xem chi tiết chấm công</span>
                                <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Col 2: Nghỉ phép -->
                <div class="col-lg-4">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">Nghỉ phép</div>
                                    <p class="app-card-subtitle">Quỹ phép ước tính: <strong>${leaveSummary.totalFund} ngày</strong></p>
                                </div>
                                <span class="badge bg-primary-subtle text-primary px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    Toàn công ty
                                </span>
                            </div>

                            <!-- Dual Bar & Labels -->
                            <div class="leave-dual-bar">
                                <div class="leave-bar-used" style="width: ${leaveSummary.usedPct}%;"></div>
                                <div class="leave-bar-remain" style="width: ${leaveSummary.remainPct}%;"></div>
                            </div>
                            <div class="leave-dual-labels">
                                <span>Đã dùng: <strong>${leaveSummary.totalDaysUsed}</strong> ngày (${leaveSummary.usedPct}%)</span>
                                <span>Còn lại: <strong>${leaveSummary.remainingDays}</strong> ngày (${leaveSummary.remainPct}%)</span>
                            </div>

                            <!-- Highlight Callout Box -->
                            <div class="leave-callout-card">
                                <div>
                                    <div class="leave-callout-title">Đơn chờ duyệt</div>
                                    <div class="d-flex align-items-baseline">
                                        <span class="leave-callout-number">${leaveSummary.pendingCount}</span>
                                        <span class="leave-callout-unit">yêu cầu</span>
                                    </div>
                                </div>
                                <div class="leave-callout-icon">
                                    <i class="bi bi-calendar-check"></i>
                                </div>
                            </div>
                        </div>

                        <div class="pt-3 mt-3 border-top">
                            <a href="${pageContext.request.contextPath}/leave" class="text-primary fw-bold text-decoration-none d-flex align-items-center justify-content-between" style="font-size:0.83rem;">
                                <span>Xem chi tiết nghỉ phép</span>
                                <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Col 3: Việc cần xử lý gấp -->
                <div class="col-lg-4">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title text-danger">
                                        <i class="bi bi-exclamation-triangle-fill me-1"></i>
                                        Việc cần xử lý gấp
                                    </div>
                                    <p class="app-card-subtitle">Các tác vụ nhân sự cần được ban giám đốc và HR duyệt ngay:</p>
                                </div>
                                <span class="badge bg-warning-subtle text-warning px-2 py-1 fw-bold" style="font-size: 0.75rem; color:#c2410c !important;">
                                    Ưu tiên cao
                                </span>
                            </div>

                            <!-- Urgent Tasks List -->
                            <div class="urgent-task-list">
                                <!-- Item 1 -->
                                <div class="urgent-task-item">
                                    <div class="urgent-task-left">
                                        <span class="urgent-num-badge orange">${urgentTasks.expiringContracts}</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Hợp đồng sắp hết hạn</span>
                                            <span class="urgent-task-sub">Trong 30 ngày tới</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/contracts" class="urgent-action-btn">
                                        Xem danh sách <i class="bi bi-chevron-right"></i>
                                    </a>
                                </div>

                                <!-- Item 2 -->
                                <div class="urgent-task-item">
                                    <div class="urgent-task-left">
                                        <span class="urgent-num-badge blue">${urgentTasks.pendingLeaves}</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Đơn nghỉ phép cần duyệt</span>
                                            <span class="urgent-task-sub">Chờ phê duyệt</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/leave" class="urgent-action-btn">
                                        Duyệt ngay <i class="bi bi-chevron-right"></i>
                                    </a>
                                </div>

                                <!-- Item 3 -->
                                <div class="urgent-task-item">
                                    <div class="urgent-task-left">
                                        <span class="urgent-num-badge purple">${urgentTasks.incompleteProfiles}</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Hồ sơ chưa hoàn tất</span>
                                            <span class="urgent-task-sub">Thiếu CCCD, MST hoặc Ngân hàng</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/employees" class="urgent-action-btn">
                                        Kiểm tra <i class="bi bi-chevron-right"></i>
                                    </a>
                                </div>

                                <!-- Item 4 -->
                                <div class="urgent-task-item">
                                    <div class="urgent-task-left">
                                        <span class="urgent-num-badge orange">${urgentTasks.openRecruitment}</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Yêu cầu tuyển dụng đang mở</span>
                                            <span class="urgent-task-sub">Đang tìm kiếm ứng viên</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/recruitment" class="urgent-action-btn">
                                        Xem yêu cầu <i class="bi bi-chevron-right"></i>
                                    </a>
                                </div>

                                <!-- Item 5 -->
                                <div class="urgent-task-item">
                                    <div class="urgent-task-left">
                                        <span class="urgent-num-badge red">${urgentTasks.pendingOvertime}</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Làm thêm giờ chờ duyệt</span>
                                            <span class="urgent-task-sub">Đăng ký ca OT gần đây</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/attendance" class="urgent-action-btn">
                                        Kiểm tra <i class="bi bi-chevron-right"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 6. Two Columns: Quỹ lương & chi phí nhân sự & Tình hình tuyển dụng -->
            <div class="row g-3 mb-4">
                <!-- Left: Quỹ lương & chi phí nhân sự (7 Columns) -->
                <div class="col-lg-7">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">
                                        <i class="bi bi-wallet2 text-primary me-1"></i>
                                        Quỹ lương & chi phí nhân sự
                                    </div>
                                    <p class="app-card-subtitle">Chi tiết phân bổ ngân sách tiền lương theo kỳ lọc</p>
                                </div>
                                <span class="badge bg-primary-subtle text-primary px-3 py-2 fw-bold" style="font-size:0.95rem;">
                                    <fmt:formatNumber value="${payrollSummary.totalNet}" type="number" groupingUsed="true"/> đ
                                </span>
                            </div>

                            <!-- 5 Mini Stats Pills -->
                            <div class="payroll-stats-bar">
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Tổng quỹ</div>
                                    <div class="payroll-stat-value text-primary">
                                        <fmt:formatNumber value="${payrollSummary.totalNet / 1000000}" maxFractionDigits="1"/> Tr đ
                                    </div>
                                </div>
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Lương cơ bản</div>
                                    <div class="payroll-stat-value">
                                        <fmt:formatNumber value="${payrollSummary.totalBase / 1000000}" maxFractionDigits="1"/> Tr đ
                                    </div>
                                </div>
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Phụ cấp</div>
                                    <div class="payroll-stat-value">
                                        <fmt:formatNumber value="${payrollSummary.totalAllowance / 1000000}" maxFractionDigits="1"/> Tr đ
                                    </div>
                                </div>
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Thưởng</div>
                                    <div class="payroll-stat-value">
                                        <fmt:formatNumber value="${payrollSummary.totalBonus / 1000000}" maxFractionDigits="1"/> Tr đ
                                    </div>
                                </div>
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Khấu trừ</div>
                                    <div class="payroll-stat-value">
                                        <fmt:formatNumber value="${payrollSummary.totalDeduction / 1000000}" maxFractionDigits="1"/> Tr đ
                                    </div>
                                </div>
                            </div>

                            <!-- Department Progress Bars -->
                            <div class="dept-payroll-list my-3">
                                <c:forEach items="${payrollSummary.deptPayrollList}" var="dp">
                                    <div class="dept-payroll-item">
                                        <div class="dept-payroll-info">
                                            <span class="dept-name">${dp.name}</span>
                                            <span class="dept-amount">
                                                <fmt:formatNumber value="${dp.amount}" type="number" groupingUsed="true"/> đ 
                                                <span class="text-muted fw-normal">(${dp.percent}%)</span>
                                            </span>
                                        </div>
                                        <div class="dept-progress">
                                            <div class="dept-progress-bar" style="width: ${dp.percent}%; background-color: #2563eb;"></div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="pt-3 border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem;">
                            <span class="text-muted d-flex align-items-center gap-1">
                                <i class="bi bi-shield-check text-success fs-6"></i>
                                Đã bao gồm thuế TNCN và các khoản trích theo lương
                            </span>
                            <a href="${pageContext.request.contextPath}/payroll" class="text-primary fw-bold text-decoration-none d-flex align-items-center gap-1">
                                Chi tiết bảng lương <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Right: Tình hình tuyển dụng (5 Columns) -->
                <div class="col-lg-5">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">
                                        <i class="bi bi-person-plus text-primary me-1"></i>
                                        Tình hình tuyển dụng
                                    </div>
                                    <p class="app-card-subtitle">Phễu tuyển dụng nhân sự và tỷ lệ chuyển đổi</p>
                                </div>
                                <span class="badge bg-primary-subtle text-primary px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    Dữ liệu thực tế
                                </span>
                            </div>

                            <!-- 4 Pipeline Metrics -->
                            <div class="recruitment-metric-grid">
                                <div class="recruitment-metric-box">
                                    <div class="recruitment-metric-val text-primary">${recruitmentStats.openPositions}</div>
                                    <div class="recruitment-metric-label">Vị trí mở</div>
                                </div>
                                <div class="recruitment-metric-box">
                                    <div class="recruitment-metric-val text-info">${recruitmentStats.totalCandidates}</div>
                                    <div class="recruitment-metric-label">Ứng viên nộp</div>
                                </div>
                                <div class="recruitment-metric-box">
                                    <div class="recruitment-metric-val text-warning" style="color:#d97706 !important;">${recruitmentStats.interviews}</div>
                                    <div class="recruitment-metric-label">Phỏng vấn</div>
                                </div>
                                <div class="recruitment-metric-box">
                                    <div class="recruitment-metric-val text-success">${recruitmentStats.onboarded}</div>
                                    <div class="recruitment-metric-label">Đã nhận việc</div>
                                </div>
                            </div>

                            <!-- Funnel Stages -->
                            <div class="funnel-list my-3">
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Ứng viên mới</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: ${recruitmentStats.newPct}%; background-color: #6366f1;">${recruitmentStats.newCount} hồ sơ</div>
                                    </div>
                                </div>
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Đã sàng lọc</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: ${recruitmentStats.screeningPct}%; background-color: #3b82f6;">${recruitmentStats.screeningCount} hồ sơ</div>
                                    </div>
                                </div>
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Phỏng vấn</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: ${recruitmentStats.interviewPct}%; background-color: #f59e0b;">${recruitmentStats.interviewCount} ứng viên</div>
                                    </div>
                                </div>
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Đề xuất tuyển</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: ${recruitmentStats.offerPct}%; background-color: #06b6d4;">${recruitmentStats.offerCount}</div>
                                    </div>
                                </div>
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Đã tuyển dụng</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: ${recruitmentStats.onboardedPct}%; background-color: #10b981;">${recruitmentStats.onboardedCount}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="pt-3 border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem;">
                            <a href="${pageContext.request.contextPath}/recruitment" class="text-primary fw-bold text-decoration-none d-flex align-items-center gap-1">
                                Xem tuyển dụng <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 7. Two Columns: Hiệu suất theo phòng ban (KPI) & Phân tích cơ cấu nhân sự -->
            <div class="row g-3 mb-4">
                <!-- Left: Hiệu suất theo phòng ban (KPI) (6 Columns) -->
                <div class="col-lg-6">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">
                                        <i class="bi bi-speedometer2 text-success me-1"></i>
                                        Hiệu suất theo phòng ban (KPI)
                                    </div>
                                    <p class="app-card-subtitle">Tỷ lệ hoàn thành mục tiêu công việc trong tháng hiện tại</p>
                                </div>
                                <span class="badge bg-success-subtle text-success px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    Đánh giá T09
                                </span>
                            </div>

                            <!-- KPI List -->
                            <div class="kpi-dept-list my-3">
                                <c:forEach items="${departmentKpis}" var="kpi">
                                    <div class="kpi-dept-item">
                                        <div class="kpi-dept-header">
                                            <span class="kpi-dept-name">${kpi.name}</span>
                                            <div>
                                                <span class="kpi-eval-badge ${kpi.badgeClass}">${kpi.badgeText}</span>
                                                <strong class="ms-2">${kpi.rate}%</strong>
                                            </div>
                                        </div>
                                        <div class="kpi-progress-bar-bg">
                                            <div class="kpi-progress-fill ${kpi.color}" style="width: ${kpi.rate}%;"></div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/reports" class="text-primary fw-bold text-decoration-none d-flex align-items-center gap-1" style="font-size:0.83rem;">
                                Xem báo cáo hiệu suất <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Right: Phân tích cơ cấu nhân sự (6 Columns) -->
                <div class="col-lg-6">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">
                                        <i class="bi bi-pie-chart text-primary me-1"></i>
                                        Phân tích cơ cấu nhân sự
                                    </div>
                                    <p class="app-card-subtitle" id="structureCardSubtitle">Phân bổ theo tuổi và cơ cấu nhân sự chi tiết toàn hệ thống</p>
                                </div>

                                <!-- Right Filter Tabs: Độ tuổi, Giới tính, Thâm niên, Trình độ -->
                                <div class="card-filter-pills" id="structureFilterTabs">
                                    <button type="button" class="filter-pill active" data-structure-tab="age">Độ tuổi</button>
                                    <button type="button" class="filter-pill" data-structure-tab="gender">Giới tính</button>
                                    <button type="button" class="filter-pill" data-structure-tab="seniority">Thâm niên</button>
                                    <button type="button" class="filter-pill" data-structure-tab="education">Trình độ</button>
                                </div>
                            </div>

                            <!-- TAB 1: ĐỘ TUỔI -->
                            <div class="structure-tab-pane active" id="structure-pane-age">
                                <div class="age-dist-list my-3">
                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">18 – 25 tuổi</span>
                                            <span class="age-dist-val">${personnelStructure.ageUnder25Pct}% <span class="text-muted fw-normal">(${personnelStructure.ageUnder25} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: ${personnelStructure.ageUnder25Pct}%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label fw-bold text-primary">25 – 35 tuổi</span>
                                            <span class="age-dist-val text-primary">${personnelStructure.age25to35Pct}% <span class="text-muted fw-normal">(${personnelStructure.age25to35} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill highlight" style="width: ${personnelStructure.age25to35Pct}%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">35 – 45 tuổi (Lực lượng nòng cốt)</span>
                                            <span class="age-dist-val">${personnelStructure.age35to45Pct}% <span class="text-muted fw-normal">(${personnelStructure.age35to45} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: ${personnelStructure.age35to45Pct}%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">45 – 55 tuổi</span>
                                            <span class="age-dist-val">${personnelStructure.age45to55Pct}% <span class="text-muted fw-normal">(${personnelStructure.age45to55} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: ${personnelStructure.age45to55Pct}%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">Trên 55 tuổi</span>
                                            <span class="age-dist-val">${personnelStructure.ageOver55Pct}% <span class="text-muted fw-normal">(${personnelStructure.ageOver55} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: ${personnelStructure.ageOver55Pct}%;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- TAB 2: GIỚI TÍNH -->
                            <div class="structure-tab-pane" id="structure-pane-gender">
                                <div class="my-3">
                                    <!-- Thanh phân bổ tổng quan toàn công ty -->
                                    <div class="gender-overview-card p-2 px-3 mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-1" style="font-size: 0.8rem;">
                                            <span class="fw-bold text-primary d-flex align-items-center gap-1">
                                                <i class="bi bi-gender-male fs-6"></i> Nam: <strong>${personnelStructure.malePct}%</strong> <span class="text-muted fw-normal">(${personnelStructure.maleCount} NS)</span>
                                            </span>
                                            <span class="fw-bold text-danger d-flex align-items-center gap-1">
                                                <i class="bi bi-gender-female fs-6"></i> Nữ: <strong>${personnelStructure.femalePct}%</strong> <span class="text-muted fw-normal">(${personnelStructure.femaleCount} NS)</span>
                                            </span>
                                        </div>
                                        <div class="gender-dual-bar" style="height: 10px; border-radius: 9999px;">
                                            <div class="gender-bar-male" style="width: ${personnelStructure.malePct}%;"></div>
                                            <div class="gender-bar-female" style="width: ${personnelStructure.femalePct}%;"></div>
                                        </div>
                                    </div>

                                    <!-- Cơ cấu theo khối chức năng -->
                                    <div class="age-dist-list">
                                        <c:forEach items="${personnelStructure.deptList}" var="dept">
                                            <div class="age-dist-item">
                                                <div class="age-dist-header">
                                                    <span class="age-dist-label">${dept.name}</span>
                                                    <span class="age-dist-val" style="font-size: 0.76rem;">
                                                        <span class="text-primary fw-bold">${dept.percent}%</span> <span class="text-muted fw-normal">(${dept.count} NS)</span>
                                                    </span>
                                                </div>
                                                <div class="gender-dual-bar" style="height: 7px; border-radius: 9999px;">
                                                    <div class="gender-bar-male" style="width: ${dept.percent}%; background-color: ${dept.color};"></div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>

                            <!-- TAB 3: THÂM NIÊN -->
                            <div class="structure-tab-pane" id="structure-pane-seniority">
                                <div class="age-dist-list my-3">
                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">Dưới 1 năm (Tân binh & Thử việc)</span>
                                            <span class="age-dist-val">${personnelStructure.senUnder1Pct}% <span class="text-muted fw-normal">(${personnelStructure.senUnder1} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: ${personnelStructure.senUnder1Pct}%; background: #38bdf8;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label fw-bold text-primary">1 – 3 năm (Cống hiến ổn định)</span>
                                            <span class="age-dist-val text-primary">${personnelStructure.sen1to3Pct}% <span class="text-muted fw-normal">(${personnelStructure.sen1to3} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill highlight" style="width: ${personnelStructure.sen1to3Pct}%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">3 – 5 năm (Chuyên viên nòng cốt)</span>
                                            <span class="age-dist-val">${personnelStructure.sen3to5Pct}% <span class="text-muted fw-normal">(${personnelStructure.sen3to5} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: ${personnelStructure.sen3to5Pct}%; background: #6366f1;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">Trên 5 năm (Cán bộ nguồn & Gắn bó)</span>
                                            <span class="age-dist-val text-success">${personnelStructure.senOver5Pct}% <span class="text-muted fw-normal">(${personnelStructure.senOver5} nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: ${personnelStructure.senOver5Pct}%; background: #10b981;"></div>
                                        </div>
                                    </div>

                                    <!-- Gắn kết card -->
                                    <div class="p-2 px-3 rounded-2 mt-1 d-flex align-items-center justify-content-between" style="background: #f0fdf4; border: 1px dashed #86efac; font-size: 0.77rem;">
                                        <div class="text-success fw-semibold d-flex align-items-center gap-1">
                                            <i class="bi bi-shield-check fs-6"></i> Tỷ lệ nhân sự gắn bó trên 1 năm: <strong>${personnelStructure.retentionOver1YearPct}%</strong>
                                        </div>
                                        <span class="badge bg-success text-white">Chỉ số ổn định cao</span>
                                    </div>
                                </div>
                            </div>

                            <!-- TAB 4: TRÌNH ĐỘ -->
                            <div class="structure-tab-pane" id="structure-pane-education">
                                <div class="age-dist-list my-3">
                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label d-flex align-items-center gap-1">
                                                <i class="bi bi-mortarboard-fill text-purple"></i>
                                                <span>Sau Đại học (Thạc sĩ, Tiến sĩ)</span>
                                                <span class="badge bg-purple-subtle ms-1" style="font-size:0.68rem;">Chuyên gia</span>
                                            </span>
                                            <span class="age-dist-val text-purple">13.3% <span class="text-muted fw-normal">(2 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 13.3%; background: #8b5cf6;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label fw-bold text-primary d-flex align-items-center gap-1">
                                                <i class="bi bi-award-fill text-primary"></i>
                                                <span>Đại học chính quy (Cử nhân, Kỹ sư)</span>
                                                <span class="badge bg-primary-subtle text-primary ms-1" style="font-size:0.68rem;">Lực lượng chủ lực</span>
                                            </span>
                                            <span class="age-dist-val text-primary">73.3% <span class="text-muted fw-normal">(11 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill highlight" style="width: 73.3%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label d-flex align-items-center gap-1">
                                                <i class="bi bi-journal-bookmark text-info"></i>
                                                <span>Cao đẳng chuyên nghiệp</span>
                                            </span>
                                            <span class="age-dist-val">13.4% <span class="text-muted fw-normal">(2 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 13.4%; background: #0ea5e9;"></div>
                                        </div>
                                    </div>

                                    <!-- Chứng chỉ quốc tế highlight -->
                                    <div class="p-2 px-3 rounded-2 mt-1 d-flex align-items-center justify-content-between" style="background: #eff6ff; border: 1px dashed #bfdbfe; font-size: 0.77rem;">
                                        <div class="text-primary fw-semibold d-flex align-items-center gap-1">
                                            <i class="bi bi-patch-check-fill fs-6 text-primary"></i> Trình độ từ Đại học trở lên: <strong>86.6%</strong>
                                        </div>
                                        <span class="badge bg-primary text-white">Chất lượng cao</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 2 Demographic Subcards -->
                        <div class="demographic-subcards" id="structureSubcards">
                            <div class="demo-subcard">
                                <div class="demo-subcard-title" id="structureSub1Title">Tỷ lệ giới tính</div>
                                <div class="demo-subcard-val text-primary" id="structureSub1Val">
                                    <i class="bi bi-gender-male"></i> Nam: ${personnelStructure.malePct}% &nbsp;|&nbsp; <i class="bi bi-gender-female text-danger"></i> Nữ: ${personnelStructure.femalePct}%
                                </div>
                            </div>
                            <div class="demo-subcard">
                                <div class="demo-subcard-title" id="structureSub2Title">Thâm niên trung bình</div>
                                <div class="demo-subcard-val text-success" id="structureSub2Val">
                                    ${personnelStructure.avgSeniority} năm <span class="text-muted fw-normal">(${personnelStructure.retentionOver1YearPct}% gắn bó > 1 năm)</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 8. Full Width: Hoạt động gần đây -->
            <div class="row g-3">
                <div class="col-12">
                    <div class="app-card">
                        <div class="app-card-header">
                            <div>
                                <div class="app-card-title">
                                    <i class="bi bi-clock-history text-primary me-1"></i>
                                    Hoạt động gần đây
                                </div>
                                <p class="app-card-subtitle">Nhật ký tác vụ thời gian thực trên hệ thống MIXIMOI</p>
                            </div>
                            <button class="btn btn-sm btn-light border btn-activity-refresh" title="Làm mới nhật ký">
                                <i class="bi bi-arrow-clockwise fs-6 text-muted"></i>
                            </button>
                        </div>

                        <!-- Activity Items List (Dữ liệu thực tế từ database) -->
                        <div class="activity-feed-full my-2">
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <c:forEach items="${recentActivities}" var="act">
                                        <div class="activity-item-clean">
                                            <div class="activity-left-side">
                                                <div class="activity-icon-round" style="background: ${act.iconBg}; color: ${act.iconColor};">
                                                    <i class="bi ${act.icon}"></i>
                                                </div>
                                                <div class="activity-desc-wrapper">
                                                    <div class="activity-main-line">
                                                        ${act.title}
                                                    </div>
                                                    <div class="activity-badge-row">
                                                        <span class="badge ${act.badgeClass} py-1 px-2">${act.badge}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <span class="activity-time-stamp">${act.timeAgo}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-3 text-muted">
                                        <i class="bi bi-info-circle me-1"></i> Chưa có hoạt động mới nào trong hệ thống.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Footer -->
                        <div class="pt-3 border-top text-center">
                            <a href="${pageContext.request.contextPath}/reports" class="text-primary fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 0.83rem;">
                                Xem toàn bộ hoạt động & báo cáo <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- Dữ liệu thực tế từ PostgreSQL cho Chart.js -->
<script>
window.dashboardChartData = {
    growthTrend: {
        labels: [
            <c:forEach items="${monthlyGrowthTrend.labels}" var="l" varStatus="loop">
                "${l}"${!loop.last ? ',' : ''}
            </c:forEach>
        ],
        data: [
            <c:forEach items="${monthlyGrowthTrend.data}" var="d" varStatus="loop">
                ${d}${!loop.last ? ',' : ''}
            </c:forEach>
        ]
    },
    donut: {
        dept: {
            labels: [
                <c:forEach items="${personnelStructure.deptList}" var="dept" varStatus="loop">
                    "${dept.name}"${!loop.last ? ',' : ''}
                </c:forEach>
            ],
            data: [
                <c:forEach items="${personnelStructure.deptList}" var="dept" varStatus="loop">
                    ${dept.count}${!loop.last ? ',' : ''}
                </c:forEach>
            ],
            colors: [
                <c:forEach items="${personnelStructure.deptList}" var="dept" varStatus="loop">
                    "${dept.color}"${!loop.last ? ',' : ''}
                </c:forEach>
            ]
        },
        gender: {
            labels: ['Nam', 'Nữ'],
            data: [${personnelStructure.maleCount != null ? personnelStructure.maleCount : 0}, ${personnelStructure.femaleCount != null ? personnelStructure.femaleCount : 0}],
            colors: ['#2563eb', '#ec4899']
        },
        age: {
            labels: ['18 - 25 tuổi', '25 - 35 tuổi', '35 - 45 tuổi', '45 - 55 tuổi', 'Trên 55'],
            data: [
                ${personnelStructure.ageUnder25 != null ? personnelStructure.ageUnder25 : 0},
                ${personnelStructure.age25to35 != null ? personnelStructure.age25to35 : 0},
                ${personnelStructure.age35to45 != null ? personnelStructure.age35to45 : 0},
                ${personnelStructure.age45to55 != null ? personnelStructure.age45to55 : 0},
                ${personnelStructure.ageOver55 != null ? personnelStructure.ageOver55 : 0}
            ],
            colors: ['#38bdf8', '#2563eb', '#6366f1', '#f59e0b', '#94a3b8']
        }
    }
};
</script>

<!-- Specific Dashboard Charts & Interactions Script -->
<script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>

</body>
</html>
