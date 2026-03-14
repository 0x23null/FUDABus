<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Thanh Toán - BusTicket</title>
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

        /* Left Panel */
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

        /* Center total (shown on left panel at bottom) */
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

        /* Right Panel */
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
        <!-- Phương thức thanh toán -->
        <div class="payment-methods">
            <h3>Chọn phương thức thanh toán</h3>
            
            <form id="paymentForm" method="POST">
                <input type="hidden" name="bookingID" value="${booking.bookingID}">
                <input type="hidden" name="amount" value="${booking.totalPrice}">

                <label class="method-item active">
                    <input type="radio" name="paymentMethod" value="vnpay" checked onchange="changeMethod(this)">
                    <img src="https://vnpay.vn/s1/statics.vnpay.vn/2023/6/0oxhzjmxbksr1686814746087.png" alt="VNPay" class="method-icon vnpay-icon">
                    <div class="method-details">
                        <h4>VNPay</h4>
                        <p>Thanh toán qua mã QR VNPay hoặc thẻ ATM/Internet Banking.</p>
                    </div>
                </label>

                <label class="method-item">
                    <input type="radio" name="paymentMethod" value="stripe" onchange="changeMethod(this)">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/b/ba/Stripe_Logo%2C_revised_2016.svg" alt="Stripe" class="method-icon" style="padding: 0 4px;">
                    <div class="method-details">
                        <h4>Stripe</h4>
                        <p>Thanh toán an toàn bằng thẻ tín dụng quốc tế (Visa, Mastercard, etc.).</p>
                    </div>
                </label>

                <div class="total-pay-box">
                    <p>Tổng thanh toán</p>
                    <div class="total-pay-amount">
                        <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" />đ
                    </div>
                    <button type="button" class="btn-checkout" onclick="submitPayment()">Thanh Toán</button>
                    
                    <c:if test="${not empty param.error}">
                        <p style="color: red; margin-top: 15px; font-size: 14px;">Thanh toán thất bại hoặc đã bị hủy. Vui lòng thử lại.</p>
                    </c:if>
                </div>
            </form>
            
             <div style="text-align: center; margin-top: 20px;">
                <a href="payment?action=cancel&bookingID=${booking.bookingID}"
                    style="font-size: 14px; color: #ef4444; font-weight: 600; text-decoration: none;"
                    onclick="return confirm('Bạn có chắc chắn muốn hủy đặt vé này không?');">Hủy thanh toán</a>
            </div>
        </div>

        <!-- Thông tin chi tiết -->
        <div class="info-panel">
            <div class="info-section">
                <h3>Thông tin hành khách</h3>
                <div class="info-row">
                    <span class="info-label">Họ và tên</span>
                    <span class="info-value">${booking.user.fullName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Số điện thoại</span>
                    <span class="info-value">${booking.user.phoneNumber}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email</span>
                    <span class="info-value">${booking.user.email}</span>
                </div>
            </div>

            <div class="info-section">
                <h3>Thông tin chuyến đi</h3>
                <div class="info-row">
                    <span class="info-label">Tuyến xe</span>
                    <span class="info-value">${booking.trip.route.origin} - ${booking.trip.route.destination}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Thời gian xuất bến</span>
                    <span class="info-value-highlight">
                        <fmt:formatDate value="${booking.trip.departureTime}" pattern="HH:mm dd/MM/yyyy" />
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Số lượng ghế</span>
                    <span class="info-value">${booking.bookedSeats.size()} Ghế</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Số ghế</span>
                    <span class="info-value-highlight">
                        <c:forEach var="seat" items="${booking.bookedSeats}" varStatus="loop">
                            ${seat}${!loop.last ? ', ' : ''}
                        </c:forEach>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Loại xe</span>
                    <span class="info-value">${booking.trip.bus.busType}</span>
                </div>
            </div>

            <div class="info-section">
                <h3>Chi tiết giá</h3>
                <div class="info-row">
                    <span class="info-label">Giá vé</span>
                    <span class="info-value">
                        <fmt:formatNumber value="${booking.trip.price}" type="number" maxFractionDigits="0" />đ
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label" style="font-weight: 600; color: #333;">Tổng tiền</span>
                    <span class="info-value" style="font-weight: 700; font-size: 18px; color: var(--primary-color);">
                        <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" />đ
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