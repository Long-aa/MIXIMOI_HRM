<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Đánh giá Hiệu suất Nhân sự - MIXIMOI HRM" />
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
            <c:if test="${param.success eq 'confirmed'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div>Đã xác nhận kết quả thẩm định <strong>8.96 / 10.0 (Xuất sắc - Hạng A+)</strong> cho nhân sự Lê Hoàng Nam!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Đánh giá hiệu suất</h1>
                        <span class="badge bg-primary-subtle text-primary fw-bold">
                            <span class="badge-dot-indicator bg-primary"></span>Kỳ Q3/2026 đang mở
                        </span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý chu kỳ đánh giá, thẩm định năng lực và kết quả xếp loại nhân sự toàn diện.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="window.print()">
                        <i class="bi bi-printer"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#configEvaluationModal">
                        <i class="bi bi-sliders"></i>
                        <span>Cấu hình kỳ đánh giá</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createEvaluationCycleModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>+ Tạo đợt đánh giá mới</span>
                    </button>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Tổng nhân viên cần đánh giá</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">245</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">nhân sự</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-light text-dark border">Phân bổ 6 phòng ban</span>
                            <span class="text-muted small">100% mục tiêu</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã hoàn tất đánh giá</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-check2-circle"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">186</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">/ 245</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-success-subtle text-success fw-semibold">↗ 75.9% hoàn thành kỳ Q3/2026</span>
                            <span class="text-muted small">+12.4% MoM</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Chưa / Đang đánh giá</span>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-clock-history"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-primary fw-bold" style="font-size: 1.85rem;">59</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">hồ sơ chờ</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-danger-subtle text-danger fw-semibold">⚠ Hạn chót còn 5 ngày (30/09)</span>
                            <span class="text-muted small">Cần nhắc nhở</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Điểm trung bình toàn công ty</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-award"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-purple fw-bold" style="font-size: 1.85rem; color: #7c3aed;">8.6</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">/ 10</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-primary-subtle text-primary fw-semibold">Xếp loại Giỏi (Tăng +0.3 vs Q2)</span>
                            <span class="badge bg-success-subtle text-success">Tốt</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-12 col-md-3">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" placeholder="Tìm kiếm theo tên nhân viên, mã NV, chức...">
                            </div>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Kỳ: Quý 3/2026</option>
                                <option>Kỳ: Quý 2/2026</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả phòng ban</option>
                                <option>CNTT & R&D</option>
                                <option>Marketing</option>
                                <option>Kinh doanh</option>
                                <option>Tài chính - KT</option>
                                <option>Nhân sự & HC</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả người đánh giá</option>
                                <option>Trần Tuấn Hưng</option>
                                <option>Phạm Thu Nga</option>
                                <option>Đặng Minh Tú</option>
                                <option>Hoàng Văn Cường</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả trạng thái</option>
                                <option>Đã hoàn tất</option>
                                <option>Đang đánh giá</option>
                                <option>Chưa đánh giá</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-1 d-flex justify-content-end">
                            <button class="btn btn-sm btn-outline-secondary w-100" title="Tải lại"><i class="bi bi-arrow-repeat"></i></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Two-Column Layout: Employee Evaluation List + Evaluation Inspector Drawer -->
            <div class="row g-4">
                <!-- Col-7: Employee Evaluation Table -->
                <div class="col-12 col-xl-7">
                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                        <div class="card-header bg-white border-bottom py-3 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                            <div>
                                <h2 class="h6 fw-bold mb-0 text-dark">Danh sách nhân viên đánh giá</h2>
                                <span class="text-muted small">Hiển thị 186/245 hồ sơ đợt Q3/2026</span>
                            </div>

                            <ul class="nav nav-pills payment-batch-tabs">
                                <li class="nav-item"><a class="nav-link active py-1 px-2" href="#">Tất cả (245)</a></li>
                                <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Chưa ĐG (59)</a></li>
                                <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Đang ĐG (42)</a></li>
                                <li class="nav-item"><a class="nav-link py-1 px-2" href="#">Chờ duyệt (18)</a></li>
                            </ul>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3" style="width: 35px;"><input class="form-check-input" type="checkbox"></th>
                                        <th>Nhân viên</th>
                                        <th>Phòng ban</th>
                                        <th>Người đánh giá</th>
                                        <th class="text-center">KPI (40%)</th>
                                        <th class="pe-3 text-center">ĐG (60%)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Row 1: Selected (Lê Hoàng Nam) -->
                                    <tr class="table-primary bg-opacity-25" style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox" checked></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-primary text-white fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">LN</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Lê Hoàng Nam</div>
                                                    <small class="text-muted">NV-IT-042 • Senior Tech Lead</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 22px; height: 22px; font-size: 0.65rem;">TH</div>
                                                <span>Trần Tuấn Hưng</span>
                                            </div>
                                        </td>
                                        <td class="text-center font-monospace fw-bold text-primary">9.4</td>
                                        <td class="pe-3 text-center font-monospace fw-bold text-dark">8.67</td>
                                    </tr>

                                    <!-- Row 2: Nguyễn Thị Mai Anh -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-info-subtle text-info fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">MA</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Nguyễn Thị Mai Anh</div>
                                                    <small class="text-muted">NV-MKT-018 • Brand Lead</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Marketing</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 22px; height: 22px; font-size: 0.65rem;">TN</div>
                                                <span>Phạm Thu Nga</span>
                                            </div>
                                        </td>
                                        <td class="text-center font-monospace fw-bold text-primary">8.8</td>
                                        <td class="pe-3 text-center font-monospace fw-bold text-dark">8.22</td>
                                    </tr>

                                    <!-- Row 3: Đặng Hoàng Quân -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-warning-subtle text-warning fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">HQ</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Đặng Hoàng Quân</div>
                                                    <small class="text-muted">NV-SAL-089 • Account Exec</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Kinh doanh</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 22px; height: 22px; font-size: 0.65rem;">DT</div>
                                                <span>Đặng Minh Tú</span>
                                            </div>
                                        </td>
                                        <td class="text-center font-monospace fw-bold text-primary">8.0</td>
                                        <td class="pe-3 text-center font-monospace fw-bold text-dark">7.75</td>
                                    </tr>

                                    <!-- Row 4: Trần Bảo Ngọc -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-success-subtle text-success fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">BN</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Trần Bảo Ngọc</div>
                                                    <small class="text-muted">NV-FIN-012 • Kế toán trưởng</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Tài chính - KT</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 22px; height: 22px; font-size: 0.65rem;">HC</div>
                                                <span>Hoàng Văn Cường</span>
                                            </div>
                                        </td>
                                        <td class="text-center font-monospace fw-bold text-primary">9.5</td>
                                        <td class="pe-3 text-center font-monospace fw-bold text-dark">8.83</td>
                                    </tr>

                                    <!-- Row 5: Vũ Hải Đăng -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">HD</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Vũ Hải Đăng</div>
                                                    <small class="text-muted">NV-IT-099 • DevOps Eng</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 22px; height: 22px; font-size: 0.65rem;">TH</div>
                                                <span>Trần Tuấn Hưng</span>
                                            </div>
                                        </td>
                                        <td class="text-center font-monospace fw-bold text-primary">7.2</td>
                                        <td class="pe-3 text-center font-monospace fw-bold text-dark">6.53</td>
                                    </tr>

                                    <!-- Row 6: Phan Thùy Trang -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-circle bg-primary-subtle text-primary fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">TT</div>
                                                <div>
                                                    <div class="fw-bold text-dark">Phan Thùy Trang</div>
                                                    <small class="text-muted">NV-HR-007 • Training Specialist</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Nhân sự & HC</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 22px; height: 22px; font-size: 0.65rem;">TN</div>
                                                <span>Phạm Thu Nga</span>
                                            </div>
                                        </td>
                                        <td class="text-center font-monospace fw-bold text-primary">9.0</td>
                                        <td class="pe-3 text-center font-monospace fw-bold text-dark">8.58</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="card-footer bg-white border-top py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                            <span class="text-muted small">Hiển thị 1 - 6 trong tổng số 245 nhân viên</span>
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

                <!-- Col-5: Evaluation Inspector Drawer (Lê Hoàng Nam) -->
                <div class="col-12 col-xl-5">
                    <div class="eval-inspector-drawer">
                        <!-- Drawer Header -->
                        <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="position-relative">
                                    <div class="avatar-circle bg-primary text-white fw-bold" style="width: 48px; height: 48px; font-size: 1.1rem;">LN</div>
                                    <span class="position-absolute bottom-0 end-0 bg-success text-white rounded-circle p-1" style="font-size: 0.6rem;"><i class="bi bi-check-lg"></i></span>
                                </div>
                                <div>
                                    <div class="d-flex align-items-center gap-2">
                                        <h3 class="h6 fw-bold text-dark mb-0">Lê Hoàng Nam</h3>
                                        <i class="bi bi-patch-check-fill text-primary" style="font-size: 0.85rem;"></i>
                                    </div>
                                    <div class="text-muted small">Senior Tech Lead - Ban CNTT & R&D</div>
                                    <div class="text-muted small font-monospace">Mã: NV-IT-042 • Đợt: Q3/2026</div>
                                </div>
                            </div>
                            <a href="#" class="text-muted"><i class="bi bi-box-arrow-up-right fs-6"></i></a>
                        </div>

                        <!-- Overall Score Summary Box -->
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <div class="p-2 px-3 border rounded-3 bg-light">
                                    <small class="text-muted text-uppercase fw-bold d-block" style="font-size: 0.68rem;">ĐIỂM THẨM ĐỊNH CHUNG</small>
                                    <div class="d-flex align-items-baseline gap-1">
                                        <strong class="text-primary fs-3 fw-bold">8.96</strong>
                                        <span class="text-muted small">/ 10.0</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 px-3 border rounded-3 bg-purple-subtle bg-opacity-25 border-purple-subtle" style="background: #faf5ff;">
                                    <small class="text-muted text-uppercase fw-bold d-block" style="font-size: 0.68rem;">XẾP LOẠI KỲ</small>
                                    <div class="badge bg-purple-subtle text-purple fs-6 fw-bold mt-1" style="background: #f3e8ff; color: #7e22ce;">
                                        Xuất sắc (Hạng A+)
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Weight Breakdown Items -->
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold text-dark small text-uppercase" style="font-size: 0.76rem;">CƠ CẤU TRỌNG SỐ ĐÁNH GIÁ</span>
                            <span class="badge bg-light text-primary border" style="font-size: 0.7rem;">Quy chuẩn 100%</span>
                        </div>

                        <!-- Item 1: KPI -->
                        <div class="eval-weight-item">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark" style="font-size: 0.8rem;">1. KPI công việc (Trọng số 40%)</span>
                                <span class="text-primary fw-bold font-monospace" style="font-size: 0.82rem;">9.4 / 10 ➔ 3.76đ</span>
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 94%;"></div>
                            </div>
                            <small class="text-muted d-block" style="font-size: 0.72rem;">Hoàn thành 102% chỉ tiêu microservices, tỷ lệ uptime hệ thống đạt 99.98% SLA.</small>
                        </div>

                        <!-- Item 2: Competency -->
                        <div class="eval-weight-item">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark" style="font-size: 0.8rem;">2. Năng lực chuyên môn (Trọng số 30%)</span>
                                <span class="text-primary fw-bold font-monospace" style="font-size: 0.82rem;">8.8 / 10 ➔ 2.64đ</span>
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 88%;"></div>
                            </div>
                            <small class="text-muted d-block" style="font-size: 0.72rem;">Năng lực thiết kế kiến trúc hệ thống phân tán, xử lý sự cố P1 & code review nghiêm ngặt.</small>
                        </div>

                        <!-- Item 3: Culture -->
                        <div class="eval-weight-item">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark" style="font-size: 0.8rem;">3. Thái độ & Văn hóa (Trọng số 20%)</span>
                                <span class="text-primary fw-bold font-monospace" style="font-size: 0.82rem;">9.0 / 10 ➔ 1.80đ</span>
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 90%;"></div>
                            </div>
                            <small class="text-muted d-block" style="font-size: 0.72rem;">Tính chủ động cao, phối hợp liên phòng ban mượt mà, văn hóa phản hồi tích cực.</small>
                        </div>

                        <!-- Item 4: Innovation -->
                        <div class="eval-weight-item">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark" style="font-size: 0.8rem;">4. Đóng góp đổi mới (Trọng số 10%)</span>
                                <span class="text-primary fw-bold font-monospace" style="font-size: 0.82rem;">7.6 / 10 ➔ 0.76đ</span>
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 76%;"></div>
                            </div>
                            <small class="text-muted d-block" style="font-size: 0.72rem;">Kèm cặp tốt 2 Junior Developers và khởi xướng tối ưu tiết kiệm 14% tài nguyên AWS.</small>
                        </div>

                        <!-- Radar Chart Representation -->
                        <div class="eval-radar-box">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="small fw-bold text-dark text-uppercase">BIỂU ĐỒ RADAR NĂNG LỰC 4 CHIỀU</span>
                                <span class="badge bg-success-subtle text-success">Cân bằng vượt trội</span>
                            </div>
                            <div class="d-flex justify-content-around text-center mt-2" style="font-size: 0.72rem;">
                                <div>
                                    <div class="text-muted">KPI</div>
                                    <strong class="text-primary">9.4</strong>
                                </div>
                                <div>
                                    <div class="text-muted">Kỹ thuật</div>
                                    <strong class="text-primary">8.8</strong>
                                </div>
                                <div>
                                    <div class="text-muted">Văn hóa</div>
                                    <strong class="text-primary">9.0</strong>
                                </div>
                                <div>
                                    <div class="text-muted">Đổi mới</div>
                                    <strong class="text-primary">7.6</strong>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <form method="post" action="${pageContext.request.contextPath}/evaluations" class="m-0">
                                <input type="hidden" name="action" value="draft">
                                <button type="submit" class="btn btn-outline-secondary btn-sm">Lưu nháp</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/evaluations" class="m-0 flex-grow-1">
                                <input type="hidden" name="action" value="submit">
                                <button type="submit" class="btn btn-outline-primary btn-sm w-100">Gửi đánh giá</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/evaluations" class="m-0 flex-grow-1">
                                <input type="hidden" name="action" value="confirm">
                                <button type="submit" class="btn btn-primary btn-sm w-100 shadow-sm d-flex align-items-center justify-content-center gap-1">
                                    <i class="bi bi-check2-circle"></i> Xác nhận
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
