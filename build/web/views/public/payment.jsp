<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Payment - BusTicket</title>
            <link rel="stylesheet" href="assets/css/style.css">
            <style>
                .payment-container {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 80vh;
                }

                .payment-card {
                    background: white;
                    padding: 40px;
                    border-radius: 24px;
                    box-shadow: var(--shadow-lg);
                    text-align: center;
                    width: 400px;
                }

                .qr-image {
                    width: 100%;
                    border-radius: 12px;
                    margin: 20px 0;
                    border: 1px solid #eee;
                }

                .amount {
                    font-size: 32px;
                    font-weight: 700;
                    color: var(--primary-color);
                    margin: 10px 0;
                }

                .memo-box {
                    background: #f5f5f7;
                    padding: 10px;
                    border-radius: 8px;
                    font-family: monospace;
                    margin-bottom: 20px;
                    font-size: 14px;
                }
            </style>
        </head>

        <body class="fade-in">
            <jsp:include page="../common/header.jsp"></jsp:include>

            <div class="container payment-container">
                <div class="payment-card">
                    <h2 style="margin-bottom: 10px;">Scan to Pay</h2>
                    <p style="color: var(--text-secondary);">Open your banking app and scan the QR code.</p>

                    <img src="${qrURL}" alt="VietQR" class="qr-image">

                    <div class="amount">
                        <fmt:formatNumber value="${amount}" type="number" maxFractionDigits="0" /> VNĐ
                    </div>

                    <div class="memo-box">
                        Memo: <strong>${memo}</strong>
                    </div>

                    <form action="payment" method="POST" style="margin-bottom: 10px;">
                        <input type="hidden" name="bookingID" value="${bookingID}">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">I have completed VietQR payment</button>
                    </form>

                    <form action="stripe-checkout" method="POST">
                        <input type="hidden" name="bookingID" value="${bookingID}">
                        <button type="submit" class="btn btn-primary" style="width: 100%; background: #635bff; border-color: #635bff; font-weight: bold; margin-bottom: 20px;">
                            Pay securely with Stripe
                        </button>
                    </form>

                    <a href="payment?action=cancel&bookingID=${bookingID}"
                        style="display: block; margin-top: 20px; font-size: 14px; color: var(--text-secondary);"
                        onclick="return confirm('Are you sure you want to cancel this booking?');">Cancel
                        Payment</a>
                </div>
            </div>

            <script src="assets/js/main.js"></script>
        </body>

        </html>