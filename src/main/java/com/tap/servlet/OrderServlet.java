package com.tap.servlet;

import com.tap.dao.OrderDAO;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        if ("details".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int orderId = Integer.parseInt(idStr);
                    Order order = orderDAO.getOrderById(orderId);
                    
                    // Verify order exists and belongs to current user
                    if (order != null && order.getUserId() == currentUser.getId()) {
                        List<OrderItem> items = orderDAO.getOrderItemsByOrderId(orderId);
                        request.setAttribute("order", order);
                        request.setAttribute("items", items);
                        request.getRequestDispatcher("/jsp/order-details.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/orders");
        } else {
            // Default: Show order history list
            List<Order> orders = orderDAO.getOrdersByUserId(currentUser.getId());
            request.setAttribute("orders", orders);
            request.setAttribute("activePage", "profile"); // profile group selection in navbar/sidebar
            request.getRequestDispatcher("/jsp/my-orders.jsp").forward(request, response);
        }
    }
}
