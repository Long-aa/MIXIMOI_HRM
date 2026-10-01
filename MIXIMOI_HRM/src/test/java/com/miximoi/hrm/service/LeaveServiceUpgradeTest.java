package com.miximoi.hrm.service;

import com.miximoi.hrm.model.Holiday;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử nâng cấp Nghiệp vụ Nghỉ phép & Nghỉ lễ (4 Giai đoạn)")
public class LeaveServiceUpgradeTest {

    private final LeaveService leaveService = new LeaveService();

    @Test
    @DisplayName("Giai đoạn 1: Loại trừ ngày Lễ Quốc Gia khi tính ngày làm việc thực tế")
    void testCalculateActualWorkingDaysExcludingHolidays() {
        // Ngày 30/04/2026 (Thứ 5) và 01/05/2026 (Thứ 6) là ngày lễ
        // 02/05/2026 là Thứ 7, 03/05/2026 là CN
        // 04/05/2026 là Thứ 2
        LocalDate start = LocalDate.of(2026, 4, 30);
        LocalDate end = LocalDate.of(2026, 5, 4);

        double days = leaveService.calculateActualWorkingDays(start, end, false);

        // 30/04: Lễ (0), 01/05: Lễ (0), 02/05: T7 (0), 03/05: CN (0), 04/05: Làm việc (1.0)
        // Kết quả mong đợi: chính xác 1.0 ngày làm việc!
        assertEquals(1.0, days, 0.01, "Ngày lễ 30/04 và 01/05 phải được loại trừ, chỉ tính ngày 04/05");
    }

    @Test
    @DisplayName("Giai đoạn 1: Nửa ngày rơi vào ngày lễ trả về 0.0")
    void testHalfDayOnHoliday() {
        LocalDate holidayDate = LocalDate.of(2026, 1, 1); // Tết dương lịch
        double halfDay = leaveService.calculateActualWorkingDays(holidayDate, holidayDate, true);
        assertEquals(0.0, halfDay, 0.01, "Nghỉ nửa ngày vào ngày lễ phải trả về 0.0");
    }

    @Test
    @DisplayName("Giai đoạn 1: Truy vấn danh mục ngày Lễ Quốc Gia năm 2026")
    void testGetHolidays() {
        List<Holiday> holidays = leaveService.getHolidays(2026);
        assertNotNull(holidays);
        assertFalse(holidays.isEmpty(), "Danh mục ngày lễ năm 2026 phải được khởi tạo từ DB");
        boolean hasNationalDay = holidays.stream().anyMatch(h -> h.getName().contains("Quốc Khánh"));
        assertTrue(hasNationalDay, "Phải có ngày Quốc Khánh trong danh sách");
    }

    @Test
    @DisplayName("Giai đoạn 3: Giới hạn công suất phòng ban (Capacity Guard)")
    void testDepartmentCapacityGuard() {
        // Phòng ban hợp lệ, kiểm tra không bị exception
        double rate = leaveService.getMaxDepartmentAbsenceRate(1, LocalDate.of(2026, 5, 4), LocalDate.of(2026, 5, 8), null);
        assertTrue(rate >= 0.0 && rate <= 100.0, "Tỷ lệ vắng mặt phòng ban phải nằm trong khoảng [0, 100]");
    }

    @Test
    @DisplayName("Giai đoạn 4: Tính tiền thanh toán phép năm chưa nghỉ theo Điều 113 BLLĐ")
    void testLeaveEncashmentFormula() {
        // Lương cơ bản 26.000.000 VNĐ -> 1 ngày công = 1.000.000 VNĐ
        double baseSalary = 26000000.0;
        double encashment = leaveService.calculateLeaveEncashment(1, 2026, baseSalary);
        assertTrue(encashment >= 0.0, "Tiền trợ cấp phép năm chưa nghỉ phải >= 0");
    }

    @Test
    @DisplayName("Nghiệp vụ Tạo đơn: Kiểm tra tạo đơn xin nghỉ phép vào CSDL")
    void testCreateLeaveRequest() {
        // Xóa sạch dữ liệu kiểm thử trước đó nếu có để đảm bảo tính độc lập
        try (java.sql.Connection conn = com.miximoi.hrm.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement("DELETE FROM leave_requests WHERE reason = 'Nghỉ việc gia đình riêng kiểm thử'")) {
            ps.executeUpdate();
        } catch (Exception ignored) {}

        com.miximoi.hrm.model.LeaveRequest lr = new com.miximoi.hrm.model.LeaveRequest();
        lr.setEmployeeId(1);
        lr.setLeaveType("PERSONAL");
        lr.setStartDate(LocalDate.of(2026, 11, 10)); // Tuesday
        lr.setEndDate(LocalDate.of(2026, 11, 11));   // Wednesday
        lr.setDays(2.0);
        lr.setReason("Nghỉ việc gia đình riêng kiểm thử");
        lr.setHandoverPerson("Nguyễn Văn B (0901234567)");
        lr.setAttachmentUrl(null);

        String error = leaveService.createLeaveRequest(lr);
        assertNull(error, "Tạo đơn phải thành công, error nhận được: " + error);
        assertTrue(lr.getId() > 0, "ID của đơn mới phải được sinh > 0");

        // Dọn dẹp bản ghi kiểm thử
        try (java.sql.Connection conn = com.miximoi.hrm.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement("DELETE FROM leave_requests WHERE id = ?")) {
            ps.setInt(1, lr.getId());
            ps.executeUpdate();
        } catch (Exception ignored) {}
    }
}
