<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Thanh toán & Lệnh chi Lương - MIXIMOI HRM" />
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
            <c:if test="${param.success eq 'batch_disbursed'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-shield-lock-fill fs-5 text-success"></i>
                    <div>Đã ký số HSM thành công và chuyển <strong>245 lệnh</strong> sang cổng Napas Corporate Banking!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'unc_exported'}">
                <div class="alert alert-info alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-file-earmark-check fs-5"></i>
                    <div>Đã tạo và tải xuống gói Ủy Nhiệm Chi (UNC) định dạng Vietcombank / Techcombank XML.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-inline-flex align-items-center gap-2 px-2 py-1 rounded bg-primary-subtle text-primary fw-bold text-uppercase mb-1" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                        <i class="bi bi-bank"></i> HỆ THỐNG QUẢN LÝ TÀI CHÍNH & CHUYỂN LƯƠNG TỰ ĐỘNG
                    </div>
                    <h1 class="h3 fw-bold text-dark mb-1">Quản lý Thanh toán & Lệnh chi lương</h1>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Kiểm tra đối soát tài khoản, lập lệnh chi tự động qua cổng ngân hàng H2H (Host-to-Host) & Napas 24/7.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="alert('Đang tải danh sách 1,240 lịch sử giao dịch thanh toán...')">
                        <i class="bi bi-clock-history"></i>
                        <span>Lịch sử giao dịch</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#createDisbursementModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>+ Tạo lệnh chi mới</span>
                    </button>
                </div>
            </div>

            <!-- Corporate Banking H2H API Gateway Bar -->
            <div class="banking-h2h-panel mb-4">
                <div class="row align-items-center g-3">
                    <div class="col-12 col-lg-7">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="badge bg-primary-subtle text-primary fw-bold">GATEWAY H2H</span>
                            <span class="fw-bold text-dark" style="font-size: 0.95rem;">Cổng kết nối thanh toán Doanh nghiệp trực tiếp</span>
                        </div>
                        <div class="d-flex flex-wrap gap-2">
                            <div class="h2h-bank-pill">
                                <span class="h2h-live-indicator"></span>
                                <span class="text-dark">Techcombank Corporate API</span>
                                <span class="text-muted small border-start ps-2">18ms • Khả dụng</span>
                            </div>
                            <div class="h2h-bank-pill">
                                <span class="h2h-live-indicator"></span>
                                <span class="text-dark">Vietcombank iB@nk H2H</span>
                                <span class="text-muted small border-start ps-2">24ms • Khả dụng</span>
                            </div>
                            <div class="h2h-bank-pill">
                                <i class="bi bi-shield-check text-success"></i>
                                <span class="text-dark">Ký số HSM Viettel-CA</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-lg-5">
                        <div class="d-flex justify-content-between align-items-baseline mb-1" style="font-size: 0.78rem;">
                            <span class="text-muted">Hạn mức chi online trong ngày:</span>
                            <span class="fw-bold text-dark">813.000.000 / 2.000.000.000 đ (40.6%)</span>
                        </div>
                        <div class="progress" style="height: 7px;">
                            <div class="progress-bar bg-primary" role="progressbar" style="width: 40.6%" aria-valuenow="40.6" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Tổng chi lương T09</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-wallet2"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.7rem;">813.000.000</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">đ</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-primary-subtle text-primary fw-semibold" style="font-size: 0.73rem;">
                                245 tài khoản
                            </span>
                            <span class="text-muted small">toàn công ty</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã thanh toán (Thành công)</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-check-circle-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.7rem;">765.000.000</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">đ</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-success-subtle text-success fw-semibold" style="font-size: 0.73rem;">
                                94.1% • 210 lệnh
                            </span>
                            <span class="text-muted small">đã quyết toán</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang xử lý / Chờ chuyển</span>
                            <div class="kpi-icon-box amber">
                                <i class="bi bi-hourglass-split"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-warning-emphasis fw-bold" style="font-size: 1.7rem;">48.000.000</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">đ</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-warning-subtle text-warning-emphasis fw-semibold" style="font-size: 0.73rem;">
                                Đợt 2 • 35 CBNV
                            </span>
                            <span class="text-muted small">chờ ký duyệt</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Lỗi / Sai thông tin TK</span>
                            <div class="kpi-icon-box coral">
                                <i class="bi bi-exclamation-octagon"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.7rem;">0</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">đ</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-success-subtle text-success fw-semibold" style="font-size: 0.73rem;">
                                0 lệnh lỗi
                            </span>
                            <span class="text-muted small">chuẩn hóa Napas 100%</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tab Filter & Search -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-header bg-white border-bottom pb-0 pt-2">
                    <ul class="nav payment-batch-tabs">
                        <li class="nav-item">
                            <a class="nav-link active" href="#">Tất cả lệnh chi (245)</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Đợt 1 - Khối Kỹ thuật & KD (210)</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Đợt 2 - Khối Backoffice & Thử việc (35)</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-12 col-md-4">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" placeholder="Tìm theo mã lệnh, tên nhân viên, STK...">
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select form-select-sm">
                                <option value="">Tất cả ngân hàng</option>
                                <option value="TCB">Techcombank (120)</option>
                                <option value="VCB">Vietcombank (85)</option>
                                <option value="MB">MBBank (25)</option>
                                <option value="ACB">ACB (15)</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select class="form-select form-select-sm">
                                <option value="">Tất cả trạng thái</option>
                                <option value="PAID">Đã chuyển thành công</option>
                                <option value="PROCESSING">Đang xử lý</option>
                                <option value="PENDING">Chờ ký duyệt HSM</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-2">
                            <button class="btn btn-sm btn-primary w-100">
                                <i class="bi bi-funnel"></i> Lọc dữ liệu
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Transaction Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-5 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="h6 fw-bold mb-0 text-dark">Danh sách lệnh chi lương tự động qua Napas / Corporate API</h2>
                        <span class="text-muted small">Cập nhật thời gian thực từ cổng ngân hàng</span>
                    </div>
                    <span class="badge bg-light text-dark border">Trang 1/5 • Hiển thị 5 bản ghi tiêu biểu</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3" style="width: 40px;">
                                    <input class="form-check-input" type="checkbox" checked id="checkAll">
                                </th>
                                <th style="width: 130px;">Mã Lệnh</th>
                                <th>Người nhận & Tài khoản</th>
                                <th class="text-end">Số tiền thực nhận</th>
                                <th>Nội dung chuyển khoản</th>
                                <th>Thời gian & Mã FT</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- TX 1 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input tx-check" type="checkbox" checked></td>
                                <td class="fw-bold text-primary font-monospace">TX-202609-001</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-primary-subtle text-primary fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">NA</div>
                                        <div>
                                            <div class="fw-bold text-dark">Nguyễn Văn An</div>
                                            <small class="text-muted"><span class="badge bg-light text-dark border">TCB</span> 1903 4567 89012</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end fw-bold text-dark fs-6">17.000.000 đ</td>
                                <td class="text-muted font-monospace small">MIXIMOI chi luong T09-2026 NV001</td>
                                <td>
                                    <div>10/09 09:15:22</div>
                                    <small class="text-muted font-monospace">FT262539102948</small>
                                </td>
                                <td class="text-center">
                                    <span class="tx-status-badge tx-status-success">
                                        <i class="bi bi-check-circle-fill"></i> Thành công
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV001" class="btn btn-sm btn-outline-secondary py-1 px-2" title="Xem phiếu lương">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </td>
                            </tr>

                            <!-- TX 2 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input tx-check" type="checkbox" checked></td>
                                <td class="fw-bold text-primary font-monospace">TX-202609-002</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-info-subtle text-info fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">TM</div>
                                        <div>
                                            <div class="fw-bold text-dark">Trần Thị Mai</div>
                                            <small class="text-muted"><span class="badge bg-light text-dark border">VCB</span> 0071 0008 92831</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end fw-bold text-dark fs-6">24.500.000 đ</td>
                                <td class="text-muted font-monospace small">MIXIMOI chi luong T09-2026 NV002</td>
                                <td>
                                    <div>10/09 09:15:24</div>
                                    <small class="text-muted font-monospace">FT262539102950</small>
                                </td>
                                <td class="text-center">
                                    <span class="tx-status-badge tx-status-success">
                                        <i class="bi bi-check-circle-fill"></i> Thành công
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV002" class="btn btn-sm btn-outline-secondary py-1 px-2" title="Xem phiếu lương">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </td>
                            </tr>

                            <!-- TX 3 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input tx-check" type="checkbox" checked></td>
                                <td class="fw-bold text-primary font-monospace">TX-202609-003</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-warning-subtle text-warning fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">HN</div>
                                        <div>
                                            <div class="fw-bold text-dark">Lê Hoàng Nam</div>
                                            <small class="text-muted"><span class="badge bg-light text-dark border">TCB</span> 1902 8847 11099</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end fw-bold text-dark fs-6">21.800.000 đ</td>
                                <td class="text-muted font-monospace small">MIXIMOI chi luong T09-2026 NV003</td>
                                <td>
                                    <div>10/09 09:15:26</div>
                                    <small class="text-muted font-monospace">FT262539102955</small>
                                </td>
                                <td class="text-center">
                                    <span class="tx-status-badge tx-status-success">
                                        <i class="bi bi-check-circle-fill"></i> Thành công
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV003" class="btn btn-sm btn-outline-secondary py-1 px-2" title="Xem phiếu lương">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </td>
                            </tr>

                            <!-- TX 4 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input tx-check" type="checkbox" checked></td>
                                <td class="fw-bold text-primary font-monospace">TX-202609-004</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-success-subtle text-success fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">PT</div>
                                        <div>
                                            <div class="fw-bold text-dark">Phạm Thu Trang</div>
                                            <small class="text-muted"><span class="badge bg-light text-dark border">MB</span> 0881 2948 10022</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end fw-bold text-dark fs-6">14.200.000 đ</td>
                                <td class="text-muted font-monospace small">MIXIMOI chi luong T09-2026 NV004</td>
                                <td>
                                    <div>10/09 09:15:28</div>
                                    <small class="text-muted font-monospace">FT262539102960</small>
                                </td>
                                <td class="text-center">
                                    <span class="tx-status-badge tx-status-success">
                                        <i class="bi bi-check-circle-fill"></i> Thành công
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV004" class="btn btn-sm btn-outline-secondary py-1 px-2" title="Xem phiếu lương">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </td>
                            </tr>

                            <!-- TX 5 -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input tx-check" type="checkbox" checked></td>
                                <td class="fw-bold text-primary font-monospace">TX-202609-005</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">VL</div>
                                        <div>
                                            <div class="fw-bold text-dark">Vũ Đình Long</div>
                                            <small class="text-muted"><span class="badge bg-light text-dark border">ACB</span> 2491 0029 8819</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end fw-bold text-dark fs-6">18.600.000 đ</td>
                                <td class="text-muted font-monospace small">MIXIMOI chi luong T09-2026 NV005</td>
                                <td>
                                    <div>Chờ xử lý Đợt 2</div>
                                    <small class="text-muted font-monospace">Chưa sinh FT</small>
                                </td>
                                <td class="text-center">
                                    <span class="tx-status-badge tx-status-pending">
                                        <i class="bi bi-hourglass-split"></i> Chờ duyệt HSM
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV005" class="btn btn-sm btn-outline-secondary py-1 px-2" title="Xem phiếu lương">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Sticky Bottom Action Bar -->
                <div class="payment-sticky-bar d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="form-check mb-0">
                            <span class="fw-bold text-dark" style="font-size: 0.9rem;">
                                Đã chọn <span class="text-primary">245 / 245</span> lệnh thanh toán
                            </span>
                        </div>
                        <div class="border-start ps-3">
                            <span class="text-muted small">Tổng tiền thanh toán:</span>
                            <span class="fw-bold text-dark fs-5 ms-1">813.000.000 VNĐ</span>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <!-- Form Xuất file UNC -->
                        <form method="post" action="${pageContext.request.contextPath}/payment">
                            <input type="hidden" name="action" value="export_unc">
                            <button type="submit" class="btn btn-outline-secondary d-flex align-items-center gap-2">
                                <i class="bi bi-file-earmark-spreadsheet"></i>
                                <span>Xuất file UNC (Excel / XML)</span>
                            </button>
                        </form>

                        <!-- Form Ký số HSM & Chuyển tiền -->
                        <form method="post" action="${pageContext.request.contextPath}/payment">
                            <input type="hidden" name="action" value="sign_send">
                            <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" onclick="return confirm('Bạn có chắc chắn muốn KÝ SỐ HSM và gửi lệnh chi 813.000.000 VNĐ sang Cổng Ngân hàng Napas không?');">
                                <i class="bi bi-shield-lock-fill"></i>
                                <span>Ký số HSM & Gửi lệnh ngân hàng</span>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<!-- Modal Tạo Lệnh Chi Mới -->
<div class="modal fade" id="createDisbursementModal" tabindex="-1" aria-labelledby="createDisbursementModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="createDisbursementModalLabel">Tạo đợt chi lương mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/payment">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên đợt chi lương</label>
                        <input type="text" class="form-control" name="batchName" value="Chi lương Kỳ 09/2026 - Đợt 2" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Cổng ngân hàng thanh toán</label>
                        <select class="form-select" name="bankGateway" required>
                            <option value="TCB">Techcombank Corporate API (H2H Direct)</option>
                            <option value="VCB">Vietcombank iB@nk Host-to-Host</option>
                            <option value="NAPAS">Napas 247 Instant Payout</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tài khoản nguồn trích nợ</label>
                        <input type="text" class="form-control" value="1913 8888 999999 - CTY TNHH MIXIMOI VN (VND)" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Nội dung chuyển khoản mặc định</label>
                        <input type="text" class="form-control" value="MIXIMOI chi luong T09-2026 {MA_NV}">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Xác nhận tạo lệnh</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script>
    // Select all checkboxes toggle
    document.getElementById('checkAll')?.addEventListener('change', function() {
        document.querySelectorAll('.tx-check').forEach(cb => cb.checked = this.checked);
    });
</script>
</body>
</html>
