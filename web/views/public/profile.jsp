<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Tài khoản của tôi - FUDA Bus</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        body {
            background:
                radial-gradient(circle at top left, rgba(37, 99, 235, 0.08), transparent 30%),
                linear-gradient(180deg, #f8fbff 0%, #eef4fb 100%);
        }

        .profile-shell {
            max-width: 1180px;
            margin: 32px auto 80px;
            padding: 0 20px;
        }

        .profile-layout {
            display: grid;
            grid-template-columns: minmax(0, 0.95fr) minmax(320px, 1.25fr);
            gap: 24px;
            align-items: start;
        }

        .summary-card,
        .content-card {
            background: rgba(255, 255, 255, 0.94);
            border-radius: 30px;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-md);
        }

        .summary-card {
            padding: 28px;
            position: sticky;
            top: 100px;
        }

        .content-stack {
            display: grid;
            gap: 20px;
        }

        .content-card {
            padding: 28px;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: #eff6ff;
            color: var(--primary-dark);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .summary-title {
            margin: 14px 0 8px;
            font-size: 30px;
            line-height: 1.14;
        }

        .summary-copy {
            margin: 0 0 22px;
            color: var(--text-secondary);
            line-height: 1.7;
        }

        .user-chip {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 18px;
            border-radius: 22px;
            background: linear-gradient(135deg, #f8fbff, #eef4ff);
            border: 1px solid #dbe7f8;
            margin-bottom: 20px;
        }

        .user-avatar {
            width: 54px;
            height: 54px;
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: #fff;
            font-size: 22px;
            box-shadow: 0 20px 34px -24px rgba(37, 99, 235, 0.72);
            flex-shrink: 0;
        }

        .user-chip strong {
            display: block;
            font-size: 18px;
            margin-bottom: 4px;
        }

        .user-chip span {
            color: var(--text-secondary);
            font-size: 14px;
        }

        .meta-list {
            display: grid;
            gap: 12px;
            margin-bottom: 22px;
        }

        .meta-item {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            align-items: flex-start;
            padding: 14px 16px;
            border-radius: 18px;
            background: #f8fbff;
            border: 1px solid #dbe7f8;
        }

        .meta-item span {
            color: var(--text-soft);
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
        }

        .meta-item strong {
            text-align: right;
            color: var(--text-primary);
            font-weight: 650;
        }

        .summary-note {
            border-radius: 20px;
            padding: 16px 18px;
            background: linear-gradient(135deg, #edf5ff, #f7fbff);
            border: 1px solid #d7e7fb;
            color: var(--text-secondary);
            line-height: 1.7;
        }

        .card-head {
            margin-bottom: 22px;
        }

        .card-head h2 {
            margin: 8px 0 6px;
            font-size: 22px;
        }

        .card-head p {
            margin: 0;
            color: var(--text-secondary);
        }

        .alert {
            margin-bottom: 18px;
            border-radius: 18px;
            padding: 14px 16px;
            font-weight: 600;
            border: 1px solid transparent;
        }

        .alert-success {
            background: #ecfdf3;
            border-color: #bbf7d0;
            color: #15803d;
        }

        .alert-error {
            background: #fff1f2;
            border-color: #fecdd3;
            color: #be123c;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .field-group {
            display: grid;
            gap: 8px;
        }

        .field-group.full {
            grid-column: 1 / -1;
        }

        .field-group label {
            color: var(--text-secondary);
            font-size: 14px;
            font-weight: 600;
        }

        .input-shell {
            position: relative;
        }

        .input-shell i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-soft);
            font-size: 14px;
        }

        .input-shell .form-control {
            padding-left: 44px;
        }

        .readonly-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            background: #eff6ff;
            color: var(--primary-dark);
            font-size: 12px;
            font-weight: 700;
        }

        .helper-text {
            color: var(--text-soft);
            font-size: 13px;
            line-height: 1.6;
        }

        .action-row {
            display: flex;
            justify-content: flex-end;
            margin-top: 24px;
        }

        .disabled-panel {
            border-radius: 22px;
            padding: 18px;
            background: #f8fbff;
            border: 1px dashed #c9dbf3;
            color: var(--text-secondary);
            line-height: 1.7;
        }

        @media (max-width: 960px) {
            .profile-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }
        }

        @media (max-width: 720px) {
            .profile-shell {
                padding: 0 16px;
            }

            .summary-card,
            .content-card {
                padding: 22px;
                border-radius: 24px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .summary-title {
                font-size: 26px;
            }
        }
    </style>
</head>
<body class="fade-in">
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="profile-shell">
        <div class="profile-layout">
            <aside class="summary-card">
                <span class="eyebrow"><i class="fas fa-user-circle"></i> Tài khoản</span>
                <h1 class="summary-title">Quản lý thông tin cá nhân của bạn</h1>
                <p class="summary-copy">Cập nhật liên hệ, giữ thông tin đặt vé luôn chính xác và dùng lại dữ liệu này cho những lần tìm chuyến, thanh toán và tra cứu vé tiếp theo.</p>

                <div class="user-chip">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.fullName}">
                                    ${sessionScope.user.fullName}
                                </c:when>
                                <c:otherwise>${sessionScope.user.username}</c:otherwise>
                            </c:choose>
                        </strong>
                        <span>@${sessionScope.user.username}</span>
                    </div>
                </div>

                <div class="meta-list">
                    <div class="meta-item">
                        <span>Email</span>
                        <strong>${sessionScope.user.email}</strong>
                    </div>
                    <div class="meta-item">
                        <span>Số điện thoại</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.phoneNumber}">
                                    ${sessionScope.user.phoneNumber}
                                </c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>
                    <div class="meta-item">
                        <span>Loại tài khoản</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.googleID}">Google</c:when>
                                <c:otherwise>Mật khẩu nội bộ</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>
                    <div class="meta-item">
                        <span>Ngày tham gia</span>
                        <strong><fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd/MM/yyyy" /></strong>
                    </div>
                </div>

                <div class="summary-note">
                    Thông tin ở đây sẽ được dùng lại trong các bước đặt vé và thanh toán, nên giữ dữ liệu luôn mới sẽ giúp trải nghiệm gọn và ít phải nhập lại hơn.
                </div>
            </aside>

            <div class="content-stack">
                <section class="content-card">
                    <div class="card-head">
                        <span class="eyebrow"><i class="fas fa-address-card"></i> Hồ sơ</span>
                        <h2>Thông tin cá nhân</h2>
                        <p>Chỉnh sửa họ tên, email và số điện thoại dùng cho các lần đặt vé tiếp theo.</p>
                    </div>

                    <c:if test="${not empty profileSuccess}">
                        <div class="alert alert-success">${profileSuccess}</div>
                    </c:if>
                    <c:if test="${not empty profileError}">
                        <div class="alert alert-error">${profileError}</div>
                    </c:if>

                    <form action="profile" method="post">
                        <input type="hidden" name="action" value="profile">

                        <div class="form-grid">
                            <div class="field-group full">
                                <label>Tên đăng nhập</label>
                                <div class="input-shell">
                                    <i class="fas fa-at"></i>
                                    <input type="text" class="form-control" value="${sessionScope.user.username}" readonly>
                                </div>
                            </div>

                            <div class="field-group">
                                <label>Họ và tên</label>
                                <div class="input-shell">
                                    <i class="fas fa-user"></i>
                                    <input type="text" name="fullName" class="form-control" value="${profileFormFullName}" required>
                                </div>
                            </div>

                            <div class="field-group">
                                <label>Số điện thoại</label>
                                <div class="input-shell">
                                    <i class="fas fa-phone"></i>
                                    <input type="text" name="phoneNumber" class="form-control" value="${profileFormPhoneNumber}" placeholder="Ví dụ: 0901234567">
                                </div>
                            </div>

                            <div class="field-group full">
                                <label>Email</label>
                                <div class="input-shell">
                                    <i class="fas fa-envelope"></i>
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.googleID}">
                                            <input type="email" name="email" class="form-control" value="${profileFormEmail}" readonly required>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="email" name="email" class="form-control" value="${profileFormEmail}" required>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <c:if test="${not empty sessionScope.user.googleID}">
                                    <div class="helper-text">
                                        <span class="readonly-badge"><i class="fab fa-google"></i> Khóa theo Google</span>
                                        Email của tài khoản Google được giữ cố định để tránh lệch định danh khi đăng nhập lại.
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="action-row">
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </section>

                <section class="content-card">
                    <div class="card-head">
                        <span class="eyebrow"><i class="fas fa-shield-alt"></i> Bảo mật</span>
                        <h2>Đổi mật khẩu</h2>
                        <p>Làm mới mật khẩu để tài khoản luôn an toàn hơn khi đăng nhập lại trên thiết bị khác.</p>
                    </div>

                    <c:if test="${not empty passwordSuccess}">
                        <div class="alert alert-success">${passwordSuccess}</div>
                    </c:if>
                    <c:if test="${not empty passwordError}">
                        <div class="alert alert-error">${passwordError}</div>
                    </c:if>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user.googleID}">
                            <div class="disabled-panel">
                                Tài khoản này đang đăng nhập bằng Google nên hiện chưa hỗ trợ đổi mật khẩu trực tiếp trên hệ thống.
                                Nếu cần sử dụng mật khẩu riêng cho tài khoản này, vui lòng liên hệ quản trị viên để được hướng dẫn cấu hình phù hợp.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <form action="profile" method="post">
                                <input type="hidden" name="action" value="password">

                                <div class="form-grid">
                                    <div class="field-group full">
                                        <label>Mật khẩu hiện tại</label>
                                        <div class="input-shell">
                                            <i class="fas fa-lock"></i>
                                            <input type="password" name="currentPassword" class="form-control" required>
                                        </div>
                                    </div>

                                    <div class="field-group">
                                        <label>Mật khẩu mới</label>
                                        <div class="input-shell">
                                            <i class="fas fa-key"></i>
                                            <input type="password" name="newPassword" class="form-control" minlength="8" required>
                                        </div>
                                    </div>

                                    <div class="field-group">
                                        <label>Xác nhận mật khẩu mới</label>
                                        <div class="input-shell">
                                            <i class="fas fa-check-circle"></i>
                                            <input type="password" name="confirmPassword" class="form-control" minlength="8" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="helper-text" style="margin-top: 16px;">
                                    Mật khẩu mới cần tối thiểu 8 ký tự và nên khác hoàn toàn mật khẩu hiện tại.
                                </div>

                                <div class="action-row">
                                    <button type="submit" class="btn btn-primary">Cập nhật mật khẩu</button>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
