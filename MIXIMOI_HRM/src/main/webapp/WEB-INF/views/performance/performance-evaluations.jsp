<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Đánh giá Hiệu suất Nhân sự - MIXIMOI HRM" />
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
            <c:if test="${param.success eq 'auto_calculated'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3 shadow-sm" role="alert">
                    <i class="bi bi-cpu-fill fs-5 text-success"></i>
                    <div>Đã chạy thành công <strong>Thuật toán phân tích hiệu suất CSDL</strong> cho ${param.count} nhân sự (Đồng bộ từ tỷ lệ chấm công chuyên cần & chỉ tiêu KPI thực tế)!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'confirmed'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div>Đã lưu và xác nhận kết quả thẩm định hiệu suất thành công!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Đánh giá hiệu suất</h1>
                        <span class="badge bg-primary-subtle text-primary fw-bold">
                            <span class="badge-dot-indicator bg-primary"></span>Kỳ ${not empty param.quarter ? param.quarter : 'Q3/2026'} đang mở
                        </span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý chu kỳ đánh giá, phân tích thuật toán chuyên cần & KPI và thẩm định kết quả nhân sự theo Ngày - Tháng - Năm.
                    </p>
                </div>
                <div class="d-flex gap-2 flex-wrap">
                    <form method="post" action="${pageContext.request.contextPath}/evaluations" class="d-inline">
                        <input type="hidden" name="action" value="auto_calculate">
                        <input type="hidden" name="quarter" value="${not empty param.quarter ? param.quarter : 'Q3/2026'}">
                        <button type="submit" class="btn btn-warning text-dark fw-bold d-flex align-items-center gap-2 shadow-sm" title="Quét dữ liệu chấm công và chỉ tiêu từ CSDL để tính điểm tự động">
                            <i class="bi bi-lightning-charge-fill"></i>
                            <span>Thuật toán tính tự động</span>
                        </button>
                    </form>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="window.print()">
                        <i class="bi bi-printer"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createEvaluationCycleModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>Tạo đợt đánh giá</span>
                    </button>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Tổng nhân viên cần đánh giá</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${totalEmployees}</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">nhân sự</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-light text-dark border">Phân bổ ${departments.size()} phòng ban</span>
                            <span class="text-muted small">100% mục tiêu</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã hoàn tất đánh giá</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-check2-circle"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">${completedCount}</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">/ ${totalEmployees}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-success-subtle text-success fw-semibold">
                                ↗ <fmt:formatNumber value="${totalEmployees > 0 ? (completedCount * 100.0 / totalEmployees) : 0}" maxFractionDigits="1"/>% hoàn thành
                            </span>
                            <span class="text-muted small">kỳ Q3/2026</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Chưa / Đang đánh giá</span>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-clock-history"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-primary fw-bold" style="font-size: 1.85rem;">${pendingCount}</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">hồ sơ chờ</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-danger-subtle text-danger fw-semibold">⚠ Hạn chót: 30/09</span>
                            <span class="text-muted small">Cần nhắc nhở</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Điểm trung bình toàn công ty</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-award"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-purple fw-bold" style="font-size: 1.85rem; color: #7c3aed;">${avgScore}</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">/ 10</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-primary-subtle text-primary fw-semibold">Xếp loại Tốt</span>
                            <span class="badge bg-success-subtle text-success">Đạt chuẩn</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <form method="get" action="${pageContext.request.contextPath}/evaluations" class="row g-2 align-items-center">
                        <div class="col-12 col-md-3">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" name="search" class="form-control border-start-0" placeholder="Tìm tên nhân viên, mã NV..." value="${param.search}">
                            </div>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="quarter" class="form-select form-select-sm" onchange="this.form.submit()">
                                <optgroup label="Theo Quý (Quarterly)">
                                    <option value="Q3/2026" ${param.quarter eq 'Q3/2026' or empty param.quarter ? 'selected' : ''}>Kỳ: Quý 3/2026</option>
                                    <option value="Q2/2026" ${param.quarter eq 'Q2/2026' ? 'selected' : ''}>Kỳ: Quý 2/2026</option>
                                    <option value="Q1/2026" ${param.quarter eq 'Q1/2026' ? 'selected' : ''}>Kỳ: Quý 1/2026</option>
                                </optgroup>
                                <optgroup label="Theo Tháng (Monthly)">
                                    <option value="T09/2026" ${param.quarter eq 'T09/2026' ? 'selected' : ''}>Kỳ: Tháng 09/2026</option>
                                    <option value="T08/2026" ${param.quarter eq 'T08/2026' ? 'selected' : ''}>Kỳ: Tháng 08/2026</option>
                                    <option value="T07/2026" ${param.quarter eq 'T07/2026' ? 'selected' : ''}>Kỳ: Tháng 07/2026</option>
                                </optgroup>
                                <optgroup label="Theo Năm (Yearly)">
                                    <option value="Y2026" ${param.quarter eq 'Y2026' ? 'selected' : ''}>Kỳ: Năm 2026</option>
                                    <option value="Y2025" ${param.quarter eq 'Y2025' ? 'selected' : ''}>Kỳ: Năm 2025</option>
                                </optgroup>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select name="deptId" class="form-select form-select-sm" onchange="this.form.submit()">
                                <option value="">Tất cả phòng ban (${departments.size()})</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" ${param.deptId eq dept.id ? 'selected' : ''}>${dept.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                <option value="" ${empty param.status ? 'selected' : ''}>Tất cả trạng thái</option>
                                <option value="CONFIRMED" ${param.status eq 'CONFIRMED' ? 'selected' : ''}>Đã thẩm định</option>
                                <option value="SUBMITTED" ${param.status eq 'SUBMITTED' ? 'selected' : ''}>Chờ duyệt</option>
                                <option value="DRAFT" ${param.status eq 'DRAFT' ? 'selected' : ''}>Đang đánh giá</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-1 d-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/evaluations" class="btn btn-sm btn-outline-secondary w-100" title="Tải lại"><i class="bi bi-arrow-repeat"></i></a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Two-Column Layout: Employee Evaluation List + Evaluation Inspector Drawer -->
            <div class="row g-4">
                <!-- Col-7: Employee Evaluation Table -->
                <div class="col-12 col-xl-7">
                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                        <div class="card-header bg-white border-bottom py-3 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                            <div>
                                <h2 class="h6 fw-bold mb-0 text-dark">Danh sách nhân viên đánh giá</h2>
                                <span class="text-muted small">Hiển thị ${evaluations.size()} hồ sơ đợt Q3/2026</span>
                            </div>

                            <ul class="nav nav-pills payment-batch-tabs">
                                <li class="nav-item"><a class="nav-link active py-1 px-2" href="#">Tất cả (${evaluations.size()})</a></li>
                            </ul>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3" style="width: 35px;"><input class="form-check-input" type="checkbox"></th>
                                        <th>Nhân viên</th>
                                        <th>Phòng ban</th>
                                        <th>Người đánh giá</th>
                                        <th class="text-center">KPI (40%)</th>
                                        <th class="pe-3 text-center">Tổng hợp</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty evaluations}">
                                            <c:forEach var="ev" items="${evaluations}" varStatus="st">
                                                <tr class="${st.first ? 'table-primary bg-opacity-25' : ''}" style="cursor: pointer;"
                                                    onclick="selectEval('${ev.evaluationCode}', '${ev.employeeId}', '${ev.employeeName}', '${ev.positionName}', '${ev.departmentName}', '${ev.finalScore}', '${ev.gradeDisplayName}', '${ev.kpiScore}', '${ev.competencyScore}', '${ev.cultureScore}', '${ev.innovationScore}')">
                                                    <td class="ps-3"><input class="form-check-input" type="checkbox" ${st.first ? 'checked' : ''}></td>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar-circle bg-primary text-white fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem;">
                                                                ${ev.employeeName != null && ev.employeeName.length() > 0 ? ev.employeeName.substring(0, 1).toUpperCase() : 'U'}
                                                            </div>
                                                            <div>
                                                                <div class="fw-bold text-dark">${ev.employeeName}</div>
                                                                <small class="text-muted">${ev.employeeCode} • ${ev.positionName}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge bg-light text-dark border">${ev.departmentName}</span></td>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-1">
                                                            <i class="bi bi-person-check text-muted"></i>
                                                            <span>${ev.evaluatorName != null ? ev.evaluatorName : 'Chưa gán'}</span>
                                                        </div>
                                                    </td>
                                                    <td class="text-center font-monospace fw-bold text-primary">${ev.kpiScore}</td>
                                                    <td class="pe-3 text-center font-monospace fw-bold text-dark">
                                                        <span class="badge ${ev.gradeBadgeClass}">${ev.finalScore} (${ev.grade})</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center py-4 text-muted">
                                                    <i class="bi bi-inbox fs-3 d-block mb-1"></i>
                                                    Không có hồ sơ đánh giá nào trong bộ lọc.
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <div class="card-footer bg-white border-top py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                            <span class="text-muted small">Hiển thị <strong>${evaluations.size()}</strong> nhân viên</span>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Col-5: Evaluation Inspector Drawer (Lê Hoàng Nam) -->
                <div class="col-12 col-xl-5">
                    <div class="eval-inspector-drawer">
                        <!-- Drawer Header -->
                        <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="position-relative">
                                    <div class="avatar-circle bg-primary text-white fw-bold" style="width: 48px; height: 48px; font-size: 1.1rem;">LN</div>
                                    <span class="position-absolute bottom-0 end-0 bg-success text-white rounded-circle p-1" style="font-size: 0.6rem;"><i class="bi bi-check-lg"></i></span>
                                </div>
                                <div>
                                    <div class="d-flex align-items-center gap-2">
                                        <h3 class="h6 fw-bold text-dark mb-0">Lê Hoàng Nam</h3>
                                        <i class="bi bi-patch-check-fill text-primary" style="font-size: 0.85rem;"></i>
                                    </div>
                                    <div class="text-muted small">Senior Tech Lead - Ban CNTT & R&D</div>
                                    <div class="text-muted small font-monospace">Mã: NV-IT-042 • Đợt: Q3/2026</div>
                                </div>
                            </div>
                            <a href="#" class="text-muted"><i class="bi bi-box-arrow-up-right fs-6"></i></a>
                        </div>

                        <!-- Overall Score Summary Box -->
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <div class="p-2 px-3 border rounded-3 bg-light">
                                    <small class="text-muted text-uppercase fw-bold d-block" style="font-size: 0.68rem;">ĐIỂM THẨM ĐỊNH CHUNG</small>
                                    <div class="d-flex align-items-baseline gap-1">
                                        <strong class="text-primary fs-3 fw-bold">8.96</strong>
                                        <span class="text-muted small">/ 10.0</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 px-3 border rounded-3 bg-purple-subtle bg-opacity-25 border-purple-subtle" style="background: #faf5ff;">
                                    <small class="text-muted text-uppercase fw-bold d-block" style="font-size: 0.68rem;">XẾP LOẠI KỲ</small>
                                    <div class="badge bg-purple-subtle text-purple fs-6 fw-bold mt-1" style="background: #f3e8ff; color: #7e22ce;">
                                        Xuất sắc (Hạng A+)
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Weight Breakdown Items -->
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold text-dark small text-uppercase" style="font-size: 0.76rem;">CƠ CẤU TRỌNG SỐ ĐÁNH GIÁ</span>
                            <span class="badge bg-light text-primary border" style="font-size: 0.7rem;">Quy chuẩn 100%</span>
                        </div>

                        <!-- Item 1: KPI -->
                        <div class="eval-weight-item">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark" style="font-size: 0.8rem;">1. KPI công việc (Trọng số 40%)</span>
                                <span class="text-primary fw-bold font-monospace" style="font-size: 0.82rem;">9.4 / 10 ➔ 3.76đ</span>
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 94%;"></div>
                            </div>
                            <small class="text-muted d-block" style="font-size: 0.72rem;">Hoàn thành 102% chỉ tiêu microservices, tỷ lệ uptime hệ thống đạt 99.98% SLA.</small>
                        </div>

                        <!-- Item 2: Competency -->
                        <div class="eval-weight-item">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark" style="font-size: 0.8rem;">2. Năng lực chuyên môn (Trọng số 30%)</span>
                                <span class="text-primary fw-bold font-monospace" style="font-size: 0.82rem;">8.8 / 10 ➔ 2.64đ</span>
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 88%;"></div>
                            </div>
                            <small class="text-muted d-block" style="font-size: 0.72rem;">Năng lực thiết kế kiến trúc hệ thống phân tán, xử lý sự cố P1 & code review nghiêm ngặt.</small>
                        </div>

                        <!-- Item 3: Culture -->
                        <div class="eval-weight-item">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark" style="font-size: 0.8rem;">3. Thái độ & Văn hóa (Trọng số 20%)</span>
                                <span class="text-primary fw-bold font-monospace" style="font-size: 0.82rem;">9.0 / 10 ➔ 1.80đ</span>
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 90%;"></div>
                            </div>
                            <small class="text-muted d-block" style="font-size: 0.72rem;">Tính chủ động cao, phối hợp liên phòng ban mượt mà, văn hóa phản hồi tích cực.</small>
                        </div>

                        <!-- Item 4: Innovation -->
                        <div class="eval-weight-item">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark" style="font-size: 0.8rem;">4. Đóng góp đổi mới (Trọng số 10%)</span>
                                <span class="text-primary fw-bold font-monospace" style="font-size: 0.82rem;">7.6 / 10 ➔ 0.76đ</span>
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div class="progress-bar bg-primary" style="width: 76%;"></div>
                            </div>
                            <small class="text-muted d-block" style="font-size: 0.72rem;">Kèm cặp tốt 2 Junior Developers và khởi xướng tối ưu tiết kiệm 14% tài nguyên AWS.</small>
                        </div>

                        <!-- Radar Chart Representation -->
                        <div class="eval-radar-box">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="small fw-bold text-dark text-uppercase">BIỂU ĐỒ RADAR NĂNG LỰC 4 CHIỀU</span>
                                <span class="badge bg-success-subtle text-success">Cân bằng vượt trội</span>
                            </div>
                            <div class="d-flex justify-content-around text-center mt-2" style="font-size: 0.72rem;">
                                <div>
                                    <div class="text-muted">KPI</div>
                                    <strong class="text-primary">9.4</strong>
                                </div>
                                <div>
                                    <div class="text-muted">Kỹ thuật</div>
                                    <strong class="text-primary">8.8</strong>
                                </div>
                                <div>
                                    <div class="text-muted">Văn hóa</div>
                                    <strong class="text-primary">9.0</strong>
                                </div>
                                <div>
                                    <div class="text-muted">Đổi mới</div>
                                    <strong class="text-primary">7.6</strong>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <form method="post" action="${pageContext.request.contextPath}/evaluations" class="m-0">
                                <input type="hidden" name="action" value="draft">
                                <input type="hidden" name="evalCode" class="drawerEvalCodeInput" value="EVAL-Q3-042">
                                <input type="hidden" name="employeeId" class="drawerEmpIdInput" value="4">
                                <button type="submit" class="btn btn-outline-secondary btn-sm">Lưu nháp</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/evaluations" class="m-0 flex-grow-1">
                                <input type="hidden" name="action" value="submit">
                                <input type="hidden" name="evalCode" class="drawerEvalCodeInput" value="EVAL-Q3-042">
                                <input type="hidden" name="employeeId" class="drawerEmpIdInput" value="4">
                                <button type="submit" class="btn btn-outline-primary btn-sm w-100">Gửi đánh giá</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/evaluations" class="m-0 flex-grow-1">
                                <input type="hidden" name="action" value="confirm">
                                <input type="hidden" name="evalCode" class="drawerEvalCodeInput" value="EVAL-Q3-042">
                                <input type="hidden" name="employeeId" class="drawerEmpIdInput" value="4">
                                <button type="submit" class="btn btn-primary btn-sm w-100 shadow-sm d-flex align-items-center justify-content-center gap-1">
                                    <i class="bi bi-check2-circle"></i> Xác nhận
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script>
function selectEval(code, empId, name, pos, dept, score, gradeName, kpi, comp, cult, inno) {
    document.querySelectorAll('.drawerEvalCodeInput').forEach(el => el.value = code);
    document.querySelectorAll('.drawerEmpIdInput').forEach(el => el.value = empId);

    const nameEl = document.querySelector('.eval-inspector-drawer h3');
    if (nameEl) nameEl.textContent = name;
    const scoreEl = document.querySelector('.eval-inspector-drawer strong.fs-3');
    if (scoreEl) scoreEl.textContent = score;
    const gradeBadge = document.querySelector('.eval-inspector-drawer .badge.bg-purple-subtle');
    if (gradeBadge) gradeBadge.textContent = gradeName;
}
</script>
</body>
</html>
