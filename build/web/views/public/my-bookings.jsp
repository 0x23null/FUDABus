<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>My Bookings - Vivu</title>
                <link rel="stylesheet" href="assets/css/style.css">
                <style>
                    .page-title-section {
                        background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                        padding: 40px 0;
                        margin-bottom: 40px;
                        border-bottom: 1px solid var(--border-color);
                    }

                    .booking-card {
                        background: white;
                        border-radius: 20px;
                        border: 1px solid var(--border-color);
                        padding: 0;
                        margin-bottom: 24px;
                        transition: all 0.3s;
                        overflow: hidden;
                        display: flex;
                        flex-direction: column;
                    }

                    .booking-card:hover {
                        transform: translateY(-4px);
                        box-shadow: var(--shadow-lg);
                        border-color: var(--primary-light);
                    }

                    .card-header {
                        background: #f8fafc;
                        padding: 16px 24px;
                        border-bottom: 1px solid var(--border-color);
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .card-body {
                        padding: 24px;
                        display: grid;
                        grid-template-columns: 2fr 1fr;
                        gap: 24px;
                    }

                    .route-visual {
                        display: flex;
                        align-items: center;
                        gap: 20px;
                        margin-bottom: 12px;
                    }

                    .city-name {
                        font-size: 20px;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .route-arrow {
                        color: var(--text-secondary);
                        font-size: 16px;
                    }

                    .trip-meta {
                        display: flex;
                        gap: 20px;
                        color: var(--text-secondary);
                        font-size: 14px;
                        margin-top: 8px;
                    }

                    .meta-item {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .price-section {
                        text-align: right;
                        display: flex;
                        flex-direction: column;
                        justify-content: center;
                        align-items: flex-end;
                        padding-left: 24px;
                        border-left: 1px dashed var(--border-color);
                    }

                    .total-price {
                        font-size: 24px;
                        font-weight: 700;
                        color: var(--primary-color);
                        margin-bottom: 12px;
                    }

                    .status-badge {
                        padding: 6px 14px;
                        border-radius: 99px;
                        font-size: 13px;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .status-Paid {
                        background: #dcfce7;
                        color: #166534;
                    }

                    .status-Pending {
                        background: #fef9c3;
                        color: #854d0e;
                    }

                    .status-Cancelled {
                        background: #fee2e2;
                        color: #991b1b;
                    }

                    @media (max-width: 768px) {
                        .card-body {
                            grid-template-columns: 1fr;
                        }

                        .price-section {
                            border-left: none;
                            border-top: 1px dashed var(--border-color);
                            padding-left: 0;
                            padding-top: 20px;
                            align-items: flex-start;
                            flex-direction: row;
                            justify-content: space-between;
                        }
                    }
                </style>
            </head>

            <body class="fade-in">
                <jsp:include page="../common/header.jsp" />

                <div class="page-title-section">
                    <div class="container">
                        <h1 style="font-size: 32px; margin-bottom: 8px;">My Journeys</h1>
                        <p style="color: var(--text-secondary);">Manage your bookings and view your e-tickets.</p>
                    </div>
                </div>

                <div class="container" style="min-height: 60vh;">
                    <c:if test="${empty bookings}">
                        <div class="glass-panel"
                            style="text-align: center; padding: 60px 20px; max-width: 600px; margin: 40px auto;">
                            <div style="font-size: 60px; color: #cbd5e1; margin-bottom: 24px;">
                                <i class="fas fa-ticket-alt"></i>
                            </div>
                            <h3 style="margin-bottom: 12px;">No trips booked yet</h3>
                            <p style="color: var(--text-secondary); margin-bottom: 30px;">Ready to explore new
                                destinations? Start your journey with Vivu today.</p>
                            <a href="search" class="btn btn-primary">Find a Trip</a>
                        </div>
                    </c:if>

                    <c:forEach items="${bookings}" var="b">
                        <div class="booking-card">
                            <div class="card-header">
                                <div style="font-family: monospace; font-weight: 600; color: var(--text-secondary);">
                                    <i class="fas fa-hashtag"></i> ${b.bookingID}
                                </div>
                                <span class="status-badge status-${b.status}">${b.status}</span>
                            </div>

                            <div class="card-body">
                                <div>
                                    <div class="route-visual">
                                        <span class="city-name">${b.trip.route.origin}</span>
                                        <i class="fas fa-long-arrow-alt-right route-arrow"></i>
                                        <span class="city-name">${b.trip.route.destination}</span>
                                    </div>

                                    <div class="trip-meta">
                                        <div class="meta-item">
                                            <i class="far fa-calendar"></i>
                                            <fmt:formatDate value="${b.trip.departureTime}" pattern="dd MMM yyyy" />
                                        </div>
                                        <div class="meta-item">
                                            <i class="far fa-clock"></i>
                                            <fmt:formatDate value="${b.trip.departureTime}" pattern="HH:mm" />
                                        </div>
                                        <div class="meta-item">
                                            <i class="fas fa-bus"></i>
                                            ${b.trip.bus.busType}
                                        </div>
                                    </div>

                                    <div style="margin-top: 16px; font-size: 14px; color: var(--text-secondary);">
                                        <span style="font-weight: 500; color: var(--text-primary);">Ticket Code:</span>
                                        <span
                                            style="font-family: monospace; background: #f1f5f9; padding: 2px 6px; border-radius: 4px;">
                                            ${not empty b.ticketCode ? b.ticketCode : 'Generating...'}
                                        </span>
                                    </div>
                                </div>

                                <div class="price-section">
                                    <div class="total-price">
                                        <fmt:formatNumber value="${b.totalPrice}" type="number" maxFractionDigits="0" />
                                        VNĐ
                                    </div>

                                    <div style="display: flex; gap: 10px;">
                                        <c:if test="${b.status == 'Pending'}">
                                            <a href="payment?bookingID=${b.bookingID}" class="btn btn-primary">
                                                Continue Payment <i class="fas fa-arrow-right"
                                                    style="font-size: 12px;"></i>
                                            </a>
                                        </c:if>

                                        <c:if test="${b.status == 'Paid'}">
                                            <a href="ticket?id=${b.bookingID}" class="btn btn-secondary">
                                                <i class="fas fa-file-pdf"></i> View E-Ticket
                                            </a>
                                        </c:if>

                                        <c:if test="${b.status == 'Cancelled'}">
                                            <button disabled class="btn btn-secondary"
                                                style="opacity: 0.6; cursor: not-allowed;">Cancelled</button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <jsp:include page="../common/footer.jsp" />
            </body>

            </html>