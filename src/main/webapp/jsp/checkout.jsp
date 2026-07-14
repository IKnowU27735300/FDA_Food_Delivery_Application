<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.tap.model.CartItem, com.tap.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <%
        User user = (User) session.getAttribute("currentUser");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        double subtotal = 0;
        if (cart != null) {
            for (CartItem item : cart) {
                subtotal += item.getSubtotal();
            }
        }
        
        // Double check login
        if (user == null || cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        String checkoutError = (String) request.getSession().getAttribute("checkoutError");
        if (checkoutError != null) {
            request.getSession().removeAttribute("checkoutError");
        }
    %>

    <div class="checkout-grid">
        <!-- Shipping Details Form -->
        <div class="form-card glass">
            <h3 class="form-title" style="color: #ffffff; font-size: 22px;">Shipping Details</h3>
            
            <% if (checkoutError != null) { %>
                <div style="background: rgba(230, 57, 70, 0.1); border: 1px solid var(--red); color: var(--red); padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                    <%= checkoutError %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/checkout" method="POST">
                <div class="form-group">
                    <label for="fullName">Recipient Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" value="<%= user.getFullName() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="phone">Contact Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="address">Delivery Address</label>
                    <textarea id="address" name="address" class="form-control" rows="4" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                </div>

                <div class="form-group" style="margin-top: 30px;">
                    <label style="font-weight: 700; margin-bottom: 12px;">Payment Method</label>
                    <div style="display: flex; flex-direction: column; gap: 10px;">
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="Cash on Delivery" checked style="accent-color: var(--accent-color);">
                            <span style="font-size: 14px;">Cash on Delivery (COD)</span>
                        </label>
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; opacity: 0.6;">
                            <input type="radio" name="paymentMethod" value="UPI / QR" disabled style="accent-color: var(--accent-color);">
                            <span style="font-size: 14px;">UPI / QR (Temporarily Unavailable)</span>
                        </label>
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; opacity: 0.6;">
                            <input type="radio" name="paymentMethod" value="Credit/Debit Card" disabled style="accent-color: var(--accent-color);">
                            <span style="font-size: 14px;">Credit / Debit Card (Temporarily Unavailable)</span>
                        </label>
                    </div>
                </div>

                <button type="submit" class="btn-premium" style="width: 100%; margin-top: 30px; height: 48px; font-size: 16px;">Place Order</button>
            </form>
        </div>

        <!-- Order Summary Column -->
        <div class="invoice-card glass">
            <h3 class="form-title" style="color: #ffffff; font-size: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">Order Summary</h3>
            
            <div style="max-height: 250px; overflow-y: auto; margin-bottom: 20px; padding-right: 5px;">
                <% for (CartItem item : cart) { %>
                <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.03);">
                    <div>
                        <div style="font-weight: 600; font-size: 14px; color: var(--text-primary);"><%= item.getProductName() %></div>
                        <div style="font-size: 11px; color: var(--text-secondary);">Size: <%= item.getSize() %> | Qty: <%= item.getQuantity() %></div>
                    </div>
                    <div style="font-weight: 600; font-size: 14px; color: var(--text-primary);">₹<%= String.format("%.2f", item.getSubtotal()) %></div>
                </div>
                <% } %>
            </div>

            <div class="invoice-row">
                <span>Subtotal</span>
                <span style="color: var(--text-primary); font-weight: 600;">₹<%= String.format("%.2f", subtotal) %></span>
            </div>
            
            <div class="invoice-row">
                <span>Shipping</span>
                <span style="color: var(--accent-color); font-weight: 600;">FREE</span>
            </div>

            <div class="invoice-total">
                <span>Total Amount</span>
                <span>₹<%= String.format("%.2f", subtotal) %></span>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
