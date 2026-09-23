package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Payroll (Bảng lương).
 */
public class PayrollDAO {

    private static final String BASE_SELECT =
        "SELECT pr.id, pr.employee_id, e.employee_code, e.full_name, "
      + "d.name AS department_name, pos.name AS position_name, e.bank_account, e.bank_name, "
      + "pr.pay_month, pr.pay_year, pr.base_salary, pr.working_days, pr.standard_days, "
      + "pr.overtime_amount, pr.allowance, pr.bonus, pr.deduction, pr.net_salary, "
      + "pr.status, pr.created_by_id, pr.approved_by_id, "
      + "COALESCE(approver.full_name,'') AS approved_by_name, "
      + "pr.approved_at, pr.created_at, pr.updated_at "
      + "FROM payroll pr "
      + "JOIN employees e ON pr.employee_id = e.id "
      + "LEFT JOIN departments d ON e.department_id = d.id "
      + "LEFT JOIN positions pos ON e.position_id = pos.id "
      + "LEFT JOIN employees approver ON pr.approved_by_id = approver.id ";

    public List<Payroll> findByPeriod(int month, int year) {
        List<Payroll> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE pr.pay_month = ? AND pr.pay_year = ? "
                   + "ORDER BY e.employee_code";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.findByPeriod lỗi: " + e.getMessage());
        }
        return list;
    }

    public Payroll findById(int id) {
        String sql = BASE_SELECT + "WHERE pr.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    public Payroll findByEmployeeAndPeriod(int employeeId, int month, int year) {
        String sql = BASE_SELECT
                   + "WHERE pr.employee_id = ? AND pr.pay_month = ? AND pr.pay_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.findByEmployeeAndPeriod lỗi: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(Payroll pr) {
        String sql = "INSERT INTO payroll (employee_id, pay_month, pay_year, base_salary, "
                   + "working_days, standard_days, overtime_amount, allowance, bonus, "
                   + "deduction, net_salary, status, created_by_id) "
                   + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pr.getEmployeeId());
            ps.setInt(2, pr.getPayMonth());
            ps.setInt(3, pr.getPayYear());
            ps.setBigDecimal(4, pr.getBaseSalary());
            ps.setDouble(5, pr.getWorkingDays());
            ps.setDouble(6, pr.getStandardDays());
            ps.setBigDecimal(7, pr.getOvertimeAmount());
            ps.setBigDecimal(8, pr.getAllowance());
            ps.setBigDecimal(9, pr.getBonus());
            ps.setBigDecimal(10, pr.getDeduction());
            ps.setBigDecimal(11, pr.getNetSalary());
            ps.setString(12, "DRAFT");
            ps.setInt(13, pr.getCreatedById());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PayrollDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStatus(int id, String status, int approvedById) {
        String sql = "UPDATE payroll SET status=?, approved_by_id=?, "
                   + "approved_at=CURRENT_TIMESTAMP, updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, approvedById);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PayrollDAO.updateStatus lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Tổng quỹ lương tháng (dùng cho dashboard) */
    public java.math.BigDecimal sumNetSalaryByPeriod(int month, int year) {
        String sql = "SELECT COALESCE(SUM(net_salary), 0) FROM payroll "
                   + "WHERE pay_month = ? AND pay_year = ? AND status != 'DRAFT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.sumNetSalaryByPeriod lỗi: " + e.getMessage());
        }
        return java.math.BigDecimal.ZERO;
    }

    /** Đếm số bảng lương theo trạng thái trong kỳ */
    public int countByStatus(int month, int year, String status) {
        String sql = "SELECT COUNT(*) FROM payroll WHERE pay_month=? AND pay_year=? AND status=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setString(3, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.countByStatus lỗi: " + e.getMessage());
        }
        return 0;
    }

    /** Lương thực lĩnh trung bình trong kỳ */
    public java.math.BigDecimal avgNetSalaryByPeriod(int month, int year) {
        String sql = "SELECT COALESCE(AVG(net_salary), 0) FROM payroll WHERE pay_month=? AND pay_year=? AND status != 'DRAFT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.avgNetSalaryByPeriod lỗi: " + e.getMessage());
        }
        return java.math.BigDecimal.ZERO;
    }

    /** Tổng số nhân viên có bảng lương trong kỳ */
    public int countEmployeesByPeriod(int month, int year) {
        String sql = "SELECT COUNT(DISTINCT employee_id) FROM payroll WHERE pay_month=? AND pay_year=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.countEmployeesByPeriod lỗi: " + e.getMessage());
        }
        return 0;
    }

    public List<Payroll> search(int month, int year, Integer deptId, String status, String keyword, int offset, int limit) {
        List<Payroll> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE pr.pay_month = ? AND pr.pay_year = ? ");

        if (deptId != null && deptId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND pr.status = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
        }
        sql.append("ORDER BY e.employee_code ASC ");
        if (limit > 0) {
            sql.append("OFFSET ? LIMIT ?");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, month);
            ps.setInt(idx++, year);
            if (deptId != null && deptId > 0) {
                ps.setInt(idx++, deptId);
            }
            if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
                ps.setString(idx++, status.trim());
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (limit > 0) {
                ps.setInt(idx++, offset);
                ps.setInt(idx++, limit);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.search error: " + e.getMessage());
        }
        return list;
    }

    public int countSearch(int month, int year, Integer deptId, String status, String keyword) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM payroll pr "
          + "JOIN employees e ON pr.employee_id = e.id "
          + "WHERE pr.pay_month = ? AND pr.pay_year = ? ");

        if (deptId != null && deptId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND pr.status = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, month);
            ps.setInt(idx++, year);
            if (deptId != null && deptId > 0) {
                ps.setInt(idx++, deptId);
            }
            if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
                ps.setString(idx++, status.trim());
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("PayrollDAO.countSearch error: " + e.getMessage());
        }
        return 0;
    }

    public boolean deleteByPeriod(int month, int year) {
        String sql = "DELETE FROM payroll WHERE pay_month = ? AND pay_year = ? AND status = 'DRAFT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            System.err.println("PayrollDAO.deleteByPeriod error: " + e.getMessage());
        }
        return false;
    }

    private Payroll mapRow(ResultSet rs) throws SQLException {
        Payroll pr = new Payroll();
        pr.setId(rs.getInt("id"));
        pr.setEmployeeId(rs.getInt("employee_id"));
        pr.setEmployeeCode(rs.getString("employee_code"));
        pr.setEmployeeName(rs.getString("full_name"));
        pr.setDepartmentName(rs.getString("department_name"));
        try {
            pr.setPositionName(rs.getString("position_name"));
            pr.setBankAccount(rs.getString("bank_account"));
            pr.setBankName(rs.getString("bank_name"));
        } catch (SQLException ignored) {}
        pr.setPayMonth(rs.getInt("pay_month"));
        pr.setPayYear(rs.getInt("pay_year"));
        pr.setBaseSalary(rs.getBigDecimal("base_salary"));
        pr.setWorkingDays(rs.getDouble("working_days"));
        pr.setStandardDays(rs.getDouble("standard_days"));
        pr.setOvertimeAmount(rs.getBigDecimal("overtime_amount"));
        pr.setAllowance(rs.getBigDecimal("allowance"));
        pr.setBonus(rs.getBigDecimal("bonus"));
        pr.setDeduction(rs.getBigDecimal("deduction"));
        pr.setNetSalary(rs.getBigDecimal("net_salary"));
        pr.setStatus(rs.getString("status"));
        pr.setCreatedById(rs.getInt("created_by_id"));
        pr.setApprovedById(rs.getInt("approved_by_id"));
        pr.setApprovedByName(rs.getString("approved_by_name"));
        Timestamp at = rs.getTimestamp("approved_at");
        if (at != null) pr.setApprovedAt(at.toLocalDateTime());
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) pr.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) pr.setUpdatedAt(ua.toLocalDateTime());
        return pr;
    }
}
