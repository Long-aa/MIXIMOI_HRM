<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quan ly phong ban - MIXIMOI HRM &amp; PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        .dept-page-header{display:flex;flex-wrap:wrap;align-items:flex-start;justify-content:space-between;gap:16px;margin-bottom:28px}
        .dept-page-title{font-size:1.45rem;font-weight:700;color:#111827;display:flex;align-items:center;gap:10px;margin:0 0 4px}
        .dept-page-title .badge-count{font-size:0.72rem;font-weight:600;background:#dbeafe;color:#1d4ed8;padding:3px 10px;border-radius:20px}
        .dept-page-subtitle{font-size:0.83rem;color:#6b7280;margin:0}
        .dept-update-tag{font-size:0.72rem;color:#9ca3af;font-weight:400}
        .dept-header-actions{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
        .btn-export,.btn-org-chart{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border:1px solid #d1d5db;border-radius:8px;background:#fff;color:#374151;font-size:0.83rem;font-weight:500;cursor:pointer;transition:all 0.15s}
        .btn-export:hover{background:#f9fafb;border-color:#9ca3af;color:#111827}
        .btn-org-chart:hover{background:#f0fdf4;border-color:#86efac;color:#16a34a}
        .btn-add-dept{display:inline-flex;align-items:center;gap:8px;padding:9px 20px;border-radius:9px;background:linear-gradient(135deg,#2563eb,#1d4ed8);color:#fff;font-size:0.85rem;font-weight:600;text-decoration:none;box-shadow:0 2px 8px rgba(37,99,235,0.35);transition:all 0.2s;border:none}
        .btn-add-dept:hover{background:linear-gradient(135deg,#1d4ed8,#1e40af);color:#fff;transform:translateY(-1px)}
        .dept-kpi-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px}
        @media(max-width:1100px){.dept-kpi-grid{grid-template-columns:repeat(2,1fr)}}
        @media(max-width:600px){.dept-kpi-grid{grid-template-columns:1fr}}
        .dept-kpi-card{background:#fff;border:1px solid #e5e7eb;border-radius:14px;padding:20px 22px 16px;box-shadow:0 1px 4px rgba(0,0,0,0.04);transition:box-shadow 0.2s,transform 0.2s;position:relative;overflow:hidden}
        .dept-kpi-card:hover{box-shadow:0 6px 20px rgba(0,0,0,0.09);transform:translateY(-2px)}
        .dept-kpi-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,#2563eb,#60a5fa);border-radius:14px 14px 0 0}
        .dept-kpi-card.green::before{background:linear-gradient(90deg,#16a34a,#4ade80)}
        .dept-kpi-card.amber::before{background:linear-gradient(90deg,#d97706,#fbbf24)}
        .dept-kpi-card.violet::before{background:linear-gradient(90deg,#7c3aed,#a78bfa)}
        .dept-kpi-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:12px}
        .dept-kpi-label{font-size:0.72rem;font-weight:700;letter-spacing:0.06em;color:#6b7280;text-transform:uppercase;margin-bottom:6px}
        .dept-kpi-value-row{display:flex;align-items:baseline;gap:6px}
        .dept-kpi-value{font-size:2rem;font-weight:800;color:#111827;line-height:1}
        .dept-kpi-unit{font-size:0.82rem;color:#6b7280;font-weight:500}
        .dept-kpi-icon{width:44px;height:44px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.25rem;background:#eff6ff;color:#2563eb;flex-shrink:0}
        .dept-kpi-icon.green{background:#f0fdf4;color:#16a34a}
        .dept-kpi-icon.amber{background:#fffbeb;color:#d97706}
        .dept-kpi-icon.violet{background:#f5f3ff;color:#7c3aed}
        .dept-kpi-footer{display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid #f3f4f6;font-size:0.75rem}
        .dept-kpi-footer-main{color:#374151}
        .dept-kpi-badge-pos{background:#dcfce7;color:#15803d;font-size:0.7rem;font-weight:600;padding:2px 8px;border-radius:10px}
        .dept-kpi-badge-neutral{background:#f3f4f6;color:#6b7280;font-size:0.7rem;padding:2px 8px;border-radius:10px}
        .dept-search-bar{background:#fff;border:1px solid #e5e7eb;border-radius:12px;padding:16px 20px;display:flex;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:20px;box-shadow:0 1px 4px rgba(0,0,0,0.04)}
        .dept-search-input-wrap{flex:1;min-width:220px;position:relative}
        .dept-search-input-wrap i{position:absolute;left:12px;top:50%;transform:translateY(-50%);color:#9ca3af;font-size:0.95rem}
        .dept-search-input{width:100%;padding:8px 12px 8px 36px;border:1px solid #e5e7eb;border-radius:8px;font-size:0.84rem;background:#f9fafb;color:#111827;outline:none;transition:border-color 0.15s,background 0.15s;box-sizing:border-box}
        .dept-search-input:focus{border-color:#2563eb;background:#fff;box-shadow:0 0 0 3px rgba(37,99,235,0.1)}
        .dept-search-select{padding:8px 12px;border:1px solid #e5e7eb;border-radius:8px;font-size:0.83rem;background:#f9fafb;color:#374151;outline:none;cursor:pointer;min-width:140px}
        .dept-search-select:focus{border-color:#2563eb;background:#fff}
        .btn-reset-filter{display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border:1px dashed #d1d5db;border-radius:8px;background:transparent;color:#6b7280;font-size:0.82rem;cursor:pointer;transition:all 0.15s;white-space:nowrap}
        .btn-reset-filter:hover{border-color:#ef4444;color:#ef4444;background:#fef2f2}
        .dept-table-wrap{background:#fff;border:1px solid #e5e7eb;border-radius:14px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,0.04)}
        .dept-table-header-bar{display:flex;justify-content:space-between;align-items:center;padding:16px 20px 14px;border-bottom:1px solid #f3f4f6}
        .dept-table-title{font-size:0.88rem;font-weight:600;color:#111827}
        .dept-table-subtitle{font-size:0.75rem;color:#6b7280;margin-left:8px}
        .dept-cols-badge{font-size:0.72rem;color:#6b7280;background:#f3f4f6;padding:3px 10px;border-radius:6px}
        .dept-table{width:100%;border-collapse:collapse}
        .dept-table thead th{background:#f8fafc;padding:11px 16px;font-size:0.72rem;font-weight:700;letter-spacing:0.05em;text-transform:uppercase;color:#6b7280;border-bottom:1px solid #e5e7eb;white-space:nowrap}
        .dept-table thead th:first-child{padding-left:20px}
        .dept-table thead th:last-child{padding-right:20px;text-align:right}
        .dept-table tbody tr{border-bottom:1px solid #f3f4f6;transition:background 0.12s}
        .dept-table tbody tr:last-child{border-bottom:none}
        .dept-table tbody tr:hover{background:#f8faff}
        .dept-table tbody td{padding:14px 16px;font-size:0.84rem;color:#374151;vertical-align:middle}
        .dept-table tbody td:first-child{padding-left:20px}
        .dept-table tbody td:last-child{padding-right:20px}
        .dept-cb{width:16px;height:16px;accent-color:#2563eb;cursor:pointer}
        .dept-code-badge{display:inline-block;font-size:0.7rem;font-weight:700;padding:3px 8px;border-radius:6px;font-family:'Courier New',monospace;letter-spacing:0.04em}
        .dept-code-blue{background:#dbeafe;color:#1d4ed8}
        .dept-code-green{background:#dcfce7;color:#15803d}
        .dept-code-purple{background:#ede9fe;color:#6d28d9}
        .dept-code-amber{background:#fef3c7;color:#92400e}
        .dept-code-pink{background:#fce7f3;color:#9d174d}
        .dept-code-teal{background:#ccfbf1;color:#0f766e}
        .dept-code-red{background:#fee2e2;color:#b91c1c}
        .dept-code-slate{background:#f1f5f9;color:#475569}
        .dept-name-cell{display:flex;align-items:flex-start;gap:10px}
        .dept-icon-circle{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:0.85rem;flex-shrink:0;font-weight:700}
        .dept-name-main{font-weight:600;color:#111827;font-size:0.87rem;line-height:1.3}
        .dept-name-meta{font-size:0.73rem;color:#6b7280;margin-top:2px}
        .dept-manager-cell{display:flex;align-items:center;gap:8px}
        .dept-manager-avatar{width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#2563eb,#7c3aed);color:#fff;display:flex;align-items:center;justify-content:center;font-size:0.7rem;font-weight:700;flex-shrink:0}
        .dept-manager-name{font-weight:500;color:#111827;font-size:0.83rem}
        .dept-manager-title{font-size:0.72rem;color:#6b7280}
        .dept-manager-vacant{display:inline-flex;align-items:center;gap:5px;font-size:0.78rem;color:#d97706;background:#fffbeb;padding:4px 10px;border-radius:6px;border:1px dashed #fbbf24}
        .dept-emp-count{font-weight:700;color:#111827;font-size:0.95rem}
        .dept-emp-unit{font-size:0.72rem;color:#6b7280}
        .dept-progress-bar{width:80px;height:4px;background:#e5e7eb;border-radius:2px;margin-top:5px;overflow:hidden}
        .dept-progress-fill{height:100%;border-radius:2px;background:linear-gradient(90deg,#2563eb,#60a5fa);transition:width 0.5s ease}
        .dept-progress-pct{font-size:0.7rem;color:#2563eb;font-weight:600}
        .status-pill{display:inline-flex;align-items:center;gap:5px;font-size:0.75rem;font-weight:600;padding:4px 11px;border-radius:20px}
        .status-pill-active{background:#dcfce7;color:#15803d}
        .status-pill-restructure{background:#fef3c7;color:#92400e}
        .status-dot{width:6px;height:6px;border-radius:50%}
        .dot-active{background:#16a34a}
        .dot-restructure{background:#d97706}
        .dept-date{font-size:0.82rem;color:#374151;font-weight:500}
        .dept-date-year{font-size:0.72rem;color:#9ca3af}
        .dept-actions{display:flex;align-items:center;gap:4px;justify-content:flex-end}
        .dept-action-btn{width:30px;height:30px;border-radius:7px;border:1px solid #e5e7eb;background:#fff;display:inline-flex;align-items:center;justify-content:center;font-size:0.85rem;cursor:pointer;transition:all 0.15s;color:#6b7280;text-decoration:none}
        .dept-action-btn:hover{border-color:#93c5fd;background:#eff6ff;color:#2563eb}
        .dept-action-btn.edit:hover{border-color:#6ee7b7;background:#ecfdf5;color:#059669}
        .dept-action-btn.del:hover{border-color:#fca5a5;background:#fef2f2;color:#dc2626}
        .dept-action-btn.more:hover{border-color:#c4b5fd;background:#f5f3ff;color:#7c3aed}
        .dept-table-footer{padding:14px 20px;border-top:1px solid #f3f4f6;display:flex;justify-content:space-between;align-items:center;font-size:0.8rem;color:#6b7280;background:#fafafa}
        .dept-empty-state{padding:64px 20px;text-align:center}
        .dept-empty-icon{width:72px;height:72px;border-radius:18px;background:#eff6ff;color:#2563eb;font-size:2rem;display:flex;align-items:center;justify-content:center;margin:0 auto 16px}
        .dept-empty-title{font-size:1rem;font-weight:600;color:#111827;margin-bottom:6px}
        .dept-empty-desc{font-size:0.83rem;color:#6b7280}
    </style>
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="departments" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>
        <div class="app-content">
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${param.success eq 'added'}">Them phong ban moi thanh cong!</c:when>
                        <c:when test="${param.success eq 'updated'}">Cap nhat thong tin phong ban thanh cong!</c:when>
                        <c:when test="${param.success eq 'deleted'}">Da xoa phong ban thanh cong.</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2 text-danger"></i>
                    <c:out value="${param.error}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:set var="totalEmp" value="0"/>
            <c:set var="deptCount" value="${not empty departments ? fn:length(departments) : 0}"/>
            <c:forEach var="dept" items="${departments}">
                <c:set var="totalEmp" value="${totalEmp + (not empty dept.employeeCount ? dept.employeeCount : 0)}"/>
            </c:forEach>
            <c:set var="maxEmpCount" value="1"/>
            <c:forEach var="dept" items="${departments}">
                <c:if test="${dept.employeeCount > maxEmpCount}">
                    <c:set var="maxEmpCount" value="${dept.employeeCount}"/>
                </c:if>
            </c:forEach>

            <div class="dept-page-header">
                <div>
                    <h1 class="dept-page-title">
                        Quan ly phong ban
                        <span class="badge-count">${deptCount} phong ban</span>
                        <span class="dept-update-tag">Cap nhat: Hom nay 09:30</span>
                    </h1>
                    <p class="dept-page-subtitle">Quan ly co cau to chuc, so do phong ban va phan bo nhan su truc thuoc Tap doan MIXIMOI</p>
                </div>
                <div class="dept-header-actions">
                    <button class="btn-export" onclick="alert('Tinh nang xuat Excel dang phat trien')">
                        <i class="bi bi-download"></i> Xuat Excel
                    </button>
                    <button class="btn-org-chart" onclick="alert('So do to chuc dang phat trien')">
                        <i class="bi bi-diagram-3"></i> So do to chuc (Org Chart)
                    </button>
                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                        <a href="${pageContext.request.contextPath}/departments?action=new" class="btn-add-dept">
                            <i class="bi bi-plus-circle-fill"></i> Them phong ban
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="dept-kpi-grid">
                <div class="dept-kpi-card">
                    <div class="dept-kpi-top">
                        <div>
                            <div class="dept-kpi-label">Tong so phong ban</div>
                            <div class="dept-kpi-value-row">
                                <span class="dept-kpi-value">${deptCount}</span>
                            </div>
                        </div>
                        <div class="dept-kpi-icon"><i class="bi bi-buildings"></i></div>
                    </div>
                    <div class="dept-kpi-footer">
                        <span class="dept-kpi-footer-main"><i class="bi bi-arrow-up-circle-fill text-success me-1"></i>+1 phong ban moi nam nay</span>
                        <span class="dept-kpi-badge-pos"><i class="bi bi-check2"></i> Hoat dong</span>
                    </div>
                </div>
                <div class="dept-kpi-card green">
                    <div class="dept-kpi-top">
                        <div>
                            <div class="dept-kpi-label">Tong nhan su truc thuoc</div>
                            <div class="dept-kpi-value-row">
                                <span class="dept-kpi-value">${totalEmp}</span>
                            </div>
                        </div>
                        <div class="dept-kpi-icon green"><i class="bi bi-people-fill"></i></div>
                    </div>
                    <div class="dept-kpi-footer">
                        <span class="dept-kpi-footer-main"><span style="color:#16a34a;font-weight:600">100%</span> nhan su da dinh danh co cau</span>
                        <span class="dept-kpi-badge-neutral">Dang lam viec</span>
                    </div>
                </div>
                <div class="dept-kpi-card amber">
                    <div class="dept-kpi-top">
                        <div>
                            <div class="dept-kpi-label">Quy mo trung binh</div>
                            <div class="dept-kpi-value-row">
                                <span class="dept-kpi-value">
                                    <c:choose>
                                        <c:when test="${deptCount > 0}"><fmt:formatNumber value="${totalEmp / deptCount}" maxFractionDigits="1"/></c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="dept-kpi-unit">NV/phong</span>
                            </div>
                        </div>
                        <div class="dept-kpi-icon amber"><i class="bi bi-pie-chart-fill"></i></div>
                    </div>
                    <div class="dept-kpi-footer">
                        <span class="dept-kpi-footer-main">Lon nhat: <strong style="color:#d97706">Kinh doanh</strong></span>
                        <span class="dept-kpi-badge-neutral">Chuan toi uu</span>
                    </div>
                </div>
                <div class="dept-kpi-card violet">
                    <div class="dept-kpi-top">
                        <div>
                            <div class="dept-kpi-label">Vi tri truong phong</div>
                            <div class="dept-kpi-value-row">
                                <span class="dept-kpi-value">${deptCount}</span>
                                <span class="dept-kpi-unit">/ ${deptCount}</span>
                            </div>
                        </div>
                        <div class="dept-kpi-icon violet"><i class="bi bi-person-badge-fill"></i></div>
                    </div>
                    <div class="dept-kpi-footer">
                        <span class="dept-kpi-footer-main"><span style="color:#7c3aed;font-weight:600">1 khuyet</span> Dang hoan tat tuyen dung</span>
                        <span class="dept-kpi-badge-neutral">Du lanh dao</span>
                    </div>
                </div>
            </div>

            <div class="dept-search-bar">
                <div class="dept-search-input-wrap">
                    <i class="bi bi-search"></i>
                    <input type="text" class="dept-search-input" id="deptSearchInput"
                           placeholder="Tim theo ten phong ban, ma PB, truong phong..."
                           oninput="filterDeptTable()">
                </div>
                <select class="dept-search-select" id="deptStatusFilter" onchange="filterDeptTable()">
                    <option value="">Tat ca trang thai</option>
                    <option value="active">Hoat dong</option>
                    <option value="restructure">Tai co cau</option>
                </select>
                <select class="dept-search-select" id="deptSizeFilter" onchange="filterDeptTable()">
                    <option value="">Tat ca quy mo</option>
                    <option value="small">Nho (&lt; 20 NV)</option>
                    <option value="medium">Vua (20-50 NV)</option>
                    <option value="large">Lon (&gt; 50 NV)</option>
                </select>
                <button class="btn-reset-filter" onclick="resetFilter()">
                    <i class="bi bi-arrow-counterclockwise"></i> Dat lai
                </button>
            </div>

            <div class="dept-table-wrap">
                <div class="dept-table-header-bar">
                    <div>
                        <span class="dept-table-title">Danh sach cau truc phong ban</span>
                        <span class="dept-table-subtitle">/ Hien thi phan bo nguon luc &amp; nhan su chu chot</span>
                    </div>
                    <span class="dept-cols-badge"><i class="bi bi-layout-three-columns me-1"></i>8 cot du lieu chuan ERP</span>
                </div>
                <div class="table-responsive">
                    <table class="dept-table" id="deptTable">
                        <thead>
                            <tr>
                                <th><input type="checkbox" class="dept-cb" id="checkAll" onchange="toggleAll(this)"></th>
                                <th>Ma PB</th>
                                <th>Ten phong ban &amp; khoi nghiep vu</th>
                                <th>Truong phong / Quan ly</th>
                                <th>Nhan vien / Ty trong</th>
                                <th>Ngay thanh lap</th>
                                <th>Trang thai</th>
                                <th style="text-align:right">Thao tac</th>
                            </tr>
                        </thead>
                        <tbody id="deptTableBody">
                            <c:choose>
                                <c:when test="${empty departments}">
                                    <tr>
                                        <td colspan="8">
                                            <div class="dept-empty-state">
                                                <div class="dept-empty-icon"><i class="bi bi-buildings"></i></div>
                                                <div class="dept-empty-title">Chua co phong ban nao</div>
                                                <div class="dept-empty-desc">He thong chua co du lieu phong ban. Hay them phong ban dau tien!</div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="dept" items="${departments}" varStatus="loop">
                                        <c:set var="pct" value="${(dept.employeeCount * 100) / maxEmpCount}"/>
                                        <c:set var="ck" value="${loop.index % 8}"/>
                                        <tr class="dept-row"
                                            data-name="${fn:toLowerCase(dept.name)}"
                                            data-code="pb${loop.index < 9 ? '0' : ''}${loop.index + 1}"
                                            data-status="${dept.employeeCount > 0 ? 'active' : 'restructure'}"
                                            data-emp="${dept.employeeCount}">
                                            <td><input type="checkbox" class="dept-cb row-cb"></td>
                                            <td>
                                                <span class="dept-code-badge ${ck == 0 ? 'dept-code-blue' : ck == 1 ? 'dept-code-green' : ck == 2 ? 'dept-code-purple' : ck == 3 ? 'dept-code-amber' : ck == 4 ? 'dept-code-pink' : ck == 5 ? 'dept-code-teal' : ck == 6 ? 'dept-code-red' : 'dept-code-slate'}">
                                                    PB${loop.index < 9 ? '0' : ''}${loop.index + 1}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="dept-name-cell">
                                                    <div class="dept-icon-circle"
                                                         style="${ck % 4 == 0 ? 'background:#eff6ff;color:#2563eb' : ck % 4 == 1 ? 'background:#f0fdf4;color:#16a34a' : ck % 4 == 2 ? 'background:#f5f3ff;color:#7c3aed' : 'background:#fffbeb;color:#d97706'}">
                                                        <c:out value="${fn:substring(dept.name, 0, 2)}"/>
                                                    </div>
                                                    <div>
                                                        <div class="dept-name-main"><c:out value="${dept.name}"/></div>
                                                        <div class="dept-name-meta">
                                                            <c:choose>
                                                                <c:when test="${not empty dept.description}">
                                                                    <c:out value="${fn:substring(dept.description, 0, 45)}"/>
                                                                    <c:if test="${fn:length(dept.description) > 45}">...</c:if>
                                                                </c:when>
                                                                <c:otherwise>Tang ${(loop.index % 8) + 1} - Thap ${loop.index % 2 == 0 ? 'A' : 'B'}</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${dept.employeeCount > 0}">
                                                        <div class="dept-manager-cell">
                                                            <div class="dept-manager-avatar">TP</div>
                                                            <div>
                                                                <div class="dept-manager-name">Truong phong ${loop.index + 1}</div>
                                                                <div class="dept-manager-title">Quan ly - <c:out value="${fn:substring(dept.name,0,20)}"/></div>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="dept-manager-vacant">
                                                            <i class="bi bi-person-dash"></i> Dang tuyen dung
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/employees?departmentId=${dept.id}" style="text-decoration:none">
                                                    <span class="dept-emp-count">${dept.employeeCount}</span>
                                                    <span class="dept-emp-unit"> NV</span>
                                                </a>
                                                <div class="dept-progress-bar">
                                                    <div class="dept-progress-fill" style="width:<fmt:formatNumber value='${pct}' maxFractionDigits='0'/>%"></div>
                                                </div>
                                                <div class="dept-progress-pct"><fmt:formatNumber value="${pct}" maxFractionDigits="1"/>%</div>
                                            </td>
                                            <td>
                                                <div class="dept-date">
                                                    ${loop.index % 3 == 0 ? '15/03' : loop.index % 3 == 1 ? '10/01' : '05/08'}/202${loop.index % 4 == 0 ? '1' : loop.index % 4 == 1 ? '0' : loop.index % 4 == 2 ? '1' : '2'}
                                                </div>
                                                <div class="dept-date-year">Nam thu ${2026 - (2019 + loop.index % 4)}</div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${dept.employeeCount == 0}">
                                                        <span class="status-pill status-pill-restructure">
                                                            <span class="status-dot dot-restructure"></span>Tai co cau
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-pill-active">
                                                            <span class="status-dot dot-active"></span>Hoat dong
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="dept-actions">
                                                    <a href="${pageContext.request.contextPath}/employees?departmentId=${dept.id}"
                                                       class="dept-action-btn" title="Xem nhan vien">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                                                        <a href="${pageContext.request.contextPath}/departments?action=edit&id=${dept.id}"
                                                           class="dept-action-btn edit" title="Chinh sua">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <button class="dept-action-btn del" title="Xoa"
                                                                data-id="${dept.id}"
                                                                data-name="<c:out value='${dept.name}'/>"
                                                                data-emp-count="${dept.employeeCount}"
                                                                onclick="confirmDeleteDept(this)">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </c:if>
                                                    <button class="dept-action-btn more" title="Them tuy chon">
                                                        <i class="bi bi-three-dots-vertical"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                <c:if test="${not empty departments}">
                    <div class="dept-table-footer">
                        <span>Tong cong: <strong id="visibleCount">${deptCount}</strong> phong ban</span>
                        <span>MIXIMOI Organization Structure - ERP v2.0</span>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="deleteDeptModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:420px">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;overflow:hidden">
            <div style="background:linear-gradient(135deg,#fef2f2,#fee2e2);padding:24px 24px 16px">
                <div style="display:flex;align-items:center;gap:12px">
                    <div style="width:44px;height:44px;border-radius:12px;background:#fee2e2;display:flex;align-items:center;justify-content:center;font-size:1.3rem;color:#dc2626;border:2px solid #fca5a5">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                    </div>
                    <div>
                        <h6 style="font-weight:700;color:#991b1b;margin:0">Xac nhan xoa phong ban</h6>
                        <p style="font-size:0.78rem;color:#b91c1c;margin:0">Thao tac nay khong the hoan tac</p>
                    </div>
                </div>
            </div>
            <div class="modal-body" style="padding:20px 24px">
                <p style="font-size:0.87rem;color:#374151;margin-bottom:12px">
                    Ban co chac chan muon xoa phong ban <strong id="deleteDeptName" class="text-dark"></strong>?
                </p>
                <div id="deptWarning" class="d-none" style="background:#fffbeb;border:1px solid #fbbf24;border-radius:8px;padding:10px 14px;font-size:0.78rem;color:#92400e">
                    <i class="bi bi-info-circle-fill me-2 text-warning"></i>
                    Phong ban nay dang co nhan vien truc thuoc! Hay chuyen nhan vien truoc khi xoa.
                </div>
            </div>
            <div class="modal-footer" style="padding:16px 24px;border-top:1px solid #f3f4f6;gap:10px">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal" style="border-radius:8px">Huy bo</button>
                <form method="post" action="${pageContext.request.contextPath}/departments" id="deleteDeptForm" style="margin:0">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteDeptId">
                    <button type="submit" class="btn btn-danger" style="border-radius:8px;font-weight:600">
                        <i class="bi bi-trash me-1"></i> Xac nhan xoa
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    function confirmDeleteDept(btn) {
        const id = btn.getAttribute('data-id');
        const name = btn.getAttribute('data-name');
        const empCount = parseInt(btn.getAttribute('data-emp-count') || '0', 10);
        document.getElementById('deleteDeptId').value = id;
        document.getElementById('deleteDeptName').textContent = name;
        document.getElementById('deptWarning').classList.toggle('d-none', empCount === 0);
        new bootstrap.Modal(document.getElementById('deleteDeptModal')).show();
    }
    function toggleAll(master) {
        document.querySelectorAll('.row-cb').forEach(cb => cb.checked = master.checked);
    }
    function filterDeptTable() {
        const q = document.getElementById('deptSearchInput').value.toLowerCase();
        const status = document.getElementById('deptStatusFilter').value;
        const size   = document.getElementById('deptSizeFilter').value;
        let visible  = 0;
        document.querySelectorAll('#deptTableBody .dept-row').forEach(row => {
            const name    = row.dataset.name || '';
            const code    = row.dataset.code || '';
            const rStatus = row.dataset.status || '';
            const emp     = parseInt(row.dataset.emp || '0', 10);
            const matchQ      = !q      || name.includes(q) || code.includes(q);
            const matchStatus = !status || rStatus === status;
            let   matchSize   = true;
            if (size === 'small')  matchSize = emp < 20;
            if (size === 'medium') matchSize = emp >= 20 && emp <= 50;
            if (size === 'large')  matchSize = emp > 50;
            const show = matchQ && matchStatus && matchSize;
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        const vc = document.getElementById('visibleCount');
        if (vc) vc.textContent = visible;
    }
    function resetFilter() {
        document.getElementById('deptSearchInput').value = '';
        document.getElementById('deptStatusFilter').value = '';
        document.getElementById('deptSizeFilter').value = '';
        filterDeptTable();
    }
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.dept-kpi-value').forEach(el => {
            const raw = el.textContent.trim().replace(',', '.');
            const target = parseFloat(raw);
            if (isNaN(target) || target <= 0) return;
            let current = 0;
            const step = target / 28;
            const timer = setInterval(() => {
                current = Math.min(current + step, target);
                el.textContent = Number.isInteger(target) ? Math.round(current) : current.toFixed(1);
                if (current >= target) clearInterval(timer);
            }, 22);
        });
    });
</script>
</body>
</html>