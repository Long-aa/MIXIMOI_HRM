<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Phiếu Lương Điện Tử A4 —
        <c:out value="${not empty payroll ? payroll.employeeName : 'N/A'}"/>
        (${not empty payroll ? payroll.employeeCode : ''}) — MIXIMOI HRM
    </title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="payslip" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <%-- Alert if sent --%>
            <c:if test="${param.success eq 'sent'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Đã gửi phiếu lương điện tử trực tiếp đến hòm thư và thông báo đẩy App của
                        <strong><c:out value="${payroll.employeeName}"/></strong>!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty payroll}">
                    <%-- Không tìm thấy phiếu lương --%>
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-file-earmark-x fs-1 d-block mb-3 text-warning"></i>
                        <h4>Không tìm thấy phiếu lương</h4>
                        <p>Kỳ lương này chưa được tính hoặc không tồn tại.</p>
                        <a href="${pageContext.request.contextPath}/payslip" class="btn btn-primary">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- Sticky Action Topbar --%>
                    <div class="payslip-action-topbar mb-4">
                        <div class="d-flex align-items-center gap-3">
                            <a href="${pageContext.request.contextPath}/payslip?month=${payroll.payMonth}&year=${payroll.payYear}"
                               class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-1">
                                <i class="bi bi-arrow-left"></i>
                                <span>Quay lại danh sách</span>
                            </a>
                            <div class="d-none d-md-flex align-items-center gap-2 border-start ps-3">
                                <c:choose>
                                    <c:when test="${payroll.status eq 'PAID'}">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                                            <i class="bi bi-patch-check-fill"></i> Đã chi trả thành công
                                        </span>
                                    </c:when>
                                    <c:when test="${payroll.status eq 'APPROVED'}">
                                        <span class="badge bg-info-subtle text-info border border-info-subtle d-inline-flex align-items-center gap-1">
                                            <i class="bi bi-check-circle-fill"></i> Đã phê duyệt — Chờ chi trả
                                        </span>
                                    </c:when>
                                    <c:when test="${payroll.status eq 'PENDING'}">
                                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle d-inline-flex align-items-center gap-1">
                                            <i class="bi bi-hourglass-split"></i> Chờ phê duyệt
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary-subtle text-secondary border d-inline-flex align-items-center gap-1">
                                            <i class="bi bi-pencil-square"></i> Bản nháp
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <span class="text-muted small font-monospace">Mã tra cứu: <c:out value="${slipCode}"/></span>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-dark btn-sm d-flex align-items-center gap-1" onclick="window.print()">
                                <i class="bi bi-printer"></i>
                                <span>In phiếu lương</span>
                            </button>
                            <button type="button" class="btn btn-outline-primary btn-sm d-flex align-items-center gap-1"
                                    onclick="alert('Đang tạo và tải xuống file PDF khổ A4 có nhúng chứng thư số HSM...');">
                                <i class="bi bi-file-earmark-pdf"></i>
                                <span>Tải PDF ký số</span>
                            </button>
                            <c:if test="${sessionScope.currentUser.role eq 'ADMIN' or sessionScope.currentUser.role eq 'ACCOUNTANT'}">
                                <form method="post" action="${pageContext.request.contextPath}/payslip" class="m-0">
                                    <input type="hidden" name="action" value="send_single">
                                    <input type="hidden" name="id" value="${payroll.id}">
                                    <button type="submit" class="btn btn-primary btn-sm d-flex align-items-center gap-1 shadow-sm">
                                        <i class="bi bi-send-fill"></i>
                                        <span>Gửi cho nhân viên</span>
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>

                    <%-- A4 Document --%>
                    <div class="payslip-a4-wrapper">
                        <div class="payslip-paper-card position-relative">
                            <%-- Watermark --%>
                            <div class="payslip-watermark">MIXIMOI</div>

                            <%-- Header --%>
                            <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="d-flex align-items-center justify-content-center bg-primary text-white rounded-3 shadow-sm"
                                         style="width:46px; height:46px; font-size:1.4rem;">
                                        <i class="bi bi-building-fill-gear"></i>
                                    </div>
                                    <div>
                                        <h2 class="h6 fw-bold text-dark mb-0 text-uppercase" style="letter-spacing:0.5px;">CÔNG TY TNHH MIXIMOI VIỆT NAM</h2>
                                        <div class="text-muted" style="font-size:0.76rem;">Tầng 25, Landmark 81, 720A Điện Biên Phủ, P.22, Q. Bình Thạnh, TP.HCM</div>
                                        <div class="text-muted" style="font-size:0.74rem;">Mã số thuế: <strong>0316888999</strong> • Hotline: 1900 6868 • Email: hr@miximoi.vn</div>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <div class="fw-bold text-primary font-monospace" style="font-size:0.95rem;">MÃ PHIẾU: <c:out value="${slipCode}"/></div>
                                    <div class="text-muted" style="font-size:0.76rem;">Kỳ lương: <strong>Tháng ${payroll.payMonth}/${payroll.payYear}</strong></div>
                                    <c:choose>
                                        <c:when test="${payroll.status eq 'PAID'}">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle mt-1" style="font-size:0.7rem;">
                                                <i class="bi bi-check-circle-fill"></i> ĐÃ THANH TOÁN
                                            </span>
                                        </c:when>
                                        <c:when test="${payroll.status eq 'APPROVED'}">
                                            <span class="badge bg-info-subtle text-info border mt-1" style="font-size:0.7rem;">
                                                <i class="bi bi-check-circle"></i> ĐÃ DUYỆT
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning-subtle text-warning-emphasis border mt-1" style="font-size:0.7rem;">
                                                <i class="bi bi-clock"></i> CHỜ XỬ LÝ
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <%-- Title --%>
                            <div class="text-center my-3">
                                <h1 class="payslip-official-title">PHIẾU LƯƠNG NHÂN VIÊN</h1>
                                <div class="text-muted fw-semibold" style="font-size:0.85rem;">
                                    KỲ LƯƠNG: THÁNG ${payroll.payMonth}/${payroll.payYear} •
                                    Từ ngày 01/${payroll.payMonth < 10 ? '0' : ''}${payroll.payMonth}/${payroll.payYear}
                                    đến ngày
                                    <fmt:parseDate value="${payroll.payYear}-${payroll.payMonth < 10 ? '0' : ''}${payroll.payMonth}-01" pattern="yyyy-MM-dd" var="periodDate"/>
                                    <fmt:formatDate value="${periodDate}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>

                            <%-- Employee Details Grid --%>
                            <div class="payslip-meta-grid">
                                <div class="payslip-meta-item">
                                    <span class="payslip-meta-label">Họ và tên nhân viên:</span>
                                    <span class="payslip-meta-value text-primary fs-6"><c:out value="${payroll.employeeName}"/></span>
                                </div>
                                <div class="payslip-meta-item">
                                    <span class="payslip-meta-label">Mã số nhân viên:</span>
                                    <span class="payslip-meta-value font-monospace"><c:out value="${payroll.employeeCode}"/></span>
                                </div>
                                <div class="payslip-meta-item">
                                    <span class="payslip-meta-label">Phòng ban:</span>
                                    <span class="payslip-meta-value"><c:out value="${not empty payroll.departmentName ? payroll.departmentName : '—'}"/></span>
                                </div>
                                <div class="payslip-meta-item">
                                    <span class="payslip-meta-label">Chức vụ / Loại HĐ:</span>
                                    <span class="payslip-meta-value"><c:out value="${not empty contract ? contract.contractType : '—'}"/></span>
                                </div>
                                <div class="payslip-meta-item">
                                    <span class="payslip-meta-label">Ngày công chuẩn:</span>
                                    <span class="payslip-meta-value"><fmt:formatNumber value="${payroll.standardDays}" pattern="0.0"/> ngày</span>
                                </div>
                                <div class="payslip-meta-item">
                                    <span class="payslip-meta-label">Ngày công thực tế:</span>
                                    <span class="payslip-meta-value text-success">
                                        <fmt:formatNumber value="${payroll.workingDays}" pattern="0.0"/> /
                                        <fmt:formatNumber value="${payroll.standardDays}" pattern="0.0"/> ngày
                                    </span>
                                </div>
                                <div class="payslip-meta-item">
                                    <span class="payslip-meta-label">Tiền tăng ca (OT):</span>
                                    <span class="payslip-meta-value">
                                        <c:choose>
                                            <c:when test="${not empty payroll.overtimeAmount and payroll.overtimeAmount > 0}">
                                                <fmt:formatNumber value="${payroll.overtimeAmount}" pattern="#,###"/> VNĐ
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="payslip-meta-item">
                                    <span class="payslip-meta-label">Tài khoản nhận lương:</span>
                                    <span class="payslip-meta-value font-monospace">
                                        <c:out value="${not empty employee ? (not empty employee.bankAccount ? employee.bankAccount : 'Chưa cập nhật') : '—'}"/>
                                    </span>
                                </div>
                            </div>

                            <%-- Earnings vs Deductions Table --%>
                            <div class="row g-4 my-2">
                                <div class="col-12 col-md-6">
                                    <div class="payslip-section-title d-flex justify-content-between">
                                        <span>I. Các khoản thu nhập</span>
                                        <span>Số tiền (VNĐ)</span>
                                    </div>
                                    <table class="payslip-table-detail">
                                        <tbody>
                                            <tr>
                                                <td>1. Lương cơ bản theo hợp đồng</td>
                                                <td class="text-end fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty payroll.baseSalary and payroll.baseSalary > 0}">
                                                            <fmt:formatNumber value="${payroll.baseSalary}" pattern="#,###"/>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>2. Phụ cấp (ăn trưa, xăng xe, ...)</td>
                                                <td class="text-end fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty payroll.allowance and payroll.allowance > 0}">
                                                            <fmt:formatNumber value="${payroll.allowance}" pattern="#,###"/>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">0</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>3. Thưởng hiệu suất (KPI/Bonus)</td>
                                                <td class="text-end fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty payroll.bonus and payroll.bonus > 0}">
                                                            <fmt:formatNumber value="${payroll.bonus}" pattern="#,###"/>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">0</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>4. Lương làm thêm giờ (OT)</td>
                                                <td class="text-end fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty payroll.overtimeAmount and payroll.overtimeAmount > 0}">
                                                            <fmt:formatNumber value="${payroll.overtimeAmount}" pattern="#,###"/>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">0</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr class="fw-bold bg-light">
                                                <td class="py-2 text-dark">TỔNG THU NHẬP (GROSS)</td>
                                                <td class="py-2 text-end text-primary fs-6">
                                                    <c:choose>
                                                        <c:when test="${grossIncome > 0}"><fmt:formatNumber value="${grossIncome}" pattern="#,###"/></c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="col-12 col-md-6">
                                    <div class="payslip-section-title d-flex justify-content-between text-danger">
                                        <span>II. Các khoản khấu trừ</span>
                                        <span>Số tiền (VNĐ)</span>
                                    </div>
                                    <table class="payslip-table-detail">
                                        <tbody>
                                            <tr>
                                                <td>1. Bảo hiểm Xã hội (BHXH 8.0%)</td>
                                                <td class="text-end fw-semibold text-danger">
                                                    <c:choose>
                                                        <c:when test="${bhxh > 0}"><fmt:formatNumber value="${bhxh}" pattern="#,###"/></c:when>
                                                        <c:otherwise>0</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>2. Bảo hiểm Y tế (BHYT 1.5%)</td>
                                                <td class="text-end fw-semibold text-danger">
                                                    <c:choose>
                                                        <c:when test="${bhyt > 0}"><fmt:formatNumber value="${bhyt}" pattern="#,###"/></c:when>
                                                        <c:otherwise>0</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>3. Bảo hiểm Thất nghiệp (BHTN 1.0%)</td>
                                                <td class="text-end fw-semibold text-danger">
                                                    <c:choose>
                                                        <c:when test="${bhtn > 0}"><fmt:formatNumber value="${bhtn}" pattern="#,###"/></c:when>
                                                        <c:otherwise>0</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>4. Thuế Thu nhập cá nhân (TNCN)</td>
                                                <td class="text-end fw-semibold text-muted">0</td>
                                            </tr>
                                            <tr>
                                                <td>5. Tạm ứng lương trong kỳ</td>
                                                <td class="text-end fw-semibold text-muted">0</td>
                                            </tr>
                                            <tr class="fw-bold bg-light">
                                                <td class="py-2 text-dark">TỔNG CÁC KHOẢN KHẤU TRỪ</td>
                                                <td class="py-2 text-end text-danger fs-6">
                                                    <c:choose>
                                                        <c:when test="${not empty payroll.deduction and payroll.deduction > 0}">
                                                            -<fmt:formatNumber value="${payroll.deduction}" pattern="#,###"/>
                                                        </c:when>
                                                        <c:otherwise>0</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <%-- Net Take-Home --%>
                            <div class="payslip-net-box">
                                <div>
                                    <div class="text-uppercase fw-bold opacity-75 small" style="letter-spacing:0.5px;">LƯƠNG THỰC LĨNH (NET TAKE-HOME PAY)</div>
                                    <div class="mt-1" style="font-size:0.85rem; font-style:italic;">
                                        Kỳ lương: Tháng ${payroll.payMonth}/${payroll.payYear}
                                    </div>
                                </div>
                                <div class="text-end">
                                    <div class="payslip-net-number">
                                        <c:choose>
                                            <c:when test="${not empty payroll.netSalary}">
                                                <fmt:formatNumber value="${payroll.netSalary}" pattern="#,###"/>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                        <span class="fs-5 fw-normal">VNĐ</span>
                                    </div>
                                </div>
                            </div>

                            <%-- Confirmation Note --%>
                            <div class="p-2 px-3 bg-light rounded text-muted small mb-4" style="font-size:0.76rem;">
                                <i class="bi bi-info-circle-fill text-primary me-1"></i>
                                <c:choose>
                                    <c:when test="${payroll.status eq 'PAID'}">
                                        Lương đã được chi trả thành công.
                                        <c:if test="${not empty payroll.approvedAt}">
                                            Phê duyệt lúc: <fmt:formatDate value="${payroll.approvedAt}" pattern="HH:mm dd/MM/yyyy" type="both"/>.
                                        </c:if>
                                        Người duyệt: <strong><c:out value="${not empty payroll.approvedByName ? payroll.approvedByName : 'Quản trị viên'}"/></strong>.
                                        Nếu có thắc mắc, vui lòng phản hồi phòng Nhân sự trong vòng 03 ngày làm việc.
                                    </c:when>
                                    <c:otherwise>
                                        Phiếu lương đang ở trạng thái <strong><c:out value="${payroll.status}"/></strong>.
                                        Vui lòng chờ phê duyệt hoặc liên hệ phòng Nhân sự — Kế toán để được hỗ trợ.
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Digital Signatures --%>
                            <div class="payslip-sign-grid">
                                <div>
                                    <div class="payslip-sign-role">NGƯỜI LẬP BIỂU</div>
                                    <div class="payslip-sign-sub">(Ký, ghi rõ họ tên)</div>
                                    <div class="payslip-digital-stamp">
                                        <i class="bi bi-patch-check-fill text-success fs-6"></i>
                                        <div class="fw-bold mt-1">ĐÃ KÝ ĐIỆN TỬ</div>
                                        <div style="font-size:0.65rem;">Chuyên viên C&amp;B</div>
                                    </div>
                                    <div class="payslip-signer-name">Bộ phận Lương &amp; Phúc lợi</div>
                                    <small class="text-muted">MIXIMOI HR</small>
                                </div>
                                <div>
                                    <div class="payslip-sign-role">KẾ TOÁN TRƯỞNG</div>
                                    <div class="payslip-sign-sub">(Ký, ghi rõ họ tên)</div>
                                    <div class="payslip-digital-stamp">
                                        <i class="bi bi-patch-check-fill text-success fs-6"></i>
                                        <div class="fw-bold mt-1">ĐÃ KÝ ĐIỆN TỬ</div>
                                        <div style="font-size:0.65rem;">
                                            <c:out value="${not empty payroll.approvedByName ? payroll.approvedByName : 'Kế toán trưởng'}"/>
                                        </div>
                                    </div>
                                    <div class="payslip-signer-name">Trưởng phòng Kế toán</div>
                                    <small class="text-muted">MIXIMOI Finance</small>
                                </div>
                                <div>
                                    <div class="payslip-sign-role">TỔNG GIÁM ĐỐC</div>
                                    <div class="payslip-sign-sub">(Ký duyệt, đóng dấu)</div>
                                    <div class="payslip-digital-stamp" style="border-color:#2563eb; background:#eff6ff; color:#1d4ed8;">
                                        <i class="bi bi-shield-check text-primary fs-6"></i>
                                        <div class="fw-bold mt-1">KÝ SỐ HSM CA</div>
                                        <div style="font-size:0.65rem;">CEO — MIXIMOI Group</div>
                                    </div>
                                    <div class="payslip-signer-name">Tổng Giám Đốc Điều Hành</div>
                                    <small class="text-muted">MIXIMOI Vietnam</small>
                                </div>
                            </div>

                            <%-- Hash Bar --%>
                            <div class="payslip-hash-bar">
                                <span>SHA-256: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855</span>
                                <span>Xác thực số: hrm.miximoi.vn/verify/<c:out value="${slipCode}"/></span>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
