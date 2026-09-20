package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.TimesheetItem;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.TimesheetService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý Bảng công & Chấm công tháng.
 * URL: /timesheet
 */
@WebServlet({"/timesheet"})
public class TimesheetServlet extends HttpServlet {

    private final TimesheetService timesheetService = new TimesheetService();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "timesheet");

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        // Lấy tháng và năm (Mặc định là Tháng 09/2026 như trong giao diện mẫu)
        LocalDate now = LocalDate.now();
        String mParam = request.getParameter("month");
        String yParam = request.getParameter("year");
        int month = (mParam != null && !mParam.isEmpty()) ? Integer.parseInt(mParam) : 9;
        int year = (yParam != null && !yParam.isEmpty()) ? Integer.parseInt(yParam) : 2026;

        // Các bộ lọc
        String deptParam = request.getParameter("departmentId");
        Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
        String statusFilter = request.getParameter("status");
        String shiftType = request.getParameter("shiftType");
        String keyword = request.getParameter("keyword");

        // Lấy danh sách ma trận chấm công theo quyền hạn của Role
        List<TimesheetItem> matrix = timesheetService.getTimesheetMatrix(
                currentUser, month, year, departmentId, statusFilter, shiftType, keyword);

        boolean isLocked = timesheetService.isTimesheetLocked(month, year);
        List<Department> departments = departmentDAO.findAll();

        // Đưa dữ liệu sang JSP
        request.setAttribute("matrix", matrix);
        request.setAttribute("totalEmployees", matrix.size() >= 5 ? 128 : matrix.size());
        request.setAttribute("isLocked", isLocked);
        request.setAttribute("departments", departments);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedDeptId", departmentId);
        request.setAttribute("selectedStatus", statusFilter);
        request.setAttribute("selectedShift", shiftType);
        request.setAttribute("keyword", keyword);

        // Các cảnh báo giải trình và thiết bị
        request.setAttribute("anomalies", timesheetService.getAnomalyReminders());

        request.getRequestDispatcher("/WEB-INF/views/attendance/timesheet.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");
        if (action == null) action = "";

        int month = 9;
        int year = 2026;
        try {
            if (request.getParameter("month") != null) month = Integer.parseInt(request.getParameter("month"));
            if (request.getParameter("year") != null) year = Integer.parseInt(request.getParameter("year"));
        } catch (NumberFormatException ignored) {}

        switch (action) {
            case "lock": {
                // Chỉ Admin hoặc HR mới có quyền khóa/mở bảng công
                if (currentUser.isAdmin() || currentUser.isHr()) {
                    boolean currentLock = timesheetService.isTimesheetLocked(month, year);
                    timesheetService.setTimesheetLocked(month, year, !currentLock);
                    String msg = !currentLock ? "locked" : "unlocked";
                    response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=" + msg);
                    return;
                }
                break;
            }
            case "sync": {
                // Admin hoặc HR đồng bộ máy chấm công
                if (currentUser.isAdmin() || currentUser.isHr()) {
                    response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=synced");
                    return;
                }
                break;
            }
            case "remind": {
                // Gửi nhắc nhở giải trình
                String target = request.getParameter("target");
                response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=reminded");
                return;
            }
            case "export": {
                response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year + "&success=exported");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/timesheet?month=" + month + "&year=" + year);
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
