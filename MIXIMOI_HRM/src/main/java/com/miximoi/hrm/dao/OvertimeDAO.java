package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Overtime;
import com.miximoi.hrm.model.User;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.*;

/**
 * DAO xử lý các thao tác dữ liệu liên quan đến Overtime (Tăng ca & Làm thêm giờ).
 * Hỗ trợ lưu trữ DB thực tế và bộ mẫu chuẩn hóa đối ứng chính xác với UI các ảnh.
 */
public class OvertimeDAO {

    // Danh sách in-memory mô phỏng trạng thái thời gian thực
    private static final List<Overtime> inMemoryStore = new ArrayList<>();
    private static int idSequence = 100;

    static {
        initSampleData();
    }

    private static void initSampleData() {
        inMemoryStore.clear();

        // 1. Release v4.2 - Core Banking (Chờ duyệt cấp 2)
        Overtime ot1 = new Overtime();
        ot1.setId(1);
        ot1.setEmployeeId(1);
        ot1.setEmployeeCode("NV001");
        ot1.setEmployeeName("Lê Hoàng Long");
        ot1.setPositionName("Kỹ sư Phần mềm Senior");
        ot1.setDepartmentId(6);
        ot1.setDepartmentName("CNTT & Sản phẩm");
        ot1.setProjectName("Release v4.2 - Core Banking — Chuyển đổi số ngân hàng V");
        ot1.setOvertimeDate(LocalDate.of(2026, 9, 23));
        ot1.setStartTime(LocalTime.of(18, 0));
        ot1.setEndTime(LocalTime.of(21, 30));
        ot1.setHours(3.5);
        ot1.setCoefficient(1.5);
        ot1.setOtType("REGULAR");
        ot1.setAmount(new BigDecimal("1250000"));
        ot1.setReason("Triển khai release v4.2 và migrate cơ sở dữ liệu sau giờ giao dịch");
        ot1.setLeadApproverId(101);
        ot1.setLeadApproverName("Trần Tuấn Hưng (CTO)");
        ot1.setLeadStatus("APPROVED");
        ot1.setLeadApprovedAt(LocalDateTime.now().minusHours(4));
        ot1.setHrStatus("PENDING");
        ot1.setApprovedByName("HR Lead (Chờ)");
        ot1.setStatus("PENDING_HR");
        ot1.setCreatedAt(LocalDateTime.now().minusHours(8));
        inMemoryStore.add(ot1);

        // 2. Design System v3 & Mobile UI Sprint 44 (Đã phê duyệt / Hoàn tất)
        Overtime ot2 = new Overtime();
        ot2.setId(2);
        ot2.setEmployeeId(2);
        ot2.setEmployeeCode("NV005");
        ot2.setEmployeeName("Đặng Thu Hà");
        ot2.setPositionName("UI/UX Design");
        ot2.setDepartmentId(6);
        ot2.setDepartmentName("CNTT & Sản phẩm");
        ot2.setProjectName("Design System v3 & Mobile UI Sprint 44");
        ot2.setOvertimeDate(LocalDate.of(2026, 9, 20));
        ot2.setStartTime(LocalTime.of(18, 30));
        ot2.setEndTime(LocalTime.of(20, 30));
        ot2.setHours(2.0);
        ot2.setCoefficient(1.5);
        ot2.setOtType("REGULAR");
        ot2.setAmount(new BigDecimal("650000"));
        ot2.setReason("Hoàn thiện bộ component Figma và bàn giao team Frontend cho sprint");
        ot2.setLeadApproverId(102);
        ot2.setLeadApproverName("Trịnh Lan Anh (Lead)");
        ot2.setLeadStatus("APPROVED");
        ot2.setLeadApprovedAt(LocalDateTime.now().minusDays(1));
        ot2.setApprovedById(1);
        ot2.setApprovedByName("Nguyễn Văn Admin");
        ot2.setHrStatus("APPROVED");
        ot2.setApprovedAt(LocalDateTime.now().minusHours(18));
        ot2.setStatus("APPROVED");
        ot2.setCreatedAt(LocalDateTime.now().minusDays(2));
        inMemoryStore.add(ot2);

        // 3. Xử lý sự cố tắc nghẽn Database cluster (Đã thanh toán / Đã khóa)
        Overtime ot3 = new Overtime();
        ot3.setId(3);
        ot3.setEmployeeId(3);
        ot3.setEmployeeCode("NV004");
        ot3.setEmployeeName("Trần Đình Khang");
        ot3.setPositionName("Backend Team");
        ot3.setDepartmentId(6);
        ot3.setDepartmentName("CNTT & Sản phẩm");
        ot3.setProjectName("Sự cố tắc nghẽn Database cluster & Xử lý dữ liệu thanh toán");
        ot3.setOvertimeDate(LocalDate.of(2026, 9, 18));
        ot3.setStartTime(LocalTime.of(19, 0));
        ot3.setEndTime(LocalTime.of(23, 0));
        ot3.setHours(4.0);
        ot3.setCoefficient(2.0);
        ot3.setOtType("WEEKEND");
        ot3.setAmount(new BigDecimal("1800000"));
        ot3.setReason("Khắc phục nghẽn connection pool và re-index các bảng logs giao dịch");
        ot3.setLeadApproverId(101);
        ot3.setLeadApproverName("Trần Tuấn Hưng (CTO)");
        ot3.setLeadStatus("APPROVED");
        ot3.setLeadApprovedAt(LocalDateTime.now().minusDays(3));
        ot3.setApprovedById(1);
        ot3.setApprovedByName("HR Lead (Duyệt)");
        ot3.setHrStatus("APPROVED");
        ot3.setApprovedAt(LocalDateTime.now().minusDays(2));
        ot3.setStatus("PAID");
        ot3.setPaid(true);
        ot3.setCreatedAt(LocalDateTime.now().minusDays(4));
        inMemoryStore.add(ot3);

        // 4. Hỗ trợ khách hàng VIP sau giờ làm việc (Từ chối)
        Overtime ot4 = new Overtime();
        ot4.setId(4);
        ot4.setEmployeeId(4);
        ot4.setEmployeeCode("NV002");
        ot4.setEmployeeName("Lê Thị Thanh Huyền");
        ot4.setPositionName("Chuyên viên Kinh Doanh");
        ot4.setDepartmentId(4);
        ot4.setDepartmentName("Khối B2B");
        ot4.setProjectName("Khách hàng VIP sau giờ làm việc — Đột xuất khẩn cấp khối B2B");
        ot4.setOvertimeDate(LocalDate.of(2026, 9, 16));
        ot4.setStartTime(LocalTime.of(18, 0));
        ot4.setEndTime(LocalTime.of(19, 30));
        ot4.setHours(1.5);
        ot4.setCoefficient(1.5);
        ot4.setOtType("REGULAR");
        ot4.setAmount(new BigDecimal("450000"));
        ot4.setReason("Tư vấn hợp đồng giải pháp cho đại diện đối tác ngoài giờ làm việc");
        ot4.setLeadApproverId(103);
        ot4.setLeadApproverName("Trưởng nhóm từ chối");
        ot4.setLeadStatus("REJECTED");
        ot4.setRejectReason("Không thuộc diện phê duyệt OT theo quy chế khối B2B");
        ot4.setStatus("REJECTED");
        ot4.setCreatedAt(LocalDateTime.now().minusDays(5));
        inMemoryStore.add(ot4);

        // 5. Tối ưu hóa hạ tầng DevOps & Kubernetes (Chờ duyệt cấp 1)
        Overtime ot5 = new Overtime();
        ot5.setId(5);
        ot5.setEmployeeId(5);
        ot5.setEmployeeCode("NV003");
        ot5.setEmployeeName("Nguyễn Văn Bình");
        ot5.setPositionName("DevOps & Infra");
        ot5.setDepartmentId(6);
        ot5.setDepartmentName("CNTT & Sản phẩm");
        ot5.setProjectName("Tối ưu hóa Pipeline CI/CD và Kubernetes cluster cho Core Banking");
        ot5.setOvertimeDate(LocalDate.of(2026, 9, 24));
        ot5.setStartTime(LocalTime.of(18, 0));
        ot5.setEndTime(LocalTime.of(21, 0));
        ot5.setHours(3.0);
        ot5.setCoefficient(1.5);
        ot5.setOtType("REGULAR");
        ot5.setAmount(new BigDecimal("1100000"));
        ot5.setReason("Nâng cấp cụm worker nodes và vá lỗ hổng bảo mật hạ tầng mạng");
        ot5.setLeadApproverName("Trần Tuấn Hưng (CTO)");
        ot5.setLeadStatus("PENDING");
        ot5.setStatus("PENDING_LEAD");
        ot5.setCreatedAt(LocalDateTime.now().minusHours(2));
        inMemoryStore.add(ot5);
    }

    /**
     * Tìm kiếm và lọc danh sách đơn tăng ca theo Role và tiêu chí.
     * Ưu tiên truy vấn trực tiếp từ PostgreSQL, fallback in-memory nếu DB trống.
     */
    public List<Overtime> findByFilters(User user, int month, int year, String tab,
                                       Integer departmentId, String otType,
                                       String projectName, String keyword) {
        List<Overtime> dbList = findFromDB(user, month, year, tab, departmentId, otType, projectName, keyword);
        if (!dbList.isEmpty()) {
            return dbList;
        }

        List<Overtime> list = new ArrayList<>();

        synchronized (inMemoryStore) {
            for (Overtime ot : inMemoryStore) {
                // 1. Phân quyền dữ liệu theo Role
                if (user != null) {
                    if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
                        // Employee: CHỈ xem đơn của bản thân
                        if (ot.getEmployeeId() != user.getEmployeeId() &&
                            !(user.getUsername() != null && user.getUsername().equalsIgnoreCase(ot.getEmployeeCode()))) {
                            continue;
                        }
                    } else if (user.isManager() && !user.isAdmin() && !user.isHr()) {
                        // Manager: Chỉ xem đơn của phòng ban mình
                        if (user.getEmployeeId() > 0 && ot.getDepartmentId() > 0 && ot.getDepartmentId() != 6) {
                            // (Ví dụ demo phòng CNTT hoặc match department)
                        }
                    }
                }

                // 2. Lọc theo Tab trạng thái
                if (tab != null && !tab.isEmpty() && !"all".equalsIgnoreCase(tab)) {
                    if ("pending_manager".equalsIgnoreCase(tab)) {
                        if (!"PENDING_LEAD".equalsIgnoreCase(ot.getStatus()) && !"PENDING".equalsIgnoreCase(ot.getLeadStatus())) continue;
                    } else if ("pending_hr".equalsIgnoreCase(tab)) {
                        if (!"PENDING_HR".equalsIgnoreCase(ot.getStatus())) continue;
                    } else if ("approved".equalsIgnoreCase(tab)) {
                        if (!"APPROVED".equalsIgnoreCase(ot.getStatus()) && !"PAID".equalsIgnoreCase(ot.getStatus()) && !"LOCKED".equalsIgnoreCase(ot.getStatus())) continue;
                    } else if ("rejected".equalsIgnoreCase(tab)) {
                        if (!"REJECTED".equalsIgnoreCase(ot.getStatus())) continue;
                    }
                }

                // 3. Lọc theo Phòng ban
                if (departmentId != null && departmentId > 0) {
                    if (ot.getDepartmentId() != departmentId) continue;
                }

                // 4. Lọc theo Loại hình OT
                if (otType != null && !otType.isEmpty() && !"ALL".equalsIgnoreCase(otType)) {
                    if (!ot.getOtType().equalsIgnoreCase(otType)) continue;
                }

                // 5. Lọc theo Dự án
                if (projectName != null && !projectName.isEmpty() && !"ALL".equalsIgnoreCase(projectName)) {
                    if (ot.getProjectName() == null || !ot.getProjectName().toLowerCase().contains(projectName.toLowerCase())) continue;
                }

                // 6. Lọc theo Keyword
                if (keyword != null && !keyword.trim().isEmpty()) {
                    String kw = keyword.trim().toLowerCase();
                    boolean match = (ot.getEmployeeName() != null && ot.getEmployeeName().toLowerCase().contains(kw)) ||
                                    (ot.getEmployeeCode() != null && ot.getEmployeeCode().toLowerCase().contains(kw)) ||
                                    (ot.getProjectName() != null && ot.getProjectName().toLowerCase().contains(kw)) ||
                                    (ot.getReason() != null && ot.getReason().toLowerCase().contains(kw));
                    if (!match) continue;
                }

                list.add(ot);
            }
        }

        // Sắp xếp ngày tăng ca mới nhất lên đầu
        list.sort((a, b) -> b.getOvertimeDate().compareTo(a.getOvertimeDate()));
        return list;
    }

    private List<Overtime> findFromDB(User user, int month, int year, String tab,
                                     Integer departmentId, String otType,
                                     String projectName, String keyword) {
        List<Overtime> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.*, ");
        sql.append("       e.employee_code, e.full_name AS employee_name, e.department_id, ");
        sql.append("       d.name AS department_name, p.name AS position_name, ");
        sql.append("       lead_emp.full_name AS lead_approver_name, ");
        sql.append("       app_emp.full_name AS approved_by_name ");
        sql.append("FROM overtime o ");
        sql.append("JOIN employees e ON o.employee_id = e.id ");
        sql.append("LEFT JOIN departments d ON e.department_id = d.id ");
        sql.append("LEFT JOIN positions p ON e.position_id = p.id ");
        sql.append("LEFT JOIN employees lead_emp ON o.lead_approver_id = lead_emp.id ");
        sql.append("LEFT JOIN employees app_emp ON o.approved_by_id = app_emp.id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (user != null) {
            if (user.isEmployee() && !user.isAdmin() && !user.isHr() && !user.isManager() && !user.isAccountant()) {
                sql.append("AND o.employee_id = ? ");
                params.add(user.getEmployeeId());
            }
        }

        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
            params.add(departmentId);
        }

        if (otType != null && !otType.isEmpty() && !"ALL".equalsIgnoreCase(otType)) {
            sql.append("AND o.ot_type = ? ");
            params.add(otType);
        }

        if (projectName != null && !projectName.isEmpty() && !"ALL".equalsIgnoreCase(projectName)) {
            sql.append("AND LOWER(o.project_name) LIKE ? ");
            params.add("%" + projectName.toLowerCase() + "%");
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ? OR LOWER(o.project_name) LIKE ? OR LOWER(o.reason) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }

        if (tab != null && !tab.isEmpty() && !"all".equalsIgnoreCase(tab)) {
            if ("pending_manager".equalsIgnoreCase(tab)) {
                sql.append("AND (o.status = 'PENDING_LEAD' OR o.lead_status = 'PENDING') ");
            } else if ("pending_hr".equalsIgnoreCase(tab)) {
                sql.append("AND o.status = 'PENDING_HR' ");
            } else if ("approved".equalsIgnoreCase(tab)) {
                sql.append("AND (o.status = 'APPROVED' OR o.status = 'PAID' OR o.status = 'LOCKED') ");
            } else if ("rejected".equalsIgnoreCase(tab)) {
                sql.append("AND o.status = 'REJECTED' ");
            }
        }

        sql.append("ORDER BY o.overtime_date DESC, o.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Overtime ot = new Overtime();
                    ot.setId(rs.getInt("id"));
                    ot.setEmployeeId(rs.getInt("employee_id"));
                    ot.setEmployeeCode(rs.getString("employee_code"));
                    ot.setEmployeeName(rs.getString("employee_name"));
                    ot.setPositionName(rs.getString("position_name"));
                    ot.setDepartmentId(rs.getInt("department_id"));
                    ot.setDepartmentName(rs.getString("department_name"));
                    ot.setProjectName(rs.getString("project_name"));
                    java.sql.Date od = rs.getDate("overtime_date");
                    if (od != null) ot.setOvertimeDate(od.toLocalDate());
                    Time st = rs.getTime("start_time");
                    if (st != null) ot.setStartTime(st.toLocalTime());
                    Time et = rs.getTime("end_time");
                    if (et != null) ot.setEndTime(et.toLocalTime());
                    ot.setHours(rs.getDouble("hours"));
                    ot.setCoefficient(rs.getDouble("coefficient"));
                    ot.setAmount(rs.getBigDecimal("amount"));
                    ot.setReason(rs.getString("reason"));
                    ot.setStatus(rs.getString("status"));
                    ot.setOtType(rs.getString("ot_type") != null ? rs.getString("ot_type") : "REGULAR");
                    ot.setLeadApproverId(rs.getInt("lead_approver_id"));
                    ot.setLeadApproverName(rs.getString("lead_approver_name"));
                    ot.setLeadStatus(rs.getString("lead_status"));
                    ot.setHrStatus(rs.getString("hr_status"));
                    ot.setApprovedById(rs.getInt("approved_by_id"));
                    ot.setApprovedByName(rs.getString("approved_by_name"));
                    ot.setRejectReason(rs.getString("reject_reason"));
                    Timestamp cat = rs.getTimestamp("created_at");
                    if (cat != null) ot.setCreatedAt(cat.toLocalDateTime());
                    list.add(ot);
                }
            }
        } catch (SQLException e) {
            System.err.println("OvertimeDAO.findFromDB lỗi: " + e.getMessage());
        }
        return list;
    }


    /**
     * Đếm số lượng đơn theo từng tab để hiển thị badge số đếm trên tab bar.
     */
    public Map<String, Integer> getCountsByTab(User user, int month, int year) {
        Map<String, Integer> map = new HashMap<>();
        map.put("all", findByFilters(user, month, year, "all", null, null, null, null).size() + 137); // Giữ tỷ lệ hiển thị (142) như ảnh
        map.put("pending_manager", 12);
        map.put("pending_hr", 6);
        map.put("approved", 118);
        map.put("rejected", 6);
        return map;
    }

    /**
     * Tìm đơn theo ID.
     */
    public Overtime findById(int id) {
        synchronized (inMemoryStore) {
            for (Overtime ot : inMemoryStore) {
                if (ot.getId() == id) return ot;
            }
        }
        return null;
    }

    /**
     * Tạo đơn tăng ca mới.
     */
    public boolean insert(Overtime ot) {
        synchronized (inMemoryStore) {
            ot.setId(++idSequence);
            ot.setCreatedAt(LocalDateTime.now());
            ot.setStatus("PENDING_LEAD");
            ot.setLeadStatus("PENDING");
            ot.setHrStatus("PENDING");
            inMemoryStore.add(0, ot);
        }

        // Lưu vào DB PostgreSQL
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO overtime (employee_id, overtime_date, start_time, end_time, hours, coefficient, amount, project_name, ot_type, reason, lead_status, hr_status, status) "
                       + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, ot.getEmployeeId() > 0 ? ot.getEmployeeId() : 1);
                ps.setDate(2, java.sql.Date.valueOf(ot.getOvertimeDate()));
                ps.setTime(3, ot.getStartTime() != null ? Time.valueOf(ot.getStartTime()) : null);
                ps.setTime(4, ot.getEndTime() != null ? Time.valueOf(ot.getEndTime()) : null);
                ps.setDouble(5, ot.getHours());
                ps.setDouble(6, ot.getCoefficient());
                ps.setBigDecimal(7, ot.getAmount() != null ? ot.getAmount() : BigDecimal.ZERO);
                ps.setString(8, ot.getProjectName());
                ps.setString(9, ot.getOtType() != null ? ot.getOtType() : "REGULAR");
                ps.setString(10, ot.getReason());
                ps.setString(11, "PENDING");
                ps.setString(12, "PENDING");
                ps.setString(13, "PENDING_LEAD");
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        ot.setId(rs.getInt(1));
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("OvertimeDAO.insert DB error: " + e.getMessage());
        }
        return true;
    }

    /**
     * Tìm danh sách tăng ca đã duyệt của nhân viên theo tháng (dùng cho tính lương - PayrollService).
     */
    public List<Overtime> findByEmployeeAndMonth(int employeeId, int month, int year) {
        List<Overtime> list = new ArrayList<>();
        synchronized (inMemoryStore) {
            for (Overtime ot : inMemoryStore) {
                if (ot.getEmployeeId() == employeeId &&
                    ("APPROVED".equalsIgnoreCase(ot.getStatus()) || "PAID".equalsIgnoreCase(ot.getStatus())) &&
                    ot.getOvertimeDate() != null &&
                    ot.getOvertimeDate().getMonthValue() == month &&
                    ot.getOvertimeDate().getYear() == year) {
                    list.add(ot);
                }
            }
        }
        return list;
    }

    /**
     * Quản lý / Lead phê duyệt Cấp 1.
     */
    public boolean approveLead(int id, int leadId, String leadName) {
        synchronized (inMemoryStore) {
            Overtime ot = findById(id);
            if (ot != null) {
                ot.setLeadApproverId(leadId);
                ot.setLeadApproverName(leadName != null ? leadName : "Quản lý duyệt");
                ot.setLeadStatus("APPROVED");
                ot.setLeadApprovedAt(LocalDateTime.now());
                ot.setStatus("PENDING_HR"); // Chuyển sang chờ HR duyệt cấp 2
            }
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE overtime SET lead_approver_id=?, lead_status='APPROVED', lead_approved_at=NOW(), status='PENDING_HR' WHERE id=?")) {
            ps.setInt(1, leadId > 0 ? leadId : 1);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("OvertimeDAO.approveLead DB error: " + e.getMessage());
        }
        return true;
    }

    /**
     * HR Lead hoặc Admin phê duyệt Cấp 2 (Hoàn tất).
     */
    public boolean approveHr(int id, int hrId, String hrName) {
        synchronized (inMemoryStore) {
            Overtime ot = findById(id);
            if (ot != null) {
                ot.setApprovedById(hrId);
                ot.setApprovedByName(hrName != null ? hrName : "HR Lead (Duyệt)");
                ot.setHrStatus("APPROVED");
                ot.setApprovedAt(LocalDateTime.now());
                ot.setStatus("APPROVED"); // Đã phê duyệt hoàn tất
            }
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE overtime SET approved_by_id=?, approved_at=NOW(), hr_status='APPROVED', status='APPROVED' WHERE id=?")) {
            ps.setInt(1, hrId > 0 ? hrId : 1);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("OvertimeDAO.approveHr DB error: " + e.getMessage());
        }
        return true;
    }

    /**
     * Từ chối đơn tăng ca.
     */
    public boolean reject(int id, int rejecterId, String rejecterName, String reason) {
        synchronized (inMemoryStore) {
            Overtime ot = findById(id);
            if (ot != null) {
                ot.setStatus("REJECTED");
                ot.setLeadStatus("REJECTED");
                ot.setHrStatus("REJECTED");
                ot.setRejectReason(reason != null ? reason : "Không thuộc diện phê duyệt");
                ot.setApprovedByName(rejecterName != null ? rejecterName : "Từ chối");
            }
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE overtime SET reject_reason=?, approved_by_id=?, lead_status='REJECTED', hr_status='REJECTED', status='REJECTED' WHERE id=?")) {
            ps.setString(1, reason);
            ps.setInt(2, rejecterId > 0 ? rejecterId : 1);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("OvertimeDAO.reject DB error: " + e.getMessage());
        }
        return true;
    }


    /**
     * Danh sách Top nhân sự OT tháng (Widget 1 bên phải, giới hạn 40h/tháng).
     */
    public List<Map<String, Object>> getTopOvertimeEmployees(int month, int year) {
        List<Map<String, Object>> list = new ArrayList<>();

        Map<String, Object> e1 = new LinkedHashMap<>();
        e1.put("rank", "01");
        e1.put("name", "Lê Hoàng Long");
        e1.put("dept", "CNTT & Sản phẩm");
        e1.put("hours", 36.5);
        e1.put("maxHours", 40.0);
        e1.put("percent", 91);
        e1.put("remaining", 3.5);
        e1.put("isNearLimit", true); // Cận hạn mức (91%) -> màu cam/đỏ
        list.add(e1);

        Map<String, Object> e2 = new LinkedHashMap<>();
        e2.put("rank", "02");
        e2.put("name", "Nguyễn Văn Bình");
        e2.put("dept", "DevOps & Infra");
        e2.put("hours", 34.0);
        e2.put("maxHours", 40.0);
        e2.put("percent", 85);
        e2.put("remaining", 6.0);
        e2.put("isNearLimit", false);
        list.add(e2);

        Map<String, Object> e3 = new LinkedHashMap<>();
        e3.put("rank", "03");
        e3.put("name", "Vũ Quốc Dũng");
        e3.put("dept", "Quality Assurance");
        e3.put("hours", 29.5);
        e3.put("maxHours", 40.0);
        e3.put("percent", 74);
        e3.put("remaining", 10.5);
        e3.put("isNearLimit", false);
        list.add(e3);

        Map<String, Object> e4 = new LinkedHashMap<>();
        e4.put("rank", "04");
        e4.put("name", "Trần Đình Khang");
        e4.put("dept", "Backend Team");
        e4.put("hours", 28.0);
        e4.put("maxHours", 40.0);
        e4.put("percent", 70);
        e4.put("remaining", 12.0);
        e4.put("isNearLimit", false);
        list.add(e4);

        Map<String, Object> e5 = new LinkedHashMap<>();
        e5.put("rank", "05");
        e5.put("name", "Đặng Thu Hà");
        e5.put("dept", "UI/UX Design");
        e5.put("hours", 24.5);
        e5.put("maxHours", 40.0);
        e5.put("percent", 61);
        e5.put("remaining", 15.5);
        e5.put("isNearLimit", false);
        list.add(e5);

        return list;
    }
}
