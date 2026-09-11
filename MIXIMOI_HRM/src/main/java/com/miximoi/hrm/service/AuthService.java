package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.UserDAO;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.PasswordUtil;

/**
 * Service xử lý nghiệp vụ xác thực (đăng nhập / đổi mật khẩu).
 */
public class AuthService {

    private final UserDAO userDAO = new UserDAO();

    /**
     * Xác thực đăng nhập.
     *
     * @param username tên đăng nhập
     * @param password mật khẩu plain text
     * @return User nếu hợp lệ, null nếu sai thông tin
     */
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            return null;
        }
        User user = userDAO.findByUsername(username.trim());
        if (user == null) return null;
        if (!PasswordUtil.verify(password, user.getPassword())) return null;
        return user;
    }

    /**
     * Đổi mật khẩu.
     *
     * @param userId         ID user
     * @param oldPassword    mật khẩu cũ (plain text)
     * @param newPassword    mật khẩu mới (plain text)
     * @return true nếu thành công
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        User user = userDAO.findById(userId);
        if (user == null) return false;
        if (!PasswordUtil.verify(oldPassword, user.getPassword())) return false;
        if (newPassword == null || newPassword.length() < 6) return false;
        String newHash = PasswordUtil.hash(newPassword);
        return userDAO.updatePassword(userId, newHash);
    }
}
