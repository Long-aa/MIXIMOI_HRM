package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.LeaveService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý Nghỉ phép & Nghỉ lễ.
 * URL: /leave
 */
@WebServlet("/leave")
public class LeaveServlet extends HttpServlet {

    private final LeaveService leaveService = new LeaveService();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "leave");
        User currentUser = getCurrentUser(request);

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                request.setAttribute("employees", employeeDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/leave/leave-form.jsp")
                       .forward(request, response);
                break;
            case "detail": {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("leaveRequest", leaveService.getById(id));
                request.getRequestDispatcher("/WEB-INF/views/leave/leave-detail.jsp")
                       .forward(request, response);
                break;
            }
            case "export": {
                exportLeaveRequestsCSV(request, response, currentUser);
                break;
            }
            default: {
                String status = request.getParameter("status");
                String deptParam = request.getParameter("departmentId");
                Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
                String leaveType = request.getParameter("leaveType");
                String keyword = request.getParameter("keyword");

                List<LeaveRequest> list = leaveService.getByFilters(
                        currentUser, status, departmentId, leaveType, keyword);

                List<Department> departments = departmentDAO.findAll();
                List<Employee> employees = employeeDAO.findAll();

                request.setAttribute("leaveRequests", list);
                request.setAttribute("departments", departments);
                request.setAttribute("employees", employees);
                request.setAttribute("selectedStatus", status);
                request.setAttribute("selectedDeptId", departmentId);
                request.setAttribute("selectedLeaveType", leaveType);
                request.setAttribute("keyword", keyword);

                // Dữ liệu số dư phép cá nhân
                String displayName = currentUser.getFullName();
                if (displayName == null || displayName.trim().isEmpty() || "admin".equalsIgnoreCase(displayName)) {
                    displayName = "Lê Văn Hoàng";
                }
                request.setAttribute("userLeaveName", displayName);
                request.setAttribute("standardLeaveDays", 12.0);
                request.setAttribute("seniorityLeaveDays", 2.0);
                request.setAttribute("carryOverLeaveDays", 3.0);
                request.setAttribute("usedLeaveDays", 5.5);
                request.setAttribute("availableLeaveDays", 11.5);

                request.getRequestDispatcher("/WEB-INF/views/leave/leave-list.jsp")
                       .forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentUser(request);
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "submit": {
                LeaveRequest lr = new LeaveRequest();
                int empId = currentUser.getEmployeeId() > 0 ? currentUser.getEmployeeId() : 1;
                if (currentUser.isAdmin() || currentUser.isHr() || currentUser.isManager()) {
                    String empParam = request.getParameter("employeeId");
                    if (empParam != null && !empParam.isEmpty()) {
                        empId = Integer.parseInt(empParam);
                    }
                }
                lr.setEmployeeId(empId);

                Employee emp = employeeDAO.findById(empId);
                lr.setEmployeeName(emp != null ? emp.getFullName() : currentUser.getFullName());
                lr.setEmployeeCode(emp != null ? emp.getEmployeeCode() : "NV001");
                lr.setDepartmentName(emp != null ? emp.getDepartmentName() : "Khối R&D");
                lr.setPositionName(emp != null ? emp.getPositionName() : "Nhân viên");

                lr.setLeaveType(request.getParameter("leaveType"));
                String sd = request.getParameter("startDate");
                String ed = request.getParameter("endDate");
                if (sd != null && !sd.isEmpty()) lr.setStartDate(LocalDate.parse(sd));
                if (ed != null && !ed.isEmpty()) lr.setEndDate(LocalDate.parse(ed));

                String daysStr = request.getParameter("days");
                if (daysStr != null && !daysStr.isEmpty()) {
                    lr.setDays(Double.parseDouble(daysStr));
                }

                lr.setReason(request.getParameter("reason"));
                lr.setHandoverPerson(request.getParameter("handoverPerson"));

                String error = leaveService.createLeaveRequest(lr);
                if (error != null) {
                    response.sendRedirect(request.getContextPath() + "/leave?error=" + java.net.URLEncoder.encode(error, "UTF-8"));
                } else {
                    response.sendRedirect(request.getContextPath() + "/leave?success=submitted");
                }
                break;
            }
            case "approve": {
                if (currentUser.isManager() || currentUser.isHr() || currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    leaveService.approve(id, currentUser.getEmployeeId());

                    // Đồng bộ sang bảng chấm công: Ghi nhận ngày nghỉ phép ON_LEAVE
                    LeaveRequest lr = leaveService.getById(id);
                    if (lr != null && lr.getStartDate() != null && lr.getEndDate() != null) {
                        LocalDate d = lr.getStartDate();
                        while (!d.isAfter(lr.getEndDate())) {
                            attendanceDAO.upsertManual(lr.getEmployeeId(), d, null, null, "ON_LEAVE", "Nghỉ phép theo đơn " + lr.getLeaveCode());
                            d = d.plusDays(1);
                        }
                    }

                    response.sendRedirect(request.getContextPath() + "/leave?success=approved");
                    return;
                }
                break;
            }
            case "reject": {
                if (currentUser.isManager() || currentUser.isHr() || currentUser.isAdmin()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String reason = request.getParameter("rejectReason");
                    leaveService.reject(id, currentUser.getEmployeeId(), reason);
                    response.sendRedirect(request.getContextPath() + "/leave?success=rejected");
                    return;
                }
                break;
            }
            case "export": {
                exportLeaveRequestsCSV(request, response, currentUser);
                return;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/leave");
        }
    }

    /** Xuất danh sách đơn xin nghỉ phép ra định dạng CSV (UTF-8 BOM hỗ trợ Excel tiếng Việt) */
    private void exportLeaveRequestsCSV(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        String status = request.getParameter("status");
        String deptParam = request.getParameter("departmentId");
        Integer departmentId = (deptParam != null && !deptParam.isEmpty()) ? Integer.parseInt(deptParam) : null;
        String leaveType = request.getParameter("leaveType");
        String keyword = request.getParameter("keyword");

        List<LeaveRequest> list = leaveService.getByFilters(currentUser, status, departmentId, leaveType, keyword);

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"MIXIMOI_Leave_Requests_" + LocalDate.now() + ".csv\"");

        try (OutputStream os = response.getOutputStream()) {
            // Ghi UTF-8 BOM
            os.write(new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF});

            StringBuilder sb = new StringBuilder();
            sb.append("Mã Đơn,Mã NV,Họ Tên Nhân Viên,Phòng Ban,Chức Vụ,Loại Nghỉ Phép,Từ Ngày,Đến Ngày,Số Ngày Nghỉ,Lý Do,Trạng Thái,Người Duyệt,Ngày Tạo\n");

            for (LeaveRequest lr : list) {
                sb.append("\"").append(safe(lr.getLeaveCode())).append("\",");
                sb.append("\"").append(safe(lr.getEmployeeCode())).append("\",");
                sb.append("\"").append(safe(lr.getEmployeeName())).append("\",");
                sb.append("\"").append(safe(lr.getDepartmentName())).append("\",");
                sb.append("\"").append(safe(lr.getPositionName())).append("\",");
                sb.append("\"").append(getLeaveTypeName(lr.getLeaveType())).append("\",");
                sb.append("\"").append(lr.getStartDate() != null ? lr.getStartDate().toString() : "").append("\",");
                sb.append("\"").append(lr.getEndDate() != null ? lr.getEndDate().toString() : "").append("\",");
                sb.append("\"").append(lr.getDays()).append("\",");
                sb.append("\"").append(safe(lr.getReason())).append("\",");
                sb.append("\"").append(getStatusName(lr.getStatus())).append("\",");
                sb.append("\"").append(safe(lr.getApprovedByName())).append("\",");
                sb.append("\"").append(lr.getCreatedAt() != null ? lr.getCreatedAt().toString() : "").append("\"\n");
            }

            os.write(sb.toString().getBytes(StandardCharsets.UTF_8));
            os.flush();
        }
    }

    private String safe(String val) {
        return val != null ? val.replace("\"", "\"\"") : "";
    }

    private String getLeaveTypeName(String type) {
        if (type == null) return "Nghỉ phép";
        switch (type.toUpperCase()) {
            case "ANNUAL": return "Phép năm (AL)";
            case "SICK": return "Nghỉ ốm (SL)";
            case "PERSONAL": return "Việc riêng hưởng lương";
            case "WEDDING": return "Kết hôn";
            case "MATERNITY": return "Thai sản";
            case "UNPAID": return "Nghỉ không lương (UL)";
            default: return type;
        }
    }

    private String getStatusName(String status) {
        if (status == null) return "Chờ duyệt";
        switch (status.toUpperCase()) {
            case "APPROVED": return "Đã phê duyệt";
            case "REJECTED": return "Từ chối";
            case "CANCELLED": return "Đã hủy";
            default: return "Chờ duyệt";
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

    private User getCurrentUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("currentUser");
    }
}
