package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Employee.
 * Đồng bộ đầy đủ với schema mở rộng (CCCD, địa chỉ TT, ngân hàng, bảo hiểm, v.v.)
 */
public class EmployeeDAO {

    private static final String BASE_SELECT =
        "SELECT e.id, e.employee_code, e.full_name, e.date_of_birth, e.gender, "
      + "e.phone, e.email, e.address, e.temp_address, e.nationality, e.ethnicity, e.avatar_url, "
      + "e.identity_number, e.identity_date, e.identity_place, "
      + "e.department_id, d.name AS department_name, "
      + "e.position_id, p.name AS position_name, "
      + "e.employee_type_id, et.name AS employee_type_name, "
      + "e.start_date, e.end_date, e.termination_reason, e.status, "
      + "e.base_salary, e.bank_account, e.bank_name, e.bank_branch, "
      + "e.tax_code, e.insurance_number, "
      + "e.emergency_contact_name, e.emergency_contact_phone, e.emergency_contact_relation, "
      + "e.created_at, e.updated_at "
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

    /** Tìm kiếm nhân viên theo từ khóa, phòng ban, chức vụ, trạng thái */
    public List<Employee> search(String keyword, Integer departmentId, Integer positionId, String status) {
        List<Employee> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ? OR LOWER(e.email) LIKE ? OR e.phone LIKE ?) ");
        }
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (positionId != null && positionId > 0) {
            sql.append("AND e.position_id = ? ");
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
                ps.setString(idx++, like);
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }
            if (departmentId != null && departmentId > 0) ps.setInt(idx++, departmentId);
            if (positionId != null && positionId > 0) ps.setInt(idx++, positionId);
            if (status != null && !status.trim().isEmpty()) ps.setString(idx, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.search lỗi: " + e.getMessage());
        }
        return list;
    }

    public List<Employee> search(String keyword, Integer departmentId, String status) {
        return search(keyword, departmentId, null, status);
    }

    /** Sinh mã nhân viên tiếp theo tự động (dạng NV013) */
    public String getNextEmployeeCode() {
        String sql = "SELECT employee_code FROM employees WHERE employee_code ~ '^NV[0-9]+$'";
        int max = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String code = rs.getString(1);
                try {
                    int num = Integer.parseInt(code.substring(2));
                    if (num > max) max = num;
                } catch (NumberFormatException ignored) {}
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.getNextEmployeeCode lỗi: " + e.getMessage());
        }
        return String.format("NV%03d", max + 1);
    }

    /** Thêm nhân viên mới (đầy đủ các trường mở rộng) */
    public boolean insert(Employee emp) {
        String sql = "INSERT INTO employees (employee_code, full_name, date_of_birth, gender, "
                   + "phone, email, address, temp_address, nationality, ethnicity, avatar_url, "
                   + "identity_number, identity_date, identity_place, "
                   + "department_id, position_id, employee_type_id, "
                   + "start_date, status, base_salary, bank_account, bank_name, bank_branch, "
                   + "tax_code, insurance_number, "
                   + "emergency_contact_name, emergency_contact_phone, emergency_contact_relation) "
                   + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, emp.getEmployeeCode());
            ps.setString(2, emp.getFullName());
            ps.setDate(3, emp.getDateOfBirth() != null ? Date.valueOf(emp.getDateOfBirth()) : null);
            ps.setString(4, emp.getGender());
            ps.setString(5, emp.getPhone());
            ps.setString(6, emp.getEmail());
            ps.setString(7, emp.getAddress());
            ps.setString(8, emp.getTempAddress());
            ps.setString(9, emp.getNationality() != null ? emp.getNationality() : "Việt Nam");
            ps.setString(10, emp.getEthnicity());
            ps.setString(11, emp.getAvatarUrl());
            ps.setString(12, emp.getIdentityNumber());
            ps.setDate(13, emp.getIdentityDate() != null ? Date.valueOf(emp.getIdentityDate()) : null);
            ps.setString(14, emp.getIdentityPlace());
            if (emp.getDepartmentId() > 0) ps.setInt(15, emp.getDepartmentId());
            else ps.setNull(15, Types.INTEGER);
            if (emp.getPositionId() > 0) ps.setInt(16, emp.getPositionId());
            else ps.setNull(16, Types.INTEGER);
            if (emp.getEmployeeTypeId() > 0) ps.setInt(17, emp.getEmployeeTypeId());
            else ps.setInt(17, 1);
            ps.setDate(18, emp.getStartDate() != null ? Date.valueOf(emp.getStartDate()) : Date.valueOf(java.time.LocalDate.now()));
            ps.setString(19, emp.getStatus() != null && !emp.getStatus().isEmpty() ? emp.getStatus() : "ACTIVE");
            if (emp.getBaseSalary() != null) ps.setBigDecimal(20, emp.getBaseSalary());
            else ps.setNull(20, Types.NUMERIC);
            ps.setString(21, emp.getBankAccount());
            ps.setString(22, emp.getBankName());
            ps.setString(23, emp.getBankBranch());
            ps.setString(24, emp.getTaxCode());
            ps.setString(25, emp.getInsuranceNumber());
            ps.setString(26, emp.getEmergencyContactName());
            ps.setString(27, emp.getEmergencyContactPhone());
            ps.setString(28, emp.getEmergencyContactRelation());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) emp.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Cập nhật thông tin nhân viên (đầy đủ) */
    public boolean update(Employee emp) {
        String sql = "UPDATE employees SET full_name=?, date_of_birth=?, gender=?, phone=?, "
                   + "email=?, address=?, temp_address=?, nationality=?, ethnicity=?, avatar_url=?, "
                   + "identity_number=?, identity_date=?, identity_place=?, "
                   + "department_id=?, position_id=?, employee_type_id=?, "
                   + "start_date=?, end_date=?, termination_reason=?, status=?, "
                   + "base_salary=?, bank_account=?, bank_name=?, bank_branch=?, "
                   + "tax_code=?, insurance_number=?, "
                   + "emergency_contact_name=?, emergency_contact_phone=?, emergency_contact_relation=?, "
                   + "updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getFullName());
            ps.setDate(2, emp.getDateOfBirth() != null ? Date.valueOf(emp.getDateOfBirth()) : null);
            ps.setString(3, emp.getGender());
            ps.setString(4, emp.getPhone());
            ps.setString(5, emp.getEmail());
            ps.setString(6, emp.getAddress());
            ps.setString(7, emp.getTempAddress());
            ps.setString(8, emp.getNationality());
            ps.setString(9, emp.getEthnicity());
            ps.setString(10, emp.getAvatarUrl());
            ps.setString(11, emp.getIdentityNumber());
            ps.setDate(12, emp.getIdentityDate() != null ? Date.valueOf(emp.getIdentityDate()) : null);
            ps.setString(13, emp.getIdentityPlace());
            ps.setInt(14, emp.getDepartmentId());
            ps.setInt(15, emp.getPositionId());
            ps.setInt(16, emp.getEmployeeTypeId());
            ps.setDate(17, emp.getStartDate() != null ? Date.valueOf(emp.getStartDate()) : null);
            ps.setDate(18, emp.getEndDate() != null ? Date.valueOf(emp.getEndDate()) : null);
            ps.setString(19, emp.getTerminationReason());
            ps.setString(20, emp.getStatus());
            if (emp.getBaseSalary() != null) ps.setBigDecimal(21, emp.getBaseSalary());
            else ps.setNull(21, Types.NUMERIC);
            ps.setString(22, emp.getBankAccount());
            ps.setString(23, emp.getBankName());
            ps.setString(24, emp.getBankBranch());
            ps.setString(25, emp.getTaxCode());
            ps.setString(26, emp.getInsuranceNumber());
            ps.setString(27, emp.getEmergencyContactName());
            ps.setString(28, emp.getEmergencyContactPhone());
            ps.setString(29, emp.getEmergencyContactRelation());
            ps.setInt(30, emp.getId());
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

    /** Xóa mềm hàng loạt theo danh sách ID */
    public int deactivateBulk(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return 0;
        StringBuilder sql = new StringBuilder("UPDATE employees SET status='INACTIVE', updated_at=CURRENT_TIMESTAMP WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i > 0 ? ",?" : "?");
        }
        sql.append(")");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.deactivateBulk lỗi: " + e.getMessage());
        }
        return 0;
    }

    /** Lấy danh sách nhân viên theo list ID (dùng cho bulk export) */
    public List<Employee> findByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE e.id IN (");
        for (int i = 0; i < ids.size(); i++) sql.append(i > 0 ? ",?" : "?");
        sql.append(") ORDER BY e.employee_code");
        List<Employee> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) ps.setInt(i + 1, ids.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.findByIds lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Đếm tổng số tất cả nhân viên */
    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM employees";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.countTotal lỗi: " + e.getMessage());
        }
        return 0;
    }

    /** Đếm tổng nhân viên theo trạng thái */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM employees WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.countByStatus lỗi: " + e.getMessage());
        }
        return 0;
    }

    public int countActive() {
        return countByStatus("ACTIVE");
    }

    // ===== Helper mapping =====
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
        e.setTempAddress(rs.getString("temp_address"));
        e.setNationality(rs.getString("nationality"));
        e.setEthnicity(rs.getString("ethnicity"));
        e.setAvatarUrl(rs.getString("avatar_url"));
        e.setIdentityNumber(rs.getString("identity_number"));
        Date idDate = rs.getDate("identity_date");
        if (idDate != null) e.setIdentityDate(idDate.toLocalDate());
        e.setIdentityPlace(rs.getString("identity_place"));
        e.setDepartmentId(rs.getInt("department_id"));
        e.setDepartmentName(rs.getString("department_name"));
        e.setPositionId(rs.getInt("position_id"));
        e.setPositionName(rs.getString("position_name"));
        e.setEmployeeTypeId(rs.getInt("employee_type_id"));
        e.setEmployeeTypeName(rs.getString("employee_type_name"));
        Date startDate = rs.getDate("start_date");
        if (startDate != null) e.setStartDate(startDate.toLocalDate());
        Date endDate = rs.getDate("end_date");
        if (endDate != null) e.setEndDate(endDate.toLocalDate());
        e.setTerminationReason(rs.getString("termination_reason"));
        e.setStatus(rs.getString("status"));
        BigDecimal salary = rs.getBigDecimal("base_salary");
        if (salary != null) e.setBaseSalary(salary);
        e.setBankAccount(rs.getString("bank_account"));
        e.setBankName(rs.getString("bank_name"));
        e.setBankBranch(rs.getString("bank_branch"));
        e.setTaxCode(rs.getString("tax_code"));
        e.setInsuranceNumber(rs.getString("insurance_number"));
        e.setEmergencyContactName(rs.getString("emergency_contact_name"));
        e.setEmergencyContactPhone(rs.getString("emergency_contact_phone"));
        e.setEmergencyContactRelation(rs.getString("emergency_contact_relation"));
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) e.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) e.setUpdatedAt(updatedAt.toLocalDateTime());
        return e;
    }
}
