<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Nhật ký Kiểm toán Hệ thống - MIXIMOI HRM" />
    </jsp:include>
    <style>
        .audit-card {
            background: #fff;
            border-radius: 14px;
            border: 1.5px solid #f1f5f9;
            box-shadow: 0 4px 16px rgba(15,23,42,0.03);
            overflow: hidden;
        }
        .audit-table thead {
            background: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
        }
        .audit-table thead th {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            padding: 0.75rem 1rem;
            vertical-align: middle;
        }
        .audit-table tbody td {
            padding: 0.85rem 1rem;
            vertical-align: middle;
            font-size: 0.84rem;
            border-bottom: 1px solid #f8fafc;
        }
        .audit-table tbody tr:hover {
            background: #fbfcfe;
        }
        .action-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 9px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            font-family: monospace;
        }
        .module-badge {
            background: #f1f5f9;
            color: #475569;
            padding: 3px 8px;
            border-radius: 6px;
            font-size: 0.72rem;
            font-weight: 600;
        }
    </style>
</head>
<body class="hrm-app-body">
<div class="app-layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <div class="app-main">
        <jsp:include page="/WEB-INF/views/common/topbar.jsp" />

        <main class="app-content p-3 p-lg-4">
            <!-- Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h1 class="h3 fw-bold text-dark mb-0">Nhật ký Kiểm toán (Audit Trail)</h1>
                        <span class="badge bg-primary-subtle text-primary fw-bold">
                            <i class="bi bi-shield-lock-fill me-1"></i>ISO 27001 Compliance
                        </span>
                        <span class="badge bg-success-subtle text-success">
                            <i class="bi bi-broadcast me-1"></i>Live Logging
                        </span>
                    </div>
                    <p class="text-muted mb-0" style="font-size: 0.875rem;">
                        Theo dõi lịch sử toàn bộ các thao tác nhạy cảm: Chốt bảng công, Tính toán lương, Lập lệnh chi và Phê duyệt tài chính.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-secondary btn-sm" onclick="location.reload();">
                        <i class="bi bi-arrow-clockwise me-1"></i>Làm mới
                    </button>
                </div>
            </div>

            <!-- Table Card -->
            <div class="audit-card">
                <form method="GET" action="${pageContext.request.contextPath}/audit-logs" class="p-3 border-bottom bg-light d-flex flex-wrap gap-2 align-items-center">
                    <div class="input-group input-group-sm" style="max-width: 320px;">
                        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                        <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Tìm theo Username, IP, Chi tiết...">
                    </div>
                    <select name="moduleFilter" class="form-select form-select-sm" style="max-width: 160px;">
                        <option value="">Tất cả phân hệ</option>
                        <option value="PAYROLL" ${moduleFilter eq 'PAYROLL' ? 'selected' : ''}>Bảng lương (PAYROLL)</option>
                        <option value="PAYMENT" ${moduleFilter eq 'PAYMENT' ? 'selected' : ''}>Thanh toán (PAYMENT)</option>
                        <option value="TIMESHEET" ${moduleFilter eq 'TIMESHEET' ? 'selected' : ''}>Chấm công (TIMESHEET)</option>
                        <option value="EMPLOYEES" ${moduleFilter eq 'EMPLOYEES' ? 'selected' : ''}>Nhân sự (EMPLOYEES)</option>
                        <option value="CONTRACT" ${moduleFilter eq 'CONTRACT' ? 'selected' : ''}>Hợp đồng (CONTRACT)</option>
                        <option value="LEAVE" ${moduleFilter eq 'LEAVE' ? 'selected' : ''}>Nghỉ phép (LEAVE)</option>
                        <option value="AUTH" ${moduleFilter eq 'AUTH' ? 'selected' : ''}>Bảo mật (AUTH)</option>
                    </select>
                    <select name="actionFilter" class="form-select form-select-sm" style="max-width: 170px;">
                        <option value="">Tất cả thao tác</option>
                        <option value="APPROVE" ${actionFilter eq 'APPROVE' ? 'selected' : ''}>Phê duyệt (APPROVE)</option>
                        <option value="LOCK" ${actionFilter eq 'LOCK' ? 'selected' : ''}>Khóa chốt (LOCK)</option>
                        <option value="CALCULATE" ${actionFilter eq 'CALCULATE' ? 'selected' : ''}>Tính toán (CALCULATE)</option>
                        <option value="PAY" ${actionFilter eq 'PAY' ? 'selected' : ''}>Chi trả (PAY)</option>
                        <option value="UPDATE" ${actionFilter eq 'UPDATE' ? 'selected' : ''}>Cập nhật (UPDATE)</option>
                    </select>
                    <button type="submit" class="btn btn-primary btn-sm px-3 d-flex align-items-center gap-1">
                        <i class="bi bi-funnel-fill"></i> Lọc dữ liệu
                    </button>
                    <a href="${pageContext.request.contextPath}/audit-logs" class="btn btn-outline-secondary btn-sm">Đặt lại</a>
                    <span class="badge bg-secondary-subtle text-secondary ms-auto">${auditLogs != null ? auditLogs.size() : 0} bản ghi kiểm toán</span>
                </form>
                <div class="table-responsive">
                    <table class="table audit-table mb-0" id="auditTable">
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th style="width: 170px;">Thời gian</th>
                                <th style="width: 150px;">Người thực hiện</th>
                                <th style="width: 100px;">Vai trò</th>
                                <th style="width: 180px;">Hành động</th>
                                <th style="width: 120px;">Phân hệ</th>
                                <th>Chi tiết nghiệp vụ</th>
                                <th style="width: 120px;">IP Address</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty auditLogs}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="bi bi-shield-check fs-1 text-muted d-block mb-2"></i>
                                            Chưa có bản ghi nhật ký kiểm toán nào được ghi nhận.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="log" items="${auditLogs}">
                                        <tr>
                                            <td class="text-muted fw-bold">#${log.id}</td>
                                            <td class="text-muted font-monospace" style="font-size:0.8rem;">
                                                ${log.createdAt}
                                            </td>
                                            <td>
                                                <div class="fw-bold text-dark">${log.username}</div>
                                                <small class="text-muted">UID: ${log.userId != null ? log.userId : 'N/A'}</small>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary-subtle text-secondary">${log.userRole}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${log.action.contains('LOCK')}">
                                                        <span class="action-badge bg-danger-subtle text-danger"><i class="bi bi-lock-fill"></i>${log.action}</span>
                                                    </c:when>
                                                    <c:when test="${log.action.contains('UNLOCK')}">
                                                        <span class="action-badge bg-success-subtle text-success"><i class="bi bi-unlock-fill"></i>${log.action}</span>
                                                    </c:when>
                                                    <c:when test="${log.action.contains('CALCULATE')}">
                                                        <span class="action-badge bg-primary-subtle text-primary"><i class="bi bi-calculator"></i>${log.action}</span>
                                                    </c:when>
                                                    <c:when test="${log.action.contains('DISBURSE') or log.action.contains('PAY')}">
                                                        <span class="action-badge bg-warning-subtle text-warning-emphasis"><i class="bi bi-cash-stack"></i>${log.action}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="action-badge bg-info-subtle text-info-emphasis"><i class="bi bi-activity"></i>${log.action}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="module-badge">${log.module}</span>
                                            </td>
                                            <td class="text-dark">
                                                ${log.details}
                                                <c:if test="${log.recordId != null}">
                                                    <span class="badge bg-light text-muted border ms-1">ID: ${log.recordId}</span>
                                                </c:if>
                                            </td>
                                            <td class="font-monospace text-muted" style="font-size: 0.78rem;">
                                                <i class="bi bi-hdd-network me-1"></i>${log.ipAddress}
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    // Live filter search for audit table
    document.getElementById('auditSearchInput').addEventListener('input', function() {
        const query = this.value.toLowerCase();
        const rows = document.querySelectorAll('#auditTable tbody tr');
        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(query) ? '' : 'none';
        });
    });
</script>
</body>
</html>
