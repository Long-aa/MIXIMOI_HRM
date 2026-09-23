<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Vị trí Tuyển dụng & Xem trước Tin tuyển dụng — MIXIMOI HRM</title>
                    <%@ include file="/WEB-INF/views/common/head.jsp" %>
                </head>

                <body class="hrm-app-body">
                    <div class="app-container">
                        <c:set var="activeMenu" value="recruitment" scope="request" />
                        <c:set var="activeSubMenu" value="jobs" scope="request" />
                        <!-- Sidebar -->
                        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

                            <div class="app-main">
                                <!-- Topbar -->
                                <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

                                    <!-- Main Content Area -->
                                    <main class="app-content p-3 p-lg-4">

                                        <!-- Toast / Alerts Notification -->
                                        <c:if test="${param.success eq 'job_created'}">
                                            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                                                <div><strong>Thành công!</strong> Đã tạo mới và đăng tuyển vị trí tuyển
                                                    dụng thành công vào hệ thống.</div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${param.success eq 'ai_promoted'}">
                                            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-stars fs-5 text-purple" style="color:#7e22ce;"></i>
                                                <div><strong>AI Tuyển Dụng Thành Công!</strong> Đã tự động chuyển TOP 3
                                                    ứng viên xuất sắc nhất do AI sàng lọc vào danh sách Vòng Phỏng vấn!
                                                </div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${param.error eq 'create_failed'}">
                                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                                                <div><strong>Lỗi!</strong> Không thể tạo vị trí tuyển dụng. Vui lòng
                                                    kiểm tra lại thông tin nhập.</div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>

                                        <!-- Header -->
                                        <div
                                            class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                                            <div>
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <h1 class="h3 fw-bold text-dark mb-0">Vị trí tuyển dụng</h1>
                                                    <span class="badge bg-primary-subtle text-primary fw-bold">ATS
                                                        Pro</span>
                                                </div>
                                                <p class="text-muted mb-0" style="font-size: 0.875rem;">
                                                    Quản lý danh mục vị trí, nhu cầu tuyển dụng, ngân sách lương và tiến
                                                    độ lấp đầy nhân tài toàn công ty.
                                                </p>
                                            </div>
                                            <div class="d-flex flex-wrap gap-2">
                                                <button type="button"
                                                    class="btn text-white d-flex align-items-center gap-2 shadow-sm"
                                                    style="background: linear-gradient(135deg, #7e22ce 0%, #2563eb 100%); border: none;"
                                                    data-bs-toggle="modal" data-bs-target="#aiCvScreeningModal">
                                                    <i class="bi bi-stars"></i>
                                                    <span>🤖 AI Lọc CV Tự Động</span>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/recruitment?action=export_report"
                                                    class="btn btn-outline-secondary d-flex align-items-center gap-2 text-decoration-none">
                                                    <i class="bi bi-file-earmark-excel"></i>
                                                    <span>Xuất Excel</span>
                                                </a>
                                                <button type="button"
                                                    class="btn btn-outline-secondary d-flex align-items-center gap-2"
                                                    onclick="toggleAdvancedFilter()">
                                                    <i class="bi bi-sliders"></i>
                                                    <span>Lọc nâng cao</span>
                                                </button>
                                                <button type="button"
                                                    class="btn btn-primary d-flex align-items-center gap-2 shadow-sm"
                                                    data-bs-toggle="modal" data-bs-target="#createJobModal">
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
                                                        <span class="text-muted text-uppercase fw-bold"
                                                            style="font-size: 0.72rem;">Đang tuyển</span>
                                                        <div class="kpi-icon-box blue">
                                                            <i class="bi bi-briefcase"></i>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                                        <span class="kpi-value text-dark fw-bold"
                                                            style="font-size: 1.85rem;">${jobsOpenCount != null ?
                                                            jobsOpenCount : 12}</span>
                                                        <span class="text-muted fw-semibold"
                                                            style="font-size: 0.85rem;">Vị trí</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">${jobsOpenCount != null ?
                                                            jobsOpenCount : 12} vị trí đang mở nhận hồ sơ</span>
                                                        <span
                                                            class="badge bg-primary-subtle text-primary fw-semibold">+3
                                                            mới</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- KPI 2 -->
                                            <div class="col-12 col-sm-6 col-xl-3">
                                                <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <span class="text-muted text-uppercase fw-bold"
                                                            style="font-size: 0.72rem;">Sắp mở</span>
                                                        <div class="kpi-icon-box cyan">
                                                            <i class="bi bi-clock-history"></i>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                                        <span class="kpi-value text-dark fw-bold"
                                                            style="font-size: 1.85rem;">${jobsPausedCount != null ?
                                                            jobsPausedCount : 5}</span>
                                                        <span class="text-muted fw-semibold"
                                                            style="font-size: 0.85rem;">Kế hoạch</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">Dự kiến mở trong Q4/2026</span>
                                                        <span class="badge bg-info-subtle text-info fw-semibold">Q4
                                                            Plan</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- KPI 3 -->
                                            <div class="col-12 col-sm-6 col-xl-3">
                                                <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <span class="text-muted text-uppercase fw-bold"
                                                            style="font-size: 0.72rem;">Đã đủ người</span>
                                                        <div class="kpi-icon-box green">
                                                            <i class="bi bi-check2-circle"></i>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                                        <span class="kpi-value text-success fw-bold"
                                                            style="font-size: 1.85rem;">${jobsFilledCount != null ?
                                                            jobsFilledCount : 18}</span>
                                                        <span class="text-muted fw-semibold"
                                                            style="font-size: 0.85rem;">Hoàn tất</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">Hoàn thành 100% chỉ tiêu</span>
                                                        <span
                                                            class="badge bg-success-subtle text-success fw-semibold">100%
                                                            fill</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- KPI 4 -->
                                            <div class="col-12 col-sm-6 col-xl-3">
                                                <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <span class="text-muted text-uppercase fw-bold"
                                                            style="font-size: 0.72rem;">Đã đóng</span>
                                                        <div class="kpi-icon-box amber">
                                                            <i class="bi bi-archive"></i>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                                        <span class="kpi-value text-dark fw-bold"
                                                            style="font-size: 1.85rem;">${jobsClosedCount != null ?
                                                            jobsClosedCount : 32}</span>
                                                        <span class="text-muted fw-semibold"
                                                            style="font-size: 0.85rem;">Lưu trữ</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">Đã lưu trữ / đóng đợt
                                                            tuyển</span>
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
                                                            <span class="input-group-text bg-light border-end-0"><i
                                                                    class="bi bi-search text-muted"></i></span>
                                                            <input type="text" id="jobSearchInput"
                                                                class="form-control border-start-0"
                                                                placeholder="Tìm theo chức danh, mã vị trí...">
                                                        </div>
                                                    </div>
                                                    <div class="col-6 col-md-2">
                                                        <select class="form-select form-select-sm" id="deptFilter"
                                                            onchange="filterJobs()">
                                                            <option value="ALL" selected>Tất cả phòng ban</option>
                                                            <c:forEach items="${departments}" var="d">
                                                                <option value="${d.name}">${d.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-6 col-md-2">
                                                        <select class="form-select form-select-sm" id="salaryFilter"
                                                            onchange="filterJobs()">
                                                            <option value="ALL" selected>Tất cả mức lương</option>
                                                            <option value="LOW">Dưới 20 triệu</option>
                                                            <option value="MID">20 - 35 triệu</option>
                                                            <option value="HIGH">35 - 50 triệu</option>
                                                            <option value="VERY_HIGH">Trên 50 triệu</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-6 col-md-2">
                                                        <select class="form-select form-select-sm" id="locationFilter"
                                                            onchange="filterJobs()">
                                                            <option value="ALL" selected>Hà Nội / TP.HCM / Remote
                                                            </option>
                                                            <option value="HN">Hà Nội (Hybrid)</option>
                                                            <option value="HCM">TP.HCM (Onsite)</option>
                                                            <option value="REMOTE">Toàn quốc (Remote)</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-6 col-md-2">
                                                        <select class="form-select form-select-sm" id="statusFilter"
                                                            onchange="filterJobs()">
                                                            <option value="OPEN" selected>Đang tuyển (${jobsOpenCount})
                                                            </option>
                                                            <option value="ALL">Tất cả trạng thái</option>
                                                            <option value="PAUSED">Tạm dừng (${jobsPausedCount})
                                                            </option>
                                                            <option value="FILLED">Đã đủ (${jobsFilledCount})</option>
                                                            <option value="CLOSED">Đã đóng (${jobsClosedCount})</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-md-1 d-flex justify-content-end gap-1">
                                                        <div class="btn-group btn-group-sm" role="group">
                                                            <button type="button" class="btn btn-primary"
                                                                id="btnTableView" onclick="switchJobView('table')"
                                                                title="Xem dạng Bảng"><i
                                                                    class="bi bi-table"></i></button>
                                                            <button type="button" class="btn btn-outline-secondary"
                                                                id="btnGridView" onclick="switchJobView('grid')"
                                                                title="Xem dạng Thẻ"><i class="bi bi-grid"></i></button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Two-Column Split View: Job List Table + Job Preview Drawer -->
                                        <div class="row g-4">
                                            <!-- Col-7: Job Openings Table or Grid -->
                                            <div class="col-12 col-xl-7">
                                                <!-- TABLE VIEW -->
                                                <div id="jobTableViewContainer"
                                                    class="card border-0 shadow-sm rounded-3 overflow-hidden mb-3">
                                                    <div
                                                        class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <h2 class="h6 fw-bold mb-0 text-dark">Danh sách vị trí đang
                                                                quản lý</h2>
                                                            <span class="badge bg-primary-subtle text-primary border-0"
                                                                id="activeJobsCountBadge">${jobs.size()} Vị trí</span>
                                                        </div>
                                                        <span class="text-muted small"><i
                                                                class="bi bi-info-circle me-1"></i>Nhấp chuột vào dòng
                                                            để xem ngay Job Preview</span>
                                                    </div>

                                                    <div class="table-responsive">
                                                        <table class="table table-hover align-middle mb-0 text-nowrap"
                                                            id="jobsTable" style="font-size: 0.83rem;">
                                                            <thead class="table-light">
                                                                <tr>
                                                                    <th class="ps-3" style="width: 35px;"><input
                                                                            class="form-check-input" type="checkbox">
                                                                    </th>
                                                                    <th style="width: 100px;">Mã VT</th>
                                                                    <th>Vị trí & Cấp bậc</th>
                                                                    <th>Phòng ban</th>
                                                                    <th style="width: 120px;">Tiến độ tuyển</th>
                                                                    <th class="text-center">Ứng viên</th>
                                                                    <th class="pe-3 text-end">Mức lương</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${jobs}" var="job" varStatus="st">
                                                                    <tr class="job-row-item ${selectedJob.id == job.id ? 'table-primary bg-opacity-25' : ''}"
                                                                        style="cursor: pointer;"
                                                                        onclick="selectJobRow(this)" data-id="${job.id}"
                                                                        data-code="${job.requestCode}"
                                                                        data-title="${job.title}"
                                                                        data-dept="${job.departmentName}"
                                                                        data-status="${job.status}"
                                                                        data-salary-min="${job.salaryMinFormatted}"
                                                                        data-salary-max="${job.salaryMaxFormatted}"
                                                                        data-hired="${job.hiredCount}"
                                                                        data-target="${job.targetHeadcount}"
                                                                        data-cand-count="${job.candidateCount}"
                                                                        data-assignee="${job.assigneeName}"
                                                                        data-desc="${job.description != null ? job.description : 'Phát triển các phân hệ phần mềm và tính năng quản lý nhân sự theo mô hình Agile.'}"
                                                                        data-req="${job.requirements != null ? job.requirements : 'Tối thiểu 3 năm kinh nghiệm làm việc thực tế, tư duy logic tốt và khả năng làm việc nhóm.'}"
                                                                        data-ben="${job.benefits != null ? job.benefits : 'Lương thưởng cạnh tranh, bảo hiểm sức khỏe cao cấp và môi trường làm việc Hybrid linh hoạt.'}">

                                                                        <td class="ps-3"
                                                                            onclick="event.stopPropagation()">
                                                                            <input class="form-check-input"
                                                                                type="checkbox" ${selectedJob.id==job.id
                                                                                ? 'checked' : '' }>
                                                                        </td>
                                                                        <td class="fw-bold font-monospace text-primary">
                                                                            ${job.requestCode}</td>
                                                                        <td>
                                                                            <div
                                                                                class="d-flex align-items-center gap-1">
                                                                                <span
                                                                                    class="fw-bold text-dark job-title-text">${job.title}</span>
                                                                                <c:if test="${job.priority eq 'HOT'}">
                                                                                    <span
                                                                                        class="badge bg-danger ms-1">HOT</span>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${job.priority eq 'URGENT'}">
                                                                                    <span
                                                                                        class="badge bg-warning text-dark ms-1">Gấp</span>
                                                                                </c:if>
                                                                            </div>
                                                                            <small class="text-muted">Toàn thời gian •
                                                                                ${job.positionName != null ?
                                                                                job.positionName : 'Chuyên
                                                                                viên'}</small>
                                                                        </td>
                                                                        <td><span
                                                                                class="badge bg-light text-dark border job-dept-text">${job.departmentName}</span>
                                                                        </td>
                                                                        <td>
                                                                            <div
                                                                                class="d-flex align-items-center gap-2">
                                                                                <div class="progress flex-grow-1"
                                                                                    style="height: 5px;">
                                                                                    <div class="progress-bar ${job.fillPercentage >= 100 ? 'bg-success' : 'bg-primary'}"
                                                                                        style="width: ${job.fillPercentage}%;">
                                                                                    </div>
                                                                                </div>
                                                                                <span
                                                                                    class="small fw-bold ${job.fillPercentage >= 100 ? 'text-success' : ''}">${job.hiredCount}/${job.targetHeadcount}</span>
                                                                            </div>
                                                                        </td>
                                                                        <td class="text-center"
                                                                            onclick="event.stopPropagation()">
                                                                            <a href="${pageContext.request.contextPath}/recruitment?view=candidates&requestId=${job.id}"
                                                                                class="text-decoration-none fw-bold text-primary"
                                                                                title="Xem danh sách ứng viên của vị trí này">
                                                                                ${job.candidateCount} CV <i
                                                                                    class="bi bi-box-arrow-up-right"
                                                                                    style="font-size: 0.7rem;"></i>
                                                                            </a>
                                                                        </td>
                                                                        <td class="pe-3 text-end fw-bold text-dark">
                                                                            ${job.salaryMinFormatted} -
                                                                            ${job.salaryMaxFormatted} Tr</td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>

                                                    <div
                                                        class="card-footer bg-white border-top py-3 d-flex justify-content-between align-items-center">
                                                        <span class="text-muted small">Hiển thị <strong
                                                                id="jobsCountShown">${jobs.size()}</strong> vị trí tuyển
                                                            dụng</span>
                                                        <ul class="pagination pagination-sm mb-0">
                                                            <li class="page-item active"><a class="page-link"
                                                                    href="#">1</a></li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <!-- GRID VIEW (Default Hidden) -->
                                                <div id="jobGridViewContainer" class="row g-3 mb-3"
                                                    style="display: none;">
                                                    <c:forEach items="${jobs}" var="job">
                                                        <div class="col-12 col-md-6 job-grid-item"
                                                            data-title="${job.title}" data-dept="${job.departmentName}"
                                                            data-status="${job.status}">
                                                            <div class="card h-100 border-0 shadow-sm rounded-3 p-3 job-card-interactive"
                                                                style="cursor: pointer;"
                                                                onclick="selectJobById(${job.id})">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <span
                                                                        class="badge bg-primary-subtle text-primary font-monospace fw-bold">${job.requestCode}</span>
                                                                    <span
                                                                        class="badge ${job.status eq 'OPEN' ? 'bg-success-subtle text-success' : 'bg-light text-muted'}">${job.status}</span>
                                                                </div>
                                                                <h6 class="fw-bold text-dark mb-1">${job.title}</h6>
                                                                <div class="text-muted small mb-2"><i
                                                                        class="bi bi-building me-1"></i>${job.departmentName}
                                                                </div>
                                                                <div class="fw-bold text-primary small mb-3">
                                                                    ${job.salaryMinFormatted} -
                                                                    ${job.salaryMaxFormatted} Triệu VNĐ</div>
                                                                <div
                                                                    class="pt-2 border-top d-flex justify-content-between align-items-center small text-muted">
                                                                    <span>Tuyển:
                                                                        <strong>${job.hiredCount}/${job.targetHeadcount}</strong></span>
                                                                    <span
                                                                        class="text-primary fw-semibold">${job.candidateCount}
                                                                        CV nộp</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>

                                            <!-- Col-5: Job Description Preview Drawer -->
                                            <div class="col-12 col-xl-5">
                                                <div class="job-preview-drawer">
                                                    <!-- Top Bar of Drawer -->
                                                    <div
                                                        class="d-flex justify-content-between align-items-center pb-3 border-bottom mb-3">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <i class="bi bi-window-sidebar text-primary"></i>
                                                            <span class="fw-bold text-dark"
                                                                style="font-size: 0.85rem;">XEM TRƯỚC TIN TUYỂN
                                                                DỤNG</span>
                                                        </div>
                                                        <span class="badge bg-primary">Public Candidate View</span>
                                                    </div>

                                                    <!-- Job Title & Meta -->
                                                    <div class="d-flex align-items-center gap-3 mb-3">
                                                        <div class="d-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-3 flex-shrink-0"
                                                            style="width: 48px; height: 48px; font-size: 1.5rem;">
                                                            <i class="bi bi-building"></i>
                                                        </div>
                                                        <div>
                                                            <span id="previewStatusBadge"
                                                                class="badge ${selectedJob.status eq 'OPEN' ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-light text-muted border'} mb-1">
                                                                ${selectedJob.status eq 'OPEN' ? 'Đang nhận CV' :
                                                                selectedJob.status}
                                                            </span>
                                                            <h3 id="previewTitle" class="h5 fw-bold text-dark mb-0">
                                                                ${selectedJob.title}</h3>
                                                        </div>
                                                    </div>

                                                    <div
                                                        class="d-flex flex-wrap align-items-center gap-3 text-muted small mb-3">
                                                        <span id="previewDept"><i
                                                                class="bi bi-geo-alt text-primary me-1"></i>${selectedJob.departmentName
                                                            != null ? selectedJob.departmentName : 'Hà Nội
                                                            (Hybrid)'}</span>
                                                        <span>•</span>
                                                        <span><i class="bi bi-clock text-primary me-1"></i>Toàn thời
                                                            gian</span>
                                                    </div>

                                                    <!-- Salary highlight -->
                                                    <div id="previewSalary" class="job-salary-highlight mb-3">
                                                        ${selectedJob.salaryMinFormatted} -
                                                        ${selectedJob.salaryMaxFormatted} Triệu VNĐ <span
                                                            class="text-muted fs-6 fw-normal">/ tháng</span>
                                                    </div>

                                                    <!-- Action buttons -->
                                                    <div class="d-flex gap-2 mb-3">
                                                        <button type="button"
                                                            class="btn btn-primary btn-sm flex-grow-1 d-flex align-items-center justify-content-center gap-2"
                                                            onclick="simulateApplyCandidate()">
                                                            <i class="bi bi-send-fill"></i>
                                                            <span>Ứng tuyển mẫu</span>
                                                        </button>
                                                        <button type="button"
                                                            class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-2"
                                                            onclick="copyShareLink()">
                                                            <i class="bi bi-share"></i>
                                                            <span>Chia sẻ tin</span>
                                                        </button>
                                                    </div>

                                                    <!-- AI Smart CV Screener Highlight Banner -->
                                                    <div class="ai-insight-box mb-4">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center mb-2">
                                                            <span class="ai-sparkle-badge"><i class="bi bi-stars"></i>
                                                                TRỢ LÝ AI ĐỌC & LỌC CV</span>
                                                            <span id="previewAiCandCount"
                                                                class="badge bg-purple-subtle text-purple fw-bold"
                                                                style="background: #f3e8ff; color: #7e22ce;">
                                                                ${selectedJob.candidateCount} CV đã nộp
                                                            </span>
                                                        </div>
                                                        <p class="small text-dark mb-2" style="font-size: 0.8rem;">
                                                            AI đã tự động phân tích
                                                            <strong>${selectedJob.candidateCount} CV</strong> ứng tuyển
                                                            vị trí này: <strong>3 CV khớp xuất sắc (90%+)</strong>,
                                                            <strong>bóc tách kỹ năng theo chuẩn JD</strong>.
                                                        </p>
                                                        <button type="button"
                                                            class="btn btn-sm text-white w-100 fw-semibold d-flex align-items-center justify-content-center gap-2 shadow-sm"
                                                            style="background: linear-gradient(135deg, #7e22ce 0%, #2563eb 100%); border: none;"
                                                            data-bs-toggle="modal" data-bs-target="#aiCvScreeningModal">
                                                            <i class="bi bi-cpu"></i>
                                                            <span>Xem AI Đánh Giá & Lọc Top 3 CV</span>
                                                        </button>
                                                    </div>

                                                    <!-- Recruiter Info -->
                                                    <div
                                                        class="p-3 bg-light rounded-3 d-flex align-items-center justify-content-between mb-4">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div id="previewAvatarInitials"
                                                                class="avatar-circle bg-primary text-white fw-bold"
                                                                style="width: 36px; height: 36px; font-size: 0.8rem;">
                                                                ${selectedJob.assigneeAvatarInitials != null ?
                                                                selectedJob.assigneeAvatarInitials : 'HR'}
                                                            </div>
                                                            <div>
                                                                <div id="previewRecruiterName" class="fw-bold text-dark"
                                                                    style="font-size: 0.83rem;">
                                                                    ${selectedJob.assigneeName != null ?
                                                                    selectedJob.assigneeName : 'Phạm Phương Thảo'}
                                                                </div>
                                                                <small class="text-muted">Talent Acquisition
                                                                    Lead</small>
                                                            </div>
                                                        </div>
                                                        <span id="previewJobCode"
                                                            class="badge bg-light text-dark border font-monospace">${selectedJob.requestCode}</span>
                                                    </div>

                                                    <!-- Job Description Content -->
                                                    <div class="mb-4">
                                                        <div
                                                            class="fw-bold text-dark text-uppercase small mb-2 d-flex align-items-center gap-1">
                                                            <i class="bi bi-card-text text-primary"></i>
                                                            <span>MÔ TẢ CÔNG VIỆC (JOB DESCRIPTION)</span>
                                                        </div>
                                                        <div id="previewDescription" class="text-muted small ps-3 mb-0"
                                                            style="line-height: 1.7;">
                                                            <c:choose>
                                                                <c:when test="${not empty selectedJob.description}">
                                                                    ${selectedJob.description}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <ul class="mb-0 ps-3">
                                                                        <li>Xây dựng kiến trúc hệ thống HRM & Payroll
                                                                            SaaS chịu tải cao cho toàn bộ doanh nghiệp.
                                                                        </li>
                                                                        <li>Thiết kế, phát triển và tối ưu Microservices
                                                                            bằng Node.js, TypeScript và cơ sở dữ liệu
                                                                            PostgreSQL.</li>
                                                                        <li>Xây dựng giao diện web phản hồi nhanh, mượt
                                                                            mà và trực quan.</li>
                                                                    </ul>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>

                                                    <!-- Requirements Content -->
                                                    <div>
                                                        <div
                                                            class="fw-bold text-dark text-uppercase small mb-2 d-flex align-items-center gap-1">
                                                            <i class="bi bi-check-circle text-primary"></i>
                                                            <span>YÊU CẦU ỨNG VIÊN (REQUIREMENTS)</span>
                                                        </div>
                                                        <div id="previewRequirements" class="text-muted small ps-3 mb-0"
                                                            style="line-height: 1.7;">
                                                            <c:choose>
                                                                <c:when test="${not empty selectedJob.requirements}">
                                                                    ${selectedJob.requirements}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <ul class="mb-0 ps-3">
                                                                        <li>Từ 3+ năm kinh nghiệm thực chiến với công
                                                                            nghệ liên quan.</li>
                                                                        <li>Thành thạo cơ sở dữ liệu quan hệ
                                                                            (PostgreSQL) và tối ưu hóa truy vấn.</li>
                                                                        <li>Kỹ năng giao tiếp và làm việc nhóm tốt theo
                                                                            quy trình Agile/Scrum.</li>
                                                                    </ul>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </main>

                                    <!-- Footer -->
                                    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
                            </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 1: TẠO VỊ TRÍ TUYỂN DỤNG MỚI (#createJobModal)                     -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="createJobModal" tabindex="-1" aria-labelledby="createJobModalLabel"
                        aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header modal-header-brand p-3 px-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-briefcase-fill fs-5"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="createJobModalLabel">Tạo
                                                Vị Trí Tuyển Dụng Mới</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Đăng
                                                tải nhu cầu tuyển dụng và đồng bộ vào hệ thống cơ sở dữ liệu</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                                    <input type="hidden" name="action" value="create_job">
                                    <div class="modal-body p-4" style="background: #f8fafc;">

                                        <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">1. Thông tin vị trí &
                                                Phòng ban</h6>
                                            <div class="row g-3 mb-3">
                                                <div class="col-md-4">
                                                    <label class="form-label small fw-semibold text-muted">Mã yêu cầu
                                                        <span class="text-danger">*</span></label>
                                                    <input type="text"
                                                        class="form-control form-control-sm font-monospace fw-bold"
                                                        name="requestCode" value="${nextRequestCode}" required>
                                                </div>
                                                <div class="col-md-8">
                                                    <label class="form-label small fw-semibold text-muted">Tên chức danh
                                                        tuyển dụng <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control form-control-sm" name="title"
                                                        placeholder="VD: Senior Data Engineer" required>
                                                </div>
                                            </div>

                                            <div class="row g-3 mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Phòng ban
                                                        <span class="text-danger">*</span></label>
                                                    <select class="form-select form-select-sm" name="departmentId"
                                                        required>
                                                        <option value="" disabled selected>-- Chọn phòng ban --</option>
                                                        <c:forEach items="${departments}" var="dept">
                                                            <option value="${dept.id}">${dept.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Chức danh
                                                        chức vụ</label>
                                                    <select class="form-select form-select-sm" name="positionId">
                                                        <c:forEach items="${positions}" var="pos">
                                                            <option value="${pos.id}">${pos.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Số lượng cần
                                                        tuyển</label>
                                                    <input type="number" class="form-control form-control-sm"
                                                        name="targetHeadcount" value="1" min="1" max="50">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Mức độ ưu
                                                        tiên</label>
                                                    <select class="form-select form-select-sm" name="priority">
                                                        <option value="NORMAL" selected>Bình thường</option>
                                                        <option value="URGENT">🔥 Ưu tiên gấp</option>
                                                        <option value="HOT">🚨 HOT Tuyển gấp</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">2. Lương, Hạn chót &
                                                Người phụ trách</h6>
                                            <div class="row g-3 mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Mức lương từ
                                                        (VNĐ)</label>
                                                    <input type="number" class="form-control form-control-sm"
                                                        name="salaryMin" placeholder="25.000.000" step="1000000">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Mức lương đến
                                                        (VNĐ)</label>
                                                    <input type="number" class="form-control form-control-sm"
                                                        name="salaryMax" placeholder="45.000.000" step="1000000">
                                                </div>
                                            </div>

                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Hạn chót nhận
                                                        hồ sơ <span class="text-danger">*</span></label>
                                                    <input type="date" class="form-control form-control-sm"
                                                        name="deadline" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Chuyên viên
                                                        HR phụ trách</label>
                                                    <select class="form-select form-select-sm" name="assigneeId">
                                                        <c:forEach items="${employees}" var="emp">
                                                            <option value="${emp.id}">${emp.fullName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">3. Mô tả JD & Yêu cầu
                                            </h6>
                                            <div class="mb-3">
                                                <label class="form-label small fw-semibold text-muted">Mô tả công
                                                    việc</label>
                                                <textarea class="form-control form-control-sm" name="description"
                                                    rows="2"
                                                    placeholder="Trách nhiệm công việc, mục tiêu bàn giao..."></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label small fw-semibold text-muted">Yêu cầu ứng
                                                    viên</label>
                                                <textarea class="form-control form-control-sm" name="requirements"
                                                    rows="2"
                                                    placeholder="Kỹ năng bắt buộc, số năm kinh nghiệm..."></textarea>
                                            </div>
                                            <div>
                                                <label class="form-label small fw-semibold text-muted">Quyền lợi đãi
                                                    ngộ</label>
                                                <textarea class="form-control form-control-sm" name="benefits" rows="2"
                                                    placeholder="Lương thưởng, bảo hiểm, chế độ du lịch..."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer bg-white border-top p-3 px-4">
                                        <button type="button" class="btn btn-outline-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit"
                                            class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                                            <i class="bi bi-check-circle-fill"></i>
                                            <span>Lưu & Đăng vị trí</span>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 2: TRỢ LÝ AI ĐỌC & LỌC CV TỰ ĐỘNG (#aiCvScreeningModal)                -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="aiCvScreeningModal" tabindex="-1"
                        aria-labelledby="aiCvScreeningModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header modal-header-ai p-3 px-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-stars fs-4"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white"
                                                id="aiCvScreeningModalLabel">Trợ Lý AI Đọc & Lọc CV Tự Động (AI CV Match
                                                Screener)</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Phân
                                                tích bóc tách kỹ năng, chấm điểm độ khớp JD và đề xuất ứng viên tiềm
                                                năng nhất</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-4" style="background: #f8fafc;">
                                    <!-- AI Processing Header Status -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-4 bg-white">
                                        <div class="row align-items-center g-3">
                                            <div class="col-12 col-md-8">
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <span
                                                        class="badge bg-primary-subtle text-primary font-monospace fw-bold"
                                                        id="aiModalJobCode">${selectedJob.requestCode}</span>
                                                    <h6 class="fw-bold text-dark mb-0" id="aiModalJobTitle">
                                                        ${selectedJob.title}</h6>
                                                </div>
                                                <div class="small text-muted">
                                                    AI đang áp dụng thuật toán NLP & Semantic Matching trên <strong
                                                        id="aiModalCandCount">${selectedJob.candidateCount} hồ sơ
                                                        CV</strong> ứng tuyển để so sánh trực tiếp với tiêu chí Mô tả
                                                    công việc (JD).
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-4 text-md-end">
                                                <button type="button"
                                                    class="btn btn-sm btn-outline-purple text-purple border-purple fw-semibold d-inline-flex align-items-center gap-1"
                                                    style="color: #7e22ce; border-color: #c084fc;"
                                                    onclick="simulateAiReScan()">
                                                    <i class="bi bi-arrow-repeat" id="aiScanSpinIcon"></i>
                                                    <span id="aiScanBtnText">Quét lại tất cả CV bằng AI</span>
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Ranked AI Top Match Candidates -->
                                    <h6 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2">
                                        <i class="bi bi-trophy-fill text-warning"></i>
                                        <span>TOP ỨNG VIÊN ĐƯỢC AI ĐÁNH GIÁ CAO NHẤT (AI TOP MATCH SCORE)</span>
                                    </h6>

                                    <div class="row g-3 mb-4">
                                        <c:choose>
                                            <c:when test="${not empty topAiCandidates}">
                                                <c:forEach items="${topAiCandidates}" var="cand" varStatus="st">
                                                    <div class="col-12 col-lg-4">
                                                        <div
                                                            class="ai-candidate-card h-100 p-3 d-flex flex-column justify-content-between">
                                                            <div>
                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <span
                                                                        class="badge ${st.index == 0 ? 'bg-success' : (st.index == 1 ? 'bg-primary' : 'bg-info')} text-white fw-bold px-2 py-1">
                                                                        ${st.index == 0 ? '🥇' : (st.index == 1 ? '🥈' :
                                                                        '🥉')} AI Score: ${cand.aiMatchScore}%
                                                                    </span>
                                                                    <span
                                                                        class="badge bg-light text-muted border">${cand.source}</span>
                                                                </div>
                                                                <div class="fw-bold text-dark fs-6">${cand.fullName}
                                                                </div>
                                                                <div class="text-primary small mb-2">${cand.jobTitle !=
                                                                    null ? cand.jobTitle : selectedJob.title}
                                                                    (${cand.experienceYears} năm EXP)</div>

                                                                <div class="progress mb-2" style="height: 6px;">
                                                                    <div class="progress-bar ${st.index == 0 ? 'ai-match-progress-bar' : (st.index == 1 ? 'bg-primary' : 'bg-info')}"
                                                                        style="width: ${cand.aiMatchScore}%;"></div>
                                                                </div>

                                                                <div class="p-2 rounded bg-light border mb-2"
                                                                    style="font-size: 0.76rem;">
                                                                    <div class="fw-bold text-success mb-1"><i
                                                                            class="bi bi-check-circle-fill me-1"></i>Kỹ
                                                                        năng khớp:</div>
                                                                    <div class="text-muted">${cand.aiMatchedSkills}
                                                                    </div>
                                                                </div>

                                                                <div class="small text-muted fst-italic mb-3"
                                                                    style="font-size: 0.74rem;">
                                                                    "${cand.aiRecommendation}"
                                                                </div>
                                                            </div>

                                                            <div class="pt-2 border-top d-flex gap-2">
                                                                <form method="POST"
                                                                    action="${pageContext.request.contextPath}/recruitment"
                                                                    class="w-100 m-0">
                                                                    <input type="hidden" name="action"
                                                                        value="update_stage">
                                                                    <input type="hidden" name="candidateId"
                                                                        value="${cand.id}">
                                                                    <input type="hidden" name="stage" value="INTERVIEW">
                                                                    <button type="submit"
                                                                        class="btn btn-sm btn-primary w-100">
                                                                        Duyệt vào Vòng PV
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="col-12 text-center py-4 text-muted">
                                                    Chưa có ứng viên nào nộp hồ sơ cho vị trí này để AI thực hiện lọc.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- AI Generated Interview Question Matrix -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                        <h6 class="fw-bold text-dark mb-2 d-flex align-items-center gap-2">
                                            <i class="bi bi-question-circle-fill text-primary"></i>
                                            <span>BỘ CÂU HỎI PHỎNG VẤN AI GỢI Ý TỰ ĐỘNG DÀNH CHO HR / TECH LEAD</span>
                                        </h6>
                                        <div class="row g-2" style="font-size: 0.78rem;">
                                            <c:choose>
                                                <c:when test="${not empty aiInterviewQuestions}">
                                                    <c:forEach items="${aiInterviewQuestions}" var="q">
                                                        <div class="col-12 col-md-6">
                                                            <div class="p-2 border rounded bg-light h-100">
                                                                <strong>${q.topic}:</strong>
                                                                <p class="text-muted mb-0 mt-1">${q.question}</p>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="col-12 col-md-6">
                                                        <div class="p-2 border rounded bg-light">
                                                            <strong>1. Về Microservices & Latency:</strong>
                                                            <p class="text-muted mb-0 mt-1">"Bạn xử lý như thế nào khi
                                                                hệ thống gặp nghẽn mạng và latency tăng đột biến trên
                                                                Node.js service?"</p>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-md-6">
                                                        <div class="p-2 border rounded bg-light">
                                                            <strong>2. Về PostgreSQL Optimization:</strong>
                                                            <p class="text-muted mb-0 mt-1">"Phương pháp tối ưu index và
                                                                partition bảng dữ liệu 50 triệu bản ghi trong
                                                                PostgreSQL?"</p>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer bg-white border-top p-3 px-4">
                                    <button type="button" class="btn btn-outline-secondary"
                                        data-bs-dismiss="modal">Đóng</button>
                                    <form method="POST" action="${pageContext.request.contextPath}/recruitment"
                                        class="m-0">
                                        <input type="hidden" name="action" value="ai_batch_promote">
                                        <input type="hidden" name="jobId" id="aiBatchJobId" value="${selectedJob.id}">
                                        <button type="submit"
                                            class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                                            <i class="bi bi-check2-all"></i>
                                            <span>Tự động chuyển Top 3 CV vào Phỏng vấn</span>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        // 1. Tương tác chọn dòng vị trí và cập nhật động Khung Job Preview
                        function selectJobRow(rowElement) {
                            // Xóa highlight cũ
                            document.querySelectorAll('.job-row-item').forEach(r => {
                                r.classList.remove('table-primary', 'bg-opacity-25');
                                const chk = r.querySelector('input[type="checkbox"]');
                                if (chk) chk.checked = false;
                            });

                            // Bật highlight mới
                            rowElement.classList.add('table-primary', 'bg-opacity-25');
                            const currentChk = rowElement.querySelector('input[type="checkbox"]');
                            if (currentChk) currentChk.checked = true;

                            // Trích xuất dữ liệu từ data attributes
                            const title = rowElement.getAttribute('data-title');
                            const code = rowElement.getAttribute('data-code');
                            const dept = rowElement.getAttribute('data-dept');
                            const status = rowElement.getAttribute('data-status');
                            const salMin = rowElement.getAttribute('data-salary-min');
                            const salMax = rowElement.getAttribute('data-salary-max');
                            const assignee = rowElement.getAttribute('data-assignee');
                            const candCount = rowElement.getAttribute('data-cand-count');
                            const desc = rowElement.getAttribute('data-desc');
                            const req = rowElement.getAttribute('data-req');

                            // Cập nhật DOM trên Preview Drawer
                            const previewTitle = document.getElementById('previewTitle');
                            if (previewTitle) previewTitle.textContent = title;

                            const previewJobCode = document.getElementById('previewJobCode');
                            if (previewJobCode) previewJobCode.textContent = code;

                            const previewDept = document.getElementById('previewDept');
                            if (previewDept) previewDept.innerHTML = '<i class="bi bi-geo-alt text-primary me-1"></i>' + dept + ' (Hybrid)';

                            const previewSalary = document.getElementById('previewSalary');
                            if (previewSalary) previewSalary.innerHTML = salMin + ' - ' + salMax + ' Triệu VNĐ <span class="text-muted fs-6 fw-normal">/ tháng</span>';

                            const previewStatusBadge = document.getElementById('previewStatusBadge');
                            if (previewStatusBadge) {
                                previewStatusBadge.textContent = (status === 'OPEN') ? 'Đang nhận CV' : status;
                                previewStatusBadge.className = 'badge ' + (status === 'OPEN' ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-light text-muted border') + ' mb-1';
                            }

                            const previewRecruiterName = document.getElementById('previewRecruiterName');
                            if (previewRecruiterName) previewRecruiterName.textContent = assignee ? assignee : 'HR Tuyển dụng';

                            const previewAiCandCount = document.getElementById('previewAiCandCount');
                            if (previewAiCandCount) previewAiCandCount.textContent = candCount + ' CV đã nộp';

                            const previewDescription = document.getElementById('previewDescription');
                            if (previewDescription) previewDescription.innerHTML = '<p class="mb-0">' + desc + '</p>';

                            const previewRequirements = document.getElementById('previewRequirements');
                            if (previewRequirements) previewRequirements.innerHTML = '<p class="mb-0">' + req + '</p>';

                            // Cập nhật Modal AI Lọc CV (#aiCvScreeningModal)
                            const id = rowElement.getAttribute('data-id');
                            const aiBatchJobId = document.getElementById('aiBatchJobId');
                            if (aiBatchJobId && id) aiBatchJobId.value = id;

                            const aiModalJobCode = document.getElementById('aiModalJobCode');
                            if (aiModalJobCode && code) aiModalJobCode.textContent = code;

                            const aiModalJobTitle = document.getElementById('aiModalJobTitle');
                            if (aiModalJobTitle && title) aiModalJobTitle.textContent = title;

                            const aiModalCandCount = document.getElementById('aiModalCandCount');
                            if (aiModalCandCount && candCount) aiModalCandCount.textContent = candCount + ' hồ sơ CV';
                        }

                        function selectJobById(id) {
                            const targetRow = document.querySelector('.job-row-item[data-id="' + id + '"]');
                            if (targetRow) {
                                selectJobRow(targetRow);
                                switchJobView('table');
                                targetRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            }
                        }

                        // 2. Chuyển đổi giao diện Bảng (Table) và Thẻ (Grid)
                        function switchJobView(mode) {
                            const tableContainer = document.getElementById('jobTableViewContainer');
                            const gridContainer = document.getElementById('jobGridViewContainer');
                            const btnTable = document.getElementById('btnTableView');
                            const btnGrid = document.getElementById('btnGridView');

                            if (mode === 'grid') {
                                tableContainer.style.display = 'none';
                                gridContainer.style.display = 'flex';
                                btnTable.className = 'btn btn-outline-secondary';
                                btnGrid.className = 'btn btn-primary';
                            } else {
                                tableContainer.style.display = 'block';
                                gridContainer.style.display = 'none';
                                btnTable.className = 'btn btn-primary';
                                btnGrid.className = 'btn btn-outline-secondary';
                            }
                        }

                        // 3. Tìm kiếm & Lọc vị trí tuyển dụng tức thì
                        const searchInput = document.getElementById('jobSearchInput');
                        if (searchInput) {
                            searchInput.addEventListener('keyup', filterJobs);
                        }

                        function filterJobs() {
                            const keyword = searchInput ? searchInput.value.toLowerCase().trim() : '';
                            const dept = document.getElementById('deptFilter').value;
                            const status = document.getElementById('statusFilter').value;

                            const rows = document.querySelectorAll('#jobsTable tbody tr');
                            let count = 0;

                            rows.forEach(row => {
                                const title = row.getAttribute('data-title').toLowerCase();
                                const code = row.getAttribute('data-code').toLowerCase();
                                const rowDept = row.getAttribute('data-dept');
                                const rowStatus = row.getAttribute('data-status');

                                const matchKw = !keyword || title.includes(keyword) || code.includes(keyword);
                                const matchDept = (dept === 'ALL') || (rowDept === dept);
                                const matchStatus = (status === 'ALL') || (rowStatus === status);

                                if (matchKw && matchDept && matchStatus) {
                                    row.style.display = '';
                                    count++;
                                } else {
                                    row.style.display = 'none';
                                }
                            });

                            const countBadge = document.getElementById('activeJobsCountBadge');
                            if (countBadge) countBadge.textContent = count + ' Vị trí';
                            const countShown = document.getElementById('jobsCountShown');
                            if (countShown) countShown.textContent = count;
                        }

                        // 4. Mô phỏng quét AI
                        function simulateAiReScan() {
                            const icon = document.getElementById('aiScanSpinIcon');
                            const text = document.getElementById('aiScanBtnText');
                            if (icon) icon.classList.add('bi-spin');
                            if (text) text.textContent = 'AI đang đọc & phân tích...';

                            setTimeout(() => {
                                if (icon) icon.classList.remove('bi-spin');
                                if (text) text.textContent = 'Đã quét xong 100%';
                                alert('🤖 AI Engine hoàn tất quét đối sánh ngữ nghĩa: Đã bóc tách 38 CV, cập nhật điểm kỹ năng và xếp hạng Top Match!');
                            }, 1200);
                        }

                        function simulateApplyCandidate() {
                            alert('🎉 Mở cổng ứng tuyển trực tuyến: Ứng viên có thể gửi hồ sơ trực tiếp qua liên kết công khai của vị trí này.');
                        }

                        function copyShareLink() {
                            navigator.clipboard.writeText(window.location.href);
                            alert('📋 Đã sao chép liên kết tuyển dụng vào bộ nhớ tạm!');
                        }

                        function toggleAdvancedFilter() {
                            alert('Bộ lọc nâng cao theo kỹ năng, chứng chỉ và mức lương trần đang được kích hoạt.');
                        }
                    </script>
                </body>

                </html>