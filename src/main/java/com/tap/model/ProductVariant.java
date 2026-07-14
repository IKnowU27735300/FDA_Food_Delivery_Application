package com.tap.model;

public class ProductVariant {
    private int id;
    private int productId;
    private String size;
    private int stockQuantity;
    private double price;

    public ProductVariant() {}

    public ProductVariant(int id, int productId, String size, int stockQuantity, double price) {
        this.id = id;
        this.productId = productId;
        this.size = size;
        this.stockQuantity = stockQuantity;
        this.price = price;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
