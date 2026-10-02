<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tạo đơn xin nghỉ phép — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/leave.css">
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="leave" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Leave Form Content Body -->
        <div class="app-content">
            
            <!-- Page Header Breadcrumbs & Action -->
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-calendar-plus text-primary"></i> Đăng ký nghỉ phép
                    </h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="font-size:0.82rem">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/leave" class="text-decoration-none">Nghỉ phép</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Tạo đơn mới</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/leave" class="btn-action-light text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <!-- Error Alert -->
            <c:if test="${not empty error or not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    <strong>Không thể gửi đơn:</strong> <c:out value="${not empty error ? error : param.error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="app-card">
                        <form method="post" action="${pageContext.request.contextPath}/leave" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="submit">

                            <div class="form-section">
                                <div class="form-section-header">
                                    <div class="form-section-icon">
                                        <i class="bi bi-calendar-range"></i>
                                    </div>
                                    <div>
                                        <h6 class="form-section-title">Khai báo thông tin nghỉ phép</h6>
                                        <p class="form-section-desc">Vui lòng điền đúng thời gian và lý do để bộ phận quản lý phê duyệt</p>
                                    </div>
                                </div>

                                <div class="row g-3">
                                    <!-- Nhân viên xin nghỉ -->
                                    <div class="col-12">
                                        <label class="form-label-custom">
                                            Nhân viên xin nghỉ <span class="required-mark">*</span>
                                        </label>
                                        <c:choose>
                                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager}">
                                                <input type="hidden" name="employeeId" value="${sessionScope.currentUser.employeeId}">
                                                <input type="text" class="form-control form-control-custom" value="${sessionScope.currentUser.fullName} (${sessionScope.currentUser.username})" readonly style="background:#f1f5f9;">
                                            </c:when>
                                            <c:otherwise>
                                                <select name="employeeId" class="form-select form-select-custom" required>
                                                    <c:forEach var="e" items="${employees}">
                                                        <option value="${e.id}" ${e.id == sessionScope.currentUser.employeeId ? 'selected' : ''}>
                                                            ${e.fullName} (${e.employeeCode}) — ${e.departmentName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label-custom">
                                            Loại nghỉ phép <span class="required-mark">*</span>
                                        </label>
                                        <select class="form-select form-select-custom" name="leaveType" id="leaveTypeSelect" required onchange="calculateLeaveDays()">
                                            <option value="ANNUAL">Nghỉ phép năm (Hưởng nguyên lương theo quy định)</option>
                                            <option value="SICK">Nghỉ ốm đau / Bệnh viện (Có giấy chứng nhận y tế)</option>
                                            <option value="PERSONAL">Việc riêng (Hiếu, hỉ, giải quyết thủ tục cá nhân)</option>
                                            <option value="MATERNITY">Nghỉ thai sản (Theo chế độ BHXH)</option>
                                            <option value="UNPAID">Nghỉ không hưởng lương</option>
                                        </select>
                                        <c:if test="${not empty availableLeaveDays}">
                                            <div class="mt-2 p-2 px-3 rounded-2 d-flex align-items-center gap-2" style="background:#ecfdf5; border:1px solid #a7f3d0; font-size:0.83rem; color:#065f46;">
                                                <i class="bi bi-wallet2 text-success fs-6"></i>
                                                <span>Số dư phép năm khả dụng hiện tại: <strong id="userAvailDaysBadge" data-avail="${availableLeaveDays}">${availableLeaveDays} ngày</strong>.</span>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Hình thức nghỉ: Cả ngày vs Nửa ngày -->
                                    <div class="col-12">
                                        <label class="form-label-custom">
                                            Thời lượng nghỉ <span class="required-mark">*</span>
                                        </label>
                                        <div class="d-flex gap-4 p-3 bg-light rounded-3 border">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="leaveDuration" id="durationFull" value="FULL_DAY" checked onchange="toggleDurationMode()">
                                                <label class="form-check-label fw-bold text-dark" for="durationFull" style="cursor:pointer;">
                                                    <i class="bi bi-calendar-check text-primary me-1"></i> Nghỉ cả ngày
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="leaveDuration" id="durationHalf" value="HALF_DAY" onchange="toggleDurationMode()">
                                                <label class="form-check-label fw-bold text-dark" for="durationHalf" style="cursor:pointer;">
                                                    <i class="bi bi-clock-half text-warning me-1"></i> Nghỉ nửa ngày (0.5 ngày - 4 giờ)
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Chọn buổi nghỉ (chỉ hiển thị khi chọn Nửa ngày) -->
                                    <div class="col-12 d-none" id="sessionSelectBlock">
                                        <label class="form-label-custom">
                                            Chọn buổi nghỉ trong ngày <span class="required-mark">*</span>
                                        </label>
                                        <div class="d-flex gap-4 p-3 rounded-3" style="background:#fffbeb; border:1px dashed #fde68a;">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="leaveSession" id="sessionMorning" value="MORNING" checked onchange="calculateLeaveDays()">
                                                <label class="form-check-label text-dark" for="sessionMorning" style="cursor:pointer;">
                                                    <strong>Buổi sáng:</strong> 08:00 – 12:00 (Check-in chiều 13:30)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="leaveSession" id="sessionAfternoon" value="AFTERNOON" onchange="calculateLeaveDays()">
                                                <label class="form-check-label text-dark" for="sessionAfternoon" style="cursor:pointer;">
                                                    <strong>Buổi chiều:</strong> 13:30 – 17:30 (Check-out trưa 12:00)
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6" id="startDateCol">
                                        <label class="form-label-custom">
                                            <span id="startDateLabel">Bắt đầu nghỉ từ ngày</span> <span class="required-mark">*</span>
                                        </label>
                                        <input type="date" class="form-control form-control-custom" 
                                               name="startDate" id="leaveStartDate" required onchange="handleStartDateChange()">
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng chọn ngày bắt đầu nghỉ.</div>
                                    </div>

                                    <div class="col-md-6" id="endDateCol">
                                        <label class="form-label-custom">
                                            Đến hết ngày <span class="required-mark">*</span>
                                        </label>
                                        <input type="date" class="form-control form-control-custom" 
                                               name="endDate" id="leaveEndDate" required onchange="calculateLeaveDays()">
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng chọn ngày kết thúc nghỉ.</div>
                                    </div>

                                    <input type="hidden" name="days" id="leaveDaysInput" value="1">

                                    <div class="col-12">
                                        <div class="p-3 bg-light rounded-3 d-flex justify-content-between align-items-center border">
                                            <div>
                                                <span class="text-secondary fw-semibold" style="font-size:0.86rem">
                                                    <i class="bi bi-clock-history text-primary me-1"></i> Ước tính số ngày nghỉ làm việc:
                                                </span>
                                                <small class="text-muted d-block" style="font-size:0.76rem;">(Đã tự động loại trừ Thứ 7, Chủ Nhật và 11 Ngày Lễ Quốc Gia năm 2026)</small>
                                            </div>
                                            <span id="estimatedDays" class="badge bg-primary fs-6 px-3 py-2 font-monospace">1 ngày</span>
                                        </div>
                                        <div id="weekendNotice" class="alert alert-warning border-0 mt-2 py-2 d-none" style="font-size:0.82rem;">
                                            <i class="bi bi-exclamation-triangle-fill text-warning me-1"></i> 
                                            Ngày bạn chọn rơi vào ngày nghỉ cuối tuần (Thứ 7 / Chủ Nhật). Vui lòng chọn ngày làm việc trong tuần.
                                        </div>
                                        <div id="quotaExceededNotice" class="alert alert-danger border-0 mt-2 py-2 d-none" style="font-size:0.82rem;">
                                            <i class="bi bi-exclamation-circle-fill text-danger me-1"></i> 
                                            Số ngày nghỉ phép năm vượt quá số dư khả dụng! Vui lòng giảm số ngày hoặc chuyển sang <strong>Nghỉ không hưởng lương (UNPAID)</strong>.
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label-custom">
                                            Người nhận bàn giao công việc <span class="required-mark">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-custom" name="handoverPerson" required
                                               placeholder="Họ tên người nhận bàn giao công việc — Số điện thoại liên hệ...">
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng nhập người nhận bàn giao công việc.</div>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label-custom">
                                            <i class="bi bi-paperclip me-1 text-primary"></i>Tài liệu đính kèm minh chứng (Chứng từ y tế / Thiệp cưới / Giấy tờ liên quan)
                                        </label>
                                        <input type="text" class="form-control form-control-custom" name="attachmentUrl"
                                               placeholder="Đường dẫn file hoặc URL chứng từ minh chứng (VD: /uploads/giay_ra_vien.pdf)...">
                                        <small class="text-muted" style="font-size:0.75rem;">Bắt buộc đối với Nghỉ ốm đau/Bệnh viện (giấy ra viện) hoặc Thai sản</small>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label-custom">
                                            Lý do xin nghỉ <span class="required-mark">*</span>
                                        </label>
                                        <textarea class="form-control form-control-custom" name="reason" rows="4" required
                                                  placeholder="Vui lòng nêu chi tiết lý do và bàn giao công việc cần thiết trong thời gian nghỉ..."></textarea>
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng ghi rõ lý do xin nghỉ.</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Bar -->
                            <div class="d-flex justify-content-end align-items-center gap-3 pt-3">
                                <a href="${pageContext.request.contextPath}/leave" class="btn-action-light text-decoration-none">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn-action-primary border-0">
                                    <i class="bi bi-send-fill"></i> Gửi đơn phê duyệt
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/leave.js"></script>
</body>
</html>
