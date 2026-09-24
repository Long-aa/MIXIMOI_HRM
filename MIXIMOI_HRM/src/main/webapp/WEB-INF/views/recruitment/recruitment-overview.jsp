<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Tổng quan Tuyển dụng & Phễu nhân tài - MIXIMOI HRM" />
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

            <!-- Toast / Alerts Notification -->
            <c:if test="${param.success eq 'request_created'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div><strong>Thành công!</strong> Đã tạo mới yêu cầu tuyển dụng và đồng bộ vào hệ thống.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.success eq 'interview_scheduled'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-calendar-check-fill fs-5 text-success"></i>
                    <div><strong>Thành công!</strong> Đã xếp lịch phỏng vấn mới thành công và gửi thông báo tới người phỏng vấn.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.error eq 'create_failed'}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                    <div><strong>Lỗi!</strong> Không thể tạo yêu cầu tuyển dụng. Vui lòng kiểm tra lại thông tin nhập.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Tuyển dụng</h1>
                        <span class="badge bg-primary-subtle text-primary fw-bold">${not empty currentQuarter ? currentQuarter : 'Q3/2026'}</span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý toàn bộ quy trình tuyển dụng và tiến độ tuyển nhân sự toàn công ty.
                    </p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <!-- Nút Xuất báo cáo -->
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#exportReportModal">
                        <i class="bi bi-file-earmark-spreadsheet"></i>
                        <span>Xuất báo cáo</span>
                    </button>

                    <!-- Nút Lịch phỏng vấn tuần này -->
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#interviewWeekModal">
                        <i class="bi bi-calendar-week"></i>
                        <span>Lịch phỏng vấn tuần này</span>
                    </button>

                    <!-- Nút Tạo yêu cầu tuyển dụng -->
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createJobReqModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>Tạo yêu cầu tuyển dụng</span>
                    </button>
                </div>
            </div>

            <!-- Top Filter & Segments Form -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body p-3">
                    <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/recruitment">
                        <div class="row g-2 align-items-center mb-3">
                            <div class="col-6 col-md-3">
                                <select class="form-select form-select-sm" name="quarter" onchange="document.getElementById('filterForm').submit()">
                                    <option value="Q3/2026" ${currentQuarter eq 'Q3/2026' ? 'selected' : ''}>Kỳ: Quý 3/2026</option>
                                    <option value="Q4/2026" ${currentQuarter eq 'Q4/2026' ? 'selected' : ''}>Kỳ: Quý 4/2026 (Kế hoạch)</option>
                                    <option value="Toàn năm 2026" ${currentQuarter eq 'Toàn năm 2026' ? 'selected' : ''}>Toàn năm 2026</option>
                                </select>
                            </div>
                            <div class="col-6 col-md-3">
                                <select class="form-select form-select-sm" name="departmentId" onchange="document.getElementById('filterForm').submit()">
                                    <option value="">Tất cả phòng ban</option>
                                    <c:forEach items="${departments}" var="dept">
                                        <option value="${dept.id}" ${selectedDeptId == dept.id ? 'selected' : ''}>${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-6 col-md-3">
                                <select class="form-select form-select-sm" name="status" onchange="document.getElementById('filterForm').submit()">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="OPEN" ${selectedStatus eq 'OPEN' ? 'selected' : ''}>Đang tuyển</option>
                                    <option value="PAUSED" ${selectedStatus eq 'PAUSED' ? 'selected' : ''}>Tạm dừng</option>
                                    <option value="FILLED" ${selectedStatus eq 'FILLED' ? 'selected' : ''}>Đã đủ</option>
                                    <option value="CLOSED" ${selectedStatus eq 'CLOSED' ? 'selected' : ''}>Đã đóng</option>
                                </select>
                            </div>
                            <div class="col-6 col-md-3 d-flex gap-2">
                                <select class="form-select form-select-sm" name="assigneeId" onchange="document.getElementById('filterForm').submit()">
                                    <option value="">Người phụ trách: Tất cả</option>
                                    <c:forEach items="${employees}" var="emp">
                                        <option value="${emp.id}" ${selectedAssigneeId == emp.id ? 'selected' : ''}>${emp.fullName}</option>
                                    </c:forEach>
                                </select>
                                <a href="${pageContext.request.contextPath}/recruitment" class="btn btn-sm btn-outline-secondary" title="Đặt lại bộ lọc">
                                    <i class="bi bi-arrow-repeat"></i>
                                </a>
                            </div>
                        </div>

                        <!-- Filter Pill Chips -->
                        <div class="d-flex flex-wrap gap-2 pt-2 border-top">
                            <a href="${pageContext.request.contextPath}/recruitment?quarter=${currentQuarter}" 
                               class="btn btn-sm ${empty currentPill ? 'btn-primary' : 'btn-light border'} py-1 px-3 fw-semibold text-decoration-none">
                                Tất cả vị trí (${stats.totalRequestsCount})
                            </a>
                            <a href="${pageContext.request.contextPath}/recruitment?quarter=${currentQuarter}&pill=open" 
                               class="btn btn-sm ${currentPill eq 'open' ? 'btn-primary' : 'btn-light border'} py-1 px-3 fw-semibold text-decoration-none">
                                Đang tuyển (${stats.openRequestsCount})
                            </a>
                            <a href="${pageContext.request.contextPath}/recruitment?quarter=${currentQuarter}&pill=urgent" 
                               class="btn btn-sm ${currentPill eq 'urgent' ? 'btn-danger text-white' : 'btn-light border text-danger'} py-1 px-3 fw-semibold text-decoration-none">
                                🔥 Ưu tiên gấp (${stats.urgentRequestsCount})
                            </a>
                            <a href="${pageContext.request.contextPath}/recruitment?quarter=${currentQuarter}&pill=expiring" 
                               class="btn btn-sm ${currentPill eq 'expiring' ? 'btn-warning text-dark' : 'btn-light border text-warning-emphasis'} py-1 px-3 fw-semibold text-decoration-none">
                                ⏳ Sắp hết hạn (${stats.expiringRequestsCount})
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1: Vị trí đang tuyển -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Vị trí đang tuyển</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-briefcase"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${stats.openPositionsCount}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Trên ${stats.openDepartmentsCount} phòng ban chức năng</span>
                            <span class="badge bg-primary-subtle text-primary fw-semibold">+${stats.newPositionsDiffMonth} so với tháng trước</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2: Ứng viên tiếp nhận -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Ứng viên tiếp nhận</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-person-lines-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${stats.totalCandidates}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Hồ sơ ứng tuyển mới</span>
                            <span class="badge bg-purple-subtle text-purple fw-semibold" style="background: #f3e8ff; color: #7e22ce;">↗ +${stats.candidateGrowthPct}% tỷ lệ ứng tuyển</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3: Đang phỏng vấn -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang phỏng vấn</span>
                            <div class="kpi-icon-box cyan">
                                <i class="bi bi-calendar2-check"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">${stats.interviewingCandidatesCount}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Vòng 1 & Vòng Chuyên môn</span>
                            <span class="badge bg-info-subtle text-info fw-semibold">⏱ ${stats.todayInterviewsCount} lịch hôm nay</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4: Đã tuyển dụng -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã tuyển dụng</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-patch-check-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">${stats.hiredCandidatesCount}</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Tỷ lệ lấp đầy: <strong>${stats.fillRateFormatted}%</strong></span>
                            <span class="badge bg-success-subtle text-success fw-semibold">+${stats.newHiresThisWeek} ứng viên tuần này</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Middle Row: Funnel Pipeline & Sourcing + Schedule -->
            <div class="row g-4 mb-4">
                <!-- Col-8: Funnel Pipeline -->
                <div class="col-12 col-lg-8">
                    <div class="card border-0 shadow-sm rounded-3 p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h3 class="h6 fw-bold text-dark mb-0">Phễu tuyển dụng tổng thể</h3>
                                <small class="text-muted">Recruitment Pipeline Funnel & Tỷ lệ chuyển đổi qua các vòng</small>
                            </div>
                            <span class="badge bg-light text-dark border font-monospace">Time-to-hire TB: <strong>${stats.avgTimeToHireDays} ngày</strong></span>
                        </div>

                        <div class="funnel-pipeline-list">
                            <!-- Stage 1 -->
                            <div class="funnel-step-item">
                                <div class="funnel-step-progress" style="width: ${stats.funnelStage1Pct}%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">1</span>
                                        <div>
                                            <span class="fw-bold text-dark">Ứng viên mới</span>
                                            <span class="text-muted small ms-1">(Tiếp nhận qua các kênh)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-dark fs-6">${stats.funnelStage1Count} hồ sơ</span>
                                        <span class="badge bg-primary-subtle text-primary">${stats.funnelStage1Pct}%</span>
                                        <span class="badge bg-light text-muted border">Drop: 0%</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Stage 2 -->
                            <div class="funnel-step-item">
                                <div class="funnel-step-progress" style="width: ${stats.funnelStage2Pct}%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">2</span>
                                        <div>
                                            <span class="fw-bold text-dark">Sàng lọc CV</span>
                                            <span class="text-muted small ms-1">(HR Pre-screening)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-dark fs-6">${stats.funnelStage2Count} hồ sơ</span>
                                        <span class="badge bg-primary-subtle text-primary">${stats.funnelStage2Pct}%</span>
                                        <span class="badge bg-danger-subtle text-danger">Drop: ${stats.funnelStage2Drop}%</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Stage 3 -->
                            <div class="funnel-step-item">
                                <div class="funnel-step-progress" style="width: ${stats.funnelStage3Pct}%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">3</span>
                                        <div>
                                            <span class="fw-bold text-dark">Phỏng vấn & Test</span>
                                            <span class="text-muted small ms-1">(Kỹ thuật & Văn hóa)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-dark fs-6">${stats.funnelStage3Count} ứng viên</span>
                                        <span class="badge bg-primary-subtle text-primary">${stats.funnelStage3Pct}%</span>
                                        <span class="badge bg-danger-subtle text-danger">Drop: ${stats.funnelStage3Drop}%</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Stage 4 -->
                            <div class="funnel-step-item">
                                <div class="funnel-step-progress" style="width: ${stats.funnelStage4Pct}%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-primary rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">4</span>
                                        <div>
                                            <span class="fw-bold text-dark">Gửi Offer lương</span>
                                            <span class="text-muted small ms-1">(Thương lượng chế độ)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-dark fs-6">${stats.funnelStage4Count} ứng viên</span>
                                        <span class="badge bg-warning-subtle text-warning-emphasis">${stats.funnelStage4Pct}%</span>
                                        <span class="badge bg-danger-subtle text-danger">Drop: ${stats.funnelStage4Drop}%</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Stage 5 -->
                            <div class="funnel-step-item bg-success-subtle bg-opacity-25 border-success-subtle">
                                <div class="funnel-step-progress bg-success bg-opacity-10" style="width: ${stats.funnelStage5Pct}%;"></div>
                                <div class="funnel-step-content">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge bg-success rounded-circle" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">5</span>
                                        <div>
                                            <span class="fw-bold text-success">Đã nhận việc (Onboarding)</span>
                                            <span class="text-muted small ms-1">(Thành công)</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="fw-bold text-success fs-6">${stats.funnelStage5Count} nhân sự</span>
                                        <span class="badge bg-success text-white">${stats.funnelStage5Pct}%</span>
                                        <span class="badge bg-success-subtle text-success border border-success-subtle">Hoàn tất quy trình</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Col-4: Sourcing Channels & Today's Schedule -->
                <div class="col-12 col-lg-4">
                    <!-- Widget 1: Sourcing Channels -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h4 class="h6 fw-bold text-dark mb-0">Nguồn tuyển dụng</h4>
                            <span class="badge bg-light text-muted border">${stats.totalCandidates} ứng viên</span>
                        </div>
                        <div class="progress mb-3" style="height: 10px;">
                            <div class="progress-bar bg-primary" style="width: ${stats.sourceLinkedInPct}%" title="LinkedIn ${stats.sourceLinkedInPct}%"></div>
                            <div class="progress-bar bg-info" style="width: ${stats.sourceTopCVPct}%" title="TopCV / VNWorks ${stats.sourceTopCVPct}%"></div>
                            <div class="progress-bar bg-purple" style="width: ${stats.sourceRefPct}%; background: #9333ea;" title="Nội bộ Referral ${stats.sourceRefPct}%"></div>
                            <div class="progress-bar bg-secondary" style="width: ${stats.sourceOtherPct}%" title="Khác ${stats.sourceOtherPct}%"></div>
                        </div>
                        <div class="row g-2" style="font-size: 0.78rem;">
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light d-flex justify-content-between">
                                    <span><span class="badge-dot-indicator bg-primary"></span>LinkedIn</span>
                                    <strong>${stats.sourceLinkedInPct}% (${stats.sourceLinkedInCount})</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light d-flex justify-content-between">
                                    <span><span class="badge-dot-indicator bg-info"></span>TopCV / VNW</span>
                                    <strong>${stats.sourceTopCVPct}% (${stats.sourceTopCVCount})</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light d-flex justify-content-between">
                                    <span><span class="badge-dot-indicator" style="background:#9333ea;"></span>Nội bộ (Ref)</span>
                                    <strong>${stats.sourceRefPct}% (${stats.sourceRefCount})</strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light d-flex justify-content-between">
                                    <span><span class="badge-dot-indicator bg-secondary"></span>Khác</span>
                                    <strong>${stats.sourceOtherPct}% (${stats.sourceOtherCount})</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Widget 2: Today's Interview Schedule -->
                    <div class="card border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center gap-2">
                                <h4 class="h6 fw-bold text-dark mb-0">Lịch phỏng vấn hôm nay</h4>
                                <span class="badge-dot-indicator bg-danger"></span>
                            </div>
                            <span class="badge bg-danger-subtle text-danger">${stats.todayInterviewsCount} ca xếp lịch</span>
                        </div>
                        <div class="interview-schedule-list">
                            <c:choose>
                                <c:when test="${not empty todayInterviews}">
                                    <c:forEach items="${todayInterviews}" var="iv" varStatus="st">
                                        <div class="interview-timeline-item">
                                            <div class="interview-time-pill" style="${st.index == 1 ? 'background: #fdf4ff; color: #a21caf;' : (st.index == 2 ? 'background: #ecfdf5; color: #059669;' : '')}">
                                                ${iv.timeHours}<br>${iv.timePeriod}
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold text-dark" style="font-size: 0.83rem;">${iv.candidateName}</div>
                                                <div class="text-muted" style="font-size: 0.74rem;">${iv.jobTitle}</div>
                                                <div class="text-primary mt-1" style="font-size: 0.72rem;">
                                                    <i class="bi bi-person-video"></i> PV: ${iv.interviewerName} • ${iv.roundName}
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4 text-muted small">
                                        <i class="bi bi-calendar2-x fs-4 d-block mb-1"></i>
                                        Chưa có ca phỏng vấn nào được xếp lịch cho ngày hôm nay.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom: Recruitment Campaigns Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <h2 class="h6 fw-bold mb-0 text-dark">Danh sách yêu cầu tuyển dụng</h2>
                        <span class="badge bg-primary-subtle text-primary border-0" id="campaignCountBadge">${recruitmentRequests.size()} chiến dịch đang chạy</span>
                    </div>

                    <div class="d-flex flex-wrap align-items-center gap-2">
                        <div class="input-group input-group-sm" style="width: 240px;">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                            <input type="text" id="campaignSearchInput" class="form-control border-start-0" placeholder="Tìm theo vị trí, mã yêu cầu...">
                        </div>
                        <ul class="nav nav-pills nav-fill payment-batch-tabs" id="campaignStatusTabs">
                            <li class="nav-item"><a class="nav-link active py-1 px-2" href="#" data-status="ALL">Tất cả</a></li>
                            <li class="nav-item"><a class="nav-link py-1 px-2" href="#" data-status="OPEN">Đang tuyển</a></li>
                            <li class="nav-item"><a class="nav-link py-1 px-2" href="#" data-status="PAUSED">Tạm dừng</a></li>
                            <li class="nav-item"><a class="nav-link py-1 px-2" href="#" data-status="FILLED">Đã đủ</a></li>
                            <li class="nav-item"><a class="nav-link py-1 px-2" href="#" data-status="CLOSED">Đã đóng</a></li>
                        </ul>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap" id="campaignTable" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3" style="width: 140px;">Mã yêu cầu</th>
                                <th>Vị trí tuyển dụng</th>
                                <th>Phòng ban</th>
                                <th class="text-center">Cần tuyển</th>
                                <th class="text-center">Ứng viên</th>
                                <th class="text-center">Phỏng vấn</th>
                                <th style="width: 180px;">Đã tuyển</th>
                                <th>Hạn chót</th>
                                <th class="pe-3">Người phụ trách</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recruitmentRequests}" var="req">
                                <tr data-status="${req.status}" data-text="${req.requestCode} ${req.title} ${req.departmentName}">
                                    <td class="ps-3 fw-bold font-monospace text-primary">
                                        <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="text-decoration-none">
                                            ${req.requestCode}
                                        </a>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark">
                                            ${req.title}
                                            <c:if test="${req.priority eq 'HOT'}">
                                                <span class="badge bg-danger ms-1">HOT</span>
                                            </c:if>
                                            <c:if test="${req.priority eq 'URGENT'}">
                                                <span class="badge bg-warning text-dark ms-1">GẤP</span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border">${req.departmentName}</span>
                                    </td>
                                    <td class="text-center fw-bold">${req.targetHeadcount}</td>
                                    <td class="text-center font-monospace">${req.candidateCount}</td>
                                    <td class="text-center font-monospace text-primary fw-bold">${req.interviewCount}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="progress flex-grow-1" style="height: 6px;">
                                                <div class="progress-bar ${req.fillPercentage >= 100 ? 'bg-success' : 'bg-primary'}" style="width: ${req.fillPercentage}%;"></div>
                                            </div>
                                            <span class="small fw-bold ${req.fillPercentage >= 100 ? 'text-success' : ''}">
                                                ${req.hiredCount}/${req.targetHeadcount} (${req.fillPercentage}%)
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div><fmt:parseDate value="${req.deadline}" pattern="yyyy-MM-dd" var="parsedDate" type="date"/><fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/></div>
                                        <c:choose>
                                            <c:when test="${req.status eq 'FILLED'}">
                                                <small class="text-success fw-semibold">Đã hoàn thành</small>
                                            </c:when>
                                            <c:when test="${req.status eq 'CLOSED'}">
                                                <small class="text-muted">Đã đóng kỳ</small>
                                            </c:when>
                                            <c:when test="${req.status eq 'PAUSED'}">
                                                <small class="text-muted">Tạm ngưng nhận HS</small>
                                            </c:when>
                                            <c:when test="${req.daysRemaining <= 10 and req.daysRemaining >= 0}">
                                                <small class="text-danger fw-bold">⚠ Còn ${req.daysRemaining} ngày</small>
                                            </c:when>
                                            <c:when test="${req.daysRemaining > 10}">
                                                <small class="text-primary">Còn ${req.daysRemaining} ngày</small>
                                            </c:when>
                                            <c:otherwise>
                                                <small class="text-danger">Hết hạn</small>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="pe-3">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="avatar-circle bg-primary-subtle text-primary fw-bold" style="width: 26px; height: 26px; font-size: 0.7rem;">
                                                ${req.assigneeAvatarInitials}
                                            </div>
                                            <span>${req.assigneeName}</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white border-top py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                    <span class="text-muted small">Hiển thị <strong>1 - ${recruitmentRequests.size()}</strong> trong tổng số <strong>${stats.totalRequestsCount}</strong> vị trí tuyển dụng</span>
                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled"><a class="page-link" href="#">Trước</a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">Sau</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 1: TẠO YÊU CẦU TUYỂN DỤNG (#createJobReqModal)                       -->
<!-- Thiết kế đồng bộ màu sắc thương hiệu MIXIMOI Blue (#2563eb), bo mềm       -->
<!-- ========================================================================= -->
<div class="modal fade" id="createJobReqModal" tabindex="-1" aria-labelledby="createJobReqModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-briefcase-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="createJobReqModalLabel">Tạo Yêu Cầu Tuyển Dụng Mới</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Khởi tạo chiến dịch tìm kiếm và chiêu mộ nhân tài cho MIXIMOI</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                <input type="hidden" name="action" value="create_request">
                
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

                        <div class="row g-3">
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
                                    <option value="URGENT">🔥 Ưu tiên gấp</option>
                                    <option value="HOT">🚨 HOT Tuyển gấp</option>
                                </select>
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
                                    <input class="form-check-input" type="checkbox" name="salaryNegotiable" id="salaryNegotiable">
                                    <label class="form-check-label small" for="salaryNegotiable">Thỏa thuận</label>
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
                        <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">3. Chi tiết mô tả công việc (JD) & Tiêu chí</h6>
                        
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Mô tả công việc (Job Description)</label>
                            <textarea class="form-control form-control-sm" name="description" rows="3" placeholder="Chi tiết trách nhiệm công việc, nhiệm vụ chính..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Yêu cầu ứng viên (Requirements)</label>
                            <textarea class="form-control form-control-sm" name="requirements" rows="3" placeholder="Số năm kinh nghiệm, kỹ năng chuyên môn, bằng cấp..."></textarea>
                        </div>
                        <div>
                            <label class="form-label small fw-semibold text-muted">Quyền lợi & Chế độ đãi ngộ (Benefits)</label>
                            <textarea class="form-control form-control-sm" name="benefits" rows="2" placeholder="Lương thưởng, bảo hiểm, đào tạo, lộ trình thăng tiến..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-white border-top p-3 px-4">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Tạo yêu cầu tuyển dụng</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 2: LỊCH PHỎNG VẤN TUẦN NÀY (#interviewWeekModal)                    -->
<!-- Calendar tuần chuyên nghiệp với 7 ngày, lọc ca phỏng vấn & nút xếp lịch   -->
<!-- ========================================================================= -->
<div class="modal fade" id="interviewWeekModal" tabindex="-1" aria-labelledby="interviewWeekModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-calendar-week-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="interviewWeekModalLabel">Lịch Phỏng Vấn Tuần Này</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Toàn bộ các ca phỏng vấn được xếp lịch trong tuần làm việc</small>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2 ms-auto me-2">
                    <button type="button" class="btn btn-sm btn-light fw-semibold text-primary d-flex align-items-center gap-1 shadow-sm" 
                            data-bs-toggle="modal" data-bs-target="#scheduleInterviewModal">
                        <i class="bi bi-plus-circle-fill"></i>
                        <span>Xếp lịch phỏng vấn mới</span>
                    </button>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4" style="background: #f8fafc;">
                <!-- Weekday Nav Buttons -->
                <div class="interview-week-nav mb-3">
                    <button type="button" class="interview-week-day-btn active" onclick="filterWeekDay('ALL', this)">
                        <div>Tất cả tuần</div>
                        <span class="badge bg-primary-subtle text-primary rounded-pill mt-1">${weeklyInterviews.size()} ca</span>
                    </button>
                    <button type="button" class="interview-week-day-btn" onclick="filterWeekDay('2', this)">
                        <div>Thứ 2</div>
                        <span class="badge bg-light text-muted rounded-pill mt-1">Đầu tuần</span>
                    </button>
                    <button type="button" class="interview-week-day-btn" onclick="filterWeekDay('3', this)">
                        <div>Thứ 3</div>
                        <span class="badge bg-light text-muted rounded-pill mt-1">Hôm nay</span>
                    </button>
                    <button type="button" class="interview-week-day-btn" onclick="filterWeekDay('4', this)">
                        <div>Thứ 4</div>
                        <span class="badge bg-light text-muted rounded-pill mt-1">Giữa tuần</span>
                    </button>
                    <button type="button" class="interview-week-day-btn" onclick="filterWeekDay('5', this)">
                        <div>Thứ 5</div>
                        <span class="badge bg-light text-muted rounded-pill mt-1">Lịch chiều</span>
                    </button>
                    <button type="button" class="interview-week-day-btn" onclick="filterWeekDay('6', this)">
                        <div>Thứ 6</div>
                        <span class="badge bg-light text-muted rounded-pill mt-1">Cuối tuần</span>
                    </button>
                    <button type="button" class="interview-week-day-btn" onclick="filterWeekDay('7', this)">
                        <div>Thứ 7</div>
                        <span class="badge bg-light text-muted rounded-pill mt-1">Dự phòng</span>
                    </button>
                </div>

                <!-- Interviews List in Week -->
                <div class="row g-3" id="weeklyInterviewList">
                    <c:choose>
                        <c:when test="${not empty weeklyInterviews}">
                            <c:forEach items="${weeklyInterviews}" var="iv">
                                <div class="col-12 col-md-6 col-lg-4 weekly-interview-item" data-day="${iv.interviewDate.dayOfWeek.value}">
                                    <div class="interview-card-item h-100 d-flex flex-column justify-content-between">
                                        <div>
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="badge bg-primary-subtle text-primary fw-bold px-2 py-1">
                                                    <i class="bi bi-clock me-1"></i>${iv.formattedTime}
                                                </span>
                                                <span class="badge bg-light text-muted border">
                                                    <fmt:parseDate value="${iv.interviewDate}" pattern="yyyy-MM-dd" var="dParsed" type="date"/>
                                                    <fmt:formatDate value="${dParsed}" pattern="dd/MM/yyyy"/>
                                                </span>
                                            </div>
                                            
                                            <h6 class="fw-bold text-dark mb-1">${iv.candidateName}</h6>
                                            <div class="text-muted small mb-2"><i class="bi bi-briefcase me-1"></i>${iv.jobTitle}</div>
                                            
                                            <div class="p-2 rounded bg-light border mb-2" style="font-size: 0.76rem;">
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <span class="text-muted">Vòng:</span>
                                                    <strong class="text-primary">${iv.roundName}</strong>
                                                </div>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="text-muted">Người PV:</span>
                                                    <span class="fw-semibold text-dark">${iv.interviewerName}</span>
                                                </div>
                                            </div>

                                            <div class="small text-muted" style="font-size: 0.75rem;">
                                                <i class="bi bi-geo-alt text-danger me-1"></i>${iv.locationOrLink}
                                            </div>
                                        </div>

                                        <div class="pt-2 mt-2 border-top d-flex justify-content-between align-items-center">
                                            <span class="badge ${iv.status eq 'SCHEDULED' ? 'bg-info-subtle text-info' : 'bg-success-subtle text-success'}">
                                                ${iv.status eq 'SCHEDULED' ? 'Đã lên lịch' : 'Đã hoàn tất'}
                                            </span>
                                            <button class="btn btn-sm btn-link text-decoration-none p-0" onclick="alert('Xem chi tiết đánh giá ứng viên: ${iv.candidateName}')">
                                                Chi tiết <i class="bi bi-chevron-right"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5 text-muted">
                                <i class="bi bi-calendar-x fs-2 d-block mb-2"></i>
                                Chưa có ca phỏng vấn nào được lên lịch trong tuần này.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="modal-footer bg-white border-top p-3 px-4">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 3: XẾP LỊCH PHỎNG VẤN NHANH (#scheduleInterviewModal)                -->
<!-- ========================================================================= -->
<div class="modal fade" id="scheduleInterviewModal" tabindex="-1" aria-labelledby="scheduleInterviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-md modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-calendar-plus-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="scheduleInterviewModalLabel">Xếp Lịch Phỏng Vấn Mới</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Lên lịch phỏng vấn và gửi thư mời tới ứng viên</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                <input type="hidden" name="action" value="schedule_interview">

                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Chọn ứng viên phỏng vấn <span class="text-danger">*</span></label>
                        <select class="form-select form-select-sm" name="candidateId" required>
                            <option value="" disabled selected>-- Chọn hồ sơ ứng viên --</option>
                            <c:forEach items="${interviewCandidates}" var="cand">
                                <option value="${cand.id}">${cand.fullName} (${cand.candidateCode}) - ${cand.jobTitle}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Người phỏng vấn (Interviewer) <span class="text-danger">*</span></label>
                        <select class="form-select form-select-sm" name="interviewerId" required>
                            <option value="" disabled selected>-- Chọn chuyên viên / Tech Lead --</option>
                            <c:forEach items="${employees}" var="emp">
                                <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Vòng tuyển dụng <span class="text-danger">*</span></label>
                        <select class="form-select form-select-sm" name="roundName" required>
                            <option value="Vòng 1 (HR Fit & Văn hóa)" selected>Vòng 1 (HR Fit & Văn hóa)</option>
                            <option value="Vòng Chuyên môn & Kỹ thuật">Vòng Chuyên môn & Kỹ thuật</option>
                            <option value="Vòng Portfolio / Bài Test">Vòng Portfolio / Bài Test</option>
                            <option value="Vòng Phỏng vấn Ban Giám đốc">Vòng Phỏng vấn Ban Giám đốc</option>
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

                    <div>
                        <label class="form-label small fw-semibold text-muted">Ghi chú cho buổi phỏng vấn</label>
                        <textarea class="form-control form-control-sm" name="feedback" rows="2" placeholder="Ghi chú câu hỏi phỏng vấn hoặc tài liệu cần chuẩn bị..."></textarea>
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
<!-- MODAL 4: XUẤT BÁO CÁO TUYỂN DỤNG (#exportReportModal)                     -->
<!-- ========================================================================= -->
<div class="modal fade" id="exportReportModal" tabindex="-1" aria-labelledby="exportReportModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-file-earmark-spreadsheet-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="exportReportModalLabel">Xuất Báo Cáo Tuyển Dụng</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Trích xuất số liệu tuyển dụng toàn diện từ hệ thống</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4">
                <p class="text-muted small mb-3">
                    Báo cáo bao gồm tổng hợp 4 thẻ chỉ số KPI, thống kê phễu 5 giai đoạn chuyển đổi, phân bổ 4 nguồn ứng viên và toàn bộ danh sách 12 chiến dịch tuyển dụng.
                </p>

                <div class="p-3 border rounded-3 bg-light mb-3">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted small">Kỳ báo cáo:</span>
                        <strong class="text-dark">${not empty currentQuarter ? currentQuarter : 'Quý 3/2026'}</strong>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted small">Định dạng file xuất:</span>
                        <span class="badge bg-success-subtle text-success fw-bold">Microsoft Excel (.CSV UTF-8 BOM)</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-muted small">Tổng số chiến dịch:</span>
                        <strong class="text-primary">${recruitmentRequests.size()} vị trí</strong>
                    </div>
                </div>

                <div class="d-grid gap-2">
                    <!-- Tải file CSV/Excel thực tế -->
                    <a href="${pageContext.request.contextPath}/recruitment?action=export_report&quarter=${currentQuarter}&departmentId=${selectedDeptId}" 
                       class="btn btn-primary d-flex align-items-center justify-content-center gap-2 py-2 shadow-sm">
                        <i class="bi bi-download"></i>
                        <span>Tải file báo cáo Excel (CSV UTF-8)</span>
                    </a>

                    <!-- In báo cáo PDF -->
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center justify-content-center gap-2 py-2" onclick="window.print()">
                        <i class="bi bi-printer"></i>
                        <span>In bản báo cáo tổng hợp (Print / PDF)</span>
                    </button>
                </div>
            </div>

            <div class="modal-footer bg-light border-top p-2 px-3">
                <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script>
    // 1. Tìm kiếm tức thì trong bảng chiến dịch
    const searchInput = document.getElementById('campaignSearchInput');
    const tableBody = document.querySelector('#campaignTable tbody');
    if (searchInput && tableBody) {
        searchInput.addEventListener('keyup', function () {
            const query = this.value.toLowerCase().trim();
            const rows = tableBody.querySelectorAll('tr');
            rows.forEach(row => {
                const text = row.getAttribute('data-text') ? row.getAttribute('data-text').toLowerCase() : '';
                if (text.includes(query)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }

    // 2. Chuyển đổi tab trạng thái chiến dịch trong bảng
    const statusTabs = document.querySelectorAll('#campaignStatusTabs .nav-link');
    if (statusTabs && tableBody) {
        statusTabs.forEach(tab => {
            tab.addEventListener('click', function (e) {
                e.preventDefault();
                statusTabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');

                const targetStatus = this.getAttribute('data-status');
                const rows = tableBody.querySelectorAll('tr');
                let count = 0;
                rows.forEach(row => {
                    const rowStatus = row.getAttribute('data-status');
                    if (targetStatus === 'ALL' || rowStatus === targetStatus) {
                        row.style.display = '';
                        count++;
                    } else {
                        row.style.display = 'none';
                    }
                });
                const badge = document.getElementById('campaignCountBadge');
                if (badge) {
                    badge.textContent = count + ' chiến dịch đang hiển thị';
                }
            });
        });
    }

    // 3. Lọc ngày trong modal Lịch phỏng vấn tuần
    function filterWeekDay(dayNumber, btn) {
        const buttons = document.querySelectorAll('.interview-week-day-btn');
        buttons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        const items = document.querySelectorAll('.weekly-interview-item');
        items.forEach(item => {
            const itemDay = item.getAttribute('data-day');
            if (dayNumber === 'ALL' || itemDay === dayNumber) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>
