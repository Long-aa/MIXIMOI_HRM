package com.miximoi.hrm.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model đại diện cho một hồ sơ vi phạm kỷ luật lao động.
 */
public class Discipline {

    private int id;
    private String violationCode;
    private int employeeId;
    private String employeeName;
    private String employeeCode;
    private String departmentName;
    private LocalDate violationDate;
    private String behavior;
    private String severity;       // HIGH, MEDIUM, LOW
    private String decisionForm;   // Khiển trách bằng văn bản, Kéo dài thời hạn nâng lương, Cách chức, Sa thải...
    private Integer handlerId;
    private String handlerName;
    private String status;         // PENDING, INVESTIGATING, RESOLVED, CLOSED
    private LocalDateTime createdAt;

    public Discipline() {}

    public Discipline(int id, String violationCode, int employeeId, String employeeName, String employeeCode,
                      String departmentName, LocalDate violationDate, String behavior, String severity,
                      String decisionForm, Integer handlerId, String handlerName, String status, LocalDateTime createdAt) {
        this.id = id;
        this.violationCode = violationCode;
        this.employeeId = employeeId;
        this.employeeName = employeeName;
        this.employeeCode = employeeCode;
        this.departmentName = departmentName;
        this.violationDate = violationDate;
        this.behavior = behavior;
        this.severity = severity;
        this.decisionForm = decisionForm;
        this.handlerId = handlerId;
        this.handlerName = handlerName;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getViolationCode() { return violationCode; }
    public void setViolationCode(String violationCode) { this.violationCode = violationCode; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public LocalDate getViolationDate() { return violationDate; }
    public void setViolationDate(LocalDate violationDate) { this.violationDate = violationDate; }

    public String getBehavior() { return behavior; }
    public void setBehavior(String behavior) { this.behavior = behavior; }

    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }

    public String getDecisionForm() { return decisionForm; }
    public void setDecisionForm(String decisionForm) { this.decisionForm = decisionForm; }

    public Integer getHandlerId() { return handlerId; }
    public void setHandlerId(Integer handlerId) { this.handlerId = handlerId; }

    public String getHandlerName() { return handlerName; }
    public void setHandlerName(String handlerName) { this.handlerName = handlerName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getSeverityLabel() {
        if ("HIGH".equalsIgnoreCase(severity)) return "Nghiêm trọng";
        if ("MEDIUM".equalsIgnoreCase(severity)) return "Trung bình";
        return "Nhẹ";
    }

    public String getSeverityBadgeClass() {
        if ("HIGH".equalsIgnoreCase(severity)) return "bg-danger-subtle text-danger border border-danger-subtle";
        if ("MEDIUM".equalsIgnoreCase(severity)) return "bg-warning-subtle text-warning border border-warning-subtle";
        return "bg-info-subtle text-info border border-info-subtle";
    }

    public String getStatusLabel() {
        if ("INVESTIGATING".equalsIgnoreCase(status)) return "Đang xác minh";
        if ("PENDING".equalsIgnoreCase(status)) return "Chờ quyết định";
        if ("RESOLVED".equalsIgnoreCase(status)) return "Đã xử lý";
        if ("CLOSED".equalsIgnoreCase(status)) return "Đã đóng";
        return status;
    }

    public String getStatusBadgeClass() {
        if ("INVESTIGATING".equalsIgnoreCase(status)) return "bg-primary-subtle text-primary border border-primary-subtle";
        if ("PENDING".equalsIgnoreCase(status)) return "bg-purple-subtle text-purple border border-purple-subtle";
        if ("RESOLVED".equalsIgnoreCase(status)) return "bg-success-subtle text-success border border-success-subtle";
        return "bg-secondary-subtle text-secondary border border-secondary-subtle";
    }

    private int currentStep = 1;
    private String notes;

    public int getCurrentStep() {
        if (currentStep > 0) return currentStep;
        if ("INVESTIGATING".equalsIgnoreCase(status) || "PENDING_VERIFY".equalsIgnoreCase(status)) return 2;
        if ("PENDING".equalsIgnoreCase(status) || "WAITING_HEARING".equalsIgnoreCase(status)) return 3;
        if ("RESOLVED".equalsIgnoreCase(status)) return 4;
        if ("CLOSED".equalsIgnoreCase(status)) return 5;
        return 1;
    }
    public void setCurrentStep(int currentStep) { this.currentStep = currentStep; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getViolationBehavior() { return getBehavior(); }
    public void setViolationBehavior(String behavior) { setBehavior(behavior); }

    public String getProposedDecision() { return getDecisionForm(); }
    public void setProposedDecision(String proposedDecision) { setDecisionForm(proposedDecision); }

    public String getAvatarLetters() {
        if (employeeName == null || employeeName.trim().isEmpty()) return "NV";
        String[] parts = employeeName.trim().split("\\s+");
        if (parts.length == 1) return parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }
}
