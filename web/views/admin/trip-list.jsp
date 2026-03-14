<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <jsp:include page="../common/head.jsp"></jsp:include>
                <title>Manage Trips - BusTicket</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <style>
                    .data-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-top: 24px;
                        background: white;
                        border-radius: 12px;
                        overflow: hidden;
                    }

                    .data-table th,
                    .data-table td {
                        padding: 16px 24px;
                        text-align: left;
                        border-bottom: 1px solid #eee;
                    }

                    .data-table th {
                        background: #f9f9f9;
                        font-weight: 600;
                        font-size: 14px;
                        color: var(--text-secondary);
                    }

                    .form-inline {
                        display: flex;
                        gap: 10px;
                        margin-top: 20px;
                        background: white;
                        padding: 24px;
                        border-radius: 18px;
                        flex-wrap: wrap;
                    }

                    .form-inline input,
                    .form-inline select {
                        padding: 10px 16px;
                        border-radius: 8px;
                        border: 1px solid #d2d2d7;
                    }
                </style>
            </head>

            <body class="fade-in">
                <jsp:include page="../common/header.jsp"></jsp:include>

                <div class="container" style="padding-top: 40px; min-height: 80vh;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h2 style="font-size: 28px; font-weight: 700;">Schedule Trips</h2>
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Back to
                            Dashboard</a>
                    </div>

                    <!-- Add Trip Form -->
                    <form action="${pageContext.request.contextPath}/admin/trip/add" method="POST"
                        class="glass-panel form-inline">
                        <h4 style="width: 100%; margin-bottom: 10px;">Schedule New Trip</h4>

                        <select name="routeID" required style="width: 300px;">
                            <option value="" disabled selected>Select Route</option>
                            <c:forEach items="${routes}" var="r">
                                <option value="${r.routeID}">${r.origin} -> ${r.destination} (${r.duration}min)</option>
                            </c:forEach>
                        </select>

                        <select name="busID" required>
                            <option value="" disabled selected>Select Bus</option>
                            <c:forEach items="${buses}" var="b">
                                <option value="${b.busID}">${b.busNumber} (${b.busType})</option>
                            </c:forEach>
                        </select>

                        <input type="datetime-local" name="departureTime" required title="Departure Time"
                            class="form-control" style="width: auto;">

                        <div style="display: flex; align-items: center; gap: 5px;">
                            <input type="number" name="price" placeholder="Price (x1000 VNĐ)" required
                                class="form-control" style="width: 150px;">
                            <span style="font-size: 14px; color: var(--text-secondary);">.000 VNĐ</span>
                        </div>

                        <button type="submit" class="btn btn-primary">Schedule Trip</button>
                    </form>

                    <div
                        style="background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-sm); margin-top: 24px;">
                        <table class="data-table" style="margin-top: 0;">
                            <thead style="background: #f5f5f7; border-bottom: 1px solid #eee;">
                                <tr>
                                    <th style="padding: 15px 20px;">ID</th>
                                    <th style="padding: 15px 20px;">Route</th>
                                    <th style="padding: 15px 20px;">Bus</th>
                                    <th style="padding: 15px 20px;">Departure</th>
                                    <th style="padding: 15px 20px;">Arrival</th>
                                    <th style="padding: 15px 20px;">Price</th>
                                    <th style="padding: 15px 20px;">Status</th>
                                    <th style="padding: 15px 20px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${trips}" var="t">
                                    <tr style="border-bottom: 1px solid #f9f9f9;">
                                        <td style="padding: 15px 20px;">#${t.tripID}</td>
                                        <td style="padding: 15px 20px; font-weight: 500;">${t.route.origin} &rarr;
                                            ${t.route.destination}</td>
                                        <td style="padding: 15px 20px;">
                                            <div>${t.bus.busNumber}</div>
                                            <div style="font-size: 12px; color: var(--text-secondary);">${t.bus.busType}
                                            </div>
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <fmt:formatDate value="${t.departureTime}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <fmt:formatDate value="${t.arrivalTime}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td style="padding: 15px 20px; font-weight: 600; color: var(--text-primary);">
                                            <fmt:formatNumber value="${t.price}" type="number" maxFractionDigits="0" />
                                            VNĐ
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <span style="padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 500;
                                    background: ${t.status == 'Scheduled' ? '#d4edda' : '#f8f9fa'}; 
                                    color: ${t.status == 'Scheduled' ? '#155724' : '#6c757d'};">
                                                ${t.status}
                                            </span>
                                        </td>
                                        <td style="padding: 15px 20px;">
                                            <a href="${pageContext.request.contextPath}/admin/trip/delete?id=${t.tripID}"
                                                class="btn btn-secondary"
                                                style="padding: 6px 12px; font-size: 12px; color: #dc3545; border-color: #dc3545;"
                                                onclick="return confirm('Cancel this trip?');">Cancel</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <jsp:include page="../common/footer.jsp"></jsp:include>
                <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
            </body>

            </html>