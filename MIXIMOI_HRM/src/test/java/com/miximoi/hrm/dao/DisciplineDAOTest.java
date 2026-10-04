package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Discipline;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

class DisciplineDAOTest {

    private final DisciplineDAO disciplineDAO = new DisciplineDAO();

    @Test
    @DisplayName("Test DisciplineDAO.findAll returns seeded dynamic records")
    void testFindAll() {
        List<Discipline> list = disciplineDAO.findAll();
        Assertions.assertNotNull(list);
        Assertions.assertFalse(list.isEmpty(), "Danh sách kỷ luật phải có ít nhất các vụ việc đã seed");
        
        Discipline first = list.get(0);
        Assertions.assertNotNull(first.getViolationCode());
        Assertions.assertNotNull(first.getEmployeeName());
        Assertions.assertNotNull(first.getSeverityBadgeClass());
        Assertions.assertNotNull(first.getStatusBadgeClass());
    }

    @Test
    @DisplayName("Test DisciplineDAO.getStats returns valid KPI metrics")
    void testGetStats() {
        Map<String, Object> stats = disciplineDAO.getStats();
        Assertions.assertNotNull(stats);
        Assertions.assertTrue(stats.containsKey("total"));
        Assertions.assertTrue(stats.containsKey("in_progress"));
        Assertions.assertTrue(stats.containsKey("waiting_decision"));
        Assertions.assertTrue(stats.containsKey("resolved"));

        int total = (int) stats.get("total");
        Assertions.assertTrue(total >= 10, "Tổng số hồ sơ kỷ luật phải >= 10");
    }

    @Test
    @DisplayName("Test DisciplineDAO.getNextViolationCode generates standard format")
    void testGetNextViolationCode() {
        String code = disciplineDAO.getNextViolationCode();
        Assertions.assertNotNull(code);
        Assertions.assertTrue(code.startsWith("KL-"), "Mã biên bản phải bắt đầu bằng KL-");
    }

    @Test
    @DisplayName("Test insert, updateStatus, and delete workflow")
    void testInsertAndUpdateStatus() {
        Discipline d = new Discipline();
        d.setViolationCode("TEST-KL-999");
        d.setEmployeeId(1);
        d.setViolationDate(LocalDate.now());
        d.setBehavior("Kiểm thử tự động hệ thống vi phạm quy chế");
        d.setSeverity("LOW");
        d.setDecisionForm("Nhắc nhở nội bộ");
        d.setStatus("INVESTIGATING");

        boolean inserted = disciplineDAO.insert(d);
        Assertions.assertTrue(inserted, "Chèn hồ sơ kỷ luật thử nghiệm phải thành công");

        List<Discipline> found = disciplineDAO.findAll("TEST-KL-999", null, null, null);
        Assertions.assertFalse(found.isEmpty());
        int testId = found.get(0).getId();

        boolean updated = disciplineDAO.updateStatus(testId, "RESOLVED", 4);
        Assertions.assertTrue(updated, "Cập nhật trạng thái phải thành công");

        Discipline reloaded = disciplineDAO.findById(testId);
        Assertions.assertNotNull(reloaded);
        Assertions.assertEquals("RESOLVED", reloaded.getStatus());

        // Cleanup
        disciplineDAO.delete(testId);
    }
}
