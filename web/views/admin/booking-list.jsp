<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <jsp:include page="../common/head.jsp"></jsp:include>
                <title>Manage Bookings - Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
            </head>

            <body class="fade-in" style="background: #fbfbfd;">

                <nav class="main-header" style="background: white; position: sticky; top: 0; z-index: 100;">
                    <div class="container header-content">
                        <a href="${pageContext.request.contextPath}/admin" class="logo">BusTicket Admin</a>
                        <div class="auth-buttons">
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">Logout</a>
                        </div>
                    </div>
                </nav>

                <div class="container" style="padding-top: 40px;">
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                        <h2>All Bookings</h2>
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">&larr; Back to
                            Dashboard</a>
                    </div>

                    <div
                        style="background: white; border-radius: 20px; box-shadow: var(--shadow-sm); overflow: hidden;">
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead style="background: #f5f5f7; border-bottom: 1px solid #e1e1e1;">
                                <tr>
                                    <th
                                        style="padding: 15px 20px; text-align: left; font-size: 14px; color: var(--text-secondary);">
                                        ID / Ticket Code</th>
                                    <th
                                        style="padding: 15px 20px; text-align: left; font-size: 14px; color: var(--text-secondary);">
                                        Customer</th>
                                    <th
                                        style="padding: 15px 20px; text-align: left; font-size: 14px; color: var(--text-secondary);">
                                        Trip</th>
                                    <th
                                        style="padding: 15px 20px; text-align: left; font-size: 14px; color: var(--text-secondary);">
                                        Date</th>
                                    <th
                                        style="padding: 15px 20px; text-align: left; font-size: 14px; color: var(--text-secondary);">
                                        Total</th>
                                    <th
                                        style="padding: 15px 20px; text-align: left; font-size: 14px; color: var(--text-secondary);">
                                        Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${bookings}" var="b">
                                    <tr style="border-bottom: 1px solid #f0f0f0;">
                                        <td style="padding: 15px 20px; font-weight: 500;">
                                            <div style="font-family: monospace;">${not empty b.ticketCode ? b.ticketCode
                                                : b.bookingID}</div>
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <div style="font-weight: 500;">${b.user.fullName}</div>
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <div>${b.trip.route.origin} &rarr; ${b.trip.route.destination}</div>
                                            <div
                                                style="font-size: 13px; color: var(--text-secondary); margin-top: 4px;">
                                                <fmt:formatDate value="${b.trip.departureTime}"
                                                    pattern="dd/MM/yyyy HH:mm" />
                                            </div>
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <fmt:formatDate value="${b.bookingDate}" pattern="dd MMM, HH:mm" />
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <fmt:formatNumber value="${b.totalPrice}" type="number"
                                                maxFractionDigits="0" /> VNĐ
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <span
                                                style="display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 500;
                                      background: ${b.status == 'Paid' ? '#d4edda' : (b.status == 'Cancelled' ? '#f8d7da' : '#fff3cd')};
                                      color: ${b.status == 'Paid' ? '#155724' : (b.status == 'Cancelled' ? '#721c24' : '#856404')};">
                                                ${b.status}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty bookings}">
                                    <tr>
                                        <td colspan="6"
                                            style="padding: 40px; text-align: center; color: var(--text-secondary);">
                                            No bookings found.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </body>

            </html>