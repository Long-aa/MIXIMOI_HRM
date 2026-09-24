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

            // 1.1 Đồng bộ thông tin mã phòng ban & trưởng phòng
            syncDepartmentMetadata(conn);

            // 1.2 Nạp dữ liệu thiết bị chấm công & sinh trắc học nếu trống
            seedBiometricsIfEmpty(conn);

            // 1.3 Nạp cấu hình hệ thống nếu trống (phục vụ AppContextListener)
            seedSystemSettingsIfEmpty(conn);

            // 2. Nạp dữ liệu Overtime vào PostgreSQL nếu trống
            seedOvertimeIfEmpty(conn);

            // 3. Nạp dữ liệu Nghỉ phép vào PostgreSQL nếu trống
            seedLeaveRequestsIfEmpty(conn);

            // 4. Đồng bộ trạng thái nhân sự (Đang nghỉ phép, Nghỉ việc)
            syncEmployeeStatuses(conn);

            // 5. Nạp dữ liệu Chấm công hôm nay (FaceID, Vân tay) nếu trống
            seedAttendanceIfEmpty(conn);

            // 6. Nạp cấu hình thang bảng lương nếu trống
            seedSalaryConfigsIfEmpty(conn);

            // 7. Nạp phụ cấp mẫu nếu trống
            seedAllowancesIfEmpty(conn);

            // 8. Nạp thưởng mẫu nếu trống
            seedBonusesIfEmpty(conn);

            // 9. Nạp khấu trừ & tạm ứng mẫu nếu trống
            seedSalaryDeductionsIfEmpty(conn);

            // 10. Nạp bảng lương & lệnh chi mẫu nếu trống
            seedPayrollAndPaymentsIfEmpty(conn);

            // 11. Nạp dữ liệu Tuyển dụng mẫu nếu trống
            seedRecruitmentIfEmpty(conn);

            // 12. Nạp dữ liệu Đánh giá KPI & Hiệu suất mẫu nếu trống
            seedPerformanceAndKpiIfEmpty(conn);

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
            "ALTER TABLE employees ADD COLUMN IF NOT EXISTS termination_reason TEXT",

            // Bảng cấu hình lương & quy chế
            "CREATE TABLE IF NOT EXISTS salary_configs ("
            + "id SERIAL PRIMARY KEY, config_key VARCHAR(50) NOT NULL UNIQUE, "
            + "config_value VARCHAR(255) NOT NULL, description TEXT, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",

            // Bảng khấu trừ & tạm ứng
            "CREATE TABLE IF NOT EXISTS salary_deductions ("
            + "id SERIAL PRIMARY KEY, employee_id INTEGER NOT NULL REFERENCES employees(id), "
            + "deduction_type VARCHAR(50) NOT NULL, amount NUMERIC(15,0) NOT NULL DEFAULT 0, "
            + "pay_month INTEGER NOT NULL, pay_year INTEGER NOT NULL, description TEXT, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)",

            // Bảng allowances: đảm bảo đủ các cột active, start_date, end_date
            "ALTER TABLE allowances ADD COLUMN IF NOT EXISTS active BOOLEAN NOT NULL DEFAULT TRUE",
            "ALTER TABLE allowances ADD COLUMN IF NOT EXISTS start_date DATE DEFAULT CURRENT_DATE",
            "ALTER TABLE allowances ADD COLUMN IF NOT EXISTS end_date DATE",

            // Bảng bonuses: đảm bảo đủ các cột pay_month, pay_year, notes
            "ALTER TABLE bonuses ADD COLUMN IF NOT EXISTS pay_month INTEGER",
            "ALTER TABLE bonuses ADD COLUMN IF NOT EXISTS pay_year INTEGER",
            "ALTER TABLE bonuses ADD COLUMN IF NOT EXISTS notes TEXT",

            // Bảng payments: Lưu lịch sử chi trả lương
            "CREATE TABLE IF NOT EXISTS payments ("
            + "id SERIAL PRIMARY KEY, payroll_id INTEGER NOT NULL REFERENCES payroll(id), "
            + "employee_id INTEGER NOT NULL REFERENCES employees(id), amount NUMERIC(15,0) NOT NULL, "
            + "payment_date DATE NOT NULL, payment_method VARCHAR(50) NOT NULL DEFAULT 'BANK_TRANSFER', "
            + "status VARCHAR(30) NOT NULL DEFAULT 'COMPLETED', notes TEXT, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)",

            // ===== Module Tuyển Dụng =====
            // Bảng recruitment_requests
            "CREATE TABLE IF NOT EXISTS recruitment_requests ("
            + "id SERIAL PRIMARY KEY, request_code VARCHAR(50) NOT NULL UNIQUE, "
            + "title VARCHAR(250) NOT NULL, department_id INTEGER REFERENCES departments(id), "
            + "position_id INTEGER REFERENCES positions(id), target_headcount INTEGER NOT NULL DEFAULT 1, "
            + "hired_count INTEGER NOT NULL DEFAULT 0, salary_min NUMERIC(15,0) DEFAULT 0, "
            + "salary_max NUMERIC(15,0) DEFAULT 0, salary_negotiable BOOLEAN DEFAULT FALSE, "
            + "deadline DATE NOT NULL, priority VARCHAR(20) NOT NULL DEFAULT 'NORMAL', "
            + "status VARCHAR(30) NOT NULL DEFAULT 'OPEN', quarter VARCHAR(20) NOT NULL DEFAULT 'Q3/2026', "
            + "assignee_id INTEGER REFERENCES employees(id), description TEXT, requirements TEXT, benefits TEXT, "
            + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP)",

            "CREATE INDEX IF NOT EXISTS idx_rec_req_status ON recruitment_requests(status)",
            "CREATE INDEX IF NOT EXISTS idx_rec_req_quarter ON recruitment_requests(quarter)",
            "CREATE INDEX IF NOT EXISTS idx_rec_req_dept ON recruitment_requests(department_id)",

            // Bảng candidates
            "CREATE TABLE IF NOT EXISTS candidates ("
            + "id SERIAL PRIMARY KEY, candidate_code VARCHAR(50) NOT NULL UNIQUE, "
            + "full_name VARCHAR(200) NOT NULL, email VARCHAR(150), phone VARCHAR(20), "
            + "recruitment_request_id INTEGER NOT NULL REFERENCES recruitment_requests(id) ON DELETE CASCADE, "
            + "source VARCHAR(50) NOT NULL DEFAULT 'LinkedIn', "
            + "stage VARCHAR(50) NOT NULL DEFAULT 'NEW', "
            + "experience_years NUMERIC(4,1) DEFAULT 0, expected_salary NUMERIC(15,0) DEFAULT 0, "
            + "cv_url VARCHAR(255), notes TEXT, applied_date DATE NOT NULL DEFAULT CURRENT_DATE, "
            + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)",

            "CREATE INDEX IF NOT EXISTS idx_cand_request ON candidates(recruitment_request_id)",
            "CREATE INDEX IF NOT EXISTS idx_cand_stage ON candidates(stage)",
            "CREATE INDEX IF NOT EXISTS idx_cand_source ON candidates(source)",

            // Bảng interviews
            "CREATE TABLE IF NOT EXISTS interviews ("
            + "id SERIAL PRIMARY KEY, candidate_id INTEGER NOT NULL REFERENCES candidates(id) ON DELETE CASCADE, "
            + "recruitment_request_id INTEGER REFERENCES recruitment_requests(id) ON DELETE CASCADE, "
            + "interviewer_id INTEGER REFERENCES employees(id), round_name VARCHAR(150) NOT NULL, "
            + "interview_date DATE NOT NULL, interview_time TIME NOT NULL, "
            + "location_or_link VARCHAR(255) DEFAULT 'Phòng họp Tầng 3 (HQ)', "
            + "status VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED', feedback TEXT, score NUMERIC(3,1), "
            + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)",

            "CREATE INDEX IF NOT EXISTS idx_interview_date ON interviews(interview_date)",
            "CREATE INDEX IF NOT EXISTS idx_interview_cand ON interviews(candidate_id)",

            // Bảng system_settings
            "CREATE TABLE IF NOT EXISTS system_settings ("
            + "setting_key VARCHAR(100) PRIMARY KEY, setting_value TEXT, "
            + "category VARCHAR(50) NOT NULL DEFAULT 'GENERAL', description VARCHAR(255), "
            + "updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)",

            // Bảng performance_cycles
            "CREATE TABLE IF NOT EXISTS performance_cycles ("
            + "id SERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE, "
            + "start_date DATE NOT NULL, end_date DATE NOT NULL, "
            + "status VARCHAR(30) NOT NULL DEFAULT 'OPEN', created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)",

            // Bảng kpi_metrics
            "CREATE TABLE IF NOT EXISTS kpi_metrics ("
            + "id SERIAL PRIMARY KEY, kpi_code VARCHAR(50) NOT NULL UNIQUE, title VARCHAR(255) NOT NULL, "
            + "employee_id INTEGER NOT NULL REFERENCES employees(id) ON DELETE CASCADE, "
            + "department_id INTEGER REFERENCES departments(id), quarter VARCHAR(30) NOT NULL DEFAULT 'Q3/2026', "
            + "target_value NUMERIC(10,2) NOT NULL DEFAULT 100.0, current_value NUMERIC(10,2) NOT NULL DEFAULT 0.0, "
            + "unit VARCHAR(50) NOT NULL DEFAULT '%', weight_pct NUMERIC(5,2) NOT NULL DEFAULT 20.0, "
            + "deadline DATE, status VARCHAR(30) NOT NULL DEFAULT 'IN_PROGRESS', notes TEXT, "
            + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP)",

            "CREATE INDEX IF NOT EXISTS idx_kpi_employee ON kpi_metrics(employee_id)",
            "CREATE INDEX IF NOT EXISTS idx_kpi_dept ON kpi_metrics(department_id)",
            "CREATE INDEX IF NOT EXISTS idx_kpi_quarter ON kpi_metrics(quarter)",
            "CREATE INDEX IF NOT EXISTS idx_kpi_status ON kpi_metrics(status)",

            // Bảng performance_evaluations
            "CREATE TABLE IF NOT EXISTS performance_evaluations ("
            + "id SERIAL PRIMARY KEY, evaluation_code VARCHAR(50) NOT NULL UNIQUE, "
            + "employee_id INTEGER NOT NULL REFERENCES employees(id) ON DELETE CASCADE, "
            + "evaluator_id INTEGER REFERENCES employees(id), quarter VARCHAR(30) NOT NULL DEFAULT 'Q3/2026', "
            + "kpi_score NUMERIC(4,2) NOT NULL DEFAULT 0.0, competency_score NUMERIC(4,2) NOT NULL DEFAULT 0.0, "
            + "culture_score NUMERIC(4,2) NOT NULL DEFAULT 0.0, innovation_score NUMERIC(4,2) NOT NULL DEFAULT 0.0, "
            + "final_score NUMERIC(4,2) NOT NULL DEFAULT 0.0, grade VARCHAR(30) NOT NULL DEFAULT 'B', "
            + "status VARCHAR(30) NOT NULL DEFAULT 'PENDING', feedback TEXT, "
            + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP)",

            "CREATE INDEX IF NOT EXISTS idx_eval_employee ON performance_evaluations(employee_id)",
            "CREATE INDEX IF NOT EXISTS idx_eval_quarter ON performance_evaluations(quarter)",
            "CREATE INDEX IF NOT EXISTS idx_eval_status ON performance_evaluations(status)",

            // Bảng overtime: overtime_code
            "ALTER TABLE overtime ADD COLUMN IF NOT EXISTS overtime_code VARCHAR(50)",
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_overtime_code ON overtime(overtime_code) WHERE overtime_code IS NOT NULL",

            // Bảng work_shifts: unique index
            "CREATE UNIQUE INDEX IF NOT EXISTS idx_work_shifts_name ON work_shifts(name)"
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

    private static void seedSalaryConfigsIfEmpty(Connection conn) throws SQLException {
        String countSql = "SELECT COUNT(*) FROM salary_configs";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(countSql)) {
            if (rs.next() && rs.getInt(1) > 0) return;
        }

        String insertSql = "INSERT INTO salary_configs (config_key, config_value, description) VALUES (?, ?, ?) "
                         + "ON CONFLICT (config_key) DO NOTHING";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            Object[][] configs = {
                {"BASE_SALARY_LEVEL", "2340000", "Mức lương cơ sở hiện hành theo NĐ 73/2024/NĐ-CP (VNĐ/tháng)"},
                {"PERSONAL_DEDUCTION", "11000000", "Mức giảm trừ gia cảnh cho bản thân người nộp thuế (VNĐ/tháng)"},
                {"DEPENDENT_DEDUCTION", "4400000", "Mức giảm trừ gia cảnh cho mỗi người phụ thuộc (VNĐ/tháng)"},
                {"BHXH_RATE", "0.08", "Tỷ lệ đóng BHXH của người lao động (8%)"},
                {"BHYT_RATE", "0.015", "Tỷ lệ đóng BHYT của người lao động (1.5%)"},
                {"BHTN_RATE", "0.01", "Tỷ lệ đóng BHTN của người lao động (1%)"},
                {"MAX_INSURANCE_SALARY", "46800000", "Mức trần tiền lương đóng BHXH, BHYT (20 lần lương cơ sở)"},
                {"STANDARD_WORKING_DAYS", "22", "Số ngày làm việc tiêu chuẩn trong tháng"},
                // Đồng bộ key viết thường dùng trong Servlet / Service / JSP
                {"base_salary", "2340000", "Lương cơ sở hiện hành (VNĐ)"},
                {"personal_reduction", "11000000", "Mức giảm trừ gia cảnh bản thân (VNĐ)"},
                {"dependent_reduction", "4400000", "Mức giảm trừ gia cảnh người phụ thuộc (VNĐ)"},
                {"bhxh_rate", "0.08", "Tỷ lệ đóng BHXH người lao động (8%)"},
                {"bhyt_rate", "0.015", "Tỷ lệ đóng BHYT người lao động (1.5%)"},
                {"bhtn_rate", "0.01", "Tỷ lệ đóng BHTN người lao động (1%)"},
                {"insurance_ceiling", "46800000", "Mức trần tiền lương đóng BHXH/BHYT (VNĐ)"},
                {"standard_working_days", "22", "Số ngày làm việc tiêu chuẩn"}
            };
            for (Object[] c : configs) {
                ps.setString(1, (String) c[0]);
                ps.setString(2, (String) c[1]);
                ps.setString(3, (String) c[2]);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[DatabaseInitializer] Đã nạp cấu hình thang bảng lương mặc định!");
        }
    }

    private static void seedAllowancesIfEmpty(Connection conn) throws SQLException {
        String countSql = "SELECT COUNT(*) FROM allowances";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(countSql)) {
            if (rs.next() && rs.getInt(1) > 0) return;
        }

        String insertSql = "INSERT INTO allowances (employee_id, name, amount, start_date, active) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            Object[][] list = {
                {1, "Phụ cấp trách nhiệm quản lý", new BigDecimal("3000000"), LocalDate.of(2026, 1, 1), true},
                {1, "Phụ cấp ăn trưa", new BigDecimal("730000"), LocalDate.of(2026, 1, 1), true},
                {2, "Phụ cấp trách nhiệm quản lý", new BigDecimal("2500000"), LocalDate.of(2026, 1, 1), true},
                {2, "Phụ cấp ăn trưa", new BigDecimal("730000"), LocalDate.of(2026, 1, 1), true},
                {3, "Phụ cấp ăn trưa", new BigDecimal("730000"), LocalDate.of(2026, 1, 1), true},
                {3, "Xăng xe & đi lại", new BigDecimal("500000"), LocalDate.of(2026, 1, 1), true},
                {4, "Phụ cấp ăn trưa", new BigDecimal("730000"), LocalDate.of(2026, 1, 1), true},
                {4, "Xăng xe & đi lại", new BigDecimal("500000"), LocalDate.of(2026, 1, 1), true},
                {4, "Điện thoại viễn thông", new BigDecimal("300000"), LocalDate.of(2026, 1, 1), true},
                {5, "Phụ cấp ăn trưa", new BigDecimal("730000"), LocalDate.of(2026, 1, 1), true},
                {5, "Xăng xe & đi lại", new BigDecimal("500000"), LocalDate.of(2026, 1, 1), true},
                {6, "Phụ cấp ăn trưa", new BigDecimal("730000"), LocalDate.of(2026, 1, 1), true},
                {7, "Phụ cấp ăn trưa", new BigDecimal("730000"), LocalDate.of(2026, 1, 1), true}
            };
            for (Object[] item : list) {
                ps.setInt(1, (Integer) item[0]);
                ps.setString(2, (String) item[1]);
                ps.setBigDecimal(3, (BigDecimal) item[2]);
                ps.setDate(4, Date.valueOf((LocalDate) item[3]));
                ps.setBoolean(5, (Boolean) item[4]);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[DatabaseInitializer] Đã nạp danh sách phụ cấp mẫu vào PostgreSQL!");
        }
    }

    private static void seedBonusesIfEmpty(Connection conn) throws SQLException {
        String countSql = "SELECT COUNT(*) FROM bonuses";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(countSql)) {
            if (rs.next() && rs.getInt(1) > 0) return;
        }

        String insertSql = "INSERT INTO bonuses (employee_id, name, amount, bonus_date, pay_month, pay_year, notes) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            Object[][] list = {
                {1, "Thưởng hiệu suất KPI xuất sắc Q3", new BigDecimal("5000000"), LocalDate.of(2026, 9, 20), 9, 2026, "Hoàn thành vượt 130% chỉ tiêu OKR quý"},
                {2, "Thưởng hoàn thành tuyển dụng trọng điểm", new BigDecimal("3000000"), LocalDate.of(2026, 9, 21), 9, 2026, "Tuyển dụng thành công 5 Senior Tech Leads"},
                {3, "Thưởng KPI phòng Kế toán T9", new BigDecimal("2000000"), LocalDate.of(2026, 9, 22), 9, 2026, "Quyết toán thuế đúng tiến độ"},
                {4, "Thưởng Dự án Core Banking v4.2", new BigDecimal("4500000"), LocalDate.of(2026, 9, 22), 9, 2026, "Hoàn thành sprint đúng hạn không lỗi"},
                {5, "Thưởng Doanh số B2B tháng 9", new BigDecimal("6000000"), LocalDate.of(2026, 9, 23), 9, 2026, "Ký kết 3 hợp đồng giải pháp lớn"},
                {6, "Thưởng Chiến dịch Marketing Viral", new BigDecimal("2500000"), LocalDate.of(2026, 9, 18), 9, 2026, "Đạt 200k lượt tương tác truyền thông"},
                {7, "Thưởng tiến độ kiểm thử QA", new BigDecimal("1500000"), LocalDate.of(2026, 9, 20), 9, 2026, "Đạt 100% test coverage sprint 44"}
            };
            for (Object[] item : list) {
                ps.setInt(1, (Integer) item[0]);
                ps.setString(2, (String) item[1]);
                ps.setBigDecimal(3, (BigDecimal) item[2]);
                ps.setDate(4, Date.valueOf((LocalDate) item[3]));
                ps.setInt(5, (Integer) item[4]);
                ps.setInt(6, (Integer) item[5]);
                ps.setString(7, (String) item[6]);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[DatabaseInitializer] Đã nạp danh sách Khen thưởng mẫu vào PostgreSQL!");
        }
    }

    private static void seedSalaryDeductionsIfEmpty(Connection conn) throws SQLException {
        String countSql = "SELECT COUNT(*) FROM salary_deductions";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(countSql)) {
            if (rs.next() && rs.getInt(1) > 0) return;
        }

        String insertSql = "INSERT INTO salary_deductions (employee_id, deduction_type, amount, pay_month, pay_year, description) "
                         + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            Object[][] list = {
                {4, "ADVANCE", new BigDecimal("2000000"), 9, 2026, "Tạm ứng lương giữa tháng — Đơn duyệt ngày 15/09"},
                {5, "ADVANCE", new BigDecimal("3000000"), 9, 2026, "Tạm ứng chi phí công tác đối tác Hà Nội"},
                {7, "UNION_FEE", new BigDecimal("100000"), 9, 2026, "Đoàn phí Công đoàn kỳ T09/2026"}
            };
            for (Object[] item : list) {
                ps.setInt(1, (Integer) item[0]);
                ps.setString(2, (String) item[1]);
                ps.setBigDecimal(3, (BigDecimal) item[2]);
                ps.setInt(4, (Integer) item[3]);
                ps.setInt(5, (Integer) item[4]);
                ps.setString(6, (String) item[5]);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[DatabaseInitializer] Đã nạp danh sách Khấu trừ/Tạm ứng mẫu vào PostgreSQL!");
        }
    }

    private static void seedPayrollAndPaymentsIfEmpty(Connection conn) throws SQLException {
        String countSql = "SELECT COUNT(*) FROM payroll WHERE pay_month = 9 AND pay_year = 2026";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(countSql)) {
            if (rs.next() && rs.getInt(1) > 0) return;
        }

        // Lấy danh sách nhân viên có hợp đồng
        String empSql = "SELECT e.id, c.base_salary "
                      + "FROM employees e "
                      + "JOIN contracts c ON e.id = c.employee_id "
                      + "WHERE e.status = 'ACTIVE' AND c.status = 'ACTIVE' "
                      + "ORDER BY e.id LIMIT 10";

        List<Object[]> activeEmps = new ArrayList<>();
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(empSql)) {
            while (rs.next()) {
                activeEmps.add(new Object[]{rs.getInt("id"), rs.getBigDecimal("base_salary")});
            }
        }

        if (activeEmps.isEmpty()) return;

        String insertPayrollSql = "INSERT INTO payroll (employee_id, pay_month, pay_year, base_salary, working_days, standard_days, "
                                + "overtime_amount, allowance, bonus, deduction, net_salary, status, created_by_id, approved_by_id, approved_at) "
                                + "VALUES (?, 9, 2026, ?, 22.0, 22.0, ?, ?, ?, ?, ?, ?, 1, 1, CURRENT_TIMESTAMP) "
                                + "RETURNING id, employee_id, net_salary, status";

        String insertPaymentSql = "INSERT INTO payments (payroll_id, employee_id, amount, payment_date, payment_method, status, notes) "
                                + "VALUES (?, ?, ?, CURRENT_DATE, 'BANK_TRANSFER', 'COMPLETED', 'Thanh toán lương chuyển khoản H2H Napas')";

        for (int i = 0; i < activeEmps.size(); i++) {
            int empId = (Integer) activeEmps.get(i)[0];
            BigDecimal base = (BigDecimal) activeEmps.get(i)[1];
            BigDecimal ot = i % 2 == 0 ? new BigDecimal("1500000") : BigDecimal.ZERO;
            BigDecimal allow = new BigDecimal("1230000");
            BigDecimal bonus = (i == 0 || i == 3) ? new BigDecimal("3000000") : BigDecimal.ZERO;
            BigDecimal bh = base.multiply(new BigDecimal("0.105")).setScale(0, java.math.RoundingMode.HALF_UP);
            BigDecimal tax = base.compareTo(new BigDecimal("15000000")) > 0 ? new BigDecimal("750000") : BigDecimal.ZERO;
            BigDecimal deduction = bh.add(tax);
            BigDecimal net = base.add(ot).add(allow).add(bonus).subtract(deduction);
            String status = i < 3 ? "PAID" : (i < 7 ? "APPROVED" : "DRAFT");

            try (PreparedStatement psPr = conn.prepareStatement(insertPayrollSql)) {
                psPr.setInt(1, empId);
                psPr.setBigDecimal(2, base);
                psPr.setBigDecimal(3, ot);
                psPr.setBigDecimal(4, allow);
                psPr.setBigDecimal(5, bonus);
                psPr.setBigDecimal(6, deduction);
                psPr.setBigDecimal(7, net);
                psPr.setString(8, status);

                try (ResultSet rsPr = psPr.executeQuery()) {
                    if (rsPr.next() && "PAID".equals(status)) {
                        int prId = rsPr.getInt("id");
                        try (PreparedStatement psPay = conn.prepareStatement(insertPaymentSql)) {
                            psPay.setInt(1, prId);
                            psPay.setInt(2, empId);
                            psPay.setBigDecimal(3, net);
                            psPay.executeUpdate();
                        }
                    }
                }
            }
        }
        System.out.println("[DatabaseInitializer] Đã nạp dữ liệu Bảng lương và Lệnh chi kỳ T09/2026 mẫu!");
    }

    // ==========================================================================
    //  Module Tuyển Dụng — Seed dữ liệu mẫu
    // ==========================================================================

    private static void seedRecruitmentIfEmpty(Connection conn) throws SQLException {
        // Kiểm tra xem đã có dữ liệu tuyển dụng chưa
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM recruitment_requests")) {
            if (rs.next() && rs.getInt(1) >= 12) return; // Đã đủ dữ liệu
        } catch (SQLException e) {
            // Bảng chưa tồn tại — bỏ qua, sẽ được tạo bởi migrateSchema
            return;
        }

        // ---- Bước 0: Đảm bảo nhân viên phụ trách NV011..NV015 tồn tại ----
        String insertEmpSql = "INSERT INTO employees "
            + "(employee_code, full_name, date_of_birth, gender, phone, email, address, department_id, position_id, employee_type_id, start_date, status) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT (employee_code) DO NOTHING";
        Object[][] hrEmps = {
            {"NV011", "Phạm Phương Thảo", java.sql.Date.valueOf("1993-04-12"), "FEMALE", "0912111222", "thao.pp@miximoi.vn", "Hà Nội", 2, 8, 1, java.sql.Date.valueOf("2022-03-01"), "ACTIVE"},
            {"NV012", "Nguyễn Minh Tuấn", java.sql.Date.valueOf("1989-08-25"), "MALE",   "0913222333", "tuan.nm@miximoi.vn", "Hà Nội", 6, 7, 1, java.sql.Date.valueOf("2021-05-15"), "ACTIVE"},
            {"NV013", "Trần Thị Mai",     java.sql.Date.valueOf("1994-11-09"), "FEMALE", "0914333444", "mai.tt@miximoi.vn",  "Hà Nội", 2, 8, 1, java.sql.Date.valueOf("2022-08-01"), "ACTIVE"},
            {"NV014", "Lê Trọng",         java.sql.Date.valueOf("1991-02-18"), "MALE",   "0915444555", "trong.l@miximoi.vn",  "Hà Nội", 5, 5, 1, java.sql.Date.valueOf("2023-01-10"), "ACTIVE"},
            {"NV015", "Đặng Quốc Việt",   java.sql.Date.valueOf("1990-10-30"), "MALE",   "0916555666", "viet.dq@miximoi.vn",  "Hà Nội", 3, 9, 1, java.sql.Date.valueOf("2022-02-20"), "ACTIVE"}
        };
        try (PreparedStatement ps = conn.prepareStatement(insertEmpSql)) {
            for (Object[] row : hrEmps) {
                ps.setString(1, (String) row[0]);
                ps.setString(2, (String) row[1]);
                ps.setDate(3, (java.sql.Date) row[2]);
                ps.setString(4, (String) row[3]);
                ps.setString(5, (String) row[4]);
                ps.setString(6, (String) row[5]);
                ps.setString(7, (String) row[6]);
                ps.setInt(8, (Integer) row[7]);
                ps.setInt(9, (Integer) row[8]);
                ps.setInt(10, (Integer) row[9]);
                ps.setDate(11, (java.sql.Date) row[10]);
                ps.setString(12, (String) row[11]);
                ps.addBatch();
            }
            ps.executeBatch();
        }

        // Lấy id nhân viên phụ trách
        java.util.Map<String, Integer> empIdByCode = new java.util.HashMap<>();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT id, employee_code FROM employees WHERE employee_code IN ('NV011','NV012','NV013','NV014','NV015')")) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) empIdByCode.put(rs.getString(2), rs.getInt(1));
            }
        }
        int nv011 = empIdByCode.getOrDefault("NV011", 1);
        int nv012 = empIdByCode.getOrDefault("NV012", 2);
        int nv013 = empIdByCode.getOrDefault("NV013", 3);
        int nv014 = empIdByCode.getOrDefault("NV014", 4);
        int nv015 = empIdByCode.getOrDefault("NV015", 5);

        // ---- Bước 1: Xóa & nạp lại 12 Yêu cầu tuyển dụng ----
        // Xóa theo thứ tự FK
        try (Statement st = conn.createStatement()) {
            st.execute("DELETE FROM interviews");
            st.execute("DELETE FROM candidates");
            st.execute("DELETE FROM recruitment_requests");
        }

        String insertReqSql = "INSERT INTO recruitment_requests "
            + "(id, request_code, title, department_id, position_id, target_headcount, hired_count, "
            + "salary_min, salary_max, deadline, priority, status, quarter, assignee_id, description, requirements, benefits) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        // id, code, title, dept, pos, target, hired, salMin, salMax, deadline, priority, status, quarter, assignee, desc, req, ben
        Object[][] requests = {
            {1,  "YCTD-2026-081", "Senior Fullstack Engineer (React/Go)",           6, 7, 3, 2, 35000000L, 55000000L, "2026-10-15", "HOT",    "OPEN",   "Q3/2026", nv011, "Phát triển hệ thống Microservices quy mô lớn và giao diện Frontend ReactJS hiện đại.", "Tối thiểu 4 năm kinh nghiệm ReactJS, Go/NodeJS. Thành thạo PostgreSQL, Docker.", "Lương thưởng cạnh tranh, bảo hiểm sức khỏe cao cấp, hỗ trợ thiết bị Macbook Pro M-series."},
            {2,  "YCTD-2026-082", "Trưởng nhóm Kinh doanh B2B (Sales Lead)",        4, 10, 1, 1, 25000000L, 45000000L, "2026-09-30", "NORMAL", "FILLED", "Q3/2026", nv013, "Dẫn dắt đội ngũ kinh doanh tiếp cận khách hàng doanh nghiệp khối B2B SaaS.", "3+ năm kinh nghiệm Sales Lead mảng dịch vụ doanh nghiệp, kỹ năng đàm phán xuất sắc.", "Hoa hồng theo doanh số không giới hạn, lộ trình thăng tiến Giám đốc kinh doanh."},
            {3,  "YCTD-2026-083", "Product Designer (UI/UX Senior)",                6, 7, 2, 1, 28000000L, 42000000L, "2026-10-20", "NORMAL", "OPEN",   "Q3/2026", nv011, "Thiết kế trải nghiệm người dùng và hệ thống Design System cho sản phẩm HRM & Payroll.", "3+ năm thiết kế sản phẩm Web/App B2B phức tạp. Nắm vững Figma, Design Token.", "Môi trường Agile năng động, tự chủ quyết định thiết kế sản phẩm."},
            {4,  "YCTD-2026-084", "Content Marketing Specialist",                    5, 5, 2, 0, 16000000L, 24000000L, "2026-10-05", "URGENT", "OPEN",   "Q3/2026", nv014, "Sáng tạo nội dung truyền thông đa kênh, bài viết chuyên sâu về chuyển đổi số nhân sự.", "2+ năm viết nội dung B2B, kỹ năng SEO, am hiểu truyền thông mạng xã hội.", "Phụ cấp đào tạo kỹ năng hàng quý, tham gia các chiến dịch Marketing quốc tế."},
            {5,  "YCTD-2026-085", "Kế toán Thuế & Kiểm toán nội bộ",                3, 9, 1, 1, 20000000L, 30000000L, "2026-09-15", "NORMAL", "CLOSED", "Q3/2026", nv015, "Quyết toán thuế doanh nghiệp, soát xét hồ sơ tài chính và làm việc với cơ quan thuế.", "Tốt nghiệp ĐH chuyên ngành Kế toán - Kiểm toán, 3+ năm làm kế toán thuế tổng hợp.", "Thưởng lương tháng 13++, chế độ du lịch nghỉ dưỡng hàng năm."},
            {6,  "YCTD-2026-086", "DevOps / Cloud Security Specialist",              6, 7, 1, 0, 35000000L, 50000000L, "2026-10-25", "URGENT", "PAUSED", "Q3/2026", nv011, "Vận hành hạ tầng AWS/GCP, bảo mật mạng nội bộ và hệ thống CI/CD.", "Có chứng chỉ AWS/CKS, kinh nghiệm Kubernetes production, quản trị hạ tầng IaC.", "Gói cổ phần ESOP cho nhân sự chủ chốt, làm việc Hybrid linh hoạt."},
            {7,  "YCTD-2026-087", "Chuyên viên Nhân sự C&B",                        2, 8, 1, 0, 18000000L, 26000000L, "2026-10-12", "NORMAL", "OPEN",   "Q3/2026", nv015, "Tính lương, quản lý bảo hiểm xã hội, thuế TNCN và các chế độ đãi ngộ toàn công ty.", "2+ năm kinh nghiệm C&B chuyên sâu quy mô 200+ nhân sự, nắm chắc luật lao động.", "Thưởng hiệu suất tháng, phụ cấp ăn trưa và gửi xe miễn phí."},
            {8,  "YCTD-2026-088", "Frontend Developer (VueJS / NuxtJS)",             6, 7, 2, 0, 22000000L, 32000000L, "2026-10-18", "NORMAL", "OPEN",   "Q3/2026", nv011, "Phát triển ứng dụng Web portal cho nhân viên và cổng quản lý chấm công.", "2+ năm VueJS/NuxtJS, CSS3/Tailwind, tối ưu hóa Web Performance.", "Thưởng dự án theo tiến độ sprint, môi trường làm việc trẻ trung."},
            {9,  "YCTD-2026-089", "Chuyên viên Quản lý Khách hàng Doanh nghiệp (Account Manager)", 4, 10, 2, 0, 18000000L, 30000000L, "2026-10-22", "NORMAL", "OPEN",   "Q3/2026", nv013, "Chăm sóc và duy trì mối quan hệ lâu dài với các khách hàng doanh nghiệp trọng điểm.", "Kinh nghiệm CSKH/Account mảng dịch vụ B2B, khả năng giao tiếp và xử lý vấn đề tốt.", "Thưởng hoa hồng gia hạn hợp đồng, tham gia các hội thảo doanh nghiệp lớn."},
            {10, "YCTD-2026-090", "QA/QC Engineer (Automation Test)",               6, 7, 2, 0, 20000000L, 30000000L, "2026-10-28", "NORMAL", "OPEN",   "Q3/2026", nv011, "Viết kịch bản kiểm thử tự động API và Web UI, đảm bảo chất lượng phát hành phiên bản.", "Kinh nghiệm Selenium, Playwright, Postman, kiểm thử tải JMeter.", "Được đào tạo nâng cao kiến trúc hệ thống và quy trình CI/CD testing."},
            {11, "YCTD-2026-091", "Chuyên viên Tuyển dụng Kỹ thuật (Tech Recruiter)",2, 8, 1, 0, 16000000L, 25000000L, "2026-10-08", "URGENT", "OPEN",   "Q3/2026", nv011, "Săn đầu người và tiếp cận các kỹ sư công nghệ chất lượng cao cho các vị trí trọng điểm.", "2+ năm tuyển dụng IT, mạng lưới quan hệ rộng trong cộng đồng lập trình viên.", "Thưởng tuyển dụng theo từng case thành công, cơ hội thăng tiến Talent Lead."},
            {12, "YCTD-2026-092", "Nhân viên Hành chính Tổng hợp",                 2, 5, 1, 0, 12000000L, 16000000L, "2026-11-05", "NORMAL", "PAUSED", "Q3/2026", nv013, "Quản lý văn phòng phẩm, cơ sở vật chất văn phòng và lễ tân đón tiếp đối tác.", "Nhanh nhẹn, cẩn thận, có kỹ năng giao tiếp và quản lý hồ sơ tốt.", "Môi trường thân thiện, hỗ trợ cơm trưa văn phòng và trà nước miễn phí."}
        };
        try (PreparedStatement ps = conn.prepareStatement(insertReqSql)) {
            for (Object[] r : requests) {
                ps.setInt(1, (Integer) r[0]);
                ps.setString(2, (String) r[1]);
                ps.setString(3, (String) r[2]);
                ps.setInt(4, (Integer) r[3]);
                ps.setInt(5, (Integer) r[4]);
                ps.setInt(6, (Integer) r[5]);
                ps.setInt(7, (Integer) r[6]);
                ps.setLong(8, (Long) r[7]);
                ps.setLong(9, (Long) r[8]);
                ps.setDate(10, java.sql.Date.valueOf((String) r[9]));
                ps.setString(11, (String) r[10]);
                ps.setString(12, (String) r[11]);
                ps.setString(13, (String) r[12]);
                ps.setInt(14, (Integer) r[13]);
                ps.setString(15, (String) r[14]);
                ps.setString(16, (String) r[15]);
                ps.setString(17, (String) r[16]);
                ps.addBatch();
            }
            ps.executeBatch();
        }
        // Reset sequence
        try (Statement st = conn.createStatement()) {
            st.execute("SELECT setval('recruitment_requests_id_seq', 12, true)");
        }

        // ---- Bước 2: Nạp 86 Ứng viên ----
        // Nhóm: 5 ONBOARDED, 3 OFFER, 16 INTERVIEW, 30 SCREENING, 32 NEW
        java.time.LocalDate today = java.time.LocalDate.now();
        String insertCandSql = "INSERT INTO candidates "
            + "(candidate_code, full_name, email, phone, recruitment_request_id, source, stage, experience_years, expected_salary, applied_date) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Dữ liệu cố định: 5 ONBOARDED + 3 OFFER + 16 INTERVIEW
        Object[][] fixedCands = {
            // ONBOARDED
            {"UV-2026-001", "Nguyễn Tiến Dũng",   "dung.nt@gmail.com",  "0901112233", 1,  "LinkedIn",       "ONBOARDED", 4.5, 42000000L, today.minusDays(54)},
            {"UV-2026-002", "Trần Hữu Nam",        "nam.th@gmail.com",   "0902223344", 1,  "TopCV/VNW",      "ONBOARDED", 5.0, 45000000L, today.minusDays(50)},
            {"UV-2026-003", "Đặng Thùy Trang",     "trang.dt@gmail.com", "0903334455", 2,  "Nội bộ (Ref)",   "ONBOARDED", 4.0, 30000000L, today.minusDays(45)},
            {"UV-2026-004", "Vũ Tuấn Kiệt",        "kiet.vt@gmail.com",  "0904445566", 3,  "LinkedIn",       "ONBOARDED", 3.5, 32000000L, today.minusDays(43)},
            {"UV-2026-005", "Lê Thị Thu",           "thu.lt@gmail.com",   "0905556677", 5,  "Khác",           "ONBOARDED", 4.0, 22000000L, today.minusDays(40)},
            // OFFER
            {"UV-2026-006", "Phan Văn Hải",         "hai.pv@gmail.com",   "0906667788", 1,  "LinkedIn",       "OFFER",     4.0, 40000000L, today.minusDays(35)},
            {"UV-2026-007", "Ngô Bảo Châu",         "chau.nb@gmail.com",  "0907778899", 3,  "TopCV/VNW",      "OFFER",     3.0, 28000000L, today.minusDays(33)},
            {"UV-2026-008", "Hoàng Minh Quân",      "quan.hm@gmail.com",  "0908889900", 4,  "Nội bộ (Ref)",   "OFFER",     2.5, 20000000L, today.minusDays(30)},
            // INTERVIEW (3 có lịch hôm nay: UV-009, UV-010, UV-011)
            {"UV-2026-009", "Vũ Hoàng Nam",         "nam.vh@gmail.com",   "0910001122", 1,  "LinkedIn",       "INTERVIEW", 4.5, 42000000L, today.minusDays(23)},
            {"UV-2026-010", "Phạm Khánh Linh",      "linh.pk@gmail.com",  "0911112233", 3,  "TopCV/VNW",      "INTERVIEW", 3.2, 30000000L, today.minusDays(22)},
            {"UV-2026-011", "Trương Bá Đạt",        "dat.tb@gmail.com",   "0912223344", 6,  "LinkedIn",       "INTERVIEW", 3.8, 38000000L, today.minusDays(21)},
            {"UV-2026-012", "Nguyễn Hữu Tài",       "tai.nh@gmail.com",   "0913334455", 1,  "TopCV/VNW",      "INTERVIEW", 4.0, 38000000L, today.minusDays(20)},
            {"UV-2026-013", "Lê Diệu Hương",        "huong.ld@gmail.com", "0914445566", 4,  "Nội bộ (Ref)",   "INTERVIEW", 2.0, 18000000L, today.minusDays(19)},
            {"UV-2026-014", "Đỗ Thành Long",        "long.dt@gmail.com",  "0915556677", 7,  "Khác",           "INTERVIEW", 3.0, 20000000L, today.minusDays(19)},
            {"UV-2026-015", "Trịnh Bích Ngọc",      "ngoc.tb@gmail.com",  "0916667788", 8,  "LinkedIn",       "INTERVIEW", 2.8, 24000000L, today.minusDays(18)},
            {"UV-2026-016", "Bùi Văn Hưng",         "hung.bv@gmail.com",  "0917778899", 9,  "TopCV/VNW",      "INTERVIEW", 3.5, 22000000L, today.minusDays(18)},
            {"UV-2026-017", "Vương Đình Toàn",      "toan.vd@gmail.com",  "0918889900", 10, "LinkedIn",       "INTERVIEW", 3.0, 23000000L, today.minusDays(17)},
            {"UV-2026-018", "Mai Phương Thảo",      "thao.mp@gmail.com",  "0919990011", 11, "Nội bộ (Ref)",   "INTERVIEW", 2.5, 19000000L, today.minusDays(17)},
            {"UV-2026-019", "Lương Thế Vinh",       "vinh.lt@gmail.com",  "0920001122", 1,  "TopCV/VNW",      "INTERVIEW", 5.0, 48000000L, today.minusDays(16)},
            {"UV-2026-020", "Phùng Gia Bảo",        "bao.pg@gmail.com",   "0921112233", 3,  "LinkedIn",       "INTERVIEW", 4.0, 35000000L, today.minusDays(16)},
            {"UV-2026-021", "Cao Thị Yến",          "yen.ct@gmail.com",   "0922223344", 4,  "TopCV/VNW",      "INTERVIEW", 2.0, 17000000L, today.minusDays(15)},
            {"UV-2026-022", "Dương Quốc Anh",       "anh.dq@gmail.com",   "0923334455", 8,  "LinkedIn",       "INTERVIEW", 3.0, 26000000L, today.minusDays(15)},
            {"UV-2026-023", "Hà Thảo Ly",           "ly.ht@gmail.com",    "0924445566", 9,  "Khác",           "INTERVIEW", 2.5, 18000000L, today.minusDays(14)},
            {"UV-2026-024", "Lâm Văn Phước",        "phuoc.lv@gmail.com", "0925556677", 10, "Nội bộ (Ref)",   "INTERVIEW", 3.2, 24000000L, today.minusDays(14)}
        };
        try (PreparedStatement ps = conn.prepareStatement(insertCandSql)) {
            for (Object[] c : fixedCands) {
                ps.setString(1, (String) c[0]);
                ps.setString(2, (String) c[1]);
                ps.setString(3, (String) c[2]);
                ps.setString(4, (String) c[3]);
                ps.setInt(5, (Integer) c[4]);
                ps.setString(6, (String) c[5]);
                ps.setString(7, (String) c[6]);
                ps.setDouble(8, (Double) c[7]);
                ps.setLong(9, (Long) c[8]);
                ps.setDate(10, java.sql.Date.valueOf((java.time.LocalDate) c[9]));
                ps.addBatch();
            }
            ps.executeBatch();
        }

        // 30 SCREENING (id 25..54)
        String[] sources = {"LinkedIn", "TopCV/VNW", "Nội bộ (Ref)", "Khác"};
        try (PreparedStatement ps = conn.prepareStatement(insertCandSql)) {
            for (int i = 25; i <= 54; i++) {
                int sIdx = (i * 3) % 4;  // 0-based
                int reqId = 1 + (i % 12);
                String code = String.format("UV-2026-%03d", i);
                ps.setString(1, code);
                ps.setString(2, "Ứng viên Sàng lọc " + i);
                ps.setString(3, "cand" + i + "@test.com");
                ps.setString(4, "093" + String.format("%07d", i));
                ps.setInt(5, reqId);
                ps.setString(6, sources[sIdx]);
                ps.setString(7, "SCREENING");
                ps.setDouble(8, 2.5);
                ps.setLong(9, 22000000L);
                ps.setDate(10, java.sql.Date.valueOf(today.minusDays(i % 15)));
                ps.addBatch();
            }
            ps.executeBatch();
        }

        // 32 NEW (id 55..86)
        try (PreparedStatement ps = conn.prepareStatement(insertCandSql)) {
            for (int i = 55; i <= 86; i++) {
                int sIdx = (i * 5) % 4;  // 0-based
                int reqId = 1 + (i % 12);
                String code = String.format("UV-2026-%03d", i);
                ps.setString(1, code);
                ps.setString(2, "Ứng viên Mới " + i);
                ps.setString(3, "cand" + i + "@test.com");
                ps.setString(4, "094" + String.format("%07d", i));
                ps.setInt(5, reqId);
                ps.setString(6, sources[sIdx]);
                ps.setString(7, "NEW");
                ps.setDouble(8, 1.5);
                ps.setLong(9, 18000000L);
                ps.setDate(10, java.sql.Date.valueOf(today.minusDays(i % 7)));
                ps.addBatch();
            }
            ps.executeBatch();
        }

        // Cập nhật phân bổ nguồn đúng tỷ lệ: LinkedIn=36, TopCV/VNW=30, Nội bộ=13, Khác=7
        try (Statement st = conn.createStatement()) {
            st.execute("UPDATE candidates SET source = 'LinkedIn' WHERE id IN (SELECT id FROM candidates ORDER BY id LIMIT 36)");
            st.execute("UPDATE candidates SET source = 'TopCV/VNW' WHERE id IN (SELECT id FROM candidates WHERE id NOT IN (SELECT id FROM candidates ORDER BY id LIMIT 36) ORDER BY id LIMIT 30)");
            st.execute("UPDATE candidates SET source = 'Nội bộ (Ref)' WHERE id IN (SELECT id FROM candidates WHERE id NOT IN (SELECT id FROM candidates ORDER BY id LIMIT 66) ORDER BY id LIMIT 13)");
            st.execute("UPDATE candidates SET source = 'Khác' WHERE id IN (SELECT id FROM candidates WHERE id NOT IN (SELECT id FROM candidates ORDER BY id LIMIT 79))");
        }

        // ---- Bước 3: Nạp 9 ca Phỏng vấn ----
        // Lấy id của các ứng viên cần lịch
        java.util.Map<String, Integer> candIdByCode = new java.util.HashMap<>();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT id, candidate_code FROM candidates WHERE candidate_code IN "
                + "('UV-2026-009','UV-2026-010','UV-2026-011','UV-2026-012','UV-2026-013',"
                + "'UV-2026-014','UV-2026-015','UV-2026-016','UV-2026-017')")) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) candIdByCode.put(rs.getString(2), rs.getInt(1));
            }
        }

        String insertIntSql = "INSERT INTO interviews "
            + "(candidate_id, recruitment_request_id, interviewer_id, round_name, interview_date, interview_time, location_or_link, status) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        // cand_code, req_id, interviewer_id, round, date_offset, time, location, status
        Object[][] interviews = {
            // 3 ca HÔM NAY
            {"UV-2026-009", 1,  nv012, "Vòng Chuyên môn",               0, "09:30:00", "Phòng họp Kỹ thuật (Tầng 4) & Google Meet", "SCHEDULED"},
            {"UV-2026-010", 3,  nv012, "Vòng Portfolio",                 0, "14:00:00", "Phòng Sáng tạo UI/UX & Google Meet",          "SCHEDULED"},
            {"UV-2026-011", 6,  nv013, "Vòng 1 (HR Fit)",                0, "16:15:00", "Phòng Phỏng vấn Nhân sự 2",                   "SCHEDULED"},
            // 6 ca trong tuần
            {"UV-2026-012", 1,  nv012, "Vòng 1 (Kỹ thuật)",             1, "10:00:00", "Google Meet: meet.google.com/mix-hrm-tech",    "SCHEDULED"},
            {"UV-2026-013", 4,  nv014, "Vòng Đánh giá Năng lực Viết",   1, "15:30:00", "Phòng Họp Marketing Tầng 3",                  "SCHEDULED"},
            {"UV-2026-014", 7,  nv015, "Vòng Nghiệp vụ C&B",            2, "09:00:00", "Phòng Hội thảo Nhân sự",                      "SCHEDULED"},
            {"UV-2026-015", 8,  nv011, "Vòng Phỏng vấn Frontend Vue",   2, "14:30:00", "Google Meet: meet.google.com/frontend-vue",    "SCHEDULED"},
            {"UV-2026-016", 9,  nv013, "Vòng Đàm phán Doanh nghiệp",    3, "10:30:00", "Phòng Khách VIP B2B",                         "SCHEDULED"},
            {"UV-2026-017", 10, nv012, "Vòng Kiểm thử Tự động",         3, "16:00:00", "Phòng Lab Kỹ thuật",                          "SCHEDULED"}
        };
        try (PreparedStatement ps = conn.prepareStatement(insertIntSql)) {
            for (Object[] iv : interviews) {
                String candCode = (String) iv[0];
                int candId = candIdByCode.getOrDefault(candCode, -1);
                if (candId < 0) continue;
                int reqId   = (Integer) iv[1];
                int interId = (Integer) iv[2];
                String round = (String) iv[3];
                int dayOffset = (Integer) iv[4];
                java.time.LocalDate iDate = today.plusDays(dayOffset);
                java.sql.Time iTime = java.sql.Time.valueOf((String) iv[5]);
                String loc    = (String) iv[6];
                String status = (String) iv[7];

                ps.setInt(1, candId);
                ps.setInt(2, reqId);
                ps.setInt(3, interId);
                ps.setString(4, round);
                ps.setDate(5, java.sql.Date.valueOf(iDate));
                ps.setTime(6, iTime);
                ps.setString(7, loc);
                ps.setString(8, status);
                ps.addBatch();
            }
            ps.executeBatch();
        }

        System.out.println("[DatabaseInitializer] Đã nạp dữ liệu Tuyển dụng mẫu (12 YCTD, 86 ứng viên, 9 lịch phỏng vấn)!");
    }

    private static void syncDepartmentMetadata(Connection conn) {
        String[] updates = {
            "UPDATE departments SET code = 'BGD' WHERE name = 'Ban Giám đốc' AND (code IS NULL OR code = '')",
            "UPDATE departments SET code = 'HR' WHERE name = 'Phòng Nhân sự' AND (code IS NULL OR code = '')",
            "UPDATE departments SET code = 'KT' WHERE name = 'Phòng Kế toán' AND (code IS NULL OR code = '')",
            "UPDATE departments SET code = 'KD' WHERE name = 'Phòng Kinh doanh' AND (code IS NULL OR code = '')",
            "UPDATE departments SET code = 'MKT' WHERE name = 'Phòng Marketing' AND (code IS NULL OR code = '')",
            "UPDATE departments SET code = 'TECH' WHERE name = 'Phòng Kỹ thuật' AND (code IS NULL OR code = '')",
            "UPDATE departments SET manager_id = 1 WHERE code = 'BGD' AND manager_id IS NULL",
            "UPDATE departments SET manager_id = 2 WHERE code = 'HR' AND manager_id IS NULL",
            "UPDATE departments SET manager_id = 3 WHERE code = 'KT' AND manager_id IS NULL",
            "UPDATE departments SET manager_id = 5 WHERE code = 'KD' AND manager_id IS NULL",
            "UPDATE departments SET manager_id = 4 WHERE code = 'TECH' AND manager_id IS NULL"
        };
        for (String sql : updates) {
            try (Statement st = conn.createStatement()) {
                st.execute(sql);
            } catch (SQLException e) {
                System.err.println("[DatabaseInitializer] Cập nhật phòng ban cảnh báo: " + e.getMessage());
            }
        }
    }

    private static void seedBiometricsIfEmpty(Connection conn) throws SQLException {
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM biometric_devices")) {
            if (rs.next() && rs.getInt(1) > 0) return;
        }

        String insertDevSql = "INSERT INTO biometric_devices (device_code, name, type, location, ip_address, status, department_id, notes) VALUES "
            + "('FID-T1', 'Máy FaceID Cửa Chính Tầng 1', 'FACE_ID', 'Sảnh chính Tòa nhà Landmark 81', '192.168.1.201', 'ONLINE', 1, 'Hỗ trợ nhận diện AI camera góc rộng'), "
            + "('FID-T6', 'Máy FaceID Cửa Tầng 6 Khối Kỹ Thuật', 'FACE_ID', 'Cửa ra vào P. Kỹ thuật Tầng 6', '192.168.1.202', 'ONLINE', 6, 'Tích hợp mở khóa cửa tự động'), "
            + "('FP-T2', 'Máy Quét Vân Tay Sảnh Tầng 2', 'FINGERPRINT', 'Khu vực Lễ tân Tầng 2', '192.168.1.203', 'ONLINE', 2, 'Cảm biến vân tay quang học độ nhạy cao'), "
            + "('FP-T3', 'Máy Quét Vân Tay Tầng 3 (Kế toán)', 'FINGERPRINT', 'Cửa P. Tài chính Tầng 3', '192.168.1.204', 'ONLINE', 3, 'Bảo mật kép') "
            + "ON CONFLICT (device_code) DO NOTHING";
        try (Statement st = conn.createStatement()) {
            st.execute(insertDevSql);
        }

        String insertBioSql = "INSERT INTO employee_biometrics (employee_id, fingerprint_enrolled, fingerprint_device_id, face_enrolled, face_device_id, employee_card_id, active) VALUES "
            + "(1, TRUE, 3, TRUE, 1, 'CARD-001', TRUE), "
            + "(2, TRUE, 3, TRUE, 1, 'CARD-002', TRUE), "
            + "(3, TRUE, 4, TRUE, 1, 'CARD-003', TRUE), "
            + "(4, TRUE, 3, TRUE, 2, 'CARD-004', TRUE), "
            + "(5, TRUE, 3, TRUE, 1, 'CARD-005', TRUE), "
            + "(6, TRUE, 3, TRUE, 1, 'CARD-006', TRUE), "
            + "(7, TRUE, 3, TRUE, 2, 'CARD-007', TRUE) "
            + "ON CONFLICT (employee_id) DO NOTHING";
        try (Statement st = conn.createStatement()) {
            st.execute(insertBioSql);
        }
        System.out.println("[DatabaseInitializer] Đã nạp dữ liệu Máy chấm công và Sinh trắc học nhân viên!");
    }

    private static void seedSystemSettingsIfEmpty(Connection conn) throws SQLException {
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM system_settings")) {
            if (rs.next() && rs.getInt(1) > 0) return;
        }

        String insertSql = "INSERT INTO system_settings (setting_key, setting_value, category, description) VALUES (?, ?, ?, ?) "
            + "ON CONFLICT (setting_key) DO NOTHING";
        Object[][] settings = {
            {"company_full_name", "CÔNG TY CỔ PHẦN CÔNG NGHỆ & DỊCH VỤ MIXIMOI VIỆT NAM", "GENERAL", "Tên đầy đủ theo ĐKKD"},
            {"company_short_name", "MIXIMOI CORP", "GENERAL", "Tên giao dịch viết tắt"},
            {"tax_code", "0316888999", "GENERAL", "Mã số thuế doanh nghiệp"},
            {"legal_rep", "Nguyễn Văn An", "GENERAL", "Người đại diện pháp luật"},
            {"legal_title", "Tổng Giám Đốc", "GENERAL", "Chức danh người đại diện"},
            {"company_address", "Tầng 18, Tòa nhà Landmark 81, 720A Điện Biên Phủ, Phường 22, Bình Thạnh, TP. Hồ Chí Minh", "GENERAL", "Trụ sở chính"},
            {"company_phone", "028 7300 8888", "GENERAL", "Hotline tổng đài"},
            {"company_website", "https://miximoi.vn", "GENERAL", "Website chính thức"},
            {"system_email", "contact@miximoi.vn", "GENERAL", "Email hệ thống"},
            {"billing_email", "accounting@miximoi.vn", "GENERAL", "Email kế toán hóa đơn"},
            {"emp_code_prefix", "NV", "EMP_CODE", "Tiền tố mã nhân viên"},
            {"emp_code_digits", "4", "EMP_CODE", "Độ dài số tự tăng"},
            {"emp_code_format", "YYYY", "EMP_CODE", "Format năm"},
            {"auto_gen_code", "true", "EMP_CODE", "Tự động tạo mã"},
            {"work_start_time", "08:30", "TIME_ATTENDANCE", "Giờ bắt đầu làm việc"},
            {"work_end_time", "18:00", "TIME_ATTENDANCE", "Giờ kết thúc làm việc"},
            {"standard_daily_hours", "8.0", "TIME_ATTENDANCE", "Số giờ làm việc chuẩn/ngày"},
            {"grace_late_minutes", "15", "TIME_ATTENDANCE", "Số phút cho phép đi muộn không phạt"},
            {"max_late_per_month", "3", "TIME_ATTENDANCE", "Số lần đi muộn tối đa trong tháng"},
            {"timesheet_cutoff_day", "25", "PAYROLL", "Ngày chốt bảng công hàng tháng"},
            {"payroll_pay_day", "5", "PAYROLL", "Ngày chi trả lương chính thức"},
            {"base_insurance_salary", "2.340.000", "PAYROLL", "Mức lương cơ sở đóng BHXH"},
            {"personal_tax_deduction", "11.000.000", "PAYROLL", "Giảm trừ gia cảnh bản thân"},
            {"dependent_tax_deduction", "4.400.000", "PAYROLL", "Giảm trừ mỗi người phụ thuộc"},
            {"require_2fa", "true", "SECURITY", "Bắt buộc xác thực 2FA"}
        };
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (Object[] s : settings) {
                ps.setString(1, (String) s[0]);
                ps.setString(2, (String) s[1]);
                ps.setString(3, (String) s[2]);
                ps.setString(4, (String) s[3]);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[DatabaseInitializer] Đã nạp 25 cấu hình hệ thống mặc định!");
        }
    }

    private static void seedPerformanceAndKpiIfEmpty(Connection conn) throws SQLException {
        // Performance Cycles
        try (Statement st = conn.createStatement()) {
            st.execute("INSERT INTO performance_cycles (name, start_date, end_date, status) VALUES "
                + "('Q3/2026', '2026-07-01', '2026-09-30', 'OPEN'), "
                + "('Q2/2026', '2026-04-01', '2026-06-30', 'CLOSED') "
                + "ON CONFLICT (name) DO NOTHING");
        }

        // KPI Metrics
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM kpi_metrics")) {
            if (rs.next() && rs.getInt(1) == 0) {
                String insertKpi = "INSERT INTO kpi_metrics (kpi_code, title, employee_id, department_id, quarter, target_value, current_value, unit, weight_pct, deadline, status) VALUES "
                    + "('KPI-IT-042', 'Triển khai Microservices & Bảo đảm SLA Uptime 99.9%', 4, 6, 'Q3/2026', 100.0, 102.0, '%', 35.0, '2026-09-30', 'APPROVED'), "
                    + "('KPI-IT-043', 'Tối ưu hóa chi phí AWS Cloud tiết kiệm 15%', 4, 6, 'Q3/2026', 15.0, 9.2, '%', 25.0, '2026-09-28', 'IN_PROGRESS'), "
                    + "('KPI-IT-044', 'Code Review & Kèm cặp 2 Junior Developers', 7, 6, 'Q3/2026', 2.0, 2.0, 'Nhân sự', 20.0, '2026-09-30', 'APPROVED'), "
                    + "('KPI-HR-012', 'Tuyển dụng 10 Kỹ sư phần mềm cho dự án Core', 2, 2, 'Q3/2026', 10.0, 8.0, 'Ứng sự', 40.0, '2026-09-30', 'IN_PROGRESS'), "
                    + "('KPI-HR-015', 'Tổ chức đào tạo nâng cao kỹ năng quý 3', 8, 2, 'Q3/2026', 4.0, 4.0, 'Khóa học', 30.0, '2026-09-20', 'APPROVED'), "
                    + "('KPI-KT-021', 'Quyết toán thuế & Lập báo cáo tài chính quý 3', 3, 3, 'Q3/2026', 100.0, 95.0, '%', 50.0, '2026-09-30', 'IN_PROGRESS'), "
                    + "('KPI-KT-022', 'Rút ngắn thời gian chốt bảng lương dưới 3 ngày', 9, 3, 'Q3/2026', 3.0, 2.5, 'Ngày công', 30.0, '2026-09-30', 'APPROVED'), "
                    + "('KPI-KD-081', 'Doanh số phát triển khách hàng Enterprise mới', 5, 4, 'Q3/2026', 500.0, 480.0, 'Triệu VNĐ', 45.0, '2026-09-30', 'IN_PROGRESS'), "
                    + "('KPI-MKT-031', 'Tăng nhận diện thương hiệu & Lead chuyển đổi', 6, 5, 'Q3/2026', 1200.0, 1350.0, 'Lead', 35.0, '2026-09-30', 'APPROVED') "
                    + "ON CONFLICT (kpi_code) DO NOTHING";
                try (Statement stKpi = conn.createStatement()) {
                    stKpi.execute(insertKpi);
                }
            }
        }

        // Performance Evaluations
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM performance_evaluations")) {
            if (rs.next() && rs.getInt(1) == 0) {
                String insertEval = "INSERT INTO performance_evaluations (evaluation_code, employee_id, evaluator_id, quarter, kpi_score, competency_score, culture_score, innovation_score, final_score, grade, status, feedback) VALUES "
                    + "('EVAL-Q3-042', 4, 1, 'Q3/2026', 9.4, 8.8, 9.0, 7.6, 8.96, 'A+', 'CONFIRMED', 'Hoàn thành xuất sắc nhiệm vụ kiến trúc và tối ưu hệ thống, phối hợp nhóm hiệu quả.'), "
                    + "('EVAL-Q3-018', 6, 1, 'Q3/2026', 8.8, 8.5, 8.2, 7.0, 8.36, 'A', 'CONFIRMED', 'Dẫn dắt các chiến dịch Marketing hiệu quả vượt chỉ tiêu lead thu về.'), "
                    + "('EVAL-Q3-089', 5, 1, 'Q3/2026', 8.0, 7.8, 8.0, 7.0, 7.84, 'B', 'SUBMITTED', 'Nỗ lực mở rộng khách hàng doanh nghiệp, cần cải thiện năng lực đàm phán hợp đồng lớn.'), "
                    + "('EVAL-Q3-007', 7, 4, 'Q3/2026', 9.0, 8.5, 8.5, 8.0, 8.65, 'A', 'CONFIRMED', 'Kỹ năng lập trình tốt, tích cực hỗ trợ đồng đội trong sprint.'), "
                    + "('EVAL-Q3-002', 2, 1, 'Q3/2026', 8.5, 8.5, 9.0, 8.0, 8.55, 'A', 'CONFIRMED', 'Tuyển dụng đáp ứng đúng tiến độ mở rộng các phòng ban.') "
                    + "ON CONFLICT (evaluation_code) DO NOTHING";
                try (Statement stEval = conn.createStatement()) {
                    stEval.execute(insertEval);
                }
            }
        }
        System.out.println("[DatabaseInitializer] Đã nạp dữ liệu Kỳ đánh giá, KPI và Hiệu suất nhân sự mẫu!");
    }
}

