package com.tap.servlet;

import com.tap.dao.ProductDAO;
import com.tap.model.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String categoryIdStr = request.getParameter("category");
        
        List<Product> list;
        int categoryId = 0;
        
        if (query != null && !query.trim().isEmpty()) {
            list = productDAO.searchProducts(query);
            request.setAttribute("activePage", "shop");
        } else if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
                list = productDAO.getProductsByCategory(categoryId);
            } catch (NumberFormatException e) {
                list = productDAO.getAllProducts();
            }
            
            // Set active page for navbar highlight
            if (categoryId == 1) request.setAttribute("activePage", "men");
            else if (categoryId == 2) request.setAttribute("activePage", "women");
            else if (categoryId == 4) request.setAttribute("activePage", "kids");
            else if (categoryId == 3) request.setAttribute("activePage", "accessories");
            else request.setAttribute("activePage", "shop");
        } else {
            list = productDAO.getAllProducts();
            request.setAttribute("activePage", "shop");
        }
        
        request.setAttribute("products", list);
        request.setAttribute("categoryId", categoryId);
        
        request.getRequestDispatcher("/jsp/products.jsp").forward(request, response);
    }
}
