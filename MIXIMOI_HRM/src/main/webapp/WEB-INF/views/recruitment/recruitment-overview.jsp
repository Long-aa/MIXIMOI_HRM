<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Tổng quan Tuyển dụng & Phễu nhân tài - MIXIMOI HRM" />
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
            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Tuyển dụng</h1>
                        <span class="badge bg-primary-subtle text-primary fw-bold">Q3/2026</span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý toàn bộ quy trình tuyển dụng và tiến độ tuyển nhân sự toàn công ty.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="window.print()">
                        <i class="bi bi-printer"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#interviewWeekModal">
                        <i class="bi bi-calendar-week"></i>
                        <span>Lịch phỏng vấn tuần này</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createJobReqModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>+ Tạo yêu cầu tuyển dụng</span>
                    </button>
                </div>
            </div>

            <!-- Top Filter & Segments -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <div class="row g-2 align-items-center mb-3">
                        <div class="col-6 col-md-3">
                            <select class="form-select form-select-sm">
                                <option selected>Kỳ: Quý 3/2026</option>
                                <option>Kỳ: Quý 4/2026 (Kế hoạch)</option>
                                <option>Toàn năm 2026</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả phòng ban</option>
                                <option>CNTT & R&D</option>
                                <option>Kinh doanh</option>
                                <option>Marketing</option>
                                <option>Tài chính - KT</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả trạng thái</option>
                                <option>Đang tuyển</option>
                                <option>Ưu tiên gấp</option>
                                <option>Sắp hết hạn</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3 d-flex gap-2">
                            <select class="form-select form-select-sm">
                                <option selected>Người phụ trách: Tất cả</option>
                                <option>Phạm Phương Thảo</option>
                                <option>Nguyễn Minh Tuấn</option>
                            </select>
                            <button class="btn btn-sm btn-outline-secondary" title="Tải lại"><i class="bi bi-arrow-repeat"></i></button>
                        </div>
                    </div>

                    <!-- Filter Pill Chips -->
                    <div class="d-flex flex-wrap gap-2 pt-2 border-top">
                        <button class="btn btn-sm btn-primary py-1 px-3 fw-semibold">Tất cả vị trí (12)</button>
                        <button class="btn btn-sm btn-light border py-1 px-3 text-dark fw-semibold">Đang tuyển (8)</button>
                        <button class="btn btn-sm btn-light border py-1 px-3 text-danger fw-semibold">🔥 Ưu tiên gấp (3)</button>
                        <button class="btn btn-sm btn-light border py-1 px-3 text-warning-emphasis fw-semibold">⏳ Sắp hết hạn (2)</button>
                    </div>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Vị trí đang tuyển</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-briefcase"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">12</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Trên 8 phòng ban chức năng</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold">+3 so với tháng trước</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Ứng viên tiếp nhận</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-person-lines-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">86</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Hồ sơ ứng tuyển mới</span>
                            <span class="badge bg-purple-subtle text-purple fw-semibold" style="background: #f3e8ff; color: #7e22ce;">↗ +28% tỷ lệ ứng tuyển</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang phỏng vấn</span>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-calendar2-check"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">24</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Vòng 1 & Vòng Chuyên môn</span>
                            <span class="badge bg-info-subtle text-info fw-semibold">⏱ 8 lịch hôm nay</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã tuyển dụng</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-patch-check-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">5</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Tỷ lệ lấp đầy: <strong>41.7%</strong></span>
                            <span class="badge bg-success-subtle text-success fw-semibold">+2 ứng viên tuần này</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Middle Row: Funnel Pipeline & Sourcing + Schedule -->
            <div class="row g-4 mb-4">
                <!-- Col-8: Funnel Pipeline -->
                <div class="col-12 col-lg-8">
                    <div class="card border-0 shadow-sm rounded-3 p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h3 class="h6 fw-bold text-dark mb-0">Phễu tuyển dụng tổng thể</h3>
                                <small class="text-muted">Recruitment Pipeline Funnel & Tỷ lệ chuyển đổi qua các vòng</small>
                            </div>
                            <span class="badge bg-light text-dark border font-monospace">Time-to-hire TB: <strong>18.5 ngày</strong></span>
                        </div>

                        <div class="funnel-pipeline-list">
                            <!-- Stage 1 -->
                            <div class="funnel-step-item">
                                <div class="funnel-step-progress" style="width: 100%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">1</span>
                                        <div>
                                            <span class="fw-bold text-dark">Ứng viên mới</span>
                                            <span class="text-muted small ms-1">(Tiếp nhận qua các kênh)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-dark fs-6">86 hồ sơ</span>
                                        <span class="badge bg-primary-subtle text-primary">100%</span>
                                        <span class="badge bg-light text-muted border">Drop: 0%</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Stage 2 -->
                            <div class="funnel-step-item">
                                <div class="funnel-step-progress" style="width: 62.8%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">2</span>
                                        <div>
                                            <span class="fw-bold text-dark">Sàng lọc CV</span>
                                            <span class="text-muted small ms-1">(HR Pre-screening)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-dark fs-6">54 hồ sơ</span>
                                        <span class="badge bg-primary-subtle text-primary">62.8%</span>
                                        <span class="badge bg-danger-subtle text-danger">Drop: -37.2%</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Stage 3 -->
                            <div class="funnel-step-item">
                                <div class="funnel-step-progress" style="width: 27.9%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">3</span>
                                        <div>
                                            <span class="fw-bold text-dark">Phỏng vấn & Test</span>
                                            <span class="text-muted small ms-1">(Kỹ thuật & Văn hóa)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-dark fs-6">24 ứng viên</span>
                                        <span class="badge bg-primary-subtle text-primary">27.9%</span>
                                        <span class="badge bg-danger-subtle text-danger">Drop: -34.9%</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Stage 4 -->
                            <div class="funnel-step-item">
                                <div class="funnel-step-progress" style="width: 9.3%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">4</span>
                                        <div>
                                            <span class="fw-bold text-dark">Gửi Offer lương</span>
                                            <span class="text-muted small ms-1">(Thương lượng chế độ)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-dark fs-6">8 ứng viên</span>
                                        <span class="badge bg-warning-subtle text-warning-emphasis">9.3%</span>
                                        <span class="badge bg-danger-subtle text-danger">Drop: -18.6%</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Stage 5 -->
                            <div class="funnel-step-item bg-success-subtle bg-opacity-25 border-success-subtle">
                                <div class="funnel-step-progress bg-success bg-opacity-10" style="width: 5.8%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-success rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">5</span>
                                        <div>
                                            <span class="fw-bold text-success">Đã nhận việc (Onboarding)</span>
                                            <span class="text-muted small ms-1">(Thành công)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-success fs-6">5 nhân sự</span>
                                        <span class="badge bg-success text-white">5.8%</span>
                                        <span class="badge bg-success-subtle text-success border border-success-subtle">Hoàn tất quy trình</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Col-4: Sourcing Channels & Today's Schedule -->
                <div class="col-12 col-lg-4">
                    <!-- Widget 1: Sourcing Channels -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h4 class="h6 fw-bold text-dark mb-0">Nguồn tuyển dụng</h4>
                            <span class="badge bg-light text-muted border">86 ứng viên</span>
                        </div>
                        <div class="progress mb-3" style="height: 10px;">
                            <div class="progress-bar bg-primary" style="width: 42%" title="LinkedIn 42%"></div>
                            <div class="progress-bar bg-info" style="width: 35%" title="TopCV / VNWorks 35%"></div>
                            <div class="progress-bar bg-purple" style="width: 15%; background: #9333ea;" title="Nội bộ Referral 15%"></div>
                            <div class="progress-bar bg-secondary" style="width: 8%" title="Khác 8%"></div>
                        </div>
                        <div class="row g-2" style="font-size: 0.78rem;">
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light d-flex justify-content-between">
                                    <span><span class="badge-dot-indicator bg-primary"></span>LinkedIn</span>
                                    <strong>42% (36)</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light d-flex justify-content-between">
                                    <span><span class="badge-dot-indicator bg-info"></span>TopCV / VNW</span>
                                    <strong>35% (30)</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light d-flex justify-content-between">
                                    <span><span class="badge-dot-indicator" style="background:#9333ea;"></span>Nội bộ (Ref)</span>
                                    <strong>15% (13)</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light d-flex justify-content-between">
                                    <span><span class="badge-dot-indicator bg-secondary"></span>Khác</span>
                                    <strong>8% (7)</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Widget 2: Today's Interview Schedule -->
                    <div class="card border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center gap-2">
                                <h4 class="h6 fw-bold text-dark mb-0">Lịch phỏng vấn hôm nay</h4>
                                <span class="badge-dot-indicator bg-danger"></span>
                            </div>
                            <span class="badge bg-danger-subtle text-danger">3 ca xếp lịch</span>
                        </div>
                        <div class="interview-schedule-list">
                            <!-- Interview 1 -->
                            <div class="interview-timeline-item">
                                <div class="interview-time-pill">09:30<br>AM</div>
                                <div>
                                    <div class="fw-bold text-dark" style="font-size: 0.83rem;">Vũ Hoàng Nam</div>
                                    <div class="text-muted" style="font-size: 0.74rem;">Senior Fullstack Eng.</div>
                                    <div class="text-primary mt-1" style="font-size: 0.72rem;">
                                        <i class="bi bi-person-video"></i> PV: Nguyễn Minh Tuấn • Vòng Chuyên môn
                                    </div>
                                </div>
                            </div>

                            <!-- Interview 2 -->
                            <div class="interview-timeline-item">
                                <div class="interview-time-pill" style="background: #fdf4ff; color: #a21caf;">14:00<br>PM</div>
                                <div>
                                    <div class="fw-bold text-dark" style="font-size: 0.83rem;">Phạm Khánh Linh</div>
                                    <div class="text-muted" style="font-size: 0.74rem;">Product Designer UI/UX</div>
                                    <div class="text-primary mt-1" style="font-size: 0.72rem;">
                                        <i class="bi bi-person-video"></i> PV: Nguyễn Minh Tuấn • Vòng Portfolio
                                    </div>
                                </div>
                            </div>

                            <!-- Interview 3 -->
                            <div class="interview-timeline-item">
                                <div class="interview-time-pill" style="background: #ecfdf5; color: #059669;">16:15<br>PM</div>
                                <div>
                                    <div class="fw-bold text-dark" style="font-size: 0.83rem;">Trương Bá Đạt</div>
                                    <div class="text-muted" style="font-size: 0.74rem;">DevOps / Cloud Security</div>
                                    <div class="text-primary mt-1" style="font-size: 0.72rem;">
                                        <i class="bi bi-person-video"></i> PV: Trần Thị Mai • Vòng 1 [HR Fit]
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom: Recruitment Campaigns Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <h2 class="h6 fw-bold mb-0 text-dark">Danh sách yêu cầu tuyển dụng</h2>
                        <span class="badge bg-primary-subtle text-primary border-0">12 chiến dịch đang chạy</span>
                    </div>

                    <div class="d-flex flex-wrap align-items-center gap-2">
                        <div class="input-group input-group-sm" style="width: 240px;">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                            <input type="text" class="form-control border-start-0" placeholder="Tìm theo vị trí, mã yêu cầu...">
                        </div>
                        <ul class="nav nav-pills nav-fill payment-batch-tabs">
                            <li class="nav-item"><a class="nav-link active py-1 px-2" href="#">Tất cả (12)</a></li>
                            <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Đang tuyển (8)</a></li>
                            <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Tạm dừng (2)</a></li>
                            <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Đã đủ (1)</a></li>
                            <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Đã đóng (1)</a></li>
                        </ul>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3" style="width: 140px;">Mã yêu cầu</th>
                                <th>Vị trí tuyển dụng</th>
                                <th>Phòng ban</th>
                                <th class="text-center">Cần tuyển</th>
                                <th class="text-center">Ứng viên</th>
                                <th class="text-center">Phỏng vấn</th>
                                <th style="width: 180px;">Đã tuyển</th>
                                <th>Hạn chót</th>
                                <th class="pe-3">Người phụ trách</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Row 1: Senior Fullstack -->
                            <tr>
                                <td class="ps-3 fw-bold font-monospace text-primary">
                                    <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="text-decoration-none">YCTD-2026-081</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Senior Fullstack Engineer (React/Go) <span class="badge bg-danger ms-1">HOT</span></div>
                                </td>
                                <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                <td class="text-center fw-bold">3</td>
                                <td class="text-center font-monospace">26</td>
                                <td class="text-center font-monospace text-primary fw-bold">7</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-primary" style="width: 67%;"></div>
                                        </div>
                                        <span class="small fw-bold">2/3 (67%)</span>
                                    </div>
                                </td>
                                <td>
                                    <div>15/10/2026</div>
                                    <small class="text-primary">Còn 18 ngày</small>
                                </td>
                                <td class="pe-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-primary-subtle text-primary fw-bold" style="width: 26px; height: 26px; font-size: 0.7rem;">PT</div>
                                        <span>Phương Thảo</span>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 2: Sales Lead -->
                            <tr>
                                <td class="ps-3 fw-bold font-monospace text-primary">
                                    <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="text-decoration-none">YCTD-2026-082</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Trưởng nhóm Kinh doanh B2B (Sales Lead)</div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Kinh doanh</span></td>
                                <td class="text-center fw-bold">1</td>
                                <td class="text-center font-monospace">18</td>
                                <td class="text-center font-monospace text-primary fw-bold">5</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-success" style="width: 100%;"></div>
                                        </div>
                                        <span class="small fw-bold text-success">1/1 (100%)</span>
                                    </div>
                                </td>
                                <td>
                                    <div>30/09/2026</div>
                                    <small class="text-success fw-semibold">Đã hoàn thành</small>
                                </td>
                                <td class="pe-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-info-subtle text-info fw-bold" style="width: 26px; height: 26px; font-size: 0.7rem;">TM</div>
                                        <span>Thị Mai</span>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 3: Product Designer -->
                            <tr>
                                <td class="ps-3 fw-bold font-monospace text-primary">
                                    <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="text-decoration-none">YCTD-2026-083</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Product Designer (UI/UX Senior)</div>
                                </td>
                                <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                <td class="text-center fw-bold">2</td>
                                <td class="text-center font-monospace">15</td>
                                <td class="text-center font-monospace text-primary fw-bold">4</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-primary" style="width: 50%;"></div>
                                        </div>
                                        <span class="small fw-bold">1/2 (50%)</span>
                                    </div>
                                </td>
                                <td>
                                    <div>20/10/2026</div>
                                    <small class="text-primary">Còn 23 ngày</small>
                                </td>
                                <td class="pe-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-primary-subtle text-primary fw-bold" style="width: 26px; height: 26px; font-size: 0.7rem;">PT</div>
                                        <span>Phương Thảo</span>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 4: Content Marketing -->
                            <tr>
                                <td class="ps-3 fw-bold font-monospace text-primary">
                                    <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="text-decoration-none">YCTD-2026-084</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Content Marketing Specialist</div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Marketing & TT</span></td>
                                <td class="text-center fw-bold">2</td>
                                <td class="text-center font-monospace">12</td>
                                <td class="text-center font-monospace text-primary fw-bold">3</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-warning" style="width: 0%;"></div>
                                        </div>
                                        <span class="small fw-bold text-muted">0/2 (0%)</span>
                                    </div>
                                </td>
                                <td>
                                    <div>05/10/2026</div>
                                    <small class="text-danger fw-bold">⚠ Còn 8 ngày</small>
                                </td>
                                <td class="pe-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-warning-subtle text-warning fw-bold" style="width: 26px; height: 26px; font-size: 0.7rem;">LT</div>
                                        <span>Lê Trọng</span>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 5: Kế toán thuế -->
                            <tr>
                                <td class="ps-3 fw-bold font-monospace text-primary">
                                    <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="text-decoration-none">YCTD-2026-085</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Kế toán Thuế & Kiểm toán nội bộ</div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Tài chính - KT</span></td>
                                <td class="text-center fw-bold">1</td>
                                <td class="text-center font-monospace">7</td>
                                <td class="text-center font-monospace text-primary fw-bold">2</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-success" style="width: 100%;"></div>
                                        </div>
                                        <span class="small fw-bold text-success">1/1 (100%)</span>
                                    </div>
                                </td>
                                <td>
                                    <div>15/09/2026</div>
                                    <small class="text-muted">Đã đóng kỳ</small>
                                </td>
                                <td class="pe-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 26px; height: 26px; font-size: 0.7rem;">ĐQ</div>
                                        <span>Quốc Việt</span>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 6: DevOps Cloud -->
                            <tr>
                                <td class="ps-3 fw-bold font-monospace text-primary">
                                    <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="text-decoration-none">YCTD-2026-086</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">DevOps / Cloud Security Specialist</div>
                                </td>
                                <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                <td class="text-center fw-bold">1</td>
                                <td class="text-center font-monospace">4</td>
                                <td class="text-center font-monospace text-primary fw-bold">2</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-secondary" style="width: 0%;"></div>
                                        </div>
                                        <span class="small fw-bold text-muted">0/1 (0%)</span>
                                    </div>
                                </td>
                                <td>
                                    <div>25/10/2026</div>
                                    <small class="text-muted">Tạm ngưng nhận HS</small>
                                </td>
                                <td class="pe-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-primary-subtle text-primary fw-bold" style="width: 26px; height: 26px; font-size: 0.7rem;">PT</div>
                                        <span>Phương Thảo</span>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 7: C&B Specialist -->
                            <tr>
                                <td class="ps-3 fw-bold font-monospace text-primary">
                                    <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="text-decoration-none">YCTD-2026-087</a>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Chuyên viên Nhân sự C&B</div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Hành chính - NS</span></td>
                                <td class="text-center fw-bold">1</td>
                                <td class="text-center font-monospace">4</td>
                                <td class="text-center font-monospace text-primary fw-bold">1</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-primary" style="width: 0%;"></div>
                                        </div>
                                        <span class="small fw-bold text-muted">0/1 (0%)</span>
                                    </div>
                                </td>
                                <td>
                                    <div>12/10/2026</div>
                                    <small class="text-primary">Còn 15 ngày</small>
                                </td>
                                <td class="pe-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 26px; height: 26px; font-size: 0.7rem;">ĐQ</div>
                                        <span>Quốc Việt</span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white border-top py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                    <span class="text-muted small">Hiển thị <strong>1 - 7</strong> trong tổng số <strong>12</strong> vị trí tuyển dụng</span>
                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled"><a class="page-link" href="#">Trước</a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">Sau</a></li>
                        </ul>
                    </nav>
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
