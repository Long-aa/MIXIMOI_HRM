package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.util.ValidationUtil;

import java.util.List;

/**
 * Service xử lý nghiệp vụ liên quan đến Employee.
 */
public class EmployeeService {

    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    public List<Employee> getAllEmployees() {
        return employeeDAO.findAll();
    }

    public Employee getById(int id) {
        return employeeDAO.findById(id);
    }

    public List<Employee> search(String keyword, Integer departmentId, String status) {
        return employeeDAO.search(keyword, departmentId, status);
    }

    public int countActive() {
        return employeeDAO.countActive();
    }

    /**
     * Thêm nhân viên mới với validate nghiệp vụ.
     *
     * @return null nếu thành công, chuỗi lỗi nếu thất bại
     */
    public String addEmployee(Employee emp) {
        if (!ValidationUtil.isNotBlank(emp.getFullName()))
            return "Họ tên không được để trống.";
        if (!ValidationUtil.isNotBlank(emp.getEmployeeCode()))
            return "Mã nhân viên không được để trống.";
        if (emp.getEmail() != null && !emp.getEmail().isEmpty()
                && !ValidationUtil.isValidEmail(emp.getEmail()))
            return "Email không hợp lệ.";
        if (emp.getPhone() != null && !emp.getPhone().isEmpty()
                && !ValidationUtil.isValidPhone(emp.getPhone()))
            return "Số điện thoại không hợp lệ (10 số, bắt đầu 03/05/07/08/09).";
        if (emp.getDepartmentId() <= 0)
            return "Vui lòng chọn phòng ban.";
        if (emp.getPositionId() <= 0)
            return "Vui lòng chọn chức vụ.";

        boolean ok = employeeDAO.insert(emp);
        return ok ? null : "Lỗi khi thêm nhân viên. Có thể mã nhân viên đã tồn tại.";
    }

    /**
     * Cập nhật thông tin nhân viên.
     *
     * @return null nếu thành công, chuỗi lỗi nếu thất bại
     */
    public String updateEmployee(Employee emp) {
        if (!ValidationUtil.isNotBlank(emp.getFullName()))
            return "Họ tên không được để trống.";
        if (emp.getEmail() != null && !emp.getEmail().isEmpty()
                && !ValidationUtil.isValidEmail(emp.getEmail()))
            return "Email không hợp lệ.";
        if (emp.getPhone() != null && !emp.getPhone().isEmpty()
                && !ValidationUtil.isValidPhone(emp.getPhone()))
            return "Số điện thoại không hợp lệ.";

        boolean ok = employeeDAO.update(emp);
        return ok ? null : "Lỗi khi cập nhật nhân viên.";
    }

    /**
     * Vô hiệu hóa nhân viên (xóa mềm).
     */
    public boolean deactivate(int id) {
        return employeeDAO.deactivate(id);
    }
}
