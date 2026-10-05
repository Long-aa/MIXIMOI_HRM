package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.AuditLogDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.PayrollService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý bảng lương.
 * URL: /payroll
 */
@WebServlet(urlPatterns = {"/payroll", "/payrolls"})
@MultipartConfig
public class PayrollServlet extends HttpServlet {

    private final PayrollService payrollService = new PayrollService();
    private final PayrollDAO     payrollDAO     = new PayrollDAO();
    private final DepartmentDAO  departmentDAO  = new DepartmentDAO();
    private final AttendanceDAO  attendanceDAO  = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User user = (User) request.getSession().getAttribute("currentUser");
        if (user.isEmployee()) {
            response.sendRedirect(request.getContextPath() + "/payslip");
            return;
        }
        if (!user.isAdmin() && !user.isAccountant()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        LocalDate now = LocalDate.now();
        String mStr = request.getParameter("month");
        String yStr = request.getParameter("year");
        int month = (mStr != null && !mStr.isEmpty()) ? Integer.parseInt(mStr) : now.getMonthValue();
        int year  = (yStr != null && !yStr.isEmpty()) ? Integer.parseInt(yStr) : now.getYear();

        String keyword = request.getParameter("keyword");
        String deptParam = request.getParameter("deptId");
        Integer deptId = (deptParam != null && !deptParam.isEmpty()) ? Integer.valueOf(deptParam) : null;
        String status = request.getParameter("status");

        // Xuất file CSV / Excel nếu có yêu cầu
        if ("export".equalsIgnoreCase(request.getParameter("action"))) {
            exportPayrollToCsv(response, month, year, deptId, status, keyword);
            return;
        }
        if ("export_bank".equalsIgnoreCase(request.getParameter("action"))) {
            exportBankPaymentBatch(response, month, year, deptId, status, keyword);
            return;
        }

        // Lấy danh sách bảng lương theo bộ lọc
        List<Payroll> allPayrolls = payrollDAO.search(month, year, deptId, status, keyword, 0, 0);
        if (allPayrolls == null) allPayrolls = new java.util.ArrayList<>();

        // ===== KPI Stats =====
        BigDecimal totalPayroll  = payrollDAO.sumNetSalaryByPeriod(month, year);
        BigDecimal avgSalary     = payrollDAO.avgNetSalaryByPeriod(month, year)
                                             .setScale(0, RoundingMode.HALF_UP);
        int        totalEmpCount = payrollDAO.countEmployeesByPeriod(month, year);
        int        countPaid     = payrollDAO.countByStatus(month, year, "PAID");
        int        countApproved = payrollDAO.countByStatus(month, year, "APPROVED");
        int        countPending  = payrollDAO.countByStatus(month, year, "PENDING")
                                 + payrollDAO.countByStatus(month, year, "PENDING_APPROVAL");
        int        countDraft    = payrollDAO.countByStatus(month, year, "DRAFT");
        int        countProcessing = payrollDAO.countByStatus(month, year, "PROCESSING_PAYMENT");

        // Tỉ lệ hoàn thành chi trả
        double paidRatio    = totalEmpCount > 0 ? (double) countPaid / totalEmpCount * 100.0 : 0;
        int    pendingCount = countPending + countDraft + countProcessing;

        // Phân trang 15 bản ghi/trang
        int pageSize    = 15;
        int totalRecords = allPayrolls.size();
        int totalPages  = (int) Math.ceil((double) totalRecords / pageSize);

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (NumberFormatException ignored) {}
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        int fromIdx = (page - 1) * pageSize;
        int toIdx   = Math.min(fromIdx + pageSize, totalRecords);
        List<Payroll> payrollList = (totalRecords > 0) ? allPayrolls.subList(fromIdx, toIdx) : allPayrolls;

        List<Department> departments = departmentDAO.findAll();

        // ===== Attributes =====
        request.setAttribute("activeMenu",      "payroll");
        request.setAttribute("payrollList",     payrollList);
        request.setAttribute("totalPayroll",    totalPayroll);
        request.setAttribute("avgSalary",       avgSalary);
        request.setAttribute("totalEmpCount",   totalEmpCount);
        request.setAttribute("countPaid",       countPaid);
        request.setAttribute("countApproved",   countApproved);
        request.setAttribute("countPending",    countPending);
        request.setAttribute("countDraft",      countDraft);
        request.setAttribute("countProcessing", countProcessing);
        request.setAttribute("pendingCount",    pendingCount);
        request.setAttribute("paidRatio",       String.format("%.1f", paidRatio));
        request.setAttribute("selectedMonth",   month);
        request.setAttribute("selectedYear",    year);
        request.setAttribute("currentPage",     page);
        request.setAttribute("totalPages",      totalPages);
        request.setAttribute("totalRecords",    totalRecords);
        request.setAttribute("pageSize",        pageSize);
        request.setAttribute("departments",     departments);
        request.setAttribute("keyword",         keyword);
        request.setAttribute("selectedDeptId",  deptId);
        request.setAttribute("selectedStatus",  status);
        request.setAttribute("isTimesheetLocked", attendanceDAO.isTimesheetLocked(month, year));

        String success = request.getParameter("success");
        if (success != null) request.setAttribute("successMsg", success);
        String error = request.getParameter("error");
        if (error != null) request.setAttribute("errorMsg", error);

        request.getRequestDispatcher("/WEB-INF/views/payroll/payroll-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        User user = (User) request.getSession().getAttribute("currentUser");
        if (!user.isAdmin() && !user.isAccountant()) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=access_denied");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        int userId = user.getId();

        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year  = now.getYear();
        try {
            String mStr = request.getParameter("month");
            String yStr = request.getParameter("year");
            if (mStr != null && !mStr.isEmpty()) month = Integer.parseInt(mStr);
            if (yStr != null && !yStr.isEmpty()) year  = Integer.parseInt(yStr);
        } catch (NumberFormatException ignored) {}

        String pageParam = request.getParameter("page");
        String deptParam = request.getParameter("deptId");
        String statusParam = request.getParameter("statusFilter");
        String kwParam = request.getParameter("keyword");

        StringBuilder extra = new StringBuilder();
        if (pageParam != null && !pageParam.isEmpty()) extra.append("&page=").append(pageParam);
        if (deptParam != null && !deptParam.isEmpty()) extra.append("&deptId=").append(deptParam);
        if (statusParam != null && !statusParam.isEmpty()) extra.append("&status=").append(statusParam);
        if (kwParam != null && !kwParam.isEmpty()) {
            try { extra.append("&keyword=").append(java.net.URLEncoder.encode(kwParam, "UTF-8")); } catch (java.io.UnsupportedEncodingException ignored) {}
        }

        switch (action) {
            case "calculate" -> {
                boolean confirmLock = "true".equalsIgnoreCase(request.getParameter("confirmLock"));
                boolean isLocked = attendanceDAO.isTimesheetLocked(month, year);
                Integer empLockId = user.getEmployeeId() > 0 ? user.getEmployeeId() : null;
                if (!isLocked) {
                    if (confirmLock) {
                        attendanceDAO.setTimesheetLocked(month, year, true, empLockId,
                                "Khóa chốt bảng công tự động khi tính lương bởi " + user.getFullName());
                        AuditLogDAO.logAction(request, "LOCK_TIMESHEET", "TIMESHEET", null,
                                "Tự động khóa chốt bảng công khi tính lương kỳ " + month + "/" + year);
                    } else {
                        if (isAjax(request)) {
                            writeJson(response, false, "Bảng công kỳ " + month + "/" + year + " chưa khóa chốt! Vui lòng khóa chốt trước khi tính lương.");
                            return;
                        }
                        response.sendRedirect(request.getContextPath()
                                + "/payroll?month=" + month + "&year=" + year + "&error=timesheet_not_locked" + extra);
                        return;
                    }
                }
                try {
                    // Đảm bảo dữ liệu chấm công đã có đầy đủ trước khi chốt công và tính lương
                    attendanceDAO.autoSeedMonthAttendance(month, year);
                    int count = payrollService.calculatePayrollForPeriod(month, year, userId);
                    AuditLogDAO.logAction(request, "CALCULATE_PAYROLL", "PAYROLL", null, "Tính lương kỳ " + month + "/" + year);
                    if (isAjax(request)) {
                        writeJson(response, true, "Đã tính toán bảng lương tháng " + month + "/" + year + " thành công cho " + count + " nhân viên!");
                        return;
                    }
                    response.sendRedirect(request.getContextPath()
                            + "/payroll?month=" + month + "&year=" + year + "&success=calculated" + extra);
                } catch (Exception e) {
                    System.err.println("PayrollServlet.calculate error: " + e.getMessage());
                    if (isAjax(request)) {
                        writeJson(response, false, "Lỗi khi tính toán bảng lương: " + e.getMessage());
                        return;
                    }
                    response.sendRedirect(request.getContextPath()
                            + "/payroll?month=" + month + "&year=" + year + "&error=calc_failed" + extra);
                }
            }
            case "toggle_lock" -> {
                boolean currentlyLocked = attendanceDAO.isTimesheetLocked(month, year);
                Integer empLockId = user.getEmployeeId() > 0 ? user.getEmployeeId() : null;
                attendanceDAO.setTimesheetLocked(month, year, !currentlyLocked, empLockId, 
                        !currentlyLocked ? "Khóa chốt kỳ tính lương" : "Mở khóa kỳ tính lương");
                AuditLogDAO.logAction(request, !currentlyLocked ? "LOCK_PAYROLL" : "UNLOCK_PAYROLL", "PAYROLL", null, 
                        (!currentlyLocked ? "Khóa chốt" : "Mở khóa") + " kỳ tính lương " + month + "/" + year);
                if (isAjax(request)) {
                    writeJson(response, true, !currentlyLocked ? "Đã khóa chốt kỳ bảng lương thành công!" : "Đã mở khóa kỳ bảng lương!");
                    return;
                }
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=" + (!currentlyLocked ? "locked" : "unlocked") + extra);
            }
            case "submit_approval" -> {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    payrollDAO.updateStatus(id, "PENDING_APPROVAL", userId);
                    AuditLogDAO.logAction(request, "SUBMIT_PAYROLL", "PAYROLL", id, "Gửi duyệt phiếu lương ID " + id);
                    if (isAjax(request)) {
                        writeJson(response, true, "Đã gửi phiếu lương đi phê duyệt!", "PENDING_APPROVAL", "Chờ duyệt");
                        return;
                    }
                } else {
                    payrollDAO.updateStatusByPeriod(month, year, "DRAFT", "PENDING_APPROVAL", userId);
                    AuditLogDAO.logAction(request, "SUBMIT_ALL_PAYROLL", "PAYROLL", null, "Gửi duyệt toàn bộ bảng lương kỳ " + month + "/" + year);
                    if (isAjax(request)) {
                        writeJson(response, true, "Đã gửi toàn bộ bảng lương đi phê duyệt!");
                        return;
                    }
                }
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=submitted" + extra);
            }
            case "approve" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                payrollService.approve(id, userId);
                AuditLogDAO.logAction(request, "APPROVE_PAYSLIP", "PAYROLL", id, "Phê duyệt phiếu lương ID " + id);
                if (isAjax(request)) {
                    writeJson(response, true, "Phê duyệt phiếu lương thành công!", "APPROVED", "Đã duyệt");
                    return;
                }
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=approved" + extra);
            }
            case "approve_all" -> {
                int count = payrollService.approveAll(month, year, userId);
                AuditLogDAO.logAction(request, "APPROVE_ALL_PAYSLIPS", "PAYROLL", null, "Phê duyệt toàn bộ phiếu lương kỳ " + month + "/" + year);
                if (isAjax(request)) {
                    writeJson(response, true, "Đã phê duyệt toàn bộ " + count + " phiếu lương tháng " + month + "/" + year + "!");
                    return;
                }
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=approved_all" + extra);
            }
            case "process_payment" -> {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    payrollDAO.updateStatus(id, "PROCESSING_PAYMENT", userId);
                    AuditLogDAO.logAction(request, "PROCESS_PAYMENT", "PAYROLL", id, "Chuyển trạng thái đang chi trả phiếu lương ID " + id);
                    if (isAjax(request)) {
                        writeJson(response, true, "Đang xử lý lệnh chi trả ngân hàng!", "PROCESSING_PAYMENT", "Đang chi trả");
                        return;
                    }
                }
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + extra);
            }
            case "pay" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                payrollService.payPayrollSingle(id, userId, "BANK_TRANSFER", null);
                AuditLogDAO.logAction(request, "PAY_PAYSLIP", "PAYMENT", id, "Thanh toán phiếu lương ID " + id + " (Chuyển khoản)");
                if (isAjax(request)) {
                    writeJson(response, true, "Ghi nhận chi trả lương thành công!", "PAID", "Đã chi trả");
                    return;
                }
                response.sendRedirect(request.getContextPath()
                        + "/payroll?month=" + month + "&year=" + year + "&success=paid" + extra);
            }
            default -> response.sendRedirect(request.getContextPath()
                    + "/payroll?month=" + month + "&year=" + year + extra);
        }
    }

    private void exportPayrollToCsv(HttpServletResponse response, int month, int year, Integer deptId, String status, String keyword)
            throws IOException {
        List<Payroll> list = payrollDAO.search(month, year, deptId, status, keyword, 0, 0);
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"bang_luong_" + month + "_" + year + ".csv\"");
        response.setCharacterEncoding("UTF-8");

        try (java.io.PrintWriter writer = response.getWriter()) {
            writer.write('\uFEFF'); // UTF-8 BOM để Excel hiển thị tiếng Việt không bị lỗi font
            writer.println("Mã NV,Họ và tên,Phòng ban,Ngày công TT,Ngày công chuẩn,Lương cơ bản,Phụ cấp,Thưởng,Tăng ca (OT),Khấu trừ,Thực nhận (Net),Trạng thái");
            if (list != null) {
                for (Payroll p : list) {
                    writer.println(String.format("\"%s\",\"%s\",\"%s\",%.1f,%.1f,%s,%s,%s,%s,%s,%s,\"%s\"",
                            p.getEmployeeCode() != null ? p.getEmployeeCode() : "",
                            p.getEmployeeName() != null ? p.getEmployeeName().replace("\"", "\"\"") : "",
                            p.getDepartmentName() != null ? p.getDepartmentName().replace("\"", "\"\"") : "",
                            p.getWorkingDays(),
                            p.getStandardDays(),
                            p.getBaseSalary() != null ? p.getBaseSalary().toString() : "0",
                            p.getAllowance() != null ? p.getAllowance().toString() : "0",
                            p.getBonus() != null ? p.getBonus().toString() : "0",
                            p.getOvertimeAmount() != null ? p.getOvertimeAmount().toString() : "0",
                            p.getDeduction() != null ? p.getDeduction().toString() : "0",
                            p.getNetSalary() != null ? p.getNetSalary().toString() : "0",
                            p.getStatus() != null ? p.getStatus() : "DRAFT"
                    ));
                }
            }
        }
    }

    private void exportBankPaymentBatch(HttpServletResponse response, int month, int year, Integer deptId, String status, String keyword)
            throws IOException {
        List<Payroll> list = payrollDAO.search(month, year, deptId, status, keyword, 0, 0);
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"lenh_chi_luong_ngan_hang_" + month + "_" + year + ".csv\"");
        response.setCharacterEncoding("UTF-8");

        try (java.io.PrintWriter writer = response.getWriter()) {
            writer.write('\uFEFF'); // UTF-8 BOM
            writer.println("STT,Số tài khoản (STK),Tên người thụ hưởng,Tên ngân hàng,Số tiền chi trả (VND),Nội dung chuyển khoản");
            if (list != null) {
                int stt = 1;
                for (Payroll p : list) {
                    String stk = "10" + String.format("%08d", p.getEmployeeId());
                    String name = p.getEmployeeName() != null ? p.getEmployeeName().toUpperCase() : "NHAN VIEN";
                    String bank = "VIETCOMBANK";
                    String amount = p.getNetSalary() != null ? p.getNetSalary().toBigInteger().toString() : "0";
                    String content = String.format("MIXIMOI CHI TRA LUONG THANG %02d/%d CHO %s", month, year, p.getEmployeeCode());

                    writer.println(String.format("%d,\"%s\",\"%s\",\"%s\",%s,\"%s\"",
                            stt++,
                            stk,
                            name.replace("\"", "\"\""),
                            bank,
                            amount,
                            content.replace("\"", "\"\"")
                    ));
                }
            }
        }
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));
    }

    private void writeJson(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + (message != null ? message.replace("\"", "\\\"") : "") + "\"}");
    }

    private void writeJson(HttpServletResponse response, boolean success, String message, String newStatus, String statusText) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"success\":" + success
                + ",\"message\":\"" + (message != null ? message.replace("\"", "\\\"") : "") + "\""
                + (newStatus != null ? ",\"newStatus\":\"" + newStatus + "\"" : "")
                + (statusText != null ? ",\"statusText\":\"" + statusText + "\"" : "")
                + "}");
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
