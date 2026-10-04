<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Topbar Header -->
<header class="app-topbar">
    <div class="d-flex align-items-center gap-3">
        <!-- Mobile Sidebar Toggle -->
        <button class="topbar-btn d-lg-none" data-toggle="sidebar" aria-label="Mở menu">
            <i class="bi bi-list fs-5"></i>
        </button>

        <!-- Topbar Breadcrumb -->
        <nav class="topbar-breadcrumb d-none d-md-flex align-items-center" aria-label="breadcrumb">
            <span class="breadcrumb-brand">
                ${not empty applicationScope.systemSettings['company_short_name'] ? applicationScope.systemSettings['company_short_name'] : 'MIXIMOI'}
            </span>
            <i class="bi bi-chevron-right breadcrumb-separator"></i>
            <c:choose>
                <c:when test="${activeMenu eq 'employees'}">
                    <span class="breadcrumb-parent">Quản lý tổ chức</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Nhân viên</span>
                </c:when>
                <c:when test="${activeMenu eq 'departments'}">
                    <span class="breadcrumb-parent">Quản lý tổ chức</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Phòng ban</span>
                </c:when>
                <c:when test="${activeMenu eq 'positions'}">
                    <span class="breadcrumb-parent">Quản lý tổ chức</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Chức vụ</span>
                </c:when>
                <c:when test="${activeMenu eq 'contracts'}">
                    <span class="breadcrumb-parent">Quản lý tổ chức</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Hợp đồng</span>
                </c:when>
                <c:when test="${activeMenu eq 'attendance'}">
                    <span class="breadcrumb-parent">Quản lý chấm công</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Chấm công</span>
                </c:when>
                <c:when test="${activeMenu eq 'timesheet'}">
                    <span class="breadcrumb-parent">Quản lý chấm công</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Bảng công</span>
                </c:when>
                <c:when test="${activeMenu eq 'overtime'}">
                    <span class="breadcrumb-parent">Quản lý chấm công</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Tăng ca</span>
                </c:when>
                <c:when test="${activeMenu eq 'leave'}">
                    <span class="breadcrumb-parent">Quản lý chấm công</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Nghỉ phép</span>
                </c:when>
                <c:when test="${activeMenu eq 'salary-config'}">
                    <span class="breadcrumb-parent">Quản lý lương</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Thiết lập lương</span>
                </c:when>
                <c:when test="${activeMenu eq 'payroll'}">
                    <span class="breadcrumb-parent">Quản lý lương</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Bảng lương</span>
                </c:when>
                <c:when test="${activeMenu eq 'allowances'}">
                    <span class="breadcrumb-parent">Quản lý lương</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Phụ cấp</span>
                </c:when>
                <c:when test="${activeMenu eq 'bonuses'}">
                    <span class="breadcrumb-parent">Quản lý lương</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Thưởng</span>
                </c:when>
                <c:when test="${activeMenu eq 'deductions'}">
                    <span class="breadcrumb-parent">Quản lý lương</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Khấu trừ</span>
                </c:when>
                <c:when test="${activeMenu eq 'payment'}">
                    <span class="breadcrumb-parent">Quản lý lương</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Thanh toán</span>
                </c:when>
                <c:when test="${activeMenu eq 'payslip'}">
                    <span class="breadcrumb-parent">Quản lý lương</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Phiếu lương</span>
                </c:when>
                <c:when test="${activeMenu eq 'disciplines'}">
                    <span class="breadcrumb-parent">Quản lý nhân sự</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Kỷ luật &amp; Vi phạm</span>
                </c:when>
                <c:when test="${activeMenu eq 'performance'}">
                    <span class="breadcrumb-parent">Quản lý hiệu suất</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">KPI</span>
                </c:when>
                <c:when test="${activeMenu eq 'evaluations'}">
                    <span class="breadcrumb-parent">Quản lý hiệu suất</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Đánh giá hiệu suất</span>
                </c:when>
                <c:when test="${activeMenu eq 'users'}">
                    <span class="breadcrumb-parent">Hệ thống</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Tài khoản & Phân quyền</span>
                </c:when>
                <c:when test="${activeMenu eq 'settings'}">
                    <span class="breadcrumb-parent">Hệ thống</span>
                    <span class="breadcrumb-slash">/</span>
                    <c:choose>
                        <c:when test="${activeSubMenu eq 'profile'}">
                            <span class="breadcrumb-current">Cài đặt hệ thống</span>
                        </c:when>
                        <c:otherwise>
                            <span class="breadcrumb-current">Thiết lập hệ thống</span>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${activeMenu eq 'recruitment'}">
                    <span class="breadcrumb-parent">Quản lý tuyển dụng</span>
                    <span class="breadcrumb-slash">/</span>
                    <c:choose>
                        <c:when test="${activeSubMenu eq 'jobs'}">
                            <span class="breadcrumb-current">Vị trí tuyển dụng</span>
                        </c:when>
                        <c:when test="${activeSubMenu eq 'candidates'}">
                            <span class="breadcrumb-current">Ứng viên</span>
                        </c:when>
                        <c:otherwise>
                            <span class="breadcrumb-current">Tuyển dụng</span>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <span class="breadcrumb-parent">Trang chủ</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Dashboard</span>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>

    <!-- Center Search Box -->
    <div class="topbar-search-box mx-auto d-none d-lg-block" role="button" data-bs-toggle="modal" data-bs-target="#quickSearchModal" style="cursor: pointer;">
        <i class="bi bi-search topbar-search-icon"></i>
        <input type="text" class="topbar-search-input" placeholder="Tìm nhanh tính năng, nhân sự (Ctrl + K)..." aria-label="Search" readonly data-bs-toggle="modal" data-bs-target="#quickSearchModal" style="cursor: pointer;">
        <span class="topbar-search-shortcut">⌘ K</span>
    </div>

    <!-- Right Side Actions & User Profile -->
    <div class="topbar-actions">
<%
    if (request.getAttribute("topbarNotifications") == null) {
        try {
            com.miximoi.hrm.dao.NotificationDAO nDao = new com.miximoi.hrm.dao.NotificationDAO();
            com.miximoi.hrm.model.User cu = (com.miximoi.hrm.model.User) session.getAttribute("currentUser");
            Integer uid = cu != null ? cu.getId() : null;
            request.setAttribute("topbarNotifications", nDao.findRecent(uid, 6));
            request.setAttribute("topbarUnreadCount", nDao.countUnread(uid));
            request.setAttribute("latestActiveAlert", nDao.getLatestActiveAlert());
        } catch (Exception ignored) {}
    }
%>
        <!-- Nút phát cảnh báo toàn công ty (Chỉ Admin & HR) -->
        <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr or sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'HR'}">
            <button class="btn btn-sm btn-outline-danger d-none d-md-flex align-items-center gap-1 shadow-xs rounded-pill px-3 py-1 fw-bold"
                    type="button" data-bs-toggle="modal" data-bs-target="#broadcastAlertModal"
                    title="Phát cảnh báo khẩn cấp hoặc thông báo quan trọng tới toàn thể nhân viên">
                <i class="bi bi-megaphone-fill text-danger"></i>
                <span class="d-none d-xl-inline">Phát cảnh báo</span>
            </button>
        </c:if>

        <!-- Notification Bell -->
        <div class="dropdown">
            <button class="topbar-btn position-relative" type="button" data-bs-toggle="dropdown" aria-expanded="false" title="Thông báo hệ thống & Tuyển dụng">
                <i class="bi bi-bell"></i>
                <c:if test="${not empty topbarUnreadCount and topbarUnreadCount > 0}">
                    <span class="topbar-badge-dot"></span>
                </c:if>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 p-2" style="width: 360px; font-size: 0.85rem;">
                <li class="px-2 py-1 fw-bold text-dark border-bottom pb-2 mb-2 d-flex justify-content-between align-items-center">
                    <span>Thông báo hệ thống</span>
                    <div class="d-flex align-items-center gap-2">
                        <c:choose>
                            <c:when test="${not empty topbarUnreadCount and topbarUnreadCount > 0}">
                                <span class="badge bg-danger" id="topbarUnreadBadge">${topbarUnreadCount} mới</span>
                                <a href="javascript:void(0)" onclick="markAllNotificationsAsRead(event)" class="text-primary small text-decoration-none" style="font-size: 0.72rem; cursor: pointer;">Đã đọc tất cả</a>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-primary-subtle text-primary" id="topbarUnreadBadge">Đã cập nhật</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </li>

                <c:choose>
                    <c:when test="${not empty topbarNotifications}">
                        <c:forEach items="${topbarNotifications}" var="n">
                            <li>
                                <a class="dropdown-item py-2 px-2 rounded d-flex gap-2 align-items-start border-bottom-subtle ${n.read ? 'opacity-75' : 'bg-light bg-opacity-50'}" 
                                   href="${pageContext.request.contextPath}/notifications?action=mark_read&id=${n.id}&redirect=${not empty n.linkUrl ? n.linkUrl : '/dashboard'}">
                                    <c:choose>
                                        <c:when test="${n.recruitment}">
                                            <i class="bi bi-briefcase-fill text-info fs-6 mt-1 flex-shrink-0"></i>
                                        </c:when>
                                        <c:when test="${n.type eq 'SUCCESS'}">
                                            <i class="bi bi-check-circle-fill text-success fs-6 mt-1 flex-shrink-0"></i>
                                        </c:when>
                                        <c:when test="${n.type eq 'WARNING' or n.type eq 'DANGER'}">
                                            <i class="bi bi-exclamation-triangle-fill text-warning fs-6 mt-1 flex-shrink-0"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-bell-fill text-primary fs-6 mt-1 flex-shrink-0"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="flex-grow-1" style="min-width: 0;">
                                        <div class="fw-semibold text-truncate text-dark d-flex justify-content-between align-items-center" style="font-size: 0.82rem;" title="${n.title}">
                                            <span>${n.title}</span>
                                            <c:if test="${not n.read}">
                                                <span class="badge bg-danger rounded-circle p-1" style="width:6px;height:6px;"></span>
                                            </c:if>
                                        </div>
                                        <p class="text-muted mb-0 small text-truncate" style="font-size: 0.74rem;">${n.message}</p>
                                        <small class="text-primary fw-medium" style="font-size: 0.7rem;">${n.timeAgo}</small>
                                    </div>
                                </a>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li class="py-3 text-center text-muted small">
                            Không có thông báo mới
                        </li>
                    </c:otherwise>
                </c:choose>

                <li class="border-top pt-2 mt-2 text-center d-flex justify-content-between px-2">
                    <a href="${pageContext.request.contextPath}/timesheet" class="text-primary text-decoration-none fw-semibold" style="font-size: 0.78rem;">
                        <i class="bi bi-calendar3 me-1"></i>Bảng chấm công
                    </a>
                    <a href="${pageContext.request.contextPath}/payroll" class="text-muted text-decoration-none" style="font-size: 0.78rem;">
                        <i class="bi bi-cash-stack me-1"></i>Phiếu lương
                    </a>
                </li>
            </ul>
        </div>

        <!-- User Profile Dropdown -->
        <div class="dropdown">
            <div class="topbar-user" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="position-relative">
                    <div class="topbar-avatar-placeholder">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.fullName}">
                                ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
                            </c:when>
                            <c:otherwise>A</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="user-online-indicator"></span>
                </div>
                <div class="topbar-user-info d-none d-sm-flex">
                    <span class="topbar-user-name">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.fullName}">
                                ${sessionScope.currentUser.fullName}
                            </c:when>
                            <c:when test="${not empty sessionScope.currentUser.username}">
                                ${sessionScope.currentUser.username}
                            </c:when>
                            <c:otherwise>Nguyễn Văn Admin</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="topbar-user-role">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.role}">
                                ${sessionScope.currentUser.role}
                            </c:when>
                            <c:otherwise>Administrator</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <i class="bi bi-chevron-down text-muted" style="font-size: 0.75rem;"></i>
            </div>
            
            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 p-2" style="min-width: 210px; font-size: 0.85rem;">
                <li class="px-3 py-2 border-bottom mb-1">
                    <div class="fw-bold text-dark">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.fullName}">
                                ${sessionScope.currentUser.fullName}
                            </c:when>
                            <c:otherwise>Nguyễn Văn Admin</c:otherwise>
                        </c:choose>
                    </div>
                    <small class="text-muted">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.email}">
                                ${sessionScope.currentUser.email}
                            </c:when>
                            <c:otherwise>admin@miximoi.vn</c:otherwise>
                        </c:choose>
                    </small>
                </li>
                <li>
                    <a class="dropdown-item rounded py-2 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/profile">
                        <i class="bi bi-person text-muted"></i> Thông tin cá nhân
                    </a>
                </li>
                <li>
                    <a class="dropdown-item rounded py-2 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/change-password">
                        <i class="bi bi-key text-muted"></i> Đổi mật khẩu
                    </a>
                </li>
                <li>
                    <a class="dropdown-item rounded py-2 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/settings">
                        <i class="bi bi-gear text-muted"></i> Cài đặt hệ thống
                    </a>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item rounded py-2 d-flex align-items-center gap-2 text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>

<!-- Quick Search & Command Palette Modal (Ctrl + K) -->
<div class="modal fade" id="quickSearchModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" style="max-width: 620px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px; overflow: hidden; background: rgba(255,255,255,0.98); backdrop-filter: blur(16px);">
            <div class="modal-header border-bottom p-3">
                <div class="d-flex align-items-center gap-2 w-100">
                    <i class="bi bi-search text-primary fs-5"></i>
                    <input type="text" id="paletteSearchInput" class="form-control border-0 shadow-none fs-6" 
                           placeholder="Nhập từ khóa tìm kiếm nhanh hoặc chọn phân hệ bên dưới..." 
                           autocomplete="off" style="outline: none;" onkeyup="filterPalette(this.value)">
                    <span class="badge bg-light text-muted border px-2 py-1" style="font-size: 0.72rem;">ESC để đóng</span>
                </div>
            </div>
            <div class="modal-body p-3" style="max-height: 420px; overflow-y: auto;">
                <div class="text-uppercase text-muted fw-bold px-2 mb-2" style="font-size: 0.7rem; letter-spacing: 0.5px;">Phân hệ Nghiệp vụ Chính</div>
                <div class="list-group list-group-flush gap-1" id="paletteList">
                    <a href="${pageContext.request.contextPath}/dashboard" class="list-group-item list-group-item-action border-0 rounded-3 d-flex align-items-center justify-content-between p-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 bg-primary bg-opacity-10 text-primary p-2 d-flex align-items-center justify-content-center" style="width:36px;height:36px;"><i class="bi bi-speedometer2"></i></div>
                            <div>
                                <div class="fw-semibold text-dark" style="font-size: 0.88rem;">Dashboard Điều hành</div>
                                <div class="text-muted" style="font-size: 0.76rem;">Thống kê tổng quan KPI, nhân sự và quỹ lương</div>
                            </div>
                        </div>
                        <i class="bi bi-arrow-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/attendance" class="list-group-item list-group-item-action border-0 rounded-3 d-flex align-items-center justify-content-between p-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 bg-success bg-opacity-10 text-success p-2 d-flex align-items-center justify-content-center" style="width:36px;height:36px;"><i class="bi bi-fingerprint"></i></div>
                            <div>
                                <div class="fw-semibold text-dark" style="font-size: 0.88rem;">Chấm công &amp; Sinh trắc học (FaceID, Vân tay)</div>
                                <div class="text-muted" style="font-size: 0.76rem;">Điểm danh vào/ra ca, GPS WFH và lịch sử công</div>
                            </div>
                        </div>
                        <i class="bi bi-arrow-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/timesheet" class="list-group-item list-group-item-action border-0 rounded-3 d-flex align-items-center justify-content-between p-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 bg-warning bg-opacity-10 text-warning p-2 d-flex align-items-center justify-content-center" style="width:36px;height:36px;"><i class="bi bi-calendar3"></i></div>
                            <div>
                                <div class="fw-semibold text-dark" style="font-size: 0.88rem;">Bảng công Tháng &amp; Khóa chốt kỳ công</div>
                                <div class="text-muted" style="font-size: 0.76rem;">Đối soát tổng công, OT và khóa chốt chuyển sang tính lương</div>
                            </div>
                        </div>
                        <i class="bi bi-arrow-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/leave" class="list-group-item list-group-item-action border-0 rounded-3 d-flex align-items-center justify-content-between p-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 bg-info bg-opacity-10 text-info p-2 d-flex align-items-center justify-content-center" style="width:36px;height:36px;"><i class="bi bi-calendar-heart"></i></div>
                            <div>
                                <div class="fw-semibold text-dark" style="font-size: 0.88rem;">Quản lý Nghỉ phép (BLLĐ 2019)</div>
                                <div class="text-muted" style="font-size: 0.76rem;">Tạo đơn, duyệt 2 cấp, kiểm soát giới hạn 30% và in phiếu</div>
                            </div>
                        </div>
                        <i class="bi bi-arrow-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/payroll" class="list-group-item list-group-item-action border-0 rounded-3 d-flex align-items-center justify-content-between p-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 bg-danger bg-opacity-10 text-danger p-2 d-flex align-items-center justify-content-center" style="width:36px;height:36px;"><i class="bi bi-cash-stack"></i></div>
                            <div>
                                <div class="fw-semibold text-dark" style="font-size: 0.88rem;">Bảng lương &amp; Quyết toán (C&amp;B)</div>
                                <div class="text-muted" style="font-size: 0.76rem;">Động cơ tính lương 1-click, thuế TNCN và xuất lệnh chi</div>
                            </div>
                        </div>
                        <i class="bi bi-arrow-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/employees" class="list-group-item list-group-item-action border-0 rounded-3 d-flex align-items-center justify-content-between p-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 bg-primary bg-opacity-10 text-primary p-2 d-flex align-items-center justify-content-center" style="width:36px;height:36px;"><i class="bi bi-people"></i></div>
                            <div>
                                <div class="fw-semibold text-dark" style="font-size: 0.88rem;">Hồ sơ Nhân sự 360°</div>
                                <div class="text-muted" style="font-size: 0.76rem;">Quản lý lý lịch, CCCD, chức vụ và vòng đời nhân viên</div>
                            </div>
                        </div>
                        <i class="bi bi-arrow-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/contracts" class="list-group-item list-group-item-action border-0 rounded-3 d-flex align-items-center justify-content-between p-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 bg-secondary bg-opacity-10 text-secondary p-2 d-flex align-items-center justify-content-center" style="width:36px;height:36px;"><i class="bi bi-file-earmark-text"></i></div>
                            <div>
                                <div class="fw-semibold text-dark" style="font-size: 0.88rem;">Hợp đồng Lao động (HĐLĐ)</div>
                                <div class="text-muted" style="font-size: 0.76rem;">Theo dõi thời hạn HĐ, cảnh báo hết hạn và in hợp đồng</div>
                            </div>
                        </div>
                        <i class="bi bi-arrow-right text-muted"></i>
                    </a>
                </div>
            </div>
            <div class="modal-footer bg-light p-2 px-3 border-0 d-flex justify-content-between align-items-center">
                <span class="text-muted" style="font-size: 0.75rem;"><i class="bi bi-keyboard me-1"></i>Dùng phím <kbd class="bg-white text-dark border">Ctrl</kbd> + <kbd class="bg-white text-dark border">K</kbd> để mở nhanh bất kỳ lúc nào</span>
                <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
function filterPalette(kw) {
    const q = (kw || '').toLowerCase().trim();
    const items = document.querySelectorAll('#paletteList .list-group-item');
    items.forEach(el => {
        const text = el.innerText.toLowerCase();
        el.style.display = (!q || text.includes(q)) ? 'flex' : 'none';
    });
}
document.getElementById('quickSearchModal')?.addEventListener('shown.bs.modal', function () {
    const inp = document.getElementById('paletteSearchInput');
    if (inp) {
        inp.value = '';
        inp.focus();
        filterPalette('');
    }
});
</script>

<!-- ========================================================================= -->
<!-- 1. MODAL PHÁT CẢNH BÁO CHO ADMIN & HR                                      -->
<!-- ========================================================================= -->
<div class="modal fade" id="broadcastAlertModal" tabindex="-1" aria-labelledby="broadcastAlertModalLabel" aria-hidden="true" style="z-index: 1060;">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 580px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 14px; overflow: hidden; background: #ffffff;">
            <form method="POST" action="${pageContext.request.contextPath}/notifications">
                <input type="hidden" name="action" value="broadcast">
                <div class="modal-header border-0" style="background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); color: #fff; padding: 20px 24px;">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-megaphone-fill text-warning fs-5"></i>
                        <h5 class="modal-title fw-bold text-white mb-0" id="broadcastAlertModalLabel">Phát Cảnh Báo / Thông Báo Toàn Công Ty</h5>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4" style="background: #ffffff; color: #1e293b;">
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-secondary">Mức độ thông báo <span class="text-danger">*</span></label>
                        <select name="type" class="form-select form-select-sm" required style="background: #ffffff; color: #1e293b; border: 1px solid #cbd5e1;">
                            <option value="WARNING" selected>⚠️ WARNING — Cảnh báo vi phạm / Nhắc hạn chốt công</option>
                            <option value="DANGER">🚨 DANGER — Cảnh báo khẩn cấp từ Ban Giám Đốc</option>
                            <option value="INFO">ℹ️ INFO — Thông báo chính sách / Phúc lợi mới</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-secondary">Tiêu đề cảnh báo (Đập vào mắt nhân viên) <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" placeholder="VD: Khẩn cấp: Hạn chốt giải trình công tháng trước 17:00 hôm nay" required maxlength="120" style="background: #ffffff; color: #1e293b; border: 1px solid #cbd5e1;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-secondary">Nội dung chi tiết thông báo <span class="text-danger">*</span></label>
                        <textarea name="message" class="form-control" rows="4" placeholder="Nhập nội dung thông báo hoặc chỉ thị cần nhân sự thực hiện ngay..." required style="background: #ffffff; color: #1e293b; border: 1px solid #cbd5e1;"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-secondary">Liên kết điều hướng (Khi bấm Xem chi tiết)</label>
                        <input type="text" name="linkUrl" class="form-control form-control-sm" placeholder="VD: /timesheet hoặc /payroll hoặc /disciplines" value="/timesheet" style="background: #ffffff; color: #1e293b; border: 1px solid #cbd5e1;">
                    </div>
                    <div class="form-check form-switch p-3 rounded bg-light border">
                        <input class="form-check-input ms-0 me-2" type="checkbox" name="sendEmail" id="chkSendEmail" checked>
                        <label class="form-check-label fw-semibold text-dark small" for="chkSendEmail">
                            <i class="bi bi-envelope-at-fill text-primary me-1"></i>Đồng thời gửi email thông báo tự động (SMTP) tới toàn thể nhân viên
                        </label>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 py-3 px-4">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-sm btn-danger px-4 fw-bold">
                        <i class="bi bi-send-fill me-1"></i>Phát cảnh báo ngay lập tức
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- 2. MODAL CẢNH BÁO TẬP TRUNG GIỮA MÀN HÌNH (ĐẬP VÀO MẮT NGAY KHI ĐĂNG NHẬP) -->
<!-- ========================================================================= -->
<div class="modal fade" id="centerScreenAlertModal" tabindex="-1" aria-labelledby="centerScreenAlertModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 520px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px; overflow: hidden; background: #ffffff;">
            <div class="modal-header border-0 pb-0" style="background: linear-gradient(135deg, #ef4444 0%, #b91c1c 100%); color: #fff; padding: 24px 24px 16px 24px;">
                <div class="d-flex align-items-center gap-3">
                    <div class="d-flex align-items-center justify-content-center bg-white text-danger rounded-circle shadow-sm flex-shrink-0" style="width: 48px; height: 48px; font-size: 1.5rem;">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                    </div>
                    <div>
                        <span class="badge bg-white text-danger font-monospace text-uppercase mb-1" style="font-size: 0.72rem; letter-spacing: 0.5px;">Cảnh báo quan trọng</span>
                        <h5 class="modal-title fw-bold mb-0 text-white" id="centerScreenAlertModalLabel">
                            <c:out value="${not empty applicationScope.activeBroadcastAlert ? applicationScope.activeBroadcastAlert.title : (not empty latestActiveAlert ? latestActiveAlert.title : 'THÔNG BÁO TỪ BAN GIÁM ĐỐC & NHÂN SỰ')}"/>
                        </h5>
                    </div>
                </div>
            </div>
            <div class="modal-body p-4" style="background: #ffffff; color: #1e293b;">
                <div class="p-3 rounded-3 mb-3" style="background: #fff1f2; border: 1px solid #fecdd3; font-size: 0.95rem; line-height: 1.6;">
                    <p class="mb-0 fw-medium text-dark" id="centerScreenAlertMessage">
                        <c:out value="${not empty applicationScope.activeBroadcastAlert ? applicationScope.activeBroadcastAlert.message : (not empty latestActiveAlert ? latestActiveAlert.message : 'Toàn thể nhân sự vui lòng kiểm tra và hoàn thành giải trình chấm công tháng, rà soát phiếu lương cá nhân và tuân thủ nội quy lao động công ty.')}"/>
                    </p>
                </div>
                <div class="d-flex align-items-center justify-content-between text-muted small">
                    <span><i class="bi bi-shield-check text-success me-1"></i>Phát từ Ban Lãnh đạo &amp; HR</span>
                    <span><i class="bi bi-clock me-1"></i>Hiệu lực toàn hệ thống</span>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0 px-4 pb-4 gap-2 d-flex justify-content-end bg-white">
                <a href="${pageContext.request.contextPath}${not empty applicationScope.activeBroadcastAlert.linkUrl ? applicationScope.activeBroadcastAlert.linkUrl : (not empty latestActiveAlert.linkUrl ? latestActiveAlert.linkUrl : '/timesheet')}" class="btn btn-outline-secondary px-3" style="border-radius: 8px;">
                    <i class="bi bi-box-arrow-up-right me-1"></i>Xem chi tiết
                </a>
                <button type="button" class="btn btn-danger px-4 fw-bold shadow-sm" style="border-radius: 8px;" id="btnAcknowledgeAlert">
                    <i class="bi bi-check2-circle me-1"></i>Tôi đã hiểu và xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    // 1. Chuyển các modal ra ngoài direct con của body để thoát khỏi stacking context của .app-main
    ['broadcastAlertModal', 'centerScreenAlertModal', 'quickSearchModal'].forEach(id => {
        const el = document.getElementById(id);
        if (el && el.parentNode !== document.body) {
            document.body.appendChild(el);
        }
    });

    // 2. Tự động hiển thị Toast cảnh báo / nhắc nhở chưa đọc cho nhân viên khi mở bất kỳ trang nào
    <c:if test="${not empty topbarNotifications}">
        <c:forEach items="${topbarNotifications}" var="notif">
            <c:if test="${not notif.read}">
                (function() {
                    const shownKey = 'notif_toast_shown_${notif.id}';
                    if (!sessionStorage.getItem(shownKey)) {
                        sessionStorage.setItem(shownKey, '1');
                        setTimeout(() => {
                            if (window.MixiToast) {
                                <c:choose>
                                    <c:when test="${notif.type eq 'WARNING' or notif.type eq 'DANGER'}">
                                        MixiToast.warning('<c:out value="${notif.title}" escapeXml="true"/>', '<c:out value="${notif.message}" escapeXml="true"/>');
                                    </c:when>
                                    <c:when test="${notif.type eq 'SUCCESS'}">
                                        MixiToast.success('<c:out value="${notif.title}" escapeXml="true"/>', '<c:out value="${notif.message}" escapeXml="true"/>');
                                    </c:when>
                                    <c:otherwise>
                                        MixiToast.info('<c:out value="${notif.title}" escapeXml="true"/>', '<c:out value="${notif.message}" escapeXml="true"/>');
                                    </c:otherwise>
                                </c:choose>
                            }
                        }, 500);
                    }
                })();
            </c:if>
        </c:forEach>
    </c:if>

    // 3. Modal Cảnh báo trung tâm (Center Screen Alert)
    const hasAlert = <%= (application.getAttribute("activeBroadcastAlert") != null || request.getAttribute("latestActiveAlert") != null) %>;
    const alertId = '<%= (application.getAttribute("activeBroadcastAlert") != null ? ((com.miximoi.hrm.model.Notification)application.getAttribute("activeBroadcastAlert")).getId() : (request.getAttribute("latestActiveAlert") != null ? ((com.miximoi.hrm.model.Notification)request.getAttribute("latestActiveAlert")).getId() : "default_alert")) %>';
    const isDismissed = sessionStorage.getItem("miximoi_alert_dismissed_" + alertId);

    if (hasAlert && !isDismissed) {
        const modalEl = document.getElementById("centerScreenAlertModal");
        if (modalEl && typeof bootstrap !== "undefined") {
            const centerModal = new bootstrap.Modal(modalEl, { backdrop: "static", keyboard: false });
            setTimeout(() => centerModal.show(), 600);

            document.getElementById("btnAcknowledgeAlert")?.addEventListener("click", function () {
                sessionStorage.setItem("miximoi_alert_dismissed_" + alertId, "true");
                centerModal.hide();
                if (typeof HRM !== "undefined" && HRM.toast) {
                    HRM.toast("Đã ghi nhận", "Bạn đã xác nhận thông báo cảnh báo từ công ty.", "success");
                }
            });
        }
    }
});

// Hàm đánh dấu đã đọc tất cả thông báo
function markAllNotificationsAsRead(e) {
    if (e) e.stopPropagation();
    fetch('${pageContext.request.contextPath}/notifications', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=mark_all_read'
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            const badge = document.getElementById('topbarUnreadBadge');
            if (badge) {
                badge.className = 'badge bg-primary-subtle text-primary';
                badge.innerText = 'Đã cập nhật';
            }
            const dot = document.querySelector('.topbar-badge-dot');
            if (dot) dot.style.display = 'none';
            if (window.MixiToast) {
                MixiToast.success('Đã đọc', 'Đã đánh dấu tất cả thông báo là đã đọc.');
            }
        }
    })
    .catch(() => {});
}

// Polling định kỳ mỗi 20s kiểm tra thông báo mới gửi tới nhân sự và bật Toast tức thời
setInterval(function() {
    fetch('${pageContext.request.contextPath}/notifications?action=unread_toast')
    .then(r => r.json())
    .then(data => {
        if (data && data.hasToast) {
            const toastKey = 'notif_toast_shown_' + data.id;
            if (!sessionStorage.getItem(toastKey)) {
                sessionStorage.setItem(toastKey, '1');
                if (window.MixiToast) {
                    if (data.type === 'WARNING' || data.type === 'DANGER') {
                        MixiToast.warning(data.title, data.message);
                    } else if (data.type === 'SUCCESS') {
                        MixiToast.success(data.title, data.message);
                    } else {
                        MixiToast.info(data.title, data.message);
                    }
                }
                const dot = document.querySelector('.topbar-badge-dot');
                if (dot) dot.style.display = 'block';
            }
        }
    })
    .catch(() => {});
}, 20000);
</script>
