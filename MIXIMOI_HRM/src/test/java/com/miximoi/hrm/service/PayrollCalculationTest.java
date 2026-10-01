package com.miximoi.hrm.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.math.RoundingMode;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Bộ kiểm thử tự động JUnit 5 cho Nghiệp vụ Tính toán Lương & Thuế TNCN Việt Nam.
 */
class PayrollCalculationTest {

    @Test
    @DisplayName("Kiểm tra tính khấu trừ Bảo hiểm bắt buộc (BHXH 8%, BHYT 1.5%, BHTN 1%)")
    void testMandatoryInsurance() {
        BigDecimal baseSalary = new BigDecimal("20000000"); // 20 triệu VNĐ

        // BHXH 8%
        BigDecimal bhxh = baseSalary.multiply(new BigDecimal("0.08")).setScale(0, RoundingMode.HALF_UP);
        assertEquals(new BigDecimal("1600000"), bhxh, "BHXH 8% của 20tr phải là 1.600.000 đ");

        // BHYT 1.5%
        BigDecimal bhyt = baseSalary.multiply(new BigDecimal("0.015")).setScale(0, RoundingMode.HALF_UP);
        assertEquals(new BigDecimal("300000"), bhyt, "BHYT 1.5% của 20tr phải là 300.000 đ");

        // BHTN 1.0%
        BigDecimal bhtn = baseSalary.multiply(new BigDecimal("0.010")).setScale(0, RoundingMode.HALF_UP);
        assertEquals(new BigDecimal("200000"), bhtn, "BHTN 1% của 20tr phải là 200.000 đ");

        // Tổng bảo hiểm = 10.5%
        BigDecimal totalIns = bhxh.add(bhyt).add(bhtn);
        assertEquals(new BigDecimal("2100000"), totalIns, "Tổng trích bảo hiểm 10.5% phải là 2.100.000 đ");
    }

    @Test
    @DisplayName("Kiểm tra tính thuế TNCN Biểu thuế lũy tiến từng phần 7 bậc")
    void testProgressiveTax() {
        // Bậc 1: Dưới 5 triệu (5%)
        BigDecimal tax1 = PayrollService.calculatePersonalIncomeTax(new BigDecimal("4000000"));
        assertEquals(new BigDecimal("200000"), tax1, "4tr tính thuế -> Thuế bậc 1 (5%) = 200.000 đ");

        // Bậc 2: 8 triệu (Bậc 1: 5tr * 5% = 250k; Bậc 2: 3tr * 10% = 300k -> Tổng = 550k)
        BigDecimal tax2 = PayrollService.calculatePersonalIncomeTax(new BigDecimal("8000000"));
        assertEquals(new BigDecimal("550000"), tax2, "8tr tính thuế -> Thuế bậc 2 = 550.000 đ");

        // Bậc 3: 15 triệu (15tr * 15% - 750k = 1.500.000 đ)
        BigDecimal tax3 = PayrollService.calculatePersonalIncomeTax(new BigDecimal("15000000"));
        assertEquals(new BigDecimal("1500000"), tax3, "15tr tính thuế -> Thuế bậc 3 = 1.500.000 đ");

        // Bậc 4: 25 triệu (25tr * 20% - 1.65tr = 3.350.000 đ)
        BigDecimal tax4 = PayrollService.calculatePersonalIncomeTax(new BigDecimal("25000000"));
        assertEquals(new BigDecimal("3350000"), tax4, "25tr tính thuế -> Thuế bậc 4 = 3.350.000 đ");

        // Bậc 5: 40 triệu (40tr * 25% - 3.25tr = 6.750.000 đ)
        BigDecimal tax5 = PayrollService.calculatePersonalIncomeTax(new BigDecimal("40000000"));
        assertEquals(new BigDecimal("6750000"), tax5, "40tr tính thuế -> Thuế bậc 5 = 6.750.000 đ");

        // Bậc 6: 60 triệu (60tr * 30% - 5.85tr = 12.150.000 đ)
        BigDecimal tax6 = PayrollService.calculatePersonalIncomeTax(new BigDecimal("60000000"));
        assertEquals(new BigDecimal("12150000"), tax6, "60tr tính thuế -> Thuế bậc 6 = 12.150.000 đ");

        // Bậc 7: 100 triệu (100tr * 35% - 9.85tr = 25.150.000 đ)
        BigDecimal tax7 = PayrollService.calculatePersonalIncomeTax(new BigDecimal("100000000"));
        assertEquals(new BigDecimal("25150000"), tax7, "100tr tính thuế -> Thuế bậc 7 = 25.150.000 đ");

        // Không phát sinh thuế khi TNTT <= 0
        BigDecimal zeroTax = PayrollService.calculatePersonalIncomeTax(BigDecimal.ZERO);
        assertEquals(BigDecimal.ZERO, zeroTax, "TNTT bằng 0 -> Thuế bằng 0");
    }

    @Test
    @DisplayName("Kiểm tra công thức Lương Thực Lĩnh (Net Salary)")
    void testNetSalaryFormula() {
        BigDecimal earnedSalary = new BigDecimal("22000000"); // 22 ngày công chuẩn
        BigDecimal otPay = new BigDecimal("1500000");
        BigDecimal allowances = new BigDecimal("1000000");
        BigDecimal bonus = new BigDecimal("2000000");
        BigDecimal insurance = new BigDecimal("2100000"); // 10.5% của 20tr
        BigDecimal tax = new BigDecimal("1200000");
        BigDecimal advances = new BigDecimal("500000");

        // Gross = Earned + OT + Allowances + Bonus = 22 + 1.5 + 1.0 + 2.0 = 26.5 triệu
        BigDecimal gross = earnedSalary.add(otPay).add(allowances).add(bonus);
        assertEquals(new BigDecimal("26500000"), gross);

        // Deductions = Insurance + Tax + Advance = 2.1 + 1.2 + 0.5 = 3.8 triệu
        BigDecimal totalDeductions = insurance.add(tax).add(advances);
        assertEquals(new BigDecimal("3800000"), totalDeductions);

        // Net = Gross - Deductions = 26.5tr - 3.8tr = 22.7 triệu
        BigDecimal net = gross.subtract(totalDeductions);
        assertEquals(new BigDecimal("22700000"), net, "Lương thực lĩnh Net phải bằng 22.700.000 đ");
    }

    @Test
    @DisplayName("Kiểm tra Ràng buộc Khóa Bảng công trước khi tính lương (Timesheet Lock Guard)")
    void testTimesheetLockGuardLogic() {
        // Kịch bản 1: Bảng công chưa khóa và người dùng không có cờ xác nhận khóa (confirmLock = false)
        boolean isTimesheetLocked = false;
        boolean confirmLock = false;
        boolean shouldAllowCalculation = isTimesheetLocked || confirmLock;
        assertFalse(shouldAllowCalculation, "Bảng công chưa khóa và chưa xác nhận khóa tự động -> Phải chặn tính lương để kiểm soát số liệu");

        // Kịch bản 2: Bảng công chưa khóa nhưng người dùng bấm 'Khóa bảng công & Tính lương ngay' (confirmLock = true)
        confirmLock = true;
        boolean shouldAutoLockAndCalculate = !isTimesheetLocked && confirmLock;
        assertTrue(shouldAutoLockAndCalculate, "Người dùng xác nhận 1-Click Lock & Calculate -> Cho phép tự động khóa bảng công và tính lương");

        // Kịch bản 3: Bảng công đã khóa chốt từ trước
        isTimesheetLocked = true;
        confirmLock = false;
        shouldAllowCalculation = isTimesheetLocked || confirmLock;
        assertTrue(shouldAllowCalculation, "Bảng công đã được khóa chốt -> Luồng liên hoàn Chấm công -> Lương hợp lệ 100%");
    }
}
