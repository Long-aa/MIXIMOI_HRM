package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.SalaryConfigDAO;
import com.miximoi.hrm.model.SalaryConfig;
import com.miximoi.hrm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet quản lý thiết lập thang bảng lương & quy chế chi trả.
 * URL: /salary-config
 */
@WebServlet("/salary-config")
public class SalaryConfigServlet extends HttpServlet {

    private final SalaryConfigDAO configDAO = new SalaryConfigDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        // Đọc tất cả tham số cấu hình từ DB
        List<SalaryConfig> configs = configDAO.getAllConfigs();

        // Đọc từng tham số quan trọng để hiển thị card nhanh
        String baseSalaryStr     = configDAO.getByKey("base_salary",         "2340000");
        String personalReduction = configDAO.getByKey("personal_reduction",  "11000000");
        String dependentReduction= configDAO.getByKey("dependent_reduction", "4400000");
        String bhxhRate          = configDAO.getByKey("bhxh_rate",           "0.08");
        String bhytRate          = configDAO.getByKey("bhyt_rate",           "0.015");
        String bhtnRate          = configDAO.getByKey("bhtn_rate",           "0.01");
        String bhCeiling         = configDAO.getByKey("insurance_ceiling",   "46800000");

        request.setAttribute("activeMenu",         "salary-config");
        request.setAttribute("configs",            configs);
        request.setAttribute("baseSalary",         baseSalaryStr);
        request.setAttribute("personalReduction",  personalReduction);
        request.setAttribute("dependentReduction", dependentReduction);
        request.setAttribute("bhxhRate",           bhxhRate);
        request.setAttribute("bhytRate",           bhytRate);
        request.setAttribute("bhtnRate",           bhtnRate);
        request.setAttribute("bhCeiling",          bhCeiling);

        String success = request.getParameter("success");
        if (success != null) request.setAttribute("successMsg", success);

        request.getRequestDispatcher("/WEB-INF/views/payroll/salary-config.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        // Cho phép ADMIN cập nhật bất kỳ config_key nào
        String[] keys = {
            "base_salary", "personal_reduction", "dependent_reduction",
            "bhxh_rate", "bhyt_rate", "bhtn_rate", "insurance_ceiling"
        };

        boolean updated = false;
        for (String key : keys) {
            String val = request.getParameter(key);
            if (val != null && !val.trim().isEmpty()) {
                // Làm sạch: nếu là số tiền (có dấu chấm/phẩy), loại bỏ dấu phân cách ngàn
                String cleanVal = val.trim().replaceAll(",", "").replaceAll("\\.", "");
                // Nhưng nếu có dạng 0.08 (tỷ lệ) giữ nguyên dấu thập phân
                if (val.trim().matches("0\\.\\d+")) cleanVal = val.trim();
                configDAO.updateConfig(key, cleanVal);
                updated = true;
            }
        }

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/salary-config?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/salary-config");
        }
    }

    private boolean checkAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
