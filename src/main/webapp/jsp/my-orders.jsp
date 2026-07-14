<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.tap.model.Order, com.tap.model.User, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <%
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy - hh:mm a");
    %>

    <div class="profile-grid">
        <!-- Sidebar Navigation -->
        <aside class="profile-nav-card glass">
            <ul class="profile-nav-links">
                <li><a href="<%= request.getContextPath() %>/profile">My Profile</a></li>
                <li><a href="<%= request.getContextPath() %>/orders" class="active">Order History</a></li>
                <li><a href="<%= request.getContextPath() %>/login?action=logout" style="color: var(--red);">Log Out</a></li>
            </ul>
        </aside>

        <!-- Orders History -->
        <main>
            <h2 style="font-weight: 800; font-size: 28px; margin-bottom: 30px; color: #ffffff;">Order History</h2>

            <% if (orders != null && !orders.isEmpty()) { 
                for (Order o : orders) {
            %>
            <div class="order-card glass">
                <div class="order-meta">
                    <h5 style="color: #ffffff;">Order #<%= o.getId() %></h5>
                    <p><%= sdf.format(o.getCreatedAt()) %> | Total: <span style="font-weight:600; color: var(--accent-color);">₹<%= String.format("%.2f", o.getTotalAmount()) %></span></p>
                </div>
                
                <div style="display: flex; align-items: center; gap: 20px;">
                    <span class="order-badge <%= "DELIVERED".equalsIgnoreCase(o.getOrderStatus()) ? "badge-completed" : ("SHIPPED".equalsIgnoreCase(o.getOrderStatus()) ? "badge-shipped" : "badge-pending") %>">
                        <%= o.getOrderStatus() %>
                    </span>
                    <a href="<%= request.getContextPath() %>/orders?action=details&id=<%= o.getId() %>" class="btn-premium btn-secondary" style="padding: 8px 16px; font-size: 12px; border-radius: 20px;">
                        View Invoice
                    </a>
                </div>
            </div>
            <% 
                }
            } else { %>
            <div class="glass" style="text-align: center; padding: 50px 20px; border-radius: 16px;">
                <p style="color: var(--text-secondary); font-size: 15px;">You haven't placed any orders yet.</p>
                <a href="<%= request.getContextPath() %>/products" class="btn-premium" style="margin-top: 20px;">Go Shop Collection</a>
            </div>
            <% } %>
        </main>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
