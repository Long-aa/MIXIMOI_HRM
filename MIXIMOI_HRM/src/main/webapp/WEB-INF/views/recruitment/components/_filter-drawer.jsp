<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- ========================================================================= -->
<!-- MODAL: BỘ LỌC ĐA CHIỀU HỒ SƠ ỨNG VIÊN (#candAdvancedFilterModal)          -->
<!-- ========================================================================= -->
<div class="modal fade" id="candAdvancedFilterModal" tabindex="-1" aria-labelledby="candAdvancedFilterModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header bg-dark text-white p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-sliders fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="candAdvancedFilterModalLabel">Lọc Nâng Cao Hồ Sơ Ứng Viên</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Lọc dữ liệu hồ sơ thật trong PostgreSQL theo vị trí, vòng tuyển dụng và nguồn</small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="GET" action="${pageContext.request.contextPath}/recruitment">
                <input type="hidden" name="view" value="candidates">
                <div class="modal-body p-4" style="background: #f8fafc;">
                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Từ khóa tìm kiếm (Họ tên / Email / Mã UV)</label>
                            <input type="text" class="form-control form-control-sm" name="search" value="${searchKeyword}" placeholder="VD: Nguyễn Văn A, UV-2026-001...">
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-muted">Vị trí tuyển dụng</label>
                                <select class="form-select form-select-sm" name="requestId">
                                    <option value="">Tất cả vị trí (${jobs != null ? jobs.size() : 0})</option>
                                    <c:forEach items="${jobs}" var="j">
                                        <option value="${j.id}" ${selectedRequestId == j.id ? 'selected' : ''}>${j.title}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-muted">Giai đoạn phễu tuyển dụng</label>
                                <select class="form-select form-select-sm" name="stage">
                                    <option value="">Tất cả giai đoạn</option>
                                    <option value="NEW" ${selectedStage eq 'NEW' ? 'selected' : ''}>Mới nộp (NEW)</option>
                                    <option value="SCREENING" ${selectedStage eq 'SCREENING' ? 'selected' : ''}>Sàng lọc CV (SCREENING)</option>
                                    <option value="INTERVIEW" ${selectedStage eq 'INTERVIEW' ? 'selected' : ''}>Phỏng vấn (INTERVIEW)</option>
                                    <option value="OFFER" ${selectedStage eq 'OFFER' ? 'selected' : ''}>Đề xuất Offer (OFFER)</option>
                                    <option value="ONBOARDED" ${selectedStage eq 'ONBOARDED' ? 'selected' : ''}>Đã nhận việc (ONBOARDED)</option>
                                </select>
                            </div>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-12">
                                <label class="form-label small fw-semibold text-muted">Kênh nguồn tuyển dụng</label>
                                <select class="form-select form-select-sm" name="source">
                                    <option value="">Nguồn ứng viên: Tất cả</option>
                                    <option value="LinkedIn" ${selectedSource eq 'LinkedIn' ? 'selected' : ''}>LinkedIn</option>
                                    <option value="TopCV/VNW" ${selectedSource eq 'TopCV/VNW' ? 'selected' : ''}>TopCV / VietnamWorks</option>
                                    <option value="Nội bộ (Ref)" ${selectedSource eq 'Nội bộ (Ref)' ? 'selected' : ''}>Nội bộ (Ref)</option>
                                    <option value="Khác" ${selectedSource eq 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white border-top p-3 px-4">
                    <a href="${pageContext.request.contextPath}/recruitment?view=candidates" class="btn btn-outline-secondary">Đặt lại</a>
                    <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                        <i class="bi bi-funnel-fill"></i>
                        <span>Áp Dụng Lọc Dữ Liệu Thật</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
