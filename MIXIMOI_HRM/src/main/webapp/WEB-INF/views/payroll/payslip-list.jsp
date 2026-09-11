<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Danh sách Phiếu Lương Nhân Viên - MIXIMOI HRM" />
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
            <c:if test="${param.success eq 'sent_all'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-send-check-fill fs-5 text-success"></i>
                    <div>Đã gửi thành công <strong>245 phiếu lương điện tử</strong> tới hộp thư nội bộ và ứng dụng di động của CBNV!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-inline-flex align-items-center gap-2 px-2 py-1 rounded bg-primary-subtle text-primary fw-bold text-uppercase mb-1" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                        <i class="bi bi-receipt-cutoff"></i> HỆ THỐNG PHIẾU LƯƠNG ĐIỆN TỬ • KỲ LƯƠNG THÁNG 09/2026
                    </div>
                    <h1 class="h3 fw-bold text-dark mb-1">Danh sách Phiếu lương Nhân viên</h1>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý, phát hành và đối soát toàn bộ phiếu lương điện tử A4 được xác thực số SHA-256 cho CBNV.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="alert('Đang nén và tải 245 file PDF phiếu lương ký số...');">
                        <i class="bi bi-file-earmark-zip"></i>
                        <span>Xuất ZIP toàn bộ PDF</span>
                    </button>
                    <form method="post" action="${pageContext.request.contextPath}/payslip">
                        <input type="hidden" name="action" value="send_all">
                        <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" onclick="return confirm('Bạn có chắc chắn muốn phát hành & gửi email phiếu lương đến toàn bộ 245 nhân viên không?');">
                            <i class="bi bi-send-fill"></i>
                            <span>Phát hành & Gửi hàng loạt</span>
                        </button>
                    </form>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Tổng phiếu lương đã tạo</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-file-earmark-text"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.7rem;">245</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">phiếu</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-primary-subtle text-primary fw-semibold" style="font-size: 0.73rem;">
                                100% CBNV
                            </span>
                            <span class="text-muted small">kỳ T09/2026</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã xác thực chữ ký số</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-patch-check-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.7rem;">245 / 245</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-success-subtle text-success fw-semibold" style="font-size: 0.73rem;">
                                3 cấp ký duyệt
                            </span>
                            <span class="text-muted small">Payroll • CFO • CEO</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã gửi tới nhân viên</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-envelope-check"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-purple fw-bold" style="font-size: 1.7rem; color: #7e22ce;">210</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">phiếu</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-purple-subtle text-purple fw-semibold" style="font-size: 0.73rem; background: #f3e8ff; color: #7e22ce;">
                                85.7% hoàn tất
                            </span>
                            <span class="text-muted small">Đợt 1</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Chờ phát hành Đợt 2</span>
                            <div class="kpi-icon-box amber">
                                <i class="bi bi-clock-history"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-warning-emphasis fw-bold" style="font-size: 1.7rem;">35</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">phiếu</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-warning-subtle text-warning-emphasis fw-semibold" style="font-size: 0.73rem;">
                                Sẵn sàng gửi
                            </span>
                            <span class="text-muted small">khối BO & Thử việc</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <form method="get" action="${pageContext.request.contextPath}/payslip" class="row g-2 align-items-center">
                        <div class="col-12 col-md-4">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" name="keyword" class="form-control border-start-0" placeholder="Tìm theo tên NV, mã NV hoặc mã phiếu..." value="${param.keyword}">
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <select name="dept" class="form-select form-select-sm">
                                <option value="">Tất cả phòng ban</option>
                                <option value="IT" ${param.dept eq 'IT' ? 'selected' : ''}>Kỹ thuật & Công nghệ</option>
                                <option value="Finance" ${param.dept eq 'Finance' ? 'selected' : ''}>Tài chính kế toán</option>
                                <option value="Product" ${param.dept eq 'Product' ? 'selected' : ''}>Phát triển sản phẩm</option>
                                <option value="HR" ${param.dept eq 'HR' ? 'selected' : ''}>Nhân sự & Vận hành</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select name="status" class="form-select form-select-sm">
                                <option value="">Tất cả trạng thái gửi</option>
                                <option value="sent" ${param.status eq 'sent' ? 'selected' : ''}>Đã gửi cho CBNV</option>
                                <option value="draft" ${param.status eq 'draft' ? 'selected' : ''}>Chưa gửi (Sẵn sàng)</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-sm btn-primary w-100 d-flex align-items-center justify-content-center gap-1">
                                <i class="bi bi-funnel"></i> Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/payslip" class="btn btn-sm btn-outline-secondary" title="Đặt lại">
                                <i class="bi bi-arrow-counterclockwise"></i>
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Payslip List Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="h6 fw-bold mb-0 text-dark">Bảng tổng hợp phiếu lương nhân viên kỳ Tháng 09/2026</h2>
                        <span class="text-muted small">Click <strong>"Xem chi tiết"</strong> để mở giao diện Phiếu lương điện tử A4 chuẩn ký số</span>
                    </div>
                    <span class="badge bg-light text-dark border">Tổng số: 245 phiếu</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3" style="width: 40px;">
                                    <input class="form-check-input" type="checkbox">
                                </th>
                                <th style="width: 140px;">Mã Phiếu</th>
                                <th>Nhân viên</th>
                                <th>Phòng ban & Vị trí</th>
                                <th class="text-end">Thu nhập Gross</th>
                                <th class="text-end">Tổng khấu trừ</th>
                                <th class="text-end fw-bold text-primary">Thực nhận (Net)</th>
                                <th class="text-center">Trạng thái gửi</th>
                                <th class="text-center pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Item 1: Nguyễn Văn An (The standard reference from mockup 3) -->
                            <tr class="table-primary bg-opacity-10">
                                <td class="ps-3"><input class="form-check-input" type="checkbox" checked></td>
                                <td class="fw-bold font-monospace text-primary">
                                    <i class="bi bi-file-earmark-check text-primary me-1"></i>PL-202609-001
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-primary text-white fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">NA</div>
                                        <div>
                                            <div class="fw-bold text-dark">Nguyễn Văn An</div>
                                            <small class="text-muted">Mã: NV001 • MXM-0102</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">Senior Software Developer</div>
                                    <small class="text-muted">Phòng Kỹ thuật & Công nghệ</small>
                                </td>
                                <td class="text-end fw-semibold text-dark">18.500.000 đ</td>
                                <td class="text-end fw-semibold text-danger">-1.500.000 đ</td>
                                <td class="text-end fw-bold text-primary fs-6">17.000.000 đ</td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                                        <i class="bi bi-check2-all"></i> Đã gửi (Email & App)
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV001" class="btn btn-sm btn-primary d-inline-flex align-items-center gap-1 shadow-sm">
                                        <i class="bi bi-receipt"></i>
                                        <span>Xem chi tiết</span>
                                    </a>
                                </td>
                            </tr>

                            <!-- Item 2: Trần Thị Mai -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-dark">
                                    <i class="bi bi-file-earmark-check text-success me-1"></i>PL-202609-002
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-info-subtle text-info fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">TM</div>
                                        <div>
                                            <div class="fw-bold text-dark">Trần Thị Mai</div>
                                            <small class="text-muted">Mã: NV002 • MXM-0245</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">Kế toán trưởng</div>
                                    <small class="text-muted">Phòng Tài chính Kế toán</small>
                                </td>
                                <td class="text-end fw-semibold text-dark">28.000.000 đ</td>
                                <td class="text-end fw-semibold text-danger">-3.500.000 đ</td>
                                <td class="text-end fw-bold text-primary fs-6">24.500.000 đ</td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                                        <i class="bi bi-check2-all"></i> Đã gửi (Email & App)
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV002" class="btn btn-sm btn-outline-primary d-inline-flex align-items-center gap-1">
                                        <i class="bi bi-receipt"></i>
                                        <span>Xem chi tiết</span>
                                    </a>
                                </td>
                            </tr>

                            <!-- Item 3: Lê Hoàng Nam -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-dark">
                                    <i class="bi bi-file-earmark-check text-success me-1"></i>PL-202609-003
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-warning-subtle text-warning fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">HN</div>
                                        <div>
                                            <div class="fw-bold text-dark">Lê Hoàng Nam</div>
                                            <small class="text-muted">Mã: NV003 • MXM-0311</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">Product Manager</div>
                                    <small class="text-muted">Phòng Phát triển sản phẩm</small>
                                </td>
                                <td class="text-end fw-semibold text-dark">24.600.000 đ</td>
                                <td class="text-end fw-semibold text-danger">-2.800.000 đ</td>
                                <td class="text-end fw-bold text-primary fs-6">21.800.000 đ</td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                                        <i class="bi bi-check2-all"></i> Đã gửi (Email & App)
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV003" class="btn btn-sm btn-outline-primary d-inline-flex align-items-center gap-1">
                                        <i class="bi bi-receipt"></i>
                                        <span>Xem chi tiết</span>
                                    </a>
                                </td>
                            </tr>

                            <!-- Item 4: Phạm Thu Trang -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-dark">
                                    <i class="bi bi-file-earmark-check text-success me-1"></i>PL-202609-004
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-success-subtle text-success fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">PT</div>
                                        <div>
                                            <div class="fw-bold text-dark">Phạm Thu Trang</div>
                                            <small class="text-muted">Mã: NV004 • MXM-0089</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">Chuyên viên Nhân sự</div>
                                    <small class="text-muted">Phòng Nhân sự & Vận hành</small>
                                </td>
                                <td class="text-end fw-semibold text-dark">16.000.000 đ</td>
                                <td class="text-end fw-semibold text-danger">-1.800.000 đ</td>
                                <td class="text-end fw-bold text-primary fs-6">14.200.000 đ</td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                                        <i class="bi bi-check2-all"></i> Đã gửi (Email & App)
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV004" class="btn btn-sm btn-outline-primary d-inline-flex align-items-center gap-1">
                                        <i class="bi bi-receipt"></i>
                                        <span>Xem chi tiết</span>
                                    </a>
                                </td>
                            </tr>

                            <!-- Item 5: Vũ Đình Long (Đợt 2 - Pending) -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td class="fw-bold font-monospace text-dark">
                                    <i class="bi bi-file-earmark-text text-warning me-1"></i>PL-202609-005
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">VL</div>
                                        <div>
                                            <div class="fw-bold text-dark">Vũ Đình Long</div>
                                            <small class="text-muted">Mã: NV005 • MXM-0412</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">QA Lead</div>
                                    <small class="text-muted">Phòng Kỹ thuật & Công nghệ</small>
                                </td>
                                <td class="text-end fw-semibold text-dark">21.000.000 đ</td>
                                <td class="text-end fw-semibold text-danger">-2.400.000 đ</td>
                                <td class="text-end fw-bold text-primary fs-6">18.600.000 đ</td>
                                <td class="text-center">
                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">
                                        <i class="bi bi-hourglass-split"></i> Chờ phát hành (Đợt 2)
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV005" class="btn btn-sm btn-outline-primary d-inline-flex align-items-center gap-1">
                                        <i class="bi bi-receipt"></i>
                                        <span>Xem chi tiết</span>
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white border-top py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                    <span class="text-muted small">Hiển thị 1 đến 5 trên 245 phiếu lương</span>
                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled"><a class="page-link" href="#">« Trước</a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item"><a class="page-link" href="#">Tiếp »</a></li>
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
