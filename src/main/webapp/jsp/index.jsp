<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.tap.model.Product, com.tap.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fashion Vault - Premium Apparel Store</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Hero Section -->
    <section class="hero-section">
        <img src="<%= request.getContextPath() %>/images/home_banner.jpg" alt="Fashion Vault Banner" class="hero-image">
        <div class="hero-content">
            <h1 style="color: #ffffff; text-transform: uppercase;">Where Premium Style is Stored</h1>
            <p>Explore our premium autumn curation. Thoughtfully designed, textured essentials crafted for maximum comfort and premium longevity.</p>
            <a href="<%= request.getContextPath() %>/products" class="btn-premium">Shop Collection</a>
        </div>
    </section>

    <!-- Browse Categories -->
    <section class="section-container">
        <h2 class="section-title">Shop by Category</h2>
        <div class="categories-grid" style="margin-top: 30px;">
            <div class="category-card glass" onclick="window.location.href='<%= request.getContextPath() %>/products?category=1'">
                <h3 style="color: #ffffff;">Men's Apparel</h3>
                <p>Premium shirts, linen, and structured denim jackets.</p>
            </div>
            <div class="category-card glass" onclick="window.location.href='<%= request.getContextPath() %>/products?category=2'">
                <h3 style="color: #ffffff;">Women's Apparel</h3>
                <p>Flowing midi dresses, pleated skirts, and timeless cuts.</p>
            </div>
            <div class="category-card glass" onclick="window.location.href='<%= request.getContextPath() %>/products?category=4'">
                <h3 style="color: #ffffff;">Kids' Section</h3>
                <p>Fun educational toys, board games, puzzles, and comfortable kid-friendly dresses.</p>
            </div>
            <div class="category-card glass" onclick="window.location.href='<%= request.getContextPath() %>/products?category=3'">
                <h3 style="color: #ffffff;">Accessories</h3>
                <p>Handcrafted leather crossbody bags and polarized aviators.</p>
            </div>
        </div>
    </section>

    <!-- Featured Products -->
    <section class="section-container">
        <h2 class="section-title">New Arrivals</h2>
        <div class="grid-products" style="margin-top: 30px;">
            <%
                List<Product> featured = (List<Product>) request.getAttribute("featuredProducts");
                if (featured != null && !featured.isEmpty()) {
                    for (Product product : featured) {
            %>
            <div class="product-card glass">
                <div class="product-image-container">
                    <span class="product-category-tag">
                        <%= product.getCategoryId() == 1 ? "Men" : (product.getCategoryId() == 2 ? "Women" : (product.getCategoryId() == 4 ? "Kids" : "Accessory")) %>
                    </span>
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
            <p style="color: var(--text-secondary); grid-column: 1/-1; text-align: center;">No arrivals found.</p>
            <% } %>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
