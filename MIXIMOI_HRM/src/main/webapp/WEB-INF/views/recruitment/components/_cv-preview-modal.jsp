<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- ========================================================================= -->
<!-- MODAL: XEM BẢN MỀM CV & CHI TIẾT ỨNG VIÊN (#viewCandidateCvModal)         -->
<!-- ========================================================================= -->
<div class="modal fade" id="viewCandidateCvModal" tabindex="-1" aria-labelledby="viewCandidateCvModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <!-- Modal Header / Document Toolbar -->
            <div class="modal-header p-3 px-4 text-white" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);">
                <div class="d-flex align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-file-earmark-pdf-fill fs-4 text-danger" id="viewerCvHeaderIcon"></i>
                        <div>
                            <div class="d-flex align-items-center gap-2">
                                <h5 class="modal-title fw-bold mb-0 text-white" id="viewerCandName">Nguyễn Hoàng Nam</h5>
                                <span class="badge bg-primary-subtle text-primary font-monospace" id="viewerCandCode">UV-2026-001</span>
                                <span class="badge bg-success" id="viewerCvTypeBadge">Bản PDF (.pdf)</span>
                            </div>
                            <small class="text-white text-opacity-75" id="viewerCandJob">Senior Fullstack Engineer • Phòng Kỹ thuật</small>
                        </div>
                    </div>
                </div>

                <!-- Document Toolbar -->
                <div class="d-flex align-items-center gap-2">
                    <div class="btn-group btn-group-sm bg-white bg-opacity-10 rounded">
                        <button type="button" class="btn btn-sm text-white" onclick="changeCvZoom(-0.1)" title="Thu nhỏ"><i class="bi bi-zoom-out"></i></button>
                        <span class="btn btn-sm text-white disabled px-2" id="viewerZoomLevel">100%</span>
                        <button type="button" class="btn btn-sm text-white" onclick="changeCvZoom(0.1)" title="Phóng to"><i class="bi bi-zoom-in"></i></button>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-light" onclick="printCandidateCv()" title="In CV"><i class="bi bi-printer me-1"></i>In CV</button>
                    <button type="button" class="btn btn-sm btn-outline-light" onclick="downloadCandidateCv()" title="Tải file"><i class="bi bi-download me-1"></i>Tải về</button>
                    <button type="button" class="btn-close btn-close-white ms-2" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
            </div>

            <!-- Modal Body: High-Fidelity Soft-Copy CV Document Sheet -->
            <div class="modal-body p-4" style="background: #e2e8f0;">
                <div class="container-fluid p-0 d-flex justify-content-center">
                    <div id="cvDocumentSheet" class="card border-0 shadow-lg rounded-3 p-4 p-md-5 bg-white text-dark" style="max-width: 860px; width: 100%; min-height: 850px; transition: transform 0.2s; transform-origin: top center;">
                        <!-- CV Header -->
                        <div class="row g-4 align-items-center border-bottom pb-4 mb-4">
                            <div class="col-auto">
                                <div id="viewerDocAvatar" class="avatar-circle bg-primary text-white fw-bold shadow" style="width: 76px; height: 76px; font-size: 1.85rem;">
                                    HN
                                </div>
                            </div>
                            <div class="col">
                                <h2 class="fw-bold text-dark mb-1 text-uppercase" id="viewerDocFullName" style="letter-spacing: 0.5px;">Nguyễn Hoàng Nam</h2>
                                <h5 class="text-primary fw-semibold mb-2" id="viewerDocJobTitle">Senior Fullstack Engineer</h5>
                                <div class="d-flex flex-wrap gap-3 text-muted small">
                                    <span><i class="bi bi-envelope me-1 text-primary"></i><span id="viewerDocEmail">nam.nv@example.com</span></span>
                                    <span><i class="bi bi-telephone me-1 text-primary"></i><span id="viewerDocPhone">0912.345.678</span></span>
                                    <span><i class="bi bi-cash me-1 text-success"></i>Kỳ vọng: <strong class="text-dark" id="viewerDocSalary">35.000.000 VNĐ</strong></span>
                                    <span><i class="bi bi-briefcase me-1 text-secondary"></i>Kinh nghiệm: <strong class="text-dark" id="viewerDocExpYears">4.0 năm</strong></span>
                                </div>
                            </div>
                            <div class="col-12 col-md-auto text-end">
                                <span class="badge bg-success-subtle text-success fs-6 border border-success px-3 py-2" id="viewerDocScoreBadge">
                                    <i class="bi bi-stars me-1"></i>AI MATCH: 92%
                                </span>
                            </div>
                        </div>

                        <!-- CV Body Sections -->
                        <div class="row g-4">
                            <!-- Left Column: Summary & Skills -->
                            <div class="col-md-5 border-end">
                                <div class="mb-4">
                                    <h6 class="text-uppercase fw-bold text-dark border-bottom pb-2 mb-2"><i class="bi bi-person-lines-fill text-primary me-2"></i>Tóm tắt năng lực</h6>
                                    <p class="small text-muted mb-0" id="viewerDocSummary" style="line-height: 1.6;">
                                        Kỹ sư phần mềm Fullstack giàu kinh nghiệm, chuyên sâu Java Spring Boot, Microservices, Docker, Kubernetes và hệ thống cơ sở dữ liệu phân tán PostgreSQL.
                                    </p>
                                </div>

                                <div class="mb-4">
                                    <h6 class="text-uppercase fw-bold text-dark border-bottom pb-2 mb-2"><i class="bi bi-tools text-primary me-2"></i>Kỹ năng chuyên môn</h6>
                                    <div class="d-flex flex-wrap gap-1" id="viewerDocSkillsList">
                                        <span class="badge bg-light text-dark border">Java</span>
                                        <span class="badge bg-light text-dark border">Spring Boot</span>
                                        <span class="badge bg-light text-dark border">PostgreSQL</span>
                                        <span class="badge bg-light text-dark border">Docker</span>
                                        <span class="badge bg-light text-dark border">Kubernetes</span>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <h6 class="text-uppercase fw-bold text-dark border-bottom pb-2 mb-2"><i class="bi bi-mortarboard-fill text-primary me-2"></i>Học vấn & Bằng cấp</h6>
                                    <div class="small">
                                        <div class="fw-semibold text-dark" id="viewerDocEducation">Đại học Bách Khoa Hà Nội</div>
                                        <div class="text-muted">Cử nhân Công nghệ thông tin • 2018 - 2022</div>
                                        <div class="text-muted small">Tốt nghiệp loại Giỏi (GPA 3.6/4.0)</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column: Work Experience & Details -->
                            <div class="col-md-7">
                                <div class="mb-4">
                                    <h6 class="text-uppercase fw-bold text-dark border-bottom pb-2 mb-3"><i class="bi bi-building text-primary me-2"></i>Kinh nghiệm làm việc</h6>
                                    <div id="viewerDocWorkHistory">
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between">
                                                <div class="fw-bold text-dark small">Tech Lead / Senior Developer</div>
                                                <span class="badge bg-light text-muted border">2022 - Nay</span>
                                            </div>
                                            <div class="text-primary small mb-1">Công ty Giải pháp Công nghệ Quốc tế</div>
                                            <p class="text-muted small mb-0" style="line-height: 1.5;">
                                                Phát triển kiến trúc backend xử lý 500K RPS, tối ưu hóa câu lệnh SQL PostgreSQL, triển khai CI/CD tự động.
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <h6 class="text-uppercase fw-bold text-dark border-bottom pb-2 mb-2"><i class="bi bi-card-text text-primary me-2"></i>Văn bản trích xuất OCR đầy đủ</h6>
                                    <div class="p-3 bg-light rounded-3 border small text-muted font-monospace" id="viewerDocRawText" style="max-height: 180px; overflow-y: auto; white-space: pre-wrap;">
                                        (Đang đồng bộ dữ liệu văn bản số hóa...)
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Footer -->
            <div class="modal-footer bg-light border-top p-3 px-4 d-flex justify-content-between align-items-center">
                <div class="text-muted small">
                    <i class="bi bi-shield-check text-success me-1"></i>Hồ sơ số hóa đạt chuẩn ATS &amp; Bảo mật GDPR
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary" onclick="alert('Đã sẵn sàng điều phối hồ sơ ứng viên.')">
                        <i class="bi bi-check2-circle me-1"></i>Xác Nhận Xem CV Xong
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
