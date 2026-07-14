<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tap.model.Product, com.tap.model.User, java.util.List" %>
<%
    User adminUser = (User) session.getAttribute("adminUser");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String msg = request.getParameter("msg");
    String cp  = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Dashboard — Fashion Vault</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --bg:       #0d0d1a;
      --sidebar:  #111121;
      --surface:  #161626;
      --border:   rgba(255,255,255,0.07);
      --accent:   #f59f00;
      --accent2:  #ff6b35;
      --green:    #38d9a9;
      --red:      #ff4444;
      --text:     #e2e8f0;
      --muted:    #64748b;
    }
    body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); display: flex; min-height: 100vh; }

    /* ── Sidebar ── */
    .sidebar {
      width: 240px;
      background: var(--sidebar);
      border-right: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      padding: 28px 0;
      position: fixed;
      height: 100vh;
      z-index: 100;
    }
    .sidebar-logo {
      padding: 0 24px 28px;
      border-bottom: 1px solid var(--border);
    }
    .sidebar-logo .name { font-size: 18px; font-weight: 800; color: #fff; }
    .sidebar-logo .name span { color: var(--accent); }
    .sidebar-logo .tag { font-size: 10px; color: var(--muted); letter-spacing: 2px; text-transform: uppercase; margin-top: 2px; }

    .nav { padding: 20px 12px; flex: 1; }
    .nav-item {
      display: flex; align-items: center; gap: 12px;
      padding: 11px 14px; border-radius: 10px;
      color: var(--muted); font-size: 13px; font-weight: 500;
      text-decoration: none; cursor: pointer;
      transition: all 0.15s;
      margin-bottom: 4px;
    }
    .nav-item:hover, .nav-item.active {
      background: rgba(245,159,0,0.1);
      color: var(--accent);
    }
    .nav-item .icon { font-size: 16px; width: 20px; text-align: center; }

    .sidebar-footer { padding: 16px 12px; border-top: 1px solid var(--border); }
    .admin-info { padding: 12px 14px; border-radius: 10px; background: rgba(255,255,255,0.03); margin-bottom: 8px; }
    .admin-info .admin-name { font-size: 13px; font-weight: 600; color: #fff; }
    .admin-info .admin-role { font-size: 11px; color: var(--accent); letter-spacing: 1px; text-transform: uppercase; }
    .btn-logout {
      display: flex; align-items: center; gap: 8px;
      padding: 10px 14px; border-radius: 10px;
      background: rgba(255,68,68,0.08); color: #ff8080;
      font-size: 13px; font-weight: 500; text-decoration: none;
      transition: background 0.15s;
    }
    .btn-logout:hover { background: rgba(255,68,68,0.15); }

    /* ── Main Content ── */
    .main { margin-left: 240px; flex: 1; padding: 32px; }

    .top-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; }
    .page-title { font-size: 24px; font-weight: 700; color: #fff; }
    .page-subtitle { font-size: 13px; color: var(--muted); margin-top: 2px; }
    .btn-add {
      display: flex; align-items: center; gap: 8px;
      padding: 11px 22px;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      color: #fff; border: none; border-radius: 10px;
      font-size: 13px; font-weight: 700; font-family: inherit;
      cursor: pointer; text-decoration: none;
      transition: opacity 0.2s;
    }
    .btn-add:hover { opacity: 0.88; }

    /* ── Stats ── */
    .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 28px; }
    .stat-card {
      background: var(--surface); border: 1px solid var(--border);
      border-radius: 14px; padding: 20px 24px;
    }
    .stat-label { font-size: 11px; color: var(--muted); text-transform: uppercase; letter-spacing: 1px; }
    .stat-value { font-size: 32px; font-weight: 800; color: #fff; margin: 6px 0; }
    .stat-icon  { font-size: 28px; float: right; margin-top: -32px; }

    /* ── Toast ── */
    .toast {
      display: flex; align-items: center; gap: 10px;
      background: rgba(56,217,169,0.12); border: 1px solid rgba(56,217,169,0.3);
      border-radius: 10px; padding: 12px 18px;
      color: var(--green); font-size: 13px; font-weight: 500;
      margin-bottom: 20px; animation: slideIn 0.3s ease;
    }
    .toast.warn { background: rgba(255,68,68,0.1); border-color: rgba(255,68,68,0.3); color: #ff8080; }
    @keyframes slideIn { from { opacity:0; transform: translateY(-8px); } to { opacity:1; transform: translateY(0); } }

    /* ── Table ── */
    .table-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; }
    .table-header { padding: 20px 24px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
    .table-title { font-size: 15px; font-weight: 600; }
    .table-count { font-size: 12px; color: var(--muted); background: rgba(255,255,255,0.05); padding: 3px 10px; border-radius: 20px; }
    table { width: 100%; border-collapse: collapse; font-size: 13px; }
    th { padding: 12px 16px; text-align: left; font-size: 11px; font-weight: 600; color: var(--muted); letter-spacing: 0.8px; text-transform: uppercase; border-bottom: 1px solid var(--border); }
    td { padding: 14px 16px; border-bottom: 1px solid rgba(255,255,255,0.03); vertical-align: middle; }
    tr:hover td { background: rgba(255,255,255,0.02); }
    tr:last-child td { border-bottom: none; }

    .product-img { width: 48px; height: 48px; border-radius: 8px; object-fit: cover; background: #222; }
    .product-name { font-weight: 600; color: #fff; margin-bottom: 2px; }
    .product-desc { font-size: 11px; color: var(--muted); max-width: 220px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .badge { display: inline-block; font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
    .badge-cat { background: rgba(245,159,0,0.12); color: var(--accent); }
    .price { font-weight: 700; color: var(--green); }

    .actions { display: flex; gap: 8px; }
    .btn-edit {
      padding: 7px 14px; border-radius: 7px; font-size: 12px; font-weight: 600;
      background: rgba(79,142,247,0.12); color: #7eb3ff; border: none; cursor: pointer;
      text-decoration: none; transition: background 0.15s;
    }
    .btn-edit:hover { background: rgba(79,142,247,0.2); }
    .btn-del {
      padding: 7px 14px; border-radius: 7px; font-size: 12px; font-weight: 600;
      background: rgba(255,68,68,0.1); color: #ff8080; border: none; cursor: pointer;
      text-decoration: none; transition: background 0.15s;
    }
    .btn-del:hover { background: rgba(255,68,68,0.18); }

    .empty { text-align: center; padding: 60px; color: var(--muted); }
    .empty .icon { font-size: 48px; margin-bottom: 12px; }
  </style>
</head>
<body>

<!-- ── Sidebar ── -->
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="name">Fashion <span>Vault</span></div>
    <div class="tag">Admin Panel</div>
  </div>
  <nav class="nav">
    <a href="<%= cp %>/admin/panel" class="nav-item active"><span class="icon">📦</span> Products</a>
    <a href="<%= cp %>/home" class="nav-item" target="_blank"><span class="icon">🌐</span> View Store</a>
  </nav>
  <div class="sidebar-footer">
    <div class="admin-info">
      <div class="admin-name"><%= adminUser.getFullName() %></div>
      <div class="admin-role">Administrator</div>
    </div>
    <a href="<%= cp %>/admin/panel?action=logout" class="btn-logout">🚪 Logout</a>
  </div>
</aside>

<!-- ── Main ── -->
<main class="main">

  <div class="top-bar">
    <div>
      <div class="page-title">Products</div>
      <div class="page-subtitle">Manage your store's product catalog</div>
    </div>
    <a href="<%= cp %>/admin/panel?action=add" class="btn-add">➕ Add New Product</a>
  </div>

  <!-- Stats -->
  <div class="stats">
    <div class="stat-card">
      <div class="stat-label">Total Products</div>
      <div class="stat-value"><%= request.getAttribute("totalProducts") %></div>
      <div class="stat-icon">📦</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Total Orders</div>
      <div class="stat-value"><%= request.getAttribute("totalOrders") %></div>
      <div class="stat-icon">📋</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Customers</div>
      <div class="stat-value"><%= request.getAttribute("totalUsers") %></div>
      <div class="stat-icon">👥</div>
    </div>
  </div>

  <!-- Toast Messages -->
  <% if ("added".equals(msg)) { %>
    <div class="toast">✅ Product added successfully!</div>
  <% } else if ("updated".equals(msg)) { %>
    <div class="toast">✅ Product updated successfully!</div>
  <% } else if ("deleted".equals(msg)) { %>
    <div class="toast warn">🗑️ Product deleted.</div>
  <% } %>

  <!-- Product Table -->
  <div class="table-card">
    <div class="table-header">
      <span class="table-title">All Products</span>
      <span class="table-count"><%= products != null ? products.size() : 0 %> items</span>
    </div>

    <% if (products == null || products.isEmpty()) { %>
      <div class="empty">
        <div class="icon">📭</div>
        <div>No products yet. <a href="<%= cp %>/admin/panel?action=add" style="color:var(--accent)">Add the first one!</a></div>
      </div>
    <% } else { %>
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Product</th>
          <th>Category</th>
          <th>Price</th>
          <th>Image</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <% for (Product p : products) { %>
        <tr>
          <td style="color:var(--muted); font-size:12px;">#<%= p.getId() %></td>
          <td>
            <div class="product-name"><%= p.getName() %></div>
            <div class="product-desc"><%= p.getDescription() != null ? p.getDescription() : "" %></div>
          </td>
          <td><span class="badge badge-cat"><%= p.getCategoryName() != null ? p.getCategoryName() : "—" %></span></td>
          <td><span class="price">₹<%= String.format("%.0f", p.getPrice()) %></span></td>
          <td style="font-size:11px; color:var(--muted);"><%= p.getImageUrl() != null ? p.getImageUrl() : "—" %></td>
          <td>
            <div class="actions">
              <a href="<%= cp %>/admin/panel?action=edit&id=<%= p.getId() %>" class="btn-edit">✏️ Edit</a>
              <a href="<%= cp %>/admin/panel?action=delete&id=<%= p.getId() %>"
                 class="btn-del"
                 onclick="return confirm('Delete \'<%= p.getName() %>\' permanently? This cannot be undone.')">🗑️ Delete</a>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

</main>
</body>
</html>
