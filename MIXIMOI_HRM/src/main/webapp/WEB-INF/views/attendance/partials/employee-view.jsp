<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Alerts -->
<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-3 modern-alert danger" role="alert">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
            <div>
                <c:choose>
                    <c:when test="${param.error eq 'on_leave'}">
                        <strong>Không thể chấm công:</strong> Hôm nay bạn đang trong thời gian nghỉ phép đã được phê duyệt (ON_LEAVE). Hệ thống tự động ghi nhận ngày công mà không cần điểm danh.
                    </c:when>
                    <c:when test="${param.error eq 'not_checked_in'}">
                        <strong>Chưa điểm danh vào ca:</strong> Bạn chưa thực hiện check-in vào ca hôm nay nên không thể ghi nhận check-out ra về.
                    </c:when>
                    <c:when test="${param.error eq 'timesheet_locked'}">
                        <strong>Kỳ công đã khóa:</strong> Bảng công của tháng này đã được khóa để chốt lương. Dữ liệu đã đóng băng, không thể chấm công hay điều chỉnh.
                    </c:when>
                    <c:otherwise>${param.error}</c:otherwise>
                </c:choose>
            </div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty param.success}">
    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-3 modern-alert success" role="alert">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-check-circle-fill fs-5 text-success"></i>
            <div>
                <c:choose>
                    <c:when test="${param.success eq 'checkin'}">
                        <c:choose>
                            <c:when test="${param.method eq 'FaceID'}"><i class="bi bi-person-bounding-box me-1 text-primary"></i> <strong>Nhận diện khuôn mặt (FaceID)</strong> thành công!</c:when>
                            <c:when test="${param.method eq 'Fingerprint'}"><i class="bi bi-fingerprint me-1 text-warning"></i> <strong>Quét vân tay (Fingerprint)</strong> xác thực thành công!</c:when>
                            <c:when test="${param.method eq 'GPS'}"><i class="bi bi-geo-alt-fill me-1 text-success"></i> <strong>GPS Mobile</strong> xác thực vị trí thành công!</c:when>
                            <c:otherwise><i class="bi bi-check-circle me-1"></i> Check-in ghi nhận thành công!</c:otherwise>
                        </c:choose>
                        Chúc bạn một ngày làm việc tràn đầy năng lượng! 🎉
                    </c:when>
                    <c:when test="${param.success eq 'checkout'}">
                        <i class="bi bi-box-arrow-right me-1"></i> Ghi nhận <strong>Check-out thành công!</strong> Cảm ơn bạn đã hoàn thành ca làm việc hôm nay.
                    </c:when>
                </c:choose>
            </div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty param.info}">
    <div class="alert alert-info alert-dismissible fade show border-0 shadow-sm mb-3 modern-alert info" role="alert">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-info-circle-fill fs-5 text-primary"></i>
            <div>
                <c:choose>
                    <c:when test="${param.info eq 'already_checked_in'}">
                        <strong>Thông báo bảo lưu:</strong> Bạn đã check-in vào ca hôm nay lúc <strong>${todayCheckIn != null ? todayCheckIn : 'buổi sáng'}</strong>. Giờ vào ban đầu được cố định để bảo vệ ngày công.
                    </c:when>
                    <c:when test="${param.info eq 'already_checked_out'}">
                        <strong>Thông báo:</strong> Bạn đã ghi nhận check-out ra về hôm nay lúc <strong>${todayCheckOut != null ? todayCheckOut : 'trước đó'}</strong>. Ca làm việc đã kết thúc và được bảo lưu an toàn.
                    </c:when>
                    <c:otherwise>${param.info}</c:otherwise>
                </c:choose>
            </div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- HERO PUNCH-CLOCK & ATTENDANCE CONTROL BANNER -->
<div class="emp-hero-card mb-4">
    <div class="emp-hero-left">
        <div class="live-clock-badge">
            <span class="pulse-recording-dot"></span> GIỜ HỆ THỐNG THỜI GIAN THỰC (GMT+7)
        </div>
        <div class="live-digital-clock" id="liveClockDisplay">--:--:--</div>
        <div class="live-date-text" id="liveDateDisplay">Đang đồng bộ ngày làm việc...</div>
        
        <!-- Ca làm việc & Trạng thái hiện tại -->
        <div class="shift-status-pill mt-3">
            <i class="bi bi-clock me-1 text-primary"></i>
            <span>Ca Hành chính (08:30 – 17:30)</span>
            <span class="shift-divider">&bull;</span>
            <c:choose>
                <c:when test="${not empty todayCheckOut}">
                    <span class="badge bg-success bg-opacity-15 text-success fw-bold">Đã xong ca (${todayHours})</span>
                </c:when>
                <c:when test="${not empty todayCheckIn}">
                    <span class="badge bg-primary bg-opacity-15 text-primary fw-bold">Đang làm việc (${todayHours})</span>
                </c:when>
                <c:otherwise>
                    <span class="badge bg-secondary bg-opacity-15 text-secondary fw-semibold">Chưa vào ca</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="emp-hero-right">
        <div class="checkin-action-cluster">
            <c:choose>
                <c:when test="${isOnLeave}">
                    <div class="on-leave-banner">
                        <i class="bi bi-calendar-heart fs-3 text-warning"></i>
                        <div>
                            <div class="fw-bold text-warning-emphasis">Hôm nay bạn đang trong thời gian Nghỉ phép (ON_LEAVE)</div>
                            <small class="text-muted">Hệ thống đã tự động ghi nhận ngày công, bạn không cần điểm danh.</small>
                        </div>
                    </div>
                </c:when>
                <c:when test="${isMonthLocked}">
                    <div class="month-locked-banner">
                        <i class="bi bi-lock-fill fs-3 text-secondary"></i>
                        <div>
                            <div class="fw-bold text-dark">Bảng công kỳ này đã Khóa chốt lương</div>
                            <small class="text-muted">Dữ liệu đã đóng băng, không thể tạo lượt chấm công mới.</small>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Unified Biometric Buttons Cluster -->
                    <div class="d-flex flex-wrap gap-2 justify-content-end align-items-center">
                        <!-- Nút FaceID AI -->
                        <button type="button" class="btn-biometric faceid ${todayCheckIn != null ? 'is-disabled' : ''}" id="btnCheckinFaceID"
                                title="Nhận diện khuôn mặt AI chống giả mạo" ${todayCheckIn != null ? 'disabled' : ''}
                                data-bs-toggle="modal" data-bs-target="#faceIdScannerModal" onclick="startFaceCamera()">
                            <i class="bi bi-person-bounding-box"></i>
                            <span>FaceID AI</span>
                        </button>

                        <!-- Nút Quét vân tay -->
                        <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline">
                            <input type="hidden" name="action" value="checkin">
                            <input type="hidden" name="method" value="Fingerprint">
                            <button type="submit" class="btn-biometric fingerprint ${todayCheckIn != null ? 'is-disabled' : ''}" id="btnCheckinFingerprint"
                                    title="Quét vân tay máy chấm công" ${todayCheckIn != null ? 'disabled' : ''}>
                                <i class="bi bi-fingerprint"></i>
                                <span>Vân tay</span>
                            </button>
                        </form>

                        <!-- Nút GPS Mobile WFH -->
                        <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline" id="gpsCheckinForm">
                            <input type="hidden" name="action" value="checkin">
                            <input type="hidden" name="method" value="GPS">
                            <input type="hidden" name="latitude" id="gpsLatitude" value="">
                            <input type="hidden" name="longitude" id="gpsLongitude" value="">
                            <button type="button" class="btn-biometric gps ${todayCheckIn != null ? 'is-disabled' : ''}" id="btnCheckinGPS"
                                    title="Chấm công từ xa WFH bằng định vị GPS" ${todayCheckIn != null ? 'disabled' : ''}
                                    onclick="triggerGpsCheckIn()">
                                <i class="bi bi-geo-alt-fill"></i>
                                <span>GPS WFH</span>
                            </button>
                        </form>

                        <!-- Nút Check-out -->
                        <c:choose>
                            <c:when test="${not empty todayCheckOut}">
                                <button type="button" class="btn-biometric-checkout completed" disabled>
                                    <i class="bi bi-check2-all"></i> Đã hoàn thành ca
                                </button>
                            </c:when>
                            <c:when test="${empty todayCheckIn}">
                                <button type="button" class="btn-biometric-checkout" onclick="if (window.MixiToast) MixiToast.warning('Chưa vào ca', 'Bạn chưa điểm danh check-in vào ca hôm nay!'); else alert('Bạn chưa điểm danh check-in vào ca hôm nay!');">
                                    <i class="bi bi-box-arrow-right"></i> Check-out
                                </button>
                            </c:when>
                            <c:otherwise>
                                <form method="post" action="${pageContext.request.contextPath}/attendance" class="d-inline">
                                    <input type="hidden" name="action" value="checkout">
                                    <button type="submit" class="btn-biometric-checkout active" id="btnCheckout">
                                        <i class="bi bi-box-arrow-right"></i> Check-out Ra về
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- 4 TODAY STATUS CARDS (EMPLOYEE) -->
<div class="row g-3 mb-4">
    <div class="col-6 col-md-3">
        <div class="modern-stat-card">
            <div class="mstat-icon green"><i class="bi bi-box-arrow-in-right"></i></div>
            <div class="mstat-content">
                <div class="mstat-label">Check-in hôm nay</div>
                <div class="mstat-val font-monospace">${todayCheckIn != null ? todayCheckIn : '--:--:--'}</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="modern-stat-card">
            <div class="mstat-icon red"><i class="bi bi-box-arrow-right"></i></div>
            <div class="mstat-content">
                <div class="mstat-label">Check-out hôm nay</div>
                <div class="mstat-val font-monospace">${todayCheckOut != null ? todayCheckOut : '--:--:--'}</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="modern-stat-card">
            <div class="mstat-icon blue"><i class="bi bi-clock-history"></i></div>
            <div class="mstat-content">
                <div class="mstat-label">Giờ thực tế hôm nay</div>
                <div class="mstat-val font-monospace">${todayHours != null ? todayHours : '0h 00m'}</div>
            </div>
        </div>
    </div>
    <div class="col-6 col-md-3">
        <div class="modern-stat-card">
            <div class="mstat-icon violet"><i class="bi bi-calendar-check"></i></div>
            <div class="mstat-content">
                <div class="mstat-label">Ngày công Tháng ${selectedMonth}/${selectedYear}</div>
                <div class="mstat-val">${workDaysThisMonth != null ? workDaysThisMonth : '0'} ngày</div>
            </div>
        </div>
    </div>
</div>

<!-- MONTH FILTER & VIEW MODE TOGGLE -->
<div class="d-flex align-items-center justify-content-between flex-wrap gap-3 mb-3">
    <form method="get" action="${pageContext.request.contextPath}/attendance" class="d-flex align-items-center gap-2">
        <select class="form-select filter-select" name="month" style="width: 130px;">
            <c:forEach var="m" begin="1" end="12">
                <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m < 10 ? '0' : ''}${m}</option>
            </c:forEach>
        </select>
        <select class="form-select filter-select" name="year" style="width: 100px;">
            <option value="2025" ${selectedYear == 2025 ? 'selected' : ''}>2025</option>
            <option value="2026" ${selectedYear == 2026 ? 'selected' : ''}>2026</option>
            <option value="2027" ${selectedYear == 2027 ? 'selected' : ''}>2027</option>
        </select>
        <button type="submit" class="btn btn-primary-modern px-3" style="height:38px;">
            <i class="bi bi-funnel-fill me-1"></i> Xem
        </button>
    </form>

    <div class="btn-group btn-group-sm p-1 bg-white rounded-3 border shadow-xs">
        <button type="button" class="btn btn-sm px-3 rounded-2 fw-semibold btn-primary" id="btnShowList" onclick="switchAttView('list')">
            <i class="bi bi-list-ul me-1"></i> Bảng chi tiết
        </button>
        <button type="button" class="btn btn-sm px-3 rounded-2 fw-semibold text-secondary" id="btnShowCalendar" onclick="switchAttView('calendar')">
            <i class="bi bi-grid-3x3-gap-fill me-1"></i> Lịch Heatmap
        </button>
    </div>
</div>

<!-- CALENDAR HEATMAP CARD -->
<div class="att-table-card d-none mb-4 p-4" id="employeeCalendarCard">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div class="fw-bold text-dark fs-6">
            <i class="bi bi-calendar3 me-2 text-primary"></i>
            Lịch Chấm công Ma trận Heatmap &bull; Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}
        </div>
        <span class="badge bg-primary-subtle text-primary border px-2.5 py-1 small">
            <i class="bi bi-arrow-repeat me-1"></i>Đồng bộ thời gian thực
        </span>
    </div>

    <!-- Calendar Header (Mon - Sun) -->
    <div class="calendar-grid-header d-grid text-center fw-bold mb-2 pb-2 border-bottom">
        <div>Thứ Hai</div>
        <div>Thứ Ba</div>
        <div>Thứ Tư</div>
        <div>Thứ Năm</div>
        <div>Thứ Sáu</div>
        <div class="text-danger">Thứ Bảy</div>
        <div class="text-danger">Chủ Nhật</div>
    </div>

    <!-- Calendar Days Grid Body -->
    <div id="calendarGridBody" class="calendar-grid-body d-grid gap-2">
        <!-- Populated by AttendanceCalendar.renderHeatmap() in attendance.js -->
    </div>

    <!-- Hidden data store for attendance records -->
    <div id="attDataStore" class="d-none" data-month="${selectedMonth}" data-year="${selectedYear}">
        <c:forEach var="a" items="${attendances}">
            <span data-date="${a.workDate}" data-checkin="${a.checkIn}" data-checkout="${a.checkOut}" data-status="${a.status}" data-hours="${a.totalHours}" data-deviation="${a.deviation}"></span>
        </c:forEach>
    </div>

    <!-- Legend -->
    <div class="d-flex flex-wrap gap-3 mt-4 pt-3 border-top align-items-center justify-content-center small">
        <span class="d-flex align-items-center gap-1.5"><span class="badge rounded-circle p-1 bg-success">&nbsp;</span> Đúng giờ</span>
        <span class="d-flex align-items-center gap-1.5"><span class="badge rounded-circle p-1 bg-warning text-dark">&nbsp;</span> Đi muộn / Về sớm</span>
        <span class="d-flex align-items-center gap-1.5"><span class="badge rounded-circle p-1 bg-danger">&nbsp;</span> Vắng mặt</span>
        <span class="d-flex align-items-center gap-1.5"><span class="badge rounded-circle p-1 bg-info">&nbsp;</span> Nghỉ phép</span>
        <span class="d-flex align-items-center gap-1.5"><span class="badge rounded-circle p-1" style="background:#8b5cf6;">&nbsp;</span> Tăng ca (OT)</span>
        <span class="d-flex align-items-center gap-1.5 text-muted"><span class="badge rounded-circle p-1 bg-secondary bg-opacity-25">&nbsp;</span> Cuối tuần</span>
    </div>
</div>

<!-- EMPLOYEE ATTENDANCE TABLE CARD -->
<div class="att-table-card" id="employeeTableCard">
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
                                <i class="bi bi-clock-history fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                <div class="fw-semibold text-secondary">Chưa có dữ liệu chấm công</div>
                                <small class="text-muted">trong tháng ${selectedMonth}/${selectedYear}</small>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="att" items="${attendances}">
                            <tr class="${att.status eq 'LATE' ? 'row-late' : att.status eq 'ABSENT' ? 'row-absent' : ''}">
                                <td style="padding-left:1.25rem;">
                                    <span class="fw-bold text-dark font-monospace">${att.workDate}</span>
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
                                    <c:if test="${att.checkOut != null}">
                                        <div class="checkin-time">${att.checkOut}</div>
                                    </c:if>
                                    <c:if test="${att.checkOut == null}"><span class="text-muted small">—&nbsp;(Chưa về)</span></c:if>
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
                                        <button type="button" class="action-btn history" title="Xem lịch sử"
                                                data-id="${att.id}" data-name="<c:out value='${sessionScope.currentUser.fullName}'/>" data-code="${sessionScope.currentUser.employeeCode}" data-date="${att.workDate}"
                                                data-checkin="${att.checkIn}" data-checkout="${att.checkOut}" data-shift="${att.shiftName != null ? att.shiftName : 'Ca Hành chính'}"
                                                data-status="${att.status}" data-method="${att.method != null ? att.method : 'Thủ công'}" data-hours="${att.totalHours}"
                                                onclick="viewHistory(this)"><i class="bi bi-clock-history"></i></button>
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
            <span class="text-muted small">MIXIMOI Smart Biometrics</span>
        </div>
    </c:if>
</div>
