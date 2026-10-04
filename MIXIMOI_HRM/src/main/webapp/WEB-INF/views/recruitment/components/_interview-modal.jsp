<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- ========================================================================= -->
<!-- MODAL: XẾP LỊCH PHỎNG VẤN ỨNG VIÊN (#scheduleCandInterviewModal)         -->
<!-- ========================================================================= -->
<div class="modal fade" id="scheduleCandInterviewModal" tabindex="-1" aria-labelledby="scheduleCandInterviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-md modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-calendar-plus-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="scheduleCandInterviewModalLabel">Xếp Lịch Phỏng Vấn Cho Ứng Viên</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Lên lịch phỏng vấn và chuyển ứng viên vào vòng phỏng vấn</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                <input type="hidden" name="action" value="schedule_interview">
                <input type="hidden" name="returnView" value="candidates">
                <input type="hidden" name="candidateId" id="modalInterviewCandId" value="${selectedCandidate.id}">
                <input type="hidden" name="recruitmentRequestId" value="${selectedCandidate.recruitmentRequestId}">
                <div class="modal-body p-4">
                    <div class="p-3 bg-light rounded-3 mb-3 border">
                        <div class="small text-muted">Ứng viên:</div>
                        <div class="fw-bold text-dark fs-6" id="modalInterviewCandName">${selectedCandidate.fullName} (${selectedCandidate.candidateCode})</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Người phỏng vấn (Interviewer) <span class="text-danger">*</span></label>
                        <select class="form-select form-select-sm" name="interviewerId" required>
                            <c:forEach items="${employees}" var="emp">
                                <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Vòng phỏng vấn</label>
                        <select class="form-select form-select-sm" name="roundName">
                            <option value="Vòng 1 (HR Fit & Văn hóa)">Vòng 1 (HR Fit & Văn hóa)</option>
                            <option value="Vòng Chuyên môn & Kỹ thuật" selected>Vòng Chuyên môn & Kỹ thuật</option>
                            <option value="Vòng Portfolio / Bài Test">Vòng Portfolio / Bài Test</option>
                            <option value="Vòng Ban Giám đốc">Vòng Ban Giám đốc</option>
                        </select>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-muted">Ngày phỏng vấn <span class="text-danger">*</span></label>
                            <input type="date" class="form-control form-control-sm" name="interviewDate" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-muted">Giờ phỏng vấn <span class="text-danger">*</span></label>
                            <input type="time" class="form-control form-control-sm" name="interviewTime" value="09:30" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Địa điểm hoặc Link Google Meet</label>
                        <input type="text" class="form-control form-control-sm" name="locationOrLink" value="Phòng họp Tầng 4 & Google Meet: meet.google.com/mix-rec">
                    </div>
                </div>
                <div class="modal-footer bg-light border-top p-3 px-4">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                        <i class="bi bi-check-lg"></i>
                        <span>Lưu lịch phỏng vấn</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
