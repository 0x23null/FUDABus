<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Support Center - BusTicket</title>
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
            </style>
            <!-- Add FontAwesome for icons -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body class="fade-in">
            <jsp:include page="../common/header.jsp"></jsp:include>

            <div class="container support-container">
                <!-- FAQ Section -->
                <div class="faq-section">
                    <h2>Frequently Asked Questions</h2>

                    <div class="faq-item" onclick="toggleFaq(this)">
                        <div class="faq-question">
                            How do I book a ticket?
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            Simply search for your destination on the home page, select a trip, choose your seats, and
                            proceed to payment. You'll receive an e-ticket immediately.
                        </div>
                    </div>

                    <div class="faq-item" onclick="toggleFaq(this)">
                        <div class="faq-question">
                            Can I cancel my booking?
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            Yes, you can cancel your booking from the "My Bookings" page or the payment page before
                            completion. Refunds depend on our cancellation policy.
                        </div>
                    </div>

                    <div class="faq-item" onclick="toggleFaq(this)">
                        <div class="faq-question">
                            How do I get my ticket?
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            After payment, you can download your e-ticket as a PDF immediately. You can also view it
                            anytime in your "My Bookings" history.
                        </div>
                    </div>

                    <div class="faq-item" onclick="toggleFaq(this)">
                        <div class="faq-question">
                            What payment methods are accepted?
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            We currently support VietQR (scanning via banking apps) for fast and secure transactions.
                        </div>
                    </div>
                </div>

                <!-- Contact Section -->
                <div class="contact-section">
                    <h2>Contact Us</h2>
                    <div class="contact-card">
                        <c:if test="${not empty message}">
                            <div
                                style="background: #d4edda; color: #155724; padding: 15px; border-radius: 12px; margin-bottom: 20px;">
                                ${message}
                            </div>
                        </c:if>

                        <form action="support" method="POST">
                            <div class="form-group">
                                <label>Your Name</label>
                                <input type="text" name="name" class="form-control" required placeholder="John Doe">
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" name="email" class="form-control" required
                                    placeholder="john@example.com">
                            </div>
                            <div class="form-group">
                                <label>Message</label>
                                <textarea name="message" class="form-control" required
                                    placeholder="How can we help you?"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%">Send Message</button>
                        </form>

                        <div class="contact-info">
                            <div class="info-item">
                                <i class="fas fa-phone-alt"></i>
                                <span>1900 1234 56</span>
                            </div>
                            <div class="info-item">
                                <i class="fas fa-envelope"></i>
                                <span>support@busticket.vn</span>
                            </div>
                            <div class="info-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <span>123 Pham Van Dong, Hanoi, Vietnam</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp"></jsp:include>

            <script>
                function toggleFaq(element) {
                    const wasActive = element.classList.contains('active');

                    // Close all
                    document.querySelectorAll('.faq-item').forEach(item => {
                        item.classList.remove('active');
                        item.querySelector('.fa-chevron-down').style.transform = 'rotate(0deg)';
                        // Optional: ensure CSS transition handles the rest, or strictly hide content via JS if CSS specific
                    });

                    // Toggle clicked if it wasn't active
                    if (!wasActive) {
                        element.classList.add('active');
                        element.querySelector('.fa-chevron-down').style.transform = 'rotate(180deg)';
                    }
                }
            </script>
        </body>

        </html>