package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model Employee — thông tin nhân viên đầy đủ.
 */
public class Employee {

    // ===== Thông tin cơ bản =====
    private int id;
    private String employeeCode;      // Mã nhân viên (NV001, NV002, ...)
    private String fullName;
    private LocalDate dateOfBirth;
    private String gender;            // MALE | FEMALE | OTHER
    private String phone;
    private String email;
    private String address;           // Địa chỉ thường trú
    private String tempAddress;       // Địa chỉ tạm trú
    private String nationality;       // Quốc tịch
    private String ethnicity;         // Dân tộc
    private String avatarUrl;         // URL ảnh đại diện

    // ===== CCCD / Giấy tờ tuỳ thân =====
    private String identityNumber;    // Số CCCD/CMND
    private LocalDate identityDate;   // Ngày cấp
    private String identityPlace;     // Nơi cấp

    // ===== Tổ chức =====
    private int departmentId;
    private String departmentName;    // Dùng cho hiển thị JOIN
    private int positionId;
    private String positionName;      // Dùng cho hiển thị JOIN
    private int employeeTypeId;
    private String employeeTypeName;
    private LocalDate startDate;
    private LocalDate endDate;        // Ngày thôi việc
    private String terminationReason; // Lý do thôi việc
    private String status;            // ACTIVE | INACTIVE | ON_LEAVE

    // ===== Lương & Tài chính =====
    private BigDecimal baseSalary;
    private String bankAccount;
    private String bankName;
    private String bankBranch;
    private String taxCode;
    private String insuranceNumber;

    // ===== Liên hệ khẩn cấp =====
    private String emergencyContactName;
    private String emergencyContactPhone;
    private String emergencyContactRelation;

    // ===== Hệ thống =====
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

    public String getTempAddress() { return tempAddress; }
    public void setTempAddress(String tempAddress) { this.tempAddress = tempAddress; }

    public String getNationality() { return nationality; }
    public void setNationality(String nationality) { this.nationality = nationality; }

    public String getEthnicity() { return ethnicity; }
    public void setEthnicity(String ethnicity) { this.ethnicity = ethnicity; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getIdentityNumber() { return identityNumber; }
    public void setIdentityNumber(String identityNumber) { this.identityNumber = identityNumber; }

    public LocalDate getIdentityDate() { return identityDate; }
    public void setIdentityDate(LocalDate identityDate) { this.identityDate = identityDate; }

    public String getIdentityPlace() { return identityPlace; }
    public void setIdentityPlace(String identityPlace) { this.identityPlace = identityPlace; }

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

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getTerminationReason() { return terminationReason; }
    public void setTerminationReason(String terminationReason) { this.terminationReason = terminationReason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getBaseSalary() { return baseSalary; }
    public void setBaseSalary(BigDecimal baseSalary) { this.baseSalary = baseSalary; }

    public String getBankAccount() { return bankAccount; }
    public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankBranch() { return bankBranch; }
    public void setBankBranch(String bankBranch) { this.bankBranch = bankBranch; }

    public String getTaxCode() { return taxCode; }
    public void setTaxCode(String taxCode) { this.taxCode = taxCode; }

    public String getInsuranceNumber() { return insuranceNumber; }
    public void setInsuranceNumber(String insuranceNumber) { this.insuranceNumber = insuranceNumber; }

    public String getEmergencyContactName() { return emergencyContactName; }
    public void setEmergencyContactName(String emergencyContactName) { this.emergencyContactName = emergencyContactName; }

    public String getEmergencyContactPhone() { return emergencyContactPhone; }
    public void setEmergencyContactPhone(String emergencyContactPhone) { this.emergencyContactPhone = emergencyContactPhone; }

    public String getEmergencyContactRelation() { return emergencyContactRelation; }
    public void setEmergencyContactRelation(String emergencyContactRelation) { this.emergencyContactRelation = emergencyContactRelation; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Employee{id=" + id + ", code='" + employeeCode + "', name='" + fullName + "'}";
    }
}
