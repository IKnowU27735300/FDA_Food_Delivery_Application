package com.tap.servlet;

import com.tap.dao.CartDAO;
import com.tap.dao.UserDAO;
import com.tap.model.CartItem;
import com.tap.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");
        
        HttpSession session = request.getSession();
        
        User user = userDAO.verifyLogin(email, password);
        if (user != null) {
            session.setAttribute("currentUser", user);
            
            // Merge guest cart items into DB cart if present
            List<CartItem> guestCart = (List<CartItem>) session.getAttribute("cart");
            int cartId = cartDAO.getOrCreateCartId(user.getId());
            if (guestCart != null && !guestCart.isEmpty()) {
                for (CartItem guestItem : guestCart) {
                    cartDAO.addOrUpdateCartItem(cartId, guestItem.getProductId(), guestItem.getVariantId(), guestItem.getQuantity());
                }
            }
            
            // Sync current database cart into session
            List<CartItem> dbCart = cartDAO.getCartItems(user.getId());
            session.setAttribute("cart", dbCart);
            
            // Redirect
            if (redirect != null && !redirect.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/" + redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            session.setAttribute("loginError", "Invalid email address or password.");
            String redirectParam = redirect != null ? "?redirect=" + redirect : "";
            response.sendRedirect(request.getContextPath() + "/login" + redirectParam);
        }
    }
}
