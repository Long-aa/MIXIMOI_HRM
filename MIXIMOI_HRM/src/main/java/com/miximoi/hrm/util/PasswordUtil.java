package com.miximoi.hrm.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Tiện ích xử lý mật khẩu sử dụng BCrypt.
 */
public class PasswordUtil {

    private static final int COST = 12;

    private PasswordUtil() {}

    /**
     * Hash mật khẩu bằng BCrypt.
     *
     * @param plainPassword mật khẩu dạng plain text
     * @return chuỗi hash BCrypt
     */
    public static String hash(String plainPassword) {
        return BCrypt.withDefaults().hashToString(COST, plainPassword.toCharArray());
    }

    /**
     * Kiểm tra mật khẩu plain text có khớp với hash không.
     *
     * @param plainPassword mật khẩu người dùng nhập
     * @param hashedPassword hash lưu trong database
     * @return true nếu khớp
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        BCrypt.Result result = BCrypt.verifyer().verify(plainPassword.toCharArray(), hashedPassword);
        return result.verified;
    }
}
