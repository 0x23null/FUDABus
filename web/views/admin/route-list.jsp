<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <jsp:include page="../common/head.jsp"></jsp:include>
            <title>Manage Routes - BusTicket</title>
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
                    <h2 style="font-size: 28px; font-weight: 700;">Route Management</h2>
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Back to Dashboard</a>
                </div>

                <!-- Add Route Form -->
                <form action="${pageContext.request.contextPath}/admin/route/add" method="POST"
                    class="glass-panel form-inline">
                    <h4 style="width: 100%; margin-bottom: 10px;">Add New Route</h4>
                    <input type="text" name="origin" placeholder="Origin (e.g. Ha Noi)" required>
                    <input type="text" name="destination" placeholder="Destination (e.g. Da Nang)" required>
                    <input type="number" step="0.1" name="distance" placeholder="Distance (km)" required>
                    <input type="number" name="duration" placeholder="Duration (mins)" required>
                    <input type="text" name="description" placeholder="Description" style="flex-grow: 1;">
                    <button type="submit" class="btn btn-primary">Add Route</button>
                </form>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Origin</th>
                            <th>Destination</th>
                            <th>Distance (km)</th>
                            <th>Duration (min)</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${routes}" var="r">
                            <tr>
                                <td>${r.routeID}</td>
                                <td>${r.origin}</td>
                                <td>${r.destination}</td>
                                <td>${r.distance}</td>
                                <td>${r.duration}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/route/delete?id=${r.routeID}"
                                        class="btn btn-secondary"
                                        style="padding: 6px 12px; font-size: 12px; color: var(--error-color);"
                                        onclick="return confirm('Delete this route?');">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <jsp:include page="../common/footer.jsp"></jsp:include>
            <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        </body>

        </html>