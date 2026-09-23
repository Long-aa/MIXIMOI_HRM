package com.miximoi.hrm.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model PerformanceCycle — Chu kỳ đánh giá hiệu suất (Ngày, Tháng, Quý, Năm).
 */
public class PerformanceCycle {
    private int id;
    private String cycleCode;
    private String name;
    private String cycleType; // DAILY | MONTHLY | QUARTERLY | YEARLY
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;    // OPEN | CLOSED | DRAFT
    private LocalDateTime createdAt;

    public PerformanceCycle() {}

    public PerformanceCycle(String cycleCode, String name, String cycleType, LocalDate startDate, LocalDate endDate, String status) {
        this.cycleCode = cycleCode;
        this.name = name;
        this.cycleType = cycleType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCycleCode() { return cycleCode; }
    public void setCycleCode(String cycleCode) { this.cycleCode = cycleCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCycleType() { return cycleType; }
    public void setCycleType(String cycleType) { this.cycleType = cycleType; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
