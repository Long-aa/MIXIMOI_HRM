package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.LeaveDAO;
import com.miximoi.hrm.dao.PositionDAO;
import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.Position;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.EmployeeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet quản lý nhân viên.
 * URL: /employees
 *
 * GET  /employees                 → danh sách nhân viên
 * GET  /employees?action=new      → form thêm mới
 * GET  /employees?action=edit&id=X → form sửa
 * GET  /employees?action=detail&id=X → chi tiết
 * GET  /employees?action=export   → xuất Excel/CSV
 * GET  /employees?action=template → tải file mẫu CSV
 * POST /employees?action=add      → thêm nhân viên
 * POST /employees?action=update   → cập nhật nhân viên
 * POST /employees?action=delete   → vô hiệu hóa nhân viên
 * POST /employees?action=import   → nhập nhân viên từ file CSV
 */
@WebServlet("/employees")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class EmployeeServlet extends HttpServlet {

    private final EmployeeService employeeService = new EmployeeService();
    private final EmployeeDAO     employeeDAO     = new EmployeeDAO();
    private final DepartmentDAO   departmentDAO   = new DepartmentDAO();
    private final PositionDAO     positionDAO     = new PositionDAO();
    private final ContractDAO     contractDAO     = new ContractDAO();
    private final LeaveDAO        leaveDAO        = new LeaveDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "export":
                exportEmployeesToCsv(request, response);
                break;
            case "template":
                downloadCsvTemplate(response);
                break;
            case "new":
                prepareFormData(request);
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                       .forward(request, response);
                break;
            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee emp = employeeService.getById(id);
                request.setAttribute("employee", emp);
                prepareFormData(request);
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                       .forward(request, response);
                break;
            }
            case "detail": {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee emp = employeeService.getById(id);
                request.setAttribute("employee", emp);

                // Load contracts of this employee
                List<Contract> contracts = contractDAO.findByEmployeeId(id);
                request.setAttribute("contracts", contracts);
                request.setAttribute("nextContractCode", contractDAO.getNextContractCode());

                // Load leaves and compute stats
                List<LeaveRequest> leaves = leaveDAO.findByEmployeeId(id);
                request.setAttribute("leaves", leaves);

                int approvedDaysTaken = 0;
                int currentYear = LocalDate.now().getYear();
                if (leaves != null) {
                    for (LeaveRequest lr : leaves) {
                        if ("APPROVED".equalsIgnoreCase(lr.getStatus()) && lr.getStartDate() != null && lr.getStartDate().getYear() == currentYear) {
                            approvedDaysTaken += lr.getTotalDays();
                        }
                    }
                }
                int standardLeaveDays = 12;
                int remainingLeaveDays = Math.max(0, standardLeaveDays - approvedDaysTaken);
                request.setAttribute("remainingLeaveDays", remainingLeaveDays);

                long monthsOfService = 0;
                if (emp != null && emp.getStartDate() != null) {
                    monthsOfService = ChronoUnit.MONTHS.between(emp.getStartDate(), LocalDate.now());
                }
                request.setAttribute("monthsOfService", monthsOfService);

                request.getRequestDispatcher("/WEB-INF/views/employee/employee-detail.jsp")
                       .forward(request, response);
                break;
            }
            default: {
                String keyword    = request.getParameter("keyword");
                String deptStr    = request.getParameter("departmentId");
                String posStr     = request.getParameter("positionId");
                String status     = request.getParameter("status");
                Integer deptId    = (deptStr != null && !deptStr.isEmpty()) ? Integer.parseInt(deptStr) : null;
                Integer posId     = (posStr != null && !posStr.isEmpty()) ? Integer.parseInt(posStr) : null;

                request.setAttribute("employees",    employeeService.search(keyword, deptId, posId, status));
                request.setAttribute("departments",  departmentDAO.findAll());
                request.setAttribute("positions",    positionDAO.findAll());
                request.setAttribute("keyword",      keyword);
                request.setAttribute("departmentId", deptId);
                request.setAttribute("positionId",   posId);
                request.setAttribute("status",       status);
                // KPI Stats
                request.setAttribute("statsTotal",    employeeService.countTotal());
                request.setAttribute("statsActive",   employeeService.countByStatus("ACTIVE"));
                request.setAttribute("statsOnLeave",  employeeService.countByStatus("ON_LEAVE"));
                request.setAttribute("statsInactive", employeeService.countByStatus("INACTIVE"));
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-list.jsp")
                       .forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "import": {
                importEmployeesFromCsv(request, response);
                break;
            }
            case "add": {
                Employee emp = bindEmployee(request, new Employee());
                String error = employeeService.addEmployee(emp);
                if (error != null) {
                    request.setAttribute("error", error);
                    request.setAttribute("employee", emp);
                    prepareFormData(request);
                    request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                           .forward(request, response);
                } else {
                    // Tự động sinh Hợp đồng lao động nếu có bật tùy chọn
                    String autoCreate = request.getParameter("autoCreateContract");
                    boolean shouldCreateContract = autoCreate == null || "true".equalsIgnoreCase(autoCreate) || "on".equalsIgnoreCase(autoCreate);
                    String contractCode = request.getParameter("contractCode");
                    String baseSalaryStr = request.getParameter("baseSalary");
                    int createdContractId = 0;

                    if (shouldCreateContract && contractCode != null && !contractCode.trim().isEmpty() && emp.getId() > 0) {
                        try {
                            Contract c = new Contract();
                            c.setContractCode(contractCode.trim());
                            c.setEmployeeId(emp.getId());
                            String cType = request.getParameter("contractType");
                            c.setContractType(cType != null && !cType.isEmpty() ? cType : "INDEFINITE");
                            String signDateStr = request.getParameter("contractSignDate");
                            if (signDateStr != null && !signDateStr.isEmpty()) {
                                LocalDate sd = LocalDate.parse(signDateStr);
                                c.setStartDate(sd);
                                c.setSignedDate(sd);
                            } else {
                                LocalDate sd = emp.getStartDate() != null ? emp.getStartDate() : LocalDate.now();
                                c.setStartDate(sd);
                                c.setSignedDate(sd);
                            }
                            String endDateStr = request.getParameter("contractEndDate");
                            if (endDateStr != null && !endDateStr.isEmpty()) {
                                c.setEndDate(LocalDate.parse(endDateStr));
                            }
                            if (baseSalaryStr != null && !baseSalaryStr.trim().isEmpty()) {
                                String cleanSalary = baseSalaryStr.replace(".", "").replace(",", "").trim();
                                c.setBaseSalary(new BigDecimal(cleanSalary));
                            } else {
                                c.setBaseSalary(new BigDecimal("28500000"));
                            }

                            // Pháp lý Bộ luật Lao động 2019
                            c.setSignerName("Nguyễn Văn An");
                            c.setSignerTitle("Tổng Giám Đốc");
                            c.setWorkLocation("Trụ sở Công ty Cổ phần Tập đoàn MIXIMOI (Landmark 81, TP.HCM / MIXIMOI Tower Hà Nội)");
                            c.setJobDescription("Thực hiện các nhiệm vụ chuyên môn theo sự phân công của Ban Lãnh đạo và Trưởng bộ phận.");

                            String probationStr = request.getParameter("probationDuration");
                            if (probationStr != null && !probationStr.isEmpty()) {
                                try { c.setProbationMonths(Integer.parseInt(probationStr)); } catch (NumberFormatException ignored) {}
                            }
                            String rateStr = request.getParameter("probationSalaryRate");
                            if (rateStr != null && !rateStr.isEmpty()) {
                                try { c.setProbationSalaryPct(new BigDecimal(rateStr)); } catch (Exception ignored) {}
                            }
                            c.setAllowanceAmount(new BigDecimal("2500000")); // Phụ cấp chuẩn ăn trưa, xăng xe, điện thoại

                            String idNum = request.getParameter("idNumber");
                            if (idNum != null && !idNum.isEmpty()) c.setIdentityNumber(idNum.trim());
                            String idDate = request.getParameter("idIssueDate");
                            if (idDate != null && !idDate.isEmpty()) {
                                try { c.setIdentityDate(LocalDate.parse(idDate)); } catch (Exception ignored) {}
                            }
                            String idPlace = request.getParameter("idIssuePlace");
                            if (idPlace != null && !idPlace.isEmpty()) c.setIdentityPlace(idPlace.trim());

                            c.setStatus("ACTIVE");
                            boolean contractSaved = contractDAO.insert(c);
                            if (contractSaved) {
                                Contract savedC = contractDAO.findById(c.getId());
                                if (savedC != null) createdContractId = savedC.getId();
                            }
                        } catch (Exception ex) {
                            System.err.println("EmployeeServlet: Không thể lưu Hợp đồng tự động: " + ex.getMessage());
                        }
                    }
                    String redirectUrl = request.getContextPath() + "/employees?success=added"
                            + (createdContractId > 0 ? ("&contractId=" + createdContractId) : "");
                    response.sendRedirect(redirectUrl);
                }
                break;
            }
            case "update": {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee emp = employeeService.getById(id);
                bindEmployee(request, emp);
                String error = employeeService.updateEmployee(emp);
                if (error != null) {
                    request.setAttribute("error", error);
                    request.setAttribute("employee", emp);
                    prepareFormData(request);
                    request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                           .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/employees?success=updated");
                }
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                employeeService.deactivate(id);
                response.sendRedirect(request.getContextPath() + "/employees?success=deleted");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/employees");
        }
    }

    // ===== Export to CSV/Excel =====

    private void exportEmployeesToCsv(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword    = request.getParameter("keyword");
        String deptStr    = request.getParameter("departmentId");
        String posStr     = request.getParameter("positionId");
        String status     = request.getParameter("status");
        Integer deptId    = (deptStr != null && !deptStr.isEmpty()) ? Integer.parseInt(deptStr) : null;
        Integer posId     = (posStr != null && !posStr.isEmpty()) ? Integer.parseInt(posStr) : null;

        List<Employee> list = employeeService.search(keyword, deptId, posId, status);

        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String fileName = "danh_sach_nhan_vien_" + LocalDate.now() + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // Write UTF-8 BOM so Excel opens Vietnamese diacritics perfectly
        response.getOutputStream().write(new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF});

        PrintWriter writer = new PrintWriter(response.getOutputStream(), false, StandardCharsets.UTF_8);
        writer.println("Mã nhân viên,Họ và tên,Email,Số điện thoại,Giới tính,Ngày sinh,Phòng ban,Chức vụ,Loại hình nhân sự,Ngày vào làm,Trạng thái");

        for (Employee emp : list) {
            String gender = "Khác";
            if ("MALE".equalsIgnoreCase(emp.getGender())) gender = "Nam";
            else if ("FEMALE".equalsIgnoreCase(emp.getGender())) gender = "Nữ";

            String empType = "Chính thức";
            if (emp.getEmployeeTypeId() == 2) empType = "Thử việc";
            else if (emp.getEmployeeTypeId() == 3) empType = "Thời vụ";
            else if (emp.getEmployeeTypeId() == 4) empType = "Cộng tác viên";

            String st = "Đang làm việc";
            if ("ON_LEAVE".equalsIgnoreCase(emp.getStatus())) st = "Nghỉ tạm thời";
            else if ("INACTIVE".equalsIgnoreCase(emp.getStatus())) st = "Đã nghỉ việc";

            writer.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                escapeCsv(emp.getEmployeeCode()),
                escapeCsv(emp.getFullName()),
                escapeCsv(emp.getEmail()),
                escapeCsv(emp.getPhone()),
                escapeCsv(gender),
                emp.getDateOfBirth() != null ? emp.getDateOfBirth().toString() : "",
                escapeCsv(emp.getDepartmentName()),
                escapeCsv(emp.getPositionName()),
                escapeCsv(empType),
                emp.getStartDate() != null ? emp.getStartDate().toString() : "",
                escapeCsv(st)
            );
        }
        writer.flush();
    }

    private void downloadCsvTemplate(HttpServletResponse response) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"mau_nhap_nhan_vien.csv\"");

        // Write UTF-8 BOM
        response.getOutputStream().write(new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF});

        PrintWriter writer = new PrintWriter(response.getOutputStream(), false, StandardCharsets.UTF_8);
        writer.println("Mã nhân viên,Họ và tên,Email,Số điện thoại,Giới tính,Ngày sinh (YYYY-MM-DD),Phòng ban,Chức vụ,Ngày vào làm (YYYY-MM-DD),Địa chỉ");
        writer.println("NV091,Nguyễn Văn An,nguyenvanan@miximoi.vn,0901234567,Nam,1995-05-20,Phòng Kỹ thuật,Kỹ sư phần mềm,2024-01-15,Hà Nội");
        writer.println("NV092,Trần Thị Mai,tranthimai@miximoi.vn,0987654321,Nữ,1998-11-10,Phòng Kế toán,Chuyên viên kế toán,2024-02-01,Hà Nội");
        writer.flush();
    }

    private void importEmployeesFromCsv(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = null;
        try {
            filePart = request.getPart("file");
        } catch (Exception ex) {
            request.getSession().setAttribute("importErrorMessage", "Không thể đọc file tải lên: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/employees?importError=read");
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            request.getSession().setAttribute("importErrorMessage", "Vui lòng chọn một file CSV hợp lệ để nhập.");
            response.sendRedirect(request.getContextPath() + "/employees?importError=nofile");
            return;
        }

        List<Department> departments = departmentDAO.findAll();
        List<Position> positions = positionDAO.findAll();

        int successCount = 0;
        int errorCount = 0;
        List<String> errorMessages = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(filePart.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            boolean isFirstLine = true;
            int rowIdx = 0;

            while ((line = reader.readLine()) != null) {
                rowIdx++;
                if (isFirstLine) {
                    isFirstLine = false;
                    if (line.startsWith("\uFEFF")) {
                        line = line.substring(1);
                    }
                    String lower = line.toLowerCase();
                    if (lower.contains("họ và tên") || lower.contains("họ tên") || lower.contains("mã nhân viên") || lower.contains("full name") || lower.contains("email")) {
                        continue;
                    }
                }

                line = line.trim();
                if (line.isEmpty()) continue;

                char delim = line.contains(";") && !line.contains(",") ? ';' : ',';
                List<String> cols = parseCsvLine(line, delim);
                if (cols.size() < 2) {
                    errorCount++;
                    errorMessages.add("Dòng " + rowIdx + ": Dữ liệu thiếu cột bắt buộc.");
                    continue;
                }

                String empCode = cols.size() > 0 ? cols.get(0).trim() : "";
                String fullName = cols.size() > 1 ? cols.get(1).trim() : "";
                String email = cols.size() > 2 ? cols.get(2).trim() : "";
                String phone = cols.size() > 3 ? cols.get(3).trim() : "";
                String genderStr = cols.size() > 4 ? cols.get(4).trim() : "";
                String dobStr = cols.size() > 5 ? cols.get(5).trim() : "";
                String deptStr = cols.size() > 6 ? cols.get(6).trim() : "";
                String posStr = cols.size() > 7 ? cols.get(7).trim() : "";
                String startDateStr = cols.size() > 8 ? cols.get(8).trim() : "";
                String address = cols.size() > 9 ? cols.get(9).trim() : "";

                if (fullName.isEmpty()) {
                    errorCount++;
                    errorMessages.add("Dòng " + rowIdx + ": Họ tên không được để trống.");
                    continue;
                }

                Employee emp = new Employee();
                if (empCode.isEmpty()) {
                    empCode = employeeService.getNextEmployeeCode();
                }
                emp.setEmployeeCode(empCode);
                emp.setFullName(fullName);
                emp.setEmail(!email.isEmpty() ? email : (empCode.toLowerCase() + "@miximoi.vn"));
                emp.setPhone(phone);

                String gLower = genderStr.toLowerCase();
                if (gLower.contains("nữ") || gLower.contains("female")) emp.setGender("FEMALE");
                else if (gLower.contains("khác") || gLower.contains("other")) emp.setGender("OTHER");
                else emp.setGender("MALE");

                emp.setDateOfBirth(parseFlexibleDate(dobStr));

                LocalDate sd = parseFlexibleDate(startDateStr);
                emp.setStartDate(sd != null ? sd : LocalDate.now());

                emp.setAddress(address);
                emp.setEmployeeTypeId(1);
                emp.setStatus("ACTIVE");

                int deptId = 0;
                if (!deptStr.isEmpty()) {
                    deptId = matchDepartment(deptStr, departments);
                }
                if (deptId == 0 && !departments.isEmpty()) {
                    deptId = departments.get(0).getId();
                }
                emp.setDepartmentId(deptId);

                int posId = 0;
                if (!posStr.isEmpty()) {
                    posId = matchPosition(posStr, positions);
                }
                if (posId == 0 && !positions.isEmpty()) {
                    posId = positions.get(0).getId();
                }
                emp.setPositionId(posId);

                boolean ok = employeeDAO.insert(emp);
                if (ok) {
                    successCount++;
                } else {
                    emp.setEmployeeCode(employeeService.getNextEmployeeCode());
                    if (employeeDAO.insert(emp)) {
                        successCount++;
                    } else {
                        errorCount++;
                        errorMessages.add("Dòng " + rowIdx + " (" + fullName + "): Lỗi lưu cơ sở dữ liệu.");
                    }
                }
            }
        } catch (Exception ex) {
            request.getSession().setAttribute("importErrorMessage", "Lỗi xử lý file CSV: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/employees?importError=exception");
            return;
        }

        if (!errorMessages.isEmpty()) {
            request.getSession().setAttribute("importErrorDetails", errorMessages);
        }
        response.sendRedirect(request.getContextPath() + "/employees?success=imported&count=" + successCount + "&errors=" + errorCount);
    }

    private List<String> parseCsvLine(String line, char delimiter) {
        List<String> values = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        boolean inQuotes = false;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '\"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '\"') {
                    sb.append('\"');
                    i++;
                } else {
                    inQuotes = !inQuotes;
                }
            } else if (c == delimiter && !inQuotes) {
                values.add(sb.toString().trim());
                sb.setLength(0);
            } else {
                sb.append(c);
            }
        }
        values.add(sb.toString().trim());
        return values;
    }

    private LocalDate parseFlexibleDate(String str) {
        if (str == null || str.trim().isEmpty()) return null;
        str = str.trim();
        try {
            if (str.matches("^\\d{4}-\\d{1,2}-\\d{1,2}$")) {
                return LocalDate.parse(str);
            }
            if (str.matches("^\\d{1,2}/\\d{1,2}/\\d{4}$")) {
                String[] parts = str.split("/");
                return LocalDate.of(Integer.parseInt(parts[2]), Integer.parseInt(parts[1]), Integer.parseInt(parts[0]));
            }
            if (str.matches("^\\d{1,2}-\\d{1,2}-\\d{4}$")) {
                String[] parts = str.split("-");
                return LocalDate.of(Integer.parseInt(parts[2]), Integer.parseInt(parts[1]), Integer.parseInt(parts[0]));
            }
        } catch (Exception ignored) {}
        return null;
    }

    private int matchDepartment(String nameOrId, List<Department> departments) {
        try {
            int id = Integer.parseInt(nameOrId);
            for (Department d : departments) {
                if (d.getId() == id) return id;
            }
        } catch (NumberFormatException ignored) {}

        String clean = nameOrId.toLowerCase().trim();
        for (Department d : departments) {
            if (d.getName().toLowerCase().trim().equals(clean) || d.getName().toLowerCase().contains(clean) || clean.contains(d.getName().toLowerCase())) {
                return d.getId();
            }
        }
        return 0;
    }

    private int matchPosition(String nameOrId, List<Position> positions) {
        try {
            int id = Integer.parseInt(nameOrId);
            for (Position p : positions) {
                if (p.getId() == id) return id;
            }
        } catch (NumberFormatException ignored) {}

        String clean = nameOrId.toLowerCase().trim();
        for (Position p : positions) {
            if (p.getName().toLowerCase().trim().equals(clean) || p.getName().toLowerCase().contains(clean) || clean.contains(p.getName().toLowerCase())) {
                return p.getId();
            }
        }
        return 0;
    }

    private String escapeCsv(String val) {
        if (val == null) return "";
        return val.replace("\"", "\"\"");
    }

    // ===== Helpers =====

    private boolean checkAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private void prepareFormData(HttpServletRequest request) {
        request.setAttribute("departments",        departmentDAO.findAll());
        request.setAttribute("positions",          positionDAO.findAll());
        request.setAttribute("nextEmployeeCode",   employeeService.getNextEmployeeCode());
        request.setAttribute("nextContractCode",   contractDAO.getNextContractCode());
    }

    private Employee bindEmployee(HttpServletRequest req, Employee emp) {
        emp.setFullName(req.getParameter("fullName"));
        String empCode = req.getParameter("employeeCode");
        if (empCode == null || empCode.trim().isEmpty()) {
            empCode = employeeService.getNextEmployeeCode();
        }
        emp.setEmployeeCode(empCode.trim());

        String dob = req.getParameter("dateOfBirth");
        if (dob != null && !dob.isEmpty()) emp.setDateOfBirth(LocalDate.parse(dob));
        emp.setGender(req.getParameter("gender") != null ? req.getParameter("gender") : "MALE");
        emp.setPhone(req.getParameter("phone"));
        
        // Email: ưu tiên email cá nhân hoặc company email
        String email = req.getParameter("email");
        if ((email == null || email.trim().isEmpty()) && req.getParameter("companyEmailPrefix") != null) {
            email = req.getParameter("companyEmailPrefix").trim() + "@miximoi.vn";
        }
        emp.setEmail(email);

        emp.setAddress(req.getParameter("address"));
        String deptId = req.getParameter("departmentId");
        if (deptId != null && !deptId.isEmpty()) emp.setDepartmentId(Integer.parseInt(deptId));
        String posId = req.getParameter("positionId");
        if (posId != null && !posId.isEmpty()) emp.setPositionId(Integer.parseInt(posId));
        String typeId = req.getParameter("employeeTypeId");
        if (typeId != null && !typeId.isEmpty()) emp.setEmployeeTypeId(Integer.parseInt(typeId));
        else if (emp.getEmployeeTypeId() <= 0) emp.setEmployeeTypeId(1); // default chính thức

        String sd = req.getParameter("startDate");
        if (sd != null && !sd.isEmpty()) emp.setStartDate(LocalDate.parse(sd));
        else if (emp.getStartDate() == null) emp.setStartDate(LocalDate.now());

        String st = req.getParameter("status");
        emp.setStatus(st != null && !st.isEmpty() ? st : "ACTIVE");
        return emp;
    }
}
