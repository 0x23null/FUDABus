<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bus Ticket - Book Your Journey</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <style>
            .hero-section {
                height: 80vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                text-align: center;
                background: radial-gradient(circle at 50% 50%, #eef2f5 0%, #e6e9ef 100%);
                position: relative;
                overflow: hidden;
            }

            .hero-title {
                font-size: 56px;
                font-weight: 700;
                margin-bottom: 20px;
                letter-spacing: -1px;
                background: linear-gradient(135deg, #1d1d1f 0%, #434344 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                animation: fadeIn 0.8s ease-out;
            }

            .search-card {
                background: rgba(255, 255, 255, 0.6);
                backdrop-filter: blur(40px);
                -webkit-backdrop-filter: blur(40px);
                border: 1px solid rgba(255, 255, 255, 0.5);
                padding: 40px;
                border-radius: 24px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                display: flex;
                gap: 20px;
                align-items: flex-end;
                margin-top: 40px;
                animation: fadeIn 1s ease-out 0.2s backwards;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }

            .form-label {
                font-size: 12px;
                font-weight: 600;
                color: var(--text-secondary);
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .form-control {
                width: 200px;
                height: 50px;
                border: 1px solid #d2d2d7;
                background: white;
                border-radius: 12px;
                padding: 0 16px;
                font-size: 16px;
                color: var(--text-primary);
                outline: none;
                transition: border-color 0.2s;
            }

            .form-control:focus {
                border-color: var(--primary-color);
            }

            .btn-search {
                height: 50px;
                padding: 0 40px;
                background: var(--primary-color);
                color: white;
                border-radius: 12px;
                border: none;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s, background 0.2s;
            }

            .btn-search:hover {
                transform: scale(1.02);
                background: #0077ed;
            }
        </style>
    </head>

    <body class="fade-in">
        <jsp:include page="views/common/header.jsp"></jsp:include>

        <section class="hero-section">
            <h1 class="hero-title">Where will you go next?</h1>
            <p style="font-size: 20px; color: var(--text-secondary); max-width: 600px; margin-bottom: 10px;">
                Experience the most comfortable bus journeys across the country.
            </p>

            <form action="search" method="GET" class="search-card">
                <div class="form-group">
                    <label class="form-label">Leaving from</label>
                    <select name="origin" class="form-control">
                        <option value="Ha Noi">Ha Noi</option>
                        <option value="Da Nang">Da Nang</option>
                        <option value="Ho Chi Minh">Ho Chi Minh</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Going to</label>
                    <select name="destination" class="form-control">
                        <option value="Da Nang">Da Nang</option>
                        <option value="Ha Noi">Ha Noi</option>
                        <option value="Ho Chi Minh">Ho Chi Minh</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Date</label>
                    <input type="date" name="date" class="form-control" required>
                </div>
                <button type="submit" class="btn-search">Search</button>
            </form>
        </section>

        <jsp:include page="views/common/footer.jsp"></jsp:include>

        <script src="assets/js/main.js"></script>
    </body>

    </html>