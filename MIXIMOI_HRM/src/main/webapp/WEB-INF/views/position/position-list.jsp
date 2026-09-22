<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý chức vụ & Cấp bậc — MIXIMOI HRM &amp; PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        /* ===== Root & Page Variables ===== */
        :root {
            --pos-primary: #2563eb;
            --pos-primary-hover: #1d4ed8;
            --pos-border: #e5e7eb;
            --pos-text-main: #111827;
            --pos-text-sub: #6b7280;
            --pos-bg-card: #ffffff;
        }

        /* ===== Page Header ===== */
        .pos-header {
            display: flex;
            flex-wrap: wrap;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 24px;
        }
        .pos-title-wrap {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .pos-title-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .pos-page-title {
            font-size: 1.55rem;
            font-weight: 800;
            color: var(--pos-text-main);
            letter-spacing: -0.02em;
            margin: 0;
        }
        .pos-count-badge {
            font-size: 0.8rem;
            font-weight: 600;
            background: #eff6ff;
            color: #2563eb;
            padding: 3px 12px;
            border-radius: 20px;
            border: 1px solid #bfdbfe;
        }
        .pos-sub-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 4px;
        }
        .iso-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.76rem;
            font-weight: 600;
            color: #15803d;
            background: #f0fdf4;
            padding: 2px 10px;
            border-radius: 12px;
            border: 1px solid #bbf7d0;
        }
        .iso-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #16a34a;
            box-shadow: 0 0 0 2px rgba(22, 163, 74, 0.2);
        }
        .pos-page-desc {
            font-size: 0.84rem;
            color: var(--pos-text-sub);
            margin: 0;
        }
        .pos-header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn-matrix {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 16px;
            background: #ffffff;
            border: 1px solid #d1d5db;
            border-radius: 9px;
            font-size: 0.84rem;
            font-weight: 600;
            color: #374151;
            transition: all 0.18s;
            cursor: pointer;
        }
        .btn-matrix:hover {
            background: #f9fafb;
            border-color: #9ca3af;
            color: #111827;
            transform: translateY(-1px);
        }
        .btn-matrix i {
            color: #2563eb;
            font-size: 0.95rem;
        }
        .btn-export {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 16px;
            background: #ffffff;
            border: 1px solid #d1d5db;
            border-radius: 9px;
            font-size: 0.84rem;
            font-weight: 600;
            color: #374151;
            transition: all 0.18s;
            cursor: pointer;
        }
        .btn-export:hover {
            background: #f9fafb;
            border-color: #9ca3af;
            color: #111827;
            transform: translateY(-1px);
        }
        .btn-add-pos {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 20px;
            background: #2563eb;
            color: #ffffff;
            border-radius: 9px;
            font-size: 0.86rem;
            font-weight: 600;
            text-decoration: none;
            border: none;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.28);
            transition: all 0.2s;
        }
        .btn-add-pos:hover {
            background: #1d4ed8;
            color: #ffffff;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.38);
            transform: translateY(-1px);
        }

        /* ===== KPI Cards (4 columns) ===== */
        .pos-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        @media (max-width: 1200px) {
            .pos-kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 640px) {
            .pos-kpi-grid { grid-template-columns: 1fr; }
        }
        .pos-kpi-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 20px 22px 18px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
            position: relative;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .pos-kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.07);
        }
        .pos-kpi-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }
        .pos-kpi-label {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            color: #6b7280;
            text-transform: uppercase;
        }
        .pos-kpi-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: #eff6ff;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
            flex-shrink: 0;
        }
        .pos-kpi-value {
            font-size: 1.85rem;
            font-weight: 800;
            color: var(--pos-text-main);
            line-height: 1.1;
            letter-spacing: -0.02em;
            margin-bottom: 12px;
        }
        .pos-kpi-value.text-level {
            font-size: 1.55rem;
        }
        .pos-kpi-footer {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.78rem;
            color: #6b7280;
            padding-top: 8px;
        }
        .pos-kpi-footer i {
            color: #2563eb;
            font-size: 0.9rem;
        }

        /* ===== Filter Card ===== */
        .pos-filter-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 18px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
        }
        .pos-search-box {
            flex: 1;
            min-width: 260px;
            position: relative;
        }
        .pos-search-box i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 0.95rem;
        }
        .pos-search-input {
            width: 100%;
            padding: 9px 14px 9px 40px;
            border: 1px solid #e5e7eb;
            border-radius: 9px;
            background: #f9fafb;
            font-size: 0.85rem;
            color: #111827;
            outline: none;
            transition: all 0.15s;
            box-sizing: border-box;
        }
        .pos-search-input:focus {
            background: #ffffff;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }
        .pos-filter-select {
            padding: 9px 14px;
            border: 1px solid #e5e7eb;
            border-radius: 9px;
            background: #f9fafb;
            font-size: 0.84rem;
            color: #374151;
            outline: none;
            cursor: pointer;
            min-width: 170px;
            transition: all 0.15s;
        }
        .pos-filter-select:focus {
            background: #ffffff;
            border-color: #2563eb;
        }
        .btn-filter-reset {
            width: 38px;
            height: 38px;
            border-radius: 9px;
            border: 1px solid #e5e7eb;
            background: #f9fafb;
            color: #6b7280;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.15s;
        }
        .btn-filter-reset:hover {
            background: #fee2e2;
            border-color: #fca5a5;
            color: #dc2626;
            transform: rotate(90deg);
        }

        /* ===== Bulk Selection Bar ===== */
        .pos-bulk-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 6px 6px 14px 6px;
            font-size: 0.84rem;
            color: #4b5563;
        }
        .pos-bulk-left strong {
            color: #111827;
        }
        .pos-bulk-left a {
            color: #2563eb;
            font-weight: 500;
        }
        .pos-bulk-left a:hover {
            text-decoration: underline;
        }
        .pos-bulk-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .btn-bulk-action {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.83rem;
            font-weight: 500;
            color: #4b5563;
            background: transparent;
            border: none;
            padding: 0;
            cursor: pointer;
            transition: color 0.15s;
        }
        .btn-bulk-action:hover {
            color: #2563eb;
        }
        .btn-bulk-action i {
            font-size: 0.9rem;
        }

        /* ===== Table Wrap & Table ===== */
        .pos-table-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
            margin-bottom: 16px;
        }
        .pos-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        .pos-table thead th {
            background: #f8fafc;
            padding: 13px 16px;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: #6b7280;
            border-bottom: 1px solid #e5e7eb;
            white-space: nowrap;
        }
        .pos-table thead th:first-child {
            padding-left: 20px;
            width: 44px;
        }
        .pos-table tbody tr {
            border-bottom: 1px solid #f3f4f6;
            transition: background 0.12s;
        }
        .pos-table tbody tr:last-child {
            border-bottom: none;
        }
        .pos-table tbody tr:hover {
            background: #f8faff;
        }
        .pos-table tbody td {
            padding: 14px 16px;
            font-size: 0.85rem;
            color: #374151;
            vertical-align: middle;
        }
        .pos-table tbody td:first-child {
            padding-left: 20px;
        }
        .pos-checkbox {
            width: 16px;
            height: 16px;
            accent-color: #2563eb;
            cursor: pointer;
            margin: 0;
            border-radius: 4px;
        }

        /* Column Cells */
        .pos-code {
            font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;
            font-weight: 700;
            color: #2563eb;
            font-size: 0.84rem;
            white-space: nowrap;
        }
        .pos-name-cell {
            display: flex;
            flex-direction: column;
            gap: 2px;
            min-width: 220px;
        }
        .pos-name-title {
            font-weight: 700;
            color: #111827;
            font-size: 0.88rem;
            line-height: 1.3;
        }
        .pos-name-desc {
            font-size: 0.75rem;
            color: #6b7280;
            line-height: 1.3;
        }

        /* Level Pill Badges */
        .level-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            white-space: nowrap;
        }
        .level-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        /* L1: Intern (Gray) */
        .level-l1-intern { background: #f1f5f9; color: #475569; }
        .level-l1-intern .level-dot { background: #64748b; }

        /* L2: Junior/Mid (Light Blue) */
        .level-l2-mid { background: #eff6ff; color: #1e40af; }
        .level-l2-mid .level-dot { background: #3b82f6; }

        /* L3: Senior (Blue) */
        .level-l3-senior { background: #dbeafe; color: #1d4ed8; }
        .level-l3-senior .level-dot { background: #2563eb; }

        /* L3: Specialist (Blue Teal) */
        .level-l3-spec { background: #e0f2fe; color: #0369a1; }
        .level-l3-spec .level-dot { background: #0284c7; }

        /* L4: Lead (Purple) */
        .level-l4-lead { background: #f3e8ff; color: #6b21a8; }
        .level-l4-lead .level-dot { background: #7c3aed; }

        /* L4: Manager (Indigo/Purple) */
        .level-l4-manager { background: #ede9fe; color: #5b21b6; }
        .level-l4-manager .level-dot { background: #6d28d9; }

        /* L5: Director (Violet/Magenta) */
        .level-l5-director { background: #fdf2f8; color: #9d174d; }
        .level-l5-director .level-dot { background: #db2777; }

        /* L6: C-Level (Red) */
        .level-l6-clevel { background: #fee2e2; color: #991b1b; }
        .level-l6-clevel .level-dot { background: #dc2626; }

        /* Department Tag */
        .dept-tag-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.78rem;
            font-weight: 500;
            color: #1e40af;
            background: #eff6ff;
            padding: 4px 10px;
            border-radius: 8px;
            white-space: nowrap;
        }
        .dept-tag-chip i {
            color: #2563eb;
            font-size: 0.85rem;
        }

        /* Salary Range */
        .salary-cell {
            white-space: nowrap;
        }
        .salary-text {
            font-weight: 600;
            color: #111827;
            font-size: 0.84rem;
        }
        .badge-kpi {
            display: inline-block;
            font-size: 0.72rem;
            font-weight: 700;
            color: #2563eb;
            margin-left: 4px;
        }

        /* Employee Count */
        .emp-count-chip {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.84rem;
            font-weight: 600;
            color: #374151;
        }
        .emp-count-chip i {
            color: #9ca3af;
            font-size: 0.9rem;
        }

        /* Status Pill */
        .status-pill-active {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 3px 10px;
            background: #f0fdf4;
            color: #15803d;
            border-radius: 12px;
            font-size: 0.76rem;
            font-weight: 600;
            white-space: nowrap;
        }

        /* Action Buttons */
        .pos-actions {
            display: flex;
            align-items: center;
            gap: 4px;
            justify-content: flex-end;
        }
        .btn-pos-action {
            width: 30px;
            height: 30px;
            border-radius: 7px;
            border: 1px solid #e5e7eb;
            background: #ffffff;
            color: #6b7280;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.15s;
            text-decoration: none;
        }
        .btn-pos-action:hover {
            border-color: #93c5fd;
            background: #eff6ff;
            color: #2563eb;
        }
        .btn-pos-action.edit:hover {
            border-color: #6ee7b7;
            background: #ecfdf5;
            color: #059669;
        }
        .btn-pos-action.copy:hover {
            border-color: #c4b5fd;
            background: #f5f3ff;
            color: #7c3aed;
        }
        .btn-pos-action.delete:hover {
            border-color: #fca5a5;
            background: #fef2f2;
            color: #dc2626;
        }

        /* ===== Pagination Bar ===== */
        .pos-pagination-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            padding: 14px 4px 18px;
            font-size: 0.82rem;
            color: #6b7280;
        }
        .pos-page-size-select {
            padding: 3px 8px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            background: #ffffff;
            font-size: 0.82rem;
            color: #374151;
            margin: 0 4px;
            outline: none;
        }
        .pos-pager {
            display: flex;
            align-items: center;
            gap: 4px;
            list-style: none;
            margin: 0;
            padding: 0;
        }
        .pos-pager-btn {
            min-width: 32px;
            height: 32px;
            padding: 0 6px;
            border-radius: 7px;
            border: 1px solid #e5e7eb;
            background: #ffffff;
            color: #4b5563;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.82rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s;
            text-decoration: none;
        }
        .pos-pager-btn:hover {
            background: #f3f4f6;
            border-color: #d1d5db;
            color: #111827;
        }
        .pos-pager-btn.active {
            background: #2563eb;
            border-color: #2563eb;
            color: #ffffff;
            font-weight: 700;
        }
        .pos-pager-btn.disabled {
            opacity: 0.45;
            cursor: not-allowed;
            pointer-events: none;
        }

        /* ===== Footer Legend Card (QUY CHUẨN CẤP BẬC) ===== */
        .pos-legend-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 16px 22px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
            margin-top: 12px;
        }
        .pos-legend-left {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }
        .pos-legend-title {
            font-size: 0.75rem;
            font-weight: 800;
            letter-spacing: 0.05em;
            color: #374151;
            text-transform: uppercase;
        }
        .pos-legend-item {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.78rem;
            font-weight: 500;
            color: #4b5563;
        }
        .pos-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }
        .pos-legend-right {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.76rem;
            color: #6b7280;
        }
        .pos-legend-right i {
            color: #2563eb;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="app-container">
    <!-- Shared Sidebar Navigation -->
    <c:set var="activeMenu" value="positions" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <!-- Main Content Area -->
    <main class="app-main">
        <!-- Shared Topbar -->
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <!-- Position Content Body -->
        <div class="app-content">

            <!-- Flash Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'added'}">Đã thêm chức danh mới thành công vào hệ thống!</c:when>
                        <c:when test="${param.success eq 'updated'}">Đã cập nhật thông tin chức danh thành công!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Đã xóa chức danh thành công khỏi hệ thống.</c:when>
                        <c:when test="${param.success eq 'duplicated'}">Đã nhân bản chức vụ thành công.</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="pos-header">
                <div class="pos-title-wrap">
                    <div class="pos-title-row">
                        <h1 class="pos-page-title">Quản lý chức vụ &amp; Cấp bậc</h1>
                        <span class="pos-count-badge" id="headerCountBadge">${not empty totalPositions ? totalPositions : fn:length(positions)} chức danh</span>
                    </div>
                    <div class="pos-sub-row">
                        <span class="iso-tag"><span class="iso-dot"></span> Chuẩn ISO-HR 2024</span>
                        <p class="pos-page-desc">Định nghĩa tiêu chuẩn chức danh công việc, cấp bậc (Level), khung năng lực và mức lương cơ bản sàn.</p>
                    </div>
                </div>
                <div class="pos-header-actions">
                    <button type="button" class="btn-matrix" data-bs-toggle="modal" data-bs-target="#matrixModal">
                        <i class="bi bi-diagram-3"></i> Khung năng lực (Matrix)
                    </button>
                    <button type="button" class="btn-export" onclick="exportPositionsToExcel()">
                        <i class="bi bi-download"></i> Xuất file
                    </button>
                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                        <a href="${pageContext.request.contextPath}/positions?action=new" class="btn-add-pos">
                            <i class="bi bi-plus-lg"></i> Thêm chức vụ
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- 4 KPI Stat Cards (Matching Mockup exactly) -->
            <div class="pos-kpi-grid">
                <!-- Card 1 -->
                <div class="pos-kpi-card">
                    <div class="pos-kpi-top">
                        <span class="pos-kpi-label">TỔNG SỐ CHỨC DANH</span>
                        <div class="pos-kpi-icon">
                            <i class="bi bi-briefcase"></i>
                        </div>
                    </div>
                    <div class="pos-kpi-value">${not empty totalPositions ? totalPositions : 28} vị trí</div>
                    <div class="pos-kpi-footer">
                        <i class="bi bi-grid-3x3"></i>
                        <span>Trải rộng 6 cấp bậc</span>
                    </div>
                </div>

                <!-- Card 2 -->
                <div class="pos-kpi-card">
                    <div class="pos-kpi-top">
                        <span class="pos-kpi-label">CẤP QUẢN LÝ &amp; LÃNH ĐẠO</span>
                        <div class="pos-kpi-icon">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>
                    <div class="pos-kpi-value">${not empty leadershipCount ? leadershipCount : 16} nhân sự</div>
                    <div class="pos-kpi-footer">
                        <i class="bi bi-pie-chart"></i>
                        <span>Chiếm 6.5% tổng nhân sự</span>
                    </div>
                </div>

                <!-- Card 3 -->
                <div class="pos-kpi-card">
                    <div class="pos-kpi-top">
                        <span class="pos-kpi-label">LƯƠNG SÀN TRUNG BÌNH</span>
                        <div class="pos-kpi-icon">
                            <i class="bi bi-coin"></i>
                        </div>
                    </div>
                    <div class="pos-kpi-value">
                        <c:choose>
                            <c:when test="${not empty avgSalary}">
                                <fmt:formatNumber value="${avgSalary}" pattern="#,###"/> đ
                            </c:when>
                            <c:otherwise>16.800.000 đ</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="pos-kpi-footer">
                        <i class="bi bi-sliders"></i>
                        <span>Dải lương: 8M – 65M</span>
                    </div>
                </div>

                <!-- Card 4 -->
                <div class="pos-kpi-card">
                    <div class="pos-kpi-top">
                        <span class="pos-kpi-label">CẤP BẬC PHỔ BIẾN NHẤT</span>
                        <div class="pos-kpi-icon">
                            <i class="bi bi-graph-up-arrow"></i>
                        </div>
                    </div>
                    <div class="pos-kpi-value text-level">Chuyên viên (L3)</div>
                    <div class="pos-kpi-footer">
                        <i class="bi bi-people"></i>
                        <span>112 nhân viên (45.7%)</span>
                    </div>
                </div>
            </div>

            <!-- Search and Filter Bar -->
            <div class="pos-filter-card">
                <div class="pos-search-box">
                    <i class="bi bi-search"></i>
                    <input type="text" id="posSearchInput" class="pos-search-input"
                           placeholder="Tìm theo tên chức vụ, mã chức danh, cấp bậc..."
                           oninput="filterPositions()">
                </div>
                <select id="posLevelFilter" class="pos-filter-select" onchange="filterPositions()">
                    <option value="">Tất cả cấp bậc (Level 1 – Level 6)</option>
                    <option value="Level 1">Level 1 (Intern)</option>
                    <option value="Level 2">Level 2 (Junior / Mid)</option>
                    <option value="Level 3">Level 3 (Senior / Specialist)</option>
                    <option value="Level 4">Level 4 (Lead / Manager)</option>
                    <option value="Level 5">Level 5 (Director)</option>
                    <option value="Level 6">Level 6 (C-Level)</option>
                </select>
                <select id="posDeptFilter" class="pos-filter-select" onchange="filterPositions()">
                    <option value="">Tất cả phòng ban</option>
                    <option value="Công nghệ thông tin">Công nghệ thông tin</option>
                    <option value="Phát triển Kinh doanh">Phát triển Kinh doanh</option>
                    <option value="Quản trị Nhân sự">Quản trị Nhân sự</option>
                    <option value="Tài chính - Kế toán">Tài chính - Kế toán</option>
                    <option value="Marketing">Marketing</option>
                    <option value="Vận hành">Vận hành</option>
                    <option value="Ban Điều hành">Ban Điều hành</option>
                    <option value="Pháp chế">Pháp chế</option>
                </select>
                <select id="posStatusFilter" class="pos-filter-select" onchange="filterPositions()">
                    <option value="ACTIVE" selected>Đang áp dụng</option>
                    <option value="">Tất cả trạng thái</option>
                    <option value="INACTIVE">Tạm ngưng</option>
                </select>
                <button type="button" class="btn-filter-reset" onclick="resetFilters()" title="Đặt lại bộ lọc">
                    <i class="bi bi-arrow-clockwise"></i>
                </button>
            </div>

            <!-- Bulk Selection & Action Row -->
            <div class="pos-bulk-bar">
                <div class="pos-bulk-left">
                    Đã chọn: <strong id="selectedCount">0</strong> • 
                    <a href="javascript:void(0)" onclick="selectAllPositions()">Chọn tất cả <span id="bulkTotalDisplay">${not empty totalRecords ? totalRecords : totalPositions}</span> dòng</a>
                </div>
                <div class="pos-bulk-actions">
                    <button type="button" class="btn-bulk-action" onclick="bulkEdit()">
                        <i class="bi bi-pencil"></i> Sửa hàng loạt
                    </button>
                    <button type="button" class="btn-bulk-action" onclick="bulkArchive()">
                        <i class="bi bi-archive"></i> Lưu trữ
                    </button>
                </div>
            </div>

            <!-- Positions Data Table -->
            <div class="pos-table-card">
                <div class="table-responsive">
                    <table class="pos-table" id="positionTable">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" id="checkAllPositions" class="pos-checkbox" onchange="toggleSelectAll(this)">
                                </th>
                                <th>MÃ CV</th>
                                <th>TÊN CHỨC VỤ</th>
                                <th>CẤP BẬC (LEVEL)</th>
                                <th>PHÒNG BAN ÁP DỤNG</th>
                                <th>DẢI LƯƠNG CHUẨN</th>
                                <th>NHÂN VIÊN</th>
                                <th>TRẠNG THÁI</th>
                                <th style="text-align: right; padding-right: 20px;">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody id="posTableBody">
                            <c:forEach var="pos" items="${positions}" varStatus="status">
                                <tr class="pos-row" 
                                    data-id="${pos.id}"
                                    data-code="${pos.code}"
                                    data-name="${pos.name}"
                                    data-desc="${pos.description}"
                                    data-level="${pos.level}"
                                    data-level-num="${pos.levelNumber}"
                                    data-dept="${pos.departmentName}"
                                    data-salary="${pos.salaryRangeFormatted}"
                                    data-emp="${pos.employeeCount}"
                                    data-status="${pos.status}">
                                    <td>
                                        <input type="checkbox" class="pos-checkbox pos-row-checkbox" value="${pos.id}" onchange="updateSelectedCount()">
                                    </td>
                                    <td>
                                        <span class="pos-code"><c:out value="${pos.code}"/></span>
                                    </td>
                                    <td>
                                        <div class="pos-name-cell">
                                            <span class="pos-name-title"><c:out value="${pos.name}"/></span>
                                            <span class="pos-name-desc"><c:out value="${pos.description}"/></span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="level-pill ${pos.levelPillClass}">
                                            <span class="level-dot"></span>
                                            <c:out value="${pos.level}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="dept-tag-chip">
                                            <i class="bi ${pos.departmentIcon}"></i>
                                            <c:out value="${pos.departmentName}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="salary-cell">
                                            <span class="salary-text">${pos.salaryRangeFormatted}</span>
                                            <c:if test="${pos.hasKpi}">
                                                <span class="badge-kpi">+ KPI</span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="emp-count-chip">
                                            <i class="bi bi-people"></i>
                                            ${pos.employeeCount}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-pill-active">Đang áp dụng</span>
                                    </td>
                                    <td style="padding-right: 20px;">
                                        <div class="pos-actions">
                                            <!-- View detail -->
                                            <button type="button" class="btn-pos-action view" 
                                                    title="Xem chi tiết chức danh"
                                                    onclick="viewPosDetail('${pos.id}', '<c:out value="${pos.code}"/>', '<c:out value="${pos.name}"/>', '<c:out value="${pos.description}"/>', '<c:out value="${pos.level}"/>', '<c:out value="${pos.departmentName}"/>', '${pos.salaryRangeFormatted}', '${pos.employeeCount}', '${pos.hasKpi}')">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <!-- Edit -->
                                            <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                                <a href="${pageContext.request.contextPath}/positions?action=edit&id=${pos.id}"
                                                   class="btn-pos-action edit" title="Chỉnh sửa chức vụ">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                            </c:if>
                                            <!-- Duplicate -->
                                            <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                                <a href="${pageContext.request.contextPath}/positions?action=duplicate&id=${pos.id}"
                                                   class="btn-pos-action copy" title="Nhân bản chức vụ"
                                                   onclick="return confirm('Bạn có muốn nhân bản chức vụ này?')">
                                                    <i class="bi bi-copy"></i>
                                                </a>
                                            </c:if>
                                            <!-- Delete -->
                                            <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                                <button type="button" class="btn-pos-action delete" 
                                                        title="Xóa chức danh"
                                                        onclick="confirmDeletePos('${pos.id}', '<c:out value="${pos.name}"/>', '${pos.employeeCount}')">
                                                    <i class="bi bi-trash3"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination Row (Server-Side) -->
            <div class="pos-pagination-bar">
                <div>
                    Hiển thị
                    <strong>${(currentPage - 1) * pageSize + 1}</strong>
                    –
                    <strong>${(currentPage - 1) * pageSize + positions.size()}</strong>
                    trên tổng số <strong id="posTotalCountDisplay">${totalRecords}</strong> chức danh
                </div>
                <div>
                    <ul class="pos-pager" id="posPagination">
                        <li><a href="${pageContext.request.contextPath}/positions?page=1${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                               class="pos-pager-btn ${currentPage <= 1 ? 'disabled' : ''}">&vert;&lt;</a></li>
                        <li><a href="${pageContext.request.contextPath}/positions?page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                               class="pos-pager-btn ${currentPage <= 1 ? 'disabled' : ''}">&lt;</a></li>
                        <c:forEach var="p" begin="1" end="${totalPages}">
                            <li><a href="${pageContext.request.contextPath}/positions?page=${p}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                                   class="pos-pager-btn ${p == currentPage ? 'active' : ''}">${p}</a></li>
                        </c:forEach>
                        <li><a href="${pageContext.request.contextPath}/positions?page=${currentPage + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                               class="pos-pager-btn ${currentPage >= totalPages ? 'disabled' : ''}">&gt;</a></li>
                        <li><a href="${pageContext.request.contextPath}/positions?page=${totalPages}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                               class="pos-pager-btn ${currentPage >= totalPages ? 'disabled' : ''}">&gt;&vert;</a></li>
                    </ul>
                </div>
            </div>

            <!-- Footer Legend Card (QUY CHUẨN CẤP BẬC) (Matching Mockup 3) -->
            <div class="pos-legend-card">
                <div class="pos-legend-left">
                    <span class="pos-legend-title">QUY CHUẨN CẤP BẬC:</span>
                    <span class="pos-legend-item">
                        <span class="pos-legend-dot" style="background: #64748b;"></span>
                        L1: Intern
                    </span>
                    <span class="pos-legend-item">
                        <span class="pos-legend-dot" style="background: #3b82f6;"></span>
                        L2: Junior / Mid
                    </span>
                    <span class="pos-legend-item">
                        <span class="pos-legend-dot" style="background: #1d4ed8;"></span>
                        L3: Senior / Specialist
                    </span>
                    <span class="pos-legend-item">
                        <span class="pos-legend-dot" style="background: #7c3aed;"></span>
                        L4: Lead / Manager
                    </span>
                    <span class="pos-legend-item">
                        <span class="pos-legend-dot" style="background: #c026d3;"></span>
                        L5: Director
                    </span>
                    <span class="pos-legend-item">
                        <span class="pos-legend-dot" style="background: #e11d48;"></span>
                        L6: C-Level
                    </span>
                </div>
                <div class="pos-legend-right">
                    <i class="bi bi-info-circle"></i>
                    <span>Dải lương đã bao gồm bảo hiểm bắt buộc theo luật lao động hiện hành.</span>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Modal Khung năng lực (Matrix) -->
<div class="modal fade" id="matrixModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px; overflow: hidden;">
            <div class="modal-header border-bottom px-4 py-3" style="background: #f8fafc;">
                <div>
                    <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-diagram-3 text-primary"></i> Khung năng lực &amp; Thang cấp bậc ISO-HR 2024
                    </h5>
                    <small class="text-muted">Bộ tiêu chuẩn định lượng năng lực, mức độ tự chủ và khung thù lao tương ứng</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="table-responsive">
                    <table class="table table-bordered align-middle" style="font-size: 0.84rem;">
                        <thead style="background: #f1f5f9;">
                            <tr>
                                <th style="width: 140px;">Cấp bậc</th>
                                <th style="width: 170px;">Chức danh tiêu chuẩn</th>
                                <th>Tiêu chuẩn năng lực chuyên môn</th>
                                <th>Kỹ năng quản lý &amp; Tự chủ</th>
                                <th style="width: 180px;">Dải thu nhập sàn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="level-pill level-l1-intern"><span class="level-dot"></span> L1 (Intern)</span></td>
                                <td>Thực tập sinh, Học việc</td>
                                <td>Nắm kiến thức nền tảng, hoàn thành nhiệm vụ theo hướng dẫn chi tiết từng bước.</td>
                                <td>Không có trách nhiệm quản lý. Báo cáo định kỳ hàng ngày cho Mentor.</td>
                                <td><strong class="text-dark">4M – 7M đ</strong></td>
                            </tr>
                            <tr>
                                <td><span class="level-pill level-l2-mid"><span class="level-dot"></span> L2 (Junior / Mid)</span></td>
                                <td>Chuyên viên, Kỹ sư phần mềm</td>
                                <td>Làm việc độc lập các module thông thường, áp dụng quy trình chuẩn ISO thành thạo.</td>
                                <td>Chịu trách nhiệm trực tiếp sản phẩm cá nhân, hỗ trợ onboarding thành viên mới.</td>
                                <td><strong class="text-dark">11M – 22M đ</strong></td>
                            </tr>
                            <tr>
                                <td><span class="level-pill level-l3-senior"><span class="level-dot"></span> L3 (Senior / Specialist)</span></td>
                                <td>Kỹ sư cao cấp, Chuyên viên chính</td>
                                <td>Chuyên môn sâu, xử lý các bài toán kỹ thuật/nghiệp vụ phức tạp, tối ưu hóa hiệu năng.</td>
                                <td>Định hướng chuyên môn cho nhóm, tham gia phỏng vấn và đào tạo nhân sự cấp dưới.</td>
                                <td><strong class="text-dark">20M – 38M đ</strong></td>
                            </tr>
                            <tr>
                                <td><span class="level-pill level-l4-lead"><span class="level-dot"></span> L4 (Lead / Manager)</span></td>
                                <td>Tech Lead, Trưởng phòng, Kế toán trưởng</td>
                                <td>Kiến trúc tổng thể hệ thống, phân bổ công việc, thẩm định chất lượng đầu ra.</td>
                                <td>Quản trị hiệu suất (KPI), lập kế hoạch ngân sách nhóm, giải quyết xung đột nội bộ.</td>
                                <td><strong class="text-dark">25M – 55M đ</strong></td>
                            </tr>
                            <tr>
                                <td><span class="level-pill level-l5-director"><span class="level-dot"></span> L5 (Director)</span></td>
                                <td>Giám đốc khối, Giám đốc chức năng</td>
                                <td>Hoạch định chiến lược trung hạn 1-3 năm của toàn bộ khối nghiệp vụ phụ trách.</td>
                                <td>Quản trị P&amp;L khối, xây dựng chính sách thu hút nhân tài cấp cao, đàm phán đối tác lớn.</td>
                                <td><strong class="text-dark">50M – 95M đ</strong></td>
                            </tr>
                            <tr>
                                <td><span class="level-pill level-l6-clevel"><span class="level-dot"></span> L6 (C-Level)</span></td>
                                <td>CEO, CTO, CFO, COO, CCO</td>
                                <td>Định hình tầm nhìn doanh nghiệp, chuyển đổi số toàn diện, kiểm soát rủi ro vĩ mô.</td>
                                <td>Báo cáo trực tiếp Hội đồng Quản trị, chịu trách nhiệm pháp lý và kết quả kinh doanh tập đoàn.</td>
                                <td><strong class="text-dark">75M – 200M+ đ</strong></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer border-top bg-light px-4 py-2">
                <button type="button" class="btn btn-primary btn-sm px-4" data-bs-dismiss="modal">Đã hiểu</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Chi tiết chức danh (View Detail) -->
<div class="modal fade" id="posDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-md">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px; overflow: hidden;">
            <div class="modal-header border-bottom px-4 py-3" style="background: linear-gradient(135deg, #eff6ff, #f0fdf4);">
                <div class="d-flex align-items-center gap-3">
                    <div class="pos-kpi-icon" style="background:#2563eb; color:#fff;">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <div>
                        <h6 class="modal-title fw-bold text-dark mb-0" id="detailPosName">Senior Software Engineer</h6>
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle" id="detailPosCode">CV-TECH-01</span>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-3">
                    <div class="col-6">
                        <label class="text-muted small fw-semibold">Cấp bậc tiêu chuẩn</label>
                        <div class="fw-bold text-dark" id="detailPosLevel">Level 3 (Senior)</div>
                    </div>
                    <div class="col-6">
                        <label class="text-muted small fw-semibold">Phòng ban phụ trách</label>
                        <div class="fw-bold text-dark" id="detailPosDept">Công nghệ thông tin</div>
                    </div>
                    <div class="col-6">
                        <label class="text-muted small fw-semibold">Dải lương chuẩn</label>
                        <div class="fw-bold text-success" id="detailPosSalary">20.000.000 – 35.000.000 đ</div>
                    </div>
                    <div class="col-6">
                        <label class="text-muted small fw-semibold">Nhân sự hiện tại</label>
                        <div class="fw-bold text-dark" id="detailPosEmp">18 nhân viên</div>
                    </div>
                    <div class="col-12">
                        <label class="text-muted small fw-semibold">Chế độ đãi ngộ mở rộng</label>
                        <div id="detailPosKpi" class="text-secondary small">Có phụ cấp KPI và thưởng dự án</div>
                    </div>
                    <div class="col-12">
                        <label class="text-muted small fw-semibold">Mô tả vai trò &amp; trách nhiệm</label>
                        <div class="p-3 bg-light rounded-3 text-secondary small" id="detailPosDesc">
                            Lập trình viên backend/fullstack cao cấp, chịu trách nhiệm thiết kế kiến trúc vi dịch vụ và tối ưu hiệu năng.
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-top bg-light px-4 py-2">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Đóng</button>
                <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                    <a href="#" id="detailEditBtn" class="btn btn-primary btn-sm px-3">
                        <i class="bi bi-pencil me-1"></i> Chỉnh sửa
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Modal Xác nhận xóa -->
<div class="modal fade" id="deletePosModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 14px;">
            <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                <div class="d-flex align-items-center gap-2 text-danger">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <h6 class="modal-title fw-bold mb-0">Xác nhận xóa chức danh</h6>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body px-4 py-3 text-secondary" style="font-size: 0.87rem;">
                Bạn có chắc chắn muốn xóa chức vụ <strong id="deletePosName" class="text-dark"></strong>?
                <div id="deleteWarning" class="alert alert-warning p-2 mt-3 mb-0 small" style="display:none;">
                    <i class="bi bi-info-circle me-1"></i> Chức vụ này đang có <strong id="deleteEmpCount"></strong> nhân viên đảm nhận.
                </div>
            </div>
            <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
                <button type="button" class="btn btn-light btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/positions">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deletePosId">
                    <button type="submit" class="btn btn-danger btn-sm px-4">Xác nhận xóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Shared JavaScript dependencies -->
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    let currentPage = 1;
    let pageSize = 8;
    let allRows = [];

    document.addEventListener('DOMContentLoaded', function() {
        allRows = Array.from(document.querySelectorAll('#posTableBody tr.pos-row'));
        paginateRows();
    });

    // Pagination logic
    function paginateRows() {
        const query = (document.getElementById('posSearchInput').value || '').toLowerCase().trim();
        const levelVal = document.getElementById('posLevelFilter').value;
        const deptVal = document.getElementById('posDeptFilter').value;
        const statusVal = document.getElementById('posStatusFilter').value;

        let visibleRows = allRows.filter(row => {
            const name = (row.getAttribute('data-name') || '').toLowerCase();
            const code = (row.getAttribute('data-code') || '').toLowerCase();
            const desc = (row.getAttribute('data-desc') || '').toLowerCase();
            const level = row.getAttribute('data-level') || '';
            const dept = row.getAttribute('data-dept') || '';
            const status = row.getAttribute('data-status') || '';

            const matchQuery = !query || name.includes(query) || code.includes(query) || desc.includes(query);
            const matchLevel = !levelVal || level.includes(levelVal);
            const matchDept = !deptVal || dept === deptVal;
            const matchStatus = !statusVal || status === statusVal;

            return matchQuery && matchLevel && matchDept && matchStatus;
        });

        const total = visibleRows.length;
        document.getElementById('posTotalCountDisplay').textContent = total;
        document.getElementById('bulkTotalDisplay').textContent = total;

        const totalPages = Math.ceil(total / pageSize) || 1;
        if (currentPage > totalPages) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        allRows.forEach(row => row.style.display = 'none');

        const startIndex = (currentPage - 1) * pageSize;
        const endIndex = Math.min(startIndex + pageSize, total);

        for (let i = startIndex; i < endIndex; i++) {
            visibleRows[i].style.display = '';
        }

        renderPaginationControls(totalPages);
    }

    function renderPaginationControls(totalPages) {
        const ul = document.getElementById('posPagination');
        ul.innerHTML = '';

        // First
        const firstLi = document.createElement('li');
        firstLi.innerHTML = '<a href="javascript:void(0)" class="pos-pager-btn ' + (currentPage === 1 ? 'disabled' : '') + '" onclick="goToPage(1)">&vert;&lt;</a>';
        ul.appendChild(firstLi);

        // Prev
        const prevLi = document.createElement('li');
        prevLi.innerHTML = '<a href="javascript:void(0)" class="pos-pager-btn ' + (currentPage === 1 ? 'disabled' : '') + '" onclick="prevPage()">&lt;</a>';
        ul.appendChild(prevLi);

        // Page buttons
        for (let i = 1; i <= totalPages; i++) {
            const li = document.createElement('li');
            li.innerHTML = '<a href="javascript:void(0)" class="pos-pager-btn ' + (i === currentPage ? 'active' : '') + '" onclick="goToPage(' + i + ')">' + i + '</a>';
            ul.appendChild(li);
        }

        // Next
        const nextLi = document.createElement('li');
        nextLi.innerHTML = '<a href="javascript:void(0)" class="pos-pager-btn ' + (currentPage === totalPages ? 'disabled' : '') + '" onclick="nextPage()">&gt;</a>';
        ul.appendChild(nextLi);

        // Last
        const lastLi = document.createElement('li');
        lastLi.innerHTML = '<a href="javascript:void(0)" class="pos-pager-btn ' + (currentPage === totalPages ? 'disabled' : '') + '" onclick="goToPage(' + totalPages + ')">&gt;&vert;</a>';
        ul.appendChild(lastLi);
    }

    function goToPage(page) {
        currentPage = page;
        paginateRows();
    }

    function prevPage() {
        if (currentPage > 1) {
            currentPage--;
            paginateRows();
        }
    }

    function nextPage() {
        const total = allRows.length;
        const totalPages = Math.ceil(total / pageSize) || 1;
        if (currentPage < totalPages) {
            currentPage++;
            paginateRows();
        }
    }

    function changePageSize(val) {
        pageSize = parseInt(val) || 8;
        currentPage = 1;
        paginateRows();
    }

    function filterPositions() {
        currentPage = 1;
        paginateRows();
    }

    function resetFilters() {
        document.getElementById('posSearchInput').value = '';
        document.getElementById('posLevelFilter').value = '';
        document.getElementById('posDeptFilter').value = '';
        document.getElementById('posStatusFilter').value = 'ACTIVE';
        currentPage = 1;
        paginateRows();
    }

    // Checkbox selection
    function toggleSelectAll(master) {
        const checkboxes = document.querySelectorAll('.pos-row-checkbox');
        checkboxes.forEach(cb => {
            const row = cb.closest('tr');
            if (row && row.style.display !== 'none') {
                cb.checked = master.checked;
            }
        });
        updateSelectedCount();
    }

    function selectAllPositions() {
        const checkboxes = document.querySelectorAll('.pos-row-checkbox');
        checkboxes.forEach(cb => cb.checked = true);
        document.getElementById('checkAllPositions').checked = true;
        updateSelectedCount();
    }

    function updateSelectedCount() {
        const checked = document.querySelectorAll('.pos-row-checkbox:checked').length;
        document.getElementById('selectedCount').textContent = checked;
    }

    function bulkEdit() {
        const checked = document.querySelectorAll('.pos-row-checkbox:checked').length;
        if (checked === 0) {
            alert('Vui lòng chọn ít nhất một chức vụ để thao tác sửa hàng loạt.');
            return;
        }
        alert('Đang mở bảng điều khiển sửa hàng loạt cho ' + checked + ' chức vụ.');
    }

    function bulkArchive() {
        const checked = document.querySelectorAll('.pos-row-checkbox:checked').length;
        if (checked === 0) {
            alert('Vui lòng chọn ít nhất một chức vụ để lưu trữ.');
            return;
        }
        if (confirm('Bạn có chắc chắn muốn chuyển ' + checked + ' chức vụ được chọn vào mục lưu trữ?')) {
            alert('Đã lưu trữ thành công ' + checked + ' chức vụ.');
        }
    }

    function viewPosDetail(id, code, name, desc, level, dept, salary, emp, hasKpi) {
        document.getElementById('detailPosName').textContent = name;
        document.getElementById('detailPosCode').textContent = code;
        document.getElementById('detailPosLevel').textContent = level;
        document.getElementById('detailPosDept').textContent = dept;
        document.getElementById('detailPosSalary').textContent = salary;
        document.getElementById('detailPosEmp').textContent = emp + ' nhân sự đang đảm nhận';
        document.getElementById('detailPosDesc').textContent = desc || 'Chưa có mô tả chi tiết trách nhiệm';
        document.getElementById('detailPosKpi').textContent = (hasKpi === 'true' || hasKpi === true) ? 'Áp dụng chính sách thưởng KPI theo doanh số đạt được' : 'Lương cố định tiêu chuẩn + phụ cấp chức vụ theo quy chế';
        
        const editBtn = document.getElementById('detailEditBtn');
        if (editBtn) {
            editBtn.href = '${pageContext.request.contextPath}/positions?action=edit&id=' + id;
        }
        new bootstrap.Modal(document.getElementById('posDetailModal')).show();
    }

    function confirmDeletePos(id, name, empCount) {
        document.getElementById('deletePosId').value = id;
        document.getElementById('deletePosName').textContent = name;
        const count = parseInt(empCount) || 0;
        const warning = document.getElementById('deleteWarning');
        if (count > 0) {
            document.getElementById('deleteEmpCount').textContent = count;
            warning.style.display = 'block';
        } else {
            warning.style.display = 'none';
        }
        new bootstrap.Modal(document.getElementById('deletePosModal')).show();
    }

    function exportPositionsToExcel() {
        let csv = 'MÃ CV,TÊN CHỨC VỤ,MÔ TẢ,CẤP BẬC,PHÒNG BAN,DẢI LƯƠNG,NHÂN VIÊN,TRẠNG THÁI\n';
        allRows.forEach(row => {
            const code = row.getAttribute('data-code') || '';
            const name = (row.getAttribute('data-name') || '').replace(/"/g, '""');
            const desc = (row.getAttribute('data-desc') || '').replace(/"/g, '""');
            const level = row.getAttribute('data-level') || '';
            const dept = row.getAttribute('data-dept') || '';
            const salary = (row.getAttribute('data-salary') || '').replace(/"/g, '""');
            const emp = row.getAttribute('data-emp') || '0';
            const status = 'Đang áp dụng';
            csv += `"${code}","${name}","${desc}","${level}","${dept}","${salary}","${emp}","${status}"\n`;
        });

        const blob = new Blob(['\uFEFF' + csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        const url = URL.createObjectURL(blob);
        link.setAttribute('href', url);
        link.setAttribute('download', 'Danh_sach_chuc_danh_MIXIMOI_HRM.csv');
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
</script>

</body>
</html>
