<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý danh mục & Mức phụ cấp — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="allowances" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Allowances Page Body -->
        <div class="app-content">
            
            <!-- Toast notification if success -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3 border-0 shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill text-success fs-5"></i>
                    <div>
                        <c:choose>
                            <c:when test="${param.success eq 'added'}">Đã thêm khoản phụ cấp nhân viên thành công!</c:when>
                            <c:when test="${param.success eq 'updated'}">Đã cập nhật trạng thái phụ cấp thành công!</c:when>
                            <c:when test="${param.success eq 'deleted'}">Đã xóa khoản phụ cấp thành công!</c:when>
                            <c:otherwise>Thao tác dữ liệu phụ cấp hoàn tất!</c:otherwise>
                        </c:choose>
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Page Header Area -->
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
                <div>
                    <h3 class="fw-extrabold text-dark mb-1 d-flex align-items-center gap-2" style="font-weight: 800; font-size: 1.65rem;">
                        <i class="bi bi-wallet2 text-primary"></i>
                        Quản lý danh mục & Mức phụ cấp
                    </h3>
                    <p class="text-muted mb-0" style="font-size: 0.84rem;">
                        Quản lý các danh mục phụ cấp cố định, phụ cấp theo chức danh, trợ cấp độc hại và các khoản hỗ trợ miễn thuế tuân thủ pháp luật thuế TNCN.
                    </p>
                </div>

                <!-- Action Toolbar -->
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <button type="button" class="btn-action-light" onclick="window.print();">
                        <i class="bi bi-printer"></i>
                        <span>In danh mục</span>
                    </button>

                    <button type="button" class="btn-action-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addAllowanceModal">
                        <i class="bi bi-plus-circle-fill"></i>
                        <span>Thêm phụ cấp mới</span>
                    </button>
                </div>
            </div>

            <!-- 4 Stat KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- Card 1: Tổng loại phụ cấp -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng loại phụ cấp</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">${totalAllowanceTypes > 0 ? totalAllowanceTypes : 4}</span>
                                    <span class="kpi-unit">danh mục đang cấu hình</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-collection-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.76rem;">
                                <i class="bi bi-check-circle text-success me-1"></i> Áp dụng toàn hệ thống
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Chi phụ cấp tháng này (T9) -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Tổng phụ cấp đang áp dụng</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">
                                        <fmt:formatNumber value="${totalAllowanceAmount}" pattern="#,###"/>
                                    </span>
                                    <span class="kpi-unit fw-bold">đ</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-cash-stack"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="trend-badge positive">
                                <i class="bi bi-check-circle-fill"></i> Hợp đồng
                            </span>
                            <span class="text-muted">Kỳ T${selectedMonth}/${selectedYear}</span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: Phụ cấp miễn thuế -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Khoản hỗ trợ miễn thuế</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">3</span>
                                    <span class="kpi-unit">khoản miễn thuế TNCN</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-shield-check"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span class="text-muted" style="font-size: 0.74rem;">Ăn trưa (730k), Xăng xe, Điện thoại</span>
                        </div>
                    </div>
                </div>

                <!-- Card 4: Nhân sự thụ hưởng -->
                <div class="col-xl-3 col-md-6">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">Nhân sự thụ hưởng</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-dark">${totalBenefited}</span>
                                    <span class="kpi-unit">nhân viên</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                        <div class="kpi-footer flex-column align-items-stretch gap-1 pt-2">
                            <div class="d-flex justify-content-between text-muted" style="font-size:0.75rem;">
                                <span>Phụ cấp kèm theo hợp đồng</span>
                                <span class="fw-bold text-primary">Hoạt động</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter & Search Bar -->
            <div class="dashboard-filter-card mb-4">
                <form method="get" action="${pageContext.request.contextPath}/allowances" class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex flex-wrap align-items-center gap-2 flex-grow-1">
                        <!-- Search input -->
                        <div class="position-relative" style="min-width: 260px;">
                            <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted" style="font-size: 0.85rem;"></i>
                            <input type="text" name="keyword" value="<c:out value='${param.keyword}'/>" class="form-control ps-5 py-2 bg-light border-0" placeholder="Tìm theo tên NV, mã NV, tên phụ cấp..." style="font-size: 0.82rem; border-radius: 10px;">
                        </div>

                        <!-- Department Filter -->
                        <select name="deptId" class="filter-select" onchange="this.form.submit()">
                            <option value="">Tất cả phòng ban</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.id}" ${param.deptId eq dept.id ? 'selected' : ''}>
                                    <c:out value="${dept.name}"/>
                                </option>
                            </c:forEach>
                        </select>

                        <button type="submit" class="btn btn-sm btn-primary px-3 rounded-3">
                            <i class="bi bi-filter"></i> Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/allowances" class="btn btn-sm btn-outline-secondary rounded-3" title="Đặt lại bộ lọc">
                            <i class="bi bi-arrow-clockwise"></i>
                        </a>
                    </div>
                </form>
            </div>

            <!-- Main Allowance Table -->
            <div class="table-custom-container mb-4">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>MÃ NV</th>
                                <th>HỌ TÊN NHÂN VIÊN</th>
                                <th>PHÒNG BAN</th>
                                <th>TÊN KHOẢN PHỤ CẤP</th>
                                <th class="text-end">MỨC PHỤ CẤP (VNĐ)</th>
                                <th class="text-center">NGÀY BẮT ĐẦU</th>
                                <th class="text-center">QUY CHẾ THUẾ</th>
                                <th class="text-center">TRẠNG THÁI</th>
                                <th class="text-end pe-4">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty allowanceList}">
                                    <c:forEach var="a" items="${allowanceList}">
                                        <tr>
                                            <td><span class="code-link"><c:out value="${a.employeeCode}"/></span></td>
                                            <td>
                                                <div class="fw-bold text-dark" style="font-size: 0.86rem;"><c:out value="${a.employeeName}"/></div>
                                            </td>
                                            <td>
                                                <span class="text-muted small"><c:out value="${not empty a.departmentName ? a.departmentName : '—'}"/></span>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark"><c:out value="${a.name}"/></div>
                                            </td>
                                            <td class="text-end font-monospace fw-bold text-primary">
                                                <fmt:formatNumber value="${a.amount}" pattern="#,###"/> đ
                                            </td>
                                            <td class="text-center text-muted small">
                                                <c:out value="${not empty a.startDate ? a.startDate : '01/01/2026'}"/>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${a.name.toLowerCase().contains('ăn trưa') or a.name.toLowerCase().contains('xăng xe') or a.name.toLowerCase().contains('điện thoại')}">
                                                        <span class="badge bg-success-subtle text-success border-0">Miễn thuế</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border-0">Chịu thuế TNCN</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${a.active ? 'bg-primary-subtle text-primary' : 'bg-secondary-subtle text-secondary'} border-0">
                                                    ${a.active ? 'Đang áp dụng' : 'Tạm dừng'}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="btn-group">
                                                    <form method="post" action="${pageContext.request.contextPath}/allowances" class="d-inline">
                                                        <input type="hidden" name="action" value="toggle">
                                                        <input type="hidden" name="id" value="${a.id}">
                                                        <button type="submit" class="btn btn-sm btn-light border-0" title="${a.active ? 'Tạm dừng' : 'Kích hoạt'}">
                                                            <i class="bi ${a.active ? 'bi-pause-circle text-warning' : 'bi-play-circle text-success'}"></i>
                                                        </button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/allowances" class="d-inline"
                                                          onsubmit="return confirm('Bạn có chắc chắn muốn xóa khoản phụ cấp này không?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${a.id}">
                                                        <button type="submit" class="btn btn-sm btn-light border-0 text-danger" title="Xóa">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            <i class="bi bi-wallet2 fs-2 d-block mb-2 text-primary opacity-50"></i>
                                            Chưa có khoản phụ cấp nào phù hợp bộ lọc.<br>
                                            <button type="button" class="btn btn-sm btn-primary mt-3 shadow-sm d-inline-flex align-items-center gap-1" data-bs-toggle="modal" data-bs-target="#addAllowanceModal">
                                                <i class="bi bi-plus-circle-fill"></i> Thêm phụ cấp mới
                                            </button>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Modal: Thêm Phụ cấp mới -->
<div class="modal fade" id="addAllowanceModal" tabindex="-1" aria-labelledby="addAllowanceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form method="post" action="${pageContext.request.contextPath}/allowances">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="addAllowanceModalLabel">
                        <i class="bi bi-plus-circle text-primary me-2"></i>Thêm Khoản Phụ Cấp Mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold" style="font-size:0.85rem;">Chọn nhân viên <span class="text-danger">*</span></label>
                        <select name="employeeId" class="form-select" required>
                            <option value="">-- Chọn nhân viên áp dụng --</option>
                            <c:forEach var="emp" items="${employees}">
                                <option value="${emp.id}">
                                    <c:out value="${emp.employeeCode}"/> — <c:out value="${emp.fullName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold" style="font-size:0.85rem;">Tên loại phụ cấp <span class="text-danger">*</span></label>
                        <input type="text" name="name" list="allowanceSuggestions" class="form-control" placeholder="Nhập hoặc chọn phụ cấp..." required>
                        <datalist id="allowanceSuggestions">
                            <option value="Phụ cấp ăn trưa">
                            <option value="Xăng xe & đi lại">
                            <option value="Điện thoại viễn thông">
                            <option value="Phụ cấp trách nhiệm quản lý">
                            <option value="Dự án kiêm nhiệm">
                            <option value="Phụ cấp thâm niên công tác">
                            <option value="Trợ cấp độc hại & môi trường">
                        </datalist>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold" style="font-size:0.85rem;">Số tiền phụ cấp (VNĐ) <span class="text-danger">*</span></label>
                        <input type="number" name="amount" class="form-control" placeholder="Ví dụ: 730000" min="10000" step="10000" required>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold" style="font-size:0.85rem;">Ngày bắt đầu</label>
                            <input type="date" name="startDate" class="form-control" value="2026-09-01">
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold" style="font-size:0.85rem;">Ngày kết thúc (tùy chọn)</label>
                            <input type="date" name="endDate" class="form-control">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary px-4">Lưu phụ cấp</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
