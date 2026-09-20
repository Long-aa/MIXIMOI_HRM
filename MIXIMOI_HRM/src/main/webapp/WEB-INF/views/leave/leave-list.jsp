<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Nghỉ phép &amp; Nghỉ lễ — MIXIMOI HRM &amp; PAYROLL</title>
    <meta name="description" content="Theo dõi quỹ phép năm, đơn xin nghỉ phép, phê duyệt nghỉ phép và tỷ lệ vắng mặt toàn công ty">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/leave.css">
</head>
<body>

<div class="app-container">
    <c:set var="activeMenu" value="leave" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'submitted'}">Tạo đơn xin nghỉ phép thành công! Đã chuyển Trưởng phòng và HR phê duyệt.</c:when>
                        <c:when test="${param.success eq 'approved'}">Phê duyệt đơn nghỉ phép thành công!</c:when>
                        <c:when test="${param.success eq 'rejected'}">Đã từ chối đơn xin nghỉ phép.</c:when>
                        <c:when test="${param.success eq 'exported'}">Đã xuất báo cáo tổng hợp nghỉ phép năm 2026!</c:when>
                        <c:otherwise>Thao tác hoàn tất!</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Page Header Bar (Role-Specific) -->
            <div class="leave-header-bar">
                <div>
                    <h1 class="leave-title">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.accountant}">
                                Đối soát Nghỉ phép &amp; Quyết toán Lương
                                <span class="badge bg-success-subtle text-success border border-success-subtle ms-1" style="font-size:0.75rem;"><i class="bi bi-cash-stack me-1"></i>Kế toán &amp; Lương</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.manager}">
                                Theo dõi Nghỉ phép &amp; Phê duyệt Phòng ban
                                <span class="badge bg-warning-subtle text-dark border border-warning-subtle ms-1" style="font-size:0.75rem;"><i class="bi bi-briefcase me-1"></i>Quản lý &amp; Duyệt</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
                                Cổng Dịch Vụ Cá Nhân — Nghỉ phép
                                <span class="badge bg-info-subtle text-primary border border-info-subtle ms-1" style="font-size:0.75rem;"><i class="bi bi-person-circle me-1"></i>Nhân viên Cá nhân</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.hr}">
                                Quản lý Nghỉ phép &amp; Nghỉ lễ
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle ms-1" style="font-size:0.75rem;"><i class="bi bi-people me-1"></i>Quản trị HR</span>
                            </c:when>
                            <c:otherwise>
                                Quản trị Nghỉ phép Toàn hệ thống
                                <span class="badge bg-dark text-white ms-1" style="font-size:0.75rem;"><i class="bi bi-shield-lock me-1"></i>Admin Toàn quyền</span>
                            </c:otherwise>
                        </c:choose>
                        <span class="fy-badge">FY 2026</span>
                    </h1>
                    <p class="leave-subtitle">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.accountant}">
                                Đối soát ngày công nghỉ phép để tính trừ lương và hồ sơ trợ cấp BHXH/BHYT kỳ quyết toán 09/2026.
                            </c:when>
                            <c:when test="${sessionScope.currentUser.manager}">
                                Giám sát tỷ lệ vắng mặt phòng ban và xử lý phê duyệt Cấp 1 (TP) cho các thành viên trong nhóm.
                            </c:when>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
                                Tra cứu số dư phép năm khả dụng (11.5 ngày), tạo đơn xin nghỉ phép và theo dõi tiến độ phê duyệt TP → HR.
                            </c:when>
                            <c:when test="${sessionScope.currentUser.hr}">
                                Quản lý quỹ phép năm Điều 113 BLLĐ, cấu hình chính sách thâm niên, thẩm tra và duyệt Cấp 2 HR toàn công ty.
                            </c:when>
                            <c:otherwise>
                                Quản trị toàn bộ hệ thống: kiểm soát hạn mức phép năm, phê duyệt đa cấp và giám sát tuân thủ toàn công ty.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <div class="leave-actions-group">
                    <!-- Dropdown Năm tài chính -->
                    <div class="fy-select-btn">
                        <i class="bi bi-calendar3 text-primary"></i>
                        <span>Năm tài chính 2026</span>
                        <i class="bi bi-chevron-down text-muted" style="font-size:0.75rem;"></i>
                    </div>

                    <!-- Nút Cấu hình quỹ phép (Admin & HR) -->
                    <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
                        <button type="button" class="btn-leave-outline" onclick="alert('Cấu hình quỹ phép năm 2026: 12 ngày phép chuẩn + thâm niên theo Điều 113 BLLĐ.');">
                            <i class="bi bi-sliders"></i> Cấu hình quỹ phép
                        </button>
                    </c:if>

                    <!-- Nút Kế toán: Xuất đối soát tính lương & Đến bảng lương -->
                    <c:if test="${sessionScope.currentUser.accountant}">
                        <a href="${pageContext.request.contextPath}/payroll" class="btn-leave-outline" title="Chuyển sang phân hệ Bảng lương">
                            <i class="bi bi-cash-coin text-success"></i> Đến Bảng lương
                        </a>
                    </c:if>

                    <!-- Nút Xuất báo cáo (Admin, HR, Accountant, Manager) -->
                    <c:if test="${not sessionScope.currentUser.employee or sessionScope.currentUser.admin or sessionScope.currentUser.hr or sessionScope.currentUser.accountant or sessionScope.currentUser.manager}">
                        <form method="post" action="${pageContext.request.contextPath}/leave" class="d-inline">
                            <input type="hidden" name="action" value="export">
                            <button type="submit" class="btn-leave-outline">
                                <i class="bi bi-download"></i> ${sessionScope.currentUser.accountant ? 'Xuất Excel tính lương' : 'Xuất báo cáo'}
                            </button>
                        </form>
                    </c:if>

                    <!-- Nút Tạo đơn nghỉ phép -->
                    <button type="button" class="btn-leave-primary" data-bs-toggle="modal" data-bs-target="#newLeaveModal">
                        <i class="bi bi-plus-lg"></i>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager}">Gửi đơn xin nghỉ phép</c:when>
                            <c:otherwise>Tạo đơn nghỉ phép</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </div>

            <!-- 4 Thẻ KPI Chỉ số theo từng Role -->
            <c:choose>
                <%-- ===== 1. GÓC NHÌN KẾ TOÁN (ACCOUNTANT): Đối soát lương & BHXH ===== --%>
                <c:when test="${sessionScope.currentUser.accountant}">
                    <div class="leave-kpi-grid">
                        <div class="leave-kpi-card" style="border-left: 4px solid #059669;">
                            <div class="lkpi-shape" style="background:#ecfdf5;"></div>
                            <div>
                                <span class="lkpi-label" style="color:#059669;">Nghỉ 100% lương</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val" style="color:#059669;">347</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">ngày</span>
                                </div>
                            </div>
                            <div class="lkpi-sub"><i class="bi bi-check2-circle text-success me-1"></i>Được tính đủ nguyên lương theo BLLĐ</div>
                        </div>

                        <div class="leave-kpi-card" style="border-left: 4px solid #dc2626;">
                            <div class="lkpi-shape" style="background:#fef2f2;"></div>
                            <div>
                                <span class="lkpi-label" style="color:#dc2626;">Nghỉ không lương (Khấu trừ)</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val" style="color:#dc2626;">10</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">ngày trừ công</span>
                                </div>
                            </div>
                            <div class="lkpi-sub text-danger"><i class="bi bi-dash-circle me-1"></i>Khấu trừ ngày công thực tế tính lương</div>
                        </div>

                        <div class="leave-kpi-card" style="border-left: 4px solid #2563eb;">
                            <div class="lkpi-shape" style="background:#eff6ff;"></div>
                            <div>
                                <span class="lkpi-label" style="color:#2563eb;">Nghỉ ốm BHXH chi trả</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val" style="color:#2563eb;">68</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">ngày trợ cấp</span>
                                </div>
                            </div>
                            <div class="lkpi-sub"><i class="bi bi-hospital text-primary me-1"></i>Hồ sơ đề nghị trợ cấp BHXH 75%</div>
                        </div>

                        <div class="leave-kpi-card" style="border-left: 4px solid #475569;">
                            <div class="lkpi-shape" style="background:#f8fafc;"></div>
                            <div>
                                <span class="lkpi-label">Đơn đã chốt tính lương</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val">166</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">/ 186 đơn</span>
                                </div>
                            </div>
                            <div class="lkpi-sub"><strong class="text-success">89.2%</strong> hoàn tất đối soát quyết toán</div>
                        </div>
                    </div>
                </c:when>

                <%-- ===== 2. GÓC NHÌN QUẢN LÝ (MANAGER): Theo dõi quân số & Phê duyệt nhóm ===== --%>
                <c:when test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
                    <div class="leave-kpi-grid">
                        <div class="leave-kpi-card" style="border-left: 4px solid #2563eb;">
                            <div class="lkpi-shape"></div>
                            <div>
                                <span class="lkpi-label">Phòng ban nghỉ hôm nay</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val">2</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">/ 24 nhân sự</span>
                                </div>
                            </div>
                            <div class="lkpi-sub"><strong class="text-primary">8.3%</strong> • Vắng mặt có đăng ký trước</div>
                        </div>

                        <div class="leave-kpi-card" style="border-left: 4px solid #d97706;">
                            <div class="lkpi-shape" style="background:#fffbeb;"></div>
                            <div>
                                <span class="lkpi-label" style="color:#d97706;">Đơn chờ TP phê duyệt</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val" style="color:#d97706;">3</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">đơn cần xử lý</span>
                                </div>
                            </div>
                            <div class="lkpi-sub"><span class="badge bg-warning-subtle text-dark fw-bold">Cần duyệt Cấp 1</span> chuyển HR</div>
                        </div>

                        <div class="leave-kpi-card">
                            <div class="lkpi-shape"></div>
                            <div>
                                <span class="lkpi-label">Quỹ phép phòng ban đã dùng</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val">84</span>
                                    <span style="font-size:0.88rem; color:#94a3b8; font-weight:600;">/ 450 ngày</span>
                                </div>
                            </div>
                            <div class="lkpi-sub d-flex align-items-center justify-content-between">
                                <div class="progress flex-grow-1 me-2" style="height:5px;">
                                    <div class="progress-bar bg-warning" style="width: 18.6%;"></div>
                                </div>
                                <span class="fw-bold text-dark" style="font-size:0.75rem;">18.6%</span>
                            </div>
                        </div>

                        <div class="leave-kpi-card" style="border-left: 4px solid #059669;">
                            <div class="lkpi-shape" style="background:#ecfdf5;"></div>
                            <div>
                                <span class="lkpi-label" style="color:#059669;">Quân số trực đảm bảo</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val" style="color:#059669;">91.7%</span>
                                    <span style="font-size:0.88rem; color:#64748b; font-weight:600;">đạt chuẩn</span>
                                </div>
                            </div>
                            <div class="lkpi-sub"><i class="bi bi-shield-check text-success me-1"></i>Đáp ứng tiến độ dự án quý 3</div>
                        </div>
                    </div>
                </c:when>

                <%-- ===== 3. GÓC NHÌN NHÂN VIÊN (EMPLOYEE): Chỉ số cá nhân ===== --%>
                <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                    <div class="leave-kpi-grid">
                        <div class="leave-kpi-card" style="border-left: 4px solid #059669; background:linear-gradient(135deg, #fff, #f0fdf4);">
                            <div class="lkpi-shape" style="background:#dcfce7;"></div>
                            <div>
                                <span class="lkpi-label" style="color:#059669;">Phép khả dụng của bạn</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val" style="color:#059669;">11.5</span>
                                    <span style="font-size:1rem; color:#059669; font-weight:800;">ngày</span>
                                </div>
                            </div>
                            <div class="lkpi-sub text-success fw-bold"><i class="bi bi-calendar-check me-1"></i>Sẵn sàng nộp đơn nghỉ phép</div>
                        </div>

                        <div class="leave-kpi-card">
                            <div class="lkpi-shape"></div>
                            <div>
                                <span class="lkpi-label">Số ngày đã nghỉ năm nay</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val">5.5</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">/ 17.0 ngày</span>
                                </div>
                            </div>
                            <div class="lkpi-sub">3.5 ngày phép năm • 2.0 ngày nghỉ ốm</div>
                        </div>

                        <div class="leave-kpi-card" style="border-left: 4px solid #d97706;">
                            <div class="lkpi-shape" style="background:#fffbeb;"></div>
                            <div>
                                <span class="lkpi-label" style="color:#d97706;">Đơn đang xử lý</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val" style="color:#d97706;">1</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">đơn trình ký</span>
                                </div>
                            </div>
                            <div class="lkpi-sub"><span class="badge bg-warning-subtle text-dark fw-bold">LP-2026-016</span> chờ TP duyệt</div>
                        </div>

                        <div class="leave-kpi-card">
                            <div class="lkpi-shape"></div>
                            <div>
                                <span class="lkpi-label">Hạn bảo lưu phép 2025</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val" style="font-size:1.35rem; color:#2563eb;">31/03/2027</span>
                                </div>
                            </div>
                            <div class="lkpi-sub"><i class="bi bi-clock-history me-1 text-muted"></i>Còn 4.0 ngày chuyển từ năm ngoái</div>
                        </div>
                    </div>
                </c:when>

                <%-- ===== 4. GÓC NHÌN ADMIN & HR: 4 Chỉ số toàn công ty ===== --%>
                <c:otherwise>
                    <div class="leave-kpi-grid">
                        <!-- Card 1: Đang nghỉ hôm nay -->
                        <div class="leave-kpi-card">
                            <div class="lkpi-shape"></div>
                            <div>
                                <span class="lkpi-label">Đang nghỉ hôm nay</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val">8</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">nhân sự</span>
                                </div>
                            </div>
                            <div class="lkpi-sub">
                                <strong class="text-primary">3.2%</strong> • Vắng mặt có kế hoạch
                            </div>
                        </div>

                        <!-- Card 2: Đơn chờ phê duyệt -->
                        <div class="leave-kpi-card">
                            <div class="lkpi-shape"></div>
                            <div>
                                <span class="lkpi-label">Đơn chờ phê duyệt</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val">14</span>
                                    <span style="font-size:0.9rem; color:#64748b; font-weight:600;">đơn trình ký</span>
                                </div>
                            </div>
                            <div class="lkpi-sub">
                                <span class="badge" style="background:#eff6ff; color:#2563eb; font-weight:700;">8 mới</span>
                                <span>gửi trong 24h qua</span>
                            </div>
                        </div>

                        <!-- Card 3: Quỹ phép đã sử dụng -->
                        <div class="leave-kpi-card">
                            <div class="lkpi-shape"></div>
                            <div>
                                <span class="lkpi-label">Quỹ phép đã sử dụng</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val">482</span>
                                    <span style="font-size:0.88rem; color:#94a3b8; font-weight:600;">/ 2,940 ngày</span>
                                </div>
                            </div>
                            <div class="lkpi-sub d-flex align-items-center justify-content-between">
                                <div class="progress flex-grow-1 me-2" style="height:5px;">
                                    <div class="progress-bar bg-primary" style="width: 16.4%;"></div>
                                </div>
                                <span class="fw-bold text-dark" style="font-size:0.75rem;">16.4%</span>
                            </div>
                        </div>

                        <!-- Card 4: Tồn phép trung bình -->
                        <div class="leave-kpi-card">
                            <div class="lkpi-shape"></div>
                            <div>
                                <span class="lkpi-label">Tồn phép trung bình</span>
                                <div class="lkpi-val-row">
                                    <span class="lkpi-val">7.8</span>
                                    <span style="font-size:0.88rem; color:#64748b; font-weight:600;">ngày / nhân sự</span>
                                </div>
                            </div>
                            <div class="lkpi-sub">
                                <i class="bi bi-clock me-1 text-muted"></i> Hạn bảo lưu đến 31/03/2027
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Middle Section: 2 Thẻ biểu đồ & Lịch tuần (Matches Screenshot 1) -->
            <div class="leave-middle-grid">
                <!-- Thẻ Trái: Cơ cấu loại nghỉ phép & Tần suất -->
                <div class="middle-card">
                    <div>
                        <div class="mcard-header">
                            <div>
                                <h3 class="mcard-title">Cơ cấu loại nghỉ phép &amp; Tần suất</h3>
                                <p class="mcard-sub">Tỷ lệ ngày nghỉ theo nhóm chế độ chính sách năm 2026</p>
                            </div>
                            <span class="mcard-tag">Tổng cộng: 482 ngày</span>
                        </div>

                        <!-- Segmented Progress Bar -->
                        <div class="segmented-bar">
                            <div class="seg-1" title="Phép thường niên: 72%"></div>
                            <div class="seg-2" title="Nghỉ ốm & BHYT: 14%"></div>
                            <div class="seg-3" title="Việc riêng có lương: 8%"></div>
                            <div class="seg-4" title="Chế độ Thai sản: 4%"></div>
                            <div class="seg-5" title="Nghỉ không hưởng lương: 2%"></div>
                        </div>

                        <!-- Legend Items (3x2 grid) -->
                        <div class="cat-legend-grid">
                            <div><span class="cat-dot c1"></span> Phép thường niên: <strong>347 ngày (72%)</strong></div>
                            <div><span class="cat-dot c2"></span> Nghỉ ốm &amp; BHYT: <strong>68 ngày (14%)</strong></div>
                            <div><span class="cat-dot c3"></span> Việc riêng có lương: <strong>38 ngày (8%)</strong></div>
                            <div><span class="cat-dot c4"></span> Chế độ Thai sản: <strong>19 ngày (4%)</strong></div>
                            <div><span class="cat-dot c5"></span> Nghỉ không hưởng lương: <strong>10 ngày (2%)</strong></div>
                            <div><span class="cat-dot c6"></span> Tỷ lệ tuân thủ hạn mức: <strong class="text-success">98.4% đạt chuẩn</strong></div>
                        </div>
                    </div>
                </div>

                <!-- Thẻ Phải: Lịch vắng mặt trong tuần -->
                <div class="middle-card">
                    <div>
                        <div class="mcard-header">
                            <div>
                                <h3 class="mcard-title">Lịch vắng mặt trong tuần</h3>
                                <p class="mcard-sub">28/09/2026 – 02/10/2026 (Tuần 40)</p>
                            </div>
                            <div class="d-flex align-items-center gap-1">
                                <button class="btn btn-sm btn-outline-light text-muted border py-0 px-2">&lt;</button>
                                <span class="badge bg-light text-dark border px-2 py-1" style="font-size:0.75rem;">Hiện tại</span>
                                <button class="btn btn-sm btn-outline-light text-muted border py-0 px-2">&gt;</button>
                            </div>
                        </div>

                        <!-- 3 Hàng ngày trong tuần -->
                        <div class="week-item-row">
                            <div class="d-flex align-items-center">
                                <div class="wdate-box"><span class="wdate-day">T2</span><span class="wdate-num">28</span></div>
                                <div class="week-content">
                                    <div class="week-title">3 nhân sự nghỉ phép</div>
                                    <div class="week-sub">Trần Thu Hà (R&amp;D), Lê Quốc Dũng (KD) +1 người</div>
                                </div>
                            </div>
                            <span class="week-badge">3 người</span>
                        </div>

                        <div class="week-item-row today">
                            <div class="d-flex align-items-center">
                                <div class="wdate-box today"><span class="wdate-day">T3</span><span class="wdate-num">29</span></div>
                                <div class="week-content">
                                    <div class="week-title text-primary">Hôm nay: 8 nhân sự •</div>
                                    <div class="week-sub">4 Phép năm, 2 Ốm đau, 2 Công tác đặc biệt</div>
                                </div>
                            </div>
                            <span class="week-badge today">Hôm nay</span>
                        </div>

                        <div class="week-item-row">
                            <div class="d-flex align-items-center">
                                <div class="wdate-box light"><span class="wdate-day">T4</span><span class="wdate-num">30</span></div>
                                <div class="week-content">
                                    <div class="week-title">5 nhân sự dự kiến vắng</div>
                                    <div class="week-sub">Phòng Kỹ thuật (2), Nhân sự (1), Kế toán (2)</div>
                                </div>
                            </div>
                            <span class="week-badge">5 người</span>
                        </div>
                    </div>

                    <div class="d-flex align-items-center justify-content-between pt-2 border-top" style="font-size:0.78rem;">
                        <span class="text-muted"><i class="bi bi-calendar-event text-primary me-1"></i> Kỳ nghỉ lễ tiếp theo: Ngày 02/09/2026 (Nghỉ 04 ngày)</span>
                        <a href="javascript:void(0);" onclick="alert('Đang mở Lịch nghỉ lễ và sự kiện toàn công ty năm 2026');" class="text-primary fw-bold text-decoration-none">
                            Xem lịch toàn công ty
                        </a>
                    </div>
                </div>
            </div>

            <!-- Banner Tra Cứu Cá Nhân Nhanh (Matches Screenshot 1) -->
            <div class="balance-lookup-card">
                <div class="lookup-left">
                    <div class="lookup-icon-box"><i class="bi bi-credit-card-2-front"></i></div>
                    <div>
                        <div class="lookup-label">TRA CỨU CÁ NHÂN NHANH</div>
                        <h4 class="lookup-title">Số dư phép của bạn (${userLeaveName})</h4>
                    </div>
                </div>

                <div class="lookup-metrics-row">
                    <div class="lmetric-item">
                        <span class="lmetric-label">Phép chuẩn năm</span>
                        <span class="lmetric-val">${standardLeaveDays} ngày</span>
                    </div>
                    <div class="lmetric-item">
                        <span class="lmetric-label">Thâm niên tích lũy</span>
                        <span class="lmetric-val text-primary">+${seniorityLeaveDays} ngày</span>
                    </div>
                    <div class="lmetric-item">
                        <span class="lmetric-label">Năm trước chuyển sang</span>
                        <span class="lmetric-val">${carryOverLeaveDays} ngày</span>
                    </div>
                    <div class="lmetric-item">
                        <span class="lmetric-label">Đã dùng kỳ này</span>
                        <span class="lmetric-val text-danger">${usedLeaveDays} ngày</span>
                    </div>
                    <div class="lmetric-item">
                        <span class="lmetric-label">Khả dụng hiện tại</span>
                        <span class="lmetric-val avail">${availableLeaveDays} <span style="font-size:0.95rem; font-weight:700;">ngày</span></span>
                    </div>
                </div>
            </div>

            <!-- Tabs Điều Hướng (Matches Screenshot 2) -->
            <div class="leave-nav-tabs">
                <a href="${pageContext.request.contextPath}/leave" class="leave-tab-link active">
                    Danh sách đơn nghỉ phép <span class="tab-badge-pill">186</span>
                </a>
                <a href="${pageContext.request.contextPath}/leave?tab=balance" class="leave-tab-link">
                    Bảng theo dõi tồn phép nhân viên <span class="tab-badge-pill">245</span>
                </a>
                <a href="${pageContext.request.contextPath}/leave?tab=policy" class="leave-tab-link">
                    Lịch nghỉ lễ &amp; Quy định công ty
                </a>
            </div>

            <!-- Thanh Lọc (Filter Row - Matches Screenshot 2) -->
            <div class="leave-filter-row">
                <form method="get" action="${pageContext.request.contextPath}/leave" class="d-flex align-items-center gap-2 flex-grow-1 flex-wrap" id="leaveFilterForm">
                    <div class="filter-search-wrap">
                        <i class="bi bi-search"></i>
                        <input type="text" name="keyword" class="filter-search-inp" placeholder="Tìm theo tên, mã NV, người thay thế..." value="${keyword}">
                    </div>

                    <select name="status" class="form-select lselect" onchange="document.getElementById('leaveFilterForm').submit();">
                        <option value="">Chờ phê duyệt</option>
                        <option value="ALL" ${selectedStatus eq 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="PENDING" ${selectedStatus eq 'PENDING' ? 'selected' : ''}>Chờ phê duyệt</option>
                        <option value="APPROVED" ${selectedStatus eq 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                        <option value="REJECTED" ${selectedStatus eq 'REJECTED' ? 'selected' : ''}>Từ chối</option>
                    </select>

                    <select name="departmentId" class="form-select lselect" onchange="document.getElementById('leaveFilterForm').submit();">
                        <option value="">Phòng ban: Tất cả</option>
                        <c:forEach var="dept" items="${departments}">
                            <option value="${dept.id}" ${selectedDeptId == dept.id ? 'selected' : ''}>${dept.name}</option>
                        </c:forEach>
                    </select>

                    <select name="leaveType" class="form-select lselect" onchange="document.getElementById('leaveFilterForm').submit();">
                        <option value="">Loại nghỉ: Tất cả</option>
                        <option value="ANNUAL" ${selectedLeaveType eq 'ANNUAL' ? 'selected' : ''}>Phép năm thường niên</option>
                        <option value="SICK" ${selectedLeaveType eq 'SICK' ? 'selected' : ''}>Nghỉ ốm đau / BHYT</option>
                        <option value="UNPAID" ${selectedLeaveType eq 'UNPAID' ? 'selected' : ''}>Nghỉ không hưởng lương</option>
                        <option value="WEDDING" ${selectedLeaveType eq 'WEDDING' ? 'selected' : ''}>Nghỉ cưới hỏi (Có lương)</option>
                    </select>

                    <a href="${pageContext.request.contextPath}/leave" class="btn-ts-reset" title="Đặt lại bộ lọc">
                        <i class="bi bi-funnel"></i>
                    </a>
                </form>
            </div>

            <!-- BẢNG DANH SÁCH ĐƠN NGHỈ PHÉP (Matches Screenshot 2 & 3) -->
            <div class="leave-table-card">
                <table class="leave-table">
                    <thead>
                        <tr>
                            <th style="width:36px; padding-left:1rem;"><input type="checkbox" class="form-check-input" style="cursor:pointer;"></th>
                            <th style="width:110px;">Mã đơn</th>
                            <th style="min-width:180px;">Nhân viên</th>
                            <th style="width:130px; text-align:center;">Loại nghỉ phép</th>
                            <th style="width:150px;">Thời gian nghỉ</th>
                            <th style="width:80px; text-align:center;">Số ngày</th>
                            <th>Lý do nghỉ</th>
                            <th style="min-width:170px;">Bàn giao công việc</th>
                            <c:if test="${sessionScope.currentUser.accountant}">
                                <th style="width:130px; text-align:center;">Tác động lương</th>
                            </c:if>
                            <th style="width:90px; text-align:center;">Phê duyệt</th>
                            <th style="width:105px; text-align:center;">Trạng thái</th>
                            <th style="width:110px; text-align:center; padding-right:1rem;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty leaveRequests}">
                                <tr>
                                    <td colspan="${sessionScope.currentUser.accountant ? 12 : 11}" class="text-center py-5 text-muted">
                                        <i class="bi bi-calendar-x" style="font-size:2.5rem; display:block; margin-bottom:0.5rem; color:#cbd5e1;"></i>
                                        Không tìm thấy đơn xin nghỉ phép nào phù hợp với bộ lọc
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="lr" items="${leaveRequests}">
                                    <tr>
                                        <!-- Checkbox -->
                                        <td style="padding-left:1rem;"><input type="checkbox" class="form-check-input"></td>

                                        <!-- Mã đơn -->
                                        <td>
                                            <span class="fw-bold text-primary" style="font-size:0.83rem;">${lr.leaveCode}</span>
                                        </td>

                                        <!-- Nhân viên -->
                                        <td>
                                            <div class="lemp-wrap">
                                                <div class="lemp-avatar">${lr.employeeName.substring(0,1)}</div>
                                                <div>
                                                    <div class="lemp-name">${lr.employeeName}</div>
                                                    <div class="lemp-dept">${lr.positionName} • ${lr.departmentName}</div>
                                                </div>
                                            </div>
                                        </td>

                                        <!-- Loại nghỉ phép -->
                                        <td class="text-center">
                                            <span class="badge-ltype ${lr.getLeaveTypeBadgeClass()}">
                                                ${lr.getLeaveTypeDisplay()}
                                            </span>
                                        </td>

                                        <!-- Thời gian nghỉ -->
                                        <td>
                                            <div class="ldate-main">${lr.startDate} – ${lr.endDate}</div>
                                            <div class="ldate-sub">${lr.timeNote != null ? lr.timeNote : 'Theo ca hành chính'}</div>
                                        </td>

                                        <!-- Số ngày -->
                                        <td class="text-center">
                                            <strong class="text-dark">${lr.days}</strong> <span style="font-size:0.75rem; color:#64748b;">ngày</span>
                                        </td>

                                        <!-- Lý do nghỉ -->
                                        <td>
                                            <div class="lreason-txt">${lr.reason}</div>
                                        </td>

                                        <!-- Bàn giao công việc -->
                                        <td>
                                            <div class="lhandover-txt">${lr.handoverPerson != null ? lr.handoverPerson : 'Lê Hoàng Nam (0912.445.892)'}</div>
                                        </td>

                                        <!-- Cột Kế toán: Tác động Lương & BHXH -->
                                        <c:if test="${sessionScope.currentUser.accountant}">
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${lr.leaveType eq 'ANNUAL'}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle py-1 px-2" style="font-size:0.74rem; font-weight:700;"><i class="bi bi-check2 me-1"></i>100% Lương</span>
                                                    </c:when>
                                                    <c:when test="${lr.leaveType eq 'SICK'}">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle py-1 px-2" style="font-size:0.74rem; font-weight:700;"><i class="bi bi-shield-plus me-1"></i>BHXH 75%</span>
                                                    </c:when>
                                                    <c:when test="${lr.leaveType eq 'UNPAID'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle py-1 px-2" style="font-size:0.74rem; font-weight:700;"><i class="bi bi-dash-circle me-1"></i>Trừ ${lr.days} công</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info-subtle text-info border border-info-subtle py-1 px-2" style="font-size:0.74rem; font-weight:700;"><i class="bi bi-gift me-1"></i>Có hưởng lương</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:if>

                                        <!-- Phê duyệt (Workflow TP -> HR) -->
                                        <td class="text-center">
                                            <span class="step-tp-hr">
                                                <span>TP</span>
                                                <i class="bi bi-${lr.managerStatus eq 'APPROVED' ? 'check-circle-fill text-success' : lr.managerStatus eq 'REJECTED' ? 'x-circle-fill text-danger' : 'arrow-right'}"></i>
                                                <span>HR</span>
                                            </span>
                                        </td>

                                        <!-- Trạng thái -->
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${lr.status eq 'APPROVED'}">
                                                    <span class="status-pill-matrix approved"><i class="bi bi-check-circle-fill"></i> Đã duyệt</span>
                                                </c:when>
                                                <c:when test="${lr.status eq 'REJECTED'}">
                                                    <span class="status-pill-matrix anomaly"><i class="bi bi-x-circle-fill"></i> Từ chối</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill-matrix pending"><i class="bi bi-clock-history"></i> Chờ duyệt</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Thao tác Phân Quyền Theo Role -->
                                        <td style="padding-right:1rem;">
                                            <div class="laction-btn-group justify-content-center">
                                                <%-- 1. Nút Duyệt Cấp 1 (TP) cho Manager --%>
                                                <c:if test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and lr.status eq 'PENDING' and lr.managerStatus ne 'APPROVED'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/leave" class="d-inline">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="id" value="${lr.id}">
                                                        <button type="submit" class="laction-btn ok" title="Trưởng phòng: Phê duyệt Cấp 1">
                                                            <i class="bi bi-check-circle text-success"></i>
                                                        </button>
                                                    </form>
                                                    <button type="button" class="laction-btn no" title="Trưởng phòng: Từ chối đơn"
                                                            onclick="openRejectLeaveModal('${lr.id}', '${lr.employeeName}', '${lr.leaveCode}')">
                                                        <i class="bi bi-x-circle text-danger"></i>
                                                    </button>
                                                </c:if>

                                                <%-- 2. Nút Duyệt Cấp 2 (HR) cho HR & Admin --%>
                                                <c:if test="${(sessionScope.currentUser.hr or sessionScope.currentUser.admin) and lr.status eq 'PENDING'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/leave" class="d-inline">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="id" value="${lr.id}">
                                                        <button type="submit" class="laction-btn ok" title="${sessionScope.currentUser.admin ? 'Toàn quyền: Phê duyệt đơn' : 'HR: Phê duyệt Cấp 2'}">
                                                            <i class="bi bi-check-circle"></i>
                                                        </button>
                                                    </form>
                                                    <button type="button" class="laction-btn no" title="Từ chối đơn"
                                                            onclick="openRejectLeaveModal('${lr.id}', '${lr.employeeName}', '${lr.leaveCode}')">
                                                        <i class="bi bi-x-circle"></i>
                                                    </button>
                                                </c:if>

                                                <%-- 3. Nút cho Nhân viên cá nhân: Hủy đơn nếu còn PENDING --%>
                                                <c:if test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant and lr.status eq 'PENDING'}">
                                                    <button type="button" class="laction-btn no" title="Hủy đơn xin nghỉ phép của tôi" onclick="if(confirm('Bạn có chắc chắn muốn hủy đơn nghỉ phép này không?')) { alert('Đã hủy đơn thành công!'); location.reload(); }">
                                                        <i class="bi bi-trash text-danger"></i>
                                                    </button>
                                                </c:if>

                                                <!-- Xem chi tiết (Tất cả Role) -->
                                                <button type="button" class="laction-btn" title="Xem chi tiết đơn"
                                                        onclick="openViewLeaveModal(this)"
                                                        data-code="${lr.leaveCode}"
                                                        data-name="${lr.employeeName}"
                                                        data-empcode="${lr.employeeCode}"
                                                        data-dept="${lr.departmentName}"
                                                        data-type="${lr.getLeaveTypeDisplay()}"
                                                        data-dates="${lr.startDate} đến ${lr.endDate} (${lr.days} ngày)"
                                                        data-reason="${lr.reason}"
                                                        data-handover="${lr.handoverPerson}"
                                                        data-mgr="${lr.managerStatus}"
                                                        data-hr="${lr.hrStatus}"
                                                        data-status="${lr.getStatusDisplay()}">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <!-- Đính kèm -->
                                                <button type="button" class="laction-btn" title="Tài liệu đính kèm" onclick="alert('Đơn có đính kèm giấy xác nhận y tế / thiệp báo.');">
                                                    <i class="bi bi-paperclip"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <!-- Phân trang Table footer -->
                <div class="ltable-footer">
                    <div>
                        Hiển thị <strong>1 - 4</strong> trong tổng số <strong>186</strong> đơn nghỉ phép • Đã chọn 0 mục
                    </div>
                    <div class="d-flex align-items-center gap-1">
                        <button class="btn btn-sm btn-outline-light text-muted border py-1 px-2" disabled>&lt;</button>
                        <button class="btn btn-sm btn-primary py-1 px-2 fw-bold">1</button>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2">2</button>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2">3</button>
                        <span class="px-1 text-muted">...</span>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2">19</button>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2">&gt;</button>
                    </div>
                </div>
            </div>

            <!-- Bottom Policy Banner (Matches Screenshot 2 & 3) -->
            <div class="bottom-policy-card">
                <div class="policy-left">
                    <div class="policy-icon-box"><i class="bi bi-shield-check"></i></div>
                    <div>
                        <h4 class="policy-title">Quy định chuyển số dư phép năm 2026 sang năm 2027</h4>
                        <p class="policy-desc">Theo điều 113 Bộ luật Lao động &amp; Thỏa ước MIXIMOI: Mỗi nhân sự được bảo lưu tối đa 5 ngày phép chưa sử dụng đến hết 31/03/2027.</p>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-sm btn-outline-primary fw-bold" onclick="alert('Mở Cẩm nang Nhân sự MIXIMOI 2026.');" style="height:36px; border-radius:8px;">
                        Xem cẩm nang nhân sự
                    </button>
                    <button type="button" class="btn btn-sm btn-primary fw-bold" onclick="alert('Đang tổng hợp số dư phép toàn công ty...');" style="height:36px; border-radius:8px; background:#2563eb;">
                        Kiểm tra số dư toàn công ty
                    </button>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- ============================================================
     MODAL TẠO ĐƠN NGHỈ PHÉP MỚI
     ============================================================ -->
<div class="modal fade" id="newLeaveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg" style="border-radius:18px;">
            <form method="post" action="${pageContext.request.contextPath}/leave" id="createLeaveForm">
                <input type="hidden" name="action" value="submit">

                <div class="modal-header border-bottom py-3 px-4">
                    <div class="d-flex align-items-center gap-3">
                        <div style="width:42px; height:42px; border-radius:12px; background:#eff6ff; color:#2563eb; display:flex; align-items:center; justify-content:center; font-size:1.35rem;">
                            <i class="bi bi-calendar-plus"></i>
                        </div>
                        <div>
                            <h5 class="modal-title fw-bold text-dark mb-0">Tạo Đơn Nghỉ Phép Mới</h5>
                            <span class="text-muted" style="font-size:0.78rem;">Điền đầy đủ thông tin để chuyển Trưởng phòng và HR phê duyệt</span>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <!-- Nhân viên xin nghỉ -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Nhân viên xin nghỉ <span class="text-danger">*</span></label>
                            <c:choose>
                                <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager}">
                                    <input type="hidden" name="employeeId" value="${sessionScope.currentUser.employeeId}">
                                    <input type="text" class="form-control" value="${sessionScope.currentUser.fullName} (${sessionScope.currentUser.username})" readonly style="background:#f1f5f9;">
                                </c:when>
                                <c:otherwise>
                                    <select name="employeeId" class="form-select" required>
                                        <c:forEach var="e" items="${employees}">
                                            <option value="${e.id}" ${e.id == sessionScope.currentUser.employeeId ? 'selected' : ''}>
                                                ${e.fullName} (${e.employeeCode}) - ${e.departmentName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Loại nghỉ phép -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Loại nghỉ phép <span class="text-danger">*</span></label>
                            <select name="leaveType" class="form-select" required>
                                <option value="ANNUAL">Phép năm thường niên (Hưởng 100% lương)</option>
                                <option value="SICK">Nghỉ ốm đau / BHYT (Hưởng chế độ BHXH)</option>
                                <option value="WEDDING">Nghỉ cưới hỏi cá nhân (Chế độ 3 ngày có lương)</option>
                                <option value="PERSONAL">Nghỉ việc riêng có lương</option>
                                <option value="MATERNITY">Chế độ Thai sản</option>
                                <option value="UNPAID">Nghỉ không hưởng lương</option>
                            </select>
                        </div>

                        <!-- Từ ngày -->
                        <div class="col-md-4">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Từ ngày <span class="text-danger">*</span></label>
                            <input type="date" name="startDate" id="leaveStartDate" class="form-control" value="2026-09-28" required onchange="calculateLeaveDays();">
                        </div>

                        <!-- Đến ngày -->
                        <div class="col-md-4">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Đến ngày <span class="text-danger">*</span></label>
                            <input type="date" name="endDate" id="leaveEndDate" class="form-control" value="2026-09-30" required onchange="calculateLeaveDays();">
                        </div>

                        <!-- Số ngày nghỉ -->
                        <div class="col-md-4">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Số ngày nghỉ tính toán</label>
                            <input type="number" step="0.5" name="days" id="leaveDaysCalculated" class="form-control" value="2.5" required>
                        </div>

                        <!-- Người nhận bàn giao công việc -->
                        <div class="col-md-12">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Người nhận bàn giao công việc <span class="text-danger">*</span></label>
                            <input type="text" name="handoverPerson" class="form-control" placeholder="Họ tên người nhận bàn giao — Số điện thoại liên hệ khẩn cấp..." value="Lê Hoàng Nam — 0912.445.892 (Khẩn cấp)" required>
                        </div>

                        <!-- Lý do nghỉ phép -->
                        <div class="col-12">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Lý do xin nghỉ cụ thể <span class="text-danger">*</span></label>
                            <textarea name="reason" class="form-control" rows="3" placeholder="Ghi rõ lý do xin nghỉ phép..." required>Giải quyết việc gia đình cá nhân</textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-top py-3 px-4">
                    <button type="button" class="btn btn-light px-4 fw-bold" data-bs-dismiss="modal" style="height:38px; border:1px solid #e2e8f0;">Hủy</button>
                    <button type="submit" class="btn btn-primary px-4 fw-bold" style="height:38px; background:#2563eb; border:none;">
                        Gửi đơn xin nghỉ phép
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Shared Modal: Từ chối đơn nghỉ phép -->
<div class="modal fade" id="sharedRejectLeaveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;">
            <form method="post" action="${pageContext.request.contextPath}/leave">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="id" id="sharedRejectLeaveId" value="">
                <div class="modal-header border-bottom py-3">
                    <h6 class="modal-title fw-bold text-danger"><i class="bi bi-x-circle me-1"></i> Từ chối đơn xin nghỉ phép</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-3">
                    <p style="font-size:0.84rem;">Nhân sự: <strong id="sharedRejectLeaveName">—</strong> (<span id="sharedRejectLeaveCode">—</span>)</p>
                    <label class="form-label" style="font-size:0.8rem; font-weight:600;">Lý do từ chối *</label>
                    <textarea name="rejectReason" class="form-control" rows="3" placeholder="Nhập lý do không duyệt đơn..." required style="font-size:0.83rem;"></textarea>
                </div>
                <div class="modal-footer border-top py-2">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-sm btn-danger fw-bold">Xác nhận Từ chối</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Shared Modal: Xem chi tiết đơn nghỉ phép -->
<div class="modal fade" id="sharedViewLeaveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;">
            <div class="modal-header border-bottom py-3">
                <h6 class="modal-title fw-bold text-dark"><i class="bi bi-calendar-check text-primary me-1"></i> Chi tiết đơn nghỉ phép <span id="sharedViewLeaveCode">—</span></h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-3" style="font-size:0.84rem;">
                <div class="mb-2"><strong>Nhân sự:</strong> <span id="sharedViewLeaveEmp">—</span></div>
                <div class="mb-2"><strong>Loại nghỉ phép:</strong> <span id="sharedViewLeaveType">—</span></div>
                <div class="mb-2"><strong>Thời gian nghỉ:</strong> <span id="sharedViewLeaveDates">—</span></div>
                <div class="mb-2"><strong>Lý do xin nghỉ:</strong> <span id="sharedViewLeaveReason">—</span></div>
                <div class="mb-2"><strong>Người nhận bàn giao:</strong> <span id="sharedViewLeaveHandover">—</span></div>
                <div class="p-2 bg-light rounded mt-3">
                    <div>• Trạng thái quản lý (TP): <strong id="sharedViewLeaveMgr">—</strong></div>
                    <div>• Trạng thái nhân sự (HR): <strong id="sharedViewLeaveHr">—</strong></div>
                    <div>• Kết luận: <strong id="sharedViewLeaveStatus">—</strong></div>
                </div>
            </div>
            <div class="modal-footer border-top py-2">
                <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
    function calculateLeaveDays() {
        const start = document.getElementById('leaveStartDate').value;
        const end = document.getElementById('leaveEndDate').value;
        if (start && end) {
            const d1 = new Date(start);
            const d2 = new Date(end);
            if (d2 >= d1) {
                const diffTime = Math.abs(d2 - d1);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
                document.getElementById('leaveDaysCalculated').value = diffDays;
            }
        }
    }

    function openRejectLeaveModal(id, name, code) {
        document.getElementById('sharedRejectLeaveId').value = id;
        document.getElementById('sharedRejectLeaveName').textContent = name;
        document.getElementById('sharedRejectLeaveCode').textContent = code;
        var modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('sharedRejectLeaveModal'));
        modal.show();
    }

    function openViewLeaveModal(btn) {
        document.getElementById('sharedViewLeaveCode').textContent = btn.getAttribute('data-code') || '';
        document.getElementById('sharedViewLeaveEmp').textContent = (btn.getAttribute('data-name') || '') + ' (' + (btn.getAttribute('data-empcode') || '') + ') • ' + (btn.getAttribute('data-dept') || '');
        document.getElementById('sharedViewLeaveType').textContent = btn.getAttribute('data-type') || '';
        document.getElementById('sharedViewLeaveDates').textContent = btn.getAttribute('data-dates') || '';
        document.getElementById('sharedViewLeaveReason').textContent = btn.getAttribute('data-reason') || '';
        document.getElementById('sharedViewLeaveHandover').textContent = btn.getAttribute('data-handover') || '—';
        document.getElementById('sharedViewLeaveMgr').textContent = btn.getAttribute('data-mgr') || '—';
        document.getElementById('sharedViewLeaveHr').textContent = btn.getAttribute('data-hr') || '—';
        document.getElementById('sharedViewLeaveStatus').textContent = btn.getAttribute('data-status') || '—';
        var modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('sharedViewLeaveModal'));
        modal.show();
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>

