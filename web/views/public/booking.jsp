<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Chọn Ghế - Vivu</title>
                <link rel="stylesheet" href="assets/css/style.css">
                <style>
                    .booking-container {
                        display: flex;
                        gap: 40px;
                        margin-top: 40px;
                    }

                    .seat-map-container {
                        flex: 2;
                        background: white;
                        padding: 40px;
                        border-radius: 24px;
                        box-shadow: var(--shadow-md);
                    }

                    .summary-card {
                        flex: 1;
                        background: white;
                        padding: 30px;
                        border-radius: 24px;
                        box-shadow: var(--shadow-md);
                        height: fit-content;
                        position: sticky;
                        top: 100px;
                    }

                    /* Dual Map Layout */
                    .maps-wrapper {
                        display: flex;
                        gap: 40px;
                        justify-content: center;
                    }

                    .map-section {
                        flex: 1;
                        background: #f8fafc;
                        padding: 20px;
                        border-radius: 16px;
                        border: 1px solid #e2e8f0;
                    }

                    .map-title {
                        text-align: center;
                        font-weight: 700;
                        margin-bottom: 20px;
                        color: var(--primary-color);
                        font-size: 18px;
                    }

                    /* Seat Grid styling */
                    .deck-label {
                        font-weight: 700;
                        margin-bottom: 20px;
                        text-align: center;
                        color: var(--text-secondary);
                        font-size: 14px;
                    }

                    .seat-grid {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
                        gap: 12px;
                        margin-bottom: 30px;
                    }

                    .seat {
                        height: 50px;
                        border: 2px solid #d2d2d7;
                        border-radius: 10px;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        cursor: pointer;
                        font-weight: 600;
                        font-size: 14px;
                        transition: all 0.2s;
                        background: white;
                    }

                    .seat.available:hover {
                        border-color: var(--primary-color);
                        background: #fffcfb;
                    }

                    .seat.selected {
                        background: var(--primary-color);
                        color: white;
                        border-color: var(--primary-color);
                    }

                    .seat.booked {
                        background: #e2e8f0;
                        color: #94a3b8;
                        border-color: #e2e8f0;
                        cursor: not-allowed;
                    }

                    /* Legend */
                    .legend {
                        display: flex;
                        gap: 20px;
                        justify-content: center;
                        margin-top: 30px;
                        padding-top: 20px;
                        border-top: 1px solid #e2e8f0;
                    }

                    .legend-item {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        font-size: 14px;
                        color: var(--text-secondary);
                        font-weight: 500;
                    }

                    .legend-box {
                        width: 20px;
                        height: 20px;
                        border-radius: 4px;
                    }
                </style>
            </head>

            <body class="fade-in">
                <jsp:include page="../common/header.jsp"></jsp:include>

                <div class="container" style="padding-top: 20px; min-height: 80vh;">
                    <a href="search?origin=${trip.route.origin}&destination=${trip.route.destination}&date=${trip.departureTime}&tripType=${not empty returnTrip ? 'roundTrip' : 'oneWay'}&ticketCount=${ticketCount}"
                        style="color: var(--text-secondary); font-size: 14px; text-decoration: none; font-weight: 500;">&larr;
                        Quay lại chọn chuyến</a>

                    <c:if test="${not empty param.error}">
                        <div
                            style="background: #fce8e6; color: #d93025; padding: 15px 20px; border-radius: 12px; margin-top: 20px; font-weight: 500;">
                            <i class="fas fa-exclamation-circle" style="margin-right: 8px;"></i>
                            <c:choose>
                                <c:when test="${param.error == 'BookingFailed'}">Lỗi hệ thống. Vui lòng thử lại.
                                </c:when>
                                <c:when test="${param.error == 'SeatsUnavailable'}">Ghế bạn chọn vừa có người đặt. Vui
                                    lòng chọn ghế khác.</c:when>
                                <c:otherwise>${param.error}</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <p style="margin-top: 20px; color: var(--text-secondary); font-size: 15px;">
                        <i class="fas fa-info-circle" style="color: var(--primary-color);"></i> Nhấp vào các ghế màu
                        trắng để chọn. Số lượng vé cần chọn: <strong>${ticketCount} ghế</strong>
                        <c:if test="${not empty returnTrip}">mỗi chiều.</c:if>
                    </p>

                    <div class="booking-container">
                        <!-- Seat Map Area -->
                        <div class="seat-map-container">
                            <h3 style="margin-bottom: 30px; font-size: 24px;">Sơ đồ ghế</h3>

                            <div class="maps-wrapper">
                                <!-- Outbound Map -->
                                <div class="map-section">
                                    <div class="map-title">CHUYẾN ĐI</div>
                                    <div style="display: flex; gap: 20px;">
                                        <div style="flex: 1;">
                                            <div class="deck-label">Tầng dưới</div>
                                            <div class="seat-grid">
                                                <c:forEach begin="1" end="15" var="i">
                                                    <c:set var="seatNum" value="A${i}" />
                                                    <div class="seat ${bookedSeats.contains(seatNum) ? 'booked' : 'available'}"
                                                        onclick="toggleSeat(this, 'outbound', '${seatNum}')">${seatNum}
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div style="flex: 1;">
                                            <div class="deck-label">Tầng trên</div>
                                            <div class="seat-grid">
                                                <c:forEach begin="1" end="15" var="i">
                                                    <c:set var="seatNum" value="B${i}" />
                                                    <div class="seat ${bookedSeats.contains(seatNum) ? 'booked' : 'available'}"
                                                        onclick="toggleSeat(this, 'outbound', '${seatNum}')">${seatNum}
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Return Map -->
                                <c:if test="${not empty returnTrip}">
                                    <div class="map-section">
                                        <div class="map-title">CHUYẾN VỀ</div>
                                        <div style="display: flex; gap: 20px;">
                                            <div style="flex: 1;">
                                                <div class="deck-label">Tầng dưới</div>
                                                <div class="seat-grid">
                                                    <c:forEach begin="1" end="15" var="i">
                                                        <c:set var="seatNum" value="A${i}" />
                                                        <div class="seat ${returnBookedSeats.contains(seatNum) ? 'booked' : 'available'}"
                                                            onclick="toggleSeat(this, 'return', '${seatNum}')">
                                                            ${seatNum}</div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div style="flex: 1;">
                                                <div class="deck-label">Tầng trên</div>
                                                <div class="seat-grid">
                                                    <c:forEach begin="1" end="15" var="i">
                                                        <c:set var="seatNum" value="B${i}" />
                                                        <div class="seat ${returnBookedSeats.contains(seatNum) ? 'booked' : 'available'}"
                                                            onclick="toggleSeat(this, 'return', '${seatNum}')">
                                                            ${seatNum}</div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="legend">
                                <div class="legend-item">
                                    <div class="legend-box" style="border: 2px solid #d2d2d7;"></div> Còn trống
                                </div>
                                <div class="legend-item">
                                    <div class="legend-box" style="background: var(--primary-color);"></div> Đang chọn
                                </div>
                                <div class="legend-item">
                                    <div class="legend-box" style="background: #e2e8f0;"></div> Đã đặt
                                </div>
                            </div>
                        </div>

                        <!-- Summary Sidebar -->
                        <div class="summary-card">
                            <h3 style="margin-bottom: 24px; font-size: 20px;">Thông tin đặt vé</h3>

                            <!-- Outbound Details -->
                            <div style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px dashed #e2e8f0;">
                                <div style="font-weight: 700; color: var(--primary-color); margin-bottom: 8px;">CHUYẾN
                                    ĐI</div>
                                <div style="font-weight: 600;">${trip.route.origin} &rarr; ${trip.route.destination}
                                </div>
                                <div style="color: var(--text-secondary); font-size: 14px; margin-top: 4px;">
                                    <fmt:formatDate value="${trip.departureTime}" pattern="HH:mm - dd/MM/yyyy" />
                                </div>
                                <div
                                    style="display: flex; justify-content: space-between; margin-top: 12px; font-size: 14px;">
                                    <span style="color: var(--text-secondary);">Ghế:</span>
                                    <span id="display-outbound-seats" style="font-weight: 600;">-</span>
                                </div>
                            </div>

                            <!-- Return Details -->
                            <c:if test="${not empty returnTrip}">
                                <div
                                    style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px dashed #e2e8f0;">
                                    <div style="font-weight: 700; color: var(--primary-color); margin-bottom: 8px;">
                                        CHUYẾN VỀ</div>
                                    <div style="font-weight: 600;">${returnTrip.route.origin} &rarr;
                                        ${returnTrip.route.destination}</div>
                                    <div style="color: var(--text-secondary); font-size: 14px; margin-top: 4px;">
                                        <fmt:formatDate value="${returnTrip.departureTime}"
                                            pattern="HH:mm - dd/MM/yyyy" />
                                    </div>
                                    <div
                                        style="display: flex; justify-content: space-between; margin-top: 12px; font-size: 14px;">
                                        <span style="color: var(--text-secondary);">Ghế:</span>
                                        <span id="display-return-seats" style="font-weight: 600;">-</span>
                                    </div>
                                </div>
                            </c:if>

                            <div style="margin-top: 20px;">
                                <div
                                    style="display: flex; justify-content: space-between; font-size: 22px; font-weight: 700; color: var(--primary-color);">
                                    <span>Tổng tiền:</span>
                                    <span id="display-total">0 đ</span>
                                </div>
                            </div>

                            <form action="booking" method="POST" id="bookingForm" style="margin-top: 30px;">
                                <input type="hidden" name="tripID" value="${trip.tripID}">
                                <input type="hidden" name="selectedSeats" id="input-outbound-seats">
                                <c:if test="${not empty returnTrip}">
                                    <input type="hidden" name="returnTripID" value="${returnTrip.tripID}">
                                    <input type="hidden" name="returnSeats" id="input-return-seats">
                                </c:if>
                                <input type="hidden" name="totalPrice" id="input-total">

                                <c:if test="${empty sessionScope.user}">
                                    <div style="margin-top: 20px; text-align: left; background: #f8fafc; padding: 16px; border-radius: 12px; border: 1px solid #e2e8f0;">
                                        <div style="font-weight: 600; color: #333; margin-bottom: 12px; font-size: 14px;">Thông tin liên hệ (Mua vé không cần tài khoản)</div>
                                        <input type="text" name="guestName" placeholder="Họ và tên" class="form-control" style="margin-bottom: 10px; padding: 10px; border: 1px solid #d2d2d7; border-radius: 8px; width: 100%; box-sizing: border-box;" required>
                                        <input type="text" name="guestPhone" placeholder="Số điện thoại" class="form-control" style="margin-bottom: 10px; padding: 10px; border: 1px solid #d2d2d7; border-radius: 8px; width: 100%; box-sizing: border-box;" required>
                                        <input type="email" name="guestEmail" placeholder="Email" class="form-control" style="margin-bottom: 10px; padding: 10px; border: 1px solid #d2d2d7; border-radius: 8px; width: 100%; box-sizing: border-box;" required>
                                    </div>
                                </c:if>

                                <button type="submit" class="btn btn-primary"
                                    style="width: 100%; padding: 14px; font-size: 16px; border-radius: 12px; margin-top: 20px;" disabled
                                    id="btn-checkout">Tiếp tục thanh toán</button>
                                <div id="validation-msg"
                                    style="color: #d93025; font-size: 13px; text-align: center; margin-top: 12px; font-weight: 500;">
                                    Vui lòng chọn đủ ${ticketCount} ghế <c:if test="${not empty returnTrip}">cho mỗi
                                        chuyến</c:if>.
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <jsp:include page="../common/footer.jsp"></jsp:include>
                <script>
                    const requiredCount = ${ ticketCount };
                    let outSeats = [];
                    let retSeats = [];
                    const outPrice = ${ trip.price };
                    const retPrice = ${ not empty returnTrip ?returnTrip.price: 0};
                    const hasReturn = ${ not empty returnTrip };

                    function toggleSeat(element, type, seatNum) {
                        if (element.classList.contains('booked')) return;

                        let arr = type === 'outbound' ? outSeats : retSeats;

                        if (element.classList.contains('selected')) {
                            element.classList.remove('selected');
                            const idx = arr.indexOf(seatNum);
                            if (idx > -1) arr.splice(idx, 1);
                        } else {
                            if (arr.length >= requiredCount) {
                                alert('Bạn chỉ có thể chọn tối đa ' + requiredCount + ' ghế.');
                                return;
                            }
                            element.classList.add('selected');
                            arr.push(seatNum);
                        }
                        updateSummary();
                    }

                    function updateSummary() {
                        document.getElementById('display-outbound-seats').innerText = outSeats.length > 0 ? outSeats.join(', ') : '-';
                        document.getElementById('input-outbound-seats').value = outSeats.join(',');

                        if (hasReturn) {
                            document.getElementById('display-return-seats').innerText = retSeats.length > 0 ? retSeats.join(', ') : '-';
                            document.getElementById('input-return-seats').value = retSeats.join(',');
                        }

                        const total = (outSeats.length * outPrice) + (retSeats.length * retPrice);
                        document.getElementById('display-total').innerText = total.toLocaleString('vi-VN') + ' đ';
                        document.getElementById('input-total').value = total;

                        const isValid = hasReturn ? (outSeats.length === requiredCount && retSeats.length === requiredCount) : (outSeats.length === requiredCount);

                        const btn = document.getElementById('btn-checkout');
                        const msg = document.getElementById('validation-msg');

                        if (isValid) {
                            btn.removeAttribute('disabled');
                            msg.style.display = 'none';
                        } else {
                            btn.setAttribute('disabled', 'true');
                            msg.style.display = 'block';
                        }
                    }
                </script>
            </body>

            </html>