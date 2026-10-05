package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Notification;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý truy vấn bảng notifications (thông báo cá nhân & thông báo toàn công ty).
 */
public class NotificationDAO {

    /**
     * Thêm một thông báo mới
     */
    public boolean insert(Notification n) {
        String sql = "INSERT INTO notifications (user_id, title, message, type, is_read, link_url, module, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (n.getUserId() != null) {
                ps.setInt(1, n.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, n.getTitle());
            ps.setString(3, n.getMessage());
            ps.setString(4, n.getType() != null ? n.getType() : "INFO");
            ps.setBoolean(5, n.isRead());
            ps.setString(6, n.getLinkUrl());
            ps.setString(7, n.getModule() != null ? n.getModule() : "GENERAL");
            ps.setTimestamp(8, Timestamp.valueOf(n.getCreatedAt() != null ? n.getCreatedAt() : java.time.LocalDateTime.now()));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) n.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.insert error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Phát thông báo chung toàn công ty (user_id = NULL)
     */
    public boolean broadcast(Notification n) {
        n.setUserId(null);
        return insert(n);
    }

    /**
     * Lấy thông báo khẩn cấp / cảnh báo chưa đọc mới nhất dành riêng cho nhân viên (hoặc thông báo chung toàn công ty).
     */
    public Notification getLatestActiveAlertForUser(Integer userId) {
        if (userId == null) return null;
        String sql = "SELECT * FROM notifications "
                   + "WHERE is_read = false "
                   + "AND (user_id = ? OR (user_id IS NULL AND module = 'BROADCAST')) "
                   + "AND type IN ('WARNING', 'DANGER', 'URGENT', 'ALERT') "
                   + "ORDER BY created_at DESC, id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.getLatestActiveAlertForUser error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy thông báo khẩn cấp / cảnh báo mới nhất của công ty để phát toast giữa màn hình khi nhân viên đăng nhập.
     */
    public Notification getLatestActiveAlert() {
        String sql = "SELECT * FROM notifications WHERE type IN ('WARNING', 'DANGER', 'URGENT', 'ALERT') ORDER BY created_at DESC, id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.getLatestActiveAlert error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy danh sách thông báo gần nhất cho người dùng (Bao gồm thông báo chung toàn công ty và thông báo riêng)
     */
    public List<Notification> findRecent(Integer userId, int limit) {
        List<Notification> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM notifications WHERE (user_id IS NULL ");
        if (userId != null && userId > 0) {
            sql.append("OR user_id = ? ");
        }
        sql.append(") ORDER BY created_at DESC, id DESC LIMIT ?");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (userId != null && userId > 0) {
                ps.setInt(paramIndex++, userId);
            }
            ps.setInt(paramIndex, limit > 0 ? limit : 10);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.findRecent error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy riêng danh sách thông báo tuyển dụng của công ty
     */
    public List<Notification> findRecentRecruitmentAnnouncements(int limit) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications "
                   + "WHERE module = 'RECRUITMENT' OR type = 'RECRUITMENT' OR LOWER(title) LIKE '%tuyển dụng%' "
                   + "ORDER BY created_at DESC, id DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit > 0 ? limit : 10);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.findRecentRecruitmentAnnouncements error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Đếm số lượng thông báo chưa đọc
     */
    public int countUnread(Integer userId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM notifications WHERE is_read = false AND (user_id IS NULL ");
        if (userId != null && userId > 0) {
            sql.append("OR user_id = ? ");
        }
        sql.append(")");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (userId != null && userId > 0) {
                ps.setInt(1, userId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.countUnread error: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Kiểm tra xem đã gửi thông báo nhắc nhở cho user hôm nay chưa (tránh spam trùng lặp).
     * @param userId   ID người dùng nhận thông báo
     * @param module   Module liên quan (ví dụ: "ATTENDANCE")
     */
    public boolean hasReminderSentToday(int userId, String module) {
        String sql = "SELECT COUNT(*) FROM notifications "
                   + "WHERE user_id = ? AND module = ? AND type = 'WARNING' "
                   + "AND DATE(created_at) = CURRENT_DATE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, module != null ? module : "GENERAL");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.hasReminderSentToday error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Đánh dấu thông báo đã đọc
     */
    public boolean markAsRead(int id) {
        String sql = "UPDATE notifications SET is_read = true WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("NotificationDAO.markAsRead error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Đánh dấu toàn bộ thông báo đã đọc của một người dùng
     */
    public boolean markAllAsRead(Integer userId) {
        if (userId == null || userId <= 0) return false;
        String sql = "UPDATE notifications SET is_read = true WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("NotificationDAO.markAllAsRead error: " + e.getMessage());
        }
        return false;
    }

    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id"));
        n.setUserId((Integer) rs.getObject("user_id"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setType(rs.getString("type"));
        n.setRead(rs.getBoolean("is_read"));
        n.setLinkUrl(rs.getString("link_url"));
        n.setModule(rs.getString("module"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) n.setCreatedAt(ts.toLocalDateTime());
        return n;
    }
}
