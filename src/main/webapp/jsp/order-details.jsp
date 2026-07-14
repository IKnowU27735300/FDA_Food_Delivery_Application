<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tap.model.Order, com.tap.model.OrderItem, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Invoice - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <%
        Order order = (Order) request.getAttribute("order");
        List<OrderItem> items = (List<OrderItem>) request.getAttribute("items");
        
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy - hh:mm a");
    %>

    <div class="cart-container" style="max-width: 900px; margin: 40px auto;">
        <div style="margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center;">
            <a href="<%= request.getContextPath() %>/orders" style="display: inline-flex; align-items: center; gap: 8px; font-weight: 600; color: var(--accent-color); font-size: 14px;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                Back to Orders
            </a>
            <span class="order-badge <%= "DELIVERED".equalsIgnoreCase(order.getOrderStatus()) ? "badge-completed" : ("SHIPPED".equalsIgnoreCase(order.getOrderStatus()) ? "badge-shipped" : "badge-pending") %>">
                <%= order.getOrderStatus() %>
            </span>
        </div>

        <div class="invoice-card glass" style="width: 100%; padding: 40px;">
            <!-- Invoice Header -->
            <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 1px solid var(--border-color); padding-bottom: 30px; margin-bottom: 30px;">
                <div>
                    <h3 style="font-weight: 800; font-size: 24px; color: var(--accent-color); letter-spacing: 0.5px; margin-bottom: 5px;">Fashion Vault</h3>
                    <p style="font-size: 13px; color: var(--text-muted);">Invoice / Receipt Receipt</p>
                </div>
                <div style="text-align: right;">
                    <h4 style="font-weight: 700; font-size: 16px; color: #ffffff; margin-bottom: 4px;">Order #<%= order.getId() %></h4>
                    <p style="font-size: 13px; color: var(--text-secondary);"><%= sdf.format(order.getCreatedAt()) %></p>
                </div>
            </div>

            <!-- Shipping Information -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 25px; margin-bottom: 25px; font-size: 14px;">
                <div>
                    <h5 style="font-weight: 700; color: #ffffff; margin-bottom: 10px; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px;">Deliver To</h5>
                    <p style="font-weight: 600; color: var(--text-primary); margin-bottom: 4px;"><%= order.getDeliveryName() %></p>
                    <p style="color: var(--text-secondary); line-height: 1.5; white-space: pre-wrap;"><%= order.getDeliveryAddress() %></p>
                    <p style="color: var(--text-secondary); margin-top: 8px;">Phone: <%= order.getDeliveryPhone() %></p>
                </div>
                <div style="text-align: right;">
                    <h5 style="font-weight: 700; color: #ffffff; margin-bottom: 10px; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px;">Payment Details</h5>
                    <p style="color: var(--text-secondary); margin-bottom: 4px;">Method: <span style="color: #ffffff; font-weight: 600;"><%= order.getPaymentMethod() %></span></p>
                    <p style="color: var(--text-secondary);">Status: <span style="color: var(--accent-color); font-weight: 600;">Paid (COD Pending)</span></p>
                </div>
            </div>

            <!-- Items table -->
            <h5 style="font-weight: 700; color: #ffffff; margin-bottom: 15px; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px;">Order Items</h5>
            
            <div style="display: grid; grid-template-columns: 80px 2fr 1fr 1.2fr; gap: 20px; font-weight: 700; padding-bottom: 10px; border-bottom: 1px solid var(--border-color); font-size: 11px; color: var(--text-secondary); text-transform: uppercase;">
                <div>Item</div>
                <div>Details</div>
                <div>Price</div>
                <div style="text-align: right;">Subtotal</div>
            </div>

            <% if (items != null) {
                for (OrderItem item : items) {
            %>
            <div style="display: grid; grid-template-columns: 80px 2fr 1fr 1.2fr; align-items: center; gap: 20px; padding: 15px 0; border-bottom: 1px solid rgba(255,255,255,0.03);">
                <img src="<%= request.getContextPath() %>/<%= item.getImageUrl() %>?v=2" alt="<%= item.getProductName() %>" style="width: 60px; height: 60px; border-radius: 6px; object-fit: cover; background: #1c1f2e;">
                <div>
                    <div style="font-weight: 700; font-size: 14px; color: #ffffff;"><%= item.getProductName() %></div>
                    <div style="font-size: 12px; color: var(--text-secondary); margin-top: 2px;">Size: <%= item.getSize() %> | Qty: <%= item.getQuantity() %></div>
                </div>
                <div style="font-size: 14px; color: var(--text-secondary);">₹<%= String.format("%.2f", item.getPrice()) %></div>
                <div style="font-size: 15px; font-weight: 700; color: var(--accent-color); text-align: right;">₹<%= String.format("%.2f", item.getSubtotal()) %></div>
            </div>
            <% 
                }
            } 
            %>

            <!-- Totals -->
            <div style="display: flex; flex-direction: column; align-items: flex-end; margin-top: 25px; font-size: 14px;">
                <div style="display: flex; gap: 40px; margin-bottom: 8px; color: var(--text-secondary);">
                    <span>Subtotal</span>
                    <span style="font-weight: 600; color: #ffffff; width: 80px; text-align: right;">₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                </div>
                <div style="display: flex; gap: 40px; margin-bottom: 12px; color: var(--text-secondary);">
                    <span>Shipping</span>
                    <span style="font-weight: 600; color: var(--accent-color); width: 80px; text-align: right;">FREE</span>
                </div>
                <div style="display: flex; gap: 40px; border-top: 1px solid var(--border-color); padding-top: 15px; font-size: 20px; font-weight: 800; color: var(--accent-color);">
                    <span>Total Paid</span>
                    <span style="width: 100px; text-align: right;">₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
