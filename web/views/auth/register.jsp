<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Sign Up - BusTicket</title>
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
                    <h2 class="auth-title">Create Account</h2>

                    <c:if test="${not empty error}">
                        <div class="error-msg">${error}</div>
                    </c:if>

                    <form action="register" method="POST">
                        <input type="text" name="username" class="form-control" placeholder="Username" required>
                        <input type="text" name="fullName" class="form-control" placeholder="Full Name" required>
                        <input type="email" name="email" class="form-control" placeholder="Email Address" required>
                        <input type="text" name="phoneNumber" class="form-control" placeholder="Phone Number" required>
                        <input type="password" name="password" class="form-control" placeholder="Password" required>
                        <input type="password" name="confirmPassword" class="form-control"
                            placeholder="Confirm Password" required>
                        <button type="submit" class="btn-submit">Sign Up</button>
                    </form>

                    <div style="margin-top: 20px; font-size: 14px; color: var(--text-secondary);">
                        Already have an account? <a href="login" style="color: var(--primary-color);">Log in</a>
                    </div>
                </div>
            </div>
        </body>

        </html>