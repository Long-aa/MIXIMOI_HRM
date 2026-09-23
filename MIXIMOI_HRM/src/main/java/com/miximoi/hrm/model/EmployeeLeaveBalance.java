package com.miximoi.hrm.model;

import java.time.LocalDate;

/**
 * Model biểu diễn số dư và hạn mức phép năm của nhân viên theo Bộ luật Lao động 2019.
 */
public class EmployeeLeaveBalance {

    private int employeeId;
    private String employeeCode;
    private String fullName;
    private String departmentName;
    private String positionName;
    private LocalDate startDate;
    private int yearsOfService;
    private double standardDays = 12.0;
    private double seniorityDays = 0.0;
    private double carryOverDays = 0.0;
    private double usedDays = 0.0;
    private double availableDays = 12.0;

    public EmployeeLeaveBalance() {}

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public int getYearsOfService() { return yearsOfService; }
    public void setYearsOfService(int yearsOfService) { this.yearsOfService = yearsOfService; }

    public double getStandardDays() { return standardDays; }
    public void setStandardDays(double standardDays) { this.standardDays = standardDays; }

    public double getSeniorityDays() { return seniorityDays; }
    public void setSeniorityDays(double seniorityDays) { this.seniorityDays = seniorityDays; }

    public double getCarryOverDays() { return carryOverDays; }
    public void setCarryOverDays(double carryOverDays) { this.carryOverDays = carryOverDays; }

    public double getUsedDays() { return usedDays; }
    public void setUsedDays(double usedDays) { this.usedDays = usedDays; }

    public double getAvailableDays() { return availableDays; }
    public void setAvailableDays(double availableDays) { this.availableDays = availableDays; }
}
