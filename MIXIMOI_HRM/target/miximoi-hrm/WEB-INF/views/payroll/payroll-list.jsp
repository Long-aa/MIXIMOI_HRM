<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý tính lương & Bảng lương — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="payroll" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Payroll Page Body -->
        <div class="app-content">
            
            <!-- Page Header Area -->
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                            PAYROLL ENGINE V4.2
                        </span>
                        <span class="text-muted" style="font-size: 0.8rem;">•</span>
                        <span class="text-muted" style="font-size: 0.82rem;">Chu kỳ quyết toán chuẩn</span>
                    </div>
                    <h3 class="fw-extrabold text-dark mb-0" style="font-weight: 800; font-size: 1.65rem;">
                        Quản lý tính lương & Bảng lương
                    </h3>
                </div>

                <!-- Action Toolbar & Month Navigator -->
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <!-- Month Navigator -->
                    <div class="period-picker-container">
                        <a href="${pageContext.request.contextPath}/payroll?month=${selectedMonth > 1 ? selectedMonth - 1 : 12}&year=${selectedMonth > 1 ? selectedYear : selectedYear - 1}" 
                           class="period-picker-btn" title="Tháng trước">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                        <span class="period-picker-label">
                            <i class="bi bi-calendar3 text-primary"></i>
                            Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}
                        </span>
                        <a href="${pageContext.request.contextPath}/payroll?month=${selectedMonth < 12 ? selectedMonth + 1 : 1}&year=${selectedMonth < 12 ? selectedYear : selectedYear + 1}" 
                           class="period-picker-btn" title="Tháng sau">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </div>

                    <!-- Action Buttons -->
                    <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                        <form method="post" action="${pageContext.request.contextPath}/payroll" class="d-inline"
                              onsubmit="return confirm('Hệ thống sẽ tự động tính toán lương tháng ${selectedMonth}/${selectedYear} cho toàn bộ nhân viên. Tiếp tục?');">
                            <input type="hidden" name="action" value="calculate">
                            <input type="hidden" name="month" value="${selectedMonth}">
                            <input type="hidden" name="year" value="${selectedYear}">
                            <button type="submit" class="btn-action-primary border-0">
                                <i class="bi bi-lightning-charge-fill"></i>
                                <span>Tính lương tự động</span>
                            </button>
                        </form>
                    </c:if>

                    <button type="button" class="btn-action-light" onclick="alert('Đang kết xuất bảng lương Tháng ${selectedMonth}/${selectedYear} ra định dạng Excel...');">
                        <i class="bi bi-file-earmark-excel"></i>
                        <span>Xuất Excel</span>
                    </button>

                    <button type="button" class="btn-action-light" onclick="window.print();">
                        <i class="bi bi-printer"></i>
                        <span>In bảng lương</span>
                    </button>

                    <button type="button" class="btn-action-dark" onclick="alert('Đã khóa dữ liệu bảng lương kỳ Tháng ${selectedMonth}/${selectedYear}. Không thể chỉnh sửa thêm!');">
                        <i class="bi bi-lock-fill"></i>
                        <span>Khóa bảng lương</span>
                    </button>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'calculated'}">Tính toán bảng lương tháng ${selectedMonth}/${selectedYear} thành công!</c:when>
                        <c:when test="${param.success eq 'approved'}">Phê duyệt bảng lương thành công!</c:when>
                        <c:when test="${param.success eq 'paid'}">Ghi nhận hoàn tất chi trả thanh toán lương!</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- 4 Stat KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- Card 1: Tổng quỹ lương tháng -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng quỹ lương tháng</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">
                                        <c:choose>
                                            <c:when test="${totalPayroll != null and totalPayroll > 0}">
                                                <fmt:formatNumber value="${totalPayroll}" type="number" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>850.000.000</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit fw-bold">VNĐ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-bank2"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-graph-up-arrow"></i> +3.4%
                            </span>
                            <span class="text-muted">so với T08/2026</span>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Lương TB nhân sự -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Lương TB nhân sự</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">12.500.000</span>
                                    <span class="kpi-unit fw-bold">VNĐ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-bar-chart-line-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted">Định mức chuẩn/vị trí</span>
                            <span class="badge bg-primary-subtle text-primary border-0 fw-bold">Chuẩn hóa KPI</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Hồ sơ nhận lương -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Hồ sơ nhận lương</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">245</span>
                                    <span class="kpi-unit">nhân viên</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-person-badge-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-primary fw-semibold d-flex align-items-center gap-1">
                                <i class="bi bi-check-circle"></i> 100% hồ sơ
                            </span>
                            <span class="text-muted">Không thiếu sót</span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Đã chi trả thành công -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Đã chi trả thành công</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">230</span>
                                    <span class="kpi-unit">/ 245</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-pie-chart-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer flex-column align-items-stretch gap-2 pt-2">
                            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                <div class="progress flex-grow-1 me-2" style="height: 6px;">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: 93.8%;"></div>
                                </div>
                                <span class="fw-bold text-primary">93.8%</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                <span class="text-danger fw-semibold">● 15 chờ duyệt</span>
                                <a href="#" class="text-primary text-decoration-none fw-semibold">Xem danh sách</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter & Search Toolbar -->
            <div class="dashboard-filter-card mb-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex flex-wrap align-items-center gap-2 flex-grow-1">
                        <!-- Search Box -->
                        <div class="position-relative" style="min-width: 260px;">
                            <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted" style="font-size: 0.85rem;"></i>
                            <input type="text" class="form-control ps-5 py-2 bg-light border-0" placeholder="Tìm theo mã NV, họ tên..." style="font-size: 0.83rem; border-radius: 10px;">
                        </div>

                        <!-- Department Filter -->
                        <select class="filter-select">
                            <option selected>Phòng ban: Tất cả</option>
                            <option>Phòng Công nghệ & IT</option>
                            <option>Phát triển Kinh doanh</option>
                            <option>Marketing Tổng hợp</option>
                            <option>Tài chính - Kế toán</option>
                            <option>Nhân sự & Đào tạo</option>
                        </select>

                        <!-- Status Filter -->
                        <select class="filter-select">
                            <option selected>Trạng thái: Tất cả</option>
                            <option>Đã chi trả</option>
                            <option>Chờ phê duyệt</option>
                            <option>Bản nháp</option>
                        </select>

                        <!-- Reset Button -->
                        <button type="button" class="btn-filter-refresh" title="Làm mới bộ lọc">
                            <i class="bi bi-arrow-clockwise"></i>
                            <span>Làm mới lọc</span>
                        </button>
                    </div>

                    <!-- Right Options & Count -->
                    <div class="d-flex align-items-center gap-3">
                        <span class="text-muted" style="font-size: 0.83rem;">
                            Hiển thị: <strong>5</strong> / 245 nhân sự
                        </span>
                        <div class="btn-group">
                            <button class="btn btn-sm btn-light border py-1 px-2" title="Cột hiển thị"><i class="bi bi-layout-three-columns"></i></button>
                            <button class="btn btn-sm btn-light border py-1 px-2" title="Lịch sử tính lương"><i class="bi bi-clock-history"></i></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payroll Master Table -->
            <div class="table-custom-container mb-4">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width: 40px;" class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </th>
                                <th>MÃ NV</th>
                                <th>HỌ TÊN & VỊ TRÍ</th>
                                <th class="text-end">LƯƠNG CƠ BẢN</th>
                                <th class="text-end">PHỤ CẤP</th>
                                <th class="text-end">THƯỞNG</th>
                                <th class="text-end">TĂNG CA (OT)</th>
                                <th class="text-end">KHẤU TRỪ</th>
                                <th class="text-end pe-4">THỰC NHẬN (NET)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Row 1: NV001 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV001" class="code-link" title="Xem phiếu lương điện tử">NV001</a>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar">AN</div>
                                        <div>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Nguyễn Văn An</div>
                                            <div class="text-muted" style="font-size: 0.74rem;">Phần mềm (CNTT)</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end font-monospace">15.000.000</td>
                                <td class="text-end font-monospace">2.000.000</td>
                                <td class="text-end font-monospace">1.000.000</td>
                                <td class="text-end font-monospace">500.000</td>
                                <td class="text-end font-monospace text-deduction">-1.500.000</td>
                                <td class="text-end pe-4 font-monospace text-net-salary">17.000.000 đ</td>
                            </tr>

                            <!-- Row 2: NV002 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV002" class="code-link" title="Xem phiếu lương điện tử">NV002</a>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#fdf2f8; color:#db2777; border-color:#fbcfe8;">TM</div>
                                        <div>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Trần Thị Mai</div>
                                            <div class="text-muted" style="font-size: 0.74rem;">Phát triển Kinh Doanh</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end font-monospace">18.000.000</td>
                                <td class="text-end font-monospace">2.500.000</td>
                                <td class="text-end font-monospace">
                                    5.000.000 <br>
                                    <small class="text-muted" style="font-size:0.7rem;">(Hoa hồng)</small>
                                </td>
                                <td class="text-end font-monospace text-muted">-</td>
                                <td class="text-end font-monospace text-deduction">-2.550.000</td>
                                <td class="text-end pe-4 font-monospace text-net-salary">22.950.000 đ</td>
                            </tr>

                            <!-- Row 3: NV003 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV003" class="code-link" title="Xem phiếu lương điện tử">NV003</a>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#f5f3ff; color:#7c3aed; border-color:#ddd6fe;">HN</div>
                                        <div>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Lê Hoàng Nam</div>
                                            <div class="text-muted" style="font-size: 0.74rem;">Quản Lý Dự Án</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end font-monospace">20.000.000</td>
                                <td class="text-end font-monospace">3.000.000</td>
                                <td class="text-end font-monospace text-muted">-</td>
                                <td class="text-end font-monospace">1.200.000</td>
                                <td class="text-end font-monospace text-deduction">-2.400.000</td>
                                <td class="text-end pe-4 font-monospace text-net-salary">21.800.000 đ</td>
                            </tr>

                            <!-- Row 4: NV005 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&code=NV005" class="code-link" title="Xem phiếu lương điện tử">NV005</a>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#ecfdf5; color:#059669; border-color:#a7f3d0;">TH</div>
                                        <div>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Phạm Thu Hà</div>
                                            <div class="text-muted" style="font-size: 0.74rem;">Kế Toán Nội Bộ</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end font-monospace">14.000.000</td>
                                <td class="text-end font-monospace">1.800.000</td>
                                <td class="text-end font-monospace">1.000.000</td>
                                <td class="text-end font-monospace">250.000</td>
                                <td class="text-end font-monospace text-deduction">-1.450.000</td>
                                <td class="text-end pe-4 font-monospace text-net-salary">15.600.000 đ</td>
                            </tr>

                            <!-- Row 5: NV006 -->
                            <tr>
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input">
                                </td>
                                <td>
                                    <a href="#" class="code-link">NV006</a>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-initials-avatar" style="background:#fffbeb; color:#d97706; border-color:#fde68a;">BN</div>
                                        <div>
                                            <div class="fw-bold text-dark" style="font-size: 0.86rem;">Đỗ Bích Ngọc</div>
                                            <div class="text-muted" style="font-size: 0.74rem;">Nhân Sự & Đào Tạo</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-end font-monospace">11.500.000</td>
                                <td class="text-end font-monospace">1.500.000</td>
                                <td class="text-end font-monospace">500.000</td>
                                <td class="text-end font-monospace text-muted">-</td>
                                <td class="text-end font-monospace text-deduction">-1.180.000</td>
                                <td class="text-end pe-4 font-monospace text-net-salary">12.320.000 đ</td>
                            </tr>

                            <!-- Summary Row matching Mockup -->
                            <tr class="table-summary-row">
                                <td class="text-center text-primary fs-5">Σ</td>
                                <td colspan="2">TỔNG CỘNG TOÀN CÔNG TY (245 NV)</td>
                                <td class="text-end font-monospace">720.000.000</td>
                                <td class="text-end font-monospace">85.000.000</td>
                                <td class="text-end font-monospace">62.000.000</td>
                                <td class="text-end font-monospace">24.000.000</td>
                                <td class="text-end font-monospace text-deduction">-78.000.000</td>
                                <td class="text-end pe-4 font-monospace text-net-salary fs-6">813.000.000 đ</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Table Pagination Footer -->
                <div class="p-3 border-top d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2" style="font-size: 0.82rem;">
                        <span class="text-muted">Số dòng mỗi trang:</span>
                        <select class="form-select form-select-sm d-inline-block w-auto">
                            <option selected>25</option>
                            <option>50</option>
                            <option>100</option>
                        </select>
                        <span class="text-muted ms-3">|&nbsp;&nbsp;Hiển thị 1 - 5 của 245 kết quả</span>
                    </div>

                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled"><a class="page-link" href="#"><i class="bi bi-chevron-bar-left"></i></a></li>
                            <li class="page-item disabled"><a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item disabled"><a class="page-link" href="#">...</a></li>
                            <li class="page-item"><a class="page-link" href="#">10</a></li>
                            <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a></li>
                            <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-bar-right"></i></a></li>
                        </ul>
                    </nav>
                </div>
            </div>

            <!-- Bottom 3 Compliance & Operations Cards -->
            <div class="row g-3">
                <!-- Card 1 -->
                <div class="col-lg-4">
                    <div class="compliance-notice-card">
                        <i class="bi bi-shield-check compliance-icon text-primary"></i>
                        <div>
                            <div class="compliance-title">Quy chuẩn tính BHXH & Thuế TNCN</div>
                            <p class="compliance-desc">
                                Đã áp dụng biểu thuế luỹ tiến mới nhất theo Thông tư 111 và mức trần đóng BHXH hiện hành của nhà nước.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Card 2 -->
                <div class="col-lg-4">
                    <div class="compliance-notice-card">
                        <i class="bi bi-clock-history compliance-icon text-primary"></i>
                        <div>
                            <div class="compliance-title">Đồng bộ dữ liệu chấm công tự động</div>
                            <p class="compliance-desc">
                                Dữ liệu công thực tế và số giờ tăng ca (OT) đã được chốt và duyệt bởi Trưởng phòng ban lúc 23:59 ngày 25/09.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Card 3 -->
                <div class="col-lg-4">
                    <div class="compliance-notice-card">
                        <i class="bi bi-lock-fill compliance-icon text-dark"></i>
                        <div>
                            <div class="compliance-title">Khóa sổ lương & Ký duyệt số</div>
                            <p class="compliance-desc">
                                Hạn chót gửi ngân hàng chi trả đợt 1 là 17:00 ngày 30/09/2026. Vui lòng hoàn tất kiểm tra 15 hồ sơ còn lại.
                            </p>
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
