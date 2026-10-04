<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Quản lý Kỷ luật & Xử lý vi phạm - MIXIMOI HRM" />
    </jsp:include>
</head>
<body class="hrm-app-body">
<div class="app-layout">
    <!-- Sidebar Navigation -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <div class="app-main">
        <!-- Topbar Header -->
        <jsp:include page="/WEB-INF/views/common/topbar.jsp" />

        <!-- Main Content Area -->
        <main class="app-content p-3 p-lg-4">
            <!-- Toast notification if action done -->
            <c:if test="${param.success eq 'report_created'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div>Đã lập biên bản vi phạm mới thành công và phân công chuyên viên thụ lý!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'step_updated'}">
                <div class="alert alert-info alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-arrow-repeat fs-5 text-info"></i>
                    <div>Đã cập nhật bước tiến trình xử lý kỷ luật thành công!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'deleted'}">
                <div class="alert alert-warning alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-trash-fill fs-5 text-warning"></i>
                    <div>Đã xóa hồ sơ vi phạm thành công khỏi hệ thống!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <h1 class="h3 fw-bold text-dark mb-1">Quản lý kỷ luật & Xử lý vi phạm</h1>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Theo dõi, giải quyết các vụ việc vi phạm nội quy, quy chế lao động và ban hành quyết định kỷ luật nhân sự bảo đảm tính chuẩn tắc, khách quan theo Bộ luật Lao động.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="window.print()">
                        <i class="bi bi-printer"></i>
                        <span>Xuất báo cáo</span>
                    </button>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#guidelineModal">
                        <i class="bi bi-journal-text"></i>
                        <span>Quy chế & Biểu mẫu</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createViolationModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>Tạo biên bản vi phạm</span>
                    </button>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Vụ việc trong năm</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-hammer"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${stats['total'] != null ? stats['total'] : 0}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Toàn bộ vụ việc ghi nhận</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold" style="font-size: 0.73rem;">Hồ sơ DB thực</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang xử lý</span>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-arrow-repeat"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-primary fw-bold" style="font-size: 1.85rem;">${stats['in_progress'] != null ? stats['in_progress'] : 0}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Xác minh & Điều tra</span>
                            <span class="badge bg-info-subtle text-info fw-semibold" style="font-size: 0.73rem;">Đang tiến hành</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Chờ quyết định</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-clipboard2-check"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-purple fw-bold" style="font-size: 1.85rem; color: #7c3aed;">${stats['waiting_decision'] != null ? stats['waiting_decision'] : 0}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Chờ họp hội đồng</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold" style="font-size: 0.73rem;">Ưu tiên xử lý</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã giải quyết</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-check-circle-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">${stats['resolved'] != null ? stats['resolved'] : 0}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Đã ban hành quyết định</span>
                            <span class="badge bg-success-subtle text-success fw-semibold" style="font-size: 0.73rem;">Hoàn tất</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Standard Discipline 5-Step Stepper -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-header bg-white border-bottom py-3 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-diagram-3-fill text-primary"></i>
                        <span class="fw-bold text-dark">Quy trình xử lý kỷ luật tiêu chuẩn</span>
                    </div>
                    <span class="badge bg-light text-dark border d-inline-flex align-items-center gap-1">
                        <i class="bi bi-shield-check text-primary"></i>
                        Tuân thủ SLA tối đa 15 ngày làm việc (Nghị định 145/2020/NĐ-CP)
                    </span>
                </div>
                <div class="card-body p-3">
                    <div class="discipline-stepper-container">
                        <!-- Step 1 -->
                        <div class="discipline-step-card completed">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-primary">BƯỚC 01</span>
                                <i class="bi bi-check-circle-fill text-primary"></i>
                            </div>
                            <div class="discipline-step-title">Tạo biên bản</div>
                            <div class="discipline-step-desc">Lập hồ sơ & ghi nhận tang chứng</div>
                        </div>

                        <!-- Step 2 -->
                        <div class="discipline-step-card active">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-primary">BƯỚC 02</span>
                                <span class="badge-dot-indicator bg-primary"></span>
                            </div>
                            <div class="discipline-step-title text-primary">Xác minh vi phạm</div>
                            <div class="discipline-step-desc">Giải trình & thu thập đối chiếu</div>
                        </div>

                        <!-- Step 3 -->
                        <div class="discipline-step-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-muted">BƯỚC 03</span>
                                <i class="bi bi-clock text-muted"></i>
                            </div>
                            <div class="discipline-step-title">Họp hội đồng</div>
                            <div class="discipline-step-desc">Họp xem xét hình thức kỷ luật</div>
                        </div>

                        <!-- Step 4 -->
                        <div class="discipline-step-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-muted">BƯỚC 04</span>
                                <i class="bi bi-file-earmark-text text-muted"></i>
                            </div>
                            <div class="discipline-step-title">Ra quyết định</div>
                            <div class="discipline-step-desc">Ký duyệt & tống đạt văn bản</div>
                        </div>

                        <!-- Step 5 -->
                        <div class="discipline-step-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="discipline-step-badge text-muted">BƯỚC 05</span>
                                <i class="bi bi-archive text-muted"></i>
                            </div>
                            <div class="discipline-step-title">Đóng vụ việc</div>
                            <div class="discipline-step-desc">Lưu hồ sơ & trích trừ bảng lương</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <form method="get" action="${pageContext.request.contextPath}/disciplines" class="row g-2 align-items-center">
                        <div class="col-12 col-md-4">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" name="keyword" class="form-control border-start-0" placeholder="Tìm kiếm theo mã vụ việc, họ tên nhân viên..." value="${param.keyword}">
                            </div>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="dept" class="form-select form-select-sm">
                                <option value="">Tất cả phòng ban</option>
                                <option value="IT" ${param.dept eq 'IT' ? 'selected' : ''}>CNTT & R&D</option>
                                <option value="Sales" ${param.dept eq 'Sales' ? 'selected' : ''}>Kinh doanh</option>
                                <option value="Ops" ${param.dept eq 'Ops' ? 'selected' : ''}>Vận hành</option>
                                <option value="Mkt" ${param.dept eq 'Mkt' ? 'selected' : ''}>Marketing</option>
                                <option value="Fin" ${param.dept eq 'Fin' ? 'selected' : ''}>Tài chính</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="severity" class="form-select form-select-sm">
                                <option value="">Mức độ: Tất cả</option>
                                <option value="high" ${param.severity eq 'high' ? 'selected' : ''}>Nghiêm trọng</option>
                                <option value="medium" ${param.severity eq 'medium' ? 'selected' : ''}>Trung bình</option>
                                <option value="low" ${param.severity eq 'low' ? 'selected' : ''}>Nhẹ</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="status" class="form-select form-select-sm">
                                <option value="">Trạng thái: Tất cả</option>
                                <option value="pending" ${param.status eq 'pending' ? 'selected' : ''}>Chờ quyết định</option>
                                <option value="investigating" ${param.status eq 'investigating' ? 'selected' : ''}>Đang xác minh</option>
                                <option value="resolved" ${param.status eq 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                                <option value="closed" ${param.status eq 'closed' ? 'selected' : ''}>Đã đóng</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-sm btn-primary w-100">Áp dụng</button>
                            <a href="${pageContext.request.contextPath}/disciplines" class="btn btn-sm btn-outline-secondary">Đặt lại</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Violations Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center gap-2">
                        <h2 class="h6 fw-bold mb-0 text-dark">Danh sách hồ sơ vi phạm</h2>
                        <span class="badge bg-light text-primary border">${totalRecords} hồ sơ</span>
                    </div>
                    <span class="text-muted small">Cơ sở dữ liệu: <strong>PostgreSQL Thực tế</strong></span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3" style="width: 40px;"><input class="form-check-input" type="checkbox"></th>
                                <th style="width: 120px;">Mã vụ việc</th>
                                <th>Nhân viên</th>
                                <th>Phòng ban</th>
                                <th>Ngày vi phạm</th>
                                <th>Hành vi vi phạm</th>
                                <th class="text-center">Mức độ</th>
                                <th>Hình thức đề xuất / Quyết định</th>
                                <th>Người thụ lý</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty disciplines}">
                                    <tr>
                                        <td colspan="11" class="text-center py-5 text-muted">
                                            <i class="bi bi-shield-check fs-1 text-success d-block mb-2"></i>
                                            <span>Không tìm thấy hồ sơ vi phạm nào phù hợp điều kiện lọc.</span>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="d" items="${disciplines}">
                                        <tr>
                                            <td class="ps-3"><input class="form-check-input" type="checkbox" value="${d.id}"></td>
                                            <td class="fw-bold font-monospace text-primary">${d.violationCode}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-circle bg-primary-subtle text-primary fw-bold" style="width: 32px; height: 32px; font-size: 0.78rem; display: flex; align-items: center; justify-content: center; border-radius: 50%;">
                                                        ${d.employeeName != null && d.employeeName.length() > 0 ? d.employeeName.substring(0, 1) : 'NV'}
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold text-dark">${d.employeeName}</div>
                                                        <small class="text-muted">${d.employeeCode}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-light text-dark border">${d.departmentName}</span></td>
                                            <td>${d.violationDate}</td>
                                            <td class="text-truncate" style="max-width: 180px;" title="${d.violationBehavior}">${d.violationBehavior}</td>
                                            <td class="text-center">
                                                <span class="badge ${d.severityBadgeClass}">${d.severityLabel}</span>
                                            </td>
                                            <td class="fw-semibold ${d.severity eq 'critical' || d.severity eq 'high' ? 'text-danger' : 'text-dark'}">${d.proposedDecision}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-1">
                                                    <i class="bi bi-person-badge text-muted"></i>
                                                    <span>${d.handlerName}</span>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${d.statusBadgeClass}">
                                                    ${d.statusLabel}
                                                </span>
                                            </td>
                                            <td class="text-center pe-3">
                                                <div class="btn-group btn-group-sm">
                                                    <!-- Chi tiết -->
                                                    <button type="button" class="btn btn-outline-secondary py-1 px-2" title="Xem hồ sơ" data-bs-toggle="modal" data-bs-target="#viewModal${d.id}">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                    <!-- Tiến trình -->
                                                    <button type="button" class="btn btn-outline-primary py-1 px-2" title="Chuyển bước xử lý" data-bs-toggle="modal" data-bs-target="#stepModal${d.id}">
                                                        <i class="bi bi-arrow-right-circle"></i>
                                                    </button>
                                                    <!-- Xóa -->
                                                    <form method="post" action="${pageContext.request.contextPath}/disciplines" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa biên bản ${d.violationCode}?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${d.id}">
                                                        <button type="submit" class="btn btn-outline-danger py-1 px-2" title="Xóa"><i class="bi bi-trash"></i></button>
                                                    </form>
                                                </div>

                                                <!-- Modal Chi tiết vụ việc -->
                                                <div class="modal fade" id="viewModal${d.id}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered text-start">
                                                        <div class="modal-content border-0 shadow">
                                                            <div class="modal-header bg-light">
                                                                <h6 class="modal-title fw-bold"><i class="bi bi-file-earmark-text text-primary me-2"></i>Hồ sơ kỷ luật: ${d.violationCode}</h6>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body small">
                                                                <div class="row g-3">
                                                                    <div class="col-6"><strong>Nhân sự:</strong> <div>${d.employeeName} (${d.employeeCode})</div></div>
                                                                    <div class="col-6"><strong>Phòng ban:</strong> <div>${d.departmentName}</div></div>
                                                                    <div class="col-6"><strong>Ngày vi phạm:</strong> <div>${d.violationDate}</div></div>
                                                                    <div class="col-6"><strong>Mức độ:</strong> <div><span class="badge ${d.severityBadgeClass}">${d.severityLabel}</span></div></div>
                                                                    <div class="col-12"><strong>Hành vi vi phạm:</strong><div class="p-2 border rounded bg-light mt-1">${d.violationBehavior}</div></div>
                                                                    <div class="col-12"><strong>Hình thức xử lý đề xuất:</strong><div class="fw-semibold text-danger mt-1">${d.proposedDecision}</div></div>
                                                                    <div class="col-6"><strong>Người thụ lý:</strong> <div>${d.handlerName}</div></div>
                                                                    <div class="col-6"><strong>Trạng thái:</strong> <div><span class="badge ${d.statusBadgeClass}">${d.statusLabel}</span> (Bước ${d.currentStep}/5)</div></div>
                                                                    <c:if test="${not empty d.notes}">
                                                                        <div class="col-12"><strong>Ghi chú:</strong><div class="text-muted mt-1">${d.notes}</div></div>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer py-2">
                                                                <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Modal Cập nhật bước xử lý -->
                                                <div class="modal fade" id="stepModal${d.id}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered text-start">
                                                        <div class="modal-content border-0 shadow">
                                                            <form method="post" action="${pageContext.request.contextPath}/disciplines">
                                                                <input type="hidden" name="action" value="update_step">
                                                                <input type="hidden" name="id" value="${d.id}">
                                                                <div class="modal-header bg-light">
                                                                    <h6 class="modal-title fw-bold"><i class="bi bi-diagram-3 text-primary me-2"></i>Chuyển bước tiến trình: ${d.violationCode}</h6>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body small">
                                                                    <div class="mb-3">
                                                                        <label class="form-label fw-semibold">Chọn bước quy trình tiếp theo:</label>
                                                                        <select name="step" class="form-select form-select-sm">
                                                                            <option value="1" ${d.currentStep == 1 ? 'selected' : ''}>Bước 1: Lập biên bản & Xác minh sơ bộ</option>
                                                                            <option value="2" ${d.currentStep == 2 ? 'selected' : ''}>Bước 2: Thu thập tài liệu & Điều tra</option>
                                                                            <option value="3" ${d.currentStep == 3 ? 'selected' : ''}>Bước 3: Tổ chức phiên họp kỷ luật</option>
                                                                            <option value="4" ${d.currentStep == 4 ? 'selected' : ''}>Bước 4: Ban hành quyết định xử lý</option>
                                                                            <option value="5" ${d.currentStep == 5 ? 'selected' : ''}>Bước 5: Hoàn tất & Đóng hồ sơ lưu trữ</option>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer py-2">
                                                                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                                    <button type="submit" class="btn btn-sm btn-primary">Lưu tiến trình</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white border-top py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                    <span class="text-muted small">Hiển thị <strong>${fromIdx} - ${toIdx}</strong> trong tổng số <strong>${totalRecords}</strong> vụ việc kỷ luật</span>
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/disciplines?page=${currentPage - 1}&keyword=${keyword != null ? keyword : ''}&status=${statusFilter != null ? statusFilter : ''}">Trước</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <li class="page-item ${currentPage == p ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/disciplines?page=${p}&keyword=${keyword != null ? keyword : ''}&status=${statusFilter != null ? statusFilter : ''}">${p}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/disciplines?page=${currentPage + 1}&keyword=${keyword != null ? keyword : ''}&status=${statusFilter != null ? statusFilter : ''}">Sau</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<!-- Modal Tạo biên bản vi phạm -->
<div class="modal fade" id="createViolationModal" tabindex="-1" aria-labelledby="createViolationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="createViolationModalLabel">Lập biên bản vi phạm nội quy lao động</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/disciplines">
                <input type="hidden" name="action" value="create_report">
                <input type="hidden" name="violationCode" value="${nextCode}">
                <div class="modal-body">
                    <div class="alert alert-light border small py-2 mb-3">
                        <i class="bi bi-info-circle text-primary me-1"></i> Mã hồ sơ dự kiến tự động: <strong class="text-primary font-monospace">${nextCode}</strong>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Nhân viên vi phạm <span class="text-danger">*</span></label>
                        <select class="form-select form-select-sm" name="employeeId" required>
                            <option value="">-- Chọn nhân sự --</option>
                            <c:forEach var="emp" items="${employees}">
                                <option value="${emp.id}">${emp.fullName} (${emp.employeeCode}) - ${emp.departmentName != null ? emp.departmentName : 'Công ty'}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Thời điểm xảy ra <span class="text-danger">*</span></label>
                            <input type="date" class="form-control form-control-sm" name="violationDate" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Mức độ sơ bộ <span class="text-danger">*</span></label>
                            <select class="form-select form-select-sm" name="severity" required>
                                <option value="low">Nhẹ (Nhắc nhở, phê bình)</option>
                                <option value="medium">Trung bình (Khiển trách văn bản)</option>
                                <option value="high">Nghiêm trọng (Sa thải, đình chỉ)</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Hành vi vi phạm & Tang chứng <span class="text-danger">*</span></label>
                        <textarea class="form-control form-control-sm" name="description" rows="3" placeholder="Ghi nhận rõ hành vi, thời gian, địa điểm và tài liệu chứng minh..." required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Đề xuất hình thức xử lý ban đầu</label>
                        <input type="text" class="form-control form-control-sm" name="proposedDecision" placeholder="Vd: Khiển trách bằng văn bản / Tạm đình chỉ...">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Chuyên viên thụ lý giải quyết</label>
                        <input type="text" class="form-control form-control-sm" name="handler" value="${sessionScope.currentUser != null ? sessionScope.currentUser.username : 'Ban Thanh tra & Nhân sự'}">
                    </div>
                </div>
                <div class="modal-footer py-2">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-sm btn-primary">Xác nhận tạo biên bản</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
