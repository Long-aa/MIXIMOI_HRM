package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Department.
 */
public class DepartmentDAO {

    /** Lấy danh sách tất cả phòng ban kèm số lượng nhân viên */
    public List<Department> findAll() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT d.id, d.name, d.code, d.description, d.manager_id, m.full_name AS manager_name, "
                   + "d.status, d.created_at, COUNT(e.id) AS employee_count "
                   + "FROM departments d "
                   + "LEFT JOIN employees m ON d.manager_id = m.id "
                   + "LEFT JOIN employees e ON e.department_id = d.id AND e.status = 'ACTIVE' "
                   + "GROUP BY d.id, d.name, d.code, d.description, d.manager_id, m.full_name, d.status, d.created_at "
                   + "ORDER BY d.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("DepartmentDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Tìm phòng ban theo ID */
    public Department findById(int id) {
        String sql = "SELECT d.id, d.name, d.code, d.description, d.manager_id, m.full_name AS manager_name, "
                   + "d.status, d.created_at, COUNT(e.id) AS employee_count "
                   + "FROM departments d "
                   + "LEFT JOIN employees m ON d.manager_id = m.id "
                   + "LEFT JOIN employees e ON e.department_id = d.id AND e.status = 'ACTIVE' "
                   + "WHERE d.id = ? "
                   + "GROUP BY d.id, d.name, d.code, d.description, d.manager_id, m.full_name, d.status, d.created_at";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("DepartmentDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    /** Thêm phòng ban mới */
    public boolean insert(Department dept) {
        String sql = "INSERT INTO departments (name, code, description, manager_id, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dept.getName());
            ps.setString(2, dept.getCode());
            ps.setString(3, dept.getDescription());
            if (dept.getManagerId() != null && dept.getManagerId() > 0) {
                ps.setInt(4, dept.getManagerId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, dept.getStatus() != null ? dept.getStatus() : "ACTIVE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DepartmentDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Cập nhật phòng ban */
    public boolean update(Department dept) {
        String sql = "UPDATE departments SET name = ?, code = ?, description = ?, manager_id = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dept.getName());
            ps.setString(2, dept.getCode());
            ps.setString(3, dept.getDescription());
            if (dept.getManagerId() != null && dept.getManagerId() > 0) {
                ps.setInt(4, dept.getManagerId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, dept.getStatus() != null ? dept.getStatus() : "ACTIVE");
            ps.setInt(6, dept.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DepartmentDAO.update lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Xóa phòng ban (chỉ xóa khi không có nhân viên) */
    public boolean delete(int id) {
        String sql = "DELETE FROM departments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DepartmentDAO.delete lỗi: " + e.getMessage());
        }
        return false;
    }

    // ===== Helper =====
    private Department mapRow(ResultSet rs) throws SQLException {
        Department d = new Department();
        d.setId(rs.getInt("id"));
        d.setName(rs.getString("name"));
        try { d.setCode(rs.getString("code")); } catch (SQLException ignored) {}
        d.setDescription(rs.getString("description"));
        try {
            int mId = rs.getInt("manager_id");
            if (!rs.wasNull()) d.setManagerId(mId);
        } catch (SQLException ignored) {}
        try { d.setManagerName(rs.getString("manager_name")); } catch (SQLException ignored) {}
        try { d.setStatus(rs.getString("status")); } catch (SQLException ignored) {}
        try {
            Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) d.setCreatedAt(ts);
        } catch (SQLException ignored) {}
        try { d.setEmployeeCount(rs.getInt("employee_count")); } catch (SQLException ignored) {}
        return d;
    }
}
