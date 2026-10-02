<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi tiết đơn nghỉ phép #${leaveRequest.leaveCode} — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/leave.css">
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="leave" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Leave Detail Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Actions -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-file-earmark-text text-primary"></i> Chi tiết đơn nghỉ phép #${leaveRequest.leaveCode}
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/leave" class="text-decoration-none">Nghỉ phép</a></li>
                            <li class="breadcrumb-item active" aria-current="page">${leaveRequest.leaveCode}</li>
                        </ol>
                    </nav>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/leave" class="btn-action-light text-decoration-none">
                        <i class="bi bi-arrow-left"></i> Quay lại danh sách
                    </a>
                    <button type="button" class="btn-action-light" onclick="window.print()">
                        <i class="bi bi-printer"></i> In đơn
                    </button>
                </div>
            </div>

            <!-- Detail Grid Layout -->
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="app-card">
                        <!-- Print-Only Header (Chỉ xuất hiện khi in đơn giấy) -->
                        <div class="print-only-header">
                            <h5 style="font-weight:800; margin-bottom:4px; text-transform:uppercase;">CÔNG TY CỔ PHẦN TẬP ĐOÀN MIXIMOI</h5>
                            <div style="font-size:10pt; color:#475569; margin-bottom:12px;">HỆ THỐNG QUẢN TRỊ NHÂN SỰ &amp; TIỀN LƯƠNG (MIXIMOI HRM)</div>
                            <h4 style="font-weight:900; margin-bottom:4px; letter-spacing:0.5px;">GIẤY XIN NGHỈ PHÉP</h4>
                            <div style="font-size:9.5pt; color:#334155;">Mã đơn: <strong>#${leaveRequest.leaveCode}</strong> — Trạng thái: ${leaveRequest.getStatusDisplay()}</div>
                        </div>

                        <!-- Header Status Banner -->
                        <div class="d-flex justify-content-between align-items-center pb-3 mb-3 border-bottom">
                            <div>
                                <span class="badge bg-light text-dark border font-monospace px-2 py-1 fs-6">
                                    ${leaveRequest.leaveCode}
                                </span>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${leaveRequest.status eq 'APPROVED'}">
                                        <span class="status-pill approved fs-6 px-3 py-1">
                                            <i class="bi bi-check-circle-fill"></i> Đã phê duyệt hoàn tất (HR)
                                        </span>
                                    </c:when>
                                    <c:when test="${leaveRequest.status eq 'MANAGER_APPROVED'}">
                                        <span class="status-pill fs-6 px-3 py-1" style="background:#fef3c7; color:#b45309; border:1px solid #fde68a;">
                                            <i class="bi bi-clock-history"></i> Trưởng phòng đã duyệt (Chờ HR)
                                        </span>
                                    </c:when>
                                    <c:when test="${leaveRequest.status eq 'REJECTED'}">
                                        <span class="status-pill rejected fs-6 px-3 py-1">
                                            <i class="bi bi-x-circle-fill"></i> Bị từ chối
                                        </span>
                                    </c:when>
                                    <c:when test="${leaveRequest.status eq 'CANCELLED'}">
                                        <span class="status-pill fs-6 px-3 py-1" style="background:#f1f5f9; color:#64748b; border:1px solid #cbd5e1;">
                                            <i class="bi bi-dash-circle"></i> Đã hủy đơn
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill pending fs-6 px-3 py-1">
                                            <i class="bi bi-clock-history"></i> Đang chờ Trưởng phòng duyệt
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Employee Info Row -->
                        <div class="d-flex align-items-center gap-3 p-3 bg-light rounded-3 mb-4 border">
                            <div class="table-user-avatar" style="width: 48px; height: 48px; font-size: 1.1rem;">
                                ${leaveRequest.employeeName != null ? leaveRequest.employeeName.substring(0, 1).toUpperCase() : 'NV'}
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0 text-dark">${leaveRequest.employeeName}</h6>
                                <span class="text-muted" style="font-size:0.82rem">
                                    Mã NV: <strong>${leaveRequest.employeeCode}</strong> • Phòng ban: <strong>${leaveRequest.departmentName}</strong> • Chức vụ: ${leaveRequest.positionName}
                                </span>
                            </div>
                        </div>

                        <!-- Detailed Information Fields -->
                        <div class="row g-3">
                            <div class="col-sm-6">
                                <div class="detail-info-row">
                                    <span class="detail-info-label">Hình thức nghỉ phép</span>
                                    <span class="detail-info-value">
                                        <c:choose>
                                            <c:when test="${leaveRequest.leaveType eq 'ANNUAL'}">Nghỉ phép năm (AL - 100% lương)</c:when>
                                            <c:when test="${leaveRequest.leaveType eq 'SICK'}">Nghỉ ốm đau / Bệnh viện (SL - Chế độ BHXH)</c:when>
                                            <c:when test="${leaveRequest.leaveType eq 'PERSONAL'}">Việc riêng cá nhân có lương</c:when>
                                            <c:when test="${leaveRequest.leaveType eq 'WEDDING'}">Nghỉ cưới hỏi bản thân (3 ngày hưởng lương)</c:when>
                                            <c:when test="${leaveRequest.leaveType eq 'MATERNITY'}">Nghỉ thai sản (6 tháng theo BHXH)</c:when>
                                            <c:otherwise>Nghỉ không hưởng lương (UL)</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <div class="col-sm-6">
                                <div class="detail-info-row">
                                    <span class="detail-info-label">Tổng thời gian nghỉ</span>
                                    <span class="detail-info-value text-primary fs-6">
                                        <i class="bi bi-calendar-check me-1"></i> ${leaveRequest.getDaysDisplay()} làm việc (loại trừ T7, CN & Lễ)
                                    </span>
                                </div>
                            </div>

                            <div class="col-sm-6">
                                <div class="detail-info-row">
                                    <span class="detail-info-label">Bắt đầu nghỉ từ</span>
                                    <span class="detail-info-value">${leaveRequest.startDate}</span>
                                </div>
                            </div>

                            <div class="col-sm-6">
                                <div class="detail-info-row">
                                    <span class="detail-info-label">Đến hết ngày</span>
                                    <span class="detail-info-value">${leaveRequest.endDate}</span>
                                </div>
                            </div>

                            <c:if test="${not empty leaveRequest.handoverPerson}">
                                <div class="col-12">
                                    <div class="detail-info-row">
                                        <span class="detail-info-label">Người nhận bàn giao công việc</span>
                                        <span class="detail-info-value"><i class="bi bi-person-check text-primary me-1"></i>${leaveRequest.handoverPerson}</span>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Tài liệu đính kèm minh chứng -->
                            <c:if test="${not empty leaveRequest.attachmentUrl}">
                                <div class="col-12">
                                    <div class="detail-info-row">
                                        <span class="detail-info-label">Tài liệu / Hồ sơ y tế minh chứng</span>
                                        <div class="mt-2 p-3 bg-light rounded-3 border d-flex align-items-center justify-content-between flex-wrap gap-2">
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="bi bi-file-earmark-medical text-primary fs-4"></i>
                                                <div>
                                                    <span class="fw-bold text-dark d-block" style="font-size:0.88rem;">Giấy tờ xác nhận / Giấy ra viện</span>
                                                    <small class="text-muted font-monospace">${leaveRequest.attachmentUrl}</small>
                                                </div>
                                            </div>
                                            <a href="${leaveRequest.attachmentUrl}" target="_blank" class="btn btn-sm btn-outline-primary fw-bold px-3">
                                                <i class="bi bi-box-arrow-up-right me-1"></i> Xem chứng từ
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <div class="col-12">
                                <div class="detail-info-row">
                                    <span class="detail-info-label">Lý do xin nghỉ</span>
                                    <div class="p-3 bg-light rounded-2 mt-1 text-dark" style="font-size:0.9rem; line-height: 1.6;">
                                        ${leaveRequest.reason}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Management Decision Buttons (Phân Quyền 2 Cấp Thực Tế) -->
                        <div class="d-flex justify-content-end align-items-center gap-3 pt-4 mt-4 border-top">
                            <%-- Manager Cấp 1: Khi đơn PENDING --%>
                            <c:if test="${sessionScope.currentUser.manager and leaveRequest.status eq 'PENDING'}">
                                <button type="button" class="btn btn-outline-danger px-3 py-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#rejectModal">
                                    <i class="bi bi-x-circle me-1"></i> Từ chối đơn
                                </button>
                                <form method="post" action="${pageContext.request.contextPath}/leave" class="d-inline">
                                    <input type="hidden" name="action" value="managerApprove">
                                    <input type="hidden" name="id" value="${leaveRequest.id}">
                                    <input type="hidden" name="managerNote" value="Trưởng phòng đã phê duyệt và chấp thuận kế hoạch bàn giao.">
                                    <button type="submit" class="btn btn-success px-4 py-2 fw-semibold shadow-sm">
                                        <i class="bi bi-check-circle me-1"></i> Trưởng phòng Phê duyệt (Cấp 1)
                                    </button>
                                </form>
                            </c:if>

                            <%-- HR / Admin Cấp 2: Khi đơn PENDING hoặc MANAGER_APPROVED --%>
                            <c:if test="${(sessionScope.currentUser.hr or sessionScope.currentUser.admin) and (leaveRequest.status eq 'PENDING' or leaveRequest.status eq 'MANAGER_APPROVED')}">
                                <button type="button" class="btn btn-outline-danger px-3 py-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#rejectModal">
                                    <i class="bi bi-x-circle me-1"></i> Từ chối đơn
                                </button>
                                <form method="post" action="${pageContext.request.contextPath}/leave" class="d-inline">
                                    <input type="hidden" name="action" value="hrApprove">
                                    <input type="hidden" name="id" value="${leaveRequest.id}">
                                    <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold shadow-sm" style="background:#2563eb;">
                                        <i class="bi bi-check2-all me-1"></i> HR Phê duyệt Hoàn tất (Cấp 2) &amp; Đồng bộ Chấm công
                                    </button>
                                </form>
                            </c:if>

                            <%-- Nút Hủy đơn: Dành cho chính chủ nhân sự hoặc Admin/HR khi đơn chưa bị REJECTED/CANCELLED --%>
                            <c:if test="${(leaveRequest.employeeId == sessionScope.currentUser.employeeId or sessionScope.currentUser.admin or sessionScope.currentUser.hr) and (leaveRequest.status eq 'PENDING' or leaveRequest.status eq 'MANAGER_APPROVED')}">
                                <form method="post" action="${pageContext.request.contextPath}/leave" class="d-inline"
                                      onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn nghỉ phép này không? Dữ liệu chấm công liên quan sẽ được tự động thu hồi.');">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="id" value="${leaveRequest.id}">
                                    <button type="submit" class="btn btn-outline-danger px-3 py-2 fw-semibold">
                                        <i class="bi bi-trash me-1"></i> Hủy đơn này
                                    </button>
                                </form>
                            </c:if>
                        </div>

                        <!-- Print-Only Signatures (Chữ ký 4 bên khi in phiếu) -->
                        <div class="print-signatures-row">
                            <div class="print-sig-col">
                                <div class="print-sig-title">NGƯỜI LÀM ĐƠN</div>
                                <div class="print-sig-name">${leaveRequest.employeeName}</div>
                            </div>
                            <div class="print-sig-col">
                                <div class="print-sig-title">NGƯỜI BÀN GIAO</div>
                                <div class="print-sig-name">${not empty leaveRequest.handoverPerson ? leaveRequest.handoverPerson : 'Đã xác nhận'}</div>
                            </div>
                            <div class="print-sig-col">
                                <div class="print-sig-title">TRƯỞNG BỘ PHẬN</div>
                                <div class="print-sig-name">${not empty leaveRequest.managerName ? leaveRequest.managerName : 'Đã thông qua'}</div>
                            </div>
                            <div class="print-sig-col">
                                <div class="print-sig-title">GIÁM ĐỐC NHÂN SỰ</div>
                                <div class="print-sig-name">${not empty leaveRequest.hrName ? leaveRequest.hrName : not empty leaveRequest.approvedByName ? leaveRequest.approvedByName : 'Phê duyệt'}</div>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Approval Timeline Sidebar -->
                <div class="col-lg-4">
                    <div class="app-card">
                        <div class="app-card-header">
                            <div>
                                <h6 class="app-card-title">
                                    <i class="bi bi-clock-history text-primary"></i> Tiến trình xét duyệt 2 cấp
                                </h6>
                                <p class="app-card-subtitle">Quy trình: Nhân viên → Trưởng phòng → HR</p>
                            </div>
                        </div>

                        <div class="activity-feed">
                            <!-- Step 1: Created -->
                            <div class="activity-item">
                                <div class="activity-icon-box text-primary" style="background:#eff6ff">
                                    <i class="bi bi-file-earmark-plus"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-title-row">
                                        <span class="activity-title">1. Tạo &amp; nộp đơn xin nghỉ</span>
                                    </div>
                                    <p class="activity-desc">Gửi bởi: <strong>${leaveRequest.employeeName}</strong> (${leaveRequest.employeeCode})</p>
                                    <small class="text-muted">${leaveRequest.createdAt != null ? leaveRequest.createdAt : 'Đã ghi nhận'}</small>
                                </div>
                            </div>

                            <!-- Step 2: Manager Review -->
                            <div class="activity-item">
                                <c:choose>
                                    <c:when test="${not empty leaveRequest.managerApprovedAt or leaveRequest.status eq 'APPROVED' or leaveRequest.status eq 'MANAGER_APPROVED'}">
                                        <div class="activity-icon-box text-success" style="background:#ecfdf5">
                                            <i class="bi bi-check2"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-success">2. Trưởng phòng đã duyệt (Cấp 1)</span>
                                            </div>
                                            <p class="activity-desc mb-1">
                                                Người duyệt: <strong>${not empty leaveRequest.managerName ? leaveRequest.managerName : 'Trưởng bộ phận'}</strong>
                                            </p>
                                            <c:if test="${not empty leaveRequest.managerNote}">
                                                <div class="p-2 bg-light rounded text-secondary mb-1" style="font-size:0.78rem;">
                                                    <i class="bi bi-chat-left-quote me-1"></i>${leaveRequest.managerNote}
                                                </div>
                                            </c:if>
                                            <small class="text-muted">${leaveRequest.managerApprovedAt}</small>
                                        </div>
                                    </c:when>
                                    <c:when test="${leaveRequest.status eq 'REJECTED' and empty leaveRequest.managerApprovedAt}">
                                        <div class="activity-icon-box text-danger" style="background:#fef2f2">
                                            <i class="bi bi-x-lg"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-danger">2. Trưởng phòng từ chối</span>
                                            </div>
                                            <p class="activity-desc mb-1">Từ chối bởi: <strong>${not empty leaveRequest.approvedByName ? leaveRequest.approvedByName : 'Ban Quản trị'}</strong></p>
                                            <div class="alert alert-danger py-1 px-2 mt-1" style="font-size:0.78rem;">${leaveRequest.rejectReason}</div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="activity-icon-box text-warning" style="background:#fffbeb">
                                            <i class="bi bi-hourglass-split"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-warning">2. Chờ Trưởng phòng phê duyệt</span>
                                            </div>
                                            <p class="activity-desc">Đang chờ Quản lý trực tiếp thẩm tra bàn giao công việc.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Step 3: HR Final Approval & Attendance Sync -->
                            <div class="activity-item">
                                <c:choose>
                                    <c:when test="${leaveRequest.status eq 'APPROVED'}">
                                        <div class="activity-icon-box text-success" style="background:#ecfdf5">
                                            <i class="bi bi-check2-all"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-success">3. HR phê duyệt &amp; Đồng bộ công</span>
                                            </div>
                                            <p class="activity-desc mb-1">
                                                Xác nhận bởi: <strong>${not empty leaveRequest.hrName ? leaveRequest.hrName : not empty leaveRequest.approvedByName ? leaveRequest.approvedByName : 'Phòng Nhân sự'}</strong>
                                            </p>
                                            <div class="badge bg-success-subtle text-success border border-success-subtle mt-1 py-1 px-2" style="font-size:0.75rem;">
                                                <i class="bi bi-arrow-repeat me-1"></i>Đã đồng bộ sang bảng chấm công
                                            </div>
                                            <small class="text-muted d-block mt-1">${leaveRequest.hrApprovedAt != null ? leaveRequest.hrApprovedAt : leaveRequest.approvedAt}</small>
                                        </div>
                                    </c:when>
                                    <c:when test="${leaveRequest.status eq 'REJECTED' and not empty leaveRequest.managerApprovedAt}">
                                        <div class="activity-icon-box text-danger" style="background:#fef2f2">
                                            <i class="bi bi-x-lg"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-danger">3. Nhân sự (HR) từ chối</span>
                                            </div>
                                            <p class="activity-desc mb-1">Từ chối bởi: <strong>${not empty leaveRequest.approvedByName ? leaveRequest.approvedByName : 'Phòng HR'}</strong></p>
                                            <div class="alert alert-danger py-1 px-2 mt-1" style="font-size:0.78rem;">${leaveRequest.rejectReason}</div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="activity-icon-box text-secondary" style="background:#f8fafc">
                                            <i class="bi bi-clock"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-muted">3. Thẩm định &amp; Quyết định HR</span>
                                            </div>
                                            <p class="activity-desc text-muted">HR sẽ kiểm tra quỹ phép năm theo Luật Lao Động và kích hoạt đồng bộ chấm công khi phê duyệt.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Modal Từ chối đơn -->
<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form method="post" action="${pageContext.request.contextPath}/leave">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="id" value="${leaveRequest.id}">

                <div class="modal-header border-bottom-0 pb-0">
                    <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                        <i class="bi bi-x-circle-fill"></i> Từ chối đơn nghỉ phép
                    </h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body py-3 text-secondary" style="font-size: 0.88rem;">
                    <p class="mb-2">Vui lòng nêu rõ lý do từ chối đơn nghỉ phép của <strong>${leaveRequest.employeeName}</strong>:</p>
                    <textarea class="form-control form-control-custom" name="rejectReason" rows="3" required
                              placeholder="Nhập lý do từ chối..."></textarea>
                </div>
                <div class="modal-footer border-top-0 pt-0">
                    <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-danger btn-sm px-3">Xác nhận từ chối</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/leave.js"></script>
</body>
</html>
