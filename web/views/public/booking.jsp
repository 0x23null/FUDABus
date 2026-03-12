<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Select Seats - BusTicket</title>
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

                    /* Seat Map Styling */
                    .deck-label {
                        font-weight: 700;
                        margin-bottom: 20px;
                        text-align: center;
                        color: var(--text-secondary);
                    }

                    .seat-grid {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
                        gap: 16px;
                        margin-bottom: 40px;
                    }

                    .seat {
                        height: 60px;
                        border: 2px solid #d2d2d7;
                        border-radius: 12px;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        cursor: pointer;
                        font-weight: 600;
                        font-size: 14px;
                        transition: all 0.2s;
                        position: relative;
                    }

                    .seat.available:hover {
                        border-color: var(--primary-color);
                        background: #f0f8ff;
                    }

                    .seat.selected {
                        background: var(--primary-color);
                        color: white;
                        border-color: var(--primary-color);
                    }

                    .seat.booked {
                        background: #eee;
                        color: #bbb;
                        border-color: #eee;
                        cursor: not-allowed;
                    }

                    /* Legend */
                    .legend {
                        display: flex;
                        gap: 20px;
                        justify-content: center;
                        margin-top: 20px;
                    }

                    .legend-item {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        font-size: 14px;
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
                    <a href="search?origin=${trip.route.origin}&destination=${trip.route.destination}&date=${trip.departureTime}"
                        style="color: var(--text-secondary); font-size: 14px;">&larr; Back to Results</a>

                    <c:if test="${not empty param.error}">
                        <div
                            style="background: #fce8e6; color: #d93025; padding: 12px; border-radius: 8px; margin-top: 16px;">
                            <strong>Error:</strong>
                            <c:choose>
                                <c:when test="${param.error == 'BookingFailed'}">
                                    Something went wrong with your booking. Please try again.
                                </c:when>
                                <c:when test="${param.error == 'SeatsUnavailable'}">
                                    Some of the selected seats are already taken. Please choose different seats.
                                </c:when>
                                <c:otherwise>
                                    ${param.error}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <p style="margin-top: 10px; color: var(--text-secondary);">
                        <i class="fas fa-info-circle"></i> Click on the white seats (Available) to select them. Grey
                        seats are already booked.
                    </p>

                    <div class="booking-container">
                        <!-- Seat Map -->
                        <div class="seat-map-container">
                            <h3 style="margin-bottom: 30px;">Select Seats</h3>
                            <div style="display: flex; justify-content: space-around;">
                                <!-- Lower Deck -->
                                <div style="width: 200px;">
                                    <div class="deck-label">Lower Deck</div>
                                    <div class="seat-grid">
                                        <!-- Simple loop for seats 1-15 (Lower) -->
                                        <c:forEach begin="1" end="15" var="i">
                                            <c:set var="seatNum" value="A${i}" />
                                            <div class="seat ${bookedSeats.contains(seatNum) ? 'booked' : 'available'}"
                                                data-seat="${seatNum}" onclick="toggleSeat(this)">${seatNum}</div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Upper Deck -->
                                <div style="width: 200px;">
                                    <div class="deck-label">Upper Deck</div>
                                    <div class="seat-grid">
                                        <c:forEach begin="1" end="15" var="i">
                                            <c:set var="seatNum" value="B${i}" />
                                            <div class="seat ${bookedSeats.contains(seatNum) ? 'booked' : 'available'}"
                                                data-seat="${seatNum}" onclick="toggleSeat(this)">${seatNum}</div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>

                            <div class="legend">
                                <div class="legend-item">
                                    <div class="legend-box" style="border: 2px solid #d2d2d7;"></div> Available
                                </div>
                                <div class="legend-item">
                                    <div class="legend-box" style="background: var(--primary-color);"></div> Selected
                                </div>
                                <div class="legend-item">
                                    <div class="legend-box" style="background: #eee;"></div> Booked
                                </div>
                            </div>
                        </div>

                        <!-- Summary Sidebar -->
                        <div class="summary-card">
                            <h3 style="margin-bottom: 20px;">Trip Summary</h3>
                            <div style="margin-bottom: 20px;">
                                <div style="font-weight: 600;">${trip.route.origin} &rarr; ${trip.route.destination}
                                </div>
                                <div style="color: var(--text-secondary); font-size: 14px;">
                                    <fmt:formatDate value="${trip.departureTime}" pattern="EEE, dd MMM yyyy - HH:mm" />
                                </div>
                                <div style="color: var(--text-secondary); font-size: 14px;">
                                    ${trip.bus.busType} (Slot ${trip.bus.busNumber})
                                </div>
                            </div>

                            <div style="border-top: 1px solid #eee; padding-top: 20px; margin-top: 20px;">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                                    <span>Seat(s):</span>
                                    <span id="display-seats" style="font-weight: 600;">-</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                                    <span>Price x <span id="seat-count">0</span>:</span>
                                    <span>
                                        <fmt:formatNumber value="${trip.price}" type="number" maxFractionDigits="0" />
                                        VNĐ
                                    </span>
                                </div>
                                <div
                                    style="display: flex; justify-content: space-between; font-size: 20px; font-weight: 700; color: var(--primary-color);">
                                    <span>Total:</span>
                                    <span id="display-total">0 VNĐ</span>
                                </div>
                            </div>

                            <form action="booking" method="POST" id="bookingForm" style="margin-top: 30px;">
                                <input type="hidden" name="tripID" value="${trip.tripID}">
                                <input type="hidden" name="selectedSeats" id="input-seats">
                                <input type="hidden" name="totalPrice" id="input-total">
                                <button type="submit" class="btn btn-primary" style="width: 100%;" disabled
                                    id="btn-checkout">Continue</button>
                            </form>
                        </div>
                    </div>
                </div>

                <jsp:include page="../common/footer.jsp"></jsp:include>
                <script>
                    let selectedSeats = [];
                    const seatPrice = ${ trip.price };

                    function toggleSeat(element) {
                        if (element.classList.contains('booked')) return;

                        const seatNum = element.getAttribute('data-seat');

                        if (element.classList.contains('selected')) {
                            element.classList.remove('selected');
                            selectedSeats = selectedSeats.filter(s => s !== seatNum);
                        } else {
                            if (selectedSeats.length >= 5) {
                                alert("You can only select up to 5 seats.");
                                return;
                            }
                            element.classList.add('selected');
                            selectedSeats.push(seatNum);
                        }
                        updateSummary();
                    }

                    function updateSummary() {
                        const count = selectedSeats.length;
                        const total = count * seatPrice;

                        document.getElementById('display-seats').innerText = selectedSeats.length > 0 ? selectedSeats.join(', ') : '-';
                        document.getElementById('seat-count').innerText = count;
                        document.getElementById('display-total').innerText = total.toLocaleString('vi-VN') + ' VNĐ';

                        document.getElementById('input-seats').value = selectedSeats.join(',');
                        document.getElementById('input-total').value = total;

                        const btn = document.getElementById('btn-checkout');
                        if (count > 0) {
                            btn.removeAttribute('disabled');
                        } else {
                            btn.setAttribute('disabled', 'disabled');
                        }
                    }
                </script>
                <script src="assets/js/main.js"></script>
            </body>

            </html>