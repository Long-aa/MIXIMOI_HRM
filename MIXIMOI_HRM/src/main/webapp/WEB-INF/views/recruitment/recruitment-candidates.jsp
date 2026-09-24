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
    <c:set var="activeMenu" value="recruitment" scope="request"/>
    <c:set var="activeSubMenu" value="candidates" scope="request"/>
    <!-- Sidebar -->
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <div class="app-main">
        <!-- Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Main Content Area -->
        <main class="app-content p-3 p-lg-4">

            <!-- Toast / Alerts Notification -->
            <c:if test="${param.success eq 'candidate_added'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div><strong>Thành công!</strong> Đã tiếp nhận hồ sơ ứng viên mới vào hệ thống phễu tuyển dụng.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'offer_sent'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-envelope-check-fill fs-5 text-success"></i>
                    <div><strong>Đã phát hành Offer!</strong> Đã gửi thư mời làm việc (Offer Letter) tới ứng viên thành công.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'stage_updated'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-arrow-right-circle-fill fs-5 text-primary"></i>
                    <div><strong>Cập nhật thành công!</strong> Đã chuyển trạng thái vòng tuyển dụng của ứng viên.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'interview_scheduled'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-calendar-check-fill fs-5 text-success"></i>
                    <div><strong>Xếp lịch thành công!</strong> Đã lên lịch phỏng vấn cho ứng viên và gửi thông báo tới người phỏng vấn.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.error eq 'add_candidate_failed'}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                    <div><strong>Lỗi tiếp nhận!</strong> Không thể thêm ứng viên mới. Vui lòng kiểm tra lại thông tin nhập.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.error eq 'update_failed'}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                    <div><strong>Lỗi xử lý!</strong> Không thể cập nhật trạng thái ứng viên. Vui lòng thử lại.</div>
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
                        Quản lý hồ sơ, tài liệu đánh giá và tiến trình tự động của ứng viên theo chuẩn 5 giai đoạn chiến lược.
                    </p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/recruitment?action=export_report" class="btn btn-outline-secondary d-flex align-items-center gap-2 text-decoration-none">
                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Xuất danh sách (Excel)</span>
                    </a>
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="alert('Bộ lọc nâng cao theo kỹ năng & nguồn đang hoạt động.')">
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
            <div class="row g-4">
                <!-- Col-7: Kanban Board Pipeline OR Table -->
                <div class="col-12 col-xl-7">
                    
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
                                            <td class="pe-3 text-end fw-bold text-dark">${c.formattedSalary}</td>
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
                        <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="position-relative">
                                    <div id="drawerAvatarInitials" class="avatar-circle bg-primary text-white fw-bold" style="width: 52px; height: 52px; font-size: 1.15rem;">
                                        ${selectedCandidate.avatarInitials != null ? selectedCandidate.avatarInitials : 'LN'}
                                    </div>
                                    <span class="position-absolute bottom-0 end-0 bg-success text-white rounded-circle p-1" style="font-size: 0.6rem;">
                                        <i class="bi bi-check-lg"></i>
                                    </span>
                                </div>
                                <div>
                                    <div class="d-flex align-items-center gap-2">
                                        <h3 id="drawerName" class="h5 fw-bold text-dark mb-0">${selectedCandidate.fullName}</h3>
                                        <span id="drawerCode" class="badge bg-primary-subtle text-primary font-monospace">${selectedCandidate.candidateCode}</span>
                                    </div>
                                    <div id="drawerJobTitle" class="text-primary fw-semibold" style="font-size: 0.86rem;">${selectedCandidate.jobTitle}</div>
                                    <div class="d-flex align-items-center gap-2 text-warning small mt-1">
                                        <span>⭐⭐⭐⭐⭐</span>
                                        <strong id="drawerRating" class="text-dark">${selectedCandidate.rating}</strong>
                                        <span class="text-muted">(Điểm AI: <strong id="drawerAiScoreText">${selectedCandidate.aiMatchScore}%</strong>)</span>
                                    </div>
                                </div>
                            </div>

                            <a href="#" class="text-muted" title="Mở trang hồ sơ riêng"><i class="bi bi-box-arrow-up-right fs-5"></i></a>
                        </div>

                        <!-- 3 Action Buttons -->
                        <div class="row g-2 mb-3">
                            <div class="col-4">
                                <button type="button" class="btn btn-primary btn-sm w-100 d-flex align-items-center justify-content-center gap-1 shadow-sm" data-bs-toggle="modal" data-bs-target="#sendOfferModal">
                                    <i class="bi bi-envelope-paper"></i> Gửi thư Offer
                                </button>
                            </div>
                            <div class="col-4">
                                <button type="button" class="btn btn-outline-secondary btn-sm w-100 d-flex align-items-center justify-content-center gap-1" data-bs-toggle="modal" data-bs-target="#scheduleCandInterviewModal">
                                    <i class="bi bi-calendar-plus"></i> Lên lịch tiếp
                                </button>
                            </div>
                            <div class="col-4">
                                <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0" onsubmit="return confirm('Bạn có chắc chắn muốn chuyển ứng viên này vào danh sách Từ chối hồ sơ?')">
                                    <input type="hidden" name="action" value="update_stage">
                                    <input type="hidden" name="candidateId" id="drawerCandidateIdInput" value="${selectedCandidate.id}">
                                    <input type="hidden" name="stage" value="REJECTED">
                                    <button type="submit" class="btn btn-outline-danger btn-sm w-100 d-flex align-items-center justify-content-center gap-1">
                                        <i class="bi bi-person-x"></i> Từ chối hồ sơ
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Contact Grid -->
                        <div class="row g-2 mb-3" style="font-size: 0.8rem;">
                            <div class="col-6">
                                <span class="text-muted"><i class="bi bi-envelope me-1"></i>Email:</span>
                                <strong id="drawerEmail" class="text-dark ms-1">${selectedCandidate.email}</strong>
                            </div>
                            <div class="col-6">
                                <span class="text-muted"><i class="bi bi-telephone me-1"></i>Điện thoại:</span>
                                <strong id="drawerPhone" class="text-dark ms-1">${selectedCandidate.phone}</strong>
                            </div>
                            <div class="col-6">
                                <span class="text-muted"><i class="bi bi-geo-alt me-1"></i>Địa chỉ:</span>
                                <span class="text-dark ms-1">Hà Nội</span>
                            </div>
                            <div class="col-6">
                                <span class="text-muted"><i class="bi bi-link-45deg me-1"></i>Nguồn:</span>
                                <span id="drawerSource" class="badge bg-light text-primary border ms-1">${selectedCandidate.source}</span>
                            </div>
                        </div>

                        <!-- CV Attachment Card with Working AI Screener -->
                        <div class="p-2 px-3 bg-light border rounded-3 d-flex justify-content-between align-items-center mb-3">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-file-earmark-pdf-fill text-danger fs-4"></i>
                                <div>
                                    <div id="drawerCvFileName" class="fw-bold text-dark" style="font-size: 0.83rem;">
                                        ${selectedCandidate != null ? selectedCandidate.cvFileName : 'CV_Ung_Vien.pdf'}
                                    </div>
                                    <small class="text-muted">2.4 MB • Đã tải lên hệ thống</small>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <button class="btn btn-sm btn-purple text-purple border-purple fw-semibold py-1 px-2"
                                        style="background: #f3e8ff; color: #7e22ce; border-color: #d8b4fe;"
                                        data-bs-toggle="modal" data-bs-target="#aiCvAnalysisModal"
                                        title="AI Đọc & Phân Tích CV">
                                    <i class="bi bi-stars me-1"></i> AI Đọc CV
                                </button>
                                <button class="btn btn-sm btn-light border py-1 px-2" title="Xem trước" onclick="alert('Đang hiển thị chế độ xem nhanh tệp CV PDF của ứng viên.')"><i class="bi bi-eye"></i></button>
                                <button class="btn btn-sm btn-light border py-1 px-2" title="Tải xuống" onclick="alert('Đã tải xuống tệp CV của ứng viên.')"><i class="bi bi-download"></i></button>
                            </div>
                        </div>

                        <!-- AI CV Insights Summary -->
                        <div class="ai-insight-box mb-3">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="ai-sparkle-badge"><i class="bi bi-robot"></i> KẾT QUẢ AI ĐỌC & ĐÁNH GIÁ CV</span>
                                <span id="drawerAiScoreBadge" class="badge bg-success text-white fw-bold">${selectedCandidate.aiMatchScore}% MATCH</span>
                            </div>
                            <div id="drawerAiRecommendation" class="small text-dark mb-2" style="font-size: 0.78rem;">
                                <strong>Đánh giá của AI:</strong> ${selectedCandidate.aiRecommendation}
                            </div>
                            <div class="progress mb-2" style="height: 6px;">
                                <div id="drawerAiProgressBar" class="progress-bar ai-match-progress-bar" style="width: ${selectedCandidate.aiMatchScore}%;"></div>
                            </div>
                            <div class="d-flex justify-content-between text-muted" style="font-size: 0.72rem;">
                                <span>✔ Kinh nghiệm: <strong id="drawerExp">${selectedCandidate.experienceYears} năm</strong></span>
                                <span>✔ Lương kỳ vọng: <strong id="drawerExpectedSalary">${selectedCandidate.formattedSalary}</strong></span>
                                <span class="text-success fw-bold">✔ Khuyến nghị: Ưu tiên</span>
                            </div>
                        </div>

                        <!-- Education & Experience -->
                        <div class="mb-3">
                            <div class="fw-bold text-dark small text-uppercase mb-1">HỌC VẤN & KINH NGHIỆM</div>
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
                            <div class="fw-bold text-dark small text-uppercase mb-1">KỸ NĂNG CỐT LÕI (AI DETECTED)</div>
                            <div id="drawerSkillsTags" class="d-flex flex-wrap gap-1">
                                <c:forEach items="${selectedCandidate.skillList}" var="sk">
                                    <span class="badge bg-light text-dark border">${sk}</span>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Evaluation History -->
                        <div class="mb-3">
                            <div class="fw-bold text-dark small text-uppercase mb-2">LỊCH SỬ ĐÁNH GIÁ VÒNG TUYỂN</div>
                            <div class="p-2 px-3 border rounded-2 bg-light mb-2" style="font-size: 0.78rem;">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="fw-bold text-dark">Vòng 1: HR Screener & Văn hóa</span>
                                    <span class="badge bg-success-subtle text-success">8.5 / 10 • Đạt</span>
                                </div>
                                <div class="text-muted fst-italic">"Giao tiếp tự tin, phong thái điềm đạm, định hướng gắn bó lâu dài."</div>
                                <div class="text-end text-muted small mt-1">Đánh giá bởi: <strong>Phạm Phương Thảo (HR Lead)</strong></div>
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
                                    <small class="text-muted d-block">Mức lương đề xuất</small>
                                    <span id="drawerOfferSalary" class="fw-bold text-primary fs-5">${selectedCandidate.formattedSalary}</span>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted d-block">Ngày dự kiến Onboard</small>
                                    <span class="fw-bold text-dark fs-6">15/10/2026</span>
                                </div>
                            </div>
                            <div class="small text-muted border-top pt-2">
                                <i class="bi bi-info-circle text-primary me-1"></i>
                                Bao gồm 100% lương thử việc, bảo hiểm sức khỏe Bảo Việt & 14 ngày phép/năm.
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
<!-- MODAL 1: THÊM ỨNG VIÊN MỚI VÀO PHỄU (#addCandidateModal)                  -->
<!-- ========================================================================= -->
<div class="modal fade" id="addCandidateModal" tabindex="-1" aria-labelledby="addCandidateModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-person-plus-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="addCandidateModalLabel">Tiếp Nhận Hồ Sơ Ứng Viên Mới</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Nhập thông tin ứng viên và lưu vào cơ sở dữ liệu phễu tuyển dụng</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                <input type="hidden" name="action" value="add_candidate">
                <div class="modal-body p-4">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Họ và tên ứng viên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-sm" name="fullName" placeholder="VD: Nguyễn Văn Nam" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Vị trí ứng tuyển <span class="text-danger">*</span></label>
                            <select class="form-select form-select-sm" name="recruitmentRequestId" required>
                                <c:forEach items="${jobs}" var="j">
                                    <option value="${j.id}">${j.title} (${j.requestCode})</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Email liên hệ <span class="text-danger">*</span></label>
                            <input type="email" class="form-control form-control-sm" name="email" placeholder="nam.nv@example.com" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control form-control-sm" name="phone" placeholder="0912 345 678" required>
                        </div>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Nguồn tuyển dụng</label>
                            <select class="form-select form-select-sm" name="source">
                                <option value="LinkedIn" selected>LinkedIn</option>
                                <option value="TopCV/VNW">TopCV / VietnamWorks</option>
                                <option value="Nội bộ (Ref)">Giới thiệu nội bộ (Ref)</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Số năm kinh nghiệm</label>
                            <input type="number" step="0.5" class="form-control form-control-sm" name="experienceYears" value="3.0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Mức lương mong muốn (VNĐ)</label>
                            <input type="number" step="1000000" class="form-control form-control-sm" name="expectedSalary" placeholder="30.000.000">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Đường link CV / Portfolio</label>
                        <input type="url" class="form-control form-control-sm" name="cvUrl" placeholder="https://linkedin.com/in/... hoặc Drive CV">
                    </div>
                    <div>
                        <label class="form-label small fw-semibold text-muted">Ghi chú ứng viên</label>
                        <textarea class="form-control form-control-sm" name="notes" rows="2" placeholder="Ghi chú về điểm mạnh, kỹ năng nổi bật..."></textarea>
                    </div>
                </div>
                <div class="modal-footer bg-light border-top p-3 px-4">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Thêm ứng viên vào phễu</span>
                    </button>
                </div>
            </form>
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

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-muted">Mức lương Net đề xuất (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control form-control-sm font-monospace fw-bold" name="offerSalary" value="35000000" step="1000000" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-muted">Ngày bắt đầu làm việc <span class="text-danger">*</span></label>
                            <input type="date" class="form-control form-control-sm" name="onboardDate" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Gói phúc lợi đính kèm</label>
                        <textarea class="form-control form-control-sm" name="benefits" rows="2">100% lương thử việc 2 tháng đầu, gói Bảo hiểm sức khỏe Bảo Việt Gold, 14 ngày phép/năm, trợ cấp ăn trưa 50.000đ/ngày.</textarea>
                    </div>
                </div>
                <div class="modal-footer bg-light border-top p-3 px-4">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
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
                        <div class="fw-bold text-dark fs-6">${selectedCandidate.fullName} (${selectedCandidate.candidateCode})</div>
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

<!-- ========================================================================= -->
<!-- MODAL 4: PHÂN TÍCH CHUYÊN SÂU AI CHO 1 CV (#aiCvAnalysisModal)             -->
<!-- ========================================================================= -->
<div class="modal fade" id="aiCvAnalysisModal" tabindex="-1" aria-labelledby="aiCvAnalysisModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-ai p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-stars fs-4"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="aiCvAnalysisModalLabel">Báo Cáo Phân Tích CV Chuyên Sâu Bằng AI</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Đánh giá mức độ khớp JD, ưu thế kỹ năng và bộ câu hỏi trắc nghiệm năng lực</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4" style="background: #f8fafc;">
                <!-- Header Info -->
                <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div>
                            <h6 class="fw-bold text-dark mb-0" id="aiCandModalName">${selectedCandidate.fullName}</h6>
                            <small class="text-primary" id="aiCandModalJob">${selectedCandidate.jobTitle}</small>
                        </div>
                        <span class="badge bg-success text-white fw-bold px-3 py-2 fs-6" id="aiCandModalScoreBadge">
                            🥇 AI Match: ${selectedCandidate.aiMatchScore}%
                        </span>
                    </div>
                    <div class="progress mb-2" style="height: 8px;">
                        <div class="progress-bar ai-match-progress-bar" id="aiCandModalProgressBar" style="width: ${selectedCandidate.aiMatchScore}%;"></div>
                    </div>
                </div>

                <!-- Skills Breakdown -->
                <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                    <h6 class="fw-bold text-dark mb-3">1. Phân tích bóc tách kỹ năng (Skills Extraction)</h6>
                    <div class="p-3 border rounded bg-light mb-2">
                        <div class="fw-bold text-success mb-1"><i class="bi bi-check-circle-fill me-1"></i>Kỹ năng khớp 100%:</div>
                        <div class="text-muted small" id="aiCandModalMatchedSkills">${selectedCandidate.aiMatchedSkills}</div>
                    </div>
                    <div class="p-3 border rounded bg-light">
                        <div class="fw-bold text-warning mb-1"><i class="bi bi-exclamation-triangle-fill me-1"></i>Kỹ năng cần bổ sung / phỏng vấn thêm:</div>
                        <div class="text-muted small" id="aiCandModalMissingSkills">${selectedCandidate.aiMissingSkills}</div>
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
                                        <p class="text-muted mb-0 mt-1">"Trình bày giải pháp bạn đã từng triển khai để tối ưu hiệu năng cơ sở dữ liệu lớn?"</p>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="modal-footer bg-white border-top p-3 px-4">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" onclick="alert('Đã lưu kết quả phân tích AI vào hồ sơ ứng viên.')">
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

        const id = cardElement.getAttribute('data-id');
        const name = cardElement.getAttribute('data-name');
        const code = cardElement.getAttribute('data-code');
        const job = cardElement.getAttribute('data-job');
        const email = cardElement.getAttribute('data-email');
        const phone = cardElement.getAttribute('data-phone');
        const source = cardElement.getAttribute('data-source');
        const score = cardElement.getAttribute('data-score');
        const rating = cardElement.getAttribute('data-rating');
        const avatar = cardElement.getAttribute('data-avatar');
        const salary = cardElement.getAttribute('data-salary');
        const exp = cardElement.getAttribute('data-exp');
        const rec = cardElement.getAttribute('data-rec');
        const edu = cardElement.getAttribute('data-edu');
        const work = cardElement.getAttribute('data-work');
        const skills = cardElement.getAttribute('data-skills');

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

        // Gửi AJAX ngầm cập nhật Database
        const formData = new URLSearchParams();
        formData.append('action', 'update_stage');
        formData.append('candidateId', candidateId);
        formData.append('stage', targetStage);
        formData.append('ajax', 'true');

        fetch('${pageContext.request.contextPath}/recruitment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                console.log('Cập nhật stage thành công:', targetStage);
            }
        })
        .catch(err => {
            console.error('Lỗi cập nhật stage:', err);
        });
    }

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
</script>
</body>
</html>