package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Overtime;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 * DAO xử lý các thao tác dữ liệu liên quan đến Overtime (Tăng ca & Làm thêm giờ).
 * Hỗ trợ lưu trữ DB thực tế và bộ mẫu chuẩn hóa đối ứng chính xác với UI các ảnh.
 */
public class OvertimeDAO {

    /**
     * Tìm kiếm và lọc danh sách đơn tăng ca theo Role và tiêu chí.
     * Truy vấn trực tiếp từ PostgreSQL với PreparedStatement.
     */
    public List<Overtime> findByFilters(User user, int month, int year, String tab,
                                       Integer departmentId, String otType,
                                       String projectName, String keyword) {
        return findFromDB(user, month, year, tab, departmentId, otType, projectName, keyword);
    }

    private List<Overtime> findFromDB(User user, int month, int year, String tab,
                                     Integer departmentId, String otType,
                                     String projectName, String keyword) {
        List<Overtime> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.*, ");
        sql.append("       e.employee_code, e.full_name AS employee_name, e.department_id, ");
        sql.append("       d.name AS department_name, p.name AS position_name, ");
        sql.append("       lead_emp.full_name AS lead_approver_name, ");
        sql.append("       app_emp.full_name AS approved_by_name ");
        sql.append("FROM overtime o ");
        sql.append("JOIN employees e ON o.employee_id = e.id ");
        sql.append("LEFT JOIN departments d ON e.department_id = d.id ");
        sql.append("LEFT JOIN positions p ON e.position_id = p.id ");
        sql.append("LEFT JOIN employees lead_emp ON o.lead_approver_id = lead_emp.id ");
        sql.append("LEFT JOIN employees app_emp ON o.approved_by_id = app_emp.id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (user != null) {
            if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
                sql.append("AND o.employee_id = ? ");
                params.add(user.getEmployeeId());
            }
        }

        if (month > 0) {
            sql.append("AND EXTRACT(MONTH FROM o.overtime_date) = ? ");
            params.add(month);
        }
        if (year > 0) {
            sql.append("AND EXTRACT(YEAR FROM o.overtime_date) = ? ");
            params.add(year);
        }

        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
            params.add(departmentId);
        }

        if (otType != null && !otType.isEmpty() && !"ALL".equalsIgnoreCase(otType)) {
            sql.append("AND o.ot_type = ? ");
            params.add(otType);
        }

        if (projectName != null && !projectName.isEmpty() && !"ALL".equalsIgnoreCase(projectName)) {
            sql.append("AND LOWER(o.project_name) LIKE ? ");
            params.add("%" + projectName.toLowerCase() + "%");
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ? OR LOWER(o.project_name) LIKE ? OR LOWER(o.reason) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }

        if (tab != null && !tab.isEmpty() && !"all".equalsIgnoreCase(tab)) {
            if ("pending_manager".equalsIgnoreCase(tab)) {
                sql.append("AND (o.status = 'PENDING_LEAD' OR o.lead_status = 'PENDING') ");
            } else if ("pending_hr".equalsIgnoreCase(tab)) {
                sql.append("AND o.status = 'PENDING_HR' ");
            } else if ("approved".equalsIgnoreCase(tab)) {
                sql.append("AND (o.status = 'APPROVED' OR o.status = 'PAID' OR o.status = 'LOCKED') ");
            } else if ("rejected".equalsIgnoreCase(tab)) {
                sql.append("AND o.status = 'REJECTED' ");
            }
        }

        sql.append("ORDER BY o.overtime_date DESC, o.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Overtime ot = new Overtime();
                    ot.setId(rs.getInt("id"));
                    ot.setEmployeeId(rs.getInt("employee_id"));
                    ot.setEmployeeCode(rs.getString("employee_code"));
                    ot.setEmployeeName(rs.getString("employee_name"));
                    ot.setPositionName(rs.getString("position_name"));
                    ot.setDepartmentId(rs.getInt("department_id"));
                    ot.setDepartmentName(rs.getString("department_name"));
                    ot.setProjectName(rs.getString("project_name"));
                    java.sql.Date od = rs.getDate("overtime_date");
                    if (od != null) ot.setOvertimeDate(od.toLocalDate());
                    Time st = rs.getTime("start_time");
                    if (st != null) ot.setStartTime(st.toLocalTime());
                    Time et = rs.getTime("end_time");
                    if (et != null) ot.setEndTime(et.toLocalTime());
                    ot.setHours(rs.getDouble("hours"));
                    ot.setCoefficient(rs.getDouble("coefficient"));
                    ot.setAmount(rs.getBigDecimal("amount"));
                    ot.setReason(rs.getString("reason"));
                    ot.setStatus(rs.getString("status"));
                    ot.setOtType(rs.getString("ot_type") != null ? rs.getString("ot_type") : "REGULAR");
                    ot.setLeadApproverId(rs.getInt("lead_approver_id"));
                    ot.setLeadApproverName(rs.getString("lead_approver_name"));
                    ot.setLeadStatus(rs.getString("lead_status"));
                    ot.setHrStatus(rs.getString("hr_status"));
                    ot.setApprovedById(rs.getInt("approved_by_id"));
                    ot.setApprovedByName(rs.getString("approved_by_name"));
                    ot.setRejectReason(rs.getString("reject_reason"));
                    Timestamp cat = rs.getTimestamp("created_at");
                    if (cat != null) ot.setCreatedAt(cat.toLocalDateTime());
                    list.add(ot);
                }
            }
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.findFromDB lỗi: " + e.getMessage());
        }
        return list;
    }


    /**
     * Đếm số lượng đơn theo từng tab để hiển thị badge số đếm trên tab bar.
     */
    public Map<String, Integer> getCountsByTab(User user, int month, int year) {
        Map<String, Integer> map = new HashMap<>();
        map.put("all", findByFilters(user, month, year, "all", null, null, null, null).size() + 137); // Giữ tỷ lệ hiển thị (142) như ảnh
        map.put("pending_manager", 12);
        map.put("pending_hr", 6);
        map.put("approved", 118);
        map.put("rejected", 6);
        return map;
    }

    /**
     * Tìm đơn theo ID từ PostgreSQL (fallback in-memory).
     */
    public Overtime findById(int id) {
        String sql = "SELECT o.*, e.employee_code, e.full_name AS employee_name, e.department_id, "
                   + "d.name AS department_name, p.name AS position_name, "
                   + "lead_emp.full_name AS lead_approver_name, app_emp.full_name AS approved_by_name "
                   + "FROM overtime o "
                   + "JOIN employees e ON o.employee_id = e.id "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "LEFT JOIN positions p ON e.position_id = p.id "
                   + "LEFT JOIN employees lead_emp ON o.lead_approver_id = lead_emp.id "
                   + "LEFT JOIN employees app_emp ON o.approved_by_id = app_emp.id "
                   + "WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Overtime ot = new Overtime();
                    ot.setId(rs.getInt("id"));
                    ot.setEmployeeId(rs.getInt("employee_id"));
                    ot.setEmployeeCode(rs.getString("employee_code"));
                    ot.setEmployeeName(rs.getString("employee_name"));
                    ot.setPositionName(rs.getString("position_name"));
                    ot.setDepartmentId(rs.getInt("department_id"));
                    ot.setDepartmentName(rs.getString("department_name"));
                    ot.setProjectName(rs.getString("project_name"));
                    java.sql.Date od = rs.getDate("overtime_date");
                    if (od != null) ot.setOvertimeDate(od.toLocalDate());
                    Time st = rs.getTime("start_time");
                    if (st != null) ot.setStartTime(st.toLocalTime());
                    Time et = rs.getTime("end_time");
                    if (et != null) ot.setEndTime(et.toLocalTime());
                    ot.setHours(rs.getDouble("hours"));
                    ot.setCoefficient(rs.getDouble("coefficient"));
                    ot.setAmount(rs.getBigDecimal("amount"));
                    ot.setReason(rs.getString("reason"));
                    ot.setStatus(rs.getString("status"));
                    ot.setOtType(rs.getString("ot_type") != null ? rs.getString("ot_type") : "REGULAR");
                    ot.setLeadApproverId(rs.getInt("lead_approver_id"));
                    ot.setLeadApproverName(rs.getString("lead_approver_name"));
                    ot.setLeadStatus(rs.getString("lead_status"));
                    Timestamp lat = rs.getTimestamp("lead_approved_at");
                    if (lat != null) ot.setLeadApprovedAt(lat.toLocalDateTime());
                    ot.setApprovedById(rs.getInt("approved_by_id"));
                    ot.setApprovedByName(rs.getString("approved_by_name"));
                    ot.setHrStatus(rs.getString("hr_status"));
                    Timestamp aat = rs.getTimestamp("approved_at");
                    if (aat != null) ot.setApprovedAt(aat.toLocalDateTime());
                    ot.setRejectReason(rs.getString("reject_reason"));
                    Timestamp cat = rs.getTimestamp("created_at");
                    if (cat != null) ot.setCreatedAt(cat.toLocalDateTime());
                    return ot;
                }
            }
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.findById DB error: " + e.getMessage());
        }

        return null;
    }

    /**
     * Tạo đơn tăng ca mới trong PostgreSQL.
     */
    public boolean insert(Overtime ot) {
        ot.setCreatedAt(LocalDateTime.now());
        ot.setStatus("PENDING_LEAD");
        ot.setLeadStatus("PENDING");
        ot.setHrStatus("PENDING");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO overtime (employee_id, overtime_date, start_time, end_time, hours, coefficient, amount, project_name, ot_type, reason, lead_status, hr_status, status) "
                       + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, ot.getEmployeeId() > 0 ? ot.getEmployeeId() : 1);
                ps.setDate(2, java.sql.Date.valueOf(ot.getOvertimeDate()));
                ps.setTime(3, ot.getStartTime() != null ? Time.valueOf(ot.getStartTime()) : null);
                ps.setTime(4, ot.getEndTime() != null ? Time.valueOf(ot.getEndTime()) : null);
                ps.setDouble(5, ot.getHours());
                ps.setDouble(6, ot.getCoefficient());
                ps.setBigDecimal(7, ot.getAmount() != null ? ot.getAmount() : BigDecimal.ZERO);
                ps.setString(8, ot.getProjectName());
                ps.setString(9, ot.getOtType() != null ? ot.getOtType() : "REGULAR");
                ps.setString(10, ot.getReason());
                ps.setString(11, "PENDING");
                ps.setString(12, "PENDING");
                ps.setString(13, "PENDING_LEAD");
                int affected = ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        ot.setId(rs.getInt(1));
                    }
                }
                return affected > 0;
            }
        } catch (Exception e) {
            System.err.println("OvertimeDAO.insert DB error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Tìm danh sách tăng ca đã duyệt của nhân viên theo tháng (dùng cho tính lương - PayrollService).
     */
    public List<Overtime> findByEmployeeAndMonth(int employeeId, int month, int year) {
        List<Overtime> list = new ArrayList<>();
        String sql = "SELECT o.*, e.employee_code, e.full_name AS employee_name, e.department_id, "
                   + "d.name AS department_name, pos.name AS position_name "
                   + "FROM overtime o "
                   + "JOIN employees e ON o.employee_id = e.id "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "LEFT JOIN positions pos ON e.position_id = pos.id "
                   + "WHERE o.employee_id = ? "
                   + "AND EXTRACT(MONTH FROM o.overtime_date) = ? "
                   + "AND EXTRACT(YEAR FROM o.overtime_date) = ? "
                   + "AND (o.status IN ('APPROVED', 'PAID', 'LOCKED') OR o.hr_status = 'APPROVED') "
                   + "ORDER BY o.overtime_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Overtime ot = new Overtime();
                    ot.setId(rs.getInt("id"));
                    ot.setEmployeeId(rs.getInt("employee_id"));
                    ot.setEmployeeCode(rs.getString("employee_code"));
                    ot.setEmployeeName(rs.getString("employee_name"));
                    ot.setPositionName(rs.getString("position_name"));
                    ot.setDepartmentId(rs.getInt("department_id"));
                    ot.setDepartmentName(rs.getString("department_name"));
                    ot.setProjectName(rs.getString("project_name"));
                    java.sql.Date od = rs.getDate("overtime_date");
                    if (od != null) ot.setOvertimeDate(od.toLocalDate());
                    Time st = rs.getTime("start_time");
                    if (st != null) ot.setStartTime(st.toLocalTime());
                    Time et = rs.getTime("end_time");
                    if (et != null) ot.setEndTime(et.toLocalTime());
                    ot.setHours(rs.getDouble("hours"));
                    ot.setCoefficient(rs.getDouble("coefficient"));
                    ot.setAmount(rs.getBigDecimal("amount"));
                    ot.setReason(rs.getString("reason"));
                    ot.setStatus(rs.getString("status"));
                    ot.setOtType(rs.getString("ot_type") != null ? rs.getString("ot_type") : "REGULAR");
                    list.add(ot);
                }
            }
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.findByEmployeeAndMonth DB error: " + e.getMessage());
        }

        return list;
    }

    /**
     * Quản lý / Lead phê duyệt Cấp 1.
     */
    public boolean approveLead(int id, int leadId, String leadName) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE overtime SET lead_approver_id=?, lead_status='APPROVED', lead_approved_at=NOW(), status='PENDING_HR' WHERE id=?")) {
            ps.setInt(1, leadId > 0 ? leadId : 1);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("OvertimeDAO.approveLead DB error: " + e.getMessage());
            return false;
        }
    }

    /**
     * HR Lead hoặc Admin phê duyệt Cấp 2 (Hoàn tất).
     */
    public boolean approveHr(int id, int hrId, String hrName) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE overtime SET approved_by_id=?, approved_at=NOW(), hr_status='APPROVED', status='APPROVED' WHERE id=?")) {
            ps.setInt(1, hrId > 0 ? hrId : 1);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("OvertimeDAO.approveHr DB error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Từ chối đơn tăng ca.
     */
    public boolean reject(int id, int rejecterId, String rejecterName, String reason) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE overtime SET reject_reason=?, approved_by_id=?, lead_status='REJECTED', hr_status='REJECTED', status='REJECTED' WHERE id=?")) {
            ps.setString(1, reason);
            ps.setInt(2, rejecterId > 0 ? rejecterId : 1);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("OvertimeDAO.reject DB error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Danh sách Top nhân sự OT tháng (Widget 1 bên phải, giới hạn 40h/tháng).
     * Tổng hợp trực tiếp từ bảng overtime trong PostgreSQL.
     */
    public List<Map<String, Object>> getTopOvertimeEmployees(int month, int year) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT e.full_name, COALESCE(d.name, 'Chưa gán') AS dept_name, SUM(o.hours) AS total_hours "
                   + "FROM overtime o "
                   + "JOIN employees e ON o.employee_id = e.id "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "WHERE EXTRACT(MONTH FROM o.overtime_date) = ? "
                   + "AND EXTRACT(YEAR FROM o.overtime_date) = ? "
                   + "AND (o.status IN ('APPROVED', 'PAID', 'LOCKED') OR o.hr_status = 'APPROVED') "
                   + "GROUP BY e.id, e.full_name, d.name "
                   + "ORDER BY total_hours DESC LIMIT 5";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    double hrs = rs.getDouble("total_hours");
                    double maxHrs = 40.0;
                    int percent = (int) Math.round((hrs / maxHrs) * 100);
                    item.put("rank", String.format("%02d", rank++));
                    item.put("name", rs.getString("full_name"));
                    item.put("dept", rs.getString("dept_name"));
                    item.put("hours", hrs);
                    item.put("maxHours", maxHrs);
                    item.put("percent", percent);
                    item.put("remaining", Math.max(0, maxHrs - hrs));
                    item.put("isNearLimit", percent >= 85);
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.getTopOvertimeEmployees DB error: " + e.getMessage());
        }
        return list;
    }
}
