<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tap.model.Product, com.tap.model.ProductVariant, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= ((Product) request.getAttribute("product")).getName() %> - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script>
        function updateQuantity(amount) {
            var qtyInput = document.getElementById("quantity-input");
            var currentVal = parseInt(qtyInput.value);
            var newVal = currentVal + amount;
            if (newVal >= 1 && newVal <= 10) {
                qtyInput.value = newVal;
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const priceDisplay = document.getElementById('display-price');
            const sizeRadios = document.querySelectorAll('input[name="variantId"]');
            
            sizeRadios.forEach(radio => {
                radio.addEventListener('change', function() {
                    if (this.checked) {
                        const selectedPrice = this.getAttribute('data-price');
                        if (selectedPrice) {
                            priceDisplay.textContent = '₹' + parseFloat(selectedPrice).toFixed(2);
                        }
                    }
                });
            });
        });
    </script>
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <%
        Product product = (Product) request.getAttribute("product");
        List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
        String message = (String) request.getSession().getAttribute("successMessage");
        if (message != null) {
            request.getSession().removeAttribute("successMessage");
        }
        String errorMessage = (String) request.getSession().getAttribute("errorMessage");
        if (errorMessage != null) {
            request.getSession().removeAttribute("errorMessage");
        }
    %>

    <div class="detail-container">
        <!-- Product Image -->
        <div class="detail-gallery glass <%= product.getTotalStock() <= 0 ? "out-of-stock" : "" %>">
            <% if (product.getTotalStock() <= 0) { %>
                <div class="out-of-stock-overlay">Out of Stock</div>
            <% } %>
            <img src="<%= request.getContextPath() %>/<%= product.getImageUrl() %>?v=2" alt="<%= product.getName() %>">
        </div>

        <!-- Product Purchase Information -->
        <div class="detail-info" style="padding-left: 20px;">
            <% if (message != null) { %>
                <div style="background: rgba(82, 183, 136, 0.1); border: 1px solid var(--accent-color); color: var(--accent-color); padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                    <%= message %>
                </div>
            <% } %>
            <% if (errorMessage != null) { %>
                <div style="background: rgba(230, 57, 70, 0.1); border: 1px solid var(--red); color: var(--red); padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                    <%= errorMessage %>
                </div>
            <% } %>

            <span class="detail-tag"><%= product.getCategoryId() == 1 ? "Men's Apparel" : (product.getCategoryId() == 2 ? "Women's Apparel" : (product.getCategoryId() == 4 ? "Kids' Collection" : "Accessory")) %></span>
            <h1 class="detail-title" style="color: #ffffff;"><%= product.getName() %></h1>
            
            <%
                double initialPrice = product.getPrice();
                int defaultCheckedIndex = -1;
                if (variants != null && !variants.isEmpty()) {
                    for (int i = 0; i < variants.size(); i++) {
                        if (variants.get(i).getStockQuantity() > 0) {
                            initialPrice = variants.get(i).getPrice();
                            defaultCheckedIndex = i;
                            break;
                        }
                    }
                }
            %>
            <div class="detail-price" id="display-price">₹<%= String.format("%.2f", initialPrice) %></div>
            
            <p class="detail-description"><%= product.getDescription() %></p>

            <form action="<%= request.getContextPath() %>/cart?action=add" method="POST">
                <input type="hidden" name="productId" value="<%= product.getId() %>">

                <!-- Size selector -->
                <div class="detail-options-group">
                    <h4 class="options-label">Select Size</h4>
                    <div class="size-selector-row">
                        <%
                            boolean hasStock = false;
                            if (variants != null && !variants.isEmpty()) {
                                for (int i = 0; i < variants.size(); i++) {
                                    ProductVariant var = variants.get(i);
                                    boolean outOfStock = var.getStockQuantity() <= 0;
                                    if (!outOfStock) hasStock = true;
                        %>
                        <label class="size-radio-label">
                            <input type="radio" name="variantId" value="<%= var.getId() %>" 
                                   data-price="<%= String.format("%.2f", var.getPrice()) %>"
                                   <%= i == defaultCheckedIndex ? "checked" : "" %> 
                                   <%= outOfStock ? "disabled" : "" %> required>
                            <span class="size-box"><%= var.getSize() %></span>
                        </label>
                        <%
                                }
                            } else {
                        %>
                        <p style="color: var(--red); font-size: 13px;">Size options currently unavailable.</p>
                        <% } %>
                    </div>
                </div>

                <!-- Quantity & Add to Cart -->
                <div class="detail-options-group" style="margin-top: 30px; display: flex; align-items: center; gap: 30px;">
                    <div>
                        <h4 class="options-label">Quantity</h4>
                        <div class="qty-selector">
                            <button type="button" class="qty-btn" onclick="updateQuantity(-1)">-</button>
                            <input type="text" id="quantity-input" name="quantity" class="qty-input" value="1" readonly>
                            <button type="button" class="qty-btn" onclick="updateQuantity(1)">+</button>
                        </div>
                    </div>
                    
                    <div style="flex-grow: 1; align-self: flex-end;">
                        <% if (hasStock) { %>
                            <button type="submit" class="btn-premium" style="width: 100%; height: 48px;">Add To Cart</button>
                        <% } else { %>
                            <button type="button" class="btn-premium btn-secondary" style="width: 100%; height: 48px; cursor: not-allowed;" disabled>Out of Stock</button>
                        <% } %>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
