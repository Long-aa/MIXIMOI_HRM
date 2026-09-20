<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty department or empty department.id or department.id == 0 ? 'Thêm phòng ban mới' : 'Chỉnh sửa phòng ban'} — MIXIMOI HRM</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/department.css">
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="departments" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>
        <div class="app-content">

            <%-- ===== PAGE HEADER ===== --%>
            <div class="dept-form-header">
                <div>
                    <h1 class="dept-form-title">
                        <i class="bi ${empty department or empty department.id or department.id == 0 ? 'bi-building-add' : 'bi-building-gear'} text-primary"></i>
                        ${empty department or empty department.id or department.id == 0 ? 'Thêm phòng ban mới' : 'Chỉnh sửa thông tin phòng ban'}
                    </h1>
                    <p class="dept-form-subtitle">
                        ${empty department or empty department.id or department.id == 0
                            ? 'Khai báo phòng ban mới vào cơ cấu tổ chức công ty'
                            : 'Cập nhật thông tin và cấu hình phòng ban trong hệ thống'}
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/departments" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/departments"
                  class="needs-validation" novalidate id="deptForm">
                <input type="hidden" name="action" value="${empty department or empty department.id or department.id == 0 ? 'add' : 'update'}">
                <c:if test="${not empty department and department.id > 0}">
                    <input type="hidden" name="id" value="${department.id}">
                </c:if>
                <input type="hidden" id="deptColorValue" name="color" value="#2563eb">

                <div class="dept-form-layout">
                    <%-- ===== LEFT PANEL: PREVIEW & INFO ===== --%>
                    <div class="dept-form-left-panel">
                        <%-- Identity Preview Card --%>
                        <div class="dept-identity-card">
                            <div class="dept-avatar-ring" id="deptAvatarPreview">
                                <c:choose>
                                    <c:when test="${not empty department and not empty department.name}">
                                        <c:out value="${fn:toUpperCase(fn:substring(department.name,0,2))}"/>
                                    </c:when>
                                    <c:otherwise>PB</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="dept-id-name" id="deptNamePreview">
                                <c:choose>
                                    <c:when test="${not empty department and not empty department.name}"><c:out value="${department.name}"/></c:when>
                                    <c:otherwise>Tên phòng ban</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="dept-id-code">
                                <c:choose>
                                    <c:when test="${not empty department and not empty department.code}"><c:out value="${department.code}"/></c:when>
                                    <c:when test="${not empty department and department.id > 0}">PB-${department.id < 10 ? '0' : ''}${department.id}</c:when>
                                    <c:otherwise>PB-MỚI</c:otherwise>
                                </c:choose>
                            </div>
                            <div><span class="dept-id-badge"><span class="dept-id-badge-dot"></span>Hoạt động</span></div>
                        </div>

                        <%-- System Info Card --%>
                        <div class="dept-info-card">
                            <div class="dept-info-card-title">
                                <i class="bi bi-info-circle"></i> Thông tin hệ thống
                            </div>
                            <div class="dept-info-row">
                                <div class="dept-info-icon"><i class="bi bi-calendar3"></i></div>
                                <div>
                                    <div class="dept-info-label">Ngày tạo</div>
                                    <div class="dept-info-value">
                                        <c:choose>
                                            <c:when test="${not empty department and not empty department.createdAt}">
                                                <fmt:formatDate value="${department.createdAt}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:when test="${not empty department and department.id > 0}">Đã có trong hệ thống</c:when>
                                            <c:otherwise>Hôm nay</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <div class="dept-info-row">
                                <div class="dept-info-icon"><i class="bi bi-person-gear"></i></div>
                                <div>
                                    <div class="dept-info-label">Người thực hiện</div>
                                    <div class="dept-info-value">${sessionScope.currentUser.fullName}</div>
                                </div>
                            </div>
                            <div class="dept-info-row">
                                <div class="dept-info-icon"><i class="bi bi-shield-check"></i></div>
                                <div>
                                    <div class="dept-info-label">Trạng thái mặc định</div>
                                    <div class="dept-info-value" style="color:#16a34a;font-weight:600">Hoạt động</div>
                                </div>
                            </div>
                            <div class="dept-info-row">
                                <div class="dept-info-icon"><i class="bi bi-people"></i></div>
                                <div>
                                    <div class="dept-info-label">Nhân viên hiện tại</div>
                                    <div class="dept-info-value">
                                        <c:choose>
                                            <c:when test="${not empty department and department.id > 0}">${department.employeeCount} người</c:when>
                                            <c:otherwise>0 người</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Guide Card --%>
                        <div class="dept-guide-card">
                            <div class="dept-guide-title">
                                <i class="bi bi-lightbulb-fill"></i> Hướng dẫn nhanh
                            </div>
                            <div class="dept-guide-item">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>Tên phòng ban phải rõ ràng, phản ánh đúng chức năng</span>
                            </div>
                            <div class="dept-guide-item">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>Mô tả nên nêu rõ nhiệm vụ và phạm vi hoạt động</span>
                            </div>
                            <div class="dept-guide-item">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>Có thể chỉnh sửa thông tin sau khi tạo thành công</span>
                            </div>
                            <div class="dept-guide-item">
                                <i class="bi bi-info-circle-fill" style="color:#d97706"></i>
                                <span>Phòng ban đã có nhân viên sẽ không thể xóa</span>
                            </div>
                        </div>
                    </div>

                    <%-- ===== RIGHT PANEL: FORM ===== --%>
                    <div class="dept-form-card">
                        <%-- Thông tin phòng ban --%>
                        <div class="dept-form-section">
                            <div class="dept-form-section-header">
                                <div class="dept-form-section-icon">
                                    <i class="bi bi-building"></i>
                                </div>
                                <div>
                                    <div class="dept-form-section-title">Thông tin phòng ban</div>
                                    <div class="dept-form-section-desc">Khai báo định danh và chức năng nhiệm vụ của phòng ban</div>
                                </div>
                            </div>

                            <p class="req-note">Các trường có dấu <span>*</span> là bắt buộc</p>

                            <%-- Tên phòng ban --%>
                            <div class="dept-form-field">
                                <label class="dept-form-label" for="deptName">
                                    Tên phòng ban <span class="req">*</span>
                                    <span class="hint">Tiếng Việt có dấu, rõ ràng</span>
                                </label>
                                <input type="text" class="dept-form-input" id="deptName" name="name"
                                       required maxlength="120"
                                       placeholder="VD: Phòng Nghiên cứu &amp; Phát triển"
                                       value="<c:out value='${department.name}'/>"
                                       oninput="updatePreview(this)">
                                <div class="dept-input-counter">
                                    <span class="dept-input-hint">Đặt tên theo chuẩn: [Chức năng chính] hoặc [Phòng + Tên]</span>
                                    <span class="dept-char-counter" id="nameCounter">0 / 120</span>
                                </div>
                                <div class="dept-invalid-feedback">Vui lòng nhập tên phòng ban.</div>
                            </div>

                            <%-- Mô tả --%>
                            <div class="dept-form-field">
                                <label class="dept-form-label" for="deptDesc">
                                    Mô tả chức năng &amp; nhiệm vụ
                                    <span class="hint">Không bắt buộc</span>
                                </label>
                                <textarea class="dept-form-textarea" id="deptDesc" name="description"
                                          rows="5" maxlength="500"
                                          placeholder="Mô tả tóm tắt vai trò, phạm vi phụ trách và chức năng của bộ phận này trong công ty..."
                                          oninput="updateDescCounter(this)"><c:out value="${department.description}"/></textarea>
                                <div class="dept-input-counter">
                                    <span class="dept-input-hint">Mô tả cụ thể giúp nhân viên mới hiểu rõ phạm vi công việc</span>
                                    <span class="dept-char-counter" id="descCounter">0 / 500</span>
                                </div>
                            </div>
                        </div>

                        <hr class="dept-form-divider">

                        <%-- Cấu hình bổ sung --%>
                        <div class="dept-form-section">
                            <div class="dept-form-section-header">
                                <div class="dept-form-section-icon" style="background:#f0fdf4;color:#16a34a">
                                    <i class="bi bi-gear"></i>
                                </div>
                                <div>
                                    <div class="dept-form-section-title">Cấu hình bổ sung</div>
                                    <div class="dept-form-section-desc">Màu sắc nhận diện và tên viết tắt (không bắt buộc)</div>
                                </div>
                            </div>

                            <%-- Màu sắc --%>
                            <div class="dept-form-field">
                                <label class="dept-form-label">Màu sắc nhận diện phòng ban</label>
                                <div class="dept-color-picker" id="colorPicker">
                                    <div class="dept-color-dot selected" style="background:#2563eb" data-color="#2563eb" onclick="selectColor(this)" title="Xanh dương"></div>
                                    <div class="dept-color-dot" style="background:#16a34a" data-color="#16a34a" onclick="selectColor(this)" title="Xanh lá"></div>
                                    <div class="dept-color-dot" style="background:#7c3aed" data-color="#7c3aed" onclick="selectColor(this)" title="Tím"></div>
                                    <div class="dept-color-dot" style="background:#d97706" data-color="#d97706" onclick="selectColor(this)" title="Cam vàng"></div>
                                    <div class="dept-color-dot" style="background:#dc2626" data-color="#dc2626" onclick="selectColor(this)" title="Đỏ"></div>
                                    <div class="dept-color-dot" style="background:#0891b2" data-color="#0891b2" onclick="selectColor(this)" title="Xanh biển"></div>
                                    <div class="dept-color-dot" style="background:#9d174d" data-color="#9d174d" onclick="selectColor(this)" title="Hồng đậm"></div>
                                    <div class="dept-color-dot" style="background:#374151" data-color="#374151" onclick="selectColor(this)" title="Xám tối"></div>
                                </div>
                                <div style="font-size:0.72rem;color:#6b7280;margin-top:6px">Màu sắc này sẽ hiển thị trong sơ đồ tổ chức và lịch</div>
                            </div>

                            <%-- Tên viết tắt --%>
                            <div class="dept-form-field">
                                <label class="dept-form-label" for="deptAlias">
                                    Mã phòng ban / Tên viết tắt
                                    <span class="hint">VD: R&amp;D, IT, HR, Sales, BGD</span>
                                </label>
                                <input type="text" class="dept-form-input" id="deptAlias" name="alias"
                                       maxlength="20" placeholder="VD: R&D, KD, TECH, HR..."
                                       value="<c:out value='${department.code}'/>"
                                       style="width:240px">
                            </div>
                        </div>

                        <%-- Action Bar --%>
                        <div class="dept-form-action-bar">
                            <a href="${pageContext.request.contextPath}/departments" class="btn-cancel-form">
                                <i class="bi bi-x-lg"></i> Hủy bỏ
                            </a>
                            <button type="submit" class="btn-submit-form" id="btnSubmitDept">
                                <i class="bi bi-check2-circle"></i>
                                ${empty department or empty department.id or department.id == 0 ? 'Tạo phòng ban' : 'Lưu thay đổi'}
                            </button>
                        </div>
                    </div>
                </div>
            </form>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/department.js"></script>
</body>
</html>
