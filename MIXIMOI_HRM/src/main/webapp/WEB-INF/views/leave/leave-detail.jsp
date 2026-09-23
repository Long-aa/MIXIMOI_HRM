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
                                            <i class="bi bi-check-circle-fill"></i> Đã phê duyệt
                                        </span>
                                    </c:when>
                                    <c:when test="${leaveRequest.status eq 'REJECTED'}">
                                        <span class="status-pill rejected fs-6 px-3 py-1">
                                            <i class="bi bi-x-circle-fill"></i> Bị từ chối
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill pending fs-6 px-3 py-1">
                                            <i class="bi bi-clock-history"></i> Đang chờ duyệt
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
                                    Mã NV: <strong>${leaveRequest.employeeCode}</strong> • Mã định danh: #${leaveRequest.employeeId}
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
                                            <c:when test="${leaveRequest.leaveType eq 'ANNUAL'}">Nghỉ phép năm</c:when>
                                            <c:when test="${leaveRequest.leaveType eq 'SICK'}">Nghỉ ốm đau / Bệnh viện</c:when>
                                            <c:when test="${leaveRequest.leaveType eq 'PERSONAL'}">Việc riêng cá nhân</c:when>
                                            <c:when test="${leaveRequest.leaveType eq 'MATERNITY'}">Nghỉ thai sản</c:when>
                                            <c:otherwise>Nghỉ không lương</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <div class="col-sm-6">
                                <div class="detail-info-row">
                                    <span class="detail-info-label">Tổng thời gian nghỉ</span>
                                    <span class="detail-info-value text-primary fs-6">
                                        <i class="bi bi-calendar-check me-1"></i> ${leaveRequest.totalDays} ngày công
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

                            <div class="col-12">
                                <div class="detail-info-row">
                                    <span class="detail-info-label">Lý do xin nghỉ</span>
                                    <div class="p-3 bg-light rounded-2 mt-1 text-dark" style="font-size:0.9rem; line-height: 1.6;">
                                        ${leaveRequest.reason}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Management Decision Buttons -->
                        <c:if test="${sessionScope.currentUser.role ne 'EMPLOYEE' and leaveRequest.status eq 'PENDING'}">
                            <div class="d-flex justify-content-end align-items-center gap-3 pt-4 mt-4 border-top">
                                <button type="button" class="btn btn-outline-danger px-3 py-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#rejectModal">
                                    <i class="bi bi-x-circle me-1"></i> Từ chối đơn
                                </button>
                                <form method="post" action="${pageContext.request.contextPath}/leave" class="d-inline">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="id" value="${leaveRequest.id}">
                                    <button type="submit" class="btn btn-success px-4 py-2 fw-semibold shadow-sm">
                                        <i class="bi bi-check-circle me-1"></i> Phê duyệt đơn này
                                    </button>
                                </form>
                            </div>
                        </c:if>

                    </div>
                </div>

                <!-- Approval Timeline Sidebar -->
                <div class="col-lg-4">
                    <div class="app-card">
                        <div class="app-card-header">
                            <div>
                                <h6 class="app-card-title">
                                    <i class="bi bi-clock-history text-primary"></i> Tiến trình xét duyệt
                                </h6>
                                <p class="app-card-subtitle">Lịch sử xử lý đơn nghỉ phép</p>
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
                                        <span class="activity-title">Tạo đơn nghỉ phép</span>
                                    </div>
                                    <p class="activity-desc">Đơn được gửi bởi <strong>${leaveRequest.employeeName}</strong></p>
                                </div>
                            </div>

                            <!-- Step 2: Evaluation -->
                            <c:choose>
                                <c:when test="${leaveRequest.status eq 'APPROVED'}">
                                    <div class="activity-item">
                                        <div class="activity-icon-box text-success" style="background:#ecfdf5">
                                            <i class="bi bi-check2-all"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-success">Đã được phê duyệt</span>
                                            </div>
                                            <p class="activity-desc">
                                                Phê duyệt bởi: <strong>${not empty leaveRequest.approvedByName ? leaveRequest.approvedByName : 'Ban Quản trị'}</strong>
                                            </p>
                                        </div>
                                    </div>
                                </c:when>

                                <c:when test="${leaveRequest.status eq 'REJECTED'}">
                                    <div class="activity-item">
                                        <div class="activity-icon-box text-danger" style="background:#fef2f2">
                                            <i class="bi bi-x-lg"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-danger">Bị từ chối</span>
                                            </div>
                                            <p class="activity-desc mb-1">
                                                Bởi: <strong>${not empty leaveRequest.approvedByName ? leaveRequest.approvedByName : 'Ban Quản trị'}</strong>
                                            </p>
                                            <c:if test="${not empty leaveRequest.rejectReason}">
                                                <div class="alert alert-danger py-2 px-3 mt-2" style="font-size:0.8rem">
                                                    <strong>Lý do từ chối:</strong> ${leaveRequest.rejectReason}
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="activity-item">
                                        <div class="activity-icon-box text-warning" style="background:#fffbeb">
                                            <i class="bi bi-hourglass-split"></i>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-title-row">
                                                <span class="activity-title text-warning">Đang chờ quản lý xét duyệt</span>
                                            </div>
                                            <p class="activity-desc">Đang đợi bộ phận HR / Quản lý kiểm tra và phê duyệt theo quy định.</p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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
