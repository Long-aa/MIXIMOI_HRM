package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Contract (Hợp đồng lao động).
 */
public class ContractDAO {

    private static final String BASE_SELECT =
        "SELECT c.id, c.contract_code, c.employee_id, e.employee_code, e.full_name, "
      + "d.name AS department_name, "
      + "c.contract_type, c.start_date, c.end_date, c.base_salary, c.status, c.notes, "
      + "c.signer_name, c.signer_title, c.work_location, c.job_description, "
      + "c.probation_months, c.probation_salary_pct, c.allowance_amount, c.signed_date, "
      + "c.identity_number, c.identity_date, c.identity_place, c.contract_file_url, "
      + "c.created_at, c.updated_at "
      + "FROM contracts c "
      + "JOIN employees e ON c.employee_id = e.id "
      + "LEFT JOIN departments d ON e.department_id = d.id ";

    /** Sinh mã hợp đồng tiếp theo tự động (dạng HD012) */
    public String getNextContractCode() {
        String sql = "SELECT contract_code FROM contracts WHERE contract_code ~ '^HD[0-9]+$'";
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
            System.err.println("ContractDAO.getNextContractCode lỗi: " + e.getMessage());
        }
        return String.format("HD%03d", max + 1);
    }

    public List<Contract> findAll() {
        List<Contract> list = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY c.start_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("ContractDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    public List<Contract> findByEmployeeId(int employeeId) {
        List<Contract> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE c.employee_id = ? ORDER BY c.start_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("ContractDAO.findByEmployeeId lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Tìm hợp đồng sắp hết hạn trong N ngày tới */
    public List<Contract> findExpiringSoon(int daysAhead) {
        List<Contract> list = new ArrayList<>();
        String sql = BASE_SELECT
                   + "WHERE c.status = 'ACTIVE' "
                   + "AND c.end_date IS NOT NULL "
                   + "AND c.end_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '"
                   + daysAhead + " days') ORDER BY c.end_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("ContractDAO.findExpiringSoon lỗi: " + e.getMessage());
        }
        return list;
    }

    public Contract findById(int id) {
        String sql = BASE_SELECT + "WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("ContractDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(Contract c) {
        String sql = "INSERT INTO contracts (contract_code, employee_id, contract_type, "
                   + "start_date, end_date, base_salary, status, notes, "
                   + "signer_name, signer_title, work_location, job_description, "
                   + "probation_months, probation_salary_pct, allowance_amount, signed_date, "
                   + "identity_number, identity_date, identity_place, contract_file_url) "
                   + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getContractCode());
            ps.setInt(2, c.getEmployeeId());
            ps.setString(3, c.getContractType());
            ps.setDate(4, c.getStartDate() != null ? Date.valueOf(c.getStartDate()) : null);
            ps.setDate(5, c.getEndDate() != null ? Date.valueOf(c.getEndDate()) : null);
            ps.setBigDecimal(6, c.getBaseSalary());
            ps.setString(7, c.getStatus() != null ? c.getStatus() : "ACTIVE");
            ps.setString(8, c.getNotes());
            ps.setString(9, c.getSignerName());
            ps.setString(10, c.getSignerTitle());
            ps.setString(11, c.getWorkLocation());
            ps.setString(12, c.getJobDescription());
            if (c.getProbationMonths() != null) ps.setInt(13, c.getProbationMonths());
            else ps.setNull(13, Types.INTEGER);
            ps.setBigDecimal(14, c.getProbationSalaryPct());
            ps.setBigDecimal(15, c.getAllowanceAmount());
            ps.setDate(16, c.getSignedDate() != null ? Date.valueOf(c.getSignedDate()) : null);
            ps.setString(17, c.getIdentityNumber());
            ps.setDate(18, c.getIdentityDate() != null ? Date.valueOf(c.getIdentityDate()) : null);
            ps.setString(19, c.getIdentityPlace());
            ps.setString(20, c.getContractFileUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ContractDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Contract c) {
        String sql = "UPDATE contracts SET contract_type=?, start_date=?, end_date=?, "
                   + "base_salary=?, status=?, notes=?, updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getContractType());
            ps.setDate(2, c.getStartDate() != null ? Date.valueOf(c.getStartDate()) : null);
            ps.setDate(3, c.getEndDate() != null ? Date.valueOf(c.getEndDate()) : null);
            ps.setBigDecimal(4, c.getBaseSalary());
            ps.setString(5, c.getStatus());
            ps.setString(6, c.getNotes());
            ps.setInt(7, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ContractDAO.update lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM contracts WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ContractDAO.delete lỗi: " + e.getMessage());
        }
        return false;
    }


    /** Tìm kiếm và lọc hợp đồng */
    public List<Contract> search(String keyword, String contractType, String status, Integer departmentId) {
        List<Contract> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(c.contract_code) LIKE ? OR LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
        }
        if (contractType != null && !contractType.trim().isEmpty()) {
            sql.append("AND c.contract_type = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            if ("EXPIRING_SOON".equalsIgnoreCase(status.trim())) {
                sql.append("AND c.status = 'ACTIVE' AND c.end_date IS NOT NULL AND c.end_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '30 days') ");
            } else {
                sql.append("AND c.status = ? ");
            }
        }
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        sql.append("ORDER BY c.start_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (contractType != null && !contractType.trim().isEmpty()) {
                ps.setString(idx++, contractType.trim());
            }
            if (status != null && !status.trim().isEmpty() && !"EXPIRING_SOON".equalsIgnoreCase(status.trim())) {
                ps.setString(idx++, status.trim());
            }
            if (departmentId != null && departmentId > 0) {
                ps.setInt(idx++, departmentId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("ContractDAO.search lỗi: " + e.getMessage());
        }
        return list;
    }

    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM contracts";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("ContractDAO.countTotal lỗi: " + e.getMessage());
        }
        return 0;
    }

    public int countActive() {
        String sql = "SELECT COUNT(*) FROM contracts WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("ContractDAO.countActive lỗi: " + e.getMessage());
        }
        return 0;
    }

    public int countByType(String contractType) {
        String sql = "SELECT COUNT(*) FROM contracts WHERE contract_type = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contractType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("ContractDAO.countByType lỗi: " + e.getMessage());
        }
        return 0;
    }

    public int countExpiringSoon(int daysAhead) {
        String sql = "SELECT COUNT(*) FROM contracts WHERE status = 'ACTIVE' "
                   + "AND end_date IS NOT NULL "
                   + "AND end_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '" + daysAhead + " days')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("ContractDAO.countExpiringSoon lỗi: " + e.getMessage());
        }
        return 0;
    }

    private Contract mapRow(ResultSet rs) throws SQLException {
        Contract c = new Contract();
        c.setId(rs.getInt("id"));
        c.setContractCode(rs.getString("contract_code"));
        c.setEmployeeId(rs.getInt("employee_id"));
        c.setEmployeeCode(rs.getString("employee_code"));
        c.setEmployeeName(rs.getString("full_name"));
        c.setDepartmentName(rs.getString("department_name"));
        c.setContractType(rs.getString("contract_type"));
        Date sd = rs.getDate("start_date");
        if (sd != null) c.setStartDate(sd.toLocalDate());
        Date ed = rs.getDate("end_date");
        if (ed != null) c.setEndDate(ed.toLocalDate());
        c.setBaseSalary(rs.getBigDecimal("base_salary"));
        c.setStatus(rs.getString("status"));
        c.setNotes(rs.getString("notes"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) c.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) c.setUpdatedAt(ua.toLocalDateTime());

        try { c.setSignerName(rs.getString("signer_name")); } catch (SQLException ignored) {}
        try { c.setSignerTitle(rs.getString("signer_title")); } catch (SQLException ignored) {}
        try { c.setWorkLocation(rs.getString("work_location")); } catch (SQLException ignored) {}
        try { c.setJobDescription(rs.getString("job_description")); } catch (SQLException ignored) {}
        try {
            int pm = rs.getInt("probation_months");
            if (!rs.wasNull()) c.setProbationMonths(pm);
        } catch (SQLException ignored) {}
        try { c.setProbationSalaryPct(rs.getBigDecimal("probation_salary_pct")); } catch (SQLException ignored) {}
        try { c.setAllowanceAmount(rs.getBigDecimal("allowance_amount")); } catch (SQLException ignored) {}
        try {
            Date sDate = rs.getDate("signed_date");
            if (sDate != null) c.setSignedDate(sDate.toLocalDate());
        } catch (SQLException ignored) {}
        try { c.setIdentityNumber(rs.getString("identity_number")); } catch (SQLException ignored) {}
        try {
            Date idDate = rs.getDate("identity_date");
            if (idDate != null) c.setIdentityDate(idDate.toLocalDate());
        } catch (SQLException ignored) {}
        try { c.setIdentityPlace(rs.getString("identity_place")); } catch (SQLException ignored) {}
        try { c.setContractFileUrl(rs.getString("contract_file_url")); } catch (SQLException ignored) {}
        return c;
    }
}
