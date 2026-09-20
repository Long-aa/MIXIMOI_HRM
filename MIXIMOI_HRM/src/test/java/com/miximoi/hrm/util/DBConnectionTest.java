package com.miximoi.hrm.util;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class DBConnectionTest {

    @Test
    public void testGetConnection() throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            assertNotNull(conn, "Connection không được null");
            assertFalse(conn.isClosed(), "Connection phải đang mở");
        }
    }

    @Test
    public void testQueryEmployees() {
        EmployeeDAO employeeDAO = new EmployeeDAO();
        List<Employee> list = employeeDAO.findAll();
        assertNotNull(list, "Danh sách nhân viên không null");
        assertTrue(list.size() > 0, "Phải có ít nhất 1 nhân viên mẫu");
        System.out.println("Đã tải thành công " + list.size() + " nhân viên từ PostgreSQL!");
    }

    @Test
    public void testTableCounts() throws Exception {
        DatabaseInitializer.initialize();
        try (Connection conn = DBConnection.getConnection();
             java.sql.Statement st = conn.createStatement()) {
            String[] tables = {"attendance", "leave_requests", "overtime", "departments", "employees", "contracts"};
            for (String t : tables) {
                try (java.sql.ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM " + t)) {
                    if (rs.next()) {
                        System.out.println("Bảng " + t + ": " + rs.getInt(1) + " dòng");
                    }
                } catch (Exception ex) {
                    System.out.println("Bảng " + t + " lỗi: " + ex.getMessage());
                }
            }
        }
    }
}

