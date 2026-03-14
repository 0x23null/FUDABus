<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <jsp:include page="../common/head.jsp"></jsp:include>
            <title>Login - BusTicket</title>
            <link rel="stylesheet" href="assets/css/style.css">
            <style>
                .auth-container {
                    height: 100vh;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    background: radial-gradient(circle at 50% 50%, #eef2f5 0%, #e6e9ef 100%);
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
                    <h2 class="auth-title">Welcome Back</h2>

                    <c:if test="${not empty error}">
                        <div class="error-msg">${error}</div>
                    </c:if>

                    <form action="login" method="POST">
                        <input type="text" name="username" class="form-control" placeholder="Username" required>
                        <input type="password" name="password" class="form-control" placeholder="Password" required>
                        <button type="submit" class="btn-submit">Log In</button>
                    </form>

                    <div style="margin-top: 20px; font-size: 14px; color: var(--text-secondary);">
                        Don't have an account? <a href="register" style="color: var(--primary-color);">Sign up</a>
                    </div>

                    <div style="margin-top: 20px; border-top: 1px solid rgba(0,0,0,0.1); padding-top: 20px;">
                        <a href="login-google" style="text-decoration: none;">
                            <button type="button" class="btn btn-secondary"
                                style="width: 100%; display: flex; align-items: center; justify-content: center; gap: 10px;">
                                <!-- Google SVG Icon -->
                                <svg width="18" height="18" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M17.64 9.2045c0-.6381-.0573-1.2518-.1636-1.8409H9v3.4814h4.8436c-.2086 1.125-.8427 2.0782-1.7959 2.7164v2.2581h2.9087c1.7018-1.5668 2.6836-3.874 2.6836-6.615z"
                                        fill="#4285F4" />
                                    <path
                                        d="M9 18c2.43 0 4.4673-.806 5.9564-2.1805l-2.9087-2.2581c-.8059.54-1.8368.859-3.0477.859-2.344 0-4.3282-1.5831-5.036-3.7104H.9574v2.3318C2.4382 15.9832 5.4818 18 9 18z"
                                        fill="#34A853" />
                                    <path
                                        d="M3.964 10.71c-.18-.54-.2822-1.1168-.2822-1.71s.1023-1.17.2823-1.71V4.9582H.9573A8.9965 8.9965 0 0 0 0 9c0 1.4523.3477 2.8268.9573 4.0418L3.964 10.71z"
                                        fill="#FBBC05" />
                                    <path
                                        d="M9 3.5795c1.3214 0 2.5077.4541 3.4405 1.346l2.5813-2.5814C13.4632.8918 11.426 0 9 0 5.4818 0 2.4382 2.0168.9574 4.9582l3.0067 2.3318C4.6718 5.1627 6.656 3.5795 9 3.5795z"
                                        fill="#EA4335" />
                                </svg>
                                Sign in with Google
                            </button>
                        </a>
                    </div>
                </div>
            </div>
        </body>

        </html>