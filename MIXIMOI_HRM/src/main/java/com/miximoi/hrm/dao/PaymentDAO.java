package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Payment;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    private static final String BASE_SELECT =
        "SELECT p.id, p.payroll_id, p.employee_id, e.employee_code, e.full_name AS employee_name, "
      + "d.name AS department_name, pos.name AS position_name, e.bank_account, e.bank_name, "
      + "p.amount, p.payment_date, p.payment_method, p.status, p.notes, p.created_at "
      + "FROM payments p "
      + "JOIN employees e ON p.employee_id = e.id "
      + "LEFT JOIN departments d ON e.department_id = d.id "
      + "LEFT JOIN positions pos ON e.position_id = pos.id "
      + "JOIN payroll pr ON p.payroll_id = pr.id ";

    public List<Payment> findByPeriod(int month, int year) {
        List<Payment> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE pr.pay_month = ? AND pr.pay_year = ? ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("PaymentDAO.findByPeriod error: " + e.getMessage());
        }
        return list;
    }

    public BigDecimal sumDisbursedByPeriod(int month, int year) {
        String sql = "SELECT COALESCE(SUM(p.amount), 0) FROM payments p "
                   + "JOIN payroll pr ON p.payroll_id = pr.id "
                   + "WHERE pr.pay_month = ? AND pr.pay_year = ? AND p.status = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("PaymentDAO.sumDisbursedByPeriod error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public boolean insert(Payment p) {
        String sql = "INSERT INTO payments (payroll_id, employee_id, amount, payment_date, payment_method, status, notes) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getPayrollId());
            ps.setInt(2, p.getEmployeeId());
            ps.setBigDecimal(3, p.getAmount());
            ps.setDate(4, p.getPaymentDate() != null ? Date.valueOf(p.getPaymentDate()) : Date.valueOf(java.time.LocalDate.now()));
            ps.setString(5, p.getPaymentMethod() != null ? p.getPaymentMethod() : "BANK_TRANSFER");
            ps.setString(6, p.getStatus() != null ? p.getStatus() : "COMPLETED");
            ps.setString(7, p.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PaymentDAO.insert error: " + e.getMessage());
        }
        return false;
    }

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setPayrollId(rs.getInt("payroll_id"));
        p.setEmployeeId(rs.getInt("employee_id"));
        p.setEmployeeCode(rs.getString("employee_code"));
        p.setEmployeeName(rs.getString("employee_name"));
        p.setDepartmentName(rs.getString("department_name"));
        p.setPositionName(rs.getString("position_name"));
        p.setBankAccount(rs.getString("bank_account"));
        p.setBankName(rs.getString("bank_name"));
        p.setAmount(rs.getBigDecimal("amount"));
        Date pd = rs.getDate("payment_date");
        if (pd != null) p.setPaymentDate(pd.toLocalDate());
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setStatus(rs.getString("status"));
        p.setNotes(rs.getString("notes"));
        Timestamp ct = rs.getTimestamp("created_at");
        if (ct != null) p.setCreatedAt(ct.toLocalDateTime());
        return p;
    }
}
