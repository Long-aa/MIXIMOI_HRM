<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Page Header -->
<div class="att-page-header">
    <div>
        <h1 class="att-title">
            Bảng Tổng Hợp Chấm Công
            <span class="live-sync-badge"><span class="live-dot"></span>Live Sync</span>
        </h1>
        <p class="att-subtitle">Đối soát dữ liệu chấm công thực tế của nhân sự phục vụ tính lương và quyết toán kỳ công</p>
    </div>
    <div class="header-actions">
        <a href="${pageContext.request.contextPath}/attendance?action=export&month=${selectedMonth}&year=${selectedYear}" class="btn-att-outline">
            <i class="bi bi-file-earmark-excel text-success"></i> Xuất Excel
        </a>
    </div>
</div>

<!-- Monthly Summary Filter Card -->
<div class="monthly-summary-card mb-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
        <div class="d-flex align-items-center gap-2">
            <div class="rounded-3 p-2 bg-primary-subtle text-primary">
                <i class="bi bi-table fs-5"></i>
            </div>
            <div>
                <h6 class="fw-bold text-dark mb-0">Bảng tổng hợp công — Tháng ${selectedMonth < 10 ? '0' : ''}${selectedMonth}/${selectedYear}</h6>
                <small class="text-muted">Chế độ xem chỉ đọc dành cho Kế toán & Quản trị tài chính</small>
            </div>
        </div>
        <form method="get" action="${pageContext.request.contextPath}/attendance" class="d-flex align-items-center gap-2">
            <select class="form-select filter-select" name="month" style="width:130px;">
                <c:forEach var="m" begin="1" end="12">
                    <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m < 10 ? '0' : ''}${m}</option>
                </c:forEach>
            </select>
            <select class="form-select filter-select" name="year" style="width:100px;">
                <option value="2025" ${selectedYear == 2025 ? 'selected' : ''}>2025</option>
                <option value="2026" ${selectedYear == 2026 ? 'selected' : ''}>2026</option>
                <option value="2027" ${selectedYear == 2027 ? 'selected' : ''}>2027</option>
            </select>
            <button type="submit" class="btn btn-primary-modern px-3" style="height:38px;">
                <i class="bi bi-funnel-fill me-1"></i> Xem
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
                    <th class="text-center">Nghỉ phép</th>
                    <th class="text-end" style="padding-right:1.25rem;">Tổng giờ làm</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty timesheetSummary}">
                        <tr>
                            <td colspan="9" class="text-center text-muted py-5">
                                <i class="bi bi-table fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                <div class="fw-semibold text-secondary">Chưa có dữ liệu bảng công tháng ${selectedMonth}/${selectedYear}</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="ts" items="${timesheetSummary}">
                            <tr>
                                <td style="padding-left:1.25rem;">
                                    <div class="emp-cell">
                                        <div class="emp-avatar gen-n">${ts.employeeName != null ? ts.employeeName.substring(0,1).toUpperCase() : 'NV'}</div>
                                        <div>
                                            <div class="emp-name">${ts.employeeName}</div>
                                            <div class="emp-code font-monospace">${ts.employeeCode}</div>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-secondary border">${ts.departmentName}</span></td>
                                <td class="text-center"><strong class="fs-6 text-dark">${ts.totalWorkDays}</strong></td>
                                <td class="text-center"><span class="text-success fw-bold">${ts.onTimeDays}</span></td>
                                <td class="text-center"><span class="text-warning-emphasis fw-bold">${ts.lateDays}</span></td>
                                <td class="text-center"><span class="text-danger-emphasis fw-bold">${ts.earlyLeaveDays}</span></td>
                                <td class="text-center"><span class="text-danger fw-bold">${ts.absentDays}</span></td>
                                <td class="text-center"><span class="text-primary fw-bold">${ts.leaveDays}</span></td>
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
            <span class="text-muted small">Chỉ đọc &bull; Phục vụ tính lương</span>
        </div>
    </c:if>
</div>
