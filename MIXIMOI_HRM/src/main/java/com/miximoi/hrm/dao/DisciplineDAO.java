package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Discipline;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object cho nghiệp vụ Kỷ luật & Vi phạm lao động.
 */
public class DisciplineDAO {

    public List<Discipline> findAll(String keyword, String dept, String severity, String status) {
        List<Discipline> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT d.id, d.violation_code, d.employee_id, e.full_name AS employee_name, e.employee_code, "
                + "dept.name AS department_name, d.violation_date, d.behavior, d.severity, d.decision_form, "
                + "d.handler_id, h.full_name AS handler_name, d.status, d.created_at "
                + "FROM disciplines d "
                + "JOIN employees e ON d.employee_id = e.id "
                + "LEFT JOIN departments dept ON e.department_id = dept.id "
                + "LEFT JOIN employees h ON d.handler_id = h.id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(d.violation_code) LIKE ? OR LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (dept != null && !dept.trim().isEmpty() && !"ALL".equalsIgnoreCase(dept)) {
            sql.append("AND (LOWER(dept.name) LIKE ? OR LOWER(dept.code) LIKE ?) ");
            String d = "%" + dept.trim().toLowerCase() + "%";
            params.add(d);
            params.add(d);
        }

        if (severity != null && !severity.trim().isEmpty() && !"ALL".equalsIgnoreCase(severity)) {
            sql.append("AND LOWER(d.severity) = LOWER(?) ");
            params.add(severity.trim());
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND LOWER(d.status) = LOWER(?) ");
            params.add(status.trim());
        }

        sql.append("ORDER BY d.violation_date DESC, d.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("DisciplineDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    public Discipline findById(int id) {
        String sql = "SELECT d.id, d.violation_code, d.employee_id, e.full_name AS employee_name, e.employee_code, "
                   + "dept.name AS department_name, d.violation_date, d.behavior, d.severity, d.decision_form, "
                   + "d.handler_id, h.full_name AS handler_name, d.status, d.created_at "
                   + "FROM disciplines d "
                   + "JOIN employees e ON d.employee_id = e.id "
                   + "LEFT JOIN departments dept ON e.department_id = dept.id "
                   + "LEFT JOIN employees h ON d.handler_id = h.id "
                   + "WHERE d.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("DisciplineDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    public List<Discipline> findByEmployeeId(int employeeId) {
        List<Discipline> list = new ArrayList<>();
        String sql = "SELECT d.id, d.violation_code, d.employee_id, e.full_name AS employee_name, e.employee_code, "
                + "dept.name AS department_name, d.violation_date, d.behavior, d.severity, d.decision_form, "
                + "d.handler_id, h.full_name AS handler_name, d.status, d.created_at "
                + "FROM disciplines d "
                + "JOIN employees e ON d.employee_id = e.id "
                + "LEFT JOIN departments dept ON e.department_id = dept.id "
                + "LEFT JOIN employees h ON d.handler_id = h.id "
                + "WHERE d.employee_id = ? ORDER BY d.violation_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("DisciplineDAO.findByEmployeeId error: " + e.getMessage());
        }
        return list;
    }

    public boolean insert(Discipline d) {
        String sql = "INSERT INTO disciplines (violation_code, employee_id, violation_date, behavior, severity, decision_form, handler_id, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, d.getViolationCode());
            ps.setInt(2, d.getEmployeeId());
            ps.setDate(3, Date.valueOf(d.getViolationDate() != null ? d.getViolationDate() : LocalDate.now()));
            ps.setString(4, d.getBehavior());
            ps.setString(5, d.getSeverity() != null ? d.getSeverity().toUpperCase() : "MEDIUM");
            ps.setString(6, d.getDecisionForm());
            if (d.getHandlerId() != null && d.getHandlerId() > 0) {
                ps.setInt(7, d.getHandlerId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setString(8, d.getStatus() != null ? d.getStatus().toUpperCase() : "INVESTIGATING");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DisciplineDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    public List<Discipline> findAll() {
        return findAll(null, null, null, null);
    }

    public boolean updateStatus(int id, String status, int step) {
        return updateStatus(id, status);
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE disciplines SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DisciplineDAO.updateStatus lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM disciplines WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DisciplineDAO.delete lỗi: " + e.getMessage());
        }
        return false;
    }

    public Map<String, Object> getStats() {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT "
                   + "COUNT(*) AS total_cases, "
                   + "COUNT(*) FILTER (WHERE LOWER(status) IN ('investigating', 'pending_verify')) AS investigating_cases, "
                   + "COUNT(*) FILTER (WHERE LOWER(status) IN ('pending', 'waiting_hearing')) AS pending_cases, "
                   + "COUNT(*) FILTER (WHERE LOWER(status) IN ('closed', 'resolved')) AS closed_cases "
                   + "FROM disciplines";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                int total = rs.getInt("total_cases");
                int inProg = rs.getInt("investigating_cases");
                int pending = rs.getInt("pending_cases");
                int closed = rs.getInt("closed_cases");

                stats.put("totalCases", total);
                stats.put("investigatingCases", inProg);
                stats.put("pendingCases", pending);
                stats.put("closedCases", closed);

                stats.put("total", total);
                stats.put("in_progress", inProg);
                stats.put("waiting_decision", pending);
                stats.put("resolved", closed);
            }
        } catch (SQLException e) {
            System.err.println("DisciplineDAO.getStats lỗi: " + e.getMessage());
            stats.put("totalCases", 0);
            stats.put("investigatingCases", 0);
            stats.put("pendingCases", 0);
            stats.put("closedCases", 0);
            stats.put("total", 0);
            stats.put("in_progress", 0);
            stats.put("waiting_decision", 0);
            stats.put("resolved", 0);
        }
        return stats;
    }

    public String getNextViolationCode() {
        String year = String.valueOf(LocalDate.now().getYear());
        String prefix = "KL-" + year + "-";
        String sql = "SELECT violation_code FROM disciplines WHERE violation_code LIKE ? ORDER BY violation_code DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String last = rs.getString(1);
                    int num = Integer.parseInt(last.substring(last.lastIndexOf('-') + 1));
                    return String.format("KL-%s-%03d", year, num + 1);
                }
            }
        } catch (Exception ignored) {}
        return String.format("KL-%s-001", year);
    }

    private Discipline mapRow(ResultSet rs) throws SQLException {
        Discipline d = new Discipline();
        d.setId(rs.getInt("id"));
        d.setViolationCode(rs.getString("violation_code"));
        d.setEmployeeId(rs.getInt("employee_id"));
        d.setEmployeeName(rs.getString("employee_name"));
        d.setEmployeeCode(rs.getString("employee_code"));
        d.setDepartmentName(rs.getString("department_name"));
        Date dDate = rs.getDate("violation_date");
        if (dDate != null) d.setViolationDate(dDate.toLocalDate());
        d.setBehavior(rs.getString("behavior"));
        d.setSeverity(rs.getString("severity"));
        d.setDecisionForm(rs.getString("decision_form"));
        int hId = rs.getInt("handler_id");
        if (!rs.wasNull()) d.setHandlerId(hId);
        d.setHandlerName(rs.getString("handler_name"));
        d.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) d.setCreatedAt(ts.toLocalDateTime());
        return d;
    }
}
