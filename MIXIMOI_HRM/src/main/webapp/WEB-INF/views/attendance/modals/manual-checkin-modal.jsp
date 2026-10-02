<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================
     MODAL: Chấm công thủ công / Giải trình (Admin/HR only)
     ============================================================ --%>
<c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
<div class="modal fade" id="manualCheckinModal" tabindex="-1" aria-labelledby="manualCheckinModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content modal-custom-card">
            <form method="post" action="${pageContext.request.contextPath}/attendance" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="manual">

                <div class="modal-header modal-header-gradient">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon-badge bg-primary text-white">
                            <i class="bi bi-clock-history fs-5"></i>
                        </div>
                        <div>
                            <h6 class="modal-title fw-bold text-dark mb-0" id="manualCheckinModalLabel">
                                Chấm công thủ công / Giải trình bổ sung
                            </h6>
                            <p class="text-muted small mb-0">Bổ sung hoặc điều chỉnh dữ liệu chấm công cho nhân viên</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Nhân viên <span class="text-danger">*</span></label>
                            <select class="form-select form-control-modern" name="employeeId" required>
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Ngày làm việc <span class="text-danger">*</span></label>
                            <input type="date" class="form-control form-control-modern" name="workDate" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Giờ Check-in</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-box-arrow-in-right text-success"></i></span>
                                <input type="time" step="1" class="form-control form-control-modern font-monospace border-start-0" name="checkIn">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Giờ Check-out</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-box-arrow-right text-danger"></i></span>
                                <input type="time" step="1" class="form-control form-control-modern font-monospace border-start-0" name="checkOut">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Phương thức chấm công</label>
                            <select class="form-select form-control-modern" name="method">
                                <option value="MANUAL">Thủ công (HR bổ sung)</option>
                                <option value="FaceID">FaceID ZKTeco / AI</option>
                                <option value="GPS">GPS Mobile (WFH)</option>
                                <option value="Fingerprint">Vân tay máy chấm công</option>
                                <option value="CARD">Thẻ từ NFC</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark small mb-1">Trạng thái</label>
                            <select class="form-select form-control-modern" name="status">
                                <option value="ON_TIME">Đúng giờ</option>
                                <option value="LATE">Đi muộn</option>
                                <option value="EARLY_LEAVE">Về sớm</option>
                                <option value="ON_LEAVE">Nghỉ phép có phép (AL)</option>
                                <option value="WFH">Làm việc từ xa (WFH)</option>
                                <option value="ABSENT">Vắng mặt không phép</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-dark small mb-1">Lý do / Ghi chú giải trình <span class="text-danger">*</span></label>
                            <textarea class="form-control form-control-modern" name="notes" rows="3" required
                                      placeholder="VD: Nhân viên quên chấm công, đã kiểm tra dữ liệu camera và xác nhận có mặt từ 08:25..."></textarea>
                            <div class="invalid-feedback">Vui lòng nhập lý do giải trình để phục vụ kiểm toán</div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 pt-2 gap-2 bg-light">
                    <button type="button" class="btn btn-secondary-modern px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary-modern px-4">
                        <i class="bi bi-check2-circle me-1"></i> Lưu bản ghi chấm công
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</c:if>
