CREATE DATABASE IF NOT EXISTS tap_fashion_db;
USE tap_fashion_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    password VARCHAR(100) NOT NULL,
    address TEXT,
    role VARCHAR(20) DEFAULT 'USER'
);

-- 2. Categories Table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- 3. Products Table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- 4. Product Variants Table (Size options)
CREATE TABLE IF NOT EXISTS product_variants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size VARCHAR(10) NOT NULL,
    stock_quantity INT DEFAULT 0,
    price DECIMAL(10, 2) NOT NULL,
    UNIQUE KEY uq_product_size (product_id, size),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 5. Cart Table
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Cart Items Table
CREATE TABLE IF NOT EXISTS cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES cart(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
);

-- 7. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    order_status VARCHAR(20) DEFAULT 'PENDING',
    delivery_name VARCHAR(100),
    delivery_phone VARCHAR(15),
    delivery_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 8. Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT,
    variant_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL,
    FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE SET NULL
);

-- Insert Sample Categories
INSERT INTO categories (id, name, description) VALUES
(1, 'Men''s Apparel', 'Classic and contemporary men''s clothing, shirts, and jackets.'),
(2, 'Women''s Apparel', 'Elegant dresses, skirts, tops, and statements for women.'),
(4, 'Kids'' Section', 'Fun educational toys, board games, puzzles, and comfortable kid-friendly dresses.'),
(3, 'Accessories', 'Premium bags, sunglasses, hats, and details to complete the look.')
ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description);

-- Insert Admin User (for Admin Panel access at /admin)
-- Credentials: admin@fashionvault.com / admin123
INSERT INTO users (full_name, email, phone, password, address, role) VALUES
('Fashion Vault Admin', 'admin@fashionvault.com', '0000000000', 'admin123', 'Admin HQ', 'ADMIN')
ON DUPLICATE KEY UPDATE role='ADMIN';


-- Insert Sample Products
INSERT INTO products (id, name, description, price, image_url, category_id) VALUES
(1, 'Classic Denim Jacket', 'A timeless utility denim jacket crafted from durable, premium cotton denim. Features chest button pockets, welt side pockets, and adjustable tab buttons at the back waist. Perfect for casual layering.', 1899.00, 'images/denim_jacket.jpg', 1),
(2, 'Slim Fit Linen Shirt', 'Lightweight and breathable slim fit shirt woven from pure, textured organic flax linen. Designed with a clean band collar, button-up front, and curved shirttail hem. Keeps you cool and comfortable all day.', 1299.00, 'images/linen_shirt.jpg', 1),
(3, 'Floral Summer Dress', 'A beautiful, flowing midi dress patterned with vibrant wildflower blooms. Featuring a structured corset bodice, delicate tie-up shoulder straps, and a flared tier skirt with a subtle side slit.', 1599.00, 'images/summer_dress.jpg', 2),
(4, 'Pleated Midi Skirt', 'An elegant pleated skirt falling gracefully to a midi length. Fabricated in lightweight, satin-finish crepe with a flexible elasticized waistband. Moves beautifully with every step.', 1199.00, 'images/midi_skirt.jpg', 2),
(5, 'Leather Crossbody Bag', 'A sleek, compact crossbody bag handcrafted from rich full-grain calfskin leather. Accented with brass hardware, featuring a secure zipper top, fabric-lined interior, and an adjustable shoulder strap.', 2499.00, 'images/crossbody_bag.jpg', 3),
(6, 'Classic Aviator Sunglasses', 'Unisex aviator sunglasses built with a slim gold-toned metal frame, double bridge bar, and protective dark grey polarized lenses. Offers 100% UV protection and classic vintage vibes.', 699.00, 'images/aviator_glasses.jpg', 3),
(7, 'Classic Crewneck T-Shirt', 'A premium crewneck t-shirt made from 100% combed cotton. Exceptionally soft, durable, and tailored for a perfect fit.', 599.00, 'images/mens_tshirt.png', 1),
(8, 'Elegant Formal Dress Combo', 'A sophisticated formal ensemble including a tailored blazer and matching trousers. Crafted from premium stretch-blend fabric for all-day comfort and sharp style.', 2999.00, 'images/womens_formal_dress_combo.png', 2),
(9, 'Men\'s Chronograph Leather Watch', 'A luxury men\'s chronograph watch featuring a genuine leather strap, water-resistant stainless steel casing, and precise quartz movement.', 3499.00, 'images/mens_watch.png', 3),
(10, 'Women\'s Rose Gold Mesh Watch', 'An elegant women\'s watch with a sleek rose gold mesh strap, minimalist dial, and scratch-resistant sapphire crystal glass.', 3299.00, 'images/womens_watch.png', 3),
(11, 'Silver Pendant & Necklace Combo', 'A beautiful layered necklace set for women featuring fine sterling silver chains and elegant minimalist pendants.', 1499.00, 'images/womens_necklace_combo.png', 3),
(12, 'Men\'s Titanium Stud Earpieces', 'Sleek and modern titanium stud earpieces designed for men. Features a matte finish and secure screw-back design.', 499.00, 'images/mens_earpieces.png', 3),
(13, 'Women\'s Pearl Hoop Earpieces', 'Charming hoop earpieces adorned with freshwater cultured pearls. Perfect for adding a touch of elegance to any outfit.', 599.00, 'images/womens_earpieces.png', 3),
(14, 'Men\'s Classic Charcoal Formal Trousers', 'Tailored slim-fit charcoal formal trousers crafted from a premium wrinkle-resistant poly-viscose blend. Featuring a clean flat-front design, side pockets, and double-welt back pockets.', 1499.00, 'images/mens_formal_pants.png', 1),
(15, 'Men\'s Classic Indigo Jeans', 'Classic straight-fit jeans cut from durable, mid-weight cotton denim with a vintage indigo wash. Features classic five-pocket styling, contrast stitching, and a metal button closure.', 1699.00, 'images/mens_jeans.png', 1),
(16, 'Men\'s Comfort Fit Casual Chinos', 'Everyday slim chinos constructed from soft, stretch-twill cotton fabric. Designed with a button-through waistband, slanted side pockets, and coin pocket. Perfect for smart-casual wear.', 1299.00, 'images/mens_casual_pants.png', 1),
(17, 'Men\'s Graphic Casual T-Shirt', 'A premium crewneck t-shirt featuring a modern geometric print on the chest. Knit from soft, breathable combed cotton for relaxed weekend comfort.', 699.00, 'images/mens_casual_tshirt_v2.png', 1),
(18, 'Men\'s Premium White Formal Shirt', 'A crisp, classic white dress shirt woven from 100% fine cotton with an easy-iron finish. Features a spread collar, button cuffs, and structured back yoke.', 1599.00, 'images/mens_formal_shirt.png', 1),
(19, 'Men\'s Vintage Plaid Casual Shirt', 'A cozy and rugged flannel button-down shirt featuring a vintage red and black plaid pattern. Accented with dual chest patch pockets and buttoned cuffs.', 1399.00, 'images/mens_casual_shirt.png', 1),
(20, 'Women\'s High-Waist Formal Trousers', 'Elegant high-rise formal trousers with a sophisticated wide-leg silhouette. Fabricated from premium crepe that drapes beautifully. Features side zip closure and clean welt pockets.', 1899.00, 'images/womens_formal_pants.png', 2),
(21, 'Women\'s Classic Skinny Jeans', 'An ultra-flattering skinny jean engineered from high-stretch denim that moves with you while retaining its shape. Styled with a classic five-pocket setup in a vintage blue wash.', 1599.00, 'images/womens_jeans.png', 2),
(22, 'Women\'s Relaxed Fit Casual Pants', 'Comfortable and light casual trousers crafted from a soft linen-cotton blend. Features an elasticated drawstring waist, relaxed tapered leg, and side slip pockets.', 1299.00, 'images/womens_casual_pants.png', 2),
(23, 'Women\'s V-Neck Casual T-Shirt', 'A basic V-neck casual t-shirt made of soft modal-cotton jersey. Features a relaxed silhouette, short sleeves, and a curved hem.', 699.00, 'images/womens_casual_tshirt.png', 2),
(24, 'Women\'s Silk Formal Blouse', 'A luxurious and smooth long-sleeve formal blouse styled in pure ivory silk. Detailed with a elegant band collar and covered front button placket.', 2799.00, 'images/womens_formal_shirt_v2.png', 2),
(25, 'Women\'s Oversized Linen Casual Shirt', 'A lightweight, breathable oversized casual button-up shirt in soft peach linen. Perfect for layering over tank tops on warm days.', 1499.00, 'images/womens_casual_shirt.png', 2),
(26, 'Soft Cuddly Princess Doll', 'A beautiful, soft fabric princess doll dressed in a lovely pink satin gown. Features stitched facial details, yarn hair, and is completely child-safe.', 799.00, 'images/kids_doll.png', 4),
(27, 'Die-Cast Toy Race Car', 'A high-speed die-cast metal toy race car in sporty red with working rubber tires, pull-back action, and openable doors. Designed for children 3+.', 499.00, 'images/kids_car.png', 4),
(28, '100-Piece Animal Kingdom Puzzle', 'An educational 100-piece cardboard jigsaw puzzle featuring a vibrant forest animal illustration. Helps develop problem-solving skills and fine motor coordination.', 399.00, 'images/kids_puzzle.png', 4),
(29, 'Classic Ludo Board Game Set', 'A premium folding wooden Ludo board game set with high-quality wooden tokens and two dice. A classic family tabletop game for kids and adults alike.', 599.00, 'images/kids_ludo.png', 4),
(30, 'Educational Building Blocks Set', 'A creative set of 120 colorful plastic building blocks in various shapes and sizes. Stimulates imagination, spatial reasoning, and creative construction skills.', 999.00, 'images/kids_toy_blocks.png', 4),
(31, 'Kid\'s Cotton Floral Summer Dress', 'A lovely and airy kid\'s summer dress stitched from 100% breathable organic cotton. Featuring a bright yellow floral pattern and adjustable tie-up shoulder straps.', 899.00, 'images/kids_dress_floral.png', 4),
(32, 'Kid\'s Denim Dungaree Combo', 'A classic and durable kid\'s outfit featuring a washed denim dungaree skirt paired with a striped cotton short-sleeve tee. Perfect for active play.', 1199.00, 'images/kids_dungaree.png', 4),
(33, 'Kid\'s Cozy Dino Hoodie & Joggers', 'A warm and playful outfit featuring a fleece hoodie with dinosaur spike details on the hood and matching elasticated joggers. Soft, cozy, and kid-approved.', 1299.00, 'images/kids_dino_set.png', 4)
ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), price=VALUES(price), image_url=VALUES(image_url), category_id=VALUES(category_id);

-- Insert Product Variants (Sizes and stock)
INSERT INTO product_variants (product_id, size, stock_quantity, price) VALUES
(1, 'S', 12, 1699.00),
(1, 'M', 25, 1899.00),
(1, 'L', 18, 1999.00),
(1, 'XL', 8, 2199.00),
(2, 'S', 15, 1199.00),
(2, 'M', 30, 1299.00),
(2, 'L', 20, 1399.00),
(2, 'XL', 10, 1499.00),
(3, 'S', 8, 1499.00),
(3, 'M', 18, 1599.00),
(3, 'L', 12, 1699.00),
(4, 'S', 10, 1099.00),
(4, 'M', 20, 1199.00),
(4, 'L', 15, 1299.00),
(5, 'One Size', 25, 2499.00),
(6, 'One Size', 40, 699.00),
(7, 'S', 30, 499.00),
(7, 'M', 50, 599.00),
(7, 'L', 40, 649.00),
(7, 'XL', 20, 699.00),
(8, 'S', 10, 2899.00),
(8, 'M', 15, 2999.00),
(8, 'L', 12, 3099.00),
(9, 'One Size', 15, 3499.00),
(10, 'One Size', 20, 3299.00),
(11, 'One Size', 25, 1499.00),
(12, 'One Size', 30, 499.00),
(13, 'One Size', 25, 599.00),
(14, 'S', 15, 1399.00),
(14, 'M', 20, 1499.00),
(14, 'L', 15, 1599.00),
(15, 'S', 20, 1599.00),
(15, 'M', 25, 1699.00),
(15, 'L', 20, 1799.00),
(16, 'S', 15, 1199.00),
(16, 'M', 25, 1299.00),
(16, 'L', 20, 1399.00),
(17, 'S', 30, 599.00),
(17, 'M', 40, 699.00),
(17, 'L', 35, 749.00),
(17, 'XL', 15, 799.00),
(18, 'S', 15, 1499.00),
(18, 'M', 25, 1599.00),
(18, 'L', 20, 1699.00),
(19, 'S', 20, 1299.00),
(19, 'M', 30, 1399.00),
(19, 'L', 25, 1499.00),
(20, 'S', 12, 1799.00),
(20, 'M', 18, 1899.00),
(20, 'L', 15, 1999.00),
(21, 'S', 20, 1499.00),
(21, 'M', 30, 1599.00),
(21, 'L', 25, 1699.00),
(22, 'S', 15, 1199.00),
(22, 'M', 25, 1299.00),
(22, 'L', 20, 1399.00),
(23, 'S', 25, 599.00),
(23, 'M', 35, 699.00),
(23, 'L', 30, 749.00),
(24, 'S', 10, 2699.00),
(24, 'M', 15, 2799.00),
(24, 'L', 12, 2899.00),
(25, 'S', 15, 1399.00),
(25, 'M', 20, 1499.00),
(25, 'L', 15, 1599.00),
(26, 'One Size', 25, 799.00),
(27, 'One Size', 40, 499.00),
(28, 'One Size', 30, 399.00),
(29, 'One Size', 20, 599.00),
(30, 'One Size', 35, 999.00),
(31, '2-3Y', 15, 799.00),
(31, '4-5Y', 20, 899.00),
(31, '6-7Y', 15, 999.00),
(32, '2-3Y', 12, 1099.00),
(32, '4-5Y', 18, 1199.00),
(32, '6-7Y', 12, 1299.00),
(33, '2-3Y', 10, 1199.00),
(33, '4-5Y', 15, 1299.00),
(33, '6-7Y', 12, 1399.00)
ON DUPLICATE KEY UPDATE stock_quantity=VALUES(stock_quantity), price=VALUES(price);
