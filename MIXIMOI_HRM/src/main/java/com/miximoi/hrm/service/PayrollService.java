package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.AllowanceDAO;
import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.BonusDAO;
import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.OvertimeDAO;
import com.miximoi.hrm.dao.PaymentDAO;
import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.dao.SalaryConfigDAO;
import com.miximoi.hrm.dao.SalaryDeductionDAO;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Overtime;
import com.miximoi.hrm.model.Payment;
import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

/**
 * Service xử lý nghiệp vụ tính lương chuẩn HRM Việt Nam.
 *
 * Công thức:
 *   Gross = (Lương cơ bản / Ngày chuẩn × Ngày công) + OT + Phụ cấp + Thưởng
 *   Khấu trừ BH = BHXH (8%) + BHYT (1.5%) + BHTN (1%)  -- áp dụng trần đóng BH
 *   Thu nhập chịu thuế = Gross - Khấu trừ BH - Giảm trừ gia cảnh - Tạm ứng
 *   Thuế TNCN = Tính lũy tiến 7 bậc
 *   Net = Gross - Khấu trừ BH - Thuế TNCN - Tạm ứng
 */
public class PayrollService {

    private final PayrollDAO         payrollDAO      = new PayrollDAO();
    private final AttendanceDAO      attendanceDAO   = new AttendanceDAO();
    private final OvertimeDAO        overtimeDAO     = new OvertimeDAO();
    private final EmployeeDAO        employeeDAO     = new EmployeeDAO();
    private final ContractDAO        contractDAO     = new ContractDAO();
    private final AllowanceDAO       allowanceDAO    = new AllowanceDAO();
    private final BonusDAO           bonusDAO        = new BonusDAO();
    private final SalaryDeductionDAO deductionDAO    = new SalaryDeductionDAO();
    private final SalaryConfigDAO    configDAO       = new SalaryConfigDAO();
    private final PaymentDAO         paymentDAO      = new PaymentDAO();

    // Hằng số fallback (khi bảng salary_configs chưa có dữ liệu)
    private static final double BHXH_RATE_DEFAULT  = 0.08;
    private static final double BHYT_RATE_DEFAULT  = 0.015;
    private static final double BHTN_RATE_DEFAULT  = 0.01;
    private static final BigDecimal INSURANCE_CEILING_DEFAULT = new BigDecimal("46800000");
    private static final BigDecimal PERSONAL_REDUCTION_DEFAULT = new BigDecimal("11000000");
    private static final BigDecimal DEPENDENT_REDUCTION_DEFAULT = new BigDecimal("4400000");

    /**
     * Tính lương cho tất cả nhân viên trong một kỳ.
     * Nếu nhân viên đã có bản DRAFT trong kỳ thì xóa và tính lại.
     *
     * @param month       tháng tính lương
     * @param year        năm tính lương
     * @param createdById người tạo bảng lương
     * @return số nhân viên đã tính lương
     */
    public int calculatePayrollForPeriod(int month, int year, int createdById) {
        // Xóa các bản DRAFT cũ để tính lại
        payrollDAO.deleteByPeriod(month, year);

        List<Employee> employees = employeeDAO.findAll();
        int count = 0;
        for (Employee emp : employees) {
            Payroll pr = calculateForEmployee(emp, month, year, createdById);
            if (payrollDAO.insert(pr)) count++;
        }
        return count;
    }

    /** Tính lương chi tiết cho 1 nhân viên */
    public Payroll calculateForEmployee(Employee emp, int month, int year, int createdById) {
        // === 1. Đọc cấu hình từ DB ===
        double bhxhRate    = configDAO.getDoubleByKey("bhxh_rate", BHXH_RATE_DEFAULT);
        double bhytRate    = configDAO.getDoubleByKey("bhyt_rate", BHYT_RATE_DEFAULT);
        double bhtnRate    = configDAO.getDoubleByKey("bhtn_rate", BHTN_RATE_DEFAULT);
        BigDecimal insuranceCeiling  = configDAO.getBigDecimalByKey("insurance_ceiling",  INSURANCE_CEILING_DEFAULT);
        BigDecimal personalReduction = configDAO.getBigDecimalByKey("personal_reduction", PERSONAL_REDUCTION_DEFAULT);

        // === 2. Ngày công ===
        YearMonth ym          = YearMonth.of(year, month);
        double standardDays   = getStandardWorkingDays(ym);
        double actualDays     = attendanceDAO.countWorkingDays(emp.getId(), month, year);
        // Nếu chưa có dữ liệu chấm công → mặc định làm đủ ngày chuẩn
        if (actualDays <= 0) actualDays = standardDays;

        // === 3. Lương cơ bản từ hợp đồng ===
        BigDecimal baseSalary = getBaseSalary(emp.getId());

        // === 4. Lương thời gian ===
        BigDecimal earnedSalary = standardDays > 0
                ? baseSalary.multiply(BigDecimal.valueOf(actualDays))
                             .divide(BigDecimal.valueOf(standardDays), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // === 5. Tiền tăng ca (OT đã duyệt) ===
        BigDecimal overtimeAmount = sumOvertimeAmount(emp.getId(), month, year);

        // === 6. Phụ cấp active trong tháng (từ bảng allowances) ===
        BigDecimal allowance = allowanceDAO.sumActiveByEmployee(emp.getId(), month, year);

        // === 7. Thưởng trong tháng (từ bảng bonuses) ===
        BigDecimal bonus = bonusDAO.sumByEmployeeAndPeriod(emp.getId(), month, year);

        // === 8. Gross Income ===
        BigDecimal grossIncome = earnedSalary.add(overtimeAmount).add(allowance).add(bonus);

        // === 9. Trích nộp BH bắt buộc (áp dụng trần đóng) ===
        // Căn cứ tính BH là lương theo hợp đồng (baseSalary), không vượt trần
        BigDecimal bhBase = baseSalary.min(insuranceCeiling);
        BigDecimal bhxh   = bhBase.multiply(BigDecimal.valueOf(bhxhRate)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal bhyt   = bhBase.multiply(BigDecimal.valueOf(bhytRate)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal bhtn   = bhBase.multiply(BigDecimal.valueOf(bhtnRate)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal totalInsurance = bhxh.add(bhyt).add(bhtn);

        // === 10. Tạm ứng & khoản khấu trừ thêm ===
        BigDecimal advanceDeduction = deductionDAO.sumByEmployeeAndPeriod(emp.getId(), month, year);

        // === 11. Thu nhập chịu thuế TNCN ===
        BigDecimal taxableIncome = grossIncome
                .subtract(totalInsurance)
                .subtract(personalReduction)  // giảm trừ bản thân 11tr
                .subtract(advanceDeduction);

        // === 12. Thuế TNCN lũy tiến 7 bậc ===
        BigDecimal tncn = calculatePersonalIncomeTax(taxableIncome);

        // === 13. Tổng khấu trừ & Net Salary ===
        BigDecimal totalDeduction = totalInsurance.add(tncn).add(advanceDeduction);
        BigDecimal netSalary = grossIncome.subtract(totalDeduction);
        if (netSalary.compareTo(BigDecimal.ZERO) < 0) netSalary = BigDecimal.ZERO;

        // === 14. Tạo Payroll record ===
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
        pr.setDeduction(totalDeduction);
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

    public int approveAll(int month, int year, int approvedById) {
        return payrollDAO.approveAll(month, year, approvedById);
    }

    public boolean markAsPaid(int id, int approvedById) {
        return payrollDAO.updateStatus(id, "PAID", approvedById);
    }

    /**
     * Thực hiện thanh toán cho 1 bản ghi lương có giao dịch CSDL (Transaction & Rollback).
     * Chặn chi trả trùng và lưu bản ghi vào bảng payments.
     */
    public boolean payPayrollSingle(int payrollId, int approvedById, String paymentMethod, String notes) {
        Payroll pr = payrollDAO.findById(payrollId);
        if (pr == null) return false;
        // Chặn thanh toán trùng nếu đã PAID hoặc có giao dịch COMPLETED
        if ("PAID".equals(pr.getStatus()) || paymentDAO.existsByPayrollId(pr.getId())) {
            return false;
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Tạo bản ghi giao dịch thanh toán
                Payment payment = new Payment();
                payment.setPayrollId(pr.getId());
                payment.setEmployeeId(pr.getEmployeeId());
                payment.setAmount(pr.getNetSalary() != null ? pr.getNetSalary() : BigDecimal.ZERO);
                payment.setPaymentDate(LocalDate.now());
                payment.setPaymentMethod(paymentMethod != null && !paymentMethod.isEmpty() ? paymentMethod : "BANK_TRANSFER");
                payment.setStatus("COMPLETED");
                String memo = notes != null && !notes.trim().isEmpty() ? notes : ("Chi lương T" + pr.getPayMonth() + "/" + pr.getPayYear() + " - " + pr.getEmployeeCode());
                payment.setNotes(memo);
                paymentDAO.insertWithConnection(conn, payment);

                // 2. Cập nhật trạng thái bảng lương sang PAID
                payrollDAO.updateStatusWithConnection(conn, pr.getId(), "PAID", approvedById);

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                System.err.println("PayrollService.payPayrollSingle lỗi, đã rollback: " + e.getMessage());
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("PayrollService.payPayrollSingle lỗi kết nối DB: " + e.getMessage());
            return false;
        }
    }

    /**
     * Thực hiện thanh toán hàng loạt (Batch Disburse) tất cả bản ghi APPROVED trong kỳ.
     * Sử dụng JDBC Transaction để đảm bảo tính toàn vẹn dữ liệu.
     */
    public int batchDisburse(int month, int year, int approvedById) {
        List<Payroll> list = payrollDAO.findByPeriod(month, year);
        if (list == null || list.isEmpty()) return 0;

        int count = 0;
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Payroll pr : list) {
                    if ("APPROVED".equals(pr.getStatus()) && !paymentDAO.existsByPayrollId(pr.getId())) {
                        Payment payment = new Payment();
                        payment.setPayrollId(pr.getId());
                        payment.setEmployeeId(pr.getEmployeeId());
                        payment.setAmount(pr.getNetSalary() != null ? pr.getNetSalary() : BigDecimal.ZERO);
                        payment.setPaymentDate(LocalDate.now());
                        payment.setPaymentMethod("BANK_TRANSFER");
                        payment.setStatus("COMPLETED");
                        payment.setNotes("Chi lương tự động kỳ T" + pr.getPayMonth() + "/" + pr.getPayYear() + " qua Napas");
                        paymentDAO.insertWithConnection(conn, payment);

                        payrollDAO.updateStatusWithConnection(conn, pr.getId(), "PAID", approvedById);
                        count++;
                    }
                }
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                System.err.println("PayrollService.batchDisburse lỗi, đã rollback: " + e.getMessage());
                return 0;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("PayrollService.batchDisburse lỗi kết nối: " + e.getMessage());
            return 0;
        }
        return count;
    }

    public BigDecimal getTotalPayroll(int month, int year) {
        return payrollDAO.sumNetSalaryByPeriod(month, year);
    }

    // ========== Helpers ==========

    /** Số ngày làm việc chuẩn trong tháng (trừ T7 và CN) */
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
        BigDecimal sal = contractDAO.findActiveContractBaseSalary(employeeId);
        return sal != null ? sal : BigDecimal.ZERO;
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

    /**
     * Tính thuế TNCN lũy tiến 7 bậc (Điều 22 Luật thuế TNCN VN).
     * Thu nhập tính thuế = Thu nhập chịu thuế sau giảm trừ gia cảnh / tháng.
     *
     * Bậc 1: Đến  5.000.000đ    → 5%
     * Bậc 2: 5 – 10.000.000đ   → 10%
     * Bậc 3: 10 – 18.000.000đ  → 15%
     * Bậc 4: 18 – 32.000.000đ  → 20%
     * Bậc 5: 32 – 52.000.000đ  → 25%
     * Bậc 6: 52 – 80.000.000đ  → 30%
     * Bậc 7: Trên 80.000.000đ  → 35%
     */
    public static BigDecimal calculatePersonalIncomeTax(BigDecimal taxableIncome) {
        if (taxableIncome == null || taxableIncome.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }

        // Định nghĩa bậc thuế (ngưỡng trên, tỷ lệ)
        long[]   thresholds = { 5_000_000L, 10_000_000L, 18_000_000L, 32_000_000L, 52_000_000L, 80_000_000L };
        double[] rates      = { 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35 };

        BigDecimal tax = BigDecimal.ZERO;
        BigDecimal remaining = taxableIncome;
        long prevThreshold = 0;

        for (int i = 0; i < thresholds.length; i++) {
            BigDecimal bracketSize = BigDecimal.valueOf(thresholds[i] - prevThreshold);
            if (remaining.compareTo(BigDecimal.ZERO) <= 0) break;
            BigDecimal taxable = remaining.min(bracketSize);
            tax = tax.add(taxable.multiply(BigDecimal.valueOf(rates[i])));
            remaining = remaining.subtract(bracketSize);
            prevThreshold = thresholds[i];
        }
        // Bậc 7: phần còn lại
        if (remaining.compareTo(BigDecimal.ZERO) > 0) {
            tax = tax.add(remaining.multiply(BigDecimal.valueOf(0.35)));
        }

        return tax.setScale(0, RoundingMode.HALF_UP);
    }
}
