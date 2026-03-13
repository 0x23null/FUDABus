<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Update Phone Number - BusTicket</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .auth-container {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: radial-gradient(circle at 50% 50%, #eef2f5 0%, #e6e9ef 100%);
            padding: 40px 0;
        }

        .auth-card {
            width: 400px;
            padding: 40px;
            text-align: center;
        }

        .auth-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 24px;
        }

        .form-control {
            width: 100%;
            margin-bottom: 16px;
        }

        .btn-submit {
            width: 100%;
            height: 48px;
            background: var(--primary-color);
            color: white;
            border-radius: 12px;
            border: none;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-submit:hover {
            transform: scale(1.02);
        }

        .error-msg {
            color: var(--error-color);
            margin-bottom: 16px;
            font-size: 14px;
        }
    </style>
</head>

<body class="fade-in">
    <div class="auth-container">
        <div class="glass-panel auth-card">
            <a href="${pageContext.request.contextPath}/"
                style="display: block; margin-bottom: 20px; font-weight: 700; font-size: 20px;">BusTicket</a>
            <h2 class="auth-title">Complete Your Profile</h2>
            <p style="margin-bottom: 20px; color: var(--text-secondary); font-size: 14px;">We need your phone number to complete the registration.</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="update-phone" method="POST">
                <input type="text" name="phoneNumber" class="form-control" placeholder="Phone Number" required autofocus>
                <button type="submit" class="btn-submit">Continue</button>
            </form>
        </div>
    </div>
</body>

</html>
