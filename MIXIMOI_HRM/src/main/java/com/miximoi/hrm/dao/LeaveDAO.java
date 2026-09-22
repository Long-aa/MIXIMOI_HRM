package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý dữ liệu đơn nghỉ phép & nghỉ lễ kết nối trực tiếp CSDL PostgreSQL.
 * Khớp hoàn toàn với bảng leave_requests trong schema.sql.
 */
public class LeaveDAO {

    private static final String BASE_SELECT =
            "SELECT lr.id, lr.leave_code, lr.employee_id, lr.leave_type, lr.start_date, lr.end_date, " +
            "       lr.total_days, lr.reason, lr.status, lr.approved_by_id, lr.approved_at, " +
            "       lr.reject_reason, lr.created_at, lr.updated_at, " +
            "       e.employee_code, e.full_name AS employee_name, e.department_id, " +
            "       d.name AS department_name, p.name AS position_name, " +
            "       ap.full_name AS approved_by_name " +
            "FROM leave_requests lr " +
            "JOIN employees e ON lr.employee_id = e.id " +
            "LEFT JOIN departments d ON e.department_id = d.id " +
            "LEFT JOIN positions p ON e.position_id = p.id " +
            "LEFT JOIN employees ap ON lr.approved_by_id = ap.id ";

    public LeaveDAO() {
        initSampleDataIfEmpty();
    }

    private void initSampleDataIfEmpty() {
        String checkSql = "SELECT COUNT(*) FROM leave_requests";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) == 0) {
                // Kiểm tra xem đã có nhân viên nào chưa
                String checkEmp = "SELECT id FROM employees ORDER BY id LIMIT 5";
                List<Integer> empIds = new ArrayList<>();
                try (PreparedStatement pse = conn.prepareStatement(checkEmp);
                     ResultSet rse = pse.executeQuery()) {
                    while (rse.next()) {
                        empIds.add(rse.getInt("id"));
                    }
                }
                if (!empIds.isEmpty()) {
                    int e1 = empIds.get(0);
                    int e2 = empIds.size() > 1 ? empIds.get(1) : e1;
                    int e3 = empIds.size() > 2 ? empIds.get(2) : e1;
                    int e4 = empIds.size() > 3 ? empIds.get(3) : e1;

                    String insert = "INSERT INTO leave_requests (leave_code, employee_id, leave_type, start_date, end_date, total_days, reason, status, approved_by_id, approved_at, reject_reason, created_at) VALUES " +
                            "('LP-2026-015', ?, 'ANNUAL', '2026-09-28', '2026-09-30', 3, 'Giải quyết việc gia đình cá nhân', 'PENDING', NULL, NULL, NULL, NOW() - INTERVAL '5 hours'), " +
                            "('LP-2026-014', ?, 'SICK', '2026-09-26', '2026-09-27', 2, 'Khám và điều trị theo chỉ định bác sĩ', 'APPROVED', ?, NOW() - INTERVAL '1 day', NULL, NOW() - INTERVAL '2 days'), " +
                            "('LP-2026-013', ?, 'UNPAID', '2026-10-01', '2026-10-05', 5, 'Du lịch cá nhân ngoài nước', 'REJECTED', ?, NOW() - INTERVAL '3 days', 'Trùng lịch chốt deal quý 4, yêu cầu sắp xếp lại', NOW() - INTERVAL '3 days'), " +
                            "('LP-2026-012', ?, 'PERSONAL', '2026-09-15', '2026-09-17', 3, 'Kết hôn cá nhân (Đã gửi thiệp báo)', 'APPROVED', ?, NOW() - INTERVAL '5 days', NULL, NOW() - INTERVAL '7 days')";
                    try (PreparedStatement psi = conn.prepareStatement(insert)) {
                        psi.setInt(1, e1);
                        psi.setInt(2, e2);
                        psi.setInt(3, e1);
                        psi.setInt(4, e3);
                        psi.setInt(5, e1);
                        psi.setInt(6, e4);
                        psi.setInt(7, e1);
                        psi.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.initSampleDataIfEmpty: " + e.getMessage());
        }
    }

    /** Lấy tất cả đơn nghỉ phép */
    public List<LeaveRequest> findAll() {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY lr.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Lấy danh sách theo nhân viên */
    public List<LeaveRequest> findByEmployeeId(int employeeId) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE lr.employee_id = ? ORDER BY lr.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findByEmployeeId lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Lấy danh sách theo trạng thái */
    public List<LeaveRequest> findByStatus(String status) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE lr.status = ? ORDER BY lr.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findByStatus lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Lấy đơn nghỉ phép theo ID */
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

    /** Đếm số đơn chờ duyệt */
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

    /** Lọc theo Role người dùng, trạng thái, phòng ban, loại nghỉ, từ khóa */
    public List<LeaveRequest> findByFilters(User user, String status, Integer departmentId,
                                           String leaveType, String keyword) {
        List<LeaveRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");

        // 1. Phân quyền theo role
        if (user != null) {
            if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
                sql.append("AND lr.employee_id = ? ");
            } else if (user.isManager() && !user.isAdmin() && !user.isHr()) {
                // Trưởng phòng: lọc theo phòng ban của manager
                sql.append("AND e.department_id = (SELECT department_id FROM employees WHERE id = ?) ");
            }
        }

        // 2. Bộ lọc trạng thái
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND lr.status = ? ");
        }

        // 3. Bộ lọc phòng ban
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }

        // 4. Bộ lọc loại nghỉ
        if (leaveType != null && !leaveType.trim().isEmpty() && !"ALL".equalsIgnoreCase(leaveType)) {
            sql.append("AND lr.leave_type = ? ");
        }

        // 5. Tìm kiếm từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(lr.leave_code) LIKE ? OR LOWER(lr.reason) LIKE ?) ");
        }

        sql.append("ORDER BY lr.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (user != null) {
                if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
                    ps.setInt(idx++, user.getEmployeeId());
                } else if (user.isManager() && !user.isAdmin() && !user.isHr()) {
                    ps.setInt(idx++, user.getEmployeeId());
                }
            }
            if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
                ps.setString(idx++, status.trim().toUpperCase());
            }
            if (departmentId != null && departmentId > 0) {
                ps.setInt(idx++, departmentId);
            }
            if (leaveType != null && !leaveType.trim().isEmpty() && !"ALL".equalsIgnoreCase(leaveType)) {
                ps.setString(idx++, leaveType.trim().toUpperCase());
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findByFilters lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Tạo đơn nghỉ phép mới */
    public boolean insert(LeaveRequest lr) {
        String sql = "INSERT INTO leave_requests (leave_code, employee_id, leave_type, start_date, end_date, total_days, reason, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING', NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, lr.getLeaveCode());
            ps.setInt(2, lr.getEmployeeId());
            ps.setString(3, lr.getLeaveType());
            ps.setDate(4, Date.valueOf(lr.getStartDate()));
            ps.setDate(5, Date.valueOf(lr.getEndDate()));
            ps.setInt(6, (int) Math.max(1, Math.round(lr.getDays())));
            ps.setString(7, lr.getReason());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) lr.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Phê duyệt đơn nghỉ phép */
    public boolean approve(int id, int approvedById) {
        String sql = "UPDATE leave_requests SET status = 'APPROVED', approved_by_id = ?, approved_at = NOW(), updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (approvedById > 0) {
                ps.setInt(1, approvedById);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.approve lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Từ chối đơn nghỉ phép */
    public boolean reject(int id, int rejectedById, String reason) {
        String sql = "UPDATE leave_requests SET status = 'REJECTED', approved_by_id = ?, approved_at = NOW(), reject_reason = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (rejectedById > 0) {
                ps.setInt(1, rejectedById);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, reason != null ? reason : "Không đủ điều kiện phê duyệt");
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.reject lỗi: " + e.getMessage());
        }
        return false;
    }

    public int bulkApprove(List<Integer> ids, int approvedById) {
        if (ids == null || ids.isEmpty()) return 0;
        StringBuilder sql = new StringBuilder("UPDATE leave_requests SET status = 'APPROVED', approved_by_id = ?, approved_at = NOW(), updated_at = NOW() WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (approvedById > 0) {
                ps.setInt(1, approvedById);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 2, ids.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("LeaveDAO.bulkApprove lỗi: " + e.getMessage());
        }
        return 0;
    }

    public int bulkReject(List<Integer> ids, int rejectedById, String reason) {
        if (ids == null || ids.isEmpty()) return 0;
        StringBuilder sql = new StringBuilder("UPDATE leave_requests SET status = 'REJECTED', approved_by_id = ?, approved_at = NOW(), reject_reason = ?, updated_at = NOW() WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (rejectedById > 0) {
                ps.setInt(1, rejectedById);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, reason != null ? reason : "Từ chối hàng loạt bởi quản trị");
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 3, ids.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("LeaveDAO.bulkReject lỗi: " + e.getMessage());
        }
        return 0;
    }

    public int bulkDelete(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return 0;
        StringBuilder sql = new StringBuilder("DELETE FROM leave_requests WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("LeaveDAO.bulkDelete lỗi: " + e.getMessage());
        }
        return 0;
    }

    public List<LeaveRequest> findByIds(List<Integer> ids) {
        List<LeaveRequest> list = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return list;
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE lr.id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(") ORDER BY lr.created_at DESC");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.findByIds lỗi: " + e.getMessage());
        }
        return list;
    }

    private LeaveRequest mapRow(ResultSet rs) throws SQLException {
        LeaveRequest lr = new LeaveRequest();
        lr.setId(rs.getInt("id"));
        lr.setLeaveCode(rs.getString("leave_code"));
        lr.setEmployeeId(rs.getInt("employee_id"));
        lr.setEmployeeCode(rs.getString("employee_code"));
        lr.setEmployeeName(rs.getString("employee_name"));
        lr.setDepartmentId(rs.getInt("department_id"));
        lr.setDepartmentName(rs.getString("department_name"));
        lr.setPositionName(rs.getString("position_name"));
        lr.setLeaveType(rs.getString("leave_type"));

        Date sd = rs.getDate("start_date");
        if (sd != null) lr.setStartDate(sd.toLocalDate());
        Date ed = rs.getDate("end_date");
        if (ed != null) lr.setEndDate(ed.toLocalDate());

        int td = rs.getInt("total_days");
        lr.setTotalDays(td);
        lr.setDays(td > 0 ? (double) td : 1.0);

        lr.setReason(rs.getString("reason"));
        lr.setStatus(rs.getString("status"));
        lr.setApprovedById(rs.getInt("approved_by_id"));
        lr.setApprovedByName(rs.getString("approved_by_name"));

        Timestamp apAt = rs.getTimestamp("approved_at");
        if (apAt != null) lr.setApprovedAt(apAt.toLocalDateTime());

        lr.setRejectReason(rs.getString("reject_reason"));

        Timestamp cat = rs.getTimestamp("created_at");
        if (cat != null) lr.setCreatedAt(cat.toLocalDateTime());

        Timestamp uat = rs.getTimestamp("updated_at");
        if (uat != null) lr.setUpdatedAt(uat.toLocalDateTime());

        // Ghi chú thời gian hiển thị UI
        lr.setTimeNote(lr.getDays() + " ngày làm việc");
        lr.setManagerStatus(lr.getStatus());
        lr.setHrStatus(lr.getStatus());
        return lr;
    }
}
