package com.miximoi.hrm.model;

import java.time.Duration;
import java.time.LocalDateTime;

/**
 * Model đại diện cho một thông báo hệ thống / thông báo toàn công ty.
 */
public class Notification {
    private int id;
    private Integer userId; // null = Thông báo toàn công ty (Broadcast)
    private String title;
    private String message;
    private String type = "INFO"; // INFO | WARNING | SUCCESS | DANGER | RECRUITMENT
    private boolean isRead = false;
    private String linkUrl;
    private String module = "GENERAL"; // RECRUITMENT | PAYROLL | LEAVE | GENERAL
    private LocalDateTime createdAt = LocalDateTime.now();

    public Notification() {}

    public Notification(Integer userId, String title, String message, String type, String linkUrl, String module) {
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.type = type != null ? type : "INFO";
        this.linkUrl = linkUrl;
        this.module = module != null ? module : "GENERAL";
        this.createdAt = LocalDateTime.now();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public String getLinkUrl() { return linkUrl; }
    public void setLinkUrl(String linkUrl) { this.linkUrl = linkUrl; }

    public String getModule() { return module; }
    public void setModule(String module) { this.module = module; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    /**
     * Tính khoảng thời gian tương đối (VD: 5 phút trước, 2 giờ trước, 1 ngày trước)
     */
    public String getTimeAgo() {
        if (createdAt == null) return "Vừa xong";
        Duration d = Duration.between(createdAt, LocalDateTime.now());
        long seconds = d.getSeconds();
        if (seconds < 60) return "Vừa xong";
        long minutes = seconds / 60;
        if (minutes < 60) return minutes + " phút trước";
        long hours = minutes / 60;
        if (hours < 24) return hours + " giờ trước";
        long days = hours / 24;
        if (days < 30) return days + " ngày trước";
        long months = days / 30;
        return months + " tháng trước";
    }

    public boolean isRecruitment() {
        return "RECRUITMENT".equalsIgnoreCase(module) || "RECRUITMENT".equalsIgnoreCase(type)
                || (title != null && (title.toLowerCase().contains("tuyển dụng") || title.toLowerCase().contains("vị trí")));
    }
}
