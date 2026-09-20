package com.miximoi.hrm.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model LeaveRequest — Đơn xin nghỉ phép & Quản lý nghỉ lễ.
 */
public class LeaveRequest {

    private int id;
    private String leaveCode;         // vd: LP-2026-015
    private int employeeId;
    private String employeeCode;       // Dùng cho hiển thị (vd: NV001)
    private String employeeName;       // Họ tên (vd: Trần Ngọc Ánh)
    private String positionName;       // Chức danh (vd: Product Designer)
    private int departmentId;
    private String departmentName;     // Phòng ban (vd: Khối R&D)
    private String avatar;

    private String leaveType;          // ANNUAL | SICK | PERSONAL | WEDDING | MATERNITY | UNPAID
    private LocalDate startDate;
    private LocalDate endDate;
    private double days;               // Số ngày nghỉ (vd: 2.5, 2.0, 5.0, 3.0)
    private int totalDays;             // Giữ tương thích với DB integer
    private String timeNote;           // Ghi chú thời gian (vd: "Bắt đầu lúc 08:30", "Kèm giấy ra viện")

    private String reason;             // Lý do nghỉ
    private String handoverPerson;     // Bàn giao công việc (Tên & SĐT/email)

    // Quy trình phê duyệt (TP -> HR)
    private String managerStatus;      // PENDING | APPROVED | REJECTED
    private String hrStatus;           // PENDING | APPROVED | REJECTED

    private String status;             // PENDING | APPROVED | REJECTED | CANCELLED
    private int approvedById;
    private String approvedByName;
    private LocalDateTime approvedAt;
    private String rejectReason;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LeaveRequest() {
        this.status = "PENDING";
        this.managerStatus = "PENDING";
        this.hrStatus = "PENDING";
        this.days = 1.0;
        this.totalDays = 1;
    }

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

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getLeaveType() { return leaveType; }
    public void setLeaveType(String leaveType) { this.leaveType = leaveType; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public double getDays() { return days > 0 ? days : totalDays; }
    public void setDays(double days) {
        this.days = days;
        this.totalDays = (int) Math.round(days);
    }

    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) {
        this.totalDays = totalDays;
        if (this.days <= 0) this.days = totalDays;
    }

    public String getTimeNote() { return timeNote; }
    public void setTimeNote(String timeNote) { this.timeNote = timeNote; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getHandoverPerson() { return handoverPerson; }
    public void setHandoverPerson(String handoverPerson) { this.handoverPerson = handoverPerson; }

    public String getManagerStatus() { return managerStatus; }
    public void setManagerStatus(String managerStatus) { this.managerStatus = managerStatus; }

    public String getHrStatus() { return hrStatus; }
    public void setHrStatus(String hrStatus) { this.hrStatus = hrStatus; }

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

    // ===== Helper Methods for UI Badges =====

    public String getLeaveTypeDisplay() {
        if (leaveType == null) return "Phép năm thường niên";
        switch (leaveType.toUpperCase()) {
            case "ANNUAL": return "Phép năm thường niên";
            case "SICK": return "Nghỉ ốm đau / BHYT";
            case "UNPAID": return "Nghỉ không hưởng lương";
            case "WEDDING":
            case "PERSONAL": return "Nghỉ cưới hỏi (Có lương)";
            case "MATERNITY": return "Chế độ Thai sản";
            default: return leaveType;
        }
    }

    public String getLeaveTypeBadgeClass() {
        if (leaveType == null) return "badge-leave-annual";
        switch (leaveType.toUpperCase()) {
            case "ANNUAL": return "badge-leave-annual";      // blue
            case "SICK": return "badge-leave-sick";          // purple
            case "UNPAID": return "badge-leave-unpaid";      // gray
            case "WEDDING":
            case "PERSONAL": return "badge-leave-wedding";   // cyan
            case "MATERNITY": return "badge-leave-maternity";// teal
            default: return "badge-leave-default";
        }
    }

    public String getStatusBadgeClass() {
        if ("APPROVED".equalsIgnoreCase(status)) return "status-pill approved";
        if ("REJECTED".equalsIgnoreCase(status)) return "status-pill rejected";
        return "status-pill pending";
    }

    public String getStatusDisplay() {
        if ("APPROVED".equalsIgnoreCase(status)) return "Đã duyệt";
        if ("REJECTED".equalsIgnoreCase(status)) return "Từ chối";
        return "Chờ duyệt";
    }

    @Override
    public String toString() {
        return "LeaveRequest{id=" + id + ", code='" + leaveCode
                + "', employee=" + employeeId + ", status='" + status + "'}";
    }
}
