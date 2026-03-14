<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Chọn ghế - FUDA Bus</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        body {
            background:
                radial-gradient(circle at top right, rgba(37, 99, 235, 0.08), transparent 32%),
                linear-gradient(180deg, #f7faff 0%, #eef4fb 100%);
        }

        .page-wrap {
            max-width: 1180px;
            margin: 32px auto 80px;
            padding: 0 20px;
        }

        .top-bar {
            padding: 30px 28px 24px;
        }

        .top-bar h1 {
            margin: 0 0 12px;
            font-size: 27px;
            line-height: 1.2;
        }

        .top-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .meta-pill {
            display: inline-flex;
            align-items: center;
            min-height: 38px;
            padding: 0 14px;
            border-radius: 999px;
            background: #f6faff;
            border: 1px solid #d7e4f6;
            color: var(--text-secondary);
            font-weight: 500;
        }

        .layout {
            display: grid;
            grid-template-columns: minmax(0, 1.42fr) minmax(320px, 0.92fr);
            gap: 24px;
            align-items: start;
            margin-top: 18px;
        }

        .panel {
            padding: 24px;
        }

        .message {
            background: #fff1f2;
            color: #be123c;
            border: 1px solid #fecdd3;
            border-radius: 16px;
            padding: 12px 14px;
            margin: 16px 0;
            font-weight: 600;
        }

        .segment-grid {
            display: grid;
            gap: 18px;
        }

        .segment-card {
            padding: 22px;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.92);
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-md);
        }

        .segment-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 18px;
        }

        .segment-title {
            margin: 0 0 6px;
            font-size: 20px;
            line-height: 1.25;
        }

        .segment-route {
            margin: 0;
            color: var(--text-secondary);
            line-height: 1.6;
        }

        .segment-status {
            min-width: 170px;
            padding: 14px 16px;
            border-radius: 20px;
            border: 1px solid #d8e5f7;
            background: linear-gradient(135deg, #f4f8ff, #fbfdff);
        }

        .segment-status span {
            display: block;
            color: var(--text-soft);
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .segment-status strong {
            display: block;
            font-size: 22px;
            line-height: 1;
            color: var(--primary-dark);
            font-weight: 700;
        }

        .segment-status small {
            display: block;
            margin-top: 6px;
            color: var(--text-secondary);
            font-size: 13px;
        }

        .segment-frame {
            border-radius: 24px;
            border: 1px solid #dbe7f7;
            background: linear-gradient(180deg, #fbfdff 0%, #f6faff 100%);
            padding: 18px;
        }

        .deck-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .deck {
            border-radius: 24px;
            border: 1px solid #d7e4f6;
            background: linear-gradient(180deg, #ffffff 0%, #f3f8ff 100%);
            padding: 16px;
        }

        .deck-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
        }

        .deck-head strong {
            font-size: 15px;
            font-weight: 650;
        }

        .deck-head span {
            color: var(--text-soft);
            font-size: 12px;
        }

        .seat-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 10px;
        }

        .seat {
            height: 46px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #cad9f0;
            background: #fff;
            color: var(--text-primary);
            font-weight: 650;
            cursor: pointer;
            transition: transform 0.18s ease, border-color 0.18s ease, background-color 0.18s ease, color 0.18s ease;
        }

        .seat:hover:not(.booked) {
            transform: translateY(-1px);
            border-color: #8fb1e6;
        }

        .seat.booked {
            background: #e9eef6;
            color: #98a5b8;
            cursor: not-allowed;
            border-color: #d7e0ec;
        }

        .seat.selected {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border-color: var(--primary-dark);
            color: #fff;
            box-shadow: 0 16px 28px -20px rgba(37, 99, 235, 0.62);
        }

        .legend {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 18px;
            padding: 2px 4px 0;
            color: var(--text-secondary);
            font-size: 14px;
        }

        .legend span {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .legend i {
            width: 16px;
            height: 16px;
            border-radius: 6px;
            display: inline-block;
        }

        .summary-card {
            padding: 24px;
            position: sticky;
            top: 92px;
        }

        .summary-card h2 {
            margin: 0 0 18px;
            font-size: 24px;
        }

        .summary-hero {
            border-radius: 22px;
            background: linear-gradient(135deg, #eff6ff 0%, #f8fbff 100%);
            border: 1px solid #dbe7f8;
            padding: 18px;
            margin-bottom: 8px;
        }

        .summary-hero span {
            display: block;
            color: var(--text-soft);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-weight: 700;
        }

        .summary-hero strong {
            display: block;
            margin-top: 8px;
            font-size: 30px;
        }

        .summary-block {
            padding: 16px 0;
            border-bottom: 1px dashed #d9e4f3;
        }

        .summary-block:last-of-type {
            border-bottom: none;
        }

        .summary-label {
            color: var(--text-soft);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-weight: 700;
        }

        .summary-value {
            color: var(--text-primary);
            font-weight: 600;
            margin-top: 5px;
            line-height: 1.55;
        }

        .seat-list {
            color: var(--primary-dark);
            font-weight: 650;
            margin-top: 6px;
            line-height: 1.6;
        }

        .guest-box {
            background: #f7faff;
            border: 1px solid #dbe7f7;
            border-radius: 18px;
            padding: 16px;
            margin-top: 16px;
        }

        .guest-box strong {
            display: block;
            margin-bottom: 8px;
            font-weight: 650;
        }

        .guest-box input {
            width: 100%;
            margin-top: 10px;
            padding: 12px 14px;
            border-radius: 14px;
            border: 1px solid #cad9f0;
            outline: none;
        }

        .helper-copy {
            color: var(--text-secondary);
            margin-top: 6px;
            line-height: 1.6;
        }

        .checkout-btn {
            width: 100%;
            border: none;
            border-radius: 18px;
            padding: 15px 18px;
            font-size: 16px;
            font-weight: 700;
            color: #fff;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            cursor: pointer;
            margin-top: 18px;
            box-shadow: 0 18px 32px -22px rgba(37, 99, 235, 0.7);
        }

        .checkout-btn:disabled {
            background: #c7d2e5;
            box-shadow: none;
            cursor: not-allowed;
        }

        @media (max-width: 980px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }
        }

        @media (max-width: 720px) {
            .page-wrap {
                padding: 0 14px;
            }

            .top-bar {
                padding: 20px;
            }

            .top-bar h1 {
                font-size: 24px;
            }

            .segment-head {
                flex-direction: column;
            }

            .segment-status {
                width: 100%;
                min-width: 0;
            }

            .segment-frame {
                padding: 14px;
            }

            .deck-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="fade-in">
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="page-wrap">
        <div class="page-panel top-bar">
            <h1>Chọn ghế cho hành trình của bạn</h1>
            <div class="top-meta">
                <span class="meta-pill">${adultCount} người lớn<c:if test="${childCount > 0}">, ${childCount} trẻ em</c:if></span>
                <span class="meta-pill">Tổng cộng ${passengerCount} hành khách</span>
                <c:if test="${not empty returnTrip}">
                    <span class="meta-pill">Khứ hồi</span>
                </c:if>
            </div>
        </div>

        <c:if test="${not empty param.error}">
            <div class="message">${param.error}</div>
        </c:if>

        <div class="layout">
            <div class="panel page-panel">
                <div class="segment-grid">
                    <div class="segment-card">
                        <div class="segment-head">
                            <div>
                                <h3 class="segment-title">Chuyến đi</h3>
                                <p class="segment-route">${trip.route.origin} - ${trip.route.destination} • <fmt:formatDate value="${trip.departureTime}" pattern="HH:mm dd/MM/yyyy" /></p>
                            </div>
                            <div class="segment-status">
                                <span>Đã chọn</span>
                                <strong id="count-outbound">0/${passengerCount}</strong>
                                <small>Ghế cho chặng đi</small>
                            </div>
                        </div>

                        <div class="segment-frame">
                            <div class="deck-grid">
                                <div class="deck">
                                    <div class="deck-head">
                                        <strong>Tầng trên</strong>
                                        <span>Dãy A</span>
                                    </div>
                                    <div class="seat-grid">
                                        <c:forEach begin="1" end="15" var="i">
                                            <c:set var="seatNum" value="A${i}" />
                                            <div class="seat ${bookedSeats.contains(seatNum) ? 'booked' : (preselectedOutboundSeats.contains(seatNum) ? 'selected' : '')}" onclick="toggleSeat(this, 'outbound', '${seatNum}')">${seatNum}</div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="deck">
                                    <div class="deck-head">
                                        <strong>Tầng dưới</strong>
                                        <span>Dãy B</span>
                                    </div>
                                    <div class="seat-grid">
                                        <c:forEach begin="1" end="15" var="i">
                                            <c:set var="seatNum" value="B${i}" />
                                            <div class="seat ${bookedSeats.contains(seatNum) ? 'booked' : (preselectedOutboundSeats.contains(seatNum) ? 'selected' : '')}" onclick="toggleSeat(this, 'outbound', '${seatNum}')">${seatNum}</div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty returnTrip}">
                        <div class="segment-card">
                            <div class="segment-head">
                                <div>
                                    <h3 class="segment-title">Chuyến về</h3>
                                    <p class="segment-route">${returnTrip.route.origin} - ${returnTrip.route.destination} • <fmt:formatDate value="${returnTrip.departureTime}" pattern="HH:mm dd/MM/yyyy" /></p>
                                </div>
                                <div class="segment-status">
                                    <span>Đã chọn</span>
                                    <strong id="count-return">0/${passengerCount}</strong>
                                    <small>Ghế cho chặng về</small>
                                </div>
                            </div>

                            <div class="segment-frame">
                                <div class="deck-grid">
                                    <div class="deck">
                                        <div class="deck-head">
                                            <strong>Tầng trên</strong>
                                            <span>Dãy A</span>
                                        </div>
                                        <div class="seat-grid">
                                            <c:forEach begin="1" end="15" var="i">
                                                <c:set var="seatNum" value="A${i}" />
                                                <div class="seat ${returnBookedSeats.contains(seatNum) ? 'booked' : (preselectedReturnSeats.contains(seatNum) ? 'selected' : '')}" onclick="toggleSeat(this, 'return', '${seatNum}')">${seatNum}</div>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="deck">
                                        <div class="deck-head">
                                            <strong>Tầng dưới</strong>
                                            <span>Dãy B</span>
                                        </div>
                                        <div class="seat-grid">
                                            <c:forEach begin="1" end="15" var="i">
                                                <c:set var="seatNum" value="B${i}" />
                                                <div class="seat ${returnBookedSeats.contains(seatNum) ? 'booked' : (preselectedReturnSeats.contains(seatNum) ? 'selected' : '')}" onclick="toggleSeat(this, 'return', '${seatNum}')">${seatNum}</div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <div class="legend">
                    <span><i style="background:#fff;border:1px solid #cad9f0;"></i> Còn trống</span>
                    <span><i style="background:linear-gradient(135deg,#2563eb,#1d4ed8);"></i> Đang chọn</span>
                    <span><i style="background:#e9eef6;"></i> Đã đặt</span>
                </div>
            </div>

            <div class="panel page-panel summary-card">
                <h2>Thông tin đặt vé</h2>

                <div class="summary-hero">
                    <span>Tổng tiền tạm tính</span>
                    <strong class="price-emphasis" id="display-total">0đ</strong>
                </div>

                <div class="summary-block">
                    <div class="summary-label">Hành khách</div>
                    <div class="summary-value">${adultCount} người lớn<c:if test="${childCount > 0}">, ${childCount} trẻ em</c:if></div>
                </div>

                <div class="summary-block">
                    <div class="summary-label">Chuyến đi</div>
                    <div class="summary-value">${trip.route.origin} - ${trip.route.destination}</div>
                    <div class="seat-list" id="display-outbound-seats">Chưa chọn ghế</div>
                </div>

                <c:if test="${not empty returnTrip}">
                    <div class="summary-block">
                        <div class="summary-label">Chuyến về</div>
                        <div class="summary-value">${returnTrip.route.origin} - ${returnTrip.route.destination}</div>
                        <div class="seat-list" id="display-return-seats">Chưa chọn ghế</div>
                    </div>
                </c:if>

                <div class="summary-block">
                    <div class="summary-label">Trạng thái chọn ghế</div>
                    <div class="summary-value">Cần chọn đủ ${passengerCount} ghế cho mỗi chặng để tiếp tục.</div>
                </div>

                <form action="booking" method="POST" id="bookingForm">
                    <input type="hidden" name="tripID" value="${trip.tripID}">
                    <input type="hidden" name="adultCount" value="${adultCount}">
                    <input type="hidden" name="childCount" value="${childCount}">
                    <input type="hidden" name="selectedSeats" id="input-outbound-seats">
                    <c:if test="${not empty returnTrip}">
                        <input type="hidden" name="returnTripID" value="${returnTrip.tripID}">
                        <input type="hidden" name="returnSeats" id="input-return-seats">
                    </c:if>

                    <c:if test="${empty sessionScope.user}">
                        <div class="guest-box">
                            <strong>Thông tin liên hệ</strong>
                            <input type="text" name="guestName" placeholder="Họ và tên" required>
                            <input type="text" name="guestPhone" placeholder="Số điện thoại" required>
                            <input type="email" name="guestEmail" placeholder="Email" required>
                        </div>
                    </c:if>

                    <div class="summary-label" style="margin-top:16px;">Yêu cầu</div>
                    <div class="helper-copy">Cần chọn đủ ${passengerCount} ghế cho mỗi chặng. Hệ thống sẽ giữ ghế bạn đã chọn khi chuyển sang bước thanh toán.</div>
                    <button type="submit" id="checkoutBtn" class="checkout-btn" disabled>Tiếp tục thanh toán</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        const requiredCount = ${passengerCount};
        const outboundPrice = ${trip.price};
        const returnPrice = ${not empty returnTrip ? returnTrip.price : 0};
        const hasReturn = ${not empty returnTrip};
        const outboundSeats = [];
        const returnSeats = [];

        <c:forEach items="${preselectedOutboundSeats}" var="seat">
            outboundSeats.push('${seat}');
        </c:forEach>
        <c:forEach items="${preselectedReturnSeats}" var="seat">
            returnSeats.push('${seat}');
        </c:forEach>

        function toggleSeat(el, type, seatNum) {
            if (el.classList.contains('booked')) return;

            const target = type === 'outbound' ? outboundSeats : returnSeats;
            if (el.classList.contains('selected')) {
                el.classList.remove('selected');
                const idx = target.indexOf(seatNum);
                if (idx >= 0) target.splice(idx, 1);
            } else {
                if (target.length >= requiredCount) {
                    alert('Bạn chỉ được chọn tối đa ' + requiredCount + ' ghế cho mỗi chặng.');
                    return;
                }
                el.classList.add('selected');
                target.push(seatNum);
            }
            updateSummary();
        }

        document.addEventListener('DOMContentLoaded', updateSummary);

        function updateSummary() {
            document.getElementById('display-outbound-seats').innerText = outboundSeats.length ? outboundSeats.join(', ') : 'Chưa chọn ghế';
            document.getElementById('input-outbound-seats').value = outboundSeats.join(',');
            document.getElementById('count-outbound').innerText = outboundSeats.length + '/' + requiredCount;

            if (hasReturn) {
                document.getElementById('display-return-seats').innerText = returnSeats.length ? returnSeats.join(', ') : 'Chưa chọn ghế';
                document.getElementById('input-return-seats').value = returnSeats.join(',');
                document.getElementById('count-return').innerText = returnSeats.length + '/' + requiredCount;
            }

            const total = (outboundSeats.length * outboundPrice) + (returnSeats.length * returnPrice);
            document.getElementById('display-total').innerText = total.toLocaleString('vi-VN') + 'đ';

            const valid = hasReturn
                ? outboundSeats.length === requiredCount && returnSeats.length === requiredCount
                : outboundSeats.length === requiredCount;
            document.getElementById('checkoutBtn').disabled = !valid;
        }
    </script>
</body>
</html>
