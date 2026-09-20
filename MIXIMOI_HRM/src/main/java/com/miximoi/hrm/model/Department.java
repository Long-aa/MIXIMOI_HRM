package com.miximoi.hrm.model;

/**
 * Model Department — Phòng ban.
 */
public class Department {

    private int id;
    private String name;
    private String code;
    private String description;
    private Integer managerId;
    private String managerName;
    private String status = "ACTIVE";
    private java.util.Date createdAt;
    private int employeeCount; // Dùng cho thống kê

    public Department() {}

    public Department(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getManagerId() { return managerId; }
    public void setManagerId(Integer managerId) { this.managerId = managerId; }

    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public java.util.Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.util.Date createdAt) { this.createdAt = createdAt; }

    public int getEmployeeCount() { return employeeCount; }
    public void setEmployeeCount(int employeeCount) { this.employeeCount = employeeCount; }

    @Override
    public String toString() {
        return "Department{id=" + id + ", name='" + name + "', code='" + code + "'}";
    }
}
