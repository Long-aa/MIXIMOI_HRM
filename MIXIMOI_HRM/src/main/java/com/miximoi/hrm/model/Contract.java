package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model Contract — Hợp đồng lao động.
 */
public class Contract {

    private int id;
    private String contractCode;
    private int employeeId;
    private String employeeCode;    // Dùng cho hiển thị
    private String employeeName;    // Dùng cho hiển thị
    private String departmentName;  // Dùng cho hiển thị
    private String contractType;    // FIXED_TERM | INDEFINITE | SEASONAL | COLLABORATOR
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal baseSalary;
    private String status;          // ACTIVE | EXPIRING_SOON | EXPIRED | TERMINATED
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Legal contract fields (Labor Code 2019)
    private String signerName;
    private String signerTitle;
    private String workLocation;
    private String jobDescription;
    private Integer probationMonths;
    private BigDecimal probationSalaryPct;
    private BigDecimal allowanceAmount;
    private LocalDate signedDate;
    private String identityNumber;
    private LocalDate identityDate;
    private String identityPlace;
    private String contractFileUrl;

    public Contract() {}

    public Long getDaysRemaining() {
        if (endDate == null) return null;
        return java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), endDate);
    }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    // ===== Getters & Setters =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getContractCode() { return contractCode; }
    public void setContractCode(String contractCode) { this.contractCode = contractCode; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getContractType() { return contractType; }
    public void setContractType(String contractType) { this.contractType = contractType; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public BigDecimal getBaseSalary() { return baseSalary; }
    public void setBaseSalary(BigDecimal baseSalary) { this.baseSalary = baseSalary; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getSignerName() { return signerName; }
    public void setSignerName(String signerName) { this.signerName = signerName; }

    public String getSignerTitle() { return signerTitle; }
    public void setSignerTitle(String signerTitle) { this.signerTitle = signerTitle; }

    public String getWorkLocation() { return workLocation; }
    public void setWorkLocation(String workLocation) { this.workLocation = workLocation; }

    public String getJobDescription() { return jobDescription; }
    public void setJobDescription(String jobDescription) { this.jobDescription = jobDescription; }

    public Integer getProbationMonths() { return probationMonths; }
    public void setProbationMonths(Integer probationMonths) { this.probationMonths = probationMonths; }

    public BigDecimal getProbationSalaryPct() { return probationSalaryPct; }
    public void setProbationSalaryPct(BigDecimal probationSalaryPct) { this.probationSalaryPct = probationSalaryPct; }

    public BigDecimal getAllowanceAmount() { return allowanceAmount; }
    public void setAllowanceAmount(BigDecimal allowanceAmount) { this.allowanceAmount = allowanceAmount; }

    public LocalDate getSignedDate() { return signedDate; }
    public void setSignedDate(LocalDate signedDate) { this.signedDate = signedDate; }

    public String getIdentityNumber() { return identityNumber; }
    public void setIdentityNumber(String identityNumber) { this.identityNumber = identityNumber; }

    public LocalDate getIdentityDate() { return identityDate; }
    public void setIdentityDate(LocalDate identityDate) { this.identityDate = identityDate; }

    public String getIdentityPlace() { return identityPlace; }
    public void setIdentityPlace(String identityPlace) { this.identityPlace = identityPlace; }

    public String getContractFileUrl() { return contractFileUrl; }
    public void setContractFileUrl(String contractFileUrl) { this.contractFileUrl = contractFileUrl; }

    @Override
    public String toString() {
        return "Contract{id=" + id + ", code='" + contractCode + "', employee=" + employeeId + "}";
    }
}
