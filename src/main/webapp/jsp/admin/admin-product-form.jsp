<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tap.model.Product, com.tap.model.Category, com.tap.model.ProductVariant, com.tap.model.User, java.util.List" %>
<%
    User adminUser   = (User)    session.getAttribute("adminUser");
    Product product  = (Product) request.getAttribute("product");
    List<Category> cats = (List<Category>) request.getAttribute("categories");
    List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
    boolean isEdit   = (product != null);
    String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title><%= isEdit ? "Edit" : "Add" %> Product — Fashion Vault Admin</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --bg:      #0d0d1a;
      --sidebar: #111121;
      --surface: #161626;
      --border:  rgba(255,255,255,0.07);
      --accent:  #f59f00;
      --accent2: #ff6b35;
      --green:   #38d9a9;
      --text:    #e2e8f0;
      --muted:   #64748b;
    }
    body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); display: flex; min-height: 100vh; }

    /* Sidebar */
    .sidebar {
      width: 240px; background: var(--sidebar); border-right: 1px solid var(--border);
      display: flex; flex-direction: column; padding: 28px 0; position: fixed; height: 100vh; z-index: 100;
    }
    .sidebar-logo { padding: 0 24px 28px; border-bottom: 1px solid var(--border); }
    .sidebar-logo .name { font-size: 18px; font-weight: 800; color: #fff; }
    .sidebar-logo .name span { color: var(--accent); }
    .sidebar-logo .tag { font-size: 10px; color: var(--muted); letter-spacing: 2px; text-transform: uppercase; margin-top: 2px; }
    .nav { padding: 20px 12px; flex: 1; }
    .nav-item {
      display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: 10px;
      color: var(--muted); font-size: 13px; font-weight: 500; text-decoration: none; margin-bottom: 4px; transition: all 0.15s;
    }
    .nav-item:hover, .nav-item.active { background: rgba(245,159,0,0.1); color: var(--accent); }
    .nav-item .icon { font-size: 16px; width: 20px; text-align: center; }
    .sidebar-footer { padding: 16px 12px; border-top: 1px solid var(--border); }
    .admin-info { padding: 12px 14px; border-radius: 10px; background: rgba(255,255,255,0.03); margin-bottom: 8px; }
    .admin-info .admin-name { font-size: 13px; font-weight: 600; color: #fff; }
    .admin-info .admin-role { font-size: 11px; color: var(--accent); letter-spacing: 1px; text-transform: uppercase; }
    .btn-logout {
      display: flex; align-items: center; gap: 8px; padding: 10px 14px; border-radius: 10px;
      background: rgba(255,68,68,0.08); color: #ff8080; font-size: 13px; font-weight: 500; text-decoration: none;
    }
    .btn-logout:hover { background: rgba(255,68,68,0.15); }

    /* Main */
    .main { margin-left: 240px; flex: 1; padding: 32px; max-width: 900px; }
    .breadcrumb { font-size: 12px; color: var(--muted); margin-bottom: 20px; }
    .breadcrumb a { color: var(--accent); text-decoration: none; }
    .breadcrumb a:hover { text-decoration: underline; }
    .page-title { font-size: 24px; font-weight: 700; color: #fff; margin-bottom: 28px; }

    /* Form Card */
    .form-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 32px; margin-bottom: 20px; }
    .section-title { font-size: 13px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 1px solid var(--border); }

    .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    .form-group { margin-bottom: 20px; }
    .form-group.full { grid-column: span 2; }
    label { display: block; font-size: 11px; font-weight: 600; color: var(--muted); letter-spacing: 0.5px; text-transform: uppercase; margin-bottom: 8px; }
    input, select, textarea {
      width: 100%; background: rgba(255,255,255,0.05); border: 1px solid var(--border);
      border-radius: 10px; padding: 12px 14px; color: var(--text); font-size: 13px; font-family: inherit;
      outline: none; transition: border-color 0.2s, box-shadow 0.2s;
    }
    input:focus, select:focus, textarea:focus {
      border-color: var(--accent); box-shadow: 0 0 0 3px rgba(245,159,0,0.1);
    }
    input::placeholder, textarea::placeholder { color: var(--muted); }
    select option { background: #1e1e2e; color: var(--text); }
    textarea { resize: vertical; min-height: 100px; }

    /* Variants */
    .variants-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
    .btn-add-row {
      display: flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 8px;
      background: rgba(56,217,169,0.1); color: var(--green); border: 1px solid rgba(56,217,169,0.2);
      font-size: 12px; font-weight: 600; cursor: pointer; font-family: inherit;
    }
    .btn-add-row:hover { background: rgba(56,217,169,0.15); }
    .variant-row { display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 12px; align-items: end; margin-bottom: 12px; }
    .btn-remove-row {
      padding: 12px 14px; border-radius: 10px; background: rgba(255,68,68,0.08);
      color: #ff8080; border: none; cursor: pointer; font-size: 14px;
    }
    .btn-remove-row:hover { background: rgba(255,68,68,0.15); }

    /* Actions */
    .form-actions { display: flex; gap: 12px; justify-content: flex-end; margin-top: 8px; }
    .btn-cancel {
      padding: 12px 24px; border-radius: 10px; background: rgba(255,255,255,0.05);
      color: var(--muted); border: 1px solid var(--border); font-size: 13px; font-weight: 600;
      cursor: pointer; font-family: inherit; text-decoration: none; display: inline-flex; align-items: center;
    }
    .btn-submit {
      padding: 12px 28px; border-radius: 10px;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      color: #fff; border: none; font-size: 13px; font-weight: 700; cursor: pointer; font-family: inherit;
    }
    .btn-submit:hover { opacity: 0.9; }
  </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="name">Fashion <span>Vault</span></div>
    <div class="tag">Admin Panel</div>
  </div>
  <nav class="nav">
    <a href="<%= cp %>/admin/panel" class="nav-item"><span class="icon">📦</span> Products</a>
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

<!-- Main -->
<main class="main">
  <div class="breadcrumb">
    <a href="<%= cp %>/admin/panel">Products</a> &rsaquo; <%= isEdit ? "Edit Product" : "Add New Product" %>
  </div>
  <div class="page-title"><%= isEdit ? "✏️ Edit Product" : "➕ Add New Product" %></div>

  <form action="<%= cp %>/admin/panel" method="POST" id="productForm">
    <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>"/>
    <% if (isEdit) { %>
      <input type="hidden" name="productId" value="<%= product.getId() %>"/>
    <% } %>

    <!-- Basic Info -->
    <div class="form-card">
      <div class="section-title">📝 Product Information</div>
      <div class="form-grid">
        <div class="form-group">
          <label for="name">Product Name *</label>
          <input type="text" id="name" name="name" placeholder="e.g. Men's Classic T-Shirt"
                 value="<%= isEdit ? product.getName() : "" %>" required/>
        </div>
        <div class="form-group">
          <label for="price">Base Price (₹) *</label>
          <input type="number" id="price" name="price" placeholder="999" step="0.01" min="0"
                 value="<%= isEdit ? String.format("%.2f", product.getPrice()) : "" %>" required/>
        </div>
        <div class="form-group">
          <label for="categoryId">Category *</label>
          <select id="categoryId" name="categoryId" required>
            <option value="">— Select Category —</option>
            <% if (cats != null) { for (Category c : cats) { %>
              <option value="<%= c.getId() %>"
                <%= (isEdit && product.getCategoryId() == c.getId()) ? "selected" : "" %>>
                <%= c.getName() %>
              </option>
            <% } } %>
          </select>
        </div>
        <div class="form-group">
          <label for="imageUrl">Image Filename</label>
          <input type="text" id="imageUrl" name="imageUrl" placeholder="images/product_name.png"
                 value="<%= isEdit && product.getImageUrl() != null ? product.getImageUrl() : "" %>"/>
        </div>
        <div class="form-group full">
          <label for="description">Description</label>
          <textarea id="description" name="description" placeholder="Describe the product in detail..."><%= isEdit && product.getDescription() != null ? product.getDescription() : "" %></textarea>
        </div>
      </div>
    </div>

    <!-- Variants -->
    <div class="form-card">
      <div class="variants-header">
        <div class="section-title" style="margin-bottom:0; border:none; padding:0;">📐 Sizes &amp; Variants</div>
        <button type="button" class="btn-add-row" onclick="addVariantRow()">➕ Add Size</button>
      </div>
      <div id="variantsContainer">
        <% if (isEdit && variants != null && !variants.isEmpty()) {
               for (ProductVariant v : variants) { %>
          <div class="variant-row">
            <div class="form-group" style="margin:0">
              <label>Size / Label</label>
              <input type="text" name="size[]" value="<%= v.getSize() %>" placeholder="S, M, L, XL..." required/>
            </div>
            <div class="form-group" style="margin:0">
              <label>Stock Qty</label>
              <input type="number" name="stock[]" value="<%= v.getStockQuantity() %>" placeholder="0" min="0" required/>
            </div>
            <div class="form-group" style="margin:0">
              <label>Price (₹)</label>
              <input type="number" name="varPrice[]" value="<%= String.format("%.2f", v.getPrice()) %>" placeholder="999" step="0.01" required/>
            </div>
            <button type="button" class="btn-remove-row" onclick="removeRow(this)">✕</button>
          </div>
        <% } } else { %>
          <!-- Default first row -->
          <div class="variant-row">
            <div class="form-group" style="margin:0">
              <label>Size / Label</label>
              <input type="text" name="size[]" placeholder="S, M, L, XL, One Size..." required/>
            </div>
            <div class="form-group" style="margin:0">
              <label>Stock Qty</label>
              <input type="number" name="stock[]" placeholder="25" min="0" required/>
            </div>
            <div class="form-group" style="margin:0">
              <label>Price (₹)</label>
              <input type="number" name="varPrice[]" placeholder="999" step="0.01" required/>
            </div>
            <button type="button" class="btn-remove-row" onclick="removeRow(this)">✕</button>
          </div>
        <% } %>
      </div>
    </div>

    <!-- Actions -->
    <div class="form-actions">
      <a href="<%= cp %>/admin/panel" class="btn-cancel">Cancel</a>
      <button type="submit" class="btn-submit"><%= isEdit ? "💾 Save Changes" : "✅ Add Product" %></button>
    </div>
  </form>
</main>

<script>
  function addVariantRow() {
    const container = document.getElementById('variantsContainer');
    const row = document.createElement('div');
    row.className = 'variant-row';
    row.innerHTML = `
      <div class="form-group" style="margin:0">
        <label>Size / Label</label>
        <input type="text" name="size[]" placeholder="S, M, L, XL, One Size..." required/>
      </div>
      <div class="form-group" style="margin:0">
        <label>Stock Qty</label>
        <input type="number" name="stock[]" placeholder="25" min="0" required/>
      </div>
      <div class="form-group" style="margin:0">
        <label>Price (₹)</label>
        <input type="number" name="varPrice[]" placeholder="999" step="0.01" required/>
      </div>
      <button type="button" class="btn-remove-row" onclick="removeRow(this)">✕</button>
    `;
    container.appendChild(row);
    row.querySelector('input').focus();
  }

  function removeRow(btn) {
    const rows = document.querySelectorAll('.variant-row');
    if (rows.length <= 1) { alert('At least one variant is required.'); return; }
    btn.closest('.variant-row').remove();
  }
</script>
</body>
</html>
