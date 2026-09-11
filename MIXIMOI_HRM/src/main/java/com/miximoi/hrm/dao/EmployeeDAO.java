package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Employee.
 */
public class EmployeeDAO {

    private static final String BASE_SELECT =
        "SELECT e.id, e.employee_code, e.full_name, e.date_of_birth, e.gender, "
      + "e.phone, e.email, e.address, e.department_id, d.name AS department_name, "
      + "e.position_id, p.name AS position_name, "
      + "e.employee_type_id, et.name AS employee_type_name, "
      + "e.start_date, e.status, e.created_at, e.updated_at "
      + "FROM employees e "
      + "LEFT JOIN departments d ON e.department_id = d.id "
      + "LEFT JOIN positions p ON e.position_id = p.id "
      + "LEFT JOIN employee_types et ON e.employee_type_id = et.id ";

    /** Lấy tất cả nhân viên đang hoạt động */
    public List<Employee> findAll() {
        List<Employee> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE e.status != 'INACTIVE' ORDER BY e.employee_code";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Tìm nhân viên theo ID */
    public Employee findById(int id) {
        String sql = BASE_SELECT + "WHERE e.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    /** Tìm kiếm nhân viên theo từ khóa (tên hoặc mã) */
    public List<Employee> search(String keyword, Integer departmentId, String status) {
        List<Employee> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
        }
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND e.status = ? ");
        }
        sql.append("ORDER BY e.employee_code");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (departmentId != null && departmentId > 0) ps.setInt(idx++, departmentId);
            if (status != null && !status.trim().isEmpty()) ps.setString(idx, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.search lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Thêm nhân viên mới */
    public boolean insert(Employee emp) {
        String sql = "INSERT INTO employees (employee_code, full_name, date_of_birth, gender, "
                   + "phone, email, address, department_id, position_id, employee_type_id, "
                   + "start_date, status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getEmployeeCode());
            ps.setString(2, emp.getFullName());
            ps.setDate(3, emp.getDateOfBirth() != null ? Date.valueOf(emp.getDateOfBirth()) : null);
            ps.setString(4, emp.getGender());
            ps.setString(5, emp.getPhone());
            ps.setString(6, emp.getEmail());
            ps.setString(7, emp.getAddress());
            ps.setInt(8, emp.getDepartmentId());
            ps.setInt(9, emp.getPositionId());
            ps.setInt(10, emp.getEmployeeTypeId());
            ps.setDate(11, emp.getStartDate() != null ? Date.valueOf(emp.getStartDate()) : null);
            ps.setString(12, emp.getStatus() != null ? emp.getStatus() : "ACTIVE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Cập nhật thông tin nhân viên */
    public boolean update(Employee emp) {
        String sql = "UPDATE employees SET full_name=?, date_of_birth=?, gender=?, phone=?, "
                   + "email=?, address=?, department_id=?, position_id=?, employee_type_id=?, "
                   + "start_date=?, status=?, updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getFullName());
            ps.setDate(2, emp.getDateOfBirth() != null ? Date.valueOf(emp.getDateOfBirth()) : null);
            ps.setString(3, emp.getGender());
            ps.setString(4, emp.getPhone());
            ps.setString(5, emp.getEmail());
            ps.setString(6, emp.getAddress());
            ps.setInt(7, emp.getDepartmentId());
            ps.setInt(8, emp.getPositionId());
            ps.setInt(9, emp.getEmployeeTypeId());
            ps.setDate(10, emp.getStartDate() != null ? Date.valueOf(emp.getStartDate()) : null);
            ps.setString(11, emp.getStatus());
            ps.setInt(12, emp.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.update lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Xóa mềm nhân viên (đổi status = INACTIVE) */
    public boolean deactivate(int id) {
        String sql = "UPDATE employees SET status='INACTIVE', updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.deactivate lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Đếm tổng nhân viên đang làm */
    public int countActive() {
        String sql = "SELECT COUNT(*) FROM employees WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.countActive lỗi: " + e.getMessage());
        }
        return 0;
    }

    // ===== Helper =====
    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setId(rs.getInt("id"));
        e.setEmployeeCode(rs.getString("employee_code"));
        e.setFullName(rs.getString("full_name"));
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) e.setDateOfBirth(dob.toLocalDate());
        e.setGender(rs.getString("gender"));
        e.setPhone(rs.getString("phone"));
        e.setEmail(rs.getString("email"));
        e.setAddress(rs.getString("address"));
        e.setDepartmentId(rs.getInt("department_id"));
        e.setDepartmentName(rs.getString("department_name"));
        e.setPositionId(rs.getInt("position_id"));
        e.setPositionName(rs.getString("position_name"));
        e.setEmployeeTypeId(rs.getInt("employee_type_id"));
        e.setEmployeeTypeName(rs.getString("employee_type_name"));
        Date startDate = rs.getDate("start_date");
        if (startDate != null) e.setStartDate(startDate.toLocalDate());
        e.setStatus(rs.getString("status"));
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) e.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) e.setUpdatedAt(updatedAt.toLocalDateTime());
        return e;
    }
}
