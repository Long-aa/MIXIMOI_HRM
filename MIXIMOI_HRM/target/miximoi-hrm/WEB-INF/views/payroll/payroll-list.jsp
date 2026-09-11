<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Bảng tính lương — MIXIMOI HRM & PAYROLL</title>
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

        <!-- Payroll Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Action -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-cash-coin text-primary"></i> Quản lý bảng lương nhân viên
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Bảng lương tháng ${selectedMonth}/${selectedYear}</li>
                        </ol>
                    </nav>
                </div>

                <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                    <form method="post" action="${pageContext.request.contextPath}/payroll" class="d-inline"
                          onsubmit="return confirm('Hệ thống sẽ tự động tính toán lương tháng ${selectedMonth}/${selectedYear} cho toàn bộ nhân viên. Tiếp tục?');">
                        <input type="hidden" name="action" value="calculate">
                        <input type="hidden" name="month" value="${selectedMonth}">
                        <input type="hidden" name="year" value="${selectedYear}">
                        <button type="submit" class="btn-action-primary border-0">
                            <i class="bi bi-calculator"></i> Tự động tính lương kỳ này
                        </button>
                    </form>
                </c:if>
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

            <!-- Filter Month/Year -->
            <div class="app-card mb-4">
                <form method="get" action="${pageContext.request.contextPath}/payroll" class="row g-3 align-items-end">
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
                            <i class="bi bi-funnel"></i> Lọc dữ liệu
                        </button>
                    </div>
                </form>
            </div>

            <!-- Table Card -->
            <div class="table-custom-container">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Nhân viên</th>
                                <th>Phòng ban</th>
                                <th class="text-center">Ngày công</th>
                                <th class="text-end">Lương cơ bản</th>
                                <th class="text-end">Phụ cấp + Thưởng</th>
                                <th class="text-end">Khấu trừ</th>
                                <th class="text-end">Thực nhận (Net)</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty payrollList}">
                                    <tr>
                                        <td colspan="9" class="text-center text-muted py-5">
                                            <i class="bi bi-wallet2 fs-1 d-block mb-2 text-secondary"></i>
                                            Chưa có dữ liệu bảng lương tháng ${selectedMonth}/${selectedYear}. 
                                            <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                                                <br>Nhấn nút <strong>"Tự động tính lương kỳ này"</strong> ở trên để khởi tạo.
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="pr" items="${payrollList}">
                                        <tr>
                                            <td>
                                                <div class="table-user-cell">
                                                    <div class="table-user-avatar">
                                                        ${pr.fullName != null ? pr.fullName.substring(0, 1).toUpperCase() : 'NV'}
                                                    </div>
                                                    <div>
                                                        <div class="table-user-name">${pr.fullName}</div>
                                                        <div class="table-user-email">${pr.employeeCode}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="fw-medium">${pr.departmentName}</span>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border font-monospace px-2 py-1">
                                                    ${pr.workingDays} công
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <span class="font-monospace text-muted">
                                                    <fmt:formatNumber value="${pr.baseSalary}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <span class="font-monospace text-success">
                                                    +<fmt:formatNumber value="${pr.allowance + pr.bonus + pr.overtimePay}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <span class="font-monospace text-danger">
                                                    -<fmt:formatNumber value="${pr.deductions}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <span class="fw-bold text-primary font-monospace fs-6">
                                                    <fmt:formatNumber value="${pr.netSalary}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${pr.status eq 'PAID'}">
                                                        <span class="status-pill approved">
                                                            <i class="bi bi-check-circle-fill"></i> Đã chi trả
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pr.status eq 'APPROVED'}">
                                                        <span class="status-pill active">
                                                            <i class="bi bi-check-all"></i> Đã duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill pending">
                                                            <i class="bi bi-hourglass-split"></i> Bản nháp
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="btn-group btn-group-sm">
                                                    <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                                                        <c:if test="${pr.status eq 'DRAFT'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/payroll" class="d-inline">
                                                                <input type="hidden" name="action" value="approve">
                                                                <input type="hidden" name="id" value="${pr.id}">
                                                                <button type="submit" class="btn btn-light border text-primary" title="Duyệt bảng lương">
                                                                    <i class="bi bi-check-lg"></i> Duyệt
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${pr.status eq 'APPROVED'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/payroll" class="d-inline">
                                                                <input type="hidden" name="action" value="pay">
                                                                <input type="hidden" name="id" value="${pr.id}">
                                                                <button type="submit" class="btn btn-light border text-success" title="Xác nhận thanh toán lương">
                                                                    <i class="bi bi-cash-stack"></i> Chi lương
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${not empty payrollList}">
                    <div class="px-4 py-3 bg-white border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem">
                        <span class="text-muted">Tổng cộng <strong>${payrollList.size()}</strong> phiếu lương</span>
                        <div class="text-muted">MIXIMOI Automated Payroll Engine</div>
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
