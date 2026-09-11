<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý nghỉ phép — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
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

        <!-- Leave List Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Action -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-calendar-check text-primary"></i> Quản lý nghỉ phép
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Danh sách đơn nghỉ phép</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/leave?action=new" class="btn-action-primary text-decoration-none">
                    <i class="bi bi-file-earmark-plus"></i> Tạo đơn xin nghỉ
                </a>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'submitted'}">Gửi đơn xin nghỉ phép thành công! Đơn đang chờ quản lý phê duyệt.</c:when>
                        <c:when test="${param.success eq 'approved'}">Đã duyệt đơn xin nghỉ phép thành công!</c:when>
                        <c:when test="${param.success eq 'rejected'}">Đã từ chối đơn xin nghỉ phép.</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    <c:out value="${param.error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:set var="leaveCount" value="${not empty leaveRequests ? fn:length(leaveRequests) : 0}" />

            <!-- Summary KPI Cards -->
            <c:set var="pendingCount" value="0" />
            <c:set var="approvedCount" value="0" />
            <c:set var="rejectedCount" value="0" />
            <c:forEach var="item" items="${leaveRequests}">
                <c:if test="${item.status eq 'PENDING'}"><c:set var="pendingCount" value="${pendingCount + 1}" /></c:if>
                <c:if test="${item.status eq 'APPROVED'}"><c:set var="approvedCount" value="${approvedCount + 1}" /></c:if>
                <c:if test="${item.status eq 'REJECTED'}"><c:set var="rejectedCount" value="${rejectedCount + 1}" /></c:if>
            </c:forEach>

            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-lg-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">TỔNG SỐ ĐƠN</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value">${leaveCount}</span>
                                    <span class="kpi-unit">yêu cầu</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box">
                                <i class="bi bi-folder2-open"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span>Toàn bộ đơn gửi lên</span>
                            <span class="text-muted">Dữ liệu hệ thống</span>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">CHỜ PHÊ DUYỆT</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-warning">${pendingCount}</span>
                                    <span class="kpi-unit">đơn</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box text-warning" style="background:#fffbeb">
                                <i class="bi bi-hourglass-split"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span>Cần xử lý kịp thời</span>
                            <span class="badge bg-warning-subtle text-warning-emphasis">Ưu tiên</span>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">ĐÃ CHẤP THUẬN</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-success">${approvedCount}</span>
                                    <span class="kpi-unit">đơn</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box text-success" style="background:#ecfdf5">
                                <i class="bi bi-check2-circle"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span>Đã cập nhật bảng công</span>
                            <span class="trend-badge positive">Hợp lệ</span>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="kpi-card">
                        <div class="kpi-header">
                            <div>
                                <div class="kpi-label">TỪ CHỐI</div>
                                <div class="kpi-value-row">
                                    <span class="kpi-value text-danger">${rejectedCount}</span>
                                    <span class="kpi-unit">đơn</span>
                                </div>
                            </div>
                            <div class="kpi-icon-box text-danger" style="background:#fef2f2">
                                <i class="bi bi-x-circle"></i>
                            </div>
                        </div>
                        <div class="kpi-footer">
                            <span>Không được duyệt</span>
                            <span class="text-muted">Kèm lý do</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Leave Request Table Card -->
            <div class="table-custom-container">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Nhân viên</th>
                                <th>Loại nghỉ</th>
                                <th>Thời gian</th>
                                <th class="text-center">Số ngày</th>
                                <th>Lý do</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty leaveRequests}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-5">
                                            <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                            Chưa có đơn xin nghỉ phép nào.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="lr" items="${leaveRequests}">
                                        <tr>
                                            <td>
                                                <span class="badge bg-light text-dark border font-monospace px-2 py-1">
                                                    <c:out value="${lr.leaveCode}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="table-user-cell">
                                                    <div class="table-user-avatar">
                                                        <c:choose>
                                                            <c:when test="${not empty lr.employeeName and fn:length(fn:trim(lr.employeeName)) > 0}">
                                                                ${fn:toUpperCase(fn:substring(fn:trim(lr.employeeName), 0, 1))}
                                                            </c:when>
                                                            <c:otherwise>NV</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div>
                                                        <div class="table-user-name"><c:out value="${lr.employeeName}"/></div>
                                                        <div class="table-user-email"><c:out value="${lr.employeeCode}"/></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${lr.leaveType eq 'ANNUAL'}"><span class="badge bg-primary-subtle text-primary border">Phép năm</span></c:when>
                                                    <c:when test="${lr.leaveType eq 'SICK'}"><span class="badge bg-info-subtle text-info-emphasis border">Nghỉ ốm</span></c:when>
                                                    <c:when test="${lr.leaveType eq 'PERSONAL'}"><span class="badge bg-secondary-subtle text-secondary border">Việc riêng</span></c:when>
                                                    <c:when test="${lr.leaveType eq 'MATERNITY'}"><span class="badge bg-warning-subtle text-warning-emphasis border">Thai sản</span></c:when>
                                                    <c:otherwise><span class="badge bg-light text-dark border">Không lương</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="font-size: 0.83rem;">
                                                    <div><i class="bi bi-arrow-right-short text-muted"></i> Từ: <strong><c:out value="${lr.startDate}"/></strong></div>
                                                    <div><i class="bi bi-arrow-left-short text-muted"></i> Đến: <strong><c:out value="${lr.endDate}"/></strong></div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="fw-bold text-dark">${lr.totalDays}</span> <span class="text-muted" style="font-size:0.75rem">ngày</span>
                                            </td>
                                            <td>
                                                <span class="text-truncate d-inline-block text-secondary" style="max-width: 180px;" title="<c:out value='${lr.reason}'/>">
                                                    <c:out value="${lr.reason}"/>
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${lr.status eq 'APPROVED'}">
                                                        <span class="status-pill approved">
                                                            <i class="bi bi-check-circle-fill"></i> Đã duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${lr.status eq 'REJECTED'}">
                                                        <span class="status-pill rejected">
                                                            <i class="bi bi-x-circle-fill"></i> Từ chối
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${lr.status eq 'CANCELLED'}">
                                                        <span class="status-pill cancelled">
                                                            <i class="bi bi-slash-circle"></i> Đã hủy
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill pending">
                                                            <i class="bi bi-clock-history"></i> Chờ duyệt
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/leave?action=detail&id=${lr.id}" 
                                                       class="btn btn-light border text-secondary" title="Xem chi tiết đơn">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    
                                                    <!-- Nút Duyệt / Từ chối cho Quản lý & HR -->
                                                    <c:if test="${sessionScope.currentUser.role ne 'EMPLOYEE' and lr.status eq 'PENDING'}">
                                                        <button type="button" class="btn btn-light border text-success" 
                                                                title="Phê duyệt nhanh"
                                                                data-id="${lr.id}"
                                                                data-code="<c:out value='${lr.leaveCode}'/>"
                                                                onclick="confirmApprove(this)">
                                                            <i class="bi bi-check-lg"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-light border text-danger" 
                                                                title="Từ chối đơn"
                                                                data-id="${lr.id}"
                                                                data-code="<c:out value='${lr.leaveCode}'/>"
                                                                onclick="openRejectModal(this)">
                                                            <i class="bi bi-x-lg"></i>
                                                        </button>
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
                
                <c:if test="${not empty leaveRequests}">
                    <div class="px-4 py-3 bg-white border-top d-flex justify-content-between align-items-center" style="font-size:0.83rem">
                        <span class="text-muted">Tổng cộng <strong>${leaveCount}</strong> đơn yêu cầu</span>
                        <div class="text-muted">Hệ thống xét duyệt MixiMoi HRM</div>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<!-- Modal Duyệt nhanh -->
<div class="modal fade" id="approveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0">
                <h6 class="modal-title fw-bold text-success d-flex align-items-center gap-2">
                    <i class="bi bi-check-circle-fill"></i> Phê duyệt đơn nghỉ
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body py-3 text-secondary" style="font-size: 0.88rem;">
                Xác nhận phê duyệt đơn nghỉ phép <strong id="approveLeaveCode" class="text-dark"></strong>?
            </div>
            <div class="modal-footer border-top-0 pt-0">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/leave" id="approveForm">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="id" id="approveLeaveId">
                    <button type="submit" class="btn btn-success btn-sm px-3">Phê duyệt</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Từ chối đơn -->
<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form method="post" action="${pageContext.request.contextPath}/leave" id="rejectForm">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="id" id="rejectLeaveId">

                <div class="modal-header border-bottom-0 pb-0">
                    <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                        <i class="bi bi-x-circle-fill"></i> Từ chối đơn nghỉ phép
                    </h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body py-3 text-secondary" style="font-size: 0.88rem;">
                    <p class="mb-2">Bạn chuẩn bị từ chối đơn nghỉ phép <strong id="rejectLeaveCode" class="text-dark"></strong>. Vui lòng nêu rõ lý do để nhân viên nắm thông tin:</p>
                    <textarea class="form-control form-control-custom" name="rejectReason" rows="3" required
                              placeholder="Nhập lý do từ chối (bắt buộc)..."></textarea>
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

<script>
    function confirmApprove(btnOrId, maybeCode) {
        let id, code;
        if (typeof btnOrId === 'object' && btnOrId !== null) {
            id = btnOrId.getAttribute('data-id');
            code = btnOrId.getAttribute('data-code');
        } else {
            id = btnOrId;
            code = maybeCode;
        }
        document.getElementById('approveLeaveId').value = id;
        document.getElementById('approveLeaveCode').textContent = code;
        new bootstrap.Modal(document.getElementById('approveModal')).show();
    }

    function openRejectModal(btnOrId, maybeCode) {
        let id, code;
        if (typeof btnOrId === 'object' && btnOrId !== null) {
            id = btnOrId.getAttribute('data-id');
            code = btnOrId.getAttribute('data-code');
        } else {
            id = btnOrId;
            code = maybeCode;
        }
        document.getElementById('rejectLeaveId').value = id;
        document.getElementById('rejectLeaveCode').textContent = code;
        new bootstrap.Modal(document.getElementById('rejectModal')).show();
    }
</script>

</body>
</html>
