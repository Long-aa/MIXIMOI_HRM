package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.SalaryConfig;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalaryConfigDAO {

    public List<SalaryConfig> getAllConfigs() {
        List<SalaryConfig> list = new ArrayList<>();
        String sql = "SELECT id, config_key, config_value, description, updated_at "
                   + "FROM salary_configs ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                SalaryConfig sc = new SalaryConfig();
                sc.setId(rs.getInt("id"));
                sc.setConfigKey(rs.getString("config_key"));
                sc.setConfigValue(rs.getString("config_value"));
                sc.setDescription(rs.getString("description"));
                Timestamp ut = rs.getTimestamp("updated_at");
                if (ut != null) sc.setUpdatedAt(ut.toLocalDateTime());
                list.add(sc);
            }
        } catch (SQLException e) {
            System.err.println("SalaryConfigDAO.getAllConfigs error: " + e.getMessage());
        }
        return list;
    }

    public String getByKey(String key, String defaultValue) {
        String alias = getAlias(key);
        String sql = "SELECT config_value FROM salary_configs WHERE LOWER(config_key) = LOWER(?) "
                   + (alias != null ? "OR LOWER(config_key) = LOWER(?) " : "")
                   + "LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            if (alias != null) {
                ps.setString(2, alias);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("config_value");
            }
        } catch (SQLException e) {
            System.err.println("SalaryConfigDAO.getByKey error: " + e.getMessage());
        }
        return defaultValue;
    }

    private String getAlias(String key) {
        if (key == null) return null;
        switch (key.toLowerCase()) {
            case "base_salary": return "BASE_SALARY_LEVEL";
            case "base_salary_level": return "base_salary";
            case "personal_reduction": return "PERSONAL_DEDUCTION";
            case "personal_deduction": return "personal_reduction";
            case "dependent_reduction": return "DEPENDENT_DEDUCTION";
            case "dependent_deduction": return "dependent_reduction";
            case "bhxh_rate": return "BHXH_RATE";
            case "bhyt_rate": return "BHYT_RATE";
            case "bhtn_rate": return "BHTN_RATE";
            case "insurance_ceiling": return "MAX_INSURANCE_SALARY";
            case "max_insurance_salary": return "insurance_ceiling";
            case "standard_working_days": return "STANDARD_WORKING_DAYS";
            default: return null;
        }
    }

    public BigDecimal getBigDecimalByKey(String key, BigDecimal defaultValue) {
        String val = getByKey(key, null);
        if (val != null) {
            try {
                return new BigDecimal(val.trim());
            } catch (Exception ignored) {}
        }
        return defaultValue;
    }

    public double getDoubleByKey(String key, double defaultValue) {
        String val = getByKey(key, null);
        if (val != null) {
            try {
                return Double.parseDouble(val.trim());
            } catch (Exception ignored) {}
        }
        return defaultValue;
    }

    public boolean updateConfig(String key, String value) {
        return updateConfig(key, value, null);
    }

    public boolean updateConfig(String key, String value, String description) {
        String sql = "INSERT INTO salary_configs (config_key, config_value, description, updated_at) "
                   + "VALUES (?, ?, ?, CURRENT_TIMESTAMP) "
                   + "ON CONFLICT (config_key) DO UPDATE "
                   + "SET config_value = EXCLUDED.config_value, "
                   + "description = COALESCE(EXCLUDED.description, salary_configs.description), "
                   + "updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            ps.setString(3, description);
            int rows = ps.executeUpdate();

            // Nếu có alias tương ứng thì cập nhật đồng bộ cả alias để tránh chênh lệch
            String alias = getAlias(key);
            if (alias != null) {
                try (PreparedStatement psAlias = conn.prepareStatement(sql)) {
                    psAlias.setString(1, alias);
                    psAlias.setString(2, value);
                    psAlias.setString(3, description);
                    psAlias.executeUpdate();
                } catch (Exception ignored) {}
            }
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("SalaryConfigDAO.updateConfig error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteConfig(String key) {
        String alias = getAlias(key);
        String sql = "DELETE FROM salary_configs WHERE LOWER(config_key) = LOWER(?)"
                   + (alias != null ? " OR LOWER(config_key) = LOWER(?)" : "");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            if (alias != null) ps.setString(2, alias);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SalaryConfigDAO.deleteConfig error: " + e.getMessage());
        }
        return false;
    }
}
