<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Vé của tôi - FUDA Bus</title>
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
            gap: 12px;
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
            flex-wrap: wrap;
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

        .trip-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 999px;
            background: #eff6ff;
            color: var(--primary-dark);
            font-size: 12px;
            font-weight: 700;
        }

        .trip-meta {
            display: flex;
            gap: 20px;
            color: var(--text-secondary);
            font-size: 14px;
            margin-top: 8px;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .segment-list {
            display: grid;
            gap: 10px;
            margin-top: 18px;
        }

        .segment-item {
            border-radius: 16px;
            border: 1px solid #d9e4f3;
            background: #f8fbff;
            padding: 14px 16px;
        }

        .segment-item strong {
            display: block;
            margin-bottom: 6px;
            color: var(--text-primary);
        }

        .segment-item span {
            display: block;
            color: var(--text-secondary);
            line-height: 1.6;
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
                text-align: left;
            }
        }
    </style>
</head>
<body class="fade-in">
    <jsp:include page="../common/header.jsp" />

    <div class="page-title-section">
        <div class="container">
            <h1 style="font-size: 32px; margin-bottom: 8px;">Vé của tôi</h1>
            <p style="color: var(--text-secondary);">Theo dõi đơn đặt vé, trạng thái thanh toán và vé điện tử của bạn tại một nơi.</p>
        </div>
    </div>

    <div class="container" style="min-height: 60vh;">
        <c:if test="${empty bookings}">
            <div class="glass-panel"
                 style="text-align: center; padding: 60px 20px; max-width: 600px; margin: 40px auto;">
                <div style="font-size: 60px; color: #cbd5e1; margin-bottom: 24px;">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <h3 style="margin-bottom: 12px;">Bạn chưa có đơn đặt vé nào</h3>
                <p style="color: var(--text-secondary); margin-bottom: 30px;">Khi hoàn tất đặt vé, thông tin hành trình và vé điện tử sẽ xuất hiện tại đây để bạn theo dõi nhanh hơn.</p>
                <a href="home#search-form" class="btn btn-primary">Tìm chuyến ngay</a>
            </div>
        </c:if>

        <c:forEach items="${bookings}" var="b">
            <div class="booking-card">
                <div class="card-header">
                    <div style="font-family: monospace; font-weight: 600; color: var(--text-secondary);">
                        <i class="fas fa-hashtag"></i>
                        ${not empty b.ticketCode ? b.ticketCode : b.bookingID}
                    </div>
                    <span class="status-badge status-${b.status}">
                        <c:choose>
                            <c:when test="${b.status == 'Paid'}">Đã thanh toán</c:when>
                            <c:when test="${b.status == 'Cancelled'}">Đã hủy</c:when>
                            <c:otherwise>Chờ thanh toán</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="card-body">
                    <div>
                        <c:choose>
                            <c:when test="${not empty b.outboundSegment}">
                                <div class="route-visual">
                                    <span class="city-name">${b.outboundSegment.trip.route.origin}</span>
                                    <i class="fas fa-long-arrow-alt-right route-arrow"></i>
                                    <span class="city-name">${b.outboundSegment.trip.route.destination}</span>
                                    <c:if test="${not empty b.returnSegment}">
                                        <span class="trip-badge"><i class="fas fa-rotate-left"></i> Khứ hồi</span>
                                    </c:if>
                                </div>

                                <div class="trip-meta">
                                    <div class="meta-item">
                                        <i class="far fa-calendar"></i>
                                        <fmt:formatDate value="${b.outboundSegment.trip.departureTime}" pattern="dd/MM/yyyy" />
                                    </div>
                                    <div class="meta-item">
                                        <i class="far fa-clock"></i>
                                        <fmt:formatDate value="${b.outboundSegment.trip.departureTime}" pattern="HH:mm" />
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-users"></i>
                                        ${b.totalPassengerCount} hành khách
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-bus"></i>
                                        <c:choose>
                                            <c:when test="${b.outboundSegment.trip.bus.busType == 'Sleeper'}">Giường nằm</c:when>
                                            <c:when test="${b.outboundSegment.trip.bus.busType == 'Seater'}">Ghế ngồi</c:when>
                                            <c:otherwise>${b.outboundSegment.trip.bus.busType}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div style="margin-top: 16px; font-size: 14px; color: var(--text-secondary);">
                                    <span style="font-weight: 500; color: var(--text-primary);">Mã đặt chỗ:</span>
                                    <span style="font-family: monospace; background: #f1f5f9; padding: 2px 6px; border-radius: 4px;">
                                        ${not empty b.ticketCode ? b.ticketCode : 'Đang cập nhật'}
                                    </span>
                                </div>

                                <div class="segment-list">
                                    <div class="segment-item">
                                        <strong>Chuyến đi</strong>
                                        <span>${b.outboundSegment.trip.route.origin} - ${b.outboundSegment.trip.route.destination}</span>
                                        <span>Ghế đã chọn:
                                            <c:forEach items="${b.outboundSegment.seatNumbers}" var="seat" varStatus="loop">
                                                ${seat}<c:if test="${!loop.last}">, </c:if>
                                            </c:forEach>
                                        </span>
                                    </div>
                                    <c:if test="${not empty b.returnSegment}">
                                        <div class="segment-item">
                                            <strong>Chuyến về</strong>
                                            <span>${b.returnSegment.trip.route.origin} - ${b.returnSegment.trip.route.destination}</span>
                                            <span>Ghế đã chọn:
                                                <c:forEach items="${b.returnSegment.seatNumbers}" var="seat" varStatus="loop">
                                                    ${seat}<c:if test="${!loop.last}">, </c:if>
                                                </c:forEach>
                                            </span>
                                        </div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="route-visual">
                                    <span class="city-name">${b.trip.route.origin}</span>
                                    <i class="fas fa-long-arrow-alt-right route-arrow"></i>
                                    <span class="city-name">${b.trip.route.destination}</span>
                                </div>

                                <div class="trip-meta">
                                    <div class="meta-item">
                                        <i class="far fa-calendar"></i>
                                        <fmt:formatDate value="${b.trip.departureTime}" pattern="dd/MM/yyyy" />
                                    </div>
                                    <div class="meta-item">
                                        <i class="far fa-clock"></i>
                                        <fmt:formatDate value="${b.trip.departureTime}" pattern="HH:mm" />
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-users"></i>
                                        ${b.totalPassengerCount} hành khách
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="price-section">
                        <div class="total-price">
                            <fmt:formatNumber value="${b.totalPrice}" type="number" maxFractionDigits="0" /> đ
                        </div>

                        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                            <c:if test="${b.status == 'Pending'}">
                                <a href="payment?bookingID=${b.bookingID}" class="btn btn-primary">
                                    Tiếp tục thanh toán
                                </a>
                            </c:if>

                            <c:if test="${b.status == 'Paid'}">
                                <a href="ticket?id=${b.bookingID}" class="btn btn-secondary">
                                    <i class="fas fa-file-pdf"></i> Xem vé điện tử
                                </a>
                            </c:if>

                            <c:if test="${b.status == 'Cancelled'}">
                                <button disabled class="btn btn-secondary" style="opacity: 0.6; cursor: not-allowed;">Đã hủy</button>
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
