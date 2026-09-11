<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý chấm công — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="attendance" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Attendance Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Quick Check-in -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-clock-history text-primary"></i> Nhật ký chấm công hàng ngày
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Chấm công tháng ${selectedMonth}/${selectedYear}</li>
                        </ol>
                    </nav>
                </div>
                
                <!-- Quick Checkin / Checkout Buttons -->
                <div class="d-flex align-items-center gap-2">
                    <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline">
                        <input type="hidden" name="action" value="checkin">
                        <button type="submit" class="btn btn-success fw-semibold px-3 py-2 shadow-sm d-flex align-items-center gap-2">
                            <i class="bi bi-box-arrow-in-right"></i> Check-in Hôm nay
                        </button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline">
                        <input type="hidden" name="action" value="checkout">
                        <button type="submit" class="btn btn-outline-danger fw-semibold px-3 py-2 shadow-sm d-flex align-items-center gap-2">
                            <i class="bi bi-box-arrow-right"></i> Check-out Ra về
                        </button>
                    </form>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'checkin'}">Ghi nhận Check-in thành công! Chúc bạn một ngày làm việc hiệu quả.</c:when>
                        <c:when test="${param.success eq 'checkout'}">Ghi nhận Check-out thành công! Cảm ơn bạn.</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Month/Year Filter Card -->
            <div class="app-card mb-4">
                <form method="get" action="${pageContext.request.contextPath}/attendance" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold text-muted mb-1" style="font-size:0.8rem">CHỌN THÁNG</label>
                        <select class="form-select bg-light" name="month">
                            <c:forEach var="m" begin="1" end="12">
                                <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold text-muted mb-1" style="font-size:0.8rem">CHỌN NĂM</label>
                        <select class="form-select bg-light" name="year">
                            <option value="2025" ${selectedYear == 2025 ? 'selected' : ''}>2025</option>
                            <option value="2026" ${selectedYear == 2026 ? 'selected' : ''}>2026</option>
                            <option value="2027" ${selectedYear == 2027 ? 'selected' : ''}>2027</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn-action-primary border-0 w-100 justify-content-center">
                            <i class="bi bi-filter"></i> Xem dữ liệu chấm công
                        </button>
                    </div>
                </form>
            </div>

            <!-- Attendance Data Table -->
            <div class="table-custom-container">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Ngày làm việc</th>
                                <th>Nhân viên</th>
                                <th>Giờ vào (Check-in)</th>
                                <th>Giờ ra (Check-out)</th>
                                <th class="text-center">Số giờ làm</th>
                                <th class="text-center">Trạng thái</th>
                                <th>Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty attendances}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-5">
                                            <i class="bi bi-clock-history fs-1 d-block mb-2 text-secondary"></i>
                                            Chưa có dữ liệu chấm công trong tháng ${selectedMonth}/${selectedYear}.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="att" items="${attendances}">
                                        <tr>
                                            <td>
                                                <span class="fw-bold text-dark font-monospace">${att.workDate}</span>
                                            </td>
                                            <td>
                                                <div class="table-user-cell">
                                                    <div class="table-user-avatar">
                                                        ${att.employeeName != null ? att.employeeName.substring(0, 1).toUpperCase() : 'NV'}
                                                    </div>
                                                    <div>
                                                        <div class="table-user-name">${att.employeeName}</div>
                                                        <div class="table-user-email">${att.employeeCode}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border font-monospace px-2 py-1">
                                                    <i class="bi bi-box-arrow-in-right text-success me-1"></i> ${att.checkIn != null ? att.checkIn : '--:--'}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border font-monospace px-2 py-1">
                                                    <i class="bi bi-box-arrow-right text-danger me-1"></i> ${att.checkOut != null ? att.checkOut : '--:--'}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="fw-bold text-primary">${att.totalHours}</span> <span class="text-muted" style="font-size:0.75rem">giờ</span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${att.status eq 'ON_TIME'}">
                                                        <span class="status-pill active">
                                                            <i class="bi bi-check-circle-fill"></i> Đúng giờ
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${att.status eq 'LATE'}">
                                                        <span class="status-pill expiring">
                                                            <i class="bi bi-exclamation-circle-fill"></i> Đi muộn
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${att.status eq 'EARLY_LEAVE'}">
                                                        <span class="status-pill pending">
                                                            <i class="bi bi-dash-circle"></i> Về sớm
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill inactive">
                                                            <i class="bi bi-x-circle-fill"></i> Vắng mặt
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="text-muted" style="font-size:0.82rem">${att.notes != null ? att.notes : '—'}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${not empty attendances}">
                    <div class="px-4 py-3 bg-white border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem">
                        <span class="text-muted">Tổng cộng <strong>${attendances.size()}</strong> lượt chấm công</span>
                        <div class="text-muted">MIXIMOI Smart Timekeeping</div>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
