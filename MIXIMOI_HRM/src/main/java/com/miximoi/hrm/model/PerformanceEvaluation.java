package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Model PerformanceEvaluation — Đánh giá năng lực và hiệu suất 4 chiều.
 */
public class PerformanceEvaluation {
    private int id;
    private String evaluationCode;
    private int employeeId;
    private String employeeName;
    private String employeeCode;
    private String positionName;
    private Integer departmentId;
    private String departmentName;
    private Integer evaluatorId;
    private String evaluatorName;
    private String quarter;
    private BigDecimal kpiScore;        // Trọng số 40% (Thang 10)
    private BigDecimal competencyScore; // Trọng số 30% (Thang 10)
    private BigDecimal cultureScore;    // Trọng số 20% (Thang 10)
    private BigDecimal innovationScore; // Trọng số 10% (Thang 10)
    private BigDecimal finalScore;      // Tổng hợp
    private String grade;               // A+ | A | B | C | D
    private String status;              // PENDING | DRAFT | SUBMITTED | CONFIRMED
    private String feedback;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public PerformanceEvaluation() {
        this.kpiScore = BigDecimal.ZERO;
        this.competencyScore = BigDecimal.ZERO;
        this.cultureScore = BigDecimal.ZERO;
        this.innovationScore = BigDecimal.ZERO;
        this.finalScore = BigDecimal.ZERO;
        this.quarter = "Q3/2026";
        this.grade = "B";
        this.status = "PENDING";
    }

    public void calculateFinalScoreAndGrade() {
        double k = (kpiScore != null) ? kpiScore.doubleValue() : 0.0;
        double c = (competencyScore != null) ? competencyScore.doubleValue() : 0.0;
        double cu = (cultureScore != null) ? cultureScore.doubleValue() : 0.0;
        double in = (innovationScore != null) ? innovationScore.doubleValue() : 0.0;

        double total = (k * 0.40) + (c * 0.30) + (cu * 0.20) + (in * 0.10);
        this.finalScore = BigDecimal.valueOf(Math.round(total * 100.0) / 100.0);

        if (total >= 9.0) this.grade = "A+";
        else if (total >= 8.0) this.grade = "A";
        else if (total >= 7.0) this.grade = "B";
        else if (total >= 5.0) this.grade = "C";
        else this.grade = "D";
    }

    public String getGradeDisplayName() {
        if ("A+".equalsIgnoreCase(grade)) return "Xuất sắc (Hạng A+)";
        if ("A".equalsIgnoreCase(grade)) return "Tốt (Hạng A)";
        if ("B".equalsIgnoreCase(grade)) return "Khá (Hạng B)";
        if ("C".equalsIgnoreCase(grade)) return "Cần cải thiện (Hạng C)";
        return "Không đạt (Hạng D)";
    }

    public String getGradeBadgeClass() {
        if ("A+".equalsIgnoreCase(grade)) return "bg-purple-subtle text-purple border border-purple-subtle";
        if ("A".equalsIgnoreCase(grade)) return "bg-success-subtle text-success border border-success-subtle";
        if ("B".equalsIgnoreCase(grade)) return "bg-primary-subtle text-primary border border-primary-subtle";
        if ("C".equalsIgnoreCase(grade)) return "bg-warning-subtle text-warning-emphasis border border-warning-subtle";
        return "bg-danger-subtle text-danger border border-danger-subtle";
    }

    public String getStatusDisplayName() {
        if ("CONFIRMED".equalsIgnoreCase(status)) return "Đã thẩm định";
        if ("SUBMITTED".equalsIgnoreCase(status)) return "Chờ duyệt";
        if ("DRAFT".equalsIgnoreCase(status)) return "Đang đánh giá";
        return "Chưa đánh giá";
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEvaluationCode() { return evaluationCode; }
    public void setEvaluationCode(String evaluationCode) { this.evaluationCode = evaluationCode; }

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

    public Integer getEvaluatorId() { return evaluatorId; }
    public void setEvaluatorId(Integer evaluatorId) { this.evaluatorId = evaluatorId; }

    public String getEvaluatorName() { return evaluatorName; }
    public void setEvaluatorName(String evaluatorName) { this.evaluatorName = evaluatorName; }

    public String getQuarter() { return quarter; }
    public void setQuarter(String quarter) { this.quarter = quarter; }

    public BigDecimal getKpiScore() { return kpiScore; }
    public void setKpiScore(BigDecimal kpiScore) { this.kpiScore = kpiScore; }

    public BigDecimal getCompetencyScore() { return competencyScore; }
    public void setCompetencyScore(BigDecimal competencyScore) { this.competencyScore = competencyScore; }

    public BigDecimal getCultureScore() { return cultureScore; }
    public void setCultureScore(BigDecimal cultureScore) { this.cultureScore = cultureScore; }

    public BigDecimal getInnovationScore() { return innovationScore; }
    public void setInnovationScore(BigDecimal innovationScore) { this.innovationScore = innovationScore; }

    public BigDecimal getFinalScore() { return finalScore; }
    public void setFinalScore(BigDecimal finalScore) { this.finalScore = finalScore; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
