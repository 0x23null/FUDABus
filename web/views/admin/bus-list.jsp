<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <jsp:include page="../common/head.jsp"></jsp:include>
            <title>Manage Buses - BusTicket</title>
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
                    <h2 style="font-size: 28px; font-weight: 700;">Bus Management</h2>
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Back to Dashboard</a>
                </div>

                <!-- Add Bus Form -->
                <form action="${pageContext.request.contextPath}/admin/bus/add" method="POST"
                    class="glass-panel form-inline">
                    <h4 style="width: 100%; margin-bottom: 10px;">Add New Bus</h4>
                    <input type="text" name="busNumber" placeholder="Bus Number (e.g. 29B-12345)" required>
                    <input type="number" name="seatCapacity" placeholder="Capacity" required>
                    <select name="busType">
                        <option value="Sleeper">Sleeper</option>
                        <option value="Seater">Seater</option>
                        <option value="Limousine">Limousine</option>
                    </select>
                    <input type="text" name="imageURL" placeholder="Image URL (Optional)">
                    <button type="submit" class="btn btn-primary">Add Bus</button>
                </form>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Bus Number</th>
                            <th>Capacity</th>
                            <th>Type</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${buses}" var="b">
                            <tr>
                                <td>${b.busID}</td>
                                <td>${b.busNumber}</td>
                                <td>${b.seatCapacity}</td>
                                <td>${b.busType}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/bus/delete?id=${b.busID}"
                                        class="btn btn-secondary"
                                        style="padding: 6px 12px; font-size: 12px; color: var(--error-color);"
                                        onclick="return confirm('Delete this bus?');">Delete</a>
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