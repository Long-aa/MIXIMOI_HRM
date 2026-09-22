<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý chấm công — MIXIMOI HRM &amp; PAYROLL</title>
    <meta name="description" content="Theo dõi dữ liệu chấm công thời gian thực, quản lý ca làm, đi muộn, về sớm và tổng hợp công tháng MIXIMOI HRM">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/attendance.css">
</head>
<body>

<div class="app-container">
    <c:set var="activeMenu" value="attendance" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <%-- ============================================================
                 EMPLOYEE ROLE: Chấm công cá nhân + Lịch sử
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">

                <!-- Alerts -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                        <i class="bi bi-check-circle-fill me-2 text-success"></i>
                        <c:choose>
                            <c:when test="${param.success eq 'checkin'}">
                                <c:choose>
                                    <c:when test="${param.method eq 'FaceID'}"><i class="bi bi-person-bounding-box me-1 text-primary"></i> <strong>Nhận diện khuôn mặt (FaceID)</strong> thành công!</c:when>
                                    <c:when test="${param.method eq 'Fingerprint'}"><i class="bi bi-fingerprint me-1 text-warning"></i> <strong>Quét vân tay (Fingerprint)</strong> xác thực thành công!</c:when>
                                    <c:when test="${param.method eq 'GPS'}"><i class="bi bi-geo-alt-fill me-1 text-success"></i> <strong>GPS Mobile</strong> xác thực vị trí thành công!</c:when>
                                    <c:otherwise><i class="bi bi-check-circle me-1"></i> Check-in ghi nhận thành công!</c:otherwise>
                                </c:choose>
                                Chúc bạn một ngày làm việc hiệu quả! 🎉
                            </c:when>
                            <c:when test="${param.success eq 'checkout'}"><i class="bi bi-box-arrow-right me-1"></i> Ghi nhận Check-out thành công! Cảm ơn bạn đã hoàn thành ca hôm nay.</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Employee Banner + Check-in/out with Biometric Methods -->
                <div class="emp-att-banner">
                    <div class="emp-att-banner-left">
                        <div class="emp-att-banner-icon"><i class="bi bi-fingerprint"></i></div>
                        <div>
                            <h1 style="font-size:1.25rem; font-weight:800; color:#0f172a; margin-bottom:3px;">Chấm công của tôi</h1>
                            <p class="att-subtitle">Chấm công bằng <strong>Vân tay</strong>, <strong>FaceID</strong> hoặc <strong>GPS</strong> — Đồng bộ thời gian thực</p>
                        </div>
                    </div>
                    <div class="emp-att-checkin-area">
                        <!-- Biometric Method Selector -->
                        <div style="display:flex; gap:8px; flex-wrap:wrap; align-items:center;">
                            <!-- FaceID Check-in -->
                            <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline">
                                <input type="hidden" name="action" value="checkin">
                                <input type="hidden" name="method" value="FaceID">
                                <button type="submit" class="btn-employee-checkin" id="btnCheckinFaceID"
                                        style="background: linear-gradient(135deg, #7c3aed, #a855f7);"
                                        title="Nhận diện khuôn mặt">
                                    <i class="bi bi-person-bounding-box"></i> FaceID
                                </button>
                            </form>
                            <!-- Fingerprint Check-in -->
                            <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline">
                                <input type="hidden" name="action" value="checkin">
                                <input type="hidden" name="method" value="Fingerprint">
                                <button type="submit" class="btn-employee-checkin" id="btnCheckinFingerprint"
                                        title="Quét vân tay">
                                    <i class="bi bi-fingerprint"></i> Vân tay
                                </button>
                            </form>
                            <!-- GPS WFH Check-in -->
                            <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline">
                                <input type="hidden" name="action" value="checkin">
                                <input type="hidden" name="method" value="GPS">
                                <button type="submit" class="btn-employee-checkin" id="btnCheckinGPS"
                                        style="background: linear-gradient(135deg, #0891b2, #06b6d4);"
                                        title="GPS Mobile - Làm việc từ xa">
                                    <i class="bi bi-geo-alt-fill"></i> GPS WFH
                                </button>
                            </form>
                            <!-- Check-out -->
                            <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline">
                                <input type="hidden" name="action" value="checkout">
                                <button type="submit" class="btn-employee-checkout" id="btnCheckout">
                                    <i class="bi bi-box-arrow-right"></i> Check-out Ra về
                                </button>
                            </form>
                        </div>
                    </div>
                </div>


                <!-- Today status cards (Employee) -->
                <div class="row g-3 mb-4">
                    <div class="col-6 col-md-3">
                        <div class="today-status-card">
                            <div class="astat-icon green" style="width:40px;height:40px;border-radius:10px;font-size:1.1rem;"><i class="bi bi-box-arrow-in-right"></i></div>
                            <div>
                                <div style="font-size:0.72rem; font-weight:700; color:#94a3b8; text-transform:uppercase; letter-spacing:0.5px;">Check-in hôm nay</div>
                                <div style="font-size:1.1rem; font-weight:800; color:#0f172a; font-family:monospace;">${todayCheckIn != null ? todayCheckIn : '--:--:--'}</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="today-status-card">
                            <div class="astat-icon red" style="width:40px;height:40px;border-radius:10px;font-size:1.1rem;"><i class="bi bi-box-arrow-right"></i></div>
                            <div>
                                <div style="font-size:0.72rem; font-weight:700; color:#94a3b8; text-transform:uppercase; letter-spacing:0.5px;">Check-out hôm nay</div>
                                <div style="font-size:1.1rem; font-weight:800; color:#0f172a; font-family:monospace;">${todayCheckOut != null ? todayCheckOut : '--:--:--'}</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="today-status-card">
                            <div class="astat-icon blue" style="width:40px;height:40px;border-radius:10px;font-size:1.1rem;"><i class="bi bi-clock"></i></div>
                            <div>
                                <div style="font-size:0.72rem; font-weight:700; color:#94a3b8; text-transform:uppercase; letter-spacing:0.5px;">Giờ thực tế</div>
                                <div style="font-size:1.1rem; font-weight:800; color:#0f172a; font-family:monospace;">${todayHours != null ? todayHours : '0h 00m'}</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="today-status-card">
                            <div class="astat-icon violet" style="width:40px;height:40px;border-radius:10px;font-size:1.1rem;"><i class="bi bi-calendar-check"></i></div>
                            <div>
                                <div style="font-size:0.72rem; font-weight:700; color:#94a3b8; text-transform:uppercase; letter-spacing:0.5px;">Ngày công tháng này</div>
                                <div style="font-size:1.1rem; font-weight:800; color:#0f172a;">${workDaysThisMonth != null ? workDaysThisMonth : '0'} ngày</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Month Filter -->
                <div class="att-filter-bar">
                    <form method="get" action="${pageContext.request.contextPath}/attendance">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-3">
                                <select class="form-select filter-select" name="month">
                                    <c:forEach var="m" begin="1" end="12">
                                        <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select filter-select" name="year">
                                    <option value="2025" ${selectedYear == 2025 ? 'selected' : ''}>2025</option>
                                    <option value="2026" ${selectedYear == 2026 ? 'selected' : ''}>2026</option>
                                    <option value="2027" ${selectedYear == 2027 ? 'selected' : ''}>2027</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button type="submit" style="height:38px; background:#2563eb; color:#fff; border:none; border-radius:9px; padding:0 1rem; font-size:0.875rem; font-weight:600; display:inline-flex; align-items:center; gap:6px; width:100%; justify-content:center;">
                                    <i class="bi bi-search"></i> Xem lịch sử
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Employee Attendance Table -->
                <div class="att-table-card">
                    <div class="table-responsive">
                        <table class="att-table">
                            <thead>
                                <tr>
                                    <th style="padding-left:1.25rem;">Ngày</th>
                                    <th>Ca làm việc</th>
                                    <th>Giờ Check-in</th>
                                    <th>Giờ Check-out</th>
                                    <th>Đi muộn / Về sớm</th>
                                    <th>Giờ thực tế</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th style="padding-right:1.25rem; text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty attendances}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-5">
                                                <i class="bi bi-clock-history" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i>
                                                <div style="font-weight:600; font-size:0.95rem; color:#64748b;">Chưa có dữ liệu chấm công</div>
                                                <div style="font-size:0.82rem; margin-top:4px;">trong tháng ${selectedMonth}/${selectedYear}</div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="att" items="${attendances}">
                                            <tr class="${att.status eq 'LATE' ? 'row-late' : att.status eq 'ABSENT' ? 'row-absent' : ''}">
                                                <td style="padding-left:1.25rem;">
                                                    <span style="font-weight:700; color:#0f172a; font-family:monospace;">${att.workDate}</span>
                                                </td>
                                                <td>
                                                    <div class="shift-cell">
                                                        <div class="shift-time">${att.shiftTime != null ? att.shiftTime : '08:30 - 17:30'}</div>
                                                        <div class="shift-name">${att.shiftName != null ? att.shiftName : 'Ca Hành chính'}</div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:if test="${att.checkIn != null}">
                                                        <div class="checkin-time ${att.status eq 'LATE' ? 'late' : ''}">${att.checkIn}</div>
                                                        <span class="checkin-method ${att.method eq 'FaceID' ? 'faceid' : att.method eq 'GPS' ? 'gps' : 'manual'}">
                                                            <i class="bi bi-${att.method eq 'FaceID' ? 'shield-check' : att.method eq 'GPS' ? 'geo-alt' : 'hand-index'}"></i>
                                                            ${att.method != null ? att.method : 'Thủ công'}
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${att.checkIn == null}"><span class="text-muted">—</span></c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${att.checkOut != null}">
                                                        <div class="checkin-time">${att.checkOut}</div>
                                                    </c:if>
                                                    <c:if test="${att.checkOut == null}"><span class="text-muted" style="font-size:0.8rem;">—&nbsp;(Chưa về)</span></c:if>
                                                </td>
                                                <td>
                                                    <div class="deviation-cell">
                                                        <c:choose>
                                                            <c:when test="${att.status eq 'LATE'}"><span class="deviation-late">⏰ Muộn ${att.minutesLate} phút</span></c:when>
                                                            <c:when test="${att.status eq 'EARLY_LEAVE'}"><span class="deviation-early">⬆ Về sớm ${att.minutesEarly} phút</span></c:when>
                                                            <c:when test="${att.status eq 'ON_TIME'}"><span class="deviation-ok">✓ Đúng giờ (${att.deviation})</span></c:when>
                                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td><span class="hours-cell">${att.totalHours != null ? att.totalHours : '0h 00m'}</span></td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${att.status eq 'ON_TIME'}"><span class="status-pill ontime"><i class="bi bi-check-circle-fill"></i> Đúng giờ</span></c:when>
                                                        <c:when test="${att.status eq 'LATE'}"><span class="status-pill late"><i class="bi bi-clock-fill"></i> Đi muộn</span></c:when>
                                                        <c:when test="${att.status eq 'EARLY_LEAVE'}"><span class="status-pill early"><i class="bi bi-dash-circle"></i> Về sớm</span></c:when>
                                                        <c:when test="${att.status eq 'ON_LEAVE'}"><span class="status-pill leave"><i class="bi bi-calendar-check"></i> Nghỉ phép (AL)</span></c:when>
                                                        <c:when test="${att.status eq 'WFH'}"><span class="status-pill wfh"><i class="bi bi-house-check"></i> WFH Đã duyệt</span></c:when>
                                                        <c:when test="${att.status eq 'COMPLETE'}"><span class="status-pill complete"><i class="bi bi-check2-all"></i> Hoàn thành ca</span></c:when>
                                                        <c:otherwise><span class="status-pill absent"><i class="bi bi-x-circle-fill"></i> Vắng mặt</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding-right:1.25rem; text-align:center;">
                                                    <div class="action-btn-group justify-content-center">
                                                        <a href="${pageContext.request.contextPath}/attendance?action=history&id=${att.id}" class="action-btn history" title="Xem lịch sử"><i class="bi bi-clock-history"></i></a>
                                                        <c:if test="${att.canExplain}">
                                                            <button type="button" class="action-btn edit" title="Gửi giải trình" onclick="openExplainModal('${att.id}','${att.workDate}')">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
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
                    <c:if test="${not empty attendances}">
                        <div class="table-footer-bar">
                            <span class="text-muted">Tổng cộng <strong>${attendances.size()}</strong> lượt chấm công trong tháng ${selectedMonth}/${selectedYear}</span>
                            <span class="text-muted">MIXIMOI Smart Timekeeping</span>
                        </div>
                    </c:if>
                </div>

            </c:if>

            <%-- ============================================================
                 ACCOUNTANT ROLE: Xem bảng tổng hợp công tháng (read-only)
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.accountant and not sessionScope.currentUser.admin}">

                <!-- Page Header -->
                <div class="att-page-header">
                    <div>
                        <h1 class="att-title">Quản lý chấm công <span class="live-sync-badge"><span class="live-dot"></span>Live Sync</span></h1>
                        <p class="att-subtitle">Xem bảng tổng hợp công tháng phục vụ tính lương</p>
                    </div>
                    <div class="header-actions">
                        <a href="${pageContext.request.contextPath}/attendance?action=export&month=${selectedMonth}&year=${selectedYear}" class="btn-att-outline">
                            <i class="bi bi-file-earmark-excel text-success"></i> Xuất Excel
                        </a>
                    </div>
                </div>

                <!-- Monthly Summary Stats -->
                <div class="monthly-summary-card">
                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3 mb-3">
                        <h6 style="font-size:0.9rem; font-weight:700; color:#0f172a; margin:0;">
                            <i class="bi bi-table text-primary me-2"></i>Bảng tổng hợp công — Tháng ${selectedMonth}/${selectedYear}
                        </h6>
                        <form method="get" action="${pageContext.request.contextPath}/attendance" class="d-flex gap-2">
                            <select class="form-select filter-select" name="month" style="width:120px;">
                                <c:forEach var="m" begin="1" end="12">
                                    <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m}</option>
                                </c:forEach>
                            </select>
                            <select class="form-select filter-select" name="year" style="width:90px;">
                                <option value="2025" ${selectedYear == 2025 ? 'selected' : ''}>2025</option>
                                <option value="2026" ${selectedYear == 2026 ? 'selected' : ''}>2026</option>
                            </select>
                            <button type="submit" style="height:38px; background:#2563eb; color:#fff; border:none; border-radius:9px; padding:0 1rem; font-size:0.84rem; font-weight:600; display:inline-flex; align-items:center; gap:5px;">
                                <i class="bi bi-funnel-fill"></i> Xem
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Attendance Summary Table (Accountant) -->
                <div class="att-table-card">
                    <div class="table-responsive">
                        <table class="att-table">
                            <thead>
                                <tr>
                                    <th style="padding-left:1.25rem;">Nhân viên</th>
                                    <th>Phòng ban</th>
                                    <th class="text-center">Tổng ngày công</th>
                                    <th class="text-center">Đúng giờ</th>
                                    <th class="text-center">Đi muộn</th>
                                    <th class="text-center">Về sớm</th>
                                    <th class="text-center">Vắng mặt</th>
                                    <th class="text-center">Ngày nghỉ phép</th>
                                    <th class="text-end" style="padding-right:1.25rem;">Tổng giờ làm</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty timesheetSummary}">
                                        <tr><td colspan="9" class="text-center text-muted py-5"><i class="bi bi-table" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i><div style="font-weight:600; color:#64748b;">Chưa có dữ liệu bảng công tháng ${selectedMonth}/${selectedYear}</div></td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="ts" items="${timesheetSummary}">
                                            <tr>
                                                <td style="padding-left:1.25rem;">
                                                    <div class="emp-cell">
                                                        <div class="emp-avatar gen-n">${ts.employeeName != null ? ts.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                                        <div><div class="emp-name">${ts.employeeName}</div><div class="emp-code">${ts.employeeCode}</div></div>
                                                    </div>
                                                </td>
                                                <td><span style="font-size:0.83rem; color:#475569;">${ts.departmentName}</span></td>
                                                <td class="text-center"><strong>${ts.totalWorkDays}</strong></td>
                                                <td class="text-center"><span style="color:#059669; font-weight:600;">${ts.onTimeDays}</span></td>
                                                <td class="text-center"><span style="color:#d97706; font-weight:600;">${ts.lateDays}</span></td>
                                                <td class="text-center"><span style="color:#c2410c; font-weight:600;">${ts.earlyLeaveDays}</span></td>
                                                <td class="text-center"><span style="color:#dc2626; font-weight:600;">${ts.absentDays}</span></td>
                                                <td class="text-center"><span style="color:#7c3aed; font-weight:600;">${ts.leaveDays}</span></td>
                                                <td class="text-end" style="padding-right:1.25rem;"><span class="hours-cell">${ts.totalHours}h</span></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${not empty timesheetSummary}">
                        <div class="table-footer-bar">
                            <span class="text-muted">Bảng tổng hợp <strong>${timesheetSummary.size()}</strong> nhân sự — Tháng ${selectedMonth}/${selectedYear}</span>
                            <span class="text-muted" style="font-size:0.78rem;">Chỉ đọc · Phục vụ tính lương</span>
                        </div>
                    </c:if>
                </div>

            </c:if>

            <%-- ============================================================
                 MANAGER ROLE: Xem + Phê duyệt NV phòng ban mình
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">

                <!-- Page Header -->
                <div class="att-page-header">
                    <div>
                        <h1 class="att-title">Quản lý chấm công <span class="live-sync-badge"><span class="live-dot"></span>Live Sync</span></h1>
                        <p class="att-subtitle">Theo dõi chấm công nhân viên phòng ban, phê duyệt giải trình và nghỉ phép</p>
                    </div>
                    <div class="header-actions">
                        <div class="date-display"><i class="bi bi-calendar3 text-primary"></i> Hôm nay: ${todayDisplay}</div>
                        <a href="${pageContext.request.contextPath}/attendance?action=export" class="btn-att-outline"><i class="bi bi-file-earmark-excel text-success"></i> Xuất Excel</a>
                    </div>
                </div>

                <!-- Manager Stats (4 cards) -->
                <div class="att-stats-grid" style="grid-template-columns: repeat(4,1fr);">
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Quân số ca hôm nay</div><div class="astat-icon blue"><i class="bi bi-people-fill"></i></div></div>
                        <div class="astat-value">${deptTotalToday}</div>
                        <div class="astat-sub">Nhân sự trong phòng ban</div>
                    </div>
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Đã Check-in</div><div class="astat-icon green"><i class="bi bi-check-circle-fill"></i></div></div>
                        <div class="astat-value">${deptCheckedIn}</div>
                        <div class="astat-sub"><strong>${deptTotalToday > 0 ? deptCheckedIn * 100 / deptTotalToday : 0}%</strong> đúng tiêu đỡ ca</div>
                    </div>
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Đi muộn / Về sớm</div><div class="astat-icon amber"><i class="bi bi-clock-history"></i></div></div>
                        <div class="astat-value">${deptLateCount}</div>
                        <div class="astat-sub"><span class="warn">+${deptLateCount} so với hôm qua</span></div>
                    </div>
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Chờ phê duyệt</div><div class="astat-icon violet"><i class="bi bi-hourglass-split"></i></div></div>
                        <div class="astat-value">${pendingApprovals}</div>
                        <div class="astat-sub">Giải trình &amp; Nghỉ phép</div>
                    </div>
                </div>

                <!-- Filter Bar -->
                <div class="att-filter-bar">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-4">
                            <div class="filter-search-wrap">
                                <i class="bi bi-search"></i>
                                <input type="text" class="filter-search-input" id="searchEmp"
                                       placeholder="Tìm theo tên hoặc mã nhân viên (NV-2026-...)" value="${keyword}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select filter-select" id="filterShift">
                                <option value="">Tất cả ca làm việc</option>
                                <option value="morning">Ca Sáng 07:00-11:30</option>
                                <option value="full">Ca Hành chính 08:30-17:30</option>
                                <option value="afternoon">Ca Chiều 13:00-17:30</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select filter-select" id="filterStatus">
                                <option value="">Tất cả trạng thái</option>
                                <option value="ON_TIME">Đúng giờ</option>
                                <option value="LATE">Đi muộn</option>
                                <option value="ABSENT">Vắng mặt</option>
                                <option value="WFH">WFH</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-center gap-2">
                            <label class="toggle-switch-label">
                                <input type="checkbox" id="toggleAnomaly" class="form-check-input toggle" role="switch">
                                <span>Bất thường</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Sync Status Bar -->
                <div class="sync-status-bar">
                    <div><i class="bi bi-wifi text-success me-1"></i><span style="font-weight:600;">Đồng bộ máy ZKTeco</span> — Hoạt động bình thường</div>
                    <div class="kycong">Kỳ công: Tháng ${selectedMonth}/${selectedYear}</div>
                </div>

                <!-- Attendance Table (Manager) -->
                <div class="att-table-card">
                    <div class="table-responsive">
                        <table class="att-table" id="attTable">
                            <thead>
                                <tr>
                                    <th style="width:42px; padding-left:1.25rem;"><input type="checkbox" id="checkAll" class="form-check-input" style="width:15px;height:15px;"></th>
                                    <th>Nhân viên &amp; Phòng ban</th>
                                    <th>Ca làm việc</th>
                                    <th>Giờ Check-in</th>
                                    <th>Giờ Check-out</th>
                                    <th>Đi muộn / Về sớm</th>
                                    <th>Giờ thực tế</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th style="padding-right:1.25rem; text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty attendances}">
                                        <tr><td colspan="9" class="text-center text-muted py-5"><i class="bi bi-inbox" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i><div style="font-weight:600; color:#64748b;">Không có dữ liệu chấm công</div></td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="att" items="${attendances}">
                                            <tr class="${att.status eq 'LATE' ? 'row-late' : att.status eq 'ABSENT' ? 'row-absent' : att.status eq 'WFH' ? 'row-wfh' : ''}">
                                                <td style="padding-left:1.25rem;"><input type="checkbox" class="form-check-input row-check" value="${att.id}" style="width:15px;height:15px;"></td>
                                                <td>
                                                    <div class="emp-cell">
                                                        <div class="emp-avatar gen-n">${att.employeeName != null ? att.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                                        <div>
                                                            <div class="emp-name">${att.employeeName}</div>
                                                            <div class="emp-meta">${att.positionName} · <span style="color:#2563eb;">${att.departmentName}</span></div>
                                                            <div class="emp-code">${att.employeeCode}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="shift-cell">
                                                        <div class="shift-time">${att.shiftTime != null ? att.shiftTime : '08:30 - 17:30'}</div>
                                                        <div class="shift-name">${att.shiftName != null ? att.shiftName : 'Ca Hành chính'}</div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:if test="${att.checkIn != null}">
                                                        <div class="checkin-time ${att.status eq 'LATE' ? 'late' : ''}">${att.checkIn}</div>
                                                        <span class="checkin-method ${att.method eq 'FaceID' ? 'faceid' : att.method eq 'GPS' ? 'gps' : 'manual'}">
                                                            <i class="bi bi-${att.method eq 'FaceID' ? 'shield-check' : att.method eq 'GPS' ? 'geo-alt-fill' : 'hand-index'}"></i>
                                                            ${att.method != null ? att.method : 'Thủ công'}
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${att.checkIn == null}"><span class="text-muted">—</span></c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${att.checkOut != null}"><div class="checkin-time">${att.checkOut}</div></c:if>
                                                    <c:if test="${att.checkOut == null}"><span class="text-muted" style="font-size:0.8rem;">—&nbsp;(Chưa về)</span></c:if>
                                                </td>
                                                <td>
                                                    <div class="deviation-cell">
                                                        <c:choose>
                                                            <c:when test="${att.status eq 'LATE'}"><span class="deviation-late">⏰ Muộn ${att.minutesLate} phút</span></c:when>
                                                            <c:when test="${att.status eq 'EARLY_LEAVE'}"><span class="deviation-early">⬆ Về sớm ${att.minutesEarly} phút</span></c:when>
                                                            <c:when test="${att.status eq 'ON_TIME'}"><span class="deviation-ok">✓ Đúng giờ (${att.deviation})</span></c:when>
                                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td><span class="hours-cell">${att.totalHours != null ? att.totalHours : '—'}</span></td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${att.status eq 'ON_TIME'}"><span class="status-pill ontime"><i class="bi bi-check-circle-fill"></i> Đúng giờ</span></c:when>
                                                        <c:when test="${att.status eq 'WORKING'}"><span class="status-pill working"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Đang làm việc</span></c:when>
                                                        <c:when test="${att.status eq 'LATE'}"><span class="status-pill late"><i class="bi bi-clock-fill"></i> Đi muộn</span></c:when>
                                                        <c:when test="${att.status eq 'ON_LEAVE'}"><span class="status-pill leave"><i class="bi bi-calendar-check"></i> Nghỉ phép</span></c:when>
                                                        <c:when test="${att.status eq 'WFH'}"><span class="status-pill wfh"><i class="bi bi-house-check"></i> WFH Đã duyệt</span></c:when>
                                                        <c:when test="${att.status eq 'COMPLETE'}"><span class="status-pill complete"><i class="bi bi-check2-all"></i> Hoàn thành ca</span></c:when>
                                                        <c:otherwise><span class="status-pill absent"><i class="bi bi-x-circle-fill"></i> Vắng mặt</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding-right:1.25rem; text-align:center;">
                                                    <div class="action-btn-group justify-content-center">
                                                        <button type="button" class="action-btn history" title="Xem lịch sử"
                                                                data-id="${att.id}" data-name="<c:out value='${att.employeeName}'/>" data-code="${att.employeeCode}" data-date="${att.workDate}"
                                                                data-checkin="${att.checkIn}" data-checkout="${att.checkOut}" data-shift="${att.shiftName != null ? att.shiftName : 'Ca Hành chính'}"
                                                                data-status="${att.status}" data-method="${att.method != null ? att.method : 'Thủ công'}" data-hours="${att.totalHours}"
                                                                onclick="viewHistory(this)"><i class="bi bi-clock-history"></i></button>
                                                        <button type="button" class="action-btn approve" title="Phê duyệt giải trình" onclick="approveExplain('${att.id}')"><i class="bi bi-check-square"></i></button>
                                                        <button type="button" class="action-btn edit" title="Chỉnh sửa"
                                                                data-id="${att.id}" data-empid="${att.employeeId}" data-date="${att.workDate}"
                                                                data-checkin="${att.checkIn}" data-checkout="${att.checkOut}" data-status="${att.status}"
                                                                data-notes="<c:out value='${att.notes}'/>"
                                                                onclick="editAttendance(this)"><i class="bi bi-pencil"></i></button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${not empty attendances}">
                        <div class="table-footer-bar">
                            <span class="text-muted">
                                Hiển thị <strong style="color:#1e293b;">${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalAttendances ? totalAttendances : currentPage * pageSize}</strong>
                                / ${totalAttendances} kết quả
                            </span>
                            <c:if test="${totalPages > 1}">
                                <div class="pagination-row">
                                    <span class="text-muted me-2" style="font-size:0.78rem;">Kỳ công: Tháng ${selectedMonth}/${selectedYear}</span>
                                    <a href="${pageContext.request.contextPath}/attendance?page=${currentPage - 1}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                                       class="page-btn ${currentPage <= 1 ? 'disabled' : ''}">
                                        <i class="bi bi-chevron-left" style="font-size:0.7rem;"></i>
                                    </a>
                                    <c:forEach begin="1" end="${totalPages}" var="pg">
                                        <a href="${pageContext.request.contextPath}/attendance?page=${pg}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                                           class="page-btn ${pg == currentPage ? 'active' : ''}">${pg}</a>
                                    </c:forEach>
                                    <a href="${pageContext.request.contextPath}/attendance?page=${currentPage + 1}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                                       class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <i class="bi bi-chevron-right" style="font-size:0.7rem;"></i>
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </div>

            </c:if>

            <%-- ============================================================
                 ADMIN / HR ROLE: Toàn quyền quản lý chấm công
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">

                <!-- Alerts -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3" role="alert" style="border-radius:10px; font-size:0.875rem;">
                        <i class="bi bi-check-circle-fill me-2 text-success"></i>
                        <c:choose>
                            <c:when test="${param.success eq 'checkin'}">Chấm công thủ công thành công!</c:when>
                            <c:when test="${param.success eq 'updated'}">Cập nhật dữ liệu chấm công thành công!</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Page Header -->
                <div class="att-page-header">
                    <div>
                        <h1 class="att-title">
                            Quản Lý Chấm Công
                            <span class="live-sync-badge"><span class="live-dot"></span>Live Sync</span>
                        </h1>
                        <p class="att-subtitle">Theo dõi dữ liệu chấm công thời gian thực, quản lý ca làm, đi muộn, về sớm và tổng hợp công tháng</p>
                    </div>
                    <div class="header-actions">
                        <div class="date-display"><i class="bi bi-calendar3 text-primary"></i> Hôm nay: ${todayDisplay}</div>
                        <button type="button" class="btn-att-outline" title="Đồng bộ máy chấm công" onclick="syncAttendanceDevice(this)">
                            <i class="bi bi-arrow-repeat text-primary"></i> Đồng bộ máy
                        </button>
                        <a href="${pageContext.request.contextPath}/attendance?action=export&month=${selectedMonth}&year=${selectedYear}" class="btn-att-outline">
                            <i class="bi bi-file-earmark-excel text-success"></i> Xuất Excel
                        </a>
                        <button type="button" class="btn-checkin-manual" data-bs-toggle="modal" data-bs-target="#manualCheckinModal">
                            <i class="bi bi-plus-circle-fill"></i> Chấm công thủ công / Giải trình
                        </button>
                    </div>
                </div>

                <!-- Stats Grid (5 cards) -->
                <div class="att-stats-grid">
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Quân số ca hôm nay</div><div class="astat-icon blue"><i class="bi bi-people-fill"></i></div></div>
                        <div class="astat-value">${totalEmployeesToday}</div>
                        <div class="astat-sub">${activeCaShift} ca trực hoạt động</div>
                    </div>
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Đã Check-in</div><div class="astat-icon green"><i class="bi bi-patch-check-fill"></i></div></div>
                        <div class="astat-value">${checkedInCount} <span style="font-size:1rem; color:#94a3b8;">/ ${totalEmployeesToday}</span></div>
                        <div class="astat-sub"><strong>${totalEmployeesToday > 0 ? checkedInCount * 100 / totalEmployeesToday : 0}%</strong> Đúng tiêu đỡ ca</div>
                    </div>
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Đi muộn / Về sớm</div><div class="astat-icon amber"><i class="bi bi-exclamation-circle-fill"></i></div></div>
                        <div class="astat-value">${lateEarlyCount} <span style="font-size:0.85rem; color:#94a3b8;">trường hợp</span></div>
                        <div class="astat-sub"><span class="warn">+${lateEarlyDiff} so với hôm qua</span></div>
                    </div>
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Vắng mặt</div><div class="astat-icon red"><i class="bi bi-person-x-fill"></i></div></div>
                        <div class="astat-value">${absentCount} <span style="font-size:0.85rem; color:#94a3b8;">nhân viên</span></div>
                        <div class="astat-sub">${absentApproved} có phép, ${absentUnapproved} chưa rõ</div>
                    </div>
                    <div class="att-stat-card">
                        <div class="astat-header"><div class="astat-label">Làm việc từ xa (WFH)</div><div class="astat-icon violet"><i class="bi bi-house-fill"></i></div></div>
                        <div class="astat-value">${wfhCount} <span style="font-size:0.85rem; color:#94a3b8;">nhân viên</span></div>
                        <div class="astat-sub">GPS Mobile xác thực</div>
                    </div>
                </div>

                <!-- Tab Navigation -->
                <div class="att-tab-nav">
                    <a href="${pageContext.request.contextPath}/attendance?tab=daily" class="att-tab-btn ${empty activeTab or activeTab eq 'daily' ? 'active' : ''}">
                        <i class="bi bi-journal-text"></i> Nhật ký chấm công hàng ngày
                    </a>
                    <a href="${pageContext.request.contextPath}/timesheet?tab=monthly" class="att-tab-btn ${activeTab eq 'monthly' ? 'active' : ''}">
                        <i class="bi bi-table"></i> Bảng tổng hợp công tháng
                    </a>
                    <a href="${pageContext.request.contextPath}/attendance?tab=anomaly" class="att-tab-btn ${activeTab eq 'anomaly' ? 'active' : ''}">
                        <i class="bi bi-exclamation-triangle-fill text-warning"></i>
                        Bất thường &amp; Giải trình
                        <c:if test="${anomalyCount > 0}"><span class="att-tab-badge">${anomalyCount}</span></c:if>
                    </a>
                    <a href="${pageContext.request.contextPath}/attendance?tab=device" class="att-tab-btn ${activeTab eq 'device' ? 'active' : ''}">
                        <i class="bi bi-cpu"></i> Thiết bị chấm công
                        <c:if test="${deviceOnline}"><span class="att-tab-dot"></span></c:if>
                    </a>
                </div>

                <!-- Filter Bar -->
                <div class="att-filter-bar">
                    <form method="get" action="${pageContext.request.contextPath}/attendance" id="filterForm">
                        <input type="hidden" name="tab" value="${empty activeTab ? 'daily' : activeTab}">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-4">
                                <div class="filter-search-wrap">
                                    <i class="bi bi-search"></i>
                                    <input type="text" class="filter-search-input" name="keyword" id="searchEmp"
                                           placeholder="Tìm theo tên hoặc mã nhân viên (NV-2026-...)" value="${keyword}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="departmentId" id="filterDept">
                                    <option value="">Tất cả phòng ban</option>
                                    <c:forEach var="dept" items="${departments}">
                                        <option value="${dept.id}" ${departmentId == dept.id ? 'selected' : ''}>${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select filter-select" name="shiftId" id="filterShift">
                                    <option value="">Tất cả ca làm việc</option>
                                    <c:forEach var="shift" items="${shifts}">
                                        <option value="${shift.id}" ${shiftId == shift.id ? 'selected' : ''}>${shift.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-center gap-2">
                                <label class="toggle-switch-label">
                                    <input type="checkbox" id="toggleAnomaly" class="form-check-input toggle" role="switch" ${showAnomaly ? 'checked' : ''} name="anomaly" value="true">
                                    <span>Chỉ hiện ca bất thường</span>
                                </label>
                            </div>
                            <div class="col-md-2 d-flex gap-2">
                                <button type="submit" class="btn-filter-primary" style="height:38px; background:#2563eb; color:#fff; border:none; border-radius:9px; padding:0 1rem; font-size:0.84rem; font-weight:600; display:inline-flex; align-items:center; gap:5px; flex:1; justify-content:center;">
                                    <i class="bi bi-funnel-fill"></i> Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/attendance" style="height:38px; background:#f1f5f9; color:#475569; border:1.5px solid #e2e8f0; border-radius:9px; padding:0 0.75rem; font-size:0.84rem; font-weight:500; display:inline-flex; align-items:center; gap:4px; text-decoration:none;" title="Đặt lại">
                                    <i class="bi bi-arrow-counterclockwise"></i>
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Sync Status Bar -->
                <div class="sync-status-bar">
                    <div>
                        <i class="bi bi-wifi text-success me-1"></i>
                        <strong>Đồng bộ ${deviceCount} máy ZKTeco</strong>  — Hoạt động bình thường
                    </div>
                    <div class="kycong">Kỳ công: Tháng ${selectedMonth}/${selectedYear}</div>
                </div>

                <!-- Bulk Action Toolbar -->
                <div id="bulkToolbar" class="d-none align-items-center gap-2 mb-2 px-2 py-2"
                     style="background:linear-gradient(90deg,#eff6ff,#f0fdf4);border-radius:10px;border:1px solid #bfdbfe;flex-wrap:wrap;">
                    <span style="font-size:0.83rem;color:#1e40af;font-weight:700;">
                        <i class="bi bi-check2-square me-1"></i>
                        Đã chọn <strong id="bulkCount">0</strong> bản ghi chấm công
                    </span>
                    <div class="d-flex gap-2 ms-auto flex-wrap">
                        <button type="button" class="btn btn-sm btn-success px-3" onclick="bulkMarkOnTime()"
                                style="border-radius:8px;font-weight:600;font-size:0.8rem;">
                            <i class="bi bi-check2-all me-1"></i> Xác nhận đúng giờ
                        </button>
                        <button type="button" class="btn btn-sm btn-danger px-3" onclick="bulkDeleteAtt()"
                                style="border-radius:8px;font-weight:600;font-size:0.8rem;">
                            <i class="bi bi-trash me-1"></i> Xóa hàng loạt
                        </button>
                        <button type="button" class="btn btn-sm btn-primary px-3" onclick="bulkExportAtt()"
                                style="border-radius:8px;font-weight:600;font-size:0.8rem;">
                            <i class="bi bi-file-earmark-excel me-1"></i> Xuất danh sách chọn
                        </button>
                        <button type="button" class="btn btn-sm btn-light px-3" onclick="clearAttSelection()"
                                style="border-radius:8px;font-size:0.8rem;">
                            <i class="bi bi-x-lg me-1"></i> Bỏ chọn
                        </button>
                    </div>
                </div>

                <!-- Attendance Table (Admin/HR: full management) -->
                <div class="att-table-card">
                    <div class="table-responsive">
                        <table class="att-table" id="attTable">
                            <thead>
                                <tr>
                                    <th style="width:42px; padding-left:1.25rem;"><input type="checkbox" id="checkAll" class="form-check-input" style="width:15px;height:15px;"></th>
                                    <th>Nhân viên &amp; Phòng ban / Chức vụ</th>
                                    <th>Ca làm việc</th>
                                    <th>Giờ Check-in</th>
                                    <th>Giờ Check-out</th>
                                    <th>Đi muộn / Về sớm</th>
                                    <th>Giờ thực tế</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th style="padding-right:1.25rem; text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty attendances}">
                                        <tr id="attEmptyRow">
                                            <td colspan="9" class="text-center text-muted py-5">
                                                <i class="bi bi-clock-history" style="font-size:2.5rem; display:block; margin-bottom:0.75rem;"></i>
                                                <div style="font-weight:600; font-size:0.95rem; color:#64748b;">Không có dữ liệu chấm công</div>
                                                <div style="font-size:0.82rem; margin-top:4px;">
                                                    <a href="#" class="text-primary" data-bs-toggle="modal" data-bs-target="#manualCheckinModal">Thêm chấm công thủ công →</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="att" items="${attendances}">
                                            <tr class="att-row ${att.status eq 'LATE' ? 'row-late' : att.status eq 'ABSENT' ? 'row-absent' : att.status eq 'WFH' ? 'row-wfh' : ''}"
                                                data-keyword="${fn:toLowerCase(att.employeeName)} ${fn:toLowerCase(att.employeeCode)} ${fn:toLowerCase(not empty att.departmentName ? att.departmentName : '')}"
                                                data-status="${att.status}"
                                                data-dept="${not empty att.departmentName ? fn:toLowerCase(att.departmentName) : ''}"
                                                data-shift="${fn:toLowerCase(not empty att.shiftName ? att.shiftName : '')}"
                                                data-id="${att.id}">
                                                <td style="padding-left:1.25rem;"><input type="checkbox" class="form-check-input row-check" value="${att.id}" style="width:15px;height:15px;"></td>
                                                <td>
                                                    <div class="emp-cell">
                                                        <div class="emp-avatar gen-n">${att.employeeName != null ? att.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                                        <div>
                                                            <div class="emp-name">${att.employeeName}</div>
                                                            <div class="emp-meta">${att.positionName}</div>
                                                            <div class="emp-code">${att.employeeCode}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="shift-cell">
                                                        <div class="shift-time">${att.shiftTime != null ? att.shiftTime : '08:30 - 17:30'}</div>
                                                        <div class="shift-name">${att.shiftName != null ? att.shiftName : 'Ca Hành chính'}</div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:if test="${att.checkIn != null}">
                                                        <div class="checkin-time ${att.status eq 'LATE' ? 'late' : ''}">${att.checkIn}</div>
                                                        <span class="checkin-method ${att.method eq 'FaceID' ? 'faceid' : att.method eq 'GPS' ? 'gps' : 'manual'}">
                                                            <i class="bi bi-${att.method eq 'FaceID' ? 'shield-check' : att.method eq 'GPS' ? 'geo-alt-fill' : 'hand-index'}"></i>
                                                            ${att.method != null ? att.method : 'Thủ công'}
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${att.checkIn == null}"><span class="text-muted">—</span></c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${att.checkOut != null}"><div class="checkin-time">${att.checkOut}</div></c:if>
                                                    <c:if test="${att.checkOut == null}"><span class="text-muted" style="font-size:0.8rem;">—&nbsp;(Chưa về)</span></c:if>
                                                </td>
                                                <td>
                                                    <div class="deviation-cell">
                                                        <c:choose>
                                                            <c:when test="${att.status eq 'LATE'}"><span class="deviation-late">⏰ Muộn ${att.minutesLate} phút</span></c:when>
                                                            <c:when test="${att.status eq 'EARLY_LEAVE'}"><span class="deviation-early">⬆ Về sớm ${att.minutesEarly} phút</span></c:when>
                                                            <c:when test="${att.status eq 'ON_TIME'}"><span class="deviation-ok">✓ Đúng giờ (${att.deviation})</span></c:when>
                                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td><span class="hours-cell">${att.totalHours != null ? att.totalHours : '—'}</span></td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${att.status eq 'ON_TIME'}"><span class="status-pill ontime"><i class="bi bi-check-circle-fill"></i> Đúng giờ</span></c:when>
                                                        <c:when test="${att.status eq 'WORKING'}"><span class="status-pill working"><i class="bi bi-circle-fill" style="font-size:0.45rem;"></i> Đang làm việc</span></c:when>
                                                        <c:when test="${att.status eq 'LATE'}"><span class="status-pill late"><i class="bi bi-clock-fill"></i> Đi muộn</span></c:when>
                                                        <c:when test="${att.status eq 'EARLY_LEAVE'}"><span class="status-pill early"><i class="bi bi-dash-circle"></i> Về sớm</span></c:when>
                                                        <c:when test="${att.status eq 'ON_LEAVE'}"><span class="status-pill leave"><i class="bi bi-calendar-check"></i> Nghỉ phép (AL)</span></c:when>
                                                        <c:when test="${att.status eq 'WFH'}"><span class="status-pill wfh"><i class="bi bi-house-check"></i> WFH Đã duyệt</span></c:when>
                                                        <c:when test="${att.status eq 'COMPLETE'}"><span class="status-pill complete"><i class="bi bi-check2-all"></i> Hoàn thành ca</span></c:when>
                                                        <c:otherwise><span class="status-pill absent"><i class="bi bi-x-circle-fill"></i> Vắng mặt</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding-right:1.25rem; text-align:center;">
                                                    <div class="action-btn-group justify-content-center">
                                                        <button type="button" class="action-btn history" title="Xem lịch sử"
                                                                data-id="${att.id}" data-name="<c:out value='${att.employeeName}'/>" data-code="${att.employeeCode}" data-date="${att.workDate}"
                                                                data-checkin="${att.checkIn}" data-checkout="${att.checkOut}" data-shift="${att.shiftName != null ? att.shiftName : 'Ca Hành chính'}"
                                                                data-status="${att.status}" data-method="${att.method != null ? att.method : 'Thủ công'}" data-hours="${att.totalHours}"
                                                                onclick="viewHistory(this)"><i class="bi bi-clock-history"></i></button>
                                                        <button type="button" class="action-btn edit" title="Chỉnh sửa"
                                                                data-id="${att.id}" data-empid="${att.employeeId}" data-date="${att.workDate}"
                                                                data-checkin="${att.checkIn}" data-checkout="${att.checkOut}" data-status="${att.status}"
                                                                data-notes="<c:out value='${att.notes}'/>"
                                                                onclick="editAttendance(this)"><i class="bi bi-pencil"></i></button>
                                                        <c:if test="${att.hasExplain}">
                                                            <button type="button" class="action-btn approve" title="Phê duyệt giải trình"
                                                                    onclick="approveExplain('${att.id}')"
                                                                    style="color:#7c3aed; border-color:#ddd6fe; background:#f5f3ff;">
                                                                <i class="bi bi-check-square"></i>
                                                            </button>
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

                    <!-- Table Footer -->
                    <c:if test="${not empty attendances}">
                        <div class="table-footer-bar">
                            <span class="text-muted">
                                Hiển thị <strong style="color:#1e293b;">${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalAttendances ? totalAttendances : currentPage * pageSize}</strong>
                                trên tổng số <strong style="color:#1e293b;">${totalAttendances}</strong> kết quả
                                <c:if test="${deviceOnline}">
                                    · <i class="bi bi-wifi text-success"></i>
                                    <span style="color:#059669; font-weight:600;">Đồng bộ ${deviceCount} máy ZKTeco — Hoạt động bình thường</span>
                                </c:if>
                            </span>
                            <c:if test="${totalPages > 1}">
                                <div class="pagination-row">
                                    <span class="text-muted me-2" style="font-size:0.78rem;">Kỳ công: Tháng ${selectedMonth}/${selectedYear}</span>
                                    <a href="${pageContext.request.contextPath}/attendance?tab=${activeTab}&page=${currentPage - 1}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                                       class="page-btn ${currentPage <= 1 ? 'disabled' : ''}">
                                        <i class="bi bi-chevron-left" style="font-size:0.7rem;"></i>
                                    </a>
                                    <c:forEach begin="1" end="${totalPages}" var="pg">
                                        <a href="${pageContext.request.contextPath}/attendance?tab=${activeTab}&page=${pg}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                                           class="page-btn ${pg == currentPage ? 'active' : ''}">${pg}</a>
                                    </c:forEach>
                                    <a href="${pageContext.request.contextPath}/attendance?tab=${activeTab}&page=${currentPage + 1}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                                       class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <i class="bi bi-chevron-right" style="font-size:0.7rem;"></i>
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </div>

            </c:if>
            <%-- end Admin/HR block --%>

        </div><!-- end app-content -->
    </main>
</div>

<%-- ============================================================
     MODAL: Chấm công thủ công / Giải trình (Admin/HR only)
     ============================================================ --%>
<c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
<div class="modal fade" id="manualCheckinModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/attendance" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="manual">

                <div class="modal-header border-0" style="background: linear-gradient(135deg, #eff6ff, #ecfdf5); padding:1.25rem 1.5rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-plus-circle-fill text-primary" style="font-size:1.1rem;"></i>
                            Chấm công thủ công / Giải trình
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Bổ sung hoặc điều chỉnh dữ liệu chấm công cho nhân viên</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Nhân viên <span class="text-danger">*</span></label>
                            <select class="form-select" name="employeeId" required style="border-radius:9px; font-size:0.875rem;">
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ngày làm việc <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="workDate" required style="border-radius:9px; font-size:0.875rem;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Giờ Check-in</label>
                            <input type="time" class="form-control" name="checkIn" style="border-radius:9px; font-size:0.875rem; font-family:monospace;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Giờ Check-out</label>
                            <input type="time" class="form-control" name="checkOut" style="border-radius:9px; font-size:0.875rem; font-family:monospace;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Phương thức chấm công</label>
                            <select class="form-select" name="method" style="border-radius:9px; font-size:0.875rem;">
                                <option value="MANUAL">Thủ công (HR bổ sung)</option>
                                <option value="FaceID">FaceID ZKTeco</option>
                                <option value="GPS">GPS Mobile</option>
                                <option value="CARD">Thẻ từ</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Trạng thái</label>
                            <select class="form-select" name="status" style="border-radius:9px; font-size:0.875rem;">
                                <option value="ON_TIME">Đúng giờ</option>
                                <option value="LATE">Đi muộn</option>
                                <option value="EARLY_LEAVE">Về sớm</option>
                                <option value="ON_LEAVE">Nghỉ phép có phép</option>
                                <option value="WFH">Làm từ xa (WFH)</option>
                                <option value="ABSENT">Vắng mặt không phép</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Lý do / Ghi chú giải trình <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="notes" rows="3" required
                                      placeholder="VD: Nhân viên quên chấm công, đã kiểm tra CCTV và xác nhận có mặt từ 08:25..."
                                      style="border-radius:9px; font-size:0.875rem;"></textarea>
                            <div class="invalid-feedback">Vui lòng nhập lý do giải trình</div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 gap-2" style="background:#f8fafc;">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal" style="border-radius:9px;">Hủy</button>
                    <button type="submit" class="btn btn-primary px-4 fw-semibold" style="border-radius:9px;">
                        <i class="bi bi-check2-circle me-1"></i> Lưu chấm công
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</c:if>

<%-- Modal: Cập nhật chấm công (Admin/HR only) --%>
<c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
<div class="modal fade" id="editAttendanceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/attendance" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editAttId">

                <div class="modal-header border-0" style="background: linear-gradient(135deg, #eff6ff, #dbeafe); padding:1.25rem 1.5rem;">
                    <div>
                        <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2 mb-1">
                            <i class="bi bi-pencil-square text-primary" style="font-size:1.1rem;"></i>
                            Cập nhật thông tin chấm công
                        </h6>
                        <p class="text-muted mb-0" style="font-size:0.79rem;">Điều chỉnh giờ vào/ra, trạng thái và ghi chú</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Nhân viên <span class="text-danger">*</span></label>
                            <select class="form-select" name="employeeId" id="editAttEmpId" required style="border-radius:9px; font-size:0.875rem;">
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.id}">${emp.fullName} (${emp.employeeCode})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ngày làm việc <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="workDate" id="editAttDate" required style="border-radius:9px; font-size:0.875rem;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Giờ Check-in</label>
                            <input type="time" class="form-control" name="checkIn" id="editAttCheckIn" style="border-radius:9px; font-size:0.875rem; font-family:monospace;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Giờ Check-out</label>
                            <input type="time" class="form-control" name="checkOut" id="editAttCheckOut" style="border-radius:9px; font-size:0.875rem; font-family:monospace;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Trạng thái</label>
                            <select class="form-select" name="status" id="editAttStatus" style="border-radius:9px; font-size:0.875rem;">
                                <option value="ON_TIME">Đúng giờ</option>
                                <option value="LATE">Đi muộn</option>
                                <option value="EARLY_LEAVE">Về sớm</option>
                                <option value="ON_LEAVE">Nghỉ phép có phép</option>
                                <option value="WFH">Làm từ xa (WFH)</option>
                                <option value="ABSENT">Vắng mặt không phép</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark mb-1" style="font-size:0.83rem;">Ghi chú / Lý do điều chỉnh</label>
                            <input type="text" class="form-control" name="notes" id="editAttNotes" style="border-radius:9px; font-size:0.875rem;" placeholder="Nhập ghi chú điều chỉnh...">
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 gap-2" style="background:#f8fafc;">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal" style="border-radius:9px;">Hủy</button>
                    <button type="submit" class="btn btn-primary px-4 fw-semibold" style="border-radius:9px;">
                        <i class="bi bi-check2-circle me-1"></i> Cập nhật
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</c:if>


<%-- Employee: Explain Modal --%>
<c:if test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
<div class="modal fade" id="explainModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:480px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <form method="post" action="${pageContext.request.contextPath}/attendance">
                <input type="hidden" name="action" value="explain">
                <input type="hidden" name="attendanceId" id="explainAttId">
                <div class="modal-header border-0" style="background:#eff6ff; padding:1.25rem 1.5rem 0.75rem;">
                    <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-pencil-square text-primary"></i> Gửi giải trình chấm công
                    </h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body px-4 py-3">
                    <div class="mb-1" style="font-size:0.83rem; color:#64748b;">Ngày: <strong id="explainDate" class="text-dark"></strong></div>
                    <label class="form-label fw-semibold text-dark mb-1 mt-2" style="font-size:0.83rem;">Lý do giải trình <span class="text-danger">*</span></label>
                    <textarea class="form-control" name="notes" rows="3" required
                              placeholder="Nêu rõ lý do đi muộn, về sớm hoặc quên chấm công..."
                              style="border-radius:9px; font-size:0.875rem;"></textarea>
                </div>
                <div class="modal-footer border-0 px-4 pb-4 gap-2">
                    <button type="button" class="btn btn-light btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm px-4" style="border-radius:9px;">
                        <i class="bi bi-send me-1"></i> Gửi giải trình
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</c:if>

<!-- Modal Xem lịch sử chấm công -->
<div class="modal fade" id="historyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:480px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px; overflow:hidden;">
            <div class="modal-header border-0" style="background:#eff6ff; padding:1.25rem 1.5rem;">
                <h6 class="modal-title fw-bold text-dark d-flex align-items-center gap-2 mb-0">
                    <i class="bi bi-clock-history text-primary"></i>
                    Lịch sử chi tiết chấm công
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4" style="font-size:0.86rem;">
                <div class="d-flex align-items-center gap-3 p-3 mb-3 rounded-3" style="background:#f8fafc; border:1px solid #e2e8f0;">
                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold text-primary" style="width:42px;height:42px;background:#dbeafe;">
                        <i class="bi bi-person-fill fs-5"></i>
                    </div>
                    <div>
                        <div class="fw-bold text-dark" id="histEmpName">—</div>
                        <div class="text-muted" style="font-size:0.78rem;" id="histEmpCode">—</div>
                    </div>
                </div>
                <div class="row g-2">
                    <div class="col-6">
                        <span class="text-muted">Ngày làm việc:</span>
                        <div class="fw-bold text-dark" id="histDate">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted">Ca làm việc:</span>
                        <div class="fw-bold text-dark" id="histShift">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted">Giờ vào (Check-in):</span>
                        <div class="fw-bold text-success" id="histCheckIn">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted">Giờ ra (Check-out):</span>
                        <div class="fw-bold text-primary" id="histCheckOut">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted">Phương thức xác thực:</span>
                        <div class="fw-semibold text-dark" id="histMethod">—</div>
                    </div>
                    <div class="col-6">
                        <span class="text-muted">Tổng giờ làm:</span>
                        <div class="fw-bold text-dark" id="histHours">—</div>
                    </div>
                    <div class="col-12 mt-2">
                        <span class="text-muted">Trạng thái:</span>
                        <div><span class="badge bg-primary-subtle text-primary border" id="histStatus">—</span></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 px-4 pb-4">
                <button type="button" class="btn btn-light btn-sm px-4" data-bs-dismiss="modal" style="border-radius:8px;">Đóng</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/attendance.js"></script>

</body>
</html>
