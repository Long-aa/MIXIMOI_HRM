package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Overtime;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Overtime (Tăng ca).
 */
public class OvertimeDAO {

    private static final String BASE_SELECT =
        "SELECT ot.id, ot.employee_id, e.employee_code, e.full_name, "
      + "ot.overtime_date, ot.hours, ot.coefficient, ot.amount, ot.reason, "
      + "ot.status, ot.approved_by_id, "
      + "COALESCE(approver.full_name, '') AS approved_by_name, "
      + "ot.approved_at, ot.created_at "
      + "FROM overtime ot "
      + "JOIN employees e ON ot.employee_id = e.id "
      + "LEFT JOIN employees approver ON ot.approved_by_id = approver.id ";

    public List<Overtime> findAll() {
        List<Overtime> list = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY ot.overtime_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    public List<Overtime> findByEmployeeAndMonth(int employeeId, int month, int year) {
        List<Overtime> list = new ArrayList<>();
        String sql = BASE_SELECT
                   + "WHERE ot.employee_id = ? AND ot.status = 'APPROVED' "
                   + "AND EXTRACT(MONTH FROM ot.overtime_date) = ? "
                   + "AND EXTRACT(YEAR FROM ot.overtime_date) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.findByEmployeeAndMonth lỗi: " + e.getMessage());
        }
        return list;
    }

    public Overtime findById(int id) {
        String sql = BASE_SELECT + "WHERE ot.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(Overtime ot) {
        String sql = "INSERT INTO overtime (employee_id, overtime_date, hours, coefficient, "
                   + "amount, reason, status) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ot.getEmployeeId());
            ps.setDate(2, Date.valueOf(ot.getOvertimeDate()));
            ps.setDouble(3, ot.getHours());
            ps.setDouble(4, ot.getCoefficient());
            ps.setBigDecimal(5, ot.getAmount());
            ps.setString(6, ot.getReason());
            ps.setString(7, "PENDING");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean approve(int id, int approvedById) {
        String sql = "UPDATE overtime SET status='APPROVED', approved_by_id=?, "
                   + "approved_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, approvedById);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.approve lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean reject(int id, int rejectedById) {
        String sql = "UPDATE overtime SET status='REJECTED', approved_by_id=?, "
                   + "approved_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rejectedById);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.reject lỗi: " + e.getMessage());
        }
        return false;
    }

    private Overtime mapRow(ResultSet rs) throws SQLException {
        Overtime ot = new Overtime();
        ot.setId(rs.getInt("id"));
        ot.setEmployeeId(rs.getInt("employee_id"));
        ot.setEmployeeCode(rs.getString("employee_code"));
        ot.setEmployeeName(rs.getString("full_name"));
        Date d = rs.getDate("overtime_date");
        if (d != null) ot.setOvertimeDate(d.toLocalDate());
        ot.setHours(rs.getDouble("hours"));
        ot.setCoefficient(rs.getDouble("coefficient"));
        ot.setAmount(rs.getBigDecimal("amount"));
        ot.setReason(rs.getString("reason"));
        ot.setStatus(rs.getString("status"));
        ot.setApprovedById(rs.getInt("approved_by_id"));
        ot.setApprovedByName(rs.getString("approved_by_name"));
        Timestamp at = rs.getTimestamp("approved_at");
        if (at != null) ot.setApprovedAt(at.toLocalDateTime());
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) ot.setCreatedAt(ca.toLocalDateTime());
        return ot;
    }
}
