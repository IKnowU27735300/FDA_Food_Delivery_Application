package com.tap.dao;

import com.tap.connection.DBConnection;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int createOrder(Order order, List<CartItem> cartItems) {
        Connection conn = null;
        PreparedStatement orderPs = null;
        PreparedStatement itemPs = null;
        PreparedStatement stockPs = null;
        PreparedStatement clearCartPs = null;
        ResultSet generatedKeys = null;
        
        String insertOrderSql = "INSERT INTO orders (user_id, total_amount, payment_method, order_status, " +
                                "delivery_name, delivery_phone, delivery_address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertItemSql = "INSERT INTO order_items (order_id, product_id, variant_id, quantity, price) " +
                               "VALUES (?, ?, ?, ?, ?)";
        String updateStockSql = "UPDATE product_variants SET stock_quantity = stock_quantity - ? " +
                                "WHERE id = ? AND stock_quantity >= ?";
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // 1. Insert Order
            orderPs = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            orderPs.setInt(1, order.getUserId());
            orderPs.setDouble(2, order.getTotalAmount());
            orderPs.setString(3, order.getPaymentMethod());
            orderPs.setString(4, order.getOrderStatus() != null ? order.getOrderStatus() : "PENDING");
            orderPs.setString(5, order.getDeliveryName());
            orderPs.setString(6, order.getDeliveryPhone());
            orderPs.setString(7, order.getDeliveryAddress());
            
            int affectedRows = orderPs.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }
            
            int orderId = -1;
            generatedKeys = orderPs.getGeneratedKeys();
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }
            
            // 2. Insert Order Items & Deduct Stock
            itemPs = conn.prepareStatement(insertItemSql);
            stockPs = conn.prepareStatement(updateStockSql);
            
            for (CartItem item : cartItems) {
                // Insert order item
                itemPs.setInt(1, orderId);
                itemPs.setInt(2, item.getProductId());
                itemPs.setInt(3, item.getVariantId());
                itemPs.setInt(4, item.getQuantity());
                itemPs.setDouble(5, item.getProductPrice());
                itemPs.addBatch();
                
                // Update stock variant
                stockPs.setInt(1, item.getQuantity());
                stockPs.setInt(2, item.getVariantId());
                stockPs.setInt(3, item.getQuantity()); // condition check: stock_quantity >= qty
                int stockUpdated = stockPs.executeUpdate();
                if (stockUpdated == 0) {
                    throw new SQLException("Insufficient stock for product: " + item.getProductName() + " (size: " + item.getSize() + ")");
                }
            }
            itemPs.executeBatch();
            
            // 3. Clear User's Database Cart
            String clearCartSql = "DELETE FROM cart_items WHERE cart_id = (SELECT id FROM cart WHERE user_id = ?)";
            clearCartPs = conn.prepareStatement(clearCartSql);
            clearCartPs.setInt(1, order.getUserId());
            clearCartPs.executeUpdate();
            
            conn.commit(); // Transaction succeeds
            return orderId;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (orderPs != null) orderPs.close();
                if (itemPs != null) itemPs.close();
                if (stockPs != null) stockPs.close();
                if (clearCartPs != null) clearCartPs.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return -1;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Order(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getDouble("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("order_status"),
                        rs.getString("delivery_name"),
                        rs.getString("delivery_phone"),
                        rs.getString("delivery_address"),
                        rs.getTimestamp("created_at")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Order(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getDouble("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("order_status"),
                        rs.getString("delivery_name"),
                        rs.getString("delivery_phone"),
                        rs.getString("delivery_address"),
                        rs.getTimestamp("created_at")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.id, oi.order_id, oi.product_id, oi.variant_id, oi.quantity, oi.price, " +
                     "p.name AS product_name, p.image_url, pv.size " +
                     "FROM order_items oi " +
                     "LEFT JOIN products p ON oi.product_id = p.id " +
                     "LEFT JOIN product_variants pv ON oi.variant_id = pv.id " +
                     "WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem(
                        rs.getInt("id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getInt("variant_id"),
                        rs.getInt("quantity"),
                        rs.getDouble("price")
                    );
                    item.setProductName(rs.getString("product_name") != null ? rs.getString("product_name") : "Product Unavailable");
                    item.setImageUrl(rs.getString("image_url") != null ? rs.getString("image_url") : "images/placeholder.jpg");
                    item.setSize(rs.getString("size") != null ? rs.getString("size") : "N/A");
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
