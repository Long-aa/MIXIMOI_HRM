<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tạo đơn xin nghỉ phép — MIXIMOI HRM & PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
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
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    <strong>Không thể gửi đơn:</strong> ${error}
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
                                    <div class="col-12">
                                        <label class="form-label-custom">
                                            Loại nghỉ phép <span class="required-mark">*</span>
                                        </label>
                                        <select class="form-select form-select-custom" name="leaveType" required>
                                            <option value="ANNUAL">Nghỉ phép năm (Hưởng nguyên lương theo quy định)</option>
                                            <option value="SICK">Nghỉ ốm đau / Bệnh viện (Có giấy chứng nhận y tế)</option>
                                            <option value="PERSONAL">Việc riêng (Hiếu, hỉ, giải quyết thủ tục cá nhân)</option>
                                            <option value="MATERNITY">Nghỉ thai sản (Theo chế độ BHXH)</option>
                                            <option value="UNPAID">Nghỉ không hưởng lương</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label-custom">
                                            Bắt đầu nghỉ từ ngày <span class="required-mark">*</span>
                                        </label>
                                        <input type="date" class="form-control form-control-custom" 
                                               name="startDate" id="leaveStartDate" required>
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng chọn ngày bắt đầu nghỉ.</div>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label-custom">
                                            Đến hết ngày <span class="required-mark">*</span>
                                        </label>
                                        <input type="date" class="form-control form-control-custom" 
                                               name="endDate" id="leaveEndDate" required>
                                        <div class="invalid-feedback" style="font-size:0.75rem">Vui lòng chọn ngày kết thúc nghỉ.</div>
                                    </div>

                                    <div class="col-12">
                                        <div class="p-3 bg-light rounded-3 d-flex justify-content-between align-items-center border">
                                            <span class="text-secondary fw-semibold" style="font-size:0.86rem">
                                                <i class="bi bi-clock-history text-primary me-1"></i> Ước tính số ngày nghỉ:
                                            </span>
                                            <span id="estimatedDays" class="badge bg-primary fs-6 px-3 py-2 font-monospace">0 ngày</span>
                                        </div>
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

<script>
    document.addEventListener('DOMContentLoaded', () => {
        window.initLeaveDurationCalculator('#leaveStartDate', '#leaveEndDate', '#estimatedDays');

        // Bootstrap form validation
        const forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    });
</script>

</body>
</html>
