package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model đại diện cho một Yêu cầu tuyển dụng / Chiến dịch tuyển dụng.
 */
public class RecruitmentRequest {
    private int id;
    private String requestCode;
    private String title;
    private Integer departmentId;
    private Integer positionId;
    private int targetHeadcount = 1;
    private int hiredCount = 0;
    private BigDecimal salaryMin;
    private BigDecimal salaryMax;
    private boolean salaryNegotiable;
    private LocalDate deadline;
    private String priority = "NORMAL";   // NORMAL | URGENT | HOT
    private String status = "OPEN";       // OPEN | PAUSED | FILLED | CLOSED
    private String quarter = "Q3/2026";
    private Integer assigneeId;
    private String description;
    private String requirements;
    private String benefits;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Các trường liên kết (JOIN) để hiển thị giao diện
    private String departmentName;
    private String positionName;
    private String assigneeName;
    private String assigneeAvatarInitials;
    private int candidateCount;
    private int interviewCount;
    private long daysRemaining;

    public RecruitmentRequest() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRequestCode() { return requestCode; }
    public void setRequestCode(String requestCode) { this.requestCode = requestCode; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Integer getDepartmentId() { return departmentId; }
    public void setDepartmentId(Integer departmentId) { this.departmentId = departmentId; }

    public Integer getPositionId() { return positionId; }
    public void setPositionId(Integer positionId) { this.positionId = positionId; }

    public int getTargetHeadcount() { return targetHeadcount; }
    public void setTargetHeadcount(int targetHeadcount) { this.targetHeadcount = targetHeadcount; }

    public int getHiredCount() { return hiredCount; }
    public void setHiredCount(int hiredCount) { this.hiredCount = hiredCount; }

    public BigDecimal getSalaryMin() { return salaryMin; }
    public void setSalaryMin(BigDecimal salaryMin) { this.salaryMin = salaryMin; }

    public BigDecimal getSalaryMax() { return salaryMax; }
    public void setSalaryMax(BigDecimal salaryMax) { this.salaryMax = salaryMax; }

    public boolean isSalaryNegotiable() { return salaryNegotiable; }
    public void setSalaryNegotiable(boolean salaryNegotiable) { this.salaryNegotiable = salaryNegotiable; }

    public LocalDate getDeadline() { return deadline; }
    public void setDeadline(LocalDate deadline) { this.deadline = deadline; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getQuarter() { return quarter; }
    public void setQuarter(String quarter) { this.quarter = quarter; }

    public Integer getAssigneeId() { return assigneeId; }
    public void setAssigneeId(Integer assigneeId) { this.assigneeId = assigneeId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }

    public String getBenefits() { return benefits; }
    public void setBenefits(String benefits) { this.benefits = benefits; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public String getAssigneeName() { return assigneeName; }
    public void setAssigneeName(String assigneeName) { this.assigneeName = assigneeName; }

    public String getAssigneeAvatarInitials() { return assigneeAvatarInitials; }
    public void setAssigneeAvatarInitials(String assigneeAvatarInitials) { this.assigneeAvatarInitials = assigneeAvatarInitials; }

    public int getCandidateCount() { return candidateCount; }
    public void setCandidateCount(int candidateCount) { this.candidateCount = candidateCount; }

    public int getInterviewCount() { return interviewCount; }
    public void setInterviewCount(int interviewCount) { this.interviewCount = interviewCount; }

    public long getDaysRemaining() { return daysRemaining; }
    public void setDaysRemaining(long daysRemaining) { this.daysRemaining = daysRemaining; }

    /** Tính tỷ lệ phần trăm đã tuyển */
    public int getFillPercentage() {
        if (targetHeadcount <= 0) return 0;
        int pct = (int) Math.round(((double) hiredCount / targetHeadcount) * 100);
        return Math.min(pct, 100);
    }

    public String getSalaryMinFormatted() {
        if (salaryMin == null || salaryMin.compareTo(BigDecimal.ZERO) <= 0) return "0";
        long millions = salaryMin.longValue() / 1000000;
        return String.valueOf(millions);
    }

    public String getSalaryMaxFormatted() {
        if (salaryMax == null || salaryMax.compareTo(BigDecimal.ZERO) <= 0) return "0";
        long millions = salaryMax.longValue() / 1000000;
        return String.valueOf(millions);
    }
}
