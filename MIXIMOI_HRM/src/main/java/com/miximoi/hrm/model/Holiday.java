package com.miximoi.hrm.model;

import java.time.LocalDate;

/**
 * Model Holiday — Danh mục ngày nghỉ lễ/Tết quốc gia theo Luật Lao Động.
 */
public class Holiday {
    private int id;
    private LocalDate holidayDate;
    private String name;
    private int year;
    private double coefficient; // Hệ số lương đi làm ngày lễ (mặc định 3.0x = 300%)

    public Holiday() {
        this.coefficient = 3.0;
    }

    public Holiday(LocalDate holidayDate, String name, int year, double coefficient) {
        this.holidayDate = holidayDate;
        this.name = name;
        this.year = year;
        this.coefficient = coefficient;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDate getHolidayDate() { return holidayDate; }
    public void setHolidayDate(LocalDate holidayDate) { this.holidayDate = holidayDate; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public double getCoefficient() { return coefficient; }
    public void setCoefficient(double coefficient) { this.coefficient = coefficient; }
}
