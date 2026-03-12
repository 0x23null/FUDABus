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

            /* Search Box Layout - Floating Bottom */
            .search-container {
                margin-top: -80px;
                /* More overlap */
                position: relative;
                z-index: 20;
                padding: 0 24px;
                margin-bottom: 40px;
            }

            .search-box {
                background: white;
                border-radius: 24px;
                padding: 32px;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
                display: grid;
                grid-template-columns: 1fr 1fr 1fr auto;
                gap: 24px;
                max-width: 1100px;
                margin: 0 auto;
                border: 1px solid var(--border-color);
                align-items: end;
            }

            .form-group-hero label {
                color: var(--text-secondary);
                font-size: 13px;
                font-weight: 600;
                text-transform: uppercase;
                display: block;
                margin-bottom: 8px;
                letter-spacing: 0.5px;
            }

            .form-control-hero {
                background: #f1f5f9;
                border: none;
                padding: 16px;
                border-radius: 12px;
                width: 100%;
                font-weight: 600;
                color: var(--text-primary);
                font-size: 16px;
                transition: all 0.2s;
            }

            .form-control-hero:focus {
                background: white;
                box-shadow: inset 0 0 0 2px var(--primary-color);
                outline: none;
            }

            .btn-search {
                height: 54px;
                padding: 0 40px;
                font-size: 16px;
                background: var(--primary-color);
                border-radius: 12px;
                color: white;
                border: none;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.2s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-search:hover {
                background: var(--primary-dark);
                transform: translateY(-2px);
                box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
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
            <form action="search" method="GET" class="search-box">
                <div class="form-group-hero">
                    <label><i class="fas fa-map-marker-alt" style="margin-right: 6px; color: var(--primary-color);"></i>
                        From</label>
                    <select name="origin" class="form-control-hero" required>
                        <option value="" disabled selected>Select Origin</option>
                        <option value="Ha Noi">Ha Noi</option>
                        <option value="Da Nang">Da Nang</option>
                        <option value="Ho Chi Minh City">Ho Chi Minh City</option>
                        <option value="Sa Pa">Sa Pa</option>
                        <option value="Quang Ninh">Quang Ninh</option>
                    </select>
                </div>

                <div class="form-group-hero">
                    <label><i class="fas fa-location-arrow" style="margin-right: 6px; color: var(--accent-color);"></i>
                        To</label>
                    <select name="destination" class="form-control-hero" required>
                        <option value="" disabled selected>Select Destination</option>
                        <option value="Ha Noi">Ha Noi</option>
                        <option value="Da Nang">Da Nang</option>
                        <option value="Ho Chi Minh City">Ho Chi Minh City</option>
                        <option value="Sa Pa">Sa Pa</option>
                        <option value="Ninh Binh">Ninh Binh</option>
                    </select>
                </div>

                <div class="form-group-hero">
                    <label><i class="far fa-calendar-alt" style="margin-right: 6px; color: var(--warning);"></i>
                        Date</label>
                    <input type="date" name="date" class="form-control-hero" required>
                </div>

                <button type="submit" class="btn-search">
                    Search <i class="fas fa-arrow-right"></i>
                </button>
            </form>
        </div>

        <!-- Why Choose Us Section -->
        <div style="background-color: #f8f9fa; padding: 60px 0; margin-top: 40px;">
            <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 24px;">
                <div style="text-align: center; margin-bottom: 40px;">
                    <h2 style="font-size: 28px; font-weight: 700; margin-bottom: 8px; color: var(--text-primary);">Why
                        Choose Vivu?</h2>
                    <p style="color: var(--text-secondary);">We provide the best experience for your journey</p>
                </div>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 40px;">
                    <div style="text-align: center; padding: 20px;">
                        <div
                            style="width: 70px; height: 70px; background: rgba(59, 130, 246, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <i class="fas fa-shield-alt" style="font-size: 30px; color: var(--primary-color);"></i>
                        </div>
                        <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 12px; color: var(--text-primary);">
                            Top Notch Security</h3>
                        <p style="color: var(--text-secondary); line-height: 1.6;">Safety is our number one priority. We
                            work with the most reliable bus operators.</p>
                    </div>
                    <div style="text-align: center; padding: 20px;">
                        <div
                            style="width: 70px; height: 70px; background: rgba(16, 185, 129, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <i class="fas fa-headset" style="font-size: 30px; color: #10b981;"></i>
                        </div>
                        <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 12px; color: var(--text-primary);">
                            24/7 Support</h3>
                        <p style="color: var(--text-secondary); line-height: 1.6;">Our customer service team is ready to
                            assist you anytime, anywhere.</p>
                    </div>
                    <div style="text-align: center; padding: 20px;">
                        <div
                            style="width: 70px; height: 70px; background: rgba(245, 158, 11, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <i class="fas fa-tags" style="font-size: 30px; color: #f59e0b;"></i>
                        </div>
                        <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 12px; color: var(--text-primary);">
                            Best Prices</h3>
                        <p style="color: var(--text-secondary); line-height: 1.6;">Competitive rates and frequent
                            promotions to help you save on every trip.</p>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const selects = document.querySelectorAll('.form-control-hero:not([type="date"])');
                selects.forEach(select => {
                    new Choices(select, { searchEnabled: false, itemSelectText: '', shouldSort: false, placeholder: true });
                });
                flatpickr("input[type=date]", { minDate: "today", dateFormat: "Y-m-d", altInput: true, altFormat: "F j, Y", disableMobile: "true" });
            });
        </script>
        <jsp:include page="../common/footer.jsp"></jsp:include>
    </body>

    </html>
