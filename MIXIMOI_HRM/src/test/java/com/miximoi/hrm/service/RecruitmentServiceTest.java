package com.miximoi.hrm.service;

import com.miximoi.hrm.model.Candidate;
import com.miximoi.hrm.model.Interview;
import com.miximoi.hrm.model.RecruitmentDashboardStats;
import com.miximoi.hrm.model.RecruitmentRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Kiểm thử tích hợp tự động cho RecruitmentService kết nối Database thật.
 */
class RecruitmentServiceTest {

    private RecruitmentService recruitmentService;

    @BeforeEach
    void setUp() {
        recruitmentService = new RecruitmentService();
    }

    @Test
    @DisplayName("Kiểm tra thống kê Dashboard: 4 thẻ KPI, Phễu 5 bước, 4 Nguồn ứng viên")
    void testGetDashboardStats() {
        RecruitmentDashboardStats stats = recruitmentService.getDashboardStats("Q3/2026", null);
        assertNotNull(stats, "Stats không được null");
        
        // KPI
        assertEquals(86, stats.getTotalCandidates(), "Tổng ứng viên phải là 86");
        assertEquals(5, stats.getHiredCandidatesCount(), "Số đã tuyển phải là 5");
        assertTrue(stats.getOpenPositionsCount() >= 8, "Vị trí đang tuyển phải >= 8");
        assertEquals(3, stats.getTodayInterviewsCount(), "Hôm nay phải có 3 ca phỏng vấn");

        // Phễu 5 giai đoạn
        assertEquals(86, stats.getFunnelStage1Count(), "Vòng 1 phải có 86 hồ sơ");
        assertEquals(54, stats.getFunnelStage2Count(), "Vòng 2 phải có 54 hồ sơ");
        assertEquals(24, stats.getFunnelStage3Count(), "Vòng 3 phải có 24 ứng viên");
        assertEquals(8, stats.getFunnelStage4Count(), "Vòng 4 phải có 8 ứng viên");
        assertEquals(5, stats.getFunnelStage5Count(), "Vòng 5 phải có 5 nhân sự");

        // 4 Nguồn tuyển dụng
        assertEquals(36, stats.getSourceLinkedInCount(), "LinkedIn phải có 36 ứng viên (42%)");
        assertEquals(30, stats.getSourceTopCVCount(), "TopCV phải có 30 ứng viên (35%)");
        assertEquals(13, stats.getSourceRefCount(), "Nội bộ phải có 13 ứng viên (15%)");
        assertEquals(7, stats.getSourceOtherCount(), "Khác phải có 7 ứng viên (8%)");
    }

    @Test
    @DisplayName("Kiểm tra danh sách chiến dịch tuyển dụng: 12 chiến dịch")
    void testGetRequests() {
        List<RecruitmentRequest> requests = recruitmentService.getRequests("Q3/2026", null, null, null, null, null);
        assertNotNull(requests);
        assertEquals(12, requests.size(), "Phải có đúng 12 chiến dịch tuyển dụng");

        RecruitmentRequest r1 = requests.get(0);
        assertEquals("YCTD-2026-081", r1.getRequestCode());
        assertTrue(r1.getTitle().contains("Senior Fullstack Engineer"));
        assertEquals("Phòng Kỹ thuật", r1.getDepartmentName());
    }

    @Test
    @DisplayName("Kiểm tra lịch phỏng vấn ngày hôm nay: 3 ca xếp lịch")
    void testGetTodayInterviews() {
        List<Interview> todayList = recruitmentService.getTodayInterviews();
        assertNotNull(todayList);
        assertEquals(3, todayList.size(), "Hôm nay phải có đúng 3 ca phỏng vấn");

        assertEquals("Vũ Hoàng Nam", todayList.get(0).getCandidateName());
        assertEquals("Phạm Khánh Linh", todayList.get(1).getCandidateName());
        assertEquals("Trương Bá Đạt", todayList.get(2).getCandidateName());
    }

    @Test
    @DisplayName("Kiểm tra xuất file Báo cáo Tuyển dụng CSV chuẩn UTF-8 BOM")
    void testGenerateRecruitmentReportCSV() {
        byte[] csvData = recruitmentService.generateRecruitmentReportCSV("Q3/2026", null);
        assertNotNull(csvData);
        assertTrue(csvData.length > 0);

        String csvText = new String(csvData, StandardCharsets.UTF_8);
        assertTrue(csvText.contains("BÁO CÁO TIẾN ĐỘ TUYỂN DỤNG"), "Báo cáo phải có tiêu đề");
        assertTrue(csvText.contains("YCTD-2026-081"), "Báo cáo phải chứa mã chiến dịch 081");
        assertTrue(csvText.contains("Vũ Hoàng Nam"), "Báo cáo phải chứa ứng viên phỏng vấn");
        assertTrue(csvText.contains("LinkedIn"), "Báo cáo phải chứa nguồn LinkedIn");
    }

    @Test
    @DisplayName("Kiểm tra danh sách Ứng viên và AI Screening Engine")
    void testCandidatesAndAiScreening() {
        List<Candidate> candidates = recruitmentService.getAllCandidates(null, null, null, null);
        assertNotNull(candidates);
        assertFalse(candidates.isEmpty(), "Danh sách ứng viên không được rỗng");

        // Kiểm tra AI Match Score và Skills đã được làm giàu
        Candidate c1 = candidates.get(0);
        assertTrue(c1.getAiMatchScore() >= 0 && c1.getAiMatchScore() <= 100, "Điểm AI phải từ 0 - 100");
        assertNotNull(c1.getSkills(), "Kỹ năng không được null");
        assertNotNull(c1.getAiRecommendation(), "Khuyến nghị AI không được null");

        // Kiểm tra Top 3 ứng viên cho vị trí 1
        List<Candidate> top3 = recruitmentService.getTopCandidatesForJob(1, 3);
        assertNotNull(top3);
        assertTrue(top3.size() <= 3);
        if (top3.size() >= 2) {
            assertTrue(top3.get(0).getAiMatchScore() >= top3.get(1).getAiMatchScore(), "Top ứng viên phải được xếp giảm dần theo điểm AI");
        }
    }

    @Test
    @DisplayName("Kiểm tra cập nhật giai đoạn tuyển dụng của ứng viên")
    void testUpdateCandidateStage() {
        List<Candidate> candidates = recruitmentService.getAllCandidates(null, null, null, null);
        assertFalse(candidates.isEmpty());
        int testCandId = candidates.get(0).getId();
        
        boolean ok = recruitmentService.updateCandidateStage(testCandId, "INTERVIEW");
        assertTrue(ok, "Cập nhật stage phải thành công");

        Candidate updated = recruitmentService.getCandidateById(testCandId);
        assertNotNull(updated);
        assertEquals("INTERVIEW", updated.getStage());
    }
}
