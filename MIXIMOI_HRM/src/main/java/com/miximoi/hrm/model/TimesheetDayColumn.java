package com.miximoi.hrm.model;

import java.io.Serializable;

/**
 * Model DTO đại diện cho một cột ngày trong Ma trận Bảng công tháng (1..daysInMonth).
 * Cho phép JSP EL truy cập thuộc tính mà không bị giới hạn reflection bởi scope servlet.
 */
public class TimesheetDayColumn implements Serializable {
    private static final long serialVersionUID = 1L;

    private int dayNumber;
    private String dayName;
    private boolean weekend;
    private boolean today;

    public TimesheetDayColumn() {}

    public TimesheetDayColumn(int dayNumber, String dayName, boolean weekend, boolean today) {
        this.dayNumber = dayNumber;
        this.dayName = dayName;
        this.weekend = weekend;
        this.today = today;
    }

    public int getDayNumber() { return dayNumber; }
    public void setDayNumber(int dayNumber) { this.dayNumber = dayNumber; }

    public String getDayDisplay() { return dayNumber < 10 ? "0" + dayNumber : String.valueOf(dayNumber); }

    public String getDayName() { return dayName; }
    public void setDayName(String dayName) { this.dayName = dayName; }

    public boolean isWeekend() { return weekend; }
    public void setWeekend(boolean weekend) { this.weekend = weekend; }

    public boolean isToday() { return today; }
    public void setToday(boolean today) { this.today = today; }
}
