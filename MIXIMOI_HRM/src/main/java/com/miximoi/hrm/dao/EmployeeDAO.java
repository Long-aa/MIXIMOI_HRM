package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Employee.
 * Đồng bộ đầy đủ với schema mở rộng (CCCD, địa chỉ TT, ngân hàng, bảo hiểm, v.v.)
 */
public class EmployeeDAO {

    private static final String BASE_SELECT =
        "SELECT e.id, e.employee_code, e.full_name, e.date_of_birth, e.gender, "
      + "e.phone, e.email, e.address, e.temp_address, e.nationality, e.ethnicity, e.religion, e.marital_status, e.avatar_url, "
      + "e.identity_number, e.identity_date, e.identity_place, "
      + "e.id_card_front_url, e.id_card_back_url, e.resume_url, "
      + "e.department_id, d.name AS department_name, "
      + "e.position_id, p.name AS position_name, "
      + "e.employee_type_id, et.name AS employee_type_name, "
      + "e.start_date, e.end_date, e.termination_reason, e.status, "
      + "e.base_salary, e.bank_account, e.bank_name, e.bank_branch, "
      + "e.tax_code, e.insurance_number, "
      + "e.emergency_contact_name, e.emergency_contact_phone, e.emergency_contact_relation, "
      + "e.work_location, e.employee_level, e.secondary_phone, e.line_manager, e.mentor_name, "
      + "e.created_at, e.updated_at "
      + "FROM employees e "
      + "LEFT JOIN departments d ON e.department_id = d.id "
      + "LEFT JOIN positions p ON e.position_id = p.id "
      + "LEFT JOIN employee_types et ON e.employee_type_id = et.id ";

    /** Lấy tất cả nhân viên đang hoạt động */
    public List<Employee> findAll() {
        List<Employee> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE e.status != 'INACTIVE' ORDER BY e.employee_code";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Tìm nhân viên theo ID */
    public Employee findById(int id) {
        String sql = BASE_SELECT + "WHERE e.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    /** Tìm kiếm nhân viên theo từ khóa, phòng ban, chức vụ, trạng thái */
    public List<Employee> search(String keyword, Integer departmentId, Integer positionId, String status) {
        List<Employee> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ? OR LOWER(e.email) LIKE ? OR e.phone LIKE ?) ");
        }
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (positionId != null && positionId > 0) {
            sql.append("AND e.position_id = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            if ("ON_LEAVE".equalsIgnoreCase(status.trim())) {
                sql.append("AND (e.status = 'ON_LEAVE' OR EXISTS (SELECT 1 FROM leave_requests lr WHERE lr.employee_id = e.id AND lr.status = 'APPROVED' AND CURRENT_DATE BETWEEN lr.start_date AND lr.end_date)) ");
            } else if ("INACTIVE".equalsIgnoreCase(status.trim())) {
                sql.append("AND (e.status = 'INACTIVE' OR e.status = 'TERMINATED') ");
            } else if ("NEW".equalsIgnoreCase(status.trim())) {
                sql.append("AND ((e.created_at IS NOT NULL AND e.created_at >= (CURRENT_TIMESTAMP - INTERVAL '7 days')) ")
                   .append("  OR (e.start_date IS NOT NULL AND e.start_date >= (CURRENT_DATE - INTERVAL '7 days'))) ");
            } else {
                sql.append("AND e.status = ? ");
            }
        } else {
            // Mặc định: ẩn nhân viên đã nghỉ việc/lưu trữ trong tab "Tất cả"
            // Nhất quán với findAll() — INACTIVE/TERMINATED chỉ hiện khi lọc tường minh
            sql.append("AND e.status NOT IN ('INACTIVE', 'TERMINATED') ");
        }
        if ("NEW".equalsIgnoreCase(status != null ? status.trim() : "")) {
            sql.append("ORDER BY COALESCE(e.created_at, e.start_date::timestamp) DESC, e.employee_code");
        } else {
            sql.append("ORDER BY e.employee_code");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }
            if (departmentId != null && departmentId > 0) ps.setInt(idx++, departmentId);
            if (positionId != null && positionId > 0) ps.setInt(idx++, positionId);
            if (status != null && !status.trim().isEmpty() && !"ON_LEAVE".equalsIgnoreCase(status.trim()) && !"INACTIVE".equalsIgnoreCase(status.trim()) && !"NEW".equalsIgnoreCase(status.trim())) {
                ps.setString(idx, status.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.search lỗi: " + e.getMessage());
        }
        return list;
    }

    public List<Employee> search(String keyword, Integer departmentId, String status) {
        return search(keyword, departmentId, null, status);
    }

    /** Sinh mã nhân viên tiếp theo tự động (dạng NV013) */
    public String getNextEmployeeCode() {
        String sql = "SELECT employee_code FROM employees WHERE employee_code ~ '^NV[0-9]+$'";
        int max = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String code = rs.getString(1);
                try {
                    int num = Integer.parseInt(code.substring(2));
                    if (num > max) max = num;
                } catch (NumberFormatException ignored) {}
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.getNextEmployeeCode lỗi: " + e.getMessage());
        }
        return String.format("NV%03d", max + 1);
    }

    /** Thêm nhân viên mới (đầy đủ các trường mở rộng) */
    public boolean insert(Employee emp) {
        String sql = "INSERT INTO employees (employee_code, full_name, date_of_birth, gender, "
                   + "phone, email, address, temp_address, nationality, ethnicity, religion, marital_status, avatar_url, "
                   + "identity_number, identity_date, identity_place, id_card_front_url, id_card_back_url, resume_url, "
                   + "department_id, position_id, employee_type_id, "
                   + "start_date, status, base_salary, bank_account, bank_name, bank_branch, "
                   + "tax_code, insurance_number, "
                   + "emergency_contact_name, emergency_contact_phone, emergency_contact_relation, "
                   + "work_location, employee_level, secondary_phone, line_manager, mentor_name) "
                   + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, emp.getEmployeeCode());
            ps.setString(2, emp.getFullName());
            ps.setDate(3, emp.getDateOfBirth() != null ? Date.valueOf(emp.getDateOfBirth()) : null);
            ps.setString(4, emp.getGender());
            ps.setString(5, emp.getPhone());
            ps.setString(6, emp.getEmail());
            ps.setString(7, emp.getAddress());
            ps.setString(8, emp.getTempAddress());
            ps.setString(9, emp.getNationality() != null ? emp.getNationality() : "Việt Nam");
            ps.setString(10, emp.getEthnicity());
            ps.setString(11, emp.getReligion());
            ps.setString(12, emp.getMaritalStatus());
            ps.setString(13, emp.getAvatarUrl());
            ps.setString(14, emp.getIdentityNumber());
            ps.setDate(15, emp.getIdentityDate() != null ? Date.valueOf(emp.getIdentityDate()) : null);
            ps.setString(16, emp.getIdentityPlace());
            ps.setString(17, emp.getIdCardFrontUrl());
            ps.setString(18, emp.getIdCardBackUrl());
            ps.setString(19, emp.getResumeUrl());
            if (emp.getDepartmentId() > 0) ps.setInt(20, emp.getDepartmentId());
            else ps.setNull(20, Types.INTEGER);
            if (emp.getPositionId() > 0) ps.setInt(21, emp.getPositionId());
            else ps.setNull(21, Types.INTEGER);
            if (emp.getEmployeeTypeId() > 0) ps.setInt(22, emp.getEmployeeTypeId());
            else ps.setInt(22, 1);
            ps.setDate(23, emp.getStartDate() != null ? Date.valueOf(emp.getStartDate()) : Date.valueOf(java.time.LocalDate.now()));
            ps.setString(24, emp.getStatus() != null && !emp.getStatus().isEmpty() ? emp.getStatus() : "ACTIVE");
            if (emp.getBaseSalary() != null) ps.setBigDecimal(25, emp.getBaseSalary());
            else ps.setNull(25, Types.NUMERIC);
            ps.setString(26, emp.getBankAccount());
            ps.setString(27, emp.getBankName());
            ps.setString(28, emp.getBankBranch());
            ps.setString(29, emp.getTaxCode());
            ps.setString(30, emp.getInsuranceNumber());
            ps.setString(31, emp.getEmergencyContactName());
            ps.setString(32, emp.getEmergencyContactPhone());
            ps.setString(33, emp.getEmergencyContactRelation());
            ps.setString(34, emp.getWorkLocation());
            ps.setString(35, emp.getEmployeeLevel());
            ps.setString(36, emp.getSecondaryPhone());
            ps.setString(37, emp.getLineManager());
            ps.setString(38, emp.getMentorName());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) emp.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Cập nhật thông tin nhân viên (đầy đủ) */
    public boolean update(Employee emp) {
        String sql = "UPDATE employees SET employee_code=?, full_name=?, date_of_birth=?, gender=?, phone=?, "
                   + "email=?, address=?, temp_address=?, nationality=?, ethnicity=?, religion=?, marital_status=?, avatar_url=?, "
                   + "identity_number=?, identity_date=?, identity_place=?, "
                   + "id_card_front_url=?, id_card_back_url=?, resume_url=?, "
                   + "department_id=?, position_id=?, employee_type_id=?, "
                   + "start_date=?, end_date=?, termination_reason=?, status=?, "
                   + "base_salary=?, bank_account=?, bank_name=?, bank_branch=?, "
                   + "tax_code=?, insurance_number=?, "
                   + "emergency_contact_name=?, emergency_contact_phone=?, emergency_contact_relation=?, "
                   + "work_location=?, employee_level=?, secondary_phone=?, line_manager=?, mentor_name=?, "
                   + "updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getEmployeeCode());
            ps.setString(2, emp.getFullName());
            ps.setDate(3, emp.getDateOfBirth() != null ? Date.valueOf(emp.getDateOfBirth()) : null);
            ps.setString(4, emp.getGender());
            ps.setString(5, emp.getPhone());
            ps.setString(6, emp.getEmail());
            ps.setString(7, emp.getAddress());
            ps.setString(8, emp.getTempAddress());
            ps.setString(9, emp.getNationality());
            ps.setString(10, emp.getEthnicity());
            ps.setString(11, emp.getReligion());
            ps.setString(12, emp.getMaritalStatus());
            ps.setString(13, emp.getAvatarUrl());
            ps.setString(14, emp.getIdentityNumber());
            ps.setDate(15, emp.getIdentityDate() != null ? Date.valueOf(emp.getIdentityDate()) : null);
            ps.setString(16, emp.getIdentityPlace());
            ps.setString(17, emp.getIdCardFrontUrl());
            ps.setString(18, emp.getIdCardBackUrl());
            ps.setString(19, emp.getResumeUrl());
            ps.setInt(20, emp.getDepartmentId());
            ps.setInt(21, emp.getPositionId());
            ps.setInt(22, emp.getEmployeeTypeId());
            ps.setDate(23, emp.getStartDate() != null ? Date.valueOf(emp.getStartDate()) : null);
            ps.setDate(24, emp.getEndDate() != null ? Date.valueOf(emp.getEndDate()) : null);
            ps.setString(25, emp.getTerminationReason());
            ps.setString(26, emp.getStatus());
            if (emp.getBaseSalary() != null) ps.setBigDecimal(27, emp.getBaseSalary());
            else ps.setNull(27, Types.NUMERIC);
            ps.setString(28, emp.getBankAccount());
            ps.setString(29, emp.getBankName());
            ps.setString(30, emp.getBankBranch());
            ps.setString(31, emp.getTaxCode());
            ps.setString(32, emp.getInsuranceNumber());
            ps.setString(33, emp.getEmergencyContactName());
            ps.setString(34, emp.getEmergencyContactPhone());
            ps.setString(35, emp.getEmergencyContactRelation());
            ps.setString(36, emp.getWorkLocation());
            ps.setString(37, emp.getEmployeeLevel());
            ps.setString(38, emp.getSecondaryPhone());
            ps.setString(39, emp.getLineManager());
            ps.setString(40, emp.getMentorName());
            ps.setInt(41, emp.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.update lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Xóa mềm nhân viên (đổi status = INACTIVE) */
    public boolean deactivate(int id) {
        String sql = "UPDATE employees SET status='INACTIVE', updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.deactivate lỗi: " + e.getMessage());
        }
        return false;
    }

    /** Xóa mềm hàng loạt theo danh sách ID */
    public int deactivateBulk(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return 0;
        StringBuilder sql = new StringBuilder("UPDATE employees SET status='INACTIVE', updated_at=CURRENT_TIMESTAMP WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i > 0 ? ",?" : "?");
        }
        sql.append(")");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.deactivateBulk lỗi: " + e.getMessage());
        }
        return 0;
    }

    /** Lấy danh sách nhân viên theo list ID (dùng cho bulk export) */
    public List<Employee> findByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE e.id IN (");
        for (int i = 0; i < ids.size(); i++) sql.append(i > 0 ? ",?" : "?");
        sql.append(") ORDER BY e.employee_code");
        List<Employee> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) ps.setInt(i + 1, ids.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.findByIds lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Đếm tổng số tất cả nhân viên */
    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM employees";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.countTotal lỗi: " + e.getMessage());
        }
        return 0;
    }

    /** Đếm tổng nhân viên theo trạng thái */
    public int countByStatus(String status) {
        if ("ON_LEAVE".equalsIgnoreCase(status)) {
            return countOnLeave();
        }
        if ("INACTIVE".equalsIgnoreCase(status)) {
            return countInactive();
        }
        String sql = "SELECT COUNT(*) FROM employees WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.countByStatus lỗi: " + e.getMessage());
        }
        return 0;
    }

    /** Đếm nhân viên đang nghỉ phép (status = ON_LEAVE hoặc có đơn APPROVED bao gồm hôm nay) */
    public int countOnLeave() {
        String sql = "SELECT COUNT(DISTINCT e.id) FROM employees e "
                   + "WHERE e.status = 'ON_LEAVE' "
                   + "   OR EXISTS (SELECT 1 FROM leave_requests lr "
                   + "              WHERE lr.employee_id = e.id AND lr.status = 'APPROVED' "
                   + "                AND CURRENT_DATE BETWEEN lr.start_date AND lr.end_date)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.countOnLeave lỗi: " + e.getMessage());
        }
        return 0;
    }

    /** Đếm nhân sự đã nghỉ việc / lưu trữ */
    public int countInactive() {
        String sql = "SELECT COUNT(*) FROM employees WHERE status = 'INACTIVE' OR status = 'TERMINATED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.countInactive lỗi: " + e.getMessage());
        }
        return 0;
    }

    public int countActive() {
        return countByStatus("ACTIVE");
    }

    // =========================================================================
    //  Phan trang (Pagination)
    // =========================================================================

    /**
     * Lay danh sach nhan vien theo trang (Server-side Pagination).
     *
     * <p>Su dung LIMIT/OFFSET cua PostgreSQL - hieu qua voi bang lon.
     * Chi truyen du lieu cua trang hien tai thay vi load toan bo.
     *
     * <p>Cong thuc OFFSET: {@code (page - 1) * pageSize}
     *
     * <pre>
     *   Trang 1, pageSize=10: LIMIT 10 OFFSET 0   -> hang 1-10
     *   Trang 2, pageSize=10: LIMIT 10 OFFSET 10  -> hang 11-20
     *   Trang 3, pageSize=10: LIMIT 10 OFFSET 20  -> hang 21-30
     * </pre>
     *
     * @param page     So trang hien tai (bat dau tu 1, khong phai 0)
     * @param pageSize So ban ghi moi trang (e.g. 10, 20, 50)
     * @return Danh sach nhan vien cua trang tuong ung (co the rong neu het du lieu)
     * @throws IllegalArgumentException neu page < 1 hoac pageSize < 1
     */
    public List<Employee> getEmployeesWithPagination(int page, int pageSize) {
        // --- Validate input de tranh OFFSET am hoac chia 0 ---
        if (page < 1) {
            throw new IllegalArgumentException("So trang phai >= 1, nhung nhan duoc: " + page);
        }
        if (pageSize < 1) {
            throw new IllegalArgumentException("Page size phai >= 1, nhung nhan duoc: " + pageSize);
        }

        List<Employee> list = new ArrayList<>();

        // LIMIT: bao nhieu ban ghi moi trang
        // OFFSET: bo qua bao nhieu ban ghi o cac trang truoc
        // Dung PreparedStatement de tranh SQL Injection va cache query plan tren PostgreSQL
        String sql = BASE_SELECT
                   + "WHERE e.status != 'INACTIVE' "
                   + "ORDER BY e.employee_code "
                   + "LIMIT ? OFFSET ?";

        int offset = (page - 1) * pageSize;  // Tinh vi tri bat dau (0-indexed)

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, pageSize);  // Param 1: so ban ghi toi da lay ve
            ps.setInt(2, offset);    // Param 2: bo qua bao nhieu ban ghi

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("EmployeeDAO.getEmployeesWithPagination loi (page="
                               + page + ", size=" + pageSize + "): " + e.getMessage());
        }

        return list;
    }

    /**
     * Dem tong so nhan vien dang ACTIVE – dung de tinh so trang toi da.
     *
     * <p>Ket hop voi {@link #getEmployeesWithPagination(int, int)} de hien thi phan trang:
     * <pre>
     *   int totalRecords = employeeDAO.countAllForPagination();
     *   int totalPages   = (int) Math.ceil((double) totalRecords / pageSize);
     * </pre>
     *
     * @return Tong so nhan vien dang hoat dong (status != INACTIVE)
     */
    public int countAllForPagination() {
        String sql = "SELECT COUNT(*) FROM employees WHERE status != 'INACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("EmployeeDAO.countAllForPagination loi: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Phan trang ket hop tim kiem – lay du lieu loc theo keyword + department + status.
     *
     * @param keyword      Tu khoa tim kiem (ho ten, ma NV, email, SDT) – null thi bo qua
     * @param departmentId ID phong ban – null hoac 0 thi bo qua filter nay
     * @param status       Trang thai nhan vien – null thi bo qua filter nay
     * @param page         So trang hien tai (bat dau tu 1)
     * @param pageSize     So ban ghi moi trang
     * @return Danh sach nhan vien khop dieu kien loc, gioi han theo trang
     */
    public List<Employee> searchWithPagination(String keyword, Integer departmentId,
                                               String status, int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;

        List<Employee> list = new ArrayList<>();

        // Xay dung SQL dong theo cac filter
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");

        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ? "
                     + "  OR LOWER(e.email) LIKE ? OR e.phone LIKE ?) ");
        }
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (status != null && !status.isBlank()) {
            sql.append("AND e.status = ? ");
        }

        sql.append("ORDER BY e.employee_code LIMIT ? OFFSET ?");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;

            if (keyword != null && !keyword.isBlank()) {
                String like = "%" + keyword.strip().toLowerCase() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, "%" + keyword.strip() + "%");
            }
            if (departmentId != null && departmentId > 0) {
                ps.setInt(idx++, departmentId);
            }
            if (status != null && !status.isBlank()) {
                ps.setString(idx++, status.strip());
            }

            ps.setInt(idx++, pageSize);
            ps.setInt(idx, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.err.println("EmployeeDAO.searchWithPagination loi: " + e.getMessage());
        }

        return list;
    }


    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setId(rs.getInt("id"));
        e.setEmployeeCode(rs.getString("employee_code"));
        e.setFullName(rs.getString("full_name"));
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) e.setDateOfBirth(dob.toLocalDate());
        e.setGender(rs.getString("gender"));
        e.setPhone(rs.getString("phone"));
        e.setEmail(rs.getString("email"));
        e.setAddress(rs.getString("address"));
        e.setTempAddress(rs.getString("temp_address"));
        e.setNationality(rs.getString("nationality"));
        e.setEthnicity(rs.getString("ethnicity"));
        try { e.setReligion(rs.getString("religion")); } catch (SQLException ignored) {}
        try { e.setMaritalStatus(rs.getString("marital_status")); } catch (SQLException ignored) {}
        e.setAvatarUrl(rs.getString("avatar_url"));
        e.setIdentityNumber(rs.getString("identity_number"));
        Date idDate = rs.getDate("identity_date");
        if (idDate != null) e.setIdentityDate(idDate.toLocalDate());
        e.setIdentityPlace(rs.getString("identity_place"));
        try { e.setIdCardFrontUrl(rs.getString("id_card_front_url")); } catch (SQLException ignored) {}
        try { e.setIdCardBackUrl(rs.getString("id_card_back_url")); } catch (SQLException ignored) {}
        try { e.setResumeUrl(rs.getString("resume_url")); } catch (SQLException ignored) {}
        e.setDepartmentId(rs.getInt("department_id"));
        e.setDepartmentName(rs.getString("department_name"));
        e.setPositionId(rs.getInt("position_id"));
        e.setPositionName(rs.getString("position_name"));
        e.setEmployeeTypeId(rs.getInt("employee_type_id"));
        e.setEmployeeTypeName(rs.getString("employee_type_name"));
        Date startDate = rs.getDate("start_date");
        if (startDate != null) e.setStartDate(startDate.toLocalDate());
        Date endDate = rs.getDate("end_date");
        if (endDate != null) e.setEndDate(endDate.toLocalDate());
        e.setTerminationReason(rs.getString("termination_reason"));
        e.setStatus(rs.getString("status"));
        BigDecimal salary = rs.getBigDecimal("base_salary");
        if (salary != null) e.setBaseSalary(salary);
        e.setBankAccount(rs.getString("bank_account"));
        e.setBankName(rs.getString("bank_name"));
        e.setBankBranch(rs.getString("bank_branch"));
        e.setTaxCode(rs.getString("tax_code"));
        e.setInsuranceNumber(rs.getString("insurance_number"));
        e.setEmergencyContactName(rs.getString("emergency_contact_name"));
        e.setEmergencyContactPhone(rs.getString("emergency_contact_phone"));
        e.setEmergencyContactRelation(rs.getString("emergency_contact_relation"));
        try { e.setWorkLocation(rs.getString("work_location")); } catch (SQLException ignored) {}
        try { e.setEmployeeLevel(rs.getString("employee_level")); } catch (SQLException ignored) {}
        try { e.setSecondaryPhone(rs.getString("secondary_phone")); } catch (SQLException ignored) {}
        try { e.setLineManager(rs.getString("line_manager")); } catch (SQLException ignored) {}
        try { e.setMentorName(rs.getString("mentor_name")); } catch (SQLException ignored) {}
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) e.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) e.setUpdatedAt(updatedAt.toLocalDateTime());
        return e;
    }
}
