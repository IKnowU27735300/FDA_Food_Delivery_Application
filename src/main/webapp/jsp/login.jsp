<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Login - Fashion Vault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <!-- Navbar -->
    <% request.setAttribute("activePage", "login"); %>
    <jsp:include page="navbar.jsp" />

    <%
        String loginError = (String) request.getSession().getAttribute("loginError");
        if (loginError != null) {
            request.getSession().removeAttribute("loginError");
        }
        String redirect = request.getParameter("redirect");
    %>

    <div class="auth-container">
        <div class="auth-card glass">
            <h2 style="color: #ffffff;">Welcome Back</h2>
            <p>Please enter your details to sign in to your account.</p>

            <% if (loginError != null) { %>
                <div style="background: rgba(230, 57, 70, 0.1); border: 1px solid var(--red); color: var(--red); padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 500; font-size: 13px;">
                    <%= loginError %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="POST">
                <% if (redirect != null) { %>
                    <input type="hidden" name="redirect" value="<%= redirect %>">
                <% } %>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="name@domain.com" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn-premium" style="width: 100%; margin-top: 15px; height: 44px;">Sign In</button>
            </form>

            <div style="margin-top: 25px; text-align: center; font-size: 14px; color: var(--text-secondary);">
                Don't have an account? 
                <a href="<%= request.getContextPath() %>/register<%= redirect != null ? "?redirect=" + redirect : "" %>" style="color: var(--accent-color); font-weight: 600;">Sign up for free</a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>
