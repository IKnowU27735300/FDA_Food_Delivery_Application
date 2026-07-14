package com.tap.dao;

import com.tap.connection.DBConnection;
import com.tap.model.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public int getOrCreateCartId(int userId) {
        String checkSql = "SELECT id FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
            
            // Cart doesn't exist, create it
            String insertSql = "INSERT INTO cart (user_id) VALUES (?)";
            try (PreparedStatement insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                insertPs.setInt(1, userId);
                insertPs.executeUpdate();
                try (ResultSet generatedKeys = insertPs.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<CartItem> getCartItems(int userId) {
        List<CartItem> list = new ArrayList<>();
        int cartId = getOrCreateCartId(userId);
        if (cartId == -1) return list;

        String sql = "SELECT ci.id, ci.cart_id, ci.product_id, ci.variant_id, ci.quantity, " +
                     "p.name AS product_name, pv.price AS product_price, p.image_url, pv.size " +
                     "FROM cart_items ci " +
                     "JOIN products p ON ci.product_id = p.id " +
                     "JOIN product_variants pv ON ci.variant_id = pv.id " +
                     "WHERE ci.cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem(
                        rs.getInt("id"),
                        rs.getInt("cart_id"),
                        rs.getInt("product_id"),
                        rs.getInt("variant_id"),
                        rs.getInt("quantity")
                    );
                    item.setProductName(rs.getString("product_name"));
                    item.setProductPrice(rs.getDouble("product_price"));
                    item.setImageUrl(rs.getString("image_url"));
                    item.setSize(rs.getString("size"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addOrUpdateCartItem(int cartId, int productId, int variantId, int quantity) {
        String checkSql = "SELECT id, quantity FROM cart_items WHERE cart_id = ? AND variant_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, cartId);
            checkPs.setInt(2, variantId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    // Update quantity
                    int existingQty = rs.getInt("quantity");
                    String updateSql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, existingQty + quantity);
                        updatePs.setInt(2, rs.getInt("id"));
                        return updatePs.executeUpdate() > 0;
                    }
                } else {
                    // Insert new item
                    String insertSql = "INSERT INTO cart_items (cart_id, product_id, variant_id, quantity) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, cartId);
                        insertPs.setInt(2, productId);
                        insertPs.setInt(3, variantId);
                        insertPs.setInt(4, quantity);
                        return insertPs.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeCartItem(int cartId, int variantId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ? AND variant_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, variantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean clearCart(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
