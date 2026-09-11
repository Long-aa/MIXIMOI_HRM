package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model Overtime — Tăng ca.
 */
public class Overtime {

    private int id;
    private int employeeId;
    private String employeeCode;  // Dùng cho hiển thị
    private String employeeName;  // Dùng cho hiển thị
    private LocalDate overtimeDate;
    private double hours;
    private double coefficient;   // Hệ số: 1.5 | 2.0 | 3.0
    private BigDecimal amount;    // Tiền tăng ca = giờ * hệ số * lương/giờ
    private String reason;
    private String status;        // PENDING | APPROVED | REJECTED
    private int approvedById;
    private String approvedByName;
    private LocalDateTime approvedAt;
    private LocalDateTime createdAt;

    public Overtime() {}

    // ===== Getters & Setters =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public LocalDate getOvertimeDate() { return overtimeDate; }
    public void setOvertimeDate(LocalDate overtimeDate) { this.overtimeDate = overtimeDate; }

    public double getHours() { return hours; }
    public void setHours(double hours) { this.hours = hours; }

    public double getCoefficient() { return coefficient; }
    public void setCoefficient(double coefficient) { this.coefficient = coefficient; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getApprovedById() { return approvedById; }
    public void setApprovedById(int approvedById) { this.approvedById = approvedById; }

    public String getApprovedByName() { return approvedByName; }
    public void setApprovedByName(String approvedByName) { this.approvedByName = approvedByName; }

    public LocalDateTime getApprovedAt() { return approvedAt; }
    public void setApprovedAt(LocalDateTime approvedAt) { this.approvedAt = approvedAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Overtime{id=" + id + ", employeeId=" + employeeId
                + ", date=" + overtimeDate + ", hours=" + hours + "}";
    }
}
