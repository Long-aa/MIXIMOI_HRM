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
    private String departmentName;// Dùng cho hiển thị
    private String positionName;  // Dùng cho hiển thị
    private LocalDate workDate;
    private LocalTime checkIn;
    private LocalTime checkOut;
    private double totalHours;
    private String status;        // ON_TIME | LATE | EARLY_LEAVE | ABSENT | OVERTIME | WFH | COMPLETE
    private String notes;
    private String method = "FaceID";
    private LocalDateTime createdAt;

    public Attendance() {}

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }

    public String getShiftTime() { return "08:30 - 17:30"; }
    public String getShiftName() { return "Ca Hành chính"; }

    public int getMinutesLate() {
        if (checkIn == null) return 0;
        LocalTime standardIn = LocalTime.of(8, 30);
        if (checkIn.isAfter(standardIn)) {
            return (int) java.time.Duration.between(standardIn, checkIn).toMinutes();
        }
        return 0;
    }

    public int getMinutesEarly() {
        if (checkOut == null) return 0;
        LocalTime standardOut = LocalTime.of(17, 30);
        if (checkOut.isBefore(standardOut)) {
            return (int) java.time.Duration.between(checkOut, standardOut).toMinutes();
        }
        return 0;
    }

    public String getDeviation() {
        if ("LATE".equalsIgnoreCase(status)) return "+" + getMinutesLate() + "m";
        if ("EARLY_LEAVE".equalsIgnoreCase(status)) return "-" + getMinutesEarly() + "m";
        return "Chuẩn";
    }

    public boolean isCanExplain() {
        return "LATE".equalsIgnoreCase(status) || "EARLY_LEAVE".equalsIgnoreCase(status) || "ABSENT".equalsIgnoreCase(status);
    }

    public boolean isHasExplain() {
        return notes != null && !notes.trim().isEmpty();
    }

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
