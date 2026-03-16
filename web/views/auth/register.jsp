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
            background:
                radial-gradient(circle at top left, rgba(15, 118, 110, 0.18), transparent 26%),
                radial-gradient(circle at top right, rgba(37, 99, 235, 0.12), transparent 28%),
                linear-gradient(180deg, #f4f8fb 0%, #eef5f3 100%);
            padding: 32px 16px;
        }

        .auth-card {
            width: min(540px, 100%);
            padding: 36px;
            text-align: left;
            overflow: hidden;
        }

        .auth-brand {
            display: inline-block;
            margin-bottom: 18px;
            font-weight: 800;
            font-size: 20px;
        }

        .auth-title {
            font-size: 30px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .auth-subtitle {
            color: var(--text-secondary);
            margin-bottom: 24px;
            line-height: 1.65;
        }

        .error-msg {
            color: #b91c1c;
            margin-bottom: 16px;
            font-size: 14px;
            background: #fff1f2;
            border: 1px solid #fecdd3;
            border-radius: 14px;
            padding: 12px 14px;
        }

        .register-form {
            position: relative;
        }

        .step-panel {
            display: none;
            animation: registerStepIn 0.24s ease;
        }

        .step-panel.active {
            display: block;
        }

        .step-heading {
            font-size: 24px;
            margin-bottom: 6px;
        }

        .step-text {
            color: var(--text-secondary);
            line-height: 1.65;
            margin-bottom: 18px;
        }

        .field-grid {
            display: grid;
            gap: 14px;
        }

        .field-note {
            margin-top: -2px;
            color: var(--text-soft);
            font-size: 12px;
            line-height: 1.5;
        }

        .form-control {
            width: 100%;
            margin-bottom: 0;
        }

        .actions-row {
            display: flex;
            gap: 12px;
            margin-top: 22px;
            align-items: center;
        }

        .btn-submit,
        .btn-secondary {
            height: 50px;
            border-radius: 14px;
            border: none;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        .btn-submit {
            flex: 1;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            box-shadow: 0 14px 28px -18px rgba(15, 118, 110, 0.8);
        }

        .btn-secondary {
            min-width: 128px;
            background: #fff;
            color: var(--text-primary);
            border: 1px solid #d7e2ef;
        }

        .btn-submit:hover,
        .btn-secondary:hover {
            transform: translateY(-1px);
        }

        .login-link {
            margin-top: 20px;
            font-size: 14px;
            color: var(--text-secondary);
            text-align: center;
        }

        .login-link a {
            color: var(--primary-color);
            font-weight: 700;
        }

        @media (max-width: 640px) {
            .auth-card {
                padding: 28px 22px;
            }

            .actions-row {
                flex-direction: column;
            }

            .btn-secondary {
                width: 100%;
            }
        }

        @keyframes registerStepIn {
            from {
                opacity: 0;
                transform: translateY(8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body class="fade-in">
    <div class="auth-container">
        <div class="glass-panel auth-card">
            <a href="${pageContext.request.contextPath}/" class="auth-brand text-gradient">FUDA Bus</a>
            <h2 class="auth-title">Tạo tài khoản mới</h2>
            <p class="auth-subtitle">
                Hoàn tất từng bước ngắn gọn để lưu lịch sử đặt vé, quản lý thông tin hành khách
                và thanh toán nhanh hơn ở những lần tiếp theo.
            </p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="register" method="POST" class="register-form" id="registerForm" data-initial-step="${empty registerStep ? 1 : registerStep}">
                <section class="step-panel" data-step="1">
<!--                    <h3 class="step-heading">Thông tin tài khoản</h3>
                    <p class="step-text">
                        Chỉ cần tên đăng nhập, họ tên và email để bắt đầu.
                    </p>-->

                    <div class="field-grid">
                        <input type="text"
                               name="username"
                               class="form-control"
                               placeholder="Tên đăng nhập"
                               value="${usernameValue}"
                               autocomplete="username"
                               pattern="[A-Za-z0-9._]{4,24}"
                               minlength="4"
                               maxlength="24"
                               required>

                        <input type="text"
                               name="fullName"
                               class="form-control"
                               placeholder="Họ và tên"
                               value="${fullNameValue}"
                               autocomplete="name"
                               required>

                        <input type="email"
                               name="email"
                               class="form-control"
                               placeholder="Địa chỉ email"
                               value="${emailValue}"
                               autocomplete="email"
                               required>
                    </div>

                    <div class="actions-row">
                        <button type="button" class="btn-submit" id="nextStepBtn">Tiếp tục</button>
                    </div>
                </section>

                <section class="step-panel" data-step="2">
<!--                    <h3 class="step-heading">Bảo mật và liên hệ</h3>
                    <p class="step-text">
                        Nhập số điện thoại và mật khẩu để hoàn tất tài khoản.
                    </p>-->

                    <div class="field-grid">
                        <input type="text"
                               name="phoneNumber"
                               class="form-control"
                               placeholder="Số điện thoại"
                               value="${phoneNumberValue}"
                               autocomplete="tel"
                               pattern="[0-9]{9,11}"
                               minlength="9"
                               maxlength="11"
                               required>

                        <input type="password"
                               name="password"
                               class="form-control"
                               placeholder="Mật khẩu"
                               autocomplete="new-password"
                               required>

                        <input type="password"
                               name="confirmPassword"
                               class="form-control"
                               placeholder="Nhập lại mật khẩu"
                               autocomplete="new-password"
                               required>
                    </div>

                    <div class="actions-row">
                        <button type="button" class="btn-secondary" id="prevStepBtn">Quay lại</button>
                        <button type="submit" class="btn-submit">Đăng ký</button>
                    </div>
                </section>
            </form>

            <div class="login-link">
                Đã có tài khoản? <a href="login">Đăng nhập</a>
            </div>
        </div>
    </div>

    <script>
        (function () {
            const form = document.getElementById('registerForm');
            if (!form) {
                return;
            }

            const panels = Array.from(form.querySelectorAll('.step-panel'));
            const nextBtn = document.getElementById('nextStepBtn');
            const prevBtn = document.getElementById('prevStepBtn');
            const initialStep = Number(form.dataset.initialStep || '1');
            let currentStep = initialStep === 2 ? 2 : 1;

            const stepFields = {
                1: Array.from(form.querySelectorAll('[name="username"], [name="fullName"], [name="email"]')),
                2: Array.from(form.querySelectorAll('[name="phoneNumber"], [name="password"], [name="confirmPassword"]'))
            };

            function renderStep(step) {
                currentStep = step;
                panels.forEach((panel) => {
                    panel.classList.toggle('active', Number(panel.dataset.step) === step);
                });
            }

            function validateCurrentStep() {
                const fields = stepFields[currentStep] || [];
                for (const field of fields) {
                    if (!field.reportValidity()) {
                        field.focus();
                        return false;
                    }
                }
                return true;
            }

            nextBtn.addEventListener('click', function () {
                if (validateCurrentStep()) {
                    renderStep(2);
                }
            });

            prevBtn.addEventListener('click', function () {
                renderStep(1);
            });

            renderStep(currentStep);
        })();
    </script>
</body>
</html>
