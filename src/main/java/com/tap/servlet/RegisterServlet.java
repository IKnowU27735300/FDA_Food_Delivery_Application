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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String address = request.getParameter("address");
        String redirect = request.getParameter("redirect");
        
        HttpSession session = request.getSession();
        
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            session.setAttribute("registerError", "All fields are required for registration.");
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        
        // Check if email already in use
        if (userDAO.getUserByEmail(email) != null) {
            session.setAttribute("registerError", "Email address is already in use by another account.");
            String redirectParam = redirect != null ? "?redirect=" + redirect : "";
            response.sendRedirect(request.getContextPath() + "/register" + redirectParam);
            return;
        }
        
        User newUser = new User(fullName, email, phone, password, address, "USER");
        boolean success = userDAO.registerUser(newUser);
        
        if (success) {
            // Retrieve created user to get the auto-generated ID
            User loggedUser = userDAO.getUserByEmail(email);
            session.setAttribute("currentUser", loggedUser);
            
            // Merge guest cart items into DB cart if present
            List<CartItem> guestCart = (List<CartItem>) session.getAttribute("cart");
            int cartId = cartDAO.getOrCreateCartId(loggedUser.getId());
            if (guestCart != null && !guestCart.isEmpty()) {
                for (CartItem guestItem : guestCart) {
                    cartDAO.addOrUpdateCartItem(cartId, guestItem.getProductId(), guestItem.getVariantId(), guestItem.getQuantity());
                }
            }
            
            // Sync current database cart into session
            List<CartItem> dbCart = cartDAO.getCartItems(loggedUser.getId());
            session.setAttribute("cart", dbCart);
            
            // Redirect
            if (redirect != null && !redirect.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/" + redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            session.setAttribute("registerError", "Registration failed due to a database error. Please try again.");
            String redirectParam = redirect != null ? "?redirect=" + redirect : "";
            response.sendRedirect(request.getContextPath() + "/register" + redirectParam);
        }
    }
}
