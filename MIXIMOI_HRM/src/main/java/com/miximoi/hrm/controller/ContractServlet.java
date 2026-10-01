package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.FileUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý hợp đồng lao động.
 * URL: /contracts
 */
@WebServlet("/contracts")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class ContractServlet extends HttpServlet {

    private final ContractDAO   contractDAO   = new ContractDAO();
    private final EmployeeDAO   employeeDAO   = new EmployeeDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("export".equalsIgnoreCase(action)) {
            exportContractsToCsv(request, response);
            return;
        }
        if ("view".equalsIgnoreCase(action) || "print".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr.trim());
                Contract contract = contractDAO.findById(id);
                if (contract != null) {
                    Employee emp = employeeDAO.findById(contract.getEmployeeId());
                    request.setAttribute("contract", contract);
                    request.setAttribute("employee", emp);
                    request.getRequestDispatcher("/WEB-INF/views/contract/contract-print.jsp").forward(request, response);
                    return;
                }
            }
        }

        if ("sign".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                contractDAO.sign(Integer.parseInt(idStr.trim()));
                response.sendRedirect(request.getContextPath() + "/contracts?success=signed");
                return;
            }
        }
        if ("terminate".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                contractDAO.terminate(Integer.parseInt(idStr.trim()), "Thanh lý hợp đồng");
                response.sendRedirect(request.getContextPath() + "/contracts?success=updated");
                return;
            }
        }

        User user = (User) request.getSession().getAttribute("currentUser");

        String keyword      = request.getParameter("keyword");
        String contractType = request.getParameter("contractType");
        String status       = request.getParameter("status");
        String deptStr      = request.getParameter("departmentId");
        Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.valueOf(deptStr.trim()) : null;

        List<Contract> contracts;
        if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
            // Employee only sees their own contracts
            int empId = user.getEmployeeId();
            contracts = contractDAO.findByEmployeeId(empId);
        } else {
            // Admin, HR, Accountant, Manager
            contracts = contractDAO.search(keyword, contractType, status, departmentId);
        }

        int totalFiltered = contracts != null ? contracts.size() : 0;
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = 20; // mặc định 20 để hiển thị danh sách đầy đủ
        if ("all".equalsIgnoreCase(pageSizeStr)) {
            pageSize = Math.max(1, totalFiltered);
        } else if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
            try {
                pageSize = Math.max(1, Integer.parseInt(pageSizeStr.trim()));
            } catch (NumberFormatException ignored) {}
        }

        int totalPages = Math.max(1, (int) Math.ceil((double) totalFiltered / pageSize));
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Math.max(1, Math.min(Integer.parseInt(pageStr.trim()), totalPages));
            } catch (NumberFormatException ignored) {}
        }
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalFiltered);
        List<Contract> pagedContracts = (contracts != null && fromIndex < totalFiltered)
                ? contracts.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        // Stats calculation
        int totalContracts   = contractDAO.countTotal();
        int activeCount      = contractDAO.countActive();
        int indefiniteCount  = contractDAO.countByType("INDEFINITE");
        int fixedCount       = contractDAO.countByType("FIXED_TERM");
        int expiringCount    = contractDAO.countExpiringSoon(30);

        request.setAttribute("contracts",        pagedContracts);
        request.setAttribute("totalFiltered",    totalFiltered);
        request.setAttribute("currentPage",      page);
        request.setAttribute("totalPages",       totalPages);
        request.setAttribute("pageSize",         pageSize);
        request.setAttribute("employees",        employeeDAO.findAll());
        request.setAttribute("departments",      departmentDAO.findAll());
        request.setAttribute("nextContractCode", contractDAO.getNextContractCode());
        request.setAttribute("fixedTermCountMap", contractDAO.countFixedTermMap());

        request.setAttribute("totalContracts",   totalContracts);
        request.setAttribute("activeCount",      activeCount);
        request.setAttribute("indefiniteCount",  indefiniteCount);
        request.setAttribute("fixedCount",       fixedCount);
        request.setAttribute("expiringCount",    expiringCount);

        request.setAttribute("keyword",          keyword);
        request.setAttribute("contractType",     contractType);
        request.setAttribute("status",           status);
        request.setAttribute("departmentId",     departmentId);

        request.getRequestDispatcher("/WEB-INF/views/contract/contract-list.jsp")
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
            case "add" -> {
                Contract c = new Contract();
                c.setContractCode(request.getParameter("contractCode"));
                c.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
                c.setContractType(request.getParameter("contractType"));
                String sd = request.getParameter("startDate");
                String ed = request.getParameter("endDate");
                if (sd != null && !sd.trim().isEmpty()) c.setStartDate(LocalDate.parse(sd.trim()));
                if (ed != null && !ed.trim().isEmpty()) c.setEndDate(LocalDate.parse(ed.trim()));
                String sal = request.getParameter("baseSalary");
                if (sal != null && !sal.trim().isEmpty()) {
                    String clean = sal.replace(".", "").replace(",", "").trim();
                    c.setBaseSalary(new BigDecimal(clean));
                } else {
                    c.setBaseSalary(BigDecimal.ZERO);
                }
                c.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "ACTIVE");
                c.setNotes(request.getParameter("notes"));

                // Tuân thủ Điều 20 Bộ luật Lao động 2019:
                // Người lao động chỉ được ký tối đa 2 lần hợp đồng có thời hạn (FIXED_TERM).
                // Lần tiếp theo bắt buộc phải chuyển sang hợp đồng không xác định thời hạn (INDEFINITE).
                if ("FIXED_TERM".equalsIgnoreCase(c.getContractType())) {
                    int fixedCount = contractDAO.countFixedTermContracts(c.getEmployeeId());
                    if (fixedCount >= 2) {
                        c.setContractType("INDEFINITE");
                        c.setEndDate(null);
                        String noteMsg = "[Điều 20 BLLĐ 2019] Tự động chuyển đổi thành HĐ Không xác định thời hạn do NLĐ đã ký đủ 2 lần HĐ có thời hạn.";
                        c.setNotes(c.getNotes() != null && !c.getNotes().trim().isEmpty() ? c.getNotes().trim() + " | " + noteMsg : noteMsg);
                    }
                }

                // Lưu file hợp đồng nếu có tải lên
                try {
                    Part filePart = request.getPart("contractFile");
                    String savedFileUrl = FileUploadUtil.saveFile(filePart, "contracts", request);
                    if (savedFileUrl != null) {
                        c.setContractFileUrl(savedFileUrl);
                    }
                } catch (ServletException | IOException ignored) {}
                // Đồng bộ thông tin pháp lý từ nhân sự vào hợp đồng
                Employee emp = employeeDAO.findById(c.getEmployeeId());
                if (emp != null) {
                    c.setIdentityNumber(emp.getIdentityNumber());
                    c.setIdentityDate(emp.getIdentityDate());
                    c.setIdentityPlace(emp.getIdentityPlace());
                    c.setSignerName("Nguyễn Văn An");
                    c.setSignerTitle("Tổng Giám Đốc");
                    c.setWorkLocation("Trụ sở Công ty Cổ phần Tập đoàn MIXIMOI (Landmark 81, TP.HCM / MIXIMOI Tower Hà Nội)");
                    c.setJobDescription("Thực hiện nhiệm vụ chuyên môn theo vị trí được phân công.");
                    if (c.getAllowanceAmount() == null) {
                        c.setAllowanceAmount(new BigDecimal("2500000"));
                    }
                }

                contractDAO.insert(c);

                String from = request.getParameter("from");
                if ("employeeDetail".equals(from)) {
                    response.sendRedirect(request.getContextPath() + "/employees?action=detail&id=" + c.getEmployeeId() + "&success=contract_added#tabContract");
                } else {
                    response.sendRedirect(request.getContextPath() + "/contracts?success=added");
                }
            }
            case "update" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Contract c = contractDAO.findById(id);
                if (c != null) {
                    c.setContractType(request.getParameter("contractType"));
                    String sd = request.getParameter("startDate");
                    String ed = request.getParameter("endDate");
                    if (sd != null && !sd.trim().isEmpty()) c.setStartDate(LocalDate.parse(sd.trim()));
                    if (ed != null && !ed.trim().isEmpty()) c.setEndDate(LocalDate.parse(ed.trim()));
                    else c.setEndDate(null);

                    String sal = request.getParameter("baseSalary");
                    if (sal != null && !sal.trim().isEmpty()) {
                        String clean = sal.replace(".", "").replace(",", "").trim();
                        c.setBaseSalary(new BigDecimal(clean));
                    }
                    String st = request.getParameter("status");
                    if (st != null && !st.trim().isEmpty()) c.setStatus(st.trim());
                    c.setNotes(request.getParameter("notes"));

                    // Lưu file hợp đồng mới nếu có tải lên
                    try {
                        Part filePart = request.getPart("contractFile");
                        String savedFileUrl = FileUploadUtil.saveFile(filePart, "contracts", request);
                        if (savedFileUrl != null) {
                            c.setContractFileUrl(savedFileUrl);
                        }
                    } catch (ServletException | IOException ignored) {}

                    contractDAO.update(c);
                }
                response.sendRedirect(request.getContextPath() + "/contracts?success=updated");
            }
            case "renew" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                String ed = request.getParameter("endDate");
                LocalDate newEnd = (ed != null && !ed.trim().isEmpty()) ? LocalDate.parse(ed.trim()) : null;
                String sal = request.getParameter("baseSalary");
                BigDecimal newSal = null;
                if (sal != null && !sal.trim().isEmpty()) {
                    newSal = new BigDecimal(sal.replace(".", "").replace(",", "").trim());
                }
                String notes = request.getParameter("notes");
                contractDAO.renew(id, newEnd, newSal, notes);
                response.sendRedirect(request.getContextPath() + "/contracts?success=updated");
            }
            case "terminate" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                String reason = request.getParameter("reason");
                contractDAO.terminate(id, reason);
                response.sendRedirect(request.getContextPath() + "/contracts?success=updated");
            }
            case "sign" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                contractDAO.sign(id);
                response.sendRedirect(request.getContextPath() + "/contracts?success=signed");
            }
            case "transition_probation" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Contract oldC = contractDAO.findById(id);
                if (oldC != null) {
                    contractDAO.terminate(id, "Hoàn thành thời gian thử việc - Chuyển sang ký HĐ chính thức");

                    Contract newC = new Contract();
                    newC.setContractCode(contractDAO.getNextContractCode());
                    newC.setEmployeeId(oldC.getEmployeeId());

                    int fixedCount = contractDAO.countFixedTermContracts(oldC.getEmployeeId());
                    if (fixedCount >= 2) {
                        newC.setContractType("INDEFINITE");
                        newC.setEndDate(null);
                    } else {
                        newC.setContractType("FIXED_TERM");
                        newC.setEndDate(LocalDate.now().plusYears(1));
                    }
                    newC.setStartDate(LocalDate.now());

                    String salStr = request.getParameter("baseSalary");
                    if (salStr != null && !salStr.trim().isEmpty()) {
                        newC.setBaseSalary(new BigDecimal(salStr.replace(".", "").replace(",", "").trim()));
                    } else if (oldC.getBaseSalary() != null) {
                        newC.setBaseSalary(oldC.getBaseSalary());
                    } else {
                        newC.setBaseSalary(new BigDecimal("15000000"));
                    }

                    newC.setStatus("ACTIVE");
                    newC.setSignerName("Nguyễn Văn An");
                    newC.setSignerTitle("Tổng Giám Đốc");
                    newC.setWorkLocation(oldC.getWorkLocation() != null ? oldC.getWorkLocation() : "Trụ sở chính Landmark 81, TP. HCM");
                    newC.setAllowanceAmount(new BigDecimal("2500000"));
                    newC.setSignedDate(LocalDate.now());
                    newC.setNotes("Chuyển từ HĐ Thử việc (" + oldC.getContractCode() + ") lên hợp đồng chính thức");

                    contractDAO.insert(newC);
                }
                response.sendRedirect(request.getContextPath() + "/contracts?success=transitioned");
            }
            case "delete" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                contractDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/contracts?success=deleted");
            }
            case "bulkDelete" -> {
                String[] idsArr = request.getParameterValues("ids");
                int count = 0;
                if (idsArr != null && idsArr.length > 0) {
                    java.util.List<Integer> ids = new java.util.ArrayList<>();
                    for (String sid : idsArr) {
                        try { ids.add(Integer.valueOf(sid.trim())); } catch (NumberFormatException ignored) {}
                    }
                    count = contractDAO.bulkDelete(ids);
                }
                response.sendRedirect(request.getContextPath() + "/contracts?success=deleted&count=" + count);
            }
            case "bulkExport" -> {
                String[] idsArr = request.getParameterValues("ids");
                List<Contract> list;
                if (idsArr != null && idsArr.length > 0) {
                    java.util.List<Integer> ids = new java.util.ArrayList<>();
                    for (String sid : idsArr) {
                        try { ids.add(Integer.valueOf(sid.trim())); } catch (NumberFormatException ignored) {}
                    }
                    list = contractDAO.findByIds(ids);
                } else {
                    String keyword      = request.getParameter("keyword");
                    String contractType = request.getParameter("contractType");
                    String status       = request.getParameter("status");
                    String deptStr      = request.getParameter("departmentId");
                    Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.valueOf(deptStr.trim()) : null;
                    list = contractDAO.search(keyword, contractType, status, departmentId);
                }
                writeContractsCsv(response, list);
            }
            default -> response.sendRedirect(request.getContextPath() + "/contracts");
        }
    }

    private void exportContractsToCsv(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword      = request.getParameter("keyword");
        String contractType = request.getParameter("contractType");
        String status       = request.getParameter("status");
        String deptStr      = request.getParameter("departmentId");
        Integer departmentId = (deptStr != null && !deptStr.trim().isEmpty()) ? Integer.valueOf(deptStr.trim()) : null;

        List<Contract> list = contractDAO.search(keyword, contractType, status, departmentId);
        writeContractsCsv(response, list);
    }

    private void writeContractsCsv(HttpServletResponse response, List<Contract> list) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"danh_sach_hop_dong_" + LocalDate.now() + ".csv\"");

        PrintWriter writer = response.getWriter();
        // Ghi UTF-8 BOM để Excel hiển thị đúng dấu tiếng Việt
        writer.write('\uFEFF');
        writer.println("STT,Số Hợp Đồng,Mã Nhân Viên,Họ Và Tên,Phòng Ban,Loại Hợp Đồng,Ngày Bắt Đầu,Ngày Hết Hạn,Lương Cơ Bản,Trạng Thái,Ghi Chú");

        int stt = 1;
        for (Contract c : list) {
            StringBuilder sb = new StringBuilder();
            sb.append(stt++).append(",");
            sb.append(escapeCsv(c.getContractCode())).append(",");
            sb.append(escapeCsv(c.getEmployeeCode())).append(",");
            sb.append(escapeCsv(c.getEmployeeName())).append(",");
            sb.append(escapeCsv(c.getDepartmentName() != null ? c.getDepartmentName() : "")).append(",");
            sb.append(escapeCsv(c.getContractType())).append(",");
            sb.append(c.getStartDate() != null ? c.getStartDate().toString() : "").append(",");
            sb.append(c.getEndDate() != null ? c.getEndDate().toString() : "Không thời hạn").append(",");
            sb.append(c.getBaseSalary() != null ? c.getBaseSalary().toPlainString() : "0").append(",");
            sb.append(escapeCsv(c.getStatus())).append(",");
            sb.append(escapeCsv(c.getNotes() != null ? c.getNotes() : ""));
            writer.println(sb.toString());
        }
        writer.flush();
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
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
