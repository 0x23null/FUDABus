<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Chọn chuyến xe - Vivu</title>
                <link rel="stylesheet" href="assets/css/style.css">
                <style>
                    .trip-container {
                        max-width: 1000px;
                        margin: 40px auto;
                        padding: 0 20px;
                    }

                    .route-header {
                        background: white;
                        padding: 20px 30px;
                        border-radius: 16px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                        margin-bottom: 30px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .route-title {
                        font-size: 24px;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .trip-section-title {
                        font-size: 20px;
                        font-weight: 700;
                        color: var(--primary-color);
                        margin: 30px 0 15px;
                        padding-bottom: 10px;
                        border-bottom: 2px solid #c7d2fe;
                    }

                    .trip-card {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 24px;
                        margin-bottom: 20px;
                        background: white;
                        border-radius: 16px;
                        border: 2px solid transparent;
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                        transition: all 0.2s ease;
                        cursor: pointer;
                    }

                    .trip-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
                        border-color: #c7d2fe;
                    }

                    .trip-card.selected {
                        border-color: var(--primary-color);
                        background: #fffcfb;
                        box-shadow: 0 0 0 1px var(--primary-color);
                    }

                    .trip-time {
                        font-size: 24px;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .trip-duration {
                        font-size: 13px;
                        color: var(--text-secondary);
                        background: #f1f5f9;
                        padding: 4px 12px;
                        border-radius: 20px;
                    }

                    .trip-price {
                        font-size: 22px;
                        font-weight: 700;
                        color: var(--primary-color);
                    }

                    .btn-select-trip {
                        background: white;
                        color: var(--primary-color);
                        border: 1px solid var(--primary-color);
                        padding: 6px 18px;
                        border-radius: 30px;
                        font-weight: 600;
                        font-size: 14px;
                        transition: all 0.2s;
                        pointer-events: none;
                        /* Let the card click handle it */
                    }

                    .trip-card.selected .btn-select-trip {
                        background: var(--primary-color);
                        color: white;
                    }

                    /* Sticky Action Bar */
                    .sticky-action-bar {
                        position: fixed;
                        bottom: 0;
                        left: 0;
                        width: 100%;
                        background: white;
                        box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.1);
                        padding: 16px 40px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        z-index: 100;
                        transform: translateY(100%);
                        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    }

                    .sticky-action-bar.visible {
                        transform: translateY(0);
                    }

                    .selected-info {
                        display: flex;
                        gap: 40px;
                    }

                    .info-col {
                        display: flex;
                        flex-direction: column;
                    }

                    .info-label {
                        font-size: 12px;
                        color: var(--text-secondary);
                        text-transform: uppercase;
                        font-weight: 600;
                        margin-bottom: 4px;
                    }

                    .info-value {
                        font-size: 16px;
                        font-weight: 700;
                        color: var(--text-primary);
                    }

                    .btn-continue {
                        background: var(--primary-color);
                        color: white;
                        padding: 14px 40px;
                        border-radius: 30px;
                        font-size: 16px;
                        font-weight: 600;
                        border: none;
                        cursor: pointer;
                        box-shadow: 0 4px 10px rgba(79, 70, 229, 0.3);
                    }

                    .btn-continue:hover {
                        background: var(--primary-dark);
                        transform: translateY(-2px);
                    }

                    body {
                        padding-bottom: 80px;
                    }

                    /* Space for sticky bar */
                </style>
            </head>

            <body class="fade-in">
                <jsp:include page="../common/header.jsp"></jsp:include>

                <div class="trip-container">
                    <div class="route-header">
                        <div>
                            <div class="route-title">
                                ${searchOrigin} <i class="fas fa-arrow-right"
                                    style="color: var(--primary-color); margin: 0 10px; font-size: 20px;"></i>
                                ${searchDest}
                            </div>
                            <div style="color: var(--text-secondary); margin-top: 8px;">
                                <c:if test="${tripType == 'roundTrip'}">Khứ hồi &bull; </c:if>Ngày đi: ${searchDate}
                                <c:if test="${not empty returnTrips}"> &bull; Ngày về: ${searchReturnDate}</c:if> &bull;
                                ${ticketCount} Vé
                            </div>
                        </div>
                    </div>

                    <c:if test="${isSuggestion}">
                        <div
                            style="background: #eef2ff; color: #4338ca; padding: 20px 24px; border-radius: 16px; margin-bottom: 30px; display: flex; align-items: center; gap: 16px; border: 1px solid #c7d2fe; box-shadow: 0 4px 12px rgba(67, 56, 202, 0.05);">
                            <i class="fas fa-info-circle" style="font-size: 28px;"></i>
                            <div>
                                <h4 style="margin: 0; font-size: 16px; font-weight: 700;">Không tìm thấy chuyến xe chính
                                    xác</h4>
                                <p style="margin: 4px 0 0 0; font-size: 14px; opacity: 0.9;">Dưới đây là các chuyến xe
                                    có sẵn để bạn tham khảo.</p>
                            </div>
                        </div>
                    </c:if>

                    <!-- CHUYẾN ĐI -->
                    <h3 class="trip-section-title">CHUYẾN ĐI <c:if test="${not empty searchDate}">(${searchDate})</c:if>
                    </h3>
                    <c:if test="${empty trips}">
                        <p style="text-align: center; color: var(--text-secondary); padding: 40px 0;">Không có chuyến xe
                            nào vào ngày này.</p>
                    </c:if>
                    <c:forEach items="${trips}" var="t">
                        <div class="trip-card outbound-card" data-id="${t.tripID}" data-price="${t.price}"
                            onclick="selectTrip('outbound', this)">
                            <div style="display: flex; align-items: center; gap: 40px; flex: 2;">
                                <div style="text-align: center;">
                                    <div class="trip-time">
                                        <fmt:formatDate value="${t.departureTime}" pattern="HH:mm" />
                                    </div>
                                    <div style="font-size: 13px; color: var(--text-secondary);">${t.route.origin}</div>
                                </div>
                                <div style="display: flex; flex-direction: column; align-items: center;">
                                    <span class="trip-duration">${t.route.duration / 60} giờ</span>
                                    <div style="border-top: 2px dotted #cbd5e1; width: 80px; margin: 8px 0;"></div>
                                </div>
                                <div style="text-align: center;">
                                    <div class="trip-time">
                                        <fmt:formatDate value="${t.arrivalTime}" pattern="HH:mm" />
                                    </div>
                                    <div style="font-size: 13px; color: var(--text-secondary);">${t.route.destination}
                                    </div>
                                </div>
                            </div>
                            <div style="flex: 1; text-align: left; padding-left: 20px;">
                                <div style="font-weight: 600; font-size: 15px;">${t.bus.busType}</div>
                                <div style="color: var(--text-secondary); font-size: 13px;">Còn 20 chỗ trống</div>
                            </div>
                            <div style="flex: 1; text-align: right;">
                                <div class="trip-price">
                                    <fmt:formatNumber value="${t.price}" type="number" maxFractionDigits="0" /> đ
                                </div>
                                <button class="btn-select-trip" id="btn-outbound-${t.tripID}">Chọn chuyến</button>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- CHUYẾN VỀ (NẾU CÓ) -->
                    <c:if test="${not empty returnTrips}">
                        <h3 class="trip-section-title" style="margin-top: 40px;">CHUYẾN VỀ <c:if
                                test="${not empty searchReturnDate}">(${searchReturnDate})</c:if>
                        </h3>
                        <c:forEach items="${returnTrips}" var="t">
                            <div class="trip-card return-card" data-id="${t.tripID}" data-price="${t.price}"
                                onclick="selectTrip('return', this)">
                                <div style="display: flex; align-items: center; gap: 40px; flex: 2;">
                                    <div style="text-align: center;">
                                        <div class="trip-time">
                                            <fmt:formatDate value="${t.departureTime}" pattern="HH:mm" />
                                        </div>
                                        <div style="font-size: 13px; color: var(--text-secondary);">${t.route.origin}
                                        </div>
                                    </div>
                                    <div style="display: flex; flex-direction: column; align-items: center;">
                                        <span class="trip-duration">${t.route.duration / 60} giờ</span>
                                        <div style="border-top: 2px dotted #cbd5e1; width: 80px; margin: 8px 0;"></div>
                                    </div>
                                    <div style="text-align: center;">
                                        <div class="trip-time">
                                            <fmt:formatDate value="${t.arrivalTime}" pattern="HH:mm" />
                                        </div>
                                        <div style="font-size: 13px; color: var(--text-secondary);">
                                            ${t.route.destination}</div>
                                    </div>
                                </div>
                                <div style="flex: 1; text-align: left; padding-left: 20px;">
                                    <div style="font-weight: 600; font-size: 15px;">${t.bus.busType}</div>
                                    <div style="color: var(--text-secondary); font-size: 13px;">Còn 20 chỗ trống</div>
                                </div>
                                <div style="flex: 1; text-align: right;">
                                    <div class="trip-price">
                                        <fmt:formatNumber value="${t.price}" type="number" maxFractionDigits="0" /> đ
                                    </div>
                                    <button class="btn-select-trip" id="btn-return-${t.tripID}">Chọn chuyến</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>

                </div>

                <!-- Sticky Bar -->
                <div class="sticky-action-bar" id="actionBar">
                    <div class="selected-info">
                        <div class="info-col">
                            <span class="info-label">Chuyến đi</span>
                            <span class="info-value" id="lblOutbound">Chưa chọn</span>
                        </div>
                        <c:if test="${not empty returnTrips}">
                            <div class="info-col">
                                <span class="info-label">Chuyến về</span>
                                <span class="info-value" id="lblReturn">Chưa chọn</span>
                            </div>
                        </c:if>
                        <div class="info-col">
                            <span class="info-label">Tổng tiền vé (tạm tính)</span>
                            <span class="info-value trip-price" id="lblTotal">0 đ</span>
                        </div>
                    </div>
                    <div>
                        <button class="btn-continue" onclick="proceedToBooking()">Tiếp tục chọn ghế</button>
                    </div>
                </div>

                <script>
                    let selectedOutboundID = null;
                    let selectedReturnID = null;
                    let outboundPrice = 0;
                    let returnPrice = 0;
                    let isRoundTrip = ${ not empty returnTrips };
                    let ticketCount = ${ ticketCount != null ? ticketCount : 1};

                    function selectTrip(type, element) {
                        const id = element.getAttribute('data-id');
                        const price = parseFloat(element.getAttribute('data-price'));
                        const time = element.querySelector('.trip-time').innerText;

                        // Remove selected class from all cards of this type
                        const selector = type === 'outbound' ? '.outbound-card' : '.return-card';
                        const cards = document.querySelectorAll(selector);
                        cards.forEach(c => {
                            c.classList.remove('selected');
                            c.querySelector('.btn-select-trip').innerText = 'Chọn chuyến';
                        });

                        // Add selected class to the clicked card
                        element.classList.add('selected');
                        element.querySelector('.btn-select-trip').innerText = 'Đã chọn';

                        if (type === 'outbound') {
                            selectedOutboundID = id;
                            outboundPrice = price;
                            document.getElementById('lblOutbound').innerText = time;
                        } else {
                            selectedReturnID = id;
                            returnPrice = price;
                            document.getElementById('lblReturn').innerText = time;
                        }

                        updateActionBar();
                    }

                    function updateActionBar() {
                        const total = (outboundPrice + returnPrice) * ticketCount;
                        document.getElementById('lblTotal').innerText = total.toLocaleString('vi-VN') + ' đ';

                        const actionBar = document.getElementById('actionBar');
                        if (isRoundTrip) {
                            if (selectedOutboundID && selectedReturnID) {
                                actionBar.classList.add('visible');
                            } else {
                                actionBar.classList.remove('visible');
                            }
                        } else {
                            if (selectedOutboundID) {
                                actionBar.classList.add('visible');
                            } else {
                                actionBar.classList.remove('visible');
                            }
                        }
                    }

                    function proceedToBooking() {
                        if (!selectedOutboundID) return;
                        let url = 'booking?tripID=' + selectedOutboundID + '&ticketCount=' + ticketCount;
                        if (isRoundTrip && selectedReturnID) {
                            url += '&returnTripID=' + selectedReturnID;
                        }
                        window.location.href = url;
                    }
                </script>
            </body>

            </html>