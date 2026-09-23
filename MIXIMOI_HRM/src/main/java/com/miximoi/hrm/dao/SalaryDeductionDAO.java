package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.SalaryDeduction;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalaryDeductionDAO {

    private static final String BASE_SELECT =
        "SELECT sd.id, sd.employee_id, e.employee_code, e.full_name AS employee_name, "
      + "d.name AS department_name, sd.deduction_type, sd.amount, sd.pay_month, sd.pay_year, "
      + "sd.description, sd.created_at "
      + "FROM salary_deductions sd "
      + "JOIN employees e ON sd.employee_id = e.id "
      + "LEFT JOIN departments d ON e.department_id = d.id ";

    public List<SalaryDeduction> findByPeriod(int month, int year, Integer deptId, String keyword) {
        List<SalaryDeduction> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE sd.pay_month = ? AND sd.pay_year = ? ");

        if (deptId != null && deptId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ? OR LOWER(sd.description) LIKE ?) ");
        }
        sql.append("ORDER BY sd.amount DESC, e.employee_code ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            int idx = 3;
            if (deptId != null && deptId > 0) {
                ps.setInt(idx++, deptId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("SalaryDeductionDAO.findByPeriod error: " + e.getMessage());
        }
        return list;
    }

    public BigDecimal sumByEmployeeAndPeriod(int employeeId, int month, int year) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM salary_deductions "
                   + "WHERE employee_id = ? AND pay_month = ? AND pay_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("SalaryDeductionDAO.sumByEmployeeAndPeriod error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal sumAdvanceByPeriod(int month, int year) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM salary_deductions "
                   + "WHERE pay_month = ? AND pay_year = ? AND deduction_type = 'ADVANCE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("SalaryDeductionDAO.sumAdvanceByPeriod error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public int countAdvanceCases(int month, int year) {
        String sql = "SELECT COUNT(*) FROM salary_deductions WHERE pay_month = ? AND pay_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("SalaryDeductionDAO.countAdvanceCases error: " + e.getMessage());
        }
        return 0;
    }

    public boolean insert(SalaryDeduction d) {
        String sql = "INSERT INTO salary_deductions (employee_id, deduction_type, amount, pay_month, pay_year, description) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, d.getEmployeeId());
            ps.setString(2, d.getDeductionType());
            ps.setBigDecimal(3, d.getAmount());
            ps.setInt(4, d.getPayMonth());
            ps.setInt(5, d.getPayYear());
            ps.setString(6, d.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SalaryDeductionDAO.insert error: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM salary_deductions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SalaryDeductionDAO.delete error: " + e.getMessage());
        }
        return false;
    }

    private SalaryDeduction mapRow(ResultSet rs) throws SQLException {
        SalaryDeduction sd = new SalaryDeduction();
        sd.setId(rs.getInt("id"));
        sd.setEmployeeId(rs.getInt("employee_id"));
        sd.setEmployeeCode(rs.getString("employee_code"));
        sd.setEmployeeName(rs.getString("employee_name"));
        sd.setDepartmentName(rs.getString("department_name"));
        sd.setDeductionType(rs.getString("deduction_type"));
        sd.setAmount(rs.getBigDecimal("amount"));
        sd.setPayMonth(rs.getInt("pay_month"));
        sd.setPayYear(rs.getInt("pay_year"));
        sd.setDescription(rs.getString("description"));
        Timestamp ct = rs.getTimestamp("created_at");
        if (ct != null) sd.setCreatedAt(ct.toLocalDateTime());
        return sd;
    }
}
