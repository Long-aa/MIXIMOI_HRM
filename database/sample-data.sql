-- =============================================================
-- MIXIMOI HRM & PAYROLL — Sample Data (Dữ liệu mẫu)
-- =============================================================
-- Chạy sau schema.sql

-- =============================================================
-- 1. ROLES
-- =============================================================
INSERT INTO roles (name, description) VALUES
    ('ADMIN',      'Quản trị toàn bộ hệ thống'),
    ('HR',         'Quản lý nhân sự, hợp đồng, chấm công, nghỉ phép'),
    ('ACCOUNTANT', 'Quản lý bảng lương, tính lương, thanh toán'),
    ('MANAGER',    'Theo dõi nhân sự và phê duyệt nghiệp vụ'),
    ('EMPLOYEE',   'Xem thông tin cá nhân và nghiệp vụ liên quan');

-- =============================================================
-- 2. LOẠI NHÂN VIÊN
-- =============================================================
INSERT INTO employee_types (name, description) VALUES
    ('Nhân viên chính thức', 'Hợp đồng không xác định thời hạn'),
    ('Nhân viên thử việc',   'Đang trong thời gian thử việc'),
    ('Nhân viên thời vụ',    'Hợp đồng ngắn hạn theo mùa'),
    ('Cộng tác viên',        'Làm việc theo hợp đồng dịch vụ');

-- =============================================================
-- 3. PHÒNG BAN
-- =============================================================
INSERT INTO departments (name, description) VALUES
    ('Ban Giám đốc',   'Lãnh đạo và điều hành công ty'),
    ('Phòng Nhân sự',  'Quản lý nhân sự và tuyển dụng'),
    ('Phòng Kế toán',  'Quản lý tài chính và kế toán'),
    ('Phòng Kinh doanh','Phát triển kinh doanh và bán hàng'),
    ('Phòng Marketing', 'Tiếp thị và quảng bá thương hiệu'),
    ('Phòng Kỹ thuật',  'Phát triển phần mềm và hệ thống');

-- =============================================================
-- 4. CHỨC VỤ
-- =============================================================
INSERT INTO positions (name, description) VALUES
    ('Giám đốc',            'Người điều hành cao nhất'),
    ('Phó Giám đốc',        'Hỗ trợ Giám đốc điều hành'),
    ('Trưởng phòng',        'Quản lý phòng ban'),
    ('Phó phòng',           'Hỗ trợ Trưởng phòng'),
    ('Nhân viên',           'Nhân viên thực hiện công việc'),
    ('Thực tập sinh',       'Đang trong thời gian thực tập'),
    ('Kỹ sư phần mềm',     'Phát triển và duy trì phần mềm'),
    ('Chuyên viên HR',      'Chuyên trách nghiệp vụ nhân sự'),
    ('Kế toán viên',        'Thực hiện công tác kế toán'),
    ('Chuyên viên kinh doanh','Phụ trách hoạt động kinh doanh');

-- =============================================================
-- 5. NHÂN VIÊN MẪU
-- =============================================================
INSERT INTO employees (employee_code, full_name, date_of_birth, gender, phone, email,
                        address, department_id, position_id, employee_type_id, start_date, status) VALUES
    ('NV001', 'Nguyễn Văn An',    '1985-03-15', 'MALE',   '0901234567', 'an.nv@miximoi.vn',    'TP.HCM', 1, 1, 1, '2020-01-06', 'ACTIVE'),
    ('NV002', 'Trần Thị Bình',    '1990-07-22', 'FEMALE', '0912345678', 'binh.tt@miximoi.vn',  'TP.HCM', 2, 3, 1, '2021-03-01', 'ACTIVE'),
    ('NV003', 'Lê Văn Cường',     '1988-11-10', 'MALE',   '0923456789', 'cuong.lv@miximoi.vn', 'HN',     3, 3, 1, '2020-06-15', 'ACTIVE'),
    ('NV004', 'Phạm Thị Dung',    '1995-02-28', 'FEMALE', '0934567890', 'dung.pt@miximoi.vn',  'TP.HCM', 6, 7, 1, '2022-01-10', 'ACTIVE'),
    ('NV005', 'Hoàng Văn Em',     '1992-09-05', 'MALE',   '0945678901', 'em.hv@miximoi.vn',    'TP.HCM', 4, 10,1, '2021-08-01', 'ACTIVE'),
    ('NV006', 'Vũ Thị Phương',    '1993-05-17', 'FEMALE', '0956789012', 'phuong.vt@miximoi.vn','DN',     5, 5, 1, '2022-04-01', 'ACTIVE'),
    ('NV007', 'Đặng Văn Giang',   '1997-12-03', 'MALE',   '0967890123', 'giang.dv@miximoi.vn', 'TP.HCM', 6, 7, 2, '2024-01-15', 'ACTIVE'),
    ('NV008', 'Bùi Thị Hoa',      '1991-08-20', 'FEMALE', '0978901234', 'hoa.bt@miximoi.vn',   'TP.HCM', 2, 8, 1, '2021-01-04', 'ACTIVE'),
    ('NV009', 'Ngô Văn Inh',      '1994-04-11', 'MALE',   '0989012345', 'inh.nv@miximoi.vn',   'HN',     3, 9, 1, '2022-09-01', 'ACTIVE'),
    ('NV010', 'Lý Thị Kim',       '1998-06-25', 'FEMALE', '0990123456', 'kim.lt@miximoi.vn',   'TP.HCM', 6, 6, 3, '2025-06-01', 'ACTIVE');

-- =============================================================
-- 6. TÀI KHOẢN NGƯỜI DÙNG
-- Password: 'miximoi@2026' — BCrypt hash (cost=12)
-- =============================================================
INSERT INTO users (username, password, role, employee_id, active) VALUES
    ('admin',     '$2a$12$RKn6YXs8E0Vg7A.wHsgC8O9L3uLuBlyynP7d0ob0X6SWWxdjKOmwC', 'ADMIN',      NULL, TRUE),
    ('hr01',      '$2a$12$RKn6YXs8E0Vg7A.wHsgC8O9L3uLuBlyynP7d0ob0X6SWWxdjKOmwC', 'HR',         2,    TRUE),
    ('accountant','$2a$12$RKn6YXs8E0Vg7A.wHsgC8O9L3uLuBlyynP7d0ob0X6SWWxdjKOmwC', 'ACCOUNTANT', 3,    TRUE),
    ('manager01', '$2a$12$RKn6YXs8E0Vg7A.wHsgC8O9L3uLuBlyynP7d0ob0X6SWWxdjKOmwC', 'MANAGER',    1,    TRUE),
    ('nv004',     '$2a$12$RKn6YXs8E0Vg7A.wHsgC8O9L3uLuBlyynP7d0ob0X6SWWxdjKOmwC', 'EMPLOYEE',   4,    TRUE),
    ('nv005',     '$2a$12$RKn6YXs8E0Vg7A.wHsgC8O9L3uLuBlyynP7d0ob0X6SWWxdjKOmwC', 'EMPLOYEE',   5,    TRUE);

-- =============================================================
-- 7. HỢP ĐỒNG LAO ĐỘNG MẪU
-- =============================================================
INSERT INTO contracts (contract_code, employee_id, contract_type, start_date, end_date, base_salary, status) VALUES
    ('HD001', 1, 'INDEFINITE',  '2020-01-06', NULL,         25000000, 'ACTIVE'),
    ('HD002', 2, 'INDEFINITE',  '2021-03-01', NULL,         18000000, 'ACTIVE'),
    ('HD003', 3, 'INDEFINITE',  '2020-06-15', NULL,         20000000, 'ACTIVE'),
    ('HD004', 4, 'INDEFINITE',  '2022-01-10', NULL,         16000000, 'ACTIVE'),
    ('HD005', 5, 'INDEFINITE',  '2021-08-01', NULL,         17000000, 'ACTIVE'),
    ('HD006', 6, 'INDEFINITE',  '2022-04-01', NULL,         15000000, 'ACTIVE'),
    ('HD007', 7, 'FIXED_TERM',  '2024-01-15', '2025-01-14', 13000000, 'EXPIRED'),
    ('HD008', 7, 'FIXED_TERM',  '2025-01-15', '2026-01-14', 14000000, 'ACTIVE'),
    ('HD009', 8, 'INDEFINITE',  '2021-01-04', NULL,         17500000, 'ACTIVE'),
    ('HD010', 9, 'INDEFINITE',  '2022-09-01', NULL,         16500000, 'ACTIVE'),
    ('HD011',10, 'SEASONAL',    '2025-06-01', '2025-12-31',  9000000, 'ACTIVE');

-- =============================================================
-- 8. CA LÀM VIỆC
-- =============================================================
INSERT INTO work_shifts (name, start_time, end_time, standard_hours) VALUES
    ('Ca hành chính', '08:00', '17:00', 8.0),
    ('Ca sáng',       '06:00', '14:00', 8.0),
    ('Ca chiều',      '14:00', '22:00', 8.0),
    ('Ca tối',        '22:00', '06:00', 8.0);

-- =============================================================
-- 9. PHỤ CẤP MẪU
-- =============================================================
INSERT INTO allowances (employee_id, name, amount, start_date, active) VALUES
    (1, 'Phụ cấp chức vụ',    3000000, '2020-01-06', TRUE),
    (2, 'Phụ cấp ăn trưa',     800000, '2021-03-01', TRUE),
    (3, 'Phụ cấp ăn trưa',     800000, '2020-06-15', TRUE),
    (4, 'Phụ cấp điện thoại',  300000, '2022-01-10', TRUE),
    (4, 'Phụ cấp xăng xe',     500000, '2022-01-10', TRUE),
    (5, 'Phụ cấp xăng xe',     500000, '2021-08-01', TRUE),
    (6, 'Phụ cấp ăn trưa',     800000, '2022-04-01', TRUE);

-- =============================================================
-- 10. ĐƠN NGHỈ PHÉP MẪU
-- =============================================================
INSERT INTO leave_requests (leave_code, employee_id, leave_type, start_date, end_date,
                             total_days, reason, status) VALUES
    ('LP001', 4, 'ANNUAL',   '2026-09-10', '2026-09-11', 2, 'Nghỉ phép năm',       'PENDING'),
    ('LP002', 5, 'SICK',     '2026-09-05', '2026-09-06', 2, 'Ốm — có đơn bác sĩ', 'APPROVED'),
    ('LP003', 6, 'PERSONAL', '2026-09-15', '2026-09-15', 1, 'Việc gia đình',       'PENDING');
