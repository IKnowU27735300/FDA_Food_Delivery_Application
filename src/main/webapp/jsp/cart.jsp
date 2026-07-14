<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.tap.model.CartItem, com.tap.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <div class="cart-container">
        <h2 style="font-weight: 800; font-size: 28px; margin-bottom: 30px; color: #ffffff;">Shopping Cart</h2>

        <%
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            double total = 0;
            if (cart != null && !cart.isEmpty()) {
        %>
        <!-- Cart Items List -->
        <div class="cart-table-card glass">
            <div style="display: grid; grid-template-columns: 80px 2fr 1fr 1.2fr 80px; gap: 20px; font-weight: 700; padding-bottom: 15px; border-bottom: 1px solid var(--border-color); font-size: 13px; color: var(--text-secondary); text-transform: uppercase;">
                <div>Item</div>
                <div>Details</div>
                <div>Price</div>
                <div style="text-align: right;">Subtotal</div>
                <div></div>
            </div>

            <%
                for (CartItem item : cart) {
                    total += item.getSubtotal();
            %>
            <div class="cart-item-row">
                <img src="<%= request.getContextPath() %>/<%= item.getImageUrl() %>?v=2" alt="<%= item.getProductName() %>" class="cart-item-thumb">
                <div>
                    <div class="cart-item-name"><%= item.getProductName() %></div>
                    <div class="cart-item-size">Size: <%= item.getSize() %> | Qty: <%= item.getQuantity() %></div>
                </div>
                <div class="cart-item-price">₹<%= String.format("%.2f", item.getProductPrice()) %></div>
                <div class="cart-item-subtotal">₹<%= String.format("%.2f", item.getSubtotal()) %></div>
                <div style="text-align: right;">
                    <form action="<%= request.getContextPath() %>/cart?action=remove" method="POST">
                        <input type="hidden" name="variantId" value="<%= item.getVariantId() %>">
                        <button type="submit" class="cart-remove-btn">Remove</button>
                    </form>
                </div>
            </div>
            <% } %>

            <!-- Cart Subtotal -->
            <div class="cart-summary">
                <span class="cart-total-label">Subtotal</span>
                <span class="cart-total-value">₹<%= String.format("%.2f", total) %></span>
            </div>

            <!-- Checkout Buttons -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 30px;">
                <a href="<%= request.getContextPath() %>/products" class="btn-premium btn-secondary">Continue Shopping</a>
                
                <%
                    User user = (User) session.getAttribute("currentUser");
                    if (user != null) {
                %>
                <a href="<%= request.getContextPath() %>/checkout" class="btn-premium">Proceed to Checkout</a>
                <% } else { %>
                <a href="<%= request.getContextPath() %>/login?redirect=checkout" class="btn-premium">Login to Checkout</a>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <!-- Empty State -->
        <div class="cart-table-card glass" style="text-align: center; padding: 60px 20px;">
            <div style="font-size: 50px; margin-bottom: 20px; color: var(--text-secondary);">
                <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
            </div>
            <h3 style="font-size: 20px; margin-bottom: 10px; color: #ffffff;">Your cart is empty</h3>
            <p style="color: var(--text-secondary); max-width: 380px; margin: 0 auto 30px;">Looks like you haven't added any items to your cart yet. Visit our shop to find something you like.</p>
            <a href="<%= request.getContextPath() %>/products" class="btn-premium">Go Shopping</a>
        </div>
        <% } %>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
