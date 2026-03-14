<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>FUDA Bus</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        body {
            background:
                radial-gradient(circle at top left, rgba(37, 99, 235, 0.16), transparent 28%),
                radial-gradient(circle at top right, rgba(14, 165, 233, 0.14), transparent 30%),
                linear-gradient(180deg, #f7faff 0%, #eff5fd 100%);
            overflow-x: hidden;
        }

        .home-shell {
            padding-bottom: 0;
        }

        .alerts {
            margin: 18px auto 0;
            max-width: 1180px;
            padding: 0 24px;
        }

        .alert {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            border-radius: 18px;
            padding: 14px 16px;
            margin-bottom: 12px;
            border: 1px solid transparent;
            background: #fff;
            box-shadow: var(--shadow-sm);
        }

        .alert.error {
            border-color: #fecaca;
            background: #fff5f5;
            color: #b91c1c;
        }

        .alert.success {
            border-color: #bbf7d0;
            background: #f0fdf4;
            color: #166534;
        }

        .hero {
            padding: 28px 0 26px;
        }

        .hero-card {
            position: relative;
            overflow: hidden;
            border-radius: 38px;
            padding: 44px;
            background:
                linear-gradient(138deg, rgba(11, 47, 52, 0.94) 0%, rgba(15, 118, 110, 0.9) 58%, rgba(45, 212, 191, 0.72) 100%),
                url('${pageContext.request.contextPath}/assets/images/bus_home.png?v=2') center/cover no-repeat;
            color: #f8fbff;
            box-shadow: 0 34px 80px -40px rgba(20, 33, 61, 0.45);
        }

        .hero-card::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 20% 20%, rgba(255, 255, 255, 0.22), transparent 24%),
                linear-gradient(120deg, rgba(255, 255, 255, 0.08), transparent 40%, rgba(255, 255, 255, 0.04));
            pointer-events: none;
        }

        .hero-grid {
            position: relative;
            z-index: 1;
            display: grid;
            grid-template-columns: minmax(0, 0.96fr) minmax(420px, 0.9fr);
            gap: 24px;
            align-items: end;
        }

        .hero-copy {
            max-width: 520px;
            align-self: stretch;
            padding-top: 8px;
            display: flex;
            flex-direction: column;
            min-height: 100%;
        }

        .hero-pill {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            align-self: flex-start;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.22);
            padding: 9px 14px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
        }

        .hero-title {
            margin: 18px 0 16px;
            font-size: clamp(40px, 5.2vw, 64px);
            line-height: 1.03;
            color: #fff;
            max-width: 10.8ch;
        }

        .hero-title span {
            color: #ccfbf1;
        }

        .hero-text {
            max-width: 500px;
            color: rgba(255, 255, 255, 0.82);
            font-size: 14px;
            line-height: 1.7;
            margin: 0 0 8px;
        }

        .hero-text:last-of-type {
            margin-bottom: 0;
        }

        .hero-stats {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 10px;
            max-width: 560px;
            margin-top: auto;
            padding-top: 52px;
        }

        .hero-stat {
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.15);
            padding: 11px 12px;
            backdrop-filter: blur(10px);
        }

        .hero-stat strong {
            display: block;
            font-size: 17px;
            margin-bottom: 2px;
            color: #fff;
            font-weight: 700;
        }

        .hero-stat span {
            color: rgba(255, 255, 255, 0.7);
            font-size: 12px;
            line-height: 1.45;
        }

        .booking-card {
            align-self: stretch;
            border-radius: 30px;
            background: rgba(255, 255, 255, 0.95);
            color: var(--text-primary);
            padding: 24px;
            border: 1px solid rgba(226, 235, 248, 0.9);
            box-shadow: 0 24px 50px -34px rgba(20, 33, 61, 0.35);
            min-height: 542px;
        }

        .booking-head {
            display: flex;
            justify-content: flex-start;
            gap: 14px;
            align-items: flex-start;
            margin-bottom: 18px;
        }

        .type-switch {
            display: inline-flex;
            padding: 4px;
            border-radius: 999px;
            background: #eef3fb;
            gap: 4px;
        }

        .type-switch label {
            cursor: pointer;
        }

        .type-switch input {
            display: none;
        }

        .type-switch span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 116px;
            border-radius: 999px;
            padding: 10px 14px;
            font-size: 13px;
            font-weight: 650;
            color: var(--text-soft);
            transition: background-color 0.22s ease, color 0.22s ease, box-shadow 0.22s ease;
        }

        .type-switch input:checked + span {
            background: #fff;
            color: var(--primary-dark);
            box-shadow: 0 12px 24px -20px rgba(20, 33, 61, 0.3);
        }

        .booking-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
        }

        .route-fields {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 10px;
            grid-column: 1 / -1;
        }

        .date-row {
            grid-column: 1 / -1;
            display: flex;
            gap: 0;
            align-items: stretch;
            height: 84px;
            min-height: 84px;
            overflow: hidden;
            width: 100%;
        }

        .date-row.is-round-trip {
            gap: 12px;
        }

        .date-field {
            min-width: 0;
            height: 84px;
            min-height: 84px;
            transition: flex-basis 0.32s ease, width 0.32s ease;
        }

        .date-field.departure {
            flex: 1 1 100%;
            width: 100%;
            max-width: 100%;
        }

        .date-row.is-round-trip .date-field.departure {
            flex-basis: calc(50% - 6px);
        }

        .return-field-shell {
            min-width: 0;
            flex: 0 0 0;
            width: 0;
            height: 84px;
            min-height: 84px;
            overflow: hidden;
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
            transform: translateX(10px);
            transition: flex-basis 0.32s ease, width 0.32s ease, opacity 0.22s ease, transform 0.32s ease, visibility 0s linear 0.32s;
        }

        .return-field-shell.is-visible {
            flex: 1 1 calc(50% - 6px);
            width: auto;
            height: 84px;
            opacity: 1;
            visibility: visible;
            pointer-events: auto;
            transform: translateX(0);
            transition: flex-basis 0.32s ease, width 0.32s ease, opacity 0.22s ease, transform 0.32s ease;
        }

        .field {
            border-radius: 20px;
            border: 1px solid #dbe6f4;
            background: #fbfdff;
            padding: 14px 16px;
            height: 84px;
            min-height: 84px;
        }

        .field label {
            display: block;
            color: var(--text-soft);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 7px;
        }

        .field input,
        .field .flatpickr-input {
            width: 100%;
            border: none;
            background: transparent;
            color: var(--text-primary);
            outline: none;
            font-weight: 600;
            min-height: 24px;
            padding: 0;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .swap-button {
            align-self: center;
            width: 42px;
            height: 42px;
            border-radius: 50%;
            border: 1px solid #d7e4f6;
            background: #fff;
            color: var(--primary-color);
            cursor: pointer;
            transition: transform 0.24s ease, border-color 0.24s ease, box-shadow 0.24s ease;
        }

        .swap-button:hover {
            transform: rotate(180deg);
            border-color: #a9c5f1;
            box-shadow: 0 18px 28px -22px rgba(37, 99, 235, 0.5);
        }

        .passenger-card {
            display: grid;
            gap: 10px;
            height: auto;
            min-height: 0;
        }

        .field.passenger-card {
            height: auto;
            min-height: 152px;
        }

        .passenger-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            font-weight: 650;
        }

        .passenger-rows {
            display: grid;
            gap: 10px;
        }

        .passenger-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .passenger-meta strong {
            display: block;
            font-size: 14px;
            font-weight: 650;
        }

        .passenger-meta span {
            color: var(--text-secondary);
            font-size: 13px;
        }

        .counter {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            border-radius: 999px;
            background: #eef4fd;
            padding: 6px;
        }

        .counter button {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            border: none;
            background: #fff;
            color: var(--primary-color);
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 12px 18px -18px rgba(20, 33, 61, 0.4);
        }

        .counter span {
            min-width: 18px;
            text-align: center;
            font-weight: 650;
        }

        .booking-foot {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            align-items: center;
            margin-top: 18px;
        }

        .booking-note {
            color: var(--text-secondary);
            font-size: 13px;
            max-width: 230px;
        }

        .booking-submit {
            border: none;
            border-radius: 999px;
            padding: 14px 24px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: #fff;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 20px 34px -22px rgba(37, 99, 235, 0.78);
            transition: transform 0.22s ease, box-shadow 0.22s ease;
        }

        .booking-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 22px 34px -20px rgba(29, 78, 216, 0.75);
        }

        .why-section {
            margin-top: 30px;
            padding: 72px 0 48px;
            background: rgba(255, 255, 255, 0.72);
            border-top: 1px solid rgba(220, 230, 244, 0.8);
            border-bottom: 1px solid rgba(220, 230, 244, 0.8);
        }

        .why-head {
            text-align: center;
            margin-bottom: 56px;
        }

        .why-head h2 {
            margin: 0;
            font-size: 36px;
        }

        .why-head p {
            margin-top: 12px;
            color: var(--text-secondary);
            font-size: 17px;
        }

        .why-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 28px;
        }

        .why-card {
            text-align: center;
            padding: 8px 18px;
        }

        .why-icon {
            width: 88px;
            height: 88px;
            margin: 0 auto 26px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
        }

        .why-icon.safe {
            background: #e7efff;
            color: #4f46e5;
        }

        .why-icon.support {
            background: #e3f7f2;
            color: #10b981;
        }

        .why-icon.price {
            background: #fff3dd;
            color: #f59e0b;
        }

        .why-card h3 {
            margin: 0 0 14px;
            font-size: 24px;
            font-weight: 700;
        }

        .why-card p {
            max-width: 320px;
            margin: 0 auto;
            color: #6b7c97;
            font-size: 17px;
            line-height: 1.8;
        }

        .flatpickr-calendar {
            border: 1px solid var(--border-color);
            border-radius: 18px;
            box-shadow: var(--shadow-lg);
            font-family: inherit;
        }

        .flatpickr-day.selected,
        .flatpickr-day.startRange,
        .flatpickr-day.endRange {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }

        .flatpickr-day.today {
            border-color: var(--accent-color);
        }

        .hero .reveal {
            opacity: 1;
            transform: none;
            transition: none;
        }

        @media (max-width: 1024px) {
            .hero-grid,
            .why-grid {
                grid-template-columns: 1fr;
            }

            .hero-card {
                padding: 28px;
            }
        }

        @media (max-width: 720px) {
            .hero {
                padding-top: 18px;
            }

            .hero-card {
                padding: 22px;
                border-radius: 28px;
            }

            .hero-stats,
            .booking-grid {
                grid-template-columns: 1fr;
            }

            .booking-card {
                min-height: unset;
            }

            .date-row,
            .date-row.is-round-trip {
                flex-direction: column;
                height: auto;
                min-height: unset;
                overflow: visible;
            }

            .date-field.departure,
            .date-row.is-round-trip .date-field.departure,
            .return-field-shell,
            .return-field-shell.is-visible {
                flex-basis: auto;
                width: 100%;
                height: auto;
                min-height: 84px;
            }

            .route-fields {
                grid-template-columns: 1fr;
            }

            .swap-button {
                justify-self: center;
                transform: rotate(90deg);
            }

            .swap-button:hover {
                transform: rotate(270deg);
            }

            .booking-foot,
            .why-head {
                flex-direction: column;
                align-items: stretch;
            }

            .booking-submit {
                width: 100%;
            }

            .alerts {
                padding: 0 16px;
            }

            .why-section {
                padding: 56px 0 36px;
            }

            .why-head {
                margin-bottom: 40px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="alerts">
        <c:if test="${param.error == 'TripExpired'}">
            <div class="alert error">
                <i class="fas fa-circle-exclamation"></i>
                <div>Chuyến xe bạn vừa chọn đã qua giờ khởi hành. Vui lòng chọn chuyến khác phù hợp hơn.</div>
            </div>
        </c:if>
        <c:if test="${param.error == 'AccessDenied'}">
            <div class="alert error">
                <i class="fas fa-lock"></i>
                <div>Bạn không có quyền truy cập vào nội dung đó.</div>
            </div>
        </c:if>
        <c:if test="${param.msg == 'BookingCancelled'}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i>
                <div>Đơn đặt vé đã được hủy thành công.</div>
            </div>
        </c:if>
    </div>

    <main class="home-shell">
        <section class="hero">
            <div class="container">
                <div class="hero-card">
                    <div class="hero-grid">
                        <div class="hero-copy">
                            <div class="hero-pill reveal is-visible">
                                <i class="fas fa-ticket-alt"></i>
                                Bus ngay hành trình của bạn
                            </div>
                            <h1 class="hero-title reveal is-visible">Vé xe trong tay <span>Đi ngay bây giờ!</span></h1>
                            <p class="hero-text">Tra cứu tuyến, chọn ngày đi và số hành khách ngay trên một khung đặt vé duy nhất.</p>
                            <p class="hero-text">Sơ đồ ghế và bước thanh toán được hiển thị rõ ngay từ đầu để bạn thao tác nhanh hơn.</p>

                            <div class="hero-stats">
                                <div class="hero-stat reveal">
                                    <strong>Chọn ghế</strong>
                                    <span>Xem sơ đồ ghế trước khi xác nhận đặt vé</span>
                                </div>
                                <div class="hero-stat reveal">
                                    <strong>Khứ hồi</strong>
                                    <span>Đặt cả lượt đi và lượt về trong một lần</span>
                                </div>
                                <div class="hero-stat reveal">
                                    <strong>Thanh toán</strong>
                                    <span>Hỗ trợ Stripe và VNPay ngay trên hệ thống</span>
                                </div>
                            </div>
                        </div>

                        <form action="search" method="GET" class="booking-card reveal is-visible" id="search-form">
                            <div class="booking-head">
                                <div class="type-switch">
                                    <label>
                                        <input type="radio" name="tripType" value="oneWay" checked onchange="toggleReturnDate(false)">
                                        <span>Một chiều</span>
                                    </label>
                                    <label>
                                        <input type="radio" name="tripType" value="roundTrip" onchange="toggleReturnDate(true)">
                                        <span>Khứ hồi</span>
                                    </label>
                                </div>
                            </div>

                            <div class="booking-grid">
                                <div class="route-fields">
                                    <div class="field">
                                        <label>Điểm đi</label>
                                        <input type="text" name="origin" list="locationsList" placeholder="Ví dụ: Hà Nội" required>
                                    </div>
                                    <button type="button" class="swap-button" onclick="swapLocations()" aria-label="Đổi điểm đi và điểm đến">
                                        <i class="fas fa-arrow-right-arrow-left"></i>
                                    </button>
                                    <div class="field">
                                        <label>Điểm đến</label>
                                        <input type="text" name="destination" list="locationsList" placeholder="Ví dụ: Đà Nẵng" required>
                                    </div>
                                </div>

                                <div class="date-row" id="dateRow">
                                    <div class="field date-field departure" id="departureField">
                                        <label>Ngày đi</label>
                                        <input type="text" name="date" id="departureDate" placeholder="Chọn ngày đi" autocomplete="off" required>
                                    </div>

                                    <div class="return-field-shell" id="returnDateShell">
                                        <div class="field">
                                            <label>Ngày về</label>
                                            <input type="text" name="returnDate" id="returnDate" placeholder="Chọn ngày về" autocomplete="off">
                                        </div>
                                    </div>
                                </div>

                                <div class="field full passenger-card">
                                    <div class="passenger-summary">
                                        <span>Hành khách</span>
                                        <span id="passengerSummary">1 người lớn</span>
                                    </div>

                                    <div class="passenger-rows">
                                        <div class="passenger-row">
                                            <div class="passenger-meta">
                                                <strong>Người lớn</strong>
                                                <span>Từ 12 tuổi trở lên</span>
                                            </div>
                                            <div class="counter">
                                                <button type="button" onclick="changeCount('adult', -1)">-</button>
                                                <span id="adultDisplay">1</span>
                                                <button type="button" onclick="changeCount('adult', 1)">+</button>
                                            </div>
                                        </div>

                                        <div class="passenger-row">
                                            <div class="passenger-meta">
                                                <strong>Trẻ em</strong>
                                                <span>Cần đặt ghế riêng</span>
                                            </div>
                                            <div class="counter">
                                                <button type="button" onclick="changeCount('child', -1)">-</button>
                                                <span id="childDisplay">0</span>
                                                <button type="button" onclick="changeCount('child', 1)">+</button>
                                            </div>
                                        </div>
                                    </div>

                                    <input type="hidden" name="adultCount" id="adultInput" value="1">
                                    <input type="hidden" name="childCount" id="childInput" value="0">
                                </div>
                            </div>

                            <div class="booking-foot">
                                <div class="booking-note"></div>
                                <button type="submit" class="booking-submit">Tìm chuyến xe</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>

        <section class="why-section">
            <div class="container">
                <div class="why-head reveal">
                    <h2>Tại sao chọn Vivu?</h2>
                    <p>Chúng tôi mang đến trải nghiệm tốt nhất cho hành trình của bạn</p>
                </div>

                <div class="why-grid">
                    <article class="why-card reveal">
                        <div class="why-icon safe">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3>An Toàn Tuyệt Đối</h3>
                        <p>Sự an toàn của bạn là ưu tiên hàng đầu. Chúng tôi hợp tác với các nhà xe uy tín nhất toàn quốc.</p>
                    </article>
                    <article class="why-card reveal">
                        <div class="why-icon support">
                            <i class="fas fa-headset"></i>
                        </div>
                        <h3>Hỗ Trợ 24/7</h3>
                        <p>Đội ngũ chăm sóc khách hàng luôn sẵn sàng hỗ trợ bạn mọi lúc, mọi nơi, giải quyết mọi thắc mắc.</p>
                    </article>
                    <article class="why-card reveal">
                        <div class="why-icon price">
                            <i class="fas fa-tags"></i>
                        </div>
                        <h3>Giá Tốt Nhất</h3>
                        <p>Mức giá cạnh tranh và các chương trình khuyến mãi thường xuyên giúp bạn tiết kiệm chi phí.</p>
                    </article>
                </div>
            </div>
        </section>
    </main>

    <datalist id="locationsList">
        <option value="Hà Nội">
        <option value="Hồ Chí Minh">
        <option value="Đà Nẵng">
        <option value="Hải Phòng">
        <option value="Cần Thơ">
        <option value="Đà Lạt">
        <option value="Nha Trang">
        <option value="Vũng Tàu">
        <option value="Quy Nhơn">
        <option value="Phú Quốc">
        <option value="Huế">
        <option value="Kon Tum">
    </datalist>

    <jsp:include page="../common/footer.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        let departurePicker = null;
        let returnPicker = null;

        function toggleReturnDate(show) {
            const returnShell = document.getElementById('returnDateShell');
            const returnInput = document.getElementById('returnDate');
            const dateRow = document.getElementById('dateRow');
            const isVisible = returnShell.classList.contains('is-visible');
            if (isVisible === show) {
                return;
            }

            returnShell.classList.toggle('is-visible', show);
            dateRow.classList.toggle('is-round-trip', show);

            if (show) {
                returnInput.setAttribute('required', 'true');
            } else {
                returnInput.removeAttribute('required');
                returnInput.value = '';
                if (returnPicker) {
                    returnPicker.clear();
                }
            }
        }

        function swapLocations() {
            const origin = document.querySelector('input[name="origin"]');
            const destination = document.querySelector('input[name="destination"]');
            const temp = origin.value;
            origin.value = destination.value;
            destination.value = temp;
        }

        function changeCount(type, delta) {
            const input = document.getElementById(type + 'Input');
            const display = document.getElementById(type + 'Display');
            const min = type === 'adult' ? 1 : 0;
            let value = parseInt(input.value || '0', 10) + delta;

            if (value < min) {
                value = min;
            }
            if (value > 6) {
                value = 6;
            }

            input.value = value;
            display.innerText = value;
            updatePassengerSummary();
        }

        function updatePassengerSummary() {
            const adult = parseInt(document.getElementById('adultInput').value || '1', 10);
            const child = parseInt(document.getElementById('childInput').value || '0', 10);
            const parts = [];

            if (adult > 0) {
                parts.push(adult + ' người lớn');
            }
            if (child > 0) {
                parts.push(child + ' trẻ em');
            }

            document.getElementById('passengerSummary').innerText = parts.join(', ');
        }

        function initDatePickers() {
            departurePicker = flatpickr('#departureDate', {
                minDate: 'today',
                dateFormat: 'Y-m-d',
                altInput: true,
                altFormat: 'd/m/Y',
                disableMobile: true,
                onChange: function(selectedDates) {
                    if (returnPicker) {
                        returnPicker.set('minDate', selectedDates[0] || 'today');
                    }
                }
            });

            returnPicker = flatpickr('#returnDate', {
                minDate: 'today',
                dateFormat: 'Y-m-d',
                altInput: true,
                altFormat: 'd/m/Y',
                disableMobile: true
            });
        }

        document.addEventListener('DOMContentLoaded', () => {
            updatePassengerSummary();
            initDatePickers();
        });
    </script>
</body>
</html>
