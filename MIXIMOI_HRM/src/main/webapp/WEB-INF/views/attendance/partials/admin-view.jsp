<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- Alerts -->
<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-3 modern-alert danger" role="alert">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
            <div>
                <c:choose>
                    <c:when test="${param.error eq 'timesheet_locked'}">
                        <strong>Không thể thao tác:</strong> Bảng công của tháng này đã được khóa để chốt lương. Vui lòng mở khóa bảng công trên trang Bảng công nếu cần điều chỉnh.
                    </c:when>
                    <c:when test="${param.error eq 'on_leave'}">
                        <strong>Không thể chấm công:</strong> Nhân viên đang trong thời gian nghỉ phép có hưởng lương (ON_LEAVE) đã được phê duyệt.
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
                    <c:when test="${param.success eq 'checkin'}">Chấm công thủ công thành công!</c:when>
                    <c:when test="${param.success eq 'updated'}">Cập nhật dữ liệu chấm công thành công!</c:when>
                    <c:otherwise>Thao tác dữ liệu chấm công thành công!</c:otherwise>
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
                        <strong>Thông báo:</strong> Nhân viên đã check-in vào ca hôm nay. Giờ check-in ban đầu được giữ nguyên để bảo đảm tính toàn vẹn dữ liệu.
                    </c:when>
                    <c:when test="${param.info eq 'already_checked_out'}">
                        <strong>Thông báo:</strong> Lượt check-out đã được ghi nhận trước đó trong ngày.
                    </c:when>
                    <c:otherwise>${param.info}</c:otherwise>
                </c:choose>
            </div>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Page Header -->
<div class="att-page-header">
    <div>
        <h1 class="att-title">
            Trung Tâm Quản Lý Chấm Công
            <span class="live-sync-badge"><span class="live-dot"></span>Live Sync</span>
        </h1>
        <p class="att-subtitle">Giám sát hiện diện toàn công ty thời gian thực, quản lý ca làm, bất thường và đối soát công</p>
    </div>
    <div class="header-actions">
        <div class="date-display"><i class="bi bi-calendar3 text-primary"></i> Hôm nay: ${todayDisplay}</div>
        <button type="button" class="btn-att-outline" title="Đồng bộ máy chấm công ZKTeco" onclick="syncAttendanceDevice(this)">
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

<!-- Stats Grid (5 Interactive KPI Cards with Click-to-Filter) -->
<div class="att-stats-grid mb-4">
    <div class="att-stat-card interactive-kpi" data-filter="" onclick="filterByCardStatus('')" title="Nhấp để xem tất cả bản ghi">
        <div class="astat-header">
            <div class="astat-label">Quân số ca hôm nay</div>
            <div class="astat-icon blue"><i class="bi bi-people-fill"></i></div>
        </div>
        <div class="astat-value">${totalEmployeesToday}</div>
        <div class="astat-sub">${activeCaShift != null ? activeCaShift : '3'} ca trực hoạt động</div>
    </div>

    <div class="att-stat-card interactive-kpi" data-filter="ON_TIME" onclick="filterByCardStatus('ON_TIME')" title="Nhấp để lọc danh sách đúng giờ">
        <div class="astat-header">
            <div class="astat-label">Đã Check-in</div>
            <div class="astat-icon green"><i class="bi bi-patch-check-fill"></i></div>
        </div>
        <div class="astat-value">
            ${checkedInCount} <span class="fs-6 text-muted fw-normal">/ ${totalEmployeesToday}</span>
        </div>
        <div class="astat-sub">
            <strong>${totalEmployeesToday > 0 ? checkedInCount * 100 / totalEmployeesToday : 0}%</strong> tỷ lệ có mặt
        </div>
    </div>

    <div class="att-stat-card interactive-kpi" data-filter="LATE" onclick="filterByCardStatus('LATE')" title="Nhấp để lọc danh sách đi muộn / về sớm">
        <div class="astat-header">
            <div class="astat-label">Đi muộn / Về sớm</div>
            <div class="astat-icon amber"><i class="bi bi-exclamation-circle-fill"></i></div>
        </div>
        <div class="astat-value">${lateEarlyCount} <span class="fs-6 text-muted fw-normal">trường hợp</span></div>
        <div class="astat-sub"><span class="warn">${lateEarlyDiff != null ? lateEarlyDiff : '+0'} so với hôm qua</span></div>
    </div>

    <div class="att-stat-card interactive-kpi" data-filter="ABSENT" onclick="filterByCardStatus('ABSENT')" title="Nhấp để lọc danh sách vắng mặt">
        <div class="astat-header">
            <div class="astat-label">Vắng mặt</div>
            <div class="astat-icon red"><i class="bi bi-person-x-fill"></i></div>
        </div>
        <div class="astat-value">${absentCount} <span class="fs-6 text-muted fw-normal">nhân sự</span></div>
        <div class="astat-sub">${absentApproved != null ? absentApproved : '0'} có phép, ${absentUnapproved != null ? absentUnapproved : '0'} chưa rõ</div>
    </div>

    <div class="att-stat-card interactive-kpi" data-filter="WFH" onclick="filterByCardStatus('WFH')" title="Nhấp để lọc danh sách làm từ xa">
        <div class="astat-header">
            <div class="astat-label">Làm từ xa (WFH)</div>
            <div class="astat-icon violet"><i class="bi bi-house-fill"></i></div>
        </div>
        <div class="astat-value">${wfhCount} <span class="fs-6 text-muted fw-normal">nhân sự</span></div>
        <div class="astat-sub">GPS Mobile xác thực</div>
    </div>
</div>

<!-- Tab Navigation -->
<div class="att-tab-nav mb-3">
    <a href="${pageContext.request.contextPath}/attendance?tab=daily&month=${selectedMonth}&year=${selectedYear}" class="att-tab-btn ${empty activeTab or activeTab eq 'daily' ? 'active' : ''}">
        <i class="bi bi-journal-text"></i> Nhật ký chấm công hàng ngày
    </a>
    <a href="${pageContext.request.contextPath}/timesheet?tab=monthly&month=${selectedMonth}&year=${selectedYear}" class="att-tab-btn ${activeTab eq 'monthly' ? 'active' : ''}">
        <i class="bi bi-table"></i> Bảng tổng hợp công tháng
    </a>
    <a href="${pageContext.request.contextPath}/attendance?tab=anomaly&month=${selectedMonth}&year=${selectedYear}" class="att-tab-btn ${activeTab eq 'anomaly' ? 'active' : ''}">
        <i class="bi bi-exclamation-triangle-fill text-warning"></i>
        Bất thường &amp; Giải trình
        <c:if test="${anomalyCount > 0}"><span class="att-tab-badge">${anomalyCount}</span></c:if>
    </a>
    <a href="${pageContext.request.contextPath}/attendance?tab=device&month=${selectedMonth}&year=${selectedYear}" class="att-tab-btn ${activeTab eq 'device' ? 'active' : ''}">
        <i class="bi bi-cpu"></i> Thiết bị chấm công
        <c:if test="${deviceOnline}"><span class="att-tab-dot"></span></c:if>
    </a>
</div>

<!-- Unified Quick Filter Bar -->
<div class="att-filter-bar mb-3">
    <form method="get" action="${pageContext.request.contextPath}/attendance" id="filterForm">
        <input type="hidden" name="tab" value="${empty activeTab ? 'daily' : activeTab}">
        <div class="row g-2 align-items-center">
            <div class="col-md-3">
                <div class="filter-search-wrap">
                    <i class="bi bi-search"></i>
                    <input type="text" class="filter-search-input" name="keyword" id="searchEmp"
                           placeholder="Tìm theo tên hoặc mã NV..." value="${keyword}">
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
                <select class="form-select filter-select" name="month" onchange="document.getElementById('filterForm').submit();">
                    <c:forEach begin="1" end="12" var="m">
                        <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m < 10 ? '0' : ''}${m}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
                <select class="form-select filter-select" name="year" onchange="document.getElementById('filterForm').submit();">
                    <c:forEach begin="2025" end="2027" var="y">
                        <option value="${y}" ${selectedYear == y ? 'selected' : ''}>Năm ${y}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary-modern px-3 flex-grow-1" style="height:38px;">
                    <i class="bi bi-funnel-fill me-1"></i> Lọc dữ liệu
                </button>
                <a href="${pageContext.request.contextPath}/attendance" class="btn btn-secondary-modern d-inline-flex align-items-center justify-content-center" style="height:38px; width:38px;" title="Đặt lại bộ lọc">
                    <i class="bi bi-arrow-counterclockwise"></i>
                </a>
            </div>
        </div>
    </form>
</div>

<!-- Sync Status Bar -->
<div class="sync-status-bar mb-3">
    <div>
        <i class="bi bi-wifi text-success me-1"></i>
        <strong>Đồng bộ ${deviceCount != null ? deviceCount : '1'} máy ZKTeco</strong> &bull; Hoạt động ổn định
    </div>
    <div class="kycong">
        <i class="bi bi-calendar-check text-primary me-1"></i>
        Kỳ công: Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}
    </div>
</div>

<!-- Bulk Action Toolbar -->
<div id="bulkToolbar" class="d-none align-items-center gap-2 mb-3 px-3 py-2.5 bulk-action-bar">
    <span class="bulk-selected-label">
        <i class="bi bi-check2-square me-1"></i>
        Đã chọn <strong id="bulkCount">0</strong> bản ghi chấm công
    </span>
    <div class="d-flex gap-2 ms-auto flex-wrap">
        <button type="button" class="btn btn-sm btn-success px-3 rounded-2 fw-semibold" onclick="bulkMarkOnTime()">
            <i class="bi bi-check2-all me-1"></i> Xác nhận đúng giờ
        </button>
        <button type="button" class="btn btn-sm btn-danger px-3 rounded-2 fw-semibold" onclick="bulkDeleteAtt()">
            <i class="bi bi-trash me-1"></i> Xóa hàng loạt
        </button>
        <button type="button" class="btn btn-sm btn-primary px-3 rounded-2 fw-semibold" onclick="bulkExportAtt()">
            <i class="bi bi-file-earmark-excel me-1"></i> Xuất danh sách chọn
        </button>
        <button type="button" class="btn btn-sm btn-light px-3 rounded-2 text-secondary" onclick="clearAttSelection()">
            <i class="bi bi-x-lg me-1"></i> Bỏ chọn
        </button>
    </div>
</div>

<!-- Attendance Table (Admin/HR: Full Management) -->
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
                        <tr id="attEmptyRow">
                            <td colspan="10" class="text-center text-muted py-5">
                                <i class="bi bi-clock-history fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                <div class="fw-semibold text-secondary">Không có dữ liệu chấm công trong kỳ này</div>
                                <div class="small text-muted mt-1">
                                    <a href="#" class="text-primary text-decoration-none fw-semibold" data-bs-toggle="modal" data-bs-target="#manualCheckinModal">
                                        <i class="bi bi-plus-circle me-1"></i>Thêm chấm công thủ công ngay →
                                    </a>
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
                                            <div class="emp-meta">${att.positionName} &bull; <span class="text-primary">${att.departmentName}</span></div>
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
                                                    onclick="approveExplain('${att.id}', this)"
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

    <!-- Table Footer with Pagination -->
    <c:if test="${not empty attendances}">
        <div class="table-footer-bar">
            <span class="text-muted">
                Hiển thị <strong class="text-dark">${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalAttendances ? totalAttendances : currentPage * pageSize}</strong>
                trên tổng số <strong class="text-dark">${totalAttendances}</strong> kết quả
            </span>
            <c:if test="${totalPages > 1}">
                <div class="pagination-row">
                    <span class="text-muted me-2 small">Kỳ công: Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}</span>
                    <a href="${pageContext.request.contextPath}/attendance?tab=${activeTab}&page=${currentPage - 1}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                       class="page-btn ${currentPage <= 1 ? 'disabled' : ''}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                    <c:forEach begin="1" end="${totalPages}" var="pg">
                        <a href="${pageContext.request.contextPath}/attendance?tab=${activeTab}&page=${pg}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                           class="page-btn ${pg == currentPage ? 'active' : ''}">${pg}</a>
                    </c:forEach>
                    <a href="${pageContext.request.contextPath}/attendance?tab=${activeTab}&page=${currentPage + 1}&keyword=${keyword}&departmentId=${departmentId}&status=${status}&month=${selectedMonth}&year=${selectedYear}"
                       class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </div>
            </c:if>
        </div>
    </c:if>
</div>
