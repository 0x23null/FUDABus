<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Thanh toán - FUDA Bus</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        body {
            background:
                radial-gradient(circle at top left, rgba(37, 99, 235, 0.08), transparent 34%),
                linear-gradient(180deg, #f8fbff 0%, #edf4fb 100%);
        }

        .payment-shell {
            max-width: 1180px;
            margin: 34px auto 88px;
            padding: 0 20px;
        }

        .payment-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.55fr) minmax(320px, 0.95fr);
            gap: 28px;
            align-items: start;
        }

        .payment-card,
        .summary-card {
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid rgba(212, 224, 241, 0.92);
            border-radius: 30px;
            box-shadow: 0 28px 64px -48px rgba(15, 23, 42, 0.28);
            backdrop-filter: blur(14px);
        }

        .payment-card {
            padding: 34px;
        }

        .summary-card {
            overflow: hidden;
        }

        .alert-banner {
            margin-bottom: 18px;
            border-radius: 18px;
            padding: 13px 16px;
            border: 1px solid #fecaca;
            background: #fff1f2;
            color: #be123c;
            font-weight: 600;
        }

        .payment-heading {
            margin-bottom: 26px;
        }

        .payment-heading h1 {
            margin: 8px 0 8px;
            font-size: 19px;
            line-height: 1.35;
        }

        .payment-heading p {
            margin: 0;
            color: var(--text-secondary);
            max-width: 520px;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: #eff6ff;
            color: var(--primary-dark);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .method-form {
            margin: 0;
        }

        .payment-options {
            display: grid;
            gap: 16px;
        }

        .payment-option {
            display: block;
        }

        .payment-option input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .option-shell {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 16px;
            align-items: center;
            padding: 22px 20px;
            border-radius: 22px;
            border: 1px solid #d7e4f6;
            background: #fff;
            transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
            cursor: pointer;
        }

        .payment-option:hover .option-shell {
            transform: translateY(-1px);
            border-color: #adc7ee;
            box-shadow: 0 22px 38px -34px rgba(37, 99, 235, 0.45);
        }

        .payment-option input:checked + .option-shell {
            border-color: #2563eb;
            background: linear-gradient(135deg, rgba(239, 246, 255, 0.98), rgba(248, 251, 255, 0.98));
            box-shadow: 0 24px 42px -34px rgba(37, 99, 235, 0.42);
        }

        .option-radio {
            width: 22px;
            height: 22px;
            border-radius: 50%;
            border: 2px solid #bfdbfe;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: border-color 0.2s ease, background 0.2s ease;
        }

        .option-radio::after {
            content: "";
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #2563eb;
            transform: scale(0);
            transition: transform 0.2s ease;
        }

        .payment-option input:checked + .option-shell .option-radio {
            border-color: #2563eb;
            background: rgba(37, 99, 235, 0.08);
        }

        .payment-option input:checked + .option-shell .option-radio::after {
            transform: scale(1);
        }

        .option-body {
            display: flex;
            align-items: center;
            gap: 18px;
            min-width: 0;
        }

        .payment-logo {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            border: 1px solid #dbe7f8;
            background: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.8);
            flex-shrink: 0;
        }

        .payment-logo span {
            font-weight: 800;
            letter-spacing: -0.03em;
        }

        .payment-logo.vnpay span {
            color: #0f6dcd;
        }

        .payment-logo.stripe span {
            color: #635bff;
            text-transform: lowercase;
        }

        .option-copy strong {
            display: block;
            margin-bottom: 6px;
            color: var(--text-primary);
            font-size: 16px;
            font-weight: 700;
        }

        .option-copy p {
            margin: 0;
            color: var(--text-secondary);
            line-height: 1.6;
        }

        .payment-divider {
            margin: 30px 0 24px;
            border: 0;
            border-top: 1px dashed #d7e4f6;
        }

        .payment-total {
            text-align: center;
        }

        .payment-total span {
            display: block;
            margin-bottom: 10px;
            color: var(--text-secondary);
            font-size: 15px;
        }

        .payment-total strong {
            display: block;
            font-size: clamp(34px, 5vw, 44px);
        }

        .payment-actions {
            margin-top: 26px;
            display: grid;
            gap: 14px;
        }

        .pay-submit {
            width: 100%;
            min-height: 62px;
            border: none;
            border-radius: 999px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
        }

        .cancel-form {
            margin: 0;
            text-align: center;
        }

        .cancel-form button {
            border: none;
            background: transparent;
            color: #ef4444;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            padding: 6px 0;
        }

        .summary-header {
            padding: 28px 28px 18px;
            background: linear-gradient(180deg, rgba(239, 246, 255, 0.9), rgba(255, 255, 255, 0.96));
            border-bottom: 1px solid #e3edf9;
        }

        .summary-header h2 {
            margin: 10px 0 8px;
            font-size: 18px;
        }

        .summary-header p {
            margin: 0;
            color: var(--text-secondary);
            line-height: 1.6;
        }

        .summary-block {
            padding: 24px 28px;
        }

        .summary-block + .summary-block {
            border-top: 1px dashed #d8e4f5;
        }

        .summary-block h3 {
            margin: 0 0 18px;
            font-size: 16px;
            font-weight: 700;
            color: var(--text-primary);
        }

        .detail-list {
            display: grid;
            gap: 14px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
        }

        .detail-row span {
            color: var(--text-secondary);
        }

        .detail-row strong {
            color: var(--text-primary);
            font-weight: 650;
            text-align: right;
        }

        .detail-row strong.link-tone {
            color: var(--primary-dark);
        }

        .segment-card {
            border: 1px solid #dbe7f8;
            border-radius: 22px;
            padding: 18px;
            background: linear-gradient(180deg, #ffffff 0%, #f9fbff 100%);
        }

        .segment-card + .segment-card {
            margin-top: 14px;
        }

        .segment-card-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 16px;
        }

        .segment-card-head strong {
            display: block;
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .segment-card-head span {
            color: var(--text-secondary);
            font-size: 14px;
        }

        .segment-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            border-radius: 999px;
            background: #eff6ff;
            color: var(--primary-dark);
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .segment-meta {
            display: grid;
            gap: 12px;
        }

        .segment-meta .detail-row strong {
            max-width: 62%;
        }

        .price-summary strong {
            font-size: 15px;
        }

        .price-summary .grand-total {
            padding-top: 14px;
            margin-top: 4px;
            border-top: 1px solid #e4edf8;
        }

        .price-summary .grand-total strong {
            font-size: 18px;
        }

        @media (max-width: 960px) {
            .payment-layout {
                grid-template-columns: 1fr;
            }

        }

        @media (max-width: 720px) {
            .payment-shell {
                margin: 24px auto 64px;
                padding: 0 14px;
            }

            .payment-card,
            .summary-card {
                border-radius: 24px;
            }

            .payment-card {
                padding: 24px 20px;
            }

            .payment-heading,
            .segment-card-head,
            .detail-row {
                flex-direction: column;
                align-items: flex-start;
            }

            .detail-row strong,
            .segment-meta .detail-row strong {
                max-width: none;
                text-align: left;
            }

            .option-shell {
                padding: 18px 16px;
            }

            .option-body {
                gap: 14px;
            }

            .summary-header,
            .summary-block {
                padding-left: 20px;
                padding-right: 20px;
            }
        }
    </style>
</head>
<body class="fade-in">
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="payment-shell">
        <c:if test="${not empty param.error}">
            <div class="alert-banner">Có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại.</div>
        </c:if>

        <div class="payment-layout">
            <section class="payment-card">
                <div class="payment-heading">
                    <span class="eyebrow">Bước cuối cùng</span>
                    <h1>Chọn phương thức thanh toán</h1>
                    <p>Kiểm tra lại thông tin và chọn cổng thanh toán phù hợp để hoàn tất đơn vé của bạn.</p>
                </div>

                <form id="paymentMethodForm" class="method-form" method="POST" action="stripe-checkout">
                    <input type="hidden" name="bookingID" value="${booking.bookingID}">

                    <div class="payment-options">
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="vnpay">
                            <span class="option-shell">
                                <span class="option-radio" aria-hidden="true"></span>
                                <span class="option-body">
                                    <span class="payment-logo vnpay">
                                        <span>VNPay</span>
                                    </span>
                                    <span class="option-copy">
                                        <strong>VNPay</strong>
                                        <p>Thanh toán qua mã QR VNPay hoặc thẻ ATM/Internet Banking nội địa.</p>
                                    </span>
                                </span>
                            </span>
                        </label>

                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="stripe" checked>
                            <span class="option-shell">
                                <span class="option-radio" aria-hidden="true"></span>
                                <span class="option-body">
                                    <span class="payment-logo stripe">
                                        <span>stripe</span>
                                    </span>
                                    <span class="option-copy">
                                        <strong>Stripe</strong>
                                        <p>Thanh toán an toàn bằng thẻ tín dụng quốc tế như Visa hoặc Mastercard.</p>
                                    </span>
                                </span>
                            </span>
                        </label>
                    </div>

                    <hr class="payment-divider">

                    <div class="payment-total">
                        <span>Tổng thanh toán</span>
                        <strong class="price-emphasis"><fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" />đ</strong>
                    </div>

                    <div class="payment-actions">
                        <button type="submit" class="btn btn-primary pay-submit">Thanh toán</button>
                    </div>
                </form>

                <form action="payment" method="POST" class="cancel-form">
                    <input type="hidden" name="bookingID" value="${booking.bookingID}">
                    <input type="hidden" name="action" value="cancel">
                    <button type="submit">Hủy thanh toán</button>
                </form>
            </section>

            <aside class="summary-card">
                <div class="summary-header">
                    <span class="eyebrow">Tóm tắt đơn vé</span>
                    <h2>Thông tin thanh toán</h2>
                    <p>Mọi chi tiết hành khách, chuyến đi và giá tiền được gom lại để bạn kiểm tra nhanh.</p>
                </div>

                <section class="summary-block">
                    <h3>Thông tin hành khách</h3>
                    <div class="detail-list">
                        <div class="detail-row">
                            <span>Họ và tên</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty booking.user and not empty booking.user.fullName}">${booking.user.fullName}</c:when>
                                    <c:otherwise>Khách đặt vé</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div class="detail-row">
                            <span>Số điện thoại</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty booking.user and not empty booking.user.phoneNumber}">${booking.user.phoneNumber}</c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div class="detail-row">
                            <span>Email</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty booking.user and not empty booking.user.email}">${booking.user.email}</c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div class="detail-row">
                            <span>Hành khách</span>
                            <strong>${booking.adultCount} người lớn<c:if test="${booking.childCount > 0}">, ${booking.childCount} trẻ em</c:if></strong>
                        </div>
                        <c:if test="${booking.childCount > 0}">
                            <div class="detail-row">
                                <span>Giá trẻ em</span>
                                <strong>70% giá vé người lớn</strong>
                            </div>
                        </c:if>
                    </div>
                </section>

                <section class="summary-block">
                    <h3>Thông tin chuyến đi</h3>
                    <c:choose>
                        <c:when test="${not empty booking.segments}">
                            <c:forEach items="${booking.segments}" var="segment">
                                <div class="segment-card">
                                    <div class="segment-card-head">
                                        <div>
                                            <strong>${segment.trip.route.origin} - ${segment.trip.route.destination}</strong>
                                            <span>${segment.displayType}</span>
                                        </div>
                                        <span class="segment-badge">${fn:length(segment.seatNumbers)} ghế</span>
                                    </div>

                                    <div class="segment-meta">
                                        <div class="detail-row">
                                            <span>Thời gian xuất bến</span>
                                            <strong class="link-tone"><fmt:formatDate value="${segment.trip.departureTime}" pattern="HH:mm dd/MM/yyyy" /></strong>
                                        </div>
                                        <div class="detail-row">
                                            <span>Số ghế</span>
                                            <strong>
                                                <c:forEach items="${segment.seatNumbers}" var="seat" varStatus="loop">
                                                    ${seat}<c:if test="${!loop.last}">, </c:if>
                                                </c:forEach>
                                            </strong>
                                        </div>
                                        <div class="detail-row">
                                            <span>Loại xe</span>
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${not empty segment.trip.bus and not empty segment.trip.bus.busType}">${segment.trip.bus.busType}</c:when>
                                                    <c:otherwise>Đang cập nhật</c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="segment-card">
                                <div class="segment-card-head">
                                    <div>
                                        <strong>${booking.trip.route.origin} - ${booking.trip.route.destination}</strong>
                                        <span>Chuyến đi</span>
                                    </div>
                                    <span class="segment-badge">${fn:length(booking.bookedSeats)} ghế</span>
                                </div>

                                <div class="segment-meta">
                                    <div class="detail-row">
                                        <span>Thời gian xuất bến</span>
                                        <strong class="link-tone"><fmt:formatDate value="${booking.trip.departureTime}" pattern="HH:mm dd/MM/yyyy" /></strong>
                                    </div>
                                    <div class="detail-row">
                                        <span>Số ghế</span>
                                        <strong>
                                            <c:forEach items="${booking.bookedSeats}" var="seat" varStatus="loop">
                                                ${seat}<c:if test="${!loop.last}">, </c:if>
                                            </c:forEach>
                                        </strong>
                                    </div>
                                    <div class="detail-row">
                                        <span>Loại xe</span>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty booking.trip.bus and not empty booking.trip.bus.busType}">${booking.trip.bus.busType}</c:when>
                                                <c:otherwise>Đang cập nhật</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section class="summary-block price-summary">
                    <h3>Chi tiết giá</h3>
                    <div class="detail-list">
                        <c:choose>
                            <c:when test="${not empty booking.segments}">
                                <c:forEach items="${booking.segments}" var="segment">
                                    <div class="detail-row">
                                        <span>${segment.displayType}</span>
                                        <strong><fmt:formatNumber value="${segment.totalPrice}" type="number" maxFractionDigits="0" />đ</strong>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="detail-row">
                                    <span>Giá vé</span>
                                    <strong><fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" />đ</strong>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="detail-row grand-total">
                            <span>Tổng tiền</span>
                            <strong class="price-emphasis"><fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" />đ</strong>
                        </div>
                    </div>
                </section>
            </aside>
        </div>
    </div>

    <script>
        (function() {
            const paymentForm = document.getElementById("paymentMethodForm");
            if (!paymentForm) {
                return;
            }

            const actions = {
                stripe: "stripe-checkout",
                vnpay: "vnpay-checkout"
            };

            const methodInputs = Array.from(paymentForm.querySelectorAll('input[name="paymentMethod"]'));

            const syncFormAction = () => {
                const selected = methodInputs.find((input) => input.checked);
                paymentForm.action = actions[selected ? selected.value : "stripe"] || "stripe-checkout";
            };

            methodInputs.forEach((input) => {
                input.addEventListener("change", syncFormAction);
            });

            syncFormAction();
        })();
    </script>
    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
