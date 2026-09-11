package com.miximoi.hrm.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Tiện ích kết nối JDBC đến PostgreSQL.
 * Cấu hình URL, USER, PASSWORD theo môi trường thực tế.
 * KHÔNG commit mật khẩu thật lên GitHub.
 */
public class DBConnection {

    private static final String URL = getParam("DB_URL", "db.url", "jdbc:postgresql://localhost:5432/miximoi_hrm");
    private static final String USER = getParam("DB_USER", "db.user", "postgres");
    private static final String PASSWORD = getParam("DB_PASSWORD", "db.password", "nqdung355");

    private static String getParam(String envKey, String propKey, String defaultValue) {
        String val = System.getProperty(propKey);
        if (val != null && !val.trim().isEmpty()) return val.trim();
        val = System.getenv(envKey);
        if (val != null && !val.trim().isEmpty()) return val.trim();
        return defaultValue;
    }

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("Không tìm thấy PostgreSQL JDBC Driver: " + e.getMessage());
        }
    }

    /** Ngăn khởi tạo instance */
    private DBConnection() {}

    /**
     * Lấy một Connection mới từ DriverManager.
     *
     * @return Connection đến PostgreSQL
     * @throws SQLException nếu kết nối thất bại
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * Đóng Connection an toàn (null-safe).
     *
     * @param conn Connection cần đóng
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
            }
        }
    }
}
