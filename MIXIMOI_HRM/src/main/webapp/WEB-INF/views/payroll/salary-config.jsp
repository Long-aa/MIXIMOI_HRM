<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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

            <!-- Toast notification if success -->
            <c:if test="${not empty param.success or not empty successMsg}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3 border-0 shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill text-success fs-5"></i>
                    <div>
                        <c:choose>
                            <c:when test="${param.success eq 'updated' or successMsg eq 'updated'}">Đã lưu và cập nhật chính sách tham số lương thành công!</c:when>
                            <c:when test="${param.success eq 'deleted' or successMsg eq 'deleted'}">Đã xóa tham số cấu hình thành công!</c:when>
                            <c:otherwise>Thao tác cấu hình tiền lương hoàn tất!</c:otherwise>
                        </c:choose>
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
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
                    <button type="button" class="btn-action-light" onclick="window.print();">
                        <i class="bi bi-printer"></i>
                        <span>In quy chế</span>
                    </button>

                    <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                        <button type="button" class="btn-action-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addConfigModal" style="padding: 0.6rem 1.25rem; font-weight: 600; border-radius: 10px;">
                            <i class="bi bi-plus-circle-fill"></i>
                            <span>Thêm tham số mới</span>
                        </button>
                    </c:if>
                </div>
            </div>

            <!-- 4 Stat KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- Card 1: Tổng khung chính sách -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng tham số cấu hình</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">${configs != null ? configs.size() : 0}</span>
                                    <span class="kpi-unit">tham số</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-sliders"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-primary fw-semibold" style="font-size: 0.78rem;">
                                <i class="bi bi-check-circle-fill me-1"></i> 100% chuẩn Luật LĐ & BHXH
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
                                    <span class="kpi-value text-dark">
                                        <fmt:formatNumber value="${baseSalary}" pattern="#,###"/>
                                    </span>
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

                <!-- Card 3: Giảm trừ bản thân & Phụ thuộc -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Giảm trừ thuế TNCN</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">
                                        <fmt:formatNumber value="${personalReduction}" pattern="#,###"/>
                                    </span>
                                    <span class="kpi-unit">đ/tháng</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-shield-shaded"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.75rem;">Phụ thuộc: <fmt:formatNumber value="${dependentReduction}" pattern="#,###"/> đ/người</span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Tỷ lệ BHXH Người lao động -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tỷ lệ BHXH NLĐ trích nộp</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">10.5%</span>
                                    <span class="kpi-unit">(Gross)</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-person-shield"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.74rem;">BHXH: ${(bhxhRate != null ? bhxhRate * 100 : 8.0)}% • BHYT: ${(bhytRate != null ? bhytRate * 100 : 1.5)}% • BHTN: ${(bhtnRate != null ? bhtnRate * 100 : 1.0)}%</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Form: Thiết lập tham số lương chuẩn (Statutory Payroll Rules) -->
            <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                <div class="app-card mb-4">
                    <div class="app-card-header d-flex justify-content-between align-items-center">
                        <div>
                            <div class="app-card-title">
                                <i class="bi bi-gear-wide-connected text-primary me-2"></i>
                                Cấu hình Tham số Quy chế Lương & Khấu trừ Pháp định
                            </div>
                            <p class="app-card-subtitle">
                                Cập nhật trực tiếp các mốc lương tối thiểu, hạn mức giảm trừ gia cảnh và tỷ lệ trích nộp BHXH vào hệ thống tính lương tự động.
                            </p>
                        </div>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/salary-config" class="p-3">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">MỨC LƯƠNG CƠ SỞ (VNĐ)</label>
                                <input type="number" step="any" name="base_salary" value="${baseSalary}" class="form-control fw-bold text-primary" required>
                                <div class="form-text" style="font-size:0.72rem;">Chuẩn hiện hành: 2.340.000 VNĐ</div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">GIẢM TRỪ BẢN THÂN (VNĐ)</label>
                                <input type="number" step="any" name="personal_reduction" value="${personalReduction}" class="form-control fw-bold" required>
                                <div class="form-text" style="font-size:0.72rem;">Quy định thuế: 11.000.000 VNĐ/tháng</div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">GIẢM TRỪ PHỤ THUỘC (VNĐ)</label>
                                <input type="number" step="any" name="dependent_reduction" value="${dependentReduction}" class="form-control fw-bold" required>
                                <div class="form-text" style="font-size:0.72rem;">Mỗi người phụ thuộc: 4.400.000 VNĐ</div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">TRẦN ĐÓNG BẢO HIỂM (VNĐ)</label>
                                <input type="number" step="any" name="insurance_ceiling" value="${bhCeiling}" class="form-control fw-bold" required>
                                <div class="form-text" style="font-size:0.72rem;">Tối đa 20 lần lương cơ sở: 46.800.000 VNĐ</div>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">TỶ LỆ BHXH NLĐ (0.08 = 8%)</label>
                                <input type="text" name="bhxh_rate" value="${bhxhRate}" class="form-control fw-bold font-monospace" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">TỶ LỆ BHYT NLĐ (0.015 = 1.5%)</label>
                                <input type="text" name="bhyt_rate" value="${bhytRate}" class="form-control fw-bold font-monospace" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">TỶ LỆ BHTN NLĐ (0.01 = 1%)</label>
                                <input type="text" name="bhtn_rate" value="${bhtnRate}" class="form-control fw-bold font-monospace" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">CÔNG CHUẨN TRONG THÁNG</label>
                                <input type="number" name="standard_working_days" value="${standardDays}" class="form-control fw-bold" required>
                                <div class="form-text" style="font-size:0.72rem;">Mặc định: 22 ngày công chuẩn</div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                            <button type="reset" class="btn btn-sm btn-light border px-3">Đặt lại ban đầu</button>
                            <button type="submit" class="btn btn-sm btn-primary px-4 fw-bold">
                                <i class="bi bi-save me-1"></i> Lưu thiết lập chính sách
                            </button>
                        </div>
                    </form>
                </div>
            </c:if>

            <!-- Main Salary Scale Table Card -->
            <div class="table-custom-container mb-4">
                <!-- Card Header with Scale Name & Period -->
                <div class="p-3 border-bottom d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fw-bold text-dark" style="font-size: 1rem;">Danh mục tham số & Thang bảng cấu hình trong Hệ thống</span>
                        <span class="badge bg-primary-subtle text-primary border-0 fw-bold">${configs != null ? configs.size() : 0} tham số hoạt động</span>
                    </div>
                    <div class="position-relative" style="min-width: 260px;">
                        <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted" style="font-size: 0.85rem;"></i>
                        <input type="text" id="configSearchInput" onkeyup="filterConfigTable()" class="form-control ps-5 py-2 bg-light border-0" placeholder="Tìm theo mã tham số, mô tả..." style="font-size: 0.83rem; border-radius: 10px;">
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table-custom" id="configTable">
                        <thead>
                            <tr>
                                <th style="width: 50px;" class="text-center">#</th>
                                <th>MÃ THAM SỐ (KEY)</th>
                                <th>MÔ TẢ / QUY CHẾ ÁP DỤNG</th>
                                <th class="text-end">GIÁ TRỊ THIẾT LẬP</th>
                                <th class="text-center">CẬP NHẬT GẦN NHẤT</th>
                                <th class="text-end pe-4">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty configs}">
                                    <c:forEach var="cfg" items="${configs}" varStatus="status">
                                        <tr>
                                            <td class="text-center text-muted">${status.count}</td>
                                            <td>
                                                <span class="fw-bold text-primary font-monospace">${cfg.configKey}</span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark" style="font-size: 0.86rem;">
                                                    <c:out value="${not empty cfg.description ? cfg.description : 'Cấu hình tham số hệ thống tính lương'}"/>
                                                </div>
                                            </td>
                                            <td class="text-end">
                                                <span class="font-monospace fw-bold text-dark fs-6">
                                                    <c:out value="${cfg.configValue}"/>
                                                </span>
                                            </td>
                                            <td class="text-center text-muted small">
                                                <c:choose>
                                                    <c:when test="${not empty cfg.updatedAt}">
                                                        ${cfg.updatedAt}
                                                    </c:when>
                                                    <c:otherwise>Mặc định hệ thống</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                                                    <div class="btn-group">
                                                        <button type="button" class="btn btn-sm btn-light border-0" title="Chỉnh sửa tham số"
                                                                onclick="openEditConfigModal('${cfg.configKey}', '${cfg.configValue}', '${cfg.description}')">
                                                            <i class="bi bi-pencil text-primary"></i>
                                                        </button>
                                                        <form method="post" action="${pageContext.request.contextPath}/salary-config" class="d-inline"
                                                              onsubmit="return confirm('Bạn có chắc muốn xóa tham số: ${cfg.configKey}?');">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="key" value="${cfg.configKey}">
                                                            <button type="submit" class="btn btn-sm btn-light border-0 text-danger" title="Xóa tham số">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-gear-fill fs-2 d-block mb-2"></i>
                                            Chưa có tham số cấu hình nào trong database.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Table Footer -->
                <div class="p-3 border-top d-flex justify-content-between align-items-center" style="font-size:0.82rem;">
                    <span class="text-muted">
                        Hiển thị <strong>${configs != null ? configs.size() : 0} bản ghi</strong> tham số cấu hình
                    </span>
                </div>
            </div>

            <!-- Bottom 2 Configuration Cards (Payroll Cycle & Overtime Factors) -->
            <div class="row g-3">
                <!-- Card 1: Cấu hình chu kỳ tính lương (Payroll Cycle) -->
                <div class="col-lg-6">
                    <div class="app-card d-flex flex-column justify-content-between h-100">
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
                                        <div class="fw-extrabold text-dark" style="font-size: 1.35rem; font-weight: 800;">${standardDays} công</div>
                                        <div class="text-muted" style="font-size: 0.72rem;">Nghỉ T7 & CN cố định</div>
                                        <div class="text-secondary mt-1" style="font-size: 0.68rem;">Lương 1 công = Lương CB / ${standardDays}</div>
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
                        </div>
                    </div>
                </div>

                <!-- Card 2: Hệ số OT & Làm tròn -->
                <div class="col-lg-6">
                    <div class="app-card d-flex flex-column justify-content-between h-100">
                        <div>
                            <div class="app-card-header">
                                <div>
                                    <div class="app-card-title">
                                        <i class="bi bi-calculator text-primary me-1"></i>
                                        Hệ số OT & Quy tắc làm tròn
                                    </div>
                                    <p class="app-card-subtitle">
                                        Quy tắc tính hệ số lương ngoài giờ (Overtime) căn cứ theo Điều 98 Bộ Luật Lao động Việt Nam.
                                    </p>
                                </div>
                                <span class="badge bg-success-subtle text-success px-2 py-1 fw-bold" style="font-size: 0.75rem;">
                                    Chuẩn Luật LĐ
                                </span>
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

<!-- Modal: Thêm tham số cấu hình mới -->
<div class="modal fade" id="addConfigModal" tabindex="-1" aria-labelledby="addConfigModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold text-dark" id="addConfigModalLabel">
                    <i class="bi bi-plus-circle text-primary me-2"></i>Thêm Tham Số / Quy Chế Mới
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/salary-config">
                <input type="hidden" name="action" value="save_custom">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">MÃ THAM SỐ (CONFIG KEY) <span class="text-danger">*</span></label>
                        <input type="text" name="configKey" class="form-control font-monospace text-uppercase" placeholder="VD: OVERTIME_WEEKEND_RATE" required>
                        <div class="form-text" style="font-size: 0.75rem;">Chữ hoa không dấu, viết liền hoặc phân cách bởi dấu gạch dưới.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">GIÁ TRỊ THIẾT LẬP (CONFIG VALUE) <span class="text-danger">*</span></label>
                        <input type="text" name="configValue" class="form-control font-monospace" placeholder="VD: 2.0 hoặc 1500000" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">MÔ TẢ / DIỄN GIẢI CHÍNH SÁCH</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Ghi chú mục đích áp dụng của tham số này..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top">
                    <button type="button" class="btn btn-sm btn-light border" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-sm btn-primary fw-bold px-3">
                        <i class="bi bi-check2-circle me-1"></i> Lưu tham số
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Chỉnh sửa tham số cấu hình -->
<div class="modal fade" id="editConfigModal" tabindex="-1" aria-labelledby="editConfigModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold text-dark" id="editConfigModalLabel">
                    <i class="bi bi-pencil-square text-primary me-2"></i>Chỉnh Sửa Tham Số Cấu Hình
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/salary-config">
                <input type="hidden" name="action" value="save_custom">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">MÃ THAM SỐ (CONFIG KEY)</label>
                        <input type="text" id="editConfigKey" name="configKey" class="form-control font-monospace bg-light" readonly required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">GIÁ TRỊ THIẾT LẬP (CONFIG VALUE) <span class="text-danger">*</span></label>
                        <input type="text" id="editConfigValue" name="configValue" class="form-control font-monospace" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">MÔ TẢ / DIỄN GIẢI CHÍNH SÁCH</label>
                        <textarea id="editDescription" name="description" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top">
                    <button type="button" class="btn btn-sm btn-light border" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-sm btn-primary fw-bold px-3">
                        <i class="bi bi-save me-1"></i> Cập nhật
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
function filterConfigTable() {
    const input = document.getElementById("configSearchInput");
    const filter = input.value.toUpperCase();
    const table = document.getElementById("configTable");
    const tr = table.getElementsByTagName("tr");

    for (let i = 1; i < tr.length; i++) {
        const tdKey = tr[i].getElementsByTagName("td")[1];
        const tdDesc = tr[i].getElementsByTagName("td")[2];
        if (tdKey || tdDesc) {
            const keyText = tdKey ? (tdKey.textContent || tdKey.innerText) : "";
            const descText = tdDesc ? (tdDesc.textContent || tdDesc.innerText) : "";
            if (keyText.toUpperCase().indexOf(filter) > -1 || descText.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
        }
    }
}

function openEditConfigModal(key, val, desc) {
    document.getElementById("editConfigKey").value = key;
    document.getElementById("editConfigValue").value = val;
    document.getElementById("editDescription").value = (desc && desc !== 'null') ? desc : '';
    const modal = new bootstrap.Modal(document.getElementById('editConfigModal'));
    modal.show();
}
</script>

</body>
</html>
