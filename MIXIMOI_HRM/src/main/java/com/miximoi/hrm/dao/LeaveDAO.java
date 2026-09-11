package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến LeaveRequest (Nghỉ phép).
 */
public class LeaveDAO {

    private static final String BASE_SELECT =
        "SELECT lr.id, lr.leave_code, lr.employee_id, e.employee_code, e.full_name, "
      + "lr.leave_type, lr.start_date, lr.end_date, lr.total_days, lr.reason, "
      + "lr.status, lr.approved_by_id, "
      + "COALESCE(approver.full_name, '') AS approved_by_name, "
      + "lr.approved_at, lr.reject_reason, lr.created_at, lr.updated_at "
      + "FROM leave_requests lr "
      + "JOIN employees e ON lr.employee_id = e.id "
      + "LEFT JOIN employees approver ON lr.approved_by_id = approver.id ";

    public List<LeaveRequest> findAll() {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY lr.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    public List<LeaveRequest> findByEmployeeId(int employeeId) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE lr.employee_id = ? ORDER BY lr.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findByEmployeeId lỗi: " + e.getMessage());
        }
        return list;
    }

    public List<LeaveRequest> findByStatus(String status) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE lr.status = ? ORDER BY lr.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findByStatus lỗi: " + e.getMessage());
        }
        return list;
    }

    public LeaveRequest findById(int id) {
        String sql = BASE_SELECT + "WHERE lr.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(LeaveRequest lr) {
        String sql = "INSERT INTO leave_requests (leave_code, employee_id, leave_type, "
                   + "start_date, end_date, total_days, reason, status) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lr.getLeaveCode());
            ps.setInt(2, lr.getEmployeeId());
            ps.setString(3, lr.getLeaveType());
            ps.setDate(4, Date.valueOf(lr.getStartDate()));
            ps.setDate(5, Date.valueOf(lr.getEndDate()));
            ps.setInt(6, lr.getTotalDays());
            ps.setString(7, lr.getReason());
            ps.setString(8, "PENDING");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Phê duyệt đơn nghỉ phép */
    public boolean approve(int id, int approvedById) {
        String sql = "UPDATE leave_requests SET status='APPROVED', approved_by_id=?, "
                   + "approved_at=CURRENT_TIMESTAMP, updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, approvedById);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.approve lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Từ chối đơn nghỉ phép */
    public boolean reject(int id, int rejectedById, String reason) {
        String sql = "UPDATE leave_requests SET status='REJECTED', approved_by_id=?, "
                   + "reject_reason=?, approved_at=CURRENT_TIMESTAMP, "
                   + "updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rejectedById);
            ps.setString(2, reason);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.reject lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Đếm đơn đang chờ duyệt (dùng cho dashboard) */
    public int countPending() {
        String sql = "SELECT COUNT(*) FROM leave_requests WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("LeaveDAO.countPending lỗi: " + e.getMessage());
        }
        return 0;
    }

    private LeaveRequest mapRow(ResultSet rs) throws SQLException {
        LeaveRequest lr = new LeaveRequest();
        lr.setId(rs.getInt("id"));
        lr.setLeaveCode(rs.getString("leave_code"));
        lr.setEmployeeId(rs.getInt("employee_id"));
        lr.setEmployeeCode(rs.getString("employee_code"));
        lr.setEmployeeName(rs.getString("full_name"));
        lr.setLeaveType(rs.getString("leave_type"));
        Date sd = rs.getDate("start_date");
        if (sd != null) lr.setStartDate(sd.toLocalDate());
        Date ed = rs.getDate("end_date");
        if (ed != null) lr.setEndDate(ed.toLocalDate());
        lr.setTotalDays(rs.getInt("total_days"));
        lr.setReason(rs.getString("reason"));
        lr.setStatus(rs.getString("status"));
        lr.setApprovedById(rs.getInt("approved_by_id"));
        lr.setApprovedByName(rs.getString("approved_by_name"));
        Timestamp approvedAt = rs.getTimestamp("approved_at");
        if (approvedAt != null) lr.setApprovedAt(approvedAt.toLocalDateTime());
        lr.setRejectReason(rs.getString("reject_reason"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) lr.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) lr.setUpdatedAt(ua.toLocalDateTime());
        return lr;
    }
}
