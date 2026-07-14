<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Register - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <% request.setAttribute("activePage", "register"); %>
    <jsp:include page="navbar.jsp" />

    <%
        String regError = (String) request.getSession().getAttribute("registerError");
        if (regError != null) {
            request.getSession().removeAttribute("registerError");
        }
        String redirect = request.getParameter("redirect");
    %>

    <div class="auth-container" style="max-width: 500px; margin: 50px auto;">
        <div class="auth-card glass">
            <h2 style="color: #ffffff;">Create Account</h2>
            <p>Sign up to shop premium fashion and track your orders.</p>

            <% if (regError != null) { %>
                <div style="background: rgba(230, 57, 70, 0.1); border: 1px solid var(--red); color: var(--red); padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 500; font-size: 13px;">
                    <%= regError %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="POST">
                <% if (redirect != null) { %>
                    <input type="hidden" name="redirect" value="<%= redirect %>">
                <% } %>
                
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="John Doe" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="john@example.com" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="9876543210" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <div class="form-group">
                    <label for="address">Address (Optional)</label>
                    <textarea id="address" name="address" class="form-control" rows="3" placeholder="Apartment, Street, City, ZIP"></textarea>
                </div>

                <button type="submit" class="btn-premium" style="width: 100%; margin-top: 15px; height: 44px;">Sign Up</button>
            </form>

            <div style="margin-top: 25px; text-align: center; font-size: 14px; color: var(--text-secondary);">
                Already have an account? 
                <a href="<%= request.getContextPath() %>/login<%= redirect != null ? "?redirect=" + redirect : "" %>" style="color: var(--accent-color); font-weight: 600;">Sign in</a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
