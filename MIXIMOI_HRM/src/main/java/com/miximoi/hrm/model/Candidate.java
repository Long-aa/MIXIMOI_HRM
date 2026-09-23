package com.miximoi.hrm.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Model đại diện cho một Ứng viên (Candidate).
 */
public class Candidate {
    private int id;
    private String candidateCode;
    private String fullName;
    private String email;
    private String phone;
    private int recruitmentRequestId;
    private String source; // LinkedIn | TopCV/VNW | Nội bộ (Ref) | Khác
    private String stage;  // NEW | SCREENING | INTERVIEW | OFFER | ONBOARDED | REJECTED
    private BigDecimal experienceYears;
    private BigDecimal expectedSalary;
    private String cvUrl;
    private String notes;
    private LocalDate appliedDate;
    private LocalDateTime createdAt;

    // Các trường liên kết
    private String jobTitle;
    private String departmentName;

    // Các trường phục vụ AI Lọc CV & ATS
    private String skills;
    private double aiMatchScore = 85.0;
    private String aiRecommendation;
    private String aiMatchedSkills;
    private String aiMissingSkills;
    private double rating = 4.5;
    private String avatarInitials = "UV";
    private String education;
    private String workHistory;

    public Candidate() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCandidateCode() { return candidateCode; }
    public void setCandidateCode(String candidateCode) { this.candidateCode = candidateCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { 
        this.fullName = fullName; 
        if (fullName != null && !fullName.trim().isEmpty()) {
            String[] parts = fullName.trim().split("\\s+");
            if (parts.length >= 2) {
                this.avatarInitials = ("" + parts[parts.length - 2].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
            } else {
                this.avatarInitials = fullName.substring(0, Math.min(2, fullName.length())).toUpperCase();
            }
        }
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getRecruitmentRequestId() { return recruitmentRequestId; }
    public void setRecruitmentRequestId(int recruitmentRequestId) { this.recruitmentRequestId = recruitmentRequestId; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getStage() { return stage; }
    public void setStage(String stage) { this.stage = stage; }

    public BigDecimal getExperienceYears() { return experienceYears; }
    public void setExperienceYears(BigDecimal experienceYears) { this.experienceYears = experienceYears; }

    public BigDecimal getExpectedSalary() { return expectedSalary; }
    public void setExpectedSalary(BigDecimal expectedSalary) { this.expectedSalary = expectedSalary; }

    public String getCvUrl() { return cvUrl; }
    public void setCvUrl(String cvUrl) { this.cvUrl = cvUrl; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDate getAppliedDate() { return appliedDate; }
    public void setAppliedDate(LocalDate appliedDate) { this.appliedDate = appliedDate; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getJobTitle() { return jobTitle; }
    public void setJobTitle(String jobTitle) { this.jobTitle = jobTitle; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public double getAiMatchScore() { return aiMatchScore; }
    public void setAiMatchScore(double aiMatchScore) { this.aiMatchScore = aiMatchScore; }

    public String getAiRecommendation() { return aiRecommendation; }
    public void setAiRecommendation(String aiRecommendation) { this.aiRecommendation = aiRecommendation; }

    public String getAiMatchedSkills() { return aiMatchedSkills; }
    public void setAiMatchedSkills(String aiMatchedSkills) { this.aiMatchedSkills = aiMatchedSkills; }

    public String getAiMissingSkills() { return aiMissingSkills; }
    public void setAiMissingSkills(String aiMissingSkills) { this.aiMissingSkills = aiMissingSkills; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getAvatarInitials() { return avatarInitials; }
    public void setAvatarInitials(String avatarInitials) { this.avatarInitials = avatarInitials; }

    public String getEducation() { return education; }
    public void setEducation(String education) { this.education = education; }

    public String getWorkHistory() { return workHistory; }
    public void setWorkHistory(String workHistory) { this.workHistory = workHistory; }

    public String getFormattedSalary() {
        if (expectedSalary == null || expectedSalary.compareTo(BigDecimal.ZERO) <= 0) return "Thỏa thuận";
        long millions = expectedSalary.longValue() / 1000000;
        return millions + " Triệu";
    }

    public String getFormattedAppliedDate() {
        if (appliedDate == null) return "";
        return appliedDate.format(DateTimeFormatter.ofPattern("dd/MM"));
    }

    public String getCvFileName() {
        if (fullName == null || fullName.trim().isEmpty()) return "CV_Ung_Vien.pdf";
        return "CV_" + fullName.trim().replaceAll("\\s+", "_") + ".pdf";
    }

    public List<String> getSkillList() {
        if (skills == null || skills.trim().isEmpty()) return Collections.emptyList();
        String[] parts = skills.split(",");
        List<String> list = new ArrayList<>();
        for (String p : parts) {
            if (!p.trim().isEmpty()) {
                list.add(p.trim());
            }
        }
        return list;
    }
}
