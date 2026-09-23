package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class SalaryDeduction {
    private int id;
    private int employeeId;
    private String employeeCode;
    private String employeeName;
    private String departmentName;
    private String deductionType; // ADVANCE, UNION_FEE, DISCIPLINE, OTHER
    private BigDecimal amount;
    private int payMonth;
    private int payYear;
    private String description;
    private LocalDateTime createdAt;

    public SalaryDeduction() {
        this.amount = BigDecimal.ZERO;
        this.deductionType = "ADVANCE";
    }

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

    public String getDeductionType() { return deductionType; }
    public void setDeductionType(String deductionType) { this.deductionType = deductionType; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public int getPayMonth() { return payMonth; }
    public void setPayMonth(int payMonth) { this.payMonth = payMonth; }

    public int getPayYear() { return payYear; }
    public void setPayYear(int payYear) { this.payYear = payYear; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
