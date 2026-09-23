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
        String sql = "SELECT config_value FROM salary_configs WHERE config_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("config_value");
            }
        } catch (SQLException e) {
            System.err.println("SalaryConfigDAO.getByKey error: " + e.getMessage());
        }
        return defaultValue;
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
        String sql = "INSERT INTO salary_configs (config_key, config_value, updated_at) "
                   + "VALUES (?, ?, CURRENT_TIMESTAMP) "
                   + "ON CONFLICT (config_key) DO UPDATE "
                   + "SET config_value = EXCLUDED.config_value, updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SalaryConfigDAO.updateConfig error: " + e.getMessage());
        }
        return false;
    }
}
