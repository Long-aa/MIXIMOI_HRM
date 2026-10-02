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
                    <span class="breadcrumb-parent">Quản lý lương</span>
                    <span class="breadcrumb-slash">/</span>
                    <span class="breadcrumb-current">Kỷ luật</span>
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
    <div class="topbar-search-box mx-auto d-none d-lg-block">
        <i class="bi bi-search topbar-search-icon"></i>
        <input type="text" class="topbar-search-input" placeholder="Tìm kiếm nhân viên, báo cáo, phòng ban..." aria-label="Search">
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
        } catch (Exception ignored) {}
    }
%>
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
                    <span>Thông báo công ty</span>
                    <c:choose>
                        <c:when test="${not empty topbarUnreadCount and topbarUnreadCount > 0}">
                            <span class="badge bg-danger">${topbarUnreadCount} mới</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-primary-subtle text-primary">Đã cập nhật</span>
                        </c:otherwise>
                    </c:choose>
                </li>

                <c:choose>
                    <c:when test="${not empty topbarNotifications}">
                        <c:forEach items="${topbarNotifications}" var="n">
                            <li>
                                <a class="dropdown-item py-2 px-2 rounded d-flex gap-2 align-items-start border-bottom-subtle" 
                                   href="${pageContext.request.contextPath}${not empty n.linkUrl ? n.linkUrl : '/recruitment?view=internal'}">
                                    <c:choose>
                                        <c:when test="${n.recruitment}">
                                            <i class="bi bi-megaphone-fill text-danger fs-6 mt-1 flex-shrink-0"></i>
                                        </c:when>
                                        <c:when test="${n.type eq 'SUCCESS'}">
                                            <i class="bi bi-check-circle-fill text-success fs-6 mt-1 flex-shrink-0"></i>
                                        </c:when>
                                        <c:when test="${n.type eq 'WARNING'}">
                                            <i class="bi bi-exclamation-circle-fill text-warning fs-6 mt-1 flex-shrink-0"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-bell-fill text-primary fs-6 mt-1 flex-shrink-0"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="flex-grow-1" style="min-width: 0;">
                                        <div class="fw-semibold text-truncate text-dark" style="font-size: 0.82rem;" title="${n.title}">${n.title}</div>
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
                    <a href="${pageContext.request.contextPath}/recruitment?view=internal" class="text-primary text-decoration-none fw-semibold" style="font-size: 0.78rem;">
                        <i class="bi bi-briefcase me-1"></i>Tuyển dụng nội bộ
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard" class="text-muted text-decoration-none" style="font-size: 0.78rem;">
                        Bảng tin công ty
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
