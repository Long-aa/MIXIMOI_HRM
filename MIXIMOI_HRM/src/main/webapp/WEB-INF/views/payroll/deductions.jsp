<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Quản lý Khấu trừ & Giảm trừ Lương - MIXIMOI HRM" />
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
            <!-- Toast notification if success -->
            <c:if test="${param.success eq 'saved'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Đã lưu và áp dụng dữ liệu khấu trừ - đối soát VssID thành công!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-inline-flex align-items-center gap-2 px-2 py-1 rounded bg-primary-subtle text-primary fw-bold text-uppercase mb-1" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                        <i class="bi bi-shield-check"></i> PAYROLL DEDUCTIONS ENGINE • Q3-2026 / KỲ 09
                    </div>
                    <h1 class="h3 fw-bold text-dark mb-1">Quản lý Khấu trừ & Giảm trừ lương</h1>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý trích nộp bảo hiểm bắt buộc, thuế TNCN lũy tiến từng phần, tạm ứng và đối soát BHXH điện tử VssID.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="window.print()">
                        <i class="bi bi-file-earmark-spreadsheet"></i>
                        <span>Xuất file Quyết toán</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#addDeductionModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>Thêm khoản khấu trừ</span>
                    </button>
                </div>
            </div>

            <!-- VssID Sync Banner -->
            <div class="vssid-banner-box d-flex flex-column flex-md-row align-items-start align-items-md-center justify-content-between gap-3 mb-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="d-flex align-items-center justify-content-center bg-white rounded-circle text-success shadow-sm" style="width: 44px; height: 44px;">
                        <i class="bi bi-patch-check-fill fs-4"></i>
                    </div>
                    <div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="fw-bold text-dark">Cổng đối soát dữ liệu Bảo hiểm Xã hội Điện tử (VssID / BHXH Việt Nam)</span>
                            <span class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                <span class="vssid-status-dot"></span> Đã kết nối API
                            </span>
                        </div>
                        <div class="text-muted small mt-1">
                            Đã đồng bộ tự động lúc <strong>08:30 hôm nay</strong> • Tỷ lệ khớp hồ sơ <strong>98.8%</strong> (242/245 CBNV) • Có <strong>1 bản ghi cảnh báo</strong> cần rà soát.
                        </div>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-sm btn-outline-success bg-white d-flex align-items-center gap-1 shadow-sm" onclick="this.innerHTML='<span class=\'spinner-border spinner-border-sm\'></span> Đang đồng bộ...'; setTimeout(() => location.reload(), 1200);">
                        <i class="bi bi-arrow-repeat"></i> Đồng bộ lại VssID
                    </button>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1: Tổng khấu trừ -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Tổng khấu trừ kỳ này</span>
                            <div class="kpi-icon-box coral"><i class="bi bi-dash-circle"></i></div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.7rem;"><fmt:formatNumber value="${totalAllDeductions}" pattern="#,##0"/></span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">đ</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-danger-subtle text-danger fw-semibold" style="font-size: 0.73rem;">
                                BH + Thuế + Tạm ứng
                            </span>
                            <span class="text-muted small">kỳ Tháng ${selectedMonth}/${selectedYear}</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2: Trích nộp BHXH/BHYT/BHTN -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Trích nộp BHXH / BHYT / BHTN</span>
                            <div class="kpi-icon-box blue"><i class="bi bi-shield-shaded"></i></div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.7rem;"><fmt:formatNumber value="${totalInsurance}" pattern="#,##0"/></span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">đ</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-primary-subtle text-primary fw-semibold" style="font-size: 0.73rem;">
                                ${bhxhRate}% + ${bhytRate}% + ${bhtnRate}% đóng BH
                            </span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3: Thuế TNCN tạm khấu trừ -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Thuế TNCN tạm khấu trừ</span>
                            <div class="kpi-icon-box amber"><i class="bi bi-percent"></i></div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.7rem;">Ấn trong Khấu trừ</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge bg-warning-subtle text-warning-emphasis fw-semibold" style="font-size: 0.73rem;">
                                Lũy tiến 7 bậc
                            </span>
                            <span class="text-muted small">Thông tư 111</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4: Tạm ứng -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Thu hồi & Tạm ứng khác</span>
                            <div class="kpi-icon-box purple"><i class="bi bi-arrow-left-right"></i></div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.7rem;"><fmt:formatNumber value="${totalAdvance}" pattern="#,##0"/></span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">đ</span>
                        </div>
                        <div class="d-flex align-items-center gap-1">
                            <span class="badge fw-semibold" style="font-size: 0.73rem; background: #f3e8ff; color: #7e22ce;">
                                ${advanceCases} trường hợp
                            </span>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Filter Card -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <form method="get" action="${pageContext.request.contextPath}/deductions" class="row g-2 align-items-center">
                        <div class="col-12 col-md-4">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" name="keyword" class="form-control border-start-0" placeholder="Tìm tên nhân viên, mã NV..." value="${keyword}">
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <select name="deptId" class="form-select form-select-sm">
                                <option value="">Tất cả phòng ban</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" ${dept.id == selectedDeptId ? 'selected' : ''}>${dept.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select name="month" class="form-select form-select-sm">
                                <c:forEach var="m" begin="1" end="12">
                                    <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>Tháng ${m}/${selectedYear}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12 col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-sm btn-primary w-100 d-flex align-items-center justify-content-center gap-1">
                                <i class="bi bi-funnel"></i> Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/deductions" class="btn btn-sm btn-outline-secondary" title="Đặt lại">
                                <i class="bi bi-arrow-counterclockwise"></i>
                            </a>
                        </div>
                    </form>
                </div>
            </div>


            <!-- Deductions Detail Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="h6 fw-bold mb-0 text-dark">Bảng khấu trừ phát sinh kỳ Tháng ${selectedMonth}/${selectedYear}</h2>
                        <span class="text-muted small">Danh sách các khoản tạm ứng, thu hồi và khấu trừ phát sinh thêm</span>
                    </div>
                    <span class="badge bg-light text-dark border">Tổng cộng: ${deductionList.size()} khoản</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3 py-3">Mã NV</th>
                                <th>Họ tên</th>
                                <th>Phòng ban</th>
                                <th>Loại khấu trừ</th>
                                <th class="text-end">Số tiỀn</th>
                                <th>Mô tả</th>
                                <th class="text-center pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty deductionList}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                            Chưa có khoản khấu trừ phát sinh nào trong tháng ${selectedMonth}/${selectedYear}
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="d" items="${deductionList}">
                                        <tr>
                                            <td class="ps-3 fw-bold text-primary">${d.employeeCode}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${d.employeeName}</div>
                                                <small class="text-muted">${d.departmentName}</small>
                                            </td>
                                            <td class="text-muted">${d.departmentName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${d.deductionType eq 'ADVANCE'}">
                                                        <span class="badge bg-purple-subtle" style="background:#f3e8ff; color:#7e22ce;">Tạm ứng</span>
                                                    </c:when>
                                                    <c:when test="${d.deductionType eq 'DISCIPLINE'}">
                                                        <span class="badge bg-danger-subtle text-danger">Kỷ luật</span>
                                                    </c:when>
                                                    <c:when test="${d.deductionType eq 'LOAN'}">
                                                        <span class="badge bg-warning-subtle text-warning">Vay nội bộ</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary">${d.deductionType}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end fw-bold text-danger">
                                                <fmt:formatNumber value="${d.amount}" pattern="#,##0"/> đ
                                            </td>
                                            <td class="text-muted" style="font-size:0.8rem;">${d.description}</td>
                                            <td class="text-center pe-3">
                                                <form method="post" action="${pageContext.request.contextPath}/deductions" style="display:inline;" onsubmit="return confirm('Xác nhận xóa khoản khấu trừ này?')">
                                                    <input type="hidden" name="action" value="delete"/>
                                                    <input type="hidden" name="id" value="${d.id}"/>
                                                    <input type="hidden" name="month" value="${selectedMonth}"/>
                                                    <input type="hidden" name="year" value="${selectedYear}"/>
                                                    <button type="submit" class="btn btn-sm btn-outline-danger py-1 px-2" title="Xóa">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Deductions by Employee in Payroll -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="h6 fw-bold mb-0 text-dark">Bảng chi tiết khấu trừ theo nhân sự kỳ Tháng ${selectedMonth}/${selectedYear}</h2>
                        <span class="text-muted small">Khấu trừ bảo hiểm (10.5%), thuế TNCN và các khoản giảm trừ theo bảng lương</span>
                    </div>
                    <span class="badge bg-light text-dark border">Tổng cộng: ${empty payrolls ? 0 : fn:length(payrolls)} nhân sự</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3 py-3" style="width: 110px;">Mã NV</th>
                                <th style="width: 220px;">Họ tên & Vị trí</th>
                                <th class="text-end">Lương cơ bản</th>
                                <th class="text-end">BHXH (8%)</th>
                                <th class="text-end">BHYT (1.5%)</th>
                                <th class="text-end">BHTN (1%)</th>
                                <th class="text-end fw-bold text-danger">Tổng khấu trừ</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty payrolls}">
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                            Chưa có dữ liệu bảng lương tháng ${selectedMonth}/${selectedYear}.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${payrolls}">
                                        <tr>
                                            <td class="ps-3 fw-bold text-primary">${p.employeeCode}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-initials-avatar bg-primary-subtle text-primary fw-bold" style="width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.78rem;">
                                                        ${fn:substring(p.employeeName, 0, 1)}
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold text-dark">${p.employeeName}</div>
                                                        <small class="text-muted">${p.positionName} • ${p.departmentName}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <fmt:formatNumber value="${p.baseSalary}" pattern="#,##0"/> đ
                                            </td>
                                            <td class="text-end font-monospace text-muted">
                                                <fmt:formatNumber value="${p.baseSalary * 0.08}" pattern="#,##0"/> đ
                                            </td>
                                            <td class="text-end font-monospace text-muted">
                                                <fmt:formatNumber value="${p.baseSalary * 0.015}" pattern="#,##0"/> đ
                                            </td>
                                            <td class="text-end font-monospace text-muted">
                                                <fmt:formatNumber value="${p.baseSalary * 0.01}" pattern="#,##0"/> đ
                                            </td>
                                            <td class="text-end font-monospace fw-bold text-danger">
                                                <fmt:formatNumber value="${p.deduction}" pattern="#,##0"/> đ
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${p.status eq 'PAID'}">
                                                        <span class="badge bg-success-subtle text-success">Đã chi trả</span>
                                                    </c:when>
                                                    <c:when test="${p.status eq 'APPROVED'}">
                                                        <span class="badge bg-primary-subtle text-primary">Đã duyệt</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning-subtle text-warning-emphasis">${p.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center pe-3">
                                                <a href="${pageContext.request.contextPath}/payslip?action=detail&id=${p.id}" class="btn btn-sm btn-outline-primary py-1 px-2" title="Xem phiếu lương">
                                                    <i class="bi bi-receipt"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Bottom 2 Cards: Tax Brackets & Legal Framework -->
            <div class="row g-4">
                <!-- Card 1: 7-Level Tax Bracket -->
                <div class="col-12 col-lg-7">
                    <div class="tax-bracket-card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h3 class="h6 fw-bold text-dark mb-1">
                                    <i class="bi bi-diagram-3-fill text-primary me-2"></i>Biểu thuế thu nhập cá nhân lũy tiến từng phần
                                </h3>
                                <span class="text-muted small">Căn cứ theo Thông tư 111/2013/TT-BTC & Nghị định quy định chi tiết</span>
                            </div>
                            <span class="badge bg-primary-subtle text-primary">7 Bậc thuế</span>
                        </div>
                        <div class="table-responsive">
                            <table class="tax-bracket-table w-100 table-bordered">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 50px;">Bậc</th>
                                        <th>Thu nhập tính thuế / tháng</th>
                                        <th class="text-center" style="width: 85px;">Thuế suất</th>
                                        <th class="text-end">Số thuế tính theo cách 1</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-center"><span class="tax-badge-step">1</span></td>
                                        <td>Đến 5 triệu VNĐ</td>
                                        <td class="text-center fw-bold text-success">5%</td>
                                        <td class="text-end">0 + 5% TNTT</td>
                                    </tr>
                                    <tr>
                                        <td class="text-center"><span class="tax-badge-step">2</span></td>
                                        <td>Trên 5 đến 10 triệu VNĐ</td>
                                        <td class="text-center fw-bold text-success">10%</td>
                                        <td class="text-end">0.25 tr + 10% (TNTT - 5 tr)</td>
                                    </tr>
                                    <tr>
                                        <td class="text-center"><span class="tax-badge-step">3</span></td>
                                        <td>Trên 10 đến 18 triệu VNĐ</td>
                                        <td class="text-center fw-bold text-primary">15%</td>
                                        <td class="text-end">0.75 tr + 15% (TNTT - 10 tr)</td>
                                    </tr>
                                    <tr class="table-primary bg-opacity-25">
                                        <td class="text-center"><span class="tax-badge-step active">4</span></td>
                                        <td><strong>Trên 18 đến 32 triệu VNĐ</strong> <span class="badge bg-primary ms-1">Mức phổ biến</span></td>
                                        <td class="text-center fw-bold text-primary">20%</td>
                                        <td class="text-end fw-bold">1.95 tr + 20% (TNTT - 18 tr)</td>
                                    </tr>
                                    <tr>
                                        <td class="text-center"><span class="tax-badge-step">5</span></td>
                                        <td>Trên 32 đến 52 triệu VNĐ</td>
                                        <td class="text-center fw-bold text-warning-emphasis">25%</td>
                                        <td class="text-end">4.75 tr + 25% (TNTT - 32 tr)</td>
                                    </tr>
                                    <tr>
                                        <td class="text-center"><span class="tax-badge-step">6</span></td>
                                        <td>Trên 52 đến 80 triệu VNĐ</td>
                                        <td class="text-center fw-bold text-warning-emphasis">30%</td>
                                        <td class="text-end">9.75 tr + 30% (TNTT - 52 tr)</td>
                                    </tr>
                                    <tr>
                                        <td class="text-center"><span class="tax-badge-step">7</span></td>
                                        <td>Trên 80 triệu VNĐ</td>
                                        <td class="text-center fw-bold text-danger">35%</td>
                                        <td class="text-end">18.15 tr + 35% (TNTT - 80 tr)</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Legal Relief Parameters -->
                <div class="col-12 col-lg-5">
                    <div class="tax-bracket-card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h3 class="h6 fw-bold text-dark mb-1">
                                    <i class="bi bi-bank2 text-success me-2"></i>Mức giảm trừ gia cảnh & Căn cứ pháp lý
                                </h3>
                                <span class="text-muted small">Cập nhật áp dụng cho năm tài chính 2026</span>
                            </div>
                            <span class="badge bg-success-subtle text-success">Hiệu lực</span>
                        </div>
                        
                        <div class="list-group list-group-flush border-top border-bottom mb-3" style="font-size: 0.83rem;">
                            <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                                <div>
                                    <div class="fw-semibold text-dark">Giảm trừ cho bản thân người nộp thuế</div>
                                    <small class="text-muted">Nghị quyết 954/2020/UBTVQH14</small>
                                </div>
                                <span class="fw-bold text-success fs-6">11.000.000 đ/tháng</span>
                            </div>

                            <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                                <div>
                                    <div class="fw-semibold text-dark">Giảm trừ mỗi người phụ thuộc (NPT)</div>
                                    <small class="text-muted">Đã đăng ký MST phụ thuộc</small>
                                </div>
                                <span class="fw-bold text-primary fs-6">4.400.000 đ/tháng</span>
                            </div>

                            <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                                <div>
                                    <div class="fw-semibold text-dark">Mức trần đóng BHXH & BHYT</div>
                                    <small class="text-muted">20 lần lương cơ sở 2.340.000 đ</small>
                                </div>
                                <span class="fw-bold text-dark fs-6">46.800.000 đ</span>
                            </div>

                            <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                                <div>
                                    <div class="fw-semibold text-dark">Mức trần đóng BHTN (Vùng I)</div>
                                    <small class="text-muted">20 lần lương tối thiểu vùng I (4.96 tr)</small>
                                </div>
                                <span class="fw-bold text-dark fs-6">99.200.000 đ</span>
                            </div>
                        </div>

                        <div class="p-3 bg-light rounded-3" style="font-size: 0.78rem;">
                            <div class="fw-bold text-dark mb-1">Tỷ lệ đóng bắt buộc của Người lao động:</div>
                            <div class="d-flex justify-content-between text-muted mb-1">
                                <span>BHXH (8.0%) + BHYT (1.5%) + BHTN (1.0%)</span>
                                <span class="fw-bold text-danger">Tổng trừ: 10.5%</span>
                            </div>
                            <div class="d-flex justify-content-between text-muted">
                                <span>Phần Doanh nghiệp chịu (BHXH, BHYT, BHTN, BHTNLĐ)</span>
                                <span class="fw-bold text-dark">Tổng đóng: 21.5%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<!-- Modal Thêm khoản khấu trừ -->
<div class="modal fade" id="addDeductionModal" tabindex="-1" aria-labelledby="addDeductionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="addDeductionModalLabel">Thêm khoản khấu trừ / Giảm trừ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/deductions">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Chọn Nhân viên</label>
                        <select name="employeeId" class="form-select" required>
                            <option value="">-- Chọn nhân viên --</option>
                            <c:forEach var="emp" items="${employees}">
                                <option value="${emp.id}">${emp.employeeCode} - ${emp.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Loại khấu trừ</label>
                        <select name="deductionType" class="form-select" required>
                            <option value="ADVANCE">Tạm ứng lương</option>
                            <option value="DISCIPLINE">Thu hồi vi phạm / Kỷ luật</option>
                            <option value="LOAN">Khấu trừ tiền vay nội bộ</option>
                            <option value="EQUIPMENT">Bồi hoàn trang thiết bị</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Số tiền khấu trừ (VNĐ)</label>
                        <input type="number" name="amount" class="form-control" placeholder="VD: 1000000" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Lý do & Ghi chú</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Ghi chú chi tiết lý do khấu trừ"></textarea>
                    </div>
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="month" value="${selectedMonth}"/>
                    <input type="hidden" name="year" value="${selectedYear}"/>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu khoản khấu trừ</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
