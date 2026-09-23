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
    private String employeeCode;
    private String positionName;
    private String departmentName;

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

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getRoleDisplayName() {
        if (role == null) return "Người dùng";
        switch (role.toUpperCase()) {
            case "ADMIN": return "Administrator";
            case "HR": return "HR Specialist";
            case "ACCOUNTANT": return "Kế toán viên";
            case "MANAGER": return "Quản lý / Trưởng phòng";
            case "EMPLOYEE": return "Nhân viên";
            default: return role;
        }
    }

    // Role checks
    public boolean isAdmin() {
        return role != null && "ADMIN".equalsIgnoreCase(role);
    }

    public boolean isHr() {
        return role != null && "HR".equalsIgnoreCase(role);
    }

    public boolean isAccountant() {
        return role != null && "ACCOUNTANT".equalsIgnoreCase(role);
    }

    public boolean isManager() {
        return role != null && "MANAGER".equalsIgnoreCase(role);
    }

    public boolean isEmployee() {
        return role != null && "EMPLOYEE".equalsIgnoreCase(role);
    }

    public boolean hasAnyRole(String... roles) {
        if (this.role == null) return false;
        for (String r : roles) {
            if (this.role.equalsIgnoreCase(r)) return true;
        }
        return false;
    }

    // Chức năng được phép truy cập theo role
    public boolean canAccessOrganization() {
        return isAdmin() || isHr() || isManager();
    }

    public boolean canAccessEmployees() {
        return isAdmin() || isHr() || isManager();
    }

    public boolean canManageEmployees() {
        return isAdmin() || isHr();
    }

    public boolean canAccessAttendanceManagement() {
        return isAdmin() || isHr() || isAccountant() || isManager();
    }

    public boolean canAccessPayroll() {
        return isAdmin() || isAccountant();
    }

    public boolean canAccessRecruitment() {
        return isAdmin() || isHr();
    }

    public boolean canAccessPerformance() {
        return isAdmin() || isManager();
    }

    public boolean canAccessReports() {
        return isAdmin() || isAccountant() || isManager();
    }

    public boolean canAccessSystem() {
        return isAdmin();
    }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', role='" + role + "'}";
    }
}
