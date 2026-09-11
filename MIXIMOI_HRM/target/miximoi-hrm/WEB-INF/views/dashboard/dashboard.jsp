<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Dashboard Tổng Quan — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <!-- Chart.js for interactive analytics -->
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
                        <span class="welcome-version-badge">Enterprise HRM v2.4</span>
                    </div>
                    <div class="welcome-meta">
                        <span class="welcome-date-chip">
                            <i class="bi bi-calendar3 text-primary"></i>
                            <span data-dynamic-date>Hôm nay, Thứ Hai 15/09/2026</span>
                        </span>
                        <span class="d-none d-md-inline text-muted">|</span>
                        <span>Chúc bạn một ngày làm việc hiệu quả và tràn đầy năng lượng!</span>
                    </div>
                </div>

                <div class="welcome-actions">
                    <button class="btn-action-light" type="button">
                        <i class="bi bi-download"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/employees?action=new" class="btn-action-soft">
                        <i class="bi bi-person-plus"></i>
                        <span>Thêm nhân viên</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/payroll" class="btn-action-primary">
                        <i class="bi bi-credit-card-2-front"></i>
                        <span>Tạo bảng lương tháng</span>
                    </a>
                </div>
            </div>

            <!-- 2. Four Stat KPI Cards -->
            <div class="row g-3 mb-4">
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
                            <div class="kpi-icon-box">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-graph-up-arrow"></i> +3.2%
                            </span>
                            <span class="text-muted">+12 nhân viên trong tháng</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2: Cơ cấu phòng ban -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Cơ cấu phòng ban</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">12</span>
                                    <span class="kpi-unit">đơn vị</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box">
                                <i class="bi bi-buildings-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="fw-semibold text-dark">Hoạt động ổn định</span>
                            <span class="text-muted">100% chỉ tiêu nhân sự</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3: Tổng quỹ lương -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng quỹ lương</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-primary" style="font-size: 1.6rem;">
                                        <c:choose>
                                            <c:when test="${totalPayroll != null}">
                                                <fmt:formatNumber value="${totalPayroll}" type="number" groupingUsed="true"/> đ
                                            </c:when>
                                            <c:otherwise>850.000.000 đ</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <div class="kpi-icon-box">
                                <i class="bi bi-wallet2"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span>Kỳ: T09/2026</span>
                            <span class="text-primary fw-semibold">96% đã hoàn tất chi trả</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4: Nghỉ phép hôm nay -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Nghỉ phép hôm nay</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">
                                        <c:choose>
                                            <c:when test="${pendingLeaves != null and pendingLeaves > 0}">0${pendingLeaves}</c:when>
                                            <c:otherwise>08</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit">trường hợp</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box">
                                <i class="bi bi-calendar2-week-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <div class="d-flex align-items-center gap-1">
                                <span class="badge bg-primary-subtle text-primary border-0">5 phép năm</span>
                                <span class="badge bg-danger-subtle text-danger border-0">3 ốm đau</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/leave" class="text-primary fw-semibold text-decoration-none">Chi tiết</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 3. Middle Row: Biến động nhân sự & Cơ cấu phòng ban -->
            <div class="row g-3 mb-4">
                <!-- Left: Biến động nhân sự (Line Chart) -->
                <div class="col-lg-8">
                    <div class="app-card">
                        <div class="app-card-header">
                            <div>
                                <div class="app-card-title">
                                    <span>Biến động nhân sự</span>
                                    <i class="bi bi-info-circle text-muted fs-6" title="Thống kê quy mô biến động nhân sự theo thời gian" style="cursor:help;"></i>
                                </div>
                                <p class="app-card-subtitle">Tăng trưởng liên tục 6 tháng qua (Tháng 4 - Tháng 9/2026)</p>
                            </div>

                            <!-- Filter Pills -->
                            <div class="card-filter-pills">
                                <button type="button" class="filter-pill active" data-period="6m">6 Tháng</button>
                                <button type="button" class="filter-pill" data-period="1y">Năm nay</button>
                                <button type="button" class="filter-pill" data-period="all">Tất cả</button>
                            </div>
                        </div>

                        <div style="height: 275px; position: relative;">
                            <canvas id="personnelGrowthChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Right: Cơ cấu phòng ban (Donut Chart) -->
                <div class="col-lg-4">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header mb-2">
                                <div>
                                    <div class="app-card-title">Cơ cấu phòng ban</div>
                                    <p class="app-card-subtitle">Phân bổ 245 nhân sự trên toàn hệ thống</p>
                                </div>
                            </div>

                            <!-- Donut Wrapper with Centered Text -->
                            <div class="donut-chart-wrapper my-2">
                                <canvas id="departmentDonutChart" width="180" height="180"></canvas>
                                <div class="donut-center-info">
                                    <div class="donut-center-val">245</div>
                                    <div class="donut-center-label">Tổng cộng</div>
                                </div>
                            </div>
                        </div>

                        <!-- Legend Items matching colors in mockup -->
                        <div class="legend-grid">
                            <div class="legend-item">
                                <span class="legend-name">
                                    <span class="legend-bullet" style="background-color: #2563eb;"></span>
                                    Kinh doanh
                                </span>
                                <span class="legend-pct">35%</span>
                            </div>
                            <div class="legend-item">
                                <span class="legend-name">
                                    <span class="legend-bullet" style="background-color: #0ea5e9;"></span>
                                    Công nghệ (IT)
                                </span>
                                <span class="legend-pct">25%</span>
                            </div>
                            <div class="legend-item">
                                <span class="legend-name">
                                    <span class="legend-bullet" style="background-color: #6366f1;"></span>
                                    Marketing
                                </span>
                                <span class="legend-pct">18%</span>
                            </div>
                            <div class="legend-item">
                                <span class="legend-name">
                                    <span class="legend-bullet" style="background-color: #38bdf8;"></span>
                                    Kế toán
                                </span>
                                <span class="legend-pct">12%</span>
                            </div>
                            <div class="legend-item" style="grid-column: span 2;">
                                <span class="legend-name">
                                    <span class="legend-bullet" style="background-color: #93c5fd;"></span>
                                    Nhân sự & Vận hành
                                </span>
                                <span class="legend-pct">10%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. Bottom Row: Quỹ lương theo phòng ban & Hoạt động gần đây -->
            <div class="row g-3">
                <!-- Left: Quỹ lương theo phòng ban -->
                <div class="col-lg-7">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">Quỹ lương theo phòng ban</div>
                                    <p class="app-card-subtitle">Tổng chi trả lương thực tế kỳ Tháng 09/2026</p>
                                </div>
                                <span class="badge bg-primary-subtle text-primary px-3 py-2 fw-bold" style="font-size:0.9rem;">
                                    850.000.000 đ
                                </span>
                            </div>

                            <!-- Progress list per department -->
                            <div class="dept-payroll-list my-3">
                                <!-- Department 1 -->
                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Kinh doanh & Bán hàng</span>
                                        <span class="dept-amount">260.000.000 đ <span class="text-muted fw-normal">(30.5%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 30.5%; background-color: #2563eb;"></div>
                                    </div>
                                </div>

                                <!-- Department 2 -->
                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Công nghệ thông tin & R&D</span>
                                        <span class="dept-amount">240.000.000 đ <span class="text-muted fw-normal">(28.2%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 28.2%; background-color: #2563eb;"></div>
                                    </div>
                                </div>

                                <!-- Department 3 -->
                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Marketing & Truyền thông</span>
                                        <span class="dept-amount">150.000.000 đ <span class="text-muted fw-normal">(17.6%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 17.6%; background-color: #3b82f6;"></div>
                                    </div>
                                </div>

                                <!-- Department 4 -->
                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Tài chính - Kế toán</span>
                                        <span class="dept-amount">110.000.000 đ <span class="text-muted fw-normal">(12.9%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 12.9%; background-color: #60a5fa;"></div>
                                    </div>
                                </div>

                                <!-- Department 5 -->
                                <div class="dept-payroll-item">
                                    <div class="dept-payroll-info">
                                        <span class="dept-name">Hành chính - Nhân sự</span>
                                        <span class="dept-amount">90.000.000 đ <span class="text-muted fw-normal">(10.6%)</span></span>
                                    </div>
                                    <div class="dept-progress">
                                        <div class="dept-progress-bar" style="width: 10.6%; background-color: #93c5fd;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Bottom Notice & Details Link -->
                        <div class="pt-3 border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem;">
                            <span class="text-muted d-flex align-items-center gap-1">
                                <i class="bi bi-shield-check text-primary fs-6"></i>
                                Đã bao gồm đóng bảo hiểm & thuế TNCN
                            </span>
                            <a href="${pageContext.request.contextPath}/payroll" class="text-primary fw-bold text-decoration-none d-flex align-items-center gap-1">
                                Xem chi tiết bảng lương <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Right: Hoạt động gần đây -->
                <div class="col-lg-5">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">Hoạt động gần đây</div>
                                    <p class="app-card-subtitle">Nhật ký tác vụ thời gian thực</p>
                                </div>
                                <button class="btn btn-sm btn-light border-0 btn-activity-refresh" title="Làm mới">
                                    <i class="bi bi-arrow-clockwise fs-6 text-muted"></i>
                                </button>
                            </div>

                            <!-- Activity Items -->
                            <div class="activity-feed my-2">
                                <!-- Activity 1 -->
                                <div class="activity-item">
                                    <div class="topbar-avatar-placeholder" style="width: 36px; height: 36px; font-size: 0.8rem; background: linear-gradient(135deg, #3b82f6, #1d4ed8);">
                                        A
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title-row">
                                            <span class="activity-title">Nguyễn Văn A</span>
                                            <span class="activity-time">2 phút trước</span>
                                        </div>
                                        <div class="activity-desc">Đã được tiếp nhận vào hệ thống MIXIMOI</div>
                                        <div class="activity-tags">
                                            <span class="activity-tag">Phòng IT</span>
                                            <span class="activity-tag">Backend Dev</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Activity 2 -->
                                <div class="activity-item">
                                    <div class="activity-icon-box bg-primary-subtle text-primary">
                                        <i class="bi bi-person-lines-fill"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title-row">
                                            <span class="activity-title">Trần Thị B</span>
                                            <span class="activity-time">10 phút trước</span>
                                        </div>
                                        <div class="activity-desc">Cập nhật thành công số CCCD và thông tin tài khoản ngân hàng VCB</div>
                                    </div>
                                </div>

                                <!-- Activity 3 -->
                                <div class="activity-item">
                                    <div class="activity-icon-box bg-info-subtle text-info">
                                        <i class="bi bi-cash-stack"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title-row">
                                            <span class="activity-title">Hệ thống Payroll</span>
                                            <span class="activity-time">30 phút trước</span>
                                        </div>
                                        <div class="activity-desc">Bảng lương T09/2026 đã được tạo và tự động tính bảo hiểm</div>
                                    </div>
                                </div>

                                <!-- Activity 4 -->
                                <div class="activity-item">
                                    <div class="activity-icon-box bg-success-subtle text-success">
                                        <i class="bi bi-check2-circle"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title-row">
                                            <span class="activity-title">Đơn nghỉ phép #NP-2041</span>
                                            <span class="activity-time">1 giờ trước</span>
                                        </div>
                                        <div class="activity-desc">Lê Hoàng Nam (Sales) được phê duyệt bởi HR Manager (2 ngày)</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- View all activity button -->
                        <a href="#" class="btn-action-light w-100 justify-content-center mt-3">
                            <span>Xem tất cả lịch sử hoạt động</span>
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- Specific Dashboard Charts Script -->
<script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>

</body>
</html>
