<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <jsp:include page="../common/head.jsp"></jsp:include>
            <title>Admin Dashboard - BusTicket</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
            <style>
                .dashboard-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 24px;
                    margin-top: 40px;
                }

                .dashboard-card {
                    padding: 30px;
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                    height: 200px;
                    transition: transform 0.2s;
                }

                .dashboard-card:hover {
                    transform: translateY(-5px);
                }

                .card-title {
                    font-size: 20px;
                    font-weight: 600;
                    color: var(--text-primary);
                }

                .card-desc {
                    font-size: 14px;
                    color: var(--text-secondary);
                    margin-top: 10px;
                }
            </style>
        </head>

        <body class="fade-in">
            <jsp:include page="../common/header.jsp"></jsp:include>

            <div class="container" style="padding-top: 40px; min-height: 80vh;">
                <h2 style="font-size: 32px; font-weight: 700;">Admin Dashboard</h2>
                <p style="color: var(--text-secondary);">Manage your system resources.</p>

                <div class="dashboard-grid">
                    <a href="${pageContext.request.contextPath}/admin/buses" class="glass-panel dashboard-card">
                        <div>
                            <div class="card-title">Manage Buses</div>
                            <div class="card-desc">Add, edit, or remove buses from the fleet.</div>
                        </div>
                        <div style="text-align: right; color: var(--primary-color);">Go &rarr;</div>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/routes" class="glass-panel dashboard-card">
                        <div>
                            <div class="card-title">Manage Routes</div>
                            <div class="card-desc">Configure travel routes and distances.</div>
                        </div>
                        <div style="text-align: right; color: var(--primary-color);">Go &rarr;</div>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/trips" class="glass-panel dashboard-card">
                        <div>
                            <div class="card-title">Manage Trips</div>
                            <div class="card-desc">Schedule trips, set prices and assign buses.</div>
                        </div>
                        <div style="text-align: right; color: var(--primary-color);">Go &rarr;</div>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/bookings" class="glass-panel dashboard-card">
                        <div>
                            <div class="card-title">View Bookings</div>
                            <div class="card-desc">Track customer bookings and payments.</div>
                        </div>
                        <div style="text-align: right; color: var(--primary-color);">Go &rarr;</div>
                    </a>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp"></jsp:include>
            <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        </body>

        </html>