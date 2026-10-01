<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Page Header -->
<div class="att-page-header">
    <div>
        <h1 class="att-title">
            Giám Sát Chấm Công Phòng Ban
            <span class="live-sync-badge"><span class="live-dot"></span>Live Sync</span>
        </h1>
        <p class="att-subtitle">Theo dõi hiện diện thời gian thực của nhân sự phòng ban, phê duyệt giải trình và đơn vắng mặt</p>
    </div>
    <div class="header-actions">
        <div class="date-display"><i class="bi bi-calendar3 text-primary"></i> Hôm nay: ${todayDisplay}</div>
        <a href="${pageContext.request.contextPath}/attendance?action=export&month=${selectedMonth}&year=${selectedYear}" class="btn-att-outline">
            <i class="bi bi-file-earmark-excel text-success"></i> Xuất Excel
        </a>
    </div>
</div>

<!-- Manager Stats (4 interactive cards) -->
<div class="att-stats-grid mb-4" style="grid-template-columns: repeat(4,1fr);">
    <div class="att-stat-card" data-filter="" onclick="filterByCardStatus('')">
        <div class="astat-header">
            <div class="astat-label">Quân số ca hôm nay</div>
            <div class="astat-icon blue"><i class="bi bi-people-fill"></i></div>
        </div>
        <div class="astat-value">${deptTotalToday}</div>
        <div class="astat-sub">Nhân sự trong phòng ban</div>
    </div>
    <div class="att-stat-card" data-filter="ON_TIME" onclick="filterByCardStatus('ON_TIME')">
        <div class="astat-header">
            <div class="astat-label">Đã Check-in</div>
            <div class="astat-icon green"><i class="bi bi-check-circle-fill"></i></div>
        </div>
        <div class="astat-value">${deptCheckedIn}</div>
        <div class="astat-sub"><strong>${deptTotalToday > 0 ? deptCheckedIn * 100 / deptTotalToday : 0}%</strong> đúng tiêu chuẩn ca</div>
    </div>
    <div class="att-stat-card" data-filter="LATE" onclick="filterByCardStatus('LATE')">
        <div class="astat-header">
            <div class="astat-label">Đi muộn / Về sớm</div>
            <div class="astat-icon amber"><i class="bi bi-clock-history"></i></div>
        </div>
        <div class="astat-value">${deptLateCount}</div>
        <div class="astat-sub"><span class="warn">Cần theo dõi sát ca</span></div>
    </div>
    <div class="att-stat-card">
        <div class="astat-header">
            <div class="astat-label">Chờ phê duyệt</div>
            <div class="astat-icon violet"><i class="bi bi-hourglass-split"></i></div>
        </div>
        <div class="astat-value">${pendingApprovals}</div>
        <div class="astat-sub">Giải trình &amp; Nghỉ phép</div>
    </div>
</div>

<!-- Filter Bar -->
<div class="att-filter-bar mb-3">
    <div class="row g-2 align-items-center">
        <div class="col-md-5">
            <div class="filter-search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" class="filter-search-input" id="searchEmp"
                       placeholder="Tìm theo tên hoặc mã nhân viên (NV-...)" value="${keyword}">
            </div>
        </div>
        <div class="col-md-4">
            <select class="form-select filter-select" id="filterStatus">
                <option value="">Tất cả trạng thái</option>
                <option value="ON_TIME">Đúng giờ</option>
                <option value="LATE">Đi muộn</option>
                <option value="EARLY_LEAVE">Về sớm</option>
                <option value="ON_LEAVE">Nghỉ phép</option>
                <option value="WFH">WFH Đã duyệt</option>
                <option value="ABSENT">Vắng mặt</option>
            </select>
        </div>
        <div class="col-md-3 d-flex align-items-center justify-content-end">
            <label class="toggle-switch-label">
                <input type="checkbox" id="toggleAnomaly" class="form-check-input toggle" role="switch">
                <span>Chỉ hiện Bất thường</span>
            </label>
        </div>
    </div>
</div>

<!-- Attendance Table (Manager) -->
<div class="att-table-card">
    <div class="table-responsive">
        <table class="att-table" id="attTable">
            <thead>
                <tr>
                    <th style="width:42px; padding-left:1.25rem;"><input type="checkbox" id="checkAll" class="form-check-input"></th>
                    <th style="width:115px;">Ngày làm việc</th>
                    <th>Nhân viên &amp; Chức vụ</th>
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
                            <td colspan="10" class="text-center text-muted py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                <div class="fw-semibold text-secondary">Không có dữ liệu chấm công phòng ban</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="att" items="${attendances}">
                            <tr class="att-row ${att.status eq 'LATE' ? 'row-late' : att.status eq 'ABSENT' ? 'row-absent' : att.status eq 'WFH' ? 'row-wfh' : ''}"
                                data-keyword="${att.employeeName} ${att.employeeCode} ${att.departmentName}"
                                data-status="${att.status}"
                                data-id="${att.id}">
                                <td style="padding-left:1.25rem;"><input type="checkbox" class="form-check-input row-check" value="${att.id}"></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${att.workDate eq today}">
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1 small fw-bold">
                                                <i class="bi bi-calendar-event me-1"></i>${att.workDate} <small>(Hôm nay)</small>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="fw-bold text-dark font-monospace small">${att.workDate}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="emp-cell">
                                        <div class="emp-avatar gen-n">${att.employeeName != null ? att.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                        <div>
                                            <div class="emp-name">${att.employeeName}</div>
                                            <div class="emp-meta">${att.positionName}</div>
                                            <div class="emp-code font-monospace">${att.employeeCode}</div>
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
                                        <button type="button" class="action-btn approve" title="Phê duyệt giải trình" onclick="approveExplain('${att.id}', this)"><i class="bi bi-check-square"></i></button>
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
                Hiển thị <strong class="text-dark">${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalAttendances ? totalAttendances : currentPage * pageSize}</strong>
                / ${totalAttendances} bản ghi
            </span>
            <c:if test="${totalPages > 1}">
                <div class="pagination-row">
                    <span class="text-muted me-2 small">Kỳ công: Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}</span>
                    <a href="${pageContext.request.contextPath}/attendance?page=${currentPage - 1}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                       class="page-btn ${currentPage <= 1 ? 'disabled' : ''}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                    <c:forEach begin="1" end="${totalPages}" var="pg">
                        <a href="${pageContext.request.contextPath}/attendance?page=${pg}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                           class="page-btn ${pg == currentPage ? 'active' : ''}">${pg}</a>
                    </c:forEach>
                    <a href="${pageContext.request.contextPath}/attendance?page=${currentPage + 1}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                       class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </div>
            </c:if>
        </div>
    </c:if>
</div>
