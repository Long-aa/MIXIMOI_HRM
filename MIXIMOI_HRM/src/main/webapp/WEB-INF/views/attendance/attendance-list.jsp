<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý chấm công — MIXIMOI HRM &amp; PAYROLL</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/attendance.css?v=2.1">
</head>
<body>

<div class="app-container">
    <c:set var="activeMenu" value="attendance" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>

        <div class="app-content">

            <%-- ============================================================
                 1. EMPLOYEE ROLE: Chấm công cá nhân + Live Clock + Heatmap
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.employee and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr and not sessionScope.currentUser.manager and not sessionScope.currentUser.accountant}">
                <jsp:include page="/WEB-INF/views/attendance/partials/employee-view.jsp"/>
            </c:if>

            <%-- ============================================================
                 2. ACCOUNTANT ROLE: Bảng tổng hợp công tháng (Read-only)
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.accountant and not sessionScope.currentUser.admin}">
                <jsp:include page="/WEB-INF/views/attendance/partials/accountant-view.jsp"/>
            </c:if>

            <%-- ============================================================
                 3. MANAGER ROLE: Giám sát hiện diện phòng ban + Duyệt giải trình
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.manager and not sessionScope.currentUser.admin and not sessionScope.currentUser.hr}">
                <jsp:include page="/WEB-INF/views/attendance/partials/manager-view.jsp"/>
            </c:if>

            <%-- ============================================================
                 4. ADMIN / HR ROLE: Toàn quyền quản trị chấm công
                 ============================================================ --%>
            <c:if test="${sessionScope.currentUser.admin or sessionScope.currentUser.hr}">
                <jsp:include page="/WEB-INF/views/attendance/partials/admin-view.jsp"/>
            </c:if>

        </div><!-- end app-content -->
    </main>
</div>

<%-- ============================================================
     MODALS MODULARIZATION
     ============================================================ --%>
<jsp:include page="/WEB-INF/views/attendance/modals/manual-checkin-modal.jsp"/>
<jsp:include page="/WEB-INF/views/attendance/modals/edit-attendance-modal.jsp"/>
<jsp:include page="/WEB-INF/views/attendance/modals/explain-modal.jsp"/>
<jsp:include page="/WEB-INF/views/attendance/modals/history-modal.jsp"/>
<jsp:include page="/WEB-INF/views/attendance/modals/faceid-scanner-modal.jsp"/>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- Attendance Unified Scripts -->
<script src="${pageContext.request.contextPath}/assets/js/attendance.js?v=2.1"></script>

</body>
</html>
