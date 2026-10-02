<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- ============================================================
     MODAL: Xem lịch sử chi tiết chấm công (Dùng chung cho các Role)
     ============================================================ --%>
<div class="modal fade" id="historyModal" tabindex="-1" aria-labelledby="historyModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:500px;">
        <div class="modal-content modal-custom-card">
            <div class="modal-header modal-header-gradient">
                <div class="d-flex align-items-center gap-3">
                    <div class="modal-icon-badge bg-info text-white">
                        <i class="bi bi-clock-history fs-5"></i>
                    </div>
                    <div>
                        <h6 class="modal-title fw-bold text-dark mb-0" id="historyModalLabel">
                            Lịch sử chi tiết lượt chấm công
                        </h6>
                        <p class="text-muted small mb-0">Thông tin xác thực sinh trắc học và thời gian biểu</p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4">
                <div class="d-flex align-items-center gap-3 p-3 mb-3 rounded-3 border bg-light">
                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold text-primary bg-primary-subtle" style="width:46px;height:46px; font-size:1.1rem;">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <div>
                        <div class="fw-bold text-dark fs-6" id="histEmpName">—</div>
                        <div class="text-muted small font-monospace" id="histEmpCode">—</div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-6">
                        <span class="text-muted small d-block mb-1">Ngày làm việc:</span>
                        <div class="fw-bold text-dark font-monospace" id="histDate">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted small d-block mb-1">Ca làm việc:</span>
                        <div class="fw-bold text-dark" id="histShift">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted small d-block mb-1">Giờ vào (Check-in):</span>
                        <div class="fw-bold text-success font-monospace" id="histCheckIn">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted small d-block mb-1">Giờ ra (Check-out):</span>
                        <div class="fw-bold text-primary font-monospace" id="histCheckOut">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted small d-block mb-1">Phương thức xác thực:</span>
                        <div class="fw-semibold text-dark" id="histMethod">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted small d-block mb-1">Tổng giờ làm việc:</span>
                        <div class="fw-bold text-dark font-monospace" id="histHours">—</div>
                    </div>
                    <div class="col-12 pt-2 border-top">
                        <span class="text-muted small d-block mb-1">Trạng thái ghi nhận:</span>
                        <div><span class="badge bg-primary-subtle text-primary border px-2 py-1" id="histStatus">—</span></div>
                    </div>
                </div>
            </div>

            <div class="modal-footer border-0 px-4 pb-4 pt-1 bg-light">
                <button type="button" class="btn btn-secondary-modern px-4 w-100" data-bs-dismiss="modal">Đóng cửa sổ</button>
            </div>
        </div>
    </div>
</div>
