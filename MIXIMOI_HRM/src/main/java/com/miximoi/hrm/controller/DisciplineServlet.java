package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DisciplineDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Discipline;
import com.miximoi.hrm.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Servlet quản lý kỷ luật lao động, xử lý vi phạm nội quy và theo dõi quy trình 5 bước.
 * URL: /disciplines
 */
@WebServlet("/disciplines")
public class DisciplineServlet extends HttpServlet {

    private final DisciplineDAO disciplineDAO = new DisciplineDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;

        request.setAttribute("activeMenu", "disciplines");

        // Load statistics
        Map<String, Object> stats = disciplineDAO.getStats();
        request.setAttribute("stats", stats);

        // Load employees for modal dropdown
        List<Employee> employees = employeeDAO.findAll();
        request.setAttribute("employees", employees);

        // Load next violation code
        String nextCode = disciplineDAO.getNextViolationCode();
        request.setAttribute("nextCode", nextCode);

        // Fetch disciplines list
        List<Discipline> disciplines = disciplineDAO.findAll();

        // Optional filter: status
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            disciplines = disciplines.stream()
                    .filter(d -> statusFilter.equalsIgnoreCase(d.getStatus()))
                    .collect(Collectors.toList());
        }

        // Optional filter: keyword search
        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            disciplines = disciplines.stream()
                    .filter(d -> (d.getViolationCode() != null && d.getViolationCode().toLowerCase().contains(kw))
                              || (d.getEmployeeName() != null && d.getEmployeeName().toLowerCase().contains(kw))
                              || (d.getEmployeeCode() != null && d.getEmployeeCode().toLowerCase().contains(kw))
                              || (d.getDepartmentName() != null && d.getDepartmentName().toLowerCase().contains(kw))
                              || (d.getViolationBehavior() != null && d.getViolationBehavior().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
        }

        // Pagination
        int pageSize = 6;
        int totalRecords = disciplines.size();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException ignored) {}
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        int fromIdx = (page - 1) * pageSize;
        int toIdx = Math.min(fromIdx + pageSize, totalRecords);
        List<Discipline> pageList = (totalRecords > 0) ? disciplines.subList(fromIdx, toIdx) : disciplines;

        request.setAttribute("disciplines", pageList);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("fromIdx", totalRecords > 0 ? (fromIdx + 1) : 0);
        request.setAttribute("toIdx", toIdx);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/WEB-INF/views/discipline/discipline-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create_report" -> {
                Discipline d = new Discipline();
                String code = request.getParameter("violationCode");
                if (code == null || code.trim().isEmpty()) {
                    code = disciplineDAO.getNextViolationCode();
                }
                d.setViolationCode(code);

                int empId = 0;
                try {
                    empId = Integer.parseInt(request.getParameter("employeeId"));
                } catch (NumberFormatException ignored) {}
                d.setEmployeeId(empId);

                Employee emp = employeeDAO.findById(empId);
                if (emp != null) {
                    d.setEmployeeCode(emp.getEmployeeCode());
                    d.setEmployeeName(emp.getFullName());
                    d.setDepartmentName(emp.getDepartmentName());
                } else {
                    d.setEmployeeCode("NV-" + empId);
                    d.setEmployeeName(request.getParameter("employeeName"));
                    d.setDepartmentName(request.getParameter("departmentName"));
                }

                String dateStr = request.getParameter("violationDate");
                if (dateStr != null && !dateStr.trim().isEmpty()) {
                    try {
                        d.setViolationDate(LocalDate.parse(dateStr));
                    } catch (java.time.format.DateTimeParseException e) {
                        d.setViolationDate(LocalDate.now());
                    }
                } else {
                    d.setViolationDate(LocalDate.now());
                }

                d.setSeverity(request.getParameter("severity"));
                d.setViolationBehavior(request.getParameter("description"));
                d.setProposedDecision(request.getParameter("proposedDecision"));
                if (d.getProposedDecision() == null || d.getProposedDecision().trim().isEmpty()) {
                    // Default proposed decision based on severity
                    if ("high".equalsIgnoreCase(d.getSeverity()) || "critical".equalsIgnoreCase(d.getSeverity())) {
                        d.setProposedDecision("Đình chỉ công tác & họp kỷ luật sa thải");
                    } else if ("medium".equalsIgnoreCase(d.getSeverity())) {
                        d.setProposedDecision("Khiển trách bằng văn bản & trừ thưởng");
                    } else {
                        d.setProposedDecision("Nhắc nhở nội bộ & cam kết tuân thủ");
                    }
                }

                String handler = request.getParameter("handler");
                d.setHandlerName(handler != null && !handler.trim().isEmpty() ? handler : "Ban Thanh tra & Nhân sự");
                d.setCurrentStep(1);
                d.setStatus("PENDING_VERIFY");
                d.setNotes(request.getParameter("notes"));

                disciplineDAO.insert(d);
                response.sendRedirect(request.getContextPath() + "/disciplines?success=report_created");
            }
            case "update_step" -> {
                int id = 0;
                try { id = Integer.parseInt(request.getParameter("id")); } catch (NumberFormatException ignored) {}
                int step = 1;
                try { step = Integer.parseInt(request.getParameter("step")); } catch (NumberFormatException ignored) {}
                String status = request.getParameter("status");
                if (status == null || status.trim().isEmpty()) {
                    status = switch (step) {
                        case 1 -> "PENDING_VERIFY";
                        case 2 -> "INVESTIGATING";
                        case 3 -> "WAITING_HEARING";
                        case 4 -> "RESOLVED";
                        default -> "CLOSED";
                    };
                }
                disciplineDAO.updateStatus(id, status, step);
                response.sendRedirect(request.getContextPath() + "/disciplines?success=step_updated");
            }
            case "delete" -> {
                int id = 0;
                try { id = Integer.parseInt(request.getParameter("id")); } catch (NumberFormatException ignored) {}
                disciplineDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/disciplines?success=deleted");
            }
            default -> response.sendRedirect(request.getContextPath() + "/disciplines");
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
