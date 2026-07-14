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

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("activePage", "home");
        
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("featuredProducts", products);
        
        request.getRequestDispatcher("/jsp/index.jsp").forward(request, response);
    }
}
