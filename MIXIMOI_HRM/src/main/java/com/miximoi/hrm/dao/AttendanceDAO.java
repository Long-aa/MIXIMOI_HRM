package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Attendance (Chấm công).
 */
public class AttendanceDAO {

    private static final String BASE_SELECT =
        "SELECT a.id, a.employee_id, e.employee_code, e.full_name, "
      + "a.work_date, a.check_in, a.check_out, a.total_hours, a.status, a.notes, a.created_at "
      + "FROM attendance a JOIN employees e ON a.employee_id = e.id ";

    /** Lấy chấm công theo nhân viên và tháng */
    public List<Attendance> findByEmployeeAndMonth(int employeeId, int month, int year) {
        List<Attendance> list = new ArrayList<>();
        String sql = BASE_SELECT
                   + "WHERE a.employee_id = ? "
                   + "AND EXTRACT(MONTH FROM a.work_date) = ? "
                   + "AND EXTRACT(YEAR FROM a.work_date) = ? "
                   + "ORDER BY a.work_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.findByEmployeeAndMonth lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Lấy chấm công của một ngày cụ thể */
    public Attendance findByEmployeeAndDate(int employeeId, LocalDate date) {
        String sql = BASE_SELECT + "WHERE a.employee_id = ? AND a.work_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.findByEmployeeAndDate lỗi: " + e.getMessage());
        }
        return null;
    }

    /** Lấy tất cả chấm công theo tháng (bảng công tháng) */
    public List<Attendance> findByMonth(int month, int year) {
        List<Attendance> list = new ArrayList<>();
        String sql = BASE_SELECT
                   + "WHERE EXTRACT(MONTH FROM a.work_date) = ? "
                   + "AND EXTRACT(YEAR FROM a.work_date) = ? "
                   + "ORDER BY e.employee_code, a.work_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.findByMonth lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Thêm bản ghi chấm công */
    public boolean insert(Attendance att) {
        String sql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, "
                   + "total_hours, status, notes) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, att.getEmployeeId());
            ps.setDate(2, Date.valueOf(att.getWorkDate()));
            ps.setTime(3, att.getCheckIn() != null ? Time.valueOf(att.getCheckIn()) : null);
            ps.setTime(4, att.getCheckOut() != null ? Time.valueOf(att.getCheckOut()) : null);
            ps.setDouble(5, att.getTotalHours());
            ps.setString(6, att.getStatus());
            ps.setString(7, att.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Cập nhật giờ ra + tổng giờ + trạng thái */
    public boolean update(Attendance att) {
        String sql = "UPDATE attendance SET check_in=?, check_out=?, total_hours=?, "
                   + "status=?, notes=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTime(1, att.getCheckIn() != null ? Time.valueOf(att.getCheckIn()) : null);
            ps.setTime(2, att.getCheckOut() != null ? Time.valueOf(att.getCheckOut()) : null);
            ps.setDouble(3, att.getTotalHours());
            ps.setString(4, att.getStatus());
            ps.setString(5, att.getNotes());
            ps.setInt(6, att.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.update lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Đếm ngày công thực tế của nhân viên trong tháng */
    public double countWorkingDays(int employeeId, int month, int year) {
        String sql = "SELECT COALESCE(SUM(total_hours), 0) / 8.0 FROM attendance "
                   + "WHERE employee_id = ? AND status != 'ABSENT' "
                   + "AND EXTRACT(MONTH FROM work_date) = ? "
                   + "AND EXTRACT(YEAR FROM work_date) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.countWorkingDays lỗi: " + e.getMessage());
        }
        return 0;
    }

    private Attendance mapRow(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setId(rs.getInt("id"));
        a.setEmployeeId(rs.getInt("employee_id"));
        a.setEmployeeCode(rs.getString("employee_code"));
        a.setEmployeeName(rs.getString("full_name"));
        Date wd = rs.getDate("work_date");
        if (wd != null) a.setWorkDate(wd.toLocalDate());
        Time ci = rs.getTime("check_in");
        if (ci != null) a.setCheckIn(ci.toLocalTime());
        Time co = rs.getTime("check_out");
        if (co != null) a.setCheckOut(co.toLocalTime());
        a.setTotalHours(rs.getDouble("total_hours"));
        a.setStatus(rs.getString("status"));
        a.setNotes(rs.getString("notes"));
        Timestamp cat = rs.getTimestamp("created_at");
        if (cat != null) a.setCreatedAt(cat.toLocalDateTime());
        return a;
    }
}
