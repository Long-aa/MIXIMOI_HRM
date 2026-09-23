package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến User và Quản lý tài khoản RBAC.
 */
public class UserDAO {

    /**
     * Tìm user theo username (dùng cho đăng nhập).
     */
    public User findByUsername(String username) {
        String sql = "SELECT u.id, u.username, u.password, u.role, u.employee_id, u.active, "
                   + "u.created_at, u.updated_at, e.full_name, e.email, e.employee_code, "
                   + "p.name AS pos_name, d.name AS dept_name "
                   + "FROM users u "
                   + "LEFT JOIN employees e ON u.employee_id = e.id "
                   + "LEFT JOIN positions p ON e.position_id = p.id "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "WHERE u.username = ? AND u.active = true";
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
        String sql = "SELECT u.id, u.username, u.password, u.role, u.employee_id, u.active, "
                   + "u.created_at, u.updated_at, e.full_name, e.email, e.employee_code, "
                   + "p.name AS pos_name, d.name AS dept_name "
                   + "FROM users u "
                   + "LEFT JOIN employees e ON u.employee_id = e.id "
                   + "LEFT JOIN positions p ON e.position_id = p.id "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "WHERE u.id = ?";
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
     * Tìm kiếm và lọc danh sách tài khoản theo điều kiện.
     */
    public List<User> findAllFiltered(String keyword, String role, Integer deptId, String status) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT u.id, u.username, u.password, u.role, u.employee_id, u.active, " +
            "u.created_at, u.updated_at, e.full_name, e.email, e.employee_code, " +
            "p.name AS pos_name, d.name AS dept_name " +
            "FROM users u " +
            "LEFT JOIN employees e ON u.employee_id = e.id " +
            "LEFT JOIN positions p ON e.position_id = p.id " +
            "LEFT JOIN departments d ON e.department_id = d.id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (role != null && !role.trim().isEmpty()) {
            sql.append(" AND u.role = ?");
            params.add(role.trim());
        }
        if (deptId != null && deptId > 0) {
            sql.append(" AND e.department_id = ?");
            params.add(deptId);
        }
        if ("active".equalsIgnoreCase(status)) {
            sql.append(" AND u.active = true");
        } else if ("locked".equalsIgnoreCase(status)) {
            sql.append(" AND u.active = false");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.username ILIKE ? OR e.full_name ILIKE ? OR e.email ILIKE ? OR e.employee_code ILIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        sql.append(" ORDER BY u.id ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.findAllFiltered lỗi: " + e.getMessage());
        }
        return list;
    }

    /**
     * Đổi trạng thái kích hoạt / khóa tài khoản.
     */
    public boolean toggleStatus(int userId) {
        String sql = "UPDATE users SET active = NOT active, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UserDAO.toggleStatus lỗi: " + e.getMessage());
            return false;
        }
    }

    /**
     * Thêm user mới.
     */
    public boolean insert(User user) {
        String sql = "INSERT INTO users (username, password, role, employee_id, active, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            if (user.getEmployeeId() > 0) ps.setInt(4, user.getEmployeeId());
            else ps.setNull(4, Types.INTEGER);
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

    /**
     * Cập nhật thông tin profile người dùng và nhân viên liên kết.
     */
    public boolean updateUserProfile(int userId, int employeeId, String fullName, String email, String phone) {
        String userSql = "UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (employeeId > 0) {
                String empSql = "UPDATE employees SET full_name = ?, email = ?, phone = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
                try (PreparedStatement psEmp = conn.prepareStatement(empSql)) {
                    psEmp.setString(1, fullName);
                    psEmp.setString(2, email);
                    psEmp.setString(3, phone);
                    psEmp.setInt(4, employeeId);
                    psEmp.executeUpdate();
                }
            }
            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setInt(1, userId);
                return psUser.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.updateUserProfile lỗi: " + e.getMessage());
            return false;
        }
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
        try {
            u.setFullName(rs.getString("full_name"));
        } catch (SQLException ignored) {}
        try {
            u.setEmail(rs.getString("email"));
        } catch (SQLException ignored) {}
        try {
            u.setEmployeeCode(rs.getString("employee_code"));
        } catch (SQLException ignored) {}
        try {
            u.setPositionName(rs.getString("pos_name"));
        } catch (SQLException ignored) {}
        try {
            u.setDepartmentName(rs.getString("dept_name"));
        } catch (SQLException ignored) {}
        return u;
    }
}
