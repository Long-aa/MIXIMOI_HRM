package com.miximoi.hrm.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model Employee — thông tin nhân viên.
 */
public class Employee {

    private int id;
    private String employeeCode;   // Mã nhân viên (NV001, NV002, ...)
    private String fullName;
    private LocalDate dateOfBirth;
    private String gender;         // MALE | FEMALE | OTHER
    private String phone;
    private String email;
    private String address;
    private int departmentId;
    private String departmentName; // Dùng cho hiển thị JOIN
    private int positionId;
    private String positionName;   // Dùng cho hiển thị JOIN
    private int employeeTypeId;
    private String employeeTypeName;
    private LocalDate startDate;
    private String status;         // ACTIVE | INACTIVE | ON_LEAVE
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Employee() {}

    // ===== Getters & Setters =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public int getPositionId() { return positionId; }
    public void setPositionId(int positionId) { this.positionId = positionId; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public int getEmployeeTypeId() { return employeeTypeId; }
    public void setEmployeeTypeId(int employeeTypeId) { this.employeeTypeId = employeeTypeId; }

    public String getEmployeeTypeName() { return employeeTypeName; }
    public void setEmployeeTypeName(String employeeTypeName) { this.employeeTypeName = employeeTypeName; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Employee{id=" + id + ", code='" + employeeCode + "', name='" + fullName + "'}";
    }
}
