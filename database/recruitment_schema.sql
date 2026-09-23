-- =============================================================
-- MIXIMOI HRM & PAYROLL — Module Tuyển Dụng (Recruitment)
-- Schema & Dữ liệu mẫu khởi tạo
-- =============================================================

-- 1. BỔ SUNG NHÂN VIÊN PHỤ TRÁCH & PHỎNG VẤN (Nếu chưa có)
INSERT INTO employees (employee_code, full_name, date_of_birth, gender, phone, email, address, department_id, position_id, employee_type_id, start_date, status)
VALUES 
    ('NV011', 'Phạm Phương Thảo', '1993-04-12', 'FEMALE', '0912111222', 'thao.pp@miximoi.vn', 'Hà Nội', 2, 8, 1, '2022-03-01', 'ACTIVE'),
    ('NV012', 'Nguyễn Minh Tuấn', '1989-08-25', 'MALE',   '0913222333', 'tuan.nm@miximoi.vn', 'Hà Nội', 6, 7, 1, '2021-05-15', 'ACTIVE'),
    ('NV013', 'Trần Thị Mai',     '1994-11-09', 'FEMALE', '0914333444', 'mai.tt@miximoi.vn',  'Hà Nội', 2, 8, 1, '2022-08-01', 'ACTIVE'),
    ('NV014', 'Lê Trọng',         '1991-02-18', 'MALE',   '0915444555', 'trong.l@miximoi.vn',  'Hà Nội', 5, 5, 1, '2023-01-10', 'ACTIVE'),
    ('NV015', 'Đặng Quốc Việt',   '1990-10-30', 'MALE',   '0916555666', 'viet.dq@miximoi.vn',  'Hà Nội', 3, 9, 1, '2022-02-20', 'ACTIVE')
ON CONFLICT (employee_code) DO NOTHING;

-- 2. TẠO BẢNG YÊU CẦU TUYỂN DỤNG (recruitment_requests)
CREATE TABLE IF NOT EXISTS recruitment_requests (
    id               SERIAL PRIMARY KEY,
    request_code     VARCHAR(50) NOT NULL UNIQUE,       -- VD: YCTD-2026-081
    title            VARCHAR(250) NOT NULL,              -- VD: Senior Fullstack Engineer (React/Go)
    department_id    INTEGER REFERENCES departments(id),
    position_id      INTEGER REFERENCES positions(id),
    target_headcount INTEGER NOT NULL DEFAULT 1,         -- Số lượng cần tuyển
    hired_count      INTEGER NOT NULL DEFAULT 0,         -- Đã tuyển thành công
    salary_min       NUMERIC(15,0) DEFAULT 0,
    salary_max       NUMERIC(15,0) DEFAULT 0,
    salary_negotiable BOOLEAN DEFAULT FALSE,
    deadline         DATE NOT NULL,                      -- Hạn chót
    priority         VARCHAR(20) NOT NULL DEFAULT 'NORMAL', -- NORMAL | URGENT (Ưu tiên gấp) | HOT (Gấp)
    status           VARCHAR(30) NOT NULL DEFAULT 'OPEN',   -- OPEN (Đang tuyển) | PAUSED (Tạm dừng) | FILLED (Đã đủ) | CLOSED (Đã đóng)
    quarter          VARCHAR(20) NOT NULL DEFAULT 'Q3/2026',-- Kỳ tuyển dụng
    assignee_id      INTEGER REFERENCES employees(id),   -- Người phụ trách chính
    description      TEXT,                               -- Mô tả công việc
    requirements     TEXT,                               -- Yêu cầu ứng viên
    benefits         TEXT,                               -- Quyền lợi & Đãi ngộ
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_rec_req_status ON recruitment_requests(status);
CREATE INDEX IF NOT EXISTS idx_rec_req_quarter ON recruitment_requests(quarter);
CREATE INDEX IF NOT EXISTS idx_rec_req_dept ON recruitment_requests(department_id);

-- 3. TẠO BẢNG ỨNG VIÊN (candidates)
CREATE TABLE IF NOT EXISTS candidates (
    id                     SERIAL PRIMARY KEY,
    candidate_code         VARCHAR(50) NOT NULL UNIQUE,   -- VD: UV-2026-001
    full_name              VARCHAR(200) NOT NULL,
    email                  VARCHAR(150),
    phone                  VARCHAR(20),
    recruitment_request_id INTEGER NOT NULL REFERENCES recruitment_requests(id) ON DELETE CASCADE,
    source                 VARCHAR(50) NOT NULL DEFAULT 'LinkedIn', -- LinkedIn | TopCV/VNW | Nội bộ (Ref) | Khác
    stage                  VARCHAR(50) NOT NULL DEFAULT 'NEW',       -- NEW (1. Mới) | SCREENING (2. Sàng lọc CV) | INTERVIEW (3. Phỏng vấn & Test) | OFFER (4. Gửi Offer) | ONBOARDED (5. Đã nhận việc) | REJECTED (Loại)
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

-- 4. TẠO BẢNG LỊCH PHỎNG VẤN (interviews)
CREATE TABLE IF NOT EXISTS interviews (
    id                     SERIAL PRIMARY KEY,
    candidate_id           INTEGER NOT NULL REFERENCES candidates(id) ON DELETE CASCADE,
    recruitment_request_id INTEGER REFERENCES recruitment_requests(id) ON DELETE CASCADE,
    interviewer_id         INTEGER REFERENCES employees(id),
    round_name             VARCHAR(150) NOT NULL,         -- Vòng Chuyên môn | Vòng Portfolio | Vòng 1 (HR Fit) | Vòng Văn hóa
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
-- 5. NẠP DỮ LIỆU MẪU CHUẨN XÁC VỚI HÌNH ẢNH GIAO DIỆN
-- =============================================================

-- Xóa dữ liệu cũ nếu có
DELETE FROM interviews;
DELETE FROM candidates;
DELETE FROM recruitment_requests;

-- 5.1 12 Yêu cầu tuyển dụng
-- Lấy id của các nhân viên phụ trách:
-- NV011: Thảo, NV013: Mai, NV014: Trọng, NV015: Việt
INSERT INTO recruitment_requests 
(id, request_code, title, department_id, position_id, target_headcount, hired_count, salary_min, salary_max, deadline, priority, status, quarter, assignee_id, description, requirements, benefits)
VALUES
(1, 'YCTD-2026-081', 'Senior Fullstack Engineer (React/Go)', 6, 7, 3, 2, 35000000, 55000000, '2026-10-15', 'HOT', 'OPEN', 'Q3/2026', 
    (SELECT id FROM employees WHERE employee_code='NV011'),
    'Phát triển hệ thống Microservices quy mô lớn và giao diện Frontend ReactJS hiện đại.',
    'Tối thiểu 4 năm kinh nghiệm ReactJS, Go/NodeJS. Thành thạo PostgreSQL, Docker.',
    'Lương thưởng cạnh tranh, bảo hiểm sức khỏe cao cấp, hỗ trợ thiết bị Macbook Pro M-series.'),

(2, 'YCTD-2026-082', 'Trưởng nhóm Kinh doanh B2B (Sales Lead)', 4, 10, 1, 1, 25000000, 45000000, '2026-09-30', 'NORMAL', 'FILLED', 'Q3/2026', 
    (SELECT id FROM employees WHERE employee_code='NV013'),
    'Dẫn dắt đội ngũ kinh doanh tiếp cận khách hàng doanh nghiệp khối B2B SaaS.',
    '3+ năm kinh nghiệm Sales Lead mảng dịch vụ doanh nghiệp, kỹ năng đàm phán xuất sắc.',
    'Hoa hồng theo doanh số không giới hạn, lộ trình thăng tiến Giám đốc kinh doanh.'),

(3, 'YCTD-2026-083', 'Product Designer (UI/UX Senior)', 6, 7, 2, 1, 28000000, 42000000, '2026-10-20', 'NORMAL', 'OPEN', 'Q3/2026', 
    (SELECT id FROM employees WHERE employee_code='NV011'),
    'Thiết kế trải nghiệm người dùng và hệ thống Design System cho sản phẩm HRM & Payroll.',
    '3+ năm thiết kế sản phẩm Web/App B2B phức tạp. Nắm vững Figma, Design Token.',
    'Môi trường Agile năng động, tự chủ quyết định thiết kế sản phẩm.'),

(4, 'YCTD-2026-084', 'Content Marketing Specialist', 5, 5, 2, 0, 16000000, 24000000, '2026-10-05', 'URGENT', 'OPEN', 'Q3/2026', 
    (SELECT id FROM employees WHERE employee_code='NV014'),
    'Sáng tạo nội dung truyền thông đa kênh, bài viết chuyên sâu về chuyển đổi số nhân sự.',
    '2+ năm viết nội dung B2B, kỹ năng SEO, am hiểu truyền thông mạng xã hội.',
    'Phụ cấp đào tạo kỹ năng hàng quý, tham gia các chiến dịch Marketing quốc tế.'),

(5, 'YCTD-2026-085', 'Kế toán Thuế & Kiểm toán nội bộ', 3, 9, 1, 1, 20000000, 30000000, '2026-09-15', 'NORMAL', 'CLOSED', 'Q3/2026', 
    (SELECT id FROM employees WHERE employee_code='NV015'),
    'Quyết toán thuế doanh nghiệp, soát xét hồ sơ tài chính và làm việc với cơ quan thuế.',
    'Tốt nghiệp ĐH chuyên ngành Kế toán - Kiểm toán, 3+ năm làm kế toán thuế tổng hợp.',
    'Thưởng lương tháng 13++, chế độ du lịch nghỉ dưỡng hàng năm.'),

(6, 'YCTD-2026-086', 'DevOps / Cloud Security Specialist', 6, 7, 1, 0, 35000000, 50000000, '2026-10-25', 'URGENT', 'PAUSED', 'Q3/2026', 
    (SELECT id FROM employees WHERE employee_code='NV011'),
    'Vận hành hạ tầng AWS/GCP, bảo mật mạng nội bộ và hệ thống CI/CD.',
    'Có chứng chỉ AWS/CKS, kinh nghiệm Kubernetes production, quản trị hạ tầng IaC.',
    'Gói cổ phần ESOP cho nhân sự chủ chốt, làm việc Hybrid linh hoạt.'),

(7, 'YCTD-2026-087', 'Chuyên viên Nhân sự C&B', 2, 8, 1, 0, 18000000, 26000000, '2026-10-12', 'NORMAL', 'OPEN', 'Q3/2026', 
    (SELECT id FROM employees WHERE employee_code='NV015'),
    'Tính lương, quản lý bảo hiểm xã hội, thuế TNCN và các chế độ đãi ngộ toàn công ty.',
    '2+ năm kinh nghiệm C&B chuyên sâu quy mô 200+ nhân sự, nắm chắc luật lao động.',
    'Thưởng hiệu suất tháng, phụ cấp ăn trưa và gửi xe miễn phí.'),

(8, 'YCTD-2026-088', 'Frontend Developer (VueJS / NuxtJS)', 6, 7, 2, 0, 22000000, 32000000, '2026-10-18', 'NORMAL', 'OPEN', 'Q3/2026',
    (SELECT id FROM employees WHERE employee_code='NV011'),
    'Phát triển ứng dụng Web portal cho nhân viên và cổng quản lý chấm công.',
    '2+ năm VueJS/NuxtJS, CSS3/Tailwind, tối ưu hóa Web Performance.',
    'Thưởng dự án theo tiến độ sprint, môi trường làm việc trẻ trung.'),

(9, 'YCTD-2026-089', 'Chuyên viên Quản lý Khách hàng Doanh nghiệp (Account Manager)', 4, 10, 2, 0, 18000000, 30000000, '2026-10-22', 'NORMAL', 'OPEN', 'Q3/2026',
    (SELECT id FROM employees WHERE employee_code='NV013'),
    'Chăm sóc và duy trì mối quan hệ lâu dài với các khách hàng doanh nghiệp trọng điểm.',
    'Kinh nghiệm CSKH/Account mảng dịch vụ B2B, khả năng giao tiếp và xử lý vấn đề tốt.',
    'Thưởng hoa hồng gia hạn hợp đồng, tham gia các hội thảo doanh nghiệp lớn.'),

(10, 'YCTD-2026-090', 'QA/QC Engineer (Automation Test)', 6, 7, 2, 0, 20000000, 30000000, '2026-10-28', 'NORMAL', 'OPEN', 'Q3/2026',
    (SELECT id FROM employees WHERE employee_code='NV011'),
    'Viết kịch bản kiểm thử tự động API và Web UI, đảm bảo chất lượng phát hành phiên bản.',
    'Kinh nghiệm Selenium, Playwright, Postman, kiểm thử tải JMeter.',
    'Được đào tạo nâng cao kiến trúc hệ thống và quy trình CI/CD testing.'),

(11, 'YCTD-2026-091', 'Chuyên viên Tuyển dụng Kỹ thuật (Tech Recruiter)', 2, 8, 1, 0, 16000000, 25000000, '2026-10-08', 'URGENT', 'OPEN', 'Q3/2026',
    (SELECT id FROM employees WHERE employee_code='NV011'),
    'Săn đầu người và tiếp cận các kỹ sư công nghệ chất lượng cao cho các vị trí trọng điểm.',
    '2+ năm tuyển dụng IT, mạng lưới quan hệ rộng trong cộng đồng lập trình viên.',
    'Thưởng tuyển dụng theo từng case thành công, cơ hội thăng tiến Talent Lead.'),

(12, 'YCTD-2026-092', 'Nhân viên Hành chính Tổng hợp', 2, 5, 1, 0, 12000000, 16000000, '2026-11-05', 'NORMAL', 'PAUSED', 'Q3/2026',
    (SELECT id FROM employees WHERE employee_code='NV013'),
    'Quản lý văn phòng phẩm, cơ sở vật chất văn phòng và lễ tân đón tiếp đối tác.',
    'Nhanh nhẹn, cẩn thận, có kỹ năng giao tiếp và quản lý hồ sơ tốt.',
    'Môi trường thân thiện, hỗ trợ cơm trưa văn phòng và trà nước miễn phí.');

-- Reset sequence nếu cần
SELECT setval('recruitment_requests_id_seq', 12, true);

-- 5.2 Nạp 86 Ứng viên chuẩn xác theo tỷ lệ nguồn và 5 vòng phễu
-- Nguồn: LinkedIn (36 ~ 42%), TopCV/VNW (30 ~ 35%), Nội bộ (13 ~ 15%), Khác (7 ~ 8%) = 86 ứng viên
-- Phễu:
-- 5 Onboarded (5.8%)
-- 3 Offer (Tổng Offer + Onboarded = 8 ~ 9.3%)
-- 16 Interview (Tổng Interview + Offer + Onboarded = 24 ~ 27.9%)
-- 30 Screening (Tổng Screening + Interview + Offer + Onboarded = 54 ~ 62.8%)
-- 32 New (Tổng toàn bộ hồ sơ = 86 ~ 100%)

-- Danh sách ứng viên Onboarded (5 người)
INSERT INTO candidates (candidate_code, full_name, email, phone, recruitment_request_id, source, stage, experience_years, expected_salary, applied_date)
VALUES
('UV-2026-001', 'Nguyễn Tiến Dũng', 'dung.nt@gmail.com', '0901112233', 1, 'LinkedIn', 'ONBOARDED', 4.5, 42000000, '2026-08-01'),
('UV-2026-002', 'Trần Hữu Nam', 'nam.th@gmail.com', '0902223344', 1, 'TopCV/VNW', 'ONBOARDED', 5.0, 45000000, '2026-08-05'),
('UV-2026-003', 'Đặng Thùy Trang', 'trang.dt@gmail.com', '0903334455', 2, 'Nội bộ (Ref)', 'ONBOARDED', 4.0, 30000000, '2026-08-10'),
('UV-2026-004', 'Vũ Tuấn Kiệt', 'kiet.vt@gmail.com', '0904445566', 3, 'LinkedIn', 'ONBOARDED', 3.5, 32000000, '2026-08-12'),
('UV-2026-005', 'Lê Thị Thu', 'thu.lt@gmail.com', '0905556677', 5, 'Khác', 'ONBOARDED', 4.0, 22000000, '2026-08-15');

-- Danh sách ứng viên Offer (3 người, tổng Offer + Onboarded = 8)
INSERT INTO candidates (candidate_code, full_name, email, phone, recruitment_request_id, source, stage, experience_years, expected_salary, applied_date)
VALUES
('UV-2026-006', 'Phan Văn Hải', 'hai.pv@gmail.com', '0906667788', 1, 'LinkedIn', 'OFFER', 4.0, 40000000, '2026-08-20'),
('UV-2026-007', 'Ngô Bảo Châu', 'chau.nb@gmail.com', '0907778899', 3, 'TopCV/VNW', 'OFFER', 3.0, 28000000, '2026-08-22'),
('UV-2026-008', 'Hoàng Minh Quân', 'quan.hm@gmail.com', '0908889900', 4, 'Nội bộ (Ref)', 'OFFER', 2.5, 20000000, '2026-08-25');

-- Danh sách ứng viên Interview (16 người, tổng Interview + Offer + Onboarded = 24)
-- Bao gồm 3 ứng viên có lịch phỏng vấn ngày hôm nay theo ảnh!
INSERT INTO candidates (candidate_code, full_name, email, phone, recruitment_request_id, source, stage, experience_years, expected_salary, applied_date)
VALUES
('UV-2026-009', 'Vũ Hoàng Nam', 'nam.vh@gmail.com', '0910001122', 1, 'LinkedIn', 'INTERVIEW', 4.5, 42000000, '2026-09-01'),
('UV-2026-010', 'Phạm Khánh Linh', 'linh.pk@gmail.com', '0911112233', 3, 'TopCV/VNW', 'INTERVIEW', 3.2, 30000000, '2026-09-02'),
('UV-2026-011', 'Trương Bá Đạt', 'dat.tb@gmail.com', '0912223344', 6, 'LinkedIn', 'INTERVIEW', 3.8, 38000000, '2026-09-03'),
('UV-2026-012', 'Nguyễn Hữu Tài', 'tai.nh@gmail.com', '0913334455', 1, 'TopCV/VNW', 'INTERVIEW', 4.0, 38000000, '2026-09-04'),
('UV-2026-013', 'Lê Diệu Hương', 'huong.ld@gmail.com', '0914445566', 4, 'Nội bộ (Ref)', 'INTERVIEW', 2.0, 18000000, '2026-09-05'),
('UV-2026-014', 'Đỗ Thành Long', 'long.dt@gmail.com', '0915556677', 7, 'Khác', 'INTERVIEW', 3.0, 20000000, '2026-09-05'),
('UV-2026-015', 'Trịnh Bích Ngọc', 'ngoc.tb@gmail.com', '0916667788', 8, 'LinkedIn', 'INTERVIEW', 2.8, 24000000, '2026-09-06'),
('UV-2026-016', 'Bùi Văn Hưng', 'hung.bv@gmail.com', '0917778899', 9, 'TopCV/VNW', 'INTERVIEW', 3.5, 22000000, '2026-09-06'),
('UV-2026-017', 'Vương Đình Toàn', 'toan.vd@gmail.com', '0918889900', 10, 'LinkedIn', 'INTERVIEW', 3.0, 23000000, '2026-09-07'),
('UV-2026-018', 'Mai Phương Thảo', 'thao.mp@gmail.com', '0919990011', 11, 'Nội bộ (Ref)', 'INTERVIEW', 2.5, 19000000, '2026-09-07'),
('UV-2026-019', 'Lương Thế Vinh', 'vinh.lt@gmail.com', '0920001122', 1, 'TopCV/VNW', 'INTERVIEW', 5.0, 48000000, '2026-09-08'),
('UV-2026-020', 'Phùng Gia Bảo', 'bao.pg@gmail.com', '0921112233', 3, 'LinkedIn', 'INTERVIEW', 4.0, 35000000, '2026-09-08'),
('UV-2026-021', 'Cao Thị Yến', 'yen.ct@gmail.com', '0922223344', 4, 'TopCV/VNW', 'INTERVIEW', 2.0, 17000000, '2026-09-09'),
('UV-2026-022', 'Dương Quốc Anh', 'anh.dq@gmail.com', '0923334455', 8, 'LinkedIn', 'INTERVIEW', 3.0, 26000000, '2026-09-09'),
('UV-2026-023', 'Hà Thảo Ly', 'ly.ht@gmail.com', '0924445566', 9, 'Khác', 'INTERVIEW', 2.5, 18000000, '2026-09-10'),
('UV-2026-024', 'Lâm Văn Phước', 'phuoc.lv@gmail.com', '0925556677', 10, 'Nội bộ (Ref)', 'INTERVIEW', 3.2, 24000000, '2026-09-10');

-- Tạo 30 ứng viên Screening (giai đoạn 2)
DO $$
DECLARE
    sources TEXT[] := ARRAY['LinkedIn', 'TopCV/VNW', 'Nội bộ (Ref)', 'Khác'];
    s_idx INT;
    i INT;
    req_id INT;
BEGIN
    FOR i IN 25..54 LOOP
        s_idx := 1 + ((i * 3) % 4);
        req_id := 1 + (i % 12);
        INSERT INTO candidates (candidate_code, full_name, email, phone, recruitment_request_id, source, stage, experience_years, expected_salary, applied_date)
        VALUES ('UV-2026-' || LPAD(i::text, 3, '0'), 'Ứng viên Sàng lọc ' || i, 'cand' || i || '@test.com', '093' || LPAD(i::text, 7, '0'), req_id, sources[s_idx], 'SCREENING', 2.5, 22000000, CURRENT_DATE - (i % 15));
    END LOOP;
END $$;

-- Tạo 32 ứng viên New (giai đoạn 1) để đủ 86 ứng viên
DO $$
DECLARE
    sources TEXT[] := ARRAY['LinkedIn', 'TopCV/VNW', 'Nội bộ (Ref)', 'Khác'];
    s_idx INT;
    i INT;
    req_id INT;
BEGIN
    FOR i IN 55..86 LOOP
        s_idx := 1 + ((i * 5) % 4);
        req_id := 1 + (i % 12);
        INSERT INTO candidates (candidate_code, full_name, email, phone, recruitment_request_id, source, stage, experience_years, expected_salary, applied_date)
        VALUES ('UV-2026-' || LPAD(i::text, 3, '0'), 'Ứng viên Mới ' || i, 'cand' || i || '@test.com', '094' || LPAD(i::text, 7, '0'), req_id, sources[s_idx], 'NEW', 1.5, 18000000, CURRENT_DATE - (i % 7));
    END LOOP;
END $$;

-- Cập nhật phân bổ nguồn chuẩn xác:
-- LinkedIn: 36, TopCV/VNW: 30, Nội bộ: 13, Khác: 7 (Tổng: 86)
UPDATE candidates SET source = 'LinkedIn' WHERE id IN (SELECT id FROM candidates ORDER BY id LIMIT 36);
UPDATE candidates SET source = 'TopCV/VNW' WHERE id IN (SELECT id FROM candidates WHERE id NOT IN (SELECT id FROM candidates ORDER BY id LIMIT 36) ORDER BY id LIMIT 30);
UPDATE candidates SET source = 'Nội bộ (Ref)' WHERE id IN (SELECT id FROM candidates WHERE id NOT IN (SELECT id FROM candidates ORDER BY id LIMIT 66) ORDER BY id LIMIT 13);
UPDATE candidates SET source = 'Khác' WHERE id IN (SELECT id FROM candidates WHERE id NOT IN (SELECT id FROM candidates ORDER BY id LIMIT 79));

-- 5.3 Nạp Lịch phỏng vấn mẫu
-- 3 ca phỏng vấn ngày HÔM NAY (CURRENT_DATE) khớp 100% với ảnh mockup:
-- Ca 1: 09:30 AM | Vũ Hoàng Nam - Senior Fullstack Eng. | PV: Nguyễn Minh Tuấn • Vòng Chuyên môn
-- Ca 2: 14:00 PM | Phạm Khánh Linh - Product Designer UI/UX | PV: Nguyễn Minh Tuấn • Vòng Portfolio
-- Ca 3: 16:15 PM | Trương Bá Đạt - DevOps / Cloud Security | PV: Trần Thị Mai • Vòng 1 (HR Fit)
INSERT INTO interviews (candidate_id, recruitment_request_id, interviewer_id, round_name, interview_date, interview_time, location_or_link, status)
VALUES
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-009'),
    1,
    (SELECT id FROM employees WHERE employee_code='NV012'),
    'Vòng Chuyên môn',
    CURRENT_DATE,
    '09:30:00',
    'Phòng họp Kỹ thuật (Tầng 4) & Google Meet',
    'SCHEDULED'
),
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-010'),
    3,
    (SELECT id FROM employees WHERE employee_code='NV012'),
    'Vòng Portfolio',
    CURRENT_DATE,
    '14:00:00',
    'Phòng Sáng tạo UI/UX & Google Meet',
    'SCHEDULED'
),
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-011'),
    6,
    (SELECT id FROM employees WHERE employee_code='NV013'),
    'Vòng 1 (HR Fit)',
    CURRENT_DATE,
    '16:15:00',
    'Phòng Phỏng vấn Nhân sự 2',
    'SCHEDULED'
);

-- Bổ sung thêm các ca phỏng vấn trong tuần này (từ Thứ 2 đến Chủ nhật) để Lịch phỏng vấn tuần hiển thị sinh động
INSERT INTO interviews (candidate_id, recruitment_request_id, interviewer_id, round_name, interview_date, interview_time, location_or_link, status)
VALUES
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-012'),
    1,
    (SELECT id FROM employees WHERE employee_code='NV012'),
    'Vòng 1 (Kỹ thuật)',
    CURRENT_DATE + 1,
    '10:00:00',
    'Google Meet: meet.google.com/mix-hrm-tech',
    'SCHEDULED'
),
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-013'),
    4,
    (SELECT id FROM employees WHERE employee_code='NV014'),
    'Vòng Đánh giá Năng lực Viết',
    CURRENT_DATE + 1,
    '15:30:00',
    'Phòng Họp Marketing Tầng 3',
    'SCHEDULED'
),
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-014'),
    7,
    (SELECT id FROM employees WHERE employee_code='NV015'),
    'Vòng Nghiệp vụ C&B',
    CURRENT_DATE + 2,
    '09:00:00',
    'Phòng Hội thảo Nhân sự',
    'SCHEDULED'
),
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-015'),
    8,
    (SELECT id FROM employees WHERE employee_code='NV011'),
    'Vòng Phỏng vấn Frontend Vue',
    CURRENT_DATE + 2,
    '14:30:00',
    'Google Meet: meet.google.com/frontend-vue',
    'SCHEDULED'
),
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-016'),
    9,
    (SELECT id FROM employees WHERE employee_code='NV013'),
    'Vòng Đàm phán Doanh nghiệp',
    CURRENT_DATE + 3,
    '10:30:00',
    'Phòng Khách VIP B2B',
    'SCHEDULED'
),
(
    (SELECT id FROM candidates WHERE candidate_code='UV-2026-017'),
    10,
    (SELECT id FROM employees WHERE employee_code='NV012'),
    'Vòng Kiểm thử Tự động',
    CURRENT_DATE + 3,
    '16:00:00',
    'Phòng Lab Kỹ thuật',
    'SCHEDULED'
);
