package com.miximoi.hrm.model;

import java.time.LocalDateTime;

/**
 * Model AuditLog — Lưu vết nhật ký kiểm toán cho các thao tác nhạy cảm
 * (Chốt công, Tính lương, Lập lệnh chi tiền, Duyệt đơn tăng ca/nghỉ phép).
 */
public class AuditLog {

    private int id;
    private Integer userId;
    private String username;
    private String userRole;
    private String action;
    private String module;
    private Integer recordId;
    private String details;
    private String ipAddress;
    private LocalDateTime createdAt;

    public AuditLog() {}

    public AuditLog(Integer userId, String username, String userRole, String action,
                    String module, Integer recordId, String details, String ipAddress) {
        this.userId = userId;
        this.username = username;
        this.userRole = userRole;
        this.action = action;
        this.module = module;
        this.recordId = recordId;
        this.details = details;
        this.ipAddress = ipAddress;
        this.createdAt = LocalDateTime.now();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getModule() { return module; }
    public void setModule(String module) { this.module = module; }

    public Integer getRecordId() { return recordId; }
    public void setRecordId(Integer recordId) { this.recordId = recordId; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
