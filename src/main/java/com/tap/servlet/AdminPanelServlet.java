package com.tap.servlet;

import com.tap.dao.AdminDAO;
import com.tap.model.Category;
import com.tap.model.Product;
import com.tap.model.ProductVariant;
import com.tap.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/panel")
public class AdminPanelServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    /** Guard: redirect to /admin login if no admin session present. */
    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            res.sendRedirect(req.getContextPath() + "/admin");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) return;

        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.removeAttribute("adminUser");
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        // Stats for dashboard header
        request.setAttribute("totalProducts", adminDAO.countProducts());
        request.setAttribute("totalOrders",   adminDAO.countOrders());
        request.setAttribute("totalUsers",    adminDAO.countUsers());

        if ("add".equals(action)) {
            // Show blank add-product form
            request.setAttribute("categories", adminDAO.getCategories());
            request.getRequestDispatcher("/jsp/admin/admin-product-form.jsp").forward(request, response);

        } else if ("edit".equals(action)) {
            // Show pre-filled edit form
            int id = Integer.parseInt(request.getParameter("id"));
            Product product  = findProduct(id);
            List<ProductVariant> variants = adminDAO.getVariantsByProductId(id);
            request.setAttribute("product",    product);
            request.setAttribute("variants",   variants);
            request.setAttribute("categories", adminDAO.getCategories());
            request.getRequestDispatcher("/jsp/admin/admin-product-form.jsp").forward(request, response);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            adminDAO.deleteProduct(id);  // CASCADE removes variants + cart_items
            response.sendRedirect(request.getContextPath() + "/admin/panel?msg=deleted");

        } else {
            // Default: dashboard — product list
            request.setAttribute("products", adminDAO.getAllProductsWithCategory());
            request.getRequestDispatcher("/jsp/admin/admin-dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) return;

        String action = request.getParameter("action");

        String   name        = request.getParameter("name").trim();
        String   description = request.getParameter("description").trim();
        double   price       = Double.parseDouble(request.getParameter("price"));
        String   imageUrl    = request.getParameter("imageUrl").trim();
        int      categoryId  = Integer.parseInt(request.getParameter("categoryId"));

        // Sizes, stocks, prices sent as parallel arrays
        String[] sizes       = request.getParameterValues("size[]");
        String[] stocks      = request.getParameterValues("stock[]");
        String[] varPrices   = request.getParameterValues("varPrice[]");

        if ("add".equals(action)) {
            int productId = adminDAO.addProduct(name, description, price, imageUrl, categoryId);
            if (productId > 0 && sizes != null) {
                for (int i = 0; i < sizes.length; i++) {
                    String sz = sizes[i].trim();
                    if (!sz.isEmpty()) {
                        int    stock    = Integer.parseInt(stocks[i].trim());
                        double varPrice = Double.parseDouble(varPrices[i].trim());
                        adminDAO.addVariant(productId, sz, stock, varPrice);
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/panel?msg=added");

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("productId"));
            adminDAO.updateProduct(id, name, description, price, imageUrl, categoryId);
            // Re-create variants (delete old, insert new)
            adminDAO.deleteVariantsByProductId(id);
            if (sizes != null) {
                for (int i = 0; i < sizes.length; i++) {
                    String sz = sizes[i].trim();
                    if (!sz.isEmpty()) {
                        int    stock    = Integer.parseInt(stocks[i].trim());
                        double varPrice = Double.parseDouble(varPrices[i].trim());
                        adminDAO.addVariant(id, sz, stock, varPrice);
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/panel?msg=updated");
        }
    }

    private Product findProduct(int id) {
        for (Product p : adminDAO.getAllProductsWithCategory()) {
            if (p.getId() == id) return p;
        }
        return null;
    }
}
