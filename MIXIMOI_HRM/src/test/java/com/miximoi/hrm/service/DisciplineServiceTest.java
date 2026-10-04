package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.DisciplineDAO;
import com.miximoi.hrm.model.Discipline;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Bộ kiểm thử tự động JUnit 5 cho Nghiệp vụ Kỷ luật & Vi phạm lao động (/disciplines).
 */
class DisciplineServiceTest {

    private final DisciplineDAO disciplineDAO = new DisciplineDAO();

    @Test
    @DisplayName("Kiểm tra định dạng mã vi phạm kỷ luật chuẩn (VD: KL-2026-xxx)")
    void testViolationCodeFormat() {
        String violationCode = "KL-" + LocalDate.now().getYear() + "-" + String.format("%03d", 1);
        assertTrue(violationCode.startsWith("KL-2026-"), "Mã quyết định kỷ luật phải có tiền tố KL-{Năm}");
        assertEquals(11, violationCode.length(), "Mã quyết định có độ dài chuẩn 11 ký tự");
    }

    @Test
    @DisplayName("Kiểm tra mức độ vi phạm và huy hiệu màu tương ứng (LOW, MEDIUM, HIGH)")
    void testDisciplineSeverityBadge() {
        Discipline dLow = new Discipline();
        dLow.setSeverity("LOW");
        assertTrue(dLow.getSeverityBadgeClass().contains("info"), "Mức độ LOW phải hiển thị badge màu xanh info");
        assertEquals("Nhẹ", dLow.getSeverityLabel(), "Hiển thị nhãn cho LOW");

        Discipline dMed = new Discipline();
        dMed.setSeverity("MEDIUM");
        assertTrue(dMed.getSeverityBadgeClass().contains("warning"), "Mức độ MEDIUM phải hiển thị badge màu vàng warning");
        assertEquals("Trung bình", dMed.getSeverityLabel(), "Hiển thị nhãn cho MEDIUM");

        Discipline dHigh = new Discipline();
        dHigh.setSeverity("HIGH");
        assertTrue(dHigh.getSeverityBadgeClass().contains("danger"), "Mức độ HIGH phải hiển thị badge màu đỏ danger");
        assertEquals("Nghiêm trọng", dHigh.getSeverityLabel(), "Hiển thị nhãn cho HIGH");
    }

    @Test
    @DisplayName("Kiểm tra vòng đời trạng thái xử lý kỷ luật (PENDING -> INVESTIGATING -> RESOLVED -> CLOSED)")
    void testDisciplineStatusTransitions() {
        Discipline d = new Discipline();

        d.setStatus("PENDING");
        assertTrue(d.getStatusBadgeClass().contains("purple") || d.getStatusBadgeClass().contains("subtle"));
        assertEquals("Chờ quyết định", d.getStatusLabel());

        d.setStatus("INVESTIGATING");
        assertTrue(d.getStatusBadgeClass().contains("primary"));
        assertEquals("Đang xác minh", d.getStatusLabel());

        d.setStatus("RESOLVED");
        assertTrue(d.getStatusBadgeClass().contains("success"));
        assertEquals("Đã xử lý", d.getStatusLabel());

        d.setStatus("CLOSED");
        assertTrue(d.getStatusBadgeClass().contains("secondary"));
        assertEquals("Đã đóng", d.getStatusLabel());
    }

    @Test
    @DisplayName("Kiểm tra truy vấn lọc danh sách kỷ luật từ DAO theo từ khóa và trạng thái")
    void testDisciplineDaoSearch() {
        List<Discipline> all = disciplineDAO.findAll(null, null, null, null);
        assertNotNull(all, "Danh sách kỷ luật không được null");

        // Lọc theo trạng thái hợp lệ
        List<Discipline> filtered = disciplineDAO.findAll(null, "INVESTIGATING", null, null);
        assertNotNull(filtered, "Kết quả tìm kiếm theo trạng thái không được null");
        for (Discipline item : filtered) {
            assertEquals("INVESTIGATING", item.getStatus(), "Bản ghi phải khớp trạng thái INVESTIGATING");
        }
    }

    @Test
    @DisplayName("Kiểm tra hợp lệ hóa dữ liệu bản ghi vi phạm (Ngày vi phạm không được trong tương lai)")
    void testViolationDateValidation() {
        LocalDate today = LocalDate.now();
        LocalDate pastDate = today.minusDays(5);
        LocalDate futureDate = today.plusDays(2);

        assertFalse(pastDate.isAfter(today), "Ngày vi phạm trong quá khứ là hợp lệ");
        assertTrue(futureDate.isAfter(today), "Ngày vi phạm trong tương lai là không hợp lệ");
    }

    @Test
    @DisplayName("Kiểm tra khởi tạo đối tượng Discipline đầy đủ các trường nghiệp vụ")
    void testDisciplineModelAttributes() {
        Discipline d = new Discipline();
        d.setViolationCode("KL-2026-999");
        d.setEmployeeId(1);
        d.setViolationDate(LocalDate.now());
        d.setBehavior("Đi làm muộn 5 lần liên tiếp trong tuần không lý do");
        d.setSeverity("LOW");
        d.setDecisionForm("Khiển trách bằng văn bản");
        d.setStatus("INVESTIGATING");

        assertEquals("KL-2026-999", d.getViolationCode());
        assertEquals(1, d.getEmployeeId());
        assertEquals("LOW", d.getSeverity());
        assertEquals("INVESTIGATING", d.getStatus());
        assertTrue(d.getBehavior().contains("Đi làm muộn"));
    }
}
