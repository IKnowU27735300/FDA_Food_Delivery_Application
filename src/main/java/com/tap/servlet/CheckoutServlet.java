package com.tap.servlet;

import com.tap.dao.OrderDAO;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=checkout");
            return;
        }
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=checkout");
            return;
        }
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        
        if (fullName == null || fullName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty()) {
            session.setAttribute("checkoutError", "All shipping details are required.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        
        double totalAmount = 0;
        for (CartItem item : cart) {
            totalAmount += item.getSubtotal();
        }
        
        Order order = new Order();
        order.setUserId(currentUser.getId());
        order.setTotalAmount(totalAmount);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "Cash on Delivery");
        order.setOrderStatus("PENDING");
        order.setDeliveryName(fullName);
        order.setDeliveryPhone(phone);
        order.setDeliveryAddress(address);
        
        int orderId = orderDAO.createOrder(order, cart);
        if (orderId > 0) {
            // Success! Clear session cart
            session.removeAttribute("cart");
            response.sendRedirect(request.getContextPath() + "/jsp/order-success.jsp?orderId=" + orderId);
        } else {
            session.setAttribute("checkoutError", "Checkout failed: Insufficient stock for one or more items, or database issue.");
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}
