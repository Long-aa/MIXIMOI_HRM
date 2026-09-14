<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ: ${employee.fullName} — MIXIMOI HRM & PAYROLL</title>
    <meta name="description" content="Hồ sơ nhân sự ${employee.fullName} - Mã ${employee.employeeCode}">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        .profile-hero {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 60%, #3b82f6 100%);
            border-radius: 18px; padding: 2rem 2rem 0; margin-bottom: 0;
            position: relative; overflow: hidden;
        }
        .profile-hero::before {
            content: ""; position: absolute; top: -40%; right: -10%; width: 380px; height: 380px;
            background: radial-gradient(circle, rgba(255,255,255,0.1), transparent 70%);
            border-radius: 50%;
        }
        .profile-avatar-xl {
            width: 88px; height: 88px; border-radius: 50%;
            background: linear-gradient(135deg, #60a5fa, #93c5fd);
            color: #fff; font-size: 2.2rem; font-weight: 800;
            display: flex; align-items: center; justify-content: center;
            border: 4px solid rgba(255,255,255,0.4);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .profile-hero-body {
            display: flex; align-items: flex-end; gap: 1.5rem;
            justify-content: space-between; flex-wrap: wrap;
        }
        .profile-hero-name { color: #fff; font-size: 1.6rem; font-weight: 800; margin: 0; line-height: 1.1; }
        .profile-hero-code {
            background: rgba(255,255,255,0.18); color: #e0e7ff;
            border-radius: 6px; padding: 2px 10px; font-size: 0.82rem;
            font-weight: 700; font-family: monospace; border: 1px solid rgba(255,255,255,0.25);
        }
        .profile-hero-role { color: #bfdbfe; font-size: 0.9rem; margin-top: 4px; }
        .profile-hero-tabs {
            display: flex; gap: 4px; margin-top: 1.5rem;
        }
        .profile-tab {
            padding: 10px 20px; border-radius: 8px 8px 0 0;
            font-size: 0.83rem; font-weight: 600; color: rgba(255,255,255,0.65);
            cursor: pointer; transition: all 0.15s; border: none; background: transparent;
            text-decoration: none; display: inline-block;
        }
        .profile-tab.active { background: #fff; color: #1e293b; }
        .profile-tab:hover:not(.active) { background: rgba(255,255,255,0.1); color: #fff; }

        /* Info row */
        .info-card {
            background: #fff; border-radius: 14px; border: 1.5px solid #f1f5f9;
            box-shadow: 0 2px 10px rgba(15,23,42,0.04); overflow: hidden; margin-bottom: 1rem;
        }
        .info-card-header {
            background: #f8fafc; padding: 0.85rem 1.25rem;
            border-bottom: 1px solid #f1f5f9;
            display: flex; align-items: center; gap: 10px;
        }
        .info-card-header i { color: #2563eb; font-size: 1.05rem; }
        .info-card-title { font-weight: 700; font-size: 0.9rem; color: #1e293b; }
        .info-card-body { padding: 1.1rem 1.25rem; }
        .info-row {
            display: flex; align-items: flex-start; gap: 0.5rem;
            padding: 0.5rem 0; border-bottom: 1px solid #f8fafc; font-size: 0.875rem;
        }
        .info-row:last-child { border-bottom: none; padding-bottom: 0; }
        .info-label { flex: 0 0 170px; color: #64748b; font-size: 0.8rem; }
        .info-value { flex: 1; color: #1e293b; font-weight: 500; }

        /* Status pills */
        .sp-active   { display:inline-flex; align-items:center; gap:5px; background:#ecfdf5; color:#059669; border:1px solid #a7f3d0; border-radius:999px; padding:4px 14px; font-size:0.82rem; font-weight:700; }
        .sp-onleave  { display:inline-flex; align-items:center; gap:5px; background:#fffbeb; color:#d97706; border:1px solid #fde68a; border-radius:999px; padding:4px 14px; font-size:0.82rem; font-weight:700; }
        .sp-inactive { display:inline-flex; align-items:center; gap:5px; background:#fef2f2; color:#dc2626; border:1px solid #fecaca; border-radius:999px; padding:4px 14px; font-size:0.82rem; font-weight:700; }

        .badge-dept {
            background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe;
            border-radius: 7px; padding: 2px 10px; font-size: 0.8rem; font-weight: 600;
        }
    </style>
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="employees" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <!-- Breadcrumb & Actions -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-3">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" style="font-size:0.82rem;">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employees" class="text-decoration-none">Nhân viên</a></li>
                        <li class="breadcrumb-item active">${employee.fullName} (${employee.employeeCode})</li>
                    </ol>
                </nav>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/employees" class="btn btn-light btn-sm border px-3" style="border-radius:9px; font-size:0.83rem;">
                        <i class="bi bi-arrow-left me-1"></i> Quay lại
                    </a>
                    <button type="button" class="btn btn-light btn-sm border px-3" style="border-radius:9px; font-size:0.83rem;" onclick="window.print()">
                        <i class="bi bi-printer me-1"></i> In hồ sơ
                    </button>
                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                        <a href="${pageContext.request.contextPath}/employees?action=edit&id=${employee.id}"
                           class="btn btn-primary btn-sm px-3" style="border-radius:9px; font-size:0.83rem;">
                            <i class="bi bi-pencil-square me-1"></i> Chỉnh sửa hồ sơ
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Profile Hero Banner -->
            <div class="profile-hero mb-0">
                <div class="profile-hero-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="profile-avatar-xl">
                            <c:choose>
                                <c:when test="${not empty employee.fullName}">${employee.fullName.substring(0,1).toUpperCase()}</c:when>
                                <c:otherwise>NV</c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <div class="d-flex align-items-center gap-2 flex-wrap">
                                <h2 class="profile-hero-name">${employee.fullName}</h2>
                                <span class="profile-hero-code">${employee.employeeCode}</span>
                            </div>
                            <div class="profile-hero-role">
                                <i class="bi bi-briefcase me-1"></i>${employee.positionName}
                                &nbsp;•&nbsp;
                                <i class="bi bi-building me-1"></i>${employee.departmentName}
                            </div>
                        </div>
                    </div>
                    <div class="mb-2">
                        <c:choose>
                            <c:when test="${employee.status eq 'ACTIVE'}">
                                <span class="sp-active"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Đang công tác</span>
                            </c:when>
                            <c:when test="${employee.status eq 'ON_LEAVE'}">
                                <span class="sp-onleave"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Nghỉ tạm thời</span>
                            </c:when>
                            <c:otherwise>
                                <span class="sp-inactive"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Đã nghỉ việc</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="profile-hero-tabs">
                    <a href="#tabProfile" class="profile-tab active">Hồ sơ cá nhân</a>
                    <a href="#tabJob" class="profile-tab">Công tác & Vị trí</a>
                    <a href="#tabContract" class="profile-tab">Hợp đồng</a>
                </div>
            </div>

            <!-- Profile Body -->
            <div class="row g-3 mt-1">
                <!-- Personal Info -->
                <div class="col-lg-6">
                    <div class="info-card">
                        <div class="info-card-header">
                            <i class="bi bi-person-vcard-fill"></i>
                            <span class="info-card-title">Thông tin cá nhân</span>
                        </div>
                        <div class="info-card-body">
                            <div class="info-row">
                                <span class="info-label">Mã định danh hệ thống</span>
                                <span class="info-value" style="font-family:monospace; color:#2563eb; font-weight:700;">EMP-#${employee.id}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Họ và tên đầy đủ</span>
                                <span class="info-value">${employee.fullName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Ngày sinh</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${employee.dateOfBirth != null}">${employee.dateOfBirth}</c:when>
                                        <c:otherwise><span class="text-muted fst-italic">Chưa cập nhật</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Giới tính</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${employee.gender eq 'MALE'}"><i class="bi bi-gender-male text-primary me-1"></i>Nam</c:when>
                                        <c:when test="${employee.gender eq 'FEMALE'}"><i class="bi bi-gender-female text-danger me-1"></i>Nữ</c:when>
                                        <c:otherwise><i class="bi bi-gender-ambiguous text-info me-1"></i>Khác</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="info-card">
                        <div class="info-card-header">
                            <i class="bi bi-telephone-fill"></i>
                            <span class="info-card-title">Thông tin liên lạc</span>
                        </div>
                        <div class="info-card-body">
                            <div class="info-row">
                                <span class="info-label">Email làm việc</span>
                                <span class="info-value">
                                    <a href="mailto:${employee.email}" class="text-primary text-decoration-none">
                                        <i class="bi bi-envelope me-1"></i>${employee.email}
                                    </a>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Số điện thoại</span>
                                <span class="info-value">
                                    <a href="tel:${employee.phone}" class="text-primary text-decoration-none">
                                        <i class="bi bi-telephone-outbound me-1"></i>${employee.phone}
                                    </a>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Địa chỉ cư trú</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty employee.address}">${employee.address}</c:when>
                                        <c:otherwise><span class="text-muted fst-italic">Chưa cập nhật</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Job & Org Info -->
                <div class="col-lg-6">
                    <div class="info-card">
                        <div class="info-card-header">
                            <i class="bi bi-building-gear"></i>
                            <span class="info-card-title">Vị trí & Tổ chức công tác</span>
                        </div>
                        <div class="info-card-body">
                            <div class="info-row">
                                <span class="info-label">Phòng ban</span>
                                <span class="info-value">
                                    <span class="badge-dept">${employee.departmentName}</span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Chức danh / Chức vụ</span>
                                <span class="info-value fw-bold">${employee.positionName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Loại hình nhân sự</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${employee.employeeTypeId == 1}">Nhân viên chính thức</c:when>
                                        <c:when test="${employee.employeeTypeId == 2}">Nhân viên thử việc</c:when>
                                        <c:when test="${employee.employeeTypeId == 3}">Nhân viên thời vụ</c:when>
                                        <c:otherwise>Cộng tác viên</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Ngày vào công ty</span>
                                <span class="info-value">${employee.startDate}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Trạng thái công tác</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${employee.status eq 'ACTIVE'}"><span class="sp-active" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Đang làm việc bình thường</span></c:when>
                                        <c:when test="${employee.status eq 'ON_LEAVE'}"><span class="sp-onleave" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Đang nghỉ tạm thời</span></c:when>
                                        <c:otherwise><span class="sp-inactive" style="font-size:0.75rem; padding:2px 10px;"><i class="bi bi-circle-fill" style="font-size:0.4rem;"></i> Đã chấm dứt hợp đồng</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Stats -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <i class="bi bi-bar-chart-fill"></i>
                            <span class="info-card-title">Thống kê nhanh</span>
                        </div>
                        <div class="info-card-body">
                            <div class="row g-2">
                                <div class="col-6">
                                    <div style="background:#f8fafc; border-radius:10px; padding:0.85rem; text-align:center;">
                                        <div style="font-size:1.4rem; font-weight:800; color:#2563eb;">—</div>
                                        <div style="font-size:0.73rem; color:#64748b; font-weight:500;">Ngày nghỉ phép còn lại</div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div style="background:#f8fafc; border-radius:10px; padding:0.85rem; text-align:center;">
                                        <div style="font-size:1.4rem; font-weight:800; color:#059669;">—</div>
                                        <div style="font-size:0.73rem; color:#64748b; font-weight:500;">Số tháng công tác</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Danger Zone -->
                    <c:if test="${sessionScope.currentUser.canManageEmployees()}">
                        <div class="info-card" style="border-color:#fecaca;">
                            <div class="info-card-header" style="background:#fef2f2; border-bottom-color:#fecaca;">
                                <i class="bi bi-shield-exclamation text-danger"></i>
                                <span class="info-card-title" style="color:#dc2626;">Tác vụ nguy hiểm</span>
                            </div>
                            <div class="info-card-body">
                                <p class="text-muted mb-3" style="font-size:0.83rem;">Vô hiệu hóa sẽ chuyển nhân viên này sang trạng thái <em>Đã nghỉ việc</em>. Dữ liệu lịch sử vẫn được lưu trữ đầy đủ.</p>
                                <button type="button" class="btn btn-outline-danger btn-sm px-3" style="border-radius:9px; font-size:0.83rem;" onclick="confirmDeactivate()">
                                    <i class="bi bi-person-x me-1"></i> Vô hiệu hóa nhân viên
                                </button>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Deactivate Modal -->
<div class="modal fade" id="deactivateModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:400px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;">
            <div class="modal-header border-0" style="background:#fef2f2; padding:1.25rem 1.5rem 0.75rem;">
                <h6 class="modal-title fw-bold text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i> Xác nhận vô hiệu hóa
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body px-4 py-3" style="font-size:0.88rem;">
                Bạn có chắc muốn vô hiệu hóa nhân sự <strong>${employee.fullName}</strong> (${employee.employeeCode})?
            </div>
            <div class="modal-footer border-0 px-4 pb-4 gap-2">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/employees" class="d-inline">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${employee.id}">
                    <button type="submit" class="btn btn-danger btn-sm px-4">Xác nhận vô hiệu hóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    function confirmDeactivate() {
        new bootstrap.Modal(document.getElementById('deactivateModal')).show();
    }
</script>
</body>
</html>
