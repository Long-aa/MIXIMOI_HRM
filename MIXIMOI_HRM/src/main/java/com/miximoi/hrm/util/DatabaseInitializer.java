package com.miximoi.hrm.util;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
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

            // 3. Nạp dữ liệu Chấm công hôm nay (FaceID, Vân tay) nếu trống
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
            + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP)"
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
}
