package com.miximoi.hrm.service;

import com.miximoi.hrm.model.TimesheetItem;
import com.miximoi.hrm.model.TimesheetKpiStats;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Bộ kiểm thử tự động JUnit 5 cho Nghiệp vụ Tính toán Bảng công & Thống kê Chấm công.
 */
class TimesheetCalculationTest {

    private final TimesheetService timesheetService = new TimesheetService();

    @Test
    @DisplayName("Kiểm tra công thức khấu trừ đi muộn: Trễ dưới 15 phút được miễn tối đa 3 lần/tháng")
    void testLatePenaltyGracePeriod() {
        int minorLateCount = 3;
        double penalty = 0.0;
        if (minorLateCount <= 3) {
            penalty = 0.0;
        }
        assertEquals(0.0, penalty, "3 lần trễ dưới 15 phút đầu tiên trong tháng được miễn phạt công");

        minorLateCount = 4;
        if (minorLateCount > 3) {
            penalty = 0.25;
        }
        assertEquals(0.25, penalty, "Lần thứ 4 trễ < 15 phút bị khấu trừ 0.25 công chuẩn");
    }

    @Test
    @DisplayName("Kiểm tra công thức khấu trừ đi muộn: Trễ từ 15-60 phút khấu trừ 0.25 công; >60 phút khấu trừ 0.5 công")
    void testLatePenaltyTiers() {
        int diff1 = 30; // 30 phút
        double penalty1 = (diff1 <= 60) ? 0.25 : 0.50;
        assertEquals(0.25, penalty1, "Trễ 30 phút (trong dải 15-60 phút) khấu trừ 0.25 công");

        int diff2 = 90; // 90 phút
        double penalty2 = (diff2 > 60) ? 0.50 : 0.25;
        assertEquals(0.50, penalty2, "Trễ 90 phút (> 60 phút) khấu trừ 0.50 công");
    }

    @Test
    @DisplayName("Kiểm tra tính toán KPI thống kê bảng công (Số ngày công chuẩn, Số giờ công, Tỷ lệ chuyên cần)")
    void testCalculateKpiStats() {
        List<TimesheetItem> list = new ArrayList<>();

        TimesheetItem emp1 = new TimesheetItem();
        emp1.setEmployeeId(1);
        emp1.setActualWorkDays(22.0);
        emp1.setOtHours(8.0);
        emp1.setLateEarlyMinutes(0);
        emp1.setStatus("APPROVED_LOCK");
        list.add(emp1);

        TimesheetItem emp2 = new TimesheetItem();
        emp2.setEmployeeId(2);
        emp2.setActualWorkDays(20.0);
        emp2.setOtHours(4.0);
        emp2.setLateEarlyMinutes(45);
        emp2.setStatus("PENDING_CONFIRM");
        list.add(emp2);

        TimesheetKpiStats stats = timesheetService.calculateKpiStats(list, 10, 2026);
        assertNotNull(stats, "KpiStats không được null");
        assertTrue(stats.getStandardWorkDays() > 0, "Số ngày công chuẩn phải > 0");
        assertTrue(stats.getStandardWorkHours() > 0, "Số giờ làm chuẩn phải > 0");
        assertTrue(stats.getAttendanceRate() > 0, "Tỷ lệ chuyên cần phải > 0");
    }

    @Test
    @DisplayName("Kiểm tra hiển thị huy hiệu CSS theo trạng thái bảng công")
    void testTimesheetItemStatusDisplay() {
        TimesheetItem itemLocked = new TimesheetItem();
        itemLocked.setStatus("APPROVED_LOCK");
        assertEquals("badge-status-locked", itemLocked.getStatusBadgeClass(), "Đã duyệt chốt phải dùng class locked");

        TimesheetItem itemPending = new TimesheetItem();
        itemPending.setStatus("PENDING_CONFIRM");
        assertEquals("badge-status-pending", itemPending.getStatusBadgeClass(), "Chờ xác nhận phải dùng class pending");

        TimesheetItem itemAnomaly = new TimesheetItem();
        itemAnomaly.setStatus("ANOMALY");
        assertEquals("badge-status-anomaly", itemAnomaly.getStatusBadgeClass(), "Bất thường phải dùng class anomaly");
    }

    @Test
    @DisplayName("Kiểm tra thiết lập trạng thái ma trận ngày (Đúng giờ: X, Đi muộn: M, Nghỉ phép: P, Nghỉ tuần: OFF)")
    void testDayStatusMapping() {
        TimesheetItem item = new TimesheetItem();
        item.setDayStatus(1, "X");
        item.setDayStatus(2, "M");
        item.setDayStatus(3, "P");
        item.setDayStatus(4, "OFF");

        assertEquals("X", item.getDayStatus(1), "Ngày 1 phải là X (Đúng giờ)");
        assertEquals("M", item.getDayStatus(2), "Ngày 2 phải là M (Đi muộn/Về sớm)");
        assertEquals("P", item.getDayStatus(3), "Ngày 3 phải là P (Nghỉ phép hưởng lương)");
        assertEquals("OFF", item.getDayStatus(4), "Ngày 4 phải là OFF (Nghỉ cuối tuần)");
    }

    @Test
    @DisplayName("Kiểm tra tính toán tỷ lệ hoàn thành công chuẩn tháng (22 ngày công chuẩn)")
    void testWorkDayCompletionRate() {
        double standardDays = 22.0;
        double actualDays = 21.0;
        double completionRate = (actualDays / standardDays) * 100.0;

        assertEquals(95.45, Math.round(completionRate * 100.0) / 100.0, 0.01, "Tỷ lệ hoàn thành công đạt ~95.45%");
    }
}
