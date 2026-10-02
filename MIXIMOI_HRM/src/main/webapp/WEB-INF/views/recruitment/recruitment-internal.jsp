<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tuyển Dụng Nội Bộ & Bảng Thông Báo Vị Trí — MIXIMOI HRM</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        .job-card-hover {
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            border: 1px solid rgba(226, 232, 240, 0.9);
        }
        .job-card-hover:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 24px -10px rgba(37, 99, 235, 0.15) !important;
            border-color: #93c5fd;
        }
        .hero-banner-internal {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 50%, #3b82f6 100%);
            border-radius: 1rem;
            color: #ffffff;
            position: relative;
            overflow: hidden;
        }
        .hero-banner-internal::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 320px;
            height: 320px;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0) 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .badge-urgent-pulse {
            animation: pulse-red 2s infinite;
        }
        @keyframes pulse-red {
            0% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.5); }
            70% { box-shadow: 0 0 0 6px rgba(239, 68, 68, 0); }
            100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); }
        }
    </style>
</head>
<body class="hrm-app-body">
<div class="app-container">
    <c:set var="activeMenu" value="recruitment" scope="request"/>
    <c:set var="activeSubMenu" value="internal" scope="request"/>
    <!-- Sidebar -->
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <div class="app-main">
        <!-- Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Main Content Area -->
        <main class="app-content p-3 p-lg-4">

            <!-- Toast / Alerts Notification -->
            <c:if test="${param.success eq 'internal_applied'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-3 shadow-sm mb-4" role="alert">
                    <i class="bi bi-patch-check-fill fs-4 text-success flex-shrink-0"></i>
                    <div>
                        <strong>Nộp đơn ứng tuyển nội bộ thành công!</strong> Hồ sơ nguyện vọng thăng tiến / chuyển bộ phận của bạn đã được chuyển tới Ban Nhân sự (HR). Bạn sẽ nhận được phản hồi sắp xếp lịch phỏng vấn nội bộ sớm nhất.
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${param.success eq 'candidate_referred'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-3 shadow-sm mb-4" role="alert">
                    <i class="bi bi-gift-fill fs-4 text-success flex-shrink-0"></i>
                    <div>
                        <strong>Giới thiệu ứng viên thành công!</strong> Thông tin ứng viên đã được ghi nhận vào hệ thống kèm mã giới thiệu của bạn. Khi ứng viên vượt qua thử việc, bạn sẽ nhận thưởng hoa hồng Referral theo quy định công ty.
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${param.success eq 'internal_stage_updated'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-3 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-4 text-success flex-shrink-0"></i>
                    <div>
                        <strong>Cập nhật trạng thái thành công!</strong> Hồ sơ ứng viên nội bộ đã được chuyển sang giai đoạn mới và thông báo đến nhân sự liên quan.
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${param.success eq 'referral_bonus_approved'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-3 shadow-sm mb-4" role="alert">
                    <i class="bi bi-cash-stack fs-4 text-success flex-shrink-0"></i>
                    <div>
                        <strong>Phê duyệt chi thưởng thành công!</strong> Đã xác nhận duyệt chi thưởng hoa hồng Referral cho nhân sự giới thiệu và đồng bộ ghi chú vào hệ thống tính lương.
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${param.success eq 'job_created'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div><strong>Thành công!</strong> Đã tạo vị trí tuyển dụng mới và đăng thông báo tới toàn thể công ty.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${param.error eq 'apply_failed'}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                    <div><strong>Lỗi!</strong> Không thể gửi đơn ứng tuyển nội bộ. Vui lòng kiểm tra lại thông tin.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${param.error eq 'refer_failed'}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-5 text-danger flex-shrink-0"></i>
                    <div><strong>Lỗi giới thiệu ứng viên!</strong> Không thể gửi hồ sơ giới thiệu. Vui lòng chọn vị trí tuyển dụng và điền đầy đủ các thông tin bắt buộc.</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- 1. Hero Header Banner -->
            <div class="hero-banner-internal p-4 p-md-5 mb-4 shadow-sm">
                <div class="row align-items-center position-relative" style="z-index: 1;">
                    <div class="col-lg-8">
                        <span class="badge bg-white text-primary fw-bold px-3 py-1 mb-2 rounded-pill shadow-sm" style="font-size: 0.78rem;">
                            <i class="bi bi-stars text-warning me-1"></i> MIXIMOI INTERNAL CAREERS 2026
                        </span>
                        <h1 class="h2 fw-bold text-white mb-2">Bảng Tin Tuyển Dụng Nội Bộ Công Ty</h1>
                        <p class="text-white text-opacity-90 mb-3" style="font-size: 0.95rem; line-height: 1.6; max-width: 680px;">
                            Khám phá các vị trí tuyển dụng vừa được mở tuyển toàn công ty. MIXIMOI luôn ưu tiên xét tuyển nhân tài nội bộ thăng tiến, hỗ trợ đào tạo chuyển đổi phòng ban và chính sách <strong>Referral Bonus thưởng lên đến 10.000.000 VNĐ</strong> khi giới thiệu bạn bè gia nhập đội ngũ.
                        </p>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="#sectionJobsList" class="btn btn-light text-primary fw-bold px-3 py-2 shadow-sm">
                                <i class="bi bi-search me-1"></i> Xem Các Vị Trí Đang Tuyển (${fn:length(jobs)})
                            </a>
                            <a href="#referralPolicySection" class="btn btn-outline-light px-3 py-2" onclick="scrollToReferralPolicy(event)">
                                <i class="bi bi-gift me-1"></i> Chính Sách Thưởng Giới Thiệu
                            </a>
                            <button type="button" class="btn btn-success px-3 py-2 fw-bold text-white shadow-sm" data-bs-toggle="modal" data-bs-target="#referCandidateModal" onclick="openGeneralReferModal()">
                                <i class="bi bi-person-plus-fill me-1"></i> Giới Thiệu Ứng Viên Ngay
                            </button>
                            <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
                                <a href="${pageContext.request.contextPath}/recruitment?view=jobs" class="btn btn-dark text-white bg-opacity-50 border-0 px-3 py-2">
                                    <i class="bi bi-gear-fill me-1"></i> Quản Lý Tuyển Dụng (HR)
                                </a>
                            </c:if>
                        </div>
                    </div>
                    <div class="col-lg-4 d-none d-lg-block text-end">
                        <div class="p-3 rounded-3 bg-white bg-opacity-10 border border-white border-opacity-25 text-start d-inline-block" style="backdrop-filter: blur(8px); min-width: 260px;">
                            <div class="text-white text-opacity-75 small mb-1">
                                <i class="bi bi-shield-check text-warning me-1"></i> Quyền lợi nhân sự nội bộ:
                            </div>
                            <ul class="text-white small mb-0 ps-3" style="font-size: 0.84rem; line-height: 1.7;">
                                <li>Miễn vòng sàng lọc CV ban đầu</li>
                                <li>Bảo lưu nguyên vẹn thâm niên</li>
                                <li>Tăng lương bậc mới theo khung</li>
                                <li>Bảo mật thông tin với quản lý cũ</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. Thống kê 4 thẻ KPI Tuyển Dụng Nội Bộ -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-md-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3 bg-white">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="text-muted small fw-semibold">VỊ TRÍ ĐANG MỞ</span>
                            <div class="rounded-circle p-2 bg-primary-subtle text-primary">
                                <i class="bi bi-briefcase-fill fs-6"></i>
                            </div>
                        </div>
                        <div class="h3 fw-bold text-dark mb-0">${fn:length(jobs)}</div>
                        <small class="text-muted">Trên toàn bộ phòng ban</small>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3 bg-white">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="text-muted small fw-semibold">ƯU TIÊN GẤP</span>
                            <div class="rounded-circle p-2 bg-danger-subtle text-danger">
                                <i class="bi bi-fire fs-6"></i>
                            </div>
                        </div>
                        <div class="h3 fw-bold text-danger mb-0">
                            <c:set var="urgentCount" value="0"/>
                            <c:forEach items="${jobs}" var="j">
                                <c:if test="${j.priority eq 'HOT' or j.priority eq 'URGENT'}">
                                    <c:set var="urgentCount" value="${urgentCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${urgentCount}
                        </div>
                        <small class="text-danger fw-semibold">Xét tuyển & Onboard nhanh</small>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3 bg-white job-card-hover" 
                         role="button" 
                         onclick="scrollToReferralPolicy(event)"
                         title="Nhấn để xem mô tả chi tiết biểu mức thưởng giới thiệu và quy trình">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="text-muted small fw-semibold">THƯỞNG GIỚI THIỆU</span>
                            <div class="rounded-circle p-2 bg-success-subtle text-success">
                                <i class="bi bi-gift-fill fs-6"></i>
                            </div>
                        </div>
                        <div class="h3 fw-bold text-success mb-0 d-flex align-items-center justify-content-between">
                            <span>10 Tr VNĐ</span>
                            <span class="badge bg-success-subtle text-success" style="font-size: 0.7rem;">Xem chi tiết &rarr;</span>
                        </div>
                        <small class="text-success fw-semibold">Tối đa cho vị trí Senior/Lead (Xem chi tiết)</small>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3 bg-white">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="text-muted small fw-semibold">TỶ LỆ PHÊ DUYỆT</span>
                            <div class="rounded-circle p-2 bg-info-subtle text-info">
                                <i class="bi bi-award-fill fs-6"></i>
                            </div>
                        </div>
                        <div class="h3 fw-bold text-info mb-0">85%</div>
                        <small class="text-muted">Nhân viên nội bộ phỏng vấn</small>
                    </div>
                </div>
            </div>

            <!-- 3. Thanh Thông Báo Công Ty: Vừa Tuyển Những Vị Trí Nào -->
            <div class="card border-0 shadow-sm rounded-3 p-4 mb-4 bg-white" style="border-left: 4px solid #2563eb !important;">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-2 mb-3">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="badge bg-primary px-2 py-1"><i class="bi bi-megaphone-fill me-1"></i> Bảng Thông Báo</span>
                            <h5 class="fw-bold text-dark mb-0">Công Ty Vừa Mở Tuyển Những Vị Trí Nào?</h5>
                        </div>
                        <small class="text-muted">Danh sách các vị trí tuyển dụng vừa được bộ phận nhân sự khởi tạo và phát thông báo trên hệ thống.</small>
                    </div>
                    <span class="text-muted small"><i class="bi bi-clock-history me-1"></i>Cập nhật theo thời gian thực</span>
                </div>

                <div class="row g-2">
                    <c:forEach items="${recentJobs}" var="rj">
                        <div class="col-12 col-md-6 col-xl-4">
                            <div class="p-3 rounded-3 border bg-light d-flex align-items-center justify-content-between gap-2 h-100">
                                <div>
                                    <div class="d-flex align-items-center gap-1 mb-1">
                                        <span class="badge bg-primary-subtle text-primary" style="font-size: 0.68rem;">${rj.departmentName}</span>
                                        <c:if test="${rj.priority eq 'HOT' or rj.priority eq 'URGENT'}">
                                            <span class="badge bg-danger text-white" style="font-size: 0.65rem;">Gấp</span>
                                        </c:if>
                                    </div>
                                    <div class="fw-bold text-dark text-truncate" style="font-size: 0.88rem; max-width: 220px;" title="${rj.title}">
                                        ${rj.title}
                                    </div>
                                    <small class="text-muted" style="font-size: 0.75rem;">
                                        Tuyển <strong>${rj.targetHeadcount}</strong> NS • Hạn: <strong>${rj.deadline}</strong>
                                    </small>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-primary text-nowrap" 
                                        data-bs-toggle="modal" data-bs-target="#internalApplyModal"
                                        data-job-id="${rj.id}" data-job-title="<c:out value='${rj.title}'/>" data-job-code="<c:out value='${rj.requestCode}'/>"
                                        onclick="openApplyDirect(this)">
                                    <i class="bi bi-send-fill me-1"></i>Ứng tuyển
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- 4. Bộ Lọc Đa Chiều Danh Sách Vị Trí Tuyển Dụng -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 bg-white" id="sectionJobsList">
                <div class="card-body p-3">
                    <form method="GET" action="${pageContext.request.contextPath}/recruitment">
                        <input type="hidden" name="view" value="internal">
                        <div class="row g-2 align-items-center">
                            <div class="col-12 col-md-4">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                    <input type="text" class="form-control" name="search" value="${searchKeyword}" placeholder="Tìm theo tên vị trí, kỹ năng, chức danh...">
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <select class="form-select form-select-sm" name="departmentId">
                                    <option value="">Tất cả phòng ban</option>
                                    <c:forEach items="${departments}" var="d">
                                        <option value="${d.id}" ${selectedDeptId == d.id ? 'selected' : ''}>${d.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-6 col-md-2">
                                <select class="form-select form-select-sm" name="priority">
                                    <option value="">Tất cả mức độ</option>
                                    <option value="NORMAL" ${selectedPriority eq 'NORMAL' ? 'selected' : ''}>Tiêu chuẩn</option>
                                    <option value="URGENT" ${selectedPriority eq 'URGENT' ? 'selected' : ''}>🔥 Tuyển gấp (URGENT)</option>
                                    <option value="HOT" ${selectedPriority eq 'HOT' ? 'selected' : ''}>🚨 HOT Cần ngay</option>
                                </select>
                            </div>
                            <div class="col-6 col-md-2">
                                <input type="number" class="form-control form-control-sm" name="salaryMin" value="${selectedSalaryMin}" placeholder="Lương tối thiểu (VNĐ)" step="1000000">
                            </div>
                            <div class="col-6 col-md-1 d-flex gap-1">
                                <button type="submit" class="btn btn-sm btn-primary w-100" title="Áp dụng bộ lọc">
                                    <i class="bi bi-funnel-fill"></i>
                                </button>
                                <a href="${pageContext.request.contextPath}/recruitment?view=internal" class="btn btn-sm btn-outline-secondary" title="Đặt lại bộ lọc">
                                    <i class="bi bi-arrow-counterclockwise"></i>
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 5. Grid Thẻ Vị Trí Tuyển Dụng Nội Bộ -->
            <div class="row g-3">
                <c:choose>
                    <c:when test="${not empty jobs}">
                        <c:forEach items="${jobs}" var="j">
                            <div class="col-12 col-lg-6 col-xl-4">
                                <div class="card h-100 border-0 shadow-sm rounded-3 p-4 bg-white job-card-hover d-flex flex-column justify-content-between job-card-element"
                                     id="jobCard_${j.id}"
                                     data-id="${j.id}"
                                     data-title="<c:out value='${j.title}'/>"
                                     data-code="<c:out value='${j.requestCode}'/>"
                                     data-dept="<c:out value='${not empty j.departmentName ? j.departmentName : \"Khối Chung\"}'/>"
                                     data-salary="<c:choose><c:when test='${j.salaryNegotiable}'>Thỏa thuận theo năng lực</c:when><c:otherwise>${j.salaryMinFormatted} - ${j.salaryMaxFormatted} triệu VNĐ</c:otherwise></c:choose>"
                                     data-headcount="${j.targetHeadcount} nhân sự"
                                     data-deadline="${j.deadline}"
                                     data-priority="${j.priority}">

                                    <!-- Dữ liệu text an toàn tuyệt đối không vỡ cú pháp JS -->
                                    <div class="job-desc-source d-none"><c:out value="${not empty j.description ? j.description : 'Tham gia cùng đội ngũ MIXIMOI phát triển giải pháp quản trị doanh nghiệp tiên phong.'}"/></div>
                                    <div class="job-req-source d-none"><c:out value="${not empty j.requirements ? j.requirements : 'Trao đổi cụ thể các yêu cầu chuyên môn trong buổi phỏng vấn trực tiếp.'}"/></div>
                                    <div class="job-bene-source d-none"><c:out value="${not empty j.benefits ? j.benefits : 'Hưởng đầy đủ chế độ đãi ngộ, bảo hiểm, thưởng hiệu suất công ty và đào tạo nâng chuẩn.'}"/></div>

                                    <div>
                                        <!-- Top Row: Department & Badges -->
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <span class="badge bg-primary-subtle text-primary fw-bold" style="font-size: 0.72rem;">
                                                <i class="bi bi-building me-1"></i>${not empty j.departmentName ? j.departmentName : 'Công ty MIXIMOI'}
                                            </span>
                                            <div class="d-flex gap-1">
                                                <c:choose>
                                                    <c:when test="${j.priority eq 'HOT'}">
                                                        <span class="badge bg-danger text-white fw-bold badge-urgent-pulse" style="font-size: 0.7rem;">🚨 HOT</span>
                                                    </c:when>
                                                    <c:when test="${j.priority eq 'URGENT'}">
                                                        <span class="badge bg-warning text-dark fw-bold" style="font-size: 0.7rem;">🔥 Tuyển gấp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-muted border" style="font-size: 0.7rem;">Mới mở</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <!-- Job Title -->
                                        <h5 class="fw-bold text-dark mb-1" style="font-size: 1.05rem; line-height: 1.4;">
                                            <a href="javascript:void(0)" onclick="handleViewDetailClick(${j.id})" class="text-dark text-decoration-none hover-primary">
                                                ${j.title}
                                            </a>
                                        </h5>
                                        <div class="text-muted small mb-3 font-monospace" style="font-size: 0.75rem;">
                                            Mã vị trí: ${j.requestCode} • Phụ trách: <strong>${not empty j.assigneeName ? j.assigneeName : 'HR Team'}</strong>
                                        </div>

                                        <!-- Highlights Box -->
                                        <div class="p-3 rounded-3 mb-3" style="background: #f8fafc; border: 1px dashed #e2e8f0; font-size: 0.83rem;">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="text-muted"><i class="bi bi-cash-stack text-success me-1"></i>Thu nhập dự kiến:</span>
                                                <strong class="text-primary fs-6">
                                                    <c:choose>
                                                        <c:when test="${j.salaryNegotiable}">Thỏa thuận theo năng lực</c:when>
                                                        <c:otherwise>${j.salaryMinFormatted} - ${j.salaryMaxFormatted} triệu VNĐ</c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="text-muted"><i class="bi bi-person-fill-add text-info me-1"></i>Chỉ tiêu tuyển:</span>
                                                <span class="fw-bold text-dark">
                                                    ${j.targetHeadcount} nhân sự 
                                                    <c:if test="${j.hiredCount > 0}">
                                                        <span class="badge bg-success-subtle text-success py-0 px-1" style="font-size: 0.7rem;">Đã tuyển ${j.hiredCount}</span>
                                                    </c:if>
                                                </span>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="text-muted"><i class="bi bi-calendar-check text-warning me-1"></i>Hạn chót hồ sơ:</span>
                                                <span class="fw-semibold text-danger">
                                                    ${j.deadline} 
                                                    <c:if test="${j.daysRemaining >= 0}">
                                                        <small class="text-muted fw-normal">(Còn ${j.daysRemaining} ngày)</small>
                                                    </c:if>
                                                </span>
                                            </div>
                                        </div>

                                        <!-- Description Preview -->
                                        <p class="text-muted mb-3" style="font-size: 0.83rem; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${not empty j.description ? j.description : 'Tham gia cùng đội ngũ MIXIMOI phát triển giải pháp quản trị doanh nghiệp tiên phong.'}
                                        </p>

                                        <!-- Perks Tags -->
                                        <div class="d-flex flex-wrap gap-1 mb-3">
                                            <span class="badge bg-light text-secondary border fw-normal" style="font-size: 0.72rem;">✨ Ưu tiên xét tuyển nội bộ</span>
                                            <span class="badge bg-light text-secondary border fw-normal" style="font-size: 0.72rem;">🎁 Thưởng Ref lên đến 10Tr</span>
                                            <span class="badge bg-light text-secondary border fw-normal" style="font-size: 0.72rem;">📈 Lộ trình thăng tiến rõ ràng</span>
                                        </div>
                                    </div>

                                    <!-- Bottom Action Buttons: Liên kết 3 thao tác chính -->
                                    <div class="pt-3 border-top d-flex gap-2">
                                        <button type="button" class="btn btn-primary btn-sm flex-grow-1 fw-bold d-flex align-items-center justify-content-center gap-1 shadow-sm"
                                                data-bs-toggle="modal" data-bs-target="#internalApplyModal"
                                                onclick="handleApplyClick(${j.id})">
                                            <i class="bi bi-send-fill"></i> Ứng tuyển nội bộ
                                        </button>
                                        <button type="button" class="btn btn-outline-success btn-sm fw-semibold d-flex align-items-center gap-1"
                                                data-bs-toggle="modal" data-bs-target="#referCandidateModal"
                                                onclick="handleReferClick(${j.id})">
                                            <i class="bi bi-gift-fill"></i> Giới thiệu
                                        </button>
                                        <button type="button" class="btn btn-light border btn-sm text-muted" title="Xem chi tiết mô tả công việc (JD)"
                                                data-bs-toggle="modal" data-bs-target="#jobDetailModal"
                                                onclick="handleViewDetailClick(${j.id})">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5 bg-white rounded-3 shadow-sm">
                            <i class="bi bi-search fs-1 text-muted d-block mb-3"></i>
                            <h5 class="fw-bold text-dark mb-1">Không tìm thấy vị trí tuyển dụng phù hợp</h5>
                            <p class="text-muted small mb-3">Vui lòng điều chỉnh lại từ khóa tìm kiếm hoặc bỏ chọn các bộ lọc để xem toàn bộ danh mục vị trí.</p>
                            <a href="${pageContext.request.contextPath}/recruitment?view=internal" class="btn btn-sm btn-primary">
                                <i class="bi bi-arrow-clockwise me-1"></i> Xem Tất Cả Vị Trí
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- ========================================================================= -->
            <!-- 5. PHẦN MÔ TẢ CHI TIẾT CHÍNH SÁCH THƯỞNG GIỚI THIỆU (REFERRAL PROGRAM)   -->
            <!-- ========================================================================= -->
            <section id="referralPolicySection" class="card border-0 shadow-sm rounded-3 mb-4 bg-white overflow-hidden">
                <div class="card-header bg-gradient text-white p-3 px-4 d-flex justify-content-between align-items-center"
                     style="background: linear-gradient(135deg, #059669 0%, #10b981 100%);">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-gift-fill fs-4"></i>
                        <div>
                            <h5 class="fw-bold mb-0 text-white">Chính Sách Thưởng Giới Thiệu Nhân Tài (MIXIMOI Referral Bonus 2026)</h5>
                            <small class="text-white text-opacity-80">Mỗi đồng nghiệp tài năng bạn giới thiệu là một phần thưởng xứng đáng!</small>
                        </div>
                    </div>
                    <button type="button" class="btn btn-sm btn-light text-success fw-bold px-3 py-1 shadow-sm" data-bs-toggle="modal" data-bs-target="#referCandidateModal" onclick="openGeneralReferModal()">
                        <i class="bi bi-plus-circle-fill me-1"></i> Giới thiệu ứng viên ngay
                    </button>
                </div>
                <div class="card-body p-4">
                    <div class="row g-4">
                        <!-- Cột 1: Biểu phí thưởng theo cấp bậc vị trí -->
                        <div class="col-12 col-lg-7">
                            <h6 class="fw-bold text-dark text-uppercase mb-3 d-flex align-items-center gap-2">
                                <i class="bi bi-cash-coin text-success fs-5"></i>
                                <span>Biểu Mức Thưởng Giới Thiệu Chi Tiết</span>
                            </h6>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover align-middle mb-0" style="font-size: 0.85rem;">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Cấp bậc vị trí</th>
                                            <th>Mức thưởng Referral</th>
                                            <th>Yêu cầu kinh nghiệm</th>
                                            <th>Thời điểm giải ngân</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <strong class="text-dark">Quản lý / Tech Lead / Specialist Cấp Cao</strong>
                                                <div class="text-muted small">Tech Lead, Project Manager, Sales Lead</div>
                                            </td>
                                            <td><span class="badge bg-success fs-6 fw-bold">10.000.000 VNĐ</span></td>
                                            <td>&ge; 4 - 5 năm</td>
                                            <td>Sau 2 tháng thử việc</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <strong class="text-dark">Senior Engineer / Chuyên Viên Cao Cấp</strong>
                                                <div class="text-muted small">Senior Backend, Product Designer, DevOps</div>
                                            </td>
                                            <td><span class="badge bg-primary fs-6 fw-bold">6.000.000 VNĐ</span></td>
                                            <td>&ge; 3 năm</td>
                                            <td>Sau 2 tháng thử việc</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <strong class="text-dark">Mid-level / Chuyên Viên Tiêu Chuẩn</strong>
                                                <div class="text-muted small">Developer, QA/QC, Marketing, Kế toán</div>
                                            </td>
                                            <td><span class="badge bg-info text-dark fs-6 fw-bold">4.000.000 VNĐ</span></td>
                                            <td>1 - 2 năm</td>
                                            <td>Sau 2 tháng thử việc</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <strong class="text-dark">Junior / Fresher / Thực Tập Sinh Tiềm Năng</strong>
                                                <div class="text-muted small">Lập trình viên mới tốt nghiệp, TTS Kỹ thuật</div>
                                            </td>
                                            <td><span class="badge bg-secondary fs-6 fw-bold">2.000.000 VNĐ</span></td>
                                            <td>&lt; 1 năm</td>
                                            <td>Ký hợp đồng chính thức</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Cột 2: Quy trình 4 bước & Điều kiện nghiệm thu -->
                        <div class="col-12 col-lg-5">
                            <h6 class="fw-bold text-dark text-uppercase mb-3 d-flex align-items-center gap-2">
                                <i class="bi bi-diagram-3-fill text-primary fs-5"></i>
                                <span>Quy Trình 4 Bước Nhận Thưởng</span>
                            </h6>
                            <div class="timeline-referral">
                                <div class="p-2 mb-2 rounded bg-light border d-flex gap-2">
                                    <span class="badge bg-primary rounded-circle p-2 px-3 fw-bold align-self-start">1</span>
                                    <div>
                                        <strong class="text-dark small">Gửi hồ sơ giới thiệu:</strong>
                                        <div class="text-muted" style="font-size: 0.78rem;">Nhân viên điền họ tên, số điện thoại, email và link CV ứng viên trên hệ thống.</div>
                                    </div>
                                </div>
                                <div class="p-2 mb-2 rounded bg-light border d-flex gap-2">
                                    <span class="badge bg-primary rounded-circle p-2 px-3 fw-bold align-self-start">2</span>
                                    <div>
                                        <strong class="text-dark small">HR tiếp nhận & Phỏng vấn:</strong>
                                        <div class="text-muted" style="font-size: 0.78rem;">Hồ sơ được ưu tiên xếp lịch phỏng vấn và phát hành Offer nếu đạt tiêu chuẩn chuyên môn.</div>
                                    </div>
                                </div>
                                <div class="p-2 mb-2 rounded bg-light border d-flex gap-2">
                                    <span class="badge bg-primary rounded-circle p-2 px-3 fw-bold align-self-start">3</span>
                                    <div>
                                        <strong class="text-dark small">Ứng viên Onboard & Thử việc:</strong>
                                        <div class="text-muted" style="font-size: 0.78rem;">Ứng viên hoàn thành 02 tháng thử việc và được Trưởng bộ phận đánh giá Đạt.</div>
                                    </div>
                                </div>
                                <div class="p-2 rounded bg-success-subtle border border-success-subtle d-flex gap-2">
                                    <span class="badge bg-success rounded-circle p-2 px-3 fw-bold align-self-start">4</span>
                                    <div>
                                        <strong class="text-success small">Chi trả thưởng Referral:</strong>
                                        <div class="text-dark" style="font-size: 0.78rem;">HR phê duyệt thưởng, kế toán giải ngân tiền thưởng trực tiếp vào kỳ lương kế tiếp của người giới thiệu.</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- ========================================================================= -->
            <!-- 6. KHU VỰC DÀNH CHO ADMIN & NHÂN SỰ HR: THEO DÕI ĐƠN & DUYỆT THƯỞNG       -->
            <!-- ========================================================================= -->
            <section class="card border-0 shadow-sm rounded-3 mb-4 bg-white overflow-hidden" id="hrManagementSection">
                <div class="card-header bg-dark text-white p-3 px-4 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-shield-lock-fill fs-4 text-warning"></i>
                        <div>
                            <div class="d-flex align-items-center gap-2">
                                <h5 class="fw-bold mb-0 text-white">Quản Lý Tuyển Dụng Nội Bộ & Xét Duyệt Thưởng Referral</h5>
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
                                        <span class="badge bg-success text-white py-1 px-2" style="font-size: 0.72rem;"><i class="bi bi-shield-check me-1"></i>Quyền Quản Trị & HR</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-info text-dark py-1 px-2" style="font-size: 0.72rem;"><i class="bi bi-eye me-1"></i>Chế độ theo dõi & kiểm tra quy trình</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-white text-opacity-75">Tiếp nhận hồ sơ nhân sự nội bộ, điều phối phỏng vấn chuyển ban và phê duyệt giải ngân hoa hồng Referral theo cấp bậc</small>
                        </div>
                    </div>
                    <div class="d-flex gap-2">
                        <span class="badge bg-primary px-3 py-2 fs-6">${fn:length(internalApplicants)} Đơn nội bộ</span>
                        <span class="badge bg-success px-3 py-2 fs-6">${fn:length(referralCandidates)} Ứng viên Ref</span>
                    </div>
                </div>

                    <div class="card-body p-4">
                        <!-- Navigation Tabs -->
                        <ul class="nav nav-pills mb-3 gap-2" id="hrInternalTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active fw-semibold" id="tab-internal-btn" data-bs-toggle="pill" data-bs-target="#tab-internal-content" type="button" role="tab">
                                    <i class="bi bi-person-lines-fill me-1"></i> Đơn Ứng Tuyển Nội Bộ (${fn:length(internalApplicants)})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link fw-semibold" id="tab-referral-btn" data-bs-toggle="pill" data-bs-target="#tab-referral-content" type="button" role="tab">
                                    <i class="bi bi-gift-fill me-1"></i> Hồ Sơ Giới Thiệu & Duyệt Thưởng (${fn:length(referralCandidates)})
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content" id="hrInternalTabsContent">
                            <!-- TAB 1: ĐƠN ỨNG TUYỂN NỘI BỘ -->
                            <div class="tab-pane fade show active" id="tab-internal-content" role="tabpanel">
                                <c:choose>
                                    <c:when test="${not empty internalApplicants}">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle border mb-0" style="font-size: 0.83rem;">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Mã UV & Họ tên</th>
                                                        <th>Liên hệ</th>
                                                        <th>Vị trí ứng tuyển</th>
                                                        <th>Kinh nghiệm / Lương</th>
                                                        <th>Nguyện vọng & Ghi chú</th>
                                                        <th>Trạng thái hiện tại</th>
                                                        <th class="text-center" style="min-width: 220px;">Thao tác xử lý</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${internalApplicants}" var="ia">
                                                        <tr>
                                                            <td>
                                                                <strong class="text-dark d-block">${ia.fullName}</strong>
                                                                <span class="badge bg-light text-muted border font-monospace">${ia.candidateCode}</span>
                                                            </td>
                                                            <td>
                                                                <div><i class="bi bi-envelope me-1 text-muted"></i>${ia.email}</div>
                                                                <div><i class="bi bi-telephone me-1 text-muted"></i>${ia.phone}</div>
                                                            </td>
                                                            <td>
                                                                <span class="badge bg-primary-subtle text-primary fw-bold">${ia.jobTitle != null ? ia.jobTitle : 'Nội bộ'}</span>
                                                                <div class="text-muted small">${ia.departmentName}</div>
                                                            </td>
                                                            <td>
                                                                <div>KN: <strong>${ia.experienceYears} năm</strong></div>
                                                                <div class="text-primary fw-semibold">${ia.formattedSalary}</div>
                                                            </td>
                                                            <td>
                                                                <div class="text-muted small text-truncate" style="max-width: 180px;" title="${ia.notes}">
                                                                    ${ia.notes}
                                                                </div>
                                                                <c:if test="${not empty ia.cvUrl}">
                                                                    <a href="${ia.cvUrl}" target="_blank" class="small text-primary text-decoration-none">
                                                                        <i class="bi bi-link-45deg"></i> Bản mềm CV
                                                                    </a>
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <span class="badge ${ia.stage eq 'ONBOARDED' ? 'bg-success' : (ia.stage eq 'INTERVIEW' ? 'bg-warning text-dark' : (ia.stage eq 'REJECTED' ? 'bg-danger' : 'bg-primary-subtle text-primary'))}">
                                                                    ${ia.stage eq 'ONBOARDED' ? 'Đã duyệt chuyển ban' : (ia.stage eq 'INTERVIEW' ? 'Đang PV nội bộ' : (ia.stage eq 'REJECTED' ? 'Từ chối' : 'Mới tiếp nhận'))}
                                                                </span>
                                                            </td>
                                                            <td class="text-center">
                                                                <div class="d-flex justify-content-center align-items-center gap-1">
                                                                    <!-- Nút xem chi tiết toàn văn đơn nguyện vọng -->
                                                                    <button type="button" class="btn btn-sm btn-outline-info py-1 px-2"
                                                                            data-bs-toggle="modal" data-bs-target="#viewInternalApplicantModal"
                                                                            data-id="${ia.id}"
                                                                            data-name="<c:out value='${ia.fullName}'/>"
                                                                            data-code="<c:out value='${ia.candidateCode}'/>"
                                                                            data-email="<c:out value='${ia.email}'/>"
                                                                            data-phone="<c:out value='${ia.phone}'/>"
                                                                            data-job="<c:out value='${ia.jobTitle}'/>"
                                                                            data-dept="<c:out value='${ia.departmentName}'/>"
                                                                            data-exp="${ia.experienceYears}"
                                                                            data-salary="${ia.formattedSalary}"
                                                                            data-notes="<c:out value='${ia.notes}'/>"
                                                                            data-cv="<c:out value='${ia.cvUrl}'/>"
                                                                            data-stage="${ia.stage}"
                                                                            onclick="openViewInternalApplicantModal(this)"
                                                                            title="Xem chi tiết toàn văn đơn ứng tuyển">
                                                                        <i class="bi bi-eye"></i> Xem đơn
                                                                    </button>

                                                                    <!-- Duyệt vào phỏng vấn nội bộ -->
                                                                    <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0">
                                                                        <input type="hidden" name="action" value="hr_update_internal_stage">
                                                                        <input type="hidden" name="candidateId" value="${ia.id}">
                                                                        <input type="hidden" name="stage" value="INTERVIEW">
                                                                        <button type="submit" class="btn btn-sm btn-outline-warning text-dark py-1 px-2" title="Xếp lịch phỏng vấn nội bộ">
                                                                            <i class="bi bi-calendar-check"></i> Duyệt PV
                                                                        </button>
                                                                    </form>
                                                                    <!-- Tiếp nhận thăng tiến / chuyển ban -->
                                                                    <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0" onsubmit="return confirm('Xác nhận đồng ý tiếp nhận nhân sự chuyển bộ phận / thăng tiến?')">
                                                                        <input type="hidden" name="action" value="hr_update_internal_stage">
                                                                        <input type="hidden" name="candidateId" value="${ia.id}">
                                                                        <input type="hidden" name="stage" value="ONBOARDED">
                                                                        <button type="submit" class="btn btn-sm btn-outline-success py-1 px-2" title="Chấp thuận chuyển bộ phận">
                                                                            <i class="bi bi-check2-circle"></i> Chấp thuận
                                                                        </button>
                                                                    </form>
                                                                    <!-- Từ chối -->
                                                                    <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0" onsubmit="return confirm('Từ chối đơn ứng tuyển nội bộ này?')">
                                                                        <input type="hidden" name="action" value="hr_update_internal_stage">
                                                                        <input type="hidden" name="candidateId" value="${ia.id}">
                                                                        <input type="hidden" name="stage" value="REJECTED">
                                                                        <button type="submit" class="btn btn-sm btn-outline-danger py-1 px-2" title="Từ chối đơn">
                                                                            <i class="bi bi-x-circle"></i>
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 text-muted bg-light rounded-3">
                                            <i class="bi bi-inbox fs-2 d-block mb-1"></i>
                                            Hiện tại chưa có đơn ứng tuyển nội bộ nào từ nhân sự.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- TAB 2: QUẢN LÝ ỨNG VIÊN GIỚI THIỆU (REFERRAL) & DUYỆT THƯỞNG THEO CẤP BẬC -->
                            <div class="tab-pane fade" id="tab-referral-content" role="tabpanel">
                                <c:choose>
                                    <c:when test="${not empty referralCandidates}">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle border mb-0" style="font-size: 0.83rem;">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Ứng viên & Mã</th>
                                                        <th>Người giới thiệu</th>
                                                        <th>Vị trí ứng tuyển</th>
                                                        <th>Giai đoạn ATS</th>
                                                        <th>Mức thưởng Referral</th>
                                                        <th>Tình trạng giải ngân</th>
                                                        <th class="text-center" style="min-width: 240px;">Thao tác HR Duyệt Thưởng</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${referralCandidates}" var="rc">
                                                        <c:set var="isBonusApproved" value="${fn:contains(rc.notes, 'HR ĐÃ DUYỆT THƯỞNG')}" />
                                                        <c:set var="rawRef" value="${fn:contains(rc.notes, 'Người giới thiệu:') ? fn:substringAfter(rc.notes, 'Người giới thiệu:') : 'Nhân sự nội bộ'}" />
                                                        <c:set var="cleanRefName" value="${fn:trim(fn:substringBefore(rawRef, '&#10;'))}" />
                                                        <c:if test="${empty cleanRefName}"><c:set var="cleanRefName" value="${fn:trim(rawRef)}"/></c:if>
                                                        <tr>
                                                            <td>
                                                                <strong class="text-dark d-block">${rc.fullName}</strong>
                                                                <small class="text-muted font-monospace">${rc.candidateCode}</small>
                                                                <div class="small">
                                                                    <a href="${not empty rc.cvUrl ? rc.cvUrl : '#'}" target="_blank" class="text-primary text-decoration-none">
                                                                        <i class="bi bi-file-earmark-person"></i> Bản mềm CV
                                                                    </a>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="badge bg-light text-dark border p-2">
                                                                    <i class="bi bi-person-fill text-primary me-1"></i>
                                                                    <span class="fw-semibold">${cleanRefName}</span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="badge bg-primary-subtle text-primary">${rc.jobTitle}</span>
                                                                <div class="text-muted small">${rc.departmentName}</div>
                                                            </td>
                                                            <td>
                                                                <span class="badge ${rc.stage eq 'ONBOARDED' ? 'bg-success' : (rc.stage eq 'INTERVIEW' ? 'bg-warning text-dark' : 'bg-primary-subtle text-primary')}">
                                                                    ${rc.stage eq 'ONBOARDED' ? 'Đã Nhận Việc' : (rc.stage eq 'INTERVIEW' ? 'Đang Phỏng Vấn' : 'Mới Tiếp Nhận')}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${isBonusApproved}">
                                                                        <span class="fw-bold text-success fs-6"><i class="bi bi-check2-circle me-1"></i>Đã phê duyệt</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="fw-bold text-success">
                                                                            <c:choose>
                                                                                <c:when test="${fn:containsIgnoreCase(rc.jobTitle, 'Lead') or fn:containsIgnoreCase(rc.jobTitle, 'Quản lý') or fn:containsIgnoreCase(rc.jobTitle, 'Manager') or fn:containsIgnoreCase(rc.jobTitle, 'Specialist')}">
                                                                                    10.000.000 VNĐ
                                                                                </c:when>
                                                                                <c:when test="${fn:containsIgnoreCase(rc.jobTitle, 'Senior')}">
                                                                                    6.000.000 VNĐ
                                                                                </c:when>
                                                                                <c:when test="${fn:containsIgnoreCase(rc.jobTitle, 'Junior') or fn:containsIgnoreCase(rc.jobTitle, 'Fresher') or fn:containsIgnoreCase(rc.jobTitle, 'TTS')}">
                                                                                    2.000.000 VNĐ
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    4.000.000 VNĐ
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </span>
                                                                        <small class="text-muted d-block" style="font-size: 0.72rem;">Ước tính theo cấp bậc</small>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${isBonusApproved}">
                                                                        <span class="badge bg-success text-white py-1 px-2 border">
                                                                            <i class="bi bi-patch-check-fill me-1"></i> Đã duyệt chi thưởng
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${rc.stage eq 'ONBOARDED'}">
                                                                        <span class="badge bg-warning-subtle text-dark border border-warning-subtle py-1 px-2">
                                                                            <i class="bi bi-hourglass-split me-1"></i> Đủ điều kiện duyệt
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-light text-muted border py-1 px-2">Chờ thử việc</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-center">
                                                                <div class="d-flex justify-content-center align-items-center gap-1">
                                                                    <!-- Nút mở Modal duyệt thưởng theo cấp bậc -->
                                                                    <button type="button" class="btn btn-sm btn-success text-white py-1 px-2 shadow-sm fw-semibold"
                                                                            data-bs-toggle="modal" data-bs-target="#approveReferralBonusModal"
                                                                            data-id="${rc.id}"
                                                                            data-name="<c:out value='${rc.fullName}'/>"
                                                                            data-job="<c:out value='${rc.jobTitle}'/>"
                                                                            data-referrer="<c:out value='${cleanRefName}'/>"
                                                                            onclick="openApproveBonusModalFromBtn(this)"
                                                                            title="Xét duyệt thưởng Referral tùy theo cấp bậc vị trí">
                                                                        <i class="bi bi-cash-stack me-1"></i> Duyệt thưởng
                                                                    </button>

                                                                    <!-- Duyệt chuyển phỏng vấn -->
                                                                    <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0">
                                                                        <input type="hidden" name="action" value="hr_update_internal_stage">
                                                                        <input type="hidden" name="candidateId" value="${rc.id}">
                                                                        <input type="hidden" name="stage" value="INTERVIEW">
                                                                        <button type="submit" class="btn btn-sm btn-outline-primary py-1 px-2" title="Chuyển sang vòng phỏng vấn">
                                                                            <i class="bi bi-arrow-right"></i> Phỏng vấn
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 text-muted bg-light rounded-3">
                                            <i class="bi bi-inbox fs-2 d-block mb-1"></i>
                                            Chưa có hồ sơ giới thiệu ứng viên (Referral) nào được gửi lên.
                                        </div>
                                    </c:otherwise>
                                  </c:choose>
                            </div>
                        </div>
                    </div>
                </section>
        </main>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 1: ỨNG TUYỂN NỘI BỘ (#internalApplyModal)                           -->
<!-- ========================================================================= -->
<div class="modal fade" id="internalApplyModal" tabindex="-1" aria-labelledby="internalApplyModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4" style="background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%); color: white;">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-person-badge-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="internalApplyModalLabel">Nộp Đơn Ứng Tuyển Nội Bộ</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Đăng ký chuyển đổi vị trí hoặc thử sức với cơ hội thăng tiến nội bộ</small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                <input type="hidden" name="action" value="internal_apply">
                <input type="hidden" name="recruitmentRequestId" id="applyReqId" value="">

                <div class="modal-body p-4" style="background: #f8fafc;">
                    <!-- Banner Vị Trí -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <small class="text-muted d-block font-monospace" id="applyJobCode">YCTD-2026-xxx</small>
                                <h5 class="fw-bold text-primary mb-0" id="applyJobTitle">Tên vị trí tuyển dụng</h5>
                            </div>
                            <span class="badge bg-success-subtle text-success px-2 py-1">Ứng tuyển nội bộ</span>
                        </div>
                    </div>

                    <!-- Thông Tin Nhân Sự Hiện Tại -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                        <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">1. Thông tin ứng viên (Nhân sự MIXIMOI)</h6>
                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Họ và tên nhân viên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-sm fw-bold" name="fullName" 
                                       value="${not empty sessionScope.currentUser.fullName ? sessionScope.currentUser.fullName : 'Nhân sự MIXIMOI'}" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Email công ty <span class="text-danger">*</span></label>
                                <input type="email" class="form-control form-control-sm" name="email" 
                                       value="${not empty sessionScope.currentUser.email ? sessionScope.currentUser.email : 'nhanvien@miximoi.vn'}" required>
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Số điện thoại liên hệ <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-sm" name="phone" placeholder="09xxxxxxxx" value="0912345678" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Phòng ban / Đội ngũ hiện tại</label>
                                <input type="text" class="form-control form-control-sm" name="currentDepartment" 
                                       value="${not empty sessionScope.currentUser.departmentName ? sessionScope.currentUser.departmentName : 'Đang công tác tại MIXIMOI'}" placeholder="VD: Khối Kỹ thuật R&D">
                            </div>
                        </div>
                    </div>

                    <!-- Nguyện Vọng & Kỳ Vọng -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                        <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">2. Nguyện vọng & Năng lực ứng tuyển</h6>
                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Số năm kinh nghiệm liên quan</label>
                                <input type="number" class="form-control form-control-sm" name="experienceYears" value="2.5" step="0.5" min="0">
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Mức thu nhập kỳ vọng (VNĐ)</label>
                                <input type="text" class="form-control form-control-sm" name="expectedSalary" placeholder="VD: 30000000">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Lý do muốn thử sức vị trí này & Định hướng phát triển <span class="text-danger">*</span></label>
                            <textarea class="form-control form-control-sm" name="reason" rows="3" required placeholder="Chia sẻ kinh nghiệm đã tích lũy tại công ty và lý do bạn tự tin sẽ hoàn thành xuất sắc vị trí này..."></textarea>
                        </div>

                        <div>
                            <label class="form-label small fw-semibold text-muted">Liên kết CV cập nhật / Portfolio dự án (Nếu có)</label>
                            <input type="text" class="form-control form-control-sm" name="cvUrl" placeholder="https://drive.google.com/... hoặc link CV">
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-white border-top p-3 px-4">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                        <i class="bi bi-send-check-fill"></i>
                        <span>Xác Nhận Nộp Đơn Ứng Tuyển</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 2: GIỚI THIỆU ỨNG VIÊN REFERRAL (#referCandidateModal)              -->
<!-- ========================================================================= -->
<div class="modal fade" id="referCandidateModal" tabindex="-1" aria-labelledby="referCandidateModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4" style="background: linear-gradient(135deg, #059669 0%, #10b981 100%); color: white;">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-gift-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="referCandidateModalLabel">Giới Thiệu Ứng Viên (Referral Program)</h5>
                        <small class="text-white text-opacity-75" style="font-size: 0.78rem;">Giới thiệu đồng nghiệp cũ, bạn bè tài năng & nhận thưởng lên tới 10.000.000 VNĐ</small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/recruitment" onsubmit="return validateReferForm(this)">
                <input type="hidden" name="action" value="refer_candidate">
                <input type="hidden" name="recruitmentRequestId" id="referReqId" value="">

                <div class="modal-body p-4" style="background: #f8fafc;">
                    <!-- Chọn hoặc hiển thị Vị Trí Tuyển Dụng -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                        <label class="form-label small fw-bold text-dark mb-2 d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-briefcase-fill text-success me-1"></i> Vị trí tuyển dụng bạn muốn giới thiệu ứng viên <span class="text-danger">*</span></span>
                            <span class="badge bg-success-subtle text-success fw-semibold" style="font-size: 0.72rem;"><i class="bi bi-coin me-1"></i>Thưởng Referral</span>
                        </label>

                        <!-- Box chọn dropdown khi mở chung từ nút Giới thiệu ứng viên ngay -->
                        <div id="referJobSelectContainer">
                            <select id="referJobSelect" class="form-select form-select-sm fw-semibold border-success" onchange="onReferJobSelectChange(this)">
                                <option value="">-- Nhấp chọn vị trí công ty đang tuyển (*) --</option>
                                <c:forEach items="${not empty allOpenJobs ? allOpenJobs : jobs}" var="j">
                                    <option value="${j.id}" data-code="${fn:escapeXml(j.requestCode)}" data-title="${fn:escapeXml(j.title)}" data-dept="${fn:escapeXml(j.departmentName)}">
                                        [${j.requestCode}] ${j.title} — ${not empty j.departmentName ? j.departmentName : 'MIXIMOI'}
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-muted mt-1 d-block" style="font-size: 0.75rem;">
                                Bạn có thể giới thiệu bạn bè vào bất kỳ vị trí tuyển dụng nào mà công ty đang mở.
                            </small>
                        </div>

                        <!-- Box hiển thị cố định khi mở từ thẻ công việc cụ thể -->
                        <div id="referJobFixedContainer" class="d-none">
                            <div class="p-2 px-3 rounded bg-light border d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="badge bg-success font-monospace" id="referJobCode">YCTD-2026-xxx</span>
                                    <h6 class="fw-bold text-dark mb-0 mt-1" id="referJobTitle">Vị trí giới thiệu</h6>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="enableReferJobSelect()" title="Đổi sang vị trí khác">
                                    <i class="bi bi-pencil me-1"></i> Đổi vị trí
                                </button>
                            </div>
                        </div>

                        <!-- Box hiển thị mức thưởng ước tính theo cấp bậc vị trí được chọn -->
                        <div id="referBonusEstimateBox" class="mt-2 p-2 px-3 rounded bg-success-subtle border border-success-subtle small text-success fw-semibold d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-gift-fill me-1"></i> Mức thưởng Referral ước tính: <strong id="referBonusEstimateText">6.000.000 VNĐ</strong></span>
                            <a href="javascript:void(0)" onclick="closeModalAndScrollToPolicy()" class="text-success text-decoration-underline small">Xem chính sách thưởng</a>
                        </div>
                    </div>

                    <!-- Người giới thiệu -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                        <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">1. Thông tin người giới thiệu (Nhân viên hiện tại)</h6>
                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Họ tên nhân viên giới thiệu</label>
                                <input type="text" class="form-control form-control-sm fw-bold bg-light" name="referrerName" 
                                       value="${not empty sessionScope.currentUser.fullName ? sessionScope.currentUser.fullName : 'Nhân sự MIXIMOI'}" readonly>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Tài khoản nhận thưởng</label>
                                <input type="text" class="form-control form-control-sm bg-light" value="Tài khoản bảng lương nội bộ của bạn" readonly>
                            </div>
                        </div>
                    </div>

                    <!-- Thông Tin Ứng Viên Được Giới Thiệu -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-white">
                        <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">2. Thông tin ứng viên tiềm năng</h6>
                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Họ và tên ứng viên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-sm" name="candidateName" placeholder="VD: Trần Đình Trọng" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Email ứng viên <span class="text-danger">*</span></label>
                                <input type="email" class="form-control form-control-sm" name="candidateEmail" placeholder="trong.td@gmail.com" required>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Số điện thoại ứng viên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-sm" name="candidatePhone" placeholder="09xxxxxxxx" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-muted">Số năm kinh nghiệm</label>
                                <input type="number" class="form-control form-control-sm" name="experienceYears" placeholder="3.0" step="0.5" min="0">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Link CV ứng viên / Hồ sơ LinkedIn <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-sm" name="cvUrl" placeholder="https://topcv.vn/... hoặc link Google Drive" required>
                        </div>

                        <div>
                            <label class="form-label small fw-semibold text-muted">Đánh giá nhanh về ứng viên (Kỹ năng, tính cách, kinh nghiệm nổi bật)</label>
                            <textarea class="form-control form-control-sm" name="notes" rows="3" placeholder="Đồng nghiệp cũ tại cty X, làm việc rất có trách nhiệm, chuyên sâu ReactJS và Cloud..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-white border-top p-3 px-4">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-success d-flex align-items-center gap-2 shadow-sm text-white fw-bold">
                        <i class="bi bi-gift-fill"></i>
                        <span>Gửi Hồ Sơ Giới Thiệu & Kích Hoạt Thưởng</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 3: XEM CHI TIẾT JD VỊ TRÍ TUYỂN DỤNG (#jobDetailModal)              -->
<!-- ========================================================================= -->
<div class="modal fade" id="jobDetailModal" tabindex="-1" aria-labelledby="jobDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header modal-header-brand p-3 px-4" style="background: #1e293b; color: white;">
                <div>
                    <span class="badge bg-primary mb-1" id="jdDept">Phòng Ban</span>
                    <h5 class="modal-title fw-bold text-white mb-0" id="jdTitle">Tên vị trí</h5>
                    <small class="text-white text-opacity-75 font-monospace" id="jdCode">Mã vị trí</small>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4" style="background: #ffffff;">
                <div class="row g-3 mb-4 p-3 rounded-3" style="background: #f8fafc; border: 1px solid #e2e8f0;">
                    <div class="col-4">
                        <span class="text-muted small d-block">Mức thu nhập:</span>
                        <strong class="text-primary fs-6" id="jdSalary">--</strong>
                    </div>
                    <div class="col-4">
                        <span class="text-muted small d-block">Số lượng tuyển:</span>
                        <strong class="text-dark fs-6" id="jdHeadcount">--</strong>
                    </div>
                    <div class="col-4">
                        <span class="text-muted small d-block">Hạn nộp hồ sơ:</span>
                        <strong class="text-danger fs-6" id="jdDeadline">--</strong>
                    </div>
                </div>

                <div class="mb-4">
                    <h6 class="fw-bold text-dark border-bottom pb-2"><i class="bi bi-briefcase me-1 text-primary"></i> 1. Mô tả công việc (Job Description)</h6>
                    <div class="text-secondary small" style="line-height: 1.6;" id="jdDescription">--</div>
                </div>

                <div class="mb-4">
                    <h6 class="fw-bold text-dark border-bottom pb-2"><i class="bi bi-check2-square me-1 text-success"></i> 2. Yêu cầu chuyên môn (Requirements)</h6>
                    <div class="text-secondary small" style="line-height: 1.6;" id="jdRequirements">--</div>
                </div>

                <div class="mb-3">
                    <h6 class="fw-bold text-dark border-bottom pb-2"><i class="bi bi-stars me-1 text-warning"></i> 3. Quyền lợi đặc quyền nhân viên nội bộ (Perks)</h6>
                    <div class="text-secondary small" style="line-height: 1.6;" id="jdBenefits">--</div>
                </div>
            </div>

            <!-- Chân Modal JD: Liên kết 1-chạm sang Ứng tuyển & Giới thiệu -->
            <div class="modal-footer bg-light border-top p-3 px-4 d-flex justify-content-between">
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="switchDetailToPolicy()">
                    <i class="bi bi-gift me-1"></i> Chính sách thưởng
                </button>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-success fw-semibold" onclick="switchDetailToRefer()">
                        <i class="bi bi-gift-fill me-1"></i> Giới thiệu bạn bè
                    </button>
                    <button type="button" class="btn btn-primary fw-bold" onclick="switchDetailToApply()">
                        <i class="bi bi-send-fill me-1"></i> Ứng tuyển vị trí này
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 4: CHÍNH SÁCH THƯỞNG REFERRAL (#referralPolicyModal)                 -->
<!-- ========================================================================= -->
<div class="modal fade" id="referralPolicyModal" tabindex="-1" aria-labelledby="referralPolicyModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header p-3 px-4 bg-primary text-white">
                <h5 class="modal-title fw-bold" id="referralPolicyModalLabel"><i class="bi bi-award-fill me-2"></i>Quy Chế Thưởng Giới Thiệu Ứng Viên</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4" style="font-size: 0.88rem; line-height: 1.6;">
                <p class="text-muted">Nhằm khuyến khích tinh thần đồng hành và xây dựng đội ngũ nhân sự chất lượng cao, MIXIMOI áp dụng chính sách chi trả Referral Bonus đặc biệt dành cho toàn thể nhân sự:</p>
                <div class="list-group mb-3">
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Vị trí Cấp Quản lý / Tech Lead / Principal</strong>
                            <div class="text-muted small">Kinh nghiệm 4-5 năm, dẫn dắt đội ngũ</div>
                        </div>
                        <span class="badge bg-success fs-6">10.000.000 VNĐ</span>
                    </div>
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Vị trí Senior Specialist / Chuyên gia</strong>
                            <div class="text-muted small">Kinh nghiệm 3+ năm, độc lập tác chiến</div>
                        </div>
                        <span class="badge bg-primary fs-6">6.000.000 VNĐ</span>
                    </div>
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Vị trí Mid-level / Chuyên Viên Tiêu Chuẩn</strong>
                            <div class="text-muted small">Kinh nghiệm 1 - 2 năm</div>
                        </div>
                        <span class="badge bg-info fs-6">4.000.000 VNĐ</span>
                    </div>
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Vị trí Junior / Fresher / TTS Tiềm Năng</strong>
                            <div class="text-muted small">Kinh nghiệm dưới 1 năm</div>
                        </div>
                        <span class="badge bg-secondary fs-6">2.000.000 VNĐ</span>
                    </div>
                </div>
                <div class="p-2 rounded bg-light border text-muted small">
                    <i class="bi bi-info-circle me-1 text-primary"></i> Tiền thưởng sẽ được chuyển trực tiếp vào kỳ lương tháng tiếp theo ngay sau khi ứng viên vượt qua thời gian thử việc 02 tháng tại công ty.
                </div>
            </div>
            <div class="modal-footer p-3 border-top d-flex justify-content-between">
                <button type="button" class="btn btn-outline-primary btn-sm" onclick="closeModalAndScrollToPolicy()">
                    <i class="bi bi-card-text me-1"></i>Xem biểu phí & quy trình chi tiết
                </button>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-success btn-sm text-white" onclick="closeModalAndOpenRefer()">
                        <i class="bi bi-gift-fill me-1"></i>Giới thiệu ứng viên ngay
                    </button>
                    <button type="button" class="btn btn-primary btn-sm" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 5: XÉT DUYỆT THƯỞNG REFERRAL THEO CẤP BẬC VỊ TRÍ (#approveReferralBonusModal) -->
<!-- ========================================================================= -->
<div class="modal fade" id="approveReferralBonusModal" tabindex="-1" aria-labelledby="approveReferralBonusModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header p-3 px-4 text-white" style="background: linear-gradient(135deg, #059669 0%, #10b981 100%);">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-cash-stack fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="approveReferralBonusModalLabel">Xét Duyệt Thưởng Referral Theo Cấp Bậc</h5>
                        <small class="text-white text-opacity-80" style="font-size: 0.78rem;">Phê duyệt hoa hồng giới thiệu nhân tài & đồng bộ giải ngân vào bảng lương</small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/recruitment">
                <input type="hidden" name="action" value="hr_approve_referral_bonus">
                <input type="hidden" name="candidateId" id="approveBonusCandId" value="">

                <div class="modal-body p-4" style="background: #f8fafc;">
                    <!-- Tóm tắt ứng viên & Người giới thiệu -->
                    <div class="card border-0 shadow-sm rounded-3 p-3 mb-3 bg-white">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="text-muted small">Ứng viên nhận việc:</span>
                            <strong class="text-dark" id="approveBonusCandName">--</strong>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="text-muted small">Vị trí tuyển dụng:</span>
                            <span class="badge bg-primary-subtle text-primary" id="approveBonusJobTitle">--</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted small">Người giới thiệu nhận thưởng:</span>
                            <strong class="text-success" id="approveBonusReferrerName">--</strong>
                        </div>
                    </div>

                    <!-- Lựa chọn Cấp bậc vị trí nghiệm thu -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-dark mb-1">
                            1. Cấp bậc vị trí nghiệm thu (Theo chính sách Referral 2026) <span class="text-danger">*</span>
                        </label>
                        <select name="rankLevel" id="approveBonusRankSelect" class="form-select form-select-sm fw-semibold" onchange="onApproveRankSelectChange(this)" required>
                            <option value="Quản lý / Tech Lead / Specialist Cấp Cao" data-amount="10.000.000 VNĐ">
                                Quản lý / Tech Lead / Specialist Cấp Cao — Thưởng 10.000.000 VNĐ (&ge; 4-5 năm)
                            </option>
                            <option value="Senior Engineer / Chuyên Viên Cao Cấp" data-amount="6.000.000 VNĐ" selected>
                                Senior Engineer / Chuyên Viên Cao Cấp — Thưởng 6.000.000 VNĐ (&ge; 3 năm)
                            </option>
                            <option value="Mid-level / Chuyên Viên Tiêu Chuẩn" data-amount="4.000.000 VNĐ">
                                Mid-level / Chuyên Viên Tiêu Chuẩn — Thưởng 4.000.000 VNĐ (1-2 năm)
                            </option>
                            <option value="Junior / Fresher / Thực Tập Sinh Tiềm Năng" data-amount="2.000.000 VNĐ">
                                Junior / Fresher / TTS Tiềm Năng — Thưởng 2.000.000 VNĐ (&lt; 1 năm)
                            </option>
                            <option value="Mức thưởng thỏa thuận đặc biệt" data-amount="5.000.000 VNĐ">
                                Mức thưởng thỏa thuận đặc biệt (Tự nhập số tiền)
                            </option>
                        </select>
                    </div>

                    <!-- Số tiền giải ngân & Kỳ lương -->
                    <div class="row g-2 mb-3">
                        <div class="col-7">
                            <label class="form-label small fw-bold text-dark mb-1">Số tiền giải ngân thưởng <span class="text-danger">*</span></label>
                            <div class="input-group input-group-sm">
                                <input type="text" class="form-control fw-bold text-success fs-6" name="bonusAmount" id="approveBonusAmountInput" value="6.000.000 VNĐ" required>
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-coin"></i></span>
                            </div>
                        </div>
                        <div class="col-5">
                            <label class="form-label small fw-bold text-dark mb-1">Kỳ lương chi trả</label>
                            <input type="text" class="form-control form-control-sm" name="payrollPeriod" id="approveBonusPeriodInput" value="Kỳ lương Tháng 10/2026" required>
                        </div>
                    </div>

                    <!-- Ghi chú thẩm định của HR -->
                    <div class="mb-2">
                        <label class="form-label small fw-semibold text-muted mb-1">Ghi chú thẩm định thử việc của Trưởng bộ phận & HR</label>
                        <textarea class="form-control form-control-sm" name="hrNotes" id="approveBonusNotesInput" rows="2" placeholder="Xác nhận ứng viên đã hoàn thành 02 tháng thử việc đạt loại Tốt, đủ điều kiện chi trả hoa hồng Referral..."></textarea>
                    </div>
                </div>

                <div class="modal-footer bg-white border-top p-3 px-4 d-flex justify-content-between">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-success text-white fw-bold d-flex align-items-center gap-2 shadow-sm">
                        <i class="bi bi-patch-check-fill"></i>
                        <span>Xác Nhận Duyệt Thưởng & Đồng Bộ Bảng Lương</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 6: XEM CHI TIẾT ĐƠN ỨNG TUYỂN NỘI BỘ (#viewInternalApplicantModal)   -->
<!-- ========================================================================= -->
<div class="modal fade" id="viewInternalApplicantModal" tabindex="-1" aria-labelledby="viewInternalApplicantModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg rounded-3">
            <div class="modal-header p-3 px-4 bg-primary text-white">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-file-earmark-person-fill fs-5"></i>
                    <div>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="viewInternalApplicantModalLabel">Chi Tiết Đơn Ứng Tuyển Nội Bộ</h5>
                        <small class="text-white text-opacity-80" style="font-size: 0.78rem;">Hồ sơ nguyện vọng chuyển bộ phận / thăng tiến từ nhân sự công ty</small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4" style="background: #ffffff;">
                <div class="row g-3 mb-3 p-3 rounded-3" style="background: #f8fafc; border: 1px solid #e2e8f0;">
                    <div class="col-12 col-md-6">
                        <small class="text-muted d-block">Họ và tên nhân sự:</small>
                        <h5 class="fw-bold text-dark mb-0" id="viewModalApplicantName">--</h5>
                        <span class="badge bg-light text-muted border font-monospace mt-1" id="viewModalApplicantCode">UV-2026-xxx</span>
                    </div>
                    <div class="col-12 col-md-6 text-md-end">
                        <small class="text-muted d-block">Vị trí mong muốn ứng tuyển:</small>
                        <h6 class="fw-bold text-primary mb-0" id="viewModalJobTitle">--</h6>
                        <small class="text-muted" id="viewModalDeptName">--</small>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-6 col-md-3">
                        <div class="p-2 border rounded bg-light">
                            <small class="text-muted d-block">Email:</small>
                            <span class="fw-semibold text-dark small" id="viewModalEmail">--</span>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="p-2 border rounded bg-light">
                            <small class="text-muted d-block">Số điện thoại:</small>
                            <span class="fw-semibold text-dark small" id="viewModalPhone">--</span>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="p-2 border rounded bg-light">
                            <small class="text-muted d-block">Kinh nghiệm:</small>
                            <strong class="text-dark small" id="viewModalExp">--</strong>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="p-2 border rounded bg-light">
                            <small class="text-muted d-block">Lương kỳ vọng:</small>
                            <strong class="text-success small" id="viewModalSalary">--</strong>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <h6 class="fw-bold text-dark border-bottom pb-2">Nguyện vọng, định hướng & lý do ứng tuyển</h6>
                    <div class="p-3 rounded bg-light border text-secondary" style="font-size: 0.88rem; line-height: 1.6;" id="viewModalNotes">
                        --
                    </div>
                </div>

                <div id="viewModalCvContainer" class="mb-2">
                    <h6 class="fw-bold text-dark border-bottom pb-2">Hồ sơ CV cập nhật / Portfolio</h6>
                    <a href="#" target="_blank" id="viewModalCvLink" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-box-arrow-up-right me-1"></i> Mở xem CV / Tài liệu đính kèm
                    </a>
                </div>
            </div>

            <div class="modal-footer bg-light border-top p-3 px-4 d-flex justify-content-between">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                <div class="d-flex gap-2">
                    <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0">
                        <input type="hidden" name="action" value="hr_update_internal_stage">
                        <input type="hidden" name="candidateId" id="viewModalActionIdInterview" value="">
                        <input type="hidden" name="stage" value="INTERVIEW">
                        <button type="submit" class="btn btn-sm btn-outline-warning text-dark fw-bold">
                            <i class="bi bi-calendar-check me-1"></i> Duyệt Phỏng Vấn
                        </button>
                    </form>
                    <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0" onsubmit="return confirm('Xác nhận đồng ý tiếp nhận nhân sự chuyển bộ phận / thăng tiến?')">
                        <input type="hidden" name="action" value="hr_update_internal_stage">
                        <input type="hidden" name="candidateId" id="viewModalActionIdAccept" value="">
                        <input type="hidden" name="stage" value="ONBOARDED">
                        <button type="submit" class="btn btn-sm btn-success fw-bold text-white">
                            <i class="bi bi-check2-circle me-1"></i> Chấp Thuận Chuyển Ban
                        </button>
                    </form>
                    <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0" onsubmit="return confirm('Từ chối đơn ứng tuyển nội bộ này?')">
                        <input type="hidden" name="action" value="hr_update_internal_stage">
                        <input type="hidden" name="candidateId" id="viewModalActionIdReject" value="">
                        <input type="hidden" name="stage" value="REJECTED">
                        <button type="submit" class="btn btn-sm btn-outline-danger">
                            <i class="bi bi-x-circle me-1"></i> Từ chối
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Shared Footer -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- JavaScript Xử Lý Tương Tác Tuyển Dụng Nội Bộ (DOM-Based, An Toàn 100%) -->
<script>
    // Biến lưu jobId đang xem trong Modal JD
    let currentViewedJobId = null;

    // 1. Xử lý mở Modal xem chi tiết JD vị trí (Con mắt hoặc Tiêu đề)
    function handleViewDetailClick(jobId) {
        const card = document.getElementById('jobCard_' + jobId);
        if (!card) return;

        currentViewedJobId = jobId;
        const title = card.getAttribute('data-title') || 'Vị trí tuyển dụng';
        const code = card.getAttribute('data-code') || 'YCTD';
        const dept = card.getAttribute('data-dept') || 'Khối Chung';
        const salary = card.getAttribute('data-salary') || 'Thỏa thuận';
        const headcount = card.getAttribute('data-headcount') || '1 nhân sự';
        const deadline = card.getAttribute('data-deadline') || 'Đang mở';

        const descElem = card.querySelector('.job-desc-source');
        const reqElem = card.querySelector('.job-req-source');
        const beneElem = card.querySelector('.job-bene-source');

        document.getElementById('jdTitle').textContent = title;
        document.getElementById('jdCode').textContent = 'Mã vị trí: ' + code;
        document.getElementById('jdDept').textContent = dept;
        document.getElementById('jdSalary').textContent = salary;
        document.getElementById('jdHeadcount').textContent = headcount;
        document.getElementById('jdDeadline').textContent = deadline;

        document.getElementById('jdDescription').innerHTML = descElem ? descElem.innerHTML : 'Chưa cập nhật mô tả chi tiết';
        document.getElementById('jdRequirements').innerHTML = reqElem ? reqElem.innerHTML : 'Trao đổi cụ thể trong buổi phỏng vấn';
        document.getElementById('jdBenefits').innerHTML = beneElem ? beneElem.innerHTML : 'Được hưởng trọn vẹn chính sách đãi ngộ công ty';

        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('jobDetailModal'));
        modal.show();
    }

    // 2. Chuyển đổi 1-chạm từ Modal JD sang Ứng tuyển nội bộ
    function switchDetailToApply() {
        const jdModal = bootstrap.Modal.getInstance(document.getElementById('jobDetailModal'));
        if (jdModal) jdModal.hide();
        setTimeout(function() {
            if (currentViewedJobId) {
                handleApplyClick(currentViewedJobId);
            }
        }, 300);
    }

    // 3. Chuyển đổi 1-chạm từ Modal JD sang Giới thiệu bạn bè
    function switchDetailToRefer() {
        const jdModal = bootstrap.Modal.getInstance(document.getElementById('jobDetailModal'));
        if (jdModal) jdModal.hide();
        setTimeout(function() {
            if (currentViewedJobId) {
                handleReferClick(currentViewedJobId);
            }
        }, 300);
    }

    // 4. Chuyển đổi từ Modal JD cuộn xuống xem Chính sách thưởng
    function switchDetailToPolicy() {
        const jdModal = bootstrap.Modal.getInstance(document.getElementById('jobDetailModal'));
        if (jdModal) jdModal.hide();
        setTimeout(function() {
            scrollToReferralPolicy();
        }, 300);
    }

    // 5. Xử lý mở Modal Ứng tuyển nội bộ từ Job Card
    function handleApplyClick(jobId) {
        const card = document.getElementById('jobCard_' + jobId);
        if (!card) return;

        const title = card.getAttribute('data-title') || 'Vị trí tuyển dụng';
        const code = card.getAttribute('data-code') || 'YCTD';

        document.getElementById('applyReqId').value = jobId;
        document.getElementById('applyJobTitle').textContent = title;
        document.getElementById('applyJobCode').textContent = code;

        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('internalApplyModal'));
        modal.show();
    }

    // 6. Xử lý mở Modal Ứng tuyển nội bộ từ nút Recent Jobs
    function openApplyDirect(btnElem) {
        if (!btnElem) return;
        const jobId = btnElem.getAttribute('data-job-id');
        const title = btnElem.getAttribute('data-job-title');
        const code = btnElem.getAttribute('data-job-code');

        document.getElementById('applyReqId').value = jobId;
        document.getElementById('applyJobTitle').textContent = title;
        document.getElementById('applyJobCode').textContent = code;

        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('internalApplyModal'));
        modal.show();
    }

    // 7. Xử lý mở Modal Giới thiệu ứng viên từ Job Card
    function handleReferClick(jobId) {
        const card = document.getElementById('jobCard_' + jobId);
        if (!card) return;

        const title = card.getAttribute('data-title') || 'Vị trí giới thiệu';
        const code = card.getAttribute('data-code') || 'YCTD';

        document.getElementById('referReqId').value = jobId;
        document.getElementById('referJobTitle').textContent = title;
        document.getElementById('referJobCode').textContent = code;

        const select = document.getElementById('referJobSelect');
        if (select) select.value = jobId;

        const selectBox = document.getElementById('referJobSelectContainer');
        const fixedBox = document.getElementById('referJobFixedContainer');
        if (fixedBox) fixedBox.classList.remove('d-none');
        if (selectBox) selectBox.classList.add('d-none');

        updateEstimatedBonus(title);

        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('referCandidateModal'));
        modal.show();
    }

    // 8. Xử lý mở Modal Giới thiệu ứng viên từ nút chung (Banner, Section 5 header...)
    function openGeneralReferModal() {
        const selectBox = document.getElementById('referJobSelectContainer');
        const fixedBox = document.getElementById('referJobFixedContainer');
        if (selectBox) selectBox.classList.remove('d-none');
        if (fixedBox) fixedBox.classList.add('d-none');

        const select = document.getElementById('referJobSelect');
        if (select) {
            if (!select.value && select.options.length > 1) {
                select.selectedIndex = 1;
            }
            onReferJobSelectChange(select);
        }

        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('referCandidateModal'));
        modal.show();
    }

    function enableReferJobSelect() {
        const selectBox = document.getElementById('referJobSelectContainer');
        const fixedBox = document.getElementById('referJobFixedContainer');
        if (selectBox) selectBox.classList.remove('d-none');
        if (fixedBox) fixedBox.classList.add('d-none');
        const select = document.getElementById('referJobSelect');
        if (select) select.focus();
    }

    function onReferJobSelectChange(selectElem) {
        if (!selectElem) return;
        const selVal = selectElem.value;
        document.getElementById('referReqId').value = selVal;
        const selectedOpt = selectElem.options[selectElem.selectedIndex];
        if (selectedOpt && selVal) {
            const title = selectedOpt.getAttribute('data-title') || selectedOpt.text;
            const code = selectedOpt.getAttribute('data-code') || '';
            document.getElementById('referJobTitle').textContent = title;
            document.getElementById('referJobCode').textContent = code ? ('Mã: ' + code) : '';
            updateEstimatedBonus(title);
        }
    }

    // Tự động suy luận mức thưởng dự kiến dựa trên tiêu đề vị trí
    function updateEstimatedBonus(title) {
        if (!title) return;
        const t = title.toLowerCase();
        let amount = '4.000.000 VNĐ';
        if (t.includes('lead') || t.includes('quản lý') || t.includes('manager') || t.includes('specialist') || t.includes('trưởng')) {
            amount = '10.000.000 VNĐ (Quản lý / Tech Lead)';
        } else if (t.includes('senior')) {
            amount = '6.000.000 VNĐ (Senior Specialist)';
        } else if (t.includes('junior') || t.includes('fresher') || t.includes('tts') || t.includes('thực tập')) {
            amount = '2.000.000 VNĐ (Junior / Fresher)';
        } else {
            amount = '4.000.000 VNĐ (Mid-level Tiêu Chuẩn)';
        }
        const elem = document.getElementById('referBonusEstimateText');
        if (elem) elem.textContent = amount;
    }

    // 9. Cuộn mượt đến Section 5 Chính sách thưởng giới thiệu
    function scrollToReferralPolicy(e) {
        if (e && e.preventDefault) e.preventDefault();
        const sec = document.getElementById('referralPolicySection');
        if (sec) {
            sec.scrollIntoView({ behavior: 'smooth', block: 'start' });
            sec.style.transition = 'box-shadow 0.4s ease, transform 0.4s ease';
            sec.style.boxShadow = '0 0 0 4px rgba(16, 185, 129, 0.45)';
            sec.style.transform = 'translateY(-2px)';
            setTimeout(function() {
                sec.style.boxShadow = '';
                sec.style.transform = '';
            }, 1800);
        }
    }

    function closeModalAndScrollToPolicy() {
        const policyModal = bootstrap.Modal.getInstance(document.getElementById('referralPolicyModal'));
        if (policyModal) policyModal.hide();
        const referModal = bootstrap.Modal.getInstance(document.getElementById('referCandidateModal'));
        if (referModal) referModal.hide();
        setTimeout(function() {
            scrollToReferralPolicy();
        }, 350);
    }

    function closeModalAndOpenRefer() {
        const policyModal = bootstrap.Modal.getInstance(document.getElementById('referralPolicyModal'));
        if (policyModal) policyModal.hide();
        setTimeout(function() {
            openGeneralReferModal();
        }, 350);
    }

    function validateReferForm(form) {
        const reqId = document.getElementById('referReqId').value;
        if (!reqId || reqId.trim() === '') {
            alert('Vui lòng chọn vị trí tuyển dụng bạn muốn giới thiệu ứng viên.');
            enableReferJobSelect();
            return false;
        }
        return true;
    }

    // 10. Dành cho HR: Mở Modal Phê Duyệt Thưởng Referral Theo Cấp Bậc
    function openApproveBonusModalFromBtn(btnElem) {
        if (!btnElem) return;
        const candId = btnElem.getAttribute('data-id');
        const candName = btnElem.getAttribute('data-name');
        const jobTitle = btnElem.getAttribute('data-job');
        const referrerName = btnElem.getAttribute('data-referrer');
        openApproveBonusModal(candId, candName, jobTitle, referrerName);
    }

    function openApproveBonusModal(candId, candName, jobTitle, referrerName) {
        document.getElementById('approveBonusCandId').value = candId;
        document.getElementById('approveBonusCandName').textContent = candName || 'Ứng viên';
        document.getElementById('approveBonusJobTitle').textContent = jobTitle || 'Vị trí';
        document.getElementById('approveBonusReferrerName').textContent = referrerName || 'Nhân sự nội bộ';

        // Tự động chọn cấp bậc tương ứng trong dropdown
        const rankSelect = document.getElementById('approveBonusRankSelect');
        if (rankSelect && jobTitle) {
            const jt = jobTitle.toLowerCase();
            if (jt.includes('lead') || jt.includes('quản lý') || jt.includes('manager') || jt.includes('specialist') || jt.includes('trưởng')) {
                rankSelect.selectedIndex = 0; // 10Tr
            } else if (jt.includes('senior')) {
                rankSelect.selectedIndex = 1; // 6Tr
            } else if (jt.includes('junior') || jt.includes('fresher') || jt.includes('tts') || jt.includes('thực tập')) {
                rankSelect.selectedIndex = 3; // 2Tr
            } else {
                rankSelect.selectedIndex = 2; // 4Tr
            }
            onApproveRankSelectChange(rankSelect);
        }

        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('approveReferralBonusModal'));
        modal.show();
    }

    function onApproveRankSelectChange(selectElem) {
        if (!selectElem) return;
        const opt = selectElem.options[selectElem.selectedIndex];
        if (opt) {
            const amt = opt.getAttribute('data-amount') || '6.000.000 VNĐ';
            const input = document.getElementById('approveBonusAmountInput');
            if (input) input.value = amt;
        }
    }

    // 11. Dành cho HR: Mở Modal Xem Toàn Văn Đơn Ứng Tuyển Nội Bộ
    function openViewInternalApplicantModal(btnElem) {
        if (!btnElem) return;
        const candId = btnElem.getAttribute('data-id');
        const name = btnElem.getAttribute('data-name');
        const code = btnElem.getAttribute('data-code');
        const email = btnElem.getAttribute('data-email');
        const phone = btnElem.getAttribute('data-phone');
        const job = btnElem.getAttribute('data-job');
        const dept = btnElem.getAttribute('data-dept');
        const exp = btnElem.getAttribute('data-exp');
        const salary = btnElem.getAttribute('data-salary');
        const notes = btnElem.getAttribute('data-notes');
        const cv = btnElem.getAttribute('data-cv');

        document.getElementById('viewModalApplicantName').textContent = name || 'Nhân sự';
        document.getElementById('viewModalApplicantCode').textContent = code || 'UV';
        document.getElementById('viewModalJobTitle').textContent = job || 'Vị trí nội bộ';
        document.getElementById('viewModalDeptName').textContent = dept || '';
        document.getElementById('viewModalEmail').textContent = email || 'Chưa cập nhật';
        document.getElementById('viewModalPhone').textContent = phone || 'Chưa cập nhật';
        document.getElementById('viewModalExp').textContent = (exp ? exp + ' năm' : 'Chưa rõ');
        document.getElementById('viewModalSalary').textContent = salary || 'Thỏa thuận';
        document.getElementById('viewModalNotes').textContent = notes || 'Không có ghi chú thêm.';

        // Gán id cho các form xử lý trong modal
        document.getElementById('viewModalActionIdInterview').value = candId;
        document.getElementById('viewModalActionIdAccept').value = candId;
        document.getElementById('viewModalActionIdReject').value = candId;

        const cvLink = document.getElementById('viewModalCvLink');
        const cvBox = document.getElementById('viewModalCvContainer');
        if (cv && cv.trim() !== '' && cv !== '#') {
            cvLink.href = cv;
            cvBox.classList.remove('d-none');
        } else {
            cvBox.classList.add('d-none');
        }

        const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('viewInternalApplicantModal'));
        modal.show();
    }

    // Mở Modal nếu có query param ?jobId=xxx
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const paramJobId = urlParams.get('jobId');
        if (paramJobId && document.getElementById('jobCard_' + paramJobId)) {
            handleViewDetailClick(paramJobId);
        }
    });
</script>
</body>
</html>
