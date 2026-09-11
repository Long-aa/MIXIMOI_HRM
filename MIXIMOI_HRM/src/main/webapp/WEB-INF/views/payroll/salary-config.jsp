<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thiết lập lương & Thang bảng lương — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="salary-config" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Salary Config Page Body -->
        <div class="app-content">
            
            <!-- Page Header Area -->
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <i class="bi bi-diagram-3-fill text-primary"></i>
                        <span class="text-primary fw-bold text-uppercase" style="font-size: 0.75rem; letter-spacing: 0.5px;">
                            HỆ THỐNG CHẾ ĐỘ ĐÃI NGỘ & QUY CHẾ CHI TRẢ
                        </span>
                    </div>
                    <h3 class="fw-extrabold text-dark mb-1" style="font-weight: 800; font-size: 1.65rem;">
                        Thiết lập lương & Thang bảng lương
                    </h3>
                    <p class="text-muted mb-0" style="font-size: 0.84rem;">
                        Định nghĩa quy chế tính lương, thang bậc lương cơ sở, ngạch bậc và chính sách đóng bảo hiểm theo pháp luật hiện hành.
                    </p>
                </div>

                <!-- Action Toolbar -->
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <button type="button" class="btn-action-light" onclick="alert('Đang tải xuống tài liệu Quy chế lương định dạng PDF...');">
                        <i class="bi bi-file-earmark-pdf"></i>
                        <span>Xuất quy chế (PDF)</span>
                    </button>

                    <button type="button" class="btn-action-primary" onclick="alert('Mở form tạo mới chính sách thang bảng lương...');">
                        <i class="bi bi-plus-circle"></i>
                        <span>Tạo chính sách lương mới</span>
                    </button>
                </div>
            </div>

            <!-- 4 Stat KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- Card 1: Tổng khung chính sách -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng khung chính sách</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">6</span>
                                    <span class="kpi-unit">khung chuẩn</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-sliders"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-primary fw-semibold" style="font-size: 0.78rem;">
                                <i class="bi bi-check-circle-fill me-1"></i> 100% đáp ứng chuẩn Luật LĐ 2024
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Lương cơ sở hiện hành -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Lương cơ sở hiện hành</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">2.340.000</span>
                                    <span class="kpi-unit fw-bold">VNĐ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-cash-coin"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-light text-dark border">NĐ 73/2024/NĐ-CP</span>
                            <span class="text-muted">Áp dụng từ 01/07</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Tỷ lệ BHXH Doanh nghiệp -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tỷ lệ BHXH Doanh nghiệp</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">21.5%</span>
                                    <span class="kpi-unit">(Quỹ lương trần)</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-shield-shaded"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.75rem;">HT 14% • ÔB-TS 3% • YT...</span>
                            <span class="badge bg-primary-subtle text-primary">+0.5%</span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Tỷ lệ BHXH Người lao động -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tỷ lệ BHXH Người lao động</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">10.5%</span>
                                    <span class="kpi-unit">(Khấu trừ Gross)</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-person-shield"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.74rem;">Khấu trừ lương: 8% Hưu trí • 1.5% BHYT • 1% BHTN</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter & Search Toolbar -->
            <div class="dashboard-filter-card mb-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex flex-wrap align-items-center gap-2 flex-grow-1">
                        <!-- Search Box -->
                        <div class="position-relative" style="min-width: 280px;">
                            <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted" style="font-size: 0.85rem;"></i>
                            <input type="text" class="form-control ps-5 py-2 bg-light border-0" placeholder="Tìm theo mã ngạch, tên cấp bậc hoặc mã chức danh..." style="font-size: 0.83rem; border-radius: 10px;">
                        </div>

                        <!-- Level Filter -->
                        <div class="d-flex align-items-center gap-1">
                            <span class="text-muted fw-bold" style="font-size: 0.75rem;">KHỐI:</span>
                            <select class="filter-select">
                                <option selected>Tất cả nhóm ngạch (All Levels)</option>
                                <option>Khối Lãnh đạo & Quản lý</option>
                                <option>Khối Chuyên gia Kỹ thuật</option>
                                <option>Khối Nghiệp vụ Tiêu chuẩn</option>
                                <option>Khối Thử việc & Thực tập</option>
                            </select>
                        </div>

                        <!-- Department Filter -->
                        <div class="d-flex align-items-center gap-1">
                            <span class="text-muted fw-bold" style="font-size: 0.75rem;">BỘ PHẬN:</span>
                            <select class="filter-select">
                                <option selected>Mọi phòng ban</option>
                                <option>Khối Công nghệ & IT</option>
                                <option>Khối Vận hành & Sản xuất</option>
                                <option>Khối Kinh doanh</option>
                            </select>
                        </div>

                        <!-- Status Filter -->
                        <select class="filter-select">
                            <option selected>Đang áp dụng (Active)</option>
                            <option>Bản dự thảo</option>
                            <option>Đã hết hiệu lực</option>
                        </select>
                    </div>

                    <!-- Right Buttons -->
                    <div class="d-flex align-items-center gap-2">
                        <button class="btn btn-sm btn-light border py-2 px-3 fw-semibold text-secondary" style="font-size: 0.8rem;">
                            <i class="bi bi-layout-three-columns me-1"></i> Cột hiển thị
                        </button>
                        <button class="btn btn-sm btn-light border py-2 px-3" title="Làm mới"><i class="bi bi-arrow-clockwise"></i></button>
                    </div>
                </div>
            </div>

            <!-- Main Salary Scale Table Card -->
            <div class="table-custom-container mb-4">
                <!-- Card Header with Scale Name & Period -->
                <div class="p-3 border-bottom d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fw-bold text-dark" style="font-size: 1rem;">Thang bậc lương & Ngạch chức danh</span>
                        <span class="badge bg-primary-subtle text-primary border-0 fw-bold">5 ngạch tiêu chuẩn</span>
                    </div>
                    <span class="text-muted" style="font-size: 0.8rem;">
                        Chu kỳ tái cấu trúc bảng lương: <strong>01/01/2025 - 31/12/2025</strong>
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width: 40px;" class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </th>
                                <th>MÃ NGẠCH</th>
                                <th>TÊN NGẠCH / VỊ TRÍ ÁP DỤNG</th>
                                <th class="text-center">BẬC THANG (1 - 7)</th>
                                <th class="text-center">HỆ SỐ CHUẨN</th>
                                <th class="text-center">MỨC SÀN GROSS (MIN - MAX)</th>
                                <th class="text-center">PHỤ CẤP CHỨC VỤ</th>
                                <th class="text-center">HIỆU LỰC</th>
                                <th class="text-center">TRẠNG THÁI</th>
                                <th class="text-end pe-4">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Row 1: DIR-01 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <span class="fw-bold text-primary">DIR-01</span>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Giám đốc Khối / Giám đốc Kỹ thuật</div>
                                    <div class="text-muted" style="font-size: 0.74rem;">Khối Công nghệ & Khối Vận hành</div>
                                </td>
                                <td class="text-center">
                                    <div class="grade-bracket-box">
                                        <span>Bậc 7/7</span>
                                        <span class="grade-bracket-sub">Cấp cao</span>
                                    </div>
                                </td>
                                <td class="text-center font-monospace fw-bold">7.85 - 10.20</td>
                                <td class="text-center">
                                    <span class="font-monospace fw-bold text-dark">55.000.000 - 90.000.000</span><br>
                                    <small class="text-muted" style="font-size:0.7rem;">VNĐ / tháng</small>
                                </td>
                                <td class="text-center font-monospace fw-bold text-primary">12.000.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">01/01/2024</td>
                                <td class="text-center">
                                    <span class="status-badge-applied">
                                        <i class="bi bi-circle-fill" style="font-size: 0.45rem;"></i> Áp dụng
                                    </span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chỉnh sửa"><i class="bi bi-pencil"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Sơ đồ ngạch"><i class="bi bi-diagram-2"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 2: MGR-02 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <span class="fw-bold text-primary">MGR-02</span>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Trưởng phòng / Trưởng nhóm Nghiệp vụ</div>
                                    <div class="text-muted" style="font-size: 0.74rem;">Tất cả các phòng ban nội bộ</div>
                                </td>
                                <td class="text-center">
                                    <div class="grade-bracket-box">
                                        <span>Bậc 5/7</span>
                                        <span class="grade-bracket-sub">Quản trị</span>
                                    </div>
                                </td>
                                <td class="text-center font-monospace fw-bold">4.50 - 6.80</td>
                                <td class="text-center">
                                    <span class="font-monospace fw-bold text-dark">32.000.000 - 52.000.000</span><br>
                                    <small class="text-muted" style="font-size:0.7rem;">VNĐ / tháng</small>
                                </td>
                                <td class="text-center font-monospace fw-bold text-primary">6.500.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">01/01/2024</td>
                                <td class="text-center">
                                    <span class="status-badge-applied">
                                        <i class="bi bi-circle-fill" style="font-size: 0.45rem;"></i> Áp dụng
                                    </span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chỉnh sửa"><i class="bi bi-pencil"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Sơ đồ ngạch"><i class="bi bi-diagram-2"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 3: SPE-03 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <span class="fw-bold text-primary">SPE-03</span>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Chuyên viên Cao cấp / Senior Tech Lead</div>
                                    <div class="text-muted" style="font-size: 0.74rem;">Phát triển phần mềm & Phân tích DL</div>
                                </td>
                                <td class="text-center">
                                    <div class="grade-bracket-box">
                                        <span>Bậc 4/7</span>
                                        <span class="grade-bracket-sub">Chuyên gia</span>
                                    </div>
                                </td>
                                <td class="text-center font-monospace fw-bold">3.20 - 4.80</td>
                                <td class="text-center">
                                    <span class="font-monospace fw-bold text-dark">24.000.000 - 38.000.000</span><br>
                                    <small class="text-muted" style="font-size:0.7rem;">VNĐ / tháng</small>
                                </td>
                                <td class="text-center font-monospace fw-bold text-primary">3.000.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">15/06/2024</td>
                                <td class="text-center">
                                    <span class="status-badge-applied">
                                        <i class="bi bi-circle-fill" style="font-size: 0.45rem;"></i> Áp dụng
                                    </span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chỉnh sửa"><i class="bi bi-pencil"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Sơ đồ ngạch"><i class="bi bi-diagram-2"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 4: EXE-04 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <span class="fw-bold text-primary">EXE-04</span>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Chuyên viên Nghiệp vụ / Kỹ sư chính</div>
                                    <div class="text-muted" style="font-size: 0.74rem;">Nhân sự, Kế toán, Kinh doanh, CSKH</div>
                                </td>
                                <td class="text-center">
                                    <div class="grade-bracket-box">
                                        <span>Bậc 2/7</span>
                                        <span class="grade-bracket-sub">Tiêu chuẩn</span>
                                    </div>
                                </td>
                                <td class="text-center font-monospace fw-bold">1.80 - 2.80</td>
                                <td class="text-center">
                                    <span class="font-monospace fw-bold text-dark">14.000.000 - 22.000.000</span><br>
                                    <small class="text-muted" style="font-size:0.7rem;">VNĐ / tháng</small>
                                </td>
                                <td class="text-center font-monospace fw-bold text-primary">1.200.000 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">01/01/2024</td>
                                <td class="text-center">
                                    <span class="status-badge-applied">
                                        <i class="bi bi-circle-fill" style="font-size: 0.45rem;"></i> Áp dụng
                                    </span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chỉnh sửa"><i class="bi bi-pencil"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Sơ đồ ngạch"><i class="bi bi-diagram-2"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 5: INT-05 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <span class="fw-bold text-primary">INT-05</span>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark" style="font-size: 0.86rem;">Nhân viên Thử việc & Thực tập sinh dự án</div>
                                    <div class="text-muted" style="font-size: 0.74rem;">Khối Kinh doanh và Tiếp thị tăng trưởng</div>
                                </td>
                                <td class="text-center">
                                    <div class="grade-bracket-box">
                                        <span>Bậc 1/7</span>
                                        <span class="grade-bracket-sub">Khởi điểm</span>
                                    </div>
                                </td>
                                <td class="text-center font-monospace fw-bold">1.00 - 1.40</td>
                                <td class="text-center">
                                    <span class="font-monospace fw-bold text-dark">6.000.000 - 10.500.000</span><br>
                                    <small class="text-muted" style="font-size:0.7rem;">VNĐ / tháng</small>
                                </td>
                                <td class="text-center font-monospace fw-bold text-muted">0 đ</td>
                                <td class="text-center text-muted" style="font-size: 0.8rem;">01/04/2025</td>
                                <td class="text-center">
                                    <span class="status-badge-draft">
                                        <i class="bi bi-circle-fill" style="font-size: 0.45rem;"></i> Bản dự thảo
                                    </span>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-light border-0" title="Chỉnh sửa"><i class="bi bi-pencil"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-light border-0" title="Sơ đồ ngạch"><i class="bi bi-diagram-2"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Table Footer -->
                <div class="p-3 border-top d-flex justify-content-between align-items-center" style="font-size:0.82rem;">
                    <span class="text-muted">
                        Hiển thị <strong>5 / 5 bản ghi</strong> danh mục cấu hình lương
                    </span>
                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        </ul>
                    </nav>
                </div>
            </div>

            <!-- Bottom 2 Configuration Cards (Payroll Cycle & Overtime Factors) -->
            <div class="row g-3">
                <!-- Card 1: Cấu hình chu kỳ tính lương (Payroll Cycle) -->
                <div class="col-lg-6">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">
                                        <i class="bi bi-calendar-range text-primary me-1"></i>
                                        Cấu hình chu kỳ tính lương (Payroll Cycle)
                                    </div>
                                    <p class="app-card-subtitle">
                                        Quy chuẩn chu kỳ cắt dữ liệu chấm công và thời điểm chi trả phiếu lương hàng tháng của toàn công ty.
                                    </p>
                                </div>
                                <span class="badge bg-primary-subtle text-primary px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    Đang áp dụng
                                </span>
                            </div>

                            <!-- 3 Mini Cycle Cards -->
                            <div class="row g-2 my-3">
                                <div class="col-4">
                                    <div class="p-3 bg-light rounded-3 text-center border">
                                        <div class="text-muted fw-bold text-uppercase mb-1" style="font-size: 0.68rem;">NGÀY CHỐT CÔNG</div>
                                        <div class="fw-extrabold text-primary" style="font-size: 1.35rem; font-weight: 800;">Ngày 25</div>
                                        <div class="text-muted" style="font-size: 0.72rem;">Hàng tháng (23:59)</div>
                                        <div class="text-secondary mt-1" style="font-size: 0.68rem;">Bao gồm bù công/tăng ca</div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="p-3 bg-light rounded-3 text-center border">
                                        <div class="text-muted fw-bold text-uppercase mb-1" style="font-size: 0.68rem;">NGÀY PHÁT LƯƠNG</div>
                                        <div class="fw-extrabold text-primary" style="font-size: 1.35rem; font-weight: 800;">Mùng 05</div>
                                        <div class="text-muted" style="font-size: 0.72rem;">Tháng kế tiếp (N+1)</div>
                                        <div class="text-secondary mt-1" style="font-size: 0.68rem;">Chuyển khoản Banking tự động</div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="p-3 bg-light rounded-3 text-center border">
                                        <div class="text-muted fw-bold text-uppercase mb-1" style="font-size: 0.68rem;">CÔNG CHUẨN THÁNG</div>
                                        <div class="fw-extrabold text-dark" style="font-size: 1.35rem; font-weight: 800;">22 công</div>
                                        <div class="text-muted" style="font-size: 0.72rem;">Nghỉ T7 & CN cố định</div>
                                        <div class="text-secondary mt-1" style="font-size: 0.68rem;">Lương 1 công = Lương cơ bản / 22</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="pt-3 border-top d-flex justify-content-between align-items-center" style="font-size:0.8rem;">
                            <span class="text-muted">
                                <i class="bi bi-info-circle text-primary me-1"></i>
                                Nếu ngày 05 rơi vào ngày lễ hoặc cuối tuần, tiền lương sẽ được giải ngân vào ngày làm việc liền trước.
                            </span>
                            <a href="#" class="text-primary fw-bold text-decoration-none">Sửa chu kỳ</a>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Hệ số OT & Làm tròn -->
                <div class="col-lg-6">
                    <div class="app-card d-flex flex-column justify-content-between">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">
                                        <i class="bi bi-calculator text-primary me-1"></i>
                                        Hệ số OT & Làm tròn
                                    </div>
                                    <p class="app-card-subtitle">
                                        Quy tắc tính hệ số lương ngoài giờ (Overtime) căn cứ theo Điều 98 Bộ Luật Lao động Việt Nam.
                                    </p>
                                </div>
                                <a href="#" class="text-primary fw-bold text-decoration-none" style="font-size: 0.8rem;">Điều chỉnh</a>
                            </div>

                            <!-- Overtime Bullets -->
                            <div class="d-flex flex-column gap-2 my-3" style="font-size: 0.84rem;">
                                <div class="d-flex justify-content-between align-items-center p-2 rounded bg-light">
                                    <span><span class="badge-dot-indicator bg-primary"></span> Tăng ca ngày làm việc thông thường</span>
                                    <strong class="text-primary fs-6">150%</strong>
                                </div>
                                <div class="d-flex justify-content-between align-items-center p-2 rounded bg-light">
                                    <span><span class="badge-dot-indicator bg-primary"></span> Tăng ca ngày nghỉ hàng tuần (Thứ 7, CN)</span>
                                    <strong class="text-primary fs-6">200%</strong>
                                </div>
                                <div class="d-flex justify-content-between align-items-center p-2 rounded bg-light">
                                    <span><span class="badge-dot-indicator bg-danger"></span> Tăng ca ngày nghỉ Lễ, Tết & ngày phép</span>
                                    <strong class="text-danger fs-6">300%</strong>
                                </div>
                            </div>

                            <!-- Highlight rounding card -->
                            <div class="p-3 rounded-3 bg-primary-subtle d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-primary fw-bold text-uppercase" style="font-size: 0.7rem;">LÀM TRÒN KẾT QUẢ CHI TRẢ</div>
                                    <div class="fw-bold text-dark" style="font-size: 0.95rem;">Làm tròn tới hàng đơn vị nghìn (1.000 VNĐ)</div>
                                </div>
                                <i class="bi bi-check-circle-fill text-primary fs-4"></i>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="pt-3 border-top">
                            <span class="text-muted" style="font-size:0.8rem;">
                                Thuật toán làm tròn được áp dụng đồng bộ trên tất cả các phiếu lương và lệnh chuyển khoản tự động.
                            </span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
