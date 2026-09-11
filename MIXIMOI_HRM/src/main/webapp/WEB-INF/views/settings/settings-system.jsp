<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Thiết lập Hệ thống Doanh nghiệp - MIXIMOI HRM" />
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
            <c:if test="${param.success eq 'system_saved'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div>Đã lưu thành công toàn bộ thiết lập hệ thống doanh nghiệp MIXIMOI ERP v4.2!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Thiết lập hệ thống</h1>
                        <span class="badge bg-primary-subtle text-primary font-monospace fw-bold">ENTERPRISE v4.2 (BUILD 2026.09.12)</span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý các cấu hình chung của hệ thống MIXIMOI HRM & PAYROLL.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/settings" class="btn btn-outline-secondary">Hủy thay đổi</a>
                    <button type="submit" form="systemSettingsForm" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm">
                        <i class="bi bi-floppy-fill"></i>
                        <span>Lưu cấu hình</span>
                    </button>
                </div>
            </div>

            <!-- Two-Column Layout: Settings Navigation Sidebar + Form Content -->
            <div class="row g-4">
                <!-- Col-3: Vertical Settings Tabs -->
                <div class="col-12 col-lg-3">
                    <div class="settings-nav-card position-sticky" style="top: 80px;">
                        <div class="fw-bold text-muted small px-3 py-2 text-uppercase" style="font-size: 0.68rem; letter-spacing: 0.5px;">
                            DANH MỤC THIẾT LẬP
                        </div>
                        <a href="#sec-company" class="settings-nav-link active">
                            <i class="bi bi-building text-primary"></i>
                            <span>1. Thông tin doanh nghiệp</span>
                        </a>
                        <a href="#sec-emp-code" class="settings-nav-link">
                            <i class="bi bi-person-badge"></i>
                            <span>2. Quy tắc mã & Nhân sự</span>
                        </a>
                        <a href="#sec-working-time" class="settings-nav-link">
                            <i class="bi bi-clock-history"></i>
                            <span>3. Chấm công & Ca làm việc</span>
                        </a>
                        <a href="#sec-leave-policy" class="settings-nav-link">
                            <i class="bi bi-calendar-check"></i>
                            <span>4. Nghỉ phép & Phê duyệt</span>
                        </a>
                        <a href="#sec-payroll-tax" class="settings-nav-link">
                            <i class="bi bi-cash-coin text-danger"></i>
                            <span>5. Cấu hình Lương & Thuế</span>
                        </a>
                        <a href="#sec-notifications" class="settings-nav-link">
                            <i class="bi bi-bell"></i>
                            <span>6. Thông báo & Cảnh báo</span>
                        </a>
                        <a href="#sec-security-audit" class="settings-nav-link">
                            <i class="bi bi-shield-lock"></i>
                            <span>7. Bảo mật & Nhật ký</span>
                        </a>

                        <!-- Sync Status Card -->
                        <div class="p-3 bg-light rounded-3 mt-3 border" style="font-size: 0.74rem;">
                            <div class="d-flex align-items-center gap-2 text-dark fw-bold mb-1">
                                <span class="vssid-status-dot"></span>
                                <span>Trạng thái đồng bộ</span>
                            </div>
                            <div class="text-muted mb-2">Hệ sinh thái MIXIMOI ERP đồng bộ tức thì trên toàn quốc qua SSL 256-bit.</div>
                            <span class="badge bg-success-subtle text-success border border-success-subtle">Hoạt động ổn định</span>
                        </div>
                    </div>
                </div>

                <!-- Col-9: Settings Form Body -->
                <div class="col-12 col-lg-9">
                    <form id="systemSettingsForm" method="post" action="${pageContext.request.contextPath}/settings">
                        <input type="hidden" name="action" value="save_system">

                        <!-- Section 1: Thông tin pháp lý & Thương hiệu -->
                        <div id="sec-company" class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="d-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-2" style="width: 32px; height: 32px;">
                                        <i class="bi bi-building"></i>
                                    </div>
                                    <h2 class="h6 fw-bold text-dark mb-0">1. Thông tin pháp lý & Nhận diện thương hiệu</h2>
                                </div>
                                <span class="badge bg-light text-primary border">Bắt buộc theo Luật Doanh nghiệp</span>
                            </div>
                            <small class="text-muted mb-3 d-block">Cung cấp thông tin doanh nghiệp để hiển thị trên hợp đồng, phiếu lương và báo cáo thuế.</small>

                            <!-- Logos -->
                            <div class="row g-3 mb-3">
                                <div class="col-12 col-md-6">
                                    <div class="p-3 border rounded-3 bg-light d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="bg-white border rounded p-2 text-primary fw-bold" style="font-size: 0.9rem;">MIXIMOI</div>
                                            <div>
                                                <div class="fw-bold text-dark small">Logo thương hiệu chính thức</div>
                                                <small class="text-muted" style="font-size: 0.72rem;">Định dạng PNG, SVG trong suốt (khuyến nghị 512x128px)</small>
                                            </div>
                                        </div>
                                        <button type="button" class="btn btn-sm btn-primary">Thay đổi logo</button>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <div class="p-3 border rounded-3 bg-light d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="bg-primary text-white rounded p-2 text-center" style="width: 36px; height: 36px; font-size: 0.9rem;">M</div>
                                            <div>
                                                <div class="fw-bold text-dark small">Điều hướng Favicon & App Icon</div>
                                                <small class="text-muted" style="font-size: 0.72rem;">Hiển thị trên tab trình duyệt và ứng dụng PWA di động</small>
                                            </div>
                                        </div>
                                        <button type="button" class="btn btn-sm btn-outline-secondary">Tải lên icon</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Form fields -->
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label small fw-semibold">Tên doanh nghiệp đầy đủ (Theo ĐKKD) <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="companyFullName" value="CÔNG TY CỔ PHẦN CÔNG NGHỆ & DỊCH VỤ MIXIMOI VIỆT NAM" required>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Tên viết tắt / Tên giao dịch <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="companyShortName" value="MIXIMOI CORP" required>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Mã số doanh nghiệp (MST) <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="taxCode" value="0316888999" required>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Người đại diện pháp luật <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="legalRep" value="Nguyễn Văn Admin" required>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Chức danh người đại diện</label>
                                    <input type="text" class="form-control" name="legalTitle" value="Tổng Giám Đốc" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small fw-semibold">Địa chỉ trụ sở chính (Theo ĐKKD) <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="address" value="Tầng 18, Tòa nhà Landmark 81, 720A Điện Biên Phủ, Phường 22, Bình Thạnh, TP. Hồ Chí Minh" required>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Số điện thoại bàn / Hotline</label>
                                    <input type="text" class="form-control" name="phone" value="028 7300 8888">
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Website chính thức</label>
                                    <input type="text" class="form-control" name="website" value="https://miximoi.vn">
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Email hệ thống (System Notification)</label>
                                    <input type="email" class="form-control" name="sysEmail" value="contact@miximoi.vn">
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Email nhận hóa đơn & chứng từ kế toán</label>
                                    <input type="email" class="form-control" name="billingEmail" value="accounting@miximoi.vn">
                                </div>
                            </div>
                        </div>

                        <!-- Section 2: Quy tắc mã & Thiết lập nhân sự ban đầu -->
                        <div id="sec-emp-code" class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="d-flex align-items-center justify-content-center bg-info-subtle text-info rounded-2" style="width: 32px; height: 32px;">
                                        <i class="bi bi-person-badge"></i>
                                    </div>
                                    <h2 class="h6 fw-bold text-dark mb-0">2. Quy tắc mã & Thiết lập nhân sự ban đầu</h2>
                                </div>
                                <div class="form-check form-switch mb-0">
                                    <input class="form-check-input" type="checkbox" checked id="autoGenCode">
                                    <label class="form-check-label small fw-semibold" for="autoGenCode">Tự động sinh mã</label>
                                </div>
                            </div>
                            <small class="text-muted mb-3 d-block">Hệ thống sẽ tự động gán mã số khi tiếp nhận ứng viên tuyển dụng Onboarding.</small>

                            <div class="row g-3 mb-3">
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Tiền tố mã (Prefix)</label>
                                    <input type="text" class="form-control" value="NV">
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Độ dài số tự tăng</label>
                                    <select class="form-select">
                                        <option selected>4 chữ số (Ví dụ: 0102)</option>
                                        <option>5 chữ số (Ví dụ: 00102)</option>
                                        <option>6 chữ số (Ví dụ: 000102)</option>
                                    </select>
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Format định dạng năm</label>
                                    <select class="form-select">
                                        <option selected>Theo năm hiện tại (YYYY)</option>
                                        <option>Theo 2 số cuối năm (YY)</option>
                                        <option>Không kèm năm</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Preview Box -->
                            <div class="p-3 bg-light rounded-3 border d-flex justify-content-between align-items-center">
                                <div>
                                    <small class="text-muted d-block">Mẫu mã nhân viên trực quan:</small>
                                    <strong class="text-primary font-monospace fs-6">NV-YYYY-00102</strong>
                                </div>
                                <span class="badge bg-light text-dark border">Ví dụ thực tế cho nhân sự tiếp theo: <strong>NV-2026-0102</strong></span>
                            </div>
                        </div>

                        <!-- Section 3: Thời gian làm việc, Đi muộn & Tăng ca -->
                        <div id="sec-working-time" class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="d-flex align-items-center justify-content-center bg-warning-subtle text-warning-emphasis rounded-2" style="width: 32px; height: 32px;">
                                        <i class="bi bi-clock-history"></i>
                                    </div>
                                    <h2 class="h6 fw-bold text-dark mb-0">3. Thời gian làm việc, Đi muộn & Tăng ca (Overtime)</h2>
                                </div>
                                <span class="badge bg-primary-subtle text-primary">8.0 giờ làm việc chuẩn / ngày</span>
                            </div>
                            <small class="text-muted mb-3 d-block">Thiết lập tham số chuẩn dùng so chiếu công ngoài giờ và tích hợp máy quét vân tay/khuôn mặt.</small>

                            <div class="row g-3 mb-3">
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Giờ bắt đầu làm việc</label>
                                    <input type="time" class="form-control" value="08:30">
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Giờ kết thúc làm việc</label>
                                    <input type="time" class="form-control" value="18:00">
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Khoảng thời gian nghỉ trưa</label>
                                    <input type="text" class="form-control" value="12:00 - 13:30 (90 phút)" readonly>
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Dung sai đi muộn cho phép</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" value="15">
                                        <span class="input-group-text">phút</span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Số lần trễ tối đa / tháng</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" value="3">
                                        <span class="input-group-text">lần/tháng</span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Khấu trừ chuyên cần khi quá hạn</label>
                                    <input type="text" class="form-control" value="Trừ trực tiếp vào phụ cấp chuyên cần" readonly>
                                </div>
                            </div>

                            <!-- Overtime multiplier -->
                            <div class="p-3 bg-light rounded-3 border">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold text-dark small">Hệ số tính lương làm thêm giờ (Tăng ca OT):</span>
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input" type="checkbox" checked id="allowOt">
                                        <label class="form-check-label small" for="allowOt">Cho phép tính OT</label>
                                    </div>
                                </div>
                                <div class="row g-2 text-center" style="font-size: 0.8rem;">
                                    <div class="col-4">
                                        <div class="p-2 border rounded bg-white">
                                            <div class="text-muted small">Ngày làm việc thường</div>
                                            <strong class="text-primary fs-5">150%</strong>
                                            <small class="text-muted d-block">lương cơ bản</small>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="p-2 border rounded bg-white">
                                            <div class="text-muted small">Ngày nghỉ cuối tuần</div>
                                            <strong class="text-success fs-5">200%</strong>
                                            <small class="text-muted d-block">lương cơ bản</small>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="p-2 border rounded bg-white">
                                            <div class="text-muted small">Ngày lễ / Tết nghỉ phép</div>
                                            <strong class="text-danger fs-5">300%</strong>
                                            <small class="text-muted d-block">lương cơ bản</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 4: Nghỉ phép & Phê duyệt -->
                        <div id="sec-leave-policy" class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="d-flex align-items-center justify-content-center bg-success-subtle text-success rounded-2" style="width: 32px; height: 32px;">
                                        <i class="bi bi-calendar-check"></i>
                                    </div>
                                    <h2 class="h6 fw-bold text-dark mb-0">4. Chế độ nghỉ phép & Quy trình phê duyệt</h2>
                                </div>
                                <span class="badge bg-success-subtle text-success">Phép năm: 12 ngày chuẩn</span>
                            </div>
                            <small class="text-muted mb-3 d-block">Quản lý định mức phép năm, thâm niên và các cấp định tuyến phê duyệt đơn xin nghỉ.</small>

                            <div class="row g-3 mb-3">
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Số ngày phép năm tiêu chuẩn</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" value="12">
                                        <span class="input-group-text">ngày/năm</span>
                                    </div>
                                    <small class="text-muted" style="font-size: 0.72rem;">Tự động cộng thêm 1 ngày cho mỗi 5 năm làm việc liên tục.</small>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Quy định chuyển phép tồn sang năm sau</label>
                                    <select class="form-select">
                                        <option selected>Hạn chót sử dụng phép năm cũ đến hết 31/03</option>
                                        <option>Không bảo lưu sang năm sau</option>
                                        <option>Quy đổi thành tiền chi trả vào lương T12</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Approval flow -->
                            <div class="p-3 bg-light rounded-3 border">
                                <div class="fw-bold text-dark small mb-2">Phân cấp quy trình phê duyệt đơn xin nghỉ:</div>
                                <div class="d-flex flex-column gap-2" style="font-size: 0.8rem;">
                                    <div class="p-2 border rounded bg-white d-flex justify-content-between align-items-center">
                                        <span><strong>1. Trưởng bộ phận trực tiếp (Line Manager):</strong> Phê duyệt đối với các đơn nghỉ dưới 2 ngày làm việc liên tiếp.</span>
                                        <span class="badge bg-light text-dark border">≤ 2 ngày</span>
                                    </div>
                                    <div class="p-2 border rounded bg-white d-flex justify-content-between align-items-center">
                                        <span><strong>2. Trưởng phòng Nhân sự & Ban Giám Đốc:</strong> Phê duyệt đối với các đơn nghỉ dài ngày từ 3 ngày trở lên.</span>
                                        <span class="badge bg-light text-dark border">≥ 3 ngày</span>
                                    </div>
                                </div>
                                <div class="form-check form-switch mt-2 mb-0">
                                    <input class="form-check-input" type="checkbox" checked id="autoApprove">
                                    <label class="form-check-label small" for="autoApprove">Tự động duyệt khi quá hạn 48 giờ nếu quản lý không phản hồi</label>
                                </div>
                            </div>
                        </div>

                        <!-- Section 5: Cấu hình Lương, Thuế & Trích nộp bảo hiểm -->
                        <div id="sec-payroll-tax" class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="d-flex align-items-center justify-content-center bg-danger-subtle text-danger rounded-2" style="width: 32px; height: 32px;">
                                        <i class="bi bi-cash-coin"></i>
                                    </div>
                                    <h2 class="h6 fw-bold text-dark mb-0">5. Chu kỳ tính Lương, Thuế & Trích nộp bảo hiểm</h2>
                                </div>
                                <span class="badge bg-danger-subtle text-danger">Lưu ý rủi ro</span>
                            </div>
                            <div class="alert alert-warning py-2 small d-flex align-items-center gap-2 mb-3">
                                <i class="bi bi-exclamation-triangle-fill text-warning"></i>
                                <span>Thay đổi các thông số tính lương sẽ ảnh hưởng trực tiếp đến chu kỳ lương tiếp theo và cần xác thực bảo mật trước khi áp dụng.</span>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Ngày chốt bảng công tháng</label>
                                    <select class="form-select">
                                        <option selected>Ngày 25 hàng tháng</option>
                                        <option>Ngày cuối cùng của tháng</option>
                                    </select>
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Ngày chi trả lương chính thức</label>
                                    <select class="form-select">
                                        <option selected>Ngày 05 của tháng tiếp theo</option>
                                        <option>Ngày 10 của tháng tiếp theo</option>
                                    </select>
                                </div>
                                <div class="col-12 col-md-4">
                                    <label class="form-label small fw-semibold">Chu kỳ tính lương</label>
                                    <input type="text" class="form-control" value="Từ ngày 26 tháng trước đến 25" readonly>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Lương cơ sở đóng BHXH hiện hành</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" value="2.340.000">
                                        <span class="input-group-text">VNĐ</span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Biểu thuế TNCN áp dụng</label>
                                    <input type="text" class="form-control" value="Biểu thuế lũy tiến từng phần 7 bậc (TT111)" readonly>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Mức giảm trừ gia cảnh bản thân</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" value="11.000.000">
                                        <span class="input-group-text">đ/tháng</span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label small fw-semibold">Mức giảm trừ mỗi người phụ thuộc</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" value="4.400.000">
                                        <span class="input-group-text">đ/người/tháng</span>
                                    </div>
                                </div>
                            </div>

                            <div class="p-3 bg-light rounded-3 border">
                                <div class="d-flex justify-content-between text-muted small mb-1">
                                    <span>Doanh nghiệp chịu trích nộp: <strong>21.5%</strong> (BHXH 17%, BHYT 3%, BHTN 1%, BHTNLĐ 0.5%)</span>
                                </div>
                                <div class="d-flex justify-content-between text-muted small">
                                    <span>Người lao động chịu khấu trừ: <strong class="text-danger">10.5%</strong> (BHXH 8%, BHYT 1.5%, BHTN 1%)</span>
                                </div>
                            </div>
                        </div>

                        <!-- Section 6: Thông báo & Cảnh báo -->
                        <div id="sec-notifications" class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <div class="d-flex align-items-center justify-content-center bg-purple-subtle text-purple rounded-2" style="width: 32px; height: 32px; background: #f3e8ff; color: #7e22ce;">
                                    <i class="bi bi-bell"></i>
                                </div>
                                <h2 class="h6 fw-bold text-dark mb-0">6. Kênh Thông báo, Nhắc hạn hợp đồng & Chấm công</h2>
                            </div>
                            <small class="text-muted mb-3 d-block">Tự động hóa thông báo qua email và web app nhằm đảm bảo quy trình vận hành trôi chảy.</small>

                            <div class="list-group list-group-flush border-top border-bottom mb-3" style="font-size: 0.83rem;">
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                                    <div>
                                        <div class="fw-semibold text-dark">Gửi thông báo qua Email (SendGrid SMTP Gateway)</div>
                                        <small class="text-muted">Tự động gửi email thông báo phê duyệt đơn phép, biên bản vi phạm và xác nhận nhận việc.</small>
                                    </div>
                                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked></div>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                                    <div>
                                        <div class="fw-semibold text-dark">Cảnh báo hợp đồng lao động sắp hết hạn</div>
                                        <small class="text-muted">Tự động gửi email trước <strong>30 ngày</strong> tới Phòng Nhân sự và Trưởng bộ phận để chuẩn bị tái ký hoặc thanh lý.</small>
                                    </div>
                                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked></div>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                                    <div>
                                        <div class="fw-semibold text-dark">Nhắc nhân viên chấm công mỗi buổi sáng</div>
                                        <small class="text-muted">Gửi thông báo đẩy (Push Notification PWA, Mobile App) lúc <strong>08:20 sáng</strong> mỗi ngày làm việc cho ai chưa check-in.</small>
                                    </div>
                                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked></div>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                                    <div>
                                        <div class="fw-semibold text-dark">Cảnh báo công đột biến / nghỉ quá giới hạn</div>
                                        <small class="text-muted">Tự động thông báo HRBP khi phát hiện trường hợp nghỉ quá <strong>3 ngày không phép liên tiếp</strong>.</small>
                                    </div>
                                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked></div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 7: Bảo mật & Nhật ký -->
                        <div id="sec-security-audit" class="card border-0 shadow-sm rounded-3 p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="d-flex align-items-center justify-content-center bg-secondary-subtle text-secondary rounded-2" style="width: 32px; height: 32px;">
                                        <i class="bi bi-shield-lock"></i>
                                    </div>
                                    <h2 class="h6 fw-bold text-dark mb-0">7. Bảo mật & Nhật ký hệ thống (Audit Trail)</h2>
                                </div>
                                <span class="badge bg-light text-dark border font-monospace">ISO 27001 SOC 2</span>
                            </div>
                            <small class="text-muted mb-3 d-block">Chính sách xác thực hai yếu tố và ghi log toàn bộ thao tác quan trọng vào nhật ký bảo mật.</small>

                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <div class="p-3 border rounded-3 bg-light">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <strong class="text-dark small">Xác thực 2 yếu tố (2FA TOTP)</strong>
                                            <span class="badge bg-primary-subtle text-primary">Bắt buộc</span>
                                        </div>
                                        <small class="text-muted d-block mb-2" style="font-size: 0.72rem;">Bắt buộc đối với tất cả tài khoản thuộc nhóm Quản trị viên (HR Admin & Payroll Manager) thông qua Google Authenticator hoặc OTP.</small>
                                        <div class="form-check form-switch mb-0">
                                            <input class="form-check-input" type="checkbox" checked id="sec2fa">
                                            <label class="form-check-label small" for="sec2fa">Áp dụng 2FA cho toàn bộ Admin</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <div class="p-3 border rounded-3 bg-light">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <strong class="text-dark small">Giới hạn IP truy cập nội bộ</strong>
                                            <span class="badge bg-light text-muted border">Tùy chọn</span>
                                        </div>
                                        <small class="text-muted d-block mb-2" style="font-size: 0.72rem;">Chỉ cho phép xuất file bảng lương và xuất báo cáo tài chính khi truy cập từ dải mạng văn phòng trụ sở Landmark 81.</small>
                                        <div class="form-check form-switch mb-0">
                                            <input class="form-check-input" type="checkbox" checked id="secIp">
                                            <label class="form-check-label small" for="secIp">Bật giới hạn IP cho Module Lương</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sticky Footer Save Bar -->
                        <div class="settings-sticky-footer d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                            <span class="text-muted small">
                                <i class="bi bi-clock-history me-1"></i>
                                Cập nhật lần cuối: Hôm nay lúc 14:28 bởi <strong>Nguyễn Văn Admin</strong>
                            </span>
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/settings" class="btn btn-outline-secondary btn-sm">Hủy thay đổi</a>
                                <button type="submit" class="btn btn-primary btn-sm shadow-sm d-flex align-items-center gap-2">
                                    <i class="bi bi-floppy-fill"></i>
                                    <span>Lưu cấu hình</span>
                                </button>
                            </div>
                        </div>
                    </form>
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
