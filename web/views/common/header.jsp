<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <header class="main-header">
            <div class="container header-content">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <i class="fas fa-bus-alt"></i> FUDA Bus
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
                    <a href="${pageContext.request.contextPath}/search">Đặt Vé</a>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/history">Vé Của Tôi</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/support">Hỗ Trợ</a>
                </nav>
                <div class="auth-buttons">
                    <c:if test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Đăng Nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary"
                            style="margin-left: 10px;">Đăng Ký</a>
                    </c:if>
                    <c:if test="${not empty sessionScope.user}">
                        <span style="font-size: 14px; margin-right: 15px; color: var(--text-secondary);">Hi,
                            <b>${sessionScope.user.fullName}</b></span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary"
                            style="padding: 8px 16px; font-size: 13px;">Đăng Xuất</a>
                    </c:if>
                </div>
            </div>
        </header>
        