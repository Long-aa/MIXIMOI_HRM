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
    public void testQueryDepartments() {
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> list = departmentDAO.findAll();
        assertNotNull(list, "Danh sách phòng ban không null");
        assertTrue(list.size() > 0, "Phải có ít nhất 1 phòng ban");
        System.out.println("Đã tải thành công " + list.size() + " phòng ban từ PostgreSQL!");
    }
}
