package com.tap.servlet;

import com.tap.dao.ProductDAO;
import com.tap.model.Product;
import com.tap.model.ProductVariant;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(idStr);
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }
            
            List<ProductVariant> variants = productDAO.getVariantsByProductId(productId);
            
            request.setAttribute("product", product);
            request.setAttribute("variants", variants);
            
            request.getRequestDispatcher("/jsp/product-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
