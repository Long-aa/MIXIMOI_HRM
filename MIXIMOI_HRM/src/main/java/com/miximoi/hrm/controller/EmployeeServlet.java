package com.miximoi.hrm.controller;

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

import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.LeaveDAO;
import com.miximoi.hrm.dao.PositionDAO;
import com.miximoi.hrm.dao.RecruitmentDAO;
import com.miximoi.hrm.dao.UserDAO;
import com.miximoi.hrm.model.Candidate;
import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.Position;
import com.miximoi.hrm.model.RecruitmentRequest;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.service.EmployeeService;
import com.miximoi.hrm.util.FileUploadUtil;
import com.miximoi.hrm.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet quản lý nhân viên. URL: /employees
 */
@WebServlet("/employees")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class EmployeeServlet extends HttpServlet {

    private final EmployeeService employeeService = new EmployeeService();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final PositionDAO positionDAO = new PositionDAO();
    private final ContractDAO contractDAO = new ContractDAO();
    private final LeaveDAO leaveDAO = new LeaveDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RecruitmentDAO recruitmentDAO = new RecruitmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) {
            return;
        }
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "export":
                exportEmployeesToCsv(request, response);
                break;
            case "template":
                downloadCsvTemplate(response);
                break;
            case "new":
            case "create":
            case "add": {
                // Tự động điền dữ liệu nếu chuyển từ ứng viên trúng tuyển (1-Click Hire Onboarding)
                String candIdStr = request.getParameter("candidateId");
                if (candIdStr != null && !candIdStr.trim().isEmpty()) {
                    int candId = parseSafeInt(candIdStr, 0);
                    if (candId > 0) {
                        Candidate cand = recruitmentDAO.findCandidateById(candId);
                        if (cand != null) {
                            Employee prefill = new Employee();
                            prefill.setFullName(cand.getFullName());
                            prefill.setEmail(cand.getEmail());
                            prefill.setPhone(cand.getPhone());
                            prefill.setResumeUrl(cand.getCvUrl());
                            if (cand.getRecruitmentRequestId() > 0) {
                                RecruitmentRequest req = recruitmentDAO.findRequestById(cand.getRecruitmentRequestId());
                                if (req != null) {
                                    if (req.getDepartmentId() != null) prefill.setDepartmentId(req.getDepartmentId());
                                    if (req.getPositionId() != null) prefill.setPositionId(req.getPositionId());
                                    if (req.getSalaryMin() != null && req.getSalaryMin().compareTo(BigDecimal.ZERO) > 0) {
                                        prefill.setBaseSalary(req.getSalaryMin());
                                    }
                                }
                            }
                            if (cand.getExpectedSalary() != null && cand.getExpectedSalary().compareTo(BigDecimal.ZERO) > 0) {
                                prefill.setBaseSalary(cand.getExpectedSalary());
                            }
                            request.setAttribute("employee", prefill);
                            request.setAttribute("candidateSource", cand);
                        }
                    }
                }
                prepareFormData(request);
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                        .forward(request, response);
                break;
            }
            case "edit": {
                int id = parseSafeInt(request.getParameter("id"), 0);
                Employee emp = employeeService.getById(id);
                if (emp == null) {
                    response.sendRedirect(request.getContextPath() + "/employees?error=notfound");
                    return;
                }
                request.setAttribute("employee", emp);
                Contract latestContract = contractDAO.findLatestByEmployee(id);
                request.setAttribute("contract", latestContract);
                User userAccount = userDAO.findByEmployeeId(id);
                request.setAttribute("userAccount", userAccount);
                prepareFormData(request);
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                        .forward(request, response);
                break;
            }
            case "detail": {
                int id = parseSafeInt(request.getParameter("id"), 0);
                Employee emp = employeeService.getById(id);
                if (emp == null) {
                    response.sendRedirect(request.getContextPath() + "/employees?error=notfound");
                    return;
                }
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
                int seniorityDays = 0;
                if (emp.getStartDate() != null) {
                    long yearsOfService = ChronoUnit.YEARS.between(emp.getStartDate(), LocalDate.now());
                    seniorityDays = (int) (yearsOfService / 5);
                }
                int totalQuota = standardLeaveDays + seniorityDays;
                int remainingLeaveDays = Math.max(0, totalQuota - approvedDaysTaken);
                request.setAttribute("standardLeaveDays", standardLeaveDays);
                request.setAttribute("seniorityLeaveDays", seniorityDays);
                request.setAttribute("totalLeaveQuota", totalQuota);
                request.setAttribute("approvedDaysTaken", approvedDaysTaken);
                request.setAttribute("remainingLeaveDays", remainingLeaveDays);

                long monthsOfService = 0;
                if (emp.getStartDate() != null) {
                    monthsOfService = ChronoUnit.MONTHS.between(emp.getStartDate(), LocalDate.now());
                }
                request.setAttribute("monthsOfService", monthsOfService);

                request.getRequestDispatcher("/WEB-INF/views/employee/employee-detail.jsp")
                        .forward(request, response);
                break;
            }
            default: {
                String keyword = request.getParameter("keyword");
                String deptStr = request.getParameter("departmentId");
                String posStr = request.getParameter("positionId");
                String status = request.getParameter("status");
                Integer deptId = (deptStr != null && !deptStr.isEmpty()) ? parseSafeInt(deptStr, 0) : null;
                Integer posId = (posStr != null && !posStr.isEmpty()) ? parseSafeInt(posStr, 0) : null;
                if (deptId != null && deptId == 0) {
                    deptId = null;
                }
                if (posId != null && posId == 0) {
                    posId = null;
                }

                List<Employee> allEmployees = employeeService.search(keyword, deptId, posId, status);
                int totalEmployees = allEmployees != null ? allEmployees.size() : 0;
                int pageSize = 10;
                int totalPages = Math.max(1, (int) Math.ceil((double) totalEmployees / pageSize));
                int page = 1;
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    page = Math.max(1, Math.min(parseSafeInt(pageStr.trim(), 1), totalPages));
                }
                int fromIndex = (page - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, totalEmployees);
                List<Employee> pagedEmployees = (allEmployees != null && fromIndex < totalEmployees)
                        ? allEmployees.subList(fromIndex, toIndex)
                        : new ArrayList<>();

                request.setAttribute("employees", pagedEmployees);
                request.setAttribute("totalEmployees", totalEmployees);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("departments", departmentDAO.findAll());
                request.setAttribute("positions", positionDAO.findAll());
                request.setAttribute("keyword", keyword);
                request.setAttribute("departmentId", deptId);
                request.setAttribute("positionId", posId);
                request.setAttribute("status", status);
                // KPI Stats
                request.setAttribute("statsTotal", employeeService.countTotal());
                request.setAttribute("statsActive", employeeService.countByStatus("ACTIVE"));
                request.setAttribute("statsOnLeave", employeeService.countByStatus("ON_LEAVE"));
                request.setAttribute("statsInactive", employeeService.countByStatus("INACTIVE"));
                request.getRequestDispatcher("/WEB-INF/views/employee/employee-list.jsp")
                        .forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) {
            return;
        }
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "import": {
                importEmployeesFromCsv(request, response);
                break;
            }
            case "add": {
                Employee emp = bindEmployee(request, new Employee());
                // Handle file uploads (Avatar, CCCD mặt trước/sau, Hồ sơ đính kèm)
                try {
                    String avatarUrl = saveUpload(request, "avatarFile", "avatars");
                    if (avatarUrl != null) {
                        emp.setAvatarUrl(avatarUrl);
                    }
                    String cccdFrontUrl = saveUpload(request, "cccdFrontFile", "cccd");
                    if (cccdFrontUrl != null) {
                        emp.setIdCardFrontUrl(cccdFrontUrl);
                    }
                    String cccdBackUrl = saveUpload(request, "cccdBackFile", "cccd");
                    if (cccdBackUrl != null) {
                        emp.setIdCardBackUrl(cccdBackUrl);
                    }
                    String resumeUrl = saveUpload(request, "resumeFile", "resumes");
                    if (resumeUrl != null) {
                        emp.setResumeUrl(resumeUrl);
                    }
                } catch (IllegalArgumentException ex) {
                    request.setAttribute("error", ex.getMessage());
                    request.setAttribute("employee", emp);
                    prepareFormData(request);
                    request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                            .forward(request, response);
                    return;
                }

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
                            LocalDate sd = parseFlexibleDate(signDateStr);
                            if (sd == null) {
                                sd = emp.getStartDate() != null ? emp.getStartDate() : LocalDate.now();
                            }
                            c.setStartDate(sd);
                            c.setSignedDate(sd);

                            String endDateStr = request.getParameter("contractEndDate");
                            c.setEndDate(parseFlexibleDate(endDateStr));

                            if (baseSalaryStr != null && !baseSalaryStr.trim().isEmpty()) {
                                String cleanSalary = baseSalaryStr.replace(".", "").replace(",", "").trim();
                                c.setBaseSalary(new BigDecimal(cleanSalary));
                            } else {
                                c.setBaseSalary(new BigDecimal("28500000"));
                            }

                            // Pháp lý Bộ luật Lao động 2019
                            c.setSignerName("Nguyễn Văn An");
                            c.setSignerTitle("Tổng Giám Đốc");
                            String workLoc = request.getParameter("workLocation");
                            c.setWorkLocation(workLoc != null && !workLoc.trim().isEmpty() ? workLoc.trim() : "Trụ sở Công ty Cổ phần Tập đoàn MIXIMOI (Landmark 81, TP.HCM / MIXIMOI Tower Hà Nội)");
                            c.setJobDescription("Thực hiện các nhiệm vụ chuyên môn theo sự phân công của Ban Lãnh đạo và Trưởng bộ phận.");

                            String probationStr = request.getParameter("probationDuration");
                            if (probationStr != null && !probationStr.isEmpty()) {
                                c.setProbationMonths(parseSafeInt(probationStr, 0));
                            }
                            String rateStr = request.getParameter("probationSalaryRate");
                            if (rateStr != null && !rateStr.isEmpty()) {
                                try {
                                    c.setProbationSalaryPct(new BigDecimal(rateStr));
                                } catch (Exception ignored) {
                                }
                            }
                            c.setAllowanceAmount(new BigDecimal("2500000")); // Phụ cấp chuẩn ăn trưa, xăng xe, điện thoại

                            String idNum = request.getParameter("identityNumber");
                            if (idNum == null || idNum.isEmpty()) {
                                idNum = request.getParameter("idNumber");
                            }
                            if (idNum == null || idNum.isEmpty()) {
                                idNum = emp.getIdentityNumber();
                            }
                            c.setIdentityNumber(idNum);

                            LocalDate idDate = emp.getIdentityDate();
                            String idDateStr = request.getParameter("identityDate");
                            if (idDateStr == null || idDateStr.isEmpty()) {
                                idDateStr = request.getParameter("idIssueDate");
                            }
                            LocalDate parsedIdDate = parseFlexibleDate(idDateStr);
                            if (parsedIdDate != null) {
                                idDate = parsedIdDate;
                            }
                            c.setIdentityDate(idDate);

                            String idPlace = request.getParameter("identityPlace");
                            if (idPlace == null || idPlace.isEmpty()) {
                                idPlace = request.getParameter("idIssuePlace");
                            }
                            if (idPlace == null || idPlace.isEmpty()) {
                                idPlace = emp.getIdentityPlace();
                            }
                            c.setIdentityPlace(idPlace);

                            // Lưu file đính kèm hợp đồng nếu có upload
                            String contractFileUrl = saveUpload(request, "contractFile", "contracts");
                            if (contractFileUrl != null) {
                                c.setContractFileUrl(contractFileUrl);
                            }

                            c.setStatus("ACTIVE");
                            boolean contractSaved = contractDAO.insert(c);
                            if (contractSaved) {
                                Contract savedC = contractDAO.findById(c.getId());
                                if (savedC != null) {
                                    createdContractId = savedC.getId();
                                }
                            }
                        } catch (Exception ex) {
                            System.err.println("EmployeeServlet: Không thể lưu Hợp đồng tự động: " + ex.getMessage());
                        }
                    }

                    // Tự động kích hoạt tài khoản SSO người dùng
                    String ssoUser = request.getParameter("ssoUsername");
                    if (ssoUser == null || ssoUser.trim().isEmpty()) {
                        String compEmail = request.getParameter("companyEmail");
                        if (compEmail != null && compEmail.contains("@")) {
                            ssoUser = compEmail.substring(0, compEmail.indexOf('@')).trim();
                        } else if (request.getParameter("companyEmailPrefix") != null && !request.getParameter("companyEmailPrefix").trim().isEmpty()) {
                            ssoUser = request.getParameter("companyEmailPrefix").trim();
                        } else {
                            ssoUser = emp.getEmployeeCode().toLowerCase();
                        }
                    }
                    if (ssoUser != null && !ssoUser.trim().isEmpty() && emp.getId() > 0) {
                        try {
                            User existing = userDAO.findByUsername(ssoUser.trim());
                            if (existing == null) {
                                User u = new User();
                                u.setUsername(ssoUser.trim());
                                u.setPassword(PasswordUtil.hash("123456"));
                                String role = "EMPLOYEE";
                                if (emp.getPositionId() == 1 || emp.getPositionId() == 2) role = "ADMIN";
                                else if (emp.getPositionId() == 3) role = "MANAGER";
                                else if (emp.getDepartmentId() == 2) role = "HR";
                                else if (emp.getDepartmentId() == 3) role = "ACCOUNTANT";
                                u.setRole(role);
                                u.setEmployeeId(emp.getId());
                                u.setActive(true);
                                userDAO.insert(u);
                            }
                        } catch (Exception ex) {
                            System.err.println("EmployeeServlet: Không thể tạo tài khoản người dùng: " + ex.getMessage());
                        }
                    }

                    String redirectUrl = request.getContextPath() + "/employees?success=added"
                            + (createdContractId > 0 ? ("&contractId=" + createdContractId) : "");
                    response.sendRedirect(redirectUrl);
                }
                break;
            }
            case "update": {
                int id = parseSafeInt(request.getParameter("id"), 0);
                Employee emp = employeeService.getById(id);
                if (emp == null) {
                    response.sendRedirect(request.getContextPath() + "/employees?error=notfound");
                    return;
                }
                bindEmployee(request, emp);
                // Handle file uploads (only update if new file provided)
                try {
                    String avatarUrl = saveUpload(request, "avatarFile", "avatars");
                    if (avatarUrl != null) {
                        emp.setAvatarUrl(avatarUrl);
                    }
                    String cccdFrontUrl = saveUpload(request, "cccdFrontFile", "cccd");
                    if (cccdFrontUrl != null) {
                        emp.setIdCardFrontUrl(cccdFrontUrl);
                    }
                    String cccdBackUrl = saveUpload(request, "cccdBackFile", "cccd");
                    if (cccdBackUrl != null) {
                        emp.setIdCardBackUrl(cccdBackUrl);
                    }
                    String resumeUrl = saveUpload(request, "resumeFile", "resumes");
                    if (resumeUrl != null) {
                        emp.setResumeUrl(resumeUrl);
                    }
                } catch (IllegalArgumentException ex) {
                    request.setAttribute("error", ex.getMessage());
                    request.setAttribute("employee", emp);
                    Contract latestContract = contractDAO.findLatestByEmployee(emp.getId());
                    request.setAttribute("contract", latestContract);
                    prepareFormData(request);
                    request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                            .forward(request, response);
                    return;
                }

                String error = employeeService.updateEmployee(emp);
                if (error != null) {
                    request.setAttribute("error", error);
                    request.setAttribute("employee", emp);
                    Contract latestContract = contractDAO.findLatestByEmployee(emp.getId());
                    request.setAttribute("contract", latestContract);
                    prepareFormData(request);
                    request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp")
                            .forward(request, response);
                } else {
                    // Đồng bộ thông tin Hợp đồng nếu có cung cấp
                    String contractCode = request.getParameter("contractCode");
                    if (contractCode != null && !contractCode.trim().isEmpty()) {
                        try {
                            Contract c = contractDAO.findLatestByEmployee(emp.getId());
                            boolean isNew = false;
                            if (c == null) {
                                c = new Contract();
                                c.setEmployeeId(emp.getId());
                                c.setContractCode(contractCode.trim());
                                c.setStatus("ACTIVE");
                                c.setSignerName("Nguyễn Văn An");
                                c.setSignerTitle("Tổng Giám Đốc");
                                c.setWorkLocation("Trụ sở MIXIMOI Tower");
                                c.setJobDescription("Thực hiện nhiệm vụ chuyên môn được phân công");
                                c.setAllowanceAmount(new BigDecimal("2500000"));
                                isNew = true;
                            } else {
                                c.setContractCode(contractCode.trim());
                            }
                            String cType = request.getParameter("contractType");
                            if (cType != null && !cType.isEmpty()) {
                                c.setContractType(cType);
                            }
                            String signDateStr = request.getParameter("contractSignDate");
                            LocalDate sd = parseFlexibleDate(signDateStr);
                            if (sd != null) {
                                c.setStartDate(sd);
                                c.setSignedDate(sd);
                            }
                            String endDateStr = request.getParameter("contractEndDate");
                            c.setEndDate(parseFlexibleDate(endDateStr));

                            if (emp.getBaseSalary() != null) {
                                c.setBaseSalary(emp.getBaseSalary());
                            }
                            String probRateStr = request.getParameter("probationSalaryRate");
                            if (probRateStr != null && !probRateStr.isEmpty()) {
                                try {
                                    c.setProbationSalaryPct(new BigDecimal(probRateStr));
                                } catch (Exception ignored) {
                                }
                            }
                            String probationDurationStr = request.getParameter("probationDuration");
                            if (probationDurationStr != null && !probationDurationStr.isEmpty()) {
                                c.setProbationMonths(parseSafeInt(probationDurationStr, 0));
                            }
                            String workLoc = request.getParameter("workLocation");
                            if (workLoc != null && !workLoc.trim().isEmpty()) {
                                c.setWorkLocation(workLoc);
                            }
                            if (c.getSignerName() == null || c.getSignerName().isEmpty()) {
                                c.setSignerName("Nguyễn Văn An");
                            }
                            if (c.getSignerTitle() == null || c.getSignerTitle().isEmpty()) {
                                c.setSignerTitle("Tổng Giám Đốc");
                            }
                            if (c.getWorkLocation() == null || c.getWorkLocation().isEmpty()) {
                                c.setWorkLocation("Trụ sở Landmark 81, TP.HCM / MIXIMOI Tower");
                            }
                            if (c.getAllowanceAmount() == null) {
                                c.setAllowanceAmount(new BigDecimal("2500000"));
                            }
                            c.setIdentityNumber(emp.getIdentityNumber());
                            c.setIdentityDate(emp.getIdentityDate());
                            c.setIdentityPlace(emp.getIdentityPlace());
                            
                            String contractFileUrl = saveUpload(request, "contractFile", "contracts");
                            if (contractFileUrl != null) {
                                c.setContractFileUrl(contractFileUrl);
                            }

                            if (isNew) {
                                contractDAO.insert(c);
                            } else {
                                contractDAO.update(c);
                            }
                        } catch (Exception ex) {
                            System.err.println("EmployeeServlet: Lỗi đồng bộ HĐ khi update: " + ex.getMessage());
                        }
                    }

                    // Cập nhật tài khoản người dùng liên kết nếu có
                    try {
                        User existingUser = userDAO.findByEmployeeId(emp.getId());
                        if (existingUser != null) {
                            userDAO.updateUserProfile(existingUser.getId(), emp.getId(), emp.getFullName(), emp.getEmail(), emp.getPhone());
                        }
                    } catch (Exception ex) {
                        System.err.println("EmployeeServlet: Không thể đồng bộ tài khoản người dùng: " + ex.getMessage());
                    }

                    response.sendRedirect(request.getContextPath() + "/employees?success=updated");
                }
                break;
            }
            case "delete": {
                int id = parseSafeInt(request.getParameter("id"), 0);
                if (id > 0) {
                    employeeService.deactivate(id);
                }
                response.sendRedirect(request.getContextPath() + "/employees?success=deleted");
                break;
            }
            case "bulkDelete": {
                String[] idsArr = request.getParameterValues("ids");
                int count = 0;
                if (idsArr != null && idsArr.length > 0) {
                    java.util.List<Integer> ids = new java.util.ArrayList<>();
                    for (String sid : idsArr) {
                        int parsedId = parseSafeInt(sid, 0);
                        if (parsedId > 0) {
                            ids.add(parsedId);
                        }
                    }
                    if (!ids.isEmpty()) {
                        count = employeeDAO.deactivateBulk(ids);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/employees?success=deleted&count=" + count);
                break;
            }
            case "bulkExport": {
                String[] idsArr = request.getParameterValues("ids");
                List<Employee> list;
                if (idsArr != null && idsArr.length > 0) {
                    java.util.List<Integer> ids = new java.util.ArrayList<>();
                    for (String sid : idsArr) {
                        int parsedId = parseSafeInt(sid, 0);
                        if (parsedId > 0) {
                            ids.add(parsedId);
                        }
                    }
                    list = employeeDAO.findByIds(ids);
                } else {
                    String keyword = request.getParameter("keyword");
                    String deptStr = request.getParameter("departmentId");
                    String posStr = request.getParameter("positionId");
                    String status = request.getParameter("status");
                    Integer deptId = (deptStr != null && !deptStr.isEmpty()) ? parseSafeInt(deptStr, 0) : null;
                    Integer posId = (posStr != null && !posStr.isEmpty()) ? parseSafeInt(posStr, 0) : null;
                    if (deptId != null && deptId == 0) {
                        deptId = null;
                    }
                    if (posId != null && posId == 0) {
                        posId = null;
                    }
                    list = employeeService.search(keyword, deptId, posId, status);
                }
                exportListToCsv(response, list);
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/employees");
        }
    }

    // ===== Export to CSV/Excel =====
    private void exportEmployeesToCsv(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = request.getParameter("keyword");
        String deptStr = request.getParameter("departmentId");
        String posStr = request.getParameter("positionId");
        String status = request.getParameter("status");
        Integer deptId = (deptStr != null && !deptStr.isEmpty()) ? parseSafeInt(deptStr, 0) : null;
        Integer posId = (posStr != null && !posStr.isEmpty()) ? parseSafeInt(posStr, 0) : null;
        if (deptId != null && deptId == 0) {
            deptId = null;
        }
        if (posId != null && posId == 0) {
            posId = null;
        }
        exportListToCsv(response, employeeService.search(keyword, deptId, posId, status));
    }

    private void exportListToCsv(HttpServletResponse response, List<Employee> list) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String fileName = "danh_sach_nhan_vien_" + LocalDate.now() + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // Write UTF-8 BOM so Excel opens Vietnamese diacritics perfectly
        response.getOutputStream().write(new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF});

        PrintWriter writer = new PrintWriter(response.getOutputStream(), false, StandardCharsets.UTF_8);
        writer.println("Mã nhân viên,Họ và tên,Email,Số điện thoại,Giới tính,Ngày sinh,Phòng ban,Chức vụ,Loại hình nhân sự,Ngày vào làm,Trạng thái");

        if (list != null) {
            for (Employee emp : list) {
                String gender = "Khác";
                if ("MALE".equalsIgnoreCase(emp.getGender())) {
                    gender = "Nam";
                } else if ("FEMALE".equalsIgnoreCase(emp.getGender())) {
                    gender = "Nữ";
                }

                String empType = "Chính thức";
                if (emp.getEmployeeTypeId() == 2) {
                    empType = "Thử việc";
                } else if (emp.getEmployeeTypeId() == 3) {
                    empType = "Thời vụ";
                } else if (emp.getEmployeeTypeId() == 4) {
                    empType = "Cộng tác viên";
                }

                String st = "Đang làm việc";
                if ("ON_LEAVE".equalsIgnoreCase(emp.getStatus())) {
                    st = "Nghỉ tạm thời";
                } else if ("INACTIVE".equalsIgnoreCase(emp.getStatus())) {
                    st = "Đã nghỉ việc";
                }

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
        }
        writer.flush();
    }

    private void downloadCsvTemplate(HttpServletResponse response) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"mau_nhap_nhan_vien.csv\"");

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
                if (line.isEmpty()) {
                    continue;
                }

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
                if (gLower.contains("nữ") || gLower.contains("female")) {
                    emp.setGender("FEMALE");
                } else if (gLower.contains("khác") || gLower.contains("other")) {
                    emp.setGender("OTHER");
                } else {
                    emp.setGender("MALE");
                }

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
        if (str == null || str.trim().isEmpty()) {
            return null;
        }
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
        } catch (Exception ignored) {
        }
        return null;
    }

    private int parseSafeInt(String str, int defaultValue) {
        if (str == null || str.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(str.trim());
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    private int matchDepartment(String nameOrId, List<Department> departments) {
        try {
            int id = Integer.parseInt(nameOrId);
            for (Department d : departments) {
                if (d.getId() == id) {
                    return id;
                }
            }
        } catch (NumberFormatException ignored) {
        }

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
                if (p.getId() == id) {
                    return id;
                }
            }
        } catch (NumberFormatException ignored) {
        }

        String clean = nameOrId.toLowerCase().trim();
        for (Position p : positions) {
            if (p.getName().toLowerCase().trim().equals(clean) || p.getName().toLowerCase().contains(clean) || clean.contains(p.getName().toLowerCase())) {
                return p.getId();
            }
        }
        return 0;
    }

    private String escapeCsv(String val) {
        if (val == null) {
            return "";
        }
        return val.replace("\"", "\"\"");
    }

    // ===== Helpers =====
    private String saveUpload(HttpServletRequest request, String fieldName, String folder) {
        try {
            Part part = request.getPart(fieldName);
            if (part == null || part.getSize() <= 0 || part.getSubmittedFileName() == null
                    || part.getSubmittedFileName().trim().isEmpty()) {
                return null;
            }

            String url = FileUploadUtil.saveFile(part, folder, request);
            if (url == null || url.trim().isEmpty()) {
                System.err.println("EmployeeServlet: FileUploadUtil không lưu được [" + fieldName + "]");
                return null;
            }

            System.out.println("EmployeeServlet: uploaded " + fieldName + " -> " + url);
            return url;
        } catch (IllegalArgumentException ex) {
            throw ex;
        } catch (Exception ex) {
            System.err.println("EmployeeServlet: upload lỗi [" + fieldName + "]: " + ex.getMessage());
            return null;
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

    private void prepareFormData(HttpServletRequest request) {
        request.setAttribute("departments", departmentDAO.findAll());
        request.setAttribute("positions", positionDAO.findAll());
        request.setAttribute("nextEmployeeCode", employeeService.getNextEmployeeCode());
        request.setAttribute("nextContractCode", contractDAO.getNextContractCode());
    }

    private Employee bindEmployee(HttpServletRequest req, Employee emp) {
        emp.setFullName(req.getParameter("fullName"));
        String empCode = req.getParameter("employeeCode");
        if (empCode == null || empCode.trim().isEmpty()) {
            empCode = employeeService.getNextEmployeeCode();
        }
        emp.setEmployeeCode(empCode.trim());

        String dob = req.getParameter("dateOfBirth");
        emp.setDateOfBirth(parseFlexibleDate(dob));

        emp.setGender(req.getParameter("gender") != null ? req.getParameter("gender") : "MALE");
        String rawPhone = req.getParameter("phone");
        if (rawPhone != null) {
            rawPhone = rawPhone.replaceAll("\\s+", "").replace(".", "").replace("-", "");
        }
        emp.setPhone(rawPhone);

        // Email: ưu tiên email cá nhân hoặc company email
        String email = req.getParameter("email");
        if ((email == null || email.trim().isEmpty()) && req.getParameter("companyEmailPrefix") != null) {
            email = req.getParameter("companyEmailPrefix").trim() + "@miximoi.vn";
        }
        emp.setEmail(email);

        emp.setAddress(req.getParameter("address"));
        emp.setTempAddress(req.getParameter("tempAddress"));
        emp.setNationality(req.getParameter("nationality"));
        emp.setEthnicity(req.getParameter("ethnicity"));
        emp.setReligion(req.getParameter("religion"));
        emp.setMaritalStatus(req.getParameter("maritalStatus"));

        String avatarUrlParam = req.getParameter("avatarUrl");
        if (avatarUrlParam != null) {
            emp.setAvatarUrl(avatarUrlParam.trim().isEmpty() ? null : avatarUrlParam.trim());
        }
        String idFrontParam = req.getParameter("idCardFrontUrl");
        if (idFrontParam != null) {
            emp.setIdCardFrontUrl(idFrontParam.trim().isEmpty() ? null : idFrontParam.trim());
        }
        String idBackParam = req.getParameter("idCardBackUrl");
        if (idBackParam != null) {
            emp.setIdCardBackUrl(idBackParam.trim().isEmpty() ? null : idBackParam.trim());
        }
        String resumeUrlParam = req.getParameter("resumeUrl");
        if (resumeUrlParam != null) {
            emp.setResumeUrl(resumeUrlParam.trim().isEmpty() ? null : resumeUrlParam.trim());
        }

        // CCCD / Giấy tờ tùy thân
        emp.setIdentityNumber(req.getParameter("identityNumber"));
        String idDate = req.getParameter("identityDate");
        emp.setIdentityDate(parseFlexibleDate(idDate));
        emp.setIdentityPlace(req.getParameter("identityPlace"));

        String deptId = req.getParameter("departmentId");
        if (deptId != null && !deptId.isEmpty()) {
            emp.setDepartmentId(parseSafeInt(deptId, 0));
        }
        String posId = req.getParameter("positionId");
        if (posId != null && !posId.isEmpty()) {
            emp.setPositionId(parseSafeInt(posId, 0));
        }
        String typeId = req.getParameter("employeeTypeId");
        if (typeId != null && !typeId.isEmpty()) {
            emp.setEmployeeTypeId(parseSafeInt(typeId, 1));
        } else if (emp.getEmployeeTypeId() <= 0) {
            emp.setEmployeeTypeId(1);
        }

        String sd = req.getParameter("startDate");
        LocalDate parsedSd = parseFlexibleDate(sd);
        if (parsedSd != null) {
            emp.setStartDate(parsedSd);
        } else if (emp.getStartDate() == null) {
            emp.setStartDate(LocalDate.now());
        }

        String endDate = req.getParameter("endDate");
        emp.setEndDate(parseFlexibleDate(endDate));

        emp.setTerminationReason(req.getParameter("terminationReason"));

        String st = req.getParameter("status");
        emp.setStatus(st != null && !st.isEmpty() ? st : "ACTIVE");

        // Lương & tài chính
        String salaryStr = req.getParameter("baseSalary");
        if (salaryStr != null && !salaryStr.trim().isEmpty()) {
            try {
                String cleanSalary = salaryStr.replace(".", "").replace(",", "").trim();
                emp.setBaseSalary(new java.math.BigDecimal(cleanSalary));
            } catch (Exception ignored) {
            }
        }
        emp.setBankAccount(req.getParameter("bankAccount"));
        emp.setBankName(req.getParameter("bankName"));
        emp.setBankBranch(req.getParameter("bankBranch"));
        emp.setTaxCode(req.getParameter("taxCode"));
        emp.setInsuranceNumber(req.getParameter("insuranceNumber"));

        // Liên hệ khẩn cấp
        emp.setEmergencyContactName(req.getParameter("emergencyContactName"));
        emp.setEmergencyContactPhone(req.getParameter("emergencyContactPhone"));
        emp.setEmergencyContactRelation(req.getParameter("emergencyContactRelation"));

        // Công việc & Định biên
        emp.setWorkLocation(req.getParameter("workLocation"));
        emp.setEmployeeLevel(req.getParameter("employeeLevel"));
        emp.setSecondaryPhone(req.getParameter("secondaryPhone"));
        emp.setLineManager(req.getParameter("lineManager"));
        emp.setMentorName(req.getParameter("mentorName"));

        return emp;
    }
}
