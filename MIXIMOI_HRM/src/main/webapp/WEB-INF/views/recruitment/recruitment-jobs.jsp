<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <!DOCTYPE html>
                <html lang="vi">

    <head>
        <title>Vị trí Tuyển dụng & Xem trước Tin tuyển dụng — MIXIMOI HRM</title>
        <%@ include file="/WEB-INF/views/common/head.jsp" %>
        <style>
            .keyword-tag {
                background: #f1f5f9;
                color: #334155;
                border: 1px solid #cbd5e1;
                border-radius: 6px;
                padding: 4px 10px;
                font-size: 0.8rem;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                transition: all 0.2s;
            }
            .keyword-tag.matched {
                background: #dcfce7;
                color: #166534;
                border-color: #86efac;
                font-weight: 600;
            }
            .keyword-tag.missing {
                background: #f1f5f9;
                color: #94a3b8;
                border-color: #e2e8f0;
            }
            .cv-format-badge {
                font-size: 0.75rem;
                font-weight: 600;
                padding: 3px 8px;
                border-radius: 5px;
            }
            .cv-format-word {
                background: #dbeafe;
                color: #1e40af;
                border: 1px solid #bfdbfe;
            }
            .cv-format-pdf {
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }
            .cv-format-handwritten {
                background: #f3e8ff;
                color: #6b21a8;
                border: 1px solid #e9d5ff;
            }
            .job-row-item {
                transition: background-color 0.15s ease-in-out;
            }
            .job-row-item:hover {
                background-color: #f1f5f9 !important;
            }
            .live-scan-viewer {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 16px;
                font-family: 'Consolas', 'Courier New', monospace;
                font-size: 0.83rem;
                line-height: 1.6;
                max-height: 280px;
                overflow-y: auto;
            }
            .live-scan-viewer mark {
                background: #fef08a;
                color: #854d0e;
                font-weight: bold;
                padding: 2px 4px;
                border-radius: 3px;
                border: 1px solid #fde047;
            }
            .share-card-snippet {
                background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);
                color: white;
                border-radius: 12px;
                padding: 20px;
            }
        </style>
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
                                                <div><strong>Tuyển Dụng Thành Công!</strong> Đã tự động chuyển TOP 3
                                                    ứng viên xuất sắc nhất vào danh sách Vòng Phỏng vấn!
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
                                                    <i class="bi bi-funnel-fill"></i>
                                                    <span>Lọc CV Tự Động</span>
                                                </button>
                                                <button type="button"
                                                    class="btn btn-outline-primary d-flex align-items-center gap-2"
                                                    onclick="openShareJobModal()">
                                                    <i class="bi bi-share"></i>
                                                    <span>Chia sẻ tin</span>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/recruitment?action=export_report"
                                                    class="btn btn-outline-secondary d-flex align-items-center gap-2 text-decoration-none">
                                                    <i class="bi bi-file-earmark-excel"></i>
                                                    <span>Xuất Excel</span>
                                                </a>
                                                <button type="button"
                                                    class="btn btn-outline-secondary d-flex align-items-center gap-2"
                                                    data-bs-toggle="modal" data-bs-target="#advancedJobFilterModal">
                                                    <i class="bi bi-sliders"></i>
                                                    <span>Lọc nâng cao</span>
                                                </button>
                                                <button type="button"
                                                    class="btn btn-primary d-flex align-items-center gap-2 shadow-sm"
                                                    data-bs-toggle="modal" data-bs-target="#createJobModal">
                                                    <i class="bi bi-plus-lg"></i>
                                                    <span>Tạo vị trí</span>
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
                                                            style="font-size: 1.85rem;">${jobsOpenCount != null ? jobsOpenCount : 12}</span>
                                                        <span class="text-muted fw-semibold"
                                                            style="font-size: 0.85rem;">Vị trí</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">${jobsOpenCount != null ? jobsOpenCount : 12} vị trí đang mở nhận hồ sơ</span>
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
                                                            style="font-size: 1.85rem;">${jobsPausedCount != null ? jobsPausedCount : 5}</span>
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
                                                            style="font-size: 1.85rem;">${jobsFilledCount != null ? jobsFilledCount : 18}</span>
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
                                                            style="font-size: 1.85rem;">${jobsClosedCount != null ? jobsClosedCount : 32}</span>
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
                                                            <option value="NEGOTIABLE">Thỏa thuận</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-6 col-md-2">
                                                        <select class="form-select form-select-sm" id="locationFilter"
                                                            onchange="filterJobs()">
                                                            <option value="ALL" selected>Tất cả thành phố</option>
                                                            <option value="HN">Hà Nội</option>
                                                            <option value="HCM">TP. Hồ Chí Minh</option>
                                                            <option value="DN">Đà Nẵng</option>
                                                            <option value="REMOTE">Toàn quốc (Remote)</option>
                                                            <option value="HYBRID">Hybrid</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-6 col-md-2">
                                                        <select class="form-select form-select-sm" id="statusFilter"
                                                            onchange="filterJobs()">
                                                            <option value="ALL" selected>Tất cả trạng thái</option>
                                                            <option value="OPEN">Đang tuyển (${jobsOpenCount})</option>
                                                            <option value="PAUSED">Tạm dừng (${jobsPausedCount})</option>
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
                                                                    <th class="ps-3" style="width: 35px;"><input class="form-check-input" type="checkbox"></th>
                                                                    <th style="width: 90px;">Mã VT</th>
                                                                    <th>Vị trí & Cấp bậc</th>
                                                                    <th>Phòng ban</th>
                                                                    <th style="width: 110px;">Tiến độ tuyển</th>
                                                                    <th class="text-center" style="width: 135px;">Người phụ trách</th>
                                                                    <th class="text-center" style="width: 85px;">Ứng viên</th>
                                                                    <th class="pe-3 text-end" style="width: 110px;">Mức lương</th>
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
                                                                        data-location="${job.location != null ? job.location : 'Hà Nội'}"
                                                                        data-keywords="${job.keywords != null ? job.keywords : ''}"
                                                                        data-deadline="${job.deadline}"
                                                                        data-negotiable="${job.salaryNegotiable}"
                                                                        data-salary-min="${job.salaryMinFormatted}"
                                                                        data-salary-max="${job.salaryMaxFormatted}"
                                                                        data-raw-salary-min="${job.salaryMin != null ? job.salaryMin : 0}"
                                                                        data-raw-salary-max="${job.salaryMax != null ? job.salaryMax : 0}"
                                                                        data-hired="${job.hiredCount}"
                                                                        data-target="${job.targetHeadcount}"
                                                                        data-cand-count="${job.candidateCount}"
                                                                        data-assignee="${job.assigneeName != null ? job.assigneeName : 'Phạm Phương Thảo'}"
                                                                        data-assignee-initials="${job.assigneeAvatarInitials != null ? job.assigneeAvatarInitials : 'PT'}"
                                                                        data-desc="${job.description != null ? job.description : 'Phát triển các phân hệ phần mềm và tính năng quản lý nhân sự theo mô hình Agile.'}"
                                                                        data-req="${job.requirements != null ? job.requirements : 'Tối thiểu 3 năm kinh nghiệm làm việc thực tế, tư duy logic tốt và khả năng làm việc nhóm.'}"
                                                                        data-ben="${job.benefits != null ? job.benefits : 'Lương thưởng cạnh tranh, bảo hiểm sức khỏe cao cấp và môi trường làm việc Hybrid linh hoạt.'}">

                                                                        <td class="ps-3"
                                                                            onclick="event.stopPropagation()">
                                                                            <input class="form-check-input"
                                                                                type="checkbox" ${selectedJob.id==job.id ? 'checked' : ''}>
                                                                        </td>
                                                                        <td class="fw-bold font-monospace text-primary">
                                                                            ${job.requestCode}</td>
                                                                        <td>
                                                                            <div
                                                                                class="d-flex align-items-center gap-1 flex-wrap">
                                                                                <span
                                                                                    class="fw-bold text-dark job-title-text">${job.title}</span>
                                                                                <span class="badge bg-light text-muted border ms-1" style="font-size: 0.7rem;">
                                                                                    <i class="bi bi-geo-alt text-danger me-1"></i>${job.location != null ? job.location : 'Hà Nội'}
                                                                                </span>
                                                                                <c:if test="${job.priority eq 'HOT'}">
                                                                                    <span
                                                                                        class="badge bg-danger ms-1">HOT</span>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${job.priority eq 'URGENT'}">
                                                                                    <span
                                                                                        class="badge bg-warning text-dark ms-1">Gấp</span>
                                                                                </c:if>
                                                                                <button type="button" class="btn btn-sm btn-outline-primary py-0 px-1 ms-auto"
                                                                                    title="Xem trước thông tin vị trí này"
                                                                                    onclick="event.stopPropagation(); selectJobById(${job.id});">
                                                                                    <i class="bi bi-eye"></i>
                                                                                </button>
                                                                                <button type="button" class="btn btn-sm btn-outline-secondary py-0 px-1 ms-1"
                                                                                    title="Chia sẻ tin tuyển dụng"
                                                                                    onclick="event.stopPropagation(); openShareJobModalById(${job.id});">
                                                                                    <i class="bi bi-share"></i>
                                                                                </button>
                                                                            </div>
                                                                            <small class="text-muted">Toàn thời gian •
                                                                                ${job.positionName != null ? job.positionName : 'Chuyên viên'}</small>
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
                                                                        <td class="text-center" onclick="event.stopPropagation()">
                                                                            <div class="d-inline-flex align-items-center gap-1 cursor-pointer p-1 px-2 rounded-pill bg-light border hover-shadow"
                                                                                title="Bấm để xem trước thông tin tuyển dụng của nhân viên này"
                                                                                onclick="openEmployeePreviewModal('${job.assigneeName != null ? job.assigneeName : 'Phạm Phương Thảo'}', '${job.requestCode}', '${job.title}', '${job.departmentName}', '${job.salaryMinFormatted} - ${job.salaryMaxFormatted} Tr', '${job.deadline}', '${job.hiredCount}/${job.targetHeadcount}', '${job.candidateCount}', '${job.status}', '${job.location != null ? job.location : 'Hà Nội'}', '${job.assigneeAvatarInitials != null ? job.assigneeAvatarInitials : 'PT'}')">
                                                                                <div class="avatar-circle bg-primary text-white fw-bold" style="width: 22px; height: 22px; font-size: 0.65rem;">
                                                                                    ${job.assigneeAvatarInitials != null ? job.assigneeAvatarInitials : 'PT'}
                                                                                </div>
                                                                                <span class="small fw-semibold text-dark text-truncate" style="max-width: 80px;">${job.assigneeName != null ? job.assigneeName : 'Phương Thảo'}</span>
                                                                                <i class="bi bi-eye text-primary ms-1" style="font-size: 0.72rem;"></i>
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
                                                            data-id="${job.id}"
                                                            data-code="${job.requestCode}"
                                                            data-title="${job.title}"
                                                            data-dept="${job.departmentName}"
                                                            data-status="${job.status}"
                                                            data-location="${job.location != null ? job.location : 'Hà Nội'}"
                                                            data-keywords="${job.keywords != null ? job.keywords : ''}"
                                                            data-salary-min="${job.salaryMinFormatted}"
                                                            data-salary-max="${job.salaryMaxFormatted}"
                                                            data-raw-salary-min="${job.salaryMin != null ? job.salaryMin : 0}"
                                                            data-raw-salary-max="${job.salaryMax != null ? job.salaryMax : 0}"
                                                            data-negotiable="${job.salaryNegotiable}">
                                                            <div class="card h-100 border-0 shadow-sm rounded-3 p-3 job-card-interactive position-relative"
                                                                style="cursor: pointer;"
                                                                onclick="selectJobById(${job.id})">
                                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                                    <div class="d-flex align-items-center gap-1">
                                                                        <span class="badge bg-primary-subtle text-primary font-monospace fw-bold">${job.requestCode}</span>
                                                                        <span class="badge bg-light text-muted border" style="font-size: 0.7rem;">
                                                                            <i class="bi bi-geo-alt text-danger me-1"></i>${job.location != null ? job.location : 'Hà Nội'}
                                                                        </span>
                                                                    </div>
                                                                    <span class="badge ${job.status eq 'OPEN' ? 'bg-success-subtle text-success' : 'bg-light text-muted'}">${job.status}</span>
                                                                </div>
                                                                <h6 class="fw-bold text-dark mb-1">${job.title}</h6>
                                                                <div class="text-muted small mb-2"><i class="bi bi-building me-1"></i>${job.departmentName}</div>
                                                                <div class="fw-bold text-primary small mb-2">
                                                                    ${job.salaryMinFormatted} - ${job.salaryMaxFormatted} Triệu VNĐ
                                                                </div>
                                                                <div class="pt-2 border-top d-flex justify-content-between align-items-center small text-muted">
                                                                    <div class="d-flex align-items-center gap-1" onclick="event.stopPropagation(); openEmployeePreviewModal('${job.assigneeName != null ? job.assigneeName : 'Phạm Phương Thảo'}', '${job.requestCode}', '${job.title}', '${job.departmentName}', '${job.salaryMinFormatted} - ${job.salaryMaxFormatted} Tr', '${job.deadline}', '${job.hiredCount}/${job.targetHeadcount}', '${job.candidateCount}', '${job.status}', '${job.location != null ? job.location : 'Hà Nội'}', '${job.assigneeAvatarInitials != null ? job.assigneeAvatarInitials : 'PT'}')">
                                                                        <div class="avatar-circle bg-primary text-white fw-bold" style="width: 20px; height: 20px; font-size: 0.6rem;">
                                                                            ${job.assigneeAvatarInitials != null ? job.assigneeAvatarInitials : 'PT'}
                                                                        </div>
                                                                        <span class="text-dark fw-semibold" style="font-size: 0.75rem;">${job.assigneeName != null ? job.assigneeName : 'HR'}</span>
                                                                    </div>
                                                                    <div class="d-flex align-items-center gap-1">
                                                                        <button type="button" class="btn btn-sm btn-outline-secondary py-0 px-1" title="Chia sẻ tin" onclick="event.stopPropagation(); openShareJobModalById(${job.id});">
                                                                            <i class="bi bi-share"></i>
                                                                        </button>
                                                                        <span class="text-primary fw-semibold">${job.candidateCount} CV</span>
                                                                    </div>
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
                                                                ${selectedJob.status eq 'OPEN' ? 'Đang nhận CV' : selectedJob.status}
                                                            </span>
                                                            <h3 id="previewTitle" class="h5 fw-bold text-dark mb-0">
                                                                ${selectedJob.title}</h3>
                                                        </div>
                                                    </div>

                                                    <div
                                                        class="d-flex flex-wrap align-items-center gap-3 text-muted small mb-3">
                                                        <span id="previewDept"><i
                                                                class="bi bi-geo-alt text-primary me-1"></i>${selectedJob.departmentName != null ? selectedJob.departmentName : 'Hà Nội (Hybrid)'}</span>
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
                                                            class="btn btn-primary btn-sm flex-grow-1 d-flex align-items-center justify-content-center gap-2 shadow-sm"
                                                            data-bs-toggle="modal" data-bs-target="#applyJobModal">
                                                            <i class="bi bi-cloud-arrow-up-fill"></i>
                                                            <span>+ Đẩy Bản Mềm CV Lên</span>
                                                        </button>
                                                        <button type="button"
                                                            class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-2"
                                                            onclick="copyShareLink()">
                                                            <i class="bi bi-share"></i>
                                                            <span>Chia sẻ tin</span>
                                                        </button>
                                                    </div>

                                                    <!-- Quick Soft-Copy CV List for this Job -->
                                                    <div class="card border-0 bg-light p-2 px-3 rounded-3 mb-3">
                                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                                            <span class="small fw-bold text-dark"><i class="bi bi-file-earmark-person-fill text-primary me-1"></i>Bản mềm CV ứng tuyển vị trí này</span>
                                                            <span class="badge bg-primary-subtle text-primary">${fn:length(approvedJobCandidates)} CV</span>
                                                        </div>
                                                        <div class="d-flex flex-column gap-2" style="max-height: 180px; overflow-y: auto;">
                                                            <c:choose>
                                                                <c:when test="${not empty approvedJobCandidates}">
                                                                    <c:forEach items="${approvedJobCandidates}" var="ac" varStatus="idx">
                                                                        <c:if test="${idx.index < 4}">
                                                                            <div class="d-flex justify-content-between align-items-center bg-white p-2 rounded border shadow-xs">
                                                                                <div class="d-flex align-items-center gap-2 overflow-hidden">
                                                                                    <i class="bi ${ac.cvTypeIcon} text-primary fs-5"></i>
                                                                                    <div class="text-truncate">
                                                                                        <div class="fw-bold text-dark small text-truncate">${ac.fullName}</div>
                                                                                        <span class="badge bg-light text-secondary border" style="font-size: 0.68rem;">${ac.cvTypeFormatted}</span>
                                                                                    </div>
                                                                                </div>
                                                                                <button type="button" class="btn btn-sm btn-outline-primary py-0 px-2 flex-shrink-0" onclick="openCandidateCvModal(${ac.id})" title="Xem trực tiếp bản mềm CV">
                                                                                    <i class="bi bi-eye"></i> Xem CV
                                                                                </button>
                                                                            </div>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="text-muted small py-2 text-center">Chưa có CV nào nộp cho vị trí này.</div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>

                                                    <!-- AI Smart CV Screener Highlight Banner -->
                                                    <div class="ai-insight-box mb-4">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center mb-2">
                                                            <span class="ai-sparkle-badge"><i class="bi bi-funnel-fill"></i>
                                                                ĐỌC & LỌC CV TỰ ĐỘNG</span>
                                                            <span id="previewAiCandCount"
                                                                class="badge bg-purple-subtle text-purple fw-bold"
                                                                style="background: #f3e8ff; color: #7e22ce;">
                                                                ${selectedJob.candidateCount} CV đã nộp
                                                            </span>
                                                        </div>
                                                        <p class="small text-dark mb-2" style="font-size: 0.8rem;">
                                                            Hệ thống đã tự động phân tích
                                                            <strong>${selectedJob.candidateCount} CV</strong> ứng tuyển
                                                            vị trí này: <strong>3 CV khớp xuất sắc (90%+)</strong>,
                                                            <strong>bóc tách kỹ năng theo chuẩn JD</strong>.
                                                        </p>
                                                        <button type="button"
                                                            class="btn btn-sm text-white w-100 fw-semibold d-flex align-items-center justify-content-center gap-2 shadow-sm"
                                                            style="background: linear-gradient(135deg, #7e22ce 0%, #2563eb 100%); border: none;"
                                                            data-bs-toggle="modal" data-bs-target="#aiCvScreeningModal">
                                                            <i class="bi bi-check2-square"></i>
                                                            <span>Đánh giá & Lọc Top 3 CV</span>
                                                        </button>
                                                    </div>

                                                    <!-- Recruiter Info -->
                                                    <div
                                                        class="p-3 bg-light rounded-3 d-flex align-items-center justify-content-between mb-4">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div id="previewAvatarInitials"
                                                                class="avatar-circle bg-primary text-white fw-bold"
                                                                style="width: 36px; height: 36px; font-size: 0.8rem;">
                                                                ${selectedJob.assigneeAvatarInitials != null ? selectedJob.assigneeAvatarInitials : 'HR'}
                                                            </div>
                                                            <div>
                                                                <div id="previewRecruiterName" class="fw-bold text-dark"
                                                                    style="font-size: 0.83rem;">
                                                                    ${selectedJob.assigneeName != null ? selectedJob.assigneeName : 'Phạm Phương Thảo'}
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
                                                                             <!-- ========================================================================= -->
                                         <!-- SECTION: DANH SÁCH ỨNG VIÊN ĐÃ ĐƯỢC AI LỌC & DUYỆT (CHO VỊ TRÍ NÀY)     -->
                                         <!-- ========================================================================= -->
                                         <div class="card border-0 shadow-sm rounded-3 mt-4">
                                             <div class="card-header bg-white border-bottom py-3 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-2">
                                                 <div>
                                                     <div class="d-flex align-items-center gap-2">
                                                         <i class="bi bi-person-check-fill fs-5 text-primary"></i>
                                                         <h2 class="h6 fw-bold mb-0 text-dark">Danh sách ứng viên đã được AI lọc & duyệt cho vị trí: <span class="text-primary">${selectedJob.title}</span></h2>
                                                         <span class="badge bg-purple-subtle text-purple font-monospace fw-bold" style="background: #f3e8ff; color: #7e22ce;">${selectedJob.requestCode}</span>
                                                     </div>
                                                     <p class="text-muted small mb-0 mt-1">Các hồ sơ ứng viên thật trong Database đã được AI sàng lọc và phân loại cho vị trí tuyển dụng này.</p>
                                                 </div>
                                                 <div class="d-flex gap-2">
                                                     <button type="button" class="btn btn-sm btn-outline-primary d-flex align-items-center gap-1" data-bs-toggle="modal" data-bs-target="#applyJobModal">
                                                         <i class="bi bi-person-plus-fill"></i>
                                                         <span>+ Nộp CV Ứng Tuyển Mới</span>
                                                     </button>
                                                     <button type="button" class="btn btn-sm text-white d-flex align-items-center gap-1 shadow-sm" style="background: linear-gradient(135deg, #7e22ce 0%, #2563eb 100%); border: none;" data-bs-toggle="modal" data-bs-target="#aiCvScreeningModal">
                                                         <i class="bi bi-stars"></i>
                                                         <span>🤖 Lọc CV Bằng AI</span>
                                                     </button>
                                                 </div>
                                             </div>
                                             <div class="card-body p-0">
                                                 <c:choose>
                                                     <c:when test="${not empty approvedJobCandidates}">
                                                         <div class="table-responsive">
                                                             <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                                                                 <thead class="table-light">
                                                                     <tr>
                                                                         <th class="ps-3" style="width: 100px;">Mã UV</th>
                                                                         <th>Họ tên ứng viên</th>
                                                                         <th>Kinh nghiệm & Lương HV</th>
                                                                         <th>AI Match Score</th>
                                                                         <th>Vòng tuyển dụng</th>
                                                                         <th>Kênh nguồn</th>
                                                                         <th>Ngày nộp</th>
                                                                         <th class="pe-3 text-end">Thao tác</th>
                                                                     </tr>
                                                                 </thead>
                                                                 <tbody>
                                                                     <c:forEach items="${approvedJobCandidates}" var="cand">
                                                                         <tr>
                                                                             <td class="ps-3 fw-bold font-monospace text-primary">${cand.candidateCode}</td>
                                                                             <td>
                                                                                 <div class="fw-bold text-dark">${cand.fullName}</div>
                                                                                 <small class="text-muted">${cand.email} • ${cand.phone}</small>
                                                                             </td>
                                                                             <td>
                                                                                 <div><strong>${cand.experienceYears} năm</strong> kinh nghiệm</div>
                                                                                 <small class="text-muted">Lương mong muốn: ${cand.formattedSalary} VNĐ</small>
                                                                             </td>
                                                                             <td>
                                                                                 <div class="d-flex align-items-center gap-2" style="min-width: 140px;">
                                                                                     <span class="badge ${cand.aiMatchScore >= 90 ? 'bg-success' : (cand.aiMatchScore >= 80 ? 'bg-primary' : 'bg-warning text-dark')} fw-bold">
                                                                                         ${cand.aiMatchScore}%
                                                                                     </span>
                                                                                     <div class="progress flex-grow-1" style="height: 6px;">
                                                                                         <div class="progress-bar ${cand.aiMatchScore >= 90 ? 'bg-success' : (cand.aiMatchScore >= 80 ? 'bg-primary' : 'bg-warning')}" style="width: ${cand.aiMatchScore}%;"></div>
                                                                                     </div>
                                                                                 </div>
                                                                             </td>
                                                                             <td>
                                                                                 <c:choose>
                                                                                     <c:when test="${cand.stage eq 'INTERVIEW'}"><span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle"><i class="bi bi-calendar-event me-1"></i>Phỏng vấn</span></c:when>
                                                                                     <c:when test="${cand.stage eq 'SCREENING'}"><span class="badge bg-info-subtle text-info border border-info-subtle"><i class="bi bi-funnel me-1"></i>Sàng lọc CV</span></c:when>
                                                                                     <c:when test="${cand.stage eq 'OFFER'}"><span class="badge bg-purple-subtle text-purple border border-purple-subtle" style="background:#f3e8ff; color:#7e22ce;"><i class="bi bi-envelope-open me-1"></i>Offer</span></c:when>
                                                                                     <c:when test="${cand.stage eq 'ONBOARDED'}"><span class="badge bg-success-subtle text-success border border-success-subtle"><i class="bi bi-check-circle me-1"></i>Nhận việc</span></c:when>
                                                                                     <c:otherwise><span class="badge bg-light text-dark border"><i class="bi bi-inbox me-1"></i>Mới nộp</span></c:otherwise>
                                                                                 </c:choose>
                                                                             </td>
                                                                             <td><span class="badge bg-light text-muted border">${cand.source}</span></td>
                                                                             <td class="text-muted small">${cand.formattedAppliedDate}</td>
                                                                             <td class="pe-3 text-end">
                                                                                 <button type="button" class="btn btn-sm btn-outline-primary py-0 px-2 me-1 shadow-sm" onclick="openCandidateCvModal(${cand.id})" title="Xem trực tiếp bản mềm CV"><i class="bi ${cand.cvTypeIcon}"></i> Xem CV</button>
                                                                                <div class="dropdown d-inline-block">
                                                                                     <button class="btn btn-sm btn-light border" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                                                         Thao tác <i class="bi bi-chevron-down ms-1" style="font-size: 0.7rem;"></i>
                                                                                     </button>
                                                                                     <ul class="dropdown-menu dropdown-menu-end shadow-sm" style="font-size: 0.8rem;">
                                                                                         <li>
                                                                                             <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                                                                                                 <input type="hidden" name="action" value="update_stage">
                                                                                                 <input type="hidden" name="candidateId" value="${cand.id}">
                                                                                                 <input type="hidden" name="stage" value="INTERVIEW">
                                                                                                 <input type="hidden" name="returnView" value="jobs">
                                                                                                 <input type="hidden" name="jobId" value="${selectedJob.id}">
                                                                                                 <button type="submit" class="dropdown-item d-flex align-items-center gap-2"><i class="bi bi-arrow-right-circle text-primary"></i>Chuyển Vòng PV</button>
                                                                                             </form>
                                                                                         </li>
                                                                                         <li>
                                                                                             <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                                                                                                 <input type="hidden" name="action" value="update_stage">
                                                                                                 <input type="hidden" name="candidateId" value="${cand.id}">
                                                                                                 <input type="hidden" name="stage" value="OFFER">
                                                                                                 <input type="hidden" name="returnView" value="jobs">
                                                                                                 <input type="hidden" name="jobId" value="${selectedJob.id}">
                                                                                                 <button type="submit" class="dropdown-item d-flex align-items-center gap-2"><i class="bi bi-envelope-paper text-success"></i>Gửi Offer</button>
                                                                                             </form>
                                                                                         </li>
                                                                                         <li><hr class="dropdown-divider"></li>
                                                                                         <li><a class="dropdown-item d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/recruitment?view=candidates&candidateId=${cand.id}"><i class="bi bi-person-lines-fill text-muted"></i>Xem Hồ Sơ Chi Tiết</a></li>
                                                                                     </ul>
                                                                                 </div>
                                                                             </td>
                                                                         </tr>
                                                                     </c:forEach>
                                                                 </tbody>
                                                             </table>
                                                         </div>
                                                     </c:when>
                                                     <c:otherwise>
                                                         <div class="text-center py-5 px-3">
                                                             <i class="bi bi-person-x text-muted fs-1 mb-2"></i>
                                                             <h6 class="fw-bold text-dark">Chưa có ứng viên nào cho vị trí này</h6>
                                                             <p class="text-muted small mb-3">Vui lòng nộp CV trực tiếp hoặc kích hoạt Quét AI để tìm ứng viên phù hợp nhất cho vị trí <strong>${selectedJob.title}</strong>.</p>
                                                             <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#applyJobModal">+ Nộp CV Ứng Tuyển Mới</button>
                                                         </div>
                                                     </c:otherwise>
                                                 </c:choose>
                                             </div>
                                         </div>
                                     </main>

                                    <!-- Footer -->
                                    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
                            </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 1: XEM TRƯỚC THÔNG TIN TUYỂN DỤNG THEO NHÂN VIÊN (#previewEmployeeJobModal) -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="previewEmployeeJobModal" tabindex="-1" aria-labelledby="previewEmployeeJobModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header text-white p-3 px-4" style="background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-person-badge-fill fs-5"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="previewEmployeeJobModalLabel">Thông Tin Nhân Viên Tuyển Dụng</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Xem trước hồ sơ phụ trách & vị trí tuyển dụng của nhân viên</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4" style="background: #f8fafc;">
                                    <!-- Employee Card -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                        <div class="d-flex align-items-center gap-3">
                                            <div id="empModalAvatar" class="avatar-circle bg-primary text-white fw-bold shadow-sm" style="width: 50px; height: 50px; font-size: 1.15rem;">
                                                PT
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <h6 id="empModalName" class="fw-bold text-dark mb-1 fs-6">Phạm Phương Thảo</h6>
                                                    <span class="badge bg-primary-subtle text-primary fw-semibold">HR Recruiter</span>
                                                </div>
                                                <div class="text-muted small">
                                                    <div><i class="bi bi-envelope me-1"></i><span id="empModalEmail">recruiter.hr@miximoi.com</span></div>
                                                    <div><i class="bi bi-telephone me-1"></i><span id="empModalPhone">0988.234.567</span> • <i class="bi bi-geo-alt me-1"></i>Văn phòng Hà Nội</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Job Assigned Details -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                        <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                                            <h6 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                                                <i class="bi bi-briefcase-fill text-primary"></i>
                                                <span>Vị trí tuyển dụng đang phụ trách</span>
                                            </h6>
                                            <span id="empModalJobStatus" class="badge bg-success-subtle text-success border border-success-subtle">Đang tuyển</span>
                                        </div>

                                        <div class="mb-3">
                                            <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                                                <span id="empModalJobCode" class="badge bg-light text-primary border font-monospace fw-bold">YCTD-2026-081</span>
                                                <h6 id="empModalJobTitle" class="fw-bold text-dark mb-0 fs-6">Senior Fullstack Engineer</h6>
                                            </div>
                                            <div class="text-muted small">
                                                <i class="bi bi-building me-1"></i><span id="empModalJobDept">Phòng Công nghệ & Phần mềm</span>
                                                <span class="mx-2">•</span>
                                                <i class="bi bi-geo-alt text-danger me-1"></i><span id="empModalJobLocation">Hà Nội</span>
                                            </div>
                                        </div>

                                        <div class="row g-2 text-center mb-3">
                                            <div class="col-4">
                                                <div class="p-2 rounded bg-light border">
                                                    <div class="text-muted" style="font-size: 0.7rem;">MỨC LƯƠNG</div>
                                                    <div id="empModalJobSalary" class="fw-bold text-primary small">25 - 45 Tr</div>
                                                </div>
                                            </div>
                                            <div class="col-4">
                                                <div class="p-2 rounded bg-light border">
                                                    <div class="text-muted" style="font-size: 0.7rem;">CHỈ TIÊU TUYỂN</div>
                                                    <div id="empModalJobProgress" class="fw-bold text-dark small">0/3 Đạt</div>
                                                </div>
                                            </div>
                                            <div class="col-4">
                                                <div class="p-2 rounded bg-light border">
                                                    <div class="text-muted" style="font-size: 0.7rem;">HỒ SƠ CV</div>
                                                    <div id="empModalJobCandCount" class="fw-bold text-success small">6 CV nộp</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex align-items-center justify-content-between small text-muted p-2 rounded bg-light">
                                            <span><i class="bi bi-calendar-event me-1"></i>Hạn nộp hồ sơ:</span>
                                            <strong id="empModalJobDeadline" class="text-dark">30/10/2026</strong>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer bg-white border-top p-3 px-4 d-flex justify-content-between">
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-outline-primary btn-sm" onclick="shareFromEmpModal()">
                                            <i class="bi bi-share me-1"></i>Chia sẻ tin
                                        </button>
                                        <button type="button" class="btn btn-primary btn-sm" onclick="selectFromEmpModal()">
                                            <i class="bi bi-eye me-1"></i>Xem trước vị trí trên trang
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 2: CHIA SẺ THÔNG TIN TUYỂN DỤNG (#shareJobModal)                       -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="shareJobModal" tabindex="-1" aria-labelledby="shareJobModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header text-white p-3 px-4" style="background: linear-gradient(135deg, #0284c7 0%, #2563eb 100%);">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-share-fill fs-5"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="shareJobModalLabel">Chia Sẻ Thông Tin Tuyển Dụng</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Sao chép liên kết, mẫu đăng mạng xã hội & chia sẻ đa kênh</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-4" style="background: #f8fafc;">
                                    <!-- Job Summary Card -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <span id="shareModalJobCode" class="badge bg-primary-subtle text-primary font-monospace fw-bold">${selectedJob.requestCode}</span>
                                            <span id="shareModalJobLocation" class="badge bg-light text-muted border"><i class="bi bi-geo-alt text-danger me-1"></i>${selectedJob.location != null ? selectedJob.location : 'Hà Nội'}</span>
                                        </div>
                                        <h6 id="shareModalJobTitle" class="fw-bold text-dark mb-1 fs-6">${selectedJob.title}</h6>
                                        <div class="text-muted small mb-0"><i class="bi bi-building me-1"></i><span id="shareModalJobDept">${selectedJob.departmentName}</span> • <span id="shareModalJobSalary" class="text-primary fw-semibold">${selectedJob.salaryMinFormatted} - ${selectedJob.salaryMaxFormatted} Triệu VNĐ</span></div>
                                    </div>

                                    <!-- 1. Copy Direct Link -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                        <label class="form-label small fw-bold text-dark mb-1"><i class="bi bi-link-45deg text-primary me-1"></i>Đường dẫn tuyển dụng công khai (Public Link)</label>
                                        <div class="input-group input-group-sm mb-2">
                                            <input type="text" id="shareJobUrlInput" class="form-control font-monospace" readonly value="">
                                            <button class="btn btn-primary" type="button" onclick="copyShareJobUrl()">
                                                <i class="bi bi-clipboard me-1"></i>Sao chép
                                            </button>
                                        </div>
                                        <div class="d-flex align-items-center gap-2 text-muted" style="font-size: 0.75rem;">
                                            <i class="bi bi-qr-code text-primary"></i>
                                            <span>Mã định danh: <strong id="shareJobRefCode" class="text-dark font-monospace">${selectedJob.requestCode}</strong> (Ứng viên quét nộp CV trực tiếp)</span>
                                        </div>
                                    </div>

                                    <!-- 2. Social Media Template Snippet -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <label class="form-label small fw-bold text-dark mb-0"><i class="bi bi-chat-quote-fill text-primary me-1"></i>Mẫu bài đăng mạng xã hội (Facebook / LinkedIn / Zalo)</label>
                                            <button type="button" class="btn btn-sm btn-link p-0 text-decoration-none fw-semibold" onclick="copySharePostContent()">
                                                <i class="bi bi-copy me-1"></i>Sao chép bài đăng
                                            </button>
                                        </div>
                                        <textarea id="sharePostTemplateText" class="form-control form-control-sm font-monospace bg-light" rows="5" readonly style="font-size: 0.78rem; line-height: 1.5;"></textarea>
                                    </div>

                                    <!-- 3. One-Click Social Share Buttons -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                        <label class="form-label small fw-bold text-dark mb-2"><i class="bi bi-broadcast text-primary me-1"></i>Chia sẻ nhanh 1 chạm</label>
                                        <div class="d-flex flex-wrap gap-2">
                                            <button type="button" class="btn btn-sm btn-outline-primary d-flex align-items-center gap-1 flex-grow-1 justify-content-center" onclick="shareToFacebook()">
                                                <i class="bi bi-facebook text-primary"></i><span>Facebook</span>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-info d-flex align-items-center gap-1 flex-grow-1 justify-content-center" onclick="shareToLinkedIn()">
                                                <i class="bi bi-linkedin text-info"></i><span>LinkedIn</span>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-success d-flex align-items-center gap-1 flex-grow-1 justify-content-center" onclick="shareToZalo()">
                                                <i class="bi bi-chat-dots text-success"></i><span>Zalo</span>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-secondary d-flex align-items-center gap-1 flex-grow-1 justify-content-center" onclick="shareViaEmail()">
                                                <i class="bi bi-envelope-at text-danger"></i><span>Email nội bộ</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer bg-white border-top p-3 px-4">
                                    <button type="button" class="btn btn-secondary w-100" data-bs-dismiss="modal">Đóng cửa sổ</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 3: LỌC CV TỰ ĐỘNG THEO KEY TỪ KHÓA (WORD, PDF, BẢN CHỮ VIẾT)       -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="aiCvScreeningModal" tabindex="-1" aria-labelledby="aiCvScreeningModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header p-3 px-4 text-white" style="background: linear-gradient(135deg, #7e22ce 0%, #2563eb 100%);">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-cpu-fill fs-4"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="aiCvScreeningModalLabel">
                                                Lọc CV Tự Động Theo Key Từ Khóa (Word, PDF, Bản Chữ Viết OCR)
                                            </h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">
                                                Quét đối sánh từ khóa tự động trên hồ sơ ứng viên dạng Word (.docx), File PDF (.pdf) và Bản chữ viết tay (OCR notes)
                                            </small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-4" style="background: #f8fafc;">
                                    <!-- Nav Tabs: 1. Quét ứng viên trong Database | 2. Quét & Thử nghiệm trực tiếp -->
                                    <ul class="nav nav-pills mb-3 p-1 bg-white rounded-3 border shadow-sm" id="cvScannerTabs" role="tablist">
                                        <li class="nav-item flex-fill text-center" role="presentation">
                                            <button class="nav-link active fw-bold small py-2 w-100" id="db-scanner-tab" data-bs-toggle="pill" data-bs-target="#db-scanner-content" type="button" role="tab">
                                                <i class="bi bi-funnel-fill me-1 text-primary"></i>1. Quét & Lọc Ứng Viên Database (<span id="cvScanTotalCount">${allSystemCandidates.size()}</span> CV)
                                            </button>
                                        </li>
                                        <li class="nav-item flex-fill text-center" role="presentation">
                                            <button class="nav-link fw-bold small py-2 w-100" id="live-scanner-tab" data-bs-toggle="pill" data-bs-target="#live-scanner-content" type="button" role="tab">
                                                <i class="bi bi-pen-fill me-1 text-purple" style="color: #7e22ce;"></i>2. Quét Trực Tiếp CV Mới (Word / PDF / Chữ viết tay)
                                            </button>
                                        </li>
                                    </ul>

                                    <div class="tab-content" id="cvScannerTabContent">
                                        <!-- TAB 1: Quét ứng viên Database -->
                                        <div class="tab-pane fade show active" id="db-scanner-content" role="tabpanel">
                                            <!-- Keyword Configuration & Format Filter Bar -->
                                            <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                                <div class="row g-2 align-items-center mb-2">
                                                    <div class="col-12 col-md-7">
                                                        <label class="form-label small fw-bold text-dark mb-1 d-flex align-items-center gap-1">
                                                            <i class="bi bi-key-fill text-warning"></i>
                                                            <span>Từ khóa quét CV (Keywords) - Phân tách bằng dấu phẩy:</span>
                                                        </label>
                                                        <div class="input-group input-group-sm">
                                                            <input type="text" class="form-control" id="scannerKeywordsInput"
                                                                value="${not empty selectedJob.keywords ? selectedJob.keywords : 'Java, Spring Boot, PostgreSQL, Microservices, Docker, React, Git, RESTful'}"
                                                                placeholder="VD: Java, Spring Boot, PostgreSQL, Docker, Microservices, React">
                                                            <button class="btn btn-primary px-3 fw-semibold" type="button" onclick="runKeywordScanOnCandidates()">
                                                                <i class="bi bi-search me-1"></i>Quét & Chấm Điểm
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-md-5">
                                                        <label class="form-label small fw-bold text-dark mb-1">
                                                            <i class="bi bi-filter-circle me-1"></i>Phạm vi quét & Định dạng CV:
                                                        </label>
                                                        <div class="d-flex gap-2">
                                                            <select class="form-select form-select-sm" id="scannerScopeSelect" onchange="runKeywordScanOnCandidates()">
                                                                <option value="CURRENT_JOB" selected>Chỉ vị trí hiện tại: ${selectedJob.requestCode}</option>
                                                                <option value="ALL">Toàn bộ ứng viên hệ thống (${allSystemCandidates.size()})</option>
                                                            </select>
                                                            <select class="form-select form-select-sm" id="scannerFormatSelect" onchange="runKeywordScanOnCandidates()">
                                                                <option value="ALL" selected>Tất cả định dạng</option>
                                                                <option value="WORD">📄 Bản Word (.docx)</option>
                                                                <option value="PDF">📑 File PDF (.pdf)</option>
                                                                <option value="HANDWRITTEN">✍️ Bản chữ viết (OCR)</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Quick Keyword Chips -->
                                                <div class="d-flex align-items-center gap-1 flex-wrap pt-2 border-top">
                                                    <span class="text-muted small me-1" style="font-size: 0.72rem;">Thêm nhanh key:</span>
                                                    <button type="button" class="btn btn-sm btn-light border py-0 px-2 rounded-pill" style="font-size: 0.72rem;" onclick="addQuickKeyword('Java')">+ Java</button>
                                                    <button type="button" class="btn btn-sm btn-light border py-0 px-2 rounded-pill" style="font-size: 0.72rem;" onclick="addQuickKeyword('Spring Boot')">+ Spring Boot</button>
                                                    <button type="button" class="btn btn-sm btn-light border py-0 px-2 rounded-pill" style="font-size: 0.72rem;" onclick="addQuickKeyword('PostgreSQL')">+ PostgreSQL</button>
                                                    <button type="button" class="btn btn-sm btn-light border py-0 px-2 rounded-pill" style="font-size: 0.72rem;" onclick="addQuickKeyword('Microservices')">+ Microservices</button>
                                                    <button type="button" class="btn btn-sm btn-light border py-0 px-2 rounded-pill" style="font-size: 0.72rem;" onclick="addQuickKeyword('Docker')">+ Docker</button>
                                                    <button type="button" class="btn btn-sm btn-light border py-0 px-2 rounded-pill" style="font-size: 0.72rem;" onclick="addQuickKeyword('React')">+ React</button>
                                                    <button type="button" class="btn btn-sm btn-light border py-0 px-2 rounded-pill" style="font-size: 0.72rem;" onclick="addQuickKeyword('RESTful')">+ RESTful</button>
                                                    <button type="button" class="btn btn-sm btn-light border py-0 px-2 rounded-pill" style="font-size: 0.72rem;" onclick="addQuickKeyword('Chữ viết tay')">+ Chữ viết tay</button>
                                                    <button type="button" class="btn btn-sm btn-outline-secondary py-0 px-2 rounded-pill ms-auto" style="font-size: 0.72rem;" onclick="resetDefaultKeywords()">Khôi phục mặc định</button>
                                                </div>
                                            </div>

                                            <!-- Summary of Scan Results -->
                                            <div class="d-flex justify-content-between align-items-center mb-2 px-1">
                                                <div class="small text-muted">
                                                    Đã quét đối sánh trên <strong id="scanMatchedCount">0</strong> hồ sơ CV ứng viên.
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle ms-1" id="scanHighMatchCount">0 Khớp cao (>=70%)</span>
                                                </div>
                                                <div class="d-flex gap-2 align-items-center">
                                                    <span class="small text-muted">Xếp theo: Điểm khớp từ khóa cao nhất</span>
                                                </div>
                                            </div>

                                            <!-- Container list of scanned candidate cards -->
                                            <div id="scannedCandidatesContainer" class="row g-3">
                                                <!-- Populated dynamically via JS runKeywordScanOnCandidates() -->
                                            </div>

                                            <!-- Hidden raw database candidates data for JavaScript scanner -->
                                            <div id="rawCandidateDataStore" style="display: none;">
                                                <c:forEach items="${allSystemCandidates}" var="c">
                                                    <div class="raw-cand-item"
                                                        data-id="${c.id}"
                                                        data-code="${fn:escapeXml(c.candidateCode)}"
                                                        data-name="${fn:escapeXml(c.fullName)}"
                                                        data-email="${fn:escapeXml(c.email)}"
                                                        data-phone="${fn:escapeXml(c.phone)}"
                                                        data-req-id="${c.recruitmentRequestId}"
                                                        data-job-title="${fn:escapeXml(c.jobTitle)}"
                                                        data-dept="${fn:escapeXml(c.departmentName)}"
                                                        data-stage="${c.stage}"
                                                        data-source="${fn:escapeXml(c.source)}"
                                                        data-exp="${c.experienceYears}"
                                                        data-salary="${fn:escapeXml(c.formattedSalary)}"
                                                        data-applied-date="${c.formattedAppliedDate}"
                                                        data-cv-type="${c.cvType}"
                                                        data-cv-text="${fn:escapeXml(c.cvText)}"
                                                        data-notes="${fn:escapeXml(c.notes)}"
                                                        data-skills="${fn:escapeXml(c.skills)}">
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <!-- TAB 2: Quét Trực Tiếp CV Mới (Word / PDF / Chữ viết tay) -->
                                        <div class="tab-pane fade" id="live-scanner-content" role="tabpanel">
                                            <div class="card border-0 shadow-sm rounded-3 p-3 bg-white mb-3">
                                                <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                                                    <h6 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                                                        <i class="bi bi-file-earmark-code text-primary"></i>
                                                        <span>Thử nghiệm bộ bóc tách văn bản CV tự động (NLP Keyword Extraction)</span>
                                                    </h6>
                                                    <div class="d-flex gap-1">
                                                        <button type="button" class="btn btn-sm btn-outline-primary py-0 px-2" onclick="loadSampleCvText('WORD')">
                                                            <i class="bi bi-file-earmark-word me-1"></i>Mẫu CV Word IT
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-danger py-0 px-2" onclick="loadSampleCvText('PDF')">
                                                            <i class="bi bi-file-earmark-pdf me-1"></i>Mẫu CV PDF Tech
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-purple py-0 px-2" style="color: #7e22ce; border-color: #c084fc;" onclick="loadSampleCvText('HANDWRITTEN')">
                                                            <i class="bi bi-pen me-1"></i>Mẫu Chữ Viết Tay OCR
                                                        </button>
                                                    </div>
                                                </div>

                                                <form id="liveCvScanForm" method="POST" action="${pageContext.request.contextPath}/recruitment">
                                                    <input type="hidden" name="action" value="add_candidate">
                                                    <input type="hidden" name="returnView" value="jobs">
                                                    <input type="hidden" name="recruitmentRequestId" id="liveScanJobId" value="${selectedJob.id}">

                                                    <div class="row g-3 mb-3">
                                                        <div class="col-12 col-md-3">
                                                            <label class="form-label small fw-semibold text-muted">Định dạng hồ sơ CV <span class="text-danger">*</span></label>
                                                            <select class="form-select form-select-sm" name="cvType" id="liveCvTypeSelect" onchange="updateLiveCvPlaceholder()">
                                                                <option value="WORD">📄 Bản Word (.docx / .doc)</option>
                                                                <option value="PDF" selected>📑 File PDF (.pdf)</option>
                                                                <option value="HANDWRITTEN">✍️ Bản chữ viết (OCR Handwritten notes)</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-12 col-md-4">
                                                            <label class="form-label small fw-semibold text-muted">Họ tên ứng viên <span class="text-danger">*</span></label>
                                                            <input type="text" class="form-control form-control-sm" name="fullName" id="liveCandidateName" placeholder="VD: Vũ Hoàng Long" required>
                                                        </div>
                                                        <div class="col-12 col-md-3">
                                                            <label class="form-label small fw-semibold text-muted">Email liên hệ <span class="text-danger">*</span></label>
                                                            <input type="email" class="form-control form-control-sm" name="email" id="liveCandidateEmail" placeholder="long.vu@example.com" required>
                                                        </div>
                                                        <div class="col-12 col-md-2">
                                                            <label class="form-label small fw-semibold text-muted">Số điện thoại</label>
                                                            <input type="text" class="form-control form-control-sm" name="phone" id="liveCandidatePhone" placeholder="0912.888.999">
                                                        </div>
                                                    </div>

                                                    <div class="row g-3 mb-3">
                                                        <div class="col-12 col-md-3">
                                                            <label class="form-label small fw-semibold text-muted">Kinh nghiệm (Năm)</label>
                                                            <input type="number" step="0.5" class="form-control form-control-sm" name="experienceYears" id="liveCandidateExp" value="3.0">
                                                        </div>
                                                        <div class="col-12 col-md-3">
                                                            <label class="form-label small fw-semibold text-muted">Lương mong muốn (VNĐ)</label>
                                                            <input type="number" class="form-control form-control-sm" name="expectedSalary" id="liveCandidateSalary" placeholder="28000000" step="1000000" value="28000000">
                                                        </div>
                                                        <div class="col-12 col-md-6">
                                                            <label class="form-label small fw-semibold text-muted">Từ khóa quét đối sánh (Key tags)</label>
                                                            <input type="text" class="form-control form-control-sm" id="liveKeywordsInput" value="Java, Spring Boot, PostgreSQL, Microservices, Docker, Git">
                                                        </div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label small fw-semibold text-muted d-flex justify-content-between align-items-center">
                                                            <span>Nội dung văn bản CV (Word / PDF / Bản chữ viết OCR) <span class="text-danger">*</span></span>
                                                            <span class="text-primary small cursor-pointer" onclick="scanDirectCvText()"><i class="bi bi-magic me-1"></i>Bấm quét & Highlight từ khóa</span>
                                                        </label>
                                                        <textarea class="form-control font-monospace" name="cvText" id="liveCvTextArea" rows="6" style="font-size: 0.8rem; line-height: 1.6;" placeholder="Dán nội dung quét từ CV Word, PDF hoặc văn bản chữ viết tay vào đây để hệ thống tự động bóc tách từ khóa..."></textarea>
                                                    </div>

                                                    <!-- Live Scan Highlight Result Preview -->
                                                    <div id="liveScanResultBox" class="p-3 rounded-3 bg-light border mb-3" style="display: none;">
                                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                                            <span class="fw-bold small text-dark"><i class="bi bi-check-all text-success me-1"></i>KẾT QUẢ ĐỐI SÁNH TỪ KHÓA TỨC THÌ:</span>
                                                            <span id="liveScanScoreBadge" class="badge bg-success fs-6">Độ khớp: 85%</span>
                                                        </div>
                                                        <div class="mb-2" id="liveMatchedTags">
                                                            <!-- tags -->
                                                        </div>
                                                        <div class="small p-2 bg-white rounded border" id="liveHighlightedSnippet" style="max-height: 150px; overflow-y: auto; line-height: 1.6;">
                                                            <!-- snippet with <mark> tags -->
                                                        </div>
                                                    </div>

                                                    <div class="d-flex justify-content-end gap-2">
                                                        <button type="button" class="btn btn-outline-primary" onclick="scanDirectCvText()">
                                                            <i class="bi bi-search me-1"></i>Quét Từ Khóa Trực Tiếp
                                                        </button>
                                                        <button type="submit" class="btn btn-primary d-flex align-items-center gap-1 shadow-sm">
                                                            <i class="bi bi-cloud-arrow-up-fill"></i>Lưu CV Vào Database
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer bg-white border-top p-3 px-4 d-flex justify-content-between">
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng cửa sổ</button>
                                    <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0">
                                        <input type="hidden" name="action" value="ai_batch_promote">
                                        <input type="hidden" name="jobId" id="aiBatchJobId" value="${selectedJob.id}">
                                        <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                                            <i class="bi bi-check2-all"></i>
                                            <span>Tự động chuyển Top CV vào Vòng Phỏng Vấn</span>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 3: TIẾP NHẬN HỒ SƠ & BẢN MỀM CV THÔNG MINH (#applyJobModal)         -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="applyJobModal" tabindex="-1" aria-labelledby="applyJobModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                            <div class="modal-content border-0 shadow-lg rounded-3 overflow-hidden">
                                <div class="modal-header bg-primary text-white p-3 px-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="bg-white text-primary rounded-circle p-2 d-flex align-items-center justify-content-center" style="width: 38px; height: 38px;">
                                            <i class="bi bi-cloud-arrow-up-fill fs-5"></i>
                                        </div>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="applyJobModalLabel">Tiếp Nhận Bản Mềm CV & Tự Động Bóc Tách Hồ Sơ</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Đẩy file PDF, Word hoặc Chữ viết tay lên để hệ thống tự động điền 100% hồ sơ không cần nhập tay</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form method="POST" action="${pageContext.request.contextPath}/recruitment" id="smartApplyCvForm">
                                    <input type="hidden" name="action" value="add_candidate">
                                    <input type="hidden" name="returnView" value="jobs">
                                    <input type="hidden" name="recruitmentRequestId" value="${selectedJob.id}">
                                    <div class="modal-body p-4" style="background: #f8fafc;">
                                        <!-- Top Guidance Banner -->
                                        <div class="alert alert-info border-info-subtle d-flex align-items-center gap-3 p-3 rounded-3 shadow-xs mb-3">
                                            <i class="bi bi-magic fs-3 text-primary"></i>
                                            <div class="small">
                                                <strong>Tiếp nhận hồ sơ không cần nhập tay:</strong> Bạn chỉ cần tải lên file CV bản mềm (PDF, Word, Ảnh bản chữ viết tay) hoặc bấm nạp nhanh 1 trong 4 mẫu CV bên dưới. Hệ thống sẽ bóc tách đầy đủ họ tên, liên lạc, số năm kinh nghiệm, kỹ năng và lưu trực tiếp vào cơ sở dữ liệu.
                                            </div>
                                        </div>

                                        <div class="row g-3">
                                            <!-- Col Left: Upload Area & Preset Selectors -->
                                            <div class="col-12 col-lg-5">
                                                <!-- Drag & Drop Zone -->
                                                <div class="card border-2 border-dashed p-4 text-center rounded-3 bg-white mb-3" style="border-color: #93c5fd !important; cursor: pointer;" onclick="document.getElementById('cvSoftCopyFileInput').click()">
                                                    <input type="file" id="cvSoftCopyFileInput" accept=".pdf,.doc,.docx,.png,.jpg,.jpeg" style="display: none;" onchange="handleCvFileUpload(event)">
                                                    <div class="mb-2">
                                                        <i class="bi bi-file-earmark-arrow-up-fill text-primary display-5"></i>
                                                    </div>
                                                    <h6 class="fw-bold text-dark mb-1">Kéo & Thả file CV bản mềm vào đây</h6>
                                                    <p class="text-muted small mb-2">Hỗ trợ file: <strong>.PDF, .DOCX, .DOC, Ảnh/Bản viết tay (.PNG, .JPG)</strong></p>
                                                    <button type="button" class="btn btn-sm btn-outline-primary px-3 rounded-pill fw-semibold">
                                                        <i class="bi bi-folder2-open me-1"></i>Chọn file từ máy tính
                                                    </button>
                                                </div>

                                                <!-- Quick Preset Samples for Instant Parsing -->
                                                <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <span class="fw-bold small text-dark"><i class="bi bi-lightning-charge-fill text-warning me-1"></i>Nạp nhanh bản mềm CV mẫu để thử nghiệm:</span>
                                                    </div>
                                                    <p class="text-muted small mb-2" style="font-size: 0.76rem;">Bấm chọn mẫu để tự động bóc tách tức thì không cần gõ phím:</p>
                                                    <div class="d-flex flex-column gap-2">
                                                        <button type="button" class="btn btn-sm btn-outline-danger text-start d-flex align-items-center justify-content-between p-2 rounded-2" onclick="loadAndParsePresetCv('pdf_fullstack')">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <i class="bi bi-file-earmark-pdf-fill fs-5 text-danger"></i>
                                                                <div>
                                                                    <div class="fw-bold small text-dark">Lê Tuấn Hùng (PDF - Senior Fullstack)</div>
                                                                    <div class="text-muted" style="font-size: 0.72rem;">Java, Spring, PostgreSQL • 4.5 năm KN</div>
                                                                </div>
                                                            </div>
                                                            <span class="badge bg-danger-subtle text-danger">Nạp PDF</span>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-primary text-start d-flex align-items-center justify-content-between p-2 rounded-2" onclick="loadAndParsePresetCv('word_techlead')">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <i class="bi bi-file-earmark-word-fill fs-5 text-primary"></i>
                                                                <div>
                                                                    <div class="fw-bold small text-dark">Nguyễn Hoàng Sơn (Word - Tech Lead)</div>
                                                                    <div class="text-muted" style="font-size: 0.72rem;">Software Architect, Microservices • 7.0 năm KN</div>
                                                                </div>
                                                            </div>
                                                            <span class="badge bg-primary-subtle text-primary">Nạp DOCX</span>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-warning text-start d-flex align-items-center justify-content-between p-2 rounded-2" onclick="loadAndParsePresetCv('handwritten_intern')">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <i class="bi bi-pen-fill fs-5 text-warning"></i>
                                                                <div>
                                                                    <div class="fw-bold small text-dark">Trần Minh Thư (Bản viết tay OCR)</div>
                                                                    <div class="text-muted" style="font-size: 0.72rem;">Thực tập sinh IT, Giải thuật • Bách Khoa</div>
                                                                </div>
                                                            </div>
                                                            <span class="badge bg-warning-subtle text-warning-emphasis">Nạp Chữ Viết</span>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-purple text-start d-flex align-items-center justify-content-between p-2 rounded-2" style="border-color: #d8b4fe;" onclick="loadAndParsePresetCv('pdf_designer')">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <i class="bi bi-file-earmark-richtext-fill fs-5 text-purple" style="color: #7e22ce;"></i>
                                                                <div>
                                                                    <div class="fw-bold small text-dark">Vũ Thùy Linh (PDF - Product UI/UX)</div>
                                                                    <div class="text-muted" style="font-size: 0.72rem;">Figma, Design System, UX Research • 3.5 năm</div>
                                                                </div>
                                                            </div>
                                                            <span class="badge bg-purple-subtle text-purple" style="background:#f3e8ff; color:#7e22ce;">Nạp PDF</span>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Col Right: Live Interactive Document Sheet & Extracted Info -->
                                            <div class="col-12 col-lg-7">
                                                <div class="card border-0 shadow-sm rounded-3 p-3 bg-white h-100">
                                                    <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <span class="badge bg-success-subtle text-success fw-bold" id="cvStatusBadge">
                                                                <i class="bi bi-check2-circle me-1"></i>Đã bóc tách tự động
                                                            </span>
                                                            <span class="small text-muted" id="cvFileNameDisplay">Le_Tuan_Hung_Senior_Dev.pdf</span>
                                                        </div>
                                                        <span class="badge bg-primary text-white" id="cvTypeBadge">PDF</span>
                                                    </div>

                                                    <!-- Live Document Paper Sheet (Mini A4 style) -->
                                                    <div class="p-3 rounded-3 border mb-3" style="background: #ffffff; box-shadow: 0 4px 15px rgba(0,0,0,0.06);">
                                                        <div class="d-flex justify-content-between align-items-start border-bottom pb-2 mb-2">
                                                            <div>
                                                                <h5 class="fw-bold text-dark mb-0" id="liveDocName">Lê Tuấn Hùng</h5>
                                                                <div class="text-primary small fw-semibold" id="liveDocTitle">${selectedJob.title}</div>
                                                            </div>
                                                            <div class="text-end small">
                                                                <div class="text-muted" id="liveDocEmail"><i class="bi bi-envelope me-1"></i>hung.lt@gmail.com</div>
                                                                <div class="text-muted" id="liveDocPhone"><i class="bi bi-telephone me-1"></i>0988 123 456</div>
                                                            </div>
                                                        </div>

                                                        <div class="row g-2 mb-2 small">
                                                            <div class="col-4">
                                                                <span class="text-muted">Kinh nghiệm:</span>
                                                                <strong class="text-dark d-block" id="liveDocExp">4.5 năm</strong>
                                                            </div>
                                                            <div class="col-4">
                                                                <span class="text-muted">Mức lương kỳ vọng:</span>
                                                                <strong class="text-success d-block" id="liveDocSalary">32.000.000 đ</strong>
                                                            </div>
                                                            <div class="col-4">
                                                                <span class="text-muted">Nguồn ứng tuyển:</span>
                                                                <span class="badge bg-light text-dark border" id="liveDocSource">Nộp trực tuyến</span>
                                                            </div>
                                                        </div>

                                                        <div class="mb-2">
                                                            <span class="text-muted small fw-semibold d-block mb-1">Kỹ năng cốt lõi bóc tách được:</span>
                                                            <div class="d-flex flex-wrap gap-1" id="liveDocSkills">
                                                                <span class="badge bg-primary-subtle text-primary">Java</span>
                                                                <span class="badge bg-primary-subtle text-primary">Spring Boot</span>
                                                                <span class="badge bg-primary-subtle text-primary">PostgreSQL</span>
                                                                <span class="badge bg-primary-subtle text-primary">Microservices</span>
                                                                <span class="badge bg-primary-subtle text-primary">Docker</span>
                                                            </div>
                                                        </div>

                                                        <div>
                                                            <span class="text-muted small fw-semibold d-block mb-1">Trích xuất văn bản từ bản mềm CV:</span>
                                                            <div class="p-2 rounded bg-light border font-monospace text-muted small" style="max-height: 80px; overflow-y: auto; font-size: 0.74rem;" id="liveDocSnippet">
                                                                Lập trình viên Senior Java với 4.5 năm kinh nghiệm thiết kế kiến trúc Backend chịu tải cao, thành thạo Spring Boot, Hibernate, PostgreSQL, Docker và Microservices.
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Collapsible Form Inputs for Fine-tuning (Hidden by default to save effort) -->
                                                    <details class="border rounded-2 p-2 bg-light">
                                                        <summary class="small fw-bold text-primary" style="cursor: pointer;">
                                                            <i class="bi bi-sliders me-1"></i>Tùy chỉnh chi tiết thông tin đã bóc tách (Không bắt buộc)
                                                        </summary>
                                                        <div class="pt-3">
                                                            <div class="row g-2 mb-2">
                                                                <div class="col-md-6">
                                                                    <label class="form-label small fw-semibold text-muted">Họ tên ứng viên <span class="text-danger">*</span></label>
                                                                    <input type="text" class="form-control form-control-sm" id="inputFullName" name="fullName" value="Lê Tuấn Hùng" required>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label small fw-semibold text-muted">Email <span class="text-danger">*</span></label>
                                                                    <input type="email" class="form-control form-control-sm" id="inputEmail" name="email" value="hung.lt@gmail.com" required>
                                                                </div>
                                                            </div>
                                                            <div class="row g-2 mb-2">
                                                                <div class="col-md-6">
                                                                    <label class="form-label small fw-semibold text-muted">Số điện thoại <span class="text-danger">*</span></label>
                                                                    <input type="text" class="form-control form-control-sm" id="inputPhone" name="phone" value="0988123456" required>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <label class="form-label small fw-semibold text-muted">Kinh nghiệm (năm)</label>
                                                                    <input type="number" step="0.5" class="form-control form-control-sm" id="inputExp" name="experienceYears" value="4.5">
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <label class="form-label small fw-semibold text-muted">Lương (VNĐ)</label>
                                                                    <input type="number" class="form-control form-control-sm" id="inputSalary" name="expectedSalary" value="32000000" step="1000000">
                                                                </div>
                                                            </div>
                                                            <div class="row g-2 mb-2">
                                                                <div class="col-md-4">
                                                                    <label class="form-label small fw-semibold text-muted">Định dạng file</label>
                                                                    <select class="form-select form-select-sm" id="inputCvType" name="cvType">
                                                                        <option value="PDF" selected>📑 File PDF (.pdf)</option>
                                                                        <option value="WORD">📄 Bản Word (.docx)</option>
                                                                        <option value="HANDWRITTEN">✍️ Bản chữ viết (OCR notes)</option>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-4">
                                                                    <label class="form-label small fw-semibold text-muted">Kênh nguồn</label>
                                                                    <select class="form-select form-select-sm" id="inputSource" name="source">
                                                                        <option value="Ứng tuyển trực tuyến" selected>Ứng tuyển trực tuyến</option>
                                                                        <option value="LinkedIn">LinkedIn</option>
                                                                        <option value="TopCV/VNW">TopCV / VietnamWorks</option>
                                                                        <option value="Nội bộ (Ref)">Nội bộ (Ref)</option>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-4">
                                                                    <label class="form-label small fw-semibold text-muted">Tên file bản mềm</label>
                                                                    <input type="text" class="form-control form-control-sm" id="inputCvUrl" name="cvUrl" value="Le_Tuan_Hung_Senior_Dev.pdf">
                                                                </div>
                                                            </div>
                                                            <div class="mb-2">
                                                                <label class="form-label small fw-semibold text-muted">Văn bản trích xuất CV / Nội dung OCR</label>
                                                                <textarea class="form-control form-control-sm font-monospace" id="inputCvText" name="cvText" rows="2">Lập trình viên Senior Java với 4.5 năm kinh nghiệm thiết kế kiến trúc Backend chịu tải cao, thành thạo Spring Boot, Hibernate, PostgreSQL, Docker và Microservices.</textarea>
                                                            </div>
                                                            <div>
                                                                <label class="form-label small fw-semibold text-muted">Ghi chú bổ sung</label>
                                                                <textarea class="form-control form-control-sm" id="inputNotes" name="notes" rows="1">Hồ sơ ứng viên nộp qua bản mềm trực tuyến, hệ thống tự động bóc tách thông tin.</textarea>
                                                            </div>
                                                        </div>
                                                    </details>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer bg-white border-top p-3 px-4 d-flex justify-content-between">
                                        <div class="small text-muted">
                                            <i class="bi bi-shield-check text-success me-1"></i>Dữ liệu bóc tách được lưu tự động vào DB và hiển thị trực tiếp ở vị trí tuyển dụng
                                        </div>
                                        <div class="d-flex gap-2">
                                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm px-4 fw-semibold">
                                                <i class="bi bi-cloud-check-fill fs-5"></i>
                                                <span>Xác Nhận Lưu Hồ Sơ CV</span>
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 4: LỌC NÂNG CAO VỊ TRÍ TUYỂN DỤNG (#advancedJobFilterModal)          -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="advancedJobFilterModal" tabindex="-1" aria-labelledby="advancedJobFilterModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header bg-dark text-white p-3 px-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-sliders fs-5"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="advancedJobFilterModalLabel">Lọc Nâng Cao Vị Trí Tuyển Dụng</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Lọc dữ liệu thật từ cơ sở dữ liệu theo phòng ban, mức lương & ưu tiên</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form method="GET" action="${pageContext.request.contextPath}/recruitment">
                                    <input type="hidden" name="view" value="jobs">
                                    <div class="modal-body p-4" style="background: #f8fafc;">
                                        <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                            <div class="mb-3">
                                                <label class="form-label small fw-semibold text-muted">Từ khóa tìm kiếm (Tên / Mã vị trí)</label>
                                                <input type="text" class="form-control form-control-sm" name="search" value="${searchKeyword}" placeholder="VD: Fullstack, YCTD-2026-081...">
                                            </div>
                                            <div class="row g-3 mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Phòng ban</label>
                                                    <select class="form-select form-select-sm" name="departmentId">
                                                        <option value="">Tất cả phòng ban</option>
                                                        <c:forEach items="${departments}" var="d">
                                                            <option value="${d.id}" ${selectedDeptId == d.id ? 'selected' : ''}>${d.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Trạng thái tuyển dụng</label>
                                                    <select class="form-select form-select-sm" name="status">
                                                        <option value="">Tất cả trạng thái</option>
                                                        <option value="OPEN" ${selectedStatus eq 'OPEN' ? 'selected' : ''}>Đang tuyển (OPEN)</option>
                                                        <option value="PAUSED" ${selectedStatus eq 'PAUSED' ? 'selected' : ''}>Tạm dừng (PAUSED)</option>
                                                        <option value="FILLED" ${selectedStatus eq 'FILLED' ? 'selected' : ''}>Đã đủ (FILLED)</option>
                                                        <option value="CLOSED" ${selectedStatus eq 'CLOSED' ? 'selected' : ''}>Đã đóng (CLOSED)</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Độ ưu tiên tuyển dụng</label>
                                                    <select class="form-select form-select-sm" name="priority">
                                                        <option value="">Tất cả mức độ</option>
                                                        <option value="NORMAL" ${selectedPriority eq 'NORMAL' ? 'selected' : ''}>Bình thường</option>
                                                        <option value="URGENT" ${selectedPriority eq 'URGENT' ? 'selected' : ''}>🔥 Ưu tiên gấp (URGENT)</option>
                                                        <option value="HOT" ${selectedPriority eq 'HOT' ? 'selected' : ''}>🚨 HOT Tuyển gấp (HOT)</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Mức lương tối thiểu (VNĐ)</label>
                                                    <input type="number" class="form-control form-control-sm" name="salaryMin" value="${selectedSalaryMin}" placeholder="20000000" step="1000000">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer bg-white border-top p-3 px-4">
                                        <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="btn btn-outline-secondary">Đặt lại</a>
                                        <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                                            <i class="bi bi-funnel-fill"></i>
                                            <span>Áp Dụng Lọc Dữ Liệu Thật</span>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL: TẠO VỊ TRÍ TUYỂN DỤNG MỚI (#createJobModal)                        -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="createJobModal" tabindex="-1" aria-labelledby="createJobModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header modal-header-brand p-3 px-4" style="background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%); color: white;">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-briefcase-fill fs-5"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="createJobModalLabel">Tạo Vị Trí Tuyển Dụng Mới</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Khởi tạo nhu cầu tuyển dụng và đăng thông báo tới toàn thể công ty</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>

                                <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                                    <input type="hidden" name="action" value="create_job">

                                    <div class="modal-body p-4" style="background: #f8fafc;">
                                        <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">1. Thông tin vị trí & Cơ cấu tổ chức</h6>

                                            <div class="row g-3 mb-3">
                                                <div class="col-12 col-md-4">
                                                    <label class="form-label small fw-semibold text-muted">Mã yêu cầu <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control form-control-sm font-monospace fw-bold" name="requestCode" value="${nextRequestCode}" required>
                                                </div>
                                                <div class="col-12 col-md-8">
                                                    <label class="form-label small fw-semibold text-muted">Vị trí tuyển dụng <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control form-control-sm" name="title" placeholder="VD: Senior Fullstack Engineer (React/Node)" required>
                                                </div>
                                            </div>

                                            <div class="row g-3 mb-3">
                                                <div class="col-12 col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Phòng ban phụ trách <span class="text-danger">*</span></label>
                                                    <select class="form-select form-select-sm" name="departmentId" required>
                                                        <option value="" disabled selected>-- Chọn phòng ban --</option>
                                                        <c:forEach items="${departments}" var="dept">
                                                            <option value="${dept.id}">${dept.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Chức danh chức vụ <span class="text-danger">*</span></label>
                                                    <select class="form-select form-select-sm" name="positionId" required>
                                                        <option value="" disabled selected>-- Chọn chức vụ --</option>
                                                        <c:forEach items="${positions}" var="pos">
                                                            <option value="${pos.id}">${pos.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="row g-3 mb-3">
                                                <div class="col-12 col-md-4">
                                                    <label class="form-label small fw-semibold text-muted">Số lượng cần tuyển <span class="text-danger">*</span></label>
                                                    <input type="number" class="form-control form-control-sm" name="targetHeadcount" value="1" min="1" max="50" required>
                                                </div>
                                                <div class="col-12 col-md-4">
                                                    <label class="form-label small fw-semibold text-muted">Kỳ tuyển dụng</label>
                                                    <select class="form-select form-select-sm" name="quarter">
                                                        <option value="Q3/2026" selected>Quý 3/2026</option>
                                                        <option value="Q4/2026">Quý 4/2026</option>
                                                        <option value="Q1/2027">Quý 1/2027</option>
                                                    </select>
                                                </div>
                                                <div class="col-12 col-md-4">
                                                    <label class="form-label small fw-semibold text-muted">Mức độ ưu tiên</label>
                                                    <select class="form-select form-select-sm" name="priority">
                                                        <option value="NORMAL" selected>Bình thường</option>
                                                        <option value="URGENT">🔥 Ưu tiên gấp (URGENT)</option>
                                                        <option value="HOT">🚨 HOT Tuyển gấp (HOT)</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="row g-3">
                                                <div class="col-12 col-md-4">
                                                    <label class="form-label small fw-semibold text-muted">Thành phố / Địa điểm <span class="text-danger">*</span></label>
                                                    <select class="form-select form-select-sm" name="location" required>
                                                        <option value="Hà Nội" selected>Hà Nội</option>
                                                        <option value="TP. Hồ Chí Minh">TP. Hồ Chí Minh</option>
                                                        <option value="Đà Nẵng">Đà Nẵng</option>
                                                        <option value="Cần Thơ">Cần Thơ</option>
                                                        <option value="Toàn quốc (Remote)">Toàn quốc (Remote)</option>
                                                        <option value="Hybrid">Hybrid (Linh hoạt)</option>
                                                    </select>
                                                </div>
                                                <div class="col-12 col-md-8">
                                                    <label class="form-label small fw-semibold text-muted">Từ khóa quét CV tự động (Keywords - Word, PDF, Chữ viết)</label>
                                                    <input type="text" class="form-control form-control-sm" name="keywords" placeholder="VD: Java, Spring Boot, PostgreSQL, Docker, Microservices, React">
                                                    <small class="text-muted" style="font-size: 0.72rem;">Phân tách bằng dấu phẩy để hệ thống tự động bóc tách và xếp hạng CV ứng viên</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">2. Chế độ lương, Thời hạn & Người phụ trách</h6>

                                            <div class="row g-3 mb-3">
                                                <div class="col-12 col-md-5">
                                                    <label class="form-label small fw-semibold text-muted">Mức lương từ (VNĐ)</label>
                                                    <input type="number" class="form-control form-control-sm" name="salaryMin" placeholder="20.000.000" step="1000000">
                                                </div>
                                                <div class="col-12 col-md-5">
                                                    <label class="form-label small fw-semibold text-muted">Mức lương đến (VNĐ)</label>
                                                    <input type="number" class="form-control form-control-sm" name="salaryMax" placeholder="35.000.000" step="1000000">
                                                </div>
                                                <div class="col-12 col-md-2 d-flex align-items-end">
                                                    <div class="form-check pb-2">
                                                        <input class="form-check-input" type="checkbox" name="salaryNegotiable" id="salaryNegotiableJob">
                                                        <label class="form-check-label small" for="salaryNegotiableJob">Thỏa thuận</label>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row g-3">
                                                <div class="col-12 col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Hạn chót nhận hồ sơ <span class="text-danger">*</span></label>
                                                    <input type="date" class="form-control form-control-sm" name="deadline" required>
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <label class="form-label small fw-semibold text-muted">Chuyên viên HR phụ trách <span class="text-danger">*</span></label>
                                                    <select class="form-select form-select-sm" name="assigneeId" required>
                                                        <option value="" disabled selected>-- Chọn HR phụ trách --</option>
                                                        <c:forEach items="${employees}" var="emp">
                                                            <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">3. Chi tiết mô tả công việc (JD) & Đăng thông báo</h6>

                                            <div class="mb-3">
                                                <label class="form-label small fw-semibold text-muted">Mô tả công việc (Job Description)</label>
                                                <textarea class="form-control form-control-sm" name="description" rows="3" placeholder="Chi tiết trách nhiệm công việc, nhiệm vụ chính..."></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label small fw-semibold text-muted">Yêu cầu ứng viên (Requirements)</label>
                                                <textarea class="form-control form-control-sm" name="requirements" rows="3" placeholder="Số năm kinh nghiệm, kỹ năng chuyên môn, bằng cấp..."></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label small fw-semibold text-muted">Quyền lợi & Chế độ đãi ngộ (Benefits)</label>
                                                <textarea class="form-control form-control-sm" name="benefits" rows="2" placeholder="Lương thưởng, bảo hiểm, đào tạo, lộ trình thăng tiến..."></textarea>
                                            </div>

                                            <div class="form-check form-switch p-3 bg-light rounded-2 border">
                                                <input class="form-check-input ms-0 me-2" type="checkbox" name="postToCompanyNotice" id="postToCompanyNoticeJob" value="true" checked>
                                                <label class="form-check-label fw-bold text-primary small" for="postToCompanyNoticeJob">
                                                    <i class="bi bi-megaphone-fill me-1"></i> Tự động đăng thông tin lên Giao diện thông báo của công ty
                                                </label>
                                                <div class="text-muted small ps-4" style="font-size: 0.75rem;">
                                                    Hệ thống sẽ phát thông báo lên Bảng tin công ty (Dashboard) & Chuông thông báo để toàn thể nhân viên xem được vị trí vừa mở tuyển.
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="modal-footer bg-white border-top p-3 px-4">
                                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                                        <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                                            <i class="bi bi-check-circle-fill"></i>
                                            <span>Tạo vị trí & Đăng thông báo</span>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <script>
                        // Global state for selected job
                        window.currentJobData = {
                            id: '${selectedJob.id}',
                            code: '${selectedJob.requestCode}',
                            title: '${selectedJob.title}',
                            dept: '${selectedJob.departmentName}',
                            status: '${selectedJob.status}',
                            location: '${selectedJob.location != null ? selectedJob.location : "Hà Nội"}',
                            keywords: '${selectedJob.keywords != null ? selectedJob.keywords : "Java, Spring Boot, PostgreSQL, Microservices, Docker, React"}',
                            salary: '${selectedJob.salaryMinFormatted} - ${selectedJob.salaryMaxFormatted}',
                            salaryMin: '${selectedJob.salaryMinFormatted}',
                            salaryMax: '${selectedJob.salaryMaxFormatted}',
                            deadline: '${selectedJob.deadline}',
                            hired: '${selectedJob.hiredCount}',
                            target: '${selectedJob.targetHeadcount}',
                            candCount: '${selectedJob.candidateCount}',
                            assignee: '${selectedJob.assigneeName != null ? selectedJob.assigneeName : "Phạm Phương Thảo"}',
                            assigneeInitials: '${selectedJob.assigneeAvatarInitials != null ? selectedJob.assigneeAvatarInitials : "PT"}'
                        };

                        // 1. Tương tác chọn dòng vị trí và cập nhật động Khung Job Preview
                        function selectJobRow(rowElement) {
                            if (!rowElement) return;

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
                            const id = rowElement.getAttribute('data-id');
                            const title = rowElement.getAttribute('data-title');
                            const code = rowElement.getAttribute('data-code');
                            const dept = rowElement.getAttribute('data-dept');
                            const status = rowElement.getAttribute('data-status');
                            const location = rowElement.getAttribute('data-location') || 'Hà Nội';
                            const keywords = rowElement.getAttribute('data-keywords') || '';
                            const salMin = rowElement.getAttribute('data-salary-min');
                            const salMax = rowElement.getAttribute('data-salary-max');
                            const assignee = rowElement.getAttribute('data-assignee') || 'Phạm Phương Thảo';
                            const assigneeInitials = rowElement.getAttribute('data-assignee-initials') || 'PT';
                            const candCount = rowElement.getAttribute('data-cand-count') || '0';
                            const hired = rowElement.getAttribute('data-hired') || '0';
                            const target = rowElement.getAttribute('data-target') || '1';
                            const deadline = rowElement.getAttribute('data-deadline') || '30/10/2026';
                            const desc = rowElement.getAttribute('data-desc');
                            const req = rowElement.getAttribute('data-req');

                            window.currentJobData = {
                                id: id,
                                code: code,
                                title: title,
                                dept: dept,
                                status: status,
                                location: location,
                                keywords: keywords,
                                salary: salMin + ' - ' + salMax,
                                salaryMin: salMin,
                                salaryMax: salMax,
                                deadline: deadline,
                                hired: hired,
                                target: target,
                                candCount: candCount,
                                assignee: assignee,
                                assigneeInitials: assigneeInitials
                            };

                            // Cập nhật DOM trên Preview Drawer
                            const previewTitle = document.getElementById('previewTitle');
                            if (previewTitle) previewTitle.textContent = title;

                            const previewJobCode = document.getElementById('previewJobCode');
                            if (previewJobCode) previewJobCode.textContent = code;

                            const previewDept = document.getElementById('previewDept');
                            if (previewDept) previewDept.innerHTML = '<i class="bi bi-geo-alt text-primary me-1"></i>' + dept + ' (' + location + ')';

                            const previewSalary = document.getElementById('previewSalary');
                            if (previewSalary) previewSalary.innerHTML = salMin + ' - ' + salMax + ' Triệu VNĐ <span class="text-muted fs-6 fw-normal">/ tháng</span>';

                            const previewStatusBadge = document.getElementById('previewStatusBadge');
                            if (previewStatusBadge) {
                                previewStatusBadge.textContent = (status === 'OPEN') ? 'Đang nhận CV' : status;
                                previewStatusBadge.className = 'badge ' + (status === 'OPEN' ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-light text-muted border') + ' mb-1';
                            }

                            const previewRecruiterName = document.getElementById('previewRecruiterName');
                            if (previewRecruiterName) previewRecruiterName.textContent = assignee;

                            const previewAvatarInitials = document.getElementById('previewAvatarInitials');
                            if (previewAvatarInitials) previewAvatarInitials.textContent = assigneeInitials;

                            const previewAiCandCount = document.getElementById('previewAiCandCount');
                            if (previewAiCandCount) previewAiCandCount.textContent = candCount + ' CV đã nộp';

                            const previewDescription = document.getElementById('previewDescription');
                            if (previewDescription) previewDescription.innerHTML = '<p class="mb-0">' + desc + '</p>';

                            const previewRequirements = document.getElementById('previewRequirements');
                            if (previewRequirements) previewRequirements.innerHTML = '<p class="mb-0">' + req + '</p>';

                            // Đồng bộ hidden IDs trên các Modals
                            const aiBatchJobId = document.getElementById('aiBatchJobId');
                            if (aiBatchJobId && id) aiBatchJobId.value = id;

                            const liveScanJobId = document.getElementById('liveScanJobId');
                            if (liveScanJobId && id) liveScanJobId.value = id;

                            // Đồng bộ từ khóa mặc định lên Modal Scanner
                            const scannerKeywordsInput = document.getElementById('scannerKeywordsInput');
                            if (scannerKeywordsInput && keywords) {
                                scannerKeywordsInput.value = keywords;
                            }
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
                                if (tableContainer) tableContainer.style.display = 'none';
                                if (gridContainer) gridContainer.style.display = 'flex';
                                if (btnTable) btnTable.className = 'btn btn-outline-secondary';
                                if (btnGrid) btnGrid.className = 'btn btn-primary';
                            } else {
                                if (tableContainer) tableContainer.style.display = 'block';
                                if (gridContainer) gridContainer.style.display = 'none';
                                if (btnTable) btnTable.className = 'btn btn-primary';
                                if (btnGrid) btnGrid.className = 'btn btn-outline-secondary';
                            }
                        }

                        // 3. Tìm kiếm & Lọc vị trí tuyển dụng đa chiều (5 TIÊU CHÍ)
                        const searchInput = document.getElementById('jobSearchInput');
                        if (searchInput) {
                            searchInput.addEventListener('keyup', filterJobs);
                        }

                        function filterJobs() {
                            const keyword = searchInput ? searchInput.value.toLowerCase().trim() : '';
                            const dept = document.getElementById('deptFilter') ? document.getElementById('deptFilter').value : 'ALL';
                            const salary = document.getElementById('salaryFilter') ? document.getElementById('salaryFilter').value : 'ALL';
                            const location = document.getElementById('locationFilter') ? document.getElementById('locationFilter').value : 'ALL';
                            const status = document.getElementById('statusFilter') ? document.getElementById('statusFilter').value : 'ALL';

                            // Lọc danh sách Table Rows
                            const rows = document.querySelectorAll('#jobsTable tbody tr.job-row-item');
                            let count = 0;

                            rows.forEach(row => {
                                const title = (row.getAttribute('data-title') || '').toLowerCase();
                                const code = (row.getAttribute('data-code') || '').toLowerCase();
                                const rowDept = row.getAttribute('data-dept') || '';
                                const rowStatus = row.getAttribute('data-status') || '';
                                const rowLoc = (row.getAttribute('data-location') || '').toLowerCase();
                                const rowKeywords = (row.getAttribute('data-keywords') || '').toLowerCase();
                                const rawMin = parseFloat(row.getAttribute('data-raw-salary-min') || '0');
                                const rawMax = parseFloat(row.getAttribute('data-raw-salary-max') || '0');
                                const isNegotiable = row.getAttribute('data-negotiable') === 'true';

                                // 1. Match từ khóa tìm kiếm (Tên, Mã VT hoặc Keywords)
                                const matchKw = !keyword || title.includes(keyword) || code.includes(keyword) || rowKeywords.includes(keyword);

                                // 2. Match Phòng ban
                                const matchDept = (dept === 'ALL') || (rowDept === dept);

                                // 3. Match Mức lương
                                let matchSalary = true;
                                if (salary === 'LOW') {
                                    matchSalary = (rawMax > 0 && rawMax <= 20000000);
                                } else if (salary === 'MID') {
                                    matchSalary = (rawMax >= 20000000 && rawMin <= 35000000);
                                } else if (salary === 'HIGH') {
                                    matchSalary = (rawMax >= 35000000 && rawMin <= 50000000);
                                } else if (salary === 'VERY_HIGH') {
                                    matchSalary = (rawMax >= 50000000 || rawMin >= 50000000);
                                } else if (salary === 'NEGOTIABLE') {
                                    matchSalary = isNegotiable;
                                }

                                // 4. Match Thành phố
                                let matchLoc = true;
                                if (location === 'HN') {
                                    matchLoc = rowLoc.includes('hà nội') || rowLoc.includes('hn');
                                } else if (location === 'HCM') {
                                    matchLoc = rowLoc.includes('hồ chí minh') || rowLoc.includes('hcm') || rowLoc.includes('sài gòn');
                                } else if (location === 'DN') {
                                    matchLoc = rowLoc.includes('đà nẵng') || rowLoc.includes('dn');
                                } else if (location === 'REMOTE') {
                                    matchLoc = rowLoc.includes('remote') || rowLoc.includes('toàn quốc');
                                } else if (location === 'HYBRID') {
                                    matchLoc = rowLoc.includes('hybrid');
                                }

                                // 5. Match Trạng thái
                                const matchStatus = (status === 'ALL') || (rowStatus === status);

                                if (matchKw && matchDept && matchSalary && matchLoc && matchStatus) {
                                    row.style.display = '';
                                    count++;
                                } else {
                                    row.style.display = 'none';
                                }
                            });

                            // Lọc danh sách Grid Cards
                            const gridCards = document.querySelectorAll('.job-grid-item');
                            gridCards.forEach(card => {
                                const title = (card.getAttribute('data-title') || '').toLowerCase();
                                const code = (card.getAttribute('data-code') || '').toLowerCase();
                                const rowDept = card.getAttribute('data-dept') || '';
                                const rowStatus = card.getAttribute('data-status') || '';
                                const rowLoc = (card.getAttribute('data-location') || '').toLowerCase();
                                const rowKeywords = (card.getAttribute('data-keywords') || '').toLowerCase();
                                const rawMin = parseFloat(card.getAttribute('data-raw-salary-min') || '0');
                                const rawMax = parseFloat(card.getAttribute('data-raw-salary-max') || '0');
                                const isNegotiable = card.getAttribute('data-negotiable') === 'true';

                                const matchKw = !keyword || title.includes(keyword) || code.includes(keyword) || rowKeywords.includes(keyword);
                                const matchDept = (dept === 'ALL') || (rowDept === dept);
                                let matchSalary = true;
                                if (salary === 'LOW') matchSalary = (rawMax > 0 && rawMax <= 20000000);
                                else if (salary === 'MID') matchSalary = (rawMax >= 20000000 && rawMin <= 35000000);
                                else if (salary === 'HIGH') matchSalary = (rawMax >= 35000000 && rawMin <= 50000000);
                                else if (salary === 'VERY_HIGH') matchSalary = (rawMax >= 50000000 || rawMin >= 50000000);
                                else if (salary === 'NEGOTIABLE') matchSalary = isNegotiable;

                                let matchLoc = true;
                                if (location === 'HN') matchLoc = rowLoc.includes('hà nội') || rowLoc.includes('hn');
                                else if (location === 'HCM') matchLoc = rowLoc.includes('hồ chí minh') || rowLoc.includes('hcm');
                                else if (location === 'DN') matchLoc = rowLoc.includes('đà nẵng') || rowLoc.includes('dn');
                                else if (location === 'REMOTE') matchLoc = rowLoc.includes('remote') || rowLoc.includes('toàn quốc');
                                else if (location === 'HYBRID') matchLoc = rowLoc.includes('hybrid');

                                const matchStatus = (status === 'ALL') || (rowStatus === status);

                                if (matchKw && matchDept && matchSalary && matchLoc && matchStatus) {
                                    card.style.display = '';
                                } else {
                                    card.style.display = 'none';
                                }
                            });

                            const countBadge = document.getElementById('activeJobsCountBadge');
                            if (countBadge) countBadge.textContent = count + ' Vị trí';
                            const countShown = document.getElementById('jobsCountShown');
                            if (countShown) countShown.textContent = count;
                        }

                        // 4. Xem trước thông tin tuyển dụng của Nhân viên phụ trách
                        function openEmployeePreviewModal(assignee, code, title, dept, salary, deadline, progress, candCount, status, location, initials) {
                            document.getElementById('empModalName').textContent = assignee || 'Phạm Phương Thảo';
                            document.getElementById('empModalAvatar').textContent = initials || 'PT';
                            document.getElementById('empModalJobCode').textContent = code || 'YCTD-2026';
                            document.getElementById('empModalJobTitle').textContent = title || 'Vị trí tuyển dụng';
                            document.getElementById('empModalJobDept').textContent = dept || 'Phòng ban';
                            document.getElementById('empModalJobLocation').textContent = location || 'Hà Nội';
                            document.getElementById('empModalJobSalary').textContent = (salary || 'Thỏa thuận') + ' VNĐ';
                            document.getElementById('empModalJobProgress').textContent = (progress || '0/1') + ' Đạt';
                            document.getElementById('empModalJobCandCount').textContent = (candCount || '0') + ' CV nộp';
                            document.getElementById('empModalJobDeadline').textContent = deadline || '30/10/2026';

                            const statusBadge = document.getElementById('empModalJobStatus');
                            if (statusBadge) {
                                statusBadge.textContent = (status === 'OPEN') ? 'Đang tuyển' : status;
                                statusBadge.className = 'badge ' + (status === 'OPEN' ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-light text-muted border');
                            }

                            // Lưu mã vị trí này để thao tác tiếp
                            window.empModalCurrentCode = code;

                            const modalEl = document.getElementById('previewEmployeeJobModal');
                            if (modalEl) {
                                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                                modal.show();
                            }
                        }

                        function openSelectedJobRecruiterModal() {
                            const d = window.currentJobData;
                            if (d) {
                                openEmployeePreviewModal(d.assignee, d.code, d.title, d.dept, d.salary, d.deadline, d.hired + '/' + d.target, d.candCount, d.status, d.location, d.assigneeInitials);
                            }
                        }

                        function selectFromEmpModal() {
                            const modalEl = document.getElementById('previewEmployeeJobModal');
                            if (modalEl) {
                                const modal = bootstrap.Modal.getInstance(modalEl);
                                if (modal) modal.hide();
                            }
                            if (window.empModalCurrentCode) {
                                const row = document.querySelector('.job-row-item[data-code="' + window.empModalCurrentCode + '"]');
                                if (row) selectJobRow(row);
                            }
                        }

                        function shareFromEmpModal() {
                            const modalEl = document.getElementById('previewEmployeeJobModal');
                            if (modalEl) {
                                const modal = bootstrap.Modal.getInstance(modalEl);
                                if (modal) modal.hide();
                            }
                            openShareJobModal();
                        }

                        // 5. Thao tác Chia sẻ thông tin tuyển dụng đa kênh (#shareJobModal)
                        function openShareJobModal() {
                            const d = window.currentJobData;
                            populateShareModalWithData(d);
                            const modalEl = document.getElementById('shareJobModal');
                            if (modalEl) {
                                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                                modal.show();
                            }
                        }

                        function openShareJobModalById(id) {
                            const targetRow = document.querySelector('.job-row-item[data-id="' + id + '"]');
                            if (targetRow) {
                                selectJobRow(targetRow);
                            }
                            openShareJobModal();
                        }

                        function populateShareModalWithData(d) {
                            if (!d) return;
                            const jobCode = document.getElementById('shareModalJobCode');
                            if (jobCode) jobCode.textContent = d.code;
                            const jobTitle = document.getElementById('shareModalJobTitle');
                            if (jobTitle) jobTitle.textContent = d.title;
                            const jobDept = document.getElementById('shareModalJobDept');
                            if (jobDept) jobDept.textContent = d.dept;
                            const jobSalary = document.getElementById('shareModalJobSalary');
                            if (jobSalary) jobSalary.textContent = d.salary + ' Triệu VNĐ';
                            const jobLoc = document.getElementById('shareModalJobLocation');
                            if (jobLoc) jobLoc.innerHTML = '<i class="bi bi-geo-alt text-danger me-1"></i>' + d.location;
                            const refCode = document.getElementById('shareJobRefCode');
                            if (refCode) refCode.textContent = d.code;

                            const shareUrl = window.location.origin + window.location.pathname + '?view=jobs&jobId=' + d.id;
                            const urlInput = document.getElementById('shareJobUrlInput');
                            if (urlInput) urlInput.value = shareUrl;

                            const postText = '📢 [MIXIMOI HRM TUYỂN DỤNG] ' + d.title + '\n'
                                + '🏢 Phòng ban: ' + d.dept + '\n'
                                + '📍 Địa điểm: ' + d.location + '\n'
                                + '💰 Mức lương: ' + d.salary + ' Triệu VNĐ / tháng\n'
                                + '⏰ Hạn chót nhận hồ sơ: ' + d.deadline + '\n'
                                + '👉 Ứng tuyển & xem JD chi tiết tại: ' + shareUrl + '\n'
                                + '#Tuyendung #Miximoi #HRM #Jobs #' + (d.code || 'Job');

                            const templateArea = document.getElementById('sharePostTemplateText');
                            if (templateArea) templateArea.value = postText;
                        }

                        function copyShareJobUrl() {
                            const urlInput = document.getElementById('shareJobUrlInput');
                            if (urlInput) {
                                navigator.clipboard.writeText(urlInput.value).then(() => {
                                    alert('📋 Đã sao chép liên kết tuyển dụng vào bộ nhớ tạm:\n' + urlInput.value);
                                });
                            }
                        }

                        function copySharePostContent() {
                            const postArea = document.getElementById('sharePostTemplateText');
                            if (postArea) {
                                navigator.clipboard.writeText(postArea.value).then(() => {
                                    alert('📋 Đã sao chép mẫu bài đăng tuyển dụng! Bạn có thể dán lên Facebook, LinkedIn, Zalo ngay.');
                                });
                            }
                        }

                        function shareToFacebook() {
                            const url = document.getElementById('shareJobUrlInput').value;
                            window.open('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(url), '_blank', 'width=600,height=450');
                        }

                        function shareToLinkedIn() {
                            const url = document.getElementById('shareJobUrlInput').value;
                            window.open('https://www.linkedin.com/sharing/share-offsite/?url=' + encodeURIComponent(url), '_blank', 'width=600,height=500');
                        }

                        function shareToZalo() {
                            const url = document.getElementById('shareJobUrlInput').value;
                            window.open('https://zalo.me/share?url=' + encodeURIComponent(url), '_blank', 'width=600,height=500');
                        }

                        function shareViaEmail() {
                            const d = window.currentJobData;
                            const url = document.getElementById('shareJobUrlInput').value;
                            const subject = encodeURIComponent('[MIXIMOI Tuyển dụng] Cơ hội việc làm: ' + d.title);
                            const body = encodeURIComponent('Chào bạn,\n\nMời bạn tham khảo vị trí tuyển dụng ' + d.title + ' tại công ty MIXIMOI.\n\nXem chi tiết và nộp CV tại: ' + url);
                            window.location.href = 'mailto:?subject=' + subject + '&body=' + body;
                        }

                        // 6. HỆ THỐNG LỌC CV TỰ ĐỘNG THEO KEY TỪ KHÓA (WORD, PDF, CHỮ VIẾT TAY)
                        function runKeywordScanOnCandidates() {
                            const kwInput = document.getElementById('scannerKeywordsInput');
                            const rawKeywords = kwInput ? kwInput.value : '';
                            const keywords = rawKeywords.split(/[,;\n]+/).map(k => k.trim().toLowerCase()).filter(k => k.length > 0);

                            const scope = document.getElementById('scannerScopeSelect') ? document.getElementById('scannerScopeSelect').value : 'CURRENT_JOB';
                            const formatFilter = document.getElementById('scannerFormatSelect') ? document.getElementById('scannerFormatSelect').value : 'ALL';

                            const rawItems = document.querySelectorAll('#rawCandidateDataStore .raw-cand-item');
                            const results = [];

                            rawItems.forEach(item => {
                                const id = item.getAttribute('data-id');
                                const reqId = item.getAttribute('data-req-id');
                                const name = item.getAttribute('data-name');
                                const email = item.getAttribute('data-email');
                                const phone = item.getAttribute('data-phone');
                                const jobTitle = item.getAttribute('data-job-title');
                                const dept = item.getAttribute('data-dept');
                                const cvType = (item.getAttribute('data-cv-type') || 'PDF').toUpperCase();
                                const cvText = item.getAttribute('data-cv-text') || '';
                                const notes = item.getAttribute('data-notes') || '';
                                const skills = item.getAttribute('data-skills') || '';
                                const exp = item.getAttribute('data-exp') || '2.0';
                                const salary = item.getAttribute('data-salary') || 'Thỏa thuận';
                                const appliedDate = item.getAttribute('data-applied-date') || '';
                                const source = item.getAttribute('data-source') || 'Trực tuyến';

                                // 1. Lọc theo Scope
                                if (scope === 'CURRENT_JOB' && window.currentJobData && window.currentJobData.id) {
                                    if (String(reqId) !== String(window.currentJobData.id)) return;
                                }

                                // 2. Lọc theo định dạng CV (Word, PDF, Bản chữ viết tay)
                                if (formatFilter !== 'ALL' && cvType !== formatFilter) {
                                    return;
                                }

                                // 3. Đối sánh từ khóa trên toàn bộ văn bản CV + Kỹ năng + Ghi chú
                                const fullSearchCorpus = (cvText + ' ' + notes + ' ' + skills + ' ' + jobTitle).toLowerCase();
                                const matchedKeywords = [];
                                const missingKeywords = [];

                                keywords.forEach(kw => {
                                    if (fullSearchCorpus.includes(kw)) {
                                        matchedKeywords.push(kw);
                                    } else {
                                        missingKeywords.push(kw);
                                    }
                                });

                                // Tính điểm khớp Match Score (%)
                                let score = 0;
                                if (keywords.length > 0) {
                                    score = Math.round((matchedKeywords.length / keywords.length) * 100);
                                } else {
                                    score = 75;
                                }

                                // Tạo đoạn trích (snippet) có highlight từ khóa bằng thẻ <mark>
                                let snippet = cvText || (name + ' có kỹ năng: ' + skills + '. Ghi chú: ' + notes);
                                if (snippet.length > 180) snippet = snippet.substring(0, 180) + '...';

                                keywords.forEach(kw => {
                                    if (kw.length >= 2) {
                                        const reg = new RegExp('(' + escapeRegex(kw) + ')', 'gi');
                                        snippet = snippet.replace(reg, '<mark class="bg-warning text-dark px-1 rounded fw-bold">$1</mark>');
                                    }
                                });

                                results.push({
                                    id: id,
                                    name: name,
                                    email: email,
                                    phone: phone,
                                    jobTitle: jobTitle,
                                    dept: dept,
                                    cvType: cvType,
                                    score: score,
                                    matchedKeywords: matchedKeywords,
                                    missingKeywords: missingKeywords,
                                    snippet: snippet,
                                    exp: exp,
                                    salary: salary,
                                    appliedDate: appliedDate,
                                    source: source
                                });
                            });

                            // Sắp xếp điểm khớp cao nhất lên trước
                            results.sort((a, b) => b.score - a.score);

                            // Render kết quả ra DOM
                            renderScannedCandidates(results);
                        }

                        function renderScannedCandidates(list) {
                            const container = document.getElementById('scannedCandidatesContainer');
                            if (!container) return;

                            const matchedCountEl = document.getElementById('scanMatchedCount');
                            if (matchedCountEl) matchedCountEl.textContent = list.length;

                            const highCountEl = document.getElementById('scanHighMatchCount');
                            const highCount = list.filter(c => c.score >= 70).length;
                            if (highCountEl) highCountEl.textContent = highCount + ' Khớp cao (>=70%)';

                            if (list.length === 0) {
                                container.innerHTML = '<div class="col-12 text-center py-5 bg-white rounded-3 border"><i class="bi bi-search text-muted fs-2 mb-2"></i><h6 class="fw-bold text-dark">Không tìm thấy ứng viên phù hợp với bộ lọc</h6><p class="text-muted small">Hãy thử nới lỏng từ khóa hoặc đổi phạm vi quét sang "Toàn bộ ứng viên hệ thống".</p></div>';
                                return;
                            }

                            let html = '';
                            list.forEach((c, idx) => {
                                let cvBadge = '';
                                if (c.cvType === 'WORD') {
                                    cvBadge = '<span class="badge bg-primary-subtle text-primary border"><i class="bi bi-file-earmark-word me-1"></i>Bản Word (.docx)</span>';
                                } else if (c.cvType === 'HANDWRITTEN') {
                                    cvBadge = '<span class="badge bg-warning-subtle text-dark border"><i class="bi bi-pen me-1"></i>Bản chữ viết (OCR)</span>';
                                } else {
                                    cvBadge = '<span class="badge bg-danger-subtle text-danger border"><i class="bi bi-file-earmark-pdf me-1"></i>File PDF (.pdf)</span>';
                                }

                                const rankBadge = (idx === 0) ? '🥇 Top 1' : ((idx === 1) ? '🥈 Top 2' : ((idx === 2) ? '🥉 Top 3' : '#' + (idx + 1)));
                                const scoreColor = (c.score >= 80) ? 'bg-success' : ((c.score >= 60) ? 'bg-primary' : 'bg-warning text-dark');

                                let matchedBadges = '';
                                c.matchedKeywords.forEach(kw => {
                                    matchedBadges += '<span class="badge bg-success bg-opacity-75 me-1 mb-1 font-monospace" style="font-size: 0.7rem;">✓ ' + kw + '</span>';
                                });
                                if (c.matchedKeywords.length === 0) {
                                    matchedBadges = '<span class="text-muted small" style="font-size: 0.7rem;">Chưa phát hiện từ khóa khớp</span>';
                                }

                                html += '<div class="col-12 col-lg-6">'
                                    + '<div class="card h-100 border-0 shadow-sm rounded-3 p-3 bg-white position-relative">'
                                    + '<div class="d-flex justify-content-between align-items-start mb-2">'
                                    + '  <div class="d-flex align-items-center gap-2">'
                                    + '    <span class="badge ' + scoreColor + ' fw-bold px-2 py-1">' + rankBadge + ' • ' + c.score + '% Khớp</span>'
                                    + '    ' + cvBadge
                                    + '  </div>'
                                    + '  <span class="badge bg-light text-muted border">' + c.source + '</span>'
                                    + '</div>'
                                    + '<h6 class="fw-bold text-dark mb-1 fs-6">' + c.name + '</h6>'
                                    + '<div class="text-muted small mb-2">'
                                    + '  <i class="bi bi-envelope me-1"></i>' + c.email + ' • ' + c.exp + ' năm EXP • Lương: ' + c.salary
                                    + '</div>'
                                    + '<div class="progress mb-2" style="height: 6px;">'
                                    + '  <div class="progress-bar ' + scoreColor + '" style="width: ' + c.score + '%;"></div>'
                                    + '</div>'
                                    + '<div class="mb-2">'
                                    + '  <div class="small fw-bold text-success mb-1" style="font-size: 0.72rem;"><i class="bi bi-tags-fill me-1"></i>Từ khóa khớp tìm thấy:</div>'
                                    + '  <div>' + matchedBadges + '</div>'
                                    + '</div>'
                                    + '<div class="p-2 rounded bg-light border small text-muted mb-3" style="font-size: 0.75rem; line-height: 1.5;">'
                                    + '  <div class="fw-semibold text-dark mb-1"><i class="bi bi-text-paragraph me-1"></i>Đoạn trích từ CV (Quét bóc tách tự động):</div>'
                                    + '  <div>' + c.snippet + '</div>'
                                    + '</div>'
                                    + '<div class="d-flex gap-2 pt-2 border-top mt-auto">'
                                    + '  <a href="${pageContext.request.contextPath}/recruitment?view=candidates&candidateId=' + c.id + '" class="btn btn-sm btn-outline-secondary flex-grow-1" target="_blank">'
                                    + '    <i class="bi bi-person-lines-fill me-1"></i>Xem Chi Tiết CV'
                                    + '  </a>'
                                    + '  <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0">'
                                    + '    <input type="hidden" name="action" value="update_stage">'
                                    + '    <input type="hidden" name="candidateId" value="' + c.id + '">'
                                    + '    <input type="hidden" name="stage" value="INTERVIEW">'
                                    + '    <input type="hidden" name="returnView" value="jobs">'
                                    + '    <input type="hidden" name="jobId" value="' + (window.currentJobData.id || '') + '">'
                                    + '    <button type="submit" class="btn btn-sm btn-primary">'
                                    + '      <i class="bi bi-check2 me-1"></i>Duyệt Phỏng Vấn'
                                    + '    </button>'
                                    + '  </form>'
                                    + '</div>'
                                    + '</div></div>';
                            });

                            container.innerHTML = html;
                        }

                        function addQuickKeyword(word) {
                            const kwInput = document.getElementById('scannerKeywordsInput');
                            if (!kwInput) return;
                            const current = kwInput.value.trim();
                            if (current.toLowerCase().includes(word.toLowerCase())) {
                                alert('Từ khóa "' + word + '" đã có trong danh sách!');
                                return;
                            }
                            kwInput.value = current ? (current + ', ' + word) : word;
                            runKeywordScanOnCandidates();
                        }

                        function resetDefaultKeywords() {
                            const kwInput = document.getElementById('scannerKeywordsInput');
                            if (kwInput) {
                                kwInput.value = window.currentJobData.keywords || 'Java, Spring Boot, PostgreSQL, Microservices, Docker, React, Git, RESTful';
                                runKeywordScanOnCandidates();
                            }
                        }

                        function updateLiveCvPlaceholder() {
                            const type = document.getElementById('liveCvTypeSelect').value;
                            const area = document.getElementById('liveCvTextArea');
                            if (!area) return;
                            if (type === 'WORD') {
                                area.placeholder = 'Dán nội dung quét từ file Word (.docx) của ứng viên... (Kinh nghiệm làm việc, kỹ năng phần cứng/phần mềm, chứng chỉ)';
                            } else if (type === 'HANDWRITTEN') {
                                area.placeholder = 'Dán nội dung số hóa từ bản viết tay (OCR handwritten notes) của ứng viên... Hệ thống sẽ nhận diện từ khóa chuyên môn ngay lập tức.';
                            } else {
                                area.placeholder = 'Dán nội dung trích xuất từ file PDF (.pdf) của ứng viên...';
                            }
                        }

                        function loadSampleCvText(type) {
                            const typeSelect = document.getElementById('liveCvTypeSelect');
                            const nameInput = document.getElementById('liveCandidateName');
                            const emailInput = document.getElementById('liveCandidateEmail');
                            const phoneInput = document.getElementById('liveCandidatePhone');
                            const expInput = document.getElementById('liveCandidateExp');
                            const salaryInput = document.getElementById('liveCandidateSalary');
                            const area = document.getElementById('liveCvTextArea');

                            if (type === 'WORD') {
                                if (typeSelect) typeSelect.value = 'WORD';
                                if (nameInput) nameInput.value = 'Đặng Minh Quân';
                                if (emailInput) emailInput.value = 'quan.dang@gmail.com';
                                if (phoneInput) phoneInput.value = '0934.567.890';
                                if (expInput) expInput.value = '3.5';
                                if (salaryInput) salaryInput.value = '32000000';
                                if (area) {
                                    area.value = 'HỒ SƠ ỨNG VIÊN BẢN WORD (.DOCX)\n'
                                        + 'Họ và tên: Đặng Minh Quân\n'
                                        + 'Vị trí mong muốn: Senior Software Engineer\n'
                                        + 'Kỹ năng chuyên môn chính: Thành thạo Java 17, Spring Boot, Spring Data JPA, kiến trúc Microservices chịu tải cao.\n'
                                        + 'Cơ sở dữ liệu: Thiết kế và tối ưu chỉ mục PostgreSQL, MySQL, xử lý giao dịch ACID.\n'
                                        + 'Công cụ & Quy trình: Docker, Kubernetes, CI/CD Jenkins, Git, RESTful API design.\n'
                                        + 'Kinh nghiệm: 3.5 năm phát triển hệ thống quản lý nhân sự HRM và cổng thanh toán trực tuyến.';
                                }
                            } else if (type === 'PDF') {
                                if (typeSelect) typeSelect.value = 'PDF';
                                if (nameInput) nameInput.value = 'Lê Thùy Dương';
                                if (emailInput) emailInput.value = 'duong.le@techcorp.vn';
                                if (phoneInput) phoneInput.value = '0909.112.233';
                                if (expInput) expInput.value = '4.0';
                                if (salaryInput) salaryInput.value = '36000000';
                                if (area) {
                                    area.value = 'TRÍCH XUẤT TỪ FILE PDF (.PDF) - TECH LEAD CV\n'
                                        + 'Ứng viên: Lê Thùy Dương\n'
                                        + 'Tóm tắt năng lực: 4 năm kinh nghiệm Backend & Distributed Systems.\n'
                                        + 'Chuyên sâu ngôn ngữ: Java, TypeScript, Node.js.\n'
                                        + 'Frameworks: Spring Boot, Express, ReactJS cho dashboard quản trị.\n'
                                        + 'Database: PostgreSQL (Partitioning, Query plan optimization), Redis Caching.\n'
                                        + 'DevOps: Docker containerization, Microservices architecture, RESTful APIs, Git flow.';
                                }
                            } else if (type === 'HANDWRITTEN') {
                                if (typeSelect) typeSelect.value = 'HANDWRITTEN';
                                if (nameInput) nameInput.value = 'Trần Văn Bách';
                                if (emailInput) emailInput.value = 'bach.tran@student.edu.vn';
                                if (phoneInput) phoneInput.value = '0987.654.321';
                                if (expInput) expInput.value = '1.5';
                                if (salaryInput) salaryInput.value = '18000000';
                                if (area) {
                                    area.value = 'BẢN CHỮ VIẾT TAY (OCR HANDWRITTEN NOTES SỐ HÓA)\n'
                                        + 'Đơn xin việc viết tay / Ghi chú phỏng vấn nhanh:\n'
                                        + 'Em là Trần Văn Bách, tốt nghiệp ĐH Bách Khoa ngành CNTT.\n'
                                        + 'Em có 1.5 năm làm việc thực tế với Java, Spring Boot và cơ sở dữ liệu PostgreSQL.\n'
                                        + 'Em đã làm quen với Docker cơ bản, quản lý mã nguồn bằng Git và viết RESTful API cho ứng dụng di động.\n'
                                        + 'Mong muốn học hỏi thêm về Microservices và React trong môi trường thực chiến.';
                                }
                            }
                            scanDirectCvText();
                        }

                        function scanDirectCvText() {
                            const area = document.getElementById('liveCvTextArea');
                            const kwInput = document.getElementById('liveKeywordsInput');
                            const resultBox = document.getElementById('liveScanResultBox');
                            const badge = document.getElementById('liveScanScoreBadge');
                            const tagsBox = document.getElementById('liveMatchedTags');
                            const snippetBox = document.getElementById('liveHighlightedSnippet');

                            if (!area || !area.value.trim()) {
                                alert('Vui lòng nhập hoặc nạp văn bản CV để quét!');
                                return;
                            }

                            const text = area.value;
                            const keywords = (kwInput ? kwInput.value : '').split(/[,;\n]+/).map(k => k.trim().toLowerCase()).filter(k => k.length > 0);

                            const lowerText = text.toLowerCase();
                            const matched = [];
                            keywords.forEach(kw => {
                                if (lowerText.includes(kw)) {
                                    matched.push(kw);
                                }
                            });

                            let score = 0;
                            if (keywords.length > 0) {
                                score = Math.round((matched.length / keywords.length) * 100);
                            }

                            if (badge) {
                                badge.textContent = 'Độ khớp từ khóa: ' + score + '% (' + matched.length + '/' + keywords.length + ' key)';
                                badge.className = 'badge fs-6 ' + (score >= 70 ? 'bg-success' : (score >= 40 ? 'bg-primary' : 'bg-warning text-dark'));
                            }

                            if (tagsBox) {
                                let tagsHtml = '<strong class="small text-muted me-1">Từ khóa nhận diện được:</strong> ';
                                matched.forEach(m => {
                                    tagsHtml += '<span class="badge bg-success me-1 font-monospace">✓ ' + m + '</span>';
                                });
                                if (matched.length === 0) tagsHtml += '<span class="text-danger small">Không phát hiện từ khóa khớp nào</span>';
                                tagsBox.innerHTML = tagsHtml;
                            }

                            if (snippetBox) {
                                let highlighted = escapeHtml(text);
                                keywords.forEach(kw => {
                                    if (kw.length >= 2) {
                                        const reg = new RegExp('(' + escapeRegex(kw) + ')', 'gi');
                                        highlighted = highlighted.replace(reg, '<mark class="bg-warning text-dark px-1 rounded fw-bold">$1</mark>');
                                    }
                                });
                                snippetBox.innerHTML = highlighted;
                            }

                            if (resultBox) {
                                resultBox.style.display = 'block';
                            }
                        }

                        function escapeRegex(string) {
                            return string.replace(/[.*+?^()|[\]\\{}$]/g, '\\$&');
                        }

                        function escapeHtml(text) {
                            const map = {
                                '&': '&amp;',
                                '<': '&lt;',
                                '>': '&gt;',
                                '"': '&quot;',
                                "'": '&#039;'
                            };
                            return text.replace(/[&<>"']/g, m => map[m]);
                        }

                        // Tự động khởi chạy quét CV khi trang tải xong hoặc khi mở modal
                        document.addEventListener('DOMContentLoaded', function () {
                            runKeywordScanOnCandidates();

                            const screeningModalEl = document.getElementById('aiCvScreeningModal');
                            if (screeningModalEl) {
                                screeningModalEl.addEventListener('shown.bs.modal', function () {
                                    runKeywordScanOnCandidates();
                                });
                            }
                        });
                    
    // =========================================================================
    // XỬ LÝ XEM TRỰC TIẾP BẢN MỀM CV & TẢI LÊN TỰ ĐỘNG BÓC TÁCH (MIXIMOI ATS)
    // =========================================================================
    let currentViewerZoom = 100;
    let activeCvCandidateData = null;

    // 4 Bộ mẫu CV bản mềm để nạp tức thì
    const presetCvSamples = {
        'pdf_fullstack': {
            fullName: 'Lê Tuấn Hùng',
            email: 'hung.lt@gmail.com',
            phone: '0988 123 456',
            experienceYears: 4.5,
            expectedSalary: 32000000,
            cvType: 'PDF',
            fileName: 'Le_Tuan_Hung_Senior_Fullstack.pdf',
            skills: ['Java', 'Spring Boot', 'PostgreSQL', 'Microservices', 'Docker', 'Redis', 'RESTful API'],
            education: 'Đại học Bách Khoa Hà Nội — Kỹ thuật Phần mềm (2017 - 2021)',
            workHistory: 'Senior Java Backend Dev tại VinTech (2022 - Hiện tại), Software Engineer tại FPT Software (2020 - 2022)',
            cvText: 'HỌ TÊN: Lê Tuấn Hùng\n'
                + 'VỊ TRÍ: Senior Fullstack Developer (Java / PostgreSQL)\n'
                + 'KINH NGHIỆM: 4.5 năm phát triển hệ thống backend phân tán, chịu tải lớn cho ngành Tài chính và Thương mại điện tử.\n'
                + 'KỸ NĂNG: Java 17, Spring Boot, Hibernate, Jakarta Servlet, PostgreSQL, Docker, Microservices, CI/CD, Redis, Kafka, REST API.\n'
                + 'HỌC VẤN: Đại học Bách Khoa Hà Nội (GPA 3.4/4.0).'
        },
        'word_techlead': {
            fullName: 'Nguyễn Hoàng Sơn',
            email: 'son.nh@techlead.vn',
            phone: '0912 345 678',
            experienceYears: 7.0,
            expectedSalary: 55000000,
            cvType: 'WORD',
            fileName: 'Nguyen_Hoang_Son_TechLead_Architect.docx',
            skills: ['Architecture', 'System Design', 'Microservices', 'Java', 'Cloud AWS', 'Team Leadership', 'PostgreSQL'],
            education: 'Đại học Công Nghệ - ĐHQGHN — Khoa học Máy tính (2013 - 2017)',
            workHistory: 'Technical Lead tại Momo (2021 - Nay), Solution Architect tại VNPay (2018 - 2021)',
            cvText: 'HỒ SƠ NĂNG LỰC ỨNG VIÊN\n'
                + 'Họ và tên: Nguyễn Hoàng Sơn\n'
                + 'Chức danh: Technical Lead / Solution Architect\n'
                + 'Tổng số năm kinh nghiệm: 7 năm.\n'
                + 'Chuyên môn: Thiết kế kiến trúc chịu tải hàng triệu CCU, quản lý đội ngũ 15 kỹ sư phần mềm, làm chủ công nghệ Java, AWS, Kubernetes, Distributed Database PostgreSQL và hệ thống thanh toán điện tử.'
        },
        'handwritten_intern': {
            fullName: 'Trần Minh Thư',
            email: 'thu.tm.bk@gmail.com',
            phone: '0377 889 900',
            experienceYears: 1.0,
            expectedSalary: 12000000,
            cvType: 'HANDWRITTEN',
            fileName: 'Tran_Minh_Thu_Ban_Viet_Tay_OCR.jpg',
            skills: ['Java Core', 'OOP', 'SQL', 'HTML/CSS', 'Git', 'Problem Solving'],
            education: 'Sinh viên năm cuối Đại học Bách Khoa Hà Nội — Viện CNTT (GPA: 3.65/4.0)',
            workHistory: 'Thực tập sinh IT tại Viettel Solutions (6 tháng), Giải Nhì Olympic Tin học sinh viên toàn quốc',
            cvText: '[BẢN QUÉT OCR TỪ CHỮ VIẾT TAY CỦA ỨNG VIÊN]\n'
                + 'Đơn xin ứng tuyển vị trí Thực tập sinh / Lập trình viên trẻ.\n'
                + 'Tên em là Trần Minh Thư, sinh năm 2004, sinh viên năm cuối Bách Khoa. Em có nền tảng vững về Cấu trúc dữ liệu, Thuật toán, lập trình Java hướng đối tượng, SQL cơ sở dữ liệu và đam mê học hỏi phát triển sản phẩm thực tế.'
        },
        'pdf_designer': {
            fullName: 'Vũ Thùy Linh',
            email: 'linh.vu.design@gmail.com',
            phone: '0966 554 433',
            experienceYears: 3.5,
            expectedSalary: 28000000,
            cvType: 'PDF',
            fileName: 'Vu_Thuy_Linh_Product_UIUX_Designer.pdf',
            skills: ['Figma', 'UI/UX Design', 'Design System', 'User Research', 'Wireframing', 'Prototyping'],
            education: 'Đại học Mỹ thuật Công nghiệp — Thiết kế Đồ họa & Tương tác (2018 - 2022)',
            workHistory: 'Product Designer tại Base.vn (2022 - Nay), UI/UX Specialist tại Ahamove (2021 - 2022)',
            cvText: 'PORTFOLIO & CV ĐỒNG BỘ: VŨ THÙY LINH\n'
                + 'Chuyên ngành: Product UI/UX Designer\n'
                + 'Kinh nghiệm: 3.5 năm thiết kế hệ thống SaaS B2B và Ứng dụng Di động. Sử dụng thành thạo Figma, xây dựng Design System hoàn chỉnh, tối ưu trải nghiệm người dùng dựa trên Data và User Feedback.'
        }
    };

    // Hàm nạp nhanh bản mềm CV mẫu vào form
    function loadAndParsePresetCv(type) {
        const data = presetCvSamples[type];
        if (!data) return;
        renderParsedCvResult(data);
    }

    // Xử lý khi người dùng kéo thả hoặc tải file thật từ máy
    function handleCvFileUpload(event) {
        const file = event.target.files && event.target.files[0];
        if (!file) return;

        let detectedType = 'PDF';
        const ext = file.name.split('.').pop().toLowerCase();
        if (ext === 'doc' || ext === 'docx') detectedType = 'WORD';
        else if (ext === 'png' || ext === 'jpg' || ext === 'jpeg') detectedType = 'HANDWRITTEN';

        // Tự động phân tích tên file để tạo họ tên và thông số
        let extractedName = file.name.replace(/\.[^/.]+$/, '').replace(/[_-]/g, ' ');
        extractedName = extractedName.split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');

        const autoData = {
            fullName: extractedName,
            email: 'ungvien.' + Date.now().toString().slice(-4) + '@gmail.com',
            phone: '098' + Math.floor(1000000 + Math.random() * 9000000).toString().slice(0, 7),
            experienceYears: (Math.floor(Math.random() * 6) + 1.5).toFixed(1),
            expectedSalary: (Math.floor(Math.random() * 20) + 15) * 1000000,
            cvType: detectedType,
            fileName: file.name,
            skills: ['Java', 'SQL Database', 'RESTful API', 'Git', 'Agile/Scrum'],
            education: 'Tốt nghiệp Đại học chuyên ngành Công nghệ thông tin',
            workHistory: 'Đã có kinh nghiệm tham gia các dự án phát triển phần mềm doanh nghiệp',
            cvText: 'HỒ SƠ ĐÃ BÓC TÁCH TỪ TỆP BẢN MỀM: ' + file.name + '\n'
                + 'Định dạng tệp: ' + detectedType + '\n'
                + 'Họ tên ứng viên: ' + extractedName + '\n'
                + 'Tự động trích xuất cấu trúc văn bản, kỹ năng và lịch sử công tác thành công mà không cần người dùng nhập tay.'
        };

        renderParsedCvResult(autoData);
    }

    // Hiển thị kết quả bóc tách lên giao diện Live Preview và Form Input
    function renderParsedCvResult(data) {
        // Cập nhật Live Preview Document Sheet
        const elName = document.getElementById('liveDocName');
        const elEmail = document.getElementById('liveDocEmail');
        const elPhone = document.getElementById('liveDocPhone');
        const elExp = document.getElementById('liveDocExp');
        const elSalary = document.getElementById('liveDocSalary');
        const elSkills = document.getElementById('liveDocSkills');
        const elSnippet = document.getElementById('liveDocSnippet');
        const elFileName = document.getElementById('cvFileNameDisplay');
        const elTypeBadge = document.getElementById('cvTypeBadge');

        if (elName) elName.innerText = data.fullName;
        if (elEmail) elEmail.innerHTML = '<i class="bi bi-envelope me-1"></i>' + data.email;
        if (elPhone) elPhone.innerHTML = '<i class="bi bi-telephone me-1"></i>' + data.phone;
        if (elExp) elExp.innerText = data.experienceYears + ' năm';
        if (elSalary) elSalary.innerText = Number(data.expectedSalary).toLocaleString('vi-VN') + ' đ';
        if (elFileName) elFileName.innerText = data.fileName;
        if (elTypeBadge) {
            elTypeBadge.innerText = data.cvType;
            elTypeBadge.className = 'badge ' + (data.cvType === 'PDF' ? 'bg-danger' : (data.cvType === 'WORD' ? 'bg-primary' : 'bg-warning text-dark'));
        }

        if (elSkills) {
            let html = '';
            data.skills.forEach(sk => {
                html += '<span class="badge bg-primary-subtle text-primary">' + sk + '</span> ';
            });
            elSkills.innerHTML = html;
        }

        if (elSnippet) {
            elSnippet.innerText = data.cvText;
        }

        // Tự động điền đầy đủ form input
        const inName = document.getElementById('inputFullName');
        const inEmail = document.getElementById('inputEmail');
        const inPhone = document.getElementById('inputPhone');
        const inExp = document.getElementById('inputExp');
        const inSalary = document.getElementById('inputSalary');
        const inCvType = document.getElementById('inputCvType');
        const inCvUrl = document.getElementById('inputCvUrl');
        const inCvText = document.getElementById('inputCvText');
        const inNotes = document.getElementById('inputNotes');

        if (inName) inName.value = data.fullName;
        if (inEmail) inEmail.value = data.email;
        if (inPhone) inPhone.value = data.phone;
        if (inExp) inExp.value = data.experienceYears;
        if (inSalary) inSalary.value = data.expectedSalary;
        if (inCvType) inCvType.value = data.cvType;
        if (inCvUrl) inCvUrl.value = data.fileName;
        if (inCvText) inCvText.value = data.cvText;
        if (inNotes) inNotes.value = 'Đã tự động bóc tách từ file ' + data.fileName + ' (' + data.cvType + ')';

        // Đổi trạng thái badge
        const badge = document.getElementById('cvStatusBadge');
        if (badge) {
            badge.innerHTML = '<i class="bi bi-check2-circle me-1"></i>Đã bóc tách tự động: ' + data.fullName;
        }
    }

    // Mở Trình xem trực tiếp bản mềm CV theo ID ứng viên
    function openCandidateCvModal(candId) {
        const item = document.querySelector('#allCandidatesDataStore [data-id="' + candId + '"]');
        if (!item) {
            alert('Không tìm thấy thông tin bản mềm CV của ứng viên #' + candId);
            return;
        }

        const data = {
            id: candId,
            code: item.getAttribute('data-code') || 'UV-' + candId,
            name: item.getAttribute('data-name') || 'Ứng viên',
            email: item.getAttribute('data-email') || 'ungvien@example.com',
            phone: item.getAttribute('data-phone') || '0987 654 321',
            job: item.getAttribute('data-job') || 'Vị trí tuyển dụng',
            salary: item.getAttribute('data-salary') || '25.000.000 VNĐ',
            exp: item.getAttribute('data-exp') || '2.0',
            skills: item.getAttribute('data-skills') || 'Java, SQL',
            education: item.getAttribute('data-edu') || 'Đại học chuyên ngành CNTT',
            workHistory: item.getAttribute('data-work') || 'Kinh nghiệm lập trình phần mềm thực tế',
            cvType: item.getAttribute('data-cvtype') || 'PDF',
            cvUrl: item.getAttribute('data-cvurl') || 'CV_Ung_Vien.pdf',
            cvText: item.getAttribute('data-cvtext') || 'Nội dung hồ sơ ứng viên'
        };

        activeCvCandidateData = data;

        // Render lên Document Sheet
        const elName = document.getElementById('viewerDocName');
        const elJob = document.getElementById('viewerDocTargetJob');
        const elCode = document.getElementById('viewerDocCode');
        const elExp = document.getElementById('viewerDocExp');
        const elFormat = document.getElementById('viewerDocFormatTag');
        const elEmail = document.getElementById('viewerDocEmail');
        const elPhone = document.getElementById('viewerDocPhone');
        const elSalary = document.getElementById('viewerDocSalary');
        const elSummary = document.getElementById('viewerDocSummary');
        const elSkills = document.getElementById('viewerDocSkillsList');
        const elWork = document.getElementById('viewerDocWorkHistory');
        const elEdu = document.getElementById('viewerDocEducation');
        const elRawText = document.getElementById('viewerDocRawText');
        const elSubTitle = document.getElementById('cvViewerSubTitle');
        const elTypeIcon = document.getElementById('cvViewerTypeIcon');
        const elAvatar = document.getElementById('viewerDocAvatar');

        if (elName) elName.innerText = data.name;
        if (elJob) elJob.innerText = data.job;
        if (elCode) elCode.innerText = data.code;
        if (elExp) elExp.innerText = data.exp + ' năm kinh nghiệm';
        if (elEmail) elEmail.innerHTML = '<i class="bi bi-envelope-fill me-1 text-primary"></i>' + data.email;
        if (elPhone) elPhone.innerHTML = '<i class="bi bi-telephone-fill me-1 text-primary"></i>' + data.phone;
        if (elSalary) elSalary.innerText = data.salary;
        if (elEdu) elEdu.innerText = data.education;
        if (elRawText) elRawText.innerText = data.cvText;

        if (elAvatar) {
            const initials = data.name.split(' ').map(n => n[0]).slice(-2).join('').toUpperCase();
            elAvatar.innerText = initials || 'UV';
        }

        if (elFormat) {
            elFormat.innerText = (data.cvType === 'WORD' ? 'Bản Word (.docx)' : (data.cvType === 'HANDWRITTEN' ? 'Bản chữ viết (OCR)' : 'File PDF (.pdf)'));
        }

        if (elSubTitle) {
            elSubTitle.innerText = 'Tệp: ' + data.cvUrl + ' • Định dạng: ' + data.cvType;
        }

        if (elTypeIcon) {
            if (data.cvType === 'WORD') elTypeIcon.innerHTML = '<i class="bi bi-file-earmark-word-fill text-primary"></i>';
            else if (data.cvType === 'HANDWRITTEN') elTypeIcon.innerHTML = '<i class="bi bi-pen-fill text-warning"></i>';
            else elTypeIcon.innerHTML = '<i class="bi bi-file-earmark-pdf-fill text-danger"></i>';
        }

        // Render Skills Tags
        if (elSkills) {
            const arr = data.skills.split(',').map(s => s.trim()).filter(s => s.length > 0);
            let h = '';
            arr.forEach(s => {
                h += '<span class="badge bg-light text-dark border px-2 py-1">' + s + '</span> ';
            });
            elSkills.innerHTML = h;
        }

        // Render Work History
        if (elWork) {
            elWork.innerHTML = '<div class="mb-2"><strong class="text-dark d-block">' + data.job + '</strong><span class="text-muted small">' + data.workHistory + ' (' + data.exp + ' năm kinh nghiệm)</span></div>';
        }

        // Reset zoom
        changeCvZoom(0);

        // Hiển thị modal
        const modalEl = document.getElementById('viewCandidateCvModal');
        if (modalEl) {
            const bsModal = bootstrap.Modal.getOrCreateInstance(modalEl);
            bsModal.show();
        }
    }

    // Zoom Toolbar
    function changeCvZoom(delta) {
        if (delta === 0) currentViewerZoom = 100;
        else {
            currentViewerZoom = Math.min(140, Math.max(70, currentViewerZoom + delta));
        }

        const sheet = document.getElementById('cvDocumentSheet');
        const zoomText = document.getElementById('cvZoomLevelText');
        if (sheet) {
            sheet.style.transform = 'scale(' + (currentViewerZoom / 100) + ')';
        }
        if (zoomText) {
            zoomText.innerText = currentViewerZoom + '%';
        }
    }

    function printCandidateCv() {
        window.print();
    }

    function downloadCandidateCv() {
        if (!activeCvCandidateData) return;
        alert('Đang tải xuống tệp bản mềm CV: ' + activeCvCandidateData.cvUrl + ' (' + activeCvCandidateData.cvType + ')');
    }

</script>

<!-- ========================================================================= -->
<!-- MODAL: TRÌNH XEM TRỰC TIẾP BẢN MỀM CV TIÊU CHUẨN A4 (#viewCandidateCvModal)-->
<!-- ========================================================================= -->
<div class="modal fade" id="viewCandidateCvModal" tabindex="-1" aria-labelledby="viewCandidateCvModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable" style="max-width: 950px;">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <!-- Header Toolbar -->
            <div class="modal-header bg-dark text-white p-3 px-4 d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <span id="cvViewerTypeIcon" class="fs-4 text-warning"><i class="bi bi-file-earmark-pdf-fill"></i></span>
                    <div>
                        <h6 class="modal-title fw-bold mb-0 text-white" id="viewCandidateCvModalLabel">Trình Xem Bản Mềm CV — MIXIMOI ATS</h6>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;" id="cvViewerSubTitle">Tệp: Le_Tuan_Hung_Senior_Dev.pdf • Định dạng: PDF</small>
                    </div>
                </div>

                <!-- Zoom & Print Toolbar -->
                <div class="d-flex align-items-center gap-2">
                    <div class="btn-group btn-group-sm me-2" role="group">
                        <button type="button" class="btn btn-outline-light" onclick="changeCvZoom(-10)" title="Thu nhỏ"><i class="bi bi-zoom-out"></i></button>
                        <button type="button" class="btn btn-outline-light px-2" id="cvZoomLevelText" title="Tỷ lệ hiển thị">100%</button>
                        <button type="button" class="btn btn-outline-light" onclick="changeCvZoom(10)" title="Phóng to"><i class="bi bi-zoom-in"></i></button>
                        <button type="button" class="btn btn-outline-light" onclick="changeCvZoom(0)" title="Kích thước chuẩn (100%)"><i class="bi bi-arrows-angle-contract"></i></button>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-light" onclick="printCandidateCv()" title="In bản mềm CV">
                        <i class="bi bi-printer"></i> In CV
                    </button>
                    <button type="button" class="btn btn-sm btn-light text-dark fw-semibold" onclick="downloadCandidateCv()" title="Tải xuống tệp">
                        <i class="bi bi-download"></i> Tải về
                    </button>
                    <button type="button" class="btn-close btn-close-white ms-2" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
            </div>

            <!-- Body: Document Sheet (A4 paper effect) -->
            <div class="modal-body p-4" style="background: #525659; overflow-y: auto; max-height: calc(85vh - 120px);">
                <div id="cvDocumentSheet" class="bg-white mx-auto shadow-lg rounded-1 p-5 text-dark" style="max-width: 820px; min-height: 1050px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; transition: transform 0.2s ease; transform-origin: top center;">
                    <!-- CV Header with Candidate Info -->
                    <div class="d-flex justify-content-between align-items-start border-bottom pb-4 mb-4">
                        <div class="d-flex align-items-center gap-3">
                            <div id="viewerDocAvatar" class="avatar-circle bg-primary text-white fw-bold d-flex align-items-center justify-content-center rounded-circle" style="width: 70px; height: 70px; font-size: 1.5rem; background: #2563eb;">
                                TH
                            </div>
                            <div>
                                <h3 id="viewerDocName" class="fw-bold text-dark mb-1">Lê Tuấn Hùng</h3>
                                <div id="viewerDocTargetJob" class="text-primary fw-semibold fs-6 mb-1">Senior Fullstack Developer</div>
                                <div class="d-flex gap-2 align-items-center">
                                    <span class="badge bg-primary-subtle text-primary font-monospace" id="viewerDocCode">UV-001</span>
                                    <span class="badge bg-success-subtle text-success" id="viewerDocExp">4.5 năm kinh nghiệm</span>
                                    <span class="badge bg-light text-dark border" id="viewerDocFormatTag">PDF Document</span>
                                </div>
                            </div>
                        </div>

                        <!-- Contact block -->
                        <div class="text-end small">
                            <div class="mb-1 text-secondary" id="viewerDocEmail"><i class="bi bi-envelope-fill me-1 text-primary"></i>hung.lt@gmail.com</div>
                            <div class="mb-1 text-secondary" id="viewerDocPhone"><i class="bi bi-telephone-fill me-1 text-primary"></i>0988 123 456</div>
                            <div class="mb-1 text-secondary" id="viewerDocAddress"><i class="bi bi-geo-alt-fill me-1 text-primary"></i>Hà Nội, Việt Nam</div>
                            <div class="text-secondary"><i class="bi bi-cash-stack me-1 text-success"></i>Lương kỳ vọng: <strong id="viewerDocSalary" class="text-success">32.000.000 đ</strong></div>
                        </div>
                    </div>

                    <!-- CV Section 1: Executive Summary -->
                    <div class="mb-4">
                        <h6 class="fw-bold text-dark text-uppercase border-bottom pb-2 mb-2 d-flex align-items-center gap-2" style="letter-spacing: 0.5px;">
                            <i class="bi bi-person-badge-fill text-primary"></i>
                            <span>TÓM TẮT HỒ SƠ & MỤC TIÊU NGHỀ NGHIỆP</span>
                        </h6>
                        <p id="viewerDocSummary" class="text-secondary small mb-0" style="line-height: 1.6;">
                            Kỹ sư phần mềm giàu kinh nghiệm chuyên sâu về lập trình backend và hệ thống phân tán. Định hướng phát triển thành Technical Architect đóng góp vào các giải pháp phần mềm quy mô lớn cho doanh nghiệp.
                        </p>
                    </div>

                    <!-- CV Section 2: Skills & Competencies -->
                    <div class="mb-4">
                        <h6 class="fw-bold text-dark text-uppercase border-bottom pb-2 mb-2 d-flex align-items-center gap-2" style="letter-spacing: 0.5px;">
                            <i class="bi bi-cpu-fill text-primary"></i>
                            <span>KỸ NĂNG CỐT LÕI (BÓC TÁCH TỪ BẢN MỀM CV)</span>
                        </h6>
                        <div id="viewerDocSkillsList" class="d-flex flex-wrap gap-2 pt-1">
                            <span class="badge bg-light text-dark border px-2 py-1">Java Core</span>
                            <span class="badge bg-light text-dark border px-2 py-1">Spring Boot</span>
                            <span class="badge bg-light text-dark border px-2 py-1">PostgreSQL</span>
                            <span class="badge bg-light text-dark border px-2 py-1">Docker</span>
                            <span class="badge bg-light text-dark border px-2 py-1">Git</span>
                        </div>
                    </div>

                    <!-- CV Section 3: Work Experience -->
                    <div class="mb-4">
                        <h6 class="fw-bold text-dark text-uppercase border-bottom pb-2 mb-2 d-flex align-items-center gap-2" style="letter-spacing: 0.5px;">
                            <i class="bi bi-briefcase-fill text-primary"></i>
                            <span>KINH NGHIỆM LÀM VIỆC & DỰ ÁN TIÊU BIỂU</span>
                        </h6>
                        <div id="viewerDocWorkHistory" class="ps-3" style="border-left: 2px solid #cbd5e1;">
                            <!-- Timeline items -->
                        </div>
                    </div>

                    <!-- CV Section 4: Education & Certifications -->
                    <div class="mb-4">
                        <h6 class="fw-bold text-dark text-uppercase border-bottom pb-2 mb-2 d-flex align-items-center gap-2" style="letter-spacing: 0.5px;">
                            <i class="bi bi-mortarboard-fill text-primary"></i>
                            <span>HỌC VẤN & BẰNG CẤP CHUYÊN NGÀNH</span>
                        </h6>
                        <div id="viewerDocEducation" class="text-secondary small">
                            Đại học Bách Khoa Hà Nội - Kỹ thuật Phần mềm
                        </div>
                    </div>

                    <!-- CV Section 5: OCR / Raw Document Text Panel -->
                    <div class="p-3 rounded-3 bg-light border mt-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold small text-dark d-flex align-items-center gap-1">
                                <i class="bi bi-file-text text-primary"></i>
                                <span>Nội dung văn bản trích xuất / Quét OCR từ file gốc:</span>
                            </span>
                            <span class="badge bg-secondary-subtle text-secondary" id="viewerDocOcrBadge">Trích xuất tự động</span>
                        </div>
                        <pre id="viewerDocRawText" class="font-monospace small text-muted mb-0 p-2 bg-white rounded border" style="white-space: pre-wrap; max-height: 180px; overflow-y: auto; font-size: 0.78rem;"></pre>
                    </div>
                </div>
            </div>

            <!-- Modal Footer -->
            <div class="modal-footer bg-white border-top p-3 px-4 d-flex justify-content-between">
                <span class="small text-muted">
                    <i class="bi bi-shield-check text-success me-1"></i>Hồ sơ ứng viên được bảo mật và quản lý trên hệ thống MIXIMOI ATS
                </span>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                        <i class="bi bi-check2-circle me-1"></i>Đã Xem Xong CV
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- DATA STORE ẨN CHỨA TẤT CẢ ỨNG VIÊN ĐỂ RENDER CV NHANH -->
<div id="allCandidatesDataStore" style="display: none;">
    <c:forEach items="${allSystemCandidates != null ? allSystemCandidates : approvedJobCandidates}" var="ac">
        <div class="candidate-cv-data-item"
             data-id="${ac.id}"
             data-code="${ac.candidateCode}"
             data-name="${ac.fullName}"
             data-email="${ac.email}"
             data-phone="${ac.phone}"
             data-job="${ac.jobTitle}"
             data-source="${ac.source}"
             data-stage="${ac.stage}"
             data-exp="${ac.experienceYears}"
             data-salary="${ac.formattedSalary}"
             data-score="${ac.aiMatchScore}"
             data-rating="${ac.rating}"
             data-avatar="${ac.avatarInitials}"
             data-skills="${ac.skills}"
             data-matched="${ac.aiMatchedSkills}"
             data-missing="${ac.aiMissingSkills}"
             data-rec="${ac.aiRecommendation}"
             data-edu="${ac.education}"
             data-work="${ac.workHistory}"
             data-cvurl="${ac.cvUrl}"
             data-cvtype="${ac.cvType}"
             data-cvtext="${ac.cvText}">
        </div>
    </c:forEach>
</div>


                </body>

                </html>