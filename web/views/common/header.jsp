<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="main-header">
    <div class="container header-content">
        <a href="${pageContext.request.contextPath}/" class="logo">
            <i class="fas fa-bus-alt"></i> FUDA Bus
        </a>

        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/#search-form">Đặt vé</a>
            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/history">Vé của tôi</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/support">Hỗ trợ</a>
        </nav>

        <div class="auth-buttons" style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
            </c:if>
            <c:if test="${not empty sessionScope.user}">
                <span style="font-size: 14px; color: var(--text-secondary);">Xin chào, <b>${sessionScope.user.fullName}</b></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 16px; font-size: 13px;">Đăng xuất</a>
            </c:if>
        </div>
    </div>
</header>
