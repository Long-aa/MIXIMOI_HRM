package com.miximoi.hrm.util;

import java.util.regex.Pattern;

/**
 * Tiện ích xác thực dữ liệu đầu vào.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^(0[3|5|7|8|9])([0-9]{8})$");

    private ValidationUtil() {}

    /** Kiểm tra chuỗi không null và không rỗng sau khi trim */
    public static boolean isNotBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /** Kiểm tra email hợp lệ */
    public static boolean isValidEmail(String email) {
        return isNotBlank(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /** Kiểm tra số điện thoại Việt Nam hợp lệ (10 số, bắt đầu 03/05/07/08/09) */
    public static boolean isValidPhone(String phone) {
        return isNotBlank(phone) && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /** Kiểm tra độ dài tối đa của chuỗi */
    public static boolean isMaxLength(String value, int maxLength) {
        return value == null || value.length() <= maxLength;
    }

    /** Kiểm tra số dương */
    public static boolean isPositive(double value) {
        return value > 0;
    }

    /** Kiểm tra số không âm */
    public static boolean isNonNegative(double value) {
        return value >= 0;
    }
}
