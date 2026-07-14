<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tap.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Fashion Vault</title>
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
        
        String profileSuccess = (String) request.getSession().getAttribute("profileSuccess");
        if (profileSuccess != null) {
            request.getSession().removeAttribute("profileSuccess");
        }
        String profileError = (String) request.getSession().getAttribute("profileError");
        if (profileError != null) {
            request.getSession().removeAttribute("profileError");
        }
    %>

    <div class="profile-grid">
        <!-- Profile Navigation Sidebar -->
        <aside class="profile-nav-card glass">
            <ul class="profile-nav-links">
                <li><a href="<%= request.getContextPath() %>/profile" class="active">My Profile</a></li>
                <li><a href="<%= request.getContextPath() %>/orders">Order History</a></li>
                <li><a href="<%= request.getContextPath() %>/login?action=logout" style="color: var(--red);">Log Out</a></li>
            </ul>
        </aside>

        <!-- Profile Settings Sheet -->
        <main class="form-card glass">
            <h3 class="form-title" style="color: #ffffff; font-size: 22px;">Account Details</h3>
            
            <% if (profileSuccess != null) { %>
                <div style="background: rgba(82, 183, 136, 0.1); border: 1px solid var(--accent-color); color: var(--accent-color); padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                    <%= profileSuccess %>
                </div>
            <% } %>
            
            <% if (profileError != null) { %>
                <div style="background: rgba(230, 57, 70, 0.1); border: 1px solid var(--red); color: var(--red); padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                    <%= profileError %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/profile" method="POST">
                <div class="form-group">
                    <label for="email">Email Address (Cannot change)</label>
                    <input type="email" id="email" class="form-control" value="<%= user.getEmail() %>" style="opacity: 0.6; cursor: not-allowed;" readonly>
                </div>

                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" value="<%= user.getFullName() %>" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="address">Default Shipping Address</label>
                    <textarea id="address" name="address" class="form-control" rows="4" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                </div>

                <button type="submit" class="btn-premium" style="margin-top: 15px;">Update Account Details</button>
            </form>
        </main>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
