package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Bonus {
    private int id;
    private int employeeId;
    private String employeeCode;
    private String employeeName;
    private String departmentName;
    private String name;
    private BigDecimal amount;
    private LocalDate bonusDate;
    private int payMonth;
    private int payYear;
    private String notes;
    private LocalDateTime createdAt;

    public Bonus() {
        this.amount = BigDecimal.ZERO;
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

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public LocalDate getBonusDate() { return bonusDate; }
    public void setBonusDate(LocalDate bonusDate) { this.bonusDate = bonusDate; }

    public int getPayMonth() { return payMonth; }
    public void setPayMonth(int payMonth) { this.payMonth = payMonth; }

    public int getPayYear() { return payYear; }
    public void setPayYear(int payYear) { this.payYear = payYear; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
