package com.miximoi.hrm.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ValidationUtilTest {

    @Test
    @DisplayName("Kiểm tra chuỗi không rỗng")
    public void testIsNotBlank() {
        assertTrue(ValidationUtil.isNotBlank("Nguyễn Văn An"));
        assertFalse(ValidationUtil.isNotBlank(""));
        assertFalse(ValidationUtil.isNotBlank("   "));
        assertFalse(ValidationUtil.isNotBlank(null));
    }

    @Test
    @DisplayName("Kiểm tra định dạng email")
    public void testIsValidEmail() {
        assertTrue(ValidationUtil.isValidEmail("an.nv@miximoi.vn"));
        assertTrue(ValidationUtil.isValidEmail("admin@gmail.com"));
        assertFalse(ValidationUtil.isValidEmail("invalid-email"));
        assertFalse(ValidationUtil.isValidEmail("@miximoi.vn"));
        assertFalse(ValidationUtil.isValidEmail(null));
    }

    @Test
    @DisplayName("Kiểm tra định dạng số điện thoại Việt Nam")
    public void testIsValidPhone() {
        assertTrue(ValidationUtil.isValidPhone("0901234567"));
        assertTrue(ValidationUtil.isValidPhone("0389998888"));
        assertTrue(ValidationUtil.isValidPhone("0765432109"));
        assertFalse(ValidationUtil.isValidPhone("0123456789")); // Đầu số cũ 11 số / sai đầu số
        assertFalse(ValidationUtil.isValidPhone("090123456"));   // Thiếu số
        assertFalse(ValidationUtil.isValidPhone("09012345678")); // Thừa số
        assertFalse(ValidationUtil.isValidPhone("abc0901234"));
        assertFalse(ValidationUtil.isValidPhone(null));
    }

    @Test
    @DisplayName("Kiểm tra số dương và không âm")
    public void testNumberValidations() {
        assertTrue(ValidationUtil.isPositive(15000000.0));
        assertFalse(ValidationUtil.isPositive(0.0));
        assertFalse(ValidationUtil.isPositive(-5.0));

        assertTrue(ValidationUtil.isNonNegative(0.0));
        assertTrue(ValidationUtil.isNonNegative(100.0));
        assertFalse(ValidationUtil.isNonNegative(-0.01));
    }
}
