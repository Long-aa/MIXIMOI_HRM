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
    ('EMPLOYEE',   'Xem thông tin cá nhân và nghiệp vụ liên quan')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

-- =============================================================
-- 2. LOẠI NHÂN VIÊN
-- =============================================================
INSERT INTO employee_types (name, description) VALUES
    ('Nhân viên chính thức', 'Hợp đồng không xác định thời hạn'),
    ('Nhân viên thử việc',   'Đang trong thời gian thử việc'),
    ('Nhân viên thời vụ',    'Hợp đồng ngắn hạn theo mùa'),
    ('Cộng tác viên',        'Làm việc theo hợp đồng dịch vụ')
ON CONFLICT (name) DO NOTHING;

-- =============================================================
-- 3. PHÒNG BAN
-- =============================================================
INSERT INTO departments (name, code, description, status) VALUES
    ('Ban Giám đốc',    'BGD', 'Lãnh đạo và điều hành công ty',        'ACTIVE'),
    ('Phòng Nhân sự',   'HR',  'Quản lý nhân sự và tuyển dụng',         'ACTIVE'),
    ('Phòng Kế toán',   'KT',  'Quản lý tài chính và kế toán',          'ACTIVE'),
    ('Phòng Kinh doanh','KD',  'Phát triển kinh doanh và bán hàng',      'ACTIVE'),
    ('Phòng Marketing', 'MKT', 'Tiếp thị và quảng bá thương hiệu',      'ACTIVE'),
    ('Phòng Kỹ thuật',  'TECH','Phát triển phần mềm và hệ thống',       'ACTIVE')
ON CONFLICT (name) DO UPDATE SET code = EXCLUDED.code, description = EXCLUDED.description, status = EXCLUDED.status;

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
    ('Chuyên viên kinh doanh','Phụ trách hoạt động kinh doanh')
ON CONFLICT (name) DO NOTHING;

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
    ('NV010', 'Lý Thị Kim',       '1998-06-25', 'FEMALE', '0990123456', 'kim.lt@miximoi.vn',   'TP.HCM', 6, 6, 3, '2025-06-01', 'ACTIVE')
ON CONFLICT (employee_code) DO NOTHING;

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
    ('nv005',     '$2a$12$RKn6YXs8E0Vg7A.wHsgC8O9L3uLuBlyynP7d0ob0X6SWWxdjKOmwC', 'EMPLOYEE',   5,    TRUE)
ON CONFLICT (username) DO NOTHING;

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
    ('HD011',10, 'SEASONAL',    '2025-06-01', '2025-12-31',  9000000, 'ACTIVE')
ON CONFLICT (contract_code) DO NOTHING;

-- =============================================================
-- 8. CA LÀM VIỆC
-- =============================================================
INSERT INTO work_shifts (name, start_time, end_time, standard_hours) VALUES
    ('Ca hành chính', '08:00', '17:00', 8.0),
    ('Ca sáng',       '06:00', '14:00', 8.0),
    ('Ca chiều',      '14:00', '22:00', 8.0),
    ('Ca tối',        '22:00', '06:00', 8.0)
ON CONFLICT (name) DO NOTHING;

-- =============================================================
-- 9. PHỤ CẤP MẪU
-- =============================================================
INSERT INTO allowances (employee_id, name, amount, start_date, active)
SELECT v.employee_id, v.name, v.amount, v.start_date::date, v.active
FROM (VALUES
    (1, 'Phụ cấp chức vụ',    3000000, '2020-01-06', TRUE),
    (2, 'Phụ cấp ăn trưa',     800000, '2021-03-01', TRUE),
    (3, 'Phụ cấp ăn trưa',     800000, '2020-06-15', TRUE),
    (4, 'Phụ cấp điện thoại',  300000, '2022-01-10', TRUE),
    (4, 'Phụ cấp xăng xe',     500000, '2022-01-10', TRUE),
    (5, 'Phụ cấp xăng xe',     500000, '2021-08-01', TRUE),
    (6, 'Phụ cấp ăn trưa',     800000, '2022-04-01', TRUE)
) AS v(employee_id, name, amount, start_date, active)
WHERE NOT EXISTS (
    SELECT 1 FROM allowances a WHERE a.employee_id = v.employee_id AND a.name = v.name
);

-- =============================================================
-- 10. ĐƠN NGHỈ PHÉP MẪU
-- =============================================================
INSERT INTO leave_requests (leave_code, employee_id, leave_type, start_date, end_date,
                             total_days, reason, status) VALUES
    ('LP001', 4, 'ANNUAL',   '2026-09-10', '2026-09-11', 2, 'Nghỉ phép năm',       'PENDING'),
    ('LP002', 5, 'SICK',     '2026-09-05', '2026-09-06', 2, 'Ốm — có đơn bác sĩ', 'APPROVED'),
    ('LP003', 6, 'PERSONAL', '2026-09-15', '2026-09-15', 1, 'Việc gia đình',       'PENDING')
ON CONFLICT (leave_code) DO NOTHING;

-- =============================================================
-- 11. CẬP NHẬT TRƯỞNG PHÒNG BAN (MANAGER_ID)
-- =============================================================
UPDATE departments SET manager_id = 1 WHERE code = 'BGD';
UPDATE departments SET manager_id = 2 WHERE code = 'HR';
UPDATE departments SET manager_id = 3 WHERE code = 'KT';
UPDATE departments SET manager_id = 5 WHERE code = 'KD';
UPDATE departments SET manager_id = 4 WHERE code = 'TECH';

-- =============================================================
-- 12. THIẾT BỊ CHẤM CÔNG SINH TRẮC HỌC (VÂN TAY & FACEID)
-- =============================================================
INSERT INTO biometric_devices (device_code, name, type, location, ip_address, status, department_id, notes) VALUES
    ('FID-T1', 'Máy FaceID Cửa Chính Tầng 1', 'FACE_ID',     'Sảnh chính Tòa nhà Landmark 81', '192.168.1.201', 'ONLINE', 1, 'Hỗ trợ nhận diện AI camera góc rộng'),
    ('FID-T6', 'Máy FaceID Cửa Tầng 6 Khối Kỹ Thuật', 'FACE_ID', 'Cửa ra vào P. Kỹ thuật Tầng 6', '192.168.1.202', 'ONLINE', 6, 'Tích hợp mở khóa cửa tự động'),
    ('FP-T2',  'Máy Quét Vân Tay Sảnh Tầng 2', 'FINGERPRINT', 'Khu vực Lễ tân Tầng 2',        '192.168.1.203', 'ONLINE', 2, 'Cảm biến vân tay quang học độ nhạy cao'),
    ('FP-T3',  'Máy Quét Vân Tay Tầng 3 (Kế toán)', 'FINGERPRINT', 'Cửa P. Tài chính Tầng 3',  '192.168.1.204', 'ONLINE', 3, 'Bảo mật kép')
ON CONFLICT (device_code) DO NOTHING;

-- =============================================================
-- 13. DỮ LIỆU SINH TRẮC HỌC NHÂN VIÊN MẪU
-- =============================================================
INSERT INTO employee_biometrics (employee_id, fingerprint_enrolled, fingerprint_device_id, face_enrolled, face_device_id, employee_card_id, active) VALUES
    (1, TRUE, 3, TRUE, 1, 'CARD-001', TRUE),
    (2, TRUE, 3, TRUE, 1, 'CARD-002', TRUE),
    (3, TRUE, 4, TRUE, 1, 'CARD-003', TRUE),
    (4, TRUE, 3, TRUE, 2, 'CARD-004', TRUE),
    (5, TRUE, 3, TRUE, 1, 'CARD-005', TRUE),
    (6, TRUE, 3, TRUE, 1, 'CARD-006', TRUE),
    (7, TRUE, 3, TRUE, 2, 'CARD-007', TRUE)
ON CONFLICT (employee_id) DO NOTHING;

-- =============================================================
-- 14. NHÂN VIÊN PHỤ TRÁCH & PHỎNG VẤN BỔ SUNG
-- =============================================================
INSERT INTO employees (employee_code, full_name, date_of_birth, gender, phone, email, address, department_id, position_id, employee_type_id, start_date, status)
VALUES 
    ('NV011', 'Phạm Phương Thảo', '1993-04-12', 'FEMALE', '0912111222', 'thao.pp@miximoi.vn', 'Hà Nội', 2, 8, 1, '2022-03-01', 'ACTIVE'),
    ('NV012', 'Nguyễn Minh Tuấn', '1989-08-25', 'MALE',   '0913222333', 'tuan.nm@miximoi.vn', 'Hà Nội', 6, 7, 1, '2021-05-15', 'ACTIVE'),
    ('NV013', 'Trần Thị Mai',     '1994-11-09', 'FEMALE', '0914333444', 'mai.tt@miximoi.vn',  'Hà Nội', 2, 8, 1, '2022-08-01', 'ACTIVE'),
    ('NV014', 'Lê Trọng',         '1991-02-18', 'MALE',   '0915444555', 'trong.l@miximoi.vn',  'Hà Nội', 5, 5, 1, '2023-01-10', 'ACTIVE'),
    ('NV015', 'Đặng Quốc Việt',   '1990-10-30', 'MALE',   '0916555666', 'viet.dq@miximoi.vn',  'Hà Nội', 3, 9, 1, '2022-02-20', 'ACTIVE')
ON CONFLICT (employee_code) DO NOTHING;

-- =============================================================
-- 15. DỮ LIỆU MẪU YÊU CẦU TUYỂN DỤNG (12 Chiến dịch)
-- =============================================================
INSERT INTO recruitment_requests 
(id, request_code, title, department_id, position_id, target_headcount, hired_count, salary_min, salary_max, deadline, priority, status, quarter, assignee_id, description, requirements, benefits)
VALUES
(1, 'YCTD-2026-081', 'Senior Fullstack Engineer (React/Go)', 6, 7, 3, 2, 35000000, 55000000, '2026-10-15', 'HOT', 'OPEN', 'Q3/2026', 11, 'Phát triển hệ thống Microservices quy mô lớn và giao diện Frontend ReactJS hiện đại.', 'Tối thiểu 4 năm kinh nghiệm ReactJS, Go/NodeJS. Thành thạo PostgreSQL, Docker.', 'Lương thưởng cạnh tranh, bảo hiểm sức khỏe cao cấp.'),
(2, 'YCTD-2026-082', 'Trưởng nhóm Kinh doanh B2B (Sales Lead)', 4, 10, 1, 1, 25000000, 45000000, '2026-09-30', 'NORMAL', 'FILLED', 'Q3/2026', 13, 'Dẫn dắt đội ngũ kinh doanh tiếp cận khách hàng doanh nghiệp.', '3+ năm kinh nghiệm Sales Lead mảng B2B.', 'Hoa hồng theo doanh số không giới hạn.'),
(3, 'YCTD-2026-083', 'Product Designer (UI/UX Senior)', 6, 7, 2, 1, 28000000, 42000000, '2026-10-20', 'NORMAL', 'OPEN', 'Q3/2026', 11, 'Thiết kế trải nghiệm người dùng HRM & Payroll.', '3+ năm thiết kế Web/App B2B, Figma.', 'Môi trường Agile năng động.'),
(4, 'YCTD-2026-084', 'Content Marketing Specialist', 5, 5, 2, 0, 16000000, 24000000, '2026-10-05', 'URGENT', 'OPEN', 'Q3/2026', 14, 'Sáng tạo nội dung truyền thông đa kênh.', '2+ năm viết nội dung B2B, SEO.', 'Phụ cấp đào tạo chuyên môn.'),
(5, 'YCTD-2026-085', 'Kế toán Thuế & Kiểm toán nội bộ', 3, 9, 1, 1, 20000000, 30000000, '2026-09-15', 'NORMAL', 'CLOSED', 'Q3/2026', 15, 'Quyết toán thuế doanh nghiệp, soát xét sổ sách.', '3+ năm làm kế toán thuế tổng hợp.', 'Thưởng lương tháng 13++.'),
(6, 'YCTD-2026-086', 'DevOps / Cloud Security Specialist', 6, 7, 1, 0, 35000000, 50000000, '2026-10-25', 'URGENT', 'PAUSED', 'Q3/2026', 11, 'Vận hành hạ tầng AWS/GCP, bảo mật và CI/CD.', 'Chứng chỉ AWS/CKS, kinh nghiệm Kubernetes.', 'Làm việc Hybrid linh hoạt.'),
(7, 'YCTD-2026-087', 'Chuyên viên Nhân sự C&B', 2, 8, 1, 0, 18000000, 26000000, '2026-10-12', 'NORMAL', 'OPEN', 'Q3/2026', 15, 'Tính lương, quản lý BHXH và thuế TNCN.', '2+ năm kinh nghiệm C&B chuyên sâu.', 'Thưởng hiệu suất tháng.'),
(8, 'YCTD-2026-088', 'Frontend Developer (VueJS / NuxtJS)', 6, 7, 2, 0, 22000000, 32000000, '2026-10-18', 'NORMAL', 'OPEN', 'Q3/2026', 11, 'Phát triển web portal nhân viên.', '2+ năm kinh nghiệm VueJS/NuxtJS.', 'Thưởng dự án sprint.'),
(9, 'YCTD-2026-089', 'Chuyên viên Quản lý Khách hàng Doanh nghiệp (Account Manager)', 4, 10, 2, 0, 18000000, 30000000, '2026-10-22', 'NORMAL', 'OPEN', 'Q3/2026', 13, 'Chăm sóc và phát triển khách hàng B2B.', 'Kỹ năng giao tiếp và đàm phán xuất sắc.', 'Thưởng hoa hồng định kỳ.'),
(10, 'YCTD-2026-090', 'QA/QC Engineer (Automation Test)', 6, 7, 2, 0, 20000000, 30000000, '2026-10-28', 'NORMAL', 'OPEN', 'Q3/2026', 11, 'Kiểm thử tự động API và Web UI.', 'Kinh nghiệm Selenium, Playwright.', 'Đào tạo chuyên sâu.'),
(11, 'YCTD-2026-091', 'Chuyên viên Tuyển dụng Kỹ thuật (Tech Recruiter)', 2, 8, 1, 0, 16000000, 25000000, '2026-10-08', 'URGENT', 'OPEN', 'Q3/2026', 11, 'Săn đầu người và tuyển dụng kỹ sư công nghệ.', '2+ năm tuyển dụng IT.', 'Thưởng tuyển dụng case.'),
(12, 'YCTD-2026-092', 'Nhân viên Hành chính Tổng hợp', 2, 5, 1, 0, 12000000, 16000000, '2026-11-05', 'NORMAL', 'PAUSED', 'Q3/2026', 13, 'Quản lý văn phòng phẩm, cơ sở vật chất.', 'Nhanh nhẹn, cẩn thận, giao tiếp tốt.', 'Phụ cấp ăn trưa.')
ON CONFLICT (request_code) DO NOTHING;

-- =============================================================
-- 16. KỲ ĐÁNH GIÁ (Performance Cycles)
-- =============================================================
INSERT INTO performance_cycles (name, start_date, end_date, status)
VALUES ('Q3/2026', '2026-07-01', '2026-09-30', 'OPEN')
ON CONFLICT (name) DO NOTHING;

INSERT INTO performance_cycles (name, start_date, end_date, status)
VALUES ('Q2/2026', '2026-04-01', '2026-06-30', 'CLOSED')
ON CONFLICT (name) DO NOTHING;

-- =============================================================
-- 17. THIẾT LẬP HỆ THỐNG DOANH NGHIỆP (System Settings)
-- =============================================================
INSERT INTO system_settings (setting_key, setting_value, category, description) VALUES
('company_full_name', 'CÔNG TY CỔ PHẦN CÔNG NGHỆ & DỊCH VỤ MIXIMOI VIỆT NAM', 'GENERAL', 'Tên đầy đủ theo ĐKKD'),
('company_short_name', 'MIXIMOI CORP', 'GENERAL', 'Tên giao dịch viết tắt'),
('tax_code', '0316888999', 'GENERAL', 'Mã số thuế doanh nghiệp'),
('legal_rep', 'Nguyễn Văn An', 'GENERAL', 'Người đại diện pháp luật'),
('legal_title', 'Tổng Giám Đốc', 'GENERAL', 'Chức danh người đại diện'),
('company_address', 'Tầng 18, Tòa nhà Landmark 81, 720A Điện Biên Phủ, Phường 22, Bình Thạnh, TP. Hồ Chí Minh', 'GENERAL', 'Trụ sở chính'),
('company_phone', '028 7300 8888', 'GENERAL', 'Hotline tổng đài'),
('company_website', 'https://miximoi.vn', 'GENERAL', 'Website chính thức'),
('system_email', 'contact@miximoi.vn', 'GENERAL', 'Email hệ thống'),
('billing_email', 'accounting@miximoi.vn', 'GENERAL', 'Email kế toán hóa đơn'),
('emp_code_prefix', 'NV', 'EMP_CODE', 'Tiền tố mã nhân viên'),
('emp_code_digits', '4', 'EMP_CODE', 'Độ dài số tự tăng'),
('emp_code_format', 'YYYY', 'EMP_CODE', 'Format năm'),
('auto_gen_code', 'true', 'EMP_CODE', 'Tự động tạo mã'),
('work_start_time', '08:30', 'TIME_ATTENDANCE', 'Giờ bắt đầu làm việc'),
('work_end_time', '18:00', 'TIME_ATTENDANCE', 'Giờ kết thúc làm việc'),
('standard_daily_hours', '8.0', 'TIME_ATTENDANCE', 'Số giờ làm việc chuẩn/ngày'),
('grace_late_minutes', '15', 'TIME_ATTENDANCE', 'Số phút cho phép đi muộn không phạt'),
('max_late_per_month', '3', 'TIME_ATTENDANCE', 'Số lần đi muộn tối đa trong tháng'),
('timesheet_cutoff_day', '25', 'PAYROLL', 'Ngày chốt bảng công hàng tháng'),
('payroll_pay_day', '5', 'PAYROLL', 'Ngày chi trả lương chính thức'),
('base_insurance_salary', '2.340.000', 'PAYROLL', 'Mức lương cơ sở đóng BHXH'),
('personal_tax_deduction', '11.000.000', 'PAYROLL', 'Giảm trừ gia cảnh bản thân'),
('dependent_tax_deduction', '4.400.000', 'PAYROLL', 'Giảm trừ mỗi người phụ thuộc'),
('require_2fa', 'true', 'SECURITY', 'Bắt buộc xác thực 2FA')
ON CONFLICT (setting_key) DO NOTHING;

-- =============================================================
-- 18. CHỈ TIÊU KPI MẪU (Kpi Metrics)
-- =============================================================
INSERT INTO kpi_metrics (kpi_code, title, employee_id, department_id, quarter, target_value, current_value, unit, weight_pct, deadline, status)
VALUES
('KPI-IT-042', 'Triển khai Microservices & Bảo đảm SLA Uptime 99.9%', 4, 6, 'Q3/2026', 100.0, 102.0, '%', 35.0, '2026-09-30', 'APPROVED'),
('KPI-IT-043', 'Tối ưu hóa chi phí AWS Cloud tiết kiệm 15%', 4, 6, 'Q3/2026', 15.0, 9.2, '%', 25.0, '2026-09-28', 'IN_PROGRESS'),
('KPI-IT-044', 'Code Review & Kèm cặp 2 Junior Developers', 7, 6, 'Q3/2026', 2.0, 2.0, 'Nhân sự', 20.0, '2026-09-30', 'APPROVED'),
('KPI-HR-012', 'Tuyển dụng 10 Kỹ sư phần mềm cho dự án Core', 2, 2, 'Q3/2026', 10.0, 8.0, 'Ứng sự', 40.0, '2026-09-30', 'IN_PROGRESS'),
('KPI-HR-015', 'Tổ chức đào tạo nâng cao kỹ năng quý 3', 8, 2, 'Q3/2026', 4.0, 4.0, 'Khóa học', 30.0, '2026-09-20', 'APPROVED'),
('KPI-KT-021', 'Quyết toán thuế & Lập báo cáo tài chính quý 3', 3, 3, 'Q3/2026', 100.0, 95.0, '%', 50.0, '2026-09-30', 'IN_PROGRESS'),
('KPI-KT-022', 'Rút ngắn thời gian chốt bảng lương dưới 3 ngày', 9, 3, 'Q3/2026', 3.0, 2.5, 'Ngày công', 30.0, '2026-09-30', 'APPROVED'),
('KPI-KD-081', 'Doanh số phát triển khách hàng Enterprise mới', 5, 4, 'Q3/2026', 500.0, 480.0, 'Triệu VNĐ', 45.0, '2026-09-30', 'IN_PROGRESS'),
('KPI-MKT-031', 'Tăng nhận diện thương hiệu & Lead chuyển đổi', 6, 5, 'Q3/2026', 1200.0, 1350.0, 'Lead', 35.0, '2026-09-30', 'APPROVED')
ON CONFLICT (kpi_code) DO NOTHING;

-- =============================================================
-- 19. ĐÁNH GIÁ HIỆU SUẤT MẪU (Performance Evaluations)
-- =============================================================
INSERT INTO performance_evaluations (evaluation_code, employee_id, evaluator_id, quarter, kpi_score, competency_score, culture_score, innovation_score, final_score, grade, status, feedback)
VALUES
('EVAL-Q3-042', 4, 1, 'Q3/2026', 9.4, 8.8, 9.0, 7.6, 8.96, 'A+', 'CONFIRMED', 'Hoàn thành xuất sắc nhiệm vụ kiến trúc và tối ưu hệ thống, phối hợp nhóm hiệu quả.'),
('EVAL-Q3-018', 6, 1, 'Q3/2026', 8.8, 8.5, 8.2, 7.0, 8.36, 'A', 'CONFIRMED', 'Dẫn dắt các chiến dịch Marketing hiệu quả vượt chỉ tiêu lead thu về.'),
('EVAL-Q3-089', 5, 1, 'Q3/2026', 8.0, 7.8, 8.0, 7.0, 7.84, 'B', 'SUBMITTED', 'Nỗ lực mở rộng khách hàng doanh nghiệp, cần cải thiện năng lực đàm phán hợp đồng lớn.'),
('EVAL-Q3-007', 7, 4, 'Q3/2026', 9.0, 8.5, 8.5, 8.0, 8.65, 'A', 'CONFIRMED', 'Kỹ năng lập trình tốt, tích cực hỗ trợ đồng đội trong sprint.'),
('EVAL-Q3-002', 2, 1, 'Q3/2026', 8.5, 8.5, 9.0, 8.0, 8.55, 'A', 'CONFIRMED', 'Tuyển dụng đáp ứng đúng tiến độ mở rộng các phòng ban.')
ON CONFLICT (evaluation_code) DO NOTHING;

-- =============================================================
-- 20. THƯỞNG HIỆU SUẤT MẪU (Bonuses)
-- =============================================================
INSERT INTO bonuses (employee_id, name, amount, bonus_date, pay_month, pay_year, notes) VALUES
    (1, 'Thưởng hoàn thành kế hoạch Q3', 5000000, '2026-09-25', 9, 2026, 'Thưởng KPI xuất sắc'),
    (4, 'Thưởng dự án Core Engine',       3000000, '2026-09-25', 9, 2026, 'Release phiên bản v4.2 đúng tiến độ'),
    (6, 'Thưởng chiến dịch Marketing T9', 2000000, '2026-09-25', 9, 2026, 'Vượt chỉ tiêu số lượng leads'),
    (4, 'Thưởng dự án nâng cấp Cloud',    2500000, '2026-08-25', 8, 2026, 'Tối ưu hóa AWS Cloud'),
    (5, 'Thưởng doanh số tháng 8',        3500000, '2026-08-25', 8, 2026, 'Đạt doanh số B2B'),
    (1, 'Thưởng chiến lược phát triển',   4000000, '2026-07-25', 7, 2026, 'Đạt mốc mở rộng chi nhánh'),
    (7, 'Thưởng năng suất sprint tháng 7',1500000, '2026-07-25', 7, 2026, 'Hoàn thành 100% story points')
ON CONFLICT DO NOTHING;

-- =============================================================
-- 21. DỮ LIỆU TĂNG CA MẪU (Overtime)
-- =============================================================
INSERT INTO overtime (overtime_code, employee_id, overtime_date, start_time, end_time, hours, coefficient, amount, reason, status) VALUES
    ('OT-2609-01', 4, '2026-09-12', '18:30', '21:30', 3.0, 1.5, 337500, 'Triển khai release bản vá lỗi máy chủ', 'APPROVED'),
    ('OT-2609-02', 7, '2026-09-15', '18:30', '20:30', 2.0, 1.5, 195000, 'Hỗ trợ migration cơ sở dữ liệu', 'APPROVED'),
    ('OT-2608-01', 4, '2026-08-18', '18:30', '21:30', 3.0, 1.5, 337500, 'Bảo trì hệ thống định kỳ', 'APPROVED'),
    ('OT-2608-02', 6, '2026-08-20', '18:30', '20:30', 2.0, 1.5, 210000, 'Hỗ trợ sự kiện trực tuyến', 'APPROVED'),
    ('OT-2607-01', 4, '2026-07-10', '18:30', '22:00', 3.5, 1.5, 393750, 'Nâng cấp cụm dịch vụ core', 'APPROVED'),
    ('OT-2607-02', 7, '2026-07-22', '18:30', '21:00', 2.5, 1.5, 243750, 'Kiểm thử tải hệ thống', 'APPROVED')
ON CONFLICT (overtime_code) DO NOTHING;

-- =============================================================
-- 22. DỮ LIỆU CHẤM CÔNG THỰC TẾ 3 THÁNG (Tháng 7, 8, 9/2026)
-- Tạo công chuẩn 20-22 ngày công mỗi tháng cho các nhân sự chính
-- =============================================================
-- Chấm công Tháng 07/2026 (Ngày 01 -> 31/07 trừ T7/CN)
INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, method, notes)
SELECT e.id, d::date, '08:25:00'::time, '17:35:00'::time, 8.0, 
       (CASE WHEN (extract(day from d)::int + e.id) % 15 = 0 THEN 'LATE' ELSE 'ON_TIME' END),
       'FaceID', 'Chấm công tự động'
FROM employees e
CROSS JOIN generate_series('2026-07-01'::date, '2026-07-31'::date, '1 day'::interval) d
WHERE extract(dow from d) NOT IN (0, 6) AND e.id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
ON CONFLICT (employee_id, work_date) DO NOTHING;

-- Chấm công Tháng 08/2026 (Ngày 01 -> 31/08 trừ T7/CN)
INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, method, notes)
SELECT e.id, d::date, '08:22:00'::time, '17:38:00'::time, 8.0, 
       (CASE WHEN (extract(day from d)::int + e.id) % 17 = 0 THEN 'LATE' ELSE 'ON_TIME' END),
       'FaceID', 'Chấm công tự động'
FROM employees e
CROSS JOIN generate_series('2026-08-01'::date, '2026-08-31'::date, '1 day'::interval) d
WHERE extract(dow from d) NOT IN (0, 6) AND e.id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
ON CONFLICT (employee_id, work_date) DO NOTHING;

-- Chấm công Tháng 09/2026 (Ngày 01 -> 24/09 trừ T7/CN)
INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, method, notes)
SELECT e.id, d::date, '08:24:00'::time, '17:32:00'::time, 8.0, 
       (CASE WHEN (extract(day from d)::int + e.id) % 13 = 0 THEN 'LATE' ELSE 'ON_TIME' END),
       'FaceID', 'Chấm công tự động'
FROM employees e
CROSS JOIN generate_series('2026-09-01'::date, '2026-09-24'::date, '1 day'::interval) d
WHERE extract(dow from d) NOT IN (0, 6) AND e.id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
ON CONFLICT (employee_id, work_date) DO NOTHING;

-- =============================================================
-- 23. BẢNG LƯƠNG ĐÃ TÍNH TOÁN THEO CÔNG THỨC 3 THÁNG
-- =============================================================
-- Bảng lương Tháng 07/2026 (Đã duyệt & Đã thanh toán)
INSERT INTO payroll (employee_id, pay_month, pay_year, base_salary, working_days, standard_days, overtime_amount, allowance, bonus, deduction, net_salary, status, created_by_id, approved_by_id) VALUES
    (1, 7, 2026, 25000000, 23.0, 23.0, 0,      3000000, 4000000, 2625000, 29375000, 'PAID', 1, 1),
    (2, 7, 2026, 18000000, 23.0, 23.0, 0,       800000,       0, 1890000, 16910000, 'PAID', 1, 1),
    (3, 7, 2026, 20000000, 23.0, 23.0, 0,       800000,       0, 2100000, 18700000, 'PAID', 1, 1),
    (4, 7, 2026, 16000000, 23.0, 23.0, 393750,  800000,       0, 1680000, 15513750, 'PAID', 1, 1),
    (5, 7, 2026, 17000000, 22.0, 23.0, 0,       500000,       0, 1785000, 14975652, 'PAID', 1, 1),
    (6, 7, 2026, 15000000, 23.0, 23.0, 0,       800000,       0, 1575000, 14225000, 'PAID', 1, 1),
    (7, 7, 2026, 14000000, 23.0, 23.0, 243750,       0, 1500000, 1470000, 14273750, 'PAID', 1, 1),
    (8, 7, 2026, 17500000, 23.0, 23.0, 0,            0,       0, 1837500, 15662500, 'PAID', 1, 1),
    (9, 7, 2026, 16500000, 23.0, 23.0, 0,            0,       0, 1732500, 14767500, 'PAID', 1, 1),
    (10,7, 2026,  9000000, 23.0, 23.0, 0,            0,       0,  945000,  8055000, 'PAID', 1, 1)
ON CONFLICT (employee_id, pay_month, pay_year) DO NOTHING;

-- Bảng lương Tháng 08/2026 (Đã duyệt & Đã thanh toán)
INSERT INTO payroll (employee_id, pay_month, pay_year, base_salary, working_days, standard_days, overtime_amount, allowance, bonus, deduction, net_salary, status, created_by_id, approved_by_id) VALUES
    (1, 8, 2026, 25000000, 21.0, 21.0, 0,      3000000,       0, 2625000, 25375000, 'PAID', 1, 1),
    (2, 8, 2026, 18000000, 21.0, 21.0, 0,       800000,       0, 1890000, 16910000, 'PAID', 1, 1),
    (3, 8, 2026, 20000000, 21.0, 21.0, 0,       800000,       0, 2100000, 18700000, 'PAID', 1, 1),
    (4, 8, 2026, 16000000, 21.0, 21.0, 337500,  800000, 2500000, 1680000, 17957500, 'PAID', 1, 1),
    (5, 8, 2026, 17000000, 21.0, 21.0, 0,       500000, 3500000, 1785000, 19215000, 'PAID', 1, 1),
    (6, 8, 2026, 15000000, 20.0, 21.0, 210000,  800000,       0, 1575000, 13720714, 'PAID', 1, 1),
    (7, 8, 2026, 14000000, 21.0, 21.0, 0,            0,       0, 1470000, 12530000, 'PAID', 1, 1),
    (8, 8, 2026, 17500000, 21.0, 21.0, 0,            0,       0, 1837500, 15662500, 'PAID', 1, 1),
    (9, 8, 2026, 16500000, 21.0, 21.0, 0,            0,       0, 1732500, 14767500, 'PAID', 1, 1),
    (10,8, 2026,  9000000, 21.0, 21.0, 0,            0,       0,  945000,  8055000, 'PAID', 1, 1)
ON CONFLICT (employee_id, pay_month, pay_year) DO NOTHING;

-- Bảng lương Tháng 09/2026 (Đang tiến hành / Đã thẩm định)
INSERT INTO payroll (employee_id, pay_month, pay_year, base_salary, working_days, standard_days, overtime_amount, allowance, bonus, deduction, net_salary, status, created_by_id, approved_by_id) VALUES
    (1, 9, 2026, 25000000, 18.0, 22.0, 0,      3000000, 5000000, 2625000, 25829545, 'APPROVED', 1, 1),
    (2, 9, 2026, 18000000, 18.0, 22.0, 0,       800000,       0, 1890000, 13637273, 'APPROVED', 1, 1),
    (3, 9, 2026, 20000000, 18.0, 22.0, 0,       800000,       0, 2100000, 15063636, 'APPROVED', 1, 1),
    (4, 9, 2026, 16000000, 18.0, 22.0, 337500,  800000, 3000000, 1680000, 15548409, 'APPROVED', 1, 1),
    (5, 9, 2026, 17000000, 17.0, 22.0, 0,       500000,       0, 1785000, 11851364, 'PENDING',  1, NULL),
    (6, 9, 2026, 15000000, 18.0, 22.0, 0,       800000, 2000000, 1575000, 13497727, 'APPROVED', 1, 1),
    (7, 9, 2026, 14000000, 18.0, 22.0, 195000,       0,       0, 1470000, 10179545, 'PENDING',  1, NULL),
    (8, 9, 2026, 17500000, 18.0, 22.0, 0,            0,       0, 1837500, 12480682, 'PENDING',  1, NULL),
    (9, 9, 2026, 16500000, 18.0, 22.0, 0,            0,       0, 1732500, 11767500, 'PENDING',  1, NULL),
    (10,9, 2026,  9000000, 18.0, 22.0, 0,            0,       0,  945000,  6418636, 'PENDING',  1, NULL)
ON CONFLICT (employee_id, pay_month, pay_year) DO NOTHING;


