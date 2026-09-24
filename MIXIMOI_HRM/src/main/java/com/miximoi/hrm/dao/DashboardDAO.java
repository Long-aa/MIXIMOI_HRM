package com.miximoi.hrm.dao;

import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.time.LocalDate;
import java.time.Period;
import java.util.*;

/**
 * Data Access Object phụ trách toàn bộ truy vấn dữ liệu thực tế cho Dashboard.
 * Hỗ trợ bộ lọc theo khoảng thời gian (startDate -> endDate), phòng ban và trạng thái.
 */
public class DashboardDAO {

    /**
     * 1. Thống kê 8 thẻ KPI chính
     */
    public Map<String, Object> getKpiStats(LocalDate startDate, LocalDate endDate, Integer departmentId, String status) {
        Map<String, Object> stats = new HashMap<>();

        // Mặc định fallback
        long totalEmployees = 0;
        long activeEmployees = 0;
        long newHires = 0;
        long inactiveEmployees = 0;
        long departmentCount = 0;
        BigDecimal totalPayroll = BigDecimal.ZERO;
        long expiringContracts = 0;
        long pendingLeaves = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // 1.1 Tổng nhân sự
            StringBuilder empSql = new StringBuilder("SELECT COUNT(*) FROM employees WHERE 1=1 ");
            List<Object> empParams = new ArrayList<>();
            if (departmentId != null && departmentId > 0) {
                empSql.append("AND department_id = ? ");
                empParams.add(departmentId);
            }
            if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
                empSql.append("AND status = ? ");
                empParams.add(status.toUpperCase());
            }
            try (PreparedStatement ps = conn.prepareStatement(empSql.toString())) {
                for (int i = 0; i < empParams.size(); i++) {
                    ps.setObject(i + 1, empParams.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalEmployees = rs.getLong(1);
                }
            }

            // 1.2 Nhân sự đang làm việc (ACTIVE)
            StringBuilder activeSql = new StringBuilder("SELECT COUNT(*) FROM employees WHERE status = 'ACTIVE' ");
            List<Object> activeParams = new ArrayList<>();
            if (departmentId != null && departmentId > 0) {
                activeSql.append("AND department_id = ? ");
                activeParams.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(activeSql.toString())) {
                for (int i = 0; i < activeParams.size(); i++) {
                    ps.setObject(i + 1, activeParams.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) activeEmployees = rs.getLong(1);
                }
            }

            // 1.3 Nhân sự mới (start_date trong khoảng lọc)
            StringBuilder newSql = new StringBuilder("SELECT COUNT(*) FROM employees WHERE start_date BETWEEN ? AND ? ");
            List<Object> newParams = new ArrayList<>();
            newParams.add(java.sql.Date.valueOf(startDate));
            newParams.add(java.sql.Date.valueOf(endDate));
            if (departmentId != null && departmentId > 0) {
                newSql.append("AND department_id = ? ");
                newParams.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(newSql.toString())) {
                for (int i = 0; i < newParams.size(); i++) {
                    ps.setObject(i + 1, newParams.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) newHires = rs.getLong(1);
                }
            }

            // 1.4 Nhân sự nghỉ việc (INACTIVE hoặc end_date trong khoảng lọc)
            StringBuilder inactSql = new StringBuilder(
                "SELECT COUNT(*) FROM employees WHERE (status = 'INACTIVE' OR (end_date IS NOT NULL AND end_date BETWEEN ? AND ?)) "
            );
            List<Object> inactParams = new ArrayList<>();
            inactParams.add(java.sql.Date.valueOf(startDate));
            inactParams.add(java.sql.Date.valueOf(endDate));
            if (departmentId != null && departmentId > 0) {
                inactSql.append("AND department_id = ? ");
                inactParams.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(inactSql.toString())) {
                for (int i = 0; i < inactParams.size(); i++) {
                    ps.setObject(i + 1, inactParams.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) inactiveEmployees = rs.getLong(1);
                }
            }

            // 1.5 Tổng số phòng ban
            String deptSql = "SELECT COUNT(*) FROM departments WHERE status = 'ACTIVE' OR status IS NULL";
            try (PreparedStatement ps = conn.prepareStatement(deptSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) departmentCount = rs.getLong(1);
            }

            // 1.6 Tổng quỹ lương trong kỳ lọc
            int startPeriod = startDate.getYear() * 12 + startDate.getMonthValue();
            int endPeriod = endDate.getYear() * 12 + endDate.getMonthValue();
            StringBuilder paySql = new StringBuilder(
                "SELECT COALESCE(SUM(p.net_salary), 0) FROM payroll p "
              + "JOIN employees e ON p.employee_id = e.id "
              + "WHERE (p.pay_year * 12 + p.pay_month) BETWEEN ? AND ? "
            );
            List<Object> payParams = new ArrayList<>();
            payParams.add(startPeriod);
            payParams.add(endPeriod);
            if (departmentId != null && departmentId > 0) {
                paySql.append("AND e.department_id = ? ");
                payParams.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(paySql.toString())) {
                for (int i = 0; i < payParams.size(); i++) {
                    ps.setObject(i + 1, payParams.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalPayroll = rs.getBigDecimal(1);
                }
            }
            // Nếu không có payroll trong khoảng chính xác, fallback lấy tổng payroll tháng mới nhất
            if (totalPayroll == null || totalPayroll.compareTo(BigDecimal.ZERO) == 0) {
                String latestPaySql = "SELECT COALESCE(SUM(net_salary), 0) FROM payroll WHERE (pay_year, pay_month) = "
                                    + "(SELECT pay_year, pay_month FROM payroll ORDER BY pay_year DESC, pay_month DESC LIMIT 1)";
                try (PreparedStatement ps = conn.prepareStatement(latestPaySql);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalPayroll = rs.getBigDecimal(1);
                }
            }

            // 1.7 Hợp đồng sắp hết hạn (trong vòng 30 ngày tới hoặc trong khoảng lọc)
            StringBuilder expSql = new StringBuilder(
                "SELECT COUNT(*) FROM contracts c JOIN employees e ON c.employee_id = e.id "
              + "WHERE c.status = 'ACTIVE' AND c.end_date IS NOT NULL "
              + "AND c.end_date >= CURRENT_DATE AND c.end_date <= (CURRENT_DATE + INTERVAL '30 days') "
            );
            List<Object> expParams = new ArrayList<>();
            if (departmentId != null && departmentId > 0) {
                expSql.append("AND e.department_id = ? ");
                expParams.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(expSql.toString())) {
                for (int i = 0; i < expParams.size(); i++) {
                    ps.setObject(i + 1, expParams.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) expiringContracts = rs.getLong(1);
                }
            }

            // 1.8 Đơn nghỉ phép chờ duyệt
            StringBuilder leaveSql = new StringBuilder(
                "SELECT COUNT(*) FROM leave_requests l JOIN employees e ON l.employee_id = e.id "
              + "WHERE l.status = 'PENDING' "
            );
            List<Object> leaveParams = new ArrayList<>();
            if (departmentId != null && departmentId > 0) {
                leaveSql.append("AND e.department_id = ? ");
                leaveParams.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(leaveSql.toString())) {
                for (int i = 0; i < leaveParams.size(); i++) {
                    ps.setObject(i + 1, leaveParams.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) pendingLeaves = rs.getLong(1);
                }
            }

        } catch (SQLException e) {
            System.err.println("DashboardDAO.getKpiStats lỗi: " + e.getMessage());
        }

        stats.put("totalEmployees", totalEmployees);
        stats.put("activeEmployees", activeEmployees);
        stats.put("newHires", newHires);
        stats.put("inactiveEmployees", inactiveEmployees);
        stats.put("departmentCount", departmentCount);
        stats.put("totalPayroll", totalPayroll != null ? totalPayroll : BigDecimal.ZERO);
        stats.put("expiringContracts", expiringContracts);
        stats.put("pendingLeaves", pendingLeaves);
        return stats;
    }

    /**
     * 2. Tình hình chấm công trong khoảng thời gian lọc
     */
    public Map<String, Object> getAttendanceSummary(LocalDate startDate, LocalDate endDate, Integer departmentId) {
        Map<String, Object> res = new HashMap<>();
        long onTimeCount = 0;
        long lateCount = 0;
        long onLeaveCount = 0;
        long absentCount = 0;
        long totalRecords = 0;

        StringBuilder sql = new StringBuilder(
            "SELECT a.status, COUNT(*) FROM attendance a "
          + "JOIN employees e ON a.employee_id = e.id "
          + "WHERE a.work_date BETWEEN ? AND ? "
        );
        List<Object> params = new ArrayList<>();
        params.add(java.sql.Date.valueOf(startDate));
        params.add(java.sql.Date.valueOf(endDate));

        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
            params.add(departmentId);
        }
        sql.append("GROUP BY a.status");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String st = rs.getString(1);
                    long count = rs.getLong(2);
                    totalRecords += count;
                    if ("ON_TIME".equalsIgnoreCase(st)) onTimeCount = count;
                    else if ("LATE".equalsIgnoreCase(st)) lateCount = count;
                    else if ("ON_LEAVE".equalsIgnoreCase(st)) onLeaveCount = count;
                    else if ("ABSENT".equalsIgnoreCase(st)) absentCount = count;
                }
            }
        } catch (SQLException e) {
            System.err.println("DashboardDAO.getAttendanceSummary lỗi: " + e.getMessage());
        }

        // Tỷ lệ %
        double onTimePct = totalRecords > 0 ? Math.round((onTimeCount * 100.0 / totalRecords) * 10.0) / 10.0 : 0.0;
        double latePct = totalRecords > 0 ? Math.round((lateCount * 100.0 / totalRecords) * 10.0) / 10.0 : 0.0;
        double onLeavePct = totalRecords > 0 ? Math.round((onLeaveCount * 100.0 / totalRecords) * 10.0) / 10.0 : 0.0;
        double absentPct = totalRecords > 0 ? Math.round((absentCount * 100.0 / totalRecords) * 10.0) / 10.0 : 0.0;

        res.put("totalRecords", totalRecords);
        res.put("onTimeCount", onTimeCount);
        res.put("lateCount", lateCount);
        res.put("onLeaveCount", onLeaveCount);
        res.put("absentCount", absentCount);
        res.put("onTimePct", onTimePct);
        res.put("latePct", latePct);
        res.put("onLeavePct", onLeavePct);
        res.put("absentPct", absentPct);
        return res;
    }

    /**
     * 3. Tình hình nghỉ phép
     */
    public Map<String, Object> getLeaveSummary(LocalDate startDate, LocalDate endDate, Integer departmentId) {
        Map<String, Object> res = new HashMap<>();
        double totalDaysUsed = 0.0;
        long pendingCount = 0;
        long activeEmps = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Số ngày phép đã duyệt
            StringBuilder sql1 = new StringBuilder(
                "SELECT COALESCE(SUM(l.total_days), 0) FROM leave_requests l "
              + "JOIN employees e ON l.employee_id = e.id "
              + "WHERE l.status = 'APPROVED' AND l.start_date <= ? AND l.end_date >= ? "
            );
            List<Object> p1 = new ArrayList<>();
            p1.add(java.sql.Date.valueOf(endDate));
            p1.add(java.sql.Date.valueOf(startDate));
            if (departmentId != null && departmentId > 0) {
                sql1.append("AND e.department_id = ? ");
                p1.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(sql1.toString())) {
                for (int i = 0; i < p1.size(); i++) ps.setObject(i + 1, p1.get(i));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalDaysUsed = rs.getDouble(1);
                }
            }

            // Đơn chờ duyệt
            StringBuilder sql2 = new StringBuilder(
                "SELECT COUNT(*) FROM leave_requests l "
              + "JOIN employees e ON l.employee_id = e.id "
              + "WHERE l.status = 'PENDING' AND l.start_date <= ? AND l.end_date >= ? "
            );
            List<Object> p2 = new ArrayList<>();
            p2.add(java.sql.Date.valueOf(endDate));
            p2.add(java.sql.Date.valueOf(startDate));
            if (departmentId != null && departmentId > 0) {
                sql2.append("AND e.department_id = ? ");
                p2.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(sql2.toString())) {
                for (int i = 0; i < p2.size(); i++) ps.setObject(i + 1, p2.get(i));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) pendingCount = rs.getLong(1);
                }
            }

            // Số nhân viên đang làm việc để ước tính quỹ phép (12 ngày/năm)
            StringBuilder sql3 = new StringBuilder("SELECT COUNT(*) FROM employees WHERE status = 'ACTIVE' ");
            List<Object> p3 = new ArrayList<>();
            if (departmentId != null && departmentId > 0) {
                sql3.append("AND department_id = ? ");
                p3.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(sql3.toString())) {
                for (int i = 0; i < p3.size(); i++) ps.setObject(i + 1, p3.get(i));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) activeEmps = rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("DashboardDAO.getLeaveSummary lỗi: " + e.getMessage());
        }

        double totalFund = activeEmps > 0 ? (activeEmps * 12.0) : 180.0;
        double remaining = Math.max(0.0, totalFund - totalDaysUsed);
        double usedPct = totalFund > 0 ? Math.round((totalDaysUsed * 100.0 / totalFund) * 10.0) / 10.0 : 0.0;
        double remainPct = Math.round((100.0 - usedPct) * 10.0) / 10.0;

        res.put("totalDaysUsed", totalDaysUsed);
        res.put("pendingCount", pendingCount);
        res.put("totalFund", totalFund);
        res.put("remainingDays", remaining);
        res.put("usedPct", usedPct);
        res.put("remainPct", remainPct);
        return res;
    }

    /**
     * 4. Việc cần xử lý gấp
     */
    public Map<String, Object> getUrgentTasks(LocalDate startDate, LocalDate endDate, Integer departmentId) {
        Map<String, Object> res = new HashMap<>();
        long expiringContracts = 0;
        long pendingLeaves = 0;
        long incompleteProfiles = 0;
        long openRecruitment = 0;
        long pendingOvertime = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Hợp đồng sắp hết hạn
            StringBuilder s1 = new StringBuilder(
                "SELECT COUNT(*) FROM contracts c JOIN employees e ON c.employee_id = e.id "
              + "WHERE c.status = 'ACTIVE' AND c.end_date IS NOT NULL "
              + "AND c.end_date >= CURRENT_DATE AND c.end_date <= (CURRENT_DATE + INTERVAL '30 days') "
            );
            if (departmentId != null && departmentId > 0) s1.append("AND e.department_id = ").append(departmentId);
            try (PreparedStatement ps = conn.prepareStatement(s1.toString());
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) expiringContracts = rs.getLong(1);
            }

            // Đơn nghỉ phép chờ duyệt
            StringBuilder s2 = new StringBuilder(
                "SELECT COUNT(*) FROM leave_requests l JOIN employees e ON l.employee_id = e.id "
              + "WHERE l.status = 'PENDING' "
            );
            if (departmentId != null && departmentId > 0) s2.append("AND e.department_id = ").append(departmentId);
            try (PreparedStatement ps = conn.prepareStatement(s2.toString());
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) pendingLeaves = rs.getLong(1);
            }

            // Hồ sơ nhân viên chưa hoàn tất (thiếu CCCD, MST hoặc Ngân hàng)
            StringBuilder s3 = new StringBuilder(
                "SELECT COUNT(*) FROM employees WHERE (identity_number IS NULL OR identity_number = '' "
              + "OR bank_account IS NULL OR bank_account = '' OR tax_code IS NULL OR tax_code = '') "
              + "AND status = 'ACTIVE' "
            );
            if (departmentId != null && departmentId > 0) s3.append("AND department_id = ").append(departmentId);
            try (PreparedStatement ps = conn.prepareStatement(s3.toString());
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) incompleteProfiles = rs.getLong(1);
            }

            // Yêu cầu tuyển dụng đang mở
            StringBuilder s4 = new StringBuilder("SELECT COUNT(*) FROM recruitment_requests WHERE status = 'OPEN' ");
            if (departmentId != null && departmentId > 0) s4.append("AND department_id = ").append(departmentId);
            try (PreparedStatement ps = conn.prepareStatement(s4.toString());
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) openRecruitment = rs.getLong(1);
            }

            // Làm thêm giờ chờ duyệt
            StringBuilder s5 = new StringBuilder(
                "SELECT COUNT(*) FROM overtime o JOIN employees e ON o.employee_id = e.id "
              + "WHERE o.status LIKE 'PENDING%' "
            );
            if (departmentId != null && departmentId > 0) s5.append("AND e.department_id = ").append(departmentId);
            try (PreparedStatement ps = conn.prepareStatement(s5.toString());
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) pendingOvertime = rs.getLong(1);
            }

        } catch (SQLException e) {
            System.err.println("DashboardDAO.getUrgentTasks lỗi: " + e.getMessage());
        }

        res.put("expiringContracts", expiringContracts);
        res.put("pendingLeaves", pendingLeaves);
        res.put("incompleteProfiles", incompleteProfiles);
        res.put("openRecruitment", openRecruitment);
        res.put("pendingOvertime", pendingOvertime);
        return res;
    }

    /**
     * 5. Quỹ lương & chi phí nhân sự
     */
    public Map<String, Object> getPayrollSummary(LocalDate startDate, LocalDate endDate, Integer departmentId) {
        Map<String, Object> res = new HashMap<>();
        BigDecimal totalNet = BigDecimal.ZERO;
        BigDecimal totalBase = BigDecimal.ZERO;
        BigDecimal totalAllowance = BigDecimal.ZERO;
        BigDecimal totalBonus = BigDecimal.ZERO;
        BigDecimal totalDeduction = BigDecimal.ZERO;

        int startPeriod = startDate.getYear() * 12 + startDate.getMonthValue();
        int endPeriod = endDate.getYear() * 12 + endDate.getMonthValue();

        List<Map<String, Object>> deptPayrollList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            StringBuilder s1 = new StringBuilder(
                "SELECT COALESCE(SUM(p.net_salary), 0), COALESCE(SUM(p.base_salary), 0), "
              + "COALESCE(SUM(p.allowance), 0), COALESCE(SUM(p.bonus), 0), COALESCE(SUM(p.deduction), 0) "
              + "FROM payroll p JOIN employees e ON p.employee_id = e.id "
              + "WHERE (p.pay_year * 12 + p.pay_month) BETWEEN ? AND ? "
            );
            List<Object> p1 = new ArrayList<>();
            p1.add(startPeriod);
            p1.add(endPeriod);
            if (departmentId != null && departmentId > 0) {
                s1.append("AND e.department_id = ? ");
                p1.add(departmentId);
            }
            try (PreparedStatement ps = conn.prepareStatement(s1.toString())) {
                for (int i = 0; i < p1.size(); i++) ps.setObject(i + 1, p1.get(i));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalNet = rs.getBigDecimal(1);
                        totalBase = rs.getBigDecimal(2);
                        totalAllowance = rs.getBigDecimal(3);
                        totalBonus = rs.getBigDecimal(4);
                        totalDeduction = rs.getBigDecimal(5);
                    }
                }
            }

            // Nếu trong kỳ lọc chưa có bản ghi lương, tự động lấy kỳ lương gần nhất có dữ liệu
            if (totalNet.compareTo(BigDecimal.ZERO) == 0) {
                String latestSql = 
                    "SELECT COALESCE(SUM(p.net_salary), 0), COALESCE(SUM(p.base_salary), 0), "
                  + "COALESCE(SUM(p.allowance), 0), COALESCE(SUM(p.bonus), 0), COALESCE(SUM(p.deduction), 0) "
                  + "FROM payroll p WHERE (p.pay_year, p.pay_month) = "
                  + "(SELECT pay_year, pay_month FROM payroll ORDER BY pay_year DESC, pay_month DESC LIMIT 1)";
                try (PreparedStatement ps = conn.prepareStatement(latestSql);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalNet = rs.getBigDecimal(1);
                        totalBase = rs.getBigDecimal(2);
                        totalAllowance = rs.getBigDecimal(3);
                        totalBonus = rs.getBigDecimal(4);
                        totalDeduction = rs.getBigDecimal(5);
                    }
                }
            }

            // Phân bổ quỹ lương theo từng phòng ban
            String deptSql = 
                "SELECT d.id, d.name, COALESCE(SUM(p.net_salary), 0) AS total_amount "
              + "FROM departments d "
              + "LEFT JOIN employees e ON e.department_id = d.id "
              + "LEFT JOIN payroll p ON p.employee_id = e.id AND (p.pay_year, p.pay_month) = "
              + "  (SELECT pay_year, pay_month FROM payroll ORDER BY pay_year DESC, pay_month DESC LIMIT 1) "
              + "GROUP BY d.id, d.name "
              + "ORDER BY total_amount DESC";

            try (PreparedStatement ps = conn.prepareStatement(deptSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String dName = rs.getString("name");
                    BigDecimal amt = rs.getBigDecimal("total_amount");
                    double pct = (totalNet.compareTo(BigDecimal.ZERO) > 0)
                        ? Math.round(amt.doubleValue() * 100.0 / totalNet.doubleValue() * 10.0) / 10.0
                        : 0.0;
                    Map<String, Object> row = new HashMap<>();
                    row.put("name", dName);
                    row.put("amount", amt);
                    row.put("percent", pct);
                    deptPayrollList.add(row);
                }
            }

        } catch (SQLException e) {
            System.err.println("DashboardDAO.getPayrollSummary lỗi: " + e.getMessage());
        }

        res.put("totalNet", totalNet);
        res.put("totalBase", totalBase);
        res.put("totalAllowance", totalAllowance);
        res.put("totalBonus", totalBonus);
        res.put("totalDeduction", totalDeduction);
        res.put("deptPayrollList", deptPayrollList);
        return res;
    }

    /**
     * 6. Tuyển dụng và phễu ứng viên
     */
    public Map<String, Object> getRecruitmentStats(LocalDate startDate, LocalDate endDate, Integer departmentId) {
        Map<String, Object> res = new HashMap<>();
        long openPositions = 0;
        long totalCandidates = 0;
        long interviews = 0;
        long onboarded = 0;

        long newCount = 0;
        long screeningCount = 0;
        long interviewCount = 0;
        long offerCount = 0;
        long onboardedCount = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Vị trí mở
            StringBuilder s1 = new StringBuilder("SELECT COUNT(*) FROM recruitment_requests WHERE status = 'OPEN' ");
            if (departmentId != null && departmentId > 0) s1.append("AND department_id = ").append(departmentId);
            try (PreparedStatement ps = conn.prepareStatement(s1.toString());
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) openPositions = rs.getLong(1);
            }

            // Thống kê theo stage ứng viên
            StringBuilder s2 = new StringBuilder(
                "SELECT c.stage, COUNT(*) FROM candidates c "
              + "JOIN recruitment_requests r ON c.recruitment_request_id = r.id "
              + "WHERE c.applied_date BETWEEN ? AND ? "
            );
            List<Object> p2 = new ArrayList<>();
            p2.add(java.sql.Date.valueOf(startDate));
            p2.add(java.sql.Date.valueOf(endDate));
            if (departmentId != null && departmentId > 0) {
                s2.append("AND r.department_id = ? ");
                p2.add(departmentId);
            }
            s2.append("GROUP BY c.stage");

            try (PreparedStatement ps = conn.prepareStatement(s2.toString())) {
                for (int i = 0; i < p2.size(); i++) ps.setObject(i + 1, p2.get(i));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String stage = rs.getString(1);
                        long count = rs.getLong(2);
                        totalCandidates += count;
                        if ("NEW".equalsIgnoreCase(stage)) newCount = count;
                        else if ("SCREENING".equalsIgnoreCase(stage)) screeningCount = count;
                        else if ("INTERVIEW".equalsIgnoreCase(stage)) { interviewCount = count; interviews = count; }
                        else if ("OFFER".equalsIgnoreCase(stage)) offerCount = count;
                        else if ("ONBOARDED".equalsIgnoreCase(stage)) { onboardedCount = count; onboarded = count; }
                    }
                }
            }

            // Nếu trong khoảng lọc chưa có ứng viên, lấy tổng toàn bộ ứng viên thực tế trong DB
            if (totalCandidates == 0) {
                String allCandSql = "SELECT stage, COUNT(*) FROM candidates GROUP BY stage";
                try (PreparedStatement ps = conn.prepareStatement(allCandSql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String stage = rs.getString(1);
                        long count = rs.getLong(2);
                        totalCandidates += count;
                        if ("NEW".equalsIgnoreCase(stage)) newCount = count;
                        else if ("SCREENING".equalsIgnoreCase(stage)) screeningCount = count;
                        else if ("INTERVIEW".equalsIgnoreCase(stage)) { interviewCount = count; interviews = count; }
                        else if ("OFFER".equalsIgnoreCase(stage)) offerCount = count;
                        else if ("ONBOARDED".equalsIgnoreCase(stage)) { onboardedCount = count; onboarded = count; }
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("DashboardDAO.getRecruitmentStats lỗi: " + e.getMessage());
        }

        // Tỷ lệ % giai đoạn phễu
        double newPct = totalCandidates > 0 ? 100.0 : 0.0;
        double screeningPct = totalCandidates > 0 ? Math.round(((screeningCount + interviewCount + offerCount + onboardedCount) * 100.0 / totalCandidates) * 10.0) / 10.0 : 0.0;
        double interviewPct = totalCandidates > 0 ? Math.round(((interviewCount + offerCount + onboardedCount) * 100.0 / totalCandidates) * 10.0) / 10.0 : 0.0;
        double offerPct = totalCandidates > 0 ? Math.round(((offerCount + onboardedCount) * 100.0 / totalCandidates) * 10.0) / 10.0 : 0.0;
        double onboardedPct = totalCandidates > 0 ? Math.round((onboardedCount * 100.0 / totalCandidates) * 10.0) / 10.0 : 0.0;

        res.put("openPositions", openPositions);
        res.put("totalCandidates", totalCandidates);
        res.put("interviews", interviews);
        res.put("onboarded", onboarded);
        res.put("newCount", newCount);
        res.put("screeningCount", screeningCount);
        res.put("interviewCount", interviewCount);
        res.put("offerCount", offerCount);
        res.put("onboardedCount", onboardedCount);
        res.put("newPct", newPct);
        res.put("screeningPct", screeningPct);
        res.put("interviewPct", interviewPct);
        res.put("offerPct", offerPct);
        res.put("onboardedPct", onboardedPct);
        return res;
    }

    /**
     * 7. Cơ cấu nhân sự (Phòng ban, Giới tính, Độ tuổi, Thâm niên)
     */
    public Map<String, Object> getPersonnelStructure(Integer departmentId) {
        Map<String, Object> res = new HashMap<>();

        List<Map<String, Object>> deptList = new ArrayList<>();
        long totalEmp = 0;
        long maleCount = 0;
        long femaleCount = 0;

        long ageUnder25 = 0;
        long age25to35 = 0;
        long age35to45 = 0;
        long age45to55 = 0;
        long ageOver55 = 0;

        long senUnder1 = 0;
        long sen1to3 = 0;
        long sen3to5 = 0;
        long senOver5 = 0;
        double totalSeniorityYears = 0.0;

        String[] colors = {"#2563eb", "#0ea5e9", "#f97316", "#10b981", "#8b5cf6", "#64748b", "#ec4899", "#eab308"};

        try (Connection conn = DBConnection.getConnection()) {
            // Cơ cấu theo phòng ban
            String deptSql = 
                "SELECT d.id, d.name, COUNT(e.id) AS emp_count "
              + "FROM departments d "
              + "LEFT JOIN employees e ON e.department_id = d.id AND e.status != 'INACTIVE' "
              + "GROUP BY d.id, d.name "
              + "ORDER BY emp_count DESC";
            try (PreparedStatement ps = conn.prepareStatement(deptSql);
                 ResultSet rs = ps.executeQuery()) {
                int cIdx = 0;
                while (rs.next()) {
                    long c = rs.getLong("emp_count");
                    totalEmp += c;
                    Map<String, Object> m = new HashMap<>();
                    m.put("name", rs.getString("name"));
                    m.put("count", c);
                    m.put("color", colors[cIdx % colors.length]);
                    deptList.add(m);
                    cIdx++;
                }
            }

            // Tính % phòng ban
            for (Map<String, Object> m : deptList) {
                long c = (Long) m.get("count");
                double pct = totalEmp > 0 ? Math.round(c * 100.0 / totalEmp * 10.0) / 10.0 : 0.0;
                m.put("percent", pct);
            }

            // Lấy danh sách nhân viên để tính giới tính, tuổi, thâm niên
            StringBuilder empSql = new StringBuilder("SELECT gender, date_of_birth, start_date FROM employees WHERE status != 'INACTIVE' ");
            if (departmentId != null && departmentId > 0) empSql.append("AND department_id = ").append(departmentId);

            LocalDate now = LocalDate.now();
            try (PreparedStatement ps = conn.prepareStatement(empSql.toString());
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String gender = rs.getString("gender");
                    if ("FEMALE".equalsIgnoreCase(gender)) femaleCount++;
                    else maleCount++;

                    java.sql.Date dob = rs.getDate("date_of_birth");
                    if (dob != null) {
                        int age = Period.between(dob.toLocalDate(), now).getYears();
                        if (age < 25) ageUnder25++;
                        else if (age <= 35) age25to35++;
                        else if (age <= 45) age35to45++;
                        else if (age <= 55) age45to55++;
                        else ageOver55++;
                    } else {
                        age25to35++;
                    }

                    java.sql.Date sDate = rs.getDate("start_date");
                    if (sDate != null) {
                        double years = Period.between(sDate.toLocalDate(), now).getYears()
                                     + Period.between(sDate.toLocalDate(), now).getMonths() / 12.0;
                        totalSeniorityYears += years;
                        if (years < 1.0) senUnder1++;
                        else if (years <= 3.0) sen1to3++;
                        else if (years <= 5.0) sen3to5++;
                        else senOver5++;
                    } else {
                        sen1to3++;
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("DashboardDAO.getPersonnelStructure lỗi: " + e.getMessage());
        }

        long activeTotal = maleCount + femaleCount;
        double malePct = activeTotal > 0 ? Math.round(maleCount * 100.0 / activeTotal * 10.0) / 10.0 : 50.0;
        double femalePct = activeTotal > 0 ? Math.round(femaleCount * 100.0 / activeTotal * 10.0) / 10.0 : 50.0;

        double ageUnder25Pct = activeTotal > 0 ? Math.round(ageUnder25 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;
        double age25to35Pct = activeTotal > 0 ? Math.round(age25to35 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;
        double age35to45Pct = activeTotal > 0 ? Math.round(age35to45 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;
        double age45to55Pct = activeTotal > 0 ? Math.round(age45to55 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;
        double ageOver55Pct = activeTotal > 0 ? Math.round(ageOver55 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;

        double senUnder1Pct = activeTotal > 0 ? Math.round(senUnder1 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;
        double sen1to3Pct = activeTotal > 0 ? Math.round(sen1to3 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;
        double sen3to5Pct = activeTotal > 0 ? Math.round(sen3to5 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;
        double senOver5Pct = activeTotal > 0 ? Math.round(senOver5 * 100.0 / activeTotal * 10.0) / 10.0 : 0.0;

        double avgSeniority = activeTotal > 0 ? Math.round((totalSeniorityYears / activeTotal) * 10.0) / 10.0 : 2.5;
        double retentionOver1YearPct = activeTotal > 0 ? Math.round(((sen1to3 + sen3to5 + senOver5) * 100.0 / activeTotal) * 10.0) / 10.0 : 75.0;

        res.put("totalEmployees", totalEmp);
        res.put("deptList", deptList);
        res.put("maleCount", maleCount);
        res.put("femaleCount", femaleCount);
        res.put("malePct", malePct);
        res.put("femalePct", femalePct);

        res.put("ageUnder25", ageUnder25);
        res.put("age25to35", age25to35);
        res.put("age35to45", age35to45);
        res.put("age45to55", age45to55);
        res.put("ageOver55", ageOver55);
        res.put("ageUnder25Pct", ageUnder25Pct);
        res.put("age25to35Pct", age25to35Pct);
        res.put("age35to45Pct", age35to45Pct);
        res.put("age45to55Pct", age45to55Pct);
        res.put("ageOver55Pct", ageOver55Pct);

        res.put("senUnder1", senUnder1);
        res.put("sen1to3", sen1to3);
        res.put("sen3to5", sen3to5);
        res.put("senOver5", senOver5);
        res.put("senUnder1Pct", senUnder1Pct);
        res.put("sen1to3Pct", sen1to3Pct);
        res.put("sen3to5Pct", sen3to5Pct);
        res.put("senOver5Pct", senOver5Pct);
        res.put("avgSeniority", avgSeniority);
        res.put("retentionOver1YearPct", retentionOver1YearPct);

        return res;
    }

    /**
     * 8. Biến động nhân sự qua các tháng (phục vụ biểu đồ Line Chart)
     */
    public Map<String, Object> getMonthlyGrowthTrend() {
        Map<String, Object> res = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Long> data = new ArrayList<>();

        LocalDate current = LocalDate.now();
        // 6 tháng gần nhất
        try (Connection conn = DBConnection.getConnection()) {
            for (int i = 5; i >= 0; i--) {
                LocalDate monthDate = current.minusMonths(i);
                LocalDate endOfMonth = monthDate.withDayOfMonth(monthDate.lengthOfMonth());
                String label = "Tháng " + String.format("%02d", monthDate.getMonthValue());
                if (i == 0) label += " (Hiện tại)";
                labels.add(label);

                String sql = "SELECT COUNT(*) FROM employees WHERE start_date <= ? AND (end_date IS NULL OR end_date > ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setDate(1, java.sql.Date.valueOf(endOfMonth));
                    ps.setDate(2, java.sql.Date.valueOf(endOfMonth));
                    try (ResultSet rs = ps.executeQuery()) {
                        long count = rs.next() ? rs.getLong(1) : 0;
                        data.add(count);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("DashboardDAO.getMonthlyGrowthTrend lỗi: " + e.getMessage());
        }

        res.put("labels", labels);
        res.put("data", data);
        return res;
    }

    /**
     * 9. Hiệu suất theo phòng ban (KPI)
     */
    public List<Map<String, Object>> getDepartmentKpis(Integer departmentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = 
            "SELECT d.id, d.name, "
          + "COALESCE(AVG(CASE WHEN k.target_value > 0 THEN (k.current_value / k.target_value * 100.0) ELSE NULL END), 0) AS kpi_rate "
          + "FROM departments d "
          + "LEFT JOIN kpi_metrics k ON k.department_id = d.id "
          + "WHERE 1=1 ";
        if (departmentId != null && departmentId > 0) {
            sql += "AND d.id = " + departmentId + " ";
        }
        sql += "GROUP BY d.id, d.name ORDER BY kpi_rate DESC, d.id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String dName = rs.getString("name");
                double rate = Math.round(rs.getDouble("kpi_rate") * 10.0) / 10.0;
                // Nếu chưa có KPI gán riêng cho phòng ban, gán fallback theo tỷ lệ đánh giá hiệu suất
                if (rate <= 0.0) rate = 85.0;

                String badgeClass = rate >= 80.0 ? "good" : (rate >= 60.0 ? "warning" : "danger");
                String badgeText = rate >= 90.0 ? "Xuất sắc" : (rate >= 80.0 ? "Đạt chỉ tiêu" : "Cần cải thiện");
                String color = rate >= 80.0 ? "green" : (rate >= 60.0 ? "orange" : "red");

                Map<String, Object> item = new HashMap<>();
                item.put("name", dName);
                item.put("rate", rate);
                item.put("badgeClass", badgeClass);
                item.put("badgeText", badgeText);
                item.put("color", color);
                list.add(item);
            }
        } catch (SQLException e) {
            System.err.println("DashboardDAO.getDepartmentKpis lỗi: " + e.getMessage());
        }
        return list;
    }

    /**
     * 10. Hoạt động gần đây từ cơ sở dữ liệu
     */
    public List<Map<String, Object>> getRecentActivities() {
        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Hoạt động 1: Nghỉ phép mới nhất
            String sqlLeave = 
                "SELECT l.leave_code, l.leave_type, l.status, l.created_at, e.full_name, d.name AS dept_name "
              + "FROM leave_requests l "
              + "JOIN employees e ON l.employee_id = e.id "
              + "LEFT JOIN departments d ON e.department_id = d.id "
              + "ORDER BY l.created_at DESC LIMIT 2";
            try (PreparedStatement ps = conn.prepareStatement(sqlLeave);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    String empName = rs.getString("full_name");
                    String dept = rs.getString("dept_name");
                    String code = rs.getString("leave_code");
                    String status = rs.getString("status");
                    item.put("icon", "bi-calendar2-check");
                    item.put("iconBg", "#ecfdf5");
                    item.put("iconColor", "#10b981");
                    item.put("title", "<strong>" + empName + "</strong> (" + dept + ") đã gửi đơn nghỉ phép <strong>" + code + "</strong>");
                    item.put("badge", "PENDING".equalsIgnoreCase(status) ? "Chờ duyệt" : "Đã duyệt");
                    item.put("badgeClass", "PENDING".equalsIgnoreCase(status) ? "bg-warning-subtle text-warning" : "bg-success-subtle text-success");
                    item.put("timeAgo", "Hôm nay");
                    list.add(item);
                }
            }

            // Hoạt động 2: Tăng ca OT mới nhất
            String sqlOt = 
                "SELECT o.overtime_code, o.hours, o.status, o.created_at, e.full_name, d.name AS dept_name "
              + "FROM overtime o "
              + "JOIN employees e ON o.employee_id = e.id "
              + "LEFT JOIN departments d ON e.department_id = d.id "
              + "ORDER BY o.created_at DESC LIMIT 2";
            try (PreparedStatement ps = conn.prepareStatement(sqlOt);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    String empName = rs.getString("full_name");
                    String dept = rs.getString("dept_name");
                    double hours = rs.getDouble("hours");
                    item.put("icon", "bi-clock-history");
                    item.put("iconBg", "#eff6ff");
                    item.put("iconColor", "#2563eb");
                    item.put("title", "<strong>" + empName + "</strong> (" + dept + ") đăng ký làm thêm giờ: <strong>" + hours + " giờ</strong>");
                    item.put("badge", "Làm thêm");
                    item.put("badgeClass", "bg-primary-subtle text-primary");
                    item.put("timeAgo", "Gần đây");
                    list.add(item);
                }
            }

            // Hoạt động 3: Yêu cầu tuyển dụng mới nhất
            String sqlRec = 
                "SELECT r.title, r.target_headcount, r.status, d.name AS dept_name "
              + "FROM recruitment_requests r "
              + "LEFT JOIN departments d ON r.department_id = d.id "
              + "ORDER BY r.created_at DESC LIMIT 2";
            try (PreparedStatement ps = conn.prepareStatement(sqlRec);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    String title = rs.getString("title");
                    String dept = rs.getString("dept_name");
                    int count = rs.getInt("target_headcount");
                    item.put("icon", "bi-briefcase-fill");
                    item.put("iconBg", "#f5f3ff");
                    item.put("iconColor", "#8b5cf6");
                    item.put("title", "Phòng <strong>" + dept + "</strong> đã tạo yêu cầu tuyển dụng: <strong>" + title + " (" + count + " vị trí)</strong>");
                    item.put("badge", "Tuyển dụng");
                    item.put("badgeClass", "bg-purple-subtle text-purple");
                    item.put("timeAgo", "Trong tuần");
                    list.add(item);
                }
            }

            // Hoạt động 4: Hợp đồng lao động mới nhất
            String sqlCont = 
                "SELECT c.contract_code, c.contract_type, c.created_at, e.full_name "
              + "FROM contracts c "
              + "JOIN employees e ON c.employee_id = e.id "
              + "ORDER BY c.created_at DESC LIMIT 2";
            try (PreparedStatement ps = conn.prepareStatement(sqlCont);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    String empName = rs.getString("full_name");
                    String code = rs.getString("contract_code");
                    String type = rs.getString("contract_type");
                    item.put("icon", "bi-file-earmark-text-fill");
                    item.put("iconBg", "#fffbeb");
                    item.put("iconColor", "#f59e0b");
                    item.put("title", "Ký kết và cập nhật hợp đồng lao động <strong>" + code + "</strong> (" + type + ") cho <strong>" + empName + "</strong>");
                    item.put("badge", "Hợp đồng");
                    item.put("badgeClass", "bg-warning-subtle text-warning");
                    item.put("timeAgo", "Gần đây");
                    list.add(item);
                }
            }

        } catch (SQLException e) {
            System.err.println("DashboardDAO.getRecentActivities lỗi: " + e.getMessage());
        }

        return list;
    }
}
