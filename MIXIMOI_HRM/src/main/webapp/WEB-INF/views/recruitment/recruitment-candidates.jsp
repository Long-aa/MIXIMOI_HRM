<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <title>Hồ sơ Ứng viên & ATS Kanban Pipeline — MIXIMOI HRM</title>
                    <%@ include file="/WEB-INF/views/common/head.jsp" %>
                </head>

                <body class="hrm-app-body">
                    <div class="app-container">
                        <c:set var="activeMenu" value="recruitment" scope="request" />
                        <c:set var="activeSubMenu" value="candidates" scope="request" />
                        <!-- Sidebar -->
                        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

                            <div class="app-main">
                                <!-- Topbar -->
                                <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

                                    <!-- Main Content Area -->
                                    <main class="app-content p-3 p-lg-4">

                                        <!-- Toast / Alerts Notification -->
                                        <c:if test="${param.success eq 'candidate_added'}">
                                            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                                                <div><strong>Thành công!</strong> Đã tiếp nhận hồ sơ ứng viên mới vào hệ
                                                    thống phễu tuyển dụng.</div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${param.success eq 'offer_sent'}">
                                            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-envelope-check-fill fs-5 text-success"></i>
                                                <div><strong>Đã phát hành Offer!</strong> Đã gửi thư mời làm việc (Offer
                                                    Letter) tới ứng viên thành công.</div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${param.success eq 'stage_updated'}">
                                            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-arrow-right-circle-fill fs-5 text-primary"></i>
                                                <div><strong>Cập nhật thành công!</strong> Đã chuyển trạng thái vòng
                                                    tuyển dụng của ứng viên.</div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${param.success eq 'interview_scheduled'}">
                                            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-calendar-check-fill fs-5 text-success"></i>
                                                <div><strong>Xếp lịch thành công!</strong> Đã lên lịch phỏng vấn cho ứng
                                                    viên và gửi thông báo tới người phỏng vấn.</div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${param.error eq 'add_candidate_failed'}">
                                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                                                <div><strong>Lỗi tiếp nhận!</strong> Không thể thêm ứng viên mới. Vui
                                                    lòng kiểm tra lại thông tin nhập.</div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${param.error eq 'update_failed'}">
                                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4"
                                                role="alert">
                                                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                                                <div><strong>Lỗi xử lý!</strong> Không thể cập nhật trạng thái ứng viên.
                                                    Vui lòng thử lại.</div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                            </div>
                                        </c:if>

                                        <!-- Header -->
                                        <div
                                            class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                                            <div>
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <h1 class="h3 fw-bold text-dark mb-0">Ứng viên</h1>
                                                    <span class="badge bg-primary-subtle text-primary fw-bold">ATS
                                                        PIPELINE PRO</span>
                                                </div>
                                                <p class="text-muted mb-0" style="font-size: 0.875rem;">
                                                    Quản lý hồ sơ, tài liệu đánh giá và tiến trình tự động của ứng viên
                                                    theo chuẩn 5 giai đoạn chiến lược.
                                                </p>
                                            </div>
                                            <div class="d-flex flex-wrap gap-2">
                                                <a href="${pageContext.request.contextPath}/recruitment?action=export_report"
                                                    class="btn btn-outline-secondary d-flex align-items-center gap-2 text-decoration-none">
                                                    <i class="bi bi-file-earmark-arrow-down"></i>
                                                    <span>Xuất danh sách (Excel)</span>
                                                </a>
                                                <button type="button"
                                                    class="btn btn-outline-secondary d-flex align-items-center gap-2"
                                                    onclick="alert('Bộ lọc nâng cao theo kỹ năng & nguồn đang hoạt động.')">
                                                    <i class="bi bi-sliders"></i>
                                                    <span>Lọc nâng cao</span>
                                                </button>
                                                <button type="button"
                                                    class="btn btn-primary d-flex align-items-center gap-2 shadow-sm"
                                                    data-bs-toggle="modal" data-bs-target="#addCandidateModal">
                                                    <i class="bi bi-person-plus-fill"></i>
                                                    <span>Thêm ứng viên</span>
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
                                                            style="font-size: 0.72rem;">Tổng ứng viên</span>
                                                        <div class="kpi-icon-box blue">
                                                            <i class="bi bi-people"></i>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                                        <span class="kpi-value text-dark fw-bold"
                                                            style="font-size: 1.85rem;">${totalCandCount != null ?
                                                            totalCandCount : candidates.size()}</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">Đang chạy trong ${jobs.size()} vị
                                                            trí chiến lược</span>
                                                        <span class="badge bg-primary-subtle text-primary fw-semibold">↗
                                                            +12% tháng này</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- KPI 2 -->
                                            <div class="col-12 col-sm-6 col-xl-3">
                                                <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <span class="text-muted text-uppercase fw-bold"
                                                            style="font-size: 0.72rem;">Ứng viên mới</span>
                                                        <div class="kpi-icon-box purple">
                                                            <i class="bi bi-envelope"></i>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                                        <span class="kpi-value text-dark fw-bold"
                                                            style="font-size: 1.85rem;">${newCandCount != null ?
                                                            newCandCount : listNew.size() + listScreening.size()}</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">+7 hồ sơ được nộp trong 24h
                                                            qua</span>
                                                        <span
                                                            class="badge bg-warning-subtle text-warning-emphasis fw-semibold">!
                                                            Cần sàng lọc</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- KPI 3 -->
                                            <div class="col-12 col-sm-6 col-xl-3">
                                                <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <span class="text-muted text-uppercase fw-bold"
                                                            style="font-size: 0.72rem;">Đang phỏng vấn</span>
                                                        <div class="kpi-icon-box cyan">
                                                            <i class="bi bi-calendar-event"></i>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                                        <span class="kpi-value text-dark fw-bold"
                                                            style="font-size: 1.85rem;">${interviewCandCount != null ?
                                                            interviewCandCount : listInterview.size()}</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">Vòng Tech Test & Ban điều
                                                            hành</span>
                                                        <span class="badge bg-info-subtle text-info fw-semibold">8 lịch
                                                            tuần này</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- KPI 4 -->
                                            <div class="col-12 col-sm-6 col-xl-3">
                                                <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <span class="text-muted text-uppercase fw-bold"
                                                            style="font-size: 0.72rem;">Đã nhận việc</span>
                                                        <div class="kpi-icon-box green">
                                                            <i class="bi bi-shield-check"></i>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex align-items-baseline gap-1 mb-2">
                                                        <span class="kpi-value text-success fw-bold"
                                                            style="font-size: 1.85rem;">${onboardedCandCount != null ?
                                                            onboardedCandCount : listOnboarded.size()}</span>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span class="text-muted small">Đang hoàn tất hợp đồng thử
                                                            việc</span>
                                                        <span
                                                            class="badge bg-success-subtle text-success fw-semibold">Tỷ
                                                            lệ chốt: 62.5%</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Filter Bar with View Mode Toggle -->
                                        <div class="card border-0 shadow-sm rounded-3 mb-4">
                                            <div class="card-body p-3">
                                                <form id="candFilterForm" method="GET"
                                                    action="${pageContext.request.contextPath}/recruitment">
                                                    <input type="hidden" name="view" value="candidates">
                                                    <div class="row g-2 align-items-center">
                                                        <div class="col-12 col-md-4">
                                                            <div class="input-group input-group-sm">
                                                                <span class="input-group-text bg-light border-end-0"><i
                                                                        class="bi bi-search text-muted"></i></span>
                                                                <input type="text" id="candSearchInput" name="search"
                                                                    class="form-control border-start-0"
                                                                    placeholder="Tìm theo tên, email, mã ứng viên..."
                                                                    value="${searchKeyword}">
                                                            </div>
                                                        </div>
                                                        <div class="col-6 col-md-2">
                                                            <select class="form-select form-select-sm" name="requestId"
                                                                onchange="document.getElementById('candFilterForm').submit()">
                                                                <option value="">Tất cả vị trí (${jobs.size()})</option>
                                                                <c:forEach items="${jobs}" var="j">
                                                                    <option value="${j.id}" ${selectedRequestId==j.id
                                                                        ? 'selected' : '' }>${j.title}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="col-6 col-md-2">
                                                            <select class="form-select form-select-sm" name="stage"
                                                                onchange="document.getElementById('candFilterForm').submit()">
                                                                <option value="">Tất cả giai đoạn (5)</option>
                                                                <option value="NEW" ${selectedStage eq 'NEW'
                                                                    ? 'selected' : '' }>Mới nộp (${listNew.size()})
                                                                </option>
                                                                <option value="SCREENING" ${selectedStage eq 'SCREENING'
                                                                    ? 'selected' : '' }>Sàng lọc CV
                                                                    (${listScreening.size()})</option>
                                                                <option value="INTERVIEW" ${selectedStage eq 'INTERVIEW'
                                                                    ? 'selected' : '' }>Phỏng vấn
                                                                    (${listInterview.size()})</option>
                                                                <option value="OFFER" ${selectedStage eq 'OFFER'
                                                                    ? 'selected' : '' }>Đề xuất Offer
                                                                    (${listOffer.size()})</option>
                                                                <option value="ONBOARDED" ${selectedStage eq 'ONBOARDED'
                                                                    ? 'selected' : '' }>Đã nhận việc
                                                                    (${listOnboarded.size()})</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-6 col-md-2">
                                                            <select class="form-select form-select-sm" name="source"
                                                                onchange="document.getElementById('candFilterForm').submit()">
                                                                <option value="">Nguồn ứng viên: Tất cả</option>
                                                                <option value="LinkedIn" ${selectedSource eq 'LinkedIn'
                                                                    ? 'selected' : '' }>LinkedIn</option>
                                                                <option value="TopCV/VNW" ${selectedSource
                                                                    eq 'TopCV/VNW' ? 'selected' : '' }>TopCV /
                                                                    VietnamWorks</option>
                                                                <option value="Nội bộ (Ref)" ${selectedSource
                                                                    eq 'Nội bộ (Ref)' ? 'selected' : '' }>Nội bộ (Ref)
                                                                </option>
                                                                <option value="Khác" ${selectedSource eq 'Khác'
                                                                    ? 'selected' : '' }>Khác</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-6 col-md-2 d-flex justify-content-end gap-1">
                                                            <div class="btn-group btn-group-sm" role="group">
                                                                <button type="button" class="btn btn-primary"
                                                                    id="btnKanbanMode"
                                                                    onclick="switchCandidateView('kanban')"
                                                                    title="Chế độ Kanban">
                                                                    <i class="bi bi-kanban"></i>
                                                                    <span class="d-none d-sm-inline ms-1">Kanban</span>
                                                                </button>
                                                                <button type="button" class="btn btn-outline-secondary"
                                                                    id="btnTableMode"
                                                                    onclick="switchCandidateView('table')"
                                                                    title="Chế độ Bảng">
                                                                    <i class="bi bi-list-ul"></i>
                                                                    <span class="d-none d-sm-inline ms-1">Bảng</span>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>

                                        <!-- Two-Column Layout: Kanban Board / Table + Candidate Detail Drawer -->
                                        <div class="row g-4">
                                            <!-- Col-7: Kanban Board Pipeline OR Table -->
                                            <div class="col-12 col-xl-7">

                                                <!-- KANBAN BOARD CONTAINER -->
                                                <div id="kanbanBoardWrapper" class="kanban-board-wrapper">

                                                    <!-- Cột 1: Mới nộp (NEW) -->
                                                    <div class="kanban-column" data-stage="NEW"
                                                        ondragover="handleDragOver(event)"
                                                        ondragleave="handleDragLeave(event)"
                                                        ondrop="handleDrop(event, 'NEW')">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center px-1 mb-2">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <span class="badge-dot-indicator bg-primary"></span>
                                                                <span class="fw-bold text-dark"
                                                                    style="font-size: 0.84rem;">Mới nộp</span>
                                                            </div>
                                                            <span
                                                                class="badge bg-light text-muted border kanban-stage-badge"
                                                                id="badgeCountNEW">${listNew.size()}</span>
                                                        </div>

                                                        <c:forEach items="${listNew}" var="c">
                                                            <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}"
                                                                draggable="true" ondragstart="handleDragStart(event)"
                                                                ondragend="handleDragEnd(event)"
                                                                onclick="selectCandidateCard(this)" data-id="${c.id}"
                                                                data-code="${c.candidateCode}" data-name="${c.fullName}"
                                                                data-email="${c.email}" data-phone="${c.phone}"
                                                                data-job="${c.jobTitle}" data-source="${c.source}"
                                                                data-stage="${c.stage}" data-exp="${c.experienceYears}"
                                                                data-salary="${c.formattedSalary}"
                                                                data-score="${c.aiMatchScore}" data-rating="${c.rating}"
                                                                data-avatar="${c.avatarInitials}"
                                                                data-skills="${c.skills}"
                                                                data-matched="${c.aiMatchedSkills}"
                                                                data-missing="${c.aiMissingSkills}"
                                                                data-rec="${c.aiRecommendation}"
                                                                data-edu="${c.education}" data-work="${c.workHistory}">

                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <span
                                                                        class="badge bg-primary-subtle text-primary">${c.jobTitle}</span>
                                                                    <small
                                                                        class="text-muted">${c.formattedAppliedDate}</small>
                                                                </div>
                                                                <div class="fw-bold text-dark"
                                                                    style="font-size: 0.9rem;">${c.fullName}</div>
                                                                <div class="text-muted small mb-2">${c.skills}</div>
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center pt-2 border-top">
                                                                    <span class="text-warning small"><i
                                                                            class="bi bi-star-fill"></i>
                                                                        ${c.rating}</span>
                                                                    <span
                                                                        class="badge bg-light text-muted border">${c.source}</span>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>

                                                    <!-- Cột 2: Sàng lọc CV (SCREENING) -->
                                                    <div class="kanban-column" data-stage="SCREENING"
                                                        ondragover="handleDragOver(event)"
                                                        ondragleave="handleDragLeave(event)"
                                                        ondrop="handleDrop(event, 'SCREENING')">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center px-1 mb-2">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <span class="badge-dot-indicator bg-info"></span>
                                                                <span class="fw-bold text-dark"
                                                                    style="font-size: 0.84rem;">Sàng lọc CV</span>
                                                            </div>
                                                            <span
                                                                class="badge bg-light text-muted border kanban-stage-badge"
                                                                id="badgeCountSCREENING">${listScreening.size()}</span>
                                                        </div>

                                                        <c:forEach items="${listScreening}" var="c">
                                                            <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}"
                                                                draggable="true" ondragstart="handleDragStart(event)"
                                                                ondragend="handleDragEnd(event)"
                                                                onclick="selectCandidateCard(this)" data-id="${c.id}"
                                                                data-code="${c.candidateCode}" data-name="${c.fullName}"
                                                                data-email="${c.email}" data-phone="${c.phone}"
                                                                data-job="${c.jobTitle}" data-source="${c.source}"
                                                                data-stage="${c.stage}" data-exp="${c.experienceYears}"
                                                                data-salary="${c.formattedSalary}"
                                                                data-score="${c.aiMatchScore}" data-rating="${c.rating}"
                                                                data-avatar="${c.avatarInitials}"
                                                                data-skills="${c.skills}"
                                                                data-matched="${c.aiMatchedSkills}"
                                                                data-missing="${c.aiMissingSkills}"
                                                                data-rec="${c.aiRecommendation}"
                                                                data-edu="${c.education}" data-work="${c.workHistory}">

                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <span class="badge bg-purple-subtle text-purple"
                                                                        style="background: #f3e8ff; color: #7e22ce;">${c.jobTitle}</span>
                                                                    <span
                                                                        class="badge bg-success-subtle text-success">AI
                                                                        Match: ${c.aiMatchScore}%</span>
                                                                </div>
                                                                <div class="fw-bold text-dark"
                                                                    style="font-size: 0.9rem;">${c.fullName}</div>
                                                                <div class="text-muted small mb-2">${c.skills}</div>
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center pt-2 border-top">
                                                                    <span class="text-warning small"><i
                                                                            class="bi bi-star-fill"></i>
                                                                        ${c.rating}</span>
                                                                    <span
                                                                        class="badge bg-light text-muted border">${c.source}</span>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>

                                                    <!-- Cột 3: Phỏng vấn (INTERVIEW) -->
                                                    <div class="kanban-column" data-stage="INTERVIEW"
                                                        ondragover="handleDragOver(event)"
                                                        ondragleave="handleDragLeave(event)"
                                                        ondrop="handleDrop(event, 'INTERVIEW')">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center px-1 mb-2">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <span class="badge-dot-indicator bg-warning"></span>
                                                                <span class="fw-bold text-dark"
                                                                    style="font-size: 0.84rem;">Phỏng vấn</span>
                                                            </div>
                                                            <span
                                                                class="badge bg-light text-muted border kanban-stage-badge"
                                                                id="badgeCountINTERVIEW">${listInterview.size()}</span>
                                                        </div>

                                                        <c:forEach items="${listInterview}" var="c">
                                                            <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}"
                                                                draggable="true" ondragstart="handleDragStart(event)"
                                                                ondragend="handleDragEnd(event)"
                                                                onclick="selectCandidateCard(this)" data-id="${c.id}"
                                                                data-code="${c.candidateCode}" data-name="${c.fullName}"
                                                                data-email="${c.email}" data-phone="${c.phone}"
                                                                data-job="${c.jobTitle}" data-source="${c.source}"
                                                                data-stage="${c.stage}" data-exp="${c.experienceYears}"
                                                                data-salary="${c.formattedSalary}"
                                                                data-score="${c.aiMatchScore}" data-rating="${c.rating}"
                                                                data-avatar="${c.avatarInitials}"
                                                                data-skills="${c.skills}"
                                                                data-matched="${c.aiMatchedSkills}"
                                                                data-missing="${c.aiMissingSkills}"
                                                                data-rec="${c.aiRecommendation}"
                                                                data-edu="${c.education}" data-work="${c.workHistory}">

                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <span
                                                                        class="badge bg-warning-subtle text-warning-emphasis">${c.jobTitle}</span>
                                                                    <small class="text-muted"><i
                                                                            class="bi bi-calendar2-check text-primary me-1"></i>PV</small>
                                                                </div>
                                                                <div class="fw-bold text-dark"
                                                                    style="font-size: 0.9rem;">${c.fullName}</div>
                                                                <div class="text-muted small mb-2">${c.skills}</div>
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center pt-2 border-top">
                                                                    <span class="text-warning small"><i
                                                                            class="bi bi-star-fill"></i>
                                                                        ${c.rating}</span>
                                                                    <span
                                                                        class="badge bg-light text-muted border">${c.source}</span>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>

                                                    <!-- Cột 4: Gửi Offer (OFFER) -->
                                                    <div class="kanban-column" data-stage="OFFER"
                                                        ondragover="handleDragOver(event)"
                                                        ondragleave="handleDragLeave(event)"
                                                        ondrop="handleDrop(event, 'OFFER')">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center px-1 mb-2">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <span class="badge-dot-indicator bg-info"></span>
                                                                <span class="fw-bold text-dark"
                                                                    style="font-size: 0.84rem;">Gửi Offer</span>
                                                            </div>
                                                            <span
                                                                class="badge bg-light text-muted border kanban-stage-badge"
                                                                id="badgeCountOFFER">${listOffer.size()}</span>
                                                        </div>

                                                        <c:forEach items="${listOffer}" var="c">
                                                            <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}"
                                                                draggable="true" ondragstart="handleDragStart(event)"
                                                                ondragend="handleDragEnd(event)"
                                                                onclick="selectCandidateCard(this)" data-id="${c.id}"
                                                                data-code="${c.candidateCode}" data-name="${c.fullName}"
                                                                data-email="${c.email}" data-phone="${c.phone}"
                                                                data-job="${c.jobTitle}" data-source="${c.source}"
                                                                data-stage="${c.stage}" data-exp="${c.experienceYears}"
                                                                data-salary="${c.formattedSalary}"
                                                                data-score="${c.aiMatchScore}" data-rating="${c.rating}"
                                                                data-avatar="${c.avatarInitials}"
                                                                data-skills="${c.skills}"
                                                                data-matched="${c.aiMatchedSkills}"
                                                                data-missing="${c.aiMissingSkills}"
                                                                data-rec="${c.aiRecommendation}"
                                                                data-edu="${c.education}" data-work="${c.workHistory}">

                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <span
                                                                        class="badge bg-info-subtle text-info">${c.jobTitle}</span>
                                                                    <span class="badge bg-primary text-white">Offer:
                                                                        ${c.formattedSalary}</span>
                                                                </div>
                                                                <div class="fw-bold text-dark"
                                                                    style="font-size: 0.9rem;">${c.fullName}</div>
                                                                <div class="text-muted small mb-2">${c.skills}</div>
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center pt-2 border-top">
                                                                    <span class="text-warning small"><i
                                                                            class="bi bi-star-fill"></i>
                                                                        ${c.rating}</span>
                                                                    <span
                                                                        class="badge bg-light text-muted border">${c.source}</span>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>

                                                    <!-- Cột 5: Đã nhận việc (ONBOARDED) -->
                                                    <div class="kanban-column" data-stage="ONBOARDED"
                                                        ondragover="handleDragOver(event)"
                                                        ondragleave="handleDragLeave(event)"
                                                        ondrop="handleDrop(event, 'ONBOARDED')">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center px-1 mb-2">
                                                            <div class="d-flex align-items-center gap-2">
                                                                <span class="badge-dot-indicator bg-success"></span>
                                                                <span class="fw-bold text-dark"
                                                                    style="font-size: 0.84rem;">Đã nhận việc</span>
                                                            </div>
                                                            <span class="badge bg-success text-white kanban-stage-badge"
                                                                id="badgeCountONBOARDED">${listOnboarded.size()}</span>
                                                        </div>

                                                        <c:forEach items="${listOnboarded}" var="c">
                                                            <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}"
                                                                draggable="true" ondragstart="handleDragStart(event)"
                                                                ondragend="handleDragEnd(event)"
                                                                onclick="selectCandidateCard(this)" data-id="${c.id}"
                                                                data-code="${c.candidateCode}" data-name="${c.fullName}"
                                                                data-email="${c.email}" data-phone="${c.phone}"
                                                                data-job="${c.jobTitle}" data-source="${c.source}"
                                                                data-stage="${c.stage}" data-exp="${c.experienceYears}"
                                                                data-salary="${c.formattedSalary}"
                                                                data-score="${c.aiMatchScore}" data-rating="${c.rating}"
                                                                data-avatar="${c.avatarInitials}"
                                                                data-skills="${c.skills}"
                                                                data-matched="${c.aiMatchedSkills}"
                                                                data-missing="${c.aiMissingSkills}"
                                                                data-rec="${c.aiRecommendation}"
                                                                data-edu="${c.education}" data-work="${c.workHistory}">

                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <span
                                                                        class="badge bg-success-subtle text-success">${c.jobTitle}</span>
                                                                    <span class="badge bg-success text-white">Thành
                                                                        công</span>
                                                                </div>
                                                                <div class="fw-bold text-dark"
                                                                    style="font-size: 0.9rem;">${c.fullName}</div>
                                                                <div class="text-muted small mb-2">${c.skills}</div>
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center pt-2 border-top">
                                                                    <span class="text-warning small"><i
                                                                            class="bi bi-star-fill"></i>
                                                                        ${c.rating}</span>
                                                                    <span
                                                                        class="badge bg-light text-muted border">${c.source}</span>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>

                                                <!-- TABLE VIEW CONTAINER (Default hidden) -->
                                                <div id="tableCandidateContainer"
                                                    class="card border-0 shadow-sm rounded-3 overflow-hidden mb-4"
                                                    style="display: none;">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover align-middle mb-0 text-nowrap"
                                                            id="candTable" style="font-size: 0.83rem;">
                                                            <thead class="table-light">
                                                                <tr>
                                                                    <th class="ps-3">Mã UV</th>
                                                                    <th>Họ tên ứng viên</th>
                                                                    <th>Vị trí ứng tuyển</th>
                                                                    <th>Giai đoạn</th>
                                                                    <th class="text-center">AI Score</th>
                                                                    <th>Nguồn</th>
                                                                    <th class="pe-3 text-end">Lương mong muốn</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${candidates}" var="c">
                                                                    <tr style="cursor: pointer;" data-id="${c.id}"
                                                                        onclick="selectCandidateById(this.getAttribute('data-id'))">
                                                                        <td
                                                                            class="ps-3 fw-bold font-monospace text-primary">
                                                                            ${c.candidateCode}</td>
                                                                        <td class="fw-bold text-dark">${c.fullName}</td>
                                                                        <td><span
                                                                                class="badge bg-light text-dark border">${c.jobTitle}</span>
                                                                        </td>
                                                                        <td>
                                                                            <span
                                                                                class="badge ${c.stage eq 'ONBOARDED' ? 'bg-success' : (c.stage eq 'OFFER' ? 'bg-info' : (c.stage eq 'INTERVIEW' ? 'bg-warning text-dark' : 'bg-primary-subtle text-primary'))}">
                                                                                ${c.stage}
                                                                            </span>
                                                                        </td>
                                                                        <td class="text-center fw-bold text-success">
                                                                            ${c.aiMatchScore}%</td>
                                                                        <td><span
                                                                                class="badge bg-light text-muted border">${c.source}</span>
                                                                        </td>
                                                                        <td class="pe-3 text-end">
                                                                            <div
                                                                                class="d-flex align-items-center justify-content-end gap-2">
                                                                                <span
                                                                                    class="fw-bold text-dark">${c.formattedSalary}</span>
                                                                                <c:if
                                                                                    test="${c.stage eq 'OFFER' or c.stage eq 'ONBOARDED' or c.stage eq 'OFFER_ACCEPTED' or c.stage eq 'HIRED'}">
                                                                                    <a href="${pageContext.request.contextPath}/employees?action=new&candidateId=${c.id}"
                                                                                        class="btn btn-sm btn-outline-success py-0 px-2 fw-bold d-inline-flex align-items-center gap-1 shadow-xs"
                                                                                        style="font-size:0.75rem; border-radius:6px;"
                                                                                        title="Tiếp nhận hồ sơ nhân sự chính thức"
                                                                                        onclick="event.stopPropagation();">
                                                                                        <i
                                                                                            class="bi bi-person-check-fill"></i>
                                                                                        Biên chế
                                                                                    </a>
                                                                                </c:if>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Col-5: Candidate Detail Drawer -->
                                            <div class="col-12 col-xl-5">
                                                <div class="candidate-detail-drawer">
                                                    <!-- Candidate Header with Avatar & Rating -->
                                                    <div
                                                        class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="position-relative">
                                                                <div id="drawerAvatarInitials"
                                                                    class="avatar-circle bg-primary text-white fw-bold"
                                                                    style="width: 52px; height: 52px; font-size: 1.15rem;">
                                                                    ${selectedCandidate.avatarInitials != null ?
                                                                    selectedCandidate.avatarInitials : 'LN'}
                                                                </div>
                                                                <span
                                                                    class="position-absolute bottom-0 end-0 bg-success text-white rounded-circle p-1"
                                                                    style="font-size: 0.6rem;">
                                                                    <i class="bi bi-check-lg"></i>
                                                                </span>
                                                            </div>
                                                            <div>
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <h3 id="drawerName"
                                                                        class="h5 fw-bold text-dark mb-0">
                                                                        ${selectedCandidate.fullName}</h3>
                                                                    <span id="drawerCode"
                                                                        class="badge bg-primary-subtle text-primary font-monospace">${selectedCandidate.candidateCode}</span>
                                                                </div>
                                                                <div id="drawerJobTitle"
                                                                    class="text-primary fw-semibold"
                                                                    style="font-size: 0.86rem;">
                                                                    ${selectedCandidate.jobTitle}</div>
                                                                <div
                                                                    class="d-flex align-items-center gap-2 text-warning small mt-1">
                                                                    <span>⭐⭐⭐⭐⭐</span>
                                                                    <strong id="drawerRating"
                                                                        class="text-dark">${selectedCandidate.rating}</strong>
                                                                    <span class="text-muted">(Điểm AI: <strong
                                                                            id="drawerAiScoreText">${selectedCandidate.aiMatchScore}%</strong>)</span>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <a href="#" class="text-muted" title="Mở trang hồ sơ riêng"><i
                                                                class="bi bi-box-arrow-up-right fs-5"></i></a>
                                                    </div>

                                                    <!-- 3 Action Buttons -->
                                                    <div class="row g-2 mb-3">
                                                        <div class="col-4">
                                                            <button type="button"
                                                                class="btn btn-primary btn-sm w-100 d-flex align-items-center justify-content-center gap-1 shadow-sm"
                                                                data-bs-toggle="modal" data-bs-target="#sendOfferModal">
                                                                <i class="bi bi-envelope-paper"></i> Gửi thư Offer
                                                            </button>
                                                        </div>
                                                        <div class="col-4">
                                                            <button type="button"
                                                                class="btn btn-outline-secondary btn-sm w-100 d-flex align-items-center justify-content-center gap-1"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#scheduleCandInterviewModal">
                                                                <i class="bi bi-calendar-plus"></i> Lên lịch tiếp
                                                            </button>
                                                        </div>
                                                        <div class="col-4">
                                                            <form method="POST"
                                                                action="${pageContext.request.contextPath}/recruitment"
                                                                class="m-0"
                                                                onsubmit="return confirm('Bạn có chắc chắn muốn chuyển ứng viên này vào danh sách Từ chối hồ sơ?')">
                                                                <input type="hidden" name="action" value="update_stage">
                                                                <input type="hidden" name="candidateId"
                                                                    id="drawerCandidateIdInput"
                                                                    value="${selectedCandidate.id}">
                                                                <input type="hidden" name="stage" value="REJECTED">
                                                                <button type="submit"
                                                                    class="btn btn-outline-danger btn-sm w-100 d-flex align-items-center justify-content-center gap-1">
                                                                    <i class="bi bi-person-x"></i> Từ chối hồ sơ
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>

                                                    <!-- 1-Click Hire Onboarding Banner & Button -->
                                                    <c:choose>
                                                        <c:when
                                                            test="${selectedCandidate.stage eq 'OFFER' or selectedCandidate.stage eq 'ONBOARDED' or selectedCandidate.stage eq 'OFFER_ACCEPTED' or selectedCandidate.stage eq 'HIRED'}">
                                                            <div class="mb-3" id="drawerHireContainer">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="mb-3" id="drawerHireContainer"
                                                                style="display:none;">
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div
                                                        class="p-2 px-3 bg-success-subtle border border-success-subtle rounded-3 d-flex align-items-center justify-content-between mb-2">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <i class="bi bi-patch-check-fill text-success fs-5"></i>
                                                            <div style="font-size:0.8rem;"
                                                                class="text-success-emphasis fw-semibold">Ứng viên đã
                                                                đạt vòng tuyển dụng</div>
                                                        </div>
                                                        <span class="badge bg-success text-white">Sẵn sàng nhận
                                                            việc</span>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/employees?action=new&candidateId=${selectedCandidate.id}"
                                                        id="drawerHireBtn"
                                                        class="btn btn-success btn-sm w-100 py-2 d-flex align-items-center justify-content-center gap-2 fw-bold shadow-sm"
                                                        style="border-radius: 8px;">
                                                        <i class="bi bi-person-check-fill fs-6"></i>
                                                        <span>Tiếp nhận vào biên chế (1-Click Onboard)</span>
                                                    </a>
                                                </div>

                                                <!-- Contact Grid -->
                                                <div class="row g-2 mb-3" style="font-size: 0.8rem;">
                                                    <div class="col-6">
                                                        <span class="text-muted"><i
                                                                class="bi bi-envelope me-1"></i>Email:</span>
                                                        <strong id="drawerEmail"
                                                            class="text-dark ms-1">${selectedCandidate.email}</strong>
                                                    </div>
                                                    <div class="col-6">
                                                        <span class="text-muted"><i
                                                                class="bi bi-telephone me-1"></i>Điện thoại:</span>
                                                        <strong id="drawerPhone"
                                                            class="text-dark ms-1">${selectedCandidate.phone}</strong>
                                                    </div>
                                                    <div class="col-6">
                                                        <span class="text-muted"><i class="bi bi-geo-alt me-1"></i>Địa
                                                            chỉ:</span>
                                                        <span class="text-dark ms-1">Hà Nội</span>
                                                    </div>
                                                    <div class="col-6">
                                                        <span class="text-muted"><i
                                                                class="bi bi-link-45deg me-1"></i>Nguồn:</span>
                                                        <span id="drawerSource"
                                                            class="badge bg-light text-primary border ms-1">${selectedCandidate.source}</span>
                                                    </div>
                                                </div>

                                                <!-- CV Attachment Card with Working AI Screener -->
                                                <div
                                                    class="p-2 px-3 bg-light border rounded-3 d-flex justify-content-between align-items-center mb-3">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="bi bi-file-earmark-pdf-fill text-danger fs-4"></i>
                                                        <div>
                                                            <div id="drawerCvFileName" class="fw-bold text-dark"
                                                                style="font-size: 0.83rem;">
                                                                ${selectedCandidate != null ?
                                                                selectedCandidate.cvFileName : 'CV_Ung_Vien.pdf'}
                                                            </div>
                                                            <small class="text-muted">2.4 MB • Đã tải lên hệ
                                                                thống</small>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex gap-2">
                                                        <button
                                                            class="btn btn-sm btn-purple text-purple border-purple fw-semibold py-1 px-2"
                                                            style="background: #f3e8ff; color: #7e22ce; border-color: #d8b4fe;"
                                                            data-bs-toggle="modal" data-bs-target="#aiCvAnalysisModal"
                                                            title="AI Đọc & Phân Tích CV">
                                                            <i class="bi bi-stars me-1"></i> AI Đọc CV
                                                        </button>
                                                        <button class="btn btn-sm btn-light border py-1 px-2"
                                                            title="Xem trước"
                                                            onclick="alert('Đang hiển thị chế độ xem nhanh tệp CV PDF của ứng viên.')"><i
                                                                class="bi bi-eye"></i></button>
                                                        <button class="btn btn-sm btn-light border py-1 px-2"
                                                            title="Tải xuống"
                                                            onclick="alert('Đã tải xuống tệp CV của ứng viên.')"><i
                                                                class="bi bi-download"></i></button>
                                                    </div>
                                                </div>

                                                <!-- AI CV Insights Summary -->
                                                <div class="ai-insight-box mb-3">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <span class="ai-sparkle-badge"><i class="bi bi-robot"></i> KẾT
                                                            QUẢ AI ĐỌC & ĐÁNH GIÁ CV</span>
                                                        <span id="drawerAiScoreBadge"
                                                            class="badge bg-success text-white fw-bold">${selectedCandidate.aiMatchScore}%
                                                            MATCH</span>
                                                    </div>
                                                    <div id="drawerAiRecommendation" class="small text-dark mb-2"
                                                        style="font-size: 0.78rem;">
                                                        <strong>Đánh giá của AI:</strong>
                                                        ${selectedCandidate.aiRecommendation}
                                                    </div>
                                                    <div class="progress mb-2" style="height: 6px;">
                                                        <c:set var="drawerProgressStyle" value="style=\" width:
                                                            ${selectedCandidate.aiMatchScore}%;\"" />
                                                        <div id="drawerAiProgressBar"
                                                            class="progress-bar ai-match-progress-bar"
                                                            ${drawerProgressStyle}></div>
                                                    </div>
                                                    <div class="d-flex justify-content-between text-muted"
                                                        style="font-size: 0.72rem;">
                                                        <span>✔ Kinh nghiệm: <strong
                                                                id="drawerExp">${selectedCandidate.experienceYears}
                                                                năm</strong></span>
                                                        <span>✔ Lương kỳ vọng: <strong
                                                                id="drawerExpectedSalary">${selectedCandidate.formattedSalary}</strong></span>
                                                        <span class="text-success fw-bold">✔ Khuyến nghị: Ưu tiên</span>
                                                    </div>
                                                </div>

                                                <!-- Education & Experience -->
                                                <div class="mb-3">
                                                    <div class="fw-bold text-dark small text-uppercase mb-1">HỌC VẤN &
                                                        KINH NGHIỆM</div>
                                                    <div class="d-flex align-items-center gap-2 small text-dark mb-1">
                                                        <i class="bi bi-mortarboard text-primary"></i>
                                                        <span id="drawerEdu">${selectedCandidate.education}</span>
                                                    </div>
                                                    <div class="d-flex align-items-center gap-2 small text-dark">
                                                        <i class="bi bi-briefcase text-primary"></i>
                                                        <span id="drawerWork">${selectedCandidate.workHistory}</span>
                                                    </div>
                                                </div>

                                                <!-- Skill Tags -->
                                                <div class="mb-3">
                                                    <div class="fw-bold text-dark small text-uppercase mb-1">KỸ NĂNG CỐT
                                                        LÕI (AI DETECTED)</div>
                                                    <div id="drawerSkillsTags" class="d-flex flex-wrap gap-1">
                                                        <c:forEach items="${selectedCandidate.skillList}" var="sk">
                                                            <span class="badge bg-light text-dark border">${sk}</span>
                                                        </c:forEach>
                                                    </div>
                                                </div>

                                                <!-- Evaluation History -->
                                                <div class="mb-3">
                                                    <div class="fw-bold text-dark small text-uppercase mb-2">LỊCH SỬ
                                                        ĐÁNH GIÁ VÒNG TUYỂN</div>
                                                    <div class="p-2 px-3 border rounded-2 bg-light mb-2"
                                                        style="font-size: 0.78rem;">
                                                        <div
                                                            class="d-flex justify-content-between align-items-center mb-1">
                                                            <span class="fw-bold text-dark">Vòng 1: HR Screener & Văn
                                                                hóa</span>
                                                            <span class="badge bg-success-subtle text-success">8.5 / 10
                                                                • Đạt</span>
                                                        </div>
                                                        <div class="text-muted fst-italic">"Giao tiếp tự tin, phong thái
                                                            điềm đạm, định hướng gắn bó lâu dài."</div>
                                                        <div class="text-end text-muted small mt-1">Đánh giá bởi:
                                                            <strong>Phạm Phương Thảo (HR Lead)</strong></div>
                                                    </div>
                                                </div>

                                                <!-- Offer Proposal Card -->
                                                <div
                                                    class="p-3 bg-primary-subtle bg-opacity-25 border border-primary-subtle rounded-3">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <span class="fw-bold text-primary small text-uppercase">THÔNG
                                                            TIN GÓI OFFER ĐỀ XUẤT</span>
                                                        <i class="bi bi-cash-stack text-primary fs-5"></i>
                                                    </div>
                                                    <div class="row g-2 mb-2">
                                                        <div class="col-6">
                                                            <small class="text-muted d-block">Mức lương đề xuất</small>
                                                            <span id="drawerOfferSalary"
                                                                class="fw-bold text-primary fs-5">${selectedCandidate.formattedSalary}</span>
                                                        </div>
                                                        <div class="col-6">
                                                            <small class="text-muted d-block">Ngày dự kiến
                                                                Onboard</small>
                                                            <span class="fw-bold text-dark fs-6">15/10/2026</span>
                                                        </div>
                                                    </div>
                                                    <div class="small text-muted border-top pt-2">
                                                        <i class="bi bi-info-circle text-primary me-1"></i>
                                                        Bao gồm 100% lương thử việc, bảo hiểm sức khỏe Bảo Việt & 14
                                                        ngày phép/năm.
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                            </div>
                            </main>

                            <!-- Footer -->
                            <%@ include file="/WEB-INF/views/common/footer.jsp" %>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý hồ sơ, tài liệu đánh giá và tiến trình tự động của ứng viên theo chuẩn 5 giai đoạn chiến lược.
                    </p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/recruitment?action=export_report" class="btn btn-outline-secondary d-flex align-items-center gap-2 text-decoration-none">
                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Xuất danh sách (Excel)</span>
                    </a>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#candAdvancedFilterModal">
                        <i class="bi bi-sliders"></i>
                        <span>Lọc nâng cao</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#addCandidateModal">
                        <i class="bi bi-person-plus-fill"></i>
                        <span>Thêm ứng viên</span>
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
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${totalCandCount != null ? totalCandCount : candidates.size()}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Đang chạy trong ${jobs.size()} vị trí chiến lược</span>
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
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${newCandCount != null ? newCandCount : listNew.size() + listScreening.size()}</span>
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
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${interviewCandCount != null ? interviewCandCount : listInterview.size()}</span>
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
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">${onboardedCandCount != null ? onboardedCandCount : listOnboarded.size()}</span>
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
                    <form id="candFilterForm" method="GET" action="${pageContext.request.contextPath}/recruitment">
                        <input type="hidden" name="view" value="candidates">
                        <div class="row g-2 align-items-center">
                            <div class="col-12 col-md-4">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                    <input type="text" id="candSearchInput" name="search" class="form-control border-start-0" 
                                           placeholder="Tìm theo tên, email, mã ứng viên..." value="${searchKeyword}">
                                </div>
                            </div>
                            <div class="col-6 col-md-2">
                                <select class="form-select form-select-sm" name="requestId" onchange="document.getElementById('candFilterForm').submit()">
                                    <option value="">Tất cả vị trí (${jobs.size()})</option>
                                    <c:forEach items="${jobs}" var="j">
                                        <option value="${j.id}" ${selectedRequestId == j.id ? 'selected' : ''}>${j.title}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-6 col-md-2">
                                <select class="form-select form-select-sm" name="stage" onchange="document.getElementById('candFilterForm').submit()">
                                    <option value="">Tất cả giai đoạn (5)</option>
                                    <option value="NEW" ${selectedStage eq 'NEW' ? 'selected' : ''}>Mới nộp (${listNew.size()})</option>
                                    <option value="SCREENING" ${selectedStage eq 'SCREENING' ? 'selected' : ''}>Sàng lọc CV (${listScreening.size()})</option>
                                    <option value="INTERVIEW" ${selectedStage eq 'INTERVIEW' ? 'selected' : ''}>Phỏng vấn (${listInterview.size()})</option>
                                    <option value="OFFER" ${selectedStage eq 'OFFER' ? 'selected' : ''}>Đề xuất Offer (${listOffer.size()})</option>
                                    <option value="ONBOARDED" ${selectedStage eq 'ONBOARDED' ? 'selected' : ''}>Đã nhận việc (${listOnboarded.size()})</option>
                                </select>
                            </div>
                            <div class="col-6 col-md-2">
                                <select class="form-select form-select-sm" name="source" onchange="document.getElementById('candFilterForm').submit()">
                                    <option value="">Nguồn ứng viên: Tất cả</option>
                                    <option value="LinkedIn" ${selectedSource eq 'LinkedIn' ? 'selected' : ''}>LinkedIn</option>
                                    <option value="TopCV/VNW" ${selectedSource eq 'TopCV/VNW' ? 'selected' : ''}>TopCV / VietnamWorks</option>
                                    <option value="Nội bộ (Ref)" ${selectedSource eq 'Nội bộ (Ref)' ? 'selected' : ''}>Nội bộ (Ref)</option>
                                    <option value="Khác" ${selectedSource eq 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                            <div class="col-6 col-md-2 d-flex justify-content-end gap-1">
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-primary" id="btnKanbanMode" onclick="switchCandidateView('kanban')" title="Chế độ Kanban">
                                        <i class="bi bi-kanban"></i>
                                        <span class="d-none d-sm-inline ms-1">Kanban</span>
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" id="btnTableMode" onclick="switchCandidateView('table')" title="Chế độ Bảng">
                                        <i class="bi bi-list-ul"></i>
                                        <span class="d-none d-sm-inline ms-1">Bảng</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Two-Column Layout: Kanban Board / Table + Candidate Detail Drawer -->
            <div class="row g-3">
                <!-- Col-7/8: Kanban Board Pipeline OR Table -->
                <div class="col-12 col-xl-7 col-xxl-8">
                    
                    <!-- KANBAN BOARD CONTAINER -->
                    <div id="kanbanBoardWrapper" class="kanban-board-wrapper">
                        
                        <!-- Cột 1: Mới nộp (NEW) -->
                        <div class="kanban-column" data-stage="NEW" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" ondrop="handleDrop(event, 'NEW')">
                            <div class="d-flex justify-content-between align-items-center px-1 mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge-dot-indicator bg-primary"></span>
                                    <span class="fw-bold text-dark" style="font-size: 0.84rem;">Mới nộp</span>
                                </div>
                                <span class="badge bg-light text-muted border kanban-stage-badge" id="badgeCountNEW">${listNew.size()}</span>
                            </div>

                            <c:forEach items="${listNew}" var="c">
                                <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}" 
                                     draggable="true" 
                                     ondragstart="handleDragStart(event)" 
                                     ondragend="handleDragEnd(event)"
                                     onclick="selectCandidateCard(this)"
                                     data-id="${c.id}"
                                     data-code="${c.candidateCode}"
                                     data-name="${c.fullName}"
                                     data-email="${c.email}"
                                     data-phone="${c.phone}"
                                     data-job="${c.jobTitle}"
                                     data-source="${c.source}"
                                     data-stage="${c.stage}"
                                     data-exp="${c.experienceYears}"
                                     data-salary="${c.formattedSalary}"
                                     data-score="${c.aiMatchScore}"
                                     data-rating="${c.rating}"
                                     data-avatar="${c.avatarInitials}"
                                     data-skills="${c.skills}"
                                     data-matched="${c.aiMatchedSkills}"
                                     data-missing="${c.aiMissingSkills}"
                                     data-rec="${c.aiRecommendation}"
                                     data-edu="${c.education}"
                                     data-work="${c.workHistory}">
                                    
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-primary-subtle text-primary">${c.jobTitle}</span>
                                        <small class="text-muted">${c.formattedAppliedDate}</small>
                                    </div>
                                    <div class="fw-bold text-dark" style="font-size: 0.9rem;">${c.fullName}</div>
                                    <div class="text-muted small mb-2">${c.skills}</div>
                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                        <span class="text-warning small"><i class="bi bi-star-fill"></i> ${c.rating}</span>
                                        <span class="badge bg-light text-muted border">${c.source}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Cột 2: Sàng lọc CV (SCREENING) -->
                        <div class="kanban-column" data-stage="SCREENING" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" ondrop="handleDrop(event, 'SCREENING')">
                            <div class="d-flex justify-content-between align-items-center px-1 mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge-dot-indicator bg-info"></span>
                                    <span class="fw-bold text-dark" style="font-size: 0.84rem;">Sàng lọc CV</span>
                                </div>
                                <span class="badge bg-light text-muted border kanban-stage-badge" id="badgeCountSCREENING">${listScreening.size()}</span>
                            </div>

                            <c:forEach items="${listScreening}" var="c">
                                <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}" 
                                     draggable="true" 
                                     ondragstart="handleDragStart(event)" 
                                     ondragend="handleDragEnd(event)"
                                     onclick="selectCandidateCard(this)"
                                     data-id="${c.id}"
                                     data-code="${c.candidateCode}"
                                     data-name="${c.fullName}"
                                     data-email="${c.email}"
                                     data-phone="${c.phone}"
                                     data-job="${c.jobTitle}"
                                     data-source="${c.source}"
                                     data-stage="${c.stage}"
                                     data-exp="${c.experienceYears}"
                                     data-salary="${c.formattedSalary}"
                                     data-score="${c.aiMatchScore}"
                                     data-rating="${c.rating}"
                                     data-avatar="${c.avatarInitials}"
                                     data-skills="${c.skills}"
                                     data-matched="${c.aiMatchedSkills}"
                                     data-missing="${c.aiMissingSkills}"
                                     data-rec="${c.aiRecommendation}"
                                     data-edu="${c.education}"
                                     data-work="${c.workHistory}">
                                    
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-purple-subtle text-purple" style="background: #f3e8ff; color: #7e22ce;">${c.jobTitle}</span>
                                        <span class="badge bg-success-subtle text-success">AI Match: ${c.aiMatchScore}%</span>
                                    </div>
                                    <div class="fw-bold text-dark" style="font-size: 0.9rem;">${c.fullName}</div>
                                    <div class="text-muted small mb-2">${c.skills}</div>
                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                        <span class="text-warning small"><i class="bi bi-star-fill"></i> ${c.rating}</span>
                                        <span class="badge bg-light text-muted border">${c.source}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Cột 3: Phỏng vấn (INTERVIEW) -->
                        <div class="kanban-column" data-stage="INTERVIEW" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" ondrop="handleDrop(event, 'INTERVIEW')">
                            <div class="d-flex justify-content-between align-items-center px-1 mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge-dot-indicator bg-warning"></span>
                                    <span class="fw-bold text-dark" style="font-size: 0.84rem;">Phỏng vấn</span>
                                </div>
                                <span class="badge bg-light text-muted border kanban-stage-badge" id="badgeCountINTERVIEW">${listInterview.size()}</span>
                            </div>

                            <c:forEach items="${listInterview}" var="c">
                                <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}" 
                                     draggable="true" 
                                     ondragstart="handleDragStart(event)" 
                                     ondragend="handleDragEnd(event)"
                                     onclick="selectCandidateCard(this)"
                                     data-id="${c.id}"
                                     data-code="${c.candidateCode}"
                                     data-name="${c.fullName}"
                                     data-email="${c.email}"
                                     data-phone="${c.phone}"
                                     data-job="${c.jobTitle}"
                                     data-source="${c.source}"
                                     data-stage="${c.stage}"
                                     data-exp="${c.experienceYears}"
                                     data-salary="${c.formattedSalary}"
                                     data-score="${c.aiMatchScore}"
                                     data-rating="${c.rating}"
                                     data-avatar="${c.avatarInitials}"
                                     data-skills="${c.skills}"
                                     data-matched="${c.aiMatchedSkills}"
                                     data-missing="${c.aiMissingSkills}"
                                     data-rec="${c.aiRecommendation}"
                                     data-edu="${c.education}"
                                     data-work="${c.workHistory}">
                                    
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-warning-subtle text-warning-emphasis">${c.jobTitle}</span>
                                        <small class="text-muted"><i class="bi bi-calendar2-check text-primary me-1"></i>PV</small>
                                    </div>
                                    <div class="fw-bold text-dark" style="font-size: 0.9rem;">${c.fullName}</div>
                                    <div class="text-muted small mb-2">${c.skills}</div>
                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                        <span class="text-warning small"><i class="bi bi-star-fill"></i> ${c.rating}</span>
                                        <span class="badge bg-light text-muted border">${c.source}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Cột 4: Gửi Offer (OFFER) -->
                        <div class="kanban-column" data-stage="OFFER" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" ondrop="handleDrop(event, 'OFFER')">
                            <div class="d-flex justify-content-between align-items-center px-1 mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge-dot-indicator bg-info"></span>
                                    <span class="fw-bold text-dark" style="font-size: 0.84rem;">Gửi Offer</span>
                                </div>
                                <span class="badge bg-light text-muted border kanban-stage-badge" id="badgeCountOFFER">${listOffer.size()}</span>
                            </div>

                            <c:forEach items="${listOffer}" var="c">
                                <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}" 
                                     draggable="true" 
                                     ondragstart="handleDragStart(event)" 
                                     ondragend="handleDragEnd(event)"
                                     onclick="selectCandidateCard(this)"
                                     data-id="${c.id}"
                                     data-code="${c.candidateCode}"
                                     data-name="${c.fullName}"
                                     data-email="${c.email}"
                                     data-phone="${c.phone}"
                                     data-job="${c.jobTitle}"
                                     data-source="${c.source}"
                                     data-stage="${c.stage}"
                                     data-exp="${c.experienceYears}"
                                     data-salary="${c.formattedSalary}"
                                     data-score="${c.aiMatchScore}"
                                     data-rating="${c.rating}"
                                     data-avatar="${c.avatarInitials}"
                                     data-skills="${c.skills}"
                                     data-matched="${c.aiMatchedSkills}"
                                     data-missing="${c.aiMissingSkills}"
                                     data-rec="${c.aiRecommendation}"
                                     data-edu="${c.education}"
                                     data-work="${c.workHistory}">
                                    
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-info-subtle text-info">${c.jobTitle}</span>
                                        <span class="badge bg-primary text-white">Offer: ${c.formattedSalary}</span>
                                    </div>
                                    <div class="fw-bold text-dark" style="font-size: 0.9rem;">${c.fullName}</div>
                                    <div class="text-muted small mb-2">${c.skills}</div>
                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                        <span class="text-warning small"><i class="bi bi-star-fill"></i> ${c.rating}</span>
                                        <span class="badge bg-light text-muted border">${c.source}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Cột 5: Đã nhận việc (ONBOARDED) -->
                        <div class="kanban-column" data-stage="ONBOARDED" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" ondrop="handleDrop(event, 'ONBOARDED')">
                            <div class="d-flex justify-content-between align-items-center px-1 mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge-dot-indicator bg-success"></span>
                                    <span class="fw-bold text-dark" style="font-size: 0.84rem;">Đã nhận việc</span>
                                </div>
                                <span class="badge bg-success text-white kanban-stage-badge" id="badgeCountONBOARDED">${listOnboarded.size()}</span>
                            </div>

                            <c:forEach items="${listOnboarded}" var="c">
                                <div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}" 
                                     draggable="true" 
                                     ondragstart="handleDragStart(event)" 
                                     ondragend="handleDragEnd(event)"
                                     onclick="selectCandidateCard(this)"
                                     data-id="${c.id}"
                                     data-code="${c.candidateCode}"
                                     data-name="${c.fullName}"
                                     data-email="${c.email}"
                                     data-phone="${c.phone}"
                                     data-job="${c.jobTitle}"
                                     data-source="${c.source}"
                                     data-stage="${c.stage}"
                                     data-exp="${c.experienceYears}"
                                     data-salary="${c.formattedSalary}"
                                     data-score="${c.aiMatchScore}"
                                     data-rating="${c.rating}"
                                     data-avatar="${c.avatarInitials}"
                                     data-skills="${c.skills}"
                                     data-matched="${c.aiMatchedSkills}"
                                     data-missing="${c.aiMissingSkills}"
                                     data-rec="${c.aiRecommendation}"
                                     data-edu="${c.education}"
                                     data-work="${c.workHistory}">
                                    
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-success-subtle text-success">${c.jobTitle}</span>
                                        <span class="badge bg-success text-white">Thành công</span>
                                    </div>
                                    <div class="fw-bold text-dark" style="font-size: 0.9rem;">${c.fullName}</div>
                                    <div class="text-muted small mb-2">${c.skills}</div>
                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                        <span class="text-warning small"><i class="bi bi-star-fill"></i> ${c.rating}</span>
                                        <span class="badge bg-light text-muted border">${c.source}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- TABLE VIEW CONTAINER (Default hidden) -->
                    <div id="tableCandidateContainer" class="card border-0 shadow-sm rounded-3 overflow-hidden mb-4" style="display: none;">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 text-nowrap" id="candTable" style="font-size: 0.83rem;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3">Mã UV</th>
                                        <th>Họ tên ứng viên</th>
                                        <th>Vị trí ứng tuyển</th>
                                        <th>Giai đoạn</th>
                                        <th class="text-center">AI Score</th>
                                        <th>Nguồn</th>
                                        <th class="pe-3 text-end">Lương mong muốn</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${candidates}" var="c">
                                        <tr style="cursor: pointer;" onclick="selectCandidateById(${c.id})">
                                            <td class="ps-3 fw-bold font-monospace text-primary">${c.candidateCode}</td>
                                            <td class="fw-bold text-dark">${c.fullName}</td>
                                            <td><span class="badge bg-light text-dark border">${c.jobTitle}</span></td>
                                            <td>
                                                <span class="badge ${c.stage eq 'ONBOARDED' ? 'bg-success' : (c.stage eq 'OFFER' ? 'bg-info' : (c.stage eq 'INTERVIEW' ? 'bg-warning text-dark' : 'bg-primary-subtle text-primary'))}">
                                                    ${c.stage}
                                                </span>
                                            </td>
                                            <td class="text-center fw-bold text-success">${c.aiMatchScore}%</td>
                                            <td><span class="badge bg-light text-muted border">${c.source}</span></td>
                                            <td class="pe-3 text-end">
                                                <span class="fw-bold text-dark me-2">${c.formattedSalary}</span>
                                                <button type="button" class="btn btn-sm btn-outline-primary py-0 px-2 shadow-sm" onclick="event.stopPropagation(); openCandidateCvModalById(${c.id})" title="Xem trực tiếp bản mềm CV">
                                                    <i class="bi ${c.cvTypeIcon}"></i> Xem CV
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Col-5/4: Candidate Detail Drawer (Compact View) -->
                <div class="col-12 col-xl-5 col-xxl-4">
                    <div class="candidate-detail-drawer p-3 rounded-3 shadow-sm bg-white border">
                        <!-- Candidate Header with Avatar & Rating (Compact) -->
                        <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-2">
                            <div class="d-flex align-items-center gap-2">
                                <div class="position-relative">
                                    <div id="drawerAvatarInitials" class="avatar-circle bg-primary text-white fw-bold d-flex align-items-center justify-content-center rounded-circle" style="width: 40px; height: 40px; font-size: 0.95rem;">
                                        ${selectedCandidate.avatarInitials != null ? selectedCandidate.avatarInitials : 'LN'}
                                    </div>
                                    <span class="position-absolute bottom-0 end-0 bg-success text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 14px; height: 14px; font-size: 0.55rem;">
                                        <i class="bi bi-check-lg"></i>
                                    </span>
                                </div>
                                <div>
                                    <div class="d-flex align-items-center gap-1">
                                        <h3 id="drawerName" class="fw-bold text-dark mb-0" style="font-size: 0.95rem;">${selectedCandidate.fullName}</h3>
                                        <span id="drawerCode" class="badge bg-primary-subtle text-primary font-monospace py-0 px-1" style="font-size: 0.7rem;">${selectedCandidate.candidateCode}</span>
                                    </div>
                                    <div id="drawerJobTitle" class="text-primary fw-semibold" style="font-size: 0.78rem;">${selectedCandidate.jobTitle}</div>
                                    <div class="d-flex align-items-center gap-1 text-warning small" style="font-size: 0.72rem;">
                                        <span>★</span>
                                        <strong id="drawerRating" class="text-dark">${selectedCandidate.rating}</strong>
                                        <span class="text-muted">(AI: <strong id="drawerAiScoreText">${selectedCandidate.aiMatchScore}%</strong>)</span>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                            </div>

                            <a href="#" class="btn btn-sm btn-outline-light text-muted p-1 border-0" title="Mở trang hồ sơ riêng"><i class="bi bi-box-arrow-up-right fs-6"></i></a>
                        </div>

                        <!-- 3 Action Buttons (Compact) -->
                        <div class="row g-1 mb-2">
                            <div class="col-4">
                                <button type="button" class="btn btn-primary btn-sm w-100 py-1 px-1 d-flex align-items-center justify-content-center gap-1 shadow-sm" style="font-size: 0.76rem;" data-bs-toggle="modal" data-bs-target="#sendOfferModal">
                                    <i class="bi bi-envelope-paper"></i> Gửi Offer
                                </button>
                            </div>
                            <div class="col-4">
                                <button type="button" class="btn btn-outline-secondary btn-sm w-100 py-1 px-1 d-flex align-items-center justify-content-center gap-1" style="font-size: 0.76rem;" data-bs-toggle="modal" data-bs-target="#scheduleCandInterviewModal">
                                    <i class="bi bi-calendar-plus"></i> Lên lịch PV
                                </button>
                            </div>
                            <div class="col-4">
                                <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0" onsubmit="return confirm('Bạn có chắc chắn muốn chuyển ứng viên này vào danh sách Từ chối hồ sơ?')">
                                    <input type="hidden" name="action" value="update_stage">
                                    <input type="hidden" name="candidateId" id="drawerCandidateIdInput" value="${selectedCandidate.id}">
                                    <input type="hidden" name="stage" value="REJECTED">
                                    <button type="submit" class="btn btn-outline-danger btn-sm w-100 py-1 px-1 d-flex align-items-center justify-content-center gap-1" style="font-size: 0.76rem;">
                                        <i class="bi bi-person-x"></i> Từ chối
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Contact Grid (Compact) -->
                        <div class="p-2 bg-light border rounded-2 mb-2" style="font-size: 0.75rem;">
                            <div class="row g-1">
                                <div class="col-6 text-truncate">
                                    <span class="text-muted"><i class="bi bi-envelope me-1"></i></span>
                                    <strong id="drawerEmail" class="text-dark">${selectedCandidate.email}</strong>
                                </div>
                                <div class="col-6 text-truncate">
                                    <span class="text-muted"><i class="bi bi-telephone me-1"></i></span>
                                    <strong id="drawerPhone" class="text-dark">${selectedCandidate.phone}</strong>
                                </div>
                                <div class="col-6 text-truncate">
                                    <span class="text-muted"><i class="bi bi-geo-alt me-1"></i></span>
                                    <span class="text-dark">Hà Nội</span>
                                </div>
                                <div class="col-6 text-truncate">
                                    <span class="text-muted"><i class="bi bi-link-45deg me-1"></i></span>
                                    <span id="drawerSource" class="badge bg-white text-primary border py-0 px-1">${selectedCandidate.source}</span>
                                </div>
                            </div>
                        </div>

                        <!-- CV Attachment Card (Compact) -->
                        <div class="p-2 bg-light border rounded-2 d-flex justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center gap-2 text-truncate me-1">
                                <i class="bi bi-file-earmark-pdf-fill text-danger fs-5"></i>
                                <div class="text-truncate">
                                    <div id="drawerCvFileName" class="fw-bold text-dark text-truncate" style="font-size: 0.78rem;">
                                        ${selectedCandidate != null ? selectedCandidate.cvFileName : 'CV_Ung_Vien.pdf'}
                                    </div>
                                    <small class="text-muted" style="font-size: 0.68rem;">2.4 MB • Sẵn sàng</small>
                                </div>
                            </div>
                            <div class="d-flex gap-1 flex-shrink-0">
                                <button class="btn btn-sm btn-purple text-purple border-purple fw-semibold py-0 px-2"
                                        style="background: #f3e8ff; color: #7e22ce; border-color: #d8b4fe; font-size: 0.74rem;"
                                        data-bs-toggle="modal" data-bs-target="#aiCvAnalysisModal"
                                        title="AI Đọc & Phân Tích CV">
                                    <i class="bi bi-stars"></i> AI Đọc
                                </button>
                                <button class="btn btn-sm btn-outline-primary py-0 px-2 fw-semibold shadow-sm" style="font-size: 0.74rem;" title="Xem trực tiếp bản mềm CV" onclick="openCurrentDrawerCandidateCv()"><i class="bi bi-eye"></i> Xem</button>
                                <button class="btn btn-sm btn-light border py-0 px-2" style="font-size: 0.74rem;" title="Tải xuống CV" onclick="downloadCurrentDrawerCandidateCv()"><i class="bi bi-download"></i></button>
                            </div>
                        </div>

                        <!-- AI CV Insights Summary (Compact) -->
                        <div class="ai-insight-box p-2 mb-2 rounded-2" style="font-size: 0.76rem;">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="ai-sparkle-badge" style="font-size: 0.68rem; padding: 2px 6px;"><i class="bi bi-robot"></i> AI LỌC CV</span>
                                <span id="drawerAiScoreBadge" class="badge bg-success text-white fw-bold py-1 px-2" style="font-size: 0.72rem;">${selectedCandidate.aiMatchScore}% MATCH</span>
                            </div>
                            <div id="drawerAiRecommendation" class="small text-dark mb-1" style="font-size: 0.75rem; line-height: 1.35;">
                                <strong>Đánh giá của AI:</strong> ${selectedCandidate.aiRecommendation}
                            </div>
                            <div class="progress mb-1" style="height: 5px;">
                                <div id="drawerAiProgressBar" class="progress-bar ai-match-progress-bar" style="width: ${selectedCandidate.aiMatchScore}%;"></div>
                            </div>
                            <div class="d-flex justify-content-between text-muted" style="font-size: 0.7rem;">
                                <span>✔ KN: <strong id="drawerExp">${selectedCandidate.experienceYears} năm</strong></span>
                                <span>✔ Lương: <strong id="drawerExpectedSalary">${selectedCandidate.formattedSalary}</strong></span>
                                <span class="text-success fw-bold">✔ Ưu tiên</span>
                            </div>
                        </div>

                        <!-- Education & Experience (Compact) -->
                        <div class="mb-2 p-2 bg-white border rounded-2" style="font-size: 0.75rem;">
                            <div class="fw-bold text-dark small text-uppercase mb-1" style="font-size: 0.7rem; letter-spacing: 0.3px;">Học vấn & Kinh nghiệm</div>
                            <div class="d-flex align-items-center gap-1 text-dark mb-1 text-truncate">
                                <i class="bi bi-mortarboard text-primary"></i>
                                <span id="drawerEdu" class="text-truncate">${selectedCandidate.education}</span>
                            </div>
                            <div class="d-flex align-items-center gap-1 text-dark text-truncate">
                                <i class="bi bi-briefcase text-primary"></i>
                                <span id="drawerWork" class="text-truncate">${selectedCandidate.workHistory}</span>
                            </div>
                        </div>

                        <!-- Skill Tags (Compact) -->
                        <div class="mb-2">
                            <div class="fw-bold text-dark small text-uppercase mb-1" style="font-size: 0.7rem; letter-spacing: 0.3px;">Kỹ năng cốt lõi (AI Detected)</div>
                            <div id="drawerSkillsTags" class="d-flex flex-wrap gap-1">
                                <c:forEach items="${selectedCandidate.skillList}" var="sk">
                                    <span class="badge bg-light text-dark border py-1 px-2" style="font-size: 0.72rem;">${sk}</span>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Evaluation History & Offer Proposal (Compact Accordion/Card) -->
                        <div class="p-2 bg-primary-subtle bg-opacity-25 border border-primary-subtle rounded-2" style="font-size: 0.76rem;">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-primary" style="font-size: 0.72rem;">GÓI OFFER ĐỀ XUẤT</span>
                                <span id="drawerOfferSalary" class="fw-bold text-primary" style="font-size: 0.95rem;">${selectedCandidate.formattedSalary}</span>
                            </div>
                            <div class="d-flex justify-content-between text-muted" style="font-size: 0.7rem;">
                                <span>Onboard: <strong class="text-dark">15/10/2026</strong></span>
                                <span>Đánh giá V1: <span class="badge bg-success-subtle text-success py-0 px-1">8.5/10 Đạt</span></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Hidden Candidates Data Store for Fast CV Viewer Lookup -->
            <div id="allCandidatesDataStore" style="display: none;">
                <c:forEach items="${candidates}" var="c">
                    <div class="store-cand-item"
                        data-id="${c.id}"
                        data-code="${c.candidateCode}"
                        data-name="${c.fullName}"
                        data-email="${c.email}"
                        data-phone="${c.phone}"
                        data-job="${c.jobTitle}"
                        data-dept="${c.departmentName}"
                        data-stage="${c.stage}"
                        data-source="${c.source}"
                        data-exp="${c.experienceYears}"
                        data-salary="${c.formattedSalary}"
                        data-score="${c.aiMatchScore}"
                        data-avatar="${c.avatarInitials}"
                        data-skills="${c.skills}"
                        data-rec="${c.aiRecommendation}"
                        data-edu="${c.education}"
                        data-work="${c.workHistory}"
                        data-cv-type="${c.cvType != null ? c.cvType : 'PDF'}"
                        data-cv-text="${fn:escapeXml(c.cvText != null ? c.cvText : '')}">
                    </div>
                </c:forEach>
            </div>
        </main>

        <!-- Footer -->
        <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 1: TIẾP NHẬN HỒ SƠ BẰNG BẢN MỀM CV (TỰ ĐỘNG BÓC TÁCH) (#addCandidateModal) -->
<!-- ========================================================================= -->
<div class="modal fade" id="addCandidateModal" tabindex="-1" aria-labelledby="addCandidateModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header p-3 px-4 text-white" style="background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-file-earmark-arrow-up-fill fs-4 text-warning"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="addCandidateModalLabel">
                            Tiếp Nhận Hồ Sơ Mới Bằng CV Bản Mềm (Tự Động Bóc Tách)
                        </h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">
                            Không cần nhập tay dài dòng! Tải lên file CV (.pdf, .docx, ảnh/chữ viết tay) - Hệ thống tự động bóc tách dữ liệu và điền hồ sơ trong 3 giây.
                        </small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/recruitment" id="smartAddCandidateForm">
                <input type="hidden" name="action" value="add_candidate">
                <input type="hidden" name="returnView" value="candidates">
                <input type="hidden" name="cvType" id="smartCvTypeInput" value="PDF">
                <input type="hidden" name="cvText" id="smartCvTextInput" value="">
                
                <div class="modal-body p-4" style="background: #f8fafc;">
                    <!-- Vùng 1: Kéo thả tải lên bản mềm & Nạp mẫu nhanh 1-Click -->
                    <div class="card border-0 shadow-sm rounded-3 p-4 mb-3 bg-white">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <label class="form-label fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                                <i class="bi bi-cloud-arrow-up-fill text-primary fs-5"></i>
                                <span>1. Tải lên Bản mềm CV của Ứng viên (PDF, Word, Ảnh chữ viết tay)</span>
                            </label>
                            <span class="badge bg-success-subtle text-success border border-success-subtle fw-semibold px-2 py-1">
                                <i class="bi bi-lightning-charge-fill me-1"></i>Tự Động Bóc Tách 100%
                            </span>
                        </div>

                        <!-- Dropzone Container -->
                        <div id="cvDropzoneArea" class="p-4 rounded-3 border-2 border-dashed text-center" 
                             style="border-color: #93c5fd; background: #eff6ff; cursor: pointer; transition: all 0.2s;"
                             onclick="document.getElementById('cvFileInput').click()">
                            <input type="file" id="cvFileInput" accept=".pdf,.doc,.docx,.png,.jpg,.jpeg" style="display: none;" onchange="handleCvFileUpload(event)">
                            <div class="d-flex flex-column align-items-center justify-content-center">
                                <div class="rounded-circle p-3 mb-2" style="background: rgba(37, 99, 235, 0.1);">
                                    <i class="bi bi-file-earmark-pdf-fill fs-1 text-primary"></i>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Kéo & Thả file CV bản mềm vào đây hoặc <span class="text-primary text-decoration-underline">Bấm để duyệt file</span></h6>
                                <p class="text-muted small mb-0">Hỗ trợ các định dạng: <strong>PDF (.pdf)</strong>, <strong>Word (.docx, .doc)</strong>, <strong>Bản quét / Ảnh chữ viết tay (.png, .jpg)</strong> (Dưới 20MB)</p>
                            </div>
                        </div>

                        <!-- 4 Nút nạp mẫu CV bản mềm có sẵn (Để giảng viên kiểm tra nhanh) -->
                        <div class="mt-3 pt-3 border-top">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="small text-muted fw-semibold">
                                    <i class="bi bi-magic text-warning me-1"></i>Hoặc bấm thử nghiệm ngay 4 Mẫu CV Bản Mềm chuẩn (1-Click Auto-Fill):
                                </span>
                                <small class="text-primary fst-italic">Tự động đọc thông tin tức thì</small>
                            </div>
                            <div class="d-flex flex-wrap gap-2">
                                <button type="button" class="btn btn-sm btn-outline-danger d-flex align-items-center gap-1 rounded-pill px-3 py-1" onclick="loadAndParsePresetCv('PDF_FULLSTACK')">
                                    <i class="bi bi-file-earmark-pdf-fill"></i>
                                    <span>📄 CV PDF: Nguyễn Hoàng Nam (Senior Fullstack)</span>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-primary d-flex align-items-center gap-1 rounded-pill px-3 py-1" onclick="loadAndParsePresetCv('WORD_BACKEND')">
                                    <i class="bi bi-file-earmark-word-fill"></i>
                                    <span>📝 CV Word: Trần Minh Đức (Tech Lead Backend)</span>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-purple d-flex align-items-center gap-1 rounded-pill px-3 py-1" style="color: #7e22ce; border-color: #c084fc;" onclick="loadAndParsePresetCv('HANDWRITTEN_OCR')">
                                    <i class="bi bi-pen-fill"></i>
                                    <span>✍️ CV Chữ viết tay (OCR): Lê Thị Ánh Tuyết</span>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-info d-flex align-items-center gap-1 rounded-pill px-3 py-1" onclick="loadAndParsePresetCv('PDF_DESIGNER')">
                                    <i class="bi bi-file-earmark-pdf-fill"></i>
                                    <span>🎨 CV PDF: Vũ Thùy Chi (UI/UX Designer)</span>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Vùng 2: Kết quả bóc tách & Bản xem trước trực tiếp CV (Live Interactive Soft-Copy Preview) -->
                    <div id="cvParseResultBox" class="card border-0 shadow-sm rounded-3 p-4 mb-3 bg-white" style="display: none;">
                        <div class="alert alert-success d-flex align-items-center gap-2 p-3 mb-3 border-0 rounded-3" style="background: #ecfdf5;">
                            <i class="bi bi-check-circle-fill text-success fs-4"></i>
                            <div class="flex-grow-1">
                                <strong class="text-success">Đã tự động đọc & trích xuất thành công bản mềm CV!</strong>
                                <div class="text-muted small">Hệ thống đã nhận diện họ tên, email, điện thoại, năm kinh nghiệm, kỹ năng và tóm tắt năng lực mà không cần nhập tay.</div>
                            </div>
                            <span id="cvTypeBadgePreview" class="badge bg-primary px-3 py-2 fs-6">Bản PDF (.pdf)</span>
                        </div>

                        <!-- Embedded Document Preview of the Parsed CV -->
                        <div class="border rounded-3 p-4 bg-light position-relative">
                            <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div id="previewCvAvatar" class="avatar-circle bg-primary text-white fw-bold shadow-sm" style="width: 56px; height: 56px; font-size: 1.25rem;">
                                        NH
                                    </div>
                                    <div>
                                        <div class="d-flex align-items-center gap-2">
                                            <h4 id="previewCvName" class="fw-bold text-dark mb-0">Nguyễn Hoàng Nam</h4>
                                            <span id="previewCvTargetJob" class="badge bg-primary-subtle text-primary">Senior Fullstack Engineer</span>
                                        </div>
                                        <div class="d-flex flex-wrap align-items-center gap-3 text-muted small mt-1">
                                            <span><i class="bi bi-envelope-fill text-primary me-1"></i><span id="previewCvEmail">hoangnam.dev@gmail.com</span></span>
                                            <span><i class="bi bi-telephone-fill text-success me-1"></i><span id="previewCvPhone">0912.888.999</span></span>
                                            <span><i class="bi bi-briefcase-fill text-warning me-1"></i>Kinh nghiệm: <strong id="previewCvExp" class="text-dark">5 năm</strong></span>
                                            <span><i class="bi bi-cash-stack text-success me-1"></i>Kỳ vọng: <strong id="previewCvSalary" class="text-dark">42.000.000 VNĐ</strong></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <span class="badge bg-dark font-monospace" id="previewCvFileName">CV_Bản_Mềm.pdf</span>
                                </div>
                            </div>

                            <!-- Skills extraction -->
                            <div class="mb-3">
                                <div class="fw-bold text-dark small text-uppercase mb-2">KỸ NĂNG BÓC TÁCH TỰ ĐỘNG (SKILLS EXTRACTED)</div>
                                <div id="previewCvSkillsTags" class="d-flex flex-wrap gap-1">
                                    <!-- Dynamic skill badges -->
                                </div>
                            </div>

                            <!-- Summary text -->
                            <div>
                                <div class="fw-bold text-dark small text-uppercase mb-1">TÓM TẮT HỒ SƠ ỨNG VIÊN</div>
                                <p id="previewCvSummary" class="text-muted small mb-0" style="line-height: 1.6;"></p>
                            </div>
                        </div>

                        <!-- Expandable accordion for manual adjustments if needed -->
                        <div class="mt-3">
                            <a class="text-muted small text-decoration-none fw-semibold d-inline-flex align-items-center gap-1" data-bs-toggle="collapse" href="#collapseManualInputs" role="button" aria-expanded="false">
                                <i class="bi bi-gear-fill"></i>
                                <span>Xem / Chỉnh sửa các trường thông tin chi tiết (Đã được điền tự động)</span>
                                <i class="bi bi-chevron-down ms-1"></i>
                            </a>
                            <div class="collapse mt-2" id="collapseManualInputs">
                                <div class="p-3 border rounded-3 bg-white">
                                    <div class="row g-3 mb-2">
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold text-muted">Họ tên ứng viên <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control form-control-sm" name="fullName" id="inputFullName" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold text-muted">Email liên hệ <span class="text-danger">*</span></label>
                                            <input type="email" class="form-control form-control-sm" name="email" id="inputEmail" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold text-muted">Số điện thoại <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control form-control-sm" name="phone" id="inputPhone" required>
                                        </div>
                                    </div>
                                    <div class="row g-3 mb-2">
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold text-muted">Vị trí ứng tuyển <span class="text-danger">*</span></label>
                                            <select class="form-select form-select-sm" name="recruitmentRequestId" id="selectRecruitmentRequestId" required>
                                                <c:forEach items="${jobs}" var="j">
                                                    <option value="${j.id}">${j.title} (${j.requestCode})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold text-muted">Số năm kinh nghiệm</label>
                                            <input type="number" step="0.5" class="form-control form-control-sm" name="experienceYears" id="inputExpYears" value="3.0">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold text-muted">Lương mong muốn (VNĐ)</label>
                                            <input type="number" step="1000000" class="form-control form-control-sm" name="expectedSalary" id="inputExpectedSalary" value="30000000">
                                        </div>
                                    </div>
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold text-muted">Nguồn tuyển dụng</label>
                                            <select class="form-select form-select-sm" name="source" id="selectSource">
                                                <option value="Hồ sơ CV bản mềm (PDF/Word)" selected>Hồ sơ CV bản mềm (PDF/Word)</option>
                                                <option value="LinkedIn">LinkedIn</option>
                                                <option value="TopCV/VNW">TopCV / VietnamWorks</option>
                                                <option value="Nội bộ (Ref)">Nội bộ (Ref)</option>
                                                <option value="Khác">Khác</option>
                                            </select>
                                        </div>
                                        <div class="col-md-8">
                                            <label class="form-label small fw-semibold text-muted">Đường dẫn file CV / Cloud Drive</label>
                                            <input type="text" class="form-control form-control-sm" name="cvUrl" id="inputCvUrl" value="uploads/cvs/soft_copy.pdf">
                                        </div>
                                    </div>
                                    <div class="mt-2">
                                        <label class="form-label small fw-semibold text-muted">Ghi chú tóm tắt</label>
                                        <textarea class="form-control form-control-sm" name="notes" id="inputNotes" rows="2"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white border-top p-3 px-4 d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm px-4">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Tiếp Nhận Hồ Sơ Ngay</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL: BỘ XEM TRỰC TIẾP CV BẢN MỀM (#viewCandidateCvModal)                -->
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
                                    NH
                                </div>
                            </div>
                            <div class="col">
                                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                                    <div>
                                        <h2 id="viewerDocFullName" class="h3 fw-bold text-dark mb-1">NGUYỄN HOÀNG NAM</h2>
                                        <div id="viewerDocJobTitle" class="text-primary fw-bold fs-6 text-uppercase" style="letter-spacing: 0.5px;">SENIOR FULLSTACK ENGINEER</div>
                                    </div>
                                    <div class="text-end">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 fw-bold" id="viewerDocScoreBadge">
                                            <i class="bi bi-stars me-1"></i>AI MATCH: 94%
                                        </span>
                                    </div>
                                </div>
                                <div class="d-flex flex-wrap align-items-center gap-3 text-muted small mt-2">
                                    <span><i class="bi bi-envelope-fill text-primary me-1"></i><span id="viewerDocEmail">hoangnam.dev@gmail.com</span></span>
                                    <span><i class="bi bi-telephone-fill text-success me-1"></i><span id="viewerDocPhone">0912.888.999</span></span>
                                    <span><i class="bi bi-geo-alt-fill text-danger me-1"></i><span id="viewerDocLocation">Hà Nội, Việt Nam</span></span>
                                    <span><i class="bi bi-cash-stack text-warning me-1"></i>Lương kỳ vọng: <strong id="viewerDocSalary">42.000.000 VNĐ</strong></span>
                                </div>
                            </div>
                        </div>

                        <!-- CV Section 1: Executive Summary -->
                        <div class="mb-4">
                            <h6 class="fw-bold text-dark text-uppercase border-bottom pb-2 mb-2 d-flex align-items-center gap-2" style="letter-spacing: 0.5px;">
                                <i class="bi bi-person-lines-fill text-primary"></i>
                                <span>TÓM TẮT NĂNG LỰC NGHỀ NGHIỆP</span>
                            </h6>
                            <p id="viewerDocSummary" class="text-secondary small mb-0" style="line-height: 1.7; font-size: 0.88rem;">
                                Kỹ sư phần mềm giàu kinh nghiệm...
                            </p>
                        </div>

                        <!-- CV Section 2: Core Skills -->
                        <div class="mb-4">
                            <h6 class="fw-bold text-dark text-uppercase border-bottom pb-2 mb-2 d-flex align-items-center gap-2" style="letter-spacing: 0.5px;">
                                <i class="bi bi-tools text-primary"></i>
                                <span>KỸ NĂNG CHUYÊN MÔN & CÔNG NGHỆ</span>
                            </h6>
                            <div id="viewerDocSkillsList" class="d-flex flex-wrap gap-2 pt-1">
                                <!-- Skill tags -->
                            </div>
                        </div>

                        <!-- CV Section 3: Work Experience -->
                        <div class="mb-4">
                            <h6 class="fw-bold text-dark text-uppercase border-bottom pb-2 mb-3 d-flex align-items-center gap-2" style="letter-spacing: 0.5px;">
                                <i class="bi bi-briefcase-fill text-primary"></i>
                                <span>KINH NGHIỆM LÀM VIỆC THỰC CHIẾN (<span id="viewerDocExpYears">5 năm</span>)</span>
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
            </div>

            <!-- Modal Footer -->
            <div class="modal-footer bg-white border-top p-3 px-4 d-flex justify-content-between">
                <span class="small text-muted">
                    <i class="bi bi-shield-check text-success me-1"></i>Hồ sơ ứng viên được bảo mật và quản lý trên hệ thống MIXIMOI ATS
                </span>
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

<!-- ========================================================================= -->
<!-- MODAL 2: GỬI THƯ MỜI LÀM VIỆC (OFFER LETTER) (#sendOfferModal)           -->
<!-- ========================================================================= -->
<div class="modal fade" id="sendOfferModal" tabindex="-1" aria-labelledby="sendOfferModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-md modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-envelope-paper-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="sendOfferModalLabel">Phát Hành Thư Mời Nhận Việc (Offer)</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Thiết lập mức đãi ngộ và gửi thư mời chính thức</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                <input type="hidden" name="action" value="send_offer">
                <input type="hidden" name="candidateId" id="modalOfferCandidateId" value="${selectedCandidate.id}">
                <div class="modal-body p-4">
                    <div class="p-3 bg-light rounded-3 mb-3 border">
                        <div class="small text-muted">Ứng viên nhận Offer:</div>
                        <div class="fw-bold text-dark fs-6" id="modalOfferCandName">${selectedCandidate.fullName} (${selectedCandidate.candidateCode})</div>
                        <div class="small text-primary" id="modalOfferCandJob">${selectedCandidate.jobTitle}</div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 2: GỬI THƯ MỜI LÀM VIỆC (OFFER LETTER) (#sendOfferModal)           -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="sendOfferModal" tabindex="-1" aria-labelledby="sendOfferModalLabel"
                        aria-hidden="true">
                        <div class="modal-dialog modal-md modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header modal-header-brand p-3 px-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-envelope-paper-fill fs-5"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="sendOfferModalLabel">
                                                Phát Hành Thư Mời Nhận Việc (Offer)</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Thiết
                                                lập mức đãi ngộ và gửi thư mời chính thức</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                                    <input type="hidden" name="action" value="send_offer">
                                    <input type="hidden" name="candidateId" id="modalOfferCandidateId"
                                        value="${selectedCandidate.id}">
                                    <div class="modal-body p-4">
                                        <div class="p-3 bg-light rounded-3 mb-3 border">
                                            <div class="small text-muted">Ứng viên nhận Offer:</div>
                                            <div class="fw-bold text-dark fs-6" id="modalOfferCandName">
                                                ${selectedCandidate.fullName} (${selectedCandidate.candidateCode})</div>
                                            <div class="small text-primary" id="modalOfferCandJob">
                                                ${selectedCandidate.jobTitle}</div>
                                        </div>

                                        <div class="row g-3 mb-3">
                                            <div class="col-6">
                                                <label class="form-label small fw-semibold text-muted">Mức lương Net đề
                                                    xuất (VNĐ) <span class="text-danger">*</span></label>
                                                <input type="number"
                                                    class="form-control form-control-sm font-monospace fw-bold"
                                                    name="offerSalary" value="35000000" step="1000000" required>
                                            </div>
                                            <div class="col-6">
                                                <label class="form-label small fw-semibold text-muted">Ngày bắt đầu làm
                                                    việc <span class="text-danger">*</span></label>
                                                <input type="date" class="form-control form-control-sm"
                                                    name="onboardDate" required>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-muted">Gói phúc lợi đính
                                                kèm</label>
                                            <textarea class="form-control form-control-sm" name="benefits"
                                                rows="2">100% lương thử việc 2 tháng đầu, gói Bảo hiểm sức khỏe Bảo Việt Gold, 14 ngày phép/năm, trợ cấp ăn trưa 50.000đ/ngày.</textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer bg-light border-top p-3 px-4">
                                        <button type="button" class="btn btn-outline-secondary"
                                            data-bs-dismiss="modal">Đóng</button>
                                        <button type="submit"
                                            class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                                            <i class="bi bi-send-check-fill"></i>
                                            <span>Xác nhận & Gửi Thư Mời</span>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 3: XẾP LỊCH PHỎNG VẤN ỨNG VIÊN (#scheduleCandInterviewModal)        -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="scheduleCandInterviewModal" tabindex="-1"
                        aria-labelledby="scheduleCandInterviewModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-md modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header modal-header-brand p-3 px-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-calendar-plus-fill fs-5"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white"
                                                id="scheduleCandInterviewModalLabel">Xếp Lịch Phỏng Vấn Cho Ứng Viên
                                            </h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Lên
                                                lịch phỏng vấn và chuyển ứng viên vào vòng phỏng vấn</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                                    <input type="hidden" name="action" value="schedule_interview">
                                    <input type="hidden" name="returnView" value="candidates">
                                    <input type="hidden" name="candidateId" id="modalInterviewCandId"
                                        value="${selectedCandidate.id}">
                                    <input type="hidden" name="recruitmentRequestId"
                                        value="${selectedCandidate.recruitmentRequestId}">
                                    <div class="modal-body p-4">
                                        <div class="p-3 bg-light rounded-3 mb-3 border">
                                            <div class="small text-muted">Ứng viên:</div>
                                            <div class="fw-bold text-dark fs-6">${selectedCandidate.fullName}
                                                (${selectedCandidate.candidateCode})</div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-muted">Người phỏng vấn
                                                (Interviewer) <span class="text-danger">*</span></label>
                                            <select class="form-select form-select-sm" name="interviewerId" required>
                                                <c:forEach items="${employees}" var="emp">
                                                    <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-muted">Vòng phỏng
                                                vấn</label>
                                            <select class="form-select form-select-sm" name="roundName">
                                                <option value="Vòng 1 (HR Fit & Văn hóa)">Vòng 1 (HR Fit & Văn hóa)
                                                </option>
                                                <option value="Vòng Chuyên môn & Kỹ thuật" selected>Vòng Chuyên môn & Kỹ
                                                    thuật</option>
                                                <option value="Vòng Portfolio / Bài Test">Vòng Portfolio / Bài Test
                                                </option>
                                                <option value="Vòng Ban Giám đốc">Vòng Ban Giám đốc</option>
                                            </select>
                                        </div>

                                        <div class="row g-2 mb-3">
                                            <div class="col-6">
                                                <label class="form-label small fw-semibold text-muted">Ngày phỏng vấn
                                                    <span class="text-danger">*</span></label>
                                                <input type="date" class="form-control form-control-sm"
                                                    name="interviewDate" required>
                                            </div>
                                            <div class="col-6">
                                                <label class="form-label small fw-semibold text-muted">Giờ phỏng vấn
                                                    <span class="text-danger">*</span></label>
                                                <input type="time" class="form-control form-control-sm"
                                                    name="interviewTime" value="09:30" required>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-muted">Địa điểm hoặc Link
                                                Google Meet</label>
                                            <input type="text" class="form-control form-control-sm"
                                                name="locationOrLink"
                                                value="Phòng họp Tầng 4 & Google Meet: meet.google.com/mix-rec">
                                        </div>
                                    </div>
                                    <div class="modal-footer bg-light border-top p-3 px-4">
                                        <button type="button" class="btn btn-outline-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit"
                                            class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                                            <i class="bi bi-check-lg"></i>
                                            <span>Lưu lịch phỏng vấn</span>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ========================================================================= -->
                    <!-- MODAL 4: PHÂN TÍCH CHUYÊN SÂU AI CHO 1 CV (#aiCvAnalysisModal)             -->
                    <!-- ========================================================================= -->
                    <div class="modal fade" id="aiCvAnalysisModal" tabindex="-1"
                        aria-labelledby="aiCvAnalysisModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                            <div class="modal-content border-0 shadow-lg rounded-3">
                                <div class="modal-header modal-header-ai p-3 px-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-stars fs-4"></i>
                                        <div>
                                            <h5 class="modal-title fw-bold mb-0 text-white" id="aiCvAnalysisModalLabel">
                                                Báo Cáo Phân Tích CV Chuyên Sâu Bằng AI</h5>
                                            <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Đánh
                                                giá mức độ khớp JD, ưu thế kỹ năng và bộ câu hỏi trắc nghiệm năng
                                                lực</small>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-4" style="background: #f8fafc;">
                                    <!-- Header Info -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <h6 class="fw-bold text-dark mb-0" id="aiCandModalName">
                                                    ${selectedCandidate.fullName}</h6>
                                                <small class="text-primary"
                                                    id="aiCandModalJob">${selectedCandidate.jobTitle}</small>
                                            </div>
                                            <span class="badge bg-success text-white fw-bold px-3 py-2 fs-6"
                                                id="aiCandModalScoreBadge">
                                                🥇 AI Match: ${selectedCandidate.aiMatchScore}%
                                            </span>
                                        </div>
                                        <div class="progress mb-2" style="height: 8px;">
                                            <c:set var="aiModalScoreWidth" value="style=\" width:
                                                ${selectedCandidate.aiMatchScore}%;\"" />
                                            <div class="progress-bar ai-match-progress-bar" id="aiCandModalProgressBar"
                                                ${aiModalScoreWidth}></div>
                                        </div>
                                    </div>

                                    <!-- Skills Breakdown -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                                        <h6 class="fw-bold text-dark mb-3">1. Phân tích bóc tách kỹ năng (Skills
                                            Extraction)</h6>
                                        <div class="p-3 border rounded bg-light mb-2">
                                            <div class="fw-bold text-success mb-1"><i
                                                    class="bi bi-check-circle-fill me-1"></i>Kỹ năng khớp 100%:</div>
                                            <div class="text-muted small" id="aiCandModalMatchedSkills">
                                                ${selectedCandidate.aiMatchedSkills}</div>
                                        </div>
                                        <div class="p-3 border rounded bg-light">
                                            <div class="fw-bold text-warning mb-1"><i
                                                    class="bi bi-exclamation-triangle-fill me-1"></i>Kỹ năng cần bổ sung
                                                / phỏng vấn thêm:</div>
                                            <div class="text-muted small" id="aiCandModalMissingSkills">
                                                ${selectedCandidate.aiMissingSkills}</div>
                                        </div>
                                    </div>

                                    <!-- AI Questions -->
                                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                                        <h6 class="fw-bold text-dark mb-3">2. Bộ câu hỏi phỏng vấn AI gợi ý tự động</h6>
                                        <div class="row g-2" style="font-size: 0.8rem;">
                                            <c:choose>
                                                <c:when test="${not empty candInterviewQuestions}">
                                                    <c:forEach items="${candInterviewQuestions}" var="q">
                                                        <div class="col-12">
                                                            <div class="p-2 border rounded bg-light">
                                                                <strong>${q.topic}:</strong>
                                                                <p class="text-muted mb-0 mt-1">${q.question}</p>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="col-12">
                                                        <div class="p-2 border rounded bg-light">
                                                            <strong>Về năng lực chuyên môn:</strong>
                                                            <p class="text-muted mb-0 mt-1">"Trình bày giải pháp bạn đã
                                                                từng triển khai để tối ưu hiệu năng cơ sở dữ liệu lớn?"
                                                            </p>
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
                                    <button type="button" class="btn btn-primary"
                                        onclick="alert('Đã lưu kết quả phân tích AI vào hồ sơ ứng viên.')">
                                        <i class="bi bi-save me-1"></i> Lưu kết quả AI
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        // 1. Tương tác chọn Card Ứng viên và cập nhật Khung Drawer bên phải
                        function selectCandidateCard(cardElement) {
                            document.querySelectorAll('.kanban-card').forEach(c => c.classList.remove('active-card'));
                            cardElement.classList.add('active-card');

    <!-- MODAL LỌC NÂNG CAO ỨNG VIÊN (#candAdvancedFilterModal) -->
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
                                        <option value="">Tất cả vị trí (${jobs.size()})</option>
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

<script>
    // 1. Tương tác chọn Card Ứng viên và cập nhật Khung Drawer bên phải
    function selectCandidateCard(cardElement) {
        document.querySelectorAll('.kanban-card').forEach(c => c.classList.remove('active-card'));
        cardElement.classList.add('active-card');

                            // Cập nhật DOM
                            const drawerName = document.getElementById('drawerName');
                            if (drawerName) drawerName.textContent = name;

                            const drawerCode = document.getElementById('drawerCode');
                            if (drawerCode) drawerCode.textContent = code;

                            const drawerJobTitle = document.getElementById('drawerJobTitle');
                            if (drawerJobTitle) drawerJobTitle.textContent = job;

                            const drawerAvatar = document.getElementById('drawerAvatarInitials');
                            if (drawerAvatar) drawerAvatar.textContent = avatar ? avatar : 'UV';

                            const drawerEmail = document.getElementById('drawerEmail');
                            if (drawerEmail) drawerEmail.textContent = email;

                            const drawerPhone = document.getElementById('drawerPhone');
                            if (drawerPhone) drawerPhone.textContent = phone;

                            const drawerSource = document.getElementById('drawerSource');
                            if (drawerSource) drawerSource.textContent = source;

                            const drawerRating = document.getElementById('drawerRating');
                            if (drawerRating) drawerRating.textContent = rating;

                            const drawerAiScoreText = document.getElementById('drawerAiScoreText');
                            if (drawerAiScoreText) drawerAiScoreText.textContent = score + '%';

                            const drawerAiScoreBadge = document.getElementById('drawerAiScoreBadge');
                            if (drawerAiScoreBadge) drawerAiScoreBadge.textContent = score + '% MATCH';

                            const drawerAiProgressBar = document.getElementById('drawerAiProgressBar');
                            if (drawerAiProgressBar) drawerAiProgressBar.style.width = score + '%';

                            const drawerAiRecommendation = document.getElementById('drawerAiRecommendation');
                            if (drawerAiRecommendation) drawerAiRecommendation.innerHTML = '<strong>Đánh giá của AI:</strong> ' + rec;

                            const drawerExp = document.getElementById('drawerExp');
                            if (drawerExp) drawerExp.textContent = exp + ' năm';

                            const drawerExpectedSalary = document.getElementById('drawerExpectedSalary');
                            if (drawerExpectedSalary) drawerExpectedSalary.textContent = salary;

                            const drawerOfferSalary = document.getElementById('drawerOfferSalary');
                            if (drawerOfferSalary) drawerOfferSalary.textContent = salary;

                            const drawerEdu = document.getElementById('drawerEdu');
                            if (drawerEdu) drawerEdu.textContent = edu;

                            const drawerWork = document.getElementById('drawerWork');
                            if (drawerWork) drawerWork.textContent = work;

                            const drawerCvFileName = document.getElementById('drawerCvFileName');
                            if (drawerCvFileName) drawerCvFileName.textContent = 'CV_' + name.replace(/\s+/g, '_') + '.pdf';

                            const drawerCandidateIdInput = document.getElementById('drawerCandidateIdInput');
                            if (drawerCandidateIdInput) drawerCandidateIdInput.value = id;

                            const modalOfferCandidateId = document.getElementById('modalOfferCandidateId');
                            if (modalOfferCandidateId) modalOfferCandidateId.value = id;

                            const modalOfferCandName = document.getElementById('modalOfferCandName');
                            if (modalOfferCandName) modalOfferCandName.textContent = name + ' (' + code + ')';

                            const modalOfferCandJob = document.getElementById('modalOfferCandJob');
                            if (modalOfferCandJob) modalOfferCandJob.textContent = job;

                            const modalInterviewCandId = document.getElementById('modalInterviewCandId');
                            if (modalInterviewCandId) modalInterviewCandId.value = id;

                            // Cập nhật nút 1-Click Tiếp nhận vào biên chế
                            const stage = cardElement.getAttribute('data-stage');
                            const drawerHireContainer = document.getElementById('drawerHireContainer');
                            const drawerHireBtn = document.getElementById('drawerHireBtn');
                            if (drawerHireContainer && drawerHireBtn) {
                                if (stage === 'OFFER' || stage === 'ONBOARDED' || stage === 'OFFER_ACCEPTED' || stage === 'HIRED') {
                                    drawerHireContainer.style.display = '';
                                    drawerHireBtn.href = '${pageContext.request.contextPath}/employees?action=new&candidateId=' + id;
                                } else {
                                    drawerHireContainer.style.display = 'none';
                                }
                            }

                            // Cập nhật Modal 4: Phân tích chuyên sâu AI (#aiCvAnalysisModal)
                            const matched = cardElement.getAttribute('data-matched');
                            const missing = cardElement.getAttribute('data-missing');

                            const aiCandModalName = document.getElementById('aiCandModalName');
                            if (aiCandModalName) aiCandModalName.textContent = name;

                            const aiCandModalJob = document.getElementById('aiCandModalJob');
                            if (aiCandModalJob) aiCandModalJob.textContent = job;

                            const aiCandModalScoreBadge = document.getElementById('aiCandModalScoreBadge');
                            if (aiCandModalScoreBadge) aiCandModalScoreBadge.textContent = '🥇 AI Match: ' + score + '%';

                            const aiCandModalProgressBar = document.getElementById('aiCandModalProgressBar');
                            if (aiCandModalProgressBar) aiCandModalProgressBar.style.width = score + '%';

                            const aiCandModalMatchedSkills = document.getElementById('aiCandModalMatchedSkills');
                            if (aiCandModalMatchedSkills) aiCandModalMatchedSkills.textContent = matched ? matched : 'Đang đồng bộ kỹ năng...';

                            const aiCandModalMissingSkills = document.getElementById('aiCandModalMissingSkills');
                            if (aiCandModalMissingSkills) aiCandModalMissingSkills.textContent = missing ? missing : 'Chưa phát hiện kỹ năng còn thiếu.';

                            // Skills tags
                            const drawerSkillsTags = document.getElementById('drawerSkillsTags');
                            if (drawerSkillsTags && skills) {
                                drawerSkillsTags.innerHTML = '';
                                skills.split(',').forEach(sk => {
                                    const s = sk.trim();
                                    if (s) {
                                        const span = document.createElement('span');
                                        span.className = 'badge bg-light text-dark border';
                                        span.textContent = s;
                                        drawerSkillsTags.appendChild(span);
                                    }
                                });
                            }
                        }

                        function selectCandidateById(id) {
                            const card = document.querySelector('.kanban-card[data-id="' + id + '"]');
                            if (card) {
                                selectCandidateCard(card);
                                switchCandidateView('kanban');
                                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            }
                        }

                        // 2. Chuyển đổi giữa chế độ Kanban và Bảng (Table)
                        function switchCandidateView(mode) {
                            const kanban = document.getElementById('kanbanBoardWrapper');
                            const table = document.getElementById('tableCandidateContainer');
                            const btnKanban = document.getElementById('btnKanbanMode');
                            const btnTable = document.getElementById('btnTableMode');

                            if (mode === 'table') {
                                kanban.style.display = 'none';
                                table.style.display = 'block';
                                btnKanban.className = 'btn btn-outline-secondary';
                                btnTable.className = 'btn btn-primary';
                            } else {
                                kanban.style.display = 'flex';
                                table.style.display = 'none';
                                btnKanban.className = 'btn btn-primary';
                                btnTable.className = 'btn btn-outline-secondary';
                            }
                        }

                        // 3. HTML5 Drag and Drop Kanban Pipeline
                        let draggedCard = null;

                        function handleDragStart(e) {
                            draggedCard = e.currentTarget;
                            e.dataTransfer.setData('text/plain', draggedCard.getAttribute('data-id'));
                            draggedCard.classList.add('opacity-50');
                        }

                        function handleDragEnd(e) {
                            if (draggedCard) draggedCard.classList.remove('opacity-50');
                        }

                        function handleDragOver(e) {
                            e.preventDefault();
                            const col = e.currentTarget;
                            col.style.background = '#f1f5f9';
                        }

                        function handleDragLeave(e) {
                            const col = e.currentTarget;
                            col.style.background = '';
                        }

                        function handleDrop(e, targetStage) {
                            e.preventDefault();
                            const col = e.currentTarget;
                            col.style.background = '';

                            if (!draggedCard) return;
                            const candidateId = draggedCard.getAttribute('data-id');
                            const oldStage = draggedCard.getAttribute('data-stage');
                            const oldParent = draggedCard.parentElement;

                            if (oldStage === targetStage) return;

                            // Di chuyển card sang cột mới trên UI ngay lập tức
                            col.appendChild(draggedCard);
                            draggedCard.setAttribute('data-stage', targetStage);

                            // Cập nhật số lượng đếm trên badge của 2 cột
                            const oldBadge = document.getElementById('badgeCount' + oldStage);
                            if (oldBadge) {
                                let oldVal = parseInt(oldBadge.textContent, 10);
                                if (!isNaN(oldVal) && oldVal > 0) oldBadge.textContent = oldVal - 1;
                            }
                            const newBadge = document.getElementById('badgeCount' + targetStage);
                            if (newBadge) {
                                let newVal = parseInt(newBadge.textContent, 10);
                                if (!isNaN(newVal)) newBadge.textContent = newVal + 1;
                            }

                            function rollbackDrop() {
                                if (oldParent && draggedCard) {
                                    oldParent.appendChild(draggedCard);
                                    draggedCard.setAttribute('data-stage', oldStage);
                                    if (oldBadge) {
                                        let v = parseInt(oldBadge.textContent, 10);
                                        if (!isNaN(v)) oldBadge.textContent = v + 1;
                                    }
                                    if (newBadge) {
                                        let v = parseInt(newBadge.textContent, 10);
                                        if (!isNaN(v) && v > 0) newBadge.textContent = v - 1;
                                    }
                                    alert('Không thể cập nhật trạng thái vòng tuyển dụng. Đã hoàn tác vị trí ứng viên.');
                                }
                            }

                            // Gửi AJAX ngầm cập nhật Database
                            const formData = new URLSearchParams();
                            formData.append('action', 'update_stage');
                            formData.append('candidateId', candidateId);
                            formData.append('stage', targetStage);
                            formData.append('ajax', 'true');

    // 4. Tìm kiếm ứng viên trên bảng / kanban
    const candSearchInput = document.getElementById('candSearchInput');
    if (candSearchInput) {
        candSearchInput.addEventListener('keyup', function () {
            const kw = this.value.toLowerCase().trim();
            document.querySelectorAll('.kanban-card').forEach(card => {
                const name = card.getAttribute('data-name').toLowerCase();
                const code = card.getAttribute('data-code').toLowerCase();
                const job = card.getAttribute('data-job').toLowerCase();
                if (!kw || name.includes(kw) || code.includes(kw) || job.includes(kw)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }

    // =========================================================================
    // 5. TIẾP NHẬN HỒ SƠ THÔNG MINH - AUTO CV PARSER & PREVIEW
    // =========================================================================
    const presetCvData = {
        'PDF_FULLSTACK': {
            name: 'Nguyễn Hoàng Nam',
            email: 'hoangnam.dev@gmail.com',
            phone: '0912.888.999',
            exp: 5.0,
            salary: 42000000,
            cvType: 'PDF',
            fileName: 'CV_Nguyen_Hoang_Nam_Fullstack.pdf',
            skills: ['Java', 'Spring Boot', 'Microservices', 'Docker', 'PostgreSQL', 'React', 'Kafka', 'Redis', 'AWS'],
            summary: 'Kỹ sư Fullstack với 5 năm kinh nghiệm chuyên sâu về kiến trúc hệ thống phân tán chịu tải cao (Fintech/E-commerce). Đạt chứng chỉ AWS Solutions Architect. Đã trực tiếp thiết kế hệ thống thanh toán xử lý 15.000 TPS.',
            workHistory: 'Tech Lead tại Techcom Software (2023 - Nay) • Senior Backend tại VNPAY (2021 - 2023)',
            education: 'Đại học Bách Khoa Hà Nội - Kỹ thuật Phần mềm (Tốt nghiệp Giỏi)',
            rawText: 'CURRICULUM VITAE (PDF)\nHọ tên: Nguyễn Hoàng Nam\nEmail: hoangnam.dev@gmail.com | Phone: 0912.888.999\nKinh nghiệm: 5 năm Fullstack Developer\nKỹ năng: Java, Spring Boot, Microservices, Docker, PostgreSQL, React, Kafka, Redis, AWS\nHọc vấn: Đại học Bách Khoa Hà Nội - Kỹ thuật Phần mềm'
        },
        'WORD_BACKEND': {
            name: 'Trần Minh Đức',
            email: 'duc.tm.tech@gmail.com',
            phone: '0936.555.777',
            exp: 6.5,
            salary: 50000000,
            cvType: 'WORD',
            fileName: 'CV_Tran_Minh_Duc_Backend_Lead.docx',
            skills: ['Java', 'Go', 'Microservices', 'Kubernetes', 'PostgreSQL', 'Elasticsearch', 'Redis', 'System Design'],
            summary: 'Tech Lead Backend có 6.5 năm kinh nghiệm dẫn dắt đội ngũ kỹ sư. Thiết kế và tối ưu kiến trúc Microservices phân tán, độ trễ p99 dưới 15ms. Kinh nghiệm dày dặn tối ưu hóa database truy vấn cao tải.',
            workHistory: 'Backend Lead tại One Mount Group (2022 - Nay) • Senior Software Engineer tại Shopee VN (2019 - 2022)',
            education: 'Đại học Quốc Gia Hà Nội - CNTT (Hệ Cử nhân Tài năng)',
            rawText: 'BẢN WORD (.DOCX) - CV Ứng viên: Trần Minh Đức\nEmail: duc.tm.tech@gmail.com | Phone: 0936.555.777\nKinh nghiệm: 6.5 năm Tech Lead Backend\nKỹ năng chuyên môn: Java, Go, Microservices, Kubernetes, PostgreSQL, Elasticsearch, Redis, System Design'
        },
        'HANDWRITTEN_OCR': {
            name: 'Lê Thị Ánh Tuyết',
            email: 'anhtuyet.salesb2b@gmail.com',
            phone: '0978.222.333',
            exp: 4.0,
            salary: 32000000,
            cvType: 'HANDWRITTEN',
            fileName: 'Ban_Ghi_Chu_Viet_Tay_OCR_Le_Thi_Anh_Tuyet.pdf',
            skills: ['B2B Sales', 'CRM', 'Đàm phán thương mại', 'Thuyết trình dự án', 'Chăm sóc đối tác', 'Tiếng Anh'],
            summary: '[BẢN TỰ THUẬT CHỮ VIẾT TAY - ĐÃ QUÉT NHẬN DẠNG OCR TỰ ĐỘNG] Ứng viên gửi bản hồ sơ viết tay tóm tắt quá trình công tác. Có 4 năm quản lý danh mục 60+ khách hàng doanh nghiệp khối tài chính & công nghệ. Kỹ năng giao tiếp và thuyết phục xuất sắc. Doanh số năm 2025 vượt chỉ tiêu 135%.',
            workHistory: 'Senior B2B Account Manager tại FPT IS (2022 - 2026) • Account Executive tại Viettel IDC (2020 - 2022)',
            education: 'Đại học Ngoại Thương Hà Nội - Quản trị Kinh doanh Quốc tế',
            rawText: '[BẢN CHỮ VIẾT TAY - QUÉT NHẬN DẠNG OCR TỰ ĐỘNG]\nỨng viên: Lê Thị Ánh Tuyết\nEmail: anhtuyet.salesb2b@gmail.com | Phone: 0978.222.333\nKinh nghiệm thực chiến: Quản lý khách hàng doanh nghiệp B2B, đàm phán hợp đồng, thuyết trình, chăm sóc đối tác, kỹ năng giao tiếp tốt. Ghi chú phỏng vấn: Chữ viết rõ ràng, tư duy phản biện sắc bén.'
        },
        'PDF_DESIGNER': {
            name: 'Vũ Thùy Chi',
            email: 'thuychi.uxui@gmail.com',
            phone: '0989.111.444',
            exp: 3.5,
            salary: 28000000,
            cvType: 'PDF',
            fileName: 'CV_Vu_Thuy_Chi_Product_Designer.pdf',
            skills: ['Figma', 'UI/UX', 'Design System', 'Wireframing', 'Prototyping', 'User Research', 'HTML5/CSS3'],
            summary: 'Product Designer có 3.5 năm kinh nghiệm thiết kế trải nghiệm người dùng cho các sản phẩm SaaS và Mobile App. Đã xây dựng trọn bộ Design System cho hệ sinh thái 1 triệu người dùng. Thành thạo Figma, nguyên lý thiết kế Human-Centered Design.',
            workHistory: 'UI/UX Designer tại Momo (2023 - Nay) • Product Designer tại ZaloPay (2021 - 2023)',
            education: 'Đại học Mỹ thuật Công nghiệp Hà Nội - Thiết kế Đồ họa',
            rawText: 'CURRICULUM VITAE (PDF)\nHọ tên: Vũ Thùy Chi\nEmail: thuychi.uxui@gmail.com | Phone: 0989.111.444\nKinh nghiệm: 3.5 năm UI/UX Product Designer\nKỹ năng: Figma, UI/UX, Design System, Wireframing, Prototyping, User Research, HTML5/CSS3'
        }
    };

    function loadAndParsePresetCv(type) {
        const data = presetCvData[type];
        if (!data) return;
        renderParsedCvResult(data);
    }

    function handleCvFileUpload(e) {
        const file = e.target.files && e.target.files[0];
        if (!file) return;

        const name = file.name;
        const ext = name.split('.').pop().toLowerCase();
        let cvType = 'PDF';
        if (ext === 'doc' || ext === 'docx') cvType = 'WORD';
        else if (ext === 'png' || ext === 'jpg' || ext === 'jpeg') cvType = 'HANDWRITTEN';

        // Tự động phân tích tên file và bóc tách thông tin
        let cleanName = name.replace(/\.[^/.]+$/, '').replace(/[-_]+/g, ' ');
        cleanName = cleanName.replace(/cv|resume|ho so/gi, '').trim();
        if (!cleanName || cleanName.length < 3) cleanName = 'Nguyễn Văn Ứng Viên';
        // Viết hoa chữ cái đầu
        cleanName = cleanName.split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');

        const autoParsed = {
            name: cleanName,
            email: cleanName.toLowerCase().replace(/\s+/g, '.') + '@gmail.com',
            phone: '09' + Math.floor(10000000 + Math.random() * 90000000),
            exp: 3.5,
            salary: 28000000,
            cvType: cvType,
            fileName: name,
            skills: ['Java', 'Spring Boot', 'SQL', 'Git', 'RESTful API', 'Giao tiếp'],
            summary: 'Hồ sơ trích xuất tự động từ tệp bản mềm: ' + name + '. Đầy đủ các tiêu chí chuyên môn, ứng viên có tác phong làm việc chuyên nghiệp, sẵn sàng nhận việc.',
            workHistory: '3.5 năm kinh nghiệm tại các công ty công nghệ',
            education: 'Đại học chuyên ngành Kỹ thuật / Kinh tế',
            rawText: 'TRÍCH XUẤT TỰ ĐỘNG TỪ TỆP: ' + name + '\nHọ tên: ' + cleanName + '\nĐịnh dạng: ' + cvType + '\nKinh nghiệm: 3.5 năm\nKỹ năng: Java, Spring Boot, SQL, Git, RESTful API'
        };

        renderParsedCvResult(autoParsed);
    }

    function renderParsedCvResult(data) {
        document.getElementById('cvParseResultBox').style.display = 'block';

        // Render preview card
        document.getElementById('previewCvName').textContent = data.name;
        document.getElementById('previewCvEmail').textContent = data.email;
        document.getElementById('previewCvPhone').textContent = data.phone;
        document.getElementById('previewCvExp').textContent = data.exp + ' năm';
        document.getElementById('previewCvSalary').textContent = Number(data.salary).toLocaleString('vi-VN') + ' VNĐ';
        document.getElementById('previewCvFileName').textContent = data.fileName;
        document.getElementById('previewCvSummary').textContent = data.summary;

        // Initials avatar
        const words = data.name.trim().split(/\s+/);
        let initials = 'UV';
        if (words.length >= 2) initials = (words[words.length - 2][0] + words[words.length - 1][0]).toUpperCase();
        else if (words.length === 1) initials = words[0].substring(0, 2).toUpperCase();
        document.getElementById('previewCvAvatar').textContent = initials;

        // Type Badge
        const typeBadge = document.getElementById('cvTypeBadgePreview');
        if (data.cvType === 'WORD') {
            typeBadge.className = 'badge bg-primary px-3 py-2 fs-6';
            typeBadge.innerHTML = '<i class="bi bi-file-earmark-word me-1"></i>Bản Word (.docx)';
        } else if (data.cvType === 'HANDWRITTEN') {
            typeBadge.className = 'badge px-3 py-2 fs-6 text-white';
            typeBadge.style.background = '#7e22ce';
            typeBadge.innerHTML = '<i class="bi bi-pen me-1"></i>Bản chữ viết tay (OCR)';
        } else {
            typeBadge.className = 'badge bg-danger px-3 py-2 fs-6';
            typeBadge.innerHTML = '<i class="bi bi-file-earmark-pdf me-1"></i>Bản PDF (.pdf)';
        }

        // Skills tags
        const tagsContainer = document.getElementById('previewCvSkillsTags');
        tagsContainer.innerHTML = '';
        data.skills.forEach(s => {
            const span = document.createElement('span');
            span.className = 'badge bg-white text-dark border px-2 py-1';
            span.style.fontSize = '0.78rem';
            span.textContent = s;
            tagsContainer.appendChild(span);
        });

        // Tự động điền các trường form ngầm
        document.getElementById('smartCvTypeInput').value = data.cvType;
        document.getElementById('smartCvTextInput').value = data.rawText;
        document.getElementById('inputFullName').value = data.name;
        document.getElementById('inputEmail').value = data.email;
        document.getElementById('inputPhone').value = data.phone;
        document.getElementById('inputExpYears').value = data.exp;
        document.getElementById('inputExpectedSalary').value = data.salary;
        document.getElementById('inputNotes').value = data.summary;
        document.getElementById('inputCvUrl').value = 'uploads/cvs/' + data.fileName;

        // Cuộn mượt xuống phần xem trước
        document.getElementById('cvParseResultBox').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    // =========================================================================
    // 6. TRÌNH XEM TRỰC TIẾP CV BẢN MỀM (#viewCandidateCvModal)
    // =========================================================================
    let currentCvZoom = 1.0;

    function changeCvZoom(delta) {
        currentCvZoom = Math.min(Math.max(0.7, currentCvZoom + delta), 1.4);
        const sheet = document.getElementById('cvDocumentSheet');
        if (sheet) sheet.style.transform = 'scale(' + currentCvZoom + ')';
        const label = document.getElementById('viewerZoomLevel');
        if (label) label.textContent = Math.round(currentCvZoom * 100) + '%';
    }

    function printCandidateCv() {
        window.print();
    }

    function downloadCandidateCv() {
        const name = document.getElementById('viewerCandName').textContent;
        alert('Đang tải xuống bản mềm CV của ứng viên ' + name + '...');
    }

    function openCurrentDrawerCandidateCv() {
        const drawerId = document.getElementById('drawerCandidateIdInput').value;
        if (drawerId) {
            openCandidateCvModalById(drawerId);
        } else {
            alert('Vui lòng chọn một ứng viên để xem CV bản mềm.');
        }
    }

    function downloadCurrentDrawerCandidateCv() {
        const name = document.getElementById('drawerName').textContent;
        alert('Đang tải xuống tệp CV của ứng viên: ' + name);
    }

    function openCandidateCvModalById(candId) {
        // Tìm kiếm ứng viên trong thẻ kanban
        const card = document.querySelector('.store-cand-item[data-id="' + candId + '"]') || document.querySelector('.kanban-card[data-id="' + candId + '"]');
        let name = 'Nguyễn Hoàng Nam', code = 'UV-2026-001', job = 'Senior Fullstack Engineer';
        let email = 'nam.nv@example.com', phone = '0912.345.678', salary = '35.000.000 VNĐ';
        let exp = '4.0', score = '92', skills = 'Java, Spring Boot, Microservices, PostgreSQL, Docker';
        let cvType = 'PDF', cvText = '', summary = '', edu = 'Đại học Bách Khoa Hà Nội', work = '4 năm phát triển phần mềm';

        if (card) {
            name = card.getAttribute('data-name') || name;
            code = card.getAttribute('data-code') || code;
            job = card.getAttribute('data-job') || job;
            email = card.getAttribute('data-email') || email;
            phone = card.getAttribute('data-phone') || phone;
            salary = card.getAttribute('data-salary') || salary;
            exp = card.getAttribute('data-exp') || exp;
            score = card.getAttribute('data-score') || score;
            skills = card.getAttribute('data-skills') || skills;
            summary = card.getAttribute('data-rec') || summary;
            edu = card.getAttribute('data-edu') || edu;
            work = card.getAttribute('data-work') || work;
            cvType = card.getAttribute('data-cv-type') || 'PDF';
            cvText = card.getAttribute('data-cv-text') || '';
        }

        // Đổ dữ liệu vào Modal
        document.getElementById('viewerCandName').textContent = name;
        document.getElementById('viewerCandCode').textContent = code;
        document.getElementById('viewerCandJob').textContent = job;
        document.getElementById('viewerDocFullName').textContent = name.toUpperCase();
        document.getElementById('viewerDocJobTitle').textContent = job.toUpperCase();
        document.getElementById('viewerDocEmail').textContent = email;
        document.getElementById('viewerDocPhone').textContent = phone;
        document.getElementById('viewerDocSalary').textContent = salary.includes('VNĐ') ? salary : salary + ' VNĐ';
        document.getElementById('viewerDocExpYears').textContent = exp + ' năm';
        document.getElementById('viewerDocScoreBadge').innerHTML = '<i class="bi bi-stars me-1"></i>AI MATCH: ' + score + '%';
        document.getElementById('viewerDocEducation').textContent = edu;

        // Initials avatar
        const words = name.trim().split(/\s+/);
        let initials = 'UV';
        if (words.length >= 2) initials = (words[words.length - 2][0] + words[words.length - 1][0]).toUpperCase();
        else if (words.length === 1) initials = words[0].substring(0, 2).toUpperCase();
        document.getElementById('viewerDocAvatar').textContent = initials;

        // Work history
        const workContainer = document.getElementById('viewerDocWorkHistory');
        workContainer.innerHTML = '';
        const workItems = work ? work.split('•') : ['3+ năm kinh nghiệm trong ngành'];
        workItems.forEach(item => {
            const div = document.createElement('div');
            div.className = 'mb-2';
            div.innerHTML = '<div class="fw-semibold text-dark small"><i class="bi bi-check2 text-primary me-1"></i>' + item.trim() + '</div>';
            workContainer.appendChild(div);
        });

        // Summary
        document.getElementById('viewerDocSummary').textContent = summary || 
            ('Ứng viên ' + name + ' có ' + exp + ' năm kinh nghiệm tại vị trí ' + job + '. Hồ sơ thể hiện năng lực chuyên môn vững vàng, khả năng thích ứng nhanh và tinh thần trách nhiệm cao.');

        // Skills List
        const skillsContainer = document.getElementById('viewerDocSkillsList');
        skillsContainer.innerHTML = '';
        const skillArray = skills ? skills.split(',') : ['Chuyên môn', 'Làm việc nhóm', 'Tiếng Anh'];
        skillArray.forEach(s => {
            if (s.trim()) {
                const badge = document.createElement('span');
                badge.className = 'badge bg-light text-dark border px-2 py-1';
                badge.style.fontSize = '0.8rem';
                badge.textContent = s.trim();
                skillsContainer.appendChild(badge);
            }
        });

        // Raw OCR text
        document.getElementById('viewerDocRawText').textContent = cvText || 
            ('TRÍCH XUẤT BẢN MỀM CV: ' + name + '\nVị trí: ' + job + '\nEmail: ' + email + ' | Điện thoại: ' + phone + '\nKỹ năng: ' + skills);

        // Format Badge & Styling
        const typeBadge = document.getElementById('viewerCvTypeBadge');
        const icon = document.getElementById('viewerCvHeaderIcon');
        const sheet = document.getElementById('cvDocumentSheet');

        if (cvType === 'WORD') {
            typeBadge.className = 'badge bg-primary';
            typeBadge.textContent = 'Bản Word (.docx)';
            icon.className = 'bi bi-file-earmark-word-fill fs-4 text-primary';
            sheet.style.fontFamily = 'inherit';
            sheet.style.background = '#ffffff';
        } else if (cvType === 'HANDWRITTEN') {
            typeBadge.className = 'badge text-white';
            typeBadge.style.background = '#7e22ce';
            typeBadge.textContent = 'Bản chữ viết tay (OCR)';
            icon.className = 'bi bi-pen-fill fs-4 text-purple';
            sheet.style.background = '#fffdfa';
        } else {
            typeBadge.className = 'badge bg-danger';
            typeBadge.textContent = 'File PDF (.pdf)';
            icon.className = 'bi bi-file-earmark-pdf-fill fs-4 text-danger';
            sheet.style.fontFamily = 'inherit';
            sheet.style.background = '#ffffff';
        }

        // Reset zoom
        currentCvZoom = 1.0;
        sheet.style.transform = 'scale(1.0)';
        document.getElementById('viewerZoomLevel').textContent = '100%';

        // Mở modal
        new bootstrap.Modal(document.getElementById('viewCandidateCvModal')).show();
    }
</script>
</body>
</html>
