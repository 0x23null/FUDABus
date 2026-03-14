<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Thanh toan - BusTicket</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .checkout-page {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            align-items: flex-start;
        }

        .payment-methods {
            background: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .payment-methods h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 24px;
            color: #333;
        }

        .method-item {
            display: flex;
            align-items: center;
            padding: 16px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 16px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .method-item:hover {
            border-color: var(--primary-color);
            background: #fdfaf2;
        }

        .method-item.active {
            border-color: var(--primary-color);
            background: #fdfaf2;
        }

        .method-item input[type="radio"] {
            margin-right: 16px;
            transform: scale(1.2);
            accent-color: var(--primary-color);
        }

        .method-icon {
            width: 40px;
            height: 40px;
            object-fit: contain;
            margin-right: 16px;
        }

        .vnpay-icon {
            background: #eff6ff;
            border-radius: 8px;
            padding: 4px;
        }

        .method-details h4 {
            margin: 0 0 4px 0;
            font-size: 16px;
            color: #333;
        }

        .method-details p {
            margin: 0;
            font-size: 13px;
            color: #666;
        }

        .total-pay-box {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px dashed #e0e0e0;
        }

        .total-pay-box p {
            font-size: 16px;
            color: #666;
            margin-bottom: 8px;
        }

        .total-pay-amount {
            font-size: 32px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .btn-checkout {
            width: 100%;
            height: 50px;
            background: var(--primary-color);
            color: white;
            font-size: 18px;
            font-weight: 600;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-checkout:hover {
            background: #d84500;
        }

        .info-panel {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .info-section {
            padding: 24px;
            border-bottom: 1px dashed #e0e0e0;
        }

        .info-section:last-child {
            border-bottom: none;
        }

        .info-section h3 {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            color: #666;
            flex: 1;
        }

        .info-value {
            font-weight: 500;
            color: #333;
            flex: 1;
            text-align: right;
            word-break: break-word;
        }

        .info-value-highlight {
            font-weight: 600;
            color: var(--primary-color);
        }
    </style>
</head>

<body class="fade-in">
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="checkout-page">
        <div class="payment-methods">
            <h3>Chon phuong thuc thanh toan</h3>

            <form id="paymentForm" method="POST">
                <input type="hidden" name="bookingID" value="${booking.bookingID}">

                <label class="method-item active">
                    <input type="radio" name="paymentMethod" value="vnpay" checked onchange="changeMethod(this)">
                    <img src="https://vnpay.vn/s1/statics.vnpay.vn/2023/6/0oxhzjmxbksr1686814746087.png" alt="VNPay" class="method-icon vnpay-icon">
                    <div class="method-details">
                        <h4>VNPay</h4>
                        <p>Thanh toan qua QR VNPay hoac the ATM/Internet Banking.</p>
                    </div>
                </label>

                <label class="method-item">
                    <input type="radio" name="paymentMethod" value="stripe" onchange="changeMethod(this)">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/b/ba/Stripe_Logo%2C_revised_2016.svg" alt="Stripe" class="method-icon" style="padding: 0 4px;">
                    <div class="method-details">
                        <h4>Stripe</h4>
                        <p>Thanh toan an toan bang the quoc te nhu Visa va Mastercard.</p>
                    </div>
                </label>

                <div class="total-pay-box">
                    <p>Tong thanh toan</p>
                    <div class="total-pay-amount">
                        <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" />d
                    </div>
                    <button type="button" class="btn-checkout" onclick="submitPayment()">Thanh toan</button>

                    <c:if test="${not empty param.error}">
                        <p style="color: red; margin-top: 15px; font-size: 14px;">
                            <c:choose>
                                <c:when test="${param.error == 'CannotCancel'}">Khong the huy don dat ve nay.</c:when>
                                <c:when test="${param.error == 'UnsupportedPaymentFlow'}">Phuong thuc thanh toan nay khong con duoc ho tro.</c:when>
                                <c:when test="${param.error == 'StripeVerificationFailed'}">Khong the xac minh giao dich Stripe.</c:when>
                                <c:when test="${param.error == 'PaymentFailed'}">Thanh toan chua thanh cong. Vui long thu lai.</c:when>
                                <c:when test="${param.error == 'InvalidHash'}">Chu ky thanh toan khong hop le.</c:when>
                                <c:otherwise>Thanh toan that bai hoac da bi huy. Vui long thu lai.</c:otherwise>
                            </c:choose>
                        </p>
                    </c:if>
                </div>
            </form>

            <form action="payment" method="POST" style="text-align: center; margin-top: 20px;"
                onsubmit="return confirm('Ban co chac chan muon huy don dat ve nay khong?');">
                <input type="hidden" name="bookingID" value="${booking.bookingID}">
                <input type="hidden" name="action" value="cancel">
                <button type="submit"
                    style="font-size: 14px; color: #ef4444; font-weight: 600; text-decoration: none; background: none; border: none; cursor: pointer;">
                    Huy thanh toan
                </button>
            </form>
        </div>

        <div class="info-panel">
            <div class="info-section">
                <h3>Thong tin hanh khach</h3>
                <div class="info-row">
                    <span class="info-label">Ho va ten</span>
                    <span class="info-value">${booking.user.fullName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">So dien thoai</span>
                    <span class="info-value">${booking.user.phoneNumber}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email</span>
                    <span class="info-value">${booking.user.email}</span>
                </div>
            </div>

            <div class="info-section">
                <h3>Thong tin chuyen di</h3>
                <div class="info-row">
                    <span class="info-label">Tuyen xe</span>
                    <span class="info-value">${booking.trip.route.origin} - ${booking.trip.route.destination}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Thoi gian xuat ben</span>
                    <span class="info-value-highlight">
                        <fmt:formatDate value="${booking.trip.departureTime}" pattern="HH:mm dd/MM/yyyy" />
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">So luong ghe</span>
                    <span class="info-value">${booking.bookedSeats.size()} ghe</span>
                </div>
                <div class="info-row">
                    <span class="info-label">So ghe</span>
                    <span class="info-value-highlight">
                        <c:forEach var="seat" items="${booking.bookedSeats}" varStatus="loop">
                            ${seat}${!loop.last ? ', ' : ''}
                        </c:forEach>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Loai xe</span>
                    <span class="info-value">${booking.trip.bus.busType}</span>
                </div>
            </div>

            <div class="info-section">
                <h3>Chi tiet gia</h3>
                <div class="info-row">
                    <span class="info-label">Gia ve</span>
                    <span class="info-value">
                        <fmt:formatNumber value="${booking.trip.price}" type="number" maxFractionDigits="0" />d
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label" style="font-weight: 600; color: #333;">Tong tien</span>
                    <span class="info-value" style="font-weight: 700; font-size: 18px; color: var(--primary-color);">
                        <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" />d
                    </span>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/main.js"></script>
    <script>
        function changeMethod(radio) {
            document.querySelectorAll('.method-item').forEach(el => el.classList.remove('active'));
            radio.closest('.method-item').classList.add('active');
        }

        function submitPayment() {
            const form = document.getElementById('paymentForm');
            const method = form.querySelector('input[name="paymentMethod"]:checked').value;

            if (method === 'vnpay') {
                form.action = 'vnpay-checkout';
            } else if (method === 'stripe') {
                form.action = 'stripe-checkout';
            }

            form.submit();
        }
    </script>
</body>

</html>
