<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Trung tâm hỗ trợ - FUDA Bus</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .support-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            padding-top: 40px;
            min-height: 80vh;
        }

        .faq-section h2,
        .contact-section h2 {
            margin-bottom: 30px;
            font-weight: 700;
            color: var(--text-primary);
        }

        .faq-item {
            background: white;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .faq-item:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .faq-question {
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .faq-answer {
            margin-top: 15px;
            color: var(--text-secondary);
            display: none;
            line-height: 1.6;
            animation: fadeIn 0.3s ease;
        }

        .faq-item.active .faq-answer {
            display: block;
        }

        .faq-item.active .faq-question {
            color: var(--primary-color);
        }

        .contact-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            padding: 40px;
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: var(--shadow-lg);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #d2d2d7;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.2s;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(0, 113, 227, 0.1);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        .contact-info {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #eee;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
            color: var(--text-secondary);
        }

        .info-item i {
            width: 20px;
            text-align: center;
            color: var(--primary-color);
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-5px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 900px) {
            .support-container {
                grid-template-columns: 1fr;
                gap: 28px;
            }
        }
    </style>
</head>
<body class="fade-in">
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="container support-container">
        <div class="faq-section">
            <h2>Câu hỏi thường gặp</h2>

            <div class="faq-item" onclick="toggleFaq(this)">
                <div class="faq-question">
                    Làm sao để đặt vé trên hệ thống?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Bạn chỉ cần nhập điểm đi, điểm đến, ngày khởi hành và số hành khách ở trang chủ, sau đó chọn chuyến phù hợp, chọn ghế và chuyển sang bước thanh toán.
                </div>
            </div>

            <div class="faq-item" onclick="toggleFaq(this)">
                <div class="faq-question">
                    Tôi có thể hủy đơn đặt vé khi nào?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Với đơn đang ở trạng thái chờ thanh toán, bạn có thể mở lại trang thanh toán để hủy đơn trực tiếp trên hệ thống. Với vé đã thanh toán, vui lòng gửi yêu cầu hỗ trợ để được kiểm tra thêm.
                </div>
            </div>

            <div class="faq-item" onclick="toggleFaq(this)">
                <div class="faq-question">
                    Sau khi thanh toán tôi xem vé ở đâu?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Sau khi thanh toán thành công, vé điện tử sẽ xuất hiện ngay trên hệ thống. Bạn có thể xem lại tại trang "Vé của tôi" hoặc mở trực tiếp trang chi tiết vé để tải PDF và dùng mã QR khi lên xe.
                </div>
            </div>

            <div class="faq-item" onclick="toggleFaq(this)">
                <div class="faq-question">
                    Hệ thống đang hỗ trợ phương thức thanh toán nào?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Hiện tại hệ thống hỗ trợ thanh toán qua VNPay và Stripe. Tùy cấu hình môi trường, một số cổng thanh toán có thể bật hoặc tắt riêng.
                </div>
            </div>
        </div>

        <div class="contact-section">
            <h2>Liên hệ hỗ trợ</h2>
            <div class="contact-card">
                <c:if test="${not empty message}">
                    <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 12px; margin-bottom: 20px;">
                        ${message}
                    </div>
                </c:if>

                <form action="support" method="POST">
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="name" class="form-control" required placeholder="Ví dụ: Nguyễn Văn A">
                    </div>
                    <div class="form-group">
                        <label>Email liên hệ</label>
                        <input type="email" name="email" class="form-control" required placeholder="tenban@example.com">
                    </div>
                    <div class="form-group">
                        <label>Nội dung cần hỗ trợ</label>
                        <textarea name="message" class="form-control" required placeholder="Mô tả ngắn gọn vấn đề bạn đang gặp phải"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%">Gửi yêu cầu</button>
                </form>

                <div class="contact-info">
                    <div class="info-item">
                        <i class="fas fa-phone-alt"></i>
                        <span>1900 1234 56</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <span>support@fudabus.store</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <span>123 Phạm Văn Đồng, Hà Nội, Việt Nam</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>

    <script>
        function toggleFaq(element) {
            const wasActive = element.classList.contains('active');

            document.querySelectorAll('.faq-item').forEach((item) => {
                item.classList.remove('active');
                item.querySelector('.fa-chevron-down').style.transform = 'rotate(0deg)';
            });

            if (!wasActive) {
                element.classList.add('active');
                element.querySelector('.fa-chevron-down').style.transform = 'rotate(180deg)';
            }
        }
    </script>
</body>
</html>
