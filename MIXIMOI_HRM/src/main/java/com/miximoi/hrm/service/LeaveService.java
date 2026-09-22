package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.LeaveDAO;
import com.miximoi.hrm.model.LeaveRequest;
import com.miximoi.hrm.model.User;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Service xử lý nghiệp vụ nghỉ phép & nghỉ lễ.
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

    public List<LeaveRequest> getByFilters(User user, String status, Integer departmentId,
                                          String leaveType, String keyword) {
        return leaveDAO.findByFilters(user, status, departmentId, leaveType, keyword);
    }

    public LeaveRequest getById(int id) {
        return leaveDAO.findById(id);
    }

    public int countPending() {
        return leaveDAO.countPending();
    }

    /**
     * Tạo đơn xin nghỉ phép.
     */
    public String createLeaveRequest(LeaveRequest lr) {
        if (lr.getStartDate() == null || lr.getEndDate() == null)
            return "Vui lòng chọn ngày bắt đầu và ngày kết thúc.";
        if (lr.getEndDate().isBefore(lr.getStartDate()))
            return "Ngày kết thúc phải sau ngày bắt đầu.";
        if (lr.getReason() == null || lr.getReason().trim().isEmpty())
            return "Vui lòng nhập lý do nghỉ phép.";

        // Tính số ngày nghỉ
        double days = lr.getDays() > 0 ? lr.getDays() :
                (ChronoUnit.DAYS.between(lr.getStartDate(), lr.getEndDate()) + 1);
        lr.setDays(days);

        // Sinh mã đơn (dạng LP-2026-xxx)
        if (lr.getLeaveCode() == null || lr.getLeaveCode().isEmpty()) {
            lr.setLeaveCode("LP-2026-" + String.format("%03d", (int)(Math.random() * 900 + 100)));
        }

        boolean ok = leaveDAO.insert(lr);
        return ok ? null : "Lỗi khi tạo đơn xin nghỉ phép.";
    }

    public boolean approve(int id, int approvedById) {
        return leaveDAO.approve(id, approvedById);
    }

    public boolean reject(int id, int rejectedById, String reason) {
        return leaveDAO.reject(id, rejectedById, reason);
    }

    public int bulkApprove(List<Integer> ids, int approvedById) {
        return leaveDAO.bulkApprove(ids, approvedById);
    }

    public int bulkReject(List<Integer> ids, int rejectedById, String reason) {
        return leaveDAO.bulkReject(ids, rejectedById, reason);
    }

    public int bulkDelete(List<Integer> ids) {
        return leaveDAO.bulkDelete(ids);
    }

    public List<LeaveRequest> findByIds(List<Integer> ids) {
        return leaveDAO.findByIds(ids);
    }
}
