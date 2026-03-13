<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <header class="main-header">
            <div class="container header-content">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <i class="fas fa-bus-alt"></i> Vivu
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/">Home</a>
                    <a href="${pageContext.request.contextPath}/search">Book Tickets</a>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/history">My Bookings</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/support">Support</a>
                </nav>
                <div class="auth-buttons">
                    <c:if test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Log in</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary"
                            style="margin-left: 10px;">Sign up</a>
                    </c:if>
                    <c:if test="${not empty sessionScope.user}">
                        <span style="font-size: 14px; margin-right: 15px; color: var(--text-secondary);">Hi,
                            <b>${sessionScope.user.fullName}</b></span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary"
                            style="padding: 8px 16px; font-size: 13px;">Logout</a>
                    </c:if>
                </div>
            </div>
        </header>
        </header>
        <!-- FontAwesome Integration for Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Favicon -->
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png?v=2">