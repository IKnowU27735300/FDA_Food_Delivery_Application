<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.tap.model.Product, com.tap.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop Collection - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <div class="layout-listing">
        <!-- Sidebar filters -->
        <aside class="filter-sidebar glass">
            <div class="filter-group">
                <h4 style="color: #ffffff;">Categories</h4>
                <ul class="filter-options" style="margin-top: 10px;">
                    <%
                        int activeCatId = request.getAttribute("categoryId") != null ? (Integer) request.getAttribute("categoryId") : 0;
                    %>
                    <li><a href="<%= request.getContextPath() %>/products" class="<%= activeCatId == 0 ? "active" : "" %>">All Products</a></li>
                    <li><a href="<%= request.getContextPath() %>/products?category=1" class="<%= activeCatId == 1 ? "active" : "" %>">Men's Apparel</a></li>
                    <li><a href="<%= request.getContextPath() %>/products?category=2" class="<%= activeCatId == 2 ? "active" : "" %>">Women's Apparel</a></li>
                    <li><a href="<%= request.getContextPath() %>/products?category=4" class="<%= activeCatId == 4 ? "active" : "" %>">Kids' Section</a></li>
                    <li><a href="<%= request.getContextPath() %>/products?category=3" class="<%= activeCatId == 3 ? "active" : "" %>">Accessories</a></li>
                </ul>
            </div>
            
            <div class="filter-group">
                <h4 style="color: #ffffff;">Filter by Size</h4>
                <ul class="filter-options" style="margin-top: 10px;">
                    <li><a href="#" style="opacity: 0.5; pointer-events: none;">S, M, L, XL available on details</a></li>
                </ul>
            </div>
        </aside>

        <!-- Product Listing Grid -->
        <main>
            <%
                String searchQuery = request.getParameter("q");
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            %>
            <h2 style="font-weight: 700; font-size: 22px; margin-bottom: 25px; color: #ffffff;">
                Search Results for "<span style="color: var(--accent-color);"><%= searchQuery %></span>"
            </h2>
            <% } else { %>
            <h2 style="font-weight: 700; font-size: 22px; margin-bottom: 25px; color: #ffffff;">
                <%
                    if (activeCatId == 1) out.print("Men's Collection");
                    else if (activeCatId == 2) out.print("Women's Collection");
                    else if (activeCatId == 4) out.print("Kids' Collection");
                    else if (activeCatId == 3) out.print("Accessories Collection");
                    else out.print("Shop All Products");
                %>
            </h2>
            <% } %>

            <div class="grid-products">
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    if (products != null && !products.isEmpty()) {
                        for (Product product : products) {
                %>
                <div class="product-card glass">
                    <div class="product-image-container <%= product.getTotalStock() <= 0 ? "out-of-stock" : "" %>">
                        <span class="product-category-tag">
                            <%= product.getCategoryId() == 1 ? "Men" : (product.getCategoryId() == 2 ? "Women" : (product.getCategoryId() == 4 ? "Kids" : "Accessory")) %>
                        </span>
                        <% if (product.getTotalStock() <= 0) { %>
                            <div class="out-of-stock-overlay">Out of Stock</div>
                        <% } %>
                        <a href="<%= request.getContextPath() %>/product?id=<%= product.getId() %>">
                            <img src="<%= request.getContextPath() %>/<%= product.getImageUrl() %>?v=2" alt="<%= product.getName() %>">
                        </a>
                    </div>
                    <div class="product-info">
                        <a href="<%= request.getContextPath() %>/product?id=<%= product.getId() %>">
                            <h3 class="product-name"><%= product.getName() %></h3>
                        </a>
                        <p class="product-description-short"><%= product.getDescription() %></p>
                        <div class="product-price-row">
                            <span class="product-price">₹<%= String.format("%.2f", product.getPrice()) %></span>
                            <a href="<%= request.getContextPath() %>/product?id=<%= product.getId() %>" class="btn-premium" style="padding: 8px 18px; font-size: 12px; border-radius: 20px;">View Details</a>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div style="grid-column: 1/-1; text-align: center; padding: 50px 0;">
                    <p style="color: var(--text-secondary); font-size: 16px;">No products match your criteria. Try searching for something else!</p>
                    <a href="<%= request.getContextPath() %>/products" class="btn-premium" style="margin-top: 20px;">View All Products</a>
                </div>
                <% } %>
            </div>
        </main>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
