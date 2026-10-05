package com.miximoi.hrm.model;

/**
 * DTO chứa toàn bộ dữ liệu thống kê tổng quan của Module Tuyển Dụng.
 */
public class RecruitmentDashboardStats {
    // 4 KPI Cards
    private int openPositionsCount = 0;        // Vị trí đang tuyển
    private int openDepartmentsCount = 0;      // Số phòng ban đang tuyển
    private int newPositionsDiffMonth = 0;     // Số vị trí mới so với tháng trước
    private int totalCandidates = 0;          // Ứng viên tiếp nhận
    private double candidateGrowthPct = 0.0;   // Tỷ lệ tăng trưởng ứng tuyển
    private int interviewingCandidatesCount = 0;// Đang phỏng vấn (vòng 1 & CM)
    private int todayInterviewsCount = 0;      // Số ca phỏng vấn hôm nay
    private int hiredCandidatesCount = 0;      // Đã tuyển dụng
    private double fillRate = 0.0;             // Tỷ lệ lấp đầy
    private int newHiresThisWeek = 0;          // Ứng viên nhận việc tuần này

    // Funnel 5 Stages
    private double avgTimeToHireDays = 0.0;    // Time-to-hire TB (ngày)

    private int funnelStage1Count = 0;         // 1. Ứng viên mới
    private double funnelStage1Pct = 0.0;
    private double funnelStage1Drop = 0.0;

    private int funnelStage2Count = 0;         // 2. Sàng lọc CV
    private double funnelStage2Pct = 0.0;
    private double funnelStage2Drop = 0.0;

    private int funnelStage3Count = 0;         // 3. Phỏng vấn & Test
    private double funnelStage3Pct = 0.0;
    private double funnelStage3Drop = 0.0;

    private int funnelStage4Count = 0;         // 4. Gửi Offer lương
    private double funnelStage4Pct = 0.0;
    private double funnelStage4Drop = 0.0;

    private int funnelStage5Count = 0;         // 5. Đã nhận việc
    private double funnelStage5Pct = 0.0;

    // Sourcing Channels
    private int sourceLinkedInCount = 0;
    private double sourceLinkedInPct = 0.0;

    private int sourceTopCVCount = 0;
    private double sourceTopCVPct = 0.0;

    private int sourceRefCount = 0;
    private double sourceRefPct = 0.0;

    private int sourceOtherCount = 0;
    private double sourceOtherPct = 0.0;

    // Filter pill counts
    private int totalRequestsCount = 0;
    private int openRequestsCount = 0;
    private int urgentRequestsCount = 0;
    private int expiringRequestsCount = 0;

    public RecruitmentDashboardStats() {}

    // Getters & Setters
    public int getOpenPositionsCount() { return openPositionsCount; }
    public void setOpenPositionsCount(int openPositionsCount) { this.openPositionsCount = openPositionsCount; }

    public int getOpenDepartmentsCount() { return openDepartmentsCount; }
    public void setOpenDepartmentsCount(int openDepartmentsCount) { this.openDepartmentsCount = openDepartmentsCount; }

    public int getNewPositionsDiffMonth() { return newPositionsDiffMonth; }
    public void setNewPositionsDiffMonth(int newPositionsDiffMonth) { this.newPositionsDiffMonth = newPositionsDiffMonth; }

    public int getTotalCandidates() { return totalCandidates; }
    public void setTotalCandidates(int totalCandidates) { this.totalCandidates = totalCandidates; }

    public double getCandidateGrowthPct() { return candidateGrowthPct; }
    public void setCandidateGrowthPct(double candidateGrowthPct) { this.candidateGrowthPct = candidateGrowthPct; }

    public int getInterviewingCandidatesCount() { return interviewingCandidatesCount; }
    public void setInterviewingCandidatesCount(int interviewingCandidatesCount) { this.interviewingCandidatesCount = interviewingCandidatesCount; }

    public int getTodayInterviewsCount() { return todayInterviewsCount; }
    public void setTodayInterviewsCount(int todayInterviewsCount) { this.todayInterviewsCount = todayInterviewsCount; }

    public int getHiredCandidatesCount() { return hiredCandidatesCount; }
    public void setHiredCandidatesCount(int hiredCandidatesCount) { this.hiredCandidatesCount = hiredCandidatesCount; }

    public double getFillRate() { return fillRate; }
    public void setFillRate(double fillRate) { this.fillRate = fillRate; }

    public String getFillRateFormatted() {
        return String.format("%.1f", fillRate);
    }

    public int getNewHiresThisWeek() { return newHiresThisWeek; }
    public void setNewHiresThisWeek(int newHiresThisWeek) { this.newHiresThisWeek = newHiresThisWeek; }

    public double getAvgTimeToHireDays() { return avgTimeToHireDays; }
    public void setAvgTimeToHireDays(double avgTimeToHireDays) { this.avgTimeToHireDays = avgTimeToHireDays; }

    public int getFunnelStage1Count() { return funnelStage1Count; }
    public void setFunnelStage1Count(int funnelStage1Count) { this.funnelStage1Count = funnelStage1Count; }

    public double getFunnelStage1Pct() { return funnelStage1Pct; }
    public void setFunnelStage1Pct(double funnelStage1Pct) { this.funnelStage1Pct = funnelStage1Pct; }

    public double getFunnelStage1Drop() { return funnelStage1Drop; }
    public void setFunnelStage1Drop(double funnelStage1Drop) { this.funnelStage1Drop = funnelStage1Drop; }

    public int getFunnelStage2Count() { return funnelStage2Count; }
    public void setFunnelStage2Count(int funnelStage2Count) { this.funnelStage2Count = funnelStage2Count; }

    public double getFunnelStage2Pct() { return funnelStage2Pct; }
    public void setFunnelStage2Pct(double funnelStage2Pct) { this.funnelStage2Pct = funnelStage2Pct; }

    public double getFunnelStage2Drop() { return funnelStage2Drop; }
    public void setFunnelStage2Drop(double funnelStage2Drop) { this.funnelStage2Drop = funnelStage2Drop; }

    public int getFunnelStage3Count() { return funnelStage3Count; }
    public void setFunnelStage3Count(int funnelStage3Count) { this.funnelStage3Count = funnelStage3Count; }

    public double getFunnelStage3Pct() { return funnelStage3Pct; }
    public void setFunnelStage3Pct(double funnelStage3Pct) { this.funnelStage3Pct = funnelStage3Pct; }

    public double getFunnelStage3Drop() { return funnelStage3Drop; }
    public void setFunnelStage3Drop(double funnelStage3Drop) { this.funnelStage3Drop = funnelStage3Drop; }

    public int getFunnelStage4Count() { return funnelStage4Count; }
    public void setFunnelStage4Count(int funnelStage4Count) { this.funnelStage4Count = funnelStage4Count; }

    public double getFunnelStage4Pct() { return funnelStage4Pct; }
    public void setFunnelStage4Pct(double funnelStage4Pct) { this.funnelStage4Pct = funnelStage4Pct; }

    public double getFunnelStage4Drop() { return funnelStage4Drop; }
    public void setFunnelStage4Drop(double funnelStage4Drop) { this.funnelStage4Drop = funnelStage4Drop; }

    public int getFunnelStage5Count() { return funnelStage5Count; }
    public void setFunnelStage5Count(int funnelStage5Count) { this.funnelStage5Count = funnelStage5Count; }

    public double getFunnelStage5Pct() { return funnelStage5Pct; }
    public void setFunnelStage5Pct(double funnelStage5Pct) { this.funnelStage5Pct = funnelStage5Pct; }

    public int getSourceLinkedInCount() { return sourceLinkedInCount; }
    public void setSourceLinkedInCount(int sourceLinkedInCount) { this.sourceLinkedInCount = sourceLinkedInCount; }

    public double getSourceLinkedInPct() { return sourceLinkedInPct; }
    public void setSourceLinkedInPct(double sourceLinkedInPct) { this.sourceLinkedInPct = sourceLinkedInPct; }

    public int getSourceTopCVCount() { return sourceTopCVCount; }
    public void setSourceTopCVCount(int sourceTopCVCount) { this.sourceTopCVCount = sourceTopCVCount; }

    public double getSourceTopCVPct() { return sourceTopCVPct; }
    public void setSourceTopCVPct(double sourceTopCVPct) { this.sourceTopCVPct = sourceTopCVPct; }

    public int getSourceRefCount() { return sourceRefCount; }
    public void setSourceRefCount(int sourceRefCount) { this.sourceRefCount = sourceRefCount; }

    public double getSourceRefPct() { return sourceRefPct; }
    public void setSourceRefPct(double sourceRefPct) { this.sourceRefPct = sourceRefPct; }

    public int getSourceOtherCount() { return sourceOtherCount; }
    public void setSourceOtherCount(int sourceOtherCount) { this.sourceOtherCount = sourceOtherCount; }

    public double getSourceOtherPct() { return sourceOtherPct; }
    public void setSourceOtherPct(double sourceOtherPct) { this.sourceOtherPct = sourceOtherPct; }

    public int getTotalRequestsCount() { return totalRequestsCount; }
    public void setTotalRequestsCount(int totalRequestsCount) { this.totalRequestsCount = totalRequestsCount; }

    public int getOpenRequestsCount() { return openRequestsCount; }
    public void setOpenRequestsCount(int openRequestsCount) { this.openRequestsCount = openRequestsCount; }

    public int getUrgentRequestsCount() { return urgentRequestsCount; }
    public void setUrgentRequestsCount(int urgentRequestsCount) { this.urgentRequestsCount = urgentRequestsCount; }

    public int getExpiringRequestsCount() { return expiringRequestsCount; }
    public void setExpiringRequestsCount(int expiringRequestsCount) { this.expiringRequestsCount = expiringRequestsCount; }
}
