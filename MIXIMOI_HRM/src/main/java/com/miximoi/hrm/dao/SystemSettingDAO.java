package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.SystemSetting;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

/**
 * DAO xử lý thiết lập hệ thống (System Settings).
 */
public class SystemSettingDAO {

    /** Lấy tất cả cài đặt theo Map */
    public Map<String, String> getAllSettings() {
        Map<String, String> map = new HashMap<>();
        String sql = "SELECT setting_key, setting_value FROM system_settings";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            System.err.println("SystemSettingDAO.getAllSettings lỗi: " + e.getMessage());
        }
        return map;
    }

    /** Lưu hoặc cập nhật một giá trị cài đặt */
    public boolean saveSetting(String key, String value, String category, String description) {
        String sql = "INSERT INTO system_settings (setting_key, setting_value, category, description, updated_at) " +
                     "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                     "ON CONFLICT (setting_key) DO UPDATE SET " +
                     "setting_value = EXCLUDED.setting_value, updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            ps.setString(3, category != null ? category : "GENERAL");
            ps.setString(4, description);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SystemSettingDAO.saveSetting lỗi: " + e.getMessage());
            return false;
        }
    }

    /** Lưu hàng loạt cài đặt từ Map form */
    public boolean saveAll(Map<String, String> settings) {
        if (settings == null || settings.isEmpty()) return true;
        String sql = "INSERT INTO system_settings (setting_key, setting_value, category, updated_at) " +
                     "VALUES (?, ?, 'GENERAL', CURRENT_TIMESTAMP) " +
                     "ON CONFLICT (setting_key) DO UPDATE SET " +
                     "setting_value = EXCLUDED.setting_value, updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Map.Entry<String, String> entry : settings.entrySet()) {
                ps.setString(1, entry.getKey());
                ps.setString(2, entry.getValue());
                ps.addBatch();
            }
            ps.executeBatch();
            return true;
        } catch (SQLException e) {
            System.err.println("SystemSettingDAO.saveAll lỗi: " + e.getMessage());
            return false;
        }
    }
}
