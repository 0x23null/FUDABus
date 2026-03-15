<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Quản lý xe - FUDA Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="fade-in admin-page">
    <jsp:include page="common/admin-header.jsp"></jsp:include>

    <main class="admin-shell">
        <section class="admin-hero">
            <div>
                <span class="admin-eyebrow"><i class="fas fa-bus"></i> Đội xe</span>
                <h1>Quản lý phương tiện</h1>
                <p>Thêm xe mới vào hệ thống, chuẩn hóa số xe, loại xe và sức chứa để phần lập chuyến phía sau luôn dùng đúng dữ liệu.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Về tổng quan</a>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-plus"></i> Tạo mới</span>
                    <h2>Thêm xe vào đội vận hành</h2>
                    <p>Mỗi xe nên có số hiệu rõ ràng và đúng loại cấu hình ghế để dễ sử dụng ở bước tạo chuyến.</p>
                </div>
            </div>
            <div class="admin-panel-body">
                <form action="${pageContext.request.contextPath}/admin/bus/add" method="POST">
                    <div class="admin-form-grid">
                        <div class="admin-field">
                            <label>Số xe</label>
                            <input type="text" name="busNumber" class="form-control" placeholder="Ví dụ: 29B-12345" required>
                        </div>
                        <div class="admin-field">
                            <label>Sức chứa</label>
                            <input type="number" name="seatCapacity" class="form-control" placeholder="40" min="1" required>
                        </div>
                        <div class="admin-field">
                            <label>Loại xe</label>
                            <select name="busType" class="form-control">
                                <option value="Sleeper">Sleeper</option>
                                <option value="Seater">Seater</option>
                                <option value="Limousine">Limousine</option>
                            </select>
                        </div>
                        <div class="admin-field">
                            <label>Ảnh minh họa</label>
                            <input type="text" name="imageURL" class="form-control" placeholder="URL ảnh (không bắt buộc)">
                        </div>
                    </div>
                    <div class="admin-form-actions">
                        <button type="submit" class="btn btn-primary">Thêm xe</button>
                    </div>
                </form>
            </div>
        </section>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <span class="admin-eyebrow"><i class="fas fa-list"></i> Danh sách</span>
                    <h2>Xe đang có trong hệ thống</h2>
                    <p>Rà nhanh sức chứa, loại xe và dọn các dữ liệu không còn dùng tới.</p>
                </div>
            </div>
            <div class="admin-panel-body">
                <div class="table-shell">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Xe</th>
                                <th>Sức chứa</th>
                                <th>Loại xe</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${buses}" var="b">
                                <tr>
                                    <td class="mono">#${b.busID}</td>
                                    <td>
                                        <span class="table-title">${b.busNumber}</span>
                                        <span class="table-subtitle">${empty b.imageURL ? 'Chưa có ảnh minh họa.' : 'Đã có ảnh minh họa cho xe này.'}</span>
                                    </td>
                                    <td>
                                        <span class="table-title">${b.seatCapacity} ghế</span>
                                        <span class="table-subtitle">Dùng cho bước chọn ghế khi đặt vé.</span>
                                    </td>
                                    <td>
                                        <span class="status-badge status-scheduled">${b.busType}</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/bus/delete?id=${b.busID}"
                                           class="action-link"
                                           onclick="return confirm('Xóa xe này khỏi hệ thống?');">
                                            <i class="fas fa-trash-alt"></i>
                                            <span>Xóa</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty buses}">
                                <tr>
                                    <td colspan="5" class="empty-state">
                                        <i class="fas fa-bus"></i>
                                        <div>Chưa có xe nào được tạo.</div>
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
