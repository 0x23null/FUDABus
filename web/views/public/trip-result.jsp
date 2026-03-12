<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Select Bus - BusTicket</title>
                <link rel="stylesheet" href="assets/css/style.css">
                <style>
                    .trip-card {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 24px;
                        margin-bottom: 20px;
                        background: white;
                        border-radius: 18px;
                        box-shadow: var(--shadow-sm);
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .trip-card:hover {
                        transform: translateY(-2px);
                        box-shadow: var(--shadow-md);
                    }

                    .trip-time {
                        font-size: 24px;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .trip-duration {
                        font-size: 14px;
                        color: var(--text-secondary);
                        background: #f5f5f7;
                        padding: 4px 12px;
                        border-radius: 20px;
                        margin: 0 10px;
                    }

                    .trip-price {
                        font-size: 24px;
                        font-weight: 700;
                        color: var(--primary-color);
                    }

                    .bus-info {
                        display: flex;
                        flex-direction: column;
                        gap: 4px;
                    }

                    .bus-type {
                        font-size: 14px;
                        font-weight: 500;
                        color: var(--text-secondary);
                    }
                </style>
            </head>

            <body class="fade-in">
                <jsp:include page="../common/header.jsp"></jsp:include>

                <div class="container" style="padding-top: 40px; min-height: 80vh;">
                    <div style="margin-bottom: 30px;">
                        <h2 style="font-size: 28px; font-weight: 700;">
                            ${searchOrigin} <span style="color: var(--text-secondary); font-size: 20px;">&rarr;</span>
                            ${searchDest}
                        </h2>
                        <p style="color: var(--text-secondary);">Date: ${searchDate}</p>
                    </div>

                    <c:if test="${isSuggestion}">
                        <div class="glass-panel" style="margin-bottom: 30px; border-left: 4px solid #f9ab00;">
                            <h3 style="color: var(--text-primary); margin-bottom: 8px;">No exact matches found.</h3>
                            <p style="color: var(--text-secondary);">We couldn't find a direct trip for your search
                                criteria. Here are all available upcoming trips:</p>
                        </div>
                    </c:if>

                    <c:forEach items="${trips}" var="t">
                        <div class="trip-card">
                            <div style="display: flex; align-items: center; gap: 40px;">
                                <div style="text-align: center;">
                                    <div class="trip-time">
                                        <fmt:formatDate value="${t.departureTime}" pattern="HH:mm" />
                                    </div>
                                    <div style="font-size: 12px; color: var(--text-secondary);">${t.route.origin}</div>
                                </div>

                                <div style="display: flex; flex-direction: column; align-items: center;">
                                    <span class="trip-duration">${t.route.duration / 60}h</span>
                                    <div style="border-top: 2px dotted #d2d2d7; width: 100px; margin: 8px 0;"></div>
                                    <span style="font-size: 12px; color: var(--text-secondary);">Direct</span>
                                </div>

                                <div style="text-align: center;">
                                    <div class="trip-time">
                                        <fmt:formatDate value="${t.arrivalTime}" pattern="HH:mm" />
                                    </div>
                                    <div style="font-size: 12px; color: var(--text-secondary);">${t.route.destination}
                                    </div>
                                </div>
                            </div>

                            <div class="bus-info">
                                <div style="font-weight: 600;">${t.bus.busNumber}</div>
                                <div class="bus-type">${t.bus.busType}</div>
                            </div>

                            <div style="text-align: right;">
                                <div class="trip-price">
                                    <fmt:formatNumber value="${t.price}" type="number" maxFractionDigits="0" /> VNĐ
                                </div>
                                <div style="font-size: 12px; color: var(--text-secondary); margin-bottom: 10px;">per
                                    seat</div>
                                <a href="booking?tripID=${t.tripID}" class="btn btn-primary">Select Seats</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <jsp:include page="../common/footer.jsp"></jsp:include>
                <script src="assets/js/main.js"></script>
            </body>

            </html> });
            });
            </script>
            <script src="assets/js/main.js"></script>
            </body>

            </html>