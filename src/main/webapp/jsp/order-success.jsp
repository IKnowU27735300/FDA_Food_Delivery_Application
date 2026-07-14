<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <%
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            orderIdStr = "N/A";
        }
    %>

    <div class="success-card glass">
        <div class="success-icon">
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
        </div>
        <h2 style="font-weight: 800; font-size: 28px; margin-bottom: 12px; color: #ffffff;">Order Placed Successfully!</h2>
        <p style="color: var(--text-secondary); font-size: 15px; margin-bottom: 8px;">Thank you for shopping at Fashion Vault.</p>
        <p style="color: var(--text-secondary); font-size: 14px; margin-bottom: 30px;">Your order reference is <span style="font-weight: 700; color: var(--accent-color);">#<%= orderIdStr %></span>. You will receive an update shortly.</p>
        
        <div style="display: flex; justify-content: center; gap: 20px;">
            <a href="<%= request.getContextPath() %>/orders" class="btn-premium btn-secondary">View Order History</a>
            <a href="<%= request.getContextPath() %>/home" class="btn-premium">Continue Shopping</a>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
