package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.model.TimesheetSummary;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * DAO xử lý các thao tác DB liên quan đến Attendance (Chấm công).
 */
public class AttendanceDAO {

    private static final String BASE_SELECT =
        "SELECT a.id, a.employee_id, e.employee_code, e.full_name, "
      + "d.name AS department_name, p.name AS position_name, "
      + "a.work_date, a.check_in, a.check_out, a.total_hours, a.status, a.notes, a.method, a.created_at "
      + "FROM attendance a "
      + "JOIN employees e ON a.employee_id = e.id "
      + "LEFT JOIN departments d ON e.department_id = d.id "
      + "LEFT JOIN positions p ON e.position_id = p.id ";

    /** Lấy chấm công theo nhân viên và tháng */
    public List<Attendance> findByEmployeeAndMonth(int employeeId, int month, int year) {
        List<Attendance> list = new ArrayList<>();
        String sql = BASE_SELECT
                   + "WHERE a.employee_id = ? "
                   + "AND EXTRACT(MONTH FROM a.work_date) = ? "
                   + "AND EXTRACT(YEAR FROM a.work_date) = ? "
                   + "ORDER BY a.work_date DESC";
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

    /** Tìm theo ID */
    public Attendance findById(int id) {
        String sql = BASE_SELECT + "WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    /** Tìm kiếm chấm công theo nhiều tiêu chí */
    public List<Attendance> search(String keyword, Integer departmentId, String status, LocalDate date, Integer month, Integer year) {
        List<Attendance> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
        }
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND a.status = ? ");
        }
        if (date != null) {
            sql.append("AND a.work_date = ? ");
        } else {
            if (month != null && month > 0) {
                sql.append("AND EXTRACT(MONTH FROM a.work_date) = ? ");
            }
            if (year != null && year > 0) {
                sql.append("AND EXTRACT(YEAR FROM a.work_date) = ? ");
            }
        }
        sql.append("ORDER BY a.work_date DESC, e.employee_code ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (departmentId != null && departmentId > 0) {
                ps.setInt(idx++, departmentId);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status.trim());
            }
            if (date != null) {
                ps.setDate(idx++, Date.valueOf(date));
            } else {
                if (month != null && month > 0) {
                    ps.setInt(idx++, month);
                }
                if (year != null && year > 0) {
                    ps.setInt(idx++, year);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.search lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Lấy thống kê chấm công hôm nay */
    public Map<String, Integer> getTodayStats(LocalDate date) {
        Map<String, Integer> map = new HashMap<>();
        map.put("totalEmployeesToday", 0);
        map.put("checkedInCount", 0);
        map.put("lateEarlyCount", 0);
        map.put("absentCount", 0);
        map.put("wfhCount", 0);

        // Tổng nhân viên active
        String totalSql = "SELECT COUNT(*) FROM employees WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(totalSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) map.put("totalEmployeesToday", rs.getInt(1));
        } catch (SQLException ignored) {}

        // Thống kê theo trạng thái trong ngày
        String attSql = "SELECT status, COUNT(*) FROM attendance WHERE work_date = ? GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(attSql)) {
            ps.setDate(1, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                int checkedIn = 0;
                int lateEarly = 0;
                int absent = 0;
                int wfh = 0;
                while (rs.next()) {
                    String st = rs.getString(1);
                    int cnt = rs.getInt(2);
                    if ("ON_TIME".equalsIgnoreCase(st) || "COMPLETE".equalsIgnoreCase(st) || "WORKING".equalsIgnoreCase(st)) {
                        checkedIn += cnt;
                    } else if ("LATE".equalsIgnoreCase(st) || "EARLY_LEAVE".equalsIgnoreCase(st)) {
                        checkedIn += cnt;
                        lateEarly += cnt;
                    } else if ("ABSENT".equalsIgnoreCase(st)) {
                        absent += cnt;
                    } else if ("WFH".equalsIgnoreCase(st)) {
                        checkedIn += cnt;
                        wfh += cnt;
                    }
                }
                map.put("checkedInCount", checkedIn);
                map.put("lateEarlyCount", lateEarly);
                map.put("absentCount", absent);
                map.put("wfhCount", wfh);
            }
        } catch (SQLException ignored) {}

        return map;
    }

    /**
     * Tự động nạp dữ liệu chấm công hôm nay nếu bảng attendance chưa có bản ghi cho ngày này.
     * Tạo dữ liệu đa dạng: đúng giờ (FaceID/Vân tay), đi muộn, WFH (GPS), nghỉ phép, vắng mặt.
     */
    public void autoSeedTodayData(LocalDate today) {
        String checkSql = "SELECT COUNT(*) FROM attendance WHERE work_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setDate(1, Date.valueOf(today));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return; // Đã có dữ liệu
            }
        } catch (SQLException e) { return; }

        List<Integer> empIds = new ArrayList<>();
        String empSql = "SELECT id FROM employees WHERE status = 'ACTIVE' ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(empSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) empIds.add(rs.getInt("id"));
        } catch (SQLException e) { return; }
        if (empIds.isEmpty()) return;

        String insertSql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?) ON CONFLICT (employee_id, work_date) DO NOTHING";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (int i = 0; i < empIds.size(); i++) {
                int empId = empIds.get(i);
                String status; LocalTime ci = null, co = null; double hrs = 0; String notes = null;
                int mod = i % 10;
                if (mod < 5) {
                    status = "ON_TIME"; int off = (int)(Math.random()*10)-2;
                    ci = LocalTime.of(8, Math.max(10, 25+off));
                    co = LocalTime.of(17, 30+(int)(Math.random()*20));
                    hrs = Math.round(Duration.between(ci, co).toMinutes()/60.0*10)/10.0;
                    notes = "Check-in bằng " + (i%2==0 ? "FaceID" : "Fingerprint");
                } else if (mod < 7) {
                    status = "LATE"; int late = 10+(int)(Math.random()*30);
                    ci = LocalTime.of(8, 35).plusMinutes(late);
                    co = LocalTime.of(17, 35+(int)(Math.random()*15));
                    hrs = Math.round(Duration.between(ci, co).toMinutes()/60.0*10)/10.0;
                    notes = "Check-in bằng FaceID — Đi muộn "+late+" phút";
                } else if (mod < 9) {
                    status = "WFH";
                    ci = LocalTime.of(8, 0+(int)(Math.random()*15));
                    co = LocalTime.of(17, 0+(int)(Math.random()*30));
                    hrs = 8.0; notes = "WFH — GPS Mobile xác thực vị trí";
                } else {
                    status = (i%2==0) ? "ON_LEAVE" : "ABSENT";
                    notes = (i%2==0) ? "Nghỉ phép năm đã duyệt" : null;
                }
                ps.setInt(1, empId); ps.setDate(2, Date.valueOf(today));
                ps.setTime(3, ci!=null?Time.valueOf(ci):null);
                ps.setTime(4, co!=null?Time.valueOf(co):null);
                ps.setDouble(5, hrs); ps.setString(6, status); ps.setString(7, notes);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[AttendanceDAO] Auto-seeded " + empIds.size() + " bản ghi chấm công ngày " + today);
        } catch (SQLException e) {
            System.err.println("autoSeedTodayData lỗi: " + e.getMessage());
        }
    }

    /**
     * Check-in với phương thức: FaceID | Fingerprint | GPS | Manual.
     * Hỗ trợ chấm công bằng vân tay và nhận diện khuôn mặt.
     */
    public boolean checkInWithMethod(int employeeId, LocalDate date, LocalTime checkInTime, String method) {
        Attendance existing = findByEmployeeAndDate(employeeId, date);
        String status = checkInTime.isAfter(LocalTime.of(8, 35)) ? "LATE" : "ON_TIME";
        String methodLabel = (method != null && !method.isEmpty()) ? method : "FaceID";
        String notes = "Check-in bằng " + methodLabel + " lúc " + checkInTime;

        if (existing == null) {
            String sql = "INSERT INTO attendance (employee_id, work_date, check_in, total_hours, status, notes, method) VALUES (?,?,?,?,?,?,?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, employeeId); ps.setDate(2, Date.valueOf(date));
                ps.setTime(3, Time.valueOf(checkInTime));
                ps.setDouble(4, 0.0); ps.setString(5, status); ps.setString(6, notes);
                ps.setString(7, methodLabel);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) { System.err.println("checkInWithMethod insert lỗi: " + e.getMessage()); }
        } else {
            String sql = "UPDATE attendance SET check_in=?, status=?, notes=?, method=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setTime(1, Time.valueOf(checkInTime));
                ps.setString(2, status); ps.setString(3, notes); ps.setString(4, methodLabel); ps.setInt(5, existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) { System.err.println("checkInWithMethod update lỗi: " + e.getMessage()); }
        }
        return false;
    }

    /** Lấy bảng tổng hợp công tháng cho Kế toán & Admin */

    public List<TimesheetSummary> getTimesheetSummary(int month, int year) {
        List<TimesheetSummary> list = new ArrayList<>();
        String sql = "SELECT e.id, e.employee_code, e.full_name, d.name AS department_name, "
                   + "COALESCE(SUM(a.total_hours), 0) AS total_hours, "
                   + "COUNT(CASE WHEN a.status IN ('ON_TIME', 'COMPLETE', 'WORKING') THEN 1 END) AS on_time_days, "
                   + "COUNT(CASE WHEN a.status = 'LATE' THEN 1 END) AS late_days, "
                   + "COUNT(CASE WHEN a.status = 'EARLY_LEAVE' THEN 1 END) AS early_days, "
                   + "COUNT(CASE WHEN a.status = 'ABSENT' THEN 1 END) AS absent_days, "
                   + "COUNT(CASE WHEN a.status = 'ON_LEAVE' THEN 1 END) AS leave_days "
                   + "FROM employees e "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "LEFT JOIN attendance a ON e.id = a.employee_id "
                   + "  AND EXTRACT(MONTH FROM a.work_date) = ? "
                   + "  AND EXTRACT(YEAR FROM a.work_date) = ? "
                   + "WHERE e.status = 'ACTIVE' "
                   + "GROUP BY e.id, e.employee_code, e.full_name, d.name "
                   + "ORDER BY e.employee_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimesheetSummary ts = new TimesheetSummary();
                    ts.setEmployeeId(rs.getInt("id"));
                    ts.setEmployeeCode(rs.getString("employee_code"));
                    ts.setEmployeeName(rs.getString("full_name"));
                    ts.setDepartmentName(rs.getString("department_name"));
                    double hours = rs.getDouble("total_hours");
                    ts.setTotalHours(hours);
                    ts.setTotalWorkDays(Math.round((hours / 8.0) * 10.0) / 10.0);
                    ts.setOnTimeDays(rs.getInt("on_time_days"));
                    ts.setLateDays(rs.getInt("late_days"));
                    ts.setEarlyLeaveDays(rs.getInt("early_days"));
                    ts.setAbsentDays(rs.getInt("absent_days"));
                    ts.setLeaveDays(rs.getInt("leave_days"));
                    list.add(ts);
                }
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.getTimesheetSummary lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Check-in của nhân viên */
    public boolean checkIn(int employeeId, LocalDate date, LocalTime checkInTime) {
        Attendance existing = findByEmployeeAndDate(employeeId, date);
        String status = "ON_TIME";
        if (checkInTime.isAfter(LocalTime.of(8, 35))) {
            status = "LATE";
        }

        if (existing == null) {
            String sql = "INSERT INTO attendance (employee_id, work_date, check_in, total_hours, status) VALUES (?,?,?,?,?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, employeeId);
                ps.setDate(2, Date.valueOf(date));
                ps.setTime(3, Time.valueOf(checkInTime));
                ps.setDouble(4, 0.0);
                ps.setString(5, status);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.checkIn lỗi: " + e.getMessage());
            }
        } else {
            String sql = "UPDATE attendance SET check_in=?, status=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setTime(1, Time.valueOf(checkInTime));
                ps.setString(2, status);
                ps.setInt(3, existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.checkIn update lỗi: " + e.getMessage());
            }
        }
        return false;
    }

    /** Check-out của nhân viên */
    public boolean checkOut(int employeeId, LocalDate date, LocalTime checkOutTime) {
        Attendance existing = findByEmployeeAndDate(employeeId, date);
        if (existing == null) {
            // Check out without prior check-in
            String sql = "INSERT INTO attendance (employee_id, work_date, check_out, total_hours, status) VALUES (?,?,?,?,?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, employeeId);
                ps.setDate(2, Date.valueOf(date));
                ps.setTime(3, Time.valueOf(checkOutTime));
                ps.setDouble(4, 4.0);
                ps.setString(5, "ON_TIME");
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.checkOut insert lỗi: " + e.getMessage());
            }
        } else {
            double hours = 8.0;
            if (existing.getCheckIn() != null) {
                long minutes = Duration.between(existing.getCheckIn(), checkOutTime).toMinutes();
                hours = Math.max(0.0, Math.round((minutes / 60.0) * 10.0) / 10.0);
            }
            String status = existing.getStatus();
            if (checkOutTime.isBefore(LocalTime.of(17, 0)) && !"LATE".equalsIgnoreCase(status)) {
                status = "EARLY_LEAVE";
            }
            String sql = "UPDATE attendance SET check_out=?, total_hours=?, status=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setTime(1, Time.valueOf(checkOutTime));
                ps.setDouble(2, hours);
                ps.setString(3, status);
                ps.setInt(4, existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.checkOut update lỗi: " + e.getMessage());
            }
        }
        return false;
    }

    /** Lưu chấm công thủ công hoặc điều chỉnh (Upsert) */
    public boolean upsertManual(int employeeId, LocalDate date, LocalTime checkIn, LocalTime checkOut, String status, String notes) {
        Attendance existing = findByEmployeeAndDate(employeeId, date);
        double hours = 8.0;
        if (checkIn != null && checkOut != null) {
            long minutes = Duration.between(checkIn, checkOut).toMinutes();
            hours = Math.max(0.0, Math.round((minutes / 60.0) * 10.0) / 10.0);
        }

        if (existing == null) {
            String sql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes) "
                       + "VALUES (?,?,?,?,?,?,?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, employeeId);
                ps.setDate(2, Date.valueOf(date));
                ps.setTime(3, checkIn != null ? Time.valueOf(checkIn) : null);
                ps.setTime(4, checkOut != null ? Time.valueOf(checkOut) : null);
                ps.setDouble(5, hours);
                ps.setString(6, status != null ? status : "ON_TIME");
                ps.setString(7, notes);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.upsertManual insert lỗi: " + e.getMessage());
            }
        } else {
            String sql = "UPDATE attendance SET check_in=?, check_out=?, total_hours=?, status=?, notes=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setTime(1, checkIn != null ? Time.valueOf(checkIn) : null);
                ps.setTime(2, checkOut != null ? Time.valueOf(checkOut) : null);
                ps.setDouble(3, hours);
                ps.setString(4, status != null ? status : existing.getStatus());
                ps.setString(5, notes);
                ps.setInt(6, existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.upsertManual update lỗi: " + e.getMessage());
            }
        }
        return false;
    }

    /** Cập nhật chấm công theo ID */
    public boolean update(int id, LocalTime checkIn, LocalTime checkOut, String status, String notes) {
        double hours = 8.0;
        if (checkIn != null && checkOut != null) {
            long minutes = Duration.between(checkIn, checkOut).toMinutes();
            hours = Math.max(0.0, Math.round((minutes / 60.0) * 10.0) / 10.0);
        }
        String sql = "UPDATE attendance SET check_in=?, check_out=?, total_hours=?, status=?, notes=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTime(1, checkIn != null ? Time.valueOf(checkIn) : null);
            ps.setTime(2, checkOut != null ? Time.valueOf(checkOut) : null);
            ps.setDouble(3, hours);
            ps.setString(4, status);
            ps.setString(5, notes);
            ps.setInt(6, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.update lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Phê duyệt giải trình: chuyển trạng thái sang ON_TIME và thêm ghi chú */
    public boolean approveExplain(int id) {
        String sql = "UPDATE attendance SET status='ON_TIME', notes=COALESCE(notes, '') || ' [Đã duyệt giải trình]' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.approveExplain lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Xóa bản ghi chấm công */
    public boolean delete(int id) {
        String sql = "DELETE FROM attendance WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.delete lỗi: " + e.getMessage());
        }
        return false;
    }

    public List<Attendance> findByMonth(int month, int year) {
        return search(null, null, null, null, month, year);
    }

    public boolean insert(Attendance att) {
        if (att == null) return false;
        String sql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, att.getEmployeeId());
            ps.setDate(2, att.getWorkDate() != null ? Date.valueOf(att.getWorkDate()) : Date.valueOf(LocalDate.now()));
            ps.setTime(3, att.getCheckIn() != null ? Time.valueOf(att.getCheckIn()) : null);
            ps.setTime(4, att.getCheckOut() != null ? Time.valueOf(att.getCheckOut()) : null);
            ps.setDouble(5, att.getTotalHours());
            ps.setString(6, att.getStatus() != null ? att.getStatus() : "ON_TIME");
            ps.setString(7, att.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Attendance att) {
        if (att == null) return false;
        return update(att.getId(), att.getCheckIn(), att.getCheckOut(), att.getStatus(), att.getNotes());
    }

    public double countWorkingDays(int employeeId, int month, int year) {
        String sql = "SELECT COUNT(*) FROM attendance WHERE employee_id = ? " +
                     "AND EXTRACT(MONTH FROM work_date) = ? AND EXTRACT(YEAR FROM work_date) = ? " +
                     "AND status IN ('ON_TIME', 'LATE', 'EARLY_LEAVE', 'WFH', 'COMPLETE')";
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
        return 0.0;
    }

    private Attendance mapRow(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setId(rs.getInt("id"));
        a.setEmployeeId(rs.getInt("employee_id"));
        a.setEmployeeCode(rs.getString("employee_code"));
        a.setEmployeeName(rs.getString("full_name"));
        a.setDepartmentName(rs.getString("department_name"));
        a.setPositionName(rs.getString("position_name"));
        Date wd = rs.getDate("work_date");
        if (wd != null) a.setWorkDate(wd.toLocalDate());
        Time ci = rs.getTime("check_in");
        if (ci != null) a.setCheckIn(ci.toLocalTime());
        Time co = rs.getTime("check_out");
        if (co != null) a.setCheckOut(co.toLocalTime());
        a.setTotalHours(rs.getDouble("total_hours"));
        a.setStatus(rs.getString("status"));
        a.setNotes(rs.getString("notes"));
        try {
            String m = rs.getString("method");
            if (m != null && !m.isEmpty()) a.setMethod(m);
        } catch (SQLException ignored) {}
        Timestamp cat = rs.getTimestamp("created_at");
        if (cat != null) a.setCreatedAt(cat.toLocalDateTime());
        return a;
    }
}

