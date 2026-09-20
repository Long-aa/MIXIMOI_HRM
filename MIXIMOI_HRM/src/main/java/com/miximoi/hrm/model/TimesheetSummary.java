package com.miximoi.hrm.model;

/**
 * DTO chứa bảng tổng hợp công tháng của từng nhân viên.
 */
public class TimesheetSummary {

    private int employeeId;
    private String employeeCode;
    private String employeeName;
    private String departmentName;
    private double totalWorkDays;
    private int onTimeDays;
    private int lateDays;
    private int earlyLeaveDays;
    private int absentDays;
    private int leaveDays;
    private double totalHours;

    public TimesheetSummary() {}

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public double getTotalWorkDays() { return totalWorkDays; }
    public void setTotalWorkDays(double totalWorkDays) { this.totalWorkDays = totalWorkDays; }

    public int getOnTimeDays() { return onTimeDays; }
    public void setOnTimeDays(int onTimeDays) { this.onTimeDays = onTimeDays; }

    public int getLateDays() { return lateDays; }
    public void setLateDays(int lateDays) { this.lateDays = lateDays; }

    public int getEarlyLeaveDays() { return earlyLeaveDays; }
    public void setEarlyLeaveDays(int earlyLeaveDays) { this.earlyLeaveDays = earlyLeaveDays; }

    public int getAbsentDays() { return absentDays; }
    public void setAbsentDays(int absentDays) { this.absentDays = absentDays; }

    public int getLeaveDays() { return leaveDays; }
    public void setLeaveDays(int leaveDays) { this.leaveDays = leaveDays; }

    public double getTotalHours() { return totalHours; }
    public void setTotalHours(double totalHours) { this.totalHours = totalHours; }
}
