<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Vivu - Where Every Ride Feels Magical</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <!-- Libs CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <link rel="stylesheet" href="https://npmcdn.com/flatpickr/dist/themes/airbnb.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
        <style>
            /* Modern Reset & Base */
            body {
                background-color: #f8fafc;
                overflow-x: hidden;
            }

            /* Hero Section Redesign */
            .hero-wrapper {
                width: 100%;
                padding: 0;
                margin: 0;
            }

            .hero-section {
                background: linear-gradient(rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.4)),
                url('${pageContext.request.contextPath}/assets/images/bus_home.png?v=2');
                background-size: cover;
                background-position: center;
                height: 480px;
                /* Reduced height for better visibility without scrolling */
                position: relative;
                display: flex;
                align-items: center;
                justify-content: center;
                /* Center content */
                text-align: center;
                padding: 0 20px;
                /* No border radius for full width impact */
                border-radius: 0;
            }

            /* Fallback if image fails */
            .hero-section.no-image {
                background: linear-gradient(120deg, #3b82f6, #06b6d4);
            }

            /* Animations */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                    filter: blur(10px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                    filter: blur(0);
                }
            }

            @keyframes textShimmer {
                0% {
                    background-position: 0% 50%;
                }

                50% {
                    background-position: 100% 50%;
                }

                100% {
                    background-position: 0% 50%;
                }
            }

            .hero-content {
                z-index: 10;
                color: white;
                max-width: 800px;
                margin-top: -40px;
            }

            .hero-label {
                font-size: 14px;
                letter-spacing: 4px;
                /* Increased spacing */
                text-transform: uppercase;
                font-weight: 700;
                margin-bottom: 16px;
                display: inline-block;
                background: rgba(255, 255, 255, 0.15);
                /* Glass badge */
                backdrop-filter: blur(4px);
                padding: 8px 16px;
                border-radius: 50px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards;
                opacity: 0;
                /* Start hidden for animation */
            }

            .hero-title {
                font-family: 'Inter', sans-serif;
                /* Modern Font */
                font-size: 64px;
                font-weight: 800;
                line-height: 1.1;
                margin-bottom: 24px;
                color: #ffffff !important;
                text-shadow: 0 4px 30px rgba(0, 0, 0, 0.5);
                animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) 0.2s forwards;
                opacity: 0;
            }

            .highlight-magical {
                background: none;
                color: #FFD700;
                /* Solid Gold - Solar Yellow */
                -webkit-text-fill-color: #FFD700;
                animation: none;
                /* Remove shimmer */
                display: inline-block;
                font-weight: 800;
                text-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
                /* Subtle Glow */
            }

            .hero-buttons {
                display: flex;
                gap: 16px;
                align-items: center;
                justify-content: center;
            }

            .btn-play {
                width: 50px;
                height: 50px;
                background: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--primary-color);
                transition: transform 0.2s;
                cursor: pointer;
            }

            .btn-play:hover {
                transform: scale(1.1);
            }

            /* Search Box Layout - Vexere Style */
            .search-container {
                margin-top: -60px;
                position: relative;
                z-index: 20;
                padding: 0 24px;
                margin-bottom: 80px;
            }

            .search-box {
                background: white;
                border-radius: 16px;
                padding: 24px 32px 40px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                max-width: 1000px;
                margin: 0 auto;
                border: 2px solid #c7d2fe; /* Light blue border */
                position: relative;
            }

            .search-top-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                border-bottom: 1px solid #f1f5f9;
                padding-bottom: 16px;
            }

            .trip-type-radios {
                display: flex;
                gap: 24px;
            }

            .radio-label {
                display: flex;
                align-items: center;
                gap: 8px;
                cursor: pointer;
                font-size: 15px;
                font-weight: 500;
                color: var(--text-primary);
            }

            .radio-label input[type="radio"] {
                accent-color: var(--primary-color);
                width: 18px;
                height: 18px;
            }

            .guide-link {
                color: var(--primary-color);
                font-size: 14px;
                font-weight: 500;
            }

            .search-inputs-row {
                display: flex;
                align-items: center;
                gap: 12px;
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 12px 16px;
            }

            .input-group {
                flex: 1;
                display: flex;
                flex-direction: column;
                position: relative;
            }
            .input-group:not(:last-child)::after {
                content: '';
                position: absolute;
                right: -6px;
                top: 10%;
                height: 80%;
                width: 1px;
                background: #e2e8f0;
            }
            
            .swap-btn-container {
                 position: relative;
                 width: 0;
                 display: flex;
                 justify-content: center;
                 align-items: center;
                 z-index: 2;
            }

            .swap-btn {
                 background: white;
                 border: 1px solid #e2e8f0;
                 border-radius: 50%;
                 width: 32px;
                 height: 32px;
                 display: flex;
                 justify-content: center;
                 align-items: center;
                 color: var(--text-secondary);
                 cursor: pointer;
                 position: absolute;
                 transition: all 0.2s;
            }
            .swap-btn:hover {
                 background: #f1f5f9;
                 color: var(--primary-color);
            }

            .input-group label {
                font-size: 13px;
                color: var(--text-secondary);
                font-weight: 500;
                margin-bottom: 4px;
            }

            .input-group input, .input-group select {
                border: none;
                background: transparent;
                font-size: 16px;
                font-weight: 600;
                color: var(--text-primary);
                width: 100%;
                outline: none;
                cursor: pointer;
            }

            .submit-wrapper {
                position: absolute;
                bottom: -24px;
                left: 0;
                right: 0;
                display: flex;
                justify-content: center;
            }

            .btn-search-new {
                background: var(--primary-color); 
                color: white;
                border: none;
                padding: 14px 60px;
                border-radius: 30px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(79, 70, 229, 0.3);
                transition: all 0.2s;
            }
            .btn-search-new:hover {
                background: var(--primary-dark);
                transform: translateY(-2px);
            }

            /* Choices.js & Flatpickr Customization */
            .choices {
                margin-bottom: 0;
            }

            .choices__inner {
                background-color: #f1f5f9;
                border: 1px solid transparent;
                border-radius: 12px;
                min-height: 54px;
                display: flex;
                align-items: center;
                padding: 0 16px;
                font-size: 16px;
                font-weight: 600;
            }

            .choices__list--dropdown {
                border-radius: 12px;
                border: none;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                margin-top: 8px;
                z-index: 100;
            }

            .choices__list--dropdown .choices__item--selectable.is-highlighted {
                background-color: var(--primary-color);
                color: white;
            }

            .flatpickr-input {
                background: #f1f5f9 !important;
                border: none !important;
                padding: 16px !important;
                border-radius: 12px !important;
                width: 100%;
                font-weight: 600;
                color: var(--text-primary);
                font-size: 16px;
                height: 54px;
                transition: all 0.2s;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .hero-section {
                    height: auto;
                    padding: 40px 24px;
                    border-radius: 24px;
                }

                .hero-title {
                    font-size: 40px;
                }

                .search-box {
                    grid-template-columns: 1fr;
                    margin-top: 24px;
                }

                .search-container {
                    margin-top: -40px;
                    padding: 0 12px;
                }
            }
        </style>
    </head>

    <body class="fade-in">
        <jsp:include page="../common/header.jsp"></jsp:include>

        <div class="hero-wrapper">
            <div class="hero-section">
                <div class="hero-content">
                    <div class="hero-label">BUS YOUR TRAVEL JOURNEY</div>
                    <h1 class="hero-title">Where Every Bus Ride Feels <span class="highlight-magical">Magical!</span>
                    </h1>
                </div>
            </div>
        </div>

        <!-- Search Section -->
        <div class="search-container" id="search-section">
            <form action="search" method="GET" class="search-box fade-in">
                <!-- Top Row Tabs -->
                <div class="search-top-row">
                    <div class="trip-type-radios">
                        <label class="radio-label">
                            <input type="radio" name="tripType" value="oneWay" checked onchange="toggleReturnDate(false)">
                            Một chiều
                        </label>
                        <label class="radio-label">
                            <input type="radio" name="tripType" value="roundTrip" onchange="toggleReturnDate(true)">
                            Khứ hồi
                        </label>
                    </div>
                    <a href="#" class="guide-link">Hướng dẫn mua vé</a>
                </div>
                
                <!-- Inputs Row -->
                <div class="search-inputs-row" id="searchFieldsGroup">
                    <!-- Origin -->
                    <div class="input-group">
                        <label>Điểm đi</label>
                        <input type="text" name="origin" list="locationsList" placeholder="Chọn điểm đi" required>
                    </div>
                    
                    <!-- Swap Icon -->
                    <div class="swap-btn-container">
                        <button type="button" class="swap-btn" onclick="swapLocations()">
                            <i class="fas fa-exchange-alt"></i>
                        </button>
                    </div>
                    
                    <!-- Destination -->
                    <div class="input-group" style="padding-left: 16px;">
                        <label>Điểm đến</label>
                        <input type="text" name="destination" list="locationsList" placeholder="Chọn điểm đến" required>
                    </div>
                    
                    <!-- Departure Date -->
                    <div class="input-group">
                        <label>Ngày đi</label>
                        <input type="date" name="date" id="departureDate" required>
                    </div>
                    
                    <!-- Return Date -->
                    <div class="input-group" id="returnDateGroup" style="display: none;">
                        <label>Ngày về</label>
                        <input type="date" name="returnDate" id="returnDate" placeholder="Thêm ngày về">
                    </div>
                    
                    <!-- Ticket Count -->
                    <div class="input-group">
                        <label>Số vé</label>
                        <select name="ticketCount" class="ticket-select">
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </div>
                </div>
                
                <div class="submit-wrapper">
                    <button type="submit" class="btn-search-new">Tìm chuyến xe</button>
                </div>
            </form>

            <datalist id="locationsList">
                <option value="Hà Nội">
                <option value="Hồ Chí Minh">
                <option value="Đà Nẵng">
                <option value="Hải Phòng">
                <option value="Cần Thơ">
                <option value="Đà Lạt">
                <option value="Nha Trang">
                <option value="Vũng Tàu">
                <option value="Quy Nhơn">
                <option value="Phú Quốc">
                <option value="Huế">
                <option value="Hạ Long">
            </datalist>
        </div>

        <!-- Why Choose Us Section -->
        <div style="background-color: #f8f9fa; padding: 60px 0;">
            <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 24px;">
                <div style="text-align: center; margin-bottom: 40px;">
                    <h2 style="font-size: 28px; font-weight: 700; margin-bottom: 8px; color: var(--text-primary);">Tại sao chọn Vivu?</h2>
                    <p style="color: var(--text-secondary);">Chúng tôi mang đến trải nghiệm tốt nhất cho hành trình của bạn</p>
                </div>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 40px;">
                    <div style="text-align: center; padding: 20px;">
                        <div style="width: 70px; height: 70px; background: rgba(59, 130, 246, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <i class="fas fa-shield-alt" style="font-size: 30px; color: var(--primary-color);"></i>
                        </div>
                        <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 12px; color: var(--text-primary);">An Toàn Tuyệt Đối</h3>
                        <p style="color: var(--text-secondary); line-height: 1.6;">Sự an toàn của bạn là ưu tiên hàng đầu. Chúng tôi hợp tác với các nhà xe uy tín nhất toàn quốc.</p>
                    </div>
                    <div style="text-align: center; padding: 20px;">
                        <div style="width: 70px; height: 70px; background: rgba(16, 185, 129, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <i class="fas fa-headset" style="font-size: 30px; color: #10b981;"></i>
                        </div>
                        <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 12px; color: var(--text-primary);">Hỗ Trợ 24/7</h3>
                        <p style="color: var(--text-secondary); line-height: 1.6;">Đội ngũ chăm sóc khách hàng luôn sẵn sàng hỗ trợ bạn mọi lúc, mọi nơi, giải quyết mọi thắc mắc.</p>
                    </div>
                    <div style="text-align: center; padding: 20px;">
                        <div style="width: 70px; height: 70px; background: rgba(245, 158, 11, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <i class="fas fa-tags" style="font-size: 30px; color: #f59e0b;"></i>
                        </div>
                        <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 12px; color: var(--text-primary);">Giá Tốt Nhất</h3>
                        <p style="color: var(--text-secondary); line-height: 1.6;">Mức giá cạnh tranh và các chương trình khuyến mãi thường xuyên giúp bạn tiết kiệm chi phí.</p>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script>
            // UI Toggle Logics
            function toggleReturnDate(show) {
                const returnGroup = document.getElementById('returnDateGroup');
                const returnInput = document.getElementById('returnDate');
                if (show) {
                    returnGroup.style.display = 'flex';
                    returnInput.setAttribute('required', 'true');
                } else {
                    returnGroup.style.display = 'none';
                    returnInput.removeAttribute('required');
                    returnInput.value = '';
                }
            }

            function swapLocations() {
                const origin = document.querySelector('input[name="origin"]');
                const dest = document.querySelector('input[name="destination"]');
                const temp = origin.value;
                origin.value = dest.value;
                dest.value = temp;
            }

            document.addEventListener('DOMContentLoaded', function () {
                const today = new Date().toISOString().split('T')[0];
                flatpickr("#departureDate", { minDate: "today", dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y, l", disableMobile: "true" });
                flatpickr("#returnDate", { minDate: "today", dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y, l", disableMobile: "true" });
            });
        </script>
        <jsp:include page="../common/footer.jsp"></jsp:include>
    </body>

    </html>
