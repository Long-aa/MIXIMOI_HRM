package com.miximoi.hrm.model;

import java.util.HashMap;
import java.util.Map;

/**
 * DTO biểu diễn một dòng nhân sự trong Ma trận Chấm công chi tiết (/timesheet).
 */
public class TimesheetItem {

    private int employeeId;
    private String employeeCode;
    private String employeeName;
    private String avatar;
    private String positionName;
    private int departmentId;
    private String departmentName;

    // Trạng thái từng ngày trong tháng: Key là ngày (1..31), Value là mã ký hiệu ("1.0", "0.5", "P", "M", "V", "CT", "O")
    private Map<Integer, String> dayStatuses = new HashMap<>();

    private double actualWorkDays;      // CÔNG TT (vd: 22.0)
    private double otHours;             // GIỜ OT (vd: 8.5)
    private int lateEarlyMinutes;       // TRỄ / SỚM (vd: 18)
    private String leaveDaysDisplay;    // NGHỈ PHÉP (vd: "0", "2.0", "0.5", "1.0 (V)")
    private String status;              // APPROVED_LOCK | PENDING_CONFIRM | UNEXPLAINED
    private String notes;

    public TimesheetItem() {
        this.actualWorkDays = 22.0;
        this.otHours = 0;
        this.lateEarlyMinutes = 0;
        this.leaveDaysDisplay = "0";
        this.status = "APPROVED_LOCK";
    }

    // ===== Getters & Setters =====

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public Map<Integer, String> getDayStatuses() { return dayStatuses; }
    public void setDayStatuses(Map<Integer, String> dayStatuses) { this.dayStatuses = dayStatuses; }

    public void setDayStatus(int day, String code) {
        this.dayStatuses.put(day, code);
    }

    public String getDayStatus(int day) {
        return dayStatuses.getOrDefault(day, "1.0");
    }

    public double getActualWorkDays() { return actualWorkDays; }
    public void setActualWorkDays(double actualWorkDays) { this.actualWorkDays = actualWorkDays; }

    public double getOtHours() { return otHours; }
    public void setOtHours(double otHours) { this.otHours = otHours; }

    public int getLateEarlyMinutes() { return lateEarlyMinutes; }
    public void setLateEarlyMinutes(int lateEarlyMinutes) { this.lateEarlyMinutes = lateEarlyMinutes; }

    public String getLeaveDaysDisplay() { return leaveDaysDisplay; }
    public void setLeaveDaysDisplay(String leaveDaysDisplay) { this.leaveDaysDisplay = leaveDaysDisplay; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    // ===== Helper Methods for Matrix Badges =====

    public String getStatusBadgeClass() {
        if ("APPROVED_LOCK".equalsIgnoreCase(status) || "LOCKED".equalsIgnoreCase(status)) {
            return "badge-status-locked"; // Đã duyệt chốt - xanh dương đậm
        } else if ("PENDING_CONFIRM".equalsIgnoreCase(status) || "PENDING".equalsIgnoreCase(status)) {
            return "badge-status-pending"; // Chờ xác nhận - xanh dương nhạt
        } else {
            return "badge-status-anomaly"; // Chưa giải trình - đỏ cam
        }
    }

    public String getStatusDisplay() {
        if ("APPROVED_LOCK".equalsIgnoreCase(status) || "LOCKED".equalsIgnoreCase(status)) {
            return "Đã duyệt chốt";
        } else if ("PENDING_CONFIRM".equalsIgnoreCase(status) || "PENDING".equalsIgnoreCase(status)) {
            return "Chờ xác nhận";
        } else {
            return "Chưa giải trình";
        }
    }

    /**
     * Trả về CSS class tương ứng với ký hiệu chấm công:
     * 1.0 -> Đủ công (xanh dương)
     * 0.5 -> Nửa công (tím)
     * P -> Phép năm có lương (xanh dương sáng)
     * M -> Đi muộn / Về sớm (cam đỏ)
     * V -> Vắng không phép (đỏ đậm)
     * CT -> Công tác (xanh đậm)
     * O -> Nghỉ tuần T7-CN (xám)
     */
    public static String getBadgeClassForCode(String code) {
        if (code == null) return "matrix-cell-empty";
        switch (code.trim()) {
            case "1.0":
            case "1":
                return "cell-code-full";      // 1.0
            case "0.5":
            case "1/2":
            case "½":
                return "cell-code-half";      // ½
            case "P":
                return "cell-code-leave";     // P
            case "M":
                return "cell-code-late";      // M
            case "V":
                return "cell-code-absent";    // V
            case "CT":
                return "cell-code-mission";   // CT
            case "O":
                return "cell-code-weekend";   // O
            default:
                return "cell-code-default";
        }
    }
}
