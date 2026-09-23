<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Mobile Backdrop -->
<div class="sidebar-backdrop"></div>

<!-- Sidebar Navigation -->
<aside class="app-sidebar">
    <!-- Brand Header -->
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/dashboard" class="d-flex align-items-center gap-3 text-decoration-none">
            <div class="brand-logo-icon">
                <span style="font-weight: 800; font-size: 1.15rem; letter-spacing: -0.5px; color: #fff;">
                    ${not empty applicationScope.systemSettings['company_short_name'] ? applicationScope.systemSettings['company_short_name'].substring(0, 1) : 'M'}
                </span>
            </div>
            <div class="brand-text">
                <span class="brand-title">
                    ${not empty applicationScope.systemSettings['company_short_name'] ? applicationScope.systemSettings['company_short_name'] : 'MIXIMOI'}
                </span>
                <span class="brand-sub">HRM & PAYROLL</span>
            </div>
        </a>
    </div>

    <!-- Navigation Menu Items -->
    <div class="sidebar-nav-container">
        
        <!-- ================= TRANG CHỦ (Tất cả Role) ================= -->
        <div class="menu-section">
            <div class="menu-section-label">Trang chủ</div>
            <a href="${pageContext.request.contextPath}/dashboard"
               class="sidebar-nav-link ${activeMenu eq 'dashboard' or pageContext.request.servletPath eq '/dashboard' or pageContext.request.servletPath eq '/WEB-INF/views/dashboard/dashboard.jsp' ? 'active' : ''}">
                <i class="bi bi-grid-fill"></i>
                <span>Dashboard</span>
            </a>
        </div>

        <!-- ================= QUẢN LÝ NHÂN SỰ (ADMIN, HR, MANAGER) ================= -->
        <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr or sessionScope.currentUser.manager}">
            <div class="menu-section">
                <div class="menu-section-label">Quản lý nhân sự</div>

                <a href="${pageContext.request.contextPath}/employees"
                   class="sidebar-nav-link ${activeMenu eq 'employees' or pageContext.request.servletPath.contains('employee') ? 'active' : ''}">
                    <i class="bi bi-person-vcard-fill"></i>
                    <span>Nhân viên</span>
                </a>

                <a href="${pageContext.request.contextPath}/departments"
                   class="sidebar-nav-link ${activeMenu eq 'departments' or pageContext.request.servletPath.contains('department') ? 'active' : ''}">
                    <i class="bi bi-building"></i>
                    <span>Phòng ban</span>
                </a>

                <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
                    <a href="${pageContext.request.contextPath}/positions"
                       class="sidebar-nav-link ${activeMenu eq 'positions' or pageContext.request.servletPath.contains('position') ? 'active' : ''}">
                        <i class="bi bi-person-badge"></i>
                        <span>Chức vụ</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/contracts"
                       class="sidebar-nav-link ${activeMenu eq 'contracts' or pageContext.request.servletPath.contains('contract') ? 'active' : ''}">
                        <i class="bi bi-file-earmark-text"></i>
                        <span>Hợp đồng</span>
                    </a>
                </c:if>
            </div>
        </c:if>

        <!-- ================= QUẢN LÝ CHẤM CÔNG ================= -->
        <div class="menu-section">
            <div class="menu-section-label">Quản lý chấm công</div>

            <c:choose>
                <%-- Với Quản trị / HR / Kế toán / Quản lý: Full nghiệp vụ chấm công công ty --%>
                <c:when test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr or sessionScope.currentUser.accountant or sessionScope.currentUser.manager}">
                    <a href="${pageContext.request.contextPath}/attendance"
                       class="sidebar-nav-link ${activeMenu eq 'attendance' or pageContext.request.servletPath eq '/attendance' ? 'active' : ''}">
                        <i class="bi bi-clock-history"></i>
                        <span>Chấm công</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/timesheet"
                       class="sidebar-nav-link ${activeMenu eq 'timesheet' or pageContext.request.servletPath eq '/timesheet' ? 'active' : ''}">
                        <i class="bi bi-calendar3"></i>
                        <span>Bảng công</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/overtime"
                       class="sidebar-nav-link ${activeMenu eq 'overtime' or pageContext.request.servletPath eq '/overtime' ? 'active' : ''}">
                        <i class="bi bi-stopwatch"></i>
                        <span>Tăng ca</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/leave"
                       class="sidebar-nav-link ${activeMenu eq 'leave' or pageContext.request.servletPath.contains('leave') ? 'active' : ''}">
                        <i class="bi bi-calendar-check"></i>
                        <span>Nghỉ phép</span>
                        <c:if test="${not empty pendingLeaves and pendingLeaves > 0}">
                            <span class="sidebar-badge bg-warning text-dark">${pendingLeaves}</span>
                        </c:if>
                    </a>
                </c:when>

                <%-- Với Nhân viên bình thường (EMPLOYEE): Xem thông tin cá nhân, chấm công, bảng công, tăng ca, nghỉ phép --%>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/attendance"
                       class="sidebar-nav-link ${activeMenu eq 'attendance' ? 'active' : ''}">
                        <i class="bi bi-fingerprint"></i>
                        <span>Chấm công của tôi</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/timesheet"
                       class="sidebar-nav-link ${activeMenu eq 'timesheet' or pageContext.request.servletPath eq '/timesheet' ? 'active' : ''}">
                        <i class="bi bi-calendar3"></i>
                        <span>Bảng công của tôi</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/overtime"
                       class="sidebar-nav-link ${activeMenu eq 'overtime' or pageContext.request.servletPath eq '/overtime' ? 'active' : ''}">
                        <i class="bi bi-stopwatch"></i>
                        <span>Tăng ca của tôi</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/leave"
                       class="sidebar-nav-link ${activeMenu eq 'leave' ? 'active' : ''}">
                        <i class="bi bi-send-check"></i>
                        <span>Đơn xin nghỉ phép</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- ================= QUẢN LÝ LƯƠNG (ADMIN, ACCOUNTANT, EMPLOYEE) ================= -->
        <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.accountant or sessionScope.currentUser.employee}">
            <div class="menu-section">
                <div class="menu-section-label">Quản lý lương</div>

                <%-- Kế toán & Admin: Quản lý thiết lập & tính lương toàn diện --%>
                <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.accountant}">
                    <a href="${pageContext.request.contextPath}/salary-config"
                       class="sidebar-nav-link ${activeMenu eq 'salary-config' or pageContext.request.servletPath.contains('salary-config') ? 'active' : ''}">
                        <i class="bi bi-sliders"></i>
                        <span>Thiết lập lương</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/payroll"
                       class="sidebar-nav-link ${activeMenu eq 'payroll' or pageContext.request.servletPath.contains('payroll') ? 'active' : ''}">
                        <i class="bi bi-cash-coin"></i>
                        <span>Bảng lương</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/allowances"
                       class="sidebar-nav-link ${activeMenu eq 'allowances' or pageContext.request.servletPath.contains('allowance') ? 'active' : ''}">
                        <i class="bi bi-wallet2"></i>
                        <span>Phụ cấp</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/bonuses"
                       class="sidebar-nav-link ${activeMenu eq 'bonuses' or pageContext.request.servletPath.contains('bonuse') ? 'active' : ''}">
                        <i class="bi bi-gift"></i>
                        <span>Thưởng</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/deductions"
                       class="sidebar-nav-link ${activeMenu eq 'deductions' or pageContext.request.servletPath.contains('deduction') ? 'active' : ''}">
                        <i class="bi bi-dash-circle"></i>
                        <span>Khấu trừ</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/payslip"
                       class="sidebar-nav-link ${activeMenu eq 'payslip' or pageContext.request.servletPath.contains('payslip') ? 'active' : ''}">
                        <i class="bi bi-receipt-cutoff"></i>
                        <span>Phiếu lương</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/payment"
                       class="sidebar-nav-link ${activeMenu eq 'payment' or pageContext.request.servletPath.contains('payment') ? 'active' : ''}">
                        <i class="bi bi-credit-card-2-front"></i>
                        <span>Thanh toán</span>
                    </a>
                </c:if>

                <%-- Nhân viên thông thường: Chỉ xem phiếu lương cá nhân --%>
                <c:if test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.accountant}">
                    <a href="${pageContext.request.contextPath}/payslip"
                       class="sidebar-nav-link ${activeMenu eq 'payslip' ? 'active' : ''}">
                        <i class="bi bi-receipt-cutoff"></i>
                        <span>Phiếu lương của tôi</span>
                    </a>
                </c:if>
            </div>
        </c:if>

        <!-- ================= QUẢN LÝ TUYỂN DỤNG (ADMIN, HR) ================= -->
        <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
            <div class="menu-section">
                <div class="menu-section-label">Quản lý tuyển dụng</div>

                <a href="${pageContext.request.contextPath}/recruitment"
                   class="sidebar-nav-link ${activeMenu eq 'recruitment' and (empty activeSubMenu or activeSubMenu eq 'overview') and empty param.view ? 'active' : ''}">
                    <i class="bi bi-person-lines-fill"></i>
                    <span>Tuyển dụng</span>
                </a>

                <a href="${pageContext.request.contextPath}/recruitment?view=jobs"
                   class="sidebar-nav-link ${activeMenu eq 'recruitment' and (activeSubMenu eq 'jobs' or param.view eq 'jobs') ? 'active' : ''}">
                    <i class="bi bi-briefcase"></i>
                    <span>Vị trí tuyển dụng</span>
                </a>

                <a href="${pageContext.request.contextPath}/recruitment?view=candidates"
                   class="sidebar-nav-link ${activeMenu eq 'recruitment' and (activeSubMenu eq 'candidates' or param.view eq 'candidates') ? 'active' : ''}">
                    <i class="bi bi-person-bounding-box"></i>
                    <span>Ứng viên</span>
                </a>
            </div>
        </c:if>

        <!-- ================= QUẢN LÝ HIỆU SUẤT (ADMIN, MANAGER) ================= -->
        <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.manager}">
            <div class="menu-section">
                <div class="menu-section-label">Quản lý hiệu suất</div>

                <a href="${pageContext.request.contextPath}/performance"
                   class="sidebar-nav-link ${activeMenu eq 'performance' or activeMenu eq 'kpi' or pageContext.request.servletPath.contains('performance') or pageContext.request.servletPath.contains('kpi') ? 'active' : ''}">
                    <i class="bi bi-graph-up-arrow"></i>
                    <span>KPI</span>
                </a>

                <a href="${pageContext.request.contextPath}/evaluations"
                   class="sidebar-nav-link ${activeMenu eq 'evaluations' or activeMenu eq 'performance-evaluations' or pageContext.request.servletPath.contains('evaluation') ? 'active' : ''}">
                    <i class="bi bi-clipboard2-data"></i>
                    <span>Đánh giá hiệu suất</span>
                </a>
            </div>
        </c:if>

        <!-- ================= BÁO CÁO & THỐNG KÊ (ADMIN, ACCOUNTANT, MANAGER) ================= -->
        <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.accountant or sessionScope.currentUser.manager}">
            <div class="menu-section">
                <div class="menu-section-label">Báo cáo & Thống kê</div>

                <a href="${pageContext.request.contextPath}/reports"
                   class="sidebar-nav-link ${activeMenu eq 'reports' or pageContext.request.servletPath.contains('report') ? 'active' : ''}">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Báo cáo tổng quan</span>
                </a>
            </div>
        </c:if>

        <!-- ================= HỆ THỐNG (Chỉ ADMIN) ================= -->
        <c:if test="${sessionScope.currentUser.admin}">
            <div class="menu-section">
                <div class="menu-section-label">Hệ thống</div>

                <a href="${pageContext.request.contextPath}/users"
                   class="sidebar-nav-link ${activeMenu eq 'users' or pageContext.request.servletPath.contains('user') ? 'active' : ''}">
                    <i class="bi bi-shield-lock"></i>
                    <span>Tài khoản & Phân quyền</span>
                </a>

                <a href="${pageContext.request.contextPath}/settings"
                   class="sidebar-nav-link ${activeMenu eq 'settings' and (empty activeSubMenu or activeSubMenu eq 'system') and empty param.view ? 'active' : ''}">
                    <i class="bi bi-gear-wide-connected"></i>
                    <span>Cài đặt hệ thống</span>
                </a>
            </div>
        </c:if>
    </div>

    <!-- Sidebar Bottom User Profile Card -->
    <div class="sidebar-user-footer">
        <div class="sidebar-user-avatar position-relative">
            <div class="avatar-circle">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.fullName}">
                        ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
                    </c:when>
                    <c:otherwise>U</c:otherwise>
                </c:choose>
            </div>
            <span class="user-online-indicator"></span>
        </div>
        <div class="sidebar-user-details">
            <div class="sidebar-user-name text-truncate">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.fullName}">
                        ${sessionScope.currentUser.fullName}
                    </c:when>
                    <c:otherwise>${sessionScope.currentUser.username}</c:otherwise>
                </c:choose>
            </div>
            <div class="sidebar-user-status text-truncate" style="font-size:0.75rem; color:#94a3b8;">
                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-0" style="font-size:0.7rem;">
                    ${sessionScope.currentUser.roleDisplayName}
                </span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn" title="Đăng xuất">
            <i class="bi bi-box-arrow-right"></i>
        </a>
    </div>
</aside>