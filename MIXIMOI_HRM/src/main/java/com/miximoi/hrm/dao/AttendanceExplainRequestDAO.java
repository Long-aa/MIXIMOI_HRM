package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.AttendanceExplainRequest;
import com.miximoi.hrm.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các yêu cầu giải trình chấm công (attendance_explain_requests).
 * Tối ưu truy vấn countPending O(1) bằng index trên status, thay thế ILIKE toàn bảng.
 */
public class AttendanceExplainRequestDAO {

    public boolean upsert(AttendanceExplainRequest req) {
        String sql = "INSERT INTO attendance_explain_requests "
                   + "(attendance_id, employee_id, reason, status, created_at) "
                   + "VALUES (?, ?, ?, 'PENDING', CURRENT_TIMESTAMP) "
                   + "ON CONFLICT (attendance_id) DO UPDATE SET "
                   + "reason = EXCLUDED.reason, status = 'PENDING', reviewed_by = NULL, reviewed_at = NULL, created_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, req.getAttendanceId());
            ps.setInt(2, req.getEmployeeId());
            ps.setString(3, req.getReason());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceExplainRequestDAO.upsert error: " + e.getMessage());
        }
        return false;
    }

    public boolean review(int attendanceId, String status, Integer reviewedBy) {
        String sql = "UPDATE attendance_explain_requests SET status = ?, reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP WHERE attendance_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            if (reviewedBy != null && reviewedBy > 0) {
                ps.setInt(2, reviewedBy);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setInt(3, attendanceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceExplainRequestDAO.review error: " + e.getMessage());
        }
        return false;
    }

    public int countPending(Integer departmentId) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM attendance_explain_requests r "
          + "JOIN employees e ON r.employee_id = e.id "
          + "WHERE r.status = 'PENDING' "
        );
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (departmentId != null && departmentId > 0) {
                ps.setInt(1, departmentId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("AttendanceExplainRequestDAO.countPending error: " + e.getMessage());
        }
        return 0;
    }

    public AttendanceExplainRequest findByAttendanceId(int attendanceId) {
        String sql = "SELECT r.*, e.employee_code, e.full_name as employee_name, u.username as reviewer_name "
                   + "FROM attendance_explain_requests r "
                   + "JOIN employees e ON r.employee_id = e.id "
                   + "LEFT JOIN users u ON r.reviewed_by = u.id "
                   + "WHERE r.attendance_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attendanceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("AttendanceExplainRequestDAO.findByAttendanceId error: " + e.getMessage());
        }
        return null;
    }

    public List<AttendanceExplainRequest> findPending(Integer departmentId) {
        List<AttendanceExplainRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, e.employee_code, e.full_name as employee_name, u.username as reviewer_name "
          + "FROM attendance_explain_requests r "
          + "JOIN employees e ON r.employee_id = e.id "
          + "LEFT JOIN users u ON r.reviewed_by = u.id "
          + "WHERE r.status = 'PENDING' "
        );
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        sql.append("ORDER BY r.created_at DESC");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (departmentId != null && departmentId > 0) {
                ps.setInt(1, departmentId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("AttendanceExplainRequestDAO.findPending error: " + e.getMessage());
        }
        return list;
    }

    private AttendanceExplainRequest mapRow(ResultSet rs) throws SQLException {
        AttendanceExplainRequest req = new AttendanceExplainRequest();
        req.setId(rs.getInt("id"));
        req.setAttendanceId(rs.getInt("attendance_id"));
        req.setEmployeeId(rs.getInt("employee_id"));
        req.setEmployeeCode(rs.getString("employee_code"));
        req.setEmployeeName(rs.getString("employee_name"));
        req.setReason(rs.getString("reason"));
        req.setStatus(rs.getString("status"));
        int rev = rs.getInt("reviewed_by");
        if (!rs.wasNull()) req.setReviewedBy(rev);
        req.setReviewerName(rs.getString("reviewer_name"));
        Timestamp rAt = rs.getTimestamp("reviewed_at");
        if (rAt != null) req.setReviewedAt(rAt.toLocalDateTime());
        Timestamp cAt = rs.getTimestamp("created_at");
        if (cAt != null) req.setCreatedAt(cAt.toLocalDateTime());
        return req;
    }
}
