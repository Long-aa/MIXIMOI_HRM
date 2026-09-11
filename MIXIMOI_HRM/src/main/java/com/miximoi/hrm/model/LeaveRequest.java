package com.miximoi.hrm.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model LeaveRequest — Đơn xin nghỉ phép.
 */
public class LeaveRequest {

    private int id;
    private String leaveCode;
    private int employeeId;
    private String employeeCode;  // Dùng cho hiển thị
    private String employeeName;  // Dùng cho hiển thị
    private String leaveType;     // ANNUAL | SICK | PERSONAL | MATERNITY | UNPAID
    private LocalDate startDate;
    private LocalDate endDate;
    private int totalDays;
    private String reason;
    private String status;        // PENDING | APPROVED | REJECTED | CANCELLED
    private int approvedById;
    private String approvedByName;
    private LocalDateTime approvedAt;
    private String rejectReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LeaveRequest() {}

    // ===== Getters & Setters =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getLeaveCode() { return leaveCode; }
    public void setLeaveCode(String leaveCode) { this.leaveCode = leaveCode; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getLeaveType() { return leaveType; }
    public void setLeaveType(String leaveType) { this.leaveType = leaveType; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }

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

    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "LeaveRequest{id=" + id + ", code='" + leaveCode
                + "', employee=" + employeeId + ", status='" + status + "'}";
    }
}
