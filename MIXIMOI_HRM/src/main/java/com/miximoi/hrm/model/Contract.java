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
    private String contractType;    // FIXED_TERM | INDEFINITE | SEASONAL | COLLABORATOR
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal baseSalary;
    private String status;          // ACTIVE | EXPIRING_SOON | EXPIRED | TERMINATED
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Contract() {}

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

    @Override
    public String toString() {
        return "Contract{id=" + id + ", code='" + contractCode + "', employee=" + employeeId + "}";
    }
}
