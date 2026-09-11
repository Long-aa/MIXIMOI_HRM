<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Khen thưởng & Thưởng hiệu suất — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <!-- Chart.js for Bonus Distribution Donut -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="bonuses" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Bonuses Page Body -->
        <div class="app-content">
            
            <!-- Page Header Area -->
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                            HỆ THỐNG LƯƠNG & ĐÃI NGỘ
                        </span>
                        <span class="text-muted" style="font-size: 0.8rem;">•</span>
                        <span class="text-muted" style="font-size: 0.82rem;">Chu kỳ Q3/2026</span>
                    </div>
                    <h3 class="fw-extrabold text-dark mb-1" style="font-weight: 800; font-size: 1.65rem;">
                        Quản lý Khen thưởng & Thưởng hiệu suất
                    </h3>
                    <p class="text-muted mb-0" style="font-size: 0.84rem;">
                        Xét duyệt, phân bổ tiền thưởng hiệu quả KPI, thưởng dự án, thưởng sáng kiến kỹ thuật và ghi nhận thành tích xuất sắc toàn doanh nghiệp.
                    </p>
                </div>

                <!-- Action Toolbar -->
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <button type="button" class="btn-action-light" onclick="alert('Đang mở lịch sử quyết định khen thưởng...');">
                        <i class="bi bi-clock-history"></i>
                        <span>Lịch sử khen thưởng</span>
                    </button>

                    <button type="button" class="btn-action-light" onclick="alert('Đang xuất phiếu chi tiền thưởng...');">
                        <i class="bi bi-printer"></i>
                        <span>Xuất phiếu chi</span>
                    </button>

                    <button type="button" class="btn-action-primary" onclick="alert('Mở form tạo quyết định khen thưởng mới...');">
                        <i class="bi bi-plus-circle"></i>
                        <span>+ Quyết định thưởng mới</span>
                    </button>
                </div>
            </div>

            <!-- 4 Stat KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- Card 1: Tổng quỹ thưởng năm 2026 -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng quỹ thưởng năm 2026</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">1.250.000.000</span>
                                    <span class="kpi-unit fw-bold">đ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-wallet2"></i>
                            </div>
                        </div>
                        <div class="kpi-footer flex-column align-items-stretch gap-1 pt-2">
                            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                <span class="text-muted">Đã giải ngân: 850.000.000 đ</span>
                                <span class="fw-bold text-primary">68%</span>
                            </div>
                            <div class="progress" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 68%;"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Thưởng kỳ tháng 09/2026 -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Thưởng kỳ tháng 09/2026</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">62.000.000</span>
                                    <span class="kpi-unit fw-bold">đ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-cash-stack"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-graph-up-arrow"></i> +8.4%
                            </span>
                            <span class="text-muted">so với Tháng 08/2026</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Đối tượng thụ hưởng -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Đối tượng thụ hưởng</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">42</span>
                                    <span class="kpi-unit">nhân sự • <strong>3</strong> phòng ban</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-trophy-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-primary fw-semibold" style="font-size: 0.76rem;">
                                ● Phủ 18.6% tổng nhân lực công ty
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: KPI trung bình loại A -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">KPI trung bình loại A</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">3.500.000</span>
                                    <span class="kpi-unit fw-bold">đ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-award-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.76rem;">Hệ số quy đổi: <strong>1.25x</strong></span>
                            <span class="badge bg-primary-subtle text-primary">Top 25%</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Middle Row: Donut Distribution Chart (7 cols) & Disbursement Stepper (5 cols) -->
            <div class="row g-3 mb-4">
                <!-- Left: Donut Chart & Breakdown (7 cols) -->
                <div class="col-lg-7">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">Cơ cấu & Tỷ lệ Phân bổ Tiền thưởng</div>
                                    <p class="app-card-subtitle">Tỷ lệ ngân sách phân rã theo 4 nhóm chương trình khen thưởng quỹ hiện hành</p>
                                </div>
                                <div class="card-filter-pills">
                                    <button type="button" class="filter-pill active">Quý 3/2026</button>
                                    <button type="button" class="filter-pill">Năm 2026</button>
                                </div>
                            </div>

                            <div class="row align-items-center my-3">
                                <!-- Donut Canvas with Center Info -->
                                <div class="col-md-5 text-center">
                                    <div class="donut-chart-wrapper position-relative" style="max-width: 190px; margin: 0 auto;">
                                        <canvas id="bonusDonutChart" width="180" height="180"></canvas>
                                        <div class="donut-center-info">
                                            <div style="font-size: 0.65rem; color:#64748b; font-weight: 700; text-transform: uppercase;">Tổng chi đợt này</div>
                                            <div style="font-size: 1.45rem; font-weight: 800; color: #0f172a; line-height: 1.1;">185M</div>
                                            <div style="font-size: 0.65rem; color:#2563eb; font-weight: 600;">100% Phân bổ</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Breakdown items -->
                                <div class="col-md-7">
                                    <div class="d-flex flex-column gap-2" style="font-size: 0.82rem;">
                                        <!-- Item 1 -->
                                        <div class="p-2 rounded bg-light border">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="fw-semibold text-dark">
                                                    <span class="badge-dot-indicator" style="background-color: #2563eb;"></span>
                                                    Thưởng KPI & Doanh số
                                                </span>
                                                <span class="fw-bold text-dark">83.250.000 đ <span class="text-muted fw-normal" style="font-size: 0.74rem;">(45.0%)</span></span>
                                            </div>
                                            <div class="text-muted" style="font-size: 0.72rem; padding-left: 1rem;">28 nhân viên xuất sắc</div>
                                        </div>

                                        <!-- Item 2 -->
                                        <div class="p-2 rounded bg-light border">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="fw-semibold text-dark">
                                                    <span class="badge-dot-indicator" style="background-color: #0ea5e9;"></span>
                                                    Thưởng Dự án Hot & ERP Go-live
                                                </span>
                                                <span class="fw-bold text-dark">55.500.000 đ <span class="text-muted fw-normal" style="font-size: 0.74rem;">(30.0%)</span></span>
                                            </div>
                                            <div class="text-muted" style="font-size: 0.72rem; padding-left: 1rem;">Phòng Tech & Vận hành</div>
                                        </div>

                                        <!-- Item 3 -->
                                        <div class="p-2 rounded bg-light border">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="fw-semibold text-dark">
                                                    <span class="badge-dot-indicator" style="background-color: #f59e0b;"></span>
                                                    Thưởng Đột xuất & Sáng kiến
                                                </span>
                                                <span class="fw-bold text-dark">27.750.000 đ <span class="text-muted fw-normal" style="font-size: 0.74rem;">(15.0%)</span></span>
                                            </div>
                                            <div class="text-muted" style="font-size: 0.72rem; padding-left: 1rem;">8 sáng kiến cải tiến</div>
                                        </div>

                                        <!-- Item 4 -->
                                        <div class="p-2 rounded bg-light border">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="fw-semibold text-dark">
                                                    <span class="badge-dot-indicator" style="background-color: #94a3b8;"></span>
                                                    Thưởng Thâm niên & Gắn kết
                                                </span>
                                                <span class="fw-bold text-dark">18.500.000 đ <span class="text-muted fw-normal" style="font-size: 0.74rem;">(10.0%)</span></span>
                                            </div>
                                            <div class="text-muted" style="font-size: 0.72rem; padding-left: 1rem;">Mốc 3 năm & 5 năm</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Disbursement Stepper (5 cols) -->
                <div class="col-lg-5">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">Tiến độ Giải ngân</div>
                                    <p class="app-card-subtitle">Đồng bộ tự động cùng bảng lương chốt ngày 28 hàng tháng</p>
                                </div>
                                <span class="badge bg-primary-subtle text-primary px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    Kỳ 09/2026
                                </span>
                            </div>

                            <!-- Stepper -->
                            <div class="stepper-timeline my-2">
                                <!-- Step 1 -->
                                <div class="stepper-step completed">
                                    <div class="step-circle"><i class="bi bi-check-lg"></i></div>
                                    <div class="step-info">
                                        <div class="step-header-line">
                                            <span class="step-title">Tổng hợp đề xuất</span>
                                            <span class="step-meta">12/09/2026</span>
                                        </div>
                                        <div class="step-sub">Phòng Nhân sự đã hoàn tất tổng hợp danh sách</div>
                                    </div>
                                </div>

                                <!-- Step 2 -->
                                <div class="stepper-step completed">
                                    <div class="step-circle"><i class="bi bi-check-lg"></i></div>
                                    <div class="step-info">
                                        <div class="step-header-line">
                                            <span class="step-title">Phê duyệt cấp Khối / Giám đốc</span>
                                            <span class="step-meta">18/09/2026</span>
                                        </div>
                                        <div class="step-sub">Đã ký số duyệt quyết định</div>
                                    </div>
                                </div>

                                <!-- Step 3 -->
                                <div class="stepper-step active">
                                    <div class="step-circle"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="step-info">
                                        <div class="step-header-line">
                                            <span class="step-title text-primary">Chờ CEO phê duyệt cuối</span>
                                            <span class="badge bg-primary-subtle text-primary border-0" style="font-size: 0.7rem;">Đang xử lý</span>
                                        </div>
                                        <div class="step-sub">3 quyết định giá trị &gt; 20.000.000 đ</div>
                                    </div>
                                </div>

                                <!-- Step 4 -->
                                <div class="stepper-step">
                                    <div class="step-circle"><i class="bi bi-arrow-right"></i></div>
                                    <div class="step-info">
                                        <div class="step-header-line">
                                            <span class="step-title text-muted">Giải ngân tài khoản ngân hàng</span>
                                            <span class="step-meta">Dự kiến 25/09</span>
                                        </div>
                                        <div class="step-sub">Liên kết cổng chi lương tự động</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Certificate Badge -->
                        <div class="cert-seal-badge mt-3">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-shield-fill-check fs-5"></i>
                                <span class="fw-bold">Chữ ký số hợp lệ VNPT-CA</span>
                            </div>
                            <span class="font-monospace text-muted" style="font-size: 0.72rem;">ID: 884-29-MIX</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Toolbar with Selected Tags -->
            <div class="dashboard-filter-card mb-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex flex-wrap align-items-center gap-2">
                        <select class="filter-select">
                            <option selected>Tháng 09/2026</option>
                            <option>Tháng 08/2026</option>
                            <option>Tháng 07/2026</option>
                        </select>

                        <select class="filter-select">
                            <option selected>Thưởng KPI & Hiệu suất</option>
                            <option>Thưởng Dự án</option>
                            <option>Thưởng Sáng kiến</option>
                            <option>Thưởng Thâm niên</option>
                        </select>

                        <select class="filter-select">
                            <option selected>Tất cả trạng thái</option>
                            <option>Đã duyệt</option>
                            <option>Chờ duyệt</option>
                        </select>
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <button type="button" class="btn btn-primary d-flex align-items-center gap-2 px-3 py-2 fw-semibold" style="font-size: 0.82rem; border-radius: 10px;">
                            <i class="bi bi-check2-all"></i> Phê duyệt hàng loạt
                        </button>
                        <button type="button" class="btn btn-light border py-2 px-3" title="Tùy chỉnh cột"><i class="bi bi-sliders"></i></button>
                    </div>
                </div>

                <!-- Active Filter Tags -->
                <div class="filter-chips-bar">
                    <span class="text-muted" style="font-size: 0.78rem;">Đang lọc:</span>
                    <span class="filter-chip-tag">
                        Tháng 09/2026 <i class="bi bi-x"></i>
                    </span>
                    <span class="filter-chip-tag">
                        Thưởng KPI & Hiệu suất <i class="bi bi-x"></i>
                    </span>
                    <a href="#" class="text-muted text-decoration-none fw-semibold" style="font-size: 0.75rem;">Xóa tất cả</a>
                </div>
            </div>

            <!-- Table Card: Danh sách Quyết định Khen thưởng -->
            <div class="table-custom-container mb-4">
                <!-- Header -->
                <div class="p-3 border-bottom d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fw-bold text-dark" style="font-size: 1rem;">Danh sách Quyết định Khen thưởng</span>
                        <span class="badge bg-primary-subtle text-primary border-0 fw-bold">5 Quyết định</span>
                    </div>
                    <span class="text-muted" style="font-size: 0.8rem;">
                        Tổng giá trị hiển thị: <strong class="text-primary font-monospace fs-6">62.000.000 đ</strong>
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width: 40px;" class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </th>
                                <th>MÃ QĐ</th>
                                <th>TÊN CHƯƠNG TRÌNH / ĐỢT THƯỞNG</th>
                                <th>ĐỐI TƯỢNG THỤ HƯỞNG</th>
                                <th>LÝ DO KHEN THƯỞNG</th>
                                <th class="text-end">SỐ TIỀN THƯỞNG</th>
                                <th class="text-center">NGÀY QUYẾT ĐỊNH</th>
                                <th class="text-center">TRẠNG THÁI</th>
                                <th class="text-end pe-4">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Row 1 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="#" class="code-link">QĐ-TH2026-09/01</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Thưởng Dự án ERP Phân hệ Lương</div>
                                    <div class="text-muted" style="font-size: 0.72rem;">Dự án chuyển đổi số 2026</div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#eff6ff; color:#2563eb;">P</div>
                                        <div>
                                            <div class="fw-semibold text-dark" style="font-size: 0.84rem;">Phòng Công nghệ & IT</div>
                                            <div class="text-muted" style="font-size: 0.72rem;">Tập thể (12 thành viên)</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-muted" style="font-size: 0.82rem;">Hoàn thành ERP đúng tiến độ vượt cam kết</td>
                                <td class="text-end font-monospace fw-bold text-dark">25.000.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">15/09/2026</td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border-0 fw-bold">Đã duyệt</span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="In quyết định"><i class="bi bi-printer"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 2 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="#" class="code-link">QĐ-TH2026-09/02</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Vượt chỉ tiêu Doanh thu Q3</div>
                                    <div class="text-muted" style="font-size: 0.72rem;">Khen thưởng chiến dịch Bán lẻ</div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#fdf2f8; color:#db2777;">MA</div>
                                        <div>
                                            <div class="fw-semibold text-dark" style="font-size: 0.84rem;">Lê Thị Mai Anh</div>
                                            <div class="text-muted" style="font-size: 0.72rem;">Trưởng nhóm Bán hàng KV1</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-muted" style="font-size: 0.82rem;">Đạt 150% KPI doanh số tháng 08 & 09</td>
                                <td class="text-end font-monospace fw-bold text-dark">15.000.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">16/09/2026</td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border-0 fw-bold">Đã duyệt</span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="In quyết định"><i class="bi bi-printer"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 3 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="#" class="code-link">QĐ-TH2026-09/03</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Sáng kiến Tối ưu Hóa Đơn Lương</div>
                                    <div class="text-muted" style="font-size: 0.72rem;">Khen thưởng Đột xuất</div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#ecfdf5; color:#059669;">HN</div>
                                        <div>
                                            <div class="fw-semibold text-dark" style="font-size: 0.84rem;">Đặng Hoàng Nam</div>
                                            <div class="text-muted" style="font-size: 0.72rem;">Chuyên viên Nhân sự C&B</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-muted" style="font-size: 0.82rem;">Rút ngắn 40% thời gian xử lý phiếu lương</td>
                                <td class="text-end font-monospace fw-bold text-dark">8.000.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">18/09/2026</td>
                                <td class="text-center">
                                    <span class="badge bg-warning-subtle text-warning border-0 fw-bold">Chờ duyệt</span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="In quyết định"><i class="bi bi-printer"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 4 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="#" class="code-link">QĐ-TH2026-09/04</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Thưởng Thâm Niên Cống Hiến 5 Năm</div>
                                    <div class="text-muted" style="font-size: 0.72rem;">Chương trình Gắn kết Đồng hành</div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#f5f3ff; color:#7c3aed;">KT</div>
                                        <div>
                                            <div class="fw-semibold text-dark" style="font-size: 0.84rem;">Phòng Tài Chính - Kế Toán</div>
                                            <div class="text-muted" style="font-size: 0.72rem;">2 Nhân sự đạt mốc</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-muted" style="font-size: 0.82rem;">Mốc kỷ niệm ngày gia nhập tổ chức</td>
                                <td class="text-end font-monospace fw-bold text-dark">10.000.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">20/09/2026</td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border-0 fw-bold">Đã duyệt</span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="In quyết định"><i class="bi bi-printer"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 5 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="#" class="code-link">QĐ-TH2026-09/05</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Khen thưởng Nhân viên Xuất sắc Tháng</div>
                                    <div class="text-muted" style="font-size: 0.72rem;">Chương trình Star of the Month</div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#fffbeb; color:#d97706;">ĐT</div>
                                        <div>
                                            <div class="fw-semibold text-dark" style="font-size: 0.84rem;">Ngô Đức Trọng</div>
                                            <div class="text-muted" style="font-size: 0.72rem;">DevOps Engineer</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-muted" style="font-size: 0.82rem;">Xử lý sự cố hạ tầng máy chủ không gián đoạn</td>
                                <td class="text-end font-monospace fw-bold text-dark">4.000.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">21/09/2026</td>
                                <td class="text-center">
                                    <span class="badge bg-warning-subtle text-warning border-0 fw-bold">Chờ duyệt</span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="In quyết định"><i class="bi bi-printer"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Footer -->
                <div class="p-3 border-top d-flex justify-content-between align-items-center" style="font-size:0.82rem;">
                    <div class="d-flex align-items-center gap-2">
                        <span class="text-muted">Hiển thị</span>
                        <select class="form-select form-select-sm d-inline-block w-auto">
                            <option selected>10</option>
                            <option>25</option>
                            <option>50</option>
                        </select>
                        <span class="text-muted">trên tổng số 45 quyết định khen thưởng</span>
                    </div>

                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled"><a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item disabled"><a class="page-link" href="#">...</a></li>
                            <li class="page-item"><a class="page-link" href="#">5</a></li>
                            <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a></li>
                        </ul>
                    </nav>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- Chart.js initialization for Bonus Donut -->
<script>
document.addEventListener('DOMContentLoaded', () => {
    const ctx = document.getElementById('bonusDonutChart');
    if (!ctx) return;

    new Chart(ctx.getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: ['KPI & Doanh số', 'Dự án Hot & ERP', 'Đột xuất & Sáng kiến', 'Thâm niên & Gắn kết'],
            datasets: [{
                data: [45, 30, 15, 10],
                backgroundColor: ['#2563eb', '#0ea5e9', '#f59e0b', '#94a3b8'],
                borderWidth: 3,
                borderColor: '#ffffff',
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            cutout: '74%',
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#0f172a',
                    titleFont: { family: 'Plus Jakarta Sans', size: 12 },
                    bodyFont: { family: 'Plus Jakarta Sans', size: 12, weight: 'bold' },
                    padding: 10,
                    cornerRadius: 8,
                    callbacks: {
                        label: (context) => ' ' + context.label + ': ' + context.parsed + '%'
                    }
                }
            }
        }
    });
});
</script>

</body>
</html>
