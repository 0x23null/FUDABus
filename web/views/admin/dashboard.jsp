<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Tổng quan quản trị - FUDA Bus</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="fade-in admin-page">
    <jsp:include page="common/admin-header.jsp"></jsp:include>

    <main class="admin-shell">
        <section class="admin-hero">
            <div>
                <span class="admin-eyebrow"><i class="fas fa-wave-square"></i> Điều hành hệ thống</span>
                <h1>Bảng điều khiển quản trị</h1>
                <p>Theo dõi nhanh tình trạng đội xe, tuyến đường, lịch chạy và các đơn đặt vé đang cần xử lý trong cùng một màn hình gọn gàng hơn.</p>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Xem trang khách</a>
        </section>

        <section class="admin-metrics">
            <article class="metric-card">
                <span>Tổng số xe</span>
                <strong>${busCount}</strong>
                <p>Đội xe đang có trong hệ thống quản lý.</p>
            </article>
            <article class="metric-card">
                <span>Tổng số tuyến</span>
                <strong>${routeCount}</strong>
                <p>Các tuyến đang được cấu hình để khai thác.</p>
            </article>
            <article class="metric-card">
                <span>Chuyến đang mở</span>
                <strong>${scheduledTripCount}</strong>
                <p>Số chuyến hiện ở trạng thái có thể bán vé.</p>
            </article>
            <article class="metric-card">
                <span>Đơn chờ thanh toán</span>
                <strong>${pendingBookingCount}</strong>
                <p>Đơn cần theo dõi tiếp ở bước hoàn tất thanh toán.</p>
            </article>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-compass-drafting"></i> Khu vực tác vụ</span>
                    <h2>Truy cập nhanh các nhóm quản trị</h2>
                    <p>Mỗi khu vực được gom lại theo đúng luồng vận hành để bạn vào đúng phần cần chỉnh mà không phải đi lòng vòng.</p>
                </div>
                <div class="admin-user-chip">
                    <i class="fas fa-coins"></i>
                    <span>Doanh thu đã thanh toán:
                        <strong style="color: var(--primary-dark);">
                            <fmt:formatNumber value="${paidRevenue}" type="number" maxFractionDigits="0" /> đ
                        </strong>
                    </span>
                </div>
            </div>
            <div class="admin-panel-body">
                <div class="admin-card-grid">
                    <a href="${pageContext.request.contextPath}/admin/buses" class="admin-link-card">
                        <div>
                            <span class="admin-link-icon"><i class="fas fa-bus"></i></span>
                            <h3>Quản lý xe</h3>
                            <p>Thêm xe mới, theo dõi sức chứa và chuẩn hóa loại xe đang được bán trên hệ thống.</p>
                        </div>
                        <strong>Đi tới danh sách xe</strong>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/routes" class="admin-link-card">
                        <div>
                            <span class="admin-link-icon"><i class="fas fa-route"></i></span>
                            <h3>Quản lý tuyến</h3>
                            <p>Cập nhật điểm đi, điểm đến, quãng đường và thời lượng vận hành của từng tuyến.</p>
                        </div>
                        <strong>Đi tới danh sách tuyến</strong>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/trips" class="admin-link-card">
                        <div>
                            <span class="admin-link-icon"><i class="fas fa-calendar-check"></i></span>
                            <h3>Quản lý chuyến</h3>
                            <p>Lập lịch chạy, gán xe, kiểm soát giờ khởi hành và mức giá bán cho từng chuyến cụ thể.</p>
                        </div>
                        <strong>Đi tới lịch chuyến</strong>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/bookings" class="admin-link-card">
                        <div>
                            <span class="admin-link-icon"><i class="fas fa-ticket-alt"></i></span>
                            <h3>Quản lý đặt vé</h3>
                            <p>Theo dõi lịch sử đặt chỗ, trạng thái thanh toán và các đơn phát sinh từ khách hàng.</p>
                        </div>
                        <strong>Đi tới danh sách đơn</strong>
                    </a>
                </div>
            </div>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-lightbulb"></i> Gợi ý vận hành</span>
                    <h2>Những điểm nên ưu tiên theo dõi</h2>
                    <p>Một vài nhắc nhanh để admin kiểm tra hệ thống theo đúng nhịp vận hành hằng ngày.</p>
                </div>
            </div>
            <div class="admin-panel-body">
                <div class="hint-grid">
                    <article class="hint-card">
                        <h3>Kiểm tra chuyến gần giờ chạy</h3>
                        <p>Ưu tiên rà lại các chuyến đã lên lịch, đặc biệt với tuyến mới tạo hoặc vừa đổi xe để tránh lệch thông tin khi khách chọn ghế.</p>
                    </article>
                    <article class="hint-card">
                        <h3>Theo dõi đơn chờ thanh toán</h3>
                        <p>Các đơn chờ thanh toán nên được kiểm soát định kỳ để nắm luồng thanh toán và xử lý nhanh những đơn bị treo quá lâu.</p>
                    </article>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
