<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Quản lý đặt vé - FUDA Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="fade-in admin-page">
    <jsp:include page="common/admin-header.jsp"></jsp:include>

    <main class="admin-shell">
        <section class="admin-hero">
            <div>
                <span class="admin-eyebrow"><i class="fas fa-ticket-alt"></i> Đơn đặt vé</span>
                <h1>Quản lý đơn đặt vé và thanh toán</h1>
                <p>Theo dõi trạng thái đơn, hành khách và hành trình khách đã chọn để nắm nhanh tình hình bán vé của hệ thống.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Về tổng quan</a>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-list"></i> Danh sách</span>
                    <h2>Tất cả đơn đặt vé</h2>
                    <p>${empty bookings ? 'Chưa có đơn đặt vé nào trong hệ thống.' : 'Theo dõi toàn bộ đơn đặt vé và trạng thái thanh toán hiện tại.'}</p>
                </div>
            </div>
            <div class="admin-panel-body">
                <div class="table-shell">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Khách hàng</th>
                                <th>Hành trình</th>
                                <th>Ngày đặt</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${bookings}" var="b">
                                <tr>
                                    <td>
                                        <span class="table-title mono">${not empty b.ticketCode ? b.ticketCode : b.bookingID}</span>
                                        <span class="table-subtitle">Đơn #${b.bookingID}</span>
                                    </td>
                                    <td>
                                        <span class="table-title">${empty b.user.fullName ? 'Khách vãng lai' : b.user.fullName}</span>
                                        <span class="table-subtitle">
                                            ${empty b.user.phoneNumber ? 'Chưa có số điện thoại' : b.user.phoneNumber}
                                            <c:if test="${b.totalPassengerCount > 0}">
                                                • ${b.totalPassengerCount} hành khách
                                            </c:if>
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty b.outboundSegment}">
                                                <span class="table-title">${b.outboundSegment.trip.route.origin} → ${b.outboundSegment.trip.route.destination}</span>
                                                <span class="table-subtitle">
                                                    <fmt:formatDate value="${b.outboundSegment.trip.departureTime}" pattern="dd/MM/yyyy HH:mm" />
                                                    <c:if test="${not empty b.returnSegment}">
                                                        • Khứ hồi
                                                    </c:if>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="table-title">${b.trip.route.origin} → ${b.trip.route.destination}</span>
                                                <span class="table-subtitle">
                                                    <fmt:formatDate value="${b.trip.departureTime}" pattern="dd/MM/yyyy HH:mm" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="table-title"><fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy" /></span>
                                        <span class="table-subtitle"><fmt:formatDate value="${b.bookingDate}" pattern="HH:mm" /></span>
                                    </td>
                                    <td>
                                        <span class="table-title"><fmt:formatNumber value="${b.totalPrice}" type="number" maxFractionDigits="0" /> đ</span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${b.status == 'Paid' ? 'status-paid' : (b.status == 'Cancelled' ? 'status-cancelled' : 'status-pending')}">
                                            <c:choose>
                                                <c:when test="${b.status == 'Paid'}">Đã thanh toán</c:when>
                                                <c:when test="${b.status == 'Cancelled'}">Đã hủy</c:when>
                                                <c:otherwise>Chờ thanh toán</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty bookings}">
                                <tr>
                                    <td colspan="6" class="empty-state">
                                        <i class="fas fa-receipt"></i>
                                        <div>Chưa có đơn đặt vé nào để hiển thị.</div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
