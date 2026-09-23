package com.miximoi.hrm.model;

/**
 * DTO chứa toàn bộ dữ liệu thống kê tổng quan của Module Tuyển Dụng.
 */
public class RecruitmentDashboardStats {
    // 4 KPI Cards
    private int openPositionsCount = 12;       // Vị trí đang tuyển
    private int openDepartmentsCount = 8;      // Số phòng ban đang tuyển
    private int newPositionsDiffMonth = 3;     // +3 so với tháng trước
    private int totalCandidates = 86;          // Ứng viên tiếp nhận
    private double candidateGrowthPct = 28.0;  // +28% tỷ lệ ứng tuyển
    private int interviewingCandidatesCount = 24;// Đang phỏng vấn (vòng 1 & CM)
    private int todayInterviewsCount = 3;      // 3 ca hôm nay (mockup ghi 8 lịch hoặc 3 ca)
    private int hiredCandidatesCount = 5;      // Đã tuyển dụng
    private double fillRate = 41.7;            // Tỷ lệ lấp đầy: 41.7%
    private int newHiresThisWeek = 2;          // +2 ứng viên tuần này

    // Funnel 5 Stages
    private double avgTimeToHireDays = 18.5;   // Time-to-hire TB: 18.5 ngày

    private int funnelStage1Count = 86;        // 1. Ứng viên mới (100%)
    private double funnelStage1Pct = 100.0;
    private double funnelStage1Drop = 0.0;

    private int funnelStage2Count = 54;        // 2. Sàng lọc CV (62.8%)
    private double funnelStage2Pct = 62.8;
    private double funnelStage2Drop = -37.2;

    private int funnelStage3Count = 24;        // 3. Phỏng vấn & Test (27.9%)
    private double funnelStage3Pct = 27.9;
    private double funnelStage3Drop = -34.9;

    private int funnelStage4Count = 8;         // 4. Gửi Offer lương (9.3%)
    private double funnelStage4Pct = 9.3;
    private double funnelStage4Drop = -18.6;

    private int funnelStage5Count = 5;         // 5. Đã nhận việc (5.8%)
    private double funnelStage5Pct = 5.8;

    // Sourcing Channels
    private int sourceLinkedInCount = 36;
    private double sourceLinkedInPct = 42.0;

    private int sourceTopCVCount = 30;
    private double sourceTopCVPct = 35.0;

    private int sourceRefCount = 13;
    private double sourceRefPct = 15.0;

    private int sourceOtherCount = 7;
    private double sourceOtherPct = 8.0;

    // Filter pill counts
    private int totalRequestsCount = 12;
    private int openRequestsCount = 8;
    private int urgentRequestsCount = 3;
    private int expiringRequestsCount = 2;

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
