<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Hồ sơ Ứng viên & ATS Kanban Pipeline - MIXIMOI HRM" />
    </jsp:include>
</head>
<body class="hrm-app-body">
<div class="app-layout">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <div class="app-main">
        <!-- Topbar -->
        <jsp:include page="/WEB-INF/views/common/topbar.jsp" />

        <!-- Main Content Area -->
        <main class="app-content p-3 p-lg-4">
            <!-- Toast notification if action done -->
            <c:if test="${param.success eq 'offer_sent'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-send-check-fill fs-5 text-success"></i>
                    <div>Đã phát hành gói Thư mời làm việc (Offer Letter) <strong>42.000.000 VNĐ</strong> tới ứng viên Lê Hoàng Nam thành công!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Ứng viên</h1>
                        <span class="badge bg-primary-subtle text-primary fw-bold">ATS PIPELINE PRO</span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý hồ sơ, tài liệu đánh giá và tiến trình tự động của ứng viên theo chuẩn 7 giai đoạn chiến lược.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="alert('Đang trích xuất danh sách hồ sơ ứng viên...')">
                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Xuất danh sách</span>
                    </button>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2">
                        <i class="bi bi-sliders"></i>
                        <span>Lọc nâng cao</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#addCandidateModal">
                        <i class="bi bi-person-plus-fill"></i>
                        <span>+ Thêm ứng viên</span>
                    </button>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Tổng ứng viên</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">86</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Đang chạy trong 6 vị trí chiến lược</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold">↗ +12% tháng này</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Ứng viên mới</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-envelope"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">18</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">+7 hồ sơ được nộp trong 24h qua</span>
                            <span class="badge bg-warning-subtle text-warning-emphasis fw-semibold">! Cần sàng lọc</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang phỏng vấn</span>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-calendar-event"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">24</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Vòng Tech Test & Ban điều hành</span>
                            <span class="badge bg-info-subtle text-info fw-semibold">8 lịch tuần này</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã nhận việc</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-shield-check"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">5</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Đang hoàn tất hợp đồng thử việc</span>
                            <span class="badge bg-success-subtle text-success fw-semibold">Tỷ lệ chốt: 62.5%</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar with View Mode Toggle -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-12 col-md-4">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" placeholder="Tìm theo tên, email, kỹ năng...">
                            </div>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả vị trí (6)</option>
                                <option>Senior Fullstack Engineer</option>
                                <option>Product Designer</option>
                                <option>Sales B2B Lead</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả giai đoạn (7)</option>
                                <option>Mới nộp (18)</option>
                                <option>Sàng lọc CV (21)</option>
                                <option>Phỏng vấn (24)</option>
                                <option>Offer (8)</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Nguồn ứng viên</option>
                                <option>LinkedIn</option>
                                <option>TopCV</option>
                                <option>Referral</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2 d-flex justify-content-end gap-1">
                            <div class="btn-group btn-group-sm" role="group">
                                <button type="button" class="btn btn-primary d-flex align-items-center gap-1" title="Chế độ Kanban">
                                    <i class="bi bi-kanban"></i>
                                    <span class="d-none d-sm-inline">Kanban</span>
                                </button>
                                <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-1" title="Chế độ Bảng">
                                    <i class="bi bi-list-ul"></i>
                                    <span class="d-none d-sm-inline">Bảng</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Two-Column Layout: Kanban Board + Candidate Detail Drawer -->
            <div class="row g-4">
                <!-- Col-6: Kanban Board Pipeline -->
                <div class="col-12 col-xl-6">
                    <div class="kanban-board-wrapper">
                        <!-- Column 1: Mới nộp -->
                        <div class="kanban-column">
                            <div class="d-flex justify-content-between align-items-center px-1">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge-dot-indicator bg-primary"></span>
                                    <span class="fw-bold text-dark" style="font-size: 0.84rem;">Mới nộp</span>
                                </div>
                                <span class="badge bg-light text-muted border">18</span>
                            </div>

                            <!-- Card 1 -->
                            <div class="kanban-card">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge bg-info-subtle text-info">UI/UX Designer</span>
                                    <small class="text-muted">Hôm nay</small>
                                </div>
                                <div class="fw-bold text-dark" style="font-size: 0.9rem;">Trần Thị Mai</div>
                                <div class="text-muted small mb-2">Figma, Design Systems, ProtoPie</div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                    <span class="text-warning small"><i class="bi bi-star-fill"></i> 4.8</span>
                                    <span class="badge bg-light text-muted border">TopCV</span>
                                </div>
                            </div>

                            <!-- Card 2 -->
                            <div class="kanban-card">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge bg-primary-subtle text-primary">DevOps Eng</span>
                                    <small class="text-muted">Hôm qua</small>
                                </div>
                                <div class="fw-bold text-dark" style="font-size: 0.9rem;">Vũ Anh Khoa</div>
                                <div class="text-muted small mb-2">Kubernetes, Terraform, AWS</div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                    <span class="text-warning small"><i class="bi bi-star-fill"></i> 4.2</span>
                                    <span class="badge bg-light text-muted border">LinkedIn</span>
                                </div>
                            </div>
                        </div>

                        <!-- Column 2: Sàng lọc CV -->
                        <div class="kanban-column">
                            <div class="d-flex justify-content-between align-items-center px-1">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge-dot-indicator bg-info"></span>
                                    <span class="fw-bold text-dark" style="font-size: 0.84rem;">Sàng lọc CV</span>
                                </div>
                                <span class="badge bg-light text-muted border">21</span>
                            </div>

                            <!-- Card 1 -->
                            <div class="kanban-card">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge bg-purple-subtle text-purple" style="background: #f3e8ff; color: #7e22ce;">AI Engineer</span>
                                    <span class="badge bg-success-subtle text-success">CV Test: 88%</span>
                                </div>
                                <div class="fw-bold text-dark" style="font-size: 0.9rem;">Đỗ Quốc Bảo</div>
                                <div class="text-muted small mb-2">PyTorch, LangChain, RAG, NLP</div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                    <span class="text-warning small"><i class="bi bi-star-fill"></i> 4.9</span>
                                    <span class="badge bg-light text-muted border">Referral</span>
                                </div>
                            </div>

                            <!-- Card 2 -->
                            <div class="kanban-card">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge bg-warning-subtle text-warning-emphasis">Product Owner</span>
                                    <small class="text-muted">3 ngày trước</small>
                                </div>
                                <div class="fw-bold text-dark" style="font-size: 0.9rem;">Hoàng Thảo Vy</div>
                                <div class="text-muted small mb-2">Fintech ERP, Scrum, Roadmap</div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                    <span class="text-warning small"><i class="bi bi-star-fill"></i> 4.0</span>
                                    <span class="badge bg-light text-muted border">VietnamWorks</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Col-6: Candidate Detail Drawer (Lê Hoàng Nam) -->
                <div class="col-12 col-xl-6">
                    <div class="candidate-detail-drawer">
                        <!-- Candidate Header with Avatar & Rating -->
                        <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="position-relative">
                                    <div class="avatar-circle bg-primary text-white fw-bold" style="width: 52px; height: 52px; font-size: 1.15rem;">LN</div>
                                    <span class="position-absolute bottom-0 end-0 bg-success text-white rounded-circle p-1" style="font-size: 0.6rem;"><i class="bi bi-check-lg"></i></span>
                                </div>
                                <div>
                                    <div class="d-flex align-items-center gap-2">
                                        <h3 class="h5 fw-bold text-dark mb-0">Lê Hoàng Nam</h3>
                                        <span class="badge bg-primary-subtle text-primary font-monospace">UV-2026-081</span>
                                    </div>
                                    <div class="text-primary fw-semibold" style="font-size: 0.86rem;">Senior Fullstack Engineer</div>
                                    <div class="d-flex align-items-center gap-2 text-warning small mt-1">
                                        <span>⭐⭐⭐⭐⭐</span>
                                        <strong class="text-dark">5.0</strong>
                                        <span class="text-muted">(Điểm chuẩn: 9.0/10)</span>
                                    </div>
                                </div>
                            </div>

                            <a href="#" class="text-muted" title="Mở trang hồ sơ riêng"><i class="bi bi-box-arrow-up-right fs-5"></i></a>
                        </div>

                        <!-- 3 Action Buttons -->
                        <div class="row g-2 mb-3">
                            <div class="col-4">
                                <form method="post" action="${pageContext.request.contextPath}/recruitment" class="m-0">
                                    <input type="hidden" name="action" value="send_offer">
                                    <button type="submit" class="btn btn-primary btn-sm w-100 d-flex align-items-center justify-content-center gap-1 shadow-sm">
                                        <i class="bi bi-envelope-paper"></i> Gửi thư Offer
                                    </button>
                                </form>
                            </div>
                            <div class="col-4">
                                <button type="button" class="btn btn-outline-secondary btn-sm w-100 d-flex align-items-center justify-content-center gap-1">
                                    <i class="bi bi-calendar-plus"></i> Lên lịch tiếp
                                </button>
                            </div>
                            <div class="col-4">
                                <button type="button" class="btn btn-outline-danger btn-sm w-100 d-flex align-items-center justify-content-center gap-1">
                                    <i class="bi bi-person-x"></i> Từ chối hồ sơ
                                </button>
                            </div>
                        </div>

                        <!-- Contact Grid -->
                        <div class="row g-2 mb-3" style="font-size: 0.8rem;">
                            <div class="col-6">
                                <span class="text-muted"><i class="bi bi-envelope me-1"></i>Email:</span>
                                <strong class="text-dark ms-1">nam.lehoang@gmail.com</strong>
                            </div>
                            <div class="col-6">
                                <span class="text-muted"><i class="bi bi-telephone me-1"></i>Điện thoại:</span>
                                <strong class="text-dark ms-1">0982 455 120</strong>
                            </div>
                            <div class="col-6">
                                <span class="text-muted"><i class="bi bi-geo-alt me-1"></i>Địa chỉ:</span>
                                <span class="text-dark ms-1">Cầu Giấy, Hà Nội</span>
                            </div>
                            <div class="col-6">
                                <span class="text-muted"><i class="bi bi-link-45deg me-1"></i>Profile:</span>
                                <a href="#" class="text-primary ms-1 text-decoration-none fw-semibold">LinkedIn</a> / <a href="#" class="text-primary text-decoration-none fw-semibold">GitHub</a>
                            </div>
                        </div>

                        <!-- CV Attachment Card -->
                        <div class="p-2 px-3 bg-light border rounded-3 d-flex justify-content-between align-items-center mb-3">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-file-earmark-pdf-fill text-danger fs-4"></i>
                                <div>
                                    <div class="fw-bold text-dark" style="font-size: 0.83rem;">CV_LeHoangNam_LeadDev.pdf</div>
                                    <small class="text-muted">2.4 MB • Tải lên 3 ngày trước</small>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <button class="btn btn-sm btn-light border py-1 px-2" title="Xem trước"><i class="bi bi-eye"></i></button>
                                <button class="btn btn-sm btn-light border py-1 px-2" title="Tải xuống"><i class="bi bi-download"></i></button>
                            </div>
                        </div>

                        <!-- Education & Experience -->
                        <div class="mb-3">
                            <div class="fw-bold text-dark small text-uppercase mb-1">HỌC VẤN & KINH NGHIỆM</div>
                            <div class="d-flex align-items-center gap-2 small text-dark mb-1">
                                <i class="bi bi-mortarboard text-primary"></i>
                                <span>Đại học Bách Khoa Hà Nội - Kỹ sư Công nghệ Thông tin (Loại Giỏi)</span>
                            </div>
                            <div class="d-flex align-items-center gap-2 small text-dark">
                                <i class="bi bi-briefcase text-primary"></i>
                                <span>5+ năm kinh nghiệm tại tập đoàn Fintech & SaaS Enterprise</span>
                            </div>
                        </div>

                        <!-- Skill Tags -->
                        <div class="d-flex flex-wrap gap-1 mb-3">
                            <span class="badge bg-light text-dark border">React.js</span>
                            <span class="badge bg-light text-dark border">Node.js</span>
                            <span class="badge bg-light text-dark border">TypeScript</span>
                            <span class="badge bg-light text-dark border">Docker</span>
                            <span class="badge bg-light text-dark border">AWS Cloud</span>
                            <span class="badge bg-light text-dark border">PostgreSQL</span>
                            <span class="badge bg-light text-dark border">System Architecture</span>
                        </div>

                        <!-- Evaluation History -->
                        <div class="mb-3">
                            <div class="fw-bold text-dark small text-uppercase mb-2">LỊCH SỬ ĐÁNH GIÁ VÒNG TUYỂN</div>
                            
                            <!-- Round 1 -->
                            <div class="p-2 px-3 border rounded-2 bg-light mb-2" style="font-size: 0.78rem;">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="fw-bold text-dark">Vòng 1: HR Screener & Văn hóa</span>
                                    <span class="badge bg-success-subtle text-success">8.5 / 10 • Đạt</span>
                                </div>
                                <div class="text-muted fst-italic">"Giao tiếp tự tin, phong thái điềm đạm, định hướng gắn bó lâu dài và tư duy làm sản phẩm phù hợp MIXIMOI."</div>
                                <div class="text-end text-muted small mt-1">Đánh giá bởi: <strong>Nguyễn Mai Lan (HR BP)</strong></div>
                            </div>

                            <!-- Round 2 -->
                            <div class="p-2 px-3 border rounded-2 bg-light" style="font-size: 0.78rem;">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="fw-bold text-dark">Vòng 2: Chuyên môn & Kiến trúc</span>
                                    <span class="badge bg-success text-white">9.0 / 10 • Đạt xuất sắc</span>
                                </div>
                                <div class="text-muted fst-italic">"Nắm rất vững kỹ thuật Microservices & High-concurrency database. Trả lời bài toán tối ưu latency cực kỳ thuyết phục."</div>
                                <div class="text-end text-muted small mt-1">Đánh giá bởi: <strong>Trần Tuấn Hưng (Tech Lead)</strong></div>
                            </div>
                        </div>

                        <!-- Offer Proposal Card -->
                        <div class="p-3 bg-primary-subtle bg-opacity-25 border border-primary-subtle rounded-3">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="fw-bold text-primary small text-uppercase">THÔNG TIN GÓI OFFER ĐỀ XUẤT</span>
                                <i class="bi bi-cash-stack text-primary fs-5"></i>
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-6">
                                    <small class="text-muted d-block">Mức lương Net đề xuất</small>
                                    <span class="fw-bold text-primary fs-5">42.000.000 đ</span>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted d-block">Ngày dự kiến Onboard</small>
                                    <span class="fw-bold text-dark fs-6">15/10/2026</span>
                                </div>
                            </div>
                            <div class="small text-muted border-top pt-2">
                                <i class="bi bi-info-circle text-primary me-1"></i>
                                Bao gồm 100% lương thử việc, gói BH Sức khỏe Bảo Việt & 14 ngày phép/năm.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
