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
                <i class="bi bi-journal-minus"></i>
                <span>Khấu trừ</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/payslip" 
               class="sidebar-nav-link ${activeMenu eq 'payslip' ? 'active' : ''}">
                <i class="bi bi-receipt"></i>
                <span>Phiếu lương</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/payment" 
               class="sidebar-nav-link ${activeMenu eq 'payment' ? 'active' : ''}">
                <i class="bi bi-credit-card"></i>
                <span>Thanh toán</span>
            </a>
        </div>

        <!-- BÁO CÁO & THỐNG KÊ -->
        <div class="menu-section">
            <div class="menu-section-label">Báo cáo & Thống kê</div>
            
            <a href="${pageContext.request.contextPath}/reports" 
               class="sidebar-nav-link ${activeMenu eq 'reports' ? 'active' : ''}">
                <i class="bi bi-bar-chart-line"></i>
                <span>Báo cáo tổng quan</span>
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
</aside>
