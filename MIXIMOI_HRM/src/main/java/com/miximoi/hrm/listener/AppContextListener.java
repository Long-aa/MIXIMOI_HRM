package com.miximoi.hrm.listener;

import com.miximoi.hrm.util.DatabaseInitializer;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Ứng dụng MIXIMOI HRM đang khởi động...");
        try {
            DatabaseInitializer.initialize();
        } catch (Exception e) {
            System.err.println("[AppContextListener] Lỗi khởi tạo cơ sở dữ liệu: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Ứng dụng MIXIMOI HRM đã tắt.");
    }
}
