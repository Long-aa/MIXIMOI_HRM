package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Allowance;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AllowanceDAO {

    private static final String BASE_SELECT =
        "SELECT a.id, a.employee_id, e.employee_code, e.full_name AS employee_name, "
      + "d.name AS department_name, a.name, a.amount, a.start_date, a.end_date, a.active, a.created_at "
      + "FROM allowances a "
      + "JOIN employees e ON a.employee_id = e.id "
      + "LEFT JOIN departments d ON e.department_id = d.id ";

    public List<Allowance> findByPeriod(int month, int year, Integer deptId, String keyword) {
        List<Allowance> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE a.active = TRUE ");

        if (deptId != null && deptId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ? OR LOWER(a.name) LIKE ?) ");
        }
        sql.append("ORDER BY a.amount DESC, e.employee_code ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
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
            System.err.println("AllowanceDAO.findByPeriod error: " + e.getMessage());
        }
        return list;
    }

    public List<Allowance> findActiveByEmployee(int employeeId) {
        List<Allowance> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE a.employee_id = ? AND a.active = TRUE ORDER BY a.amount DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.findActiveByEmployee error: " + e.getMessage());
        }
        return list;
    }

    public BigDecimal sumActiveByEmployee(int employeeId) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM allowances WHERE employee_id = ? AND active = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.sumActiveByEmployee error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    /**
     * Tổng phụ cấp active của nhân viên trong kỳ tháng/năm cụ thể.
     * Điều kiện: start_date <= ngày cuối tháng VÀ (end_date IS NULL hoặc end_date >= ngày đầu tháng).
     */
    public BigDecimal sumActiveByEmployee(int employeeId, int month, int year) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM allowances "
                   + "WHERE employee_id = ? AND active = TRUE "
                   + "AND start_date <= CAST(? AS DATE) "
                   + "AND (end_date IS NULL OR end_date >= CAST(? AS DATE))";
        // Ngày đầu tháng và ngày cuối tháng
        java.time.LocalDate firstDay = java.time.YearMonth.of(year, month).atDay(1);
        java.time.LocalDate lastDay  = java.time.YearMonth.of(year, month).atEndOfMonth();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, java.sql.Date.valueOf(lastDay));
            ps.setDate(3, java.sql.Date.valueOf(firstDay));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.sumActiveByEmployee(month,year) error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal sumTotalAmount() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM allowances WHERE active = TRUE";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.sumTotalAmount error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public int countBenefitedEmployees() {
        String sql = "SELECT COUNT(DISTINCT employee_id) FROM allowances WHERE active = TRUE";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.countBenefitedEmployees error: " + e.getMessage());
        }
        return 0;
    }

    public int countTypes() {
        String sql = "SELECT COUNT(DISTINCT name) FROM allowances WHERE active = TRUE";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.countTypes error: " + e.getMessage());
        }
        return 0;
    }

    public boolean insert(Allowance a) {
        String sql = "INSERT INTO allowances (employee_id, name, amount, start_date, end_date, active) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, a.getEmployeeId());
            ps.setString(2, a.getName());
            ps.setBigDecimal(3, a.getAmount());
            ps.setDate(4, a.getStartDate() != null ? Date.valueOf(a.getStartDate()) : Date.valueOf(java.time.LocalDate.now()));
            ps.setDate(5, a.getEndDate() != null ? Date.valueOf(a.getEndDate()) : null);
            ps.setBoolean(6, a.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.insert error: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Allowance a) {
        String sql = "UPDATE allowances SET name = ?, amount = ?, start_date = ?, end_date = ?, active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getName());
            ps.setBigDecimal(2, a.getAmount());
            ps.setDate(3, a.getStartDate() != null ? Date.valueOf(a.getStartDate()) : null);
            ps.setDate(4, a.getEndDate() != null ? Date.valueOf(a.getEndDate()) : null);
            ps.setBoolean(5, a.isActive());
            ps.setInt(6, a.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.update error: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM allowances WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.delete error: " + e.getMessage());
        }
        return false;
    }

    public boolean toggleActive(int id) {
        String sql = "UPDATE allowances SET active = NOT active WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AllowanceDAO.toggleActive error: " + e.getMessage());
        }
        return false;
    }

    private Allowance mapRow(ResultSet rs) throws SQLException {
        Allowance a = new Allowance();
        a.setId(rs.getInt("id"));
        a.setEmployeeId(rs.getInt("employee_id"));
        a.setEmployeeCode(rs.getString("employee_code"));
        a.setEmployeeName(rs.getString("employee_name"));
        a.setDepartmentName(rs.getString("department_name"));
        a.setName(rs.getString("name"));
        a.setAmount(rs.getBigDecimal("amount"));
        Date sd = rs.getDate("start_date");
        if (sd != null) a.setStartDate(sd.toLocalDate());
        Date ed = rs.getDate("end_date");
        if (ed != null) a.setEndDate(ed.toLocalDate());
        a.setActive(rs.getBoolean("active"));
        Timestamp ct = rs.getTimestamp("created_at");
        if (ct != null) a.setCreatedAt(ct.toLocalDateTime());
        return a;
    }
}
