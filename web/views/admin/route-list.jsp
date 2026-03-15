<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Quản lý tuyến - FUDA Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="fade-in admin-page">
    <jsp:include page="common/admin-header.jsp"></jsp:include>

    <main class="admin-shell">
        <section class="admin-hero">
            <div>
                <span class="admin-eyebrow"><i class="fas fa-route"></i> Tuyến xe</span>
                <h1>Quản lý tuyến đường</h1>
                <p>Cấu hình điểm đi, điểm đến, quãng đường và thời lượng vận hành để bước lập lịch chuyến có dữ liệu chính xác.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Về tổng quan</a>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-plus"></i> Tạo mới</span>
                    <h2>Thêm tuyến vào hệ thống</h2>
                    <p>Một tuyến rõ ràng sẽ giúp lịch chuyến, giá vé và bản đồ hành trình sau này bám đúng dữ liệu nguồn.</p>
                </div>
            </div>
            <div class="admin-panel-body">
                <form action="${pageContext.request.contextPath}/admin/route/add" method="POST">
                    <div class="admin-form-grid">
                        <div class="admin-field">
                            <label>Điểm đi</label>
                            <input type="text" name="origin" class="form-control" placeholder="Ví dụ: Hà Nội" required>
                        </div>
                        <div class="admin-field">
                            <label>Điểm đến</label>
                            <input type="text" name="destination" class="form-control" placeholder="Ví dụ: Đà Nẵng" required>
                        </div>
                        <div class="admin-field">
                            <label>Quãng đường (km)</label>
                            <input type="number" step="0.1" name="distance" class="form-control" placeholder="765" required>
                        </div>
                        <div class="admin-field">
                            <label>Thời lượng (phút)</label>
                            <input type="number" name="duration" class="form-control" placeholder="840" required>
                        </div>
                        <div class="admin-field full">
                            <label>Mô tả</label>
                            <input type="text" name="description" class="form-control" placeholder="Ghi chú ngắn cho tuyến này (không bắt buộc)">
                        </div>
                    </div>
                    <div class="admin-form-actions">
                        <button type="submit" class="btn btn-primary">Thêm tuyến</button>
                    </div>
                </form>
            </div>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-list"></i> Danh sách</span>
                    <h2>Tuyến đang được khai thác</h2>
                    <p>Rà nhanh khoảng cách, thời lượng và mô tả của từng tuyến trước khi lên lịch chạy.</p>
                </div>
            </div>
            <div class="admin-panel-body">
                <div class="table-shell">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tuyến</th>
                                <th>Quãng đường</th>
                                <th>Thời lượng</th>
                                <th>Mô tả</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${routes}" var="r">
                                <tr>
                                    <td class="mono">#${r.routeID}</td>
                                    <td>
                                        <span class="table-title">${r.origin} → ${r.destination}</span>
                                        <span class="table-subtitle">Tuyến nền để tạo các chuyến cụ thể.</span>
                                    </td>
                                    <td>
                                        <span class="table-title"><fmt:formatNumber value="${r.distance}" type="number" maxFractionDigits="1" /> km</span>
                                    </td>
                                    <td>
                                        <span class="table-title">${r.duration} phút</span>
                                    </td>
                                    <td>
                                        <span class="table-subtitle">${empty r.description ? 'Chưa có mô tả thêm.' : r.description}</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/route/delete?id=${r.routeID}"
                                           class="action-link"
                                           onclick="return confirm('Xóa tuyến này khỏi hệ thống?');">
                                            <i class="fas fa-trash-alt"></i>
                                            <span>Xóa</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty routes}">
                                <tr>
                                    <td colspan="6" class="empty-state">
                                        <i class="fas fa-route"></i>
                                        <div>Chưa có tuyến nào được tạo.</div>
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
