package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model KpiMetric — Chỉ tiêu hiệu suất KPI.
 */
public class KpiMetric {
    private int id;
    private String kpiCode;
    private String title;
    private int employeeId;
    private String employeeName;
    private String employeeCode;
    private String positionName;
    private Integer departmentId;
    private String departmentName;
    private String quarter;
    private BigDecimal targetValue;
    private BigDecimal currentValue;
    private String unit;
    private BigDecimal weightPct;
    private LocalDate deadline;
    private String status; // IN_PROGRESS | APPROVED | OVERDUE | NEEDS_IMPROVEMENT
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public KpiMetric() {
        this.targetValue = new BigDecimal("100.0");
        this.currentValue = BigDecimal.ZERO;
        this.weightPct = new BigDecimal("20.0");
        this.status = "IN_PROGRESS";
        this.quarter = "Q3/2026";
        this.unit = "%";
    }

    public double getProgressPct() {
        if (targetValue == null || targetValue.compareTo(BigDecimal.ZERO) == 0) return 0.0;
        if (currentValue == null) return 0.0;
        return currentValue.doubleValue() / targetValue.doubleValue() * 100.0;
    }

    public String getStatusBadgeClass() {
        if ("APPROVED".equalsIgnoreCase(status)) return "bg-success-subtle text-success border border-success-subtle";
        if ("OVERDUE".equalsIgnoreCase(status)) return "bg-danger-subtle text-danger border border-danger-subtle";
        if ("NEEDS_IMPROVEMENT".equalsIgnoreCase(status)) return "bg-warning-subtle text-warning-emphasis border border-warning-subtle";
        return "bg-primary-subtle text-primary border border-primary-subtle";
    }

    public String getStatusDisplayName() {
        if ("APPROVED".equalsIgnoreCase(status)) return "Đã phê duyệt";
        if ("OVERDUE".equalsIgnoreCase(status)) return "Quá hạn";
        if ("NEEDS_IMPROVEMENT".equalsIgnoreCase(status)) return "Cần cải thiện";
        return "Đang tiến hành";
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getKpiCode() { return kpiCode; }
    public void setKpiCode(String kpiCode) { this.kpiCode = kpiCode; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public Integer getDepartmentId() { return departmentId; }
    public void setDepartmentId(Integer departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getQuarter() { return quarter; }
    public void setQuarter(String quarter) { this.quarter = quarter; }

    public BigDecimal getTargetValue() { return targetValue; }
    public void setTargetValue(BigDecimal targetValue) { this.targetValue = targetValue; }

    public BigDecimal getCurrentValue() { return currentValue; }
    public void setCurrentValue(BigDecimal currentValue) { this.currentValue = currentValue; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public BigDecimal getWeightPct() { return weightPct; }
    public void setWeightPct(BigDecimal weightPct) { this.weightPct = weightPct; }

    public LocalDate getDeadline() { return deadline; }
    public void setDeadline(LocalDate deadline) { this.deadline = deadline; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
