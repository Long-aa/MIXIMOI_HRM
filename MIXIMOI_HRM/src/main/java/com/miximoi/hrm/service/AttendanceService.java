package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.model.Attendance;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * Service xử lý nghiệp vụ chấm công.
 */
public class AttendanceService {

    // Giờ chuẩn bắt đầu ca sáng
    private static final LocalTime STANDARD_START = LocalTime.of(8, 0);
    // Giờ chuẩn kết thúc ca sáng
    private static final LocalTime STANDARD_END   = LocalTime.of(17, 0);
    // Ngưỡng tính "đi muộn" (phút)
    private static final int LATE_THRESHOLD_MIN   = 5;

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    public List<Attendance> getByEmployeeAndMonth(int employeeId, int month, int year) {
        return attendanceDAO.findByEmployeeAndMonth(employeeId, month, year);
    }

    public List<Attendance> getByMonth(int month, int year) {
        return attendanceDAO.findByMonth(month, year);
    }

    public Attendance getByEmployeeAndDate(int employeeId, LocalDate date) {
        return attendanceDAO.findByEmployeeAndDate(employeeId, date);
    }

    /**
     * Ghi nhận chấm công: xác định trạng thái tự động.
     */
    public boolean checkIn(int employeeId, LocalDate date, LocalTime checkIn) {
        // Kiểm tra đã chấm công chưa
        if (attendanceDAO.findByEmployeeAndDate(employeeId, date) != null) return false;

        String status = determineStatus(checkIn, null);
        Attendance att = new Attendance();
        att.setEmployeeId(employeeId);
        att.setWorkDate(date);
        att.setCheckIn(checkIn);
        att.setStatus(status);
        att.setTotalHours(0);
        return attendanceDAO.insert(att);
    }

    /**
     * Cập nhật giờ ra, tính tổng giờ và cập nhật trạng thái.
     */
    public boolean checkOut(int employeeId, LocalDate date, LocalTime checkOut) {
        Attendance att = attendanceDAO.findByEmployeeAndDate(employeeId, date);
        if (att == null || att.getCheckIn() == null) return false;

        double hours = calculateHours(att.getCheckIn(), checkOut);
        att.setCheckOut(checkOut);
        att.setTotalHours(hours);
        att.setStatus(determineStatus(att.getCheckIn(), checkOut));
        return attendanceDAO.update(att);
    }

    public double countWorkingDays(int employeeId, int month, int year) {
        return attendanceDAO.countWorkingDays(employeeId, month, year);
    }

    // ===== Helpers =====

    private double calculateHours(LocalTime in, LocalTime out) {
        if (in == null || out == null) return 0;
        long minutes = java.time.Duration.between(in, out).toMinutes();
        // Trừ 60 phút nghỉ trưa nếu làm > 5 tiếng
        if (minutes > 300) minutes -= 60;
        return Math.max(0, minutes / 60.0);
    }

    private String determineStatus(LocalTime checkIn, LocalTime checkOut) {
        if (checkIn == null) return "ABSENT";
        boolean late = checkIn.isAfter(STANDARD_START.plusMinutes(LATE_THRESHOLD_MIN));
        if (checkOut == null) return late ? "LATE" : "ON_TIME";
        boolean earlyLeave = checkOut.isBefore(STANDARD_END.minusMinutes(LATE_THRESHOLD_MIN));
        if (late && earlyLeave) return "LATE";
        if (late) return "LATE";
        if (earlyLeave) return "EARLY_LEAVE";
        // Kiểm tra tăng ca
        if (checkOut.isAfter(STANDARD_END.plusMinutes(30))) return "OVERTIME";
        return "ON_TIME";
    }
}
