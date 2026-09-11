<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý danh mục & Mức phụ cấp — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="allowances" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Allowances Page Body -->
        <div class="app-content">
            
            <!-- Page Header Area -->
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <h3 class="fw-extrabold text-dark mb-1 d-flex align-items-center gap-2" style="font-weight: 800; font-size: 1.65rem;">
                        <i class="bi bi-wallet2 text-primary"></i>
                        Quản lý danh mục & Mức phụ cấp
                    </h3>
                    <p class="text-muted mb-0" style="font-size: 0.84rem;">
                        Quản lý các danh mục phụ cấp cố định, phụ cấp theo chức danh, trợ cấp độc hại và các khoản hỗ trợ miễn thuế tuân thủ pháp luật thuế TNCN.
                    </p>
                </div>

                <!-- Action Toolbar -->
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <button type="button" class="btn-action-light" onclick="alert('Đang kết xuất báo cáo danh mục phụ cấp...');">
                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Xuất báo cáo phụ cấp</span>
                    </button>

                    <button type="button" class="btn-action-primary" onclick="alert('Mở form thêm loại phụ cấp mới...');">
                        <i class="bi bi-plus-circle"></i>
                        <span>+ Thêm loại phụ cấp mới</span>
                    </button>
                </div>
            </div>

            <!-- 4 Stat KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- Card 1: Tổng loại phụ cấp -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng loại phụ cấp</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">12</span>
                                    <span class="kpi-unit">danh mục đang cấu hình</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-collection-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.76rem;">
                                <i class="bi bi-check-circle text-success me-1"></i> 10 đang áp dụng • 2 tạm dừng
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Chi phụ cấp tháng này (T9) -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Chi phụ cấp tháng này (T9)</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">85.200.000</span>
                                    <span class="kpi-unit fw-bold">đ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-cash-stack"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-graph-up-arrow"></i> +3.2%
                            </span>
                            <span class="text-muted">so với tháng 8/2024</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Phụ cấp miễn thuế -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Phụ cấp miễn thuế</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">4</span>
                                    <span class="kpi-unit">khoản miễn thuế TNCN</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-shield-check"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.74rem;">Cơm trưa, Xăng xe, Đ.Thoại, Tran...</span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Nhân sự thụ hưởng -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Nhân sự thụ hưởng</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">245</span>
                                    <span class="kpi-unit">/ 245 NV</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer flex-column align-items-stretch gap-1 pt-2">
                            <div class="progress" style="height: 6px;">
                                <div class="progress-bar bg-primary" role="progressbar" style="width: 100%;"></div>
                            </div>
                            <div class="text-end" style="font-size:0.75rem;">
                                <span class="fw-bold text-primary">100%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter & Tabs Bar -->
            <div class="dashboard-filter-card mb-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <!-- Segmented Tabs -->
                    <div class="card-filter-pills">
                        <button type="button" class="filter-pill active">Danh mục phụ cấp (12)</button>
                        <button type="button" class="filter-pill">Phân bổ theo nhân viên</button>
                        <button type="button" class="filter-pill">Chính sách & Khung mức</button>
                    </div>

                    <!-- Dropdowns & Search -->
                    <div class="d-flex flex-wrap align-items-center gap-2">
                        <select class="filter-select">
                            <option selected>Tất cả quy chế thuế</option>
                            <option>Miễn thuế TNCN</option>
                            <option>Chịu thuế TNCN</option>
                        </select>

                        <select class="filter-select">
                            <option selected>Tất cả hình thức chi trả</option>
                            <option>Cố định tháng</option>
                            <option>Theo ngày công</option>
                            <option>Theo dự án</option>
                        </select>

                        <div class="position-relative" style="min-width: 220px;">
                            <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted" style="font-size: 0.85rem;"></i>
                            <input type="text" class="form-control ps-5 py-2 bg-light border-0" placeholder="Tìm tên, mã phụ cấp..." style="font-size: 0.82rem; border-radius: 10px;">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Two Columns Layout: Left (Table 8 cols) & Right (Widgets 4 cols) -->
            <div class="row g-3">
                <!-- Left: Allowance Table (8 Cols) -->
                <div class="col-lg-8">
                    <div class="table-custom-container">
                        <div class="table-responsive">
                            <table class="table-custom">
                                <thead>
                                    <tr>
                                        <th>MÃ</th>
                                        <th>TÊN LOẠI PHỤ CẤP</th>
                                        <th class="text-end">MỨC CHUẨN (VNĐ)</th>
                                        <th class="text-center">HÌNH THỨC TÍNH</th>
                                        <th class="text-center">QUY CHẾ THUẾ TNCN</th>
                                        <th class="text-center">NGƯỜI HƯỞNG</th>
                                        <th class="text-center">TRẠNG THÁI</th>
                                        <th class="text-end pe-4">THAO TÁC</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- PC01 -->
                                    <tr>
                                        <td><span class="code-link">PC01</span></td>
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Phụ cấp ăn trưa</div>
                                            <div class="text-muted" style="font-size: 0.73rem;">Hỗ trợ bữa trưa ca tiêu chuẩn</div>
                                        </td>
                                        <td class="text-end font-monospace fw-bold">730.000</td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">Theo ngày công</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Miễn thuế (Tối đa 730k)</span>
                                        </td>
                                        <td class="text-center font-monospace fw-bold">245</td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Đang áp dụng</span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-light border-0" title="Sửa"><i class="bi bi-pencil"></i></button>
                                                <button class="btn btn-sm btn-light border-0" title="Tạm dừng"><i class="bi bi-pause-circle"></i></button>
                                                <button class="btn btn-sm btn-light border-0 text-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- PC02 -->
                                    <tr>
                                        <td><span class="code-link">PC02</span></td>
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Xăng xe & Đi lại</div>
                                            <div class="text-muted" style="font-size: 0.73rem;">Trợ cấp công tác & di chuyển</div>
                                        </td>
                                        <td class="text-end font-monospace fw-bold">500.000</td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">Cố định tháng</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Miễn thuế (Theo HĐLĐ)</span>
                                        </td>
                                        <td class="text-center font-monospace fw-bold">180</td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Đang áp dụng</span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-light border-0" title="Sửa"><i class="bi bi-pencil"></i></button>
                                                <button class="btn btn-sm btn-light border-0" title="Tạm dừng"><i class="bi bi-pause-circle"></i></button>
                                                <button class="btn btn-sm btn-light border-0 text-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- PC03 -->
                                    <tr>
                                        <td><span class="code-link">PC03</span></td>
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Điện thoại viễn thông</div>
                                            <div class="text-muted" style="font-size: 0.73rem;">Gói cước sim liên lạc nội bộ</div>
                                        </td>
                                        <td class="text-end font-monospace fw-bold">300.000</td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">Cố định tháng</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Miễn thuế (Theo mức khoán)</span>
                                        </td>
                                        <td class="text-center font-monospace fw-bold">94</td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Đang áp dụng</span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-light border-0" title="Sửa"><i class="bi bi-pencil"></i></button>
                                                <button class="btn btn-sm btn-light border-0" title="Tạm dừng"><i class="bi bi-pause-circle"></i></button>
                                                <button class="btn btn-sm btn-light border-0 text-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- PC04 -->
                                    <tr>
                                        <td><span class="code-link">PC04</span></td>
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Trách nhiệm quản lý</div>
                                            <div class="text-muted" style="font-size: 0.73rem;">Cấp Trưởng nhóm trở lên</div>
                                        </td>
                                        <td class="text-end font-monospace fw-bold">2.500.000</td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">Cố định tháng</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-secondary-subtle text-secondary border-0">Chịu thuế TNCN</span>
                                        </td>
                                        <td class="text-center font-monospace fw-bold">32</td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Đang áp dụng</span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-light border-0" title="Sửa"><i class="bi bi-pencil"></i></button>
                                                <button class="btn btn-sm btn-light border-0" title="Tạm dừng"><i class="bi bi-pause-circle"></i></button>
                                                <button class="btn btn-sm btn-light border-0 text-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- PC05 -->
                                    <tr>
                                        <td><span class="code-link">PC05</span></td>
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Dự án kiêm nhiệm</div>
                                            <div class="text-muted" style="font-size: 0.73rem;">Phụ cấp tiến độ & trọng điểm</div>
                                        </td>
                                        <td class="text-end font-monospace fw-bold">1.800.000</td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">Theo dự án</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-secondary-subtle text-secondary border-0">Chịu thuế TNCN</span>
                                        </td>
                                        <td class="text-center font-monospace fw-bold">19</td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Đang áp dụng</span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-light border-0" title="Sửa"><i class="bi bi-pencil"></i></button>
                                                <button class="btn btn-sm btn-light border-0" title="Tạm dừng"><i class="bi bi-pause-circle"></i></button>
                                                <button class="btn btn-sm btn-light border-0 text-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- PC06 -->
                                    <tr>
                                        <td><span class="code-link">PC06</span></td>
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Thâm niên công tác</div>
                                            <div class="text-muted" style="font-size: 0.73rem;">Từ 3 năm cống hiến trở lên</div>
                                        </td>
                                        <td class="text-end font-monospace fw-bold">1.000.000</td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">Cố định tháng</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-secondary-subtle text-secondary border-0">Chịu thuế TNCN</span>
                                        </td>
                                        <td class="text-center font-monospace fw-bold">62</td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Đang áp dụng</span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-light border-0" title="Sửa"><i class="bi bi-pencil"></i></button>
                                                <button class="btn btn-sm btn-light border-0" title="Tạm dừng"><i class="bi bi-pause-circle"></i></button>
                                                <button class="btn btn-sm btn-light border-0 text-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- PC07 -->
                                    <tr>
                                        <td><span class="code-link">PC07</span></td>
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Nuôi con nhỏ (&lt; 1 tuổi)</div>
                                            <div class="text-muted" style="font-size: 0.73rem;">Hỗ trợ chăm sóc thai sản/con nhỏ</div>
                                        </td>
                                        <td class="text-end font-monospace fw-bold">500.000</td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">Cố định tháng</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Miễn thuế (Phúc lợi)</span>
                                        </td>
                                        <td class="text-center font-monospace fw-bold">15</td>
                                        <td class="text-center">
                                            <span class="badge bg-primary-subtle text-primary border-0">Đang áp dụng</span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-light border-0" title="Sửa"><i class="bi bi-pencil"></i></button>
                                                <button class="btn btn-sm btn-light border-0" title="Tạm dừng"><i class="bi bi-pause-circle"></i></button>
                                                <button class="btn btn-sm btn-light border-0 text-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination Footer -->
                        <div class="p-3 border-top d-flex justify-content-between align-items-center" style="font-size:0.82rem;">
                            <span class="text-muted">
                                Hiển thị <strong>1 - 7</strong> trong tổng số 12 loại phụ cấp
                            </span>
                            <nav aria-label="Page navigation">
                                <ul class="pagination pagination-sm mb-0">
                                    <li class="page-item disabled"><a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a></li>
                                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a></li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>

                <!-- Right: Top 5 Departments & Legal Notes (4 Cols) -->
                <div class="col-lg-4">
                    <div class="d-flex flex-column gap-3">
                        <!-- Card 1: Top 5 phòng ban -->
                        <div class="app-card">
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">
                                        <i class="bi bi-bar-chart-fill text-primary me-1"></i>
                                        Top 5 phòng ban
                                    </div>
                                    <p class="app-card-subtitle">Các bộ phận có tỷ trọng chi trả phụ cấp cao nhất kỳ này.</p>
                                </div>
                                <span class="badge bg-light text-dark border">Tháng 9</span>
                            </div>

                            <div class="allowance-dept-rank-list my-2">
                                <!-- Rank 1 -->
                                <div class="allowance-dept-rank-item">
                                    <div class="allowance-dept-rank-header">
                                        <span class="allowance-dept-rank-name">1. Khối Kinh doanh & Bán hàng</span>
                                        <span class="allowance-dept-rank-amount">28.400.000 đ</span>
                                    </div>
                                    <div class="progress" style="height: 5px;">
                                        <div class="progress-bar bg-primary" style="width: 33.3%;"></div>
                                    </div>
                                    <div class="allowance-dept-rank-meta">
                                        <span>65 nhân viên</span>
                                        <span>33.3% ngân sách</span>
                                    </div>
                                </div>

                                <!-- Rank 2 -->
                                <div class="allowance-dept-rank-item">
                                    <div class="allowance-dept-rank-header">
                                        <span class="allowance-dept-rank-name">2. Kỹ thuật & R&D</span>
                                        <span class="allowance-dept-rank-amount">22.800.000 đ</span>
                                    </div>
                                    <div class="progress" style="height: 5px;">
                                        <div class="progress-bar bg-primary" style="width: 26.7%;"></div>
                                    </div>
                                    <div class="allowance-dept-rank-meta">
                                        <span>52 nhân viên</span>
                                        <span>26.7% ngân sách</span>
                                    </div>
                                </div>

                                <!-- Rank 3 -->
                                <div class="allowance-dept-rank-item">
                                    <div class="allowance-dept-rank-header">
                                        <span class="allowance-dept-rank-name">3. Vận hành & Khách hàng</span>
                                        <span class="allowance-dept-rank-amount">14.150.000 đ</span>
                                    </div>
                                    <div class="progress" style="height: 5px;">
                                        <div class="progress-bar bg-info" style="width: 16.6%;"></div>
                                    </div>
                                    <div class="allowance-dept-rank-meta">
                                        <span>48 nhân viên</span>
                                        <span>16.6% ngân sách</span>
                                    </div>
                                </div>

                                <!-- Rank 4 -->
                                <div class="allowance-dept-rank-item">
                                    <div class="allowance-dept-rank-header">
                                        <span class="allowance-dept-rank-name">4. Marketing & Truyền thông</span>
                                        <span class="allowance-dept-rank-amount">10.600.000 đ</span>
                                    </div>
                                    <div class="progress" style="height: 5px;">
                                        <div class="progress-bar bg-info" style="width: 12.4%;"></div>
                                    </div>
                                    <div class="allowance-dept-rank-meta">
                                        <span>24 nhân viên</span>
                                        <span>12.4% ngân sách</span>
                                    </div>
                                </div>

                                <!-- Rank 5 -->
                                <div class="allowance-dept-rank-item">
                                    <div class="allowance-dept-rank-header">
                                        <span class="allowance-dept-rank-name">5. Nhân sự & Tài chính</span>
                                        <span class="allowance-dept-rank-amount">9.250.000 đ</span>
                                    </div>
                                    <div class="progress" style="height: 5px;">
                                        <div class="progress-bar bg-secondary" style="width: 10.8%;"></div>
                                    </div>
                                    <div class="allowance-dept-rank-meta">
                                        <span>20 nhân viên</span>
                                        <span>10.8% ngân sách</span>
                                    </div>
                                </div>
                            </div>

                            <div class="p-2 mt-3 rounded bg-light d-flex align-items-start gap-2 border" style="font-size: 0.75rem;">
                                <i class="bi bi-info-circle text-primary mt-1"></i>
                                <span class="text-muted">
                                    Khối Kinh doanh có phụ cấp xăng xe & lưu động tăng 12% do đợt phát triển thị trường phía Nam.
                                </span>
                            </div>
                        </div>

                        <!-- Card 2: Lưu ý Pháp lý Thuế -->
                        <div class="app-card">
                            <div class="app-card-title mb-2">
                                <i class="bi bi-shield-exclamation text-primary me-1"></i>
                                Lưu ý Pháp lý Thuế
                            </div>
                            <p class="text-muted" style="font-size: 0.8rem; line-height: 1.5;">
                                Theo quy định Thông tư 111/2013/TT-BTC, mức tiền ăn trưa không chịu thuế tối đa là <strong>730.000 đ/tháng/người</strong>. Khoản phụ cấp điện thoại, trang phục bằng tiền mặt miễn thuế tối đa <strong>5.000.000 đ/năm/người</strong>.
                            </p>
                            <div class="pt-2 border-top">
                                <a href="#" class="text-primary fw-bold text-decoration-none d-flex align-items-center gap-1" style="font-size: 0.8rem;">
                                    Xem cẩm nang thuế lương <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
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
