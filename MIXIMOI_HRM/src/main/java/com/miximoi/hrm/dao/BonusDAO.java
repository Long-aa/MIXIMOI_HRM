package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Bonus;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class BonusDAO {

    private static final String BASE_SELECT =
        "SELECT b.id, b.employee_id, e.employee_code, e.full_name AS employee_name, "
      + "d.name AS department_name, b.name, b.amount, b.bonus_date, b.pay_month, b.pay_year, b.notes, b.created_at "
      + "FROM bonuses b "
      + "JOIN employees e ON b.employee_id = e.id "
      + "LEFT JOIN departments d ON e.department_id = d.id ";

    public List<Bonus> findByPeriod(int month, int year, Integer deptId, String keyword) {
        List<Bonus> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE (b.pay_month = ? AND b.pay_year = ?) ");

        if (deptId != null && deptId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ? OR LOWER(b.name) LIKE ?) ");
        }
        sql.append("ORDER BY b.amount DESC, b.bonus_date DESC");

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
            System.err.println("BonusDAO.findByPeriod error: " + e.getMessage());
        }
        return list;
    }

    public BigDecimal sumByEmployeeAndPeriod(int employeeId, int month, int year) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM bonuses "
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
            System.err.println("BonusDAO.sumByEmployeeAndPeriod error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal sumTotalByPeriod(int month, int year) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM bonuses WHERE pay_month = ? AND pay_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("BonusDAO.sumTotalByPeriod error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal sumTotalYear(int year) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM bonuses WHERE pay_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("BonusDAO.sumTotalYear error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public int countBonusEmployees(int month, int year) {
        String sql = "SELECT COUNT(DISTINCT employee_id) FROM bonuses WHERE pay_month = ? AND pay_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("BonusDAO.countBonusEmployees error: " + e.getMessage());
        }
        return 0;
    }

    /** Lấy phân bổ thưởng theo phòng ban phục vụ Donut Chart */
    public Map<String, BigDecimal> getBonusDistributionByDepartment(int month, int year) {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT COALESCE(d.name, 'Chưa xếp phòng') AS dept_name, SUM(b.amount) AS total "
                   + "FROM bonuses b "
                   + "JOIN employees e ON b.employee_id = e.id "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "WHERE b.pay_month = ? AND b.pay_year = ? "
                   + "GROUP BY d.name ORDER BY total DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("dept_name"), rs.getBigDecimal("total"));
                }
            }
        } catch (SQLException e) {
            System.err.println("BonusDAO.getBonusDistributionByDepartment error: " + e.getMessage());
        }
        return map;
    }

    public boolean insert(Bonus b) {
        String sql = "INSERT INTO bonuses (employee_id, name, amount, bonus_date, pay_month, pay_year, notes) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, b.getEmployeeId());
            ps.setString(2, b.getName());
            ps.setBigDecimal(3, b.getAmount());
            ps.setDate(4, b.getBonusDate() != null ? Date.valueOf(b.getBonusDate()) : Date.valueOf(java.time.LocalDate.now()));
            ps.setInt(5, b.getPayMonth());
            ps.setInt(6, b.getPayYear());
            ps.setString(7, b.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BonusDAO.insert error: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM bonuses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BonusDAO.delete error: " + e.getMessage());
        }
        return false;
    }

    private Bonus mapRow(ResultSet rs) throws SQLException {
        Bonus b = new Bonus();
        b.setId(rs.getInt("id"));
        b.setEmployeeId(rs.getInt("employee_id"));
        b.setEmployeeCode(rs.getString("employee_code"));
        b.setEmployeeName(rs.getString("employee_name"));
        b.setDepartmentName(rs.getString("department_name"));
        b.setName(rs.getString("name"));
        b.setAmount(rs.getBigDecimal("amount"));
        Date bd = rs.getDate("bonus_date");
        if (bd != null) b.setBonusDate(bd.toLocalDate());
        b.setPayMonth(rs.getInt("pay_month"));
        b.setPayYear(rs.getInt("pay_year"));
        b.setNotes(rs.getString("notes"));
        Timestamp ct = rs.getTimestamp("created_at");
        if (ct != null) b.setCreatedAt(ct.toLocalDateTime());
        return b;
    }
}
