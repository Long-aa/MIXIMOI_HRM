package com.miximoi.hrm.util;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Tiện ích đồng bộ CSDL:
 * 1. Nâng cấp schema (thêm các cột còn thiếu trong attendance, overtime, leave_requests).
 * 2. Tự động nạp dữ liệu mẫu vào PostgreSQL nếu bảng còn trống (overtime, attendance, leave_requests).
 * 3. Đảm bảo hỗ trợ chấm công bằng FaceID và Vân tay (Fingerprint).
 */
public class DatabaseInitializer {

    private static boolean initialized = false;

    public static synchronized void initialize() {
        if (initialized) return;

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Đồng bộ các cột còn thiếu trong DB
            migrateSchema(conn);

            // 2. Nạp dữ liệu Overtime vào PostgreSQL nếu trống
            seedOvertimeIfEmpty(conn);

            // 3. Nạp dữ liệu Nghỉ phép vào PostgreSQL nếu trống
            seedLeaveRequestsIfEmpty(conn);

            // 4. Đồng bộ trạng thái nhân sự (Đang nghỉ phép, Nghỉ việc)
            syncEmployeeStatuses(conn);

            // 5. Nạp dữ liệu Chấm công hôm nay (FaceID, Vân tay) nếu trống
            seedAttendanceIfEmpty(conn);

            initialized = true;
            System.out.println("[DatabaseInitializer] Đồng bộ CSDL và dữ liệu mẫu thành công!");
        } catch (SQLException e) {
            System.err.println("[DatabaseInitializer] Lỗi đồng bộ CSDL: " + e.getMessage());
        }
    }

    private static void migrateSchema(Connection conn) {
        String[] alterSqls = {
            // Bảng attendance: Thêm cột phương thức chấm công (FaceID / Fingerprint / GPS / Manual)
            "ALTER TABLE attendance ADD COLUMN IF NOT EXISTS method VARCHAR(50) DEFAULT 'FaceID'",

            // Bảng overtime: Thêm các trường khớp với UI & nghiệp vụ 2 cấp duyệt
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS project_name VARCHAR(255)",
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS start_time TIME",
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS end_time TIME",
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS ot_type VARCHAR(50) DEFAULT 'REGULAR'",
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS lead_approver_id INTEGER",
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS lead_status VARCHAR(20) DEFAULT 'PENDING'",
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS lead_approved_at TIMESTAMP",
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS hr_status VARCHAR(20) DEFAULT 'PENDING'",
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS reject_reason TEXT",

            // Bảng leave_requests: Thêm các trường khớp với UI
            "ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS handover_person VARCHAR(150)",
            "ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS manager_status VARCHAR(20) DEFAULT 'PENDING'",
            "ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS hr_status VARCHAR(20) DEFAULT 'PENDING'",
            "ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS days NUMERIC(4,1) DEFAULT 1.0",
            "ALTER TABLE leave_requests ADD COLUMN IF NOT EXISTS time_note VARCHAR(255)",

            // Bảng contracts: Thêm các trường pháp lý Bộ luật Lao động 2019
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS signer_name VARCHAR(200)",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS signer_title VARCHAR(100)",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS work_location VARCHAR(300)",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS job_description TEXT",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS probation_months INTEGER DEFAULT 0",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS probation_salary_pct NUMERIC(5,2) DEFAULT 85.0",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS allowance_amount NUMERIC(15,0) DEFAULT 0",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS signed_date DATE",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS identity_number VARCHAR(20)",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS identity_date DATE",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS identity_place VARCHAR(200)",
            "ALTER TABLE contracts ADD COLUMN IF NOT EXISTS contract_file_url VARCHAR(500)",

            // Bảng departments: code, manager_id, status
            "ALTER TABLE departments ADD COLUMN IF NOT EXISTS code VARCHAR(20)",
            "ALTER TABLE departments ADD COLUMN IF NOT EXISTS manager_id INTEGER REFERENCES employees(id)",
            "ALTER TABLE departments ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'ACTIVE'",
            "ALTER TABLE departments ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP",

            // Bảng attendance: device_id, device_name, etc.
            "ALTER TABLE attendance ADD COLUMN IF NOT EXISTS device_id VARCHAR(50)",
            "ALTER TABLE attendance ADD COLUMN IF NOT EXISTS device_name VARCHAR(150)",
            "ALTER TABLE attendance ADD COLUMN IF NOT EXISTS check_out_method VARCHAR(50)",
            "ALTER TABLE attendance ADD COLUMN IF NOT EXISTS face_image_url VARCHAR(255)",
            "ALTER TABLE attendance ADD COLUMN IF NOT EXISTS confidence_score NUMERIC(5,2)",

            // Bảng biometric_devices
            "CREATE TABLE IF NOT EXISTS biometric_devices ("
            + "id SERIAL PRIMARY KEY, device_code VARCHAR(50) NOT NULL UNIQUE, name VARCHAR(150) NOT NULL, "
            + "type VARCHAR(30) NOT NULL, location VARCHAR(200), ip_address VARCHAR(50), mac_address VARCHAR(50), "
            + "firmware VARCHAR(50), status VARCHAR(20) NOT NULL DEFAULT 'ONLINE', department_id INTEGER REFERENCES departments(id), "
            + "notes TEXT, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP)",

            // Bảng employee_biometrics
            "CREATE TABLE IF NOT EXISTS employee_biometrics ("
            + "id SERIAL PRIMARY KEY, employee_id INTEGER NOT NULL REFERENCES employees(id) UNIQUE, "
            + "fingerprint_template_1 TEXT, fingerprint_template_2 TEXT, fingerprint_enrolled BOOLEAN NOT NULL DEFAULT FALSE, "
            + "fingerprint_device_id INTEGER, fingerprint_enrolled_at TIMESTAMP, face_image_url VARCHAR(255), "
            + "face_embedding_ref TEXT, face_enrolled BOOLEAN NOT NULL DEFAULT FALSE, face_device_id INTEGER, "
            + "face_enrolled_at TIMESTAMP, employee_card_id VARCHAR(50), active BOOLEAN NOT NULL DEFAULT TRUE, "
            + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP)",

            // ===== Bảng employees: bổ sung các trường còn thiếu để đồng bộ với UI =====
            // Thông tin CCCD/CMND
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS identity_number VARCHAR(20)",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS identity_date DATE",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS identity_place VARCHAR(200)",
            // Địa chỉ tạm trú
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS temp_address VARCHAR(500)",
            // Quốc tịch / dân tộc
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS nationality VARCHAR(100) DEFAULT 'Việt Nam'",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS ethnicity VARCHAR(100)",
            // Ảnh đại diện
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(500)",
            // Lương cơ bản (đồng bộ với contract/payroll)
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS base_salary NUMERIC(15,0) DEFAULT 0",
            // Số tài khoản ngân hàng cho payroll
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS bank_account VARCHAR(30)",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS bank_name VARCHAR(150)",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS bank_branch VARCHAR(200)",
            // Bảo hiểm xã hội / y tế
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS insurance_number VARCHAR(20)",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS tax_code VARCHAR(20)",
            // Thông tin người thân liên hệ khẩn cấp
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS emergency_contact_name VARCHAR(150)",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS emergency_contact_phone VARCHAR(20)",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS emergency_contact_relation VARCHAR(50)",
            // Ngày kết thúc/thôi việc
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS end_date DATE",
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS termination_reason TEXT"
        };

        for (String sql : alterSqls) {
            try (Statement st = conn.createStatement()) {
                st.execute(sql);
            } catch (SQLException e) {
                System.err.println("[DatabaseInitializer] Migrate cảnh báo: " + e.getMessage());
            }
        }
    }

    private static void seedOvertimeIfEmpty(Connection conn) throws SQLException {
        String countSql = "SELECT COUNT(*) FROM overtime";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(countSql)) {
            if (rs.next() && rs.getInt(1) > 0) return; // Đã có dữ liệu
        }

        // Lấy danh sách nhân viên để liên kết
        List<Integer> empIds = new ArrayList<>();
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT id FROM employees WHERE status = 'ACTIVE' ORDER BY id LIMIT 10")) {
            while (rs.next()) empIds.add(rs.getInt(1));
        }

        if (empIds.isEmpty()) return;

        int e1 = empIds.get(0);
        int e2 = empIds.size() > 1 ? empIds.get(1) : e1;
        int e3 = empIds.size() > 2 ? empIds.get(2) : e1;
        int e4 = empIds.size() > 3 ? empIds.get(3) : e1;
        int e5 = empIds.size() > 4 ? empIds.get(4) : e1;

        String insertSql = "INSERT INTO overtime (employee_id, overtime_date, start_time, end_time, hours, coefficient, amount, "
                         + "project_name, ot_type, reason, lead_approver_id, lead_status, hr_status, status, created_at) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW() - INTERVAL '1 day')";

        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            // 1. Release v4.2 - Core Banking (Chờ duyệt HR)
            ps.setInt(1, e1);
            ps.setDate(2, Date.valueOf(LocalDate.now()));
            ps.setTime(3, Time.valueOf(LocalTime.of(18, 0)));
            ps.setTime(4, Time.valueOf(LocalTime.of(21, 30)));
            ps.setDouble(5, 3.5);
            ps.setDouble(6, 1.5);
            ps.setBigDecimal(7, new BigDecimal("1250000"));
            ps.setString(8, "Release v4.2 - Core Banking — Chuyển đổi số ngân hàng V");
            ps.setString(9, "REGULAR");
            ps.setString(10, "Triển khai release v4.2 và migrate cơ sở dữ liệu sau giờ giao dịch");
            ps.setInt(11, e2);
            ps.setString(12, "APPROVED");
            ps.setString(13, "PENDING");
            ps.setString(14, "PENDING_HR");
            ps.addBatch();

            // 2. Design System v3 & Mobile UI Sprint 44 (Đã duyệt)
            ps.setInt(1, e2);
            ps.setDate(2, Date.valueOf(LocalDate.now().minusDays(1)));
            ps.setTime(3, Time.valueOf(LocalTime.of(18, 30)));
            ps.setTime(4, Time.valueOf(LocalTime.of(20, 30)));
            ps.setDouble(5, 2.0);
            ps.setDouble(6, 1.5);
            ps.setBigDecimal(7, new BigDecimal("650000"));
            ps.setString(8, "Design System v3 & Mobile UI Sprint 44");
            ps.setString(9, "REGULAR");
            ps.setString(10, "Hoàn thiện bộ component Figma và bàn giao team Frontend cho sprint");
            ps.setInt(11, e1);
            ps.setString(12, "APPROVED");
            ps.setString(13, "APPROVED");
            ps.setString(14, "APPROVED");
            ps.addBatch();

            // 3. Sự cố tắc nghẽn Database cluster (Đã duyệt)
            ps.setInt(1, e3);
            ps.setDate(2, Date.valueOf(LocalDate.now().minusDays(2)));
            ps.setTime(3, Time.valueOf(LocalTime.of(19, 0)));
            ps.setTime(4, Time.valueOf(LocalTime.of(23, 0)));
            ps.setDouble(5, 4.0);
            ps.setDouble(6, 2.0);
            ps.setBigDecimal(7, new BigDecimal("1800000"));
            ps.setString(8, "Sự cố tắc nghẽn Database cluster & Xử lý dữ liệu thanh toán");
            ps.setString(9, "NIGHT");
            ps.setString(10, "Xử lý timeout transaction và phân tích deadlock log");
            ps.setInt(11, e1);
            ps.setString(12, "APPROVED");
            ps.setString(13, "APPROVED");
            ps.setString(14, "APPROVED");
            ps.addBatch();

            // 4. Kiểm thử tải cao điểm Black Friday (Chờ Lead duyệt)
            ps.setInt(1, e4);
            ps.setDate(2, Date.valueOf(LocalDate.now()));
            ps.setTime(3, Time.valueOf(LocalTime.of(18, 0)));
            ps.setTime(4, Time.valueOf(LocalTime.of(21, 0)));
            ps.setDouble(5, 3.0);
            ps.setDouble(6, 1.5);
            ps.setBigDecimal(7, new BigDecimal("1100000"));
            ps.setString(8, "Tối ưu hóa Pipeline CI/CD và Kubernetes cluster cho Core Banking");
            ps.setString(9, "REGULAR");
            ps.setString(10, "Nâng cấp cụm worker nodes và vá lỗ hổng bảo mật hạ tầng mạng");
            ps.setInt(11, e1);
            ps.setString(12, "PENDING");
            ps.setString(13, "PENDING");
            ps.setString(14, "PENDING_LEAD");
            ps.addBatch();

            ps.executeBatch();
            System.out.println("[DatabaseInitializer] Đã nạp 4 bản ghi Overtime mẫu vào PostgreSQL!");
        }
    }

    private static void seedAttendanceIfEmpty(Connection conn) throws SQLException {
        LocalDate today = LocalDate.now();
        String countSql = "SELECT COUNT(*) FROM attendance WHERE work_date = ?";
        try (PreparedStatement ps = conn.prepareStatement(countSql)) {
            ps.setDate(1, Date.valueOf(today));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return;
            }
        }

        List<Integer> empIds = new ArrayList<>();
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT id FROM employees WHERE status = 'ACTIVE' ORDER BY id LIMIT 32")) {
            while (rs.next()) empIds.add(rs.getInt(1));
        }

        if (empIds.isEmpty()) return;

        String insertSql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes, method) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT (employee_id, work_date) DO NOTHING";

        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (int i = 0; i < empIds.size(); i++) {
                int empId = empIds.get(i);
                String method = (i % 2 == 0) ? "FaceID" : "Fingerprint";
                String status;
                LocalTime ci = null, co = null;
                double hrs = 0;
                String notes;

                int mod = i % 10;
                if (mod < 6) {
                    status = "ON_TIME";
                    ci = LocalTime.of(8, 15 + (i % 12));
                    co = LocalTime.of(17, 30 + (i % 20));
                    hrs = 9.0;
                    notes = "Xác thực qua máy chấm công " + method;
                } else if (mod < 8) {
                    status = "LATE";
                    int late = 10 + (i * 3) % 30;
                    ci = LocalTime.of(8, 35).plusMinutes(late);
                    co = LocalTime.of(17, 35);
                    hrs = 8.0;
                    notes = "Đi muộn " + late + " phút (Máy " + method + ")";
                } else if (mod == 8) {
                    status = "WFH";
                    method = "GPS";
                    ci = LocalTime.of(8, 5);
                    co = LocalTime.of(17, 10);
                    hrs = 8.0;
                    notes = "WFH — GPS Mobile xác thực";
                } else {
                    status = (i % 2 == 0) ? "ON_LEAVE" : "ABSENT";
                    notes = (i % 2 == 0) ? "Nghỉ phép năm đã duyệt" : "Chưa chấm công";
                }

                ps.setInt(1, empId);
                ps.setDate(2, Date.valueOf(today));
                ps.setTime(3, ci != null ? Time.valueOf(ci) : null);
                ps.setTime(4, co != null ? Time.valueOf(co) : null);
                ps.setDouble(5, hrs);
                ps.setString(6, status);
                ps.setString(7, notes);
                ps.setString(8, method);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[DatabaseInitializer] Đã nạp " + empIds.size() + " bản ghi chấm công hôm nay vào PostgreSQL!");
        }
    }

    private static void seedLeaveRequestsIfEmpty(Connection conn) throws SQLException {
        String countSql = "SELECT COUNT(*) FROM leave_requests";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(countSql)) {
            if (rs.next() && rs.getInt(1) >= 4) return; // Đã có dữ liệu đầy đủ
        }

        List<Integer> empIds = new ArrayList<>();
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT id FROM employees ORDER BY id LIMIT 10")) {
            while (rs.next()) empIds.add(rs.getInt(1));
        }

        if (empIds.isEmpty()) return;

        int e1 = empIds.get(0);
        int e2 = empIds.size() > 1 ? empIds.get(1) : e1;
        int e3 = empIds.size() > 2 ? empIds.get(2) : e1;
        int e4 = empIds.size() > 3 ? empIds.get(3) : e1;
        int e5 = empIds.size() > 4 ? empIds.get(4) : e1;
        int e6 = empIds.size() > 5 ? empIds.get(5) : e1;
        int e7 = empIds.size() > 6 ? empIds.get(6) : e1;
        int e8 = empIds.size() > 7 ? empIds.get(7) : e1;

        LocalDate today = LocalDate.now();

        String insertSql = "INSERT INTO leave_requests (leave_code, employee_id, leave_type, start_date, end_date, total_days, "
                         + "reason, status, approved_by_id, approved_at, reject_reason, handover_person, manager_status, hr_status, created_at) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW() - INTERVAL '1 day') "
                         + "ON CONFLICT (leave_code) DO NOTHING";

        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            // 1. Nhân viên e4 (Kỹ thuật): Nghỉ phép năm ĐÃ DUYỆT (Bao gồm ngày hôm nay)
            ps.setString(1, "LP-2026-001");
            ps.setInt(2, e4);
            ps.setString(3, "ANNUAL");
            ps.setDate(4, Date.valueOf(today.minusDays(1)));
            ps.setDate(5, Date.valueOf(today.plusDays(1)));
            ps.setInt(6, 3);
            ps.setString(7, "Nghỉ phép thường niên cùng gia đình");
            ps.setString(8, "APPROVED");
            ps.setInt(9, e1);
            ps.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now().minusDays(2)));
            ps.setString(11, null);
            ps.setString(12, "Đặng Văn Giang — 0967890123 (R&D)");
            ps.setString(13, "APPROVED");
            ps.setString(14, "APPROVED");
            ps.addBatch();

            // 2. Nhân viên e6 (Marketing): Nghỉ ốm đau BHXH ĐÃ DUYỆT (Bao gồm ngày hôm nay)
            ps.setString(1, "LP-2026-002");
            ps.setInt(2, e6);
            ps.setString(3, "SICK");
            ps.setDate(4, Date.valueOf(today));
            ps.setDate(5, Date.valueOf(today.plusDays(1)));
            ps.setInt(6, 2);
            ps.setString(7, "Điều trị cảm sốt cấp tính theo chỉ định y tế tại BV Đa khoa");
            ps.setString(8, "APPROVED");
            ps.setInt(9, e2);
            ps.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now().minusDays(1)));
            ps.setString(11, null);
            ps.setString(12, "Bùi Thị Hoa — 0978901234 (HR/Admin)");
            ps.setString(13, "APPROVED");
            ps.setString(14, "APPROVED");
            ps.addBatch();

            // 3. Nhân viên e5 (Kinh doanh): Nghỉ phép năm ĐANG CHỜ DUYỆT
            ps.setString(1, "LP-2026-003");
            ps.setInt(2, e5);
            ps.setString(3, "ANNUAL");
            ps.setDate(4, Date.valueOf(today.plusDays(2)));
            ps.setDate(5, Date.valueOf(today.plusDays(4)));
            ps.setInt(6, 3);
            ps.setString(7, "Giải quyết việc hiếu hỉ gia đình ở quê");
            ps.setString(8, "PENDING");
            ps.setNull(9, Types.INTEGER);
            ps.setNull(10, Types.TIMESTAMP);
            ps.setString(11, null);
            ps.setString(12, "Nguyễn Văn An — 0901234567");
            ps.setString(13, "PENDING");
            ps.setString(14, "PENDING");
            ps.addBatch();

            // 4. Nhân viên e7 (Kỹ thuật): Nghỉ việc riêng kết hôn (3 ngày có lương) ĐANG CHỜ DUYỆT
            ps.setString(1, "LP-2026-004");
            ps.setInt(2, e7);
            ps.setString(3, "PERSONAL");
            ps.setDate(4, Date.valueOf(today.plusDays(5)));
            ps.setDate(5, Date.valueOf(today.plusDays(7)));
            ps.setInt(6, 3);
            ps.setString(7, "Nghỉ cưới kết hôn cá nhân (Đã gửi thiệp báo phòng HR)");
            ps.setString(8, "PENDING");
            ps.setNull(9, Types.INTEGER);
            ps.setNull(10, Types.TIMESTAMP);
            ps.setString(11, null);
            ps.setString(12, "Phạm Thị Dung — 0934567890");
            ps.setString(13, "APPROVED");
            ps.setString(14, "PENDING");
            ps.addBatch();

            // 5. Nhân viên e8 (HR): Nghỉ không hưởng lương ĐÃ TỪ CHỐI
            ps.setString(1, "LP-2026-005");
            ps.setInt(2, e8);
            ps.setString(3, "UNPAID");
            ps.setDate(4, Date.valueOf(today.plusDays(1)));
            ps.setDate(5, Date.valueOf(today.plusDays(5)));
            ps.setInt(6, 5);
            ps.setString(7, "Du lịch nước ngoài tự túc cùng bạn bè");
            ps.setString(8, "REJECTED");
            ps.setInt(9, e1);
            ps.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now().minusDays(1)));
            ps.setString(11, "Trùng thời điểm quyết toán nhân sự quý 3, đề nghị dời lịch sang tháng sau");
            ps.setString(12, "Trần Thị Bình — 0912345678");
            ps.setString(13, "REJECTED");
            ps.setString(14, "REJECTED");
            ps.addBatch();

            // 6. Nhân viên e2 (HR): Nghỉ phép năm đã sử dụng tuần trước
            ps.setString(1, "LP-2026-006");
            ps.setInt(2, e2);
            ps.setString(3, "ANNUAL");
            ps.setDate(4, Date.valueOf(today.minusDays(10)));
            ps.setDate(5, Date.valueOf(today.minusDays(9)));
            ps.setInt(6, 2);
            ps.setString(7, "Nghỉ phép năm định kỳ quý 3");
            ps.setString(8, "APPROVED");
            ps.setInt(9, e1);
            ps.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now().minusDays(12)));
            ps.setString(11, null);
            ps.setString(12, "Bùi Thị Hoa — 0978901234");
            ps.setString(13, "APPROVED");
            ps.setString(14, "APPROVED");
            ps.addBatch();

            ps.executeBatch();
            System.out.println("[DatabaseInitializer] Đã nạp danh sách Đơn nghỉ phép mẫu đa dạng vào PostgreSQL!");
        }
    }

    private static void syncEmployeeStatuses(Connection conn) throws SQLException {
        LocalDate today = LocalDate.now();

        // 1. Cập nhật nhân viên có đơn nghỉ phép APPROVED bao gồm hôm nay sang ON_LEAVE
        String updateOnLeaveSql = "UPDATE employees SET status = 'ON_LEAVE' WHERE id IN ("
                                + "SELECT employee_id FROM leave_requests "
                                + "WHERE status = 'APPROVED' AND ? BETWEEN start_date AND end_date)";
        try (PreparedStatement ps = conn.prepareStatement(updateOnLeaveSql)) {
            ps.setDate(1, Date.valueOf(today));
            int updated = ps.executeUpdate();
            if (updated > 0) {
                System.out.println("[DatabaseInitializer] Đã cập nhật " + updated + " nhân sự sang trạng thái ON_LEAVE!");
            }
        }

        // 2. Đảm bảo có ít nhất 2 nhân sự mẫu ở trạng thái INACTIVE (đã thôi việc / hết hạn hợp đồng)
        // để thẻ 'Nghỉ việc / Lưu trữ' trên UI hiển thị số liệu thực tế
        String countInactiveSql = "SELECT COUNT(*) FROM employees WHERE status IN ('INACTIVE', 'TERMINATED')";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(countInactiveSql)) {
            int inactiveCount = rs.next() ? rs.getInt(1) : 0;
            if (inactiveCount < 2) {
                // Đánh dấu 2 nhân viên cuối cùng là INACTIVE nếu chưa đủ 2
                String setInactiveSql = "UPDATE employees SET status = 'INACTIVE', end_date = COALESCE(end_date, ?), "
                                      + "termination_reason = COALESCE(termination_reason, 'Hết hạn hợp đồng thời vụ — Hoàn tất thủ tục bàn giao') "
                                      + "WHERE status NOT IN ('INACTIVE','TERMINATED','ON_LEAVE') "
                                      + "AND id IN (SELECT id FROM employees WHERE status NOT IN ('INACTIVE','TERMINATED') ORDER BY id DESC LIMIT 2)";
                try (PreparedStatement psi = conn.prepareStatement(setInactiveSql)) {
                    psi.setDate(1, Date.valueOf(today.minusDays(30)));
                    int updated = psi.executeUpdate();
                    if (updated > 0) {
                        System.out.println("[DatabaseInitializer] Đã thiết lập " + updated + " nhân viên mẫu sang trạng thái INACTIVE!");
                    }
                }
            }
        }

        // 3. Đồng bộ vào bảng chấm công hôm nay cho những ai có status ON_LEAVE
        String syncAttSql = "INSERT INTO attendance (employee_id, work_date, status, notes, method) "
                          + "SELECT lr.employee_id, ?, 'ON_LEAVE', 'Nghỉ phép theo đơn ' || lr.leave_code, 'FaceID' "
                          + "FROM leave_requests lr "
                          + "WHERE lr.status = 'APPROVED' AND ? BETWEEN lr.start_date AND lr.end_date "
                          + "ON CONFLICT (employee_id, work_date) DO UPDATE "
                          + "SET status = 'ON_LEAVE', notes = EXCLUDED.notes";
        try (PreparedStatement ps = conn.prepareStatement(syncAttSql)) {
            ps.setDate(1, Date.valueOf(today));
            ps.setDate(2, Date.valueOf(today));
            ps.executeUpdate();
        }
    }
}

