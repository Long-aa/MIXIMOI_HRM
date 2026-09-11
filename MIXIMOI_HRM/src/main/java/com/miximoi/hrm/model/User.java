package com.miximoi.hrm.model;

import java.time.LocalDateTime;

/**
 * Model User — tài khoản đăng nhập hệ thống.
 */
public class User {

    private int id;
    private String username;
    private String password;       // Lưu dạng hash BCrypt
    private String role;           // ADMIN | HR | ACCOUNTANT | MANAGER | EMPLOYEE
    private int employeeId;        // Liên kết tới nhân viên (có thể null)
    private boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String fullName;
    private String email;

    public User() {}

    public User(int id, String username, String password, String role,
                int employeeId, boolean active) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.employeeId = employeeId;
        this.active = active;
    }

    // ===== Getters & Setters =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getFullName() {
        if (fullName != null && !fullName.trim().isEmpty()) {
            return fullName;
        }
        return username != null ? username : "Administrator";
    }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() {
        if (email != null && !email.trim().isEmpty()) {
            return email;
        }
        return (username != null ? username : "admin") + "@miximoi.vn";
    }
    public void setEmail(String email) { this.email = email; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', role='" + role + "'}";
    }
}
