package com.tap.dao;

import com.tap.connection.DBConnection;
import com.tap.model.Category;
import com.tap.model.Product;
import com.tap.model.ProductVariant;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Category> getCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Category(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, COALESCE(SUM(pv.stock_quantity), 0) AS total_stock " +
                     "FROM products p " +
                     "LEFT JOIN product_variants pv ON p.id = pv.product_id " +
                     "GROUP BY p.id";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_url"),
                    rs.getInt("category_id")
                );
                p.setTotalStock(rs.getInt("total_stock"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, COALESCE(SUM(pv.stock_quantity), 0) AS total_stock " +
                     "FROM products p " +
                     "LEFT JOIN product_variants pv ON p.id = pv.product_id " +
                     "WHERE p.category_id = ? " +
                     "GROUP BY p.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("image_url"),
                        rs.getInt("category_id")
                    );
                    p.setTotalStock(rs.getInt("total_stock"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int productId) {
        String sql = "SELECT p.*, COALESCE(SUM(pv.stock_quantity), 0) AS total_stock " +
                     "FROM products p " +
                     "LEFT JOIN product_variants pv ON p.id = pv.product_id " +
                     "WHERE p.id = ? " +
                     "GROUP BY p.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("image_url"),
                        rs.getInt("category_id")
                    );
                    p.setTotalStock(rs.getInt("total_stock"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ProductVariant> getVariantsByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ? ORDER BY FIELD(size, 'S', 'M', 'L', 'XL', 'XXL')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ProductVariant(
                        rs.getInt("id"),
                        rs.getInt("product_id"),
                        rs.getString("size"),
                        rs.getInt("stock_quantity"),
                        rs.getDouble("price")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ProductVariant getVariantById(int variantId) {
        String sql = "SELECT * FROM product_variants WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ProductVariant(
                        rs.getInt("id"),
                        rs.getInt("product_id"),
                        rs.getString("size"),
                        rs.getInt("stock_quantity"),
                        rs.getDouble("price")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, COALESCE(SUM(pv.stock_quantity), 0) AS total_stock " +
                     "FROM products p " +
                     "LEFT JOIN product_variants pv ON p.id = pv.product_id " +
                     "WHERE p.name LIKE ? OR p.description LIKE ? " +
                     "GROUP BY p.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String likeKey = "%" + keyword + "%";
            ps.setString(1, likeKey);
            ps.setString(2, likeKey);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("image_url"),
                        rs.getInt("category_id")
                    );
                    p.setTotalStock(rs.getInt("total_stock"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
