package com.tap.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3307/tap_fashion_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            String host = System.getenv("DB_HOST");
            String port = System.getenv("DB_PORT");
            String db = System.getenv("DB_NAME");
            if (host != null && !host.trim().isEmpty()) {
                port = (port != null && !port.trim().isEmpty()) ? port : "3306";
                db = (db != null && !db.trim().isEmpty()) ? db : "tap_fashion_db";
                url = "jdbc:mysql://" + host + ":" + port + "/" + db + "?useSSL=false&allowPublicKeyRetrieval=true";
            } else {
                url = DEFAULT_URL;
            }
        }

        String user = System.getenv("DB_USER");
        if (user == null) {
            user = DEFAULT_USER;
        }

        String password = System.getenv("DB_PASSWORD");
        if (password == null) {
            password = DEFAULT_PASSWORD;
        }

        return DriverManager.getConnection(url, user, password);
    }
}
