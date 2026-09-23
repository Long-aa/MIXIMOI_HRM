package com.miximoi.hrm.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

/**
 * Model đại diện cho Lịch phỏng vấn (Interview).
 */
public class Interview {
    private int id;
    private int candidateId;
    private Integer recruitmentRequestId;
    private Integer interviewerId;
    private String roundName;
    private LocalDate interviewDate;
    private LocalTime interviewTime;
    private String locationOrLink;
    private String status = "SCHEDULED"; // SCHEDULED | COMPLETED | CANCELLED | PASSED | FAILED
    private String feedback;
    private Double score;

    // Các trường liên kết (JOIN)
    private String candidateName;
    private String candidateCode;
    private String jobTitle;
    private String interviewerName;
    private String interviewerAvatarInitials;

    public Interview() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public Integer getRecruitmentRequestId() { return recruitmentRequestId; }
    public void setRecruitmentRequestId(Integer recruitmentRequestId) { this.recruitmentRequestId = recruitmentRequestId; }

    public Integer getInterviewerId() { return interviewerId; }
    public void setInterviewerId(Integer interviewerId) { this.interviewerId = interviewerId; }

    public String getRoundName() { return roundName; }
    public void setRoundName(String roundName) { this.roundName = roundName; }

    public LocalDate getInterviewDate() { return interviewDate; }
    public void setInterviewDate(LocalDate interviewDate) { this.interviewDate = interviewDate; }

    public LocalTime getInterviewTime() { return interviewTime; }
    public void setInterviewTime(LocalTime interviewTime) { this.interviewTime = interviewTime; }

    public String getLocationOrLink() { return locationOrLink; }
    public void setLocationOrLink(String locationOrLink) { this.locationOrLink = locationOrLink; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    public Double getScore() { return score; }
    public void setScore(Double score) { this.score = score; }

    public String getCandidateName() { return candidateName; }
    public void setCandidateName(String candidateName) { this.candidateName = candidateName; }

    public String getCandidateCode() { return candidateCode; }
    public void setCandidateCode(String candidateCode) { this.candidateCode = candidateCode; }

    public String getJobTitle() { return jobTitle; }
    public void setJobTitle(String jobTitle) { this.jobTitle = jobTitle; }

    public String getInterviewerName() { return interviewerName; }
    public void setInterviewerName(String interviewerName) { this.interviewerName = interviewerName; }

    public String getInterviewerAvatarInitials() { return interviewerAvatarInitials; }
    public void setInterviewerAvatarInitials(String interviewerAvatarInitials) { this.interviewerAvatarInitials = interviewerAvatarInitials; }

    /** Định dạng giờ phỏng vấn hiển thị (e.g., 09:30 AM) */
    public String getFormattedTime() {
        if (interviewTime == null) return "";
        return interviewTime.format(DateTimeFormatter.ofPattern("hh:mm a"));
    }

    public String getTimeHours() {
        if (interviewTime == null) return "";
        return interviewTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public String getTimePeriod() {
        if (interviewTime == null) return "";
        return interviewTime.getHour() < 12 ? "AM" : "PM";
    }
}
