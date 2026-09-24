<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Quản lý Kỷ luật & Xử lý vi phạm - MIXIMOI HRM" />
    </jsp:include>
</head>
<body class="hrm-app-body">
<div class="app-layout">
    <!-- Sidebar Navigation -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <div class="app-main">
        <!-- Topbar Header -->
        <jsp:include page="/WEB-INF/views/common/topbar.jsp" />

        <!-- Main Content Area -->
        <main class="app-content p-3 p-lg-4">
            <!-- Toast notification if action done -->
            <c:if test="${param.success eq 'report_created'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div>Đã lập biên bản vi phạm mới thành công và phân công chuyên viên thụ lý!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <h1 class="h3 fw-bold text-dark mb-1">Quản lý kỷ luật & Xử lý vi phạm</h1>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Theo dõi, giải quyết các vụ việc vi phạm nội quy, quy chế lao động và ban hành quyết định kỷ luật nhân sự bảo đảm tính chuẩn tắc, khách quan theo Bộ luật Lao động.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="window.print()">
                        <i class="bi bi-printer"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#guidelineModal">
                        <i class="bi bi-journal-text"></i>
                        <span>Quy chế & Biểu mẫu</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createViolationModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>Tạo biên bản vi phạm</span>
                    </button>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Vụ việc trong năm</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-hammer"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">12</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Toàn bộ vụ việc 2026</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold" style="font-size: 0.73rem;">+2 vụ quý này</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang xử lý</span>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-arrow-repeat"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-primary fw-bold" style="font-size: 1.85rem;">3</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">2 xác minh, 1 điều tra</span>
                            <span class="badge bg-info-subtle text-info fw-semibold" style="font-size: 0.73rem;">Đang tiến hành</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Chờ quyết định</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-clipboard2-check"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-purple fw-bold" style="font-size: 1.85rem; color: #7c3aed;">2</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Cần hội đồng họp phê duyệt</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold" style="font-size: 0.73rem;">Ưu tiên xử lý</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã giải quyết</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-check-circle-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">7</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Đã ban hành quyết định</span>
                            <span class="badge bg-success-subtle text-success fw-semibold" style="font-size: 0.73rem;">75% tỷ lệ hoàn tất</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Standard Discipline 5-Step Stepper -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-header bg-white border-bottom py-3 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-diagram-3-fill text-primary"></i>
                        <span class="fw-bold text-dark">Quy trình xử lý kỷ luật tiêu chuẩn</span>
                    </div>
                    <span class="badge bg-light text-dark border d-inline-flex align-items-center gap-1">
                        <i class="bi bi-shield-check text-primary"></i>
                        Tuân thủ SLA tối đa 15 ngày làm việc (Nghị định 145/2020/NĐ-CP)
                    </span>
                </div>
                <div class="card-body p-3">
                    <div class="discipline-stepper-container">
                        <!-- Step 1 -->
                        <div class="discipline-step-card completed">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-primary">BƯỚC 01</span>
                                <i class="bi bi-check-circle-fill text-primary"></i>
                            </div>
                            <div class="discipline-step-title">Tạo biên bản</div>
                            <div class="discipline-step-desc">Lập hồ sơ & ghi nhận tang chứng</div>
                        </div>

                        <!-- Step 2 -->
                        <div class="discipline-step-card active">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-primary">BƯỚC 02</span>
                                <span class="badge-dot-indicator bg-primary"></span>
                            </div>
                            <div class="discipline-step-title text-primary">Xác minh vi phạm</div>
                            <div class="discipline-step-desc">Giải trình & thu thập đối chiếu</div>
                        </div>

                        <!-- Step 3 -->
                        <div class="discipline-step-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-muted">BƯỚC 03</span>
                                <i class="bi bi-clock text-muted"></i>
                            </div>
                            <div class="discipline-step-title">Họp hội đồng</div>
                            <div class="discipline-step-desc">Họp xem xét hình thức kỷ luật</div>
                        </div>

                        <!-- Step 4 -->
                        <div class="discipline-step-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-muted">BƯỚC 04</span>
                                <i class="bi bi-file-earmark-text text-muted"></i>
                            </div>
                            <div class="discipline-step-title">Ra quyết định</div>
                            <div class="discipline-step-desc">Ký duyệt & tống đạt văn bản</div>
                        </div>

                        <!-- Step 5 -->
                        <div class="discipline-step-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-muted">BƯỚC 05</span>
                                <i class="bi bi-archive text-muted"></i>
                            </div>
                            <div class="discipline-step-title">Đóng vụ việc</div>
                            <div class="discipline-step-desc">Lưu hồ sơ & trích trừ bảng lương</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <form method="get" action="${pageContext.request.contextPath}/disciplines" class="row g-2 align-items-center">
                        <div class="col-12 col-md-4">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" name="keyword" class="form-control border-start-0" placeholder="Tìm kiếm theo mã vụ việc, họ tên nhân viên..." value="${param.keyword}">
                            </div>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="dept" class="form-select form-select-sm">
                                <option value="">Tất cả phòng ban</option>
                                <option value="IT" ${param.dept eq 'IT' ? 'selected' : ''}>CNTT & R&D</option>
                                <option value="Sales" ${param.dept eq 'Sales' ? 'selected' : ''}>Kinh doanh</option>
                                <option value="Ops" ${param.dept eq 'Ops' ? 'selected' : ''}>Vận hành</option>
                                <option value="Mkt" ${param.dept eq 'Mkt' ? 'selected' : ''}>Marketing</option>
                                <option value="Fin" ${param.dept eq 'Fin' ? 'selected' : ''}>Tài chính</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="severity" class="form-select form-select-sm">
                                <option value="">Mức độ: Tất cả</option>
                                <option value="high" ${param.severity eq 'high' ? 'selected' : ''}>Nghiêm trọng</option>
                                <option value="medium" ${param.severity eq 'medium' ? 'selected' : ''}>Trung bình</option>
                                <option value="low" ${param.severity eq 'low' ? 'selected' : ''}>Nhẹ</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="status" class="form-select form-select-sm">
                                <option value="">Trạng thái: Tất cả</option>
                                <option value="pending" ${param.status eq 'pending' ? 'selected' : ''}>Chờ quyết định</option>
                                <option value="investigating" ${param.status eq 'investigating' ? 'selected' : ''}>Đang xác minh</option>
                                <option value="resolved" ${param.status eq 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                                <option value="closed" ${param.status eq 'closed' ? 'selected' : ''}>Đã đóng</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-sm btn-primary w-100">Áp dụng</button>
                            <a href="${pageContext.request.contextPath}/disciplines" class="btn btn-sm btn-outline-secondary">Đặt lại</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Violations Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center gap-2">
                        <h2 class="h6 fw-bold mb-0 text-dark">Danh sách hồ sơ vi phạm</h2>
                        <span class="badge bg-light text-primary border">12 hồ sơ</span>
                    </div>
                    <span class="text-muted small">Kỳ cập nhật: <strong>Tháng 09/2026</strong></span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3" style="width: 40px;"><input class="form-check-input" type="checkbox"></th>
                                <th style="width: 120px;">Mã vụ việc</th>
                                <th>Nhân viên</th>
                                <th>Phòng ban</th>
                                <th>Ngày vi phạm</th>
                                <th>Hành vi vi phạm</th>
                                <th class="text-center">Mức độ</th>
                                <th>Hình thức đề xuất / Quyết định</th>
                                <th>Người thụ lý</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Row 1: KL-2026-008 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-primary">KL-2026-008</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-danger-subtle text-danger fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">VM</div>
                                        <div>
                                            <div class="fw-bold text-dark">Vũ Đức Minh</div>
                                            <small class="text-muted">NV-8841</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                <td>22/09/2026</td>
                                <td class="text-truncate" style="max-width: 170px;" title="Tiết lộ tài liệu mã nguồn nội bộ ra bên ngoài">Tiết lộ mã nguồn nội bộ...</td>
                                <td class="text-center">
                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Nghiêm trọng</span>
                                </td>
                                <td class="fw-semibold text-danger">Đình chỉ công tác & họp kỷ luật</td>
                                <td>
                                    <div class="d-flex align-items-center gap-1">
                                        <i class="bi bi-person-badge text-muted"></i>
                                        <span>Lê Minh Hoàng</span>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-purple-subtle text-purple border border-purple-subtle" style="background: #f3e8ff; color: #7e22ce;">
                                        Chờ quyết định
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2" title="Xem hồ sơ"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2" title="Biên bản họp"><i class="bi bi-journal-text"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2" title="Khác"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 2: KL-2026-007 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-primary">KL-2026-007</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-info-subtle text-info fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">TB</div>
                                        <div>
                                            <div class="fw-bold text-dark">Trần Thị Bình</div>
                                            <small class="text-muted">NV-6419</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Kinh doanh</span></td>
                                <td>18/09/2026</td>
                                <td class="text-truncate" style="max-width: 170px;" title="Đi làm muộn 5 lần liên tiếp trong tuần">Đi làm muộn 5 lần liên tiếp...</td>
                                <td class="text-center">
                                    <span class="badge bg-info-subtle text-info border border-info-subtle">Nhẹ</span>
                                </td>
                                <td>Khiển trách bằng văn bản</td>
                                <td>
                                    <div class="d-flex align-items-center gap-1">
                                        <i class="bi bi-person-badge text-muted"></i>
                                        <span>Đỗ Quốc Việt</span>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                        Đang xác minh
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-journal-text"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 3: KL-2026-006 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-primary">KL-2026-006</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-warning-subtle text-warning fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">HL</div>
                                        <div>
                                            <div class="fw-bold text-dark">Nguyễn Hoàng Long</div>
                                            <small class="text-muted">NV-5312</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Kinh doanh</span></td>
                                <td>10/09/2026</td>
                                <td class="text-truncate" style="max-width: 170px;" title="Sai lệch số liệu báo cáo doanh số">Sai lệch báo cáo quý...</td>
                                <td class="text-center">
                                    <span class="badge bg-purple-subtle text-purple border border-purple-subtle" style="background: #f3e8ff; color: #7e22ce;">Trung bình</span>
                                </td>
                                <td>Kéo dài thời hạn nâng lương 3 tháng</td>
                                <td>
                                    <div class="d-flex align-items-center gap-1">
                                        <i class="bi bi-person-badge text-muted"></i>
                                        <span>Phạm Thu Hà</span>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-secondary-subtle text-secondary border">
                                        Đã xử lý
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-journal-text"></i></button>
                                        <button class="btn btn-outline-success py-1 px-2"><i class="bi bi-check2-circle"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 4: KL-2026-005 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-primary">KL-2026-005</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-danger-subtle text-danger fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">VD</div>
                                        <div>
                                            <div class="fw-bold text-dark">Đặng Văn Dũng</div>
                                            <small class="text-muted">NV-3104</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Vận hành</span></td>
                                <td>02/09/2026</td>
                                <td class="text-truncate" style="max-width: 170px;" title="Tự ý bỏ việc 5 ngày làm việc cộng dồn trong thời hạn 30 ngày">Tự ý nghỉ việc 5 ngày...</td>
                                <td class="text-center">
                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Nghiêm trọng</span>
                                </td>
                                <td class="fw-bold text-danger">Sa thải theo Điều 125 BLLĐ</td>
                                <td>
                                    <div class="d-flex align-items-center gap-1">
                                        <i class="bi bi-person-badge text-muted"></i>
                                        <span>Lê Minh Hoàng</span>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-secondary-subtle text-secondary border">
                                        Đã xử lý
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-journal-text"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 5: KL-2026-004 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-primary">KL-2026-004</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">AT</div>
                                        <div>
                                            <div class="fw-bold text-dark">Hoàng Anh Tuấn</div>
                                            <small class="text-muted">NV-9102</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Marketing</span></td>
                                <td>28/08/2026</td>
                                <td class="text-truncate" style="max-width: 170px;">Không tuân thủ quy chuẩn...</td>
                                <td class="text-center">
                                    <span class="badge bg-info-subtle text-info border border-info-subtle">Nhẹ</span>
                                </td>
                                <td>Nhắc nhở & cam kết tuân thủ</td>
                                <td>
                                    <div class="d-flex align-items-center gap-1">
                                        <i class="bi bi-person-badge text-muted"></i>
                                        <span>Đỗ Quốc Việt</span>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-light text-muted border">
                                        Đã đóng
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-archive"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- Row 6: KL-2026-003 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-primary">KL-2026-003</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">ML</div>
                                        <div>
                                            <div class="fw-bold text-dark">Bùi Mai Linh</div>
                                            <small class="text-muted">NV-2207</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark border">Tài chính</span></td>
                                <td>15/08/2026</td>
                                <td class="text-truncate" style="max-width: 170px;">Chậm nộp tờ khai chi phí...</td>
                                <td class="text-center">
                                    <span class="badge bg-purple-subtle text-purple border border-purple-subtle" style="background: #f3e8ff; color: #7e22ce;">Trung bình</span>
                                </td>
                                <td>Khiển trách bằng văn bản</td>
                                <td>
                                    <div class="d-flex align-items-center gap-1">
                                        <i class="bi bi-person-badge text-muted"></i>
                                        <span>Phạm Thu Hà</span>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-light text-muted border">
                                        Đã đóng
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-archive"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white border-top py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                    <span class="text-muted small">Hiển thị <strong>1 - 6</strong> trong tổng số <strong>12</strong> vụ việc kỷ luật</span>
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

<!-- Modal Tạo biên bản vi phạm -->
<div class="modal fade" id="createViolationModal" tabindex="-1" aria-labelledby="createViolationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="createViolationModalLabel">Lập biên bản vi phạm nội quy lao động</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/disciplines">
                <input type="hidden" name="action" value="create_report">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Nhân viên vi phạm</label>
                        <select class="form-select" name="employeeId" required>
                            <option value="">-- Chọn nhân sự --</option>
                            <option value="1">Vũ Đức Minh (NV-8841) - CNTT & R&D</option>
                            <option value="2">Trần Thị Bình (NV-6419) - Kinh doanh</option>
                            <option value="3">Nguyễn Hoàng Long (NV-5312) - Kinh doanh</option>
                            <option value="4">Đặng Văn Dũng (NV-3104) - Vận hành</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Thời điểm xảy ra vi phạm</label>
                        <input type="date" class="form-control" name="violationDate" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mức độ vi phạm nhận định sơ bộ</label>
                        <select class="form-select" name="severity" required>
                            <option value="low">Nhẹ (Nhắc nhở, phê bình nội bộ)</option>
                            <option value="medium">Trung bình (Khiển trách văn bản, kéo dài nâng lương)</option>
                            <option value="high">Nghiêm trọng (Cách chức, Sa thải theo Điều 125 BLLĐ)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mô tả hành vi & Tang chứng</label>
                        <textarea class="form-control" name="description" rows="3" placeholder="Ghi nhận rõ hành vi, thời gian, địa điểm và người làm chứng..." required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Chuyên viên thụ lý giải quyết</label>
                        <input type="text" class="form-control" name="handler" value="Lê Minh Hoàng (HR Compliance Lead)" readonly>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Xác nhận tạo biên bản</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
