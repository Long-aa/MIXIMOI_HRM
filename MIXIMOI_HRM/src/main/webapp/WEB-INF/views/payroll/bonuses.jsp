<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
                    <button type="button" class="btn-action-light" onclick="window.print();">
                        <i class="bi bi-printer"></i>
                        <span>Xuất phiếu chi</span>
                    </button>

                    <button type="button" class="btn-action-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addBonusModal">
                        <i class="bi bi-plus-circle-fill"></i>
                        <span>Quyết định thưởng mới</span>
                    </button>
                </div>
            </div>

            <!-- Toast notification -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3 border-0 shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill text-success fs-5"></i>
                    <div>
                        <c:choose>
                            <c:when test="${param.success eq 'added'}">Đã thêm quyết định thưởng thành công!</c:when>
                            <c:when test="${param.success eq 'deleted'}">Đã xóa quyết định thưởng thành công!</c:when>
                            <c:otherwise>Thao tác thành công!</c:otherwise>
                        </c:choose>
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- 4 Stat KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- Card 1: Tổng quỹ thưởng năm -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng quỹ thưởng năm ${selectedYear}</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark"><fmt:formatNumber value="${totalBonusYear}" pattern="#,##0"/></span>
                                    <span class="kpi-unit fw-bold">đ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-wallet2"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size:0.76rem;">Lũy kế cả năm ${selectedYear}</span>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Thưởng kỳ tháng -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Thưởng kỳ tháng ${selectedMonth}/${selectedYear}</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark"><fmt:formatNumber value="${totalBonusMonth}" pattern="#,##0"/></span>
                                    <span class="kpi-unit fw-bold">đ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-cash-stack"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size:0.76rem;">Trong kỳ tháng ${selectedMonth}/${selectedYear}</span>
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
                                    <span class="kpi-value text-dark">${bonusEmpCount}</span>
                                    <span class="kpi-unit">nhân sự được thưởng</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-trophy-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-primary fw-semibold" style="font-size: 0.76rem;">
                                ● Kỳ tháng ${selectedMonth}/${selectedYear}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Số lượng quyết định thưởng -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Số quyết định thưởng</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">${bonusList.size()}</span>
                                    <span class="kpi-unit">quyết định trong kỳ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-award-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.76rem;">Tháng ${selectedMonth}/${selectedYear}</span>
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

            <!-- Filter Form -->
            <form method="get" action="" class="dashboard-filter-card mb-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex flex-wrap align-items-center gap-2">
                        <select class="filter-select" name="month">
                            <c:forEach var="m" begin="1" end="12">
                                <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>Tháng ${m}/${selectedYear}</option>
                            </c:forEach>
                        </select>
                        <input type="hidden" name="year" value="${selectedYear}"/>

                        <select class="filter-select" name="deptId">
                            <option value="">Tất cả phòng ban</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.id}" ${dept.id == selectedDeptId ? 'selected' : ''}>${dept.name}</option>
                            </c:forEach>
                        </select>

                        <input type="text" class="filter-select" name="keyword" placeholder="Tìm tên nhân viên, tên thưởng..." value="${keyword}"/>
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 px-3 py-2 fw-semibold" style="font-size: 0.82rem; border-radius: 10px;">
                            <i class="bi bi-search"></i> Tìm kiếm
                        </button>
                        <a href="bonuses" class="btn btn-light border py-2 px-3" title="Xóa bộ lọc"><i class="bi bi-x-circle"></i></a>
                    </div>
                </div>
            </form>

            <!-- Table Card: Danh sách Quyết định Khen thưởng -->
            <div class="table-custom-container mb-4">
                <!-- Header -->
                <div class="p-3 border-bottom d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fw-bold text-dark" style="font-size: 1rem;">Danh sách Quyết định Khen thưởng</span>
                        <span class="badge bg-primary-subtle text-primary border-0 fw-bold">${bonusList.size()} Quyết định</span>
                    </div>
                    <span class="text-muted" style="font-size: 0.8rem;">
                        Tổng giá trị hiển thị: <strong class="text-primary font-monospace fs-6"><fmt:formatNumber value="${totalBonusMonth}" pattern="#,##0"/> đ</strong>
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>MÃ QĐ</th>
                                <th>TÊN THƯỞNG</th>
                                <th>NHÂN VIÊN THỤ HƯỞNG</th>
                                <th>PHÒNG BAN</th>
                                <th>GHI CHÚ</th>
                                <th class="text-end">SỐ TIỀN THƯỞNG</th>
                                <th class="text-center">NGÀY THƯỞNG</th>
                                <th class="text-end pe-4">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty bonusList}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                            Chưa có quyết định khen thưởng nào trong tháng ${selectedMonth}/${selectedYear}
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="b" items="${bonusList}" varStatus="idx">
                                        <tr>
                                            <td>
                                                <span class="code-link">QĐ-TH${b.payYear}${String.format('%02d', b.payMonth)}/${String.format('%02d', idx.count)}</span>
                                            </td>
                                            <td>
                                                <div class="fw-bold text-dark" style="font-size: 0.86rem;">${b.name}</div>
                                                <div class="text-muted" style="font-size: 0.72rem;">Kỳ tháng ${b.payMonth}/${b.payYear}</div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-initials-avatar" style="background:#eff6ff; color:#2563eb;">
                                                        ${fn:substring(b.employeeName,0,1)}
                                                    </div>
                                                    <div>
                                                        <div class="fw-semibold text-dark" style="font-size: 0.84rem;">${b.employeeName}</div>
                                                        <div class="text-muted" style="font-size: 0.72rem;">${b.employeeCode}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-muted" style="font-size: 0.82rem;">${b.departmentName}</td>
                                            <td class="text-muted" style="font-size: 0.82rem;">${b.notes}</td>
                                            <td class="text-end font-monospace fw-bold text-dark">
                                                <fmt:formatNumber value="${b.amount}" pattern="#,##0"/> đ
                                            </td>
                                            <td class="text-center text-muted" style="font-size: 0.8rem;">
                                                <fmt:formatDate value="${b.bonusDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td class="text-end pe-4">
                                                <form method="post" action="bonuses" style="display:inline;" onsubmit="return confirm('Xác nhận xóa quyết định thưởng này?')">
                                                    <input type="hidden" name="action" value="delete"/>
                                                    <input type="hidden" name="id" value="${b.id}"/>
                                                    <input type="hidden" name="month" value="${selectedMonth}"/>
                                                    <input type="hidden" name="year" value="${selectedYear}"/>
                                                    <button type="submit" class="btn btn-sm btn-light border-0 text-danger" title="Xóa">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer bg-white d-flex justify-content-between align-items-center py-3 border-top">
                    <span class="text-muted" style="font-size: 0.8rem;">
                        Tổng số quyết định: <strong>${empty bonusList ? 0 : fn:length(bonusList)}</strong>
                    </span>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Modal Thêm Quyết Định Thưởng Mới -->
<div class="modal fade" id="addBonusModal" tabindex="-1" aria-labelledby="addBonusModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow-lg">
            <form method="post" action="bonuses">
                <input type="hidden" name="action" value="add"/>
                <input type="hidden" name="month" value="${selectedMonth}"/>
                <input type="hidden" name="year" value="${selectedYear}"/>
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="addBonusModalLabel">
                        <i class="bi bi-trophy text-warning me-2"></i>Tạo Quyết Định Khen Thưởng Mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-semibold">Nhân viên thụ hưởng <span class="text-danger">*</span></label>
                            <select class="form-select" name="employeeId" required>
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.id}">${emp.employeeCode} - ${emp.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Tên loại thưởng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" required placeholder="VD: Thưởng KPI Q3, Thưởng Dự án..." />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Ngày quyết định <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="bonusDate" required />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Số tiền thưởng (đ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="amount" required min="0" step="1000" placeholder="VD: 5000000" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Ghi chú / Lý do khen thưởng</label>
                            <input type="text" class="form-control" name="notes" placeholder="VD: Đạt 150% KPI doanh số..." />
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-semibold">
                        <i class="bi bi-check-circle me-1"></i>Xác nhận & Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- Chart.js initialization with real server data -->
<script>
document.addEventListener('DOMContentLoaded', () => {
    const ctx = document.getElementById('bonusDonutChart');
    if (!ctx) return;

    // Dữ liệu phân bổ thưởng theo phòng ban từ server
    const deptLabels = [<c:forEach var="entry" items="${deptDistribution}" varStatus="s">'${entry.key}'${!s.last ? ',' : ''}</c:forEach>];
    const deptData   = [<c:forEach var="entry" items="${deptDistribution}" varStatus="s">${entry.value}${!s.last ? ',' : ''}</c:forEach>];
    const colors = ['#2563eb','#0ea5e9','#f59e0b','#10b981','#f43f5e','#7c3aed','#64748b'];

    new Chart(ctx.getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: deptLabels.length > 0 ? deptLabels : ['Chưa có dữ liệu'],
            datasets: [{
                data: deptData.length > 0 ? deptData : [1],
                backgroundColor: colors,
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
                        label: (ctx) => ' ' + ctx.label + ': ' + new Intl.NumberFormat('vi-VN').format(ctx.parsed) + ' đ'
                    }
                }
            }
        }
    });
});
</script>

</body>
</html>
