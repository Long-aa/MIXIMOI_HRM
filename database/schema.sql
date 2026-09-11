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
ALTER TABLE users ADD CONSTRAINT fk_users_employee
    FOREIGN KEY (employee_id) REFERENCES employees(id);

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
    name           VARCHAR(100) NOT NULL,
    start_time     TIME         NOT NULL,
    end_time       TIME         NOT NULL,
    standard_hours NUMERIC(4,1) NOT NULL DEFAULT 8.0,
    description    TEXT
);

-- =============================================================
-- 9. CHẤM CÔNG
-- =============================================================

CREATE TABLE IF NOT EXISTS attendance (
    id          SERIAL PRIMARY KEY,
    employee_id INTEGER       NOT NULL REFERENCES employees(id),
    work_date   DATE          NOT NULL,
    check_in    TIME,
    check_out   TIME,
    total_hours NUMERIC(4,1)  NOT NULL DEFAULT 0,
    status      VARCHAR(20)   NOT NULL DEFAULT 'ON_TIME',  -- ON_TIME | LATE | EARLY_LEAVE | ABSENT | OVERTIME
    notes       TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
