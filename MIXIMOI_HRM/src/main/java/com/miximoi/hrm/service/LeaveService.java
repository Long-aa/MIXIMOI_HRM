package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.LeaveDAO;
import com.miximoi.hrm.model.LeaveRequest;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Service xử lý nghiệp vụ nghỉ phép.
 */
public class LeaveService {

    private final LeaveDAO leaveDAO = new LeaveDAO();

    public List<LeaveRequest> getAll() {
        return leaveDAO.findAll();
    }

    public List<LeaveRequest> getByEmployee(int employeeId) {
        return leaveDAO.findByEmployeeId(employeeId);
    }

    public List<LeaveRequest> getPending() {
        return leaveDAO.findByStatus("PENDING");
    }

    public LeaveRequest getById(int id) {
        return leaveDAO.findById(id);
    }

    public int countPending() {
        return leaveDAO.countPending();
    }

    /**
     * Tạo đơn xin nghỉ phép.
     *
     * @return null nếu thành công, chuỗi lỗi nếu thất bại
     */
    public String createLeaveRequest(LeaveRequest lr) {
        if (lr.getStartDate() == null || lr.getEndDate() == null)
            return "Vui lòng chọn ngày bắt đầu và ngày kết thúc.";
        if (lr.getEndDate().isBefore(lr.getStartDate()))
            return "Ngày kết thúc phải sau ngày bắt đầu.";
        if (lr.getStartDate().isBefore(LocalDate.now()))
            return "Không thể xin nghỉ phép cho ngày đã qua.";
        if (lr.getReason() == null || lr.getReason().trim().isEmpty())
            return "Vui lòng nhập lý do nghỉ phép.";

        // Tính số ngày nghỉ
        int days = (int) ChronoUnit.DAYS.between(lr.getStartDate(), lr.getEndDate()) + 1;
        lr.setTotalDays(days);

        // Sinh mã đơn
        lr.setLeaveCode("LP" + System.currentTimeMillis());

        boolean ok = leaveDAO.insert(lr);
        return ok ? null : "Lỗi khi tạo đơn xin nghỉ phép.";
    }

    /**
     * Phê duyệt đơn nghỉ phép.
     */
    public boolean approve(int id, int approvedById) {
        LeaveRequest lr = leaveDAO.findById(id);
        if (lr == null || !"PENDING".equals(lr.getStatus())) return false;
        return leaveDAO.approve(id, approvedById);
    }

    /**
     * Từ chối đơn nghỉ phép.
     */
    public boolean reject(int id, int rejectedById, String reason) {
        LeaveRequest lr = leaveDAO.findById(id);
        if (lr == null || !"PENDING".equals(lr.getStatus())) return false;
        return leaveDAO.reject(id, rejectedById, reason);
    }
}
