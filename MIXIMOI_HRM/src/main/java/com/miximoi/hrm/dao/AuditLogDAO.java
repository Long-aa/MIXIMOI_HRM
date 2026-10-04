package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.AuditLog;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.DBConnection;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý ghi và tra cứu nhật ký kiểm toán (Audit Trail) trong PostgreSQL.
 * Chống SQL Injection tuyệt đối với PreparedStatement.
 */
public class AuditLogDAO {

    /**
     * Ghi nhật ký kiểm toán mới vào CSDL.
     */
    public boolean insert(AuditLog log) {
        String sql = "INSERT INTO audit_logs (user_id, username, user_role, action, module, record_id, details, ip_address, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (log.getUserId() != null) {
                ps.setInt(1, log.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, log.getUsername() != null ? log.getUsername() : "SYSTEM");
            ps.setString(3, log.getUserRole() != null ? log.getUserRole() : "ANONYMOUS");
            ps.setString(4, log.getAction());
            ps.setString(5, log.getModule());
            if (log.getRecordId() != null) {
                ps.setInt(6, log.getRecordId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setString(7, log.getDetails());
            ps.setString(8, log.getIpAddress());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[AuditLogDAO] Lỗi ghi nhật ký kiểm toán: " + e.getMessage());
            return false;
        }
    }

    /**
     * Phương thức tiện ích tĩnh: Tự động trích xuất thông tin người dùng từ request để ghi nhật ký.
     */
    public static void logAction(HttpServletRequest req, String action, String module, Integer recordId, String details) {
        try {
            Integer userId = null;
            String username = "SYSTEM";
            String userRole = "SYSTEM";

            if (req != null) {
                HttpSession session = req.getSession(false);
                if (session != null) {
                    User currentUser = (User) session.getAttribute("currentUser");
                    if (currentUser != null) {
                        userId = currentUser.getId();
                        username = currentUser.getUsername();
                        userRole = currentUser.getRole();
                    }
                }
            }

            String ipAddress = "127.0.0.1";
            if (req != null) {
                ipAddress = req.getHeader("X-Forwarded-For");
                if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
                    ipAddress = req.getRemoteAddr();
                }
            }

            AuditLog log = new AuditLog(userId, username, userRole, action, module, recordId, details, ipAddress);
            new AuditLogDAO().insert(log);
        } catch (Exception e) {
            System.err.println("[AuditLogDAO.logAction] Không thể ghi audit log: " + e.getMessage());
        }
    }

    /**
     * Tra cứu danh sách nhật ký gần nhất.
     */
    public List<AuditLog> findRecent(int limit) {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit > 0 ? limit : 50);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLog item = new AuditLog();
                    item.setId(rs.getInt("id"));
                    int uid = rs.getInt("user_id");
                    if (!rs.wasNull()) item.setUserId(uid);
                    item.setUsername(rs.getString("username"));
                    item.setUserRole(rs.getString("user_role"));
                    item.setAction(rs.getString("action"));
                    item.setModule(rs.getString("module"));
                    int rid = rs.getInt("record_id");
                    if (!rs.wasNull()) item.setRecordId(rid);
                    item.setDetails(rs.getString("details"));
                    item.setIpAddress(rs.getString("ip_address"));
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) item.setCreatedAt(ts.toLocalDateTime());
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("[AuditLogDAO.findRecent] Lỗi: " + e.getMessage());
        }
        return list;
    }

    /**
     * Tìm kiếm và lọc đa tiêu chí lịch sử kiểm toán.
     */
    public List<AuditLog> search(String keyword, String action, String module, int limit) {
        List<AuditLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM audit_logs WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(username) LIKE ? OR LOWER(details) LIKE ? OR LOWER(ip_address) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (action != null && !action.trim().isEmpty() && !"ALL".equalsIgnoreCase(action)) {
            sql.append("AND LOWER(action) LIKE ? ");
            params.add("%" + action.trim().toLowerCase() + "%");
        }
        if (module != null && !module.trim().isEmpty() && !"ALL".equalsIgnoreCase(module)) {
            sql.append("AND LOWER(module) = LOWER(?) ");
            params.add(module.trim());
        }
        sql.append("ORDER BY created_at DESC LIMIT ?");
        params.add(limit > 0 ? limit : 100);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLog item = new AuditLog();
                    item.setId(rs.getInt("id"));
                    int uid = rs.getInt("user_id");
                    if (!rs.wasNull()) item.setUserId(uid);
                    item.setUsername(rs.getString("username"));
                    item.setUserRole(rs.getString("user_role"));
                    item.setAction(rs.getString("action"));
                    item.setModule(rs.getString("module"));
                    int rid = rs.getInt("record_id");
                    if (!rs.wasNull()) item.setRecordId(rid);
                    item.setDetails(rs.getString("details"));
                    item.setIpAddress(rs.getString("ip_address"));
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) item.setCreatedAt(ts.toLocalDateTime());
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("[AuditLogDAO.search] Lỗi: " + e.getMessage());
        }
        return list;
    }
}
