package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

/**
 * Model Overtime — Tăng ca & Làm thêm giờ.
 */
public class Overtime {

    private int id;
    private int employeeId;
    private String employeeCode;       // Dùng cho hiển thị (vd: NV001)
    private String employeeName;       // Họ và tên nhân sự
    private String positionName;       // Chức danh (vd: Kỹ sư Frontend, Backend Team)
    private int departmentId;
    private String departmentName;     // Phòng ban (vd: CNTT & Sản phẩm)
    private String avatar;

    private String projectName;        // Tên dự án liên quan (vd: Release v4.2 - Core Banking)
    private LocalDate overtimeDate;
    private LocalTime startTime;       // Từ giờ (vd: 18:00)
    private LocalTime endTime;         // Đến giờ (vd: 21:30)
    private double hours;              // Số giờ làm thêm (vd: 3.5)
    private double coefficient;        // Hệ số: 1.5 | 2.0 | 3.0
    private String otType;             // REGULAR (1.5x) | WEEKEND (2.0x) | HOLIDAY (3.0x)
    private BigDecimal amount;         // Tiền tăng ca = giờ * hệ số * lương/giờ
    private String reason;             // Lý do & Đầu việc cụ thể / Jira Task ID

    // Trạng thái tổng thể:
    // PENDING_LEAD | PENDING_HR | APPROVED | REJECTED | PAID | LOCKED
    private String status;

    // Duyệt Cấp 1 (Quản lý trực tiếp / Lead)
    private int leadApproverId;
    private String leadApproverName;   // vd: Trần Tuấn Hưng (CTO)
    private String leadStatus;         // PENDING | APPROVED | REJECTED
    private LocalDateTime leadApprovedAt;

    // Duyệt Cấp 2 (HR Lead duyệt)
    private int approvedById;          // HR Approver ID
    private String approvedByName;     // vd: Nguyễn Văn Admin / HR Lead
    private String hrStatus;           // PENDING | APPROVED | REJECTED
    private LocalDateTime approvedAt;

    private String rejectReason;
    private boolean isPaid;            // Đã thanh toán / Đã khóa
    private LocalDateTime createdAt;

    public Overtime() {
        this.coefficient = 1.5;
        this.status = "PENDING_LEAD";
        this.leadStatus = "PENDING";
        this.hrStatus = "PENDING";
        this.amount = BigDecimal.ZERO;
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

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getProjectName() { return projectName; }
    public void setProjectName(String projectName) { this.projectName = projectName; }

    public LocalDate getOvertimeDate() { return overtimeDate; }
    public void setOvertimeDate(LocalDate overtimeDate) { this.overtimeDate = overtimeDate; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

    public double getHours() { return hours; }
    public void setHours(double hours) { this.hours = hours; }

    public double getCoefficient() { return coefficient; }
    public void setCoefficient(double coefficient) { this.coefficient = coefficient; }

    public String getOtType() { return otType; }
    public void setOtType(String otType) { this.otType = otType; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getLeadApproverId() { return leadApproverId; }
    public void setLeadApproverId(int leadApproverId) { this.leadApproverId = leadApproverId; }

    public String getLeadApproverName() { return leadApproverName; }
    public void setLeadApproverName(String leadApproverName) { this.leadApproverName = leadApproverName; }

    public String getLeadStatus() { return leadStatus; }
    public void setLeadStatus(String leadStatus) { this.leadStatus = leadStatus; }

    public LocalDateTime getLeadApprovedAt() { return leadApprovedAt; }
    public void setLeadApprovedAt(LocalDateTime leadApprovedAt) { this.leadApprovedAt = leadApprovedAt; }

    public int getApprovedById() { return approvedById; }
    public void setApprovedById(int approvedById) { this.approvedById = approvedById; }

    public String getApprovedByName() { return approvedByName; }
    public void setApprovedByName(String approvedByName) { this.approvedByName = approvedByName; }

    public String getHrStatus() { return hrStatus; }
    public void setHrStatus(String hrStatus) { this.hrStatus = hrStatus; }

    public LocalDateTime getApprovedAt() { return approvedAt; }
    public void setApprovedAt(LocalDateTime approvedAt) { this.approvedAt = approvedAt; }

    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }

    public boolean isPaid() { return isPaid; }
    public void setPaid(boolean paid) { isPaid = paid; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    // ===== Helper Methods for View Rendering =====

    public String getOtTypeDisplay() {
        if (coefficient >= 3.0) return "Ngày lễ Tết (Hệ số 300%)";
        if (coefficient >= 2.0) return "Ngày nghỉ cuối tuần (Hệ số 200%)";
        return "Ngày thường (Hệ số 150%)";
    }

    public String getStatusBadgeClass() {
        if ("APPROVED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status)) return "bg-success-soft text-success";
        if ("PENDING_LEAD".equalsIgnoreCase(status)) return "bg-primary-soft text-primary";
        if ("PENDING_HR".equalsIgnoreCase(status)) return "bg-info-soft text-info";
        if ("REJECTED".equalsIgnoreCase(status)) return "bg-danger-soft text-danger";
        if ("PAID".equalsIgnoreCase(status) || "LOCKED".equalsIgnoreCase(status)) return "bg-secondary-soft text-secondary";
        return "bg-warning-soft text-warning";
    }

    public String getStatusDisplay() {
        if ("APPROVED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status)) return "Đã phê duyệt";
        if ("PENDING_LEAD".equalsIgnoreCase(status)) return "Chờ duyệt cấp 1";
        if ("PENDING_HR".equalsIgnoreCase(status)) return "Chờ duyệt cấp 2";
        if ("REJECTED".equalsIgnoreCase(status)) return "Từ chối";
        if ("PAID".equalsIgnoreCase(status)) return "Đã thanh toán";
        if ("LOCKED".equalsIgnoreCase(status)) return "Đã khóa";
        return "Chờ xử lý";
    }

    @Override
    public String toString() {
        return "Overtime{id=" + id + ", employeeId=" + employeeId
                + ", date=" + overtimeDate + ", hours=" + hours + ", status='" + status + "'}";
    }
}
