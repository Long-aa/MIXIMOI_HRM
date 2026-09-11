package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.AttendanceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * Servlet quản lý chấm công.
 * URL: /attendance
 */
@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        LocalDate now = LocalDate.now();
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.isEmpty()) ? Integer.parseInt(mStr) : now.getMonthValue();
        int year = (yStr != null && !yStr.isEmpty()) ? Integer.parseInt(yStr) : now.getYear();

        User user = (User) request.getSession().getAttribute("currentUser");
        List<Attendance> attendances;
        if ("EMPLOYEE".equals(user.getRole())) {
            attendances = attendanceService.getByEmployeeAndMonth(user.getEmployeeId(), month, year);
        } else {
            attendances = attendanceService.getByMonth(month, year);
        }

        request.setAttribute("attendances", attendances);
        request.setAttribute("employees", employeeDAO.findAll());
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);
        request.getRequestDispatcher("/WEB-INF/views/attendance/attendance-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        User user = (User) request.getSession().getAttribute("currentUser");
        int empId = user.getEmployeeId() > 0 ? user.getEmployeeId() : 1;
        String empParam = request.getParameter("employeeId");
        if (empParam != null && !empParam.isEmpty()) {
            empId = Integer.parseInt(empParam);
        }

        switch (action) {
            case "checkin": {
                attendanceService.checkIn(empId, LocalDate.now(), LocalTime.now());
                response.sendRedirect(request.getContextPath() + "/attendance?success=checkin");
                break;
            }
            case "checkout": {
                attendanceService.checkOut(empId, LocalDate.now(), LocalTime.now());
                response.sendRedirect(request.getContextPath() + "/attendance?success=checkout");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/attendance");
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
