package com.miximoi.hrm.dao;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử DashboardDAO với dữ liệu thực từ PostgreSQL")
public class DashboardDAOTest {

    private static DashboardDAO dashboardDAO;

    @BeforeAll
    static void setUp() {
        dashboardDAO = new DashboardDAO();
    }

    @Test
    @DisplayName("Kiểm tra 8 thẻ KPI với khoảng ngày mặc định")
    void testGetKpiStatsDefault() {
        LocalDate startDate = LocalDate.of(2026, 9, 1);
        LocalDate endDate = LocalDate.of(2026, 9, 24);

        Map<String, Object> kpis = dashboardDAO.getKpiStats(startDate, endDate, null, null);
        assertNotNull(kpis);
        assertTrue(kpis.containsKey("totalEmployees"));
        assertTrue((Long) kpis.get("totalEmployees") > 0);
        assertTrue(kpis.containsKey("totalPayroll"));
        assertTrue(kpis.containsKey("departmentCount"));
        assertTrue(kpis.containsKey("pendingLeaves"));
    }

    @Test
    @DisplayName("Kiểm tra 8 thẻ KPI lọc theo phòng ban và trạng thái")
    void testGetKpiStatsWithFilters() {
        LocalDate startDate = LocalDate.of(2026, 7, 1);
        LocalDate endDate = LocalDate.of(2026, 9, 24);

        Map<String, Object> kpis = dashboardDAO.getKpiStats(startDate, endDate, 1, "ACTIVE");
        assertNotNull(kpis);
        assertNotNull(kpis.get("totalEmployees"));
    }

    @Test
    @DisplayName("Kiểm tra tình hình chấm công theo ngày thực tế")
    void testGetAttendanceSummary() {
        LocalDate startDate = LocalDate.of(2026, 9, 1);
        LocalDate endDate = LocalDate.of(2026, 9, 24);

        Map<String, Object> att = dashboardDAO.getAttendanceSummary(startDate, endDate, null);
        assertNotNull(att);
        assertTrue(att.containsKey("onTimeCount"));
        assertTrue(att.containsKey("lateCount"));
        assertTrue(att.containsKey("absentCount"));
        assertTrue(att.containsKey("totalRecords"));
        assertTrue(att.containsKey("onTimePct"));
    }

    @Test
    @DisplayName("Kiểm tra phân tích nghỉ phép")
    void testGetLeaveSummary() {
        LocalDate startDate = LocalDate.of(2026, 9, 1);
        LocalDate endDate = LocalDate.of(2026, 9, 24);

        Map<String, Object> leave = dashboardDAO.getLeaveSummary(startDate, endDate, null);
        assertNotNull(leave);
        assertTrue(leave.containsKey("pendingCount"));
        assertTrue(leave.containsKey("totalDaysUsed"));
        assertTrue(leave.containsKey("totalFund"));
        assertTrue(leave.containsKey("remainingDays"));
    }

    @Test
    @DisplayName("Kiểm tra danh sách việc cần xử lý gấp")
    void testGetUrgentTasks() {
        LocalDate startDate = LocalDate.of(2026, 9, 1);
        LocalDate endDate = LocalDate.of(2026, 9, 24);

        Map<String, Object> tasks = dashboardDAO.getUrgentTasks(startDate, endDate, null);
        assertNotNull(tasks);
        assertTrue(tasks.containsKey("expiringContracts"));
        assertTrue(tasks.containsKey("pendingLeaves"));
        assertTrue(tasks.containsKey("incompleteProfiles"));
        assertTrue(tasks.containsKey("openRecruitment"));
        assertTrue(tasks.containsKey("pendingOvertime"));
    }

    @Test
    @DisplayName("Kiểm tra quỹ lương theo phòng ban")
    void testGetPayrollSummary() {
        LocalDate startDate = LocalDate.of(2026, 7, 1);
        LocalDate endDate = LocalDate.of(2026, 9, 30);

        Map<String, Object> payroll = dashboardDAO.getPayrollSummary(startDate, endDate, null);
        assertNotNull(payroll);
        assertTrue(payroll.containsKey("totalNet"));
        assertNotNull(payroll.get("deptPayrollList"));
    }

    @Test
    @DisplayName("Kiểm tra tình hình và phễu tuyển dụng")
    void testGetRecruitmentStats() {
        LocalDate startDate = LocalDate.of(2026, 9, 1);
        LocalDate endDate = LocalDate.of(2026, 9, 24);

        Map<String, Object> recruit = dashboardDAO.getRecruitmentStats(startDate, endDate, null);
        assertNotNull(recruit);
        assertTrue(recruit.containsKey("openPositions"));
        assertTrue(recruit.containsKey("totalCandidates"));
        assertTrue(recruit.containsKey("interviews"));
        assertTrue(recruit.containsKey("onboarded"));
        assertTrue(recruit.containsKey("screeningPct"));
    }

    @Test
    @DisplayName("Kiểm tra cơ cấu nhân sự (phòng ban, giới tính, độ tuổi, thâm niên)")
    void testGetPersonnelStructure() {
        Map<String, Object> structure = dashboardDAO.getPersonnelStructure(null);
        assertNotNull(structure);
        assertTrue(structure.containsKey("deptList"));
        assertTrue(structure.containsKey("maleCount"));
        assertTrue(structure.containsKey("femaleCount"));
        assertTrue(structure.containsKey("age25to35"));
    }

    @Test
    @DisplayName("Kiểm tra biểu đồ biến động nhân sự 6 tháng")
    void testGetMonthlyGrowthTrend() {
        Map<String, Object> trend = dashboardDAO.getMonthlyGrowthTrend();
        assertNotNull(trend);
        List<?> labels = (List<?>) trend.get("labels");
        List<?> data = (List<?>) trend.get("data");
        assertNotNull(labels);
        assertNotNull(data);
        assertEquals(labels.size(), data.size());
    }

    @Test
    @DisplayName("Kiểm tra KPI phòng ban & Hoạt động gần đây")
    void testGetDepartmentKpisAndActivities() {
        List<Map<String, Object>> deptKpis = dashboardDAO.getDepartmentKpis(null);
        assertNotNull(deptKpis);

        List<Map<String, Object>> activities = dashboardDAO.getRecentActivities();
        assertNotNull(activities);
    }
}
