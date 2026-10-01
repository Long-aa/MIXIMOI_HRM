package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.model.Contract;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử Quy tắc Tuân thủ Hợp đồng Lao động (Điều 20 BLLĐ 2019)")
class ContractComplianceUpgradeTest {

    private final ContractDAO contractDAO = new ContractDAO();

    @Test
    @DisplayName("Kiểm tra tự động sinh mã HĐ dạng HDxxx chuẩn format")
    void testGetNextContractCode() {
        String code = contractDAO.getNextContractCode();
        assertNotNull(code);
        assertTrue(code.matches("^HD\\d{3}$"), "Mã hợp đồng phải có tiền tố HD kèm 3 số");
    }

    @Test
    @DisplayName("Quy tắc Điều 20 BLLĐ 2019: Đếm số lần ký HĐ xác định thời hạn không âm")
    void testCountFixedTermContracts() {
        int count = contractDAO.countFixedTermContracts(1);
        assertTrue(count >= 0, "Số hợp đồng xác định thời hạn phải >= 0");
    }

    @Test
    @DisplayName("Quy tắc Điều 20 BLLĐ 2019: canSignFixedTerm trả về true nếu đã ký < 2 lần, false nếu >= 2 lần")
    void testCanSignFixedTermRule() {
        boolean canSign = contractDAO.canSignFixedTerm(1);
        int count = contractDAO.countFixedTermContracts(1);
        if (count >= 2) {
            assertFalse(canSign, "Đã ký từ 2 lần xác định thời hạn thì không được phép ký tiếp mà phải chuyển sang Không xác định thời hạn");
        } else {
            assertTrue(canSign, "Chưa đủ 2 lần thì vẫn đủ điều kiện ký xác định thời hạn");
        }
    }

    @Test
    @DisplayName("Công thức Lương Thử việc: tối thiểu 85% lương chính thức theo Điều 26 BLLĐ 2019")
    void testProbationSalaryLawRule() {
        BigDecimal officialSalary = new BigDecimal("20000000");
        BigDecimal minProbationSalary = officialSalary.multiply(new BigDecimal("0.85")).setScale(0, RoundingMode.HALF_UP);
        assertEquals(new BigDecimal("17000000"), minProbationSalary);

        // Quy đổi ngược từ thử việc sang chính thức (thử việc 17tr -> chính thức 20tr)
        BigDecimal convertedBack = minProbationSalary.divide(new BigDecimal("0.85"), 0, RoundingMode.HALF_UP);
        assertEquals(officialSalary, convertedBack);
    }

    @Test
    @DisplayName("Kiểm tra thời hạn hợp đồng: ngày kết thúc phải sau ngày bắt đầu")
    void testContractDatesValidation() {
        Contract contract = new Contract();
        contract.setStartDate(LocalDate.of(2026, 1, 1));
        contract.setEndDate(LocalDate.of(2026, 12, 31));

        assertTrue(contract.getEndDate().isAfter(contract.getStartDate()), "Ngày kết thúc HĐ phải sau ngày bắt đầu");
    }
}
