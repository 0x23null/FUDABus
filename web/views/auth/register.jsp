<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>&#272;&#259;ng k&#253; - FUDA Bus</title>
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
            <h2 class="auth-title">T&#7841;o t&#224;i kho&#7843;n m&#7899;i</h2>
            <p class="auth-subtitle">L&#432;u l&#7883;ch s&#7917; &#273;&#7863;t v&#233;, qu&#7843;n l&#253; th&#244;ng tin h&#224;nh kh&#225;ch v&#224; thanh to&#225;n thu&#7853;n ti&#7879;n h&#417;n &#7903; nh&#7919;ng l&#7847;n ti&#7871;p theo.</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="register" method="POST">
                <input type="text" name="username" class="form-control" placeholder="T&#234;n &#273;&#259;ng nh&#7853;p" required>
                <input type="text" name="fullName" class="form-control" placeholder="H&#7885; v&#224; t&#234;n" required>
                <input type="email" name="email" class="form-control" placeholder="&#272;&#7883;a ch&#7881; email" required>
                <input type="text" name="phoneNumber" class="form-control" placeholder="S&#7889; &#273;i&#7879;n tho&#7841;i" required>
                <input type="password" name="password" class="form-control" placeholder="M&#7853;t kh&#7849;u" required>
                <input type="password" name="confirmPassword" class="form-control" placeholder="Nh&#7853;p l&#7841;i m&#7853;t kh&#7849;u" required>
                <button type="submit" class="btn-submit">&#272;&#259;ng k&#253;</button>
            </form>

            <div style="margin-top: 18px; font-size: 14px; color: var(--text-secondary);">
                &#272;&#227; c&#243; t&#224;i kho&#7843;n? <a href="login" style="color: var(--primary-color); font-weight: 700;">&#272;&#259;ng nh&#7853;p</a>
            </div>
        </div>
    </div>
</body>
</html>