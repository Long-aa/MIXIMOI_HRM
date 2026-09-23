package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.KpiMetric;
import com.miximoi.hrm.model.PerformanceEvaluation;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO xử lý các truy vấn cho KPI và Đánh giá hiệu suất.
 */
public class PerformanceDAO {

    /** Lấy danh sách KPI có lọc */
    public List<KpiMetric> findKpis(String quarter, Integer deptId, String status, String rating, String search) {
        List<KpiMetric> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT k.*, e.full_name AS emp_name, e.employee_code AS emp_code, " +
            "p.name AS pos_name, d.name AS dept_name " +
            "FROM kpi_metrics k " +
            "JOIN employees e ON k.employee_id = e.id " +
            "LEFT JOIN positions p ON e.position_id = p.id " +
            "LEFT JOIN departments d ON k.department_id = d.id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (quarter != null && !quarter.trim().isEmpty()) {
            sql.append(" AND k.quarter = ?");
            params.add(quarter.trim());
        }
        if (deptId != null && deptId > 0) {
            sql.append(" AND k.department_id = ?");
            params.add(deptId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND k.status = ?");
            params.add(status.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (k.title ILIKE ? OR k.kpi_code ILIKE ? OR e.full_name ILIKE ?)");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        sql.append(" ORDER BY k.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    KpiMetric m = new KpiMetric();
                    m.setId(rs.getInt("id"));
                    m.setKpiCode(rs.getString("kpi_code"));
                    m.setTitle(rs.getString("title"));
                    m.setEmployeeId(rs.getInt("employee_id"));
                    m.setEmployeeName(rs.getString("emp_name"));
                    m.setEmployeeCode(rs.getString("emp_code"));
                    m.setPositionName(rs.getString("pos_name"));
                    m.setDepartmentId(rs.getInt("department_id"));
                    m.setDepartmentName(rs.getString("dept_name"));
                    m.setQuarter(rs.getString("quarter"));
                    m.setTargetValue(rs.getBigDecimal("target_value"));
                    m.setCurrentValue(rs.getBigDecimal("current_value"));
                    m.setUnit(rs.getString("unit"));
                    m.setWeightPct(rs.getBigDecimal("weight_pct"));
                    Date dl = rs.getDate("deadline");
                    if (dl != null) m.setDeadline(dl.toLocalDate());
                    m.setStatus(rs.getString("status"));
                    m.setNotes(rs.getString("notes"));

                    // Rating filter post-calc if provided
                    if (rating != null && !rating.trim().isEmpty()) {
                        double pct = m.getProgressPct();
                        if ("EXCEED".equalsIgnoreCase(rating) && pct <= 100.0) continue;
                        if ("ACHIEVED".equalsIgnoreCase(rating) && (pct < 90.0 || pct > 100.0)) continue;
                        if ("IMPROVE".equalsIgnoreCase(rating) && (pct < 70.0 || pct >= 90.0)) continue;
                        if ("FAILED".equalsIgnoreCase(rating) && pct >= 70.0) continue;
                    }
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            System.err.println("PerformanceDAO.findKpis lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Tạo KPI mới */
    public boolean insertKpi(KpiMetric m) {
        String sql = "INSERT INTO kpi_metrics (kpi_code, title, employee_id, department_id, quarter, target_value, current_value, unit, weight_pct, deadline, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getKpiCode());
            ps.setString(2, m.getTitle());
            ps.setInt(3, m.getEmployeeId());
            if (m.getDepartmentId() != null) ps.setInt(4, m.getDepartmentId());
            else ps.setNull(4, Types.INTEGER);
            ps.setString(5, m.getQuarter());
            ps.setBigDecimal(6, m.getTargetValue() != null ? m.getTargetValue() : new BigDecimal("100.0"));
            ps.setBigDecimal(7, m.getCurrentValue() != null ? m.getCurrentValue() : BigDecimal.ZERO);
            ps.setString(8, m.getUnit() != null ? m.getUnit() : "%");
            ps.setBigDecimal(9, m.getWeightPct() != null ? m.getWeightPct() : new BigDecimal("20.0"));
            if (m.getDeadline() != null) ps.setDate(10, Date.valueOf(m.getDeadline()));
            else ps.setNull(10, Types.DATE);
            ps.setString(11, m.getStatus() != null ? m.getStatus() : "IN_PROGRESS");
            ps.setString(12, m.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PerformanceDAO.insertKpi lỗi: " + e.getMessage());
            return false;
        }
    }

    /** Phê duyệt KPI */
    public boolean approveKpi(String kpiCode) {
        String sql = "UPDATE kpi_metrics SET status = 'APPROVED', updated_at = CURRENT_TIMESTAMP WHERE kpi_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kpiCode);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PerformanceDAO.approveKpi lỗi: " + e.getMessage());
            return false;
        }
    }

    /** Sinh mã KPI tiếp theo */
    public String generateNextKpiCode(String deptCode) {
        String prefix = (deptCode != null && !deptCode.trim().isEmpty()) ? deptCode.toUpperCase() : "GEN";
        String sql = "SELECT COUNT(*) FROM kpi_metrics";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int count = rs.getInt(1) + 1;
                return String.format("KPI-%s-%03d", prefix, count);
            }
        } catch (SQLException ignored) {}
        return "KPI-IT-050";
    }

    /** Lấy danh sách đánh giá hiệu suất có lọc */
    public List<PerformanceEvaluation> findEvaluations(String quarter, Integer deptId, String status, String search) {
        List<PerformanceEvaluation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT ev.*, e.full_name AS emp_name, e.employee_code AS emp_code, " +
            "p.name AS pos_name, d.id AS dept_id, d.name AS dept_name, evr.full_name AS evaluator_name " +
            "FROM performance_evaluations ev " +
            "JOIN employees e ON ev.employee_id = e.id " +
            "LEFT JOIN positions p ON e.position_id = p.id " +
            "LEFT JOIN departments d ON e.department_id = d.id " +
            "LEFT JOIN employees evr ON ev.evaluator_id = evr.id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (quarter != null && !quarter.trim().isEmpty()) {
            sql.append(" AND ev.quarter = ?");
            params.add(quarter.trim());
        }
        if (deptId != null && deptId > 0) {
            sql.append(" AND e.department_id = ?");
            params.add(deptId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND ev.status = ?");
            params.add(status.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (ev.evaluation_code ILIKE ? OR e.full_name ILIKE ? OR e.employee_code ILIKE ?)");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        sql.append(" ORDER BY ev.final_score DESC, ev.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PerformanceEvaluation ev = new PerformanceEvaluation();
                    ev.setId(rs.getInt("id"));
                    ev.setEvaluationCode(rs.getString("evaluation_code"));
                    ev.setEmployeeId(rs.getInt("employee_id"));
                    ev.setEmployeeName(rs.getString("emp_name"));
                    ev.setEmployeeCode(rs.getString("emp_code"));
                    ev.setPositionName(rs.getString("pos_name"));
                    ev.setDepartmentId(rs.getInt("dept_id"));
                    ev.setDepartmentName(rs.getString("dept_name"));
                    ev.setEvaluatorId(rs.getInt("evaluator_id"));
                    ev.setEvaluatorName(rs.getString("evaluator_name"));
                    ev.setQuarter(rs.getString("quarter"));
                    ev.setKpiScore(rs.getBigDecimal("kpi_score"));
                    ev.setCompetencyScore(rs.getBigDecimal("competency_score"));
                    ev.setCultureScore(rs.getBigDecimal("culture_score"));
                    ev.setInnovationScore(rs.getBigDecimal("innovation_score"));
                    ev.setFinalScore(rs.getBigDecimal("final_score"));
                    ev.setGrade(rs.getString("grade"));
                    ev.setStatus(rs.getString("status"));
                    ev.setFeedback(rs.getString("feedback"));
                    list.add(ev);
                }
            }
        } catch (SQLException e) {
            System.err.println("PerformanceDAO.findEvaluations lỗi: " + e.getMessage());
        }
        return list;
    }

    /** Cập nhật hoặc lưu thẩm định */
    public boolean saveEvaluation(PerformanceEvaluation ev) {
        ev.calculateFinalScoreAndGrade();
        String sql = "INSERT INTO performance_evaluations (evaluation_code, employee_id, evaluator_id, quarter, kpi_score, competency_score, culture_score, innovation_score, final_score, grade, status, feedback) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON CONFLICT (evaluation_code) DO UPDATE SET " +
                     "kpi_score = EXCLUDED.kpi_score, competency_score = EXCLUDED.competency_score, " +
                     "culture_score = EXCLUDED.culture_score, innovation_score = EXCLUDED.innovation_score, " +
                     "final_score = EXCLUDED.final_score, grade = EXCLUDED.grade, status = EXCLUDED.status, " +
                     "feedback = EXCLUDED.feedback, updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ev.getEvaluationCode());
            ps.setInt(2, ev.getEmployeeId());
            if (ev.getEvaluatorId() != null) ps.setInt(3, ev.getEvaluatorId());
            else ps.setNull(3, Types.INTEGER);
            ps.setString(4, ev.getQuarter());
            ps.setBigDecimal(5, ev.getKpiScore());
            ps.setBigDecimal(6, ev.getCompetencyScore());
            ps.setBigDecimal(7, ev.getCultureScore());
            ps.setBigDecimal(8, ev.getInnovationScore());
            ps.setBigDecimal(9, ev.getFinalScore());
            ps.setString(10, ev.getGrade());
            ps.setString(11, ev.getStatus());
            ps.setString(12, ev.getFeedback());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PerformanceDAO.saveEvaluation lỗi: " + e.getMessage());
            return false;
        }
    }

    /**
     * THUẬT TOÁN ĐÁNH GIÁ HIỆU SUẤT & KPI THEO NGÀY - THÁNG - NĂM:
     * Phân tích dữ liệu thực tế từ PostgreSQL (attendance, kpi_metrics):
     * 1. Tỷ lệ chuyên cần & kỷ luật chấm công (Culture & Discipline):
     *    - Điểm chuẩn: 10.0
     *    - Mỗi lần đi muộn (LATE): trừ 0.5 điểm
     *    - Mỗi lần vắng (ABSENT): trừ 1.5 điểm
     * 2. Điểm KPI bình quân (KPI Score):
     *    - Lấy từ kpi_metrics theo employee và chu kỳ: tổng (tiến_độ_kpi * trọng_số_kpi) / 100 quy đổi thang điểm 10.
     * 3. Điểm năng lực chuyên môn (Competency Score) & Sáng tạo (Innovation)
     */
    public Map<String, Object> analyzePerformanceStats(int employeeId, String cycleQuarter, Integer month, Integer year, java.time.LocalDate specificDate) {
        Map<String, Object> result = new HashMap<>();

        // 1. Phân tích chấm công chuyên cần thực tế từ CSDL
        StringBuilder attSql = new StringBuilder("SELECT COUNT(*) AS total_work_days, " +
                "COUNT(CASE WHEN status = 'ON_TIME' THEN 1 END) AS on_time_count, " +
                "COUNT(CASE WHEN status = 'LATE' THEN 1 END) AS late_count, " +
                "COUNT(CASE WHEN status = 'ABSENT' THEN 1 END) AS absent_count, " +
                "COALESCE(SUM(total_hours), 0) AS total_hours " +
                "FROM attendance WHERE employee_id = ?");

        List<Object> attParams = new ArrayList<>();
        attParams.add(employeeId);

        if (specificDate != null) {
            attSql.append(" AND work_date = ?");
            attParams.add(Date.valueOf(specificDate));
        } else if (month != null && year != null) {
            attSql.append(" AND EXTRACT(MONTH FROM work_date) = ? AND EXTRACT(YEAR FROM work_date) = ?");
            attParams.add(month);
            attParams.add(year);
        } else if (year != null) {
            attSql.append(" AND EXTRACT(YEAR FROM work_date) = ?");
            attParams.add(year);
        }

        int totalDays = 0, onTime = 0, late = 0, absent = 0;
        double totalHours = 0.0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(attSql.toString())) {
            for (int i = 0; i < attParams.size(); i++) {
                ps.setObject(i + 1, attParams.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalDays = rs.getInt("total_work_days");
                    onTime = rs.getInt("on_time_count");
                    late = rs.getInt("late_count");
                    absent = rs.getInt("absent_count");
                    totalHours = rs.getDouble("total_hours");
                }
            }
        } catch (SQLException e) {
            System.err.println("analyzePerformanceStats (attendance) lỗi: " + e.getMessage());
        }

        // Thuật toán tính Culture / Chuyên cần (thang 10)
        double cultureScore = 10.0;
        if (totalDays > 0) {
            cultureScore = cultureScore - (late * 0.5) - (absent * 1.5);
            if (cultureScore < 5.0) cultureScore = 5.0;
            if (cultureScore > 10.0) cultureScore = 10.0;
        } else {
            cultureScore = 9.0;
        }

        // 2. Phân tích KPI Metrics thực tế từ CSDL
        StringBuilder kpiSql = new StringBuilder("SELECT * FROM kpi_metrics WHERE employee_id = ?");
        List<Object> kpiParams = new ArrayList<>();
        kpiParams.add(employeeId);
        if (cycleQuarter != null && !cycleQuarter.isEmpty()) {
            kpiSql.append(" AND quarter = ?");
            kpiParams.add(cycleQuarter);
        }

        double weightedKpiProgress = 0.0;
        double totalWeight = 0.0;
        int kpiCount = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(kpiSql.toString())) {
            for (int i = 0; i < kpiParams.size(); i++) {
                ps.setObject(i + 1, kpiParams.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    kpiCount++;
                    BigDecimal target = rs.getBigDecimal("target_value");
                    BigDecimal current = rs.getBigDecimal("current_value");
                    BigDecimal weight = rs.getBigDecimal("weight_pct");
                    double w = (weight != null) ? weight.doubleValue() : 20.0;
                    double t = (target != null && target.doubleValue() > 0) ? target.doubleValue() : 100.0;
                    double c = (current != null) ? current.doubleValue() : 0.0;
                    double progress = (c / t) * 100.0;
                    weightedKpiProgress += (progress * w);
                    totalWeight += w;
                }
            }
        } catch (SQLException e) {
            System.err.println("analyzePerformanceStats (kpi) lỗi: " + e.getMessage());
        }

        double kpiScore = 9.0;
        if (totalWeight > 0) {
            double overallProgress = weightedKpiProgress / totalWeight;
            kpiScore = (overallProgress / 10.0);
            if (kpiScore > 10.0) kpiScore = 10.0;
            if (kpiScore < 0.0) kpiScore = 0.0;
        }

        double competencyScore = Math.min(10.0, Math.round((kpiScore * 0.95 + 0.4) * 10.0) / 10.0);
        double innovationScore = Math.min(10.0, Math.round((kpiScore * 0.90 + 0.8) * 10.0) / 10.0);

        result.put("totalDays", totalDays);
        result.put("onTimeCount", onTime);
        result.put("lateCount", late);
        result.put("absentCount", absent);
        result.put("totalHours", totalHours);
        result.put("kpiCount", kpiCount);
        result.put("kpiScore", Math.round(kpiScore * 100.0) / 100.0);
        result.put("cultureScore", Math.round(cultureScore * 100.0) / 100.0);
        result.put("competencyScore", competencyScore);
        result.put("innovationScore", innovationScore);

        return result;
    }

    /** Tự động tính toán và lưu/cập nhật bảng đánh giá hiệu suất của toàn bộ nhân viên theo thuật toán */
    public int autoCalculateAndSyncEvaluations(String quarter, Integer evaluatorId) {
        int count = 0;
        String empSql = "SELECT id, employee_code, full_name FROM employees WHERE status != 'INACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(empSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int empId = rs.getInt("id");
                Map<String, Object> stats = analyzePerformanceStats(empId, quarter, null, null, null);

                PerformanceEvaluation ev = new PerformanceEvaluation();
                ev.setEvaluationCode(String.format("EVAL-%s-%03d", quarter.replace("/", "-"), empId));
                ev.setEmployeeId(empId);
                ev.setEvaluatorId(evaluatorId != null ? evaluatorId : 1);
                ev.setQuarter(quarter);
                ev.setKpiScore(BigDecimal.valueOf(((Number) stats.get("kpiScore")).doubleValue()));
                ev.setCultureScore(BigDecimal.valueOf(((Number) stats.get("cultureScore")).doubleValue()));
                ev.setCompetencyScore(BigDecimal.valueOf(((Number) stats.get("competencyScore")).doubleValue()));
                ev.setInnovationScore(BigDecimal.valueOf(((Number) stats.get("innovationScore")).doubleValue()));
                ev.setStatus("CONFIRMED");
                ev.setFeedback("Hệ thống tự động tính toán từ dữ liệu chấm công (" + stats.get("onTimeCount") + " ngày đúng giờ, " + stats.get("lateCount") + " lần trễ) và tiến độ các chỉ tiêu KPI.");

                if (saveEvaluation(ev)) {
                    count++;
                }
            }
        } catch (SQLException e) {
            System.err.println("autoCalculateAndSyncEvaluations lỗi: " + e.getMessage());
        }
        return count;
    }
}
