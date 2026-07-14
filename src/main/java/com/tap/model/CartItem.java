package com.tap.model;

public class CartItem {
    private int id;
    private int cartId;
    private int productId;
    private int variantId;
    private int quantity;

    // Derived fields for easy rendering in JSP
    private String productName;
    private double productPrice;
    private String imageUrl;
    private String size;

    public CartItem() {}

    public CartItem(int id, int cartId, int productId, int variantId, int quantity) {
        this.id = id;
        this.cartId = cartId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getVariantId() { return variantId; }
    public void setVariantId(int variantId) { this.variantId = variantId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public double getProductPrice() { return productPrice; }
    public void setProductPrice(double productPrice) { this.productPrice = productPrice; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public double getSubtotal() {
        return this.productPrice * this.quantity;
    }
}
