<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hợp Đồng Lao Động — ${contract.contractCode} — ${employee.fullName}</title>
    <meta name="description" content="Văn bản Hợp đồng lao động chính thức theo quy định Bộ luật Lao động Việt Nam — MIXIMOI HRM">
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/contract-print.css">
</head>
<body>

<!-- Floating Action Bar -->
<div class="floating-action-bar no-print">
    <a href="${pageContext.request.contextPath}/contracts" class="btn btn-sm btn-outline-secondary px-3" style="border-radius:20px;">
        <i class="bi bi-arrow-left me-1"></i> Quay lại
    </a>
    <button type="button" class="btn btn-sm btn-primary px-4 fw-bold" style="border-radius:20px; background:#2563eb;" onclick="window.print()">
        <i class="bi bi-printer me-1"></i> In hợp đồng (Ctrl+P)
    </button>
</div>

<div class="print-container">

    <!-- Header Quốc Hiệu -->
    <div class="contract-header-top">
        <div class="contract-country-title">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</div>
        <div class="contract-country-sub">Độc lập – Tự do – Hạnh phúc</div>
        <div class="contract-line"></div>
        <div class="contract-main-title">HỢP ĐỒNG LAO ĐỘNG</div>
        <div class="contract-code-display">Số: <strong>${contract.contractCode}</strong>/HĐLĐ-MIXIMOI</div>
    </div>

    <p class="contract-intro">
        Căn cứ Bộ luật Lao động số 45/2019/QH14 được Quốc hội nước Cộng hòa xã hội chủ nghĩa Việt Nam thông qua ngày 20 tháng 11 năm 2019;<br>
        Căn cứ nhu cầu sản xuất kinh doanh của Tập đoàn Công nghệ MIXIMOI và năng lực của người lao động;<br>
        Hôm nay, ngày ${contract.startDate}, tại trụ sở Công ty Cổ phần Tập đoàn MIXIMOI, hai bên gồm:
    </p>

    <!-- BÊN A -->
    <div class="contract-party-title">BÊN NGƯỜI SỬ DỤNG LAO ĐỘNG (BÊN A):</div>
    <div class="party-info-row">
        <div class="party-label">Tên doanh nghiệp:</div>
        <div class="party-val"><strong>CÔNG TY CỔ PHẦN TẬP ĐOÀN MIXIMOI</strong></div>
    </div>
    <div class="party-info-row">
        <div class="party-label">Mã số doanh nghiệp (MST):</div>
        <div class="party-val">0109887766 do Sở Kế hoạch và Đầu tư Hà Nội cấp</div>
    </div>
    <div class="party-info-row">
        <div class="party-label">Địa chỉ trụ sở chính:</div>
        <div class="party-val">Tầng 18, Tòa nhà MIXIMOI Tower, Q. Cầu Giấy, TP. Hà Nội</div>
    </div>
    <div class="party-info-row">
        <div class="party-label">Đại diện theo pháp luật:</div>
        <div class="party-val">Ông <strong>${not empty contract.signerName ? contract.signerName : 'Nguyễn Văn An'}</strong> — Chức vụ: ${not empty contract.signerTitle ? contract.signerTitle : 'Tổng Giám Đốc'}</div>
    </div>

    <!-- BÊN B -->
    <div class="contract-party-title" style="margin-top:1.5rem;">BÊN NGƯỜI LAO ĐỘNG (BÊN B):</div>
    <div class="party-info-row">
        <div class="party-label">Họ và tên người lao động:</div>
        <div class="party-val"><strong>${employee.fullName}</strong></div>
    </div>
    <div class="party-info-row">
        <div class="party-label">Mã nhân sự:</div>
        <div class="party-val"><strong>${employee.employeeCode}</strong></div>
    </div>
    <div class="party-info-row">
        <div class="party-label">Số CCCD / Hộ chiếu:</div>
        <div class="party-val">
            <c:choose>
                <c:when test="${not empty contract.identityNumber}"><c:out value="${contract.identityNumber}"/></c:when>
                <c:when test="${not empty employee.identityNumber}"><c:out value="${employee.identityNumber}"/></c:when>
                <c:otherwise>Theo hồ sơ nhân sự</c:otherwise>
            </c:choose>
            &nbsp;&nbsp;&nbsp;&nbsp; Ngày cấp: 
            <c:choose>
                <c:when test="${not empty contract.identityDate}"><c:out value="${contract.identityDate}"/></c:when>
                <c:when test="${not empty employee.identityIssueDate}"><c:out value="${employee.identityIssueDate}"/></c:when>
                <c:otherwise>Theo hồ sơ gốc</c:otherwise>
            </c:choose>
            &nbsp;&nbsp;&nbsp;&nbsp; Nơi cấp: 
            <c:choose>
                <c:when test="${not empty contract.identityPlace}"><c:out value="${contract.identityPlace}"/></c:when>
                <c:when test="${not empty employee.identityIssuePlace}"><c:out value="${employee.identityIssuePlace}"/></c:when>
                <c:otherwise>Cục Cảnh sát QLHC về TTXH</c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="party-info-row">
        <div class="party-label">Ngày sinh:</div>
        <div class="party-val">${employee.dateOfBirth != null ? employee.dateOfBirth : 'Theo hồ sơ nhân sự'} &nbsp;&nbsp;&nbsp;&nbsp; Giới tính: ${employee.gender eq 'MALE' ? 'Nam' : employee.gender eq 'FEMALE' ? 'Nữ' : 'Khác'}</div>
    </div>
    <div class="party-info-row">
        <div class="party-label">Số điện thoại liên hệ:</div>
        <div class="party-val">${employee.phone != null ? employee.phone : '—'} &nbsp;&nbsp;&nbsp;&nbsp; Email: ${not empty employee.email ? employee.email : '—'}</div>
    </div>
    <div class="party-info-row">
        <div class="party-label">Địa chỉ thường trú / cư trú:</div>
        <div class="party-val">${not empty employee.address ? employee.address : 'Theo hồ sơ lưu trữ'}</div>
    </div>

    <p class="contract-intro" style="margin-top:1rem;">
        Hai bên cùng nhau thỏa thuận ký kết hợp đồng lao động và cam kết làm đúng những điều khoản sau đây:
    </p>

    <!-- ĐIỀU 1 -->
    <div class="article-title">Điều 1: Thời hạn và công việc hợp đồng</div>
    <div class="article-content">
        1. <strong>Loại hợp đồng:</strong> 
        <c:choose>
            <c:when test="${contract.contractType eq 'INDEFINITE'}">Hợp đồng lao động không xác định thời hạn.</c:when>
            <c:when test="${contract.contractType eq 'FIXED_TERM'}">Hợp đồng lao động xác định thời hạn.</c:when>
            <c:when test="${contract.contractType eq 'SEASONAL'}">Hợp đồng lao động theo mùa vụ / thời vụ.</c:when>
            <c:otherwise>Hợp đồng cộng tác viên chuyên môn.</c:otherwise>
        </c:choose>
    </div>
    <div class="article-content">
        2. <strong>Thời hạn hợp đồng:</strong> Từ ngày <strong>${contract.startDate}</strong> 
        <c:choose>
            <c:when test="${not empty contract.endDate}">đến ngày <strong>${contract.endDate}</strong>.</c:when>
            <c:otherwise>cho đến khi hai bên có thỏa thuận chấm dứt theo quy định pháp luật.</c:otherwise>
        </c:choose>
    </div>
    <div class="article-content">
        3. <strong>Địa điểm làm việc:</strong> ${not empty contract.workLocation ? contract.workLocation : 'Trụ sở Công ty Cổ phần Tập đoàn MIXIMOI (Landmark 81, TP.HCM / MIXIMOI Tower Hà Nội) và các chi nhánh theo điều động.'}
    </div>
    <div class="article-content">
        4. <strong>Chức vụ / Vị trí chuyên môn:</strong> <strong>${employee.positionName != null ? employee.positionName : 'Chuyên viên'}</strong> thuộc <strong>${contract.departmentName != null ? contract.departmentName : employee.departmentName}</strong>.
    </div>
    <c:if test="${not empty contract.probationMonths and contract.probationMonths > 0}">
    <div class="article-content">
        5. <strong>Thời gian thử việc:</strong> <strong>${contract.probationMonths} tháng</strong>, hưởng mức lương thử việc bằng <strong>${not empty contract.probationSalaryPct ? contract.probationSalaryPct : '85'}%</strong> mức lương chính thỏa thuận.
    </div>
    </c:if>

    <!-- ĐIỀU 2 -->
    <div class="article-title">Điều 2: Chế độ làm việc</div>
    <div class="article-content">
        1. <strong>Thời gian làm việc:</strong> 08 giờ/ngày (từ 08h30 đến 17h30, nghỉ trưa từ 12h00 đến 13h00), 40 giờ/tuần từ thứ Hai đến thứ Sáu (Nghỉ thứ Bảy và Chủ Nhật).
    </div>
    <div class="article-content">
        2. Do tính chất công việc hoặc yêu cầu tiến độ dự án, Bên A có thể yêu cầu Bên B làm thêm giờ theo đúng trình tự và quy định chi trả tiền làm thêm giờ (150%, 200%, 300%) của Bộ luật Lao động.
    </div>

    <!-- ĐIỀU 3 -->
    <div class="article-title">Điều 3: Tiền lương, phụ cấp và các quyền lợi</div>
    <div class="article-content">
        1. <strong>Mức lương chính (lương cơ bản):</strong> 
        <strong style="color:#0f172a; font-size:1.05rem;">
            <fmt:formatNumber value="${contract.baseSalary}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/> / tháng.
        </strong>
    </div>
    <c:if test="${not empty contract.allowanceAmount and contract.allowanceAmount > 0}">
    <div class="article-content">
        2. <strong>Các khoản phụ cấp cố định:</strong> 
        <strong><fmt:formatNumber value="${contract.allowanceAmount}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/> / tháng</strong> (Hỗ trợ ăn trưa, xăng xe, liên lạc công vụ).
    </div>
    </c:if>
    <div class="article-content">
        3. <strong>Hình thức chi trả:</strong> Chuyển khoản qua tài khoản ngân hàng cá nhân vào ngày 05 hàng tháng.
    </div>
    <div class="article-content">
        4. <strong>Tiền thưởng và phụ cấp:</strong> Theo kết quả đánh giá hiệu suất KPIs và Quy chế tài chính nội bộ của Tập đoàn.
    </div>
    <div class="article-content">
        5. <strong>Chế độ bảo hiểm:</strong> Bên A đóng đầy đủ Bảo hiểm xã hội (BHXH), Bảo hiểm y tế (BHYT), Bảo hiểm thất nghiệp (BHTN) cho Bên B theo mức lương hợp đồng và quy định pháp luật.
    </div>
    <div class="article-content">
        6. <strong>Nghỉ ngơi:</strong> Bên B được hưởng 12 ngày nghỉ phép năm hưởng nguyên lương cùng chế độ nghỉ lễ, Tết theo quy định Bộ luật Lao động 2019.
    </div>

    <!-- ĐIỀU 4 -->
    <div class="article-title">Điều 4: Nghĩa vụ và quyền hạn mỗi bên</div>
    <div class="article-content">
        1. Bên B có nghĩa vụ chấp hành nghiêm túc Nội quy lao động, Bảo mật thông tin kinh doanh công nghệ, Quy chế văn hóa doanh nghiệp MIXIMOI.
    </div>
    <div class="article-content">
        2. Bên A bảo đảm quyền lợi hợp pháp của Bên B, thanh toán lương đúng hạn và trang bị điều kiện làm việc tiêu chuẩn hiện đại.
    </div>

    <!-- ĐIỀU 5 -->
    <div class="article-title">Điều 5: Điều khoản thi hành</div>
    <div class="article-content">
        Hợp đồng này được lập thành 02 (hai) bản có giá trị pháp lý như nhau, mỗi bên giữ 01 bản để thực hiện. Có hiệu lực kể từ ngày hai bên ký kết.
    </div>

    <!-- CHỮ KÝ -->
    <div class="signature-grid">
        <div>
            <div class="sig-role">NGƯỜI LAO ĐỘNG</div>
            <div class="sig-sub">(Ký, ghi rõ họ tên)</div>
            <div class="sig-name">${employee.fullName}</div>
        </div>
        <div>
            <div class="sig-role">ĐẠI DIỆN NGƯỜI SỬ DỤNG LAO ĐỘNG</div>
            <div class="sig-sub">(Ký tên, đóng dấu)</div>
            <div class="sig-name">${not empty contract.signerTitle ? contract.signerTitle.toUpperCase() : 'TỔNG GIÁM ĐỐC'} — ${not empty contract.signerName ? contract.signerName.toUpperCase() : 'NGUYỄN VĂN AN'}</div>
        </div>
    </div>

</div>

</body>
</html>
