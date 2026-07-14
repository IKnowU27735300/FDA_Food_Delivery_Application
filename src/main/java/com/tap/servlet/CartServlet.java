package com.tap.servlet;

import com.tap.dao.CartDAO;
import com.tap.dao.ProductDAO;
import com.tap.model.CartItem;
import com.tap.model.Product;
import com.tap.model.ProductVariant;
import com.tap.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Sync database cart to session if user is logged in and session cart is empty/missing
        if (currentUser != null) {
            List<CartItem> dbCart = cartDAO.getCartItems(currentUser.getId());
            session.setAttribute("cart", dbCart);
        }
        
        request.setAttribute("activePage", "cart");
        request.getRequestDispatcher("/jsp/cart.jsp").forward(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if ("add".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                Product product = productDAO.getProductById(productId);
                ProductVariant variant = productDAO.getVariantById(variantId);
                
                if (product == null || variant == null || quantity <= 0) {
                    session.setAttribute("errorMessage", "Invalid product or quantity.");
                    response.sendRedirect(request.getContextPath() + "/products");
                    return;
                }
                
                if (variant.getStockQuantity() < quantity) {
                    session.setAttribute("errorMessage", "Insufficient stock available.");
                    response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
                    return;
                }
                
                if (currentUser != null) {
                    // Logged in user: persist to DB
                    int cartId = cartDAO.getOrCreateCartId(currentUser.getId());
                    cartDAO.addOrUpdateCartItem(cartId, productId, variantId, quantity);
                    
                    // Sync to session
                    List<CartItem> dbCart = cartDAO.getCartItems(currentUser.getId());
                    session.setAttribute("cart", dbCart);
                } else {
                    // Guest user: save to session list
                    List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("cart");
                    if (sessionCart == null) {
                        sessionCart = new ArrayList<>();
                    }
                    
                    boolean found = false;
                    for (CartItem item : sessionCart) {
                        if (item.getVariantId() == variantId) {
                            item.setQuantity(item.getQuantity() + quantity);
                            found = true;
                            break;
                        }
                    }
                    
                    if (!found) {
                        CartItem newItem = new CartItem(0, 0, productId, variantId, quantity);
                        newItem.setProductName(product.getName());
                        newItem.setProductPrice(variant.getPrice());
                        newItem.setImageUrl(product.getImageUrl());
                        newItem.setSize(variant.getSize());
                        sessionCart.add(newItem);
                    }
                    session.setAttribute("cart", sessionCart);
                }
                
                session.setAttribute("successMessage", "Item added to cart successfully!");
                response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
                
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Error parsing quantity or details.");
                response.sendRedirect(request.getContextPath() + "/products");
            }
            
        } else if ("remove".equalsIgnoreCase(action)) {
            try {
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                
                if (currentUser != null) {
                    // Logged in: delete from DB
                    int cartId = cartDAO.getOrCreateCartId(currentUser.getId());
                    cartDAO.removeCartItem(cartId, variantId);
                    
                    // Sync
                    List<CartItem> dbCart = cartDAO.getCartItems(currentUser.getId());
                    session.setAttribute("cart", dbCart);
                } else {
                    // Guest: remove from list
                    List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("cart");
                    if (sessionCart != null) {
                        sessionCart.removeIf(item -> item.getVariantId() == variantId);
                        session.setAttribute("cart", sessionCart);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/cart");
                
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        }
    }
}
