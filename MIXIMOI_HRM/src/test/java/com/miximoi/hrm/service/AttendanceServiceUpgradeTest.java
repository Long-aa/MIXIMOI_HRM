package com.miximoi.hrm.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử Quy tắc Nghiệp vụ Chấm công — AttendanceService")
class AttendanceServiceUpgradeTest {

    @Test
    @DisplayName("Check-in đúng giờ: vào ca lúc hoặc trước 08:30 hoặc trong thời gian ân hạn 15 phút (<= 08:45)")
    void testDetermineCheckInStatus_OnTime() {
        // Vào sớm
        assertEquals("ON_TIME", AttendanceService.determineCheckInStatus(LocalTime.of(8, 0)));
        // Đúng giờ
        assertEquals("ON_TIME", AttendanceService.determineCheckInStatus(LocalTime.of(8, 30)));
        // Trong thời gian ân hạn (08:45)
        assertEquals("ON_TIME", AttendanceService.determineCheckInStatus(LocalTime.of(8, 45)));
    }

    @Test
    @DisplayName("Check-in muộn: vào ca sau 08:45 bị đánh dấu LATE")
    void testDetermineCheckInStatus_Late() {
        // Trễ 1 phút sau ân hạn
        assertEquals("LATE", AttendanceService.determineCheckInStatus(LocalTime.of(8, 46)));
        // Trễ 30 phút
        assertEquals("LATE", AttendanceService.determineCheckInStatus(LocalTime.of(9, 0)));
    }

    @Test
    @DisplayName("Check-in null trả về ABSENT")
    void testDetermineCheckInStatus_Null() {
        assertEquals("ABSENT", AttendanceService.determineCheckInStatus(null));
    }

    @Test
    @DisplayName("Check-out: nếu buổi sáng đã LATE thì kết quả cuối cùng vẫn giữ LATE")
    void testDetermineCheckOutStatus_PreservesLate() {
        String status = AttendanceService.determineCheckOutStatus("LATE", LocalTime.of(9, 0), LocalTime.of(17, 30));
        assertEquals("LATE", status);
    }

    @Test
    @DisplayName("Check-out: ra về trước 17:15 bị đánh dấu EARLY_LEAVE")
    void testDetermineCheckOutStatus_EarlyLeave() {
        String status = AttendanceService.determineCheckOutStatus("ON_TIME", LocalTime.of(8, 30), LocalTime.of(16, 50));
        assertEquals("EARLY_LEAVE", status);
    }

    @Test
    @DisplayName("Check-out: ra về sau 18:00 (quá ca 30 phút) được tính OVERTIME")
    void testDetermineCheckOutStatus_Overtime() {
        String status = AttendanceService.determineCheckOutStatus("ON_TIME", LocalTime.of(8, 30), LocalTime.of(18, 15));
        assertEquals("OVERTIME", status);
    }

    @Test
    @DisplayName("Check-out: ra về đúng giờ (17:15 - 18:00) trả về ON_TIME")
    void testDetermineCheckOutStatus_OnTime() {
        String status = AttendanceService.determineCheckOutStatus("ON_TIME", LocalTime.of(8, 30), LocalTime.of(17, 30));
        assertEquals("ON_TIME", status);
    }

    @Test
    @DisplayName("Tính giờ làm thực tế: từ 5h trở lên tự động trừ 1h nghỉ trưa, tối đa 8.0h")
    void testCalculateWorkHours() {
        // Ca chuẩn 08:30 - 17:30 (9 tiếng - 1h trưa = 8.0h)
        double hoursFull = AttendanceService.calculateWorkHours(LocalTime.of(8, 30), LocalTime.of(17, 30));
        assertEquals(8.0, hoursFull, 0.01);

        // Làm nửa ngày 08:30 - 12:00 (3.5 tiếng, < 5h không trừ trưa)
        double hoursHalf = AttendanceService.calculateWorkHours(LocalTime.of(8, 30), LocalTime.of(12, 0));
        assertEquals(3.5, hoursHalf, 0.01);

        // Giờ null
        assertEquals(0.0, AttendanceService.calculateWorkHours(null, LocalTime.of(17, 30)));
        assertEquals(0.0, AttendanceService.calculateWorkHours(LocalTime.of(8, 30), null));
    }
}
