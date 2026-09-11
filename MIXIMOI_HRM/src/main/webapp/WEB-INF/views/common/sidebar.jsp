<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Mobile Backdrop -->
<div class="sidebar-backdrop"></div>

<!-- Sidebar Navigation -->
<aside class="app-sidebar">
    <!-- Brand Header -->
    <div class="sidebar-header">
        <div class="brand-logo-icon">
            <i class="bi bi-building-fill-gear"></i>
        </div>
        <div class="brand-text">
            <span class="brand-title">MIXIMOI</span>
            <span class="brand-sub">HRM & PAYROLL</span>
        </div>
    </div>

    <!-- Navigation Menu Items -->
    <div class="sidebar-nav-container">
        <!-- Dashboard -->
        <a href="${pageContext.request.contextPath}/dashboard" 
           class="sidebar-nav-link ${pageContext.request.servletPath eq '/WEB-INF/views/dashboard/dashboard.jsp' or activeMenu eq 'dashboard' ? 'active' : ''}">
            <i class="bi bi-grid-1x2-fill"></i>
            <span>Dashboard</span>
        </a>

        <!-- QUẢN LÝ NHÂN SỰ -->
        <div class="menu-section">
            <div class="menu-section-label">Quản lý nhân sự</div>
            
            <a href="${pageContext.request.contextPath}/employees" 
               class="sidebar-nav-link ${activeMenu eq 'employees' or pageContext.request.servletPath.contains('employee') ? 'active' : ''}">
                <i class="bi bi-people"></i>
                <span>Nhân viên</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/departments" 
               class="sidebar-nav-link ${activeMenu eq 'departments' ? 'active' : ''}">
                <i class="bi bi-building"></i>
                <span>Phòng ban</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/positions" 
               class="sidebar-nav-link ${activeMenu eq 'positions' ? 'active' : ''}">
                <i class="bi bi-person-badge"></i>
                <span>Chức vụ</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/contracts" 
               class="sidebar-nav-link ${activeMenu eq 'contracts' ? 'active' : ''}">
                <i class="bi bi-file-earmark-text"></i>
                <span>Hợp đồng</span>
            </a>
        </div>

        <!-- QUẢN LÝ CHẤM CÔNG -->
        <div class="menu-section">
            <div class="menu-section-label">Quản lý chấm công</div>
            
            <a href="${pageContext.request.contextPath}/attendance" 
               class="sidebar-nav-link ${activeMenu eq 'attendance' ? 'active' : ''}">
                <i class="bi bi-clock-history"></i>
                <span>Chấm công</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/timesheet" 
               class="sidebar-nav-link ${activeMenu eq 'timesheet' ? 'active' : ''}">
                <i class="bi bi-calendar3"></i>
                <span>Bảng công</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/overtime" 
               class="sidebar-nav-link ${activeMenu eq 'overtime' ? 'active' : ''}">
                <i class="bi bi-stopwatch"></i>
                <span>Tăng ca</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/leave" 
               class="sidebar-nav-link ${activeMenu eq 'leave' ? 'active' : ''}">
                <i class="bi bi-calendar-check"></i>
                <span>Nghỉ phép</span>
                <c:if test="${not empty pendingLeaves and pendingLeaves > 0}">
                    <span class="sidebar-badge bg-warning text-dark">${pendingLeaves}</span>
                </c:if>
            </a>
        </div>

        <!-- QUẢN LÝ LƯƠNG -->
        <div class="menu-section">
            <div class="menu-section-label">Quản lý lương</div>
            
            <a href="${pageContext.request.contextPath}/salary-config" 
               class="sidebar-nav-link ${activeMenu eq 'salary-config' ? 'active' : ''}">
                <i class="bi bi-sliders"></i>
                <span>Thiết lập lương</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/payroll" 
               class="sidebar-nav-link ${activeMenu eq 'payroll' ? 'active' : ''}">
                <i class="bi bi-cash-coin"></i>
                <span>Bảng lương</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/allowances" 
               class="sidebar-nav-link ${activeMenu eq 'allowances' ? 'active' : ''}">
                <i class="bi bi-credit-card-2-front"></i>
                <span>Phụ cấp</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/bonuses" 
               class="sidebar-nav-link ${activeMenu eq 'bonuses' ? 'active' : ''}">
                <i class="bi bi-gift"></i>
                <span>Thưởng</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/deductions" 
               class="sidebar-nav-link ${activeMenu eq 'deductions' ? 'active' : ''}">
                <i class="bi bi-dash-circle"></i>
                <span>Khấu trừ</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/rewards" 
               class="sidebar-nav-link ${activeMenu eq 'rewards' ? 'active' : ''}">
                <i class="bi bi-award"></i>
                <span>Khen thưởng</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/disciplines" 
               class="sidebar-nav-link ${activeMenu eq 'disciplines' ? 'active' : ''}">
                <i class="bi bi-shield-exclamation"></i>
                <span>Kỷ luật</span>
            </a>
        </div>

        <!-- QUẢN TRỊ TUYỂN DỤNG -->
        <div class="menu-section">
            <div class="menu-section-label">Quản trị tuyển dụng</div>
            
            <a href="${pageContext.request.contextPath}/recruitment" 
               class="sidebar-nav-link ${activeMenu eq 'recruitment' ? 'active' : ''}">
                <i class="bi bi-person-plus"></i>
                <span>Tuyển dụng</span>
            </a>
        </div>

        <!-- HỆ THỐNG -->
        <div class="menu-section">
            <div class="menu-section-label">Hệ thống</div>
            
            <a href="${pageContext.request.contextPath}/users" 
               class="sidebar-nav-link ${activeMenu eq 'users' ? 'active' : ''}">
                <i class="bi bi-shield-lock"></i>
                <span>Tài khoản & Phân quyền</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/settings" 
               class="sidebar-nav-link ${activeMenu eq 'settings' ? 'active' : ''}">
                <i class="bi bi-gear"></i>
                <span>Cài đặt hệ thống</span>
            </a>
        </div>
    </div>

    <!-- Sidebar Bottom User Status Card -->
    <div class="sidebar-user-footer">
        <div class="sidebar-user-avatar position-relative">
            <div class="avatar-circle">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.fullName}">
                        ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
                    </c:when>
                    <c:otherwise>A</c:otherwise>
                </c:choose>
            </div>
            <span class="user-online-indicator"></span>
        </div>
        <div class="sidebar-user-details">
            <div class="sidebar-user-name">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.fullName}">
                        ${sessionScope.currentUser.fullName}
                    </c:when>
                    <c:otherwise>Nguyễn Văn Admin</c:otherwise>
                </c:choose>
            </div>
            <div class="sidebar-user-status">
                <span class="online-dot"></span> Đang trực tuyến
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn" title="Đăng xuất">
            <i class="bi bi-box-arrow-right"></i>
        </a>
    </div>
</aside>
