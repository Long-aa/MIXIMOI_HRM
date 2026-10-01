<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================
     MODAL: Cập nhật chấm công (Admin/HR/Manager)
     ============================================================ --%>
<c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr or sessionScope.currentUser.manager}">
<div class="modal fade" id="editAttendanceModal" tabindex="-1" aria-labelledby="editAttendanceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content modal-custom-card">
            <form method="post" action="${pageContext.request.contextPath}/attendance" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editAttId">

                <div class="modal-header modal-header-gradient">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon-badge bg-warning text-dark">
                            <i class="bi bi-pencil-square fs-5"></i>
                        </div>
                        <div>
                            <h6 class="modal-title fw-bold text-dark mb-0" id="editAttendanceModalLabel">
                                Điều chỉnh thông tin chấm công
                            </h6>
                            <p class="text-muted small mb-0">Cập nhật giờ vào, giờ ra, trạng thái và lý do điều chỉnh</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Nhân viên <span class="text-danger">*</span></label>
                            <select class="form-select form-control-modern" name="employeeId" id="editAttEmpId" required>
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Ngày làm việc <span class="text-danger">*</span></label>
                            <input type="date" class="form-control form-control-modern" name="workDate" id="editAttDate" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Giờ Check-in</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-box-arrow-in-right text-success"></i></span>
                                <input type="time" step="1" class="form-control form-control-modern font-monospace border-start-0" name="checkIn" id="editAttCheckIn">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Giờ Check-out</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-box-arrow-right text-danger"></i></span>
                                <input type="time" step="1" class="form-control form-control-modern font-monospace border-start-0" name="checkOut" id="editAttCheckOut">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Trạng thái</label>
                            <select class="form-select form-control-modern" name="status" id="editAttStatus">
                                <option value="ON_TIME">Đúng giờ</option>
                                <option value="LATE">Đi muộn</option>
                                <option value="EARLY_LEAVE">Về sớm</option>
                                <option value="ON_LEAVE">Nghỉ phép có phép (AL)</option>
                                <option value="WFH">Làm việc từ xa (WFH)</option>
                                <option value="ABSENT">Vắng mặt không phép</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Ghi chú điều chỉnh</label>
                            <input type="text" class="form-control form-control-modern" name="notes" id="editAttNotes" placeholder="Nhập lý do thay đổi...">
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 pt-2 gap-2 bg-light">
                    <button type="button" class="btn btn-secondary-modern px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary-modern px-4">
                        <i class="bi bi-check2-circle me-1"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</c:if>
