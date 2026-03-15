<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Quản lý chuyến - FUDA Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="fade-in admin-page">
    <jsp:include page="common/admin-header.jsp"></jsp:include>

    <main class="admin-shell">
        <section class="admin-hero">
            <div>
                <span class="admin-eyebrow"><i class="fas fa-calendar-check"></i> Lịch chạy</span>
                <h1>Quản lý chuyến xe</h1>
                <p>Lập lịch, gán xe và chốt mức giá cho từng chuyến cụ thể. Đây là lớp dữ liệu đi thẳng ra màn hình tìm chuyến của khách hàng.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Về tổng quan</a>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-plus"></i> Tạo mới</span>
                    <h2>Lên lịch chuyến mới</h2>
                    <p>Chọn đúng tuyến, xe và thời gian khởi hành để hệ thống tự tính thời gian đến dự kiến phía sau.</p>
                </div>
            </div>
            <div class="admin-panel-body">
                <form action="${pageContext.request.contextPath}/admin/trip/add" method="POST">
                    <div class="admin-form-grid">
                        <div class="admin-field">
                            <label>Tuyến</label>
                            <select name="routeID" class="form-control" required>
                                <option value="" disabled selected>Chọn tuyến</option>
                                <c:forEach items="${routes}" var="r">
                                    <option value="${r.routeID}">${r.origin} → ${r.destination} (${r.duration} phút)</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="admin-field">
                            <label>Xe</label>
                            <select name="busID" class="form-control" required>
                                <option value="" disabled selected>Chọn xe</option>
                                <c:forEach items="${buses}" var="b">
                                    <option value="${b.busID}">${b.busNumber} (${b.busType})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="admin-field">
                            <label>Giờ khởi hành</label>
                            <input type="datetime-local" name="departureTime" class="form-control" required>
                        </div>
                        <div class="admin-field">
                            <label>Giá vé (nghìn đồng)</label>
                            <input type="number" name="price" class="form-control" placeholder="350" min="1" required>
                        </div>
                    </div>
                    <div class="admin-form-actions">
                        <button type="submit" class="btn btn-primary">Lên lịch chuyến</button>
                    </div>
                </form>
            </div>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-list"></i> Danh sách</span>
                    <h2>Chuyến đã được lên lịch</h2>
                    <p>Kiểm tra nhanh giờ chạy, xe gán cho chuyến và trạng thái đang mở bán hay đã hủy.</p>
                </div>
            </div>
            <div class="admin-panel-body">
                <div class="table-shell">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tuyến</th>
                                <th>Xe</th>
                                <th>Khởi hành</th>
                                <th>Đến nơi</th>
                                <th>Giá vé</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${trips}" var="t">
                                <tr>
                                    <td class="mono">#${t.tripID}</td>
                                    <td>
                                        <span class="table-title">${t.route.origin} → ${t.route.destination}</span>
                                        <span class="table-subtitle">${t.route.duration} phút • ${t.route.distance} km</span>
                                    </td>
                                    <td>
                                        <span class="table-title">${t.bus.busNumber}</span>
                                        <span class="table-subtitle">${t.bus.busType} • ${t.bus.seatCapacity} ghế</span>
                                    </td>
                                    <td>
                                        <span class="table-title"><fmt:formatDate value="${t.departureTime}" pattern="dd/MM/yyyy" /></span>
                                        <span class="table-subtitle"><fmt:formatDate value="${t.departureTime}" pattern="HH:mm" /></span>
                                    </td>
                                    <td>
                                        <span class="table-title"><fmt:formatDate value="${t.arrivalTime}" pattern="dd/MM/yyyy" /></span>
                                        <span class="table-subtitle"><fmt:formatDate value="${t.arrivalTime}" pattern="HH:mm" /></span>
                                    </td>
                                    <td>
                                        <span class="table-title"><fmt:formatNumber value="${t.price}" type="number" maxFractionDigits="0" /> đ</span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${t.status == 'Scheduled' ? 'status-scheduled' : 'status-pending'}">${t.status}</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/trip/delete?id=${t.tripID}"
                                           class="action-link"
                                           onclick="return confirm('Hủy chuyến này?');">
                                            <i class="fas fa-ban"></i>
                                            <span>Hủy chuyến</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty trips}">
                                <tr>
                                    <td colspan="8" class="empty-state">
                                        <i class="fas fa-calendar-xmark"></i>
                                        <div>Chưa có chuyến nào được lên lịch.</div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
