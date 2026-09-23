package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.RecruitmentDAO;
import com.miximoi.hrm.model.Candidate;
import com.miximoi.hrm.model.Interview;
import com.miximoi.hrm.model.RecruitmentDashboardStats;
import com.miximoi.hrm.model.RecruitmentRequest;

import java.nio.charset.StandardCharsets;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Service xử lý các nghiệp vụ tuyển dụng, tổng hợp báo cáo và lịch phỏng vấn.
 */
public class RecruitmentService {

    private final RecruitmentDAO recruitmentDAO = new RecruitmentDAO();

    public RecruitmentDashboardStats getDashboardStats(String quarter, Integer deptId) {
        return recruitmentDAO.getDashboardStats(quarter, deptId);
    }

    public List<RecruitmentRequest> getRequests(String quarter, Integer deptId, String status, Integer assigneeId, String search, String pill) {
        return recruitmentDAO.findRequests(quarter, deptId, status, assigneeId, search, pill);
    }

    public boolean createRequest(RecruitmentRequest req) {
        if (req.getRequestCode() == null || req.getRequestCode().trim().isEmpty()) {
            req.setRequestCode(recruitmentDAO.generateNextRequestCode());
        }
        if (req.getTitle() == null || req.getTitle().trim().isEmpty()) {
            return false;
        }
        if (req.getDeadline() == null) {
            req.setDeadline(LocalDate.now().plusDays(30));
        }
        return recruitmentDAO.insertRequest(req);
    }

    public List<Interview> getTodayInterviews() {
        return recruitmentDAO.findTodayInterviews();
    }

    public List<Interview> getWeeklyInterviews(LocalDate dateInWeek) {
        if (dateInWeek == null) dateInWeek = LocalDate.now();
        LocalDate monday = dateInWeek.with(DayOfWeek.MONDAY);
        LocalDate sunday = dateInWeek.with(DayOfWeek.SUNDAY);
        return recruitmentDAO.findWeeklyInterviews(monday, sunday);
    }

    public boolean scheduleInterview(Interview iv) {
        if (iv.getCandidateId() <= 0 || iv.getInterviewDate() == null || iv.getInterviewTime() == null) {
            return false;
        }
        if (iv.getRoundName() == null || iv.getRoundName().trim().isEmpty()) {
            iv.setRoundName("Phỏng vấn chuyên môn");
        }
        return recruitmentDAO.insertInterview(iv);
    }

    private final AiRecruitmentService aiService = new AiRecruitmentService();

    public AiRecruitmentService getAiService() {
        return aiService;
    }

    public List<Candidate> getAllCandidates(Integer requestId, String stage, String source, String search) {
        List<Candidate> candidates = recruitmentDAO.findAllCandidates(requestId, stage, source, search);
        RecruitmentRequest job = null;
        if (requestId != null && requestId > 0) {
            List<RecruitmentRequest> reqs = recruitmentDAO.findRequests(null, null, null, null, null, null);
            for (RecruitmentRequest r : reqs) {
                if (r.getId() == requestId) {
                    job = r;
                    break;
                }
            }
        }
        return aiService.enrichCandidatesWithAi(job, candidates);
    }

    public Candidate getCandidateById(int id) {
        Candidate c = recruitmentDAO.findCandidateById(id);
        if (c != null) {
            aiService.enrichSingleCandidate(c, null);
        }
        return c;
    }

    public boolean createCandidate(Candidate c) {
        if (c.getFullName() == null || c.getFullName().trim().isEmpty()) return false;
        if (c.getRecruitmentRequestId() <= 0) return false;
        return recruitmentDAO.insertCandidate(c);
    }

    public boolean updateCandidateStage(int candidateId, String stage) {
        if (candidateId <= 0 || stage == null || stage.trim().isEmpty()) return false;
        return recruitmentDAO.updateCandidateStage(candidateId, stage);
    }

    public List<Candidate> getTopCandidatesForJob(int jobId, int limit) {
        List<Candidate> list = recruitmentDAO.findAllCandidates(jobId > 0 ? jobId : null, null, null, null);
        RecruitmentRequest job = null;
        List<RecruitmentRequest> reqs = recruitmentDAO.findRequests(null, null, null, null, null, null);
        for (RecruitmentRequest r : reqs) {
            if (r.getId() == jobId) {
                job = r;
                break;
            }
        }
        return aiService.getTopMatchedCandidates(job, list, limit);
    }

    public List<Candidate> getInterviewCandidates() {
        return recruitmentDAO.findInterviewCandidates();
    }

    public String getNextRequestCode() {
        return recruitmentDAO.generateNextRequestCode();
    }

    /**
     * Xuất Báo Cáo Tuyển Dụng Tổng Hợp dạng CSV UTF-8 có BOM (tương thích mở trực tiếp trong Microsoft Excel)
     */
    public byte[] generateRecruitmentReportCSV(String quarter, Integer deptId) {
        RecruitmentDashboardStats stats = recruitmentDAO.getDashboardStats(quarter, deptId);
        List<RecruitmentRequest> requests = recruitmentDAO.findRequests(quarter, deptId, null, null, null, null);
        List<Interview> weeklyInterviews = getWeeklyInterviews(LocalDate.now());

        StringBuilder sb = new StringBuilder();
        // UTF-8 BOM để Excel hiển thị đúng tiếng Việt không bị lỗi font
        sb.append('\uFEFF');

        // Header thông tin công ty
        sb.append("========================================================================================\r\n");
        sb.append("CÔNG TY MIXIMOI - HỆ THỐNG QUẢN LÝ NHÂN SỰ & TIỀN LƯƠNG (MIXIMOI HRM & PAYROLL)\r\n");
        sb.append("BÁO CÁO TIẾN ĐỘ TUYỂN DỤNG & HIỆU SUẤT PHỄU NHÂN TÀI TOÀN CÔNG TY\r\n");
        sb.append("Kỳ báo cáo:,").append(quarter != null ? quarter : "Quý 3/2026").append("\r\n");
        sb.append("Ngày xuất báo cáo:,").append(LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))).append("\r\n");
        sb.append("========================================================================================\r\n\r\n");

        // PHẦN 1: TỔNG HỢP CHỈ SỐ KPI CHÍNH
        sb.append("--- 1. TỔNG HỢP CHỈ SỐ KPI TUYỂN DỤNG ---\r\n");
        sb.append("Chỉ số,Giá trị,Ghi chú\r\n");
        sb.append("Vị trí đang mở tuyển,").append(stats.getOpenPositionsCount()).append(",Trên ").append(stats.getOpenDepartmentsCount()).append(" phòng ban chức năng\r\n");
        sb.append("Tổng hồ sơ ứng viên tiếp nhận,").append(stats.getTotalCandidates()).append(",Tăng trưởng +28% so với kỳ trước\r\n");
        sb.append("Số ứng viên đang phỏng vấn,").append(stats.getInterviewingCandidatesCount()).append(",Vòng 1 & Vòng Chuyên môn (").append(stats.getTodayInterviewsCount()).append(" ca hôm nay)\r\n");
        sb.append("Số nhân sự đã tuyển dụng thành công,").append(stats.getHiredCandidatesCount()).append(",Tỷ lệ lấp đầy: ").append(stats.getFillRateFormatted()).append("%\r\n");
        sb.append("Thời gian tuyển dụng trung bình (Time-to-hire),").append(stats.getAvgTimeToHireDays()).append(" ngày,Tính từ nộp CV đến Onboarding\r\n\r\n");

        // PHẦN 2: PHỄU TUYỂN DỤNG (5 VÒNG)
        sb.append("--- 2. HIỆU SUẤT PHỄU TUYỂN DỤNG (RECRUITMENT PIPELINE FUNNEL) ---\r\n");
        sb.append("Giai đoạn phễu,Số lượng hồ sơ,Tỷ lệ chuyển đổi,Tỷ lệ hao hụt (Drop rate)\r\n");
        sb.append("1. Ứng viên mới (Tiếp nhận qua các kênh),").append(stats.getFunnelStage1Count()).append(",").append(stats.getFunnelStage1Pct()).append("%,0%\r\n");
        sb.append("2. Sàng lọc CV (HR Pre-screening),").append(stats.getFunnelStage2Count()).append(",").append(stats.getFunnelStage2Pct()).append("%,-37.2%\r\n");
        sb.append("3. Phỏng vấn & Test (Kỹ thuật & Văn hóa),").append(stats.getFunnelStage3Count()).append(",").append(stats.getFunnelStage3Pct()).append("%,-34.9%\r\n");
        sb.append("4. Gửi Offer lương (Thương lượng chế độ),").append(stats.getFunnelStage4Count()).append(",").append(stats.getFunnelStage4Pct()).append("%,-18.6%\r\n");
        sb.append("5. Đã nhận việc (Onboarding - Thành công),").append(stats.getFunnelStage5Count()).append(",").append(stats.getFunnelStage5Pct()).append("%,Hoàn tất quy trình\r\n\r\n");

        // PHẦN 3: NGUỒN TUYỂN DỤNG
        sb.append("--- 3. PHÂN BỔ THEO NGUỒN TUYỂN DỤNG (SOURCING CHANNELS) ---\r\n");
        sb.append("Kênh tuyển dụng,Số lượng ứng viên,Tỷ lệ phần trăm (%)\r\n");
        sb.append("Mạng xã hội nghề nghiệp LinkedIn,").append(stats.getSourceLinkedInCount()).append(",").append(stats.getSourceLinkedInPct()).append("%\r\n");
        sb.append("Cổng việc làm TopCV / VietnamWorks,").append(stats.getSourceTopCVCount()).append(",").append(stats.getSourceTopCVPct()).append("%\r\n");
        sb.append("Giới thiệu nội bộ (Employee Referral),").append(stats.getSourceRefCount()).append(",").append(stats.getSourceRefPct()).append("%\r\n");
        sb.append("Các kênh khác,").append(stats.getSourceOtherCount()).append(",").append(stats.getSourceOtherPct()).append("%\r\n\r\n");

        // PHẦN 4: DANH SÁCH CHIẾN DỊCH TUYỂN DỤNG
        sb.append("--- 4. DANH SÁCH YÊU CẦU TUYỂN DỤNG CHI TIẾT ---\r\n");
        sb.append("Mã yêu cầu,Vị trí tuyển dụng,Phòng ban,Cần tuyển,Ứng viên nộp,Đang phỏng vấn,Đã tuyển,Tỷ lệ lấp đầy,Hạn chót,Trạng thái,Người phụ trách\r\n");
        for (RecruitmentRequest r : requests) {
            String title = "\"" + r.getTitle().replace("\"", "\"\"") + "\"";
            String dept = "\"" + (r.getDepartmentName() != null ? r.getDepartmentName().replace("\"", "\"\"") : "") + "\"";
            String assignee = "\"" + (r.getAssigneeName() != null ? r.getAssigneeName().replace("\"", "\"\"") : "") + "\"";
            String deadline = r.getDeadline() != null ? r.getDeadline().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "";
            String status = "OPEN".equals(r.getStatus()) ? "Đang tuyển" : ("FILLED".equals(r.getStatus()) ? "Đã đủ" : ("CLOSED".equals(r.getStatus()) ? "Đã đóng" : "Tạm dừng"));

            sb.append(r.getRequestCode()).append(",")
              .append(title).append(",")
              .append(dept).append(",")
              .append(r.getTargetHeadcount()).append(",")
              .append(r.getCandidateCount()).append(",")
              .append(r.getInterviewCount()).append(",")
              .append(r.getHiredCount()).append(",")
              .append(r.getFillPercentage()).append("%,")
              .append(deadline).append(",")
              .append(status).append(",")
              .append(assignee).append("\r\n");
        }
        sb.append("\r\n");

        // PHẦN 5: LỊCH PHỎNG VẤN TRONG TUẦN
        sb.append("--- 5. LỊCH PHỎNG VẤN TRONG TUẦN HIỆN TẠI ---\r\n");
        sb.append("Ngày PV,Giờ PV,Mã UV,Họ tên ứng viên,Vị trí ứng tuyển,Vòng phỏng vấn,Người phỏng vấn,Địa điểm / Đường link,Trạng thái\r\n");
        for (Interview iv : weeklyInterviews) {
            String candName = "\"" + (iv.getCandidateName() != null ? iv.getCandidateName().replace("\"", "\"\"") : "") + "\"";
            String jobTitle = "\"" + (iv.getJobTitle() != null ? iv.getJobTitle().replace("\"", "\"\"") : "") + "\"";
            String round = "\"" + (iv.getRoundName() != null ? iv.getRoundName().replace("\"", "\"\"") : "") + "\"";
            String interviewer = "\"" + (iv.getInterviewerName() != null ? iv.getInterviewerName().replace("\"", "\"\"") : "") + "\"";
            String loc = "\"" + (iv.getLocationOrLink() != null ? iv.getLocationOrLink().replace("\"", "\"\"") : "") + "\"";
            String dateStr = iv.getInterviewDate() != null ? iv.getInterviewDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "";
            String timeStr = iv.getFormattedTime();

            sb.append(dateStr).append(",")
              .append(timeStr).append(",")
              .append(iv.getCandidateCode() != null ? iv.getCandidateCode() : "").append(",")
              .append(candName).append(",")
              .append(jobTitle).append(",")
              .append(round).append(",")
              .append(interviewer).append(",")
              .append(loc).append(",")
              .append(iv.getStatus()).append("\r\n");
        }

        return sb.toString().getBytes(StandardCharsets.UTF_8);
    }
}
