<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Ve dien tu #${booking.bookingID}</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .ticket-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 40px;
            padding-bottom: 100px;
            min-height: 80vh;
        }

        .boarding-pass {
            background: white;
            width: 100%;
            max-width: 700px;
            border-radius: 24px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .pass-header {
            background: var(--primary-color);
            color: white;
            padding: 24px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .pass-body {
            padding: 40px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
        }

        .info-group {
            margin-bottom: 20px;
        }

        .label {
            font-size: 12px;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .value {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
        }

        .pass-footer {
            background: #f8fafc;
            padding: 24px 40px;
            border-top: 2px dashed var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .actions {
            margin-top: 40px;
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            justify-content: center;
        }

        @media print {

            .main-header,
            .actions,
            footer {
                display: none;
            }

            .ticket-container {
                padding: 0;
                min-height: 0;
            }

            .boarding-pass {
                box-shadow: none;
                border: 1px solid #000;
                width: 100%;
                max-width: none;
            }

            body {
                background: white;
            }
        }
    </style>
</head>

<body class="fade-in">
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="container ticket-container">
        <h2
            style="margin-bottom: 30px; font-weight: 800; background: linear-gradient(135deg, var(--primary-color), var(--accent-color)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
            Ve dien tu cua ban</h2>

        <div class="boarding-pass" id="ticketContent">
            <div class="pass-header">
                <div style="font-size: 24px; font-weight: 800; display: flex; align-items: center; gap: 8px;">
                    <i class="fas fa-bus-alt"></i> Vivu
                </div>
                <div
                    style="background: rgba(255, 255, 255, 0.15); backdrop-filter: blur(4px); border: 1px solid rgba(255, 255, 255, 0.3); border-radius: 50px; padding: 6px 16px; display: flex; align-items: center; gap: 8px;">
                    <span
                        style="font-size: 10px; text-transform: uppercase; letter-spacing: 1px; opacity: 0.8; font-weight: 600;">Ma ve:</span>
                    <span
                        style="font-family: 'Courier New', monospace; font-weight: 700; font-size: 16px; letter-spacing: 1px;">
                        ${not empty booking.ticketCode ? booking.ticketCode : booking.bookingID}
                    </span>
                </div>
            </div>

            <div class="pass-body">
                <div class="info-group">
                    <div class="label">Hanh khach</div>
                    <div class="value">${booking.user.fullName}</div>
                </div>
                <div class="info-group">
                    <div class="label">Ngay di</div>
                    <div class="value">
                        <fmt:formatDate value="${booking.trip.departureTime}" pattern="dd/MM/yyyy" />
                    </div>
                </div>

                <div class="info-group">
                    <div class="label">Diem di</div>
                    <div class="value">${booking.trip.route.origin}</div>
                    <div style="font-size: 14px; color: var(--text-secondary);">
                        <fmt:formatDate value="${booking.trip.departureTime}" pattern="HH:mm" />
                    </div>
                </div>
                <div class="info-group">
                    <div class="label">Diem den</div>
                    <div class="value">${booking.trip.route.destination}</div>
                    <div style="font-size: 14px; color: var(--text-secondary);">
                        <fmt:formatDate value="${booking.trip.arrivalTime}" pattern="HH:mm" />
                    </div>
                </div>

                <div class="info-group">
                    <div class="label">Thong tin xe</div>
                    <div class="value">${booking.trip.bus.busNumber}
                        <span style="font-weight: 400; font-size: 14px; color: var(--text-secondary);">
                            (${booking.trip.bus.busType})
                        </span>
                    </div>
                </div>
                <div class="info-group">
                    <div class="label">So ghe</div>
                    <div class="value" style="color: var(--primary-color);">
                        <c:forEach var="seat" items="${booking.bookedSeats}" varStatus="loop">
                            ${seat}${!loop.last ? ', ' : ''}
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="pass-footer">
                <div>
                    <div class="label">Tong tien</div>
                    <div class="value" style="color: var(--primary-dark);">
                        <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0" /> VND
                    </div>
                </div>
                <div style="text-align: right;">
                    <div class="label">Trang thai</div>
                    <div class="value" style="color: ${booking.status == 'Paid' ? 'var(--success)' : 'var(--warning)'}">
                        ${booking.status}
                    </div>
                </div>
            </div>
        </div>

        <div class="actions">
            <button onclick="downloadPDF()" class="btn btn-secondary"><i class="fas fa-download"></i> Tai PDF</button>
            <button onclick="window.print()" class="btn btn-secondary"><i class="fas fa-print"></i> In ve</button>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Dat chuyen moi</a>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        function downloadPDF() {
            const element = document.getElementById('ticketContent');
            const opt = {
                margin: 10,
                filename: 'BusTicket-' + '${not empty booking.ticketCode ? booking.ticketCode : booking.bookingID}' + '.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2, useCORS: true },
                jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };

            html2pdf().set(opt).from(element).save();
        }
    </script>
</body>

</html>
