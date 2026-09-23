<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="KPI & Đánh giá Hiệu suất Toàn diện - MIXIMOI HRM" />
    </jsp:include>
</head>
<body class="hrm-app-body">
<div class="app-layout">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <div class="app-main">
        <!-- Topbar -->
        <jsp:include page="/WEB-INF/views/common/topbar.jsp" />

        <!-- Main Content Area -->
        <main class="app-content p-3 p-lg-4">
            <!-- Toast notification if action done -->
            <c:if test="${param.success eq 'approved'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div>Đã phê duyệt đánh giá chỉ tiêu <strong>KPI-IT-042 (102% - Vượt mục tiêu)</strong> thành công!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <h1 class="h3 fw-bold text-dark mb-1">KPI & Đánh giá hiệu suất</h1>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Thiết lập, theo dõi và đánh giá chỉ tiêu hiệu suất của nhân viên và các phòng ban toàn công ty theo chu kỳ vận hành.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="window.print()">
                        <i class="bi bi-printer"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#cycleConfigModal">
                        <i class="bi bi-calendar3"></i>
                        <span>Cấu hình kỳ đánh giá</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createKpiModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>+ Tạo KPI mới</span>
                    </button>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <form method="get" action="${pageContext.request.contextPath}/performance" class="row g-2 align-items-center">
                        <div class="col-6 col-md-3">
                            <select name="quarter" class="form-select form-select-sm" onchange="this.form.submit()">
                                <optgroup label="Theo Quý (Quarterly)">
                                    <option value="Q3/2026" ${param.quarter eq 'Q3/2026' or empty param.quarter ? 'selected' : ''}>📅 Quý 3/2026 (01/07 - 30/09)</option>
                                    <option value="Q2/2026" ${param.quarter eq 'Q2/2026' ? 'selected' : ''}>📅 Quý 2/2026 (01/04 - 30/06)</option>
                                    <option value="Q1/2026" ${param.quarter eq 'Q1/2026' ? 'selected' : ''}>📅 Quý 1/2026 (01/01 - 31/03)</option>
                                </optgroup>
                                <optgroup label="Theo Tháng (Monthly)">
                                    <option value="T09/2026" ${param.quarter eq 'T09/2026' ? 'selected' : ''}>📅 Tháng 09/2026</option>
                                    <option value="T08/2026" ${param.quarter eq 'T08/2026' ? 'selected' : ''}>📅 Tháng 08/2026</option>
                                    <option value="T07/2026" ${param.quarter eq 'T07/2026' ? 'selected' : ''}>📅 Tháng 07/2026</option>
                                </optgroup>
                                <optgroup label="Theo Năm (Yearly)">
                                    <option value="Y2026" ${param.quarter eq 'Y2026' ? 'selected' : ''}>📅 Năm 2026</option>
                                    <option value="Y2025" ${param.quarter eq 'Y2025' ? 'selected' : ''}>📅 Năm 2025</option>
                                </optgroup>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select name="deptId" class="form-select form-select-sm" onchange="this.form.submit()">
                                <option value="">Tất cả phòng ban (${departments.size()})</option>
                                <c:forEach var="d" items="${departments}">
                                    <option value="${d.id}" ${param.deptId eq d.id ? 'selected' : ''}>${d.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                <option value="" ${empty param.status ? 'selected' : ''}>Tất cả trạng thái</option>
                                <option value="IN_PROGRESS" ${param.status eq 'IN_PROGRESS' ? 'selected' : ''}>Đang tiến hành</option>
                                <option value="APPROVED" ${param.status eq 'APPROVED' ? 'selected' : ''}>Đã phê duyệt</option>
                                <option value="OVERDUE" ${param.status eq 'OVERDUE' ? 'selected' : ''}>Cần can thiệp (Quá hạn)</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3 d-flex gap-2">
                            <select name="rating" class="form-select form-select-sm" onchange="this.form.submit()">
                                <option value="" ${empty param.rating ? 'selected' : ''}>Tất cả xếp loại</option>
                                <option value="EXCEED" ${param.rating eq 'EXCEED' ? 'selected' : ''}>Vượt mục tiêu (>100%)</option>
                                <option value="ACHIEVED" ${param.rating eq 'ACHIEVED' ? 'selected' : ''}>Đạt mục tiêu (90-100%)</option>
                                <option value="IMPROVE" ${param.rating eq 'IMPROVE' ? 'selected' : ''}>Cần cải thiện (70-89%)</option>
                                <option value="FAILED" ${param.rating eq 'FAILED' ? 'selected' : ''}>Không đạt (&lt;70%)</option>
                            </select>
                            <a href="${pageContext.request.contextPath}/performance" class="btn btn-sm btn-outline-secondary" title="Đặt lại"><i class="bi bi-arrow-repeat"></i></a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 5 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-2" style="flex: 1;">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Tổng KPI</span>
                            <div class="kpi-icon-box blue" style="width: 36px; height: 36px; font-size: 1.1rem;">
                                <i class="bi bi-sliders"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${totalKpi}</span>
                        </div>
                        <div class="text-muted small">Phân bổ trên ${departments.size()} phòng ban</div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-2" style="flex: 1;">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đạt KPI</span>
                            <div class="kpi-icon-box green" style="width: 36px; height: 36px; font-size: 1.1rem;">
                                <i class="bi bi-check2-circle"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">${achievedCount}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-success-subtle text-success fw-semibold">
                                <fmt:formatNumber value="${totalKpi > 0 ? (achievedCount * 100.0 / totalKpi) : 0}" maxFractionDigits="1"/>% tỷ lệ
                            </span>
                            <span class="text-muted small">hoàn thành</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-2" style="flex: 1;">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang theo dõi</span>
                            <div class="kpi-icon-box cyan" style="width: 36px; height: 36px; font-size: 1.1rem;">
                                <i class="bi bi-hourglass-split"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-primary fw-bold" style="font-size: 1.85rem;">${inProgressCount}</span>
                        </div>
                        <div class="text-muted small">
                            <span class="badge bg-info-subtle text-info fw-semibold">Đang tiến hành</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-2" style="flex: 1;">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Không đạt</span>
                            <div class="kpi-icon-box coral" style="width: 36px; height: 36px; font-size: 1.1rem;">
                                <i class="bi bi-exclamation-triangle"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-danger fw-bold" style="font-size: 1.85rem;">${failedCount}</span>
                        </div>
                        <div class="text-muted small">
                            <span class="badge bg-danger-subtle text-danger fw-semibold">Cần can thiệp</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 5 -->
                <div class="col-12 col-sm-6 col-xl-2" style="flex: 1.1;">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Hiệu suất trung bình</span>
                            <div class="kpi-icon-box purple" style="width: 36px; height: 36px; font-size: 1.1rem;">
                                <i class="bi bi-graph-up-arrow"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${avgPerformance}<span class="fs-5">%</span></span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="text-muted small">Vượt kỳ vọng chung</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold">+3.2%</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Middle Row: Department Performance Breakdown & Alerts -->
            <div class="row g-4 mb-4">
                <!-- Col-8: Department Performance -->
                <div class="col-12 col-lg-8">
                    <div class="card border-0 shadow-sm rounded-3 p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h3 class="h6 fw-bold text-dark mb-0">Hiệu suất theo phòng ban (Quý 3/2026)</h3>
                                <small class="text-muted">Tổng hợp dữ liệu tính điểm thực tế theo tỷ trọng</small>
                            </div>
                            <span class="badge bg-light text-dark border">5 Phòng Ban Hoạt Động</span>
                        </div>

                        <!-- Legend -->
                        <div class="d-flex flex-wrap gap-3 small text-muted mb-4 pb-2 border-bottom">
                            <span><span class="badge-dot-indicator" style="background: #1e3a8a;"></span>>100% Vượt chỉ tiêu</span>
                            <span><span class="badge-dot-indicator bg-primary"></span>90-100% Đạt</span>
                            <span><span class="badge-dot-indicator bg-secondary"></span>70-89% Cần cải thiện</span>
                            <span><span class="badge-dot-indicator bg-danger"></span><70% Không đạt</span>
                        </div>

                        <!-- Bar 1: CNTT & R&D -->
                        <div class="dept-kpi-row">
                            <div class="d-flex justify-content-between align-items-center small">
                                <div class="d-flex align-items-center gap-2">
                                    <strong class="text-dark">CNTT & R&D (Engineering)</strong>
                                    <span class="badge bg-primary-subtle text-primary py-0 px-2" style="font-size: 0.7rem;">Xuất sắc</span>
                                </div>
                                <div>
                                    <span class="text-muted me-2">72/75 KPI</span>
                                    <strong class="text-dark fs-6">96%</strong>
                                </div>
                            </div>
                            <div class="dept-kpi-bar">
                                <div style="width: 96%; background: #2563eb;"></div>
                            </div>
                        </div>

                        <!-- Bar 2: Finance -->
                        <div class="dept-kpi-row">
                            <div class="d-flex justify-content-between align-items-center small">
                                <div class="d-flex align-items-center gap-2">
                                    <strong class="text-dark">Tài chính - Kế toán</strong>
                                    <span class="badge bg-primary-subtle text-primary py-0 px-2" style="font-size: 0.7rem;">Đạt mục tiêu</span>
                                </div>
                                <div>
                                    <span class="text-muted me-2">32/34 KPI</span>
                                    <strong class="text-dark fs-6">94%</strong>
                                </div>
                            </div>
                            <div class="dept-kpi-bar">
                                <div style="width: 94%; background: #2563eb;"></div>
                            </div>
                        </div>

                        <!-- Bar 3: Sales -->
                        <div class="dept-kpi-row">
                            <div class="d-flex justify-content-between align-items-center small">
                                <div class="d-flex align-items-center gap-2">
                                    <strong class="text-dark">Kinh doanh & Phát triển</strong>
                                    <span class="badge bg-primary-subtle text-primary py-0 px-2" style="font-size: 0.7rem;">Đạt mục tiêu</span>
                                </div>
                                <div>
                                    <span class="text-muted me-2">58/63 KPI</span>
                                    <strong class="text-dark fs-6">92%</strong>
                                </div>
                            </div>
                            <div class="dept-kpi-bar">
                                <div style="width: 92%; background: #2563eb;"></div>
                            </div>
                        </div>

                        <!-- Bar 4: HR -->
                        <div class="dept-kpi-row">
                            <div class="d-flex justify-content-between align-items-center small">
                                <div class="d-flex align-items-center gap-2">
                                    <strong class="text-dark">Hành chính - Nhân sự</strong>
                                    <span class="badge bg-primary-subtle text-primary py-0 px-2" style="font-size: 0.7rem;">Đạt mục tiêu</span>
                                </div>
                                <div>
                                    <span class="text-muted me-2">27/30 KPI</span>
                                    <strong class="text-dark fs-6">90%</strong>
                                </div>
                            </div>
                            <div class="dept-kpi-bar">
                                <div style="width: 90%; background: #2563eb;"></div>
                            </div>
                        </div>

                        <!-- Bar 5: Marketing -->
                        <div class="dept-kpi-row mb-4">
                            <div class="d-flex justify-content-between align-items-center small">
                                <div class="d-flex align-items-center gap-2">
                                    <strong class="text-dark">Marketing & Truyền thông</strong>
                                    <span class="badge bg-secondary-subtle text-secondary py-0 px-2" style="font-size: 0.7rem;">Cần cải thiện</span>
                                </div>
                                <div>
                                    <span class="text-muted me-2">44/50 KPI</span>
                                    <strong class="text-dark fs-6">88%</strong>
                                </div>
                            </div>
                            <div class="dept-kpi-bar">
                                <div style="width: 88%; background: #64748b;"></div>
                            </div>
                        </div>

                        <!-- Bottom KPI Distribution -->
                        <div class="row g-2 pt-3 border-top text-center" style="font-size: 0.8rem;">
                            <div class="col-3">
                                <div class="text-muted small">Vượt chỉ tiêu</div>
                                <strong class="text-primary fs-6">12.2%</strong>
                            </div>
                            <div class="col-3">
                                <div class="text-muted small">Đạt mục tiêu</div>
                                <strong class="text-success fs-6">64.5%</strong>
                            </div>
                            <div class="col-3">
                                <div class="text-muted small">Cần cải thiện</div>
                                <strong class="text-warning-emphasis fs-6">17.1%</strong>
                            </div>
                            <div class="col-3">
                                <div class="text-muted small">Không đạt</div>
                                <strong class="text-danger fs-6">6.2%</strong>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Col-4: Urgent Actions & Rewards -->
                <div class="col-12 col-lg-4">
                    <!-- Card 1: Cần can thiệp gấp -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-exclamation-octagon-fill text-danger"></i>
                                <h4 class="h6 fw-bold text-dark mb-0">Cần can thiệp gấp</h4>
                            </div>
                            <span class="badge bg-danger-subtle text-danger">3 Nguy cơ</span>
                        </div>
                        <small class="text-muted mb-3 d-block" style="font-size: 0.73rem;">Các chỉ tiêu cốt lõi có hạn chót trong 7 ngày tới đang có tiến độ dưới 65%.</small>

                        <div class="d-flex flex-column gap-2">
                            <!-- Item 1 -->
                            <div class="p-2 border rounded-2 bg-light d-flex justify-content-between align-items-center" style="font-size: 0.78rem;">
                                <div>
                                    <div class="fw-bold text-dark">Tăng trưởng khách hàng Enterprise Q3</div>
                                    <small class="text-muted">Vũ Minh Tuấn • <span class="text-danger fw-bold">Hạn: Còn 3 ngày</span></small>
                                </div>
                                <span class="badge bg-danger-subtle text-danger fs-6">52%</span>
                            </div>

                            <!-- Item 2 -->
                            <div class="p-2 border rounded-2 bg-light d-flex justify-content-between align-items-center" style="font-size: 0.78rem;">
                                <div>
                                    <div class="fw-bold text-dark">Tối ưu hóa chi phí AWS Cloud</div>
                                    <small class="text-muted">Phạm Hoàng Đức • <span class="text-danger fw-bold">Hạn: Còn 5 ngày</span></small>
                                </div>
                                <span class="badge bg-danger-subtle text-danger fs-6">61%</span>
                            </div>

                            <!-- Item 3 -->
                            <div class="p-2 border rounded-2 bg-light d-flex justify-content-between align-items-center" style="font-size: 0.78rem;">
                                <div>
                                    <div class="fw-bold text-dark">Tuyển dụng 10 Senior Golang Dev</div>
                                    <small class="text-muted">Nguyễn Bảo Trang • <span class="text-danger fw-bold">Hạn: Còn 6 ngày</span></small>
                                </div>
                                <span class="badge bg-danger-subtle text-danger fs-6">50%</span>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2: Đề xuất khen thưởng -->
                    <div class="card border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-award-fill text-warning"></i>
                                <h4 class="h6 fw-bold text-dark mb-0">Đề xuất khen thưởng</h4>
                            </div>
                            <span class="badge bg-primary-subtle text-primary">>115% KPI</span>
                        </div>

                        <div class="p-2 px-3 border rounded-3 bg-light d-flex justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center gap-2">
                                <div class="avatar-circle bg-warning-subtle text-warning fw-bold" style="width: 34px; height: 34px; font-size: 0.8rem;">TV</div>
                                <div>
                                    <div class="fw-bold text-dark" style="font-size: 0.83rem;">Hoàng Thảo Vy</div>
                                    <small class="text-muted">Marketing Lead • Đạt 122% KPI</small>
                                </div>
                            </div>
                            <span class="badge bg-success-subtle text-success border border-success-subtle">Vinh danh</span>
                        </div>

                        <a href="#" class="text-primary small text-decoration-none fw-semibold d-flex align-items-center gap-1">
                            <span>Xem phân tích chi tiết BI & Báo cáo</span>
                            <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Bottom Row: KPI List Table + KPI Detail Inspector Drawer -->
            <div class="row g-4">
                <!-- Col-8: KPI List Table -->
                <div class="col-12 col-xl-8">
                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                        <div class="card-header bg-white border-bottom py-3 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                            <h2 class="h6 fw-bold mb-0 text-dark">Danh sách chỉ tiêu & Tiến độ chi tiết</h2>

                            <div class="d-flex flex-wrap align-items-center gap-2">
                                <div class="input-group input-group-sm" style="width: 220px;">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                    <input type="text" class="form-control border-start-0" placeholder="Tìm tên mục tiêu, mã KPI...">
                                </div>
                                <ul class="nav nav-pills payment-batch-tabs">
                                    <li class="nav-item"><a class="nav-link active py-1 px-2" href="#">Tất cả (245)</a></li>
                                    <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Vượt mục tiêu (30)</a></li>
                                    <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Đạt (158)</a></li>
                                    <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Cần cải thiện (42)</a></li>
                                    <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Không đạt (15)</a></li>
                                </ul>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3" style="width: 35px;"><input class="form-check-input" type="checkbox"></th>
                                        <th style="width: 110px;">Mã KPI</th>
                                        <th>Nhân sự thực hiện</th>
                                        <th>Phòng ban</th>
                                        <th class="pe-3">Mục tiêu cốt lõi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty kpis}">
                                            <c:forEach var="k" items="${kpis}" varStatus="status">
                                                <tr class="${status.first ? 'table-primary bg-opacity-25' : ''}" style="cursor: pointer;"
                                                    onclick="selectKpi('${k.kpiCode}', '${k.title}', '${k.employeeName}', '${k.positionName}', '${k.departmentName}', '${k.targetValue} ${k.unit}', '${k.currentValue} ${k.unit}', '${k.progressPct}', '${k.weightPct}', '${k.statusDisplayName}', '${k.statusBadgeClass}')">
                                                    <td class="ps-3"><input class="form-check-input" type="checkbox" ${status.first ? 'checked' : ''}></td>
                                                    <td class="fw-bold font-monospace text-primary">${k.kpiCode}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar-circle bg-primary text-white fw-bold" style="width: 30px; height: 30px; font-size: 0.75rem;">
                                                                ${k.employeeName != null && k.employeeName.length() > 0 ? k.employeeName.substring(0, 1).toUpperCase() : 'U'}
                                                            </div>
                                                            <div>
                                                                <div class="fw-bold text-dark">${k.employeeName}</div>
                                                                <small class="text-muted">${k.positionName}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge bg-light text-dark border">${k.departmentName}</span></td>
                                                    <td class="pe-3">
                                                        <div class="fw-bold text-dark">${k.title}</div>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <small class="text-muted">Trọng số: ${k.weightPct}%</small>
                                                            <span class="badge ${k.statusBadgeClass}" style="font-size: 0.7rem;">${k.statusDisplayName}</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">
                                                    <i class="bi bi-inbox fs-3 d-block mb-1"></i>
                                                    Không có chỉ tiêu KPI nào phù hợp với bộ lọc hiện tại.
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <div class="card-footer bg-white border-top py-3 d-flex justify-content-between align-items-center">
                            <span class="text-muted small">Hiển thị <strong>${kpis.size()}</strong> chỉ tiêu trong hệ thống</span>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Col-4: KPI Detail Inspector Drawer -->
                <div class="col-12 col-xl-4">
                    <div class="kpi-inspector-card">
                        <!-- Drawer Header -->
                        <div class="d-flex justify-content-between align-items-center pb-2 border-bottom mb-3">
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-primary-subtle text-primary font-monospace fw-bold">KPI-IT-042</span>
                                <span class="badge bg-success-subtle text-success">Vượt mục tiêu</span>
                            </div>
                            <button class="btn btn-sm btn-light border-0"><i class="bi bi-x-lg"></i></button>
                        </div>

                        <!-- KPI Title & Assignee -->
                        <h3 class="h6 fw-bold text-dark mb-3">Phát triển Microservices & Uptime hệ thống 99.9%</h3>
                        
                        <div class="d-flex align-items-center gap-2 mb-3">
                            <div class="avatar-circle bg-primary text-white fw-bold" style="width: 36px; height: 36px; font-size: 0.8rem;">LN</div>
                            <div>
                                <div class="fw-bold text-dark" style="font-size: 0.84rem;">Lê Hoàng Nam</div>
                                <small class="text-muted">Senior Tech Lead • CNTT & R&D</small>
                                <div class="text-primary small">Trọng số: <strong>35%</strong> bộ chỉ tiêu quý</div>
                            </div>
                        </div>

                        <!-- Metric Score Boxes -->
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light">
                                    <small class="text-muted d-block" style="font-size: 0.72rem;">Chỉ tiêu cam kết</small>
                                    <strong class="text-dark fs-5">99.90%</strong>
                                    <small class="text-muted d-block" style="font-size: 0.7rem;">Uptime tiêu chuẩn</small>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-success-subtle bg-opacity-25 border-success-subtle">
                                    <small class="text-muted d-block" style="font-size: 0.72rem;">Kết quả ghi nhận</small>
                                    <strong class="text-success fs-5">102%</strong>
                                    <small class="text-success d-block" style="font-size: 0.7rem;">Tương đương 99.96d</small>
                                </div>
                            </div>
                        </div>

                        <!-- Formula Box -->
                        <div class="mb-3">
                            <div class="fw-bold text-dark small text-uppercase mb-1" style="font-size: 0.73rem;">CÔNG THỨC ĐO LƯỜNG</div>
                            <div class="kpi-formula-box">
                                Điểm = (Thời gian Uptime thực tế / 2.160 giờ) * 100 + Điểm audit bảo mật SonarQube
                            </div>
                        </div>

                        <!-- Evaluation Timeline -->
                        <div class="mb-3">
                            <div class="fw-bold text-dark small text-uppercase mb-2" style="font-size: 0.73rem;">LỊCH SỬ ĐÁNH GIÁ</div>
                            
                            <div class="kpi-timeline-item">
                                <span class="kpi-timeline-dot completed"></span>
                                <div class="fw-bold text-dark" style="font-size: 0.78rem;">15/09/2026: Quản lý trực tiếp xác nhận</div>
                                <small class="text-muted">Trần Tuấn Hưng (CTO) duyệt mức điểm 102% sau Sprint 4.</small>
                            </div>

                            <div class="kpi-timeline-item">
                                <span class="kpi-timeline-dot completed"></span>
                                <div class="fw-bold text-dark" style="font-size: 0.78rem;">01/09/2026: Nhân sự tự đánh giá</div>
                                <small class="text-muted">Lê Hoàng Nam đề xuất mức hoàn thành 95%.</small>
                            </div>

                            <div class="kpi-timeline-item">
                                <span class="kpi-timeline-dot"></span>
                                <div class="fw-bold text-dark" style="font-size: 0.78rem;">01/07/2026: Thiết lập chỉ tiêu đầu kỳ</div>
                                <small class="text-muted">Phê duyệt chỉ tiêu đánh giá Quý 3.</small>
                            </div>
                        </div>

                        <!-- Reviewer Note -->
                        <div class="p-2 px-3 bg-light rounded-3 border mb-4" style="font-size: 0.76rem;">
                            <div class="text-primary fw-bold mb-1">
                                <i class="bi bi-chat-quote-fill me-1"></i>Nhận xét của Trưởng bộ phận:
                            </div>
                            <div class="text-muted fst-italic">
                                "Nam hoàn thành xuất sắc việc refactor kiến trúc API Gateway, không phát sinh downtime trong các kỳ trả lương cao điểm của hệ thống."
                            </div>
                        </div>

                        <!-- Drawer Footer Buttons -->
                        <div class="d-flex gap-2">
                            <form method="post" action="${pageContext.request.contextPath}/performance" class="flex-grow-1 m-0">
                                <input type="hidden" name="action" value="approve_kpi">
                                <input type="hidden" name="kpiCode" id="drawerInputKpiCode" value="KPI-IT-042">
                                <button type="submit" class="btn btn-primary btn-sm w-100 shadow-sm">
                                    <i class="bi bi-check-circle me-1"></i>Phê duyệt đánh giá
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<!-- Modal Tạo KPI Mới -->
<div class="modal fade" id="createKpiModal" tabindex="-1" aria-labelledby="createKpiModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="createKpiModalLabel">Thiết lập chỉ tiêu KPI mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/performance">
                <input type="hidden" name="action" value="create_kpi">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Mục tiêu cốt lõi / Tiêu đề KPI <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="title" placeholder="VD: Tối ưu hóa chi phí AWS Cloud tiết kiệm 15%" required>
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label small fw-semibold">Nhân sự thực hiện <span class="text-danger">*</span></label>
                            <select class="form-select" name="employeeId" required>
                                <option value="">-- Chọn nhân sự --</option>
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label small fw-semibold">Phòng ban phụ trách</label>
                            <select class="form-select" name="departmentId">
                                <option value="">-- Chọn phòng ban --</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}">${dept.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label small fw-semibold">Kỳ đánh giá</label>
                            <input type="text" class="form-control" name="quarter" value="Q3/2026" required>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label small fw-semibold">Chỉ tiêu cam kết</label>
                            <input type="number" step="0.1" class="form-control" name="targetValue" value="100.0" required>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label small fw-semibold">Đơn vị đo</label>
                            <input type="text" class="form-control" name="unit" value="%" required>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label small fw-semibold">Trọng số (%)</label>
                            <input type="number" step="1" class="form-control" name="weightPct" value="25" required>
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label small fw-semibold">Hạn chót hoàn thành (Deadline)</label>
                            <input type="date" class="form-control" name="deadline" value="2026-09-30">
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label small fw-semibold">Tiến độ hiện tại ban đầu</label>
                            <input type="number" step="0.1" class="form-control" name="currentValue" value="0.0">
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Ghi chú & Phương thức tính điểm</label>
                            <textarea class="form-control" name="notes" rows="2" placeholder="Ghi chú chi tiết cách thức nghiệm thu chỉ tiêu..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Xác nhận tạo KPI</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script>
function selectKpi(code, title, empName, posName, deptName, target, current, pct, weight, statusName, statusClass) {
    document.getElementById('drawerInputKpiCode').value = code;
    const badge = document.querySelector('.kpi-inspector-card .badge.bg-primary-subtle');
    if (badge) badge.textContent = code;
    const titleEl = document.querySelector('.kpi-inspector-card h3');
    if (titleEl) titleEl.textContent = title;
}
</script>
</body>
</html>
