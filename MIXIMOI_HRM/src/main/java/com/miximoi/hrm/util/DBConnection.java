package com.miximoi.hrm.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Quản ly Connection Pool den PostgreSQL su dung HikariCP.
 *
 * Thiet ke: Singleton Pattern + static factory method.
 * HikariDataSource duoc khoi tao mot lan duy nhat (thread-safe via class loading)
 * va tai su dung suot vong doi ung dung.
 *
 * Cau hinh uu tien (cao → thap):
 *   1. System property: -Ddb.url=...   (truyen qua JVM / Tomcat args)
 *   2. Environment variable: DB_URL, DB_USER, DB_PASSWORD
 *   3. Gia tri fallback mac dinh cho moi truong phat trien
 *
 * Luu y bao mat: KHONG commit mat khau that len Git.
 * Su dung bien moi truong hoac file cau hinh ngoai (khong commit).
 *
 * @see com.miximoi.hrm.listener.AppContextListener - goi closePool() khi ung dung shutdown
 */
public final class DBConnection {

    // =========================================================================
    //  Cau hinh ket noi - doc tu System Property -> Env Var -> Fallback default
    // =========================================================================
    private static final String JDBC_URL = resolveParam("DB_URL",      "db.url",      "jdbc:postgresql://localhost:5432/miximoi_hrm");
    private static final String DB_USER  = resolveParam("DB_USER",     "db.user",     "postgres");
    private static final String DB_PASS  = resolveParam("DB_PASSWORD", "db.password", "nqdung355");

    // =========================================================================
    //  HikariCP pool - khoi tao mot lan, thread-safe boi class loading JVM
    // =========================================================================
    private static final HikariDataSource DATA_SOURCE;

    static {
        HikariConfig config = new HikariConfig();

        // -- Ket noi co ban --
        config.setJdbcUrl(JDBC_URL);
        config.setUsername(DB_USER);
        config.setPassword(DB_PASS);
        config.setDriverClassName("org.postgresql.Driver");

        // -- Pool sizing --
        config.setMaximumPoolSize(20);       // 20 connection toi da - phu hop hoc tap/demo
        config.setMinimumIdle(5);            // 5 connection du tru toi thieu

        // -- Timeout & health check --
        config.setConnectionTimeout(30_000);  // 30s cho lay connection tu pool
        config.setIdleTimeout(600_000);       // 10 phut - dong connection ranh
        config.setMaxLifetime(1_800_000);     // 30 phut - tuoi tho toi da 1 connection
        config.setKeepaliveTime(60_000);      // 1 phut - ping giu connection song

        // -- Ping kiem tra connection con song (PostgreSQL) --
        config.setConnectionTestQuery("SELECT 1");

        // -- Pool name hien thi trong log --
        config.setPoolName("MixiMoi-HRM-Pool");

        // -- Toi uu PreparedStatement cache --
        config.addDataSourceProperty("cachePrepStmts",        "true");
        config.addDataSourceProperty("prepStmtCacheSize",     "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        DATA_SOURCE = new HikariDataSource(config);
        System.out.println("[DBConnection] HikariCP pool khoi tao thanh cong -> " + JDBC_URL);
    }

    /** Singleton utility class - ngan khoi tao instance tu ben ngoai */
    private DBConnection() {
        throw new UnsupportedOperationException("DBConnection is a utility class");
    }

    // =========================================================================
    //  Public API
    // =========================================================================

    /**
     * Lay mot Connection tu HikariCP pool.
     *
     * Connection BAT BUOC phai duoc dong (try-with-resources hoac close())
     * de tra ve pool. Voi HikariCP, close() khong dong socket that ma chi
     * tra connection ve pool de tai su dung.
     *
     * Example:
     *   try (Connection conn = DBConnection.getConnection()) {
     *       // su dung conn
     *   } // tu dong tra ve pool
     *
     * @return Connection san sang su dung
     * @throws SQLException neu pool het connection hoac vuot qua connectionTimeout
     */
    public static Connection getConnection() throws SQLException {
        return DATA_SOURCE.getConnection();
    }

    /**
     * Dong toan bo connection pool - goi khi ung dung shutdown.
     * Nen duoc goi trong contextDestroyed() cua AppContextListener.
     */
    public static void closePool() {
        if (DATA_SOURCE != null && !DATA_SOURCE.isClosed()) {
            DATA_SOURCE.close();
            System.out.println("[DBConnection] HikariCP pool da dong.");
        }
    }

    // =========================================================================
    //  Null-safe close helpers - giam boilerplate trong DAO
    // =========================================================================

    /** Dong Connection an toan (null-safe, tra ve HikariCP pool). */
    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); }
            catch (SQLException e) {
                System.err.println("[DBConnection] Loi dong Connection: " + e.getMessage());
            }
        }
    }

    /** Dong PreparedStatement an toan (null-safe). */
    public static void close(PreparedStatement ps) {
        if (ps != null) {
            try { ps.close(); }
            catch (SQLException e) {
                System.err.println("[DBConnection] Loi dong PreparedStatement: " + e.getMessage());
            }
        }
    }

    /** Dong ResultSet an toan (null-safe). */
    public static void close(ResultSet rs) {
        if (rs != null) {
            try { rs.close(); }
            catch (SQLException e) {
                System.err.println("[DBConnection] Loi dong ResultSet: " + e.getMessage());
            }
        }
    }

    // =========================================================================
    //  Private helpers
    // =========================================================================

    /**
     * Giai quyet gia tri cau hinh theo thu tu uu tien:
     * System Property (JVM) -> Environment Variable -> Default value.
     *
     * @param envKey       Ten bien moi truong (e.g. "DB_URL")
     * @param propKey      Ten System property  (e.g. "db.url")
     * @param defaultValue Gia tri fallback cho moi truong dev
     * @return Gia tri cau hinh da duoc resolve
     */
    private static String resolveParam(String envKey, String propKey, String defaultValue) {
        String value = System.getProperty(propKey);
        if (value != null && !value.isBlank()) return value.strip();

        value = System.getenv(envKey);
        if (value != null && !value.isBlank()) return value.strip();

        return defaultValue;
    }
}
