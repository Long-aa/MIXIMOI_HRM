-- =============================================================
-- MIXIMOI HRM & PAYROLL — Database Schema PostgreSQL
-- =============================================================

-- Tạo database (chạy trước khi execute file này)
-- CREATE DATABASE miximoi_hrm;

-- =============================================================
-- 1. PHÂN QUYỀN
-- =============================================================

CREATE TABLE IF NOT EXISTS roles (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,  -- ADMIN | HR | ACCOUNTANT | MANAGER | EMPLOYEE
    description TEXT
);

-- =============================================================
-- 2. TÀI KHOẢN NGƯỜI DÙNG
-- =============================================================

CREATE TABLE IF NOT EXISTS users (
    id          SERIAL PRIMARY KEY,
    username    VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,         -- BCrypt hash
    role        VARCHAR(50)  NOT NULL DEFAULT 'EMPLOYEE',
    employee_id INTEGER,                       -- Liên kết nhân viên (nullable với admin)
    active      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP
);

-- =============================================================
-- 3. LOẠI NHÂN VIÊN
-- =============================================================

CREATE TABLE IF NOT EXISTS employee_types (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- =============================================================
-- 4. PHÒNG BAN
-- =============================================================

CREATE TABLE IF NOT EXISTS departments (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(150) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- 5. CHỨC VỤ
-- =============================================================

CREATE TABLE IF NOT EXISTS positions (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(150) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- 6. NHÂN VIÊN
-- =============================================================

CREATE TABLE IF NOT EXISTS employees (
    id               SERIAL PRIMARY KEY,
    employee_code    VARCHAR(20)  NOT NULL UNIQUE,
    full_name        VARCHAR(200) NOT NULL,
    date_of_birth    DATE,
    gender           VARCHAR(10),              -- MALE | FEMALE | OTHER
    phone            VARCHAR(20),
    email            VARCHAR(150),
    address          TEXT,
    department_id    INTEGER REFERENCES departments(id),
    position_id      INTEGER REFERENCES positions(id),
    employee_type_id INTEGER REFERENCES employee_types(id),
    start_date       DATE,
    status           VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',  -- ACTIVE | INACTIVE | ON_LEAVE
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP
);

-- Index thường dùng
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department_id);
CREATE INDEX IF NOT EXISTS idx_employees_status     ON employees(status);
CREATE INDEX IF NOT EXISTS idx_employees_code       ON employees(employee_code);

-- Thêm khóa ngoại users → employees sau khi tạo employees
DO $do$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_users_employee') THEN
        ALTER TABLE users ADD CONSTRAINT fk_users_employee
            FOREIGN KEY (employee_id) REFERENCES employees(id);
    END IF;
END $do$;

-- =============================================================
-- 7. HỢP ĐỒNG LAO ĐỘNG
-- =============================================================

CREATE TABLE IF NOT EXISTS contracts (
    id            SERIAL PRIMARY KEY,
    contract_code VARCHAR(50)    NOT NULL UNIQUE,
    employee_id   INTEGER        NOT NULL REFERENCES employees(id),
    contract_type VARCHAR(50)    NOT NULL,    -- FIXED_TERM | INDEFINITE | SEASONAL | COLLABORATOR
    start_date    DATE           NOT NULL,
    end_date      DATE,                       -- NULL = không xác định thời hạn
    base_salary   NUMERIC(15,0)  NOT NULL DEFAULT 0,
    status        VARCHAR(30)    NOT NULL DEFAULT 'ACTIVE',
    notes         TEXT,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_contracts_employee ON contracts(employee_id);
CREATE INDEX IF NOT EXISTS idx_contracts_status   ON contracts(status);

-- =============================================================
-- 8. CA LÀM VIỆC
-- =============================================================

CREATE TABLE IF NOT EXISTS work_shifts (
    id             SERIAL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL UNIQUE,
    start_time     TIME         NOT NULL,
    end_time       TIME         NOT NULL,
    standard_hours NUMERIC(4,1) NOT NULL DEFAULT 8.0,
    description    TEXT
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_work_shifts_name ON work_shifts(name);

-- =============================================================
-- 9. CHẤM CÔNG
-- =============================================================

CREATE TABLE IF NOT EXISTS attendance (
    id                  SERIAL PRIMARY KEY,
    employee_id         INTEGER       NOT NULL REFERENCES employees(id),
    work_date           DATE          NOT NULL,
    check_in            TIME,
    check_out           TIME,
    total_hours         NUMERIC(4,1)  NOT NULL DEFAULT 0,
    status              VARCHAR(20)   NOT NULL DEFAULT 'ON_TIME',  -- ON_TIME | LATE | EARLY_LEAVE | ABSENT | OVERTIME | WORKING | COMPLETE
    notes               TEXT,
    -- ===== CHẤM CÔNG SINH TRẮC HỌC (VÂN TAY / FACE ID / GPS) =====
    method              VARCHAR(50)   DEFAULT 'MANUAL',   -- FACE_ID | FINGERPRINT | GPS | MANUAL | QR_CODE
    device_id           VARCHAR(50),                       -- Mã máy chấm công
    device_name         VARCHAR(150),                      -- Tên/vị trí máy chấm công
    check_out_method    VARCHAR(50),                       -- Phương thức check-out
    face_image_url      VARCHAR(255),                      -- URL ảnh khuôn mặt chụp khi chấm công
    confidence_score    NUMERIC(5,2),                      -- Độ chính xác nhận dạng (0-100%)
    -- ==============================
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (employee_id, work_date)
);

CREATE INDEX IF NOT EXISTS idx_attendance_employee  ON attendance(employee_id);
CREATE INDEX IF NOT EXISTS idx_attendance_work_date ON attendance(work_date);

-- =============================================================
-- 10. ĐƠN NGHỈ PHÉP
-- =============================================================

CREATE TABLE IF NOT EXISTS leave_requests (
    id             SERIAL PRIMARY KEY,
    leave_code     VARCHAR(50) NOT NULL UNIQUE,
    employee_id    INTEGER     NOT NULL REFERENCES employees(id),
    leave_type     VARCHAR(50) NOT NULL,  -- ANNUAL | SICK | PERSONAL | MATERNITY | UNPAID
    start_date     DATE        NOT NULL,
    end_date       DATE        NOT NULL,
    total_days     INTEGER     NOT NULL DEFAULT 1,
    reason         TEXT,
    status         VARCHAR(20) NOT NULL DEFAULT 'PENDING',  -- PENDING | APPROVED | REJECTED | CANCELLED
    approved_by_id INTEGER REFERENCES employees(id),
    approved_at    TIMESTAMP,
    reject_reason  TEXT,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_leave_employee ON leave_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_leave_status   ON leave_requests(status);

-- =============================================================
-- 11. TĂNG CA
-- =============================================================

CREATE TABLE IF NOT EXISTS overtime (
    id             SERIAL PRIMARY KEY,
    overtime_code  VARCHAR(50)   UNIQUE,
    employee_id    INTEGER       NOT NULL REFERENCES employees(id),
    overtime_date  DATE          NOT NULL,
    hours          NUMERIC(4,1)  NOT NULL,
    coefficient    NUMERIC(3,1)  NOT NULL DEFAULT 1.5,  -- 1.5x | 2.0x | 3.0x
    amount         NUMERIC(15,0) NOT NULL DEFAULT 0,
    reason         TEXT,
    status         VARCHAR(20)   NOT NULL DEFAULT 'PENDING',  -- PENDING | APPROVED | REJECTED
    approved_by_id INTEGER REFERENCES employees(id),
    approved_at    TIMESTAMP,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_overtime_employee ON overtime(employee_id);
CREATE INDEX IF NOT EXISTS idx_overtime_date     ON overtime(overtime_date);

-- =============================================================
-- 12. CẤU HÌNH LƯƠNG (Phụ cấp)
-- =============================================================

CREATE TABLE IF NOT EXISTS allowances (
    id          SERIAL PRIMARY KEY,
    employee_id INTEGER       NOT NULL REFERENCES employees(id),
    name        VARCHAR(150)  NOT NULL,   -- Phụ cấp ăn trưa, xăng xe, điện thoại...
    amount      NUMERIC(15,0) NOT NULL DEFAULT 0,
    start_date  DATE          NOT NULL,
    end_date    DATE,
    active      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- 13. THƯỞNG
-- =============================================================

CREATE TABLE IF NOT EXISTS bonuses (
    id          SERIAL PRIMARY KEY,
    employee_id INTEGER       NOT NULL REFERENCES employees(id),
    name        VARCHAR(150)  NOT NULL,   -- Thưởng hiệu suất, thưởng Tết...
    amount      NUMERIC(15,0) NOT NULL DEFAULT 0,
    bonus_date  DATE          NOT NULL,
    pay_month   INTEGER,
    pay_year    INTEGER,
    notes       TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- 14. BẢNG LƯƠNG
-- =============================================================

CREATE TABLE IF NOT EXISTS payroll (
    id              SERIAL PRIMARY KEY,
    employee_id     INTEGER       NOT NULL REFERENCES employees(id),
    pay_month       INTEGER       NOT NULL,  -- 1-12
    pay_year        INTEGER       NOT NULL,
    base_salary     NUMERIC(15,0) NOT NULL DEFAULT 0,
    working_days    NUMERIC(4,1)  NOT NULL DEFAULT 0,
    standard_days   NUMERIC(4,1)  NOT NULL DEFAULT 26,
    overtime_amount NUMERIC(15,0) NOT NULL DEFAULT 0,
    allowance       NUMERIC(15,0) NOT NULL DEFAULT 0,
    bonus           NUMERIC(15,0) NOT NULL DEFAULT 0,
    deduction       NUMERIC(15,0) NOT NULL DEFAULT 0,
    net_salary      NUMERIC(15,0) NOT NULL DEFAULT 0,
    status          VARCHAR(30)   NOT NULL DEFAULT 'DRAFT',
    created_by_id   INTEGER REFERENCES users(id),
    approved_by_id  INTEGER REFERENCES employees(id),
    approved_at     TIMESTAMP,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP,
    UNIQUE (employee_id, pay_month, pay_year)
);

CREATE INDEX IF NOT EXISTS idx_payroll_employee ON payroll(employee_id);
CREATE INDEX IF NOT EXISTS idx_payroll_period   ON payroll(pay_month, pay_year);
CREATE INDEX IF NOT EXISTS idx_payroll_status   ON payroll(status);

-- =============================================================
-- 15. THANH TOÁN
-- =============================================================

CREATE TABLE IF NOT EXISTS payments (
    id              SERIAL PRIMARY KEY,
    payroll_id      INTEGER       NOT NULL REFERENCES payroll(id),
    employee_id     INTEGER       NOT NULL REFERENCES employees(id),
    amount          NUMERIC(15,0) NOT NULL,
    payment_date    DATE          NOT NULL,
    payment_method  VARCHAR(50)   NOT NULL DEFAULT 'BANK_TRANSFER',  -- BANK_TRANSFER | CASH
    status          VARCHAR(30)   NOT NULL DEFAULT 'PENDING',         -- PENDING | COMPLETED
    notes           TEXT,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- 16. THÔNG BÁO
-- =============================================================

CREATE TABLE IF NOT EXISTS notifications (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER     NOT NULL REFERENCES users(id),
    title       VARCHAR(255) NOT NULL,
    message     TEXT,
    type        VARCHAR(50) NOT NULL DEFAULT 'INFO',  -- INFO | WARNING | SUCCESS | DANGER
    is_read     BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_notifications_user   ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id, is_read);

-- =============================================================
-- 17. NHẬT KÝ HOẠT ĐỘNG (Audit Log)
-- =============================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER      REFERENCES users(id),
    username    VARCHAR(100),
    action      VARCHAR(50)  NOT NULL,  -- CREATE | UPDATE | DELETE | APPROVE | REJECT | LOGIN | LOGOUT
    module      VARCHAR(100),           -- EMPLOYEE | PAYROLL | LEAVE...
    object_id   INTEGER,
    description TEXT,
    ip_address  VARCHAR(50),
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_audit_user   ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_module ON audit_logs(module);
CREATE INDEX IF NOT EXISTS idx_audit_time   ON audit_logs(created_at);

-- =============================================================
-- 18. THIẾT BỊ CHẤM CÔNG SINH TRẮC HỌC
--     (Máy Vân Tay + Máy FaceID)
-- =============================================================

CREATE TABLE IF NOT EXISTS biometric_devices (
    id           SERIAL PRIMARY KEY,
    device_code  VARCHAR(50)  NOT NULL UNIQUE,    -- Mã máy: CC-01, FID-01, FP-01...
    name         VARCHAR(150) NOT NULL,             -- Tên máy: Máy chấm công FaceID tầng 1
    type         VARCHAR(30)  NOT NULL,             -- FACE_ID | FINGERPRINT | DUAL (cả hai)
    location     VARCHAR(200),                      -- Vị trí lắp đặt (cửa chính, tầng 2...)
    ip_address   VARCHAR(50),                       -- IP thiết bị trong mạng nội bộ
    mac_address  VARCHAR(50),                       -- MAC address
    firmware     VARCHAR(50),                       -- Phiên bản firmware
    status       VARCHAR(20) NOT NULL DEFAULT 'ONLINE', -- ONLINE | OFFLINE | MAINTENANCE
    department_id INTEGER REFERENCES departments(id),   -- Thiết bị phụ trách phòng ban nào
    notes        TEXT,
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_biometric_device_status ON biometric_devices(status);
CREATE INDEX IF NOT EXISTS idx_biometric_device_type   ON biometric_devices(type);

-- =============================================================
-- 19. DỮ LIỆU SINH TRẮC HỌC NHÂN VIÊN
--     (Template Vân Tay & Ảnh khuôn mặt đăng ký FaceID)
-- =============================================================

CREATE TABLE IF NOT EXISTS employee_biometrics (
    id                  SERIAL PRIMARY KEY,
    employee_id         INTEGER NOT NULL REFERENCES employees(id) UNIQUE,
    -- Vân tay (Fingerprint)
    fingerprint_template_1  TEXT,       -- Template vân tay ngón 1 (mã hóa Base64)
    fingerprint_template_2  TEXT,       -- Template vân tay ngón 2 (dự phòng)
    fingerprint_enrolled    BOOLEAN NOT NULL DEFAULT FALSE,
    fingerprint_device_id   INTEGER REFERENCES biometric_devices(id),
    fingerprint_enrolled_at TIMESTAMP,
    -- Nhận diện khuôn mặt (FaceID)
    face_image_url          VARCHAR(255),   -- Ảnh khuôn mặt gốc đăng ký
    face_embedding_ref      TEXT,           -- Reference embedding / feature vector (mã hóa)
    face_enrolled           BOOLEAN NOT NULL DEFAULT FALSE,
    face_device_id          INTEGER REFERENCES biometric_devices(id),
    face_enrolled_at        TIMESTAMP,
    -- Thông tin chung
    employee_card_id        VARCHAR(50),    -- Mã thẻ chấm công (nếu dùng thẻ từ thay thế)
    active                  BOOLEAN NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP
);

-- =============================================================
-- 20. BỔ SUNG CÁC CỘT CÒN THIẾU (ALTER TABLE)
-- =============================================================

-- Phòng ban: thêm mã phòng ban, trưởng phòng, trạng thái
ALTER TABLE departments
    ADD COLUMN IF NOT EXISTS code        VARCHAR(20),
    ADD COLUMN IF NOT EXISTS manager_id  INTEGER REFERENCES employees(id),
    ADD COLUMN IF NOT EXISTS status      VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',   -- ACTIVE | RESTRUCTURING | INACTIVE
    ADD COLUMN IF NOT EXISTS updated_at  TIMESTAMP;

-- Chỉnh sửa code phòng ban phải UNIQUE
CREATE UNIQUE INDEX IF NOT EXISTS idx_departments_code ON departments(code) WHERE code IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_departments_status      ON departments(status);

-- Hợp đồng lao động: bổ sung các trường chuẩn pháp lý (Bộ Luật Lao Động 2019)
ALTER TABLE contracts
    ADD COLUMN IF NOT EXISTS signer_name          VARCHAR(200),   -- Người ký (đại diện công ty)
    ADD COLUMN IF NOT EXISTS signer_title         VARCHAR(100),   -- Chức danh người ký
    ADD COLUMN IF NOT EXISTS work_location        VARCHAR(300),   -- Địa điểm làm việc
    ADD COLUMN IF NOT EXISTS job_description      TEXT,           -- Mô tả công việc & nhiệm vụ chính
    ADD COLUMN IF NOT EXISTS probation_months     INTEGER DEFAULT 0,  -- Số tháng thử việc (0 nếu không có)
    ADD COLUMN IF NOT EXISTS probation_salary_pct NUMERIC(5,2) DEFAULT 85.0, -- % lương trong thời gian thử việc
    ADD COLUMN IF NOT EXISTS allowance_amount     NUMERIC(15,0) DEFAULT 0,   -- Tổng phụ cấp kèm theo HĐ
    ADD COLUMN IF NOT EXISTS signed_date          DATE,           -- Ngày ký hợp đồng thực tế
    ADD COLUMN IF NOT EXISTS identity_number      VARCHAR(20),    -- CCCD/CMND của NLĐ (lưu trong HĐ)
    ADD COLUMN IF NOT EXISTS identity_date        DATE,           -- Ngày cấp CCCD
    ADD COLUMN IF NOT EXISTS identity_place       VARCHAR(200),   -- Nơi cấp CCCD
    ADD COLUMN IF NOT EXISTS contract_file_url    VARCHAR(500);   -- Đường dẫn file HĐ (PDF scan)

-- Attendance: thêm index cho method
CREATE INDEX IF NOT EXISTS idx_attendance_method    ON attendance(method);
CREATE INDEX IF NOT EXISTS idx_attendance_device    ON attendance(device_id);

-- Overtime: bổ sung các trường nghiệp vụ nâng cao
ALTER TABLE overtime
    ADD COLUMN IF NOT EXISTS overtime_code    VARCHAR(50),
    ADD COLUMN IF NOT EXISTS project_name     VARCHAR(255),
    ADD COLUMN IF NOT EXISTS start_time       TIME,
    ADD COLUMN IF NOT EXISTS end_time         TIME,
    ADD COLUMN IF NOT EXISTS ot_type          VARCHAR(50) DEFAULT 'REGULAR',
    ADD COLUMN IF NOT EXISTS lead_approver_id INTEGER REFERENCES employees(id),
    ADD COLUMN IF NOT EXISTS lead_status      VARCHAR(20) DEFAULT 'PENDING',
    ADD COLUMN IF NOT EXISTS lead_approved_at TIMESTAMP,
    ADD COLUMN IF NOT EXISTS hr_status        VARCHAR(20) DEFAULT 'PENDING',
    ADD COLUMN IF NOT EXISTS reject_reason    TEXT;

DO $do$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_overtime_code') THEN
        ALTER TABLE overtime ADD CONSTRAINT uq_overtime_code UNIQUE (overtime_code);
    END IF;
END $do$;

-- =============================================================
-- 21. YÊU CẦU TUYỂN DỤNG (Recruitment Requests)
-- =============================================================

CREATE TABLE IF NOT EXISTS recruitment_requests (
    id               SERIAL PRIMARY KEY,
    request_code     VARCHAR(50) NOT NULL UNIQUE,
    title            VARCHAR(250) NOT NULL,
    department_id    INTEGER REFERENCES departments(id),
    position_id      INTEGER REFERENCES positions(id),
    target_headcount INTEGER NOT NULL DEFAULT 1,
    hired_count      INTEGER NOT NULL DEFAULT 0,
    salary_min       NUMERIC(15,0) DEFAULT 0,
    salary_max       NUMERIC(15,0) DEFAULT 0,
    salary_negotiable BOOLEAN DEFAULT FALSE,
    deadline         DATE NOT NULL,
    priority         VARCHAR(20) NOT NULL DEFAULT 'NORMAL', -- NORMAL | URGENT | HOT
    status           VARCHAR(30) NOT NULL DEFAULT 'OPEN',   -- OPEN | PAUSED | FILLED | CLOSED
    quarter          VARCHAR(20) NOT NULL DEFAULT 'Q3/2026',
    assignee_id      INTEGER REFERENCES employees(id),
    description      TEXT,
    requirements     TEXT,
    benefits         TEXT,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_rec_req_status ON recruitment_requests(status);
CREATE INDEX IF NOT EXISTS idx_rec_req_quarter ON recruitment_requests(quarter);
CREATE INDEX IF NOT EXISTS idx_rec_req_dept ON recruitment_requests(department_id);

-- =============================================================
-- 22. ỨNG VIÊN (Candidates)
-- =============================================================

CREATE TABLE IF NOT EXISTS candidates (
    id                     SERIAL PRIMARY KEY,
    candidate_code         VARCHAR(50) NOT NULL UNIQUE,
    full_name              VARCHAR(200) NOT NULL,
    email                  VARCHAR(150),
    phone                  VARCHAR(20),
    recruitment_request_id INTEGER NOT NULL REFERENCES recruitment_requests(id) ON DELETE CASCADE,
    source                 VARCHAR(50) NOT NULL DEFAULT 'LinkedIn', -- LinkedIn | TopCV/VNW | Nội bộ (Ref) | Khác
    stage                  VARCHAR(50) NOT NULL DEFAULT 'NEW',       -- NEW | SCREENING | INTERVIEW | OFFER | ONBOARDED | REJECTED
    experience_years       NUMERIC(4,1) DEFAULT 0,
    expected_salary        NUMERIC(15,0) DEFAULT 0,
    cv_url                 VARCHAR(255),
    notes                  TEXT,
    applied_date           DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_cand_request ON candidates(recruitment_request_id);
CREATE INDEX IF NOT EXISTS idx_cand_stage ON candidates(stage);
CREATE INDEX IF NOT EXISTS idx_cand_source ON candidates(source);

-- =============================================================
-- 23. LỊCH PHỎNG VẤN (Interviews)
-- =============================================================

CREATE TABLE IF NOT EXISTS interviews (
    id                     SERIAL PRIMARY KEY,
    candidate_id           INTEGER NOT NULL REFERENCES candidates(id) ON DELETE CASCADE,
    recruitment_request_id INTEGER REFERENCES recruitment_requests(id) ON DELETE CASCADE,
    interviewer_id         INTEGER REFERENCES employees(id),
    round_name             VARCHAR(150) NOT NULL,
    interview_date         DATE NOT NULL,
    interview_time         TIME NOT NULL,
    location_or_link       VARCHAR(255) DEFAULT 'Phòng họp Tầng 3 (HQ)',
    status                 VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED', -- SCHEDULED | COMPLETED | CANCELLED | PASSED | FAILED
    feedback               TEXT,
    score                  NUMERIC(3,1),
    created_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_interview_date ON interviews(interview_date);
CREATE INDEX IF NOT EXISTS idx_interview_cand ON interviews(candidate_id);

-- =============================================================
-- 24. CẤU HÌNH THANG BẢNG LƯƠNG & QUY CHẾ (Salary Configs)
-- =============================================================

CREATE TABLE IF NOT EXISTS salary_configs (
    id           SERIAL PRIMARY KEY,
    config_key   VARCHAR(50) NOT NULL UNIQUE,
    config_value VARCHAR(255) NOT NULL,
    description  TEXT,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- 25. KHẤU TRỪ & TẠM ỨNG LƯƠNG (Salary Deductions)
-- =============================================================

CREATE TABLE IF NOT EXISTS salary_deductions (
    id             SERIAL PRIMARY KEY,
    employee_id    INTEGER NOT NULL REFERENCES employees(id),
    deduction_type VARCHAR(50) NOT NULL, -- ADVANCE | UNION_FEE | DISCIPLINE | OTHER
    amount         NUMERIC(15,0) NOT NULL DEFAULT 0,
    pay_month      INTEGER NOT NULL,
    pay_year       INTEGER NOT NULL,
    description    TEXT,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_deductions_employee ON salary_deductions(employee_id);
CREATE INDEX IF NOT EXISTS idx_deductions_period   ON salary_deductions(pay_month, pay_year);

-- =============================================================
-- 26. KỲ ĐÁNH GIÁ (Performance Cycles)
-- =============================================================

CREATE TABLE IF NOT EXISTS performance_cycles (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,  -- Q3/2026, Q2/2026, ...
    start_date  DATE NOT NULL,
    end_date    DATE NOT NULL,
    status      VARCHAR(30) NOT NULL DEFAULT 'OPEN', -- OPEN | CLOSED | DRAFT
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- 27. CHỈ TIÊU KPI (Kpi Metrics)
-- =============================================================

CREATE TABLE IF NOT EXISTS kpi_metrics (
    id             SERIAL PRIMARY KEY,
    kpi_code       VARCHAR(50) NOT NULL UNIQUE,
    title          VARCHAR(255) NOT NULL,
    employee_id    INTEGER NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    department_id  INTEGER REFERENCES departments(id),
    quarter        VARCHAR(30) NOT NULL DEFAULT 'Q3/2026',
    target_value   NUMERIC(10,2) NOT NULL DEFAULT 100.0,
    current_value  NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    unit           VARCHAR(50) NOT NULL DEFAULT '%', -- %, Triệu VNĐ, Khách hàng, Giờ, ...
    weight_pct     NUMERIC(5,2) NOT NULL DEFAULT 20.0, -- Trọng số %
    deadline       DATE,
    status         VARCHAR(30) NOT NULL DEFAULT 'IN_PROGRESS', -- IN_PROGRESS | APPROVED | OVERDUE | NEEDS_IMPROVEMENT
    notes          TEXT,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_kpi_employee ON kpi_metrics(employee_id);
CREATE INDEX IF NOT EXISTS idx_kpi_dept ON kpi_metrics(department_id);
CREATE INDEX IF NOT EXISTS idx_kpi_quarter ON kpi_metrics(quarter);
CREATE INDEX IF NOT EXISTS idx_kpi_status ON kpi_metrics(status);

-- =============================================================
-- 28. ĐÁNH GIÁ HIỆU SUẤT NHÂN SỰ (Performance Evaluations)
-- =============================================================

CREATE TABLE IF NOT EXISTS performance_evaluations (
    id                SERIAL PRIMARY KEY,
    evaluation_code   VARCHAR(50) NOT NULL UNIQUE,
    employee_id       INTEGER NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    evaluator_id      INTEGER REFERENCES employees(id),
    quarter           VARCHAR(30) NOT NULL DEFAULT 'Q3/2026',
    kpi_score         NUMERIC(4,2) NOT NULL DEFAULT 0.0, -- Thang điểm 10 (Trọng số 40%)
    competency_score  NUMERIC(4,2) NOT NULL DEFAULT 0.0, -- Thang điểm 10 (Trọng số 30%)
    culture_score     NUMERIC(4,2) NOT NULL DEFAULT 0.0, -- Thang điểm 10 (Trọng số 20%)
    innovation_score  NUMERIC(4,2) NOT NULL DEFAULT 0.0, -- Thang điểm 10 (Trọng số 10%)
    final_score       NUMERIC(4,2) NOT NULL DEFAULT 0.0, -- Tính tổng hợp: kpi*0.4 + comp*0.3 + cult*0.2 + inno*0.1
    grade             VARCHAR(30) NOT NULL DEFAULT 'B',  -- A+ (Xuất sắc) | A (Tốt) | B (Khá) | C (Cần cải thiện) | D (Không đạt)
    status            VARCHAR(30) NOT NULL DEFAULT 'PENDING', -- PENDING | DRAFT | SUBMITTED | CONFIRMED
    feedback          TEXT,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_eval_employee ON performance_evaluations(employee_id);
CREATE INDEX IF NOT EXISTS idx_eval_quarter ON performance_evaluations(quarter);
CREATE INDEX IF NOT EXISTS idx_eval_status ON performance_evaluations(status);

-- =============================================================
-- 29. THIẾT LẬP HỆ THỐNG DOANH NGHIỆP (System Settings)
-- =============================================================

CREATE TABLE IF NOT EXISTS system_settings (
    setting_key    VARCHAR(100) PRIMARY KEY,
    setting_value  TEXT,
    category       VARCHAR(50) NOT NULL DEFAULT 'GENERAL', -- GENERAL | EMP_CODE | TIME_ATTENDANCE | PAYROLL | SECURITY
    description    VARCHAR(255),
    updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
