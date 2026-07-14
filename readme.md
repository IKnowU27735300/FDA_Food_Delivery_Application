Here is the refined, highly structured **Master Context Document**. 

### 💡 How to use this document:
Copy everything inside the box below and paste it as the **first prompt** (or as a `.md` context file) into your AI coding assistant (Cursor, Windsurf, GitHub Copilot, or ChatGPT). This document contains all the architectural decisions, constraints, and step-by-step instructions required to build the project **without errors**, specifically tailored for **Eclipse IDE, Maven, and Tomcat 10.1**.

***

```markdown
# MASTER SYSTEM CONTEXT: "Fashion Store" E-Commerce Project

## 1. ROLE & OBJECTIVE
You are an Expert Full-Stack Java Architect and Senior Developer. Your objective is to guide me in building a complete, end-to-end E-Commerce Web Application named "Fashion Store" from scratch. 
**Constraint:** Do NOT generate the entire codebase in a single response. We will build this layer-by-layer. Acknowledge this document, confirm your understanding of the tech stack and constraints, and wait for my command to begin Step 1.

## 2. TECHNOLOGY STACK & ENVIRONMENT CONSTRAINTS (CRITICAL)
*   **IDE:** Eclipse IDE (Maven Project)
*   **Java Version:** JDK 21
*   **Server:** Apache Tomcat 10.1 
*   **⚠️ CRITICAL IMPORT RULE:** Because we are using Tomcat 10.1, you MUST use **Jakarta EE** imports (`jakarta.servlet.*`, `jakarta.servlet.http.*`). DO NOT use legacy `javax.servlet.*` imports, or the code will fail to compile.
*   **Dynamic Web Module:** 5.0
*   **Database:** MySQL (Database Name: `fashion_store`)
*   **Frontend:** JSP (JavaServer Pages), HTML5, CSS3, Vanilla JavaScript.
*   **Architecture:** Strict MVC (Model-View-Controller) + DAO Design Pattern.

## 3. DATABASE SCHEMA (MySQL)
*Note: Address is stored directly in the `users` and `orders` tables (1-to-1 relationship) to keep it simple. No separate address table.*

```sql
CREATE DATABASE fashion_store;
USE fashion_store;

-- 1. Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL, -- Store encrypted
    address_line1 VARCHAR(255), address_line2 VARCHAR(255),
    city VARCHAR(50), state VARCHAR(50), pincode VARCHAR(10), country VARCHAR(50)
);

-- 2. Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- 3. Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 4. Product Variants Table (Size/Stock)
CREATE TABLE product_variants (
    variant_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    size VARCHAR(10) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    UNIQUE (product_id, size) -- Prevents duplicate sizes for same product
);

-- 5. Carts Table
CREATE TABLE carts (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 6. Cart Items Table
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT,
    variant_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id)
);

-- 7. Orders Table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(20) DEFAULT 'PLACED',
    delivery_name VARCHAR(100), delivery_phone VARCHAR(15),
    address_line1 VARCHAR(255), address_line2 VARCHAR(255),
    city VARCHAR(50), state VARCHAR(50), pincode VARCHAR(10), country VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 8. Order Items Table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    variant_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL, -- Price at the time of purchase
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id)
);
```

## 4. PROJECT STRUCTURE (Eclipse Maven Layout)
Follow this exact directory structure. Do not deviate.

```text
fashion-store/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/com/fashionstore/
│   │   │   ├── controller/       # Servlets (Controllers)
│   │   │   ├── model/            # POJO / Entity Classes
│   │   │   ├── dao/              # DAO Interfaces
│   │   │   │   └── implementation/ # DAO Impl Classes (JDBC)
│   │   │   └── util/             # DBConnection, PasswordUtil
│   │   ├── resources/
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml       # Deployment Descriptor
│   │       │   └── views/        # JSP Files (Protected from direct URL access)
│   │       │       ├── partials/ # navbar.jsp, footer.jsp
│   │       │       ├── home.jsp, products.jsp, product-details.jsp, etc.
│   │       └── assets/           # Public static resources
│   │           ├── css/          # style.css, home.css, auth.css, etc.
│   │           ├── js/           # script.js
│   │           └── images/products/ # Product Images
```

## 5. ARCHITECTURE & DESIGN PATTERNS RULES
1.  **MVC Pattern:** 
    *   **View:** JSP files only handle rendering and UI logic. No database queries in JSP.
    *   **Controller:** Servlets extend `HttpServlet`. They handle `doGet`/`doPost`, fetch data via DAO, set data as `request.setAttribute()`, and forward to JSP using `RequestDispatcher`.
    *   **Model:** POJO classes with private fields, constructors, getters, and setters.
2.  **DAO Pattern:** 
    *   Create an **Interface** for every entity (e.g., `UserDao`, `ProductDao`).
    *   Create an **Implementation Class** in the `dao.implementation` package.
    *   Use `PreparedStatement` with `?` placeholders for ALL queries to prevent SQL injection.
3.  **Security:** 
    *   Never store plain-text passwords. Use `PasswordUtil` (e.g., SHA-256 or BCrypt) to hash before inserting and verify during login.
4.  **Session Management:** 
    *   Use `HttpSession` to track the logged-in `user_id` and `cart_id`.
    *   Protect servlets (like Cart, Checkout) by checking if the session attribute exists; if not, redirect to `/login`.

## 6. ROUTING & CONTROLLER MAP
*   `/home` -> `HomeServlet` (Fetches featured products & categories)
*   `/products` -> `ProductServlet` (Handles filtering by category, price, sorting)
*   `/product-details` -> `ProductDetailsServlet` (Fetches single product & variants by ID)
*   `/register` -> `RegisterServlet` (POST: Creates user)
*   `/login` -> `LoginServlet` (POST: Validates credentials, creates session)
*   `/logout` -> `LogoutServlet` (Invalidates session)
*   `/cart` -> `CartServlet` (Handles Add, Update, Remove cart items)
*   `/checkout` -> `CheckoutServlet` (POST: Moves cart to orders, clears cart)
*   `/order-success` -> `OrderSuccessServlet` (Displays confirmation)

## 7. STEP-BY-STEP EXECUTION PLAN
To ensure zero errors and maintain context, we will execute in this exact order. **Wait for my prompt before moving to the next step.**

*   **Step 1:** Generate `pom.xml` dependencies (MySQL Connector, Jakarta Servlet API, JSTL).
*   **Step 2:** Generate `util` package (`DBConnection.java`, `PasswordUtil.java`).
*   **Step 3:** Generate `model` package (All 8 POJO classes).
*   **Step 4:** Generate `dao` interfaces.
*   **Step 5:** Generate `dao.implementation` classes (JDBC logic).
*   **Step 6:** Generate `controller` Servlets (One by one or in logical groups).
*   **Step 7:** Generate `webapp` structure (`web.xml`, `partials`, JSPs, and CSS).
*   **Step 8:** Provide sample SQL `INSERT` scripts for testing data.

---
**AI Acknowledgment:** 
If you understand these constraints, the tech stack, the Jakarta EE requirement, and the step-by-step plan, reply with: 
*"Context loaded. I am ready to act as your Full-Stack Java Architect. Shall we begin with Step 1: Generating the `pom.xml` with the correct Jakarta EE and MySQL dependencies?"*
```

### 🚀 Next Steps for You:
1. Open your AI tool (Cursor, ChatGPT, etc.).
2. Paste the **entire markdown block** above.
3. Once the AI acknowledges it, simply say: **"Yes, proceed with Step 1."**
4. The AI will give you the `pom.xml`. Copy it into your Eclipse Maven project.
5. Continue saying **"Proceed to Step X"** until the project is fully built. 

*Note: When you reach Step 7 (JSP/CSS), if the AI generates basic UI, you can take screenshots of Myntra/Amazon and say to the AI: "Update the CSS to match this color theme and layout," just like in the transcript!*