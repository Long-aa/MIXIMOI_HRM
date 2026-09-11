package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Model Payroll — Bảng lương theo kỳ.
 */
public class Payroll {

    private int id;
    private int employeeId;
    private String employeeCode;      // Dùng cho hiển thị
    private String employeeName;      // Dùng cho hiển thị
    private String departmentName;    // Dùng cho hiển thị
    private int payMonth;             // Tháng kỳ lương (1-12)
    private int payYear;              // Năm kỳ lương
    private BigDecimal baseSalary;    // Lương cơ bản
    private double workingDays;       // Số ngày công thực tế
    private double standardDays;      // Số ngày công chuẩn trong tháng
    private BigDecimal overtimeAmount;// Tiền tăng ca
    private BigDecimal allowance;     // Tổng phụ cấp
    private BigDecimal bonus;         // Tổng thưởng
    private BigDecimal deduction;     // Tổng khấu trừ (BHXH, thuế,...)
    private BigDecimal netSalary;     // Lương thực nhận
    private String status;            // DRAFT | PENDING | APPROVED | PAYING | PAID
    private int createdById;
    private int approvedById;
    private String approvedByName;
    private LocalDateTime approvedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Payroll() {}

    // ===== Getters & Setters =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public int getPayMonth() { return payMonth; }
    public void setPayMonth(int payMonth) { this.payMonth = payMonth; }

    public int getPayYear() { return payYear; }
    public void setPayYear(int payYear) { this.payYear = payYear; }

    public BigDecimal getBaseSalary() { return baseSalary; }
    public void setBaseSalary(BigDecimal baseSalary) { this.baseSalary = baseSalary; }

    public double getWorkingDays() { return workingDays; }
    public void setWorkingDays(double workingDays) { this.workingDays = workingDays; }

    public double getStandardDays() { return standardDays; }
    public void setStandardDays(double standardDays) { this.standardDays = standardDays; }

    public BigDecimal getOvertimeAmount() { return overtimeAmount; }
    public void setOvertimeAmount(BigDecimal overtimeAmount) { this.overtimeAmount = overtimeAmount; }

    public BigDecimal getAllowance() { return allowance; }
    public void setAllowance(BigDecimal allowance) { this.allowance = allowance; }

    public BigDecimal getBonus() { return bonus; }
    public void setBonus(BigDecimal bonus) { this.bonus = bonus; }

    public BigDecimal getDeduction() { return deduction; }
    public void setDeduction(BigDecimal deduction) { this.deduction = deduction; }

    public BigDecimal getNetSalary() { return netSalary; }
    public void setNetSalary(BigDecimal netSalary) { this.netSalary = netSalary; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getCreatedById() { return createdById; }
    public void setCreatedById(int createdById) { this.createdById = createdById; }

    public int getApprovedById() { return approvedById; }
    public void setApprovedById(int approvedById) { this.approvedById = approvedById; }

    public String getApprovedByName() { return approvedByName; }
    public void setApprovedByName(String approvedByName) { this.approvedByName = approvedByName; }

    public LocalDateTime getApprovedAt() { return approvedAt; }
    public void setApprovedAt(LocalDateTime approvedAt) { this.approvedAt = approvedAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Payroll{id=" + id + ", employee=" + employeeId
                + ", period=" + payMonth + "/" + payYear
                + ", net=" + netSalary + ", status='" + status + "'}";
    }
}
