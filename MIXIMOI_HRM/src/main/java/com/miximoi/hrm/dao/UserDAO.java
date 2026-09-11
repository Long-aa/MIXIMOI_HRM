package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;

/**
 * DAO xử lý các thao tác DB liên quan đến User.
 */
public class UserDAO {

    /**
     * Tìm user theo username (dùng cho đăng nhập).
     */
    public User findByUsername(String username) {
        String sql = "SELECT u.id, u.username, u.password, u.role, u.employee_id, u.active, "
                   + "u.created_at, u.updated_at "
                   + "FROM users u WHERE u.username = ? AND u.active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.findByUsername lỗi: " + e.getMessage());
        }
        return null;
    }

    /**
     * Tìm user theo ID.
     */
    public User findById(int id) {
        String sql = "SELECT id, username, password, role, employee_id, active, "
                   + "created_at, updated_at FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    /**
     * Thêm user mới.
     */
    public boolean insert(User user) {
        String sql = "INSERT INTO users (username, password, role, employee_id, active) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.setInt(4, user.getEmployeeId());
            ps.setBoolean(5, user.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UserDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /**
     * Cập nhật mật khẩu.
     */
    public boolean updatePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UserDAO.updatePassword lỗi: " + e.getMessage());
        }
        return false;
    }

    // ===== Helper =====
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setEmployeeId(rs.getInt("employee_id"));
        u.setActive(rs.getBoolean("active"));
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) u.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) u.setUpdatedAt(updatedAt.toLocalDateTime());
        return u;
    }
}
