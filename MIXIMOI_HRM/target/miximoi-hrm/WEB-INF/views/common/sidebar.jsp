<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!-- Mobile Backdrop -->
        <div class="sidebar-backdrop"></div>

        <!-- Sidebar Navigation -->
        <aside class="app-sidebar">
            <!-- Brand Header -->
            <div class="sidebar-header">
                <div class="brand-logo-icon">
                    <span style="font-weight: 800; font-size: 1.15rem; letter-spacing: -0.5px;">M</span>
                </div>
                <div class="brand-text">
                    <span class="brand-title">MIXIMOI</span>
                    <span class="brand-sub">HRM & PAYROLL</span>
                </div>
            </div>

            <!-- Navigation Menu Items -->
            <div class="sidebar-nav-container">
                <!-- TRANG CHỦ -->
                <div class="menu-section">
                    <div class="menu-section-label">Trang chủ</div>
                    <a href="${pageContext.request.contextPath}/dashboard"
                        class="sidebar-nav-link ${pageContext.request.servletPath eq '/WEB-INF/views/dashboard/dashboard.jsp' or activeMenu eq 'dashboard' or pageContext.request.servletPath eq '/dashboard' ? 'active' : ''}">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </div>

                <!-- QUẢN LÝ TỔ CHỨC -->
                <div class="menu-section">
                    <div class="menu-section-label">Quản lý tổ chức</div>

                    <a href="${pageContext.request.contextPath}/employees"
                        class="sidebar-nav-link ${activeMenu eq 'employees' or pageContext.request.servletPath.contains('employee') ? 'active' : ''}">
                        <i class="bi bi-people"></i>
                        <span>Nhân viên</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/departments"
                        class="sidebar-nav-link ${activeMenu eq 'departments' or pageContext.request.servletPath.contains('department') ? 'active' : ''}">
                        <i class="bi bi-building"></i>
                        <span>Phòng ban</span>
                    </a>

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
                </div>

                <!-- QUẢN LÝ CHẤM CÔNG -->
                <div class="menu-section">
                    <div class="menu-section-label">Quản lý chấm công</div>

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
                </div>

                <!-- QUẢN LÝ LƯƠNG -->
                <div class="menu-section">
                    <div class="menu-section-label">Quản lý lương</div>

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

                    <a href="${pageContext.request.contextPath}/payment"
                        class="sidebar-nav-link ${activeMenu eq 'payment' or pageContext.request.servletPath.contains('payment') ? 'active' : ''}">
                        <i class="bi bi-credit-card-2-front"></i>
                        <span>Thanh toán</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/payslip"
                        class="sidebar-nav-link ${activeMenu eq 'payslip' or pageContext.request.servletPath.contains('payslip') ? 'active' : ''}">
                        <i class="bi bi-receipt-cutoff"></i>
                        <span>Phiếu lương</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/disciplines"
                        class="sidebar-nav-link ${activeMenu eq 'disciplines' or pageContext.request.servletPath.contains('discipline') ? 'active' : ''}">
                        <i class="bi bi-shield-exclamation"></i>
                        <span>Kỷ luật</span>
                    </a>
                </div>

                <!-- QUẢN LÝ TUYỂN DỤNG -->
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

                <!-- QUẢN LÝ HIỆU SUẤT -->
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

                <!-- HỆ THỐNG -->
                <div class="menu-section">
                    <div class="menu-section-label">Hệ thống</div>

                    <a href="${pageContext.request.contextPath}/settings"
                        class="sidebar-nav-link ${activeMenu eq 'settings' and (empty activeSubMenu or activeSubMenu eq 'system') and empty param.view ? 'active' : ''}">
                        <i class="bi bi-gear-wide-connected"></i>
                        <span>Thiết lập hệ thống</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/users"
                        class="sidebar-nav-link ${activeMenu eq 'users' or pageContext.request.servletPath.contains('user') ? 'active' : ''}">
                        <i class="bi bi-shield-lock"></i>
                        <span>Tài khoản & Phân quyền</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/settings?view=profile"
                        class="sidebar-nav-link ${activeMenu eq 'settings' and (activeSubMenu eq 'profile' or param.view eq 'profile' or param.view eq 'account') ? 'active' : ''}">
                        <i class="bi bi-sliders2-vertical"></i>
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