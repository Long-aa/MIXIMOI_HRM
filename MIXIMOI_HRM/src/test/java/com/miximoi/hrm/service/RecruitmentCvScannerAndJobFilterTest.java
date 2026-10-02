package com.miximoi.hrm.service;

import com.miximoi.hrm.model.Candidate;
import com.miximoi.hrm.model.RecruitmentRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Kiểm thử tính năng Lọc CV tự động theo từ khóa quét CV (Word, PDF, Bản chữ viết)
 * và Bộ lọc tuyển dụng đa chiều (Phòng ban, Lương, Thành phố, Trạng thái).
 */
class RecruitmentCvScannerAndJobFilterTest {

    private RecruitmentService recruitmentService;

    @BeforeEach
    void setUp() {
        cleanTestRequests();
        com.miximoi.hrm.util.DatabaseInitializer.initialize();
        recruitmentService = new RecruitmentService();
    }

    @org.junit.jupiter.api.AfterEach
    void tearDown() {
        cleanTestRequests();
    }

    private void cleanTestRequests() {
        try (java.sql.Connection conn = com.miximoi.hrm.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                     "DELETE FROM recruitment_requests WHERE request_code LIKE 'TEST-REQ-%'")) {
            ps.executeUpdate();
        } catch (Exception ignored) {}
    }

    @Test
    @DisplayName("Kiểm tra ứng viên có đầy đủ thông tin loại CV (WORD, PDF, HANDWRITTEN) và nội dung quét CV")
    void testCandidateCvTypesAndText() {
        List<Candidate> candidates = recruitmentService.getAllCandidates(null, null, null, null);
        assertNotNull(candidates);
        assertFalse(candidates.isEmpty(), "Danh sách ứng viên không được rỗng");

        boolean hasWord = false;
        boolean hasPdf = false;
        boolean hasHandwritten = false;

        for (Candidate c : candidates) {
            String cvType = c.getCvType();
            if ("WORD".equalsIgnoreCase(cvType)) {
                hasWord = true;
                assertEquals("Bản Word (.docx)", c.getCvTypeFormatted());
                assertTrue(c.getCvTypeIcon().contains("word"));
            } else if ("PDF".equalsIgnoreCase(cvType)) {
                hasPdf = true;
                assertEquals("File PDF (.pdf)", c.getCvTypeFormatted());
                assertTrue(c.getCvTypeIcon().contains("pdf"));
            } else if ("HANDWRITTEN".equalsIgnoreCase(cvType)) {
                hasHandwritten = true;
                assertEquals("Bản chữ viết (OCR)", c.getCvTypeFormatted());
                assertTrue(c.getCvTypeIcon().contains("pen"));
            }
        }

        assertTrue(hasWord, "Phải có ít nhất 1 ứng viên định dạng Word");
        assertTrue(hasPdf, "Phải có ít nhất 1 ứng viên định dạng PDF");
        assertTrue(hasHandwritten, "Phải có ít nhất 1 ứng viên định dạng Bản chữ viết (OCR)");
    }

    @Test
    @DisplayName("Kiểm tra quét từ khóa trong CV (Spring Boot, React, OCR, Java, Figma, SQL)")
    void testCvKeywordScanning() {
        List<Candidate> candidates = recruitmentService.getAllCandidates(null, null, null, null);

        // Quét từ khóa 'Java' hoặc 'Spring' trong các CV
        long javaOrSpringMatches = candidates.stream()
                .filter(c -> c.getCvText() != null &&
                        (c.getCvText().toLowerCase().contains("java") || c.getCvText().toLowerCase().contains("spring")))
                .count();
        assertTrue(javaOrSpringMatches >= 1, "Phải có ứng viên khớp từ khóa Java / Spring trong CV");

        // Quét từ khóa 'chữ viết' / 'viết tay' hoặc OCR
        long ocrMatches = candidates.stream()
                .filter(c -> c.getCvText() != null &&
                        (c.getCvText().toLowerCase().contains("viết tay") ||
                         c.getCvText().toLowerCase().contains("ocr") ||
                         c.getCvText().toLowerCase().contains("ghi chú") ||
                         "HANDWRITTEN".equalsIgnoreCase(c.getCvType())))
                .count();
        assertTrue(ocrMatches >= 1, "Phải có ứng viên bản viết tay quét OCR");
    }

    @Test
    @DisplayName("Kiểm tra tạo vị trí tuyển dụng với Thành phố (Location) và Từ khóa (Keywords)")
    void testCreateRecruitmentRequestWithLocationAndKeywords() {
        RecruitmentRequest req = new RecruitmentRequest();
        req.setRequestCode("TEST-REQ-" + System.currentTimeMillis());
        req.setTitle("Senior Cloud Security Engineer");
        req.setDepartmentId(1);
        req.setPositionId(1);
        req.setTargetHeadcount(2);
        req.setSalaryMin(new BigDecimal("35000000"));
        req.setSalaryMax(new BigDecimal("55000000"));
        req.setDeadline(LocalDate.now().plusMonths(1));
        req.setPriority("HOT");
        req.setStatus("OPEN");
        req.setQuarter("Q3/2026");
        req.setLocation("Hà Nội");
        req.setKeywords("AWS, Cloud Security, Kubernetes, Docker, Terraform");
        req.setDescription("Bảo mật hệ thống đám mây nội bộ");
        req.setRequirements("3+ năm kinh nghiệm AWS/GCP");
        req.setBenefits("Lương tháng 13, BHXH đầy đủ");

        boolean created = recruitmentService.createRequest(req);
        assertTrue(created, "Tạo yêu cầu tuyển dụng với Thành phố và Từ khóa phải thành công");

        List<RecruitmentRequest> list = recruitmentService.getRequests("Q3/2026", null, null, null, null, null);
        RecruitmentRequest found = list.stream()
                .filter(r -> req.getRequestCode().equals(r.getRequestCode()))
                .findFirst()
                .orElse(null);

        assertNotNull(found, "Yêu cầu vừa tạo phải có trong cơ sở dữ liệu");
        assertEquals("Hà Nội", found.getLocation());
        assertTrue(found.getKeywords().contains("AWS"));
    }
}
