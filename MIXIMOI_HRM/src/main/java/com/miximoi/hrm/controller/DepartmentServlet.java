package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet quản lý phòng ban.
 * URL: /departments
 *
 * Phân quyền:
 *   - Admin, HR: Toàn quyền (thêm, sửa, xóa, xem)
 *   - Manager: Chỉ xem danh sách phòng ban
 *   - Accountant, Employee: Không có quyền truy cập (redirect)
 */
@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {

    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAuth(request, response);
        if (user == null) return;

        // Chỉ Admin, HR và Manager được xem trang phòng ban
        if (!user.canAccessOrganization()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                // Chỉ Admin và HR được thêm mới
                if (!user.canManageEmployees()) {
                    response.sendRedirect(request.getContextPath() + "/departments?error=Bạn không có quyền thêm phòng ban.");
                    return;
                }
                request.getRequestDispatcher("/WEB-INF/views/department/department-form.jsp")
                       .forward(request, response);
                break;
            case "edit": {
                // Chỉ Admin và HR được chỉnh sửa
                if (!user.canManageEmployees()) {
                    response.sendRedirect(request.getContextPath() + "/departments?error=Bạn không có quyền chỉnh sửa phòng ban.");
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("department", departmentDAO.findById(id));
                request.getRequestDispatcher("/WEB-INF/views/department/department-form.jsp")
                       .forward(request, response);
                break;
            }
            default:
                request.setAttribute("departments", departmentDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/department/department-list.jsp")
                       .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAuth(request, response);
        if (user == null) return;

        // Chỉ Admin và HR được thực hiện các thao tác POST
        if (!user.canManageEmployees()) {
            response.sendRedirect(request.getContextPath() + "/departments?error=Bạn không có quyền thực hiện thao tác này.");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add": {
                Department dept = new Department();
                dept.setName(request.getParameter("name"));
                String code = request.getParameter("alias");
                if (code == null || code.trim().isEmpty()) {
                    code = request.getParameter("code");
                }
                dept.setCode(code != null && !code.trim().isEmpty() ? code.trim().toUpperCase() : null);
                dept.setDescription(request.getParameter("description"));
                departmentDAO.insert(dept);
                response.sendRedirect(request.getContextPath() + "/departments?success=added");
                break;
            }
            case "update": {
                Department dept = new Department();
                dept.setId(Integer.parseInt(request.getParameter("id")));
                dept.setName(request.getParameter("name"));
                String code = request.getParameter("alias");
                if (code == null || code.trim().isEmpty()) {
                    code = request.getParameter("code");
                }
                dept.setCode(code != null && !code.trim().isEmpty() ? code.trim().toUpperCase() : null);
                dept.setDescription(request.getParameter("description"));
                departmentDAO.update(dept);
                response.sendRedirect(request.getContextPath() + "/departments?success=updated");
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                // Kiểm tra xem phòng ban có nhân viên không (bảo vệ dữ liệu)
                Department dept = departmentDAO.findById(id);
                if (dept != null && dept.getEmployeeCount() > 0) {
                    response.sendRedirect(request.getContextPath()
                        + "/departments?error=Không thể xóa phòng ban còn nhân viên. Vui lòng chuyển nhân viên trước.");
                    return;
                }
                departmentDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/departments?success=deleted");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/departments");
        }
    }

    /**
     * Kiểm tra xác thực đăng nhập.
     * @return User nếu đã đăng nhập, null nếu chưa (đã redirect).
     */
    private User checkAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return (User) session.getAttribute("currentUser");
    }
}

