package com.miximoi.hrm.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

/**
 * Model Attendance — Bảng chấm công hàng ngày.
 */
public class Attendance {

    private int id;
    private int employeeId;
    private String employeeCode;  // Dùng cho hiển thị
    private String employeeName;  // Dùng cho hiển thị
    private LocalDate workDate;
    private LocalTime checkIn;
    private LocalTime checkOut;
    private double totalHours;
    private String status;        // ON_TIME | LATE | EARLY_LEAVE | ABSENT | OVERTIME
    private String notes;
    private LocalDateTime createdAt;

    public Attendance() {}

    // ===== Getters & Setters =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public LocalDate getWorkDate() { return workDate; }
    public void setWorkDate(LocalDate workDate) { this.workDate = workDate; }

    public LocalTime getCheckIn() { return checkIn; }
    public void setCheckIn(LocalTime checkIn) { this.checkIn = checkIn; }

    public LocalTime getCheckOut() { return checkOut; }
    public void setCheckOut(LocalTime checkOut) { this.checkOut = checkOut; }

    public double getTotalHours() { return totalHours; }
    public void setTotalHours(double totalHours) { this.totalHours = totalHours; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Attendance{id=" + id + ", employeeId=" + employeeId
                + ", date=" + workDate + ", status='" + status + "'}";
    }
}
