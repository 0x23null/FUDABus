<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Vé điện tử - ${booking.ticketCode}</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        body {
            background: linear-gradient(180deg, #f8fbff 0%, #eef4fb 100%);
        }

        .page-wrap {
            max-width: 1120px;
            margin: 32px auto 80px;
            padding: 0 20px;
        }

        .success-box {
            text-align: center;
            margin-bottom: 24px;
        }

        .success-badge {
            width: 82px;
            height: 82px;
            margin: 0 auto 14px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            font-weight: 900;
            box-shadow: 0 20px 36px -24px rgba(37, 99, 235, 0.72);
        }

        .success-box h1 {
            margin: 0;
            font-size: 38px;
        }

        .success-box p {
            margin: 10px auto 0;
            color: var(--text-secondary);
            max-width: 620px;
        }

        .layout {
            display: grid;
            grid-template-columns: 0.95fr 1.05fr;
            gap: 24px;
        }

        .panel {
            background: rgba(255, 255, 255, 0.93);
            border-radius: 30px;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-md);
            padding: 24px;
        }

        .ticket-card {
            position: sticky;
            top: 100px;
            background: linear-gradient(180deg, #fbfdff 0%, #f4f8ff 100%);
        }

        .ticket-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
        }

        .ticket-code {
            font-family: 'Courier New', monospace;
            font-size: 18px;
            font-weight: 800;
            color: var(--primary-dark);
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-bottom: 22px;
        }

        .info-item {
            border-radius: 18px;
            background: #fff;
            border: 1px solid #dce6f4;
            padding: 14px;
        }

        .info-item small {
            display: block;
            color: var(--text-soft);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .info-item strong {
            color: var(--text-primary);
            font-weight: 650;
        }

        .segment-item {
            border: 1px solid #dce6f4;
            border-radius: 22px;
            padding: 18px;
            background: #f8fbff;
            margin-top: 16px;
        }

        .segment-item h3 {
            margin: 0 0 8px;
            font-size: 19px;
        }

        .segment-meta {
            color: var(--text-secondary);
            line-height: 1.8;
        }

        .segment-meta strong {
            color: var(--text-primary);
            font-weight: 650;
        }

        .ticket-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .ticket-actions button,
        .ticket-actions a {
            border: none;
            border-radius: 999px;
            padding: 12px 18px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: #fff;
        }

        .btn-secondary {
            background: #edf4ff;
            color: var(--primary-dark);
        }

        .highlight-box {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1d4ed8;
            border-radius: 18px;
            padding: 14px 16px;
            font-weight: 600;
        }

        @media print {
            .main-header, .ticket-actions, footer { display: none; }
            .layout { grid-template-columns: 1fr; }
            .ticket-card { position: static; }
        }

        @media (max-width: 900px) {
            .layout { grid-template-columns: 1fr; }
            .ticket-card { position: static; }
            .info-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body class="fade-in">
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="page-wrap">
        <div class="success-box">
            <div class="success-badge">✓</div>
            <h1>Mua vé xe thành công</h1>
            <p>Vé của bạn đã sẵn sàng. Bạn có thể tải PDF, in vé hoặc dùng mã QR khi lên xe.</p>
        </div>

        <div class="layout" id="ticketContent">
            <div class="panel ticket-card">
                <div class="ticket-head">
                    <div>
                        <div style="color:var(--text-soft); font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:0.08em;">Mã đặt chỗ</div>
                        <div class="ticket-code">${booking.ticketCode}</div>
                    </div>
                    <div id="qrcode"></div>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <small>Khách hàng</small>
                        <strong>${booking.user.fullName}</strong>
                    </div>
                    <div class="info-item">
                        <small>Trạng thái</small>
                        <strong>${booking.status}</strong>
                    </div>
                    <div class="info-item">
                        <small>Điện thoại</small>
                        <strong>${booking.user.phoneNumber}</strong>
                    </div>
                    <div class="info-item">
                        <small>Tổng tiền</small>
                        <strong class="price-emphasis"><fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" />đ</strong>
                    </div>
                    <div class="info-item">
                        <small>Hành khách</small>
                        <strong>${booking.adultCount} người lớn<c:if test="${booking.childCount > 0}">, ${booking.childCount} trẻ em</c:if></strong>
                    </div>
                    <div class="info-item">
                        <small>Ngày đặt</small>
                        <strong><fmt:formatDate value="${booking.bookingDate}" pattern="HH:mm dd/MM/yyyy" /></strong>
                    </div>
                </div>

                <div class="highlight-box">
                    Mang theo mã QR hoặc mã đặt chỗ khi làm thủ tục lên xe. Nên có mặt trước giờ xuất bến ít nhất 30 phút.
                </div>

                <div class="ticket-actions">
                    <button onclick="window.print()" class="btn-secondary">In vé</button>
                    <button onclick="downloadPDF()" class="btn-secondary">Tải PDF</button>
                    <a href="${pageContext.request.contextPath}/home" class="btn-primary">Đặt chuyến mới</a>
                </div>
            </div>

            <div class="panel">
                <h2 style="margin-top:0;">Thông tin mua vé</h2>
                <c:forEach items="${booking.segments}" var="segment">
                    <div class="segment-item">
                        <h3>${segment.displayType}</h3>
                        <div class="segment-meta">
                            <div><strong>Tuyến:</strong> ${segment.trip.route.origin} - ${segment.trip.route.destination}</div>
                            <div><strong>Giờ xuất bến:</strong> <fmt:formatDate value="${segment.trip.departureTime}" pattern="HH:mm dd/MM/yyyy" /></div>
                            <div><strong>Giờ đến dự kiến:</strong> <fmt:formatDate value="${segment.trip.arrivalTime}" pattern="HH:mm dd/MM/yyyy" /></div>
                            <div><strong>Loại xe:</strong> ${segment.trip.bus.busType}</div>
                            <div><strong>Số ghế:</strong>
                                <c:forEach items="${segment.seatNumbers}" var="seat" varStatus="loop">
                                    ${seat}<c:if test="${!loop.last}">, </c:if>
                                </c:forEach>
                            </div>
                            <div><strong>Giá chặng:</strong> <span class="price-emphasis"><fmt:formatNumber value="${segment.segmentPrice * booking.totalPassengerCount}" type="number" maxFractionDigits="0" />đ</span></div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        new QRCode(document.getElementById('qrcode'), {
            text: '${booking.ticketCode}',
            width: 112,
            height: 112
        });

        function downloadPDF() {
            const element = document.getElementById('ticketContent');
            html2pdf().set({
                margin: 8,
                filename: 'BusTicket-${booking.ticketCode}.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2, useCORS: true },
                jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            }).from(element).save();
        }
    </script>
</body>
</html>
