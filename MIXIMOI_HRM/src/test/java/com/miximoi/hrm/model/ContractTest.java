package com.miximoi.hrm.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

public class ContractTest {

    @Test
    @DisplayName("Kiểm tra khởi tạo và các trường pháp lý HĐLĐ 2019")
    public void testContractLegalFields() {
        Contract c = new Contract();
        c.setContractCode("HD999");
        c.setEmployeeId(1);
        c.setContractType("FIXED_TERM");
        c.setStartDate(LocalDate.now());
        c.setEndDate(LocalDate.now().plusYears(1));
        c.setBaseSalary(new BigDecimal("25000000"));
        c.setStatus("ACTIVE");

        // Các trường pháp lý Bộ luật Lao động 2019
        c.setSignerName("Nguyễn Văn An");
        c.setSignerTitle("Tổng Giám Đốc");
        c.setWorkLocation("Tầng 18 MIXIMOI Tower");
        c.setJobDescription("Kỹ sư phần mềm cao cấp");
        c.setProbationMonths(2);
        c.setProbationSalaryPct(new BigDecimal("85"));
        c.setAllowanceAmount(new BigDecimal("2500000"));
        c.setIdentityNumber("001095012345");
        c.setIdentityDate(LocalDate.of(2021, 5, 10));
        c.setIdentityPlace("Cục Cảnh sát QLHC về TTXH");

        assertEquals("HD999", c.getContractCode());
        assertEquals("Nguyễn Văn An", c.getSignerName());
        assertEquals("Tổng Giám Đốc", c.getSignerTitle());
        assertEquals(2, c.getProbationMonths());
        assertEquals(new BigDecimal("85"), c.getProbationSalaryPct());
        assertEquals(new BigDecimal("2500000"), c.getAllowanceAmount());
        assertEquals("001095012345", c.getIdentityNumber());
        assertNotNull(c.getDaysRemaining());
        assertTrue(c.getDaysRemaining() >= 364);
    }
}
