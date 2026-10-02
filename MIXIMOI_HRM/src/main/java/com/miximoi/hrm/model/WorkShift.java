package com.miximoi.hrm.model;

import java.time.LocalTime;

/**
 * Model ca làm việc (Work Shift).
 */
public class WorkShift {
    private int id;
    private String name;
    private LocalTime startTime;
    private LocalTime endTime;
    private double standardHours;
    private String description;

    public WorkShift() {
        this.standardHours = 8.0;
    }

    public WorkShift(int id, String name, LocalTime startTime, LocalTime endTime, double standardHours, String description) {
        this.id = id;
        this.name = name;
        this.startTime = startTime;
        this.endTime = endTime;
        this.standardHours = standardHours;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

    public double getStandardHours() { return standardHours; }
    public void setStandardHours(double standardHours) { this.standardHours = standardHours; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getTimeRangeFormatted() {
        String s = (startTime != null) ? startTime.toString() : "08:30";
        String e = (endTime != null) ? endTime.toString() : "17:30";
        if (s.length() > 5) s = s.substring(0, 5);
        if (e.length() > 5) e = e.substring(0, 5);
        return s + " - " + e;
    }

    @Override
    public String toString() {
        return "WorkShift{id=" + id + ", name='" + name + "', timeRange='" + getTimeRangeFormatted() + "'}";
    }
}
