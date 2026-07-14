<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Login — Fashion Vault</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg:      #0a0a12;
      --surface: rgba(20, 20, 35, 0.85);
      --border:  rgba(255,255,255,0.08);
      --accent:  #f59f00;
      --accent2: #ff6b35;
      --text:    #e2e8f0;
      --muted:   #64748b;
      --red:     #ff4444;
    }

    body {
      font-family: 'Inter', sans-serif;
      background: var(--bg);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
    }

    /* Animated gradient background */
    body::before {
      content: '';
      position: fixed;
      inset: 0;
      background:
        radial-gradient(ellipse 800px 600px at 20% 30%, rgba(245,159,0,0.08) 0%, transparent 60%),
        radial-gradient(ellipse 600px 500px at 80% 70%, rgba(255,107,53,0.06) 0%, transparent 60%);
      pointer-events: none;
    }

    /* Subtle grid pattern */
    body::after {
      content: '';
      position: fixed;
      inset: 0;
      background-image:
        linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
      background-size: 60px 60px;
      pointer-events: none;
    }

    .login-wrapper {
      position: relative;
      z-index: 10;
      width: 100%;
      max-width: 420px;
      padding: 24px;
    }

    .brand {
      text-align: center;
      margin-bottom: 36px;
    }
    .brand-logo {
      font-size: 28px;
      font-weight: 800;
      color: #fff;
      letter-spacing: -0.5px;
    }
    .brand-logo span { color: var(--accent); }
    .brand-sub {
      font-size: 11px;
      letter-spacing: 3px;
      text-transform: uppercase;
      color: var(--muted);
      margin-top: 6px;
    }

    .card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 40px 36px;
      backdrop-filter: blur(20px);
      box-shadow:
        0 0 0 1px rgba(255,255,255,0.04),
        0 24px 60px rgba(0,0,0,0.5),
        inset 0 1px 0 rgba(255,255,255,0.06);
    }

    h1 {
      font-size: 22px;
      font-weight: 700;
      color: #fff;
      margin-bottom: 6px;
    }
    .subtitle {
      font-size: 13px;
      color: var(--muted);
      margin-bottom: 32px;
    }

    .error-box {
      background: rgba(255, 68, 68, 0.1);
      border: 1px solid rgba(255,68,68,0.3);
      border-radius: 10px;
      padding: 12px 16px;
      color: #ff8080;
      font-size: 13px;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .form-group { margin-bottom: 20px; }
    label {
      display: block;
      font-size: 12px;
      font-weight: 600;
      color: var(--muted);
      letter-spacing: 0.5px;
      text-transform: uppercase;
      margin-bottom: 8px;
    }
    input {
      width: 100%;
      background: rgba(255,255,255,0.05);
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 13px 16px;
      color: var(--text);
      font-size: 14px;
      font-family: inherit;
      transition: border-color 0.2s, box-shadow 0.2s;
      outline: none;
    }
    input:focus {
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(245,159,0,0.12);
    }
    input::placeholder { color: var(--muted); }

    .btn {
      width: 100%;
      padding: 14px;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      border: none;
      border-radius: 10px;
      color: #fff;
      font-size: 14px;
      font-weight: 700;
      font-family: inherit;
      cursor: pointer;
      margin-top: 8px;
      letter-spacing: 0.5px;
      transition: opacity 0.2s, transform 0.1s;
    }
    .btn:hover  { opacity: 0.9; }
    .btn:active { transform: scale(0.99); }

    .back-link {
      text-align: center;
      margin-top: 20px;
      font-size: 12px;
      color: var(--muted);
    }
    .back-link a { color: var(--accent); text-decoration: none; }
    .back-link a:hover { text-decoration: underline; }

    .shield-icon {
      text-align: center;
      font-size: 40px;
      margin-bottom: 16px;
      filter: drop-shadow(0 0 12px rgba(245,159,0,0.3));
    }
  </style>
</head>
<body>
<div class="login-wrapper">

  <div class="brand">
    <div class="brand-logo">Fashion <span>Vault</span></div>
    <div class="brand-sub">Administration Portal</div>
  </div>

  <div class="card">
    <div class="shield-icon">🛡️</div>
    <h1>Admin Access</h1>
    <p class="subtitle">Enter your admin credentials to continue.</p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
      <div class="error-box">
        <span>⚠️</span> <%= error %>
      </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/admin" method="POST">
      <div class="form-group">
        <label for="email">Email Address</label>
        <input type="email" id="email" name="email" placeholder="admin@fashionvault.com" required autocomplete="off"/>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="••••••••" required/>
      </div>
      <button type="submit" class="btn">🔐 Sign In to Admin Panel</button>
    </form>

    <div class="back-link">
      <a href="<%= request.getContextPath() %>/home">← Back to Store</a>
    </div>
  </div>
</div>
</body>
</html>
