package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.EmployeeLeaveBalance;
import com.miximoi.hrm.model.Holiday;
import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;

/**
 * DAO xử lý dữ liệu đơn nghỉ phép & nghỉ lễ kết nối trực tiếp CSDL PostgreSQL.
 * Khớp hoàn toàn với bảng leave_requests và holidays trong schema.sql.
 */
public class LeaveDAO {

    private static final String BASE_SELECT =
            "SELECT lr.id, lr.leave_code, lr.employee_id, lr.leave_type, lr.start_date, lr.end_date, " +
            "       lr.total_days, lr.reason, lr.status, lr.approved_by_id, lr.approved_at, " +
            "       lr.reject_reason, lr.created_at, lr.updated_at, " +
            "       lr.manager_id, lr.manager_approved_at, lr.manager_note, " +
            "       lr.hr_id, lr.hr_approved_at, lr.attachment_url, " +
            "       lr.handover_person, lr.time_note, " +
            "       e.employee_code, e.full_name AS employee_name, e.department_id, " +
            "       d.name AS department_name, p.name AS position_name, " +
            "       ap.full_name AS approved_by_name, " +
            "       m.full_name AS manager_name, " +
            "       h.full_name AS hr_name " +
            "FROM leave_requests lr " +
            "JOIN employees e ON lr.employee_id = e.id " +
            "LEFT JOIN departments d ON e.department_id = d.id " +
            "LEFT JOIN positions p ON e.position_id = p.id " +
            "LEFT JOIN employees ap ON lr.approved_by_id = ap.id " +
            "LEFT JOIN employees m ON lr.manager_id = m.id " +
            "LEFT JOIN employees h ON lr.hr_id = h.id ";

    public LeaveDAO() {
        initSampleDataIfEmpty();
    }

    private void initSampleDataIfEmpty() {
        // Tự động migration các cột và bảng cần thiết
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            st.execute("ALTER TABLE leave_requests ALTER COLUMN total_days TYPE NUMERIC(4,1)");
            st.execute("ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS manager_id INTEGER REFERENCES employees(id)");
            st.execute("ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS manager_approved_at TIMESTAMP");
            st.execute("ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS manager_note TEXT");
            st.execute("ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS hr_id INTEGER REFERENCES employees(id)");
            st.execute("ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS hr_approved_at TIMESTAMP");
            st.execute("ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS attachment_url VARCHAR(255)");

            st.execute("CREATE TABLE IF NOT EXISTS holidays (" +
                       "id SERIAL PRIMARY KEY, " +
                       "holiday_date DATE NOT NULL UNIQUE, " +
                       "name VARCHAR(150) NOT NULL, " +
                       "year INTEGER NOT NULL, " +
                       "coefficient NUMERIC(3,1) NOT NULL DEFAULT 3.0)");

            try (ResultSet rsH = st.executeQuery("SELECT COUNT(*) FROM holidays WHERE year = 2026")) {
                if (rsH.next() && rsH.getInt(1) == 0) {
                    st.execute("INSERT INTO holidays (holiday_date, name, year, coefficient) VALUES " +
                               "('2026-01-01', 'Tết Dương Lịch 2026', 2026, 3.0), " +
                               "('2026-02-16', 'Tết Nguyên Đán (29 Tết)', 2026, 3.0), " +
                               "('2026-02-17', 'Tết Nguyên Đán (Mùng 1)', 2026, 3.0), " +
                               "('2026-02-18', 'Tết Nguyên Đán (Mùng 2)', 2026, 3.0), " +
                               "('2026-02-19', 'Tết Nguyên Đán (Mùng 3)', 2026, 3.0), " +
                               "('2026-02-20', 'Tết Nguyên Đán (Mùng 4)', 2026, 3.0), " +
                               "('2026-04-26', 'Giỗ Tổ Hùng Vương (10/3 AL)', 2026, 3.0), " +
                               "('2026-04-30', 'Ngày Giải phóng Miền Nam', 2026, 3.0), " +
                               "('2026-05-01', 'Ngày Quốc tế Lao Động', 2026, 3.0), " +
                               "('2026-09-01', 'Nghỉ liền kề Quốc Khánh', 2026, 3.0), " +
                               "('2026-09-02', 'Quốc Khánh Nước CHXHCNVN', 2026, 3.0) ON CONFLICT DO NOTHING");
                }
            }
        } catch (SQLException ignored) {}

        String checkSql = "SELECT COUNT(*) FROM leave_requests";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) == 0) {
                // Kiểm tra xem đã có nhân viên nào chưa
                String checkEmp = "SELECT id FROM employees ORDER BY id LIMIT 5";
                int[] empIds = new int[4];
                int empCount = 0;
                try (PreparedStatement pse = conn.prepareStatement(checkEmp);
                     ResultSet rse = pse.executeQuery()) {
                    while (rse.next() && empCount < 4) {
                        empIds[empCount++] = rse.getInt("id");
                    }
                }
                if (empCount > 0) {
                    int e1 = empIds[0];
                    int e2 = empCount > 1 ? empIds[1] : e1;
                    int e3 = empCount > 2 ? empIds[2] : e1;
                    int e4 = empCount > 3 ? empIds[3] : e1;

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
        String sql = "INSERT INTO leave_requests (leave_code, employee_id, leave_type, start_date, end_date, total_days, days, reason, status, handover_person, attachment_url, time_note, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'PENDING', ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            double numDays = lr.getDays() > 0 ? lr.getDays() : 1.0;
            ps.setString(1, lr.getLeaveCode());
            ps.setInt(2, lr.getEmployeeId());
            ps.setString(3, lr.getLeaveType());
            ps.setDate(4, java.sql.Date.valueOf(lr.getStartDate()));
            ps.setDate(5, java.sql.Date.valueOf(lr.getEndDate()));
            ps.setDouble(6, numDays);
            ps.setDouble(7, numDays);
            ps.setString(8, lr.getReason());
            ps.setString(9, lr.getHandoverPerson());
            ps.setString(10, lr.getAttachmentUrl());
            ps.setString(11, lr.getTimeNote());

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

    /** Cấp 1: Trưởng phòng phê duyệt vận hành & bàn giao công việc */
    public boolean managerApprove(int id, int managerId, String note) {
        String sql = "UPDATE leave_requests SET status = 'MANAGER_APPROVED', manager_id = ?, manager_approved_at = NOW(), manager_note = ?, updated_at = NOW() WHERE id = ? AND status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ps.setString(2, note != null ? note : "Trưởng phòng đã xác nhận bàn giao công việc");
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.managerApprove lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Cấp 2: HR phê duyệt chính sách & chốt nghỉ phép chính thức */
    public boolean hrApprove(int id, int hrId) {
        String sql = "UPDATE leave_requests SET status = 'APPROVED', hr_id = ?, hr_approved_at = NOW(), approved_by_id = ?, approved_at = NOW(), updated_at = NOW() WHERE id = ? AND status IN ('PENDING', 'MANAGER_APPROVED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hrId);
            ps.setInt(2, hrId);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.hrApprove lỗi: " + e.getMessage());
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

        java.sql.Date sd = rs.getDate("start_date");
        if (sd != null) lr.setStartDate(sd.toLocalDate());
        java.sql.Date ed = rs.getDate("end_date");
        if (ed != null) lr.setEndDate(ed.toLocalDate());

        double td = rs.getDouble("total_days");
        lr.setDays(td > 0 ? td : 1.0);
        lr.setTotalDays((int) Math.round(lr.getDays()));

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

        try {
            int mid = rs.getInt("manager_id");
            if (!rs.wasNull()) lr.setManagerId(mid);
            lr.setManagerName(rs.getString("manager_name"));
            Timestamp mt = rs.getTimestamp("manager_approved_at");
            if (mt != null) lr.setManagerApprovedAt(mt.toLocalDateTime());
            lr.setManagerNote(rs.getString("manager_note"));

            int hid = rs.getInt("hr_id");
            if (!rs.wasNull()) lr.setHrId(hid);
            lr.setHrName(rs.getString("hr_name"));
            Timestamp ht = rs.getTimestamp("hr_approved_at");
            if (ht != null) lr.setHrApprovedAt(ht.toLocalDateTime());

            lr.setAttachmentUrl(rs.getString("attachment_url"));
            lr.setHandoverPerson(rs.getString("handover_person"));
            String tn = rs.getString("time_note");
            if (tn != null && !tn.trim().isEmpty()) {
                lr.setTimeNote(tn);
            }
        } catch (SQLException ignored) {}

        // Ghi chú thời gian hiển thị UI nếu chưa có
        if (lr.getTimeNote() == null || lr.getTimeNote().trim().isEmpty()) {
            if (lr.getDays() == 0.5) {
                lr.setTimeNote("0.5 ngày (Nửa ngày)");
            } else {
                lr.setTimeNote(lr.getDaysDisplay() + " làm việc");
            }
        }

        if ("APPROVED".equalsIgnoreCase(lr.getStatus())) {
            lr.setManagerStatus("APPROVED");
            lr.setHrStatus("APPROVED");
        } else if ("MANAGER_APPROVED".equalsIgnoreCase(lr.getStatus())) {
            lr.setManagerStatus("APPROVED");
            lr.setHrStatus("PENDING");
        } else if ("REJECTED".equalsIgnoreCase(lr.getStatus())) {
            lr.setManagerStatus(lr.getManagerId() != null && lr.getHrId() == null ? "REJECTED" : "APPROVED");
            lr.setHrStatus(lr.getHrId() != null ? "REJECTED" : "PENDING");
        } else {
            lr.setManagerStatus("PENDING");
            lr.setHrStatus("PENDING");
        }
        return lr;
    }

    /** Dem so nhan su dang nghi phep hom nay (don APPROVED bao gom ngay hien tai). */
    public int countOnLeaveToday() {
        String sql = "SELECT COUNT(DISTINCT lr.employee_id) FROM leave_requests lr " +
                     "WHERE lr.status = 'APPROVED' AND CURRENT_DATE BETWEEN lr.start_date AND lr.end_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("LeaveDAO.countOnLeaveToday loi: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Thong ke so ngay nghi theo tung loai trong nam (chi tinh don APPROVED).
     * @return int[6]: [annualDays, sickDays, personalDays, maternityDays, unpaidDays, totalDays]
     */
    public int[] getLeaveStatsByType(int year) {
        String sql = "SELECT leave_type, COALESCE(SUM(total_days),0) AS total FROM leave_requests " +
                     "WHERE status = 'APPROVED' AND EXTRACT(YEAR FROM start_date) = ? " +
                     "GROUP BY leave_type";
        int annual = 0, sick = 0, personal = 0, maternity = 0, unpaid = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String type = rs.getString("leave_type");
                    int days = rs.getInt("total");
                    if (type == null) continue;
                    switch (type.toUpperCase()) {
                        case "ANNUAL" -> annual += days;
                        case "SICK" -> sick += days;
                        case "PERSONAL", "WEDDING" -> personal += days;
                        case "MATERNITY" -> maternity += days;
                        case "UNPAID" -> unpaid += days;
                        default -> {}
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.getLeaveStatsByType loi: " + e.getMessage());
        }
        int total = annual + sick + personal + maternity + unpaid;
        return new int[]{annual, sick, personal, maternity, unpaid, total};
    }

    /** Dem so don PENDING duoc tao trong 24h qua. */
    public int countPending24h() {
        String sql = "SELECT COUNT(*) FROM leave_requests " +
                     "WHERE status = 'PENDING' AND created_at >= NOW() - INTERVAL '24 hours'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("LeaveDAO.countPending24h loi: " + e.getMessage());
        }
        return 0;
    }

    /** Dem so don PENDING cua phong ban cu the (danh cho Manager view). */
    public int countPendingByDepartment(int departmentId) {
        String sql = "SELECT COUNT(*) FROM leave_requests lr " +
                     "JOIN employees e ON lr.employee_id = e.id " +
                     "WHERE lr.status = 'PENDING' AND e.department_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.countPendingByDepartment loi: " + e.getMessage());
        }
        return 0;
    }

    /** Dem so nhan su dang nghi hom nay trong phong ban cu the (Manager). */
    public int countOnLeaveTodayByDepartment(int departmentId) {
        String sql = "SELECT COUNT(DISTINCT lr.employee_id) FROM leave_requests lr " +
                     "JOIN employees e ON lr.employee_id = e.id " +
                     "WHERE lr.status = 'APPROVED' AND CURRENT_DATE BETWEEN lr.start_date AND lr.end_date " +
                     "AND e.department_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.countOnLeaveTodayByDepartment loi: " + e.getMessage());
        }
        return 0;
    }

    /** Tinh so ngay phep da dung trong nam cua mot nhan vien. */
    public double countUsedDaysByEmployee(int employeeId, int year) {
        String sql = "SELECT COALESCE(SUM(total_days), 0) FROM leave_requests " +
                     "WHERE employee_id = ? AND status = 'APPROVED' " +
                     "AND EXTRACT(YEAR FROM start_date) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.countUsedDaysByEmployee loi: " + e.getMessage());
        }
        return 0.0;
    }

    /** Dem so don PENDING cua nhan vien cu the. */
    public int countPendingByEmployee(int employeeId) {
        String sql = "SELECT COUNT(*) FROM leave_requests WHERE employee_id = ? AND status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.countPendingByEmployee loi: " + e.getMessage());
        }
        return 0;
    }

    /** Lay ma don PENDING moi nhat cua nhan vien (de hien thi tren the Employee KPI). */
    public String getLatestPendingCode(int employeeId) {
        String sql = "SELECT leave_code FROM leave_requests WHERE employee_id = ? AND status = 'PENDING' " +
                     "ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.getLatestPendingCode loi: " + e.getMessage());
        }
        return null;
    }

    /** Hủy đơn nghỉ phép (hỗ trợ PENDING, MANAGER_APPROVED hoặc APPROVED). */
    public boolean cancelLeave(int leaveId, int employeeId) {
        String sql = (employeeId > 0)
                ? "UPDATE leave_requests SET status = 'CANCELLED', updated_at = NOW() WHERE id = ? AND employee_id = ? AND status IN ('PENDING', 'MANAGER_APPROVED', 'APPROVED')"
                : "UPDATE leave_requests SET status = 'CANCELLED', updated_at = NOW() WHERE id = ? AND status IN ('PENDING', 'MANAGER_APPROVED', 'APPROVED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, leaveId);
            if (employeeId > 0) {
                ps.setInt(2, employeeId);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.cancelLeave loi: " + e.getMessage());
        }
        return false;
    }

    /** Kiểm tra xem nhân viên có đơn nghỉ phép nào trùng khoảng thời gian (PENDING hoặc APPROVED) không. */
    public boolean hasOverlappingLeave(int employeeId, LocalDate startDate, LocalDate endDate, Integer excludeId) {
        if (startDate == null || endDate == null) return false;
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM leave_requests " +
                "WHERE employee_id = ? " +
                "  AND status IN ('PENDING', 'MANAGER_APPROVED', 'APPROVED') " +
                "  AND start_date <= ? AND end_date >= ? ");
        if (excludeId != null && excludeId > 0) {
            sql.append("AND id != ? ");
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, employeeId);
            ps.setDate(2, java.sql.Date.valueOf(endDate));
            ps.setDate(3, java.sql.Date.valueOf(startDate));
            if (excludeId != null && excludeId > 0) {
                ps.setInt(4, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return true;
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.hasOverlappingLeave lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Tự động sinh mã đơn nghỉ phép kế tiếp theo thứ tự tuần tự (dạng LP-YYYY-XXX). */
    public String generateNextLeaveCode(LocalDate date) {
        int year = (date != null) ? date.getYear() : LocalDate.now().getYear();
        String prefix = "LP-" + year + "-";
        String sql = "SELECT leave_code FROM leave_requests WHERE leave_code LIKE ? ORDER BY leave_code DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String lastCode = rs.getString(1);
                    if (lastCode != null && lastCode.length() > prefix.length()) {
                        String numPart = lastCode.substring(prefix.length());
                        try {
                            int num = Integer.parseInt(numPart.replaceAll("\\D+", ""));
                            return String.format("%s%03d", prefix, num + 1);
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("LeaveDAO.generateNextLeaveCode lỗi: " + e.getMessage());
        }
        return prefix + "001";
    }

    /** Tong so ngay cong ty da su dung phep trong nam (cho Admin/HR KPI). */
    public int countTotalUsedDays(int year) {
        String sql = "SELECT COALESCE(SUM(total_days), 0) FROM leave_requests " +
                     "WHERE status = 'APPROVED' AND EXTRACT(YEAR FROM start_date) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.countTotalUsedDays loi: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Thống kê số ngày nghỉ theo từng loại trong năm dưới dạng Map (chi tính đơn APPROVED).
     * @return Map với key = loại nghỉ (ANNUAL, SICK, PERSONAL, MATERNITY, UNPAID), value = tổng ngày
     */
    public Map<String, Integer> getLeaveStatsMap(int year) {
        String sql = "SELECT leave_type, COALESCE(SUM(total_days), 0) AS total FROM leave_requests " +
                     "WHERE status = 'APPROVED' AND EXTRACT(YEAR FROM start_date) = ? " +
                     "GROUP BY leave_type";
        Map<String, Integer> stats = new LinkedHashMap<>();
        stats.put("ANNUAL",    0);
        stats.put("SICK",      0);
        stats.put("PERSONAL",  0);
        stats.put("MATERNITY", 0);
        stats.put("UNPAID",    0);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String type = rs.getString("leave_type");
                    int days = rs.getInt("total");
                    if (type == null) continue;
                    switch (type.toUpperCase()) {
                        case "ANNUAL" -> stats.merge("ANNUAL", days, Integer::sum);
                        case "SICK" -> stats.merge("SICK", days, Integer::sum);
                        case "PERSONAL", "WEDDING" -> stats.merge("PERSONAL", days, Integer::sum);
                        case "MATERNITY" -> stats.merge("MATERNITY", days, Integer::sum);
                        case "UNPAID" -> stats.merge("UNPAID", days, Integer::sum);
                        default -> {}
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.getLeaveStatsMap loi: " + e.getMessage());
        }
        return stats;
    }

    /**
     * Đếm số nhân sự vắng mặt (đơn APPROVED) từng ngày trong khoảng tuần.
     * @return Map<LocalDate, Integer> số người nghỉ theo từng ngày
     */
    public Map<LocalDate, Integer> getWeeklyAbsences(LocalDate weekStart, LocalDate weekEnd) {
        Map<LocalDate, Integer> result = new LinkedHashMap<>();
        // Khởi tạo 0 cho tất cả các ngày trong tuần
        LocalDate d = weekStart;
        while (!d.isAfter(weekEnd)) {
            result.put(d, 0);
            d = d.plusDays(1);
        }
        String sql = "SELECT lr.employee_id, lr.start_date, lr.end_date " +
                     "FROM leave_requests lr " +
                     "WHERE lr.status = 'APPROVED' " +
                     "AND lr.end_date >= ? AND lr.start_date <= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(weekStart));
            ps.setDate(2, java.sql.Date.valueOf(weekEnd));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.sql.Date sd = rs.getDate("start_date");
                    java.sql.Date ed = rs.getDate("end_date");
                    if (sd == null || ed == null) continue;
                    LocalDate start = sd.toLocalDate();
                    LocalDate end   = ed.toLocalDate();
                    LocalDate cur = start.isBefore(weekStart) ? weekStart : start;
                    LocalDate fin = end.isAfter(weekEnd) ? weekEnd : end;
                    while (!cur.isAfter(fin)) {
                        result.merge(cur, 1, Integer::sum);
                        cur = cur.plusDays(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.getWeeklyAbsences loi: " + e.getMessage());
        }
        return result;
    }

    /**
     * Tính số dư phép khả dụng của một nhân viên (theo Điều 113-114 BLLĐ 2019):
     * - Tích lũy phép lũy tiến từng tháng đối với nhân viên năm đầu: 1 tháng = 1 ngày (không cấp bừa 12 ngày).
     * - Hạn chót phép tồn năm cũ: Sau ngày 31/03, số ngày carry-over tự động hết hiệu lực (= 0.0).
     */
    public double calculateLeaveBalance(int employeeId, int year, LocalDate requestDate, LocalDate empStartDate) {
        double standard = 12.0;
        int startYear = (empStartDate != null) ? empStartDate.getYear() : year;
        long yearsOfSvc = Math.max(0, year - startYear);

        // Quy tắc 1: Nhân viên mới vào làm trong năm (thâm niên < 1 năm): tích lũy theo tháng làm việc
        if (empStartDate != null && empStartDate.getYear() == year) {
            int currentMonth = (requestDate != null) ? requestDate.getMonthValue() : LocalDate.now().getMonthValue();
            int startMonth = empStartDate.getMonthValue();
            standard = Math.min(12.0, Math.max(1.0, (double) (currentMonth - startMonth + 1)));
        }

        // Quy tắc 2: Thâm niên 5 năm cộng 1 ngày phép
        double seniority = Math.floor((double) yearsOfSvc / 5);

        // Quy tắc 3: Phép tồn năm cũ chỉ được dùng đến hết 31/03 của năm sau
        LocalDate checkDate = (requestDate != null) ? requestDate : LocalDate.now();
        double carryOver = 0.0;
        if (yearsOfSvc > 0 && !checkDate.isAfter(LocalDate.of(year, 3, 31))) {
            carryOver = Math.min(3.0, 5.0);
        }

        double used = countUsedDaysByEmployee(employeeId, year);
        double available = standard + seniority + carryOver - used;
        return Math.max(0, available);
    }

    public double calculateLeaveBalance(int employeeId, int year, int startYear) {
        return calculateLeaveBalance(employeeId, year, LocalDate.now(), LocalDate.of(startYear, 1, 1));
    }

    /** Lấy danh sách ngày nghỉ lễ quốc gia trong năm */
    public List<Holiday> getHolidaysByYear(int year) {
        List<Holiday> list = new ArrayList<>();
        String sql = "SELECT id, holiday_date, name, year, coefficient FROM holidays WHERE year = ? ORDER BY holiday_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Holiday h = new Holiday();
                    h.setId(rs.getInt("id"));
                    java.sql.Date hd = rs.getDate("holiday_date");
                    if (hd != null) h.setHolidayDate(hd.toLocalDate());
                    h.setName(rs.getString("name"));
                    h.setYear(rs.getInt("year"));
                    h.setCoefficient(rs.getDouble("coefficient"));
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.getHolidaysByYear loi: " + e.getMessage());
        }
        return list;
    }

    /** Lấy tập hợp các ngày nghỉ lễ để đối soát ngày công */
    public Set<LocalDate> getHolidayDates(int year) {
        Set<LocalDate> dates = new HashSet<>();
        String sql = "SELECT holiday_date FROM holidays WHERE year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.sql.Date hd = rs.getDate("holiday_date");
                    if (hd != null) dates.add(hd.toLocalDate());
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.getHolidayDates loi: " + e.getMessage());
        }
        return dates;
    }

    /**
     * Tính tỷ lệ vắng mặt (%) của phòng ban trong một ngày cụ thể (đơn PENDING hoặc APPROVED).
     */
    public double getDepartmentAbsenceRateOnDate(int departmentId, LocalDate date, Integer excludeRequestId) {
        if (departmentId <= 0 || date == null) return 0.0;
        String countEmpSql = "SELECT COUNT(*) FROM employees WHERE department_id = ? AND status NOT IN ('INACTIVE', 'TERMINATED')";
        String countLeaveSql = "SELECT COUNT(DISTINCT lr.employee_id) FROM leave_requests lr " +
                               "JOIN employees e ON lr.employee_id = e.id " +
                               "WHERE e.department_id = ? AND lr.status IN ('PENDING', 'MANAGER_APPROVED', 'APPROVED') " +
                               "AND ? BETWEEN lr.start_date AND lr.end_date " +
                               (excludeRequestId != null && excludeRequestId > 0 ? "AND lr.id != ? " : "");
        try (Connection conn = DBConnection.getConnection()) {
            int totalEmp = 0;
            try (PreparedStatement ps = conn.prepareStatement(countEmpSql)) {
                ps.setInt(1, departmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalEmp = rs.getInt(1);
                }
            }
            if (totalEmp <= 0) return 0.0;

            int leaveCount = 0;
            try (PreparedStatement ps = conn.prepareStatement(countLeaveSql)) {
                ps.setInt(1, departmentId);
                ps.setDate(2, java.sql.Date.valueOf(date));
                if (excludeRequestId != null && excludeRequestId > 0) {
                    ps.setInt(3, excludeRequestId);
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) leaveCount = rs.getInt(1);
                }
            }
            return (double) Math.round((double) leaveCount * 100.0 / (double) totalEmp * 10.0) / 10.0;
        } catch (SQLException e) {
            System.err.println("LeaveDAO.getDepartmentAbsenceRateOnDate loi: " + e.getMessage());
        }
        return 0.0;
    }

    /**
     * Lấy danh sách tồn phép của tất cả nhân viên đang hoạt động.
     * Dùng cho tab=balance trong leave-list.jsp.
     * @param year năm tính
     * @return List<EmployeeLeaveBalance> đã sắp xếp theo tên nhân viên
     */
    public List<EmployeeLeaveBalance> getAllLeaveBalances(int year) {
        List<EmployeeLeaveBalance> result = new ArrayList<>();
        String sql = "SELECT e.id, e.employee_code, e.full_name, e.start_date, " +
                     "d.name AS dept_name, p.name AS pos_name, " +
                     "COALESCE((SELECT SUM(lr.total_days) FROM leave_requests lr " +
                     "          WHERE lr.employee_id = e.id AND lr.status = 'APPROVED' " +
                     "          AND EXTRACT(YEAR FROM lr.start_date) = ?), 0) AS used_days " +
                     "FROM employees e " +
                     "LEFT JOIN departments d ON e.department_id = d.id " +
                     "LEFT JOIN positions p ON e.position_id = p.id " +
                     "WHERE e.status NOT IN ('INACTIVE', 'TERMINATED') " +
                     "ORDER BY e.full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EmployeeLeaveBalance bal = new EmployeeLeaveBalance();
                    bal.setEmployeeId(rs.getInt("id"));
                    bal.setEmployeeCode(rs.getString("employee_code"));
                    bal.setFullName(rs.getString("full_name"));
                    bal.setDepartmentName(rs.getString("dept_name"));
                    bal.setPositionName(rs.getString("pos_name"));

                    java.sql.Date sd = rs.getDate("start_date");
                    if (sd != null) bal.setStartDate(sd.toLocalDate());

                    long yearsOfSvc = (sd != null)
                        ? ChronoUnit.YEARS.between(sd.toLocalDate(), LocalDate.now())
                        : 0;
                    bal.setYearsOfService((int) yearsOfSvc);

                    double standard  = 12.0;
                    if (sd != null && sd.toLocalDate().getYear() == year) {
                        standard = Math.min(12.0, Math.max(1.0, (double) (LocalDate.now().getMonthValue() - sd.toLocalDate().getMonthValue() + 1)));
                    }
                    double seniority = Math.floor((double) yearsOfSvc / 5);
                    double carryOver = (yearsOfSvc > 0 && !LocalDate.now().isAfter(LocalDate.of(year, 3, 31))) ? Math.min(3.0, 5.0) : 0.0;
                    double used      = rs.getDouble("used_days");
                    double available = Math.max(0, standard + seniority + carryOver - used);

                    bal.setStandardDays(standard);
                    bal.setSeniorityDays(seniority);
                    bal.setCarryOverDays(carryOver);
                    bal.setUsedDays(used);
                    bal.setAvailableDays(available);
                    result.add(bal);
                }
            }
        } catch (SQLException e) {
            System.err.println("LeaveDAO.getAllLeaveBalances loi: " + e.getMessage());
        }
        return result;
    }
}

