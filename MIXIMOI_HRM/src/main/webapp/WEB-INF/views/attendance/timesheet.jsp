<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Bảng công &amp; Chấm công tháng — MIXIMOI HRM &amp; PAYROLL</title>
    <meta name="description" content="Bảng tổng hợp ngày công, giờ làm việc thực tế, đi muộn/về sớm và chốt công kỳ quyết toán">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        /* ===== TIMESHEET PAGE SPECIFIC STYLES ===== */

        /* Header Bar */
        .ts-header-bar {
            display: flex; align-items: flex-start; justify-content: space-between;
            flex-wrap: wrap; gap: 1.25rem; margin-bottom: 1.5rem;
        }
        .ts-title {
            font-size: 1.55rem; font-weight: 800; color: #0f172a; margin-bottom: 4px;
            letter-spacing: -0.5px;
        }
        .ts-subtitle { font-size: 0.86rem; color: #64748b; margin: 0; }
        
        .settlement-badge {
            display: inline-flex; align-items: center; gap: 6px;
            background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
            border-radius: 999px; padding: 2px 10px; font-size: 0.75rem; font-weight: 700;
        }
        .settlement-badge.locked {
            background: #f1f5f9; color: #475569; border-color: #cbd5e1;
        }
        .pulse-dot {
            width: 7px; height: 7px; border-radius: 50%; background: #2563eb;
            animation: pulse-blue 1.5s infinite;
        }
        @keyframes pulse-blue {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(1.3); }
        }

        /* Top Action Buttons */
        .ts-actions-group { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
        .month-selector-wrap {
            display: inline-flex; align-items: center; background: #fff;
            border: 1.5px solid #e2e8f0; border-radius: 10px; padding: 3px 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
        }
        .month-btn-nav {
            background: transparent; border: none; color: #64748b; padding: 4px 8px;
            border-radius: 6px; cursor: pointer; transition: all 0.15s; font-size: 0.85rem;
        }
        .month-btn-nav:hover { background: #f1f5f9; color: #0f172a; }
        .month-display-text {
            font-size: 0.86rem; font-weight: 700; color: #0f172a; padding: 0 8px;
            display: inline-flex; align-items: center; gap: 6px;
        }
        
        .btn-ts-outline {
            height: 38px; border: 1.5px solid #e2e8f0; background: #fff; color: #475569;
            border-radius: 9px; padding: 0 1rem; font-size: 0.84rem; font-weight: 600;
            display: inline-flex; align-items: center; gap: 7px; transition: all 0.15s;
            text-decoration: none; cursor: pointer;
        }
        .btn-ts-outline:hover { background: #f8fafc; border-color: #cbd5e1; color: #1e293b; }
        
        .btn-ts-primary {
            height: 38px; background: #2563eb; color: #fff; border: 1px solid #2563eb;
            border-radius: 9px; padding: 0 1.1rem; font-size: 0.84rem; font-weight: 600;
            display: inline-flex; align-items: center; gap: 7px; transition: all 0.15s;
            cursor: pointer; text-decoration: none; box-shadow: 0 2px 6px rgba(37,99,235,0.25);
        }
        .btn-ts-primary:hover { background: #1d4ed8; color: #fff; }
        .btn-ts-locked {
            background: #dc2626; border-color: #dc2626; color: #fff;
        }
        .btn-ts-locked:hover { background: #b91c1c; }

        /* 4 KPI Cards Grid */
        .ts-kpi-grid {
            display: grid; grid-template-columns: repeat(4, 1fr);
            gap: 1rem; margin-bottom: 1.35rem;
        }
        .ts-kpi-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            padding: 1.15rem 1.25rem; box-shadow: 0 2px 10px rgba(15,23,42,0.03);
            display: flex; flex-direction: column; justify-content: space-between;
            min-height: 140px; transition: transform 0.15s, box-shadow 0.15s;
        }
        .ts-kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(15,23,42,0.06); }
        .kpi-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.65rem; }
        .kpi-label { font-size: 0.74rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.4px; }
        .kpi-icon-wrap {
            width: 34px; height: 34px; border-radius: 9px; display: flex;
            align-items: center; justify-content: center; font-size: 1.05rem;
        }
        .kpi-icon-blue   { background: #eff6ff; color: #2563eb; }
        .kpi-icon-amber  { background: #fffbeb; color: #d97706; }
        .kpi-icon-violet { background: #f5f3ff; color: #7c3aed; }
        .kpi-icon-rose   { background: #fff1f2; color: #e11d48; }

        .kpi-val-row { display: flex; align-items: baseline; gap: 8px; margin-bottom: 0.45rem; }
        .kpi-main-val { font-size: 1.75rem; font-weight: 800; color: #0f172a; line-height: 1; }
        .kpi-sub-val { font-size: 0.85rem; color: #94a3b8; font-weight: 500; }
        
        .kpi-bottom-text { font-size: 0.78rem; color: #64748b; display: flex; align-items: center; gap: 6px; }
        .kpi-progress-bar {
            width: 70px; height: 5px; background: #e2e8f0; border-radius: 999px; overflow: hidden; display: inline-block;
        }
        .kpi-progress-fill { height: 100%; background: #2563eb; border-radius: 999px; }

        /* Filter Bar */
        .ts-filter-bar {
            background: #fff; border-radius: 13px; border: 1.5px solid #f1f5f9;
            padding: 0.85rem 1.15rem; margin-bottom: 1.15rem;
            box-shadow: 0 2px 8px rgba(15,23,42,0.03);
        }
        .filter-search-box { position: relative; }
        .filter-search-box .bi-search {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: #94a3b8; font-size: 0.9rem;
        }
        .filter-search-input {
            width: 100%; height: 38px; border-radius: 9px; border: 1.5px solid #e2e8f0;
            padding-left: 35px; font-size: 0.84rem; background: #f8fafc; transition: all 0.15s;
        }
        .filter-search-input:focus { background: #fff; border-color: #2563eb; outline: none; box-shadow: 0 0 0 3px rgba(37,99,235,0.08); }
        .ts-select {
            height: 38px; border-radius: 9px; border: 1.5px solid #e2e8f0; font-size: 0.84rem;
            background-color: #f8fafc; transition: all 0.15s;
        }
        .ts-select:focus { background-color: #fff; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.08); }
        .btn-ts-reset {
            height: 38px; width: 38px; border-radius: 9px; border: 1.5px solid #e2e8f0;
            background: #f8fafc; color: #64748b; display: flex; align-items: center; justify-content: center;
            transition: all 0.15s; cursor: pointer; text-decoration: none;
        }
        .btn-ts-reset:hover { background: #eff6ff; border-color: #bfdbfe; color: #2563eb; }

        /* Legend Bar (Quy ước ký hiệu) */
        .ts-legend-bar {
            background: #fff; border-radius: 12px; border: 1.5px solid #f1f5f9;
            padding: 0.65rem 1.15rem; margin-bottom: 1.25rem;
            display: flex; align-items: center; gap: 1rem; flex-wrap: wrap;
            box-shadow: 0 2px 6px rgba(15,23,42,0.02);
        }
        .legend-title { font-size: 0.75rem; font-weight: 800; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }
        .legend-items-wrap { display: flex; align-items: center; gap: 0.85rem; flex-wrap: wrap; }
        .legend-item { display: inline-flex; align-items: center; gap: 6px; font-size: 0.78rem; font-weight: 500; color: #334155; }
        
        /* Badges for matrix cells */
        .cell-badge {
            width: 28px; height: 26px; border-radius: 6px; display: inline-flex;
            align-items: center; justify-content: center; font-size: 0.72rem; font-weight: 700;
            user-select: none;
        }
        .cell-code-full    { background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; }
        .cell-code-half    { background: #f5f3ff; color: #7c3aed; border: 1px solid #ddd6fe; }
        .cell-code-leave   { background: #e0f2fe; color: #0284c7; border: 1px solid #bae6fd; }
        .cell-code-late    { background: #fff7ed; color: #ea580c; border: 1px solid #fed7aa; }
        .cell-code-absent  { background: #dc2626; color: #ffffff; border: 1px solid #dc2626; font-weight: 800; }
        .cell-code-mission { background: #0f172a; color: #38bdf8; border: 1px solid #1e293b; font-size: 0.68rem; }
        .cell-code-weekend { background: #f8fafc; color: #94a3b8; border: 1px solid #f1f5f9; font-weight: 500; }

        /* Matrix Table Card */
        .ts-matrix-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            overflow: hidden; box-shadow: 0 2px 12px rgba(15,23,42,0.04);
            margin-bottom: 1.5rem;
        }
        .ts-matrix-header {
            padding: 0.9rem 1.25rem; border-bottom: 1.5px solid #f1f5f9;
            display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.75rem;
        }
        .matrix-title-group { display: flex; align-items: center; gap: 10px; }
        .matrix-title { font-size: 0.98rem; font-weight: 800; color: #0f172a; margin: 0; }
        .date-range-tag {
            background: #eff6ff; color: #2563eb; border-radius: 6px; padding: 2px 8px;
            font-size: 0.74rem; font-weight: 600;
        }
        .matrix-total-count { font-size: 0.8rem; color: #64748b; }
        
        .table-responsive-matrix {
            overflow-x: auto; -webkit-overflow-scrolling: touch;
        }
        .ts-table {
            width: 100%; border-collapse: collapse; min-width: 1200px;
        }
        .ts-table thead {
            background: #f8fafc; border-bottom: 2px solid #e2e8f0;
        }
        .ts-table thead th {
            padding: 0.65rem 0.5rem; font-size: 0.7rem; font-weight: 700;
            text-transform: uppercase; color: #64748b; letter-spacing: 0.4px;
            text-align: center; white-space: nowrap; vertical-align: middle;
        }
        .ts-table thead th.day-header {
            min-width: 36px; padding: 4px 2px;
        }
        .day-header .day-num { font-size: 0.75rem; font-weight: 800; color: #1e293b; display: block; line-height: 1.2; }
        .day-header .day-txt { font-size: 0.66rem; font-weight: 600; color: #94a3b8; display: block; text-transform: uppercase; }
        .day-header.weekend { background: #f1f5f9; }
        .day-header.weekend .day-txt { color: #dc2626; }

        .ts-table tbody tr {
            border-bottom: 1px solid #f1f5f9; transition: background 0.12s;
        }
        .ts-table tbody tr:hover { background: #f8fafc; }
        .ts-table td {
            padding: 0.65rem 0.5rem; vertical-align: middle; font-size: 0.83rem;
            text-align: center;
        }
        .ts-table td.emp-info-col {
            text-align: left; padding-left: 0.75rem; min-width: 200px;
        }
        
        .emp-profile-wrap { display: flex; align-items: center; gap: 9px; }
        .emp-avatar-img {
            width: 34px; height: 34px; border-radius: 50%;
            background: linear-gradient(135deg, #1e293b, #475569);
            color: #fff; font-weight: 700; font-size: 0.82rem;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .emp-name-bold { font-weight: 700; color: #0f172a; font-size: 0.85rem; line-height: 1.2; }
        .emp-role-sub { font-size: 0.73rem; color: #64748b; margin-top: 1px; }
        
        .dept-tag {
            display: inline-block; background: #f1f5f9; color: #475569;
            border-radius: 6px; padding: 2px 8px; font-size: 0.72rem; font-weight: 600;
        }

        .metric-cong { font-weight: 800; color: #0f172a; font-family: monospace; font-size: 0.88rem; }
        .metric-ot   { font-weight: 700; color: #2563eb; font-family: monospace; font-size: 0.85rem; }
        .metric-late { font-weight: 600; color: #d97706; font-size: 0.82rem; }
        .metric-leave{ font-weight: 600; color: #64748b; font-size: 0.82rem; }
        .metric-leave.absent { color: #dc2626; font-weight: 700; }

        /* Status Pills */
        .status-pill-matrix {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 3px 10px; border-radius: 999px; font-size: 0.72rem; font-weight: 700; white-space: nowrap;
        }
        .status-pill-matrix.approved {
            background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0;
        }
        .status-pill-matrix.pending {
            background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
        }
        .status-pill-matrix.anomaly {
            background: #fef2f2; color: #dc2626; border: 1px solid #fecaca;
        }

        .action-icon-btn {
            width: 28px; height: 28px; border-radius: 6px; border: 1px solid #e2e8f0;
            background: #fff; color: #64748b; display: inline-flex; align-items: center; justify-content: center;
            font-size: 0.8rem; cursor: pointer; transition: all 0.15s; text-decoration: none;
        }
        .action-icon-btn:hover { background: #eff6ff; color: #2563eb; border-color: #bfdbfe; }
        .action-icon-btn.warn:hover { background: #fef2f2; color: #dc2626; border-color: #fca5a5; }

        /* Table Footer Bar */
        .ts-table-footer {
            padding: 0.75rem 1.25rem; border-top: 1.5px solid #f1f5f9;
            display: flex; align-items: center; justify-content: space-between;
            font-size: 0.82rem; color: #64748b; flex-wrap: wrap; gap: 0.75rem;
        }

        /* Bottom 3 Cards Grid */
        .ts-bottom-grid {
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 1.25rem; margin-bottom: 2rem;
        }
        .ts-bottom-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            padding: 1.25rem; box-shadow: 0 2px 10px rgba(15,23,42,0.03);
            display: flex; flex-direction: column; justify-content: space-between;
        }
        .bottom-card-title-row {
            display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.5rem;
        }
        .bcard-title {
            font-size: 0.94rem; font-weight: 800; color: #0f172a; display: flex; align-items: center; gap: 7px;
        }
        .bcard-sub { font-size: 0.78rem; color: #64748b; margin-bottom: 1rem; line-height: 1.35; }
        
        /* Rule card rows */
        .rule-item-row {
            display: flex; justify-content: space-between; align-items: flex-start;
            padding: 0.5rem 0; border-bottom: 1px dashed #f1f5f9; font-size: 0.81rem;
        }
        .rule-label { color: #64748b; }
        .rule-val   { font-weight: 700; color: #0f172a; text-align: right; }
        .rule-val.alert { color: #dc2626; }
        .rule-val.bonus { color: #2563eb; }

        /* Device card rows */
        .device-item-row {
            display: flex; align-items: center; justify-content: space-between;
            padding: 0.6rem 0; border-bottom: 1px solid #f8fafc;
        }
        .device-info-left { display: flex; align-items: center; gap: 8px; }
        .device-icon { color: #2563eb; font-size: 1.1rem; }
        .device-name { font-size: 0.82rem; font-weight: 700; color: #1e293b; line-height: 1.2; }
        .device-sub  { font-size: 0.72rem; color: #94a3b8; }
        .device-time { font-family: monospace; font-size: 0.78rem; font-weight: 700; color: #475569; }

        /* Anomaly alert rows */
        .anomaly-item-row {
            display: flex; align-items: center; justify-content: space-between;
            padding: 0.55rem 0; border-bottom: 1px solid #f8fafc;
        }
        .anomaly-name { font-size: 0.82rem; font-weight: 700; color: #0f172a; }
        .anomaly-desc { font-size: 0.72rem; color: #dc2626; }
        .btn-remind-single {
            background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
            border-radius: 6px; padding: 2px 8px; font-size: 0.72rem; font-weight: 600;
            cursor: pointer; transition: all 0.15s;
        }
        .btn-remind-single:hover { background: #2563eb; color: #fff; }
        
        .btn-send-all-anomalies {
            width: 100%; height: 38px; border: none; background: #eff6ff; color: #2563eb;
            border-radius: 9px; font-size: 0.82rem; font-weight: 700; margin-top: 1rem;
            display: flex; align-items: center; justify-content: center; gap: 6px;
            transition: all 0.15s; cursor: pointer;
        }
        .btn-send-all-anomalies:hover { background: #2563eb; color: #fff; }

        @media (max-width: 1200px) {
            .ts-kpi-grid { grid-template-columns: repeat(2, 1fr); }
            .ts-bottom-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .ts-kpi-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="app-container">
    <c:set var="activeMenu" value="timesheet" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Thông báo thành công nếu có -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'locked'}">Đã khóa bảng công Tháng ${selectedMonth}/${selectedYear} thành công! Dữ liệu đã được chốt phục vụ tính lương.</c:when>
                        <c:when test="${param.success eq 'unlocked'}">Đã mở khóa kỳ quyết toán Tháng ${selectedMonth}/${selectedYear}!</c:when>
                        <c:when test="${param.success eq 'synced'}">Đã kích hoạt đồng bộ dữ liệu thời gian thực từ 3 thiết bị chấm công ZKTeco!</c:when>
                        <c:when test="${param.success eq 'reminded'}">Đã gửi email nhắc nhở giải trình thành công đến nhân viên!</c:when>
                        <c:when test="${param.success eq 'exported'}">Đã xuất báo cáo bảng công chi tiết định dạng Excel!</c:when>
                        <c:otherwise>Thao tác hoàn tất thành công!</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Page Header Bar (Role-Specific) -->
            <div class="ts-header-bar">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="settlement-badge ${isLocked ? 'locked' : ''}">
                            <span class="${isLocked ? '' : 'pulse-dot'}"></span>
                            KỲ QUYẾT TOÁN: <strong>${isLocked ? 'Đã Khóa' : 'Mở'}</strong>
                        </span>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.accountant}">
                                <span class="badge bg-success-subtle text-success border border-success-subtle"><i class="bi bi-cash-stack me-1"></i>Đối soát Lương</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
                                <span class="badge bg-warning-subtle text-dark border border-warning-subtle"><i class="bi bi-briefcase me-1"></i>Phòng ban Quản lý</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                                <span class="badge bg-info-subtle text-primary border border-info-subtle"><i class="bi bi-person-circle me-1"></i>Cá nhân của tôi</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.hr}">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle"><i class="bi bi-people me-1"></i>Quản trị HR</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-dark text-white"><i class="bi bi-shield-lock me-1"></i>Admin Toàn quyền</span>
                            </c:otherwise>
                        </c:choose>
                        <span class="text-muted" style="font-size:0.75rem;">· Lần cập nhật cuối: Hôm nay 10:45:12</span>
                    </div>
                    <h1 class="ts-title">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                                Bảng Chấm Công &amp; Ngày Công Cá Nhân
                            </c:when>
                            <c:when test="${sessionScope.currentUser.accountant}">
                                Bảng Công Tổng Hợp &amp; Đối Soát Quyết Toán Lương
                            </c:when>
                            <c:when test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
                                Bảng Công Nhân Sự Phòng Ban Quản Lý
                            </c:when>
                            <c:otherwise>
                                Quản lý Bảng công &amp; Chấm công tháng
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="ts-subtitle">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.accountant}">
                                Đối soát tổng công thực tế và ngày công chuẩn để hạch toán chi phí lương Tháng 0${selectedMonth}/${selectedYear}.
                            </c:when>
                            <c:when test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                                Xem chi tiết ma trận 31 ngày chấm công, số giờ làm việc thực tế, đi muộn và gửi giải trình nếu có sai lệch.
                            </c:when>
                            <c:otherwise>
                                Bảng tổng hợp ngày công, giờ làm việc thực tế, đi muộn/về sớm và chốt công kỳ quyết toán.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <div class="ts-actions-group">
                    <!-- Month Selector -->
                    <div class="month-selector-wrap">
                        <a href="${pageContext.request.contextPath}/timesheet?month=${selectedMonth > 1 ? selectedMonth - 1 : 12}&year=${selectedMonth > 1 ? selectedYear : selectedYear - 1}" class="month-btn-nav" title="Tháng trước"><i class="bi bi-chevron-left"></i></a>
                        <span class="month-display-text">
                            <i class="bi bi-calendar3 text-primary"></i> Tháng 0${selectedMonth} / ${selectedYear}
                        </span>
                        <a href="${pageContext.request.contextPath}/timesheet?month=${selectedMonth < 12 ? selectedMonth + 1 : 1}&year=${selectedMonth < 12 ? selectedYear : selectedYear + 1}" class="month-btn-nav" title="Tháng sau"><i class="bi bi-chevron-right"></i></a>
                    </div>

                    <!-- Nút Đồng bộ máy chấm công (Admin & HR) -->
                    <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
                        <form method="post" action="${pageContext.request.contextPath}/timesheet" class="d-inline">
                            <input type="hidden" name="action" value="sync">
                            <input type="hidden" name="month" value="${selectedMonth}">
                            <input type="hidden" name="year" value="${selectedYear}">
                            <button type="submit" class="btn-ts-outline" title="Đồng bộ máy chấm công">
                                <i class="bi bi-arrow-repeat text-primary"></i> Đồng bộ máy chấm công
                            </button>
                        </form>
                    </c:if>

                    <!-- Nút Kế toán: Sang bảng lương -->
                    <c:if test="${sessionScope.currentUser.accountant}">
                        <a href="${pageContext.request.contextPath}/payroll" class="btn-ts-outline" title="Chuyển sang Bảng lương">
                            <i class="bi bi-calculator text-success"></i> Chuyển sang tính lương
                        </a>
                    </c:if>

                    <!-- Nút Xuất Excel (Tất cả trừ Employee) -->
                    <c:if test="${not sessionScope.currentUser.employee or sessionScope.currentUser.admin or sessionScope.currentUser.hr or sessionScope.currentUser.accountant or sessionScope.currentUser.manager}">
                        <form method="post" action="${pageContext.request.contextPath}/timesheet" class="d-inline">
                            <input type="hidden" name="action" value="export">
                            <input type="hidden" name="month" value="${selectedMonth}">
                            <input type="hidden" name="year" value="${selectedYear}">
                            <button type="submit" class="btn-ts-outline">
                                <i class="bi bi-download"></i> Xuất Excel
                            </button>
                        </form>
                    </c:if>

                    <!-- Nút Khóa bảng công (Chỉ Admin & HR) -->
                    <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
                        <form method="post" action="${pageContext.request.contextPath}/timesheet" class="d-inline">
                            <input type="hidden" name="action" value="lock">
                            <input type="hidden" name="month" value="${selectedMonth}">
                            <input type="hidden" name="year" value="${selectedYear}">
                            <button type="submit" class="btn-ts-primary ${isLocked ? 'btn-ts-locked' : ''}">
                                <i class="bi bi-${isLocked ? 'unlock-fill' : 'lock-fill'}"></i>
                                ${isLocked ? 'Mở khóa bảng công' : 'Khóa bảng công'}
                            </button>
                        </form>
                    </c:if>

                    <!-- Nút Nhân viên: Gửi giải trình chấm công -->
                    <c:if test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                        <button type="button" class="btn-ts-primary" onclick="alert('Đã mở biểu mẫu gửi giải trình chấm công Tháng 0${selectedMonth}/${selectedYear} của bạn.');">
                            <i class="bi bi-envelope-exclamation"></i> Gửi giải trình chấm công
                        </button>
                    </c:if>
                </div>
            </div>

            <!-- 4 Thẻ KPI Chỉ số (Matches Screenshot 1) -->
            <div class="ts-kpi-grid">
                <!-- Card 1: Tổng công chuẩn kỳ -->
                <div class="ts-kpi-card">
                    <div>
                        <div class="kpi-top">
                            <span class="kpi-label">Tổng công chuẩn kỳ</span>
                            <div class="kpi-icon-wrap kpi-icon-blue"><i class="bi bi-calendar-event"></i></div>
                        </div>
                        <div class="kpi-val-row">
                            <span class="kpi-main-val">22</span>
                            <span class="kpi-sub-val">ngày / 176 giờ chuẩn</span>
                        </div>
                    </div>
                    <div class="kpi-bottom-text">
                        <span class="text-primary fw-bold"><i class="bi bi-graph-up-arrow"></i> 96.8%</span>
                        <span>tỷ lệ đi làm đủ</span>
                        <div class="kpi-progress-bar ms-auto"><div class="kpi-progress-fill" style="width:96.8%;"></div></div>
                    </div>
                </div>

                <!-- Card 2: Tổng giờ làm thực tế -->
                <div class="ts-kpi-card">
                    <div>
                        <div class="kpi-top">
                            <span class="kpi-label">Tổng giờ làm thực tế</span>
                            <div class="kpi-icon-wrap kpi-icon-blue"><i class="bi bi-clock-history"></i></div>
                        </div>
                        <div class="kpi-val-row">
                            <span class="kpi-main-val">43,120</span>
                            <span class="kpi-sub-val">giờ</span>
                        </div>
                    </div>
                    <div class="kpi-bottom-text">
                        <span class="text-primary fw-bold"><i class="bi bi-arrow-up-short"></i> +3.4% vs T08</span>
                        <span>· TB 7.9h / ngày / người</span>
                    </div>
                </div>

                <!-- Card 3: Đi muộn / Về sớm -->
                <div class="ts-kpi-card">
                    <div>
                        <div class="kpi-top">
                            <span class="kpi-label">Đi muộn / Về sớm</span>
                            <div class="kpi-icon-wrap kpi-icon-rose"><i class="bi bi-bell-slash"></i></div>
                        </div>
                        <div class="kpi-val-row">
                            <span class="kpi-main-val text-danger">38</span>
                            <span class="kpi-sub-val">lượt (24 nhân sự)</span>
                        </div>
                    </div>
                    <div class="kpi-bottom-text">
                        <span class="text-primary fw-bold"><i class="bi bi-arrow-down-short"></i> Giảm 12%</span>
                        <span>so với tháng trước</span>
                    </div>
                </div>

                <!-- Card 4: Công vắng / Nghỉ phép -->
                <div class="ts-kpi-card">
                    <div>
                        <div class="kpi-top">
                            <span class="kpi-label">Công vắng / Nghỉ phép</span>
                            <div class="kpi-icon-wrap kpi-icon-violet"><i class="bi bi-umbrella"></i></div>
                        </div>
                        <div class="kpi-val-row">
                            <span class="kpi-main-val">84</span>
                            <span class="kpi-sub-val">ngày</span>
                        </div>
                    </div>
                    <div class="kpi-bottom-text">
                        <span style="color:#2563eb; font-weight:600;">• 62 phép năm</span>
                        <span class="ms-1" style="color:#94a3b8;">• 22 ốm/không lương</span>
                    </div>
                </div>
            </div>

            <!-- Thanh bộ lọc (Filter Bar) -->
            <div class="ts-filter-bar">
                <form method="get" action="${pageContext.request.contextPath}/timesheet" id="tsFilterForm">
                    <input type="hidden" name="month" value="${selectedMonth}">
                    <input type="hidden" name="year" value="${selectedYear}">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-4">
                            <div class="filter-search-box">
                                <i class="bi bi-search"></i>
                                <input type="text" name="keyword" class="filter-search-input"
                                       placeholder="Tìm theo mã NV, họ tên..." value="${keyword}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select name="departmentId" class="form-select ts-select" onchange="document.getElementById('tsFilterForm').submit();">
                                <option value="">Phòng ban: Tất cả</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" ${selectedDeptId == dept.id ? 'selected' : ''}>${dept.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select name="status" class="form-select ts-select" onchange="document.getElementById('tsFilterForm').submit();">
                                <option value="ALL" ${selectedStatus eq 'ALL' ? 'selected' : ''}>Trạng thái: Tất cả</option>
                                <option value="APPROVED_LOCK" ${selectedStatus eq 'APPROVED_LOCK' ? 'selected' : ''}>Đã duyệt chốt</option>
                                <option value="PENDING_CONFIRM" ${selectedStatus eq 'PENDING_CONFIRM' ? 'selected' : ''}>Chờ xác nhận</option>
                                <option value="UNEXPLAINED" ${selectedStatus eq 'UNEXPLAINED' ? 'selected' : ''}>Chưa giải trình</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select name="shiftType" class="form-select ts-select" onchange="document.getElementById('tsFilterForm').submit();">
                                <option value="full">Loại ca: Hành chính 8h</option>
                                <option value="morning" ${selectedShift eq 'morning' ? 'selected' : ''}>Ca Sáng 4h</option>
                                <option value="afternoon" ${selectedShift eq 'afternoon' ? 'selected' : ''}>Ca Chiều 4h</option>
                            </select>
                        </div>
                        <div class="col-md-1 d-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/timesheet" class="btn-ts-reset" title="Đặt lại bộ lọc">
                                <i class="bi bi-arrow-counterclockwise"></i>
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Quy ước ký hiệu (Legend Bar - Matches Screenshot 1) -->
            <div class="ts-legend-bar">
                <span class="legend-title">Quy ước ký hiệu:</span>
                <div class="legend-items-wrap">
                    <div class="legend-item"><span class="cell-badge cell-code-full">1</span> Đủ công (1.0)</div>
                    <div class="legend-item"><span class="cell-badge cell-code-half">½</span> Nửa công (0.5)</div>
                    <div class="legend-item"><span class="cell-badge cell-code-leave">P</span> Phép năm có lương</div>
                    <div class="legend-item"><span class="cell-badge cell-code-late">M</span> Đi muộn / Về sớm</div>
                    <div class="legend-item"><span class="cell-badge cell-code-absent">V</span> Vắng không phép</div>
                    <div class="legend-item"><span class="cell-badge cell-code-mission">CT</span> Công tác</div>
                    <div class="legend-item"><span class="cell-badge cell-code-weekend">O</span> Nghỉ tuần (T7-CN)</div>
                </div>
            </div>

            <!-- Ma trận chấm công chi tiết (Matrix Table Card) -->
            <div class="ts-matrix-card">
                <div class="ts-matrix-header">
                    <div class="matrix-title-group">
                        <h2 class="matrix-title">Ma trận chấm công chi tiết</h2>
                        <span class="date-range-tag">Hiển thị ngày 01 đến 15/09/${selectedYear}</span>
                    </div>
                    <div class="matrix-total-count">
                        Tổng số: <strong>${totalEmployees}</strong> nhân viên
                    </div>
                </div>

                <div class="table-responsive-matrix">
                    <table class="ts-table">
                        <thead>
                            <tr>
                                <th style="width:38px; padding-left:1rem;"><input type="checkbox" class="form-check-input" style="cursor:pointer;"></th>
                                <th style="width:80px;">Mã NV</th>
                                <th class="text-start" style="min-width:210px;">Họ tên &amp; Chức vụ</th>
                                <th style="width:95px;">Phòng ban</th>
                                
                                <!-- 15 Ngày (Tháng 09/2026: 01 T2.. 06 T7, 07 CN..) -->
                                <th class="day-header"><span class="day-num">01</span><span class="day-txt">T2</span></th>
                                <th class="day-header"><span class="day-num">02</span><span class="day-txt">T3</span></th>
                                <th class="day-header"><span class="day-num">03</span><span class="day-txt">T4</span></th>
                                <th class="day-header"><span class="day-num">04</span><span class="day-txt">T5</span></th>
                                <th class="day-header"><span class="day-num">05</span><span class="day-txt">T6</span></th>
                                <th class="day-header weekend"><span class="day-num">06</span><span class="day-txt">T7</span></th>
                                <th class="day-header weekend"><span class="day-num">07</span><span class="day-txt">CN</span></th>
                                <th class="day-header"><span class="day-num">08</span><span class="day-txt">T2</span></th>
                                <th class="day-header"><span class="day-num">09</span><span class="day-txt">T3</span></th>
                                <th class="day-header"><span class="day-num">10</span><span class="day-txt">T4</span></th>
                                <th class="day-header"><span class="day-num">11</span><span class="day-txt">T5</span></th>
                                <th class="day-header"><span class="day-num">12</span><span class="day-txt">T6</span></th>
                                <th class="day-header weekend"><span class="day-num">13</span><span class="day-txt">T7</span></th>
                                <th class="day-header weekend"><span class="day-num">14</span><span class="day-txt">CN</span></th>
                                <th class="day-header"><span class="day-num">15</span><span class="day-txt">T2</span></th>

                                <th style="width:85px;">Công TT</th>
                                <th style="width:80px;">Giờ OT</th>
                                <th style="width:85px;">Trễ/Sớm</th>
                                <th style="width:90px;">Nghỉ phép</th>
                                <th style="width:130px;">Trạng thái</th>
                                <th style="width:70px; padding-right:1rem;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty matrix}">
                                    <tr>
                                        <td colspan="21" class="text-center py-5 text-muted">
                                            <i class="bi bi-calendar-x" style="font-size:2.5rem; display:block; margin-bottom:0.5rem; color:#cbd5e1;"></i>
                                            Không tìm thấy dữ liệu chấm công phù hợp với bộ lọc
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="item" items="${matrix}">
                                        <tr>
                                            <td style="padding-left:1rem;"><input type="checkbox" class="form-check-input"></td>
                                            <td><span class="fw-bold text-primary" style="font-size:0.84rem;">${item.employeeCode}</span></td>
                                            <td class="emp-info-col">
                                                <div class="emp-profile-wrap">
                                                    <div class="emp-avatar-img">${item.employeeName.substring(0,1)}</div>
                                                    <div>
                                                        <div class="emp-name-bold">${item.employeeName}</div>
                                                        <div class="emp-role-sub">${item.positionName}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="dept-tag">${item.departmentName}</span></td>

                                            <!-- 15 Ngày Chấm Công -->
                                            <c:forEach var="d" begin="1" end="15">
                                                <c:set var="code" value="${item.getDayStatus(d)}"/>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${code eq '1.0'}"><span class="cell-badge cell-code-full">1.0</span></c:when>
                                                        <c:when test="${code eq '0.5'}"><span class="cell-badge cell-code-half">½</span></c:when>
                                                        <c:when test="${code eq 'P'}"><span class="cell-badge cell-code-leave">P</span></c:when>
                                                        <c:when test="${code eq 'M'}"><span class="cell-badge cell-code-late">M</span></c:when>
                                                        <c:when test="${code eq 'V'}"><span class="cell-badge cell-code-absent">V</span></c:when>
                                                        <c:when test="${code eq 'CT'}"><span class="cell-badge cell-code-mission">CT</span></c:when>
                                                        <c:otherwise><span class="cell-badge cell-code-weekend">O</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </c:forEach>

                                            <!-- Tổng hợp -->
                                            <td><span class="metric-cong">${item.actualWorkDays}</span></td>
                                            <td><span class="metric-ot">${item.otHours > 0 ? item.otHours : '0'}h</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.lateEarlyMinutes > 0}"><span class="metric-late text-danger">${item.lateEarlyMinutes}p</span></c:when>
                                                    <c:otherwise><span class="text-muted">0p</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="metric-leave ${item.leaveDaysDisplay.contains('V') ? 'absent' : ''}">
                                                    ${item.leaveDaysDisplay}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.status eq 'APPROVED_LOCK'}">
                                                        <span class="status-pill-matrix approved"><i class="bi bi-check-circle-fill"></i> Đã duyệt chốt</span>
                                                    </c:when>
                                                    <c:when test="${item.status eq 'PENDING_CONFIRM'}">
                                                        <span class="status-pill-matrix pending"><i class="bi bi-box-arrow-in-right"></i> Chờ xác nhận</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill-matrix anomaly"><i class="bi bi-exclamation-triangle-fill"></i> Chưa giải trình</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding-right:1rem;">
                                                <div class="d-flex align-items-center justify-content-center gap-1">
                                                    <button type="button" class="action-icon-btn" title="Xem chi tiết ngày công"
                                                            onclick="openTimesheetDetail(this)"
                                                            data-code="${item.employeeCode}"
                                                            data-name="${item.employeeName}"
                                                            data-position="${item.positionName}"
                                                            data-dept="${item.departmentName}"
                                                            data-days="${item.actualWorkDays}"
                                                            data-ot="${item.otHours}"
                                                            data-late="${item.lateEarlyMinutes}"
                                                            data-leave="${item.leaveDaysDisplay}"
                                                            data-status="${item.getStatusDisplay()}">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                    <c:if test="${item.status eq 'UNEXPLAINED' or item.lateEarlyMinutes > 0}">
                                                        <form method="post" action="${pageContext.request.contextPath}/timesheet" class="d-inline">
                                                            <input type="hidden" name="action" value="remind">
                                                            <input type="hidden" name="target" value="${item.employeeCode}">
                                                            <button type="submit" class="action-icon-btn warn" title="Gửi email nhắc nhở giải trình">
                                                                <i class="bi bi-envelope"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Phân trang Table footer -->
                <div class="ts-table-footer">
                    <div>
                        Hiển thị <strong>25 dòng</strong> trên tổng <strong>${totalEmployees}</strong> bản ghi
                    </div>
                    <div class="d-flex align-items-center gap-1">
                        <button class="btn btn-sm btn-outline-light text-muted border py-1 px-2" disabled><i class="bi bi-chevron-bar-left"></i></button>
                        <button class="btn btn-sm btn-outline-light text-muted border py-1 px-2" disabled><i class="bi bi-chevron-left"></i></button>
                        <button class="btn btn-sm btn-primary py-1 px-2 fw-bold">1</button>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2">2</button>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2">3</button>
                        <span class="px-1 text-muted">...</span>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2">6</button>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2"><i class="bi bi-chevron-right"></i></button>
                        <button class="btn btn-sm btn-outline-light text-dark border py-1 px-2"><i class="bi bi-chevron-bar-right"></i></button>
                    </div>
                </div>
            </div>

            <!-- 3 Widget Phụ bên dưới (Matches Screenshot 2) -->
            <div class="ts-bottom-grid">
                <!-- Widget 1: Quy tắc tính công tự động -->
                <div class="ts-bottom-card">
                    <div>
                        <div class="bottom-card-title-row">
                            <span class="bcard-title"><i class="bi bi-sliders text-primary"></i> Quy tắc tính công tự động</span>
                        </div>
                        <p class="bcard-sub">Quy chuẩn áp dụng kỳ công Tháng ${selectedMonth}/${selectedYear} theo Chính sách nhân sự ban hành:</p>
                        
                        <div class="rule-item-row">
                            <span class="rule-label">Khung giờ chuẩn:</span>
                            <span class="rule-val">08:30 - 17:30 (Nghỉ trưa 1h)</span>
                        </div>
                        <div class="rule-item-row">
                            <span class="rule-label">Giảm trừ trễ &lt; 15 phút:</span>
                            <span class="rule-val text-primary">Miễn phạt (Tối đa 3 lần/tháng)</span>
                        </div>
                        <div class="rule-item-row">
                            <span class="rule-label">Trễ từ 15 - 60 phút:</span>
                            <span class="rule-val text-danger">Khấu trừ 0.25 công</span>
                        </div>
                        <div class="rule-item-row">
                            <span class="rule-label">Hệ số tính giờ OT ngày thường:</span>
                            <span class="rule-val bonus">x 1.5 Lương cơ bản</span>
                        </div>
                    </div>
                    
                    <div class="pt-3">
                        <c:if test="${sessionScope.currentUser.admin}">
                            <a href="${pageContext.request.contextPath}/salary-config" class="text-primary fw-bold text-decoration-none" style="font-size:0.83rem;">
                                Chỉnh sửa cấu hình ca &amp; phạt <i class="bi bi-arrow-right"></i>
                            </a>
                        </c:if>
                        <c:if test="${not sessionScope.currentUser.admin}">
                            <span class="text-muted" style="font-size:0.8rem;">Quy tắc áp dụng thống nhất toàn công ty</span>
                        </c:if>
                    </div>
                </div>

                <!-- Widget 2: Thiết bị chấm công -->
                <div class="ts-bottom-card">
                    <div>
                        <div class="bottom-card-title-row">
                            <span class="bcard-title"><i class="bi bi-hdd-network text-primary"></i> Thiết bị chấm công</span>
                            <span class="settlement-badge" style="background:#ecfdf5; color:#059669; border-color:#a7f3d0;">
                                <i class="bi bi-check-circle-fill"></i> 3/3 Online
                            </span>
                        </div>
                        <p class="bcard-sub">Trạng thái đồng bộ thời gian thực từ phần cứng văn phòng:</p>

                        <div class="device-item-row">
                            <div class="device-info-left">
                                <i class="bi bi-person-bounding-box device-icon"></i>
                                <div>
                                    <div class="device-name">FaceID Tầng 8 - MIXIMOI HQ</div>
                                    <div class="device-sub">IP: 192.168.1.102 · ZKTeco SpeedFace</div>
                                </div>
                            </div>
                            <span class="device-time">10:45:10</span>
                        </div>

                        <div class="device-item-row">
                            <div class="device-info-left">
                                <i class="bi bi-fingerprint device-icon"></i>
                                <div>
                                    <div class="device-name">Vân tay Cửa sảnh Tầng 7</div>
                                    <div class="device-sub">IP: 192.168.1.103 · ZKTeco ProCapture</div>
                                </div>
                            </div>
                            <span class="device-time">10:44:58</span>
                        </div>

                        <div class="device-item-row">
                            <div class="device-info-left">
                                <i class="bi bi-person-bounding-box device-icon"></i>
                                <div>
                                    <div class="device-name">FaceID Chi nhánh Hồ Chí Minh</div>
                                    <div class="device-sub">IP: 10.0.12.4 · BioSense Pro</div>
                                </div>
                            </div>
                            <span class="device-time">10:42:15</span>
                        </div>
                    </div>

                    <div class="d-flex align-items-center justify-content-between pt-3 border-top" style="font-size:0.8rem;">
                        <span class="text-muted">Tổng logs hôm nay: <strong>342 lượt</strong></span>
                        <a href="javascript:void(0);" onclick="alert('Đã kiểm tra 3 thiết bị ZKTeco: Kết nối WebSocket ổn định (Ping: 14ms)');" class="text-primary fw-bold text-decoration-none">
                            Kiểm tra kết nối
                        </a>
                    </div>
                </div>

                <!-- Widget 3: Cảnh báo giải trình -->
                <div class="ts-bottom-card">
                    <div>
                        <div class="bottom-card-title-row">
                            <span class="bcard-title"><i class="bi bi-shield-exclamation text-danger"></i> Cảnh báo giải trình</span>
                            <span class="settlement-badge" style="background:#fef2f2; color:#dc2626; border-color:#fecaca;">
                                4 hồ sơ
                            </span>
                        </div>
                        <p class="bcard-sub">Danh sách nhân sự chưa hoàn thành giải trình vắng mặt hoặc quên chấm công:</p>

                        <c:forEach var="anom" items="${anomalies}">
                            <div class="anomaly-item-row">
                                <div>
                                    <div class="anomaly-name">${anom.name} (${anom.code})</div>
                                    <div class="anomaly-desc">${anom.issue} · ${anom.date}</div>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/timesheet">
                                    <input type="hidden" name="action" value="remind">
                                    <input type="hidden" name="target" value="${anom.code}">
                                    <button type="submit" class="btn-remind-single">Nhắc nhở</button>
                                </form>
                            </div>
                        </c:forEach>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/timesheet" class="mt-2">
                        <input type="hidden" name="action" value="remind">
                        <input type="hidden" name="target" value="ALL">
                        <button type="submit" class="btn-send-all-anomalies">
                            <i class="bi bi-send-fill"></i> Gửi thông báo đồng loạt đến 4 nhân sự
                        </button>
                    </form>
                </div>
            </div>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- MODAL Chi tiết bảng công (1 modal dùng chung, đặt ngoài bảng để tránh lỗi tối màn backdrop) -->
<div class="modal fade" id="timesheetDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;">
            <div class="modal-header border-bottom py-3">
                <div class="d-flex align-items-center gap-2">
                    <div class="emp-avatar-img" id="tsDetailAvatar" style="width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#2563eb,#7c3aed);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1rem;">N</div>
                    <div>
                        <h6 class="modal-title fw-bold text-dark mb-0" id="tsDetailName">Nhân viên</h6>
                        <span class="text-muted" id="tsDetailMeta" style="font-size:0.75rem;">Chức vụ · Phòng ban</span>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-3">
                <div class="p-3 bg-light rounded-3 mb-3">
                    <div class="row g-2 text-center">
                        <div class="col-3">
                            <div style="font-size:0.72rem; color:#64748b;">Công TT</div>
                            <div class="fw-bold fs-5 text-primary" id="tsDetailDays">0</div>
                        </div>
                        <div class="col-3">
                            <div style="font-size:0.72rem; color:#64748b;">Giờ OT</div>
                            <div class="fw-bold fs-5 text-success" id="tsDetailOt">0h</div>
                        </div>
                        <div class="col-3">
                            <div style="font-size:0.72rem; color:#64748b;">Trễ/Sớm</div>
                            <div class="fw-bold fs-5 text-warning" id="tsDetailLate">0p</div>
                        </div>
                        <div class="col-3">
                            <div style="font-size:0.72rem; color:#64748b;">Nghỉ phép</div>
                            <div class="fw-bold fs-5" style="color:#7c3aed;" id="tsDetailLeave">0</div>
                        </div>
                    </div>
                </div>
                <div class="alert alert-info py-2 px-3 mb-0" style="font-size:0.8rem; border-radius:8px;">
                    <i class="bi bi-info-circle me-1"></i> Trạng thái bảng công: <strong id="tsDetailStatus">—</strong>
                </div>
            </div>
            <div class="modal-footer border-top py-2">
                <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
// Mở modal chi tiết bảng công từ data-attributes trên button
function openTimesheetDetail(btn) {
    var code = btn.getAttribute('data-code') || '';
    var name = btn.getAttribute('data-name') || '';
    var position = btn.getAttribute('data-position') || '';
    var dept = btn.getAttribute('data-dept') || '';
    var days = btn.getAttribute('data-days') || '0';
    var ot = btn.getAttribute('data-ot') || '0';
    var late = btn.getAttribute('data-late') || '0';
    var leave = btn.getAttribute('data-leave') || '0';
    var status = btn.getAttribute('data-status') || '';

    var avatar = document.getElementById('tsDetailAvatar');
    if (avatar && name.length > 0) avatar.textContent = name.charAt(0).toUpperCase();
    var elName = document.getElementById('tsDetailName');
    if (elName) elName.textContent = name + ' (' + code + ')';
    var elMeta = document.getElementById('tsDetailMeta');
    if (elMeta) elMeta.textContent = position + ' \u00b7 ' + dept;
    var elDays = document.getElementById('tsDetailDays');
    if (elDays) elDays.textContent = days;
    var elOt = document.getElementById('tsDetailOt');
    if (elOt) elOt.textContent = ot + 'h';
    var elLate = document.getElementById('tsDetailLate');
    if (elLate) elLate.textContent = late + 'p';
    var elLeave = document.getElementById('tsDetailLeave');
    if (elLeave) elLeave.textContent = leave;
    var elStatus = document.getElementById('tsDetailStatus');
    if (elStatus) elStatus.textContent = status;

    var modalEl = document.getElementById('timesheetDetailModal');
    if (modalEl) {
        var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
    }
}
</script>
</body>
</html>
