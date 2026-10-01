package com.miximoi.hrm.model;

import java.time.LocalDateTime;

/**
 * Model giải trình chấm công (Attendance Explain Request).
 */
public class AttendanceExplainRequest {
    private int id;
    private int attendanceId;
    private int employeeId;
    private String employeeCode;
    private String employeeName;
    private String reason;
    private String status = "PENDING"; // PENDING | APPROVED | REJECTED
    private Integer reviewedBy;
    private String reviewerName;
    private LocalDateTime reviewedAt;
    private LocalDateTime createdAt;

    public AttendanceExplainRequest() {}

    public AttendanceExplainRequest(int attendanceId, int employeeId, String reason) {
        this.attendanceId = attendanceId;
        this.employeeId = employeeId;
        this.reason = reason;
        this.status = "PENDING";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAttendanceId() { return attendanceId; }
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public LocalDateTime getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isPending() {
        return "PENDING".equalsIgnoreCase(status);
    }
}
