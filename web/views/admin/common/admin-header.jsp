<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="adminPath" value="${pageContext.request.requestURI}" />

<header class="admin-topbar">
    <div class="container">
        <a href="${pageContext.request.contextPath}/admin" class="admin-brand">
            <span class="admin-brand-mark">
                <i class="fas fa-chart-pie"></i>
            </span>
            <span class="admin-brand-copy">
                <strong>FUDA Admin</strong>
                <span>Điều phối xe, tuyến và đơn đặt vé</span>
            </span>
        </a>

        <div class="admin-topbar-actions">
            <span class="admin-user-chip">
                <i class="fas fa-user-shield"></i>
                <span>${empty sessionScope.user.fullName ? sessionScope.user.username : sessionScope.user.fullName}</span>
            </span>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Trang khách</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">Đăng xuất</a>
        </div>
    </div>
</header>

<nav class="admin-tabs">
    <div class="container">
        <a href="${pageContext.request.contextPath}/admin" class="admin-nav-link ${fn:endsWith(adminPath, '/admin') ? 'is-active' : ''}">
            <i class="fas fa-table-columns"></i>
            <span>Tổng quan</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/buses" class="admin-nav-link ${fn:contains(adminPath, '/admin/buses') || fn:contains(adminPath, '/admin/bus/') ? 'is-active' : ''}">
            <i class="fas fa-bus"></i>
            <span>Xe</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/routes" class="admin-nav-link ${fn:contains(adminPath, '/admin/routes') || fn:contains(adminPath, '/admin/route/') ? 'is-active' : ''}">
            <i class="fas fa-route"></i>
            <span>Tuyến</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/trips" class="admin-nav-link ${fn:contains(adminPath, '/admin/trips') || fn:contains(adminPath, '/admin/trip/') ? 'is-active' : ''}">
            <i class="fas fa-calendar-check"></i>
            <span>Chuyến</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="admin-nav-link ${fn:contains(adminPath, '/admin/bookings') ? 'is-active' : ''}">
            <i class="fas fa-ticket-alt"></i>
            <span>Đặt vé</span>
        </a>
    </div>
</nav>
