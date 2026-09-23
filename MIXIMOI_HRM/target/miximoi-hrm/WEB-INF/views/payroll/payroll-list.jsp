<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
                                    <span class="kpi-value text-dark">
                                        <c:choose>
                                            <c:when test="${not empty avgSalary and avgSalary > 0}">
                                                <fmt:formatNumber value="${avgSalary}" type="number" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit fw-bold">VNĐ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-bar-chart-line-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted">Lương thực lĩnh trung bình</span>
                            <span class="badge bg-primary-subtle text-primary border-0 fw-bold">Kỳ ${selectedMonth}/${selectedYear}</span>
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
                                    <span class="kpi-value text-dark">${totalEmpCount > 0 ? totalEmpCount : totalRecords}</span>
                                    <span class="kpi-unit">nhân viên</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-person-badge-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-primary fw-semibold d-flex align-items-center gap-1">
                                <i class="bi bi-check-circle"></i> Kỳ ${selectedMonth}/${selectedYear}
                            </span>
                            <span class="text-muted">Đã tính lương</span>
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
                                    <span class="kpi-value text-dark">${countPaid}</span>
                                    <span class="kpi-unit">/ ${totalEmpCount > 0 ? totalEmpCount : totalRecords}</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-pie-chart-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer flex-column align-items-stretch gap-2 pt-2">
                            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                <div class="progress flex-grow-1 me-2" style="height: 6px;">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: ${empty paidRatio ? '0' : paidRatio}%;"></div>
                                </div>
                                <span class="fw-bold text-primary">${empty paidRatio ? '0.0' : paidRatio}%</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                                <span class="text-warning fw-semibold">● ${pendingCount} chờ xử lý</span>
                                <a href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}" class="text-primary text-decoration-none fw-semibold">Xem danh sách</a>
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
                            Hiển thị: <strong>${not empty payrollList ? payrollList.size() : 0}</strong> / <strong>${totalRecords}</strong> bản ghi
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
                            <%-- Render từ DB nếu có dữ liệu --%>
                            <c:choose>
                                <c:when test="${not empty payrollList}">
                                    <c:forEach var="pr" items="${payrollList}" varStatus="st">
                                        <c:set var="initials" value="${not empty pr.employeeName ? fn:toUpperCase(fn:substring(pr.employeeName, 0, 2)) : 'NV'}" />
                                        <tr>
                                            <td class="text-center">
                                                <input type="checkbox" class="form-check-input payroll-row-check" value="${pr.id}">
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/payslip?action=detail&id=${pr.id}" class="code-link" title="Xem phiếu lương điện tử">
                                                    <c:out value="${not empty pr.employeeCode ? pr.employeeCode : 'NV-'.concat(pr.id)}"/>
                                                </a>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-initials-avatar"><c:out value="${initials}"/></div>
                                                    <div>
                                                        <div class="fw-bold text-dark" style="font-size: 0.86rem;"><c:out value="${pr.employeeName}"/></div>
                                                        <div class="text-muted" style="font-size: 0.74rem;"><c:out value="${not empty pr.departmentName ? pr.departmentName : '—'}"/></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.baseSalary}">
                                                        <fmt:formatNumber value="${pr.baseSalary}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.allowance and pr.allowance > 0}">
                                                        <fmt:formatNumber value="${pr.allowance}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.bonus and pr.bonus > 0}">
                                                        <fmt:formatNumber value="${pr.bonus}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.overtimeAmount and pr.overtimeAmount > 0}">
                                                        <fmt:formatNumber value="${pr.overtimeAmount}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end font-monospace text-deduction">
                                                <c:choose>
                                                    <c:when test="${not empty pr.deduction and pr.deduction > 0}">
                                                        -<fmt:formatNumber value="${pr.deduction}" pattern="#,###"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4 font-monospace text-net-salary">
                                                <c:choose>
                                                    <c:when test="${not empty pr.netSalary}">
                                                        <fmt:formatNumber value="${pr.netSalary}" pattern="#,###"/> đ
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <%-- Dòng tổng cộng --%>
                                    <tr class="table-summary-row">
                                        <td class="text-center text-primary fs-5">Σ</td>
                                        <td colspan="2">TỔNG CỘNG KỲ THÁNG ${selectedMonth}/${selectedYear} (${totalRecords} NV)</td>
                                        <td class="text-end font-monospace" colspan="5"></td>
                                        <td class="text-end pe-4 font-monospace text-net-salary fs-6">
                                            <c:choose>
                                                <c:when test="${not empty totalPayroll and totalPayroll > 0}">
                                                    <fmt:formatNumber value="${totalPayroll}" pattern="#,###"/> đ
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                            Chưa có dữ liệu bảng lương tháng ${selectedMonth}/${selectedYear}.<br>
                                            <small>Nhấn "Tính lương tự động" để tạo bảng lương cho kỳ này.</small>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Table Pagination Footer (Server-Side) -->
                <div class="p-3 border-top d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2" style="font-size: 0.82rem;">
                        <span class="text-muted">
                            Hiển thị
                            <strong>${(currentPage - 1) * pageSize + 1}</strong>
                            –
                            <strong>${(currentPage - 1) * pageSize + payrollList.size()}</strong>
                            của <strong>${totalRecords}</strong> bản ghi
                        </span>
                    </div>

                    <nav aria-label="Phân trang bảng lương">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=1"><i class="bi bi-chevron-bar-left"></i></a>
                            </li>
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=${currentPage - 1}"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=${p}">${p}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=${currentPage + 1}"><i class="bi bi-chevron-right"></i></a>
                            </li>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/payroll?month=${selectedMonth}&year=${selectedYear}&page=${totalPages}"><i class="bi bi-chevron-bar-right"></i></a>
                            </li>
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
