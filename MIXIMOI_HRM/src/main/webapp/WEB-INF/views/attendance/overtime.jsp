<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Tăng ca &amp; Làm thêm giờ (OT) — MIXIMOI HRM &amp; PAYROLL</title>
    <meta name="description" content="Theo dõi, phê duyệt và thống kê khối lượng giờ làm thêm của nhân viên theo dự án và ca làm việc">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        /* ===== OVERTIME PAGE SPECIFIC STYLES ===== */

        .ot-header-bar {
            display: flex; align-items: flex-start; justify-content: space-between;
            flex-wrap: wrap; gap: 1.25rem; margin-bottom: 1.35rem;
        }
        .ot-title { font-size: 1.55rem; font-weight: 800; color: #0f172a; margin-bottom: 4px; letter-spacing: -0.5px; }
        .ot-subtitle { font-size: 0.86rem; color: #64748b; margin: 0; }

        .cycle-badge {
            display: inline-flex; align-items: center; gap: 6px;
            background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
            border-radius: 999px; padding: 2px 10px; font-size: 0.74rem; font-weight: 700;
        }

        .btn-ot-new {
            height: 38px; background: #2563eb; color: #fff; border: 1px solid #2563eb;
            border-radius: 9px; padding: 0 1.15rem; font-size: 0.84rem; font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px; cursor: pointer;
            box-shadow: 0 2px 6px rgba(37,99,235,0.25); text-decoration: none; transition: all 0.15s;
        }
        .btn-ot-new:hover { background: #1d4ed8; color: #fff; transform: translateY(-1px); }

        /* KPI Cards */
        .ot-kpi-grid {
            display: grid; grid-template-columns: repeat(4, 1fr);
            gap: 1rem; margin-bottom: 1.35rem;
        }
        .ot-kpi-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            padding: 1.15rem 1.25rem; box-shadow: 0 2px 10px rgba(15,23,42,0.03);
            display: flex; flex-direction: column; justify-content: space-between; min-height: 140px;
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .ot-kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(15,23,42,0.06); }
        .okpi-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.5rem; }
        .okpi-label { font-size: 0.73rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }
        .okpi-icon {
            width: 34px; height: 34px; border-radius: 9px; display: flex;
            align-items: center; justify-content: center; font-size: 1.05rem;
        }
        .okpi-icon.blue   { background: #eff6ff; color: #2563eb; }
        .okpi-icon.amber  { background: #fffbeb; color: #d97706; }
        .okpi-icon.violet { background: #f5f3ff; color: #7c3aed; }
        
        .okpi-val-row { display: flex; align-items: baseline; gap: 6px; margin-bottom: 0.35rem; }
        .okpi-val { font-size: 1.7rem; font-weight: 800; color: #0f172a; line-height: 1; }
        .okpi-sub { font-size: 0.77rem; color: #64748b; line-height: 1.35; }

        /* Tabs Navigation */
        .ot-tab-nav {
            display: flex; align-items: center; gap: 6px; flex-wrap: wrap;
            margin-bottom: 1.15rem;
        }
        .ot-tab-item {
            padding: 7px 14px; border-radius: 9px; font-size: 0.83rem; font-weight: 600;
            color: #64748b; text-decoration: none; transition: all 0.15s;
            display: inline-flex; align-items: center; gap: 6px; border: 1.5px solid transparent;
            background: #fff;
        }
        .ot-tab-item:hover { background: #f8fafc; color: #1e293b; }
        .ot-tab-item.active {
            background: #2563eb; color: #fff; border-color: #2563eb;
        }
        .ot-tab-item.active .tab-count {
            background: rgba(255,255,255,0.25); color: #fff;
        }
        .tab-count {
            display: inline-flex; align-items: center; justify-content: center;
            background: #f1f5f9; color: #64748b; font-size: 0.7rem; font-weight: 700;
            border-radius: 999px; padding: 1px 6px; min-width: 18px;
        }

        /* Filter Bar */
        .ot-filter-bar {
            background: #fff; border-radius: 12px; border: 1.5px solid #f1f5f9;
            padding: 0.75rem 1rem; margin-bottom: 1.25rem; box-shadow: 0 2px 6px rgba(15,23,42,0.02);
        }
        .ot-search-box { position: relative; }
        .ot-search-box .bi-search {
            position: absolute; left: 11px; top: 50%; transform: translateY(-50%);
            color: #94a3b8; font-size: 0.85rem;
        }
        .ot-search-input {
            width: 100%; height: 36px; border-radius: 8px; border: 1.5px solid #e2e8f0;
            padding-left: 32px; font-size: 0.82rem; background: #f8fafc;
        }
        .ot-search-input:focus { background: #fff; border-color: #2563eb; outline: none; }
        .ot-select {
            height: 36px; border-radius: 8px; border: 1.5px solid #e2e8f0; font-size: 0.82rem;
            background: #f8fafc;
        }

        /* 2-Column Layout */
        .ot-layout-grid {
            display: grid; grid-template-columns: 1fr 340px; gap: 1.35rem;
            align-items: start;
        }

        /* Table Card */
        .ot-table-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            overflow: hidden; box-shadow: 0 2px 10px rgba(15,23,42,0.03);
        }
        .ot-table { width: 100%; border-collapse: collapse; }
        .ot-table thead { background: #f8fafc; border-bottom: 2px solid #e2e8f0; }
        .ot-table thead th {
            padding: 0.75rem 1rem; font-size: 0.72rem; font-weight: 700;
            text-transform: uppercase; color: #64748b; letter-spacing: 0.4px;
        }
        .ot-table tbody tr { border-bottom: 1px solid #f1f5f9; transition: background 0.12s; }
        .ot-table tbody tr:hover { background: #f8fafc; }
        .ot-table td { padding: 1rem 1rem; vertical-align: middle; font-size: 0.84rem; }

        /* Request Row Item Details */
        .project-name-bold {
            font-size: 0.88rem; font-weight: 700; color: #0f172a; margin-bottom: 4px;
        }
        .ot-emp-meta {
            display: flex; align-items: center; gap: 7px; flex-wrap: wrap;
            font-size: 0.76rem; color: #64748b;
        }
        .ot-tag-badge {
            background: #f1f5f9; color: #475569; border-radius: 5px; padding: 1px 6px;
            font-weight: 600; font-size: 0.72rem;
        }

        /* Approver Step Flow */
        .approver-step-item {
            display: flex; align-items: center; gap: 6px; font-size: 0.76rem; margin-bottom: 3px;
        }
        .step-icon-approved { color: #2563eb; font-size: 0.9rem; }
        .step-icon-pending  { color: #64748b; font-size: 0.85rem; }
        .step-icon-rejected { color: #dc2626; font-size: 0.9rem; }

        /* Status Badges */
        .ot-status-pill {
            display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px;
            border-radius: 999px; font-size: 0.74rem; font-weight: 700; white-space: nowrap;
        }
        .ot-status-pill.pending-hr {
            background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
        }
        .ot-status-pill.pending-lead {
            background: #fffbeb; color: #d97706; border: 1px solid #fde68a;
        }
        .ot-status-pill.approved {
            background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0;
        }
        .ot-status-pill.rejected {
            background: #fef2f2; color: #dc2626; border: 1px solid #fecaca;
        }
        .ot-status-pill.paid {
            background: #f8fafc; color: #475569; border: 1px solid #e2e8f0;
        }

        .ot-actions { display: flex; align-items: center; gap: 4px; }
        .btn-act {
            width: 30px; height: 30px; border-radius: 7px; border: 1px solid #e2e8f0;
            background: #fff; color: #64748b; display: inline-flex; align-items: center; justify-content: center;
            font-size: 0.85rem; cursor: pointer; transition: all 0.15s;
        }
        .btn-act.approve:hover { background: #ecfdf5; color: #059669; border-color: #a7f3d0; }
        .btn-act.reject:hover  { background: #fef2f2; color: #dc2626; border-color: #fecaca; }
        .btn-act.view:hover    { background: #eff6ff; color: #2563eb; border-color: #bfdbfe; }

        /* Right Column Cards */
        .ot-side-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            padding: 1.25rem; box-shadow: 0 2px 10px rgba(15,23,42,0.03); margin-bottom: 1.25rem;
        }
        .side-card-header {
            display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;
        }
        .side-card-title {
            font-size: 0.94rem; font-weight: 800; color: #0f172a; display: flex; align-items: center; gap: 7px;
        }
        .side-limit-badge {
            font-size: 0.72rem; font-weight: 700; color: #64748b; background: #f1f5f9;
            border-radius: 6px; padding: 2px 6px;
        }

        /* Top OT Ranking Item */
        .rank-item-row {
            display: flex; align-items: center; gap: 10px; padding: 0.65rem 0;
            border-bottom: 1px solid #f8fafc;
        }
        .rank-num {
            font-size: 0.84rem; font-weight: 800; color: #94a3b8; font-family: monospace; width: 22px;
        }
        .rank-content { flex: 1; }
        .rank-name-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2px; }
        .rank-name { font-size: 0.83rem; font-weight: 700; color: #0f172a; }
        .rank-hours { font-size: 0.83rem; font-weight: 800; color: #0f172a; }
        .rank-hours-sub { font-size: 0.72rem; color: #94a3b8; }
        .rank-dept { font-size: 0.72rem; color: #64748b; margin-bottom: 4px; }
        
        .rank-bar-bg {
            width: 100%; height: 5px; background: #f1f5f9; border-radius: 999px; overflow: hidden;
        }
        .rank-bar-fill {
            height: 100%; border-radius: 999px; background: #2563eb;
        }
        .rank-bar-fill.near-limit {
            background: linear-gradient(90deg, #f59e0b, #ef4444);
        }
        .rank-alert-text {
            font-size: 0.7rem; font-weight: 700; color: #dc2626; margin-top: 2px; display: flex; justify-content: space-between;
        }

        /* Law Compliance Card */
        .law-card-text { font-size: 0.8rem; color: #475569; line-height: 1.4; margin-bottom: 0.85rem; }
        .law-warning-box {
            background: #fffbeb; border: 1px solid #fde68a; border-radius: 9px;
            padding: 0.65rem 0.85rem; font-size: 0.77rem; color: #92400e; margin-bottom: 0.85rem;
            display: flex; gap: 8px; align-items: flex-start;
        }
        .law-quota-box {
            background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 9px;
            padding: 0.65rem 0.85rem; font-size: 0.77rem; color: #166534;
        }

        /* Auto Approval Dark Card */
        .auto-approve-card {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            border-radius: 14px; padding: 1.25rem; color: #fff; box-shadow: 0 4px 14px rgba(15,23,42,0.12);
        }
        .auto-badge-tag {
            font-size: 0.7rem; font-weight: 700; letter-spacing: 0.5px; color: #94a3b8;
            text-transform: uppercase; margin-bottom: 4px; display: flex; align-items: center; gap: 5px;
        }
        .auto-card-title { font-size: 1.05rem; font-weight: 800; color: #fff; margin-bottom: 6px; }
        .auto-card-body { font-size: 0.78rem; color: #cbd5e1; line-height: 1.4; margin-bottom: 1rem; }
        .btn-auto-config {
            width: 100%; height: 36px; border: 1.5px solid rgba(255,255,255,0.25);
            background: rgba(255,255,255,0.08); color: #fff; border-radius: 8px;
            font-size: 0.8rem; font-weight: 600; display: flex; align-items: center; justify-content: center;
            transition: all 0.15s; text-decoration: none;
        }
        .btn-auto-config:hover { background: rgba(255,255,255,0.18); color: #fff; }

        @media (max-width: 1200px) {
            .ot-layout-grid { grid-template-columns: 1fr; }
            .ot-kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .ot-kpi-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="app-container">
    <c:set var="activeMenu" value="overtime" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'created'}">Tạo yêu cầu tăng ca mới thành công! Đã chuyển cấp Quản lý trực tiếp phê duyệt.</c:when>
                        <c:when test="${param.success eq 'lead_approved'}">Quản lý trực tiếp đã phê duyệt Cấp 1! Đơn đã được chuyển sang HR Lead.</c:when>
                        <c:when test="${param.success eq 'hr_approved'}">HR Lead đã phê duyệt Cấp 2! Yêu cầu làm thêm giờ đã hoàn tất.</c:when>
                        <c:when test="${param.success eq 'rejected'}">Đã từ chối yêu cầu tăng ca!</c:when>
                        <c:when test="${param.success eq 'exported'}">Đã xuất báo cáo tổng hợp tăng ca!</c:when>
                        <c:otherwise>Thao tác thành công!</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Page Header Bar (Role-Specific) -->
            <div class="ot-header-bar">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="cycle-badge">CHU KỲ BẢNG CÔNG Q3</span>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.accountant}">
                                <span class="badge bg-success-subtle text-success border border-success-subtle"><i class="bi bi-cash-coin me-1"></i>Chi phí OT &amp; Thanh toán</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
                                <span class="badge bg-warning-subtle text-dark border border-warning-subtle"><i class="bi bi-briefcase me-1"></i>Duyệt Cấp 1 Trưởng phòng</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                                <span class="badge bg-info-subtle text-primary border border-info-subtle"><i class="bi bi-person-circle me-1"></i>Cá nhân của tôi</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.hr}">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle"><i class="bi bi-people me-1"></i>Duyệt Cấp 2 HR &amp; Luật LĐ</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-dark text-white"><i class="bi bi-shield-lock me-1"></i>Admin Toàn quyền</span>
                            </c:otherwise>
                        </c:choose>
                        <span class="text-muted" style="font-size:0.75rem;">· Cập nhật 15 phút trước</span>
                    </div>
                    <h1 class="ot-title">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                                Theo Dõi Tăng Ca &amp; Làm Thêm Giờ Cá Nhân
                            </c:when>
                            <c:when test="${sessionScope.currentUser.accountant}">
                                Dự Toán Chi Phí Tăng Ca &amp; Quyết Toán OT
                            </c:when>
                            <c:when test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
                                Quản Lý Tăng Ca Dự Án &amp; Duyệt Cấp 1 (TP)
                            </c:when>
                            <c:otherwise>
                                Quản lý Tăng ca &amp; Làm thêm giờ (OT)
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="ot-subtitle">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.accountant}">
                                Tổng hợp chi phí tăng ca, hệ số quy đổi 150%, 200%, 300% và trạng thái chi trả cùng kỳ lương.
                            </c:when>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                                Xem tổng giờ OT cá nhân đã làm, tiền OT ước tính và đăng ký ca làm thêm giờ mới.
                            </c:when>
                            <c:otherwise>
                                Theo dõi, phê duyệt và thống kê khối lượng giờ làm thêm của nhân viên theo dự án và ca làm việc.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <!-- Month Selector -->
                    <div class="month-selector-wrap" style="background:#fff; border:1.5px solid #e2e8f0; border-radius:10px; padding:3px 6px;">
                        <a href="${pageContext.request.contextPath}/overtime?month=${selectedMonth > 1 ? selectedMonth - 1 : 12}&year=${selectedMonth > 1 ? selectedYear : selectedYear - 1}" class="month-btn-nav"><i class="bi bi-chevron-left"></i></a>
                        <span class="month-display-text" style="font-size:0.86rem; font-weight:700; color:#0f172a; padding:0 8px;">
                            <i class="bi bi-calendar3 text-primary"></i> Tháng 0${selectedMonth}/${selectedYear}
                        </span>
                        <a href="${pageContext.request.contextPath}/overtime?month=${selectedMonth < 12 ? selectedMonth + 1 : 1}&year=${selectedMonth < 12 ? selectedYear : selectedYear + 1}" class="month-btn-nav"><i class="bi bi-chevron-right"></i></a>
                    </div>

                    <!-- Nút Kế toán: Sang tính lương -->
                    <c:if test="${sessionScope.currentUser.accountant}">
                        <a href="${pageContext.request.contextPath}/payroll" class="btn-ts-outline" title="Chuyển sang Bảng lương">
                            <i class="bi bi-cash-stack text-success"></i> Chuyển sang bảng lương
                        </a>
                    </c:if>

                    <!-- Xuất báo cáo OT -->
                    <a href="${pageContext.request.contextPath}/overtime?action=export" class="btn-ts-outline">
                        <i class="bi bi-download"></i> Xuất báo cáo OT
                    </a>

                    <!-- Nút Đăng ký tăng ca mới -->
                    <button type="button" class="btn-ot-new" data-bs-toggle="modal" data-bs-target="#newOvertimeModal">
                        <i class="bi bi-plus-circle-fill"></i>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">Đăng ký tăng ca cá nhân</c:when>
                            <c:otherwise>Đăng ký tăng ca mới</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </div>

            <!-- 4 Thẻ KPI Chỉ số (Matches Screenshot 3) -->
            <div class="ot-kpi-grid">
                <!-- Card 1: Tổng giờ OT tháng -->
                <div class="ot-kpi-card">
                    <div>
                        <div class="okpi-top">
                            <span class="okpi-label">Tổng giờ OT tháng</span>
                            <div class="okpi-icon blue"><i class="bi bi-clock-history"></i></div>
                        </div>
                        <div class="okpi-val-row">
                            <span class="okpi-val">1,420</span>
                            <span style="font-size:1rem; font-weight:700; color:#64748b;">h</span>
                        </div>
                    </div>
                    <div>
                        <div class="okpi-sub">Ngân sách OT chu kỳ: <strong>88% (1,600h max)</strong></div>
                        <div class="okpi-sub text-primary fw-bold mt-1"><i class="bi bi-graph-up-arrow"></i> +4.2% so với tháng trước</div>
                    </div>
                </div>

                <!-- Card 2: Chi phí OT dự kiến -->
                <div class="ot-kpi-card">
                    <div>
                        <div class="okpi-top">
                            <span class="okpi-label">Chi phí OT dự kiến</span>
                            <div class="okpi-icon blue"><i class="bi bi-cash-stack"></i></div>
                        </div>
                        <div class="okpi-val-row">
                            <span class="okpi-val">148.500.000</span>
                            <span style="font-size:0.9rem; font-weight:700; color:#64748b;">đ</span>
                        </div>
                    </div>
                    <div>
                        <div class="okpi-sub">Hệ số bình quân: <strong>1.72x</strong></div>
                        <div class="okpi-sub mt-1" style="font-size:0.73rem;">Quy đổi 150%, 200%, 300% theo Bộ luật Lao Động</div>
                    </div>
                </div>

                <!-- Card 3: Đơn chờ phê duyệt -->
                <div class="ot-kpi-card">
                    <div>
                        <div class="okpi-top">
                            <span class="okpi-label">Đơn chờ phê duyệt</span>
                            <div class="okpi-icon amber"><i class="bi bi-clipboard2-pulse"></i></div>
                        </div>
                        <div class="okpi-val-row">
                            <span class="okpi-val text-dark">18</span>
                            <span class="badge bg-danger text-white ms-1" style="font-size:0.68rem;">KHẨN CẤP</span>
                        </div>
                    </div>
                    <div class="okpi-sub text-danger fw-bold">
                        <i class="bi bi-clock me-1"></i> Yêu cầu duyệt cấp 1 &amp; HR trước 24h
                    </div>
                </div>

                <!-- Card 4: Điểm nóng OT (DEPT) -->
                <div class="ot-kpi-card">
                    <div>
                        <div class="okpi-top">
                            <span class="okpi-label">Điểm nóng OT (DEPT)</span>
                            <div class="okpi-icon blue"><i class="bi bi-diagram-3-fill"></i></div>
                        </div>
                        <div class="okpi-val-row">
                            <span class="okpi-val" style="font-size:1.25rem;">CNTT &amp; Sản phẩm</span>
                        </div>
                    </div>
                    <div>
                        <div class="okpi-sub">Tỷ trọng toàn công ty: <strong>45% tổng OT</strong></div>
                        <div class="okpi-sub mt-1" style="font-size:0.73rem;">Dự án: <strong>Core Banking v4.2</strong></div>
                    </div>
                </div>
            </div>

            <!-- Tabs Điều Hướng (Matches Screenshot 3) -->
            <div class="ot-tab-nav">
                <a href="${pageContext.request.contextPath}/overtime?tab=all" class="ot-tab-item ${activeTab eq 'all' ? 'active' : ''}">
                    Tất cả yêu cầu <span class="tab-count">${counts['all']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/overtime?tab=pending_manager" class="ot-tab-item ${activeTab eq 'pending_manager' ? 'active' : ''}">
                    Chờ quản lý duyệt <span class="tab-count">${counts['pending_manager']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/overtime?tab=pending_hr" class="ot-tab-item ${activeTab eq 'pending_hr' ? 'active' : ''}">
                    Chờ HR duyệt <span class="tab-count">${counts['pending_hr']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/overtime?tab=approved" class="ot-tab-item ${activeTab eq 'approved' ? 'active' : ''}">
                    Đã phê duyệt <span class="tab-count">${counts['approved']}</span>
                </a>
                <a href="${pageContext.request.contextPath}/overtime?tab=rejected" class="ot-tab-item ${activeTab eq 'rejected' ? 'active' : ''}">
                    Từ chối <span class="tab-count">${counts['rejected']}</span>
                </a>
            </div>

            <!-- Thanh lọc (Filter Bar) -->
            <div class="ot-filter-bar">
                <form method="get" action="${pageContext.request.contextPath}/overtime" id="otFilterForm">
                    <input type="hidden" name="tab" value="${activeTab}">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-3">
                            <div class="ot-search-box">
                                <i class="bi bi-search"></i>
                                <input type="text" name="keyword" class="ot-search-input" placeholder="Tìm theo tên, mã NV, dự án..." value="${keyword}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select name="departmentId" class="form-select ot-select" onchange="document.getElementById('otFilterForm').submit();">
                                <option value="">Tất cả phòng ban</option>
                                <c:forEach var="d" items="${departments}">
                                    <option value="${d.id}" ${selectedDeptId == d.id ? 'selected' : ''}>${d.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select name="otType" class="form-select ot-select" onchange="document.getElementById('otFilterForm').submit();">
                                <option value="">Tất cả loại OT</option>
                                <option value="REGULAR" ${selectedOtType eq 'REGULAR' ? 'selected' : ''}>Ngày thường (Hệ số 150%)</option>
                                <option value="WEEKEND" ${selectedOtType eq 'WEEKEND' ? 'selected' : ''}>Cuối tuần (Hệ số 200%)</option>
                                <option value="HOLIDAY" ${selectedOtType eq 'HOLIDAY' ? 'selected' : ''}>Ngày lễ Tết (Hệ số 300%)</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select name="project" class="form-select ot-select" onchange="document.getElementById('otFilterForm').submit();">
                                <option value="">Tất cả dự án</option>
                                <option value="Core Banking">Core Banking v4.2</option>
                                <option value="Design System">Design System v3</option>
                                <option value="Database">Database cluster</option>
                                <option value="VIP">Khách hàng VIP</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Bố cục 2 Cột (2-Column Layout) -->
            <div class="ot-layout-grid">
                
                <!-- CỘT TRÁI: BẢNG DANH SÁCH ĐƠN OT -->
                <div>
                    <div class="ot-table-card">
                        <table class="ot-table">
                            <thead>
                                <tr>
                                    <th>Dự án / Nhân viên</th>
                                    <th style="width:180px;">Cấp duyệt</th>
                                    <th style="width:130px; text-align:center;">Trạng thái</th>
                                    <th style="width:90px; text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty overtimes}">
                                        <tr>
                                            <td colspan="4" class="text-center py-5 text-muted">
                                                <i class="bi bi-clock-history" style="font-size:2.5rem; display:block; margin-bottom:0.5rem; color:#cbd5e1;"></i>
                                                Không có yêu cầu tăng ca nào trong mục này
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="ot" items="${overtimes}">
                                            <tr>
                                                <!-- Dự án / Nhân viên -->
                                                <td>
                                                    <div class="project-name-bold">${ot.projectName}</div>
                                                    <div class="ot-emp-meta mb-1">
                                                        <span class="fw-bold text-dark">${ot.employeeName}</span>
                                                        <span>(${ot.employeeCode})</span>
                                                        <span>·</span>
                                                        <span>${ot.departmentName}</span>
                                                    </div>
                                                    <div class="ot-emp-meta">
                                                        <span class="ot-tag-badge">${ot.overtimeDate}</span>
                                                        <span class="ot-tag-badge">${ot.startTime} - ${ot.endTime} (<strong>${ot.hours}h</strong>)</span>
                                                        <span class="ot-tag-badge" style="color:#2563eb;">${ot.otTypeDisplay}</span>
                                                    </div>
                                                    <c:if test="${not empty ot.reason}">
                                                        <div class="text-muted mt-1" style="font-size:0.75rem; font-style:italic;">
                                                            <i class="bi bi-chat-left-text me-1"></i> "${ot.reason}"
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty ot.rejectReason}">
                                                        <div class="text-danger mt-1" style="font-size:0.74rem;">
                                                            <i class="bi bi-x-circle me-1"></i> Lý do từ chối: "${ot.rejectReason}"
                                                        </div>
                                                    </c:if>
                                                </td>

                                                <!-- Cấp duyệt (2 cấp) -->
                                                <td>
                                                    <!-- Cấp 1: Lead duyệt -->
                                                    <div class="approver-step-item">
                                                        <c:choose>
                                                            <c:when test="${ot.leadStatus eq 'APPROVED'}">
                                                                <i class="bi bi-check-circle-fill step-icon-approved"></i>
                                                                <span class="text-dark fw-bold">${ot.leadApproverName}</span>
                                                            </c:when>
                                                            <c:when test="${ot.leadStatus eq 'REJECTED'}">
                                                                <i class="bi bi-x-circle-fill step-icon-rejected"></i>
                                                                <span class="text-danger">${ot.leadApproverName}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="bi bi-hourglass step-icon-pending"></i>
                                                                <span class="text-muted">${ot.leadApproverName != null ? ot.leadApproverName : 'Chờ Lead duyệt'}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <!-- Cấp 2: HR duyệt -->
                                                    <div class="approver-step-item">
                                                        <c:choose>
                                                            <c:when test="${ot.hrStatus eq 'APPROVED'}">
                                                                <i class="bi bi-check-circle-fill step-icon-approved"></i>
                                                                <span class="text-dark fw-bold">${ot.approvedByName}</span>
                                                            </c:when>
                                                            <c:when test="${ot.hrStatus eq 'REJECTED'}">
                                                                <i class="bi bi-x-circle-fill step-icon-rejected"></i>
                                                                <span class="text-danger">HR Từ chối</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="bi bi-hourglass step-icon-pending"></i>
                                                                <span class="text-muted">HR Lead (Chờ)</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>

                                                <!-- Trạng thái -->
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${ot.status eq 'PENDING_LEAD'}">
                                                            <span class="ot-status-pill pending-lead">Chờ duyệt cấp 1</span>
                                                        </c:when>
                                                        <c:when test="${ot.status eq 'PENDING_HR'}">
                                                            <span class="ot-status-pill pending-hr">Chờ duyệt cấp 2</span>
                                                        </c:when>
                                                        <c:when test="${ot.status eq 'APPROVED'}">
                                                            <span class="ot-status-pill approved">Đã phê duyệt</span>
                                                        </c:when>
                                                        <c:when test="${ot.status eq 'PAID' or ot.paid}">
                                                            <span class="ot-status-pill paid">Đã thanh toán</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="ot-status-pill rejected">Từ chối</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Thao tác Phân quyền theo Role -->
                                                <td>
                                                    <div class="ot-actions justify-content-center">
                                                        <!-- Phê duyệt Cấp 1: Manager & Admin -->
                                                        <c:if test="${(sessionScope.currentUser.manager or sessionScope.currentUser.admin) and ot.status eq 'PENDING_LEAD'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/overtime" class="d-inline">
                                                                <input type="hidden" name="action" value="approve_lead">
                                                                <input type="hidden" name="id" value="${ot.id}">
                                                                <button type="submit" class="btn-act approve" title="Phê duyệt Cấp 1 (Lead)">
                                                                    <i class="bi bi-check-lg"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>

                                                        <!-- Phê duyệt Cấp 2: HR & Admin -->
                                                        <c:if test="${(sessionScope.currentUser.hr or sessionScope.currentUser.admin) and ot.status eq 'PENDING_HR'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/overtime" class="d-inline">
                                                                <input type="hidden" name="action" value="approve_hr">
                                                                <input type="hidden" name="id" value="${ot.id}">
                                                                <button type="submit" class="btn-act approve" title="Phê duyệt Cấp 2 (HR Lead)">
                                                                    <i class="bi bi-check-lg"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>

                                                        <!-- Từ chối đơn: Manager, HR, Admin -->
                                                        <c:if test="${(sessionScope.currentUser.manager or sessionScope.currentUser.hr or sessionScope.currentUser.admin) and (ot.status eq 'PENDING_LEAD' or ot.status eq 'PENDING_HR')}">
                                                            <button type="button" class="btn-act reject" title="Từ chối đơn OT"
                                                                    onclick="openRejectOtModal('${ot.id}', '${ot.employeeName}', '${ot.projectName}')">
                                                                <i class="bi bi-x-lg"></i>
                                                            </button>
                                                        </c:if>

                                                        <!-- Xem chi tiết modal -->
                                                        <button type="button" class="btn-act view" title="Xem chi tiết đơn"
                                                                onclick="openViewOtModal(this)"
                                                                data-project="${ot.projectName}"
                                                                data-emp="${ot.employeeName} (${ot.employeeCode}) · ${ot.departmentName}"
                                                                data-date="${ot.overtimeDate} (${ot.startTime} - ${ot.endTime})"
                                                                data-hours="${ot.hours} giờ (Hệ số: ${ot.coefficient}x)"
                                                                data-amount="${ot.amount} đ"
                                                                data-reason="${ot.reason}"
                                                                data-lead="${ot.leadApproverName} - ${ot.leadStatus}"
                                                                data-hr="${ot.approvedByName} - ${ot.hrStatus}">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>




                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <!-- Phân trang Table footer (Server-Side) -->
                        <div class="ts-table-footer">
                            <div>
                                Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong>
                                – <strong>${(currentPage - 1) * pageSize + overtimes.size()}</strong>
                                trên tổng số <strong>${totalRecords}</strong> yêu cầu tăng ca
                            </div>
                            <div class="d-flex align-items-center gap-1">
                                <a href="${pageContext.request.contextPath}/overtime?tab=${activeTab}&month=${selectedMonth}&year=${selectedYear}&page=${currentPage - 1}"
                                   class="btn btn-sm btn-outline-light text-muted border py-1 px-2 ${currentPage <= 1 ? 'disabled' : ''}">Trước</a>
                                <c:forEach var="p" begin="1" end="${totalPages}">
                                    <a href="${pageContext.request.contextPath}/overtime?tab=${activeTab}&month=${selectedMonth}&year=${selectedYear}&page=${p}"
                                       class="btn btn-sm py-1 px-2 fw-bold ${p == currentPage ? 'btn-primary' : 'btn-outline-light text-dark border'}">${p}</a>
                                </c:forEach>
                                <a href="${pageContext.request.contextPath}/overtime?tab=${activeTab}&month=${selectedMonth}&year=${selectedYear}&page=${currentPage + 1}"
                                   class="btn btn-sm btn-outline-light text-dark border py-1 px-2 ${currentPage >= totalPages ? 'disabled' : ''}">Sau</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CỘT PHẢI: 3 WIDGET PHÂN TÍCH & TUÂN THỦ (Matches Screenshot 3) -->
                <div>
                    <!-- Widget 1: Top nhân sự OT tháng -->
                    <div class="ot-side-card">
                        <div class="side-card-header">
                            <span class="side-card-title"><i class="bi bi-bar-chart-fill text-primary"></i> Top nhân sự OT tháng</span>
                            <span class="side-limit-badge">GIỚI HẠN 40H/THÁNG</span>
                        </div>

                        <c:forEach var="top" items="${topEmployees}">
                            <div class="rank-item-row">
                                <span class="rank-num">${top.rank}</span>
                                <div class="rank-content">
                                    <div class="rank-name-row">
                                        <span class="rank-name">${top.name}</span>
                                        <span class="rank-hours">${top.hours}h <span class="rank-hours-sub">/ 40h max</span></span>
                                    </div>
                                    <div class="rank-dept">${top.dept}</div>
                                    <div class="rank-bar-bg">
                                        <div class="rank-bar-fill ${top.isNearLimit ? 'near-limit' : ''}" style="width: ${top.percent}%;"></div>
                                    </div>
                                    <c:if test="${top.isNearLimit}">
                                        <div class="rank-alert-text">
                                            <span>Cận hạn mức (${top.percent}%)</span>
                                            <span>Còn ${top.remaining}h</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not top.isNearLimit}">
                                        <div class="d-flex justify-content-between text-muted" style="font-size:0.7rem; margin-top:2px;">
                                            <span>${top.percent}% mức trần</span>
                                            <span>Còn ${top.remaining}h</span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Widget 2: Cảnh báo tuân thủ Luật LĐ (Matches Screenshot 5) -->
                    <div class="ot-side-card">
                        <div class="side-card-header mb-2">
                            <span class="side-card-title text-danger"><i class="bi bi-shield-exclamation"></i> Cảnh báo tuân thủ Luật LĐ</span>
                        </div>
                        <p class="law-card-text">
                            Theo <strong>Điều 107 Bộ luật Lao động 2019</strong>: Tối đa <strong>40 giờ/tháng</strong> và không quá <strong>200 giờ/năm</strong> (trường hợp đặc biệt tối đa 300 giờ).
                        </p>

                        <div class="law-warning-box">
                            <i class="bi bi-exclamation-triangle-fill text-warning fs-5"></i>
                            <div>
                                <strong>3 nhân sự vượt 85% hạn mức tháng</strong>. Hệ thống sẽ khóa tạo đơn tự động nếu nhân sự đạt đủ 40h trong kỳ lương này.
                            </div>
                        </div>

                        <div class="law-quota-box">
                            <div class="d-flex align-items-center justify-content-between mb-1">
                                <span class="fw-bold"><i class="bi bi-shield-check me-1"></i> Hạn ngạch lũy kế năm 2026</span>
                            </div>
                            <div class="d-flex justify-content-between mb-1" style="font-size:0.75rem;">
                                <span>Toàn công ty: <strong>124h / 200h</strong></span>
                                <span class="fw-bold">62%</span>
                            </div>
                            <div class="rank-bar-bg" style="height:6px;">
                                <div class="rank-bar-fill" style="width:62%; background:#166534;"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Widget 3: Quy trình duyệt tự động (Dark Card - Matches Screenshot 5) -->
                    <div class="auto-approve-card">
                        <div class="auto-badge-tag">
                            <span>QUY TRÌNH DUYỆT TỰ ĐỘNG</span>
                            <i class="bi bi-lightning-charge-fill text-warning"></i>
                        </div>
                        <h4 class="auto-card-title">Chính sách OT Thông minh</h4>
                        <p class="auto-card-body">
                            Đơn làm ngoài giờ dưới 2 giờ vào ngày thường tự động thông qua cấp quản lý trực tiếp nếu có gắn mã Task Jira hợp lệ.
                        </p>
                        <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
                            <button type="button" class="btn-auto-config" onclick="alert('Mở cấu hình luồng duyệt OT tự động cho HR & Admin.');">
                                Cấu hình luồng duyệt OT
                            </button>
                        </c:if>
                        <c:if test="${not (sessionScope.currentUser.admin or sessionScope.currentUser.hr)}">
                            <div class="text-muted" style="font-size:0.75rem;">Áp dụng tự động toàn hệ thống</div>
                        </c:if>
                    </div>

                </div>
            </div>

        </div>
    </main>
</div>

<!-- ============================================================
     MODAL ĐĂNG KÝ TĂNG CA MỚI (Matches Screenshot 4)
     ============================================================ -->
<div class="modal fade" id="newOvertimeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg" style="border-radius:18px;">
            <form method="post" action="${pageContext.request.contextPath}/overtime" id="newOtForm">
                <input type="hidden" name="action" value="create">

                <!-- Modal Header -->
                <div class="modal-header border-bottom py-3 px-4">
                    <div class="d-flex align-items-center gap-3">
                        <div style="width:42px; height:42px; border-radius:12px; background:#eff6ff; color:#2563eb; display:flex; align-items:center; justify-content:center; font-size:1.35rem;">
                            <i class="bi bi-stopwatch"></i>
                        </div>
                        <div>
                            <h5 class="modal-title fw-bold text-dark mb-0">Đăng ký Tăng ca Mới</h5>
                            <span class="text-muted" style="font-size:0.78rem;">Điền đầy đủ thông tin để chuyển cấp quản lý và HR phê duyệt</span>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <!-- Modal Body -->
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <!-- Nhân viên tăng ca -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Nhân viên tăng ca <span class="text-danger">*</span></label>
                            <c:choose>
                                <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager}">
                                    <!-- Nhân viên chỉ đăng ký cho chính mình -->
                                    <input type="hidden" name="employeeId" value="${sessionScope.currentUser.employeeId}">
                                    <input type="text" class="form-control" value="${sessionScope.currentUser.fullName} (${sessionScope.currentUser.username})" readonly style="background:#f1f5f9;">
                                </c:when>
                                <c:otherwise>
                                    <select name="employeeId" class="form-select" required>
                                        <c:forEach var="emp" items="${employees}">
                                            <option value="${emp.id}" ${emp.id == sessionScope.currentUser.employeeId ? 'selected' : ''}>
                                                ${emp.fullName} (${emp.employeeCode}) - ${emp.departmentName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Dự án liên quan -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Dự án liên quan <span class="text-danger">*</span></label>
                            <select name="projectName" class="form-select" required>
                                <option value="Core Banking v4.2">Core Banking v4.2</option>
                                <option value="Design System v3 &amp; Mobile UI">Design System v3 &amp; Mobile UI</option>
                                <option value="CRM B2B Enterprise v2">CRM B2B Enterprise v2</option>
                                <option value="Hạ tầng Cloud &amp; DevOps">Hạ tầng Cloud &amp; DevOps</option>
                                <option value="Hỗ trợ khách hàng VIP sau giờ làm việc">Hỗ trợ khách hàng VIP sau giờ làm việc</option>
                            </select>
                        </div>

                        <!-- Ngày làm thêm -->
                        <div class="col-md-4">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Ngày làm thêm <span class="text-danger">*</span></label>
                            <input type="date" name="overtimeDate" class="form-control" value="2026-09-23" required>
                        </div>

                        <!-- Từ giờ -->
                        <div class="col-md-4">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Từ giờ <span class="text-danger">*</span></label>
                            <input type="time" name="startTime" id="otStartTime" class="form-control" value="18:00" required onchange="calculateOtHours();">
                        </div>

                        <!-- Đến giờ -->
                        <div class="col-md-4">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Đến giờ <span class="text-danger">*</span></label>
                            <input type="time" name="endTime" id="otEndTime" class="form-control" value="21:30" required onchange="calculateOtHours();">
                        </div>

                        <!-- Loại hình tăng ca -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Loại hình tăng ca <span class="text-danger">*</span></label>
                            <select name="coefficient" id="otCoefficient" class="form-select" required onchange="calculateOtHours();">
                                <option value="1.5" selected>Ngày thường (Hệ số 150%)</option>
                                <option value="2.0">Ngày nghỉ cuối tuần (Hệ số 200%)</option>
                                <option value="3.0">Ngày Lễ Tết (Hệ số 300%)</option>
                            </select>
                        </div>

                        <!-- Người phê duyệt cấp 1 (Lead) -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Người phê duyệt cấp 1 (Lead) <span class="text-danger">*</span></label>
                            <select name="leadApproverName" class="form-select" required>
                                <option value="Trần Tuấn Hưng (CTO)">Trần Tuấn Hưng (CTO)</option>
                                <option value="Trịnh Lan Anh (Lead)">Trịnh Lan Anh (Lead)</option>
                                <option value="Nguyễn Văn An (Trưởng phòng)">Nguyễn Văn An (Trưởng phòng)</option>
                            </select>
                        </div>

                        <!-- Lý do & Đầu việc cụ thể -->
                        <div class="col-12">
                            <label class="form-label fw-bold" style="font-size:0.83rem;">Lý do &amp; Đầu việc cụ thể <span class="text-danger">*</span></label>
                            <textarea name="reason" class="form-control" rows="3" placeholder="Mô tả chi tiết mục tiêu làm thêm giờ và task ID liên quan..." required></textarea>
                        </div>

                        <!-- Real-time calculation banner (Matches Screenshot 4) -->
                        <div class="col-12">
                            <div class="p-3 bg-light rounded-3 d-flex align-items-center justify-content-between border" style="font-size:0.85rem;">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-calculator text-primary fs-5"></i>
                                    <span>Tổng giờ OT tính toán: <strong id="calcHoursDisplay" class="text-primary fs-6">3.5</strong> giờ</span>
                                </div>
                                <div>
                                    <span>Hệ số áp dụng: <strong id="calcCoeffDisplay" class="text-dark">1.5x</strong></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal Footer -->
                <div class="modal-footer border-top py-3 px-4">
                    <button type="button" class="btn btn-light px-4 fw-bold" data-bs-dismiss="modal" style="height:38px; border:1px solid #e2e8f0;">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary px-4 fw-bold" style="height:38px; background:#2563eb; border:none;">
                        Gửi yêu cầu phê duyệt
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Shared Modal: Từ chối đơn OT -->
<div class="modal fade" id="sharedRejectOtModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;">
            <form method="post" action="${pageContext.request.contextPath}/overtime">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="id" id="sharedRejectOtId" value="">
                <div class="modal-header border-bottom py-3">
                    <h6 class="modal-title fw-bold text-danger"><i class="bi bi-x-circle me-1"></i> Từ chối yêu cầu tăng ca</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-3">
                    <p style="font-size:0.84rem;">Nhân sự: <strong id="sharedRejectOtEmp">—</strong> — Dự án: <strong id="sharedRejectOtProj">—</strong></p>
                    <label class="form-label" style="font-size:0.8rem; font-weight:600;">Lý do từ chối *</label>
                    <textarea name="rejectReason" class="form-control" rows="3" placeholder="Nhập lý do không duyệt đơn tăng ca..." required style="font-size:0.83rem;"></textarea>
                </div>
                <div class="modal-footer border-top py-2">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-sm btn-danger fw-bold">Xác nhận Từ chối</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Shared Modal: Xem chi tiết đơn OT -->
<div class="modal fade" id="sharedViewOtModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;">
            <div class="modal-header border-bottom py-3">
                <h6 class="modal-title fw-bold text-dark"><i class="bi bi-file-earmark-text text-primary me-1"></i> Chi tiết đơn tăng ca</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-3" style="font-size:0.83rem;">
                <div class="mb-2"><strong>Dự án:</strong> <span id="sharedViewOtProj">—</span></div>
                <div class="mb-2"><strong>Nhân sự:</strong> <span id="sharedViewOtEmp">—</span></div>
                <div class="mb-2"><strong>Ngày thực hiện:</strong> <span id="sharedViewOtDate">—</span></div>
                <div class="mb-2"><strong>Tổng số giờ:</strong> <span class="text-primary fw-bold" id="sharedViewOtHours">—</span></div>
                <div class="mb-2"><strong>Tiền tăng ca dự kiến:</strong> <span class="text-success fw-bold" id="sharedViewOtAmount">—</span></div>
                <div class="mb-2"><strong>Lý do &amp; Công việc:</strong> <span id="sharedViewOtReason">—</span></div>
                <div class="p-2 bg-light rounded mt-3">
                    <div class="fw-bold mb-1">Tiến độ phê duyệt:</div>
                    <div>• Cấp 1 (Lead): <strong id="sharedViewOtLead">—</strong></div>
                    <div>• Cấp 2 (HR): <strong id="sharedViewOtHr">—</strong></div>
                </div>
            </div>
            <div class="modal-footer border-top py-2">
                <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
    function calculateOtHours() {
        const start = document.getElementById('otStartTime').value;
        const end = document.getElementById('otEndTime').value;
        const coeff = document.getElementById('otCoefficient').value;

        if (start && end) {
            const [sh, sm] = start.split(':').map(Number);
            const [eh, em] = end.split(':').map(Number);
            let sMinutes = sh * 60 + sm;
            let eMinutes = eh * 60 + em;
            if (eMinutes < sMinutes) eMinutes += 24 * 60; // qua đêm
            const diffHours = Math.max(0.5, Math.round(((eMinutes - sMinutes) / 60.0) * 10) / 10);
            document.getElementById('calcHoursDisplay').innerText = diffHours;
        }
        document.getElementById('calcCoeffDisplay').innerText = coeff + 'x';
    }

    function openRejectOtModal(id, name, project) {
        document.getElementById('sharedRejectOtId').value = id;
        document.getElementById('sharedRejectOtEmp').textContent = name;
        document.getElementById('sharedRejectOtProj').textContent = project;
        var modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('sharedRejectOtModal'));
        modal.show();
    }

    function openViewOtModal(btn) {
        document.getElementById('sharedViewOtProj').textContent = btn.getAttribute('data-project') || '—';
        document.getElementById('sharedViewOtEmp').textContent = btn.getAttribute('data-emp') || '—';
        document.getElementById('sharedViewOtDate').textContent = btn.getAttribute('data-date') || '—';
        document.getElementById('sharedViewOtHours').textContent = btn.getAttribute('data-hours') || '—';
        document.getElementById('sharedViewOtAmount').textContent = btn.getAttribute('data-amount') || '—';
        document.getElementById('sharedViewOtReason').textContent = btn.getAttribute('data-reason') || '—';
        document.getElementById('sharedViewOtLead').textContent = btn.getAttribute('data-lead') || '—';
        document.getElementById('sharedViewOtHr').textContent = btn.getAttribute('data-hr') || '—';
        var modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('sharedViewOtModal'));
        modal.show();
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
