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
                    <div class="row g-2 align-items-center">
                        <div class="col-6 col-md-3">
                            <select class="form-select form-select-sm">
                                <option selected>📅 Quý 3/2026 (01/07 - 30/09)</option>
                                <option>📅 Quý 2/2026 (01/04 - 30/06)</option>
                                <option>📅 Quý 1/2026 (01/01 - 31/03)</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả phòng ban (5)</option>
                                <option>CNTT & R&D (Engineering)</option>
                                <option>Tài chính - Kế toán</option>
                                <option>Kinh doanh & Phát triển</option>
                                <option>Hành chính - Nhân sự</option>
                                <option>Marketing & Truyền thông</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả trạng thái</option>
                                <option>Đang tiến hành</option>
                                <option>Đã phê duyệt</option>
                                <option>Cần can thiệp</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3 d-flex gap-2">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả xếp loại</option>
                                <option>Vượt mục tiêu (>100%)</option>
                                <option>Đạt mục tiêu (90-100%)</option>
                                <option>Cần cải thiện (70-89%)</option>
                                <option>Không đạt (<70%)</option>
                            </select>
                            <button class="btn btn-sm btn-outline-secondary" title="Tải lại"><i class="bi bi-arrow-repeat"></i></button>
                        </div>
                    </div>
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
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">245</span>
                        </div>
                        <div class="text-muted small">Phân bổ trên 5 phòng ban</div>
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
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">188</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-success-subtle text-success fw-semibold">+76.7% tỷ lệ</span>
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
                            <span class="kpi-value text-primary fw-bold" style="font-size: 1.85rem;">42</span>
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
                            <span class="kpi-value text-danger fw-bold" style="font-size: 1.85rem;">15</span>
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
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">91.4<span class="fs-5">%</span></span>
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
                                    <!-- Row 1: Selected / Active -->
                                    <tr class="table-primary bg-opacity-25" style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox" checked></td>
                                        <td class="fw-bold font-monospace text-primary">KPI-IT-042</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-primary text-white fw-bold" style="width: 30px; height: 30px; font-size: 0.75rem;">LN</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Lê Hoàng Nam</div>
                                                    <small class="text-muted">Senior Tech Lead</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                        <td class="pe-3">
                                            <div class="fw-bold text-dark">Microservices & Uptime 99.9%</div>
                                            <small class="text-muted">Trọng số: 35%</small>
                                        </td>
                                    </tr>

                                    <!-- Row 2 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">KPI-KD-081</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-info-subtle text-info fw-bold" style="width: 30px; height: 30px; font-size: 0.75rem;">TM</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Trần Thị Mai</div>
                                                    <small class="text-muted">Enterprise Sales Mgr</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Kinh doanh</span></td>
                                        <td class="pe-3">
                                            <div class="fw-bold text-dark">Doanh số ký mới 3.5 Tỷ VNĐ</div>
                                            <small class="text-muted">Trọng số: 40%</small>
                                        </td>
                                    </tr>

                                    <!-- Row 3 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">KPI-MKT-019</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-warning-subtle text-warning fw-bold" style="width: 30px; height: 30px; font-size: 0.75rem;">VB</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Vũ Quốc Bình</div>
                                                    <small class="text-muted">Performance Specialist</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Marketing</span></td>
                                        <td class="pe-3">
                                            <div class="fw-bold text-dark">Chi phí CPL < 120.000 VNĐ</div>
                                            <small class="text-muted">Trọng số: 25%</small>
                                        </td>
                                    </tr>

                                    <!-- Row 4 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">KPI-TC-023</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 30px; height: 30px; font-size: 0.75rem;">NV</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Nguyễn Thị Cẩm Vân</div>
                                                    <small class="text-muted">Trưởng phòng Kế toán</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Tài chính</span></td>
                                        <td class="pe-3">
                                            <div class="fw-bold text-dark">Quyết toán thuế & BCTC kiểm toán</div>
                                            <small class="text-muted">Trọng số: 30%</small>
                                        </td>
                                    </tr>

                                    <!-- Row 5 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">KPI-HR-012</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 30px; height: 30px; font-size: 0.75rem;">PT</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Phan Thanh Tùng</div>
                                                    <small class="text-muted">HR Generalist Lead</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Hành chính NS</span></td>
                                        <td class="pe-3">
                                            <div class="fw-bold text-dark">Tỷ lệ Onboarding thành công 95%</div>
                                            <small class="text-muted">Trọng số: 30%</small>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="card-footer bg-white border-top py-3 d-flex justify-content-between align-items-center">
                            <span class="text-muted small">Hiển thị 1 - 5 trong 245 KPI</span>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item"><a class="page-link" href="#">...</a></li>
                                <li class="page-item"><a class="page-link" href="#">25</a></li>
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
                            <button type="button" class="btn btn-outline-secondary btn-sm flex-grow-1">Cập nhật điểm</button>
                            <form method="post" action="${pageContext.request.contextPath}/performance" class="flex-grow-1 m-0">
                                <input type="hidden" name="action" value="approve_kpi">
                                <button type="submit" class="btn btn-primary btn-sm w-100 shadow-sm">Phê duyệt đánh giá</button>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
