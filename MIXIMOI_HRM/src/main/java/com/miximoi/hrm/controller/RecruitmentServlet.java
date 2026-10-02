package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.DepartmentDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.PositionDAO;
import com.miximoi.hrm.model.Candidate;
import com.miximoi.hrm.model.Interview;
import com.miximoi.hrm.model.RecruitmentDashboardStats;
import com.miximoi.hrm.model.RecruitmentRequest;
import com.miximoi.hrm.service.RecruitmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Servlet quản trị tuyển dụng toàn diện:
 * - /recruitment : Tuyển dụng tổng quan & Phễu tuyển dụng (kết nối Database thật)
 * - /recruitment?view=jobs : Quản lý Vị trí tuyển dụng & Xem trước JD
 * - /recruitment?view=candidates : Quản lý Hồ sơ ứng viên & ATS Kanban
 * - /recruitment?action=export_report : Xuất file báo cáo tuyển dụng CSV/Excel UTF-8
 */
@WebServlet("/recruitment")
public class RecruitmentServlet extends HttpServlet {

    private final RecruitmentService recruitmentService = new RecruitmentService();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final PositionDAO positionDAO = new PositionDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String view = request.getParameter("view");

        // 1. Xử lý Xuất báo cáo CSV/Excel UTF-8 BOM
        if ("export_report".equalsIgnoreCase(action)) {
            String quarter = request.getParameter("quarter");
            if (quarter == null || quarter.trim().isEmpty()) quarter = "Q3/2026";
            Integer deptId = parseInteger(request.getParameter("departmentId"));

            byte[] csvBytes = recruitmentService.generateRecruitmentReportCSV(quarter, deptId);
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"Bao_Cao_Tuyen_Dung_MIXIMOI_" + quarter.replace("/", "_") + ".csv\"");
            response.setContentLength(csvBytes.length);

            try (OutputStream out = response.getOutputStream()) {
                out.write(csvBytes);
                out.flush();
            }
            return;
        }

        // 2. Chuyển hướng các view con
        request.setAttribute("activeMenu", "recruitment");

        HttpSession currentSession = request.getSession(false);
        com.miximoi.hrm.model.User currentUser = (com.miximoi.hrm.model.User) (currentSession != null ? currentSession.getAttribute("currentUser") : null);
        boolean isHrOrAdmin = currentUser != null && (currentUser.isAdmin() || currentUser.isHr());

        // View 2.1: Bảng Tin Tuyển Dụng Nội Bộ Toàn Công Ty (Internal Jobs)
        if ("internal".equalsIgnoreCase(view) || (!isHrOrAdmin && (view == null || view.trim().isEmpty()))) {
            request.setAttribute("activeSubMenu", "internal");

            Integer deptId = parseInteger(request.getParameter("departmentId"));
            String priority = request.getParameter("priority");
            String search = request.getParameter("search");
            BigDecimal salMin = parseBigDecimal(request.getParameter("salaryMin"));
            BigDecimal salMax = parseBigDecimal(request.getParameter("salaryMax"));

            // Lấy toàn bộ vị trí đang tuyển công khai / nội bộ
            List<RecruitmentRequest> internalJobs = recruitmentService.getRequests(null, deptId, "OPEN", null, search, null, priority, salMin, salMax);
            request.setAttribute("jobs", internalJobs);

            // Nạp danh sách tất cả các vị trí đang mở để phục vụ modal Giới thiệu ứng viên
            List<RecruitmentRequest> allOpenJobs = recruitmentService.getRequests(null, null, "OPEN", null, null, null);
            request.setAttribute("allOpenJobs", allOpenJobs);

            // Lấy các vị trí vừa mở tuyển dụng gần đây (Recent open jobs)
            List<RecruitmentRequest> recentJobs = recruitmentService.getRecentOpenRequests(5);
            request.setAttribute("recentJobs", recentJobs);

            // Lấy danh sách thông báo tuyển dụng của công ty
            com.miximoi.hrm.dao.NotificationDAO notifDAO = new com.miximoi.hrm.dao.NotificationDAO();
            request.setAttribute("recruitmentNotices", notifDAO.findRecentRecruitmentAnnouncements(5));

            request.setAttribute("departments", departmentDAO.findAll());
            request.setAttribute("selectedDeptId", deptId);
            request.setAttribute("selectedPriority", priority);
            request.setAttribute("searchKeyword", search);
            request.setAttribute("selectedSalaryMin", salMin);
            request.setAttribute("selectedSalaryMax", salMax);

            // Vị trí đang được chọn xem chi tiết (nếu có jobId)
            Integer jobId = parseInteger(request.getParameter("jobId"));
            RecruitmentRequest selectedJob = null;
            if (jobId != null) {
                selectedJob = recruitmentService.getRequestById(jobId);
            }
            if (selectedJob == null && !internalJobs.isEmpty()) {
                selectedJob = internalJobs.get(0);
            }
            request.setAttribute("selectedJob", selectedJob);

            // Nạp danh sách đơn ứng tuyển nội bộ & đơn Referral cho bộ phận HR và nhân sự theo dõi
            List<Candidate> allCands = recruitmentService.getAllCandidates(null, null, null, null);
            List<Candidate> internalApplicants = new java.util.ArrayList<>();
            List<Candidate> referralCandidates = new java.util.ArrayList<>();
            for (Candidate c : allCands) {
                String src = c.getSource() != null ? c.getSource().toLowerCase() : "";
                String notes = c.getNotes() != null ? c.getNotes().toLowerCase() : "";
                if (src.contains("ứng tuyển nội bộ") || notes.contains("ứng tuyển nội bộ")) {
                    internalApplicants.add(c);
                } else if (src.contains("ref") || src.contains("nội bộ") || notes.contains("referral") || notes.contains("giới thiệu")) {
                    referralCandidates.add(c);
                }
            }
            request.setAttribute("internalApplicants", internalApplicants);
            request.setAttribute("referralCandidates", referralCandidates);

            request.getRequestDispatcher("/WEB-INF/views/recruitment/recruitment-internal.jsp")
                   .forward(request, response);
            return;
        }

        if ("jobs".equalsIgnoreCase(view)) {
            request.setAttribute("activeSubMenu", "jobs");

            String quarter = request.getParameter("quarter");
            Integer deptId = parseInteger(request.getParameter("departmentId"));
            String status = request.getParameter("status");
            String priority = request.getParameter("priority");
            String search = request.getParameter("search");
            String pill = request.getParameter("pill");
            BigDecimal salMin = parseBigDecimal(request.getParameter("salaryMin"));
            BigDecimal salMax = parseBigDecimal(request.getParameter("salaryMax"));

            List<RecruitmentRequest> allJobs = recruitmentService.getRequests(quarter, deptId, status, null, search, pill, priority, salMin, salMax);
            request.setAttribute("jobs", allJobs);
            request.setAttribute("departments", departmentDAO.findAll());
            request.setAttribute("positions", positionDAO.findAll());
            request.setAttribute("employees", employeeDAO.findAll());
            request.setAttribute("nextRequestCode", recruitmentService.getNextRequestCode());

            // Bind filter parameters for UI preservation
            request.setAttribute("selectedDeptId", deptId);
            request.setAttribute("selectedStatus", status);
            request.setAttribute("selectedPriority", priority);
            request.setAttribute("selectedSalaryMin", salMin);
            request.setAttribute("selectedSalaryMax", salMax);
            request.setAttribute("searchKeyword", search);

            // Xác định vị trí được chọn để hiển thị trên Khung Preview (mặc định là vị trí đầu tiên)
            Integer selectedJobId = parseInteger(request.getParameter("jobId"));
            RecruitmentRequest selectedJob = null;
            if (selectedJobId != null) {
                for (RecruitmentRequest r : allJobs) {
                    if (r.getId() == selectedJobId) {
                        selectedJob = r;
                        break;
                    }
                }
            }
            if (selectedJob == null && !allJobs.isEmpty()) {
                selectedJob = allJobs.get(0);
            }
            request.setAttribute("selectedJob", selectedJob);

            // Thống kê 4 thẻ KPI Vị trí
            int openCount = 0, pausedCount = 0, filledCount = 0, closedCount = 0;
            for (RecruitmentRequest r : allJobs) {
                if ("OPEN".equalsIgnoreCase(r.getStatus())) openCount++;
                else if ("PAUSED".equalsIgnoreCase(r.getStatus())) pausedCount++;
                else if ("FILLED".equalsIgnoreCase(r.getStatus())) filledCount++;
                else if ("CLOSED".equalsIgnoreCase(r.getStatus())) closedCount++;
            }
            request.setAttribute("jobsOpenCount", openCount);
            request.setAttribute("jobsPausedCount", pausedCount);
            request.setAttribute("jobsFilledCount", filledCount);
            request.setAttribute("jobsClosedCount", closedCount);

            // Nạp danh sách ứng viên và kết quả AI cho vị trí đang chọn
            List<Candidate> allSystemCandidates = recruitmentService.getAllCandidates(null, null, null, null);
            request.setAttribute("allSystemCandidates", allSystemCandidates);

            if (selectedJob != null) {
                List<Candidate> allJobCandidates = recruitmentService.getAllCandidates(selectedJob.getId(), null, null, null);
                request.setAttribute("jobCandidates", allJobCandidates);

                // Danh sách ứng viên đã được duyệt / phỏng vấn cho vị trí này
                List<Candidate> approvedJobCandidates = new java.util.ArrayList<>();
                for (Candidate c : allJobCandidates) {
                    String st = c.getStage() != null ? c.getStage().toUpperCase() : "NEW";
                    if (!"REJECTED".equals(st)) {
                        approvedJobCandidates.add(c);
                    }
                }
                request.setAttribute("approvedJobCandidates", approvedJobCandidates);

                List<Candidate> topAi = recruitmentService.getTopCandidatesForJob(selectedJob.getId(), 5);
                request.setAttribute("topAiCandidates", topAi);
                if (!topAi.isEmpty()) {
                    request.setAttribute("aiInterviewQuestions", 
                            recruitmentService.getAiService().generateInterviewQuestions(topAi.get(0), selectedJob));
                }
            }

            request.getRequestDispatcher("/WEB-INF/views/recruitment/recruitment-jobs.jsp")
                   .forward(request, response);
            return;
        } else if ("candidates".equalsIgnoreCase(view)) {
            request.setAttribute("activeSubMenu", "candidates");

            Integer reqId = parseInteger(request.getParameter("requestId"));
            String stage = request.getParameter("stage");
            String source = request.getParameter("source");
            String search = request.getParameter("search");

            List<RecruitmentRequest> allJobs = recruitmentService.getRequests(null, null, null, null, null, null);
            request.setAttribute("jobs", allJobs);
            request.setAttribute("employees", employeeDAO.findAll());

            List<Candidate> allCandidates = recruitmentService.getAllCandidates(reqId, stage, source, search);
            request.setAttribute("candidates", allCandidates);

            // Phân loại danh sách ứng viên theo các cột Kanban
            List<Candidate> listNew = new java.util.ArrayList<>();
            List<Candidate> listScreening = new java.util.ArrayList<>();
            List<Candidate> listInterview = new java.util.ArrayList<>();
            List<Candidate> listOffer = new java.util.ArrayList<>();
            List<Candidate> listOnboarded = new java.util.ArrayList<>();
            List<Candidate> listRejected = new java.util.ArrayList<>();

            for (Candidate c : allCandidates) {
                String st = c.getStage() != null ? c.getStage().toUpperCase() : "NEW";
                switch (st) {
                    case "SCREENING": listScreening.add(c); break;
                    case "INTERVIEW": listInterview.add(c); break;
                    case "OFFER": listOffer.add(c); break;
                    case "ONBOARDED": listOnboarded.add(c); break;
                    case "REJECTED": listRejected.add(c); break;
                    default: listNew.add(c); break;
                }
            }

            request.setAttribute("listNew", listNew);
            request.setAttribute("listScreening", listScreening);
            request.setAttribute("listInterview", listInterview);
            request.setAttribute("listOffer", listOffer);
            request.setAttribute("listOnboarded", listOnboarded);
            request.setAttribute("listRejected", listRejected);

            // Thống kê 4 thẻ KPI Ứng viên
            request.setAttribute("totalCandCount", allCandidates.size());
            request.setAttribute("newCandCount", listNew.size() + listScreening.size());
            request.setAttribute("interviewCandCount", listInterview.size());
            request.setAttribute("onboardedCandCount", listOnboarded.size());

            // Xác định ứng viên được chọn để hiển thị chi tiết bên Khung Drawer
            Integer selectedCandId = parseInteger(request.getParameter("candidateId"));
            Candidate selectedCandidate = null;
            if (selectedCandId != null) {
                for (Candidate c : allCandidates) {
                    if (c.getId() == selectedCandId) {
                        selectedCandidate = c;
                        break;
                    }
                }
            }
            if (selectedCandidate == null && !allCandidates.isEmpty()) {
                selectedCandidate = allCandidates.get(0);
            }
            request.setAttribute("selectedCandidate", selectedCandidate);

            if (selectedCandidate != null) {
                request.setAttribute("candInterviewQuestions", 
                        recruitmentService.getAiService().generateInterviewQuestions(selectedCandidate, null));
            }

            request.setAttribute("selectedRequestId", reqId);
            request.setAttribute("selectedStage", stage);
            request.setAttribute("selectedSource", source);
            request.setAttribute("searchKeyword", search);

            request.getRequestDispatcher("/WEB-INF/views/recruitment/recruitment-candidates.jsp")
                   .forward(request, response);
            return;
        }

        // 3. View mặc định: Tổng quan Tuyển dụng & Phễu nhân tài (Overview)
        request.setAttribute("activeSubMenu", "overview");

        String quarter = request.getParameter("quarter");
        if (quarter == null || quarter.trim().isEmpty()) quarter = "Q3/2026";
        Integer deptId = parseInteger(request.getParameter("departmentId"));
        String status = request.getParameter("status");
        Integer assigneeId = parseInteger(request.getParameter("assigneeId"));
        String search = request.getParameter("search");
        String pill = request.getParameter("pill");

        // Lấy dữ liệu từ Database
        RecruitmentDashboardStats stats = recruitmentService.getDashboardStats(quarter, deptId);
        List<RecruitmentRequest> requests = recruitmentService.getRequests(quarter, deptId, status, assigneeId, search, pill);
        List<Interview> todayInterviews = recruitmentService.getTodayInterviews();
        List<Interview> weeklyInterviews = recruitmentService.getWeeklyInterviews(LocalDate.now());

        // Đổ dữ liệu vào Request
        request.setAttribute("currentQuarter", quarter);
        request.setAttribute("selectedDeptId", deptId);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedAssigneeId", assigneeId);
        request.setAttribute("currentSearch", search);
        request.setAttribute("currentPill", pill);

        request.setAttribute("stats", stats);
        request.setAttribute("recruitmentRequests", requests);
        request.setAttribute("todayInterviews", todayInterviews);
        request.setAttribute("weeklyInterviews", weeklyInterviews);

        // Danh mục phục vụ dropdown
        request.setAttribute("departments", departmentDAO.findAll());
        request.setAttribute("positions", positionDAO.findAll());
        request.setAttribute("employees", employeeDAO.findAll());
        request.setAttribute("interviewCandidates", recruitmentService.getInterviewCandidates());
        request.setAttribute("nextRequestCode", recruitmentService.getNextRequestCode());

        request.getRequestDispatcher("/WEB-INF/views/recruitment/recruitment-overview.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String redirectTarget = request.getContextPath() + "/recruitment";

        // Xử lý AJAX update stage
        if ("update_stage".equalsIgnoreCase(action)) {
            Integer candidateId = parseInteger(request.getParameter("candidateId"));
            String newStage = request.getParameter("stage");
            boolean ok = false;
            if (candidateId != null && newStage != null) {
                ok = recruitmentService.updateCandidateStage(candidateId, newStage);
            }
            
            String isAjax = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equalsIgnoreCase(isAjax) || "true".equalsIgnoreCase(request.getParameter("ajax"))) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":" + ok + "}");
                return;
            }
            String returnView = request.getParameter("returnView");
            if ("jobs".equalsIgnoreCase(returnView)) {
                Integer jobId = parseInteger(request.getParameter("jobId"));
                redirectTarget += "?view=jobs" + (jobId != null ? "&jobId=" + jobId : "") + "&success=" + (ok ? "stage_updated" : "update_failed");
            } else {
                redirectTarget += "?view=candidates&success=" + (ok ? "stage_updated" : "update_failed");
            }

        } else if ("create_request".equalsIgnoreCase(action) || "create_job".equalsIgnoreCase(action)) {
            // Xử lý tạo mới Yêu cầu tuyển dụng / Vị trí
            RecruitmentRequest req = new RecruitmentRequest();
            req.setRequestCode(request.getParameter("requestCode"));
            req.setTitle(request.getParameter("title"));
            req.setDepartmentId(parseInteger(request.getParameter("departmentId")));
            req.setPositionId(parseInteger(request.getParameter("positionId")));
            
            int targetHeadcount = 1;
            try {
                targetHeadcount = Integer.parseInt(request.getParameter("targetHeadcount"));
            } catch (Exception ignored) {}
            req.setTargetHeadcount(Math.max(1, targetHeadcount));

            String salMinStr = request.getParameter("salaryMin");
            if (salMinStr != null && !salMinStr.trim().isEmpty()) {
                try { req.setSalaryMin(new BigDecimal(salMinStr.replaceAll("[^0-9]", ""))); } catch (Exception ignored) {}
            }
            String salMaxStr = request.getParameter("salaryMax");
            if (salMaxStr != null && !salMaxStr.trim().isEmpty()) {
                try { req.setSalaryMax(new BigDecimal(salMaxStr.replaceAll("[^0-9]", ""))); } catch (Exception ignored) {}
            }
            req.setSalaryNegotiable("on".equalsIgnoreCase(request.getParameter("salaryNegotiable")) || "true".equalsIgnoreCase(request.getParameter("salaryNegotiable")));

            String deadlineStr = request.getParameter("deadline");
            if (deadlineStr != null && !deadlineStr.trim().isEmpty()) {
                try { req.setDeadline(LocalDate.parse(deadlineStr)); } catch (Exception e) {
                    req.setDeadline(LocalDate.now().plusDays(30));
                }
            } else {
                req.setDeadline(LocalDate.now().plusDays(30));
            }

            req.setPriority(request.getParameter("priority") != null ? request.getParameter("priority") : "NORMAL");
            req.setStatus("OPEN");
            req.setQuarter(request.getParameter("quarter") != null ? request.getParameter("quarter") : "Q3/2026");
            req.setAssigneeId(parseInteger(request.getParameter("assigneeId")));
            req.setDescription(request.getParameter("description"));
            req.setRequirements(request.getParameter("requirements"));
            req.setBenefits(request.getParameter("benefits"));

            String locationParam = request.getParameter("location");
            req.setLocation(locationParam != null && !locationParam.trim().isEmpty() ? locationParam.trim() : "Hà Nội");
            req.setKeywords(request.getParameter("keywords"));

            boolean success = recruitmentService.createRequest(req);
            String viewParam = "create_job".equalsIgnoreCase(action) ? "?view=jobs&" : "?";
            if (success) {
                // Tự động đăng thông tin lên giao diện thông báo của công ty
                String postNotice = request.getParameter("postToCompanyNotice");
                if (postNotice == null || "on".equalsIgnoreCase(postNotice) || "true".equalsIgnoreCase(postNotice)) {
                    String deptName = "";
                    if (req.getDepartmentId() != null) {
                        com.miximoi.hrm.model.Department d = departmentDAO.findById(req.getDepartmentId());
                        if (d != null) deptName = d.getName();
                    }
                    recruitmentService.publishRecruitmentAnnouncement(req, deptName);
                }
                redirectTarget += viewParam + "success=job_created";
            } else {
                redirectTarget += viewParam + "error=create_failed";
            }

        } else if ("internal_apply".equalsIgnoreCase(action)) {
            // Xử lý nộp đơn ứng tuyển nội bộ (Chuyển bộ phận / Thăng tiến)
            Candidate c = new Candidate();
            Integer reqId = parseInteger(request.getParameter("recruitmentRequestId"));
            if (reqId != null) c.setRecruitmentRequestId(reqId);
            c.setFullName(request.getParameter("fullName"));
            c.setEmail(request.getParameter("email"));
            c.setPhone(request.getParameter("phone"));
            c.setSource("Ứng tuyển nội bộ");
            c.setStage("NEW");

            String expStr = request.getParameter("experienceYears");
            if (expStr != null && !expStr.trim().isEmpty()) {
                try { c.setExperienceYears(new BigDecimal(expStr.trim())); } catch (Exception ignored) {}
            }
            String salStr = request.getParameter("expectedSalary");
            if (salStr != null && !salStr.trim().isEmpty()) {
                try { c.setExpectedSalary(new BigDecimal(salStr.replaceAll("[^0-9]", ""))); } catch (Exception ignored) {}
            }
            c.setCvUrl(request.getParameter("cvUrl"));
            String currentDept = request.getParameter("currentDepartment");
            String reason = request.getParameter("reason");
            c.setNotes("ỨNG TUYỂN NỘI BỘ (Chuyển bộ phận / Thăng tiến).\nPhòng ban hiện tại: " 
                    + (currentDept != null ? currentDept : "Không xác định") 
                    + "\nNguyện vọng: " + (reason != null ? reason : "Ứng tuyển nâng cao chuyên môn"));
            c.setAppliedDate(LocalDate.now());

            boolean success = recruitmentService.createCandidate(c);
            redirectTarget = request.getContextPath() + "/recruitment?view=internal" 
                    + (reqId != null ? "&jobId=" + reqId : "") 
                    + "&success=" + (success ? "internal_applied" : "apply_failed");

        } else if ("refer_candidate".equalsIgnoreCase(action)) {
            // Xử lý giới thiệu ứng viên (Referral nhận thưởng)
            Candidate c = new Candidate();
            Integer reqId = parseInteger(request.getParameter("recruitmentRequestId"));
            if (reqId == null || reqId <= 0) {
                // Tự động tìm vị trí OPEN đầu tiên làm fallback để tránh lỗi DB constraint
                List<RecruitmentRequest> openList = recruitmentService.getRequests(null, null, "OPEN", null, null, null);
                if (openList != null && !openList.isEmpty()) {
                    reqId = openList.get(0).getId();
                }
            }
            if (reqId != null) c.setRecruitmentRequestId(reqId);
            c.setFullName(request.getParameter("candidateName"));
            c.setEmail(request.getParameter("candidateEmail"));
            c.setPhone(request.getParameter("candidatePhone"));
            c.setSource("Nội bộ (Ref)");
            c.setStage("NEW");

            String expStr = request.getParameter("experienceYears");
            if (expStr != null && !expStr.trim().isEmpty()) {
                try { c.setExperienceYears(new BigDecimal(expStr.trim())); } catch (Exception ignored) {}
            }
            String salStr = request.getParameter("expectedSalary");
            if (salStr != null && !salStr.trim().isEmpty()) {
                try { c.setExpectedSalary(new BigDecimal(salStr.replaceAll("[^0-9]", ""))); } catch (Exception ignored) {}
            }
            c.setCvUrl(request.getParameter("cvUrl"));
            String referrerName = request.getParameter("referrerName");
            String notes = request.getParameter("notes");
            c.setNotes("GIỚI THIỆU ỨNG VIÊN (REFERRAL NHẬN THƯỞNG).\nNgười giới thiệu: " 
                    + (referrerName != null ? referrerName : "Nhân viên nội bộ") 
                    + "\nĐánh giá / Ghi chú: " + (notes != null ? notes : ""));
            c.setAppliedDate(LocalDate.now());

            boolean success = recruitmentService.createCandidate(c);
            redirectTarget = request.getContextPath() + "/recruitment?view=internal" 
                    + (reqId != null ? "&jobId=" + reqId : "") 
                    + (success ? "&success=candidate_referred" : "&error=refer_failed");

        } else if ("hr_update_internal_stage".equalsIgnoreCase(action)) {
            // HR cập nhật giai đoạn hồ sơ ứng tuyển nội bộ
            Integer candId = parseInteger(request.getParameter("candidateId"));
            String stage = request.getParameter("stage");
            boolean ok = false;
            if (candId != null && stage != null) {
                ok = recruitmentService.updateCandidateStage(candId, stage);
            }
            redirectTarget = request.getContextPath() + "/recruitment?view=internal&success=" + (ok ? "internal_stage_updated" : "update_failed");

        } else if ("hr_approve_referral_bonus".equalsIgnoreCase(action)) {
            // HR phê duyệt chi thưởng hoa hồng Referral cho nhân viên giới thiệu theo cấp bậc
            Integer candId = parseInteger(request.getParameter("candidateId"));
            String bonusAmount = request.getParameter("bonusAmount");
            String rankLevel = request.getParameter("rankLevel");
            String payrollPeriod = request.getParameter("payrollPeriod");
            String hrNotes = request.getParameter("hrNotes");

            if (bonusAmount == null || bonusAmount.trim().isEmpty()) bonusAmount = "6.000.000 VNĐ";
            if (rankLevel == null || rankLevel.trim().isEmpty()) rankLevel = "Senior Engineer / Chuyên Viên Cao Cấp";
            if (payrollPeriod == null || payrollPeriod.trim().isEmpty()) {
                payrollPeriod = "Kỳ lương Tháng " + LocalDate.now().plusMonths(1).getMonthValue() + "/" + LocalDate.now().plusMonths(1).getYear();
            }
            if (hrNotes == null) hrNotes = "";

            boolean ok = false;
            if (candId != null) {
                Candidate c = recruitmentService.getCandidateById(candId);
                if (c != null) {
                    // Cập nhật trạng thái candidate sang ONBOARDED (Đã tiếp nhận)
                    recruitmentService.updateCandidateStage(candId, "ONBOARDED");

                    String approveLog = "\n[HR ĐÃ DUYỆT THƯỞNG REFERRAL: " + bonusAmount 
                            + " | Cấp bậc: " + rankLevel 
                            + " | Chi trả: " + payrollPeriod 
                            + (!hrNotes.trim().isEmpty() ? (" | Đánh giá: " + hrNotes.trim()) : "") 
                            + " - Ngày duyệt: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + "]";
                    c.setNotes((c.getNotes() != null ? c.getNotes() : "") + approveLog);
                    recruitmentService.updateCandidateNotes(candId, c.getNotes());

                    // Trích xuất tên người giới thiệu để ghi nhận khoản thưởng vào bảng bonuses (Payroll)
                    try {
                        String notes = c.getNotes();
                        String refName = null;
                        if (notes != null && notes.contains("Người giới thiệu:")) {
                            String after = notes.substring(notes.indexOf("Người giới thiệu:") + "Người giới thiệu:".length()).trim();
                            refName = after.split("\n")[0].trim();
                        }
                        if (refName != null && !refName.isEmpty()) {
                            List<com.miximoi.hrm.model.Employee> emps = employeeDAO.findAll();
                            com.miximoi.hrm.model.Employee referrerEmp = null;
                            for (com.miximoi.hrm.model.Employee emp : emps) {
                                if (emp.getFullName() != null && emp.getFullName().trim().equalsIgnoreCase(refName)) {
                                    referrerEmp = emp;
                                    break;
                                }
                            }
                            if (referrerEmp != null) {
                                String cleanNum = bonusAmount.replaceAll("[^0-9]", "");
                                if (!cleanNum.isEmpty()) {
                                    BigDecimal amountNumeric = new BigDecimal(cleanNum);
                                    com.miximoi.hrm.model.Bonus bonus = new com.miximoi.hrm.model.Bonus();
                                    bonus.setEmployeeId(referrerEmp.getId());
                                    bonus.setName("Thưởng Referral tuyển dụng: " + c.getFullName() + " (" + rankLevel + ")");
                                    bonus.setAmount(amountNumeric);
                                    bonus.setBonusDate(LocalDate.now());
                                    bonus.setPayMonth(LocalDate.now().plusMonths(1).getMonthValue());
                                    bonus.setPayYear(LocalDate.now().plusMonths(1).getYear());
                                    bonus.setNotes("Phê duyệt hoa hồng giới thiệu ứng viên đạt thử việc. Ghi chú HR: " + hrNotes);
                                    com.miximoi.hrm.dao.BonusDAO bDao = new com.miximoi.hrm.dao.BonusDAO();
                                    bDao.insert(bonus);
                                }
                            }
                        }
                    } catch (Exception ex) {
                        System.err.println("Ghi nhận thưởng Referral vào BonusDAO: " + ex.getMessage());
                    }

                    ok = true;
                }
            }
            redirectTarget = request.getContextPath() + "/recruitment?view=internal&success=" + (ok ? "referral_bonus_approved" : "update_failed");

        } else if ("add_candidate".equalsIgnoreCase(action)) {
            Candidate c = new Candidate();
            c.setFullName(request.getParameter("fullName"));
            c.setEmail(request.getParameter("email"));
            c.setPhone(request.getParameter("phone"));
            Integer rId = parseInteger(request.getParameter("recruitmentRequestId"));
            if (rId != null) c.setRecruitmentRequestId(rId);
            c.setSource(request.getParameter("source") != null ? request.getParameter("source") : "Ứng tuyển trực tuyến");
            c.setStage("NEW");

            String expStr = request.getParameter("experienceYears");
            if (expStr != null && !expStr.trim().isEmpty()) {
                try { c.setExperienceYears(new BigDecimal(expStr.trim())); } catch (Exception ignored) {}
            }

            String salStr = request.getParameter("expectedSalary");
            if (salStr != null && !salStr.trim().isEmpty()) {
                try { c.setExpectedSalary(new BigDecimal(salStr.replaceAll("[^0-9]", ""))); } catch (Exception ignored) {}
            }

            c.setCvUrl(request.getParameter("cvUrl"));
            c.setNotes(request.getParameter("notes"));
            c.setAppliedDate(LocalDate.now());

            String cvTypeParam = request.getParameter("cvType");
            if (cvTypeParam != null && !cvTypeParam.trim().isEmpty()) {
                c.setCvType(cvTypeParam.trim());
            }
            String cvTextParam = request.getParameter("cvText");
            if (cvTextParam != null && !cvTextParam.trim().isEmpty()) {
                c.setCvText(cvTextParam.trim());
            }

            boolean success = recruitmentService.createCandidate(c);
            String returnView = request.getParameter("returnView");
            if ("jobs".equalsIgnoreCase(returnView)) {
                redirectTarget += "?view=jobs&jobId=" + (rId != null ? rId : "") + "&success=" + (success ? "candidate_added" : "add_candidate_failed");
            } else {
                redirectTarget += "?view=candidates&success=" + (success ? "candidate_added" : "add_candidate_failed");
            }

        } else if ("ai_batch_promote".equalsIgnoreCase(action)) {
            Integer jobId = parseInteger(request.getParameter("jobId"));
            if (jobId != null) {
                List<Candidate> topAi = recruitmentService.getTopCandidatesForJob(jobId, 3);
                for (Candidate c : topAi) {
                    recruitmentService.updateCandidateStage(c.getId(), "INTERVIEW");
                }
            }
            redirectTarget += "?view=jobs&jobId=" + (jobId != null ? jobId : "") + "&success=ai_promoted";

        } else if ("schedule_interview".equalsIgnoreCase(action)) {
            // Xử lý Xếp lịch phỏng vấn
            Interview iv = new Interview();
            Integer candId = parseInteger(request.getParameter("candidateId"));
            if (candId != null) iv.setCandidateId(candId);
            iv.setRecruitmentRequestId(parseInteger(request.getParameter("recruitmentRequestId")));
            iv.setInterviewerId(parseInteger(request.getParameter("interviewerId")));
            iv.setRoundName(request.getParameter("roundName"));

            String dateStr = request.getParameter("interviewDate");
            if (dateStr != null && !dateStr.trim().isEmpty()) {
                try { iv.setInterviewDate(LocalDate.parse(dateStr)); } catch (Exception ignored) {}
            }
            if (iv.getInterviewDate() == null) iv.setInterviewDate(LocalDate.now());

            String timeStr = request.getParameter("interviewTime");
            if (timeStr != null && !timeStr.trim().isEmpty()) {
                try {
                    if (timeStr.length() == 5) timeStr += ":00";
                    iv.setInterviewTime(LocalTime.parse(timeStr));
                } catch (Exception ignored) {}
            }
            if (iv.getInterviewTime() == null) iv.setInterviewTime(LocalTime.of(9, 30));

            iv.setLocationOrLink(request.getParameter("locationOrLink"));
            iv.setFeedback(request.getParameter("feedback"));
            iv.setStatus("SCHEDULED");

            boolean success = recruitmentService.scheduleInterview(iv);
            String returnView = request.getParameter("returnView");
            String prefix = ("candidates".equalsIgnoreCase(returnView)) ? "?view=candidates&" : "?";
            if (success) {
                redirectTarget += prefix + "success=interview_scheduled";
            } else {
                redirectTarget += prefix + "error=schedule_failed";
            }

        } else if ("send_offer".equalsIgnoreCase(action)) {
            Integer candId = parseInteger(request.getParameter("candidateId"));
            if (candId != null) {
                recruitmentService.updateCandidateStage(candId, "OFFER");
            }
            redirectTarget += "?view=candidates&success=offer_sent";

        } else {
            redirectTarget += "?success=true";
        }

        response.sendRedirect(redirectTarget);
    }

    private BigDecimal parseBigDecimal(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try {
            return new BigDecimal(val.replaceAll("[^0-9.]", ""));
        } catch (Exception e) {
            return null;
        }
    }

    private Integer parseInteger(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
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
}
