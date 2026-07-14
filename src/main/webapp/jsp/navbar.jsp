<%@ page import="com.tap.model.User, java.util.List, com.tap.model.CartItem" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (sessionCart != null) {
        for (CartItem item : sessionCart) {
            cartCount += item.getQuantity();
        }
    }
    String contextPath = request.getContextPath();
%>
<nav class="navbar">
    <a href="<%= contextPath %>/home" class="logo">Fashion Vault</a>
    
    <ul class="nav-links">
        <li><a href="<%= contextPath %>/home" class="<%= "home".equals(request.getAttribute("activePage")) ? "active" : "" %>">Home</a></li>
        <li><a href="<%= contextPath %>/products" class="<%= "shop".equals(request.getAttribute("activePage")) ? "active" : "" %>">Shop</a></li>
        <li><a href="<%= contextPath %>/products?category=1" class="<%= "men".equals(request.getAttribute("activePage")) ? "active" : "" %>">Men</a></li>
        <li><a href="<%= contextPath %>/products?category=2" class="<%= "women".equals(request.getAttribute("activePage")) ? "active" : "" %>">Women</a></li>
        <li><a href="<%= contextPath %>/products?category=4" class="<%= "kids".equals(request.getAttribute("activePage")) ? "active" : "" %>">Kids</a></li>
        <li><a href="<%= contextPath %>/products?category=3" class="<%= "accessories".equals(request.getAttribute("activePage")) ? "active" : "" %>">Accessories</a></li>
    </ul>

    <div style="display: flex; align-items: center; gap: 20px;">
        <!-- Search -->
        <form action="<%= contextPath %>/products" method="GET" class="search-box">
            <input type="text" name="q" placeholder="Search fashion..." value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>" required>
            <button type="submit">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            </button>
        </form>

        <!-- Cart Badge -->
        <a href="<%= contextPath %>/cart" class="cart-icon-wrapper">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
            <% if (cartCount > 0) { %>
                <span class="cart-badge"><%= cartCount %></span>
            <% } %>
        </a>

        <!-- Account Actions -->
        <% if (currentUser != null) { %>
            <div style="display: flex; align-items: center; gap: 15px;">
                <a href="<%= contextPath %>/profile" class="<%= "profile".equals(request.getAttribute("activePage")) ? "active" : "" %>" style="font-weight: 600; color: var(--accent-color);">
                    Hi, <%= currentUser.getFullName().split(" ")[0] %>
                </a>
                <a href="<%= contextPath %>/login?action=logout" style="font-size: 13px; color: var(--text-secondary); text-decoration: underline;">Logout</a>
            </div>
        <% } else if ("login".equals(request.getAttribute("activePage"))) { %>
            <a href="<%= contextPath %>/register" class="btn-premium btn-secondary" style="padding: 8px 20px;">Sign Up</a>
        <% } else if ("register".equals(request.getAttribute("activePage"))) { %>
            <a href="<%= contextPath %>/login" class="btn-premium btn-secondary" style="padding: 8px 20px;">Login</a>
        <% } else { %>
            <a href="<%= contextPath %>/login" class="btn-premium btn-secondary" style="padding: 8px 20px;">Login</a>
        <% } %>
    </div>
</nav>
