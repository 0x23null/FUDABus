<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Chọn chuyến xe - FUDA Bus</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        body {
            background:
                radial-gradient(circle at top left, rgba(37, 99, 235, 0.12), transparent 28%),
                radial-gradient(circle at top right, rgba(14, 165, 233, 0.1), transparent 30%),
                linear-gradient(180deg, #f7faff 0%, #eef4fb 100%);
        }

        .trip-page {
            max-width: 1180px;
            margin: 36px auto 80px;
            padding: 0 20px;
        }

        .hero-card,
        .section-card,
        .trip-card,
        .empty-card,
        .tip-card,
        .selected-pane {
            background: rgba(255, 255, 255, 0.92);
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-md);
        }

        .hero-card {
            border-radius: 32px;
            padding: 28px 32px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 24px;
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            background: var(--primary-soft);
            color: var(--primary-dark);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .hero-title {
            margin: 16px 0 8px;
            font-size: clamp(30px, 4vw, 42px);
            line-height: 1.08;
        }

        .hero-subtitle {
            margin: 0;
            color: var(--text-secondary);
            font-size: 15px;
            line-height: 1.7;
            max-width: 640px;
        }

        .trip-summary-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 18px;
        }

        .summary-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 16px;
            background: #f7fbff;
            border: 1px solid #dbe7f7;
            color: #355070;
            font-weight: 600;
            font-size: 14px;
        }

        .hero-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .hero-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 999px;
            padding: 12px 18px;
            font-weight: 650;
        }

        .hero-link.primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: #fff;
        }

        .hero-link.secondary {
            background: #fff;
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .notice {
            border-radius: 22px;
            padding: 18px 22px;
            margin-bottom: 24px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1d4ed8;
        }

        .section-card {
            border-radius: 30px;
            padding: 28px;
            margin-bottom: 28px;
        }

        .section-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
        }

        .section-heading h2 {
            margin: 0;
            font-size: 26px;
        }

        .section-heading p {
            margin: 6px 0 0;
            color: var(--text-secondary);
        }

        .step-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            background: var(--primary-soft);
            color: var(--primary-dark);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .trip-list {
            display: grid;
            gap: 18px;
        }

        .trip-card {
            border-radius: 26px;
            padding: 22px;
            display: grid;
            grid-template-columns: 1.5fr 1fr 0.95fr;
            gap: 18px;
            align-items: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .trip-card:hover {
            transform: translateY(-2px);
        }

        .trip-main {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .trip-time {
            min-width: 120px;
            text-align: center;
        }

        .trip-time strong {
            display: block;
            font-size: 30px;
            line-height: 1;
            font-weight: 700;
        }

        .trip-time span {
            color: var(--text-secondary);
            font-size: 13px;
        }

        .trip-line {
            flex: 1;
            min-width: 140px;
        }

        .trip-line-top {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }

        .trip-dot {
            width: 12px;
            height: 12px;
            border-radius: 999px;
            background: var(--primary-color);
            box-shadow: 0 0 0 6px rgba(37, 99, 235, 0.12);
        }

        .trip-line-rule {
            flex: 1;
            height: 2px;
            border-top: 2px dashed #cad9f0;
        }

        .trip-duration {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: #f3f8ff;
            color: var(--primary-dark);
            font-weight: 650;
            font-size: 13px;
        }

        .trip-route {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            color: #42526b;
            font-weight: 600;
        }

        .trip-meta {
            display: grid;
            gap: 10px;
            color: #4b5b76;
        }

        .trip-meta .label {
            color: var(--text-soft);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .trip-meta strong {
            font-weight: 650;
        }

        .trip-price-wrap {
            text-align: right;
        }

        .trip-price {
            font-size: 28px;
            line-height: 1;
        }

        .price-note {
            color: var(--text-secondary);
            font-size: 13px;
            margin-top: 6px;
        }

        .trip-status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 12px;
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.04em;
        }

        .trip-status-badge.departed {
            background: #fff1f2;
            color: #be123c;
            border: 1px solid #fecdd3;
        }

        .trip-form {
            margin-top: 18px;
        }

        .trip-btn {
            width: 100%;
            border: none;
            border-radius: 18px;
            padding: 14px 18px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            color: #fff;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            box-shadow: 0 18px 30px -24px rgba(37, 99, 235, 0.7);
        }

        .trip-btn.is-disabled,
        .trip-btn:disabled {
            cursor: not-allowed;
            background: linear-gradient(135deg, #94a3b8, #64748b);
            box-shadow: none;
            opacity: 0.92;
        }

        .selected-banner {
            display: grid;
            grid-template-columns: 1.3fr 0.9fr;
            gap: 18px;
            margin-bottom: 22px;
        }

        .selected-pane {
            border-radius: 24px;
            padding: 20px 22px;
        }

        .selected-pane h3 {
            margin: 0 0 10px;
            font-size: 21px;
        }

        .selected-pane p {
            margin: 0;
            color: var(--text-secondary);
            line-height: 1.65;
        }

        .selected-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px;
            margin-top: 16px;
        }

        .selected-item {
            border-radius: 18px;
            background: #fbfdff;
            border: 1px solid #dbe7f7;
            padding: 14px;
        }

        .selected-item .label {
            display: block;
            color: var(--text-soft);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .selected-item strong {
            font-weight: 650;
        }

        .empty-card,
        .tip-card {
            border-radius: 24px;
            padding: 22px;
        }

        .empty-card {
            text-align: center;
            color: var(--text-secondary);
        }

        .tip-card {
            background: linear-gradient(135deg, #10224d 0%, #1e3a8a 100%);
            color: #fff;
            border: none;
            margin-top: 22px;
        }

        .tip-card h3 {
            margin: 0 0 10px;
            font-size: 22px;
            color: #fff;
        }

        .tip-card p {
            margin: 0;
            color: rgba(255, 255, 255, 0.8);
            line-height: 1.7;
        }

        @media (max-width: 960px) {
            .hero-card,
            .section-heading,
            .selected-banner,
            .trip-card {
                grid-template-columns: 1fr;
                display: grid;
            }

            .trip-price-wrap {
                text-align: left;
            }
        }

        @media (max-width: 640px) {
            .trip-page {
                margin-top: 24px;
                padding: 0 14px;
            }

            .section-card {
                padding: 20px;
            }

            .trip-main {
                flex-direction: column;
                align-items: flex-start;
            }

            .trip-time {
                text-align: left;
                min-width: 0;
            }

            .trip-route,
            .selected-grid {
                grid-template-columns: 1fr;
                display: grid;
            }

            .hero-link {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="trip-page">
        <div class="hero-card">
            <div>
                <span class="hero-eyebrow"><i class="fas fa-route"></i> Hành trình của bạn</span>
                <h1 class="hero-title">${searchOrigin} <i class="fas fa-arrow-right" style="color:#2563eb;"></i> ${searchDest}</h1>
                <p class="hero-subtitle">
                    <c:choose>
                        <c:when test="${tripType eq 'roundTrip'}">Chọn chuyến đi trước, sau đó chọn chuyến về để tiếp tục sang bước chọn ghế.</c:when>
                        <c:otherwise>Chọn chuyến phù hợp nhất để tiếp tục sang bước chọn ghế và thanh toán.</c:otherwise>
                    </c:choose>
                </p>
                <div class="trip-summary-badges">
                    <span class="summary-badge"><i class="far fa-calendar-alt"></i> Ngày đi: ${searchDate}</span>
                    <c:if test="${tripType eq 'roundTrip' and not empty searchReturnDate}">
                        <span class="summary-badge"><i class="fas fa-rotate-left"></i> Ngày về: ${searchReturnDate}</span>
                    </c:if>
                    <span class="summary-badge"><i class="fas fa-user"></i> ${adultCount} người lớn</span>
                    <span class="summary-badge"><i class="fas fa-child"></i> ${childCount} trẻ em</span>
                    <span class="summary-badge"><i class="fas fa-ticket-alt"></i> ${passengerCount} ghế cần chọn</span>
                </div>
            </div>
            <div class="hero-actions">
                <a class="hero-link primary" href="home#search-form"><i class="fas fa-pen"></i> Sửa tiêu chí</a>
            </div>
        </div>

        <c:if test="${isSuggestion}">
            <div class="notice">
                <i class="fas fa-info-circle"></i>
                <div>
                    <strong>Không có chuyến đúng ngày bạn đã chọn.</strong>
                    <div>Hệ thống đang ưu tiên hiển thị các chuyến gần nhất cùng tuyến ở ngày khác để bạn cân nhắc.</div>
                </div>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${tripType eq 'roundTrip' and not empty selectedOutboundTrip}">
                <div class="section-card">
                    <div class="section-heading">
                        <div>
                            <span class="step-chip">Bước 2/2</span>
                            <h2>Chọn chuyến về</h2>
                            <p>Chiều đi đã được giữ trong phiên chọn. Bây giờ chỉ cần chọn chuyến về phù hợp để sang bước chọn ghế.</p>
                        </div>
                    </div>

                    <div class="selected-banner">
                        <div class="selected-pane">
                            <h3>Chiều đi đã chọn</h3>
                            <p>${selectedOutboundTrip.route.origin} đến ${selectedOutboundTrip.route.destination}</p>
                            <div class="selected-grid">
                                <div class="selected-item">
                                    <span class="label">Khởi hành</span>
                                    <strong><fmt:formatDate value="${selectedOutboundTrip.departureTime}" pattern="HH:mm - dd/MM/yyyy" /></strong>
                                </div>
                                <div class="selected-item">
                                    <span class="label">Đến nơi</span>
                                    <strong><fmt:formatDate value="${selectedOutboundTrip.arrivalTime}" pattern="HH:mm - dd/MM/yyyy" /></strong>
                                </div>
                                <div class="selected-item">
                                    <span class="label">Loại xe</span>
                                    <strong>${selectedOutboundTrip.bus.busType}</strong>
                                </div>
                                <div class="selected-item">
                                    <span class="label">Giá / ghế</span>
                                    <strong class="price-emphasis"><fmt:formatNumber value="${selectedOutboundTrip.price}" type="number" maxFractionDigits="0" />đ</strong>
                                </div>
                            </div>
                        </div>
                        <div class="selected-pane">
                            <h3>Thông tin đặt vé</h3>
                            <p>Đơn này gồm <strong>${passengerCount}</strong> hành khách, trong đó có <strong>${adultCount}</strong> người lớn và <strong>${childCount}</strong> trẻ em.</p>
                            <div class="selected-grid">
                                <div class="selected-item">
                                    <span class="label">Loại chuyến</span>
                                    <strong>Khứ hồi</strong>
                                </div>
                                <div class="selected-item">
                                    <span class="label">Ngày về</span>
                                    <strong>${searchReturnDate}</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty returnTrips}">
                            <div class="empty-card">
                                <h3>Chưa có chuyến về phù hợp</h3>
                                <p>Bạn có thể quay lại và đổi ngày về hoặc đổi hành trình để tiếp tục.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="trip-list">
                                <c:forEach items="${returnTrips}" var="t">
                                    <c:set var="isDeparted" value="${t.departureTime.time le currentTimeMillis}" />
                                    <div class="trip-card">
                                        <div class="trip-main">
                                            <div class="trip-time">
                                                <strong><fmt:formatDate value="${t.departureTime}" pattern="HH:mm" /></strong>
                                                <span><fmt:formatDate value="${t.departureTime}" pattern="dd/MM/yyyy" /></span>
                                            </div>
                                            <div class="trip-line">
                                                <div class="trip-line-top">
                                                    <span class="trip-dot"></span>
                                                    <span class="trip-line-rule"></span>
                                                    <span class="trip-duration"><i class="far fa-clock"></i> ${t.route.duration / 60} giờ</span>
                                                </div>
                                                <div class="trip-route">
                                                    <span>${t.route.origin}</span>
                                                    <span>${t.route.destination}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="trip-meta">
                                            <div>
                                                <div class="label">Loại xe</div>
                                                <strong>${t.bus.busType}</strong>
                                            </div>
                                            <div>
                                                <div class="label">Sức chứa</div>
                                                <strong>${t.bus.seatCapacity} chỗ</strong>
                                            </div>
                                            <div>
                                                <div class="label">Giờ đến</div>
                                                <strong><fmt:formatDate value="${t.arrivalTime}" pattern="HH:mm - dd/MM/yyyy" /></strong>
                                            </div>
                                        </div>
                                        <div class="trip-price-wrap">
                                            <div class="trip-price price-emphasis"><fmt:formatNumber value="${t.price}" type="number" maxFractionDigits="0" />đ</div>
                                            <div class="price-note">Giá mỗi ghế</div>
                                            <c:if test="${isDeparted}">
                                                <div class="trip-status-badge departed"><i class="fas fa-ban"></i> Đã khởi hành</div>
                                            </c:if>
                                            <form class="trip-form" method="get" action="booking">
                                                <input type="hidden" name="tripID" value="${selectedOutboundID}">
                                                <input type="hidden" name="returnTripID" value="${t.tripID}">
                                                <input type="hidden" name="adultCount" value="${adultCount}">
                                                <input type="hidden" name="childCount" value="${childCount}">
                                                <c:choose>
                                                    <c:when test="${isDeparted}">
                                                        <button type="submit" class="trip-btn is-disabled" disabled="disabled">Đã khởi hành</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" class="trip-btn">Chọn ghế cho hai chiều</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <div class="section-card">
                    <div class="section-heading">
                        <div>
                            <span class="step-chip">
                                <c:choose>
                                    <c:when test="${tripType eq 'roundTrip'}">Bước 1/2</c:when>
                                    <c:otherwise>Một chiều</c:otherwise>
                                </c:choose>
                            </span>
                            <h2>Chọn chuyến đi</h2>
                            <p>Danh sách dưới đây đã được lọc theo hành trình bạn vừa tìm kiếm.</p>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty trips}">
                            <div class="empty-card">
                                <h3>Hiện chưa có chuyến phù hợp</h3>
                                <p>Hãy đổi ngày hoặc đổi điểm đi, điểm đến để tìm chuyến khác.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="trip-list">
                                <c:forEach items="${trips}" var="t">
                                    <c:set var="isDeparted" value="${t.departureTime.time le currentTimeMillis}" />
                                    <div class="trip-card">
                                        <div class="trip-main">
                                            <div class="trip-time">
                                                <strong><fmt:formatDate value="${t.departureTime}" pattern="HH:mm" /></strong>
                                                <span><fmt:formatDate value="${t.departureTime}" pattern="dd/MM/yyyy" /></span>
                                            </div>
                                            <div class="trip-line">
                                                <div class="trip-line-top">
                                                    <span class="trip-dot"></span>
                                                    <span class="trip-line-rule"></span>
                                                    <span class="trip-duration"><i class="far fa-clock"></i> ${t.route.duration / 60} giờ</span>
                                                </div>
                                                <div class="trip-route">
                                                    <span>${t.route.origin}</span>
                                                    <span>${t.route.destination}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="trip-meta">
                                            <div>
                                                <div class="label">Loại xe</div>
                                                <strong>${t.bus.busType}</strong>
                                            </div>
                                            <div>
                                                <div class="label">Sức chứa</div>
                                                <strong>${t.bus.seatCapacity} chỗ</strong>
                                            </div>
                                            <div>
                                                <div class="label">Giờ đến</div>
                                                <strong><fmt:formatDate value="${t.arrivalTime}" pattern="HH:mm - dd/MM/yyyy" /></strong>
                                            </div>
                                        </div>
                                        <div class="trip-price-wrap">
                                            <div class="trip-price price-emphasis"><fmt:formatNumber value="${t.price}" type="number" maxFractionDigits="0" />đ</div>
                                            <div class="price-note">Giá mỗi ghế</div>
                                            <c:if test="${isDeparted}">
                                                <div class="trip-status-badge departed"><i class="fas fa-ban"></i> Đã khởi hành</div>
                                            </c:if>
                                            <c:choose>
                                                <c:when test="${tripType eq 'roundTrip'}">
                                                    <form class="trip-form" method="get" action="search">
                                                        <input type="hidden" name="tripType" value="${tripType}">
                                                        <input type="hidden" name="origin" value="${searchOrigin}">
                                                        <input type="hidden" name="destination" value="${searchDest}">
                                                        <input type="hidden" name="date" value="${searchDate}">
                                                        <input type="hidden" name="returnDate" value="${searchReturnDate}">
                                                        <input type="hidden" name="adultCount" value="${adultCount}">
                                                        <input type="hidden" name="childCount" value="${childCount}">
                                                        <input type="hidden" name="selectedOutboundID" value="${t.tripID}">
                                                        <c:choose>
                                                            <c:when test="${isDeparted}">
                                                                <button type="submit" class="trip-btn is-disabled" disabled="disabled">Đã khởi hành</button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="submit" class="trip-btn">Chọn chiều đi</button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form class="trip-form" method="get" action="booking">
                                                        <input type="hidden" name="tripID" value="${t.tripID}">
                                                        <input type="hidden" name="adultCount" value="${adultCount}">
                                                        <input type="hidden" name="childCount" value="${childCount}">
                                                        <c:choose>
                                                            <c:when test="${isDeparted}">
                                                                <button type="submit" class="trip-btn is-disabled" disabled="disabled">Đã khởi hành</button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="submit" class="trip-btn">Chọn ghế ngay</button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="tip-card">
            <h3>Gợi ý để chọn chuyến nhanh hơn</h3>
            <p>Ưu tiên những chuyến có giờ khởi hành phù hợp với lịch trình của bạn, sau đó mới cân nhắc loại xe và tổng thời gian di chuyển. Sau bước này, hệ thống sẽ cho bạn chọn ghế cụ thể theo đúng số hành khách đã nhập.</p>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
