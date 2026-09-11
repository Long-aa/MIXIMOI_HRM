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
        String sql = "SELECT d.id, d.name, d.description, "
                   + "COUNT(e.id) AS employee_count "
                   + "FROM departments d "
                   + "LEFT JOIN employees e ON e.department_id = d.id AND e.status = 'ACTIVE' "
                   + "GROUP BY d.id, d.name, d.description ORDER BY d.name";
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
        String sql = "SELECT id, name, description FROM departments WHERE id = ?";
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
        String sql = "INSERT INTO departments (name, description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dept.getName());
            ps.setString(2, dept.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DepartmentDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Cập nhật phòng ban */
    public boolean update(Department dept) {
        String sql = "UPDATE departments SET name = ?, description = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dept.getName());
            ps.setString(2, dept.getDescription());
            ps.setInt(3, dept.getId());
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
        d.setDescription(rs.getString("description"));
        try { d.setEmployeeCount(rs.getInt("employee_count")); } catch (SQLException ignored) {}
        return d;
    }
}
