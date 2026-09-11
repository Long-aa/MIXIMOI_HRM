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

                <div class="welcome-actions">
                    <button class="btn-action-light" type="button" id="btnExportReport">
                        <i class="bi bi-box-arrow-up"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <button class="btn-action-light" type="button" id="btnGenerateComposite">
                        <i class="bi bi-file-earmark-text"></i>
                        <span>Tạo báo cáo tổng hợp</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/employees?action=new" class="btn-action-primary">
                        <i class="bi bi-plus-lg"></i>
                        <span>+ Thêm nhân viên</span>
                    </a>
                </div>
            </div>

            <!-- 2. Multi-Criteria Filter Bar (Bộ lọc đa chiều) -->
            <div class="dashboard-filter-card">
                <div class="filter-row-top">
                    <div class="filter-controls-group">
                        <select class="filter-select" id="filterMonth">
                            <option value="9" selected>Tháng 09/2026</option>
                            <option value="8">Tháng 08/2026</option>
                            <option value="7">Tháng 07/2026</option>
                            <option value="6">Tháng 06/2026</option>
                        </select>

                        <select class="filter-select" id="filterDepartment">
                            <option value="all" selected>Tất cả phòng ban</option>
                            <option value="sales">Kinh doanh & Bán hàng</option>
                            <option value="it">Công nghệ & R&D</option>
                            <option value="marketing">Marketing & Truyền thông</option>
                            <option value="finance">Tài chính - Kế toán</option>
                            <option value="hr">Hành chính - Nhân sự</option>
                        </select>

                        <select class="filter-select" id="filterBranch">
                            <option value="all" selected>Tất cả chi nhánh</option>
                            <option value="hanoi">Hà Nội (Trụ sở chính)</option>
                            <option value="hcm">TP. Hồ Chí Minh</option>
                            <option value="danang">Đà Nẵng</option>
                        </select>

                        <select class="filter-select" id="filterStatus">
                            <option value="all" selected>Tất cả trạng thái</option>
                            <option value="active">Đang làm việc</option>
                            <option value="probation">Thử việc</option>
                            <option value="leave">Đang nghỉ phép</option>
                        </select>
                    </div>

                    <button type="button" class="btn-filter-refresh" id="btnRefreshFilters" title="Làm mới bộ lọc">
                        <i class="bi bi-arrow-clockwise"></i>
                        <span>Làm mới</span>
                    </button>
                </div>

                <!-- Segmented Period Tabs -->
                <div class="period-segments-wrapper">
                    <button type="button" class="period-tab-btn" data-range="today">Hôm nay</button>
                    <button type="button" class="period-tab-btn" data-range="week">Tuần này</button>
                    <button type="button" class="period-tab-btn active" data-range="month">Tháng này</button>
                    <button type="button" class="period-tab-btn" data-range="quarter">Quý này</button>
                    <button type="button" class="period-tab-btn" data-range="year">Năm nay</button>
                    <button type="button" class="period-tab-btn" data-range="custom">Tùy chỉnh</button>
                </div>
            </div>

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
                                    <span class="kpi-value">
                                        <c:choose>
                                            <c:when test="${totalEmployees != null and totalEmployees > 0}">${totalEmployees}</c:when>
                                            <c:otherwise>245</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit">nhân sự</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-arrow-up-short"></i> +4.2%
                            </span>
                            <span class="text-muted">so với tháng trước</span>
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
                                    <span class="kpi-value">232</span>
                                    <span class="kpi-unit">nhân sự</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-person-check-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-arrow-up-short"></i> +3.1%
                            </span>
                            <span class="text-muted">Năng suất tại các công ty</span>
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
                                    <span class="kpi-value">12</span>
                                    <span class="kpi-unit">tuyển mới</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-person-plus-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge" style="background:#eff6ff; color:#2563eb;">
                                <i class="bi bi-arrow-up-short"></i> +20%
                            </span>
                            <span class="text-muted">so với tháng trước</span>
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
                                    <span class="kpi-value">3</span>
                                    <span class="kpi-unit">nghỉ việc</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box coral">
                                <i class="bi bi-person-dash-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-arrow-down-short"></i> -12%
                            </span>
                            <span class="text-muted">Tỷ lệ biến động giảm</span>
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
                                    <span class="kpi-value">12</span>
                                    <span class="kpi-unit">đơn vị</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-buildings-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="kpi-chip-soft">+1 phòng ban mới</span>
                            <span class="text-muted">Bộ phận AI Lab</span>
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
                                        <c:choose>
                                            <c:when test="${totalPayroll != null}">
                                                <fmt:formatNumber value="${totalPayroll}" type="number" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>850.000.000</c:otherwise>
                                        </c:choose>
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
                                <i class="bi bi-arrow-up-short"></i> +3.5%
                            </span>
                            <span class="text-muted">Kỳ: T09/2026</span>
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
                                    <span class="kpi-value text-warning" style="color: #ea580c !important;">08</span>
                                    <span class="kpi-unit">hợp đồng</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box amber">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="kpi-chip-warning">
                                <i class="bi bi-dot fs-5 p-0"></i> Có cảnh báo
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
                                    <span class="kpi-value text-primary">
                                        <c:choose>
                                            <c:when test="${pendingLeaves != null and pendingLeaves > 0}">
                                                ${pendingLeaves}
                                            </c:when>
                                            <c:otherwise>12</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit">yêu cầu</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-clipboard2-check-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="kpi-chip-soft">Còn xử lý</span>
                            <span class="text-danger fw-semibold">Cần xử lý gấp</span>
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
                                <p class="app-card-subtitle">Xu hướng nhân sự trong 6 tháng gần nhất (Tháng 4 - Tháng 9/2026)</p>
                            </div>

                            <div class="d-flex align-items-center gap-3 flex-wrap">
                                <!-- Legend Indicators -->
                                <div class="chart-header-badges">
                                    <span><span class="badge-dot-indicator" style="background-color: #2563eb;"></span>Tổng NS</span>
                                    <span><span class="badge-dot-indicator" style="background-color: #10b981;"></span>Mới (+12)</span>
                                    <span><span class="badge-dot-indicator" style="background-color: #ef4444;"></span>Nghỉ (-3)</span>
                                </div>

                                <!-- Filter dropdown -->
                                <button type="button" class="btn btn-sm btn-light border py-1 px-2 fw-semibold text-secondary" style="font-size: 0.78rem;">
                                    6 tháng gần nhất <i class="bi bi-chevron-down ms-1"></i>
                                </button>
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
                                    <p class="app-card-subtitle">Phân bố 245 nhân sự trong công ty</p>
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
                                    <div class="donut-center-val">245</div>
                                    <div class="donut-center-label">Tổng nhân sự</div>
                                </div>
                            </div>
                        </div>

                        <!-- 2-Column Legend Grid Matching Mockup -->
                        <div class="donut-legend-row">
                            <div class="donut-legend-item">
                                <span class="legend-label">
                                    <span class="color-square" style="background-color: #2563eb;"></span>
                                    Kinh doanh
                                </span>
                                <span class="legend-val">28% <span class="text-muted fw-normal">(68)</span></span>
                            </div>
                            <div class="donut-legend-item">
                                <span class="legend-label">
                                    <span class="color-square" style="background-color: #0ea5e9;"></span>
                                    CNTT & R&D
                                </span>
                                <span class="legend-val">22% <span class="text-muted fw-normal">(54)</span></span>
                            </div>
                            <div class="donut-legend-item">
                                <span class="legend-label">
                                    <span class="color-square" style="background-color: #f97316;"></span>
                                    Marketing
                                </span>
                                <span class="legend-val">18% <span class="text-muted fw-normal">(44)</span></span>
                            </div>
                            <div class="donut-legend-item">
                                <span class="legend-label">
                                    <span class="color-square" style="background-color: #10b981;"></span>
                                    Kế toán
                                </span>
                                <span class="legend-val">15% <span class="text-muted fw-normal">(37)</span></span>
                            </div>
                            <div class="donut-legend-item">
                                <span class="legend-label">
                                    <span class="color-square" style="background-color: #8b5cf6;"></span>
                                    Nhân sự
                                </span>
                                <span class="legend-val">10% <span class="text-muted fw-normal">(25)</span></span>
                            </div>
                            <div class="donut-legend-item">
                                <span class="legend-label">
                                    <span class="color-square" style="background-color: #64748b;"></span>
                                    Khác
                                </span>
                                <span class="legend-val">7% <span class="text-muted fw-normal">(17)</span></span>
                            </div>
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
                                    <div class="app-card-title">Tình hình chấm công hôm nay</div>
                                    <p class="app-card-subtitle">Tổng số nhân sự theo lịch trực: <strong>245</strong></p>
                                </div>
                                <span class="badge bg-success-subtle text-success px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    ● Trực tiếp
                                </span>
                            </div>

                            <!-- Stacked Progress Bar -->
                            <div class="attendance-stacked-bar">
                                <div class="attendance-stacked-segment" style="width: 88%; background-color: #10b981;" title="Đúng giờ: 88%"></div>
                                <div class="attendance-stacked-segment" style="width: 5%; background-color: #f59e0b;" title="Đi muộn/Về sớm: 5%"></div>
                                <div class="attendance-stacked-segment" style="width: 3%; background-color: #3b82f6;" title="Nghỉ có lương: 3%"></div>
                                <div class="attendance-stacked-segment" style="width: 1%; background-color: #ef4444;" title="Vắng không phép: 1%"></div>
                            </div>

                            <!-- Breakdown Items -->
                            <div class="attendance-breakdown-list">
                                <div class="attendance-item">
                                    <span class="attendance-item-label">
                                        <span class="badge-dot-indicator" style="background-color: #10b981;"></span>
                                        Đi làm đúng giờ
                                    </span>
                                    <span class="attendance-item-val text-success">215 nhân sự (88%)</span>
                                </div>
                                <div class="attendance-item">
                                    <span class="attendance-item-label">
                                        <span class="badge-dot-indicator" style="background-color: #f59e0b;"></span>
                                        Đi muộn / Về sớm
                                    </span>
                                    <span class="attendance-item-val text-warning" style="color:#d97706 !important;">12 nhân sự (5%)</span>
                                </div>
                                <div class="attendance-item">
                                    <span class="attendance-item-label">
                                        <span class="badge-dot-indicator" style="background-color: #3b82f6;"></span>
                                        Nghỉ phép có lương
                                    </span>
                                    <span class="attendance-item-val text-primary">8 nhân sự (3%)</span>
                                </div>
                                <div class="attendance-item">
                                    <span class="attendance-item-label">
                                        <span class="badge-dot-indicator" style="background-color: #ef4444;"></span>
                                        Vắng mặt không phép
                                    </span>
                                    <span class="attendance-item-val text-danger">2 nhân sự (1%)</span>
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
                                    <p class="app-card-subtitle">Quỹ phép toàn công ty: <strong>450.5 ngày</strong></p>
                                </div>
                                <span class="badge bg-primary-subtle text-primary px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    Năm 2026
                                </span>
                            </div>

                            <!-- Dual Bar & Labels -->
                            <div class="leave-dual-bar">
                                <div class="leave-bar-used" style="width: 27%;"></div>
                                <div class="leave-bar-remain" style="width: 73%;"></div>
                            </div>
                            <div class="leave-dual-labels">
                                <span>Đã dùng: <strong>120</strong></span>
                                <span>Còn lại: <strong>330.5</strong></span>
                            </div>

                            <!-- Highlight Callout Box -->
                            <div class="leave-callout-card">
                                <div>
                                    <div class="leave-callout-title">Đơn chờ duyệt</div>
                                    <div class="d-flex align-items-baseline">
                                        <span class="leave-callout-number">12</span>
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
                                        <span class="urgent-num-badge orange">6</span>
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
                                        <span class="urgent-num-badge blue">12</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Đơn nghỉ phép cần duyệt</span>
                                            <span class="urgent-task-sub">4 đơn nghỉ phép gấp hôm nay</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/leave" class="urgent-action-btn">
                                        Duyệt ngay <i class="bi bi-chevron-right"></i>
                                    </a>
                                </div>

                                <!-- Item 3 -->
                                <div class="urgent-task-item">
                                    <div class="urgent-task-left">
                                        <span class="urgent-num-badge purple">3</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Hồ sơ nhân viên chưa hoàn tất</span>
                                            <span class="urgent-task-sub">Thiếu công chứng, MST, BHXH</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/employees" class="urgent-action-btn">
                                        Kiểm tra <i class="bi bi-chevron-right"></i>
                                    </a>
                                </div>

                                <!-- Item 4 -->
                                <div class="urgent-task-item">
                                    <div class="urgent-task-left">
                                        <span class="urgent-num-badge orange">2</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Yêu cầu tuyển dụng chờ xử lý</span>
                                            <span class="urgent-task-sub">Từ team Kỹ thuật & Sales</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/recruitment" class="urgent-action-btn">
                                        Xem yêu cầu <i class="bi bi-chevron-right"></i>
                                    </a>
                                </div>

                                <!-- Item 5 -->
                                <div class="urgent-task-item">
                                    <div class="urgent-task-left">
                                        <span class="urgent-num-badge red">1</span>
                                        <div class="urgent-task-info">
                                            <span class="urgent-task-title">Chưa cập nhật thông tin</span>
                                            <span class="urgent-task-sub">Cần bổ sung STK & BHXH</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/employees" class="urgent-action-btn">
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
                                    <p class="app-card-subtitle">Chi tiết phân bổ ngân sách tiền lương kỳ Tháng 09/2026</p>
                                </div>
                                <span class="badge bg-primary-subtle text-primary px-3 py-2 fw-bold" style="font-size:0.95rem;">
                                    850.000.000 đ
                                </span>
                            </div>

                            <!-- 5 Mini Stats Pills -->
                            <div class="payroll-stats-bar">
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Tổng quỹ</div>
                                    <div class="payroll-stat-value text-primary">850 Tr đ</div>
                                </div>
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Lương cơ bản</div>
                                    <div class="payroll-stat-value">650 Tr đ</div>
                                </div>
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Phụ cấp</div>
                                    <div class="payroll-stat-value">75 Tr đ</div>
                                </div>
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Thưởng</div>
                                    <div class="payroll-stat-value">65 Tr đ</div>
                                </div>
                                <div class="payroll-stat-pill">
                                    <div class="payroll-stat-label">Khống chế</div>
                                    <div class="payroll-stat-value">60 Tr đ</div>
                                </div>
                            </div>

                            <!-- Department Progress Bars -->
                            <div class="dept-payroll-list my-3">
                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Kinh doanh & Bán hàng</span>
                                        <span class="dept-amount">260.000.000 đ <span class="text-muted fw-normal">(31%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 31%; background-color: #2563eb;"></div>
                                    </div>
                                </div>

                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Công nghệ & R&D</span>
                                        <span class="dept-amount">240.000.000 đ <span class="text-muted fw-normal">(28%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 28%; background-color: #2563eb;"></div>
                                    </div>
                                </div>

                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Marketing & Truyền thông</span>
                                        <span class="dept-amount">150.000.000 đ <span class="text-muted fw-normal">(18%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 18%; background-color: #3b82f6;"></div>
                                    </div>
                                </div>

                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Tài chính - Kế toán</span>
                                        <span class="dept-amount">110.000.000 đ <span class="text-muted fw-normal">(13%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 13%; background-color: #60a5fa;"></div>
                                    </div>
                                </div>

                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Hành chính - Nhân sự</span>
                                        <span class="dept-amount">90.000.000 đ <span class="text-muted fw-normal">(10%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 10%; background-color: #93c5fd;"></div>
                                    </div>
                                </div>
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
                                    Q3 / 2026
                                </span>
                            </div>

                            <!-- 4 Pipeline Metrics -->
                            <div class="recruitment-metric-grid">
                                <div class="recruitment-metric-box">
                                    <div class="recruitment-metric-val text-primary">12</div>
                                    <div class="recruitment-metric-label">Vị trí mở</div>
                                </div>
                                <div class="recruitment-metric-box">
                                    <div class="recruitment-metric-val text-info">88</div>
                                    <div class="recruitment-metric-label">Ứng viên nộp</div>
                                </div>
                                <div class="recruitment-metric-box">
                                    <div class="recruitment-metric-val text-warning" style="color:#d97706 !important;">24</div>
                                    <div class="recruitment-metric-label">Phỏng vấn</div>
                                </div>
                                <div class="recruitment-metric-box">
                                    <div class="recruitment-metric-val text-success">08</div>
                                    <div class="recruitment-metric-label">Đã nhận việc</div>
                                </div>
                            </div>

                            <!-- Funnel Stages -->
                            <div class="funnel-list my-3">
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Ứng viên mới</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: 100%; background-color: #6366f1;">88 hồ sơ</div>
                                    </div>
                                </div>
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Đã sàng lọc</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: 61%; background-color: #3b82f6;">54 hồ sơ</div>
                                    </div>
                                </div>
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Phỏng vấn</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: 27%; background-color: #f59e0b;">24 ứng viên</div>
                                    </div>
                                </div>
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Đề xuất tuyển</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: 11%; background-color: #06b6d4;">10</div>
                                    </div>
                                </div>
                                <div class="funnel-row">
                                    <span class="funnel-stage-name">Đã tuyển thành công</span>
                                    <div class="funnel-bar-container">
                                        <div class="funnel-bar-fill" style="width: 9%; background-color: #10b981;">8</div>
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
                                <div class="kpi-dept-item">
                                    <div class="kpi-dept-header">
                                        <span class="kpi-dept-name">Kinh doanh & Bán hàng</span>
                                        <div>
                                            <span class="kpi-eval-badge good">+100% Tốt</span>
                                            <strong class="ms-2">90%</strong>
                                        </div>
                                    </div>
                                    <div class="kpi-progress-bar-bg">
                                        <div class="kpi-progress-fill green" style="width: 90%;"></div>
                                    </div>
                                </div>

                                <div class="kpi-dept-item">
                                    <div class="kpi-dept-header">
                                        <span class="kpi-dept-name">Công nghệ & R&D</span>
                                        <div>
                                            <span class="kpi-eval-badge good">+100% Tốt</span>
                                            <strong class="ms-2">95%</strong>
                                        </div>
                                    </div>
                                    <div class="kpi-progress-bar-bg">
                                        <div class="kpi-progress-fill green" style="width: 95%;"></div>
                                    </div>
                                </div>

                                <div class="kpi-dept-item">
                                    <div class="kpi-dept-header">
                                        <span class="kpi-dept-name">Marketing & Truyền thông</span>
                                        <div>
                                            <span class="kpi-eval-badge warning">78/100% Cần cải thiện</span>
                                            <strong class="ms-2">68%</strong>
                                        </div>
                                    </div>
                                    <div class="kpi-progress-bar-bg">
                                        <div class="kpi-progress-fill orange" style="width: 68%;"></div>
                                    </div>
                                </div>

                                <div class="kpi-dept-item">
                                    <div class="kpi-dept-header">
                                        <span class="kpi-dept-name">Tài chính - Kế toán</span>
                                        <div>
                                            <span class="kpi-eval-badge good">+100% Tốt</span>
                                            <strong class="ms-2">94%</strong>
                                        </div>
                                    </div>
                                    <div class="kpi-progress-bar-bg">
                                        <div class="kpi-progress-fill green" style="width: 94%;"></div>
                                    </div>
                                </div>

                                <div class="kpi-dept-item">
                                    <div class="kpi-dept-header">
                                        <span class="kpi-dept-name">Hành chính - Nhân sự</span>
                                        <div>
                                            <span class="kpi-eval-badge good">+100% Tốt</span>
                                            <strong class="ms-2">96%</strong>
                                        </div>
                                    </div>
                                    <div class="kpi-progress-bar-bg">
                                        <div class="kpi-progress-fill green" style="width: 96%;"></div>
                                    </div>
                                </div>
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
                                            <span class="age-dist-val">18% <span class="text-muted fw-normal">(44 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 18%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label fw-bold text-primary">25 – 35 tuổi</span>
                                            <span class="age-dist-val text-primary">52% <span class="text-muted fw-normal">(128 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill highlight" style="width: 52%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">35 – 45 tuổi (Lực lượng nòng cốt)</span>
                                            <span class="age-dist-val">18% <span class="text-muted fw-normal">(44 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 18%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">45 – 55 tuổi</span>
                                            <span class="age-dist-val">12% <span class="text-muted fw-normal">(30 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 12%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">Trên 55 tuổi</span>
                                            <span class="age-dist-val">5% <span class="text-muted fw-normal">(11 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 5%;"></div>
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
                                                <i class="bi bi-gender-male fs-6"></i> Nam: <strong>55%</strong> <span class="text-muted fw-normal">(135 NS)</span>
                                            </span>
                                            <span class="fw-bold text-danger d-flex align-items-center gap-1">
                                                <i class="bi bi-gender-female fs-6"></i> Nữ: <strong>45%</strong> <span class="text-muted fw-normal">(110 NS)</span>
                                            </span>
                                        </div>
                                        <div class="gender-dual-bar" style="height: 10px; border-radius: 9999px;">
                                            <div class="gender-bar-male" style="width: 55%;"></div>
                                            <div class="gender-bar-female" style="width: 45%;"></div>
                                        </div>
                                    </div>

                                    <!-- Cơ cấu theo khối chức năng -->
                                    <div class="age-dist-list">
                                        <div class="age-dist-item">
                                            <div class="age-dist-header">
                                                <span class="age-dist-label">Cấp Quản lý & Lãnh đạo</span>
                                                <span class="age-dist-val" style="font-size: 0.76rem;">
                                                    <span class="text-primary fw-bold">♂ 58%</span> <span class="text-muted fw-normal">(14)</span> &nbsp;|&nbsp; 
                                                    <span class="text-danger fw-bold">♀ 42%</span> <span class="text-muted fw-normal">(10)</span>
                                                </span>
                                            </div>
                                            <div class="gender-dual-bar" style="height: 7px; border-radius: 9999px;">
                                                <div class="gender-bar-male" style="width: 58%;"></div>
                                                <div class="gender-bar-female" style="width: 42%;"></div>
                                            </div>
                                        </div>

                                        <div class="age-dist-item">
                                            <div class="age-dist-header">
                                                <span class="age-dist-label">Khối Công nghệ & R&D</span>
                                                <span class="age-dist-val" style="font-size: 0.76rem;">
                                                    <span class="text-primary fw-bold">♂ 78%</span> <span class="text-muted fw-normal">(42)</span> &nbsp;|&nbsp; 
                                                    <span class="text-danger fw-bold">♀ 22%</span> <span class="text-muted fw-normal">(12)</span>
                                                </span>
                                            </div>
                                            <div class="gender-dual-bar" style="height: 7px; border-radius: 9999px;">
                                                <div class="gender-bar-male" style="width: 78%;"></div>
                                                <div class="gender-bar-female" style="width: 22%;"></div>
                                            </div>
                                        </div>

                                        <div class="age-dist-item">
                                            <div class="age-dist-header">
                                                <span class="age-dist-label">Khối Kinh doanh & Marketing</span>
                                                <span class="age-dist-val" style="font-size: 0.76rem;">
                                                    <span class="text-primary fw-bold">♂ 46%</span> <span class="text-muted fw-normal">(38)</span> &nbsp;|&nbsp; 
                                                    <span class="text-danger fw-bold">♀ 54%</span> <span class="text-muted fw-normal">(45)</span>
                                                </span>
                                            </div>
                                            <div class="gender-dual-bar" style="height: 7px; border-radius: 9999px;">
                                                <div class="gender-bar-male" style="width: 46%;"></div>
                                                <div class="gender-bar-female" style="width: 54%;"></div>
                                            </div>
                                        </div>

                                        <div class="age-dist-item">
                                            <div class="age-dist-header">
                                                <span class="age-dist-label">Khối Tài chính & Hành chính HR</span>
                                                <span class="age-dist-val" style="font-size: 0.76rem;">
                                                    <span class="text-primary fw-bold">♂ 35%</span> <span class="text-muted fw-normal">(15)</span> &nbsp;|&nbsp; 
                                                    <span class="text-danger fw-bold">♀ 65%</span> <span class="text-muted fw-normal">(28)</span>
                                                </span>
                                            </div>
                                            <div class="gender-dual-bar" style="height: 7px; border-radius: 9999px;">
                                                <div class="gender-bar-male" style="width: 35%;"></div>
                                                <div class="gender-bar-female" style="width: 65%;"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- TAB 3: THÂM NIÊN -->
                            <div class="structure-tab-pane" id="structure-pane-seniority">
                                <div class="age-dist-list my-3">
                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">Dưới 1 năm (Tân binh & Thử việc)</span>
                                            <span class="age-dist-val">24% <span class="text-muted fw-normal">(59 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 24%; background: #38bdf8;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label fw-bold text-primary">1 – 3 năm (Cống hiến ổn định)</span>
                                            <span class="age-dist-val text-primary">38% <span class="text-muted fw-normal">(93 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill highlight" style="width: 38%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">3 – 5 năm (Chuyên viên nòng cốt)</span>
                                            <span class="age-dist-val">22% <span class="text-muted fw-normal">(54 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 22%; background: #6366f1;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label">Trên 5 năm (Cán bộ nguồn & Gắn bó)</span>
                                            <span class="age-dist-val text-success">16% <span class="text-muted fw-normal">(39 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 16%; background: #10b981;"></div>
                                        </div>
                                    </div>

                                    <!-- Gắn kết card -->
                                    <div class="p-2 px-3 rounded-2 mt-1 d-flex align-items-center justify-content-between" style="background: #f0fdf4; border: 1px dashed #86efac; font-size: 0.77rem;">
                                        <div class="text-success fw-semibold d-flex align-items-center gap-1">
                                            <i class="bi bi-shield-check fs-6"></i> Tỷ lệ nhân sự gắn bó trên 1 năm: <strong>76.0%</strong>
                                        </div>
                                        <span class="badge bg-success text-white">Chỉ số ổn định cao</span>
                                    </div>
                                </div>
                            </div>

                            <!-- TAB 4: TRÌNH ĐỘ (NEW TAB) -->
                            <div class="structure-tab-pane" id="structure-pane-education">
                                <div class="age-dist-list my-3">
                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label d-flex align-items-center gap-1">
                                                <i class="bi bi-mortarboard-fill text-purple"></i>
                                                <span>Sau Đại học (Thạc sĩ, Tiến sĩ)</span>
                                                <span class="badge bg-purple-subtle ms-1" style="font-size:0.68rem;">Chuyên gia</span>
                                            </span>
                                            <span class="age-dist-val text-purple">8% <span class="text-muted fw-normal">(20 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 8%; background: #8b5cf6;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label fw-bold text-primary d-flex align-items-center gap-1">
                                                <i class="bi bi-award-fill text-primary"></i>
                                                <span>Đại học chính quy (Cử nhân, Kỹ sư)</span>
                                                <span class="badge bg-primary-subtle text-primary ms-1" style="font-size:0.68rem;">Lực lượng chủ lực</span>
                                            </span>
                                            <span class="age-dist-val text-primary">68% <span class="text-muted fw-normal">(167 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill highlight" style="width: 68%;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label d-flex align-items-center gap-1">
                                                <i class="bi bi-journal-bookmark text-info"></i>
                                                <span>Cao đẳng chuyên nghiệp</span>
                                            </span>
                                            <span class="age-dist-val">16% <span class="text-muted fw-normal">(39 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 16%; background: #0ea5e9;"></div>
                                        </div>
                                    </div>

                                    <div class="age-dist-item">
                                        <div class="age-dist-header">
                                            <span class="age-dist-label d-flex align-items-center gap-1">
                                                <i class="bi bi-tools text-secondary"></i>
                                                <span>Trung cấp &amp; Chứng chỉ nghề</span>
                                            </span>
                                            <span class="age-dist-val">8% <span class="text-muted fw-normal">(19 nhân sự)</span></span>
                                        </div>
                                        <div class="age-dist-bar-bg">
                                            <div class="age-dist-bar-fill" style="width: 8%; background: #64748b;"></div>
                                        </div>
                                    </div>

                                    <!-- Chứng chỉ quốc tế highlight -->
                                    <div class="p-2 px-3 rounded-2 mt-1 d-flex align-items-center justify-content-between" style="background: #eff6ff; border: 1px dashed #bfdbfe; font-size: 0.77rem;">
                                        <div class="text-primary fw-semibold d-flex align-items-center gap-1">
                                            <i class="bi bi-patch-check-fill fs-6 text-primary"></i> Trình độ từ Đại học trở lên: <strong>76.3%</strong> (187 NS)
                                        </div>
                                        <span class="badge bg-primary text-white">42 Chứng chỉ quốc tế</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 2 Demographic Subcards (Dynamic theo tab) -->
                        <div class="demographic-subcards" id="structureSubcards">
                            <div class="demo-subcard">
                                <div class="demo-subcard-title" id="structureSub1Title">Tỷ lệ giới tính</div>
                                <div class="demo-subcard-val text-primary" id="structureSub1Val">
                                    <i class="bi bi-gender-male"></i> Nam: 55% &nbsp;|&nbsp; <i class="bi bi-gender-female text-danger"></i> Nữ: 45%
                                </div>
                            </div>
                            <div class="demo-subcard">
                                <div class="demo-subcard-title" id="structureSub2Title">Thâm niên trung bình</div>
                                <div class="demo-subcard-val text-success" id="structureSub2Val">
                                    2.8 năm <span class="text-muted fw-normal">(38% từ 1-3 năm)</span>
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

                        <!-- Activity Items List -->
                        <div class="activity-feed-full my-2">
                            <!-- Item 1 -->
                            <div class="activity-item-clean">
                                <div class="activity-left-side">
                                    <div class="activity-icon-round" style="background: linear-gradient(135deg, #3b82f6, #1d4ed8); color: white;">
                                        <i class="bi bi-person-fill"></i>
                                    </div>
                                    <div class="activity-desc-wrapper">
                                        <div class="activity-main-line">
                                            <strong>Nguyễn Văn An</strong> (IT Specialist) đã tiếp nhận và làm hồ sơ nhân viên mới cho <strong>Lê Quốc Tín</strong>
                                        </div>
                                        <div class="activity-badge-row">
                                            <span class="activity-pill-tag">Phòng IT</span>
                                            <span class="activity-pill-tag">Backend Engineer</span>
                                        </div>
                                    </div>
                                </div>
                                <span class="activity-time-stamp">3 phút trước</span>
                            </div>

                            <!-- Item 2 -->
                            <div class="activity-item-clean">
                                <div class="activity-left-side">
                                    <div class="activity-icon-round" style="background: #eff6ff; color: #2563eb;">
                                        <i class="bi bi-person-vcard"></i>
                                    </div>
                                    <div class="activity-desc-wrapper">
                                        <div class="activity-main-line">
                                            <strong>Trần Thị B</strong> (Kế toán) đã cập nhật thông tin cá nhân số CCCD gắn chip và tài khoản ngân hàng VCB.
                                        </div>
                                        <div class="activity-badge-row">
                                            <span class="badge bg-success-subtle text-success py-1 px-2">Đã xác minh</span>
                                        </div>
                                    </div>
                                </div>
                                <span class="activity-time-stamp">15 phút trước</span>
                            </div>

                            <!-- Item 3 -->
                            <div class="activity-item-clean">
                                <div class="activity-left-side">
                                    <div class="activity-icon-round" style="background: #ecfdf5; color: #10b981;">
                                        <i class="bi bi-calendar2-check"></i>
                                    </div>
                                    <div class="activity-desc-wrapper">
                                        <div class="activity-main-line">
                                            <strong>Lê Văn C</strong> (Trưởng nhóm Kinh doanh) được phê duyệt đơn nghỉ phép 2 ngày bởi Giám đốc Chi nhánh.
                                        </div>
                                        <div class="activity-badge-row">
                                            <span class="text-muted" style="font-size: 0.72rem;">Đơn: #NP-2026-88</span>
                                        </div>
                                    </div>
                                </div>
                                <span class="activity-time-stamp">45 phút trước</span>
                            </div>

                            <!-- Item 4 -->
                            <div class="activity-item-clean">
                                <div class="activity-left-side">
                                    <div class="activity-icon-round" style="background: #f5f3ff; color: #8b5cf6;">
                                        <i class="bi bi-briefcase-fill"></i>
                                    </div>
                                    <div class="activity-desc-wrapper">
                                        <div class="activity-main-line">
                                            <strong>Phòng IT</strong> đã tạo yêu cầu tuyển dụng mới: <strong>Senior DevOps Engineer (02 nhân sự)</strong>.
                                        </div>
                                        <div class="activity-badge-row">
                                            <span class="activity-pill-tag">IT Operations</span>
                                        </div>
                                    </div>
                                </div>
                                <span class="activity-time-stamp">2 giờ trước</span>
                            </div>

                            <!-- Item 5 -->
                            <div class="activity-item-clean">
                                <div class="activity-left-side">
                                    <div class="activity-icon-round" style="background: #fffbeb; color: #f59e0b;">
                                        <i class="bi bi-file-earmark-text-fill"></i>
                                    </div>
                                    <div class="activity-desc-wrapper">
                                        <div class="activity-main-line">
                                            <strong>Admin</strong> đã gia hạn thành công và ký điện tử hợp đồng lao động mới mã <strong>HĐLĐ-2026-102</strong>.
                                        </div>
                                        <div class="activity-badge-row">
                                            <span class="badge bg-warning-subtle text-warning py-1 px-2" style="color: #c2410c !important;">Thời hạn 3 năm</span>
                                        </div>
                                    </div>
                                </div>
                                <span class="activity-time-stamp">3 giờ trước</span>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="pt-3 border-top text-center">
                            <a href="#" class="text-primary fw-bold text-decoration-none d-inline-flex align-items-center gap-1" style="font-size: 0.83rem;">
                                Xem toàn bộ hoạt động <i class="bi bi-arrow-right"></i>
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

<!-- Specific Dashboard Charts & Interactions Script -->
<script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>

</body>
</html>
