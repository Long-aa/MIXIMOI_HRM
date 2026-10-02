<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================
     MODAL: Gửi giải trình chấm công (Employee only)
     ============================================================ --%>
<c:if test="${sessionScope.currentUser.employee}">
<div class="modal fade" id="explainModal" tabindex="-1" aria-labelledby="explainModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:500px;">
        <div class="modal-content modal-custom-card">
            <form method="post" action="${pageContext.request.contextPath}/attendance">
                <input type="hidden" name="action" value="explain">
                <input type="hidden" name="attendanceId" id="explainAttId">

                <div class="modal-header modal-header-gradient">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon-badge bg-primary text-white">
                            <i class="bi bi-pencil-square fs-5"></i>
                        </div>
                        <div>
                            <h6 class="modal-title fw-bold text-dark mb-0" id="explainModalLabel">
                                Gửi giải trình chấm công
                            </h6>
                            <p class="text-muted small mb-0">Báo cáo lý do phát sinh đi muộn, về sớm hoặc sự cố thiết bị</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="p-3 mb-3 rounded-3 border bg-light d-flex align-items-center justify-content-between">
                        <span class="text-muted small"><i class="bi bi-calendar3 me-1"></i> Ngày ghi nhận:</span>
                        <strong id="explainDate" class="text-dark font-monospace"></strong>
                    </div>

                    <label class="form-label fw-semibold text-dark small mb-1">
                        Lý do giải trình chi tiết <span class="text-danger">*</span>
                    </label>
                    <textarea class="form-control form-control-modern" name="notes" rows="4" required
                              placeholder="Nêu rõ lý do đi muộn, về sớm hoặc máy chấm công không nhận diện..."></textarea>
                    <div class="form-text small mt-1 text-muted">
                        <i class="bi bi-info-circle me-1"></i> Giải trình sẽ được gửi trực tiếp đến Quản lý bộ phận hoặc HR để phê duyệt.
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 pt-2 gap-2 bg-light">
                    <button type="button" class="btn btn-secondary-modern px-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary-modern px-4">
                        <i class="bi bi-send me-1"></i> Gửi giải trình
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</c:if>
