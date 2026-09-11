<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Vị trí Tuyển dụng & Xem trước Tin tuyển dụng - MIXIMOI HRM" />
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
            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Vị trí tuyển dụng</h1>
                        <span class="badge bg-primary-subtle text-primary fw-bold">ATS Pro</span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý danh mục vị trí, nhu cầu tuyển dụng, ngân sách lương và tiến độ lấp đầy nhân tài toàn công ty.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="alert('Đang trích xuất dữ liệu danh mục vị trí tuyển dụng sang Excel...')">
                        <i class="bi bi-file-earmark-excel"></i>
                        <span>Xuất Excel</span>
                    </button>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2">
                        <i class="bi bi-sliders"></i>
                        <span>Lọc nâng cao</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createJobModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>+ Tạo vị trí</span>
                    </button>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang tuyển</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-briefcase"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">12</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">Vị trí</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">12 vị trí đang mở nhận hồ sơ</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold">+3 mới</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Sắp mở</span>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-clock-history"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">05</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">Kế hoạch</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Dự kiến mở trong Q4/2026</span>
                            <span class="badge bg-info-subtle text-info fw-semibold">Q4 Plan</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã đủ người</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-check2-circle"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">18</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">Hoàn tất</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Hoàn thành 100% chỉ tiêu</span>
                            <span class="badge bg-success-subtle text-success fw-semibold">100% fill</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã đóng</span>
                            <div class="kpi-icon-box amber">
                                <i class="bi bi-archive"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">32</span>
                            <span class="text-muted fw-semibold" style="font-size: 0.85rem;">Lưu trữ</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Đã lưu trữ / đóng đợt tuyển</span>
                            <span class="badge bg-light text-muted border">Archived</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Bar with Table/Card Toggle -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-12 col-md-3">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" placeholder="Tìm theo chức danh, mã...">
                            </div>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả phòng ban</option>
                                <option>CNTT & R&D</option>
                                <option>Kinh doanh</option>
                                <option>Nhân sự</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Tất cả mức lương</option>
                                <option>Dưới 20 triệu</option>
                                <option>20 - 35 triệu</option>
                                <option>35 - 50 triệu</option>
                                <option>Trên 50 triệu</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Hà Nội / TP.HCM / Remote</option>
                                <option>Hà Nội (Hybrid)</option>
                                <option>TP.HCM (Onsite)</option>
                                <option>Toàn quốc (Remote)</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select class="form-select form-select-sm">
                                <option selected>Đang tuyển (12)</option>
                                <option>Tất cả trạng thái</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-1 d-flex justify-content-end gap-1">
                            <div class="btn-group btn-group-sm" role="group">
                                <button type="button" class="btn btn-primary" title="Xem dạng Bảng"><i class="bi bi-table"></i></button>
                                <button type="button" class="btn btn-outline-secondary" title="Xem dạng Thẻ"><i class="bi bi-grid"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Two-Column Split View: Job List Table + Job Preview Drawer -->
            <div class="row g-4">
                <!-- Col-7: Job Openings Table -->
                <div class="col-12 col-xl-7">
                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                        <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2">
                                <h2 class="h6 fw-bold mb-0 text-dark">Danh sách vị trí đang quản lý</h2>
                                <span class="badge bg-primary-subtle text-primary border-0">12 Active</span>
                            </div>
                            <span class="text-muted small"><i class="bi bi-info-circle me-1"></i>Nhấp chuột vào dòng để xem ngay Job Preview</span>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3" style="width: 35px;"><input class="form-check-input" type="checkbox"></th>
                                        <th style="width: 100px;">Mã VT</th>
                                        <th>Vị trí & Cấp bậc</th>
                                        <th>Phòng ban</th>
                                        <th style="width: 130px;">Tiến độ tuyển</th>
                                        <th class="text-center">Ứng viên</th>
                                        <th class="pe-3 text-end">Mức lương</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Row 1: Selected / Active -->
                                    <tr class="table-primary bg-opacity-25" style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox" checked></td>
                                        <td class="fw-bold font-monospace text-primary">VT-2026-01</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <span class="fw-bold text-dark">Senior Fullstack Engineer</span>
                                                <span class="badge bg-danger ms-1">HOT</span>
                                            </div>
                                            <small class="text-muted">React, Node.js, GraphQL • Toàn thời gian</small>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="progress flex-grow-1" style="height: 5px;">
                                                    <div class="progress-bar bg-primary" style="width: 67%;"></div>
                                                </div>
                                                <span class="small fw-bold">2/3</span>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/recruitment?view=candidates" class="text-decoration-none fw-bold text-primary">
                                                38 CV <i class="bi bi-box-arrow-up-right" style="font-size: 0.7rem;"></i>
                                            </a>
                                        </td>
                                        <td class="pe-3 text-end fw-bold text-dark">30 - 45 Tr</td>
                                    </tr>

                                    <!-- Row 2 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">VT-2026-02</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <span class="fw-bold text-dark">Lead Product Designer</span>
                                                <span class="badge bg-primary-subtle text-primary ms-1">Ưu tiên</span>
                                            </div>
                                            <small class="text-muted">Design System, Enterprise UI/UX</small>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="progress flex-grow-1" style="height: 5px;">
                                                    <div class="progress-bar bg-success" style="width: 100%;"></div>
                                                </div>
                                                <span class="small fw-bold text-success">1/1</span>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/recruitment?view=candidates" class="text-decoration-none fw-bold text-primary">
                                                19 CV <i class="bi bi-box-arrow-up-right" style="font-size: 0.7rem;"></i>
                                            </a>
                                        </td>
                                        <td class="pe-3 text-end fw-bold text-dark">35 - 50 Tr</td>
                                    </tr>

                                    <!-- Row 3 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">VT-2026-03</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <span class="fw-bold text-dark">Sales B2B Enterprise Account</span>
                                                <span class="badge bg-danger ms-1">HOT</span>
                                            </div>
                                            <small class="text-muted">Phần mềm SaaS B2B, Key Account</small>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Kinh doanh</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="progress flex-grow-1" style="height: 5px;">
                                                    <div class="progress-bar bg-primary" style="width: 25%;"></div>
                                                </div>
                                                <span class="small fw-bold">1/4</span>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/recruitment?view=candidates" class="text-decoration-none fw-bold text-primary">
                                                45 CV <i class="bi bi-box-arrow-up-right" style="font-size: 0.7rem;"></i>
                                            </a>
                                        </td>
                                        <td class="pe-3 text-end fw-bold text-dark">20 - 35 Tr + HH</td>
                                    </tr>

                                    <!-- Row 4 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">VT-2026-04</td>
                                        <td>
                                            <div class="fw-bold text-dark">DevOps & Cloud Infra Specialist</div>
                                            <small class="text-muted">AWS, Kubernetes, CI/CD Jenkins</small>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="progress flex-grow-1" style="height: 5px;">
                                                    <div class="progress-bar bg-secondary" style="width: 0%;"></div>
                                                </div>
                                                <span class="small fw-bold text-muted">0/2</span>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/recruitment?view=candidates" class="text-decoration-none fw-bold text-primary">
                                                12 CV <i class="bi bi-box-arrow-up-right" style="font-size: 0.7rem;"></i>
                                            </a>
                                        </td>
                                        <td class="pe-3 text-end fw-bold text-dark">28 - 40 Tr</td>
                                    </tr>

                                    <!-- Row 5 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">VT-2026-05</td>
                                        <td>
                                            <div class="fw-bold text-dark">Senior C&B Specialist</div>
                                            <small class="text-muted">Payroll, BHXH, Thuế TNCN & Ngân sách</small>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">Nhân sự</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="progress flex-grow-1" style="height: 5px;">
                                                    <div class="progress-bar bg-success" style="width: 100%;"></div>
                                                </div>
                                                <span class="small fw-bold text-success">1/1</span>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/recruitment?view=candidates" class="text-decoration-none fw-bold text-primary">
                                                26 CV <i class="bi bi-box-arrow-up-right" style="font-size: 0.7rem;"></i>
                                            </a>
                                        </td>
                                        <td class="pe-3 text-end fw-bold text-dark">22 - 30 Tr</td>
                                    </tr>

                                    <!-- Row 6 -->
                                    <tr style="cursor: pointer;">
                                        <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                        <td class="fw-bold font-monospace text-dark">VT-2026-06</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-1">
                                                <span class="fw-bold text-dark">AI & LLM Research Engineer</span>
                                                <span class="badge bg-danger ms-1">HOT</span>
                                            </div>
                                            <small class="text-muted">Python, PyTorch, LangChain, RAG Systems</small>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">CNTT & R&D</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="progress flex-grow-1" style="height: 5px;">
                                                    <div class="progress-bar bg-primary" style="width: 33%;"></div>
                                                </div>
                                                <span class="small fw-bold">1/3</span>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/recruitment?view=candidates" class="text-decoration-none fw-bold text-primary">
                                                64 CV <i class="bi bi-box-arrow-up-right" style="font-size: 0.7rem;"></i>
                                            </a>
                                        </td>
                                        <td class="pe-3 text-end fw-bold text-dark">40 - 65 Tr</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="card-footer bg-white border-top py-3 d-flex justify-content-between align-items-center">
                            <span class="text-muted small">Hiển thị 6 trên tổng số 12 vị trí</span>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Col-5: Job Description Preview Drawer -->
                <div class="col-12 col-xl-5">
                    <div class="job-preview-drawer">
                        <!-- Top Bar of Drawer -->
                        <div class="d-flex justify-content-between align-items-center pb-3 border-bottom mb-3">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-window-sidebar text-primary"></i>
                                <span class="fw-bold text-dark" style="font-size: 0.85rem;">XEM TRƯỚC TIN TUYỂN DỤNG</span>
                            </div>
                            <span class="badge bg-primary">Public Candidate View</span>
                        </div>

                        <!-- Job Title & Meta -->
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <div class="d-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-3" style="width: 48px; height: 48px; font-size: 1.5rem;">
                                <i class="bi bi-building"></i>
                            </div>
                            <div>
                                <span class="badge bg-success-subtle text-success border border-success-subtle mb-1">Đang nhận CV</span>
                                <h3 class="h5 fw-bold text-dark mb-0">Senior Fullstack Engineer (React & Node.js)</h3>
                            </div>
                        </div>

                        <div class="d-flex flex-wrap align-items-center gap-3 text-muted small mb-3">
                            <span><i class="bi bi-geo-alt text-primary me-1"></i>Hà Nội (Hybrid)</span>
                            <span>•</span>
                            <span><i class="bi bi-clock text-primary me-1"></i>Toàn thời gian</span>
                        </div>

                        <!-- Salary highlight -->
                        <div class="job-salary-highlight mb-3">
                            30 - 45 Triệu VNĐ <span class="text-muted fs-6 fw-normal">/ tháng</span>
                        </div>

                        <!-- Action buttons -->
                        <div class="d-flex gap-2 mb-4">
                            <button type="button" class="btn btn-primary btn-sm flex-grow-1 d-flex align-items-center justify-content-center gap-2">
                                <i class="bi bi-send-fill"></i>
                                <span>Ứng tuyển mẫu</span>
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-2">
                                <i class="bi bi-share"></i>
                                <span>Chia sẻ tin</span>
                            </button>
                        </div>

                        <!-- Recruiter Info -->
                        <div class="p-3 bg-light rounded-3 d-flex align-items-center justify-content-between mb-4">
                            <div class="d-flex align-items-center gap-2">
                                <div class="avatar-circle bg-primary text-white fw-bold" style="width: 36px; height: 36px; font-size: 0.8rem;">TA</div>
                                <div>
                                    <div class="fw-bold text-dark" style="font-size: 0.83rem;">Phạm Phương Thảo</div>
                                    <small class="text-muted">Talent Acquisition Lead</small>
                                </div>
                            </div>
                            <span class="badge bg-light text-dark border font-monospace">VT-2026-01</span>
                        </div>

                        <!-- Job Description Content -->
                        <div class="mb-4">
                            <div class="fw-bold text-dark text-uppercase small mb-2 d-flex align-items-center gap-1">
                                <i class="bi bi-card-text text-primary"></i>
                                <span>MÔ TẢ CÔNG VIỆC (JOB DESCRIPTION)</span>
                            </div>
                            <ul class="text-muted small ps-3 mb-0" style="line-height: 1.7;">
                                <li>Xây dựng kiến trúc hệ thống HRM & Payroll SaaS chịu tải cao cho 50,000+ nhân sự.</li>
                                <li>Thiết kế, phát triển và tối ưu Microservices bằng Node.js, TypeScript và GraphQL.</li>
                                <li>Xây dựng giao diện web bằng React, Next.js, Tailwind CSS với độ trễ phản hồi dưới 150ms.</li>
                                <li>Phối hợp cùng Product Owner & UI/UX Designer để chuẩn hoá trải nghiệm nhân sự thông minh.</li>
                            </ul>
                        </div>

                        <!-- Requirements Content -->
                        <div>
                            <div class="fw-bold text-dark text-uppercase small mb-2 d-flex align-items-center gap-1">
                                <i class="bi bi-check-circle text-primary"></i>
                                <span>YÊU CẦU ỨNG VIÊN (REQUIREMENTS)</span>
                            </div>
                            <ul class="text-muted small ps-3 mb-0" style="line-height: 1.7;">
                                <li>Từ 4+ năm kinh nghiệm thực chiến với React.js, TypeScript và Node.js/Golang.</li>
                                <li>Thành thạo cơ sở dữ liệu quan hệ (PostgreSQL) và NoSQL (Redis, MongoDB).</li>
                                <li>Có kinh nghiệm tích hợp CI/CD, Docker container, Kubernetes và kiến trúc Event-driven.</li>
                            </ul>
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
