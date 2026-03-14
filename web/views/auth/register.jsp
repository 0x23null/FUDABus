<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Đăng ký - FUDA Bus</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .auth-container {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: radial-gradient(circle at top, #f3ede0 0%, #e9f4f1 38%, #f7f4ee 100%);
            padding: 32px 16px;
        }

        .auth-card {
            width: min(460px, 100%);
            padding: 36px;
            text-align: center;
        }

        .auth-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .auth-subtitle {
            color: var(--text-secondary);
            margin-bottom: 26px;
        }

        .form-control {
            width: 100%;
            margin-bottom: 14px;
        }

        .btn-submit {
            width: 100%;
            height: 48px;
            background: var(--primary-color);
            color: white;
            border-radius: 14px;
            border: none;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 14px 28px -18px rgba(15, 118, 110, 0.8);
        }

        .btn-submit:hover {
            transform: translateY(-1px);
        }

        .error-msg {
            color: #b91c1c;
            margin-bottom: 16px;
            font-size: 14px;
            background: #fff1f2;
            border: 1px solid #fecdd3;
            border-radius: 12px;
            padding: 12px 14px;
        }
    </style>
</head>
<body class="fade-in">
    <div class="auth-container">
        <div class="glass-panel auth-card">
            <a href="${pageContext.request.contextPath}/" style="display: block; margin-bottom: 18px; font-weight: 800; font-size: 20px;" class="text-gradient">FUDA Bus</a>
            <h2 class="auth-title">Tạo tài khoản mới</h2>
            <p class="auth-subtitle">Lưu lịch sử đặt vé, quản lý thông tin hành khách và thanh toán thuận tiện hơn ở những lần tiếp theo.</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="register" method="POST">
                <input type="text" name="username" class="form-control" placeholder="Tên đăng nhập" required>
                <input type="text" name="fullName" class="form-control" placeholder="Họ và tên" required>
                <input type="email" name="email" class="form-control" placeholder="Địa chỉ email" required>
                <input type="text" name="phoneNumber" class="form-control" placeholder="Số điện thoại" required>
                <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required>
                <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required>
                <button type="submit" class="btn-submit">Đăng ký</button>
            </form>

            <div style="margin-top: 18px; font-size: 14px; color: var(--text-secondary);">
                Đã có tài khoản? <a href="login" style="color: var(--primary-color); font-weight: 700;">Đăng nhập</a>
            </div>
        </div>
    </div>
</body>
</html>
