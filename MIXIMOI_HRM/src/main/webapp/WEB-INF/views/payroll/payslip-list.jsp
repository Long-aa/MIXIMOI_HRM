<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Danh sách Phiếu Lương Nhân Viên — MIXIMOI HRM</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="payslip" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <%-- Alerts --%>
            <c:if test="${param.success eq 'sent_all'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-send-check-fill fs-5 text-success"></i>
                    <div>Đã gửi thành công <strong>${totalSlips} phiếu lương điện tử</strong> tới hộp thư nội bộ và ứng dụng di động!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- Page Header --%>
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase" style="font-size:0.72rem; letter-spacing:0.5px;">
                            <i class="bi bi-receipt-cutoff"></i> HỆ THỐNG PHIẾU LƯƠNG ĐIỆN TỬ
                        </span>
                        <span class="text-muted" style="font-size:0.8rem;">Kỳ T${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}</span>
                    </div>
                    <h1 class="h3 fw-bold text-dark mb-0">Danh sách Phiếu lương Nhân viên</h1>
                    <p class="text-muted mb-0" style="font-size:0.875rem;">Quản lý, phát hành và đối soát phiếu lương điện tử A4 xác thực số SHA-256 cho CBNV.</p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn-action-light" onclick="alert('Đang nén và tải ${totalSlips} file PDF phiếu lương ký số...');">
                        <i class="bi bi-file-earmark-zip"></i>
                        <span>Xuất ZIP toàn bộ PDF</span>
                    </button>
                    <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                        <form method="post" action="${pageContext.request.contextPath}/payslip">
                            <input type="hidden" name="action" value="send_all">
                            <button type="submit" class="btn-action-primary border-0"
                                    onclick="return confirm('Phát hành &amp; gửi email phiếu lương đến toàn bộ ${totalSlips} nhân viên?');">
                                <i class="bi bi-send-fill"></i>
                                <span>Phát hành &amp; Gửi hàng loạt</span>
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <%-- KPI Cards --%>
            <div class="row g-3 mb-4">
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng phiếu lương đã tạo</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">${totalSlips}</span>
                                    <span class="kpi-unit">phiếu</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue"><i class="bi bi-file-earmark-text"></i></div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-primary-subtle text-primary fw-semibold" style="font-size:0.73rem;">
                                Kỳ T${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}
                            </span>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Đã hoàn tất chi trả</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-success">${countPaid}</span>
                                    <span class="kpi-unit">phiếu PAID</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box" style="background:rgba(22,163,74,0.12);color:#16a34a;"><i class="bi bi-patch-check-fill"></i></div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-success-subtle text-success fw-semibold">Đã thanh toán</span>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Chờ phê duyệt / Nháp</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value" style="color:#d97706;">${countPending}</span>
                                    <span class="kpi-unit">phiếu</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box" style="background:rgba(217,119,6,0.12);color:#d97706;"><i class="bi bi-clock-history"></i></div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-warning-subtle text-warning-emphasis fw-semibold">Cần xử lý</span>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Xác thực chữ ký số</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">${totalSlips} / ${totalSlips}</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple"><i class="bi bi-shield-check"></i></div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-primary-subtle text-primary fw-semibold">3 cấp ký duyệt</span>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Payslip Table --%>
            <div class="table-custom-container mb-4">
                <div class="p-3 border-bottom d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div>
                        <span class="fw-bold text-dark">Bảng tổng hợp phiếu lương kỳ Tháng ${selectedMonth}/${selectedYear}</span>
                        <span class="badge bg-light text-dark border ms-2">Tổng: ${totalSlips} phiếu</span>
                    </div>
                    <%-- Period navigation --%>
                    <div class="period-picker-container">
                        <a href="${pageContext.request.contextPath}/payslip?month=${selectedMonth > 1 ? selectedMonth - 1 : 12}&year=${selectedMonth > 1 ? selectedYear : selectedYear - 1}"
                           class="period-picker-btn"><i class="bi bi-chevron-left"></i></a>
                        <span class="period-picker-label">
                            <i class="bi bi-calendar3 text-primary"></i>
                            Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}
                        </span>
                        <a href="${pageContext.request.contextPath}/payslip?month=${selectedMonth < 12 ? selectedMonth + 1 : 1}&year=${selectedMonth < 12 ? selectedYear : selectedYear + 1}"
                           class="period-picker-btn"><i class="bi bi-chevron-right"></i></a>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width:40px;" class="text-center"><input type="checkbox" class="form-check-input"></th>
                                <th>MÃ PHIẾU</th>
                                <th>NHÂN VIÊN</th>
                                <th>PHÒNG BAN</th>
                                <th class="text-end">THU NHẬP GROSS</th>
                                <th class="text-end">KHẤU TRỪ</th>
                                <th class="text-end">THỰC NHẬN (NET)</th>
                                <th class="text-center">TRẠNG THÁI</th>
                                <th class="text-center pe-4">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty payrollList}">
                                    <c:forEach var="pr" items="${payrollList}" varStatus="st">
                                        <c:set var="initials" value="${not empty pr.employeeName ? fn:toUpperCase(fn:substring(pr.employeeName, 0, 2)) : 'NV'}"/>
                                        <c:set var="gross" value="${(not empty pr.baseSalary ? pr.baseSalary : 0)
                                            + (not empty pr.overtimeAmount ? pr.overtimeAmount : 0)
                                            + (not empty pr.allowance ? pr.allowance : 0)
                                            + (not empty pr.bonus ? pr.bonus : 0)}"/>
                                        <c:set var="slipCode" value="PL-${pr.payYear}${pr.payMonth < 10 ? '0' : ''}${pr.payMonth}-${pr.id < 100 ? '0' : ''}${pr.id < 10 ? '0' : ''}${pr.id}"/>
                                        <tr>
                                            <td class="text-center"><input type="checkbox" class="form-check-input" value="${pr.id}"></td>
                                            <td>
                                                <span class="fw-bold font-monospace text-primary" style="font-size:0.83rem;">
                                                    <i class="bi bi-file-earmark-check text-primary me-1"></i>
                                                    <c:out value="${slipCode}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-initials-avatar"><c:out value="${initials}"/></div>
                                                    <div>
                                                        <div class="fw-bold text-dark" style="font-size:0.86rem;"><c:out value="${pr.employeeName}"/></div>
                                                        <small class="text-muted">Mã: <c:out value="${pr.employeeCode}"/></small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark" style="font-size:0.83rem;"><c:out value="${not empty pr.departmentName ? pr.departmentName : '—'}"/></div>
                                            </td>
                                            <td class="text-end fw-semibold text-dark font-monospace">
                                                <c:choose>
                                                    <c:when test="${gross > 0}"><fmt:formatNumber value="${gross}" pattern="#,###"/> đ</c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end fw-semibold text-danger font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.deduction and pr.deduction > 0}">-<fmt:formatNumber value="${pr.deduction}" pattern="#,###"/> đ</c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end fw-bold text-primary font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.netSalary}"><fmt:formatNumber value="${pr.netSalary}" pattern="#,###"/> đ</c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${pr.status eq 'PAID'}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle">
                                                            <i class="bi bi-check2-all"></i> Đã chi trả
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pr.status eq 'APPROVED'}">
                                                        <span class="badge bg-info-subtle text-info border border-info-subtle">
                                                            <i class="bi bi-check-circle"></i> Đã duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pr.status eq 'PENDING'}">
                                                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">
                                                            <i class="bi bi-hourglass-split"></i> Chờ duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">
                                                            <i class="bi bi-pencil-square"></i> Nháp
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center pe-4">
                                                <a href="${pageContext.request.contextPath}/payslip?action=detail&id=${pr.id}"
                                                   class="btn btn-sm btn-primary d-inline-flex align-items-center gap-1 shadow-sm">
                                                    <i class="bi bi-receipt"></i>
                                                    <span>Xem chi tiết</span>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                            Chưa có phiếu lương kỳ Tháng ${selectedMonth}/${selectedYear}.<br>
                                            <small>Vào <a href="${pageContext.request.contextPath}/payroll">Quản lý bảng lương</a> để tính lương trước.</small>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="p-3 border-top d-flex justify-content-between align-items-center">
                    <span class="text-muted small">Hiển thị <strong>${not empty payrollList ? payrollList.size() : 0}</strong> / <strong>${totalSlips}</strong> phiếu lương</span>
                </div>
            </div>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
