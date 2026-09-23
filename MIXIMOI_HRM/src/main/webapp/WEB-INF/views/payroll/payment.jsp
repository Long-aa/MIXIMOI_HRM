<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thanh toán &amp; Lệnh chi Lương — MIXIMOI HRM</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="payment" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <%-- Alerts --%>
            <c:if test="${param.success eq 'batch_disbursed'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-shield-lock-fill fs-5 text-success"></i>
                    <div>Đã ký số HSM thành công và chuyển <strong>${countPaid} lệnh</strong> sang cổng Napas Corporate Banking!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'paid'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div>Đã ghi nhận chi trả thành công!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- Page Header --%>
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase" style="font-size:0.72rem; letter-spacing:0.5px;">
                            <i class="bi bi-bank"></i> HỆ THỐNG TÀI CHÍNH &amp; CHUYỂN LƯƠNG TỰ ĐỘNG
                        </span>
                    </div>
                    <h1 class="h3 fw-bold text-dark mb-1">Quản lý Thanh toán &amp; Lệnh chi lương</h1>
                    <p class="text-muted mb-0" style="font-size:0.875rem;">
                        Kiểm tra đối soát tài khoản, lập lệnh chi tự động qua cổng ngân hàng H2H &amp; Napas 24/7.
                    </p>
                </div>
                <div class="d-flex gap-2 align-items-center">
                    <%-- Period nav --%>
                    <div class="period-picker-container">
                        <a href="${pageContext.request.contextPath}/payment?month=${selectedMonth > 1 ? selectedMonth - 1 : 12}&year=${selectedMonth > 1 ? selectedYear : selectedYear - 1}"
                           class="period-picker-btn"><i class="bi bi-chevron-left"></i></a>
                        <span class="period-picker-label">
                            <i class="bi bi-calendar3 text-primary"></i>
                            T${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}
                        </span>
                        <a href="${pageContext.request.contextPath}/payment?month=${selectedMonth < 12 ? selectedMonth + 1 : 1}&year=${selectedMonth < 12 ? selectedYear : selectedYear + 1}"
                           class="period-picker-btn"><i class="bi bi-chevron-right"></i></a>
                    </div>
                    <button type="button" class="btn-action-light" onclick="alert('Lịch sử giao dịch thanh toán đang được tải...')">
                        <i class="bi bi-clock-history"></i>
                        <span>Lịch sử GD</span>
                    </button>
                    <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                        <form method="post" action="${pageContext.request.contextPath}/payment" class="d-inline"
                              onsubmit="return confirm('Xác nhận KÝ SỐ HSM và chuyển tất cả lệnh APPROVED sang trạng thái PAID?');">
                            <input type="hidden" name="action" value="batch_disburse">
                            <input type="hidden" name="month" value="${selectedMonth}">
                            <input type="hidden" name="year" value="${selectedYear}">
                            <button type="submit" class="btn-action-primary border-0">
                                <i class="bi bi-shield-lock-fill"></i>
                                <span>Ký số HSM &amp; Chi trả hàng loạt</span>
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <%-- Banking H2H Panel --%>
            <div class="banking-h2h-panel mb-4">
                <div class="row align-items-center g-3">
                    <div class="col-12 col-lg-7">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="badge bg-primary-subtle text-primary fw-bold">GATEWAY H2H</span>
                            <span class="fw-bold text-dark" style="font-size:0.95rem;">Cổng kết nối thanh toán Doanh nghiệp trực tiếp</span>
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
                        <div class="d-flex justify-content-between align-items-baseline mb-1" style="font-size:0.78rem;">
                            <span class="text-muted">Hạn mức chi online trong ngày:</span>
                            <span class="fw-bold text-dark">
                                <c:choose>
                                    <c:when test="${not empty totalPayroll and totalPayroll > 0}">
                                        <fmt:formatNumber value="${totalPayroll}" type="number" groupingUsed="true"/> / 2.000.000.000 đ
                                    </c:when>
                                    <c:otherwise>0 / 2.000.000.000 đ (0%)</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="progress" style="height:7px;">
                            <div class="progress-bar bg-primary" role="progressbar" style="width: 40.6%"></div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 4 KPI Cards --%>
            <div class="row g-3 mb-4">
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng quỹ lương kỳ T${selectedMonth}/${selectedYear}</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">
                                        <c:choose>
                                            <c:when test="${not empty totalPayroll and totalPayroll > 0}">
                                                <fmt:formatNumber value="${totalPayroll}" type="number" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="kpi-unit fw-bold">VNĐ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue"><i class="bi bi-wallet2"></i></div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-primary-subtle text-primary fw-semibold">${totalCount} hồ sơ</span>
                            <span class="text-muted">toàn công ty</span>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Đã chi trả thành công (PAID)</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-success">${countPaid}</span>
                                    <span class="kpi-unit">hồ sơ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box" style="background:rgba(22,163,74,0.12);color:#16a34a;"><i class="bi bi-check-circle-fill"></i></div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-success-subtle text-success fw-semibold">Hoàn tất</span>
                            <span class="text-muted">kỳ T${selectedMonth}/${selectedYear}</span>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Đã duyệt — Sẵn sàng chi (APPROVED)</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value" style="color:#d97706;">${countApproved}</span>
                                    <span class="kpi-unit">hồ sơ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box amber"><i class="bi bi-hourglass-split"></i></div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-warning-subtle text-warning-emphasis fw-semibold">Sẵn sàng chi trả</span>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Lỗi / Thiếu thông tin TK</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">0</span>
                                    <span class="kpi-unit">lỗi</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box" style="background:rgba(220,38,38,0.1);color:#dc2626;"><i class="bi bi-exclamation-octagon"></i></div>
                        </div>
                        <div class="kpi-footer">
                            <span class="badge bg-success-subtle text-success fw-semibold">0 lệnh lỗi</span>
                            <span class="text-muted">chuẩn hóa Napas 100%</span>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Payment Table --%>
            <div class="table-custom-container mb-4">
                <div class="p-3 border-bottom d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div>
                        <h2 class="h6 fw-bold mb-0 text-dark">Danh sách lệnh chi lương kỳ Tháng ${selectedMonth}/${selectedYear}</h2>
                        <span class="text-muted small">Cập nhật thời gian thực từ cổng ngân hàng • Tổng: <strong>${totalCount}</strong> lệnh</span>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th style="width:40px;" class="text-center">
                                    <input type="checkbox" class="form-check-input" id="checkAll">
                                </th>
                                <th>MÃ LỆNH</th>
                                <th>NGƯỜI NHẬN &amp; PHÒNG BAN</th>
                                <th class="text-end">SỐ TIỀN THỰC NHẬN</th>
                                <th>NỘI DUNG CHUYỂN KHOẢN</th>
                                <th class="text-center">TRẠNG THÁI</th>
                                <th class="text-center pe-4">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty payrollList}">
                                    <c:forEach var="pr" items="${payrollList}" varStatus="st">
                                        <c:set var="txCode" value="TX-${pr.payYear}${pr.payMonth < 10 ? '0' : ''}${pr.payMonth}-${pr.id < 100 ? '0' : ''}${pr.id < 10 ? '0' : ''}${pr.id}"/>
                                        <c:set var="initials" value="${not empty pr.employeeName ? fn:toUpperCase(fn:substring(pr.employeeName, 0, 2)) : 'NV'}"/>
                                        <tr>
                                            <td class="text-center">
                                                <input type="checkbox" class="form-check-input tx-check" value="${pr.id}">
                                            </td>
                                            <td class="fw-bold font-monospace text-primary" style="font-size:0.82rem;">
                                                <c:out value="${txCode}"/>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-initials-avatar"><c:out value="${initials}"/></div>
                                                    <div>
                                                        <div class="fw-bold text-dark"><c:out value="${pr.employeeName}"/></div>
                                                        <small class="text-muted">
                                                            Mã: <c:out value="${pr.employeeCode}"/>
                                                            <c:if test="${not empty pr.departmentName}"> • <c:out value="${pr.departmentName}"/></c:if>
                                                        </small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-end fw-bold text-dark font-monospace">
                                                <c:choose>
                                                    <c:when test="${not empty pr.netSalary}">
                                                        <fmt:formatNumber value="${pr.netSalary}" pattern="#,###"/> đ
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-muted font-monospace small">
                                                MIXIMOI chi luong T${pr.payMonth}-${pr.payYear}
                                                <c:out value="${pr.employeeCode}"/>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${pr.status eq 'PAID'}">
                                                        <span class="tx-status-badge tx-status-success">
                                                            <i class="bi bi-check-circle-fill"></i> Thành công
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pr.status eq 'APPROVED'}">
                                                        <span class="tx-status-badge" style="background:#eff6ff;color:#1d4ed8;border:1px solid #bfdbfe;">
                                                            <i class="bi bi-clock-history"></i> Sẵn sàng chi
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pr.status eq 'PENDING'}">
                                                        <span class="tx-status-badge tx-status-pending">
                                                            <i class="bi bi-hourglass-split"></i> Chờ duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="tx-status-badge" style="background:#f9fafb;color:#6b7280;border:1px solid #e5e7eb;">
                                                            <i class="bi bi-pencil-square"></i> Nháp
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center pe-4">
                                                <div class="d-flex gap-1 justify-content-center">
                                                    <a href="${pageContext.request.contextPath}/payslip?action=detail&id=${pr.id}"
                                                       class="btn btn-sm btn-outline-secondary py-1 px-2" title="Xem phiếu lương">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <c:if test="${pr.status eq 'APPROVED' and (sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT')}">
                                                        <form method="post" action="${pageContext.request.contextPath}/payment" class="m-0">
                                                            <input type="hidden" name="action" value="pay_single">
                                                            <input type="hidden" name="id" value="${pr.id}">
                                                            <input type="hidden" name="month" value="${selectedMonth}">
                                                            <input type="hidden" name="year" value="${selectedYear}">
                                                            <button type="submit" class="btn btn-sm btn-success py-1 px-2" title="Chi trả ngay"
                                                                    onclick="return confirm('Xác nhận chi trả cho ${pr.employeeName}?');">
                                                                <i class="bi bi-send-check"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                            Chưa có dữ liệu thanh toán kỳ T${selectedMonth}/${selectedYear}.<br>
                                            <small>Hãy tính lương và phê duyệt tại <a href="${pageContext.request.contextPath}/payroll">Quản lý bảng lương</a>.</small>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <%-- Sticky Bottom Action Bar --%>
                <div class="payment-sticky-bar d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <span class="fw-bold text-dark" style="font-size:0.9rem;">
                            Tổng tiền chi trả kỳ này:
                            <span class="text-primary fs-5 ms-1">
                                <c:choose>
                                    <c:when test="${not empty totalPayroll and totalPayroll > 0}">
                                        <fmt:formatNumber value="${totalPayroll}" type="number" groupingUsed="true"/> VNĐ
                                    </c:when>
                                    <c:otherwise>0 VNĐ</c:otherwise>
                                </c:choose>
                            </span>
                        </span>
                        <span class="text-muted small border-start ps-3">
                            PAID: <strong class="text-success">${countPaid}</strong> •
                            APPROVED: <strong class="text-primary">${countApproved}</strong> •
                            Chờ: <strong class="text-warning-emphasis">${countPending}</strong>
                        </span>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2"
                                onclick="alert('Đang xuất file UNC XML định dạng Napas...');">
                            <i class="bi bi-file-earmark-spreadsheet"></i>
                            <span>Xuất file UNC</span>
                        </button>
                        <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                            <form method="post" action="${pageContext.request.contextPath}/payment">
                                <input type="hidden" name="action" value="batch_disburse">
                                <input type="hidden" name="month" value="${selectedMonth}">
                                <input type="hidden" name="year" value="${selectedYear}">
                                <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm"
                                        onclick="return confirm('Bạn có chắc chắn muốn KÝ SỐ HSM và gửi tất cả lệnh chi sang Cổng Ngân hàng Napas không?');">
                                    <i class="bi bi-shield-lock-fill"></i>
                                    <span>Ký số HSM &amp; Gửi lệnh ngân hàng</span>
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    document.getElementById('checkAll')?.addEventListener('change', function() {
        document.querySelectorAll('.tx-check').forEach(cb => cb.checked = this.checked);
    });
</script>
</body>
</html>
