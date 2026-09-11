package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.OvertimeDAO;
import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Overtime;
import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.dao.EmployeeDAO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

/**
 * Service xử lý nghiệp vụ tính lương.
 *
 * Công thức:
 *   Lương thực nhận = (Lương cơ bản / Ngày chuẩn × Ngày công)
 *                   + Tiền tăng ca
 *                   + Phụ cấp
 *                   + Thưởng
 *                   - Khấu trừ (BHXH 8% + BHYT 1.5% + BHTN 1% + Thuế TNCN)
 */
public class PayrollService {

    // Tỷ lệ khấu trừ theo quy định (cấu hình ở đây, không hard-code trong JSP)
    public static final double BHXH_RATE  = 0.08;   // 8%
    public static final double BHYT_RATE  = 0.015;  // 1.5%
    public static final double BHTN_RATE  = 0.01;   // 1%

    private final PayrollDAO    payrollDAO    = new PayrollDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final OvertimeDAO   overtimeDAO   = new OvertimeDAO();
    private final EmployeeDAO   employeeDAO   = new EmployeeDAO();

    /**
     * Tính lương cho tất cả nhân viên trong một kỳ.
     *
     * @param month      tháng
     * @param year       năm
     * @param createdById người tạo bảng lương
     * @return số nhân viên đã tính lương
     */
    public int calculatePayrollForPeriod(int month, int year, int createdById) {
        List<Employee> employees = employeeDAO.findAll();
        int count = 0;
        for (Employee emp : employees) {
            // Bỏ qua nếu đã có bảng lương trong kỳ này
            if (payrollDAO.findByEmployeeAndPeriod(emp.getId(), month, year) != null) continue;

            Payroll pr = calculateForEmployee(emp, month, year, createdById);
            if (payrollDAO.insert(pr)) count++;
        }
        return count;
    }

    /** Tính lương cho 1 nhân viên */
    public Payroll calculateForEmployee(Employee emp, int month, int year, int createdById) {
        YearMonth ym = YearMonth.of(year, month);
        double standardDays = getStandardWorkingDays(ym); // Ngày công chuẩn trong tháng
        double actualDays   = attendanceDAO.countWorkingDays(emp.getId(), month, year);

        // Lấy lương cơ bản từ hợp đồng hiện tại (giả định 0 nếu chưa có)
        BigDecimal baseSalary = getBaseSalary(emp.getId());

        // Lương theo ngày công: lương cơ bản / ngày chuẩn * ngày thực
        BigDecimal earnedSalary = standardDays > 0
                ? baseSalary.multiply(BigDecimal.valueOf(actualDays))
                            .divide(BigDecimal.valueOf(standardDays), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // Tổng tiền tăng ca
        BigDecimal overtimeAmount = sumOvertimeAmount(emp.getId(), month, year);

        // Phụ cấp và thưởng (placeholder — nhóm sẽ bổ sung từ bảng allowances/bonuses)
        BigDecimal allowance = BigDecimal.ZERO;
        BigDecimal bonus     = BigDecimal.ZERO;

        // Khấu trừ BHXH + BHYT + BHTN tính trên lương cơ bản
        BigDecimal bhxh = baseSalary.multiply(BigDecimal.valueOf(BHXH_RATE)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal bhyt = baseSalary.multiply(BigDecimal.valueOf(BHYT_RATE)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal bhtn = baseSalary.multiply(BigDecimal.valueOf(BHTN_RATE)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal deduction = bhxh.add(bhyt).add(bhtn);

        // Lương thực nhận
        BigDecimal netSalary = earnedSalary.add(overtimeAmount).add(allowance).add(bonus)
                                           .subtract(deduction);
        if (netSalary.compareTo(BigDecimal.ZERO) < 0) netSalary = BigDecimal.ZERO;

        Payroll pr = new Payroll();
        pr.setEmployeeId(emp.getId());
        pr.setPayMonth(month);
        pr.setPayYear(year);
        pr.setBaseSalary(baseSalary);
        pr.setWorkingDays(actualDays);
        pr.setStandardDays(standardDays);
        pr.setOvertimeAmount(overtimeAmount);
        pr.setAllowance(allowance);
        pr.setBonus(bonus);
        pr.setDeduction(deduction);
        pr.setNetSalary(netSalary);
        pr.setCreatedById(createdById);
        return pr;
    }

    public List<Payroll> getByPeriod(int month, int year) {
        return payrollDAO.findByPeriod(month, year);
    }

    public Payroll getById(int id) {
        return payrollDAO.findById(id);
    }

    public Payroll getByEmployeeAndPeriod(int employeeId, int month, int year) {
        return payrollDAO.findByEmployeeAndPeriod(employeeId, month, year);
    }

    public boolean approve(int id, int approvedById) {
        return payrollDAO.updateStatus(id, "APPROVED", approvedById);
    }

    public boolean markAsPaid(int id, int approvedById) {
        return payrollDAO.updateStatus(id, "PAID", approvedById);
    }

    public BigDecimal getTotalPayroll(int month, int year) {
        return payrollDAO.sumNetSalaryByPeriod(month, year);
    }

    // ===== Helpers =====

    /** Số ngày làm việc chuẩn trong tháng (trừ thứ 7, chủ nhật) */
    private double getStandardWorkingDays(YearMonth ym) {
        int count = 0;
        for (int day = 1; day <= ym.lengthOfMonth(); day++) {
            java.time.DayOfWeek dow = ym.atDay(day).getDayOfWeek();
            if (dow != java.time.DayOfWeek.SATURDAY && dow != java.time.DayOfWeek.SUNDAY) {
                count++;
            }
        }
        return count;
    }

    /** Lấy lương cơ bản từ hợp đồng active gần nhất */
    private BigDecimal getBaseSalary(int employeeId) {
        // TODO: lấy từ bảng contracts WHERE employee_id = ? AND status = 'ACTIVE' LIMIT 1
        // Placeholder trả về 0 — nhóm tích hợp ContractDAO.findActiveByEmployee()
        return BigDecimal.ZERO;
    }

    /** Tổng tiền tăng ca đã duyệt trong tháng */
    private BigDecimal sumOvertimeAmount(int employeeId, int month, int year) {
        List<Overtime> otList = overtimeDAO.findByEmployeeAndMonth(employeeId, month, year);
        BigDecimal total = BigDecimal.ZERO;
        for (Overtime ot : otList) {
            if (ot.getAmount() != null) total = total.add(ot.getAmount());
        }
        return total;
    }
}
