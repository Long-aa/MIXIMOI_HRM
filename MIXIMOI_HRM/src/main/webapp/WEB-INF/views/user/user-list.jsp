<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Tài khoản & Phân quyền RBAC v3.5 - MIXIMOI HRM" />
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
            <c:if test="${param.success eq 'created'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div>Đã khởi tạo tài khoản mới thành công và gửi thư kích hoạt 2FA tới email nhân sự!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Tài khoản & Phân quyền</h1>
                        <span class="badge bg-primary-subtle text-primary font-monospace fw-bold">
                            <i class="bi bi-shield-check me-1"></i>RBAC v3.5 • Level 4 Security
                        </span>
                        <span class="badge bg-success-subtle text-success border border-success-subtle">
                            <span class="vssid-status-dot"></span> 2FA Enforced
                        </span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Quản lý tập trung tài khoản người dùng, ma trận phân quyền theo vai trò (RBAC) và kiểm soát nhật ký truy cập hệ thống toàn diện.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" onclick="alert('Đang xuất danh sách tài khoản & ma trận phân quyền...')">
                        <i class="bi bi-file-earmark-arrow-down"></i>
                        <span>Xuất danh sách</span>
                    </button>
                    <button type="button" class="btn btn-primary d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#createUserModal">
                        <i class="bi bi-person-plus-fill"></i>
                        <span>+ Tạo tài khoản</span>
                    </button>
                </div>
            </div>

            <!-- 4 Metric KPI Cards -->
            <div class="row g-3 mb-4">
                <!-- KPI 1 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Tổng tài khoản</span>
                            <div class="kpi-icon-box blue">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-dark fw-bold" style="font-size: 1.85rem;">245</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="badge bg-primary-subtle text-primary fw-semibold">↗ +8 so với tháng trước</span>
                            <span class="text-muted small">100% Phủ sóng</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 2 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đang hoạt động</span>
                            <div class="kpi-icon-box green">
                                <i class="bi bi-check2-circle"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-success fw-bold" style="font-size: 1.85rem;">232</span>
                            <span class="badge bg-success-subtle text-success ms-2">94.7% active</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Phiên đăng nhập thực tế</span>
                            <span class="badge bg-light text-dark border">41 online</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 3 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Đã khóa</span>
                            <div class="kpi-icon-box coral">
                                <i class="bi bi-lock-fill"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-danger fw-bold" style="font-size: 1.85rem;">8</span>
                            <span class="badge bg-danger-subtle text-danger ms-2">Bảo mật kiểm soát</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Nghỉ việc / Tạm dừng</span>
                            <span class="text-muted small">3.2% tổng số</span>
                        </div>
                    </div>
                </div>

                <!-- KPI 4 -->
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card h-100 border-0 shadow-sm rounded-3 p-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Chờ kích hoạt</span>
                            <div class="kpi-icon-box purple">
                                <i class="bi bi-envelope-exclamation"></i>
                            </div>
                        </div>
                        <div class="d-flex align-items-baseline gap-1 mb-2">
                            <span class="kpi-value text-purple fw-bold" style="font-size: 1.85rem; color: #7c3aed;">5</span>
                            <span class="badge bg-warning-subtle text-warning-emphasis ms-2">Chưa xác thực 2FA</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="text-muted small">Nhân sự mới tuyển</span>
                            <a href="#" class="small text-primary text-decoration-none fw-semibold">Gửi lại email</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Segmented Tabs & Filters -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-header bg-white border-bottom pt-3 pb-0">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-2 mb-2">
                        <ul class="nav payment-batch-tabs">
                            <li class="nav-item"><a class="nav-link active" href="#"><i class="bi bi-people-fill me-1"></i>Tài khoản (245)</a></li>
                            <li class="nav-item"><a class="nav-link" href="#"><i class="bi bi-shield-shaded me-1"></i>Vai trò & Cấp độ (7)</a></li>
                            <li class="nav-item"><a class="nav-link" href="#"><i class="bi bi-grid-3x3 me-1"></i>Ma trận phân quyền (Matrix)</a></li>
                            <li class="nav-item"><a class="nav-link" href="#"><i class="bi bi-journal-text me-1"></i>Nhật ký truy cập & An ninh <span class="badge-dot-indicator bg-danger ms-1"></span></a></li>
                        </ul>
                        <span class="text-muted small font-monospace"><i class="bi bi-arrow-repeat me-1"></i>Đồng bộ chính sách: 14:30:12</span>
                    </div>
                </div>

                <div class="card-body p-3">
                    <form method="get" action="${pageContext.request.contextPath}/users" class="row g-2 align-items-center">
                        <div class="col-12 col-md-4">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" name="keyword" class="form-control border-start-0" placeholder="Tìm theo Tên, Email, Mã NV hoặc username..." value="${param.keyword}">
                            </div>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="role" class="form-select form-select-sm">
                                <option value="">Tất cả vai trò</option>
                                <option value="ADMIN">Super Admin</option>
                                <option value="HR">HR Manager</option>
                                <option value="PAYROLL">Payroll Manager</option>
                                <option value="EMPLOYEE">Employee</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="dept" class="form-select form-select-sm">
                                <option value="">Tất cả phòng ban</option>
                                <option value="BGD">Ban Giám Đốc</option>
                                <option value="IT">CNTT & R&D</option>
                                <option value="HR">Nhân sự & Tuyển dụng</option>
                                <option value="FIN">Kế toán & Tài chính</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <select name="status" class="form-select form-select-sm">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active">Đang hoạt động</option>
                                <option value="locked">Đã khóa</option>
                                <option value="pending">Chờ kích hoạt</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-sm btn-primary w-100"><i class="bi bi-funnel"></i> Lọc</button>
                            <a href="${pageContext.request.contextPath}/users" class="btn btn-sm btn-outline-secondary" title="Đặt lại"><i class="bi bi-arrow-counterclockwise"></i></a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- User Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap" style="font-size: 0.83rem;">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3" style="width: 35px;"><input class="form-check-input" type="checkbox"></th>
                                <th>Nhân viên & Mã</th>
                                <th>Tài khoản & Email</th>
                                <th>Vai trò (Role)</th>
                                <th>Phòng ban</th>
                                <th>Đăng nhập gần nhất</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- User 1: Nguyễn Văn Admin -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-primary text-white fw-bold" style="width: 34px; height: 34px; font-size: 0.8rem;">NA</div>
                                        <div>
                                            <div class="fw-bold text-dark">Nguyễn Văn Admin</div>
                                            <small class="text-muted font-monospace">NV-001 • Chính thức</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-primary font-monospace">@admin.executive</div>
                                    <small class="text-muted">admin@miximoi.vn</small>
                                </td>
                                <td>
                                    <span class="role-badge-superadmin">
                                        <i class="bi bi-shield-fill-check"></i> Super Admin
                                    </span>
                                </td>
                                <td>Ban Giám Đốc</td>
                                <td>
                                    <div class="fw-semibold text-dark">Vừa xong (14:32)</div>
                                    <small class="text-muted font-monospace">118.69.182.45 • Chrome</small>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                        <span class="vssid-status-dot"></span> Đang hoạt động
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2" title="Xem chi tiết"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2" title="Chỉnh sửa quyền"><i class="bi bi-sliders"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- User 2: Lê Hoàng Nam -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-purple-subtle text-purple fw-bold" style="width: 34px; height: 34px; font-size: 0.8rem; background: #f3e8ff; color: #7e22ce;">LN</div>
                                        <div>
                                            <div class="fw-bold text-dark">Lê Hoàng Nam</div>
                                            <small class="text-muted font-monospace">NV-014 • Kỹ sư trưởng</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark font-monospace">@nam.le</div>
                                    <small class="text-muted">nam.le@miximoi.vn</small>
                                </td>
                                <td>
                                    <span class="role-badge-admin">
                                        <i class="bi bi-shield-shaded"></i> Administrator
                                    </span>
                                </td>
                                <td>CNTT & R&D</td>
                                <td>
                                    <div>Hôm nay 13:48</div>
                                    <small class="text-muted font-monospace">14.161.35.88 • Firefox</small>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                        <span class="vssid-status-dot"></span> Đang hoạt động
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-sliders"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- User 3: Trần Thị Mai -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-info-subtle text-info fw-bold" style="width: 34px; height: 34px; font-size: 0.8rem;">TM</div>
                                        <div>
                                            <div class="fw-bold text-dark">Trần Thị Mai</div>
                                            <small class="text-muted font-monospace">NV-028 • Trưởng phòng</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark font-monospace">@mai.tran</div>
                                    <small class="text-muted">mai.tran@miximoi.vn</small>
                                </td>
                                <td>
                                    <span class="role-badge-manager">
                                        <i class="bi bi-people-fill"></i> HR Manager
                                    </span>
                                </td>
                                <td>Nhân sự & Tuyển dụng</td>
                                <td>
                                    <div>Hôm nay 14:15</div>
                                    <small class="text-muted font-monospace">115.78.22.10 • Edge</small>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                        <span class="vssid-status-dot"></span> Đang hoạt động
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-sliders"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- User 4: Đặng Hoàng Quân -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-warning-subtle text-warning fw-bold" style="width: 34px; height: 34px; font-size: 0.8rem;">HQ</div>
                                        <div>
                                            <div class="fw-bold text-dark">Đặng Hoàng Quân</div>
                                            <small class="text-muted font-monospace">NV-035 • Kế toán trưởng</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark font-monospace">@quan.dang</div>
                                    <small class="text-muted">quan.dang@miximoi.vn</small>
                                </td>
                                <td>
                                    <span class="role-badge-payroll">
                                        <i class="bi bi-wallet2"></i> Payroll Manager
                                    </span>
                                </td>
                                <td>Kế toán & Tài chính</td>
                                <td>
                                    <div>12/05 09:15</div>
                                    <small class="text-muted font-monospace">125.235.4.11 • Chrome</small>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                        <span class="vssid-status-dot"></span> Đang hoạt động
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-sliders"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- User 5: Lê Văn Cường (Đã khóa) -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-secondary-subtle text-secondary fw-bold" style="width: 34px; height: 34px; font-size: 0.8rem;">LC</div>
                                        <div>
                                            <div class="fw-bold text-dark">Lê Văn Cường</div>
                                            <small class="text-muted font-monospace">NV-108 • Kế toán viên</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark font-monospace">@cuong.le</div>
                                    <small class="text-muted">cuong.le@miximoi.vn</small>
                                </td>
                                <td>
                                    <span class="role-badge-employee">
                                        <i class="bi bi-person"></i> Employee
                                    </span>
                                </td>
                                <td>Kế toán - Tài chính</td>
                                <td>
                                    <div class="text-muted">10 ngày trước</div>
                                    <small class="text-muted">Tạm dừng bảo mật</small>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-secondary-subtle text-secondary border d-inline-flex align-items-center gap-1">
                                        <i class="bi bi-lock-fill"></i> Đã khóa
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2" title="Mở khóa tài khoản"><i class="bi bi-unlock"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-sliders"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- User 6: Vũ Quốc Bình (Chờ kích hoạt) -->
                            <tr>
                                <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle bg-primary-subtle text-primary fw-bold" style="width: 34px; height: 34px; font-size: 0.8rem;">QB</div>
                                        <div>
                                            <div class="fw-bold text-dark">Vũ Quốc Bình</div>
                                            <small class="text-muted font-monospace">NV-241 • Onboarding</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark font-monospace">@binh.vu</div>
                                    <small class="text-muted">binh.vu@miximoi.vn</small>
                                </td>
                                <td>
                                    <span class="role-badge-manager" style="background: #e0f2fe; color: #0284c7; border-color: #bae6fd;">
                                        <i class="bi bi-person-badge"></i> HR Staff
                                    </span>
                                </td>
                                <td>Nhân sự & Tuyển dụng</td>
                                <td>
                                    <div class="text-primary fw-semibold">Chưa từng đăng nhập</div>
                                    <small class="text-muted">Email mời: 08:30 hôm nay</small>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-purple-subtle text-purple border border-purple-subtle d-inline-flex align-items-center gap-1" style="background: #f3e8ff; color: #7e22ce;">
                                        <i class="bi bi-envelope-paper"></i> Chờ kích hoạt
                                    </span>
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-secondary py-1 px-2" title="Gửi lại thư mời"><i class="bi bi-send"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-sliders"></i></button>
                                        <button class="btn btn-outline-secondary py-1 px-2"><i class="bi bi-three-dots-vertical"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white border-top py-3 d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2 small text-muted">
                        <span>Hiển thị <strong>1 - 6</strong> trong tổng số <strong>245</strong> tài khoản</span>
                        <span>•</span>
                        <span>Dòng mỗi trang:</span>
                        <select class="form-select form-select-sm d-inline-block w-auto">
                            <option selected>20</option>
                            <option>50</option>
                            <option>100</option>
                        </select>
                    </div>

                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled"><a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item disabled"><a class="page-link" href="#">...</a></li>
                            <li class="page-item"><a class="page-link" href="#">25</a></li>
                            <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<!-- Modal Tạo tài khoản mới -->
<div class="modal fade" id="createUserModal" tabindex="-1" aria-labelledby="createUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="createUserModalLabel">Khởi tạo tài khoản hệ thống</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/users">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Gán cho Nhân viên</label>
                        <select class="form-select" name="employeeId" required>
                            <option value="">-- Chọn nhân sự đã tiếp nhận --</option>
                            <option value="1">Vũ Đức Minh (NV-8841) - CNTT & R&D</option>
                            <option value="2">Trần Thị Bình (NV-6419) - Kinh doanh</option>
                            <option value="3">Vũ Quốc Bình (NV-241) - Nhân sự</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên đăng nhập (Username)</label>
                        <div class="input-group">
                            <span class="input-group-text">@</span>
                            <input type="text" class="form-control" name="username" placeholder="VD: minh.vu" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Email nhận thông báo & 2FA</label>
                        <input type="email" class="form-control" name="email" placeholder="email@miximoi.vn" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Vai trò phân quyền (RBAC Role)</label>
                        <select class="form-select" name="role" required>
                            <option value="EMPLOYEE">Employee (Quyền nhân viên cơ bản)</option>
                            <option value="HR">HR Manager (Quản lý Nhân sự & Tuyển dụng)</option>
                            <option value="PAYROLL">Payroll Manager (Quản lý Lương & Phúc lợi)</option>
                            <option value="ADMIN">Administrator (Quản trị viên hệ thống)</option>
                        </select>
                    </div>
                    <div class="form-check form-switch mb-0">
                        <input class="form-check-input" type="checkbox" checked id="require2faNew">
                        <label class="form-check-label small" for="require2faNew">Bắt buộc xác thực 2FA khi đăng nhập lần đầu</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Khởi tạo & Gửi thư kích hoạt</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
