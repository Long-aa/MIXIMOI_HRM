package com.miximoi.hrm.model;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

/**
 * DTO chứa 4 chỉ số KPI tổng hợp của Bảng công (/timesheet) được tính toán đồng bộ theo kỳ công và bộ lọc.
 */
public class TimesheetKpiStats {

    private int standardWorkDays;             // Số ngày công chuẩn trong kỳ (loại trừ T7, CN)
    private int standardWorkHours;            // Số giờ chuẩn (standardWorkDays * 8)
    private double attendanceRate;            // Tỷ lệ đi làm đủ (%)

    private double totalActualHours;          // Tổng số giờ làm việc thực tế
    private String totalActualHoursFormatted; // Định dạng có dấu phẩy (vd: 43,120 hoặc 3,520)
    private double avgDailyHoursPerEmp;       // Giờ làm trung bình (vd: 7.9h)
    private String prevMonthCompare;          // So sánh kỳ trước (vd: "+3.4% vs T09")

    private int lateEarlyCount;               // Tổng số lượt đi muộn / về sớm
    private int lateEmployeesCount;           // Số nhân sự bị vi phạm
    private String lateCompareText;           // Mô tả so sánh

    private double totalLeaveAndAbsentDays;   // Tổng số ngày nghỉ / vắng
    private double paidLeaveDays;             // Nghỉ phép năm có hưởng lương (P)
    private double unpaidAbsentDays;          // Nghỉ không lương / vắng mặt (V)

    public TimesheetKpiStats() {
        this.standardWorkDays = 22;
        this.standardWorkHours = 176;
        this.attendanceRate = 96.8;
        this.totalActualHours = 0;
        this.avgDailyHoursPerEmp = 8.0;
        this.prevMonthCompare = "vs tháng trước";
        this.lateCompareText = "so với tháng trước";
    }

    // Getters and Setters

    public int getStandardWorkDays() { return standardWorkDays; }
    public void setStandardWorkDays(int standardWorkDays) { this.standardWorkDays = standardWorkDays; }

    public int getStandardWorkHours() { return standardWorkHours; }
    public void setStandardWorkHours(int standardWorkHours) { this.standardWorkHours = standardWorkHours; }

    public double getAttendanceRate() { return attendanceRate; }
    public void setAttendanceRate(double attendanceRate) { this.attendanceRate = attendanceRate; }

    public double getTotalActualHours() { return totalActualHours; }
    public void setTotalActualHours(double totalActualHours) {
        this.totalActualHours = totalActualHours;
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.US);
        symbols.setGroupingSeparator(',');
        DecimalFormat df = new DecimalFormat("#,##0.#", symbols);
        this.totalActualHoursFormatted = df.format(totalActualHours);
    }

    public String getTotalActualHoursFormatted() {
        if (totalActualHoursFormatted == null) {
            setTotalActualHours(totalActualHours);
        }
        return totalActualHoursFormatted;
    }

    public double getAvgDailyHoursPerEmp() { return avgDailyHoursPerEmp; }
    public void setAvgDailyHoursPerEmp(double avgDailyHoursPerEmp) { this.avgDailyHoursPerEmp = avgDailyHoursPerEmp; }

    public String getPrevMonthCompare() { return prevMonthCompare; }
    public void setPrevMonthCompare(String prevMonthCompare) { this.prevMonthCompare = prevMonthCompare; }

    public int getLateEarlyCount() { return lateEarlyCount; }
    public void setLateEarlyCount(int lateEarlyCount) { this.lateEarlyCount = lateEarlyCount; }

    public int getLateEmployeesCount() { return lateEmployeesCount; }
    public void setLateEmployeesCount(int lateEmployeesCount) { this.lateEmployeesCount = lateEmployeesCount; }

    public String getLateCompareText() { return lateCompareText; }
    public void setLateCompareText(String lateCompareText) { this.lateCompareText = lateCompareText; }

    public double getTotalLeaveAndAbsentDays() { return totalLeaveAndAbsentDays; }
    public void setTotalLeaveAndAbsentDays(double totalLeaveAndAbsentDays) { this.totalLeaveAndAbsentDays = totalLeaveAndAbsentDays; }

    public double getPaidLeaveDays() { return paidLeaveDays; }
    public void setPaidLeaveDays(double paidLeaveDays) { this.paidLeaveDays = paidLeaveDays; }

    public double getUnpaidAbsentDays() { return unpaidAbsentDays; }
    public void setUnpaidAbsentDays(double unpaidAbsentDays) { this.unpaidAbsentDays = unpaidAbsentDays; }
}
