package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.model.TimesheetSummary;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * DAO xá»­ lÃ½ cÃ¡c thao tÃ¡c DB liÃªn quan Ä‘áº¿n Attendance (Cháº¥m cÃ´ng).
 */
public class AttendanceDAO {

    private static final String BASE_SELECT =
        "SELECT a.id, a.employee_id, e.employee_code, e.full_name, "
      + "d.name AS department_name, p.name AS position_name, "
      + "a.work_date, a.check_in, a.check_out, a.total_hours, a.status, a.notes, a.method, a.created_at "
      + "FROM attendance a "
      + "JOIN employees e ON a.employee_id = e.id "
      + "LEFT JOIN departments d ON e.department_id = d.id "
      + "LEFT JOIN positions p ON e.position_id = p.id ";

    /** Láº¥y cháº¥m cÃ´ng theo nhÃ¢n viÃªn vÃ  thÃ¡ng */
    public List<Attendance> findByEmployeeAndMonth(int employeeId, int month, int year) {
        List<Attendance> list = new ArrayList<>();
        String sql = BASE_SELECT
                   + "WHERE a.employee_id = ? "
                   + "AND EXTRACT(MONTH FROM a.work_date) = ? "
                   + "AND EXTRACT(YEAR FROM a.work_date) = ? "
                   + "AND a.work_date <= CURRENT_DATE "
                   + "ORDER BY a.work_date DESC, COALESCE(a.check_out, a.check_in) DESC NULLS LAST, a.check_in DESC NULLS LAST, a.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.findByEmployeeAndMonth lá»—i: " + e.getMessage());
        }
        return list;
    }

    /** Láº¥y cháº¥m cÃ´ng cá»§a má»™t ngÃ y cá»¥ thá»ƒ */
    public Attendance findByEmployeeAndDate(int employeeId, LocalDate date) {
        String sql = BASE_SELECT + "WHERE a.employee_id = ? AND a.work_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.findByEmployeeAndDate lá»—i: " + e.getMessage());
        }
        return null;
    }

    /** TÃ¬m theo ID */
    public Attendance findById(int id) {
        String sql = BASE_SELECT + "WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.findById lá»—i: " + e.getMessage());
        }
        return null;
    }

    /** TÃ¬m kiáº¿m cháº¥m cÃ´ng theo nhiá»u tiÃªu chÃ­ */
    public List<Attendance> search(String keyword, Integer departmentId, String status, LocalDate date, Integer month, Integer year) {
        List<Attendance> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
        }
        if (departmentId != null && departmentId > 0) {
            sql.append("AND e.department_id = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND a.status = ? ");
        }
        if (date != null) {
            sql.append("AND a.work_date = ? ");
        } else {
            if (month != null && month > 0) {
                sql.append("AND EXTRACT(MONTH FROM a.work_date) = ? ");
            }
            if (year != null && year > 0) {
                sql.append("AND EXTRACT(YEAR FROM a.work_date) = ? ");
            }
            sql.append("AND a.work_date <= CURRENT_DATE ");
        }
        sql.append("ORDER BY a.work_date DESC, COALESCE(a.check_out, a.check_in) DESC NULLS LAST, a.check_in DESC NULLS LAST, a.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (departmentId != null && departmentId > 0) {
                ps.setInt(idx++, departmentId);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status.trim());
            }
            if (date != null) {
                ps.setDate(idx++, Date.valueOf(date));
            } else {
                if (month != null && month > 0) {
                    ps.setInt(idx++, month);
                }
                if (year != null && year > 0) {
                    ps.setInt(idx++, year);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.search lá»—i: " + e.getMessage());
        }
        return list;
    }

    /** Láº¥y thá»‘ng kÃª cháº¥m cÃ´ng hÃ´m nay */
    public Map<String, Integer> getTodayStats(LocalDate date) {
        Map<String, Integer> map = new HashMap<>();
        map.put("totalEmployeesToday", 0);
        map.put("checkedInCount", 0);
        map.put("lateEarlyCount", 0);
        map.put("absentCount", 0);
        map.put("wfhCount", 0);

        // Tá»•ng nhÃ¢n viÃªn active
        String totalSql = "SELECT COUNT(*) FROM employees WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(totalSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) map.put("totalEmployeesToday", rs.getInt(1));
        } catch (SQLException ignored) {}

        // Thá»‘ng kÃª theo tráº¡ng thÃ¡i trong ngÃ y
        String attSql = "SELECT status, COUNT(*) FROM attendance WHERE work_date = ? GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(attSql)) {
            ps.setDate(1, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                int checkedIn = 0;
                int lateEarly = 0;
                int absent = 0;
                int wfh = 0;
                while (rs.next()) {
                    String st = rs.getString(1);
                    int cnt = rs.getInt(2);
                    if ("ON_TIME".equalsIgnoreCase(st) || "COMPLETE".equalsIgnoreCase(st) || "WORKING".equalsIgnoreCase(st)) {
                        checkedIn += cnt;
                    } else if ("LATE".equalsIgnoreCase(st) || "EARLY_LEAVE".equalsIgnoreCase(st)) {
                        checkedIn += cnt;
                        lateEarly += cnt;
                    } else if ("ABSENT".equalsIgnoreCase(st)) {
                        absent += cnt;
                    } else if ("WFH".equalsIgnoreCase(st)) {
                        checkedIn += cnt;
                        wfh += cnt;
                    }
                }
                map.put("checkedInCount", checkedIn);
                map.put("lateEarlyCount", lateEarly);
                map.put("absentCount", absent);
                map.put("wfhCount", wfh);
            }
        } catch (SQLException ignored) {}

        return map;
    }

    /**
     * Tá»± Ä‘á»™ng náº¡p dá»¯ liá»‡u cháº¥m cÃ´ng hÃ´m nay náº¿u báº£ng attendance chÆ°a cÃ³ báº£n ghi cho ngÃ y nÃ y.
     * [F3.4 FIX] ThÃªm column method vÃ o INSERT. [F3.1 FIX] ON_LEAVE chá»‰ khi cÃ³ Ä‘Æ¡n thá»±c.
     */
    public void autoSeedTodayData(LocalDate today) {
        String checkSql = "SELECT COUNT(*) FROM attendance WHERE work_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setDate(1, Date.valueOf(today));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return; // ÄÃ£ cÃ³ dá»¯ liá»‡u
            }
        } catch (SQLException e) { return; }

        List<Integer> empIds = new ArrayList<>();
        String empSql = "SELECT id FROM employees WHERE status = 'ACTIVE' ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(empSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) empIds.add(rs.getInt("id"));
        } catch (SQLException e) { return; }
        if (empIds.isEmpty()) return;

        // [F3.4] ThÃªm column method vÃ o INSERT Ä‘á»ƒ nháº¥t quÃ¡n vá»›i autoSeedMonthAttendance
        String insertSql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes, method) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT (employee_id, work_date) DO NOTHING";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (int i = 0; i < empIds.size(); i++) {
                int empId = empIds.get(i);
                String status; LocalTime ci = null, co = null; double hrs; String notes; String method;
                int mod = i % 10;
                if (mod < 5) {
                    method = (i % 2 == 0) ? "FaceID" : "Fingerprint";
                    status = "ON_TIME"; int off = (int)(Math.random()*10)-2;
                    ci = LocalTime.of(8, Math.max(10, 25+off));
                    co = LocalTime.of(17, 30+(int)(Math.random()*20));
                    hrs = Math.round(Duration.between(ci, co).toMinutes()/60.0*10)/10.0;
                    notes = "Check-in báº±ng " + method;
                } else if (mod < 7) {
                    method = "FaceID";
                    status = "LATE"; int late = 10+(int)(Math.random()*30);
                    ci = LocalTime.of(8, 35).plusMinutes(late);
                    co = LocalTime.of(17, 35+(int)(Math.random()*15));
                    hrs = Math.round(Duration.between(ci, co).toMinutes()/60.0*10)/10.0;
                    notes = "Check-in báº±ng FaceID â€” Äi muá»™n "+late+" phÃºt";
                } else if (mod < 9) {
                    method = "GPS";
                    status = "WFH";
                    ci = LocalTime.of(8, 0+(int)(Math.random()*15));
                    co = LocalTime.of(17, 0+(int)(Math.random()*30));
                    hrs = 8.0; notes = "WFH â€” GPS Mobile xÃ¡c thá»±c vá»‹ trÃ­";
                } else {
                    // [F3.1 FIX] Chá»‰ Ä‘Ã¡nh ON_LEAVE náº¿u nhÃ¢n viÃªn thá»±c sá»± cÃ³ Ä‘Æ¡n duyá»‡t
                    boolean onLeave = isEmployeeOnLeave(empId, today);
                    method = onLeave ? "SYSTEM_LEAVE" : "SYSTEM";
                    status = onLeave ? "ON_LEAVE" : "ABSENT";
                    notes  = onLeave ? "Nghá»‰ phÃ©p Ä‘Ã£ duyá»‡t" : "Váº¯ng máº·t chÆ°a rÃµ lÃ½ do";
                    hrs    = onLeave ? 8.0 : 0.0;
                }
                ps.setInt(1, empId); ps.setDate(2, Date.valueOf(today));
                ps.setTime(3, ci!=null?Time.valueOf(ci):null);
                ps.setTime(4, co!=null?Time.valueOf(co):null);
                ps.setDouble(5, hrs); ps.setString(6, status); ps.setString(7, notes); ps.setString(8, method);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[AttendanceDAO] Auto-seeded " + empIds.size() + " báº£n ghi cháº¥m cÃ´ng ngÃ y " + today);
        } catch (SQLException e) {
            System.err.println("autoSeedTodayData lá»—i: " + e.getMessage());
        }
    }

    /**
     * Tá»± Ä‘á»™ng náº¡p dá»¯ liá»‡u cháº¥m cÃ´ng cho cáº£ thÃ¡ng (tá»« ngÃ y 01 Ä‘áº¿n ngÃ y hiá»‡n táº¡i hoáº·c háº¿t thÃ¡ng)
     * náº¿u thÃ¡ng Ä‘Ã³ chÆ°a cÃ³ Ä‘á»§ dá»¯ liá»‡u thá»±c táº¿. Äáº£m báº£o dá»¯ liá»‡u realtime vÃ  Ä‘a dáº¡ng.
     */
    public void autoSeedMonthAttendance(int month, int year) {
        List<Integer> empIds = new ArrayList<>();
        String empSql = "SELECT id FROM employees WHERE status = 'ACTIVE' ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(empSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) empIds.add(rs.getInt("id"));
        } catch (SQLException e) { return; }
        if (empIds.isEmpty()) return;

        String checkCountSql = "SELECT COUNT(*) FROM attendance WHERE EXTRACT(MONTH FROM work_date) = ? AND EXTRACT(YEAR FROM work_date) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkCountSql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                int minExpected = Math.max(15, empIds.size() * 12);
                if (rs.next() && rs.getInt(1) >= minExpected) {
                    return; // ÄÃ£ cÃ³ Ä‘á»§ dá»¯ liá»‡u cháº¥m cÃ´ng cho sá»‘ lÆ°á»£ng nhÃ¢n viÃªn
                }
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.autoSeedMonthAttendance count error: " + e.getMessage());
        }

        LocalDate today = LocalDate.now();
        int maxDaysInMonth = java.time.YearMonth.of(year, month).lengthOfMonth();
        int lastDayToSeed = maxDaysInMonth;
        if (year == today.getYear() && month == today.getMonthValue()) {
            lastDayToSeed = today.getDayOfMonth() - 1; // Chá»‰ seed Ä‘áº¿n ngÃ y hÃ´m qua, Ä‘á»ƒ hÃ´m nay ngÆ°á»i dÃ¹ng tá»± cháº¥m cÃ´ng thá»±c táº¿
        } else if (year > today.getYear() || (year == today.getYear() && month > today.getMonthValue())) {
            return; // ThÃ¡ng tÆ°Æ¡ng lai chÆ°a tá»›i
        }
        if (lastDayToSeed < 1) {
            return;
        }

        String insertSql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes, method) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT (employee_id, work_date) DO NOTHING";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {
            for (int d = 1; d <= lastDayToSeed; d++) {
                LocalDate date = LocalDate.of(year, month, d);
                java.time.DayOfWeek dow = date.getDayOfWeek();
                if (dow == java.time.DayOfWeek.SATURDAY || dow == java.time.DayOfWeek.SUNDAY) {
                    continue; // Nghá»‰ tuáº§n
                }

                for (int i = 0; i < empIds.size(); i++) {
                    int empId = empIds.get(i);
                    int hash = (empId * 37 + d * 13) % 100;
                    String status;
                    LocalTime ci;
                    LocalTime co;
                    double hrs;
                    String notes;
                    String method = (empId % 2 == 0) ? "FaceID" : "Fingerprint";

                    if (hash < 75) {
                        status = "ON_TIME";
                        int minuteOff = (empId + d) % 15;
                        ci = LocalTime.of(8, 15 + minuteOff);
                        co = LocalTime.of(17, 30 + ((empId * 2 + d) % 25));
                        hrs = 8.0;
                        notes = "XÃ¡c thá»±c báº±ng " + method;
                    } else if (hash < 87) {
                        status = "LATE";
                        int lateMins = 10 + ((empId + d) % 25);
                        ci = LocalTime.of(8, 35).plusMinutes(lateMins);
                        co = LocalTime.of(17, 35 + ((empId + d) % 15));
                        hrs = 8.0;
                        notes = "Check-in " + method + " â€” Äi muá»™n " + lateMins + " phÃºt";
                    } else if (hash < 94) {
                        status = "WFH";
                        method = "GPS";
                        ci = LocalTime.of(8, (empId + d) % 15);
                        co = LocalTime.of(17, 5 + ((empId + d) % 25));
                        hrs = 8.0;
                        notes = "WFH â€” GPS Mobile xÃ¡c thá»±c vá»‹ trÃ­";
                    } else if (hash < 98) {
                        status = "ON_LEAVE";
                        method = "SYSTEM_LEAVE";
                        ci = LocalTime.of(8, 0);
                        co = LocalTime.of(17, 30);
                        hrs = 8.0;
                        notes = "Nghá»‰ phÃ©p nÄƒm Ä‘Ã£ duyá»‡t";
                    } else {
                        status = "ABSENT";
                        method = "SYSTEM";
                        ci = null;
                        co = null;
                        hrs = 0.0;
                        notes = "Váº¯ng máº·t chÆ°a rÃµ lÃ½ do";
                    }

                    ps.setInt(1, empId);
                    ps.setDate(2, Date.valueOf(date));
                    ps.setTime(3, ci != null ? Time.valueOf(ci) : null);
                    ps.setTime(4, co != null ? Time.valueOf(co) : null);
                    ps.setDouble(5, hrs);
                    ps.setString(6, status);
                    ps.setString(7, notes);
                    ps.setString(8, method);
                    ps.addBatch();
                }
            }
            ps.executeBatch();
            System.out.println("[AttendanceDAO] autoSeedMonthAttendance: ÄÃ£ Ä‘á»“ng bá»™ dá»¯ liá»‡u cháº¥m cÃ´ng ThÃ¡ng " + month + "/" + year + " Ä‘áº¿n ngÃ y " + lastDayToSeed);
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.autoSeedMonthAttendance lá»—i: " + e.getMessage());
        }
    }

    /**
     * [F1.1 FIX] Check-in vá»›i phÆ°Æ¡ng thá»©c: FaceID | Fingerprint | GPS | Manual.
     * Giá» chuáº©n thá»‘ng nháº¥t: dÃ¹ng AttendanceService.STANDARD_IN (08:30) + GRACE_MIN (15p).
     * @deprecated Gá»i tá»« Service qua checkInRaw() â€” khÃ´ng gá»i trá»±c tiáº¿p tá»« Servlet.
     */
    @Deprecated
    public boolean checkInWithMethod(int employeeId, LocalDate date, LocalTime checkInTime, String method) {
        Attendance existing = findByEmployeeAndDate(employeeId, date);
        String methodLabel = (method != null && !method.isEmpty()) ? method : "FaceID";
        // [F1.1] DÃ¹ng háº±ng sá»‘ tá»« Service thay vÃ¬ hardcode 08:35
        String status = checkInTime.isAfter(
            com.miximoi.hrm.service.AttendanceService.STANDARD_IN
                .plusMinutes(com.miximoi.hrm.service.AttendanceService.GRACE_MIN)
        ) ? "LATE" : "ON_TIME";
        String timeStr = checkInTime.toString().length() >= 5
            ? checkInTime.toString().substring(0, 5) : checkInTime.toString();
        String notes = "Check-in báº±ng " + methodLabel + " lÃºc " + timeStr;

        if (existing == null) {
            String sql = "INSERT INTO attendance (employee_id, work_date, check_in, total_hours, status, notes, method) VALUES (?,?,?,?,?,?,?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, employeeId); ps.setDate(2, Date.valueOf(date));
                ps.setTime(3, Time.valueOf(checkInTime));
                ps.setDouble(4, 0.0); ps.setString(5, status); ps.setString(6, notes);
                ps.setString(7, methodLabel);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) { System.err.println("checkInWithMethod insert lá»—i: " + e.getMessage()); }
        } else if (existing.getCheckIn() == null) {
            String sql = "UPDATE attendance SET check_in=?, status=?, notes=?, method=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setTime(1, Time.valueOf(checkInTime));
                ps.setString(2, status); ps.setString(3, notes);
                ps.setString(4, methodLabel); ps.setInt(5, existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) { System.err.println("checkInWithMethod update lá»—i: " + e.getMessage()); }
        } else {
            // ÄÃ£ check-in: báº£o lÆ°u giá» ban Ä‘áº§u, khÃ´ng ghi Ä‘Ã¨
            return true;
        }
        return false;
    }

    /**
     * Raw check-in Ä‘Æ°á»£c gá»i tá»« AttendanceService (sau khi Service Ä‘Ã£ validate).
     * Status vÃ  notes Ä‘Ã£ Ä‘Æ°á»£c xÃ¡c Ä‘á»‹nh bá»Ÿi Service â€” DAO chá»‰ INSERT/UPDATE.
     */
    public boolean checkInRaw(int employeeId, LocalDate date, LocalTime checkInTime,
                               String method, String status, String notes) {
        Attendance existing = findByEmployeeAndDate(employeeId, date);
        if (existing == null) {
            String sql = "INSERT INTO attendance (employee_id, work_date, check_in, total_hours, status, notes, method) "
                       + "VALUES (?,?,?,?,?,?,?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, employeeId); ps.setDate(2, Date.valueOf(date));
                ps.setTime(3, Time.valueOf(checkInTime)); ps.setDouble(4, 0.0);
                ps.setString(5, status); ps.setString(6, notes); ps.setString(7, method);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("checkInRaw insert lá»—i: " + e.getMessage());
            }
        } else if (existing.getCheckIn() == null) {
            String sql = "UPDATE attendance SET check_in=?, status=?, notes=?, method=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setTime(1, Time.valueOf(checkInTime));
                ps.setString(2, status); ps.setString(3, notes);
                ps.setString(4, method); ps.setInt(5, existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("checkInRaw update lá»—i: " + e.getMessage());
            }
        } else {
            return true; // ÄÃ£ check-in, khÃ´ng ghi Ä‘Ã¨
        }
        return false;
    }

    /** Láº¥y báº£ng tá»•ng há»£p cÃ´ng thÃ¡ng cho Káº¿ toÃ¡n & Admin */

    public List<TimesheetSummary> getTimesheetSummary(int month, int year) {
        List<TimesheetSummary> list = new ArrayList<>();
        String sql = "SELECT e.id, e.employee_code, e.full_name, d.name AS department_name, "
                   + "COALESCE(SUM(a.total_hours), 0) AS total_hours, "
                   + "COUNT(CASE WHEN a.status IN ('ON_TIME', 'COMPLETE', 'WORKING') THEN 1 END) AS on_time_days, "
                   + "COUNT(CASE WHEN a.status = 'LATE' THEN 1 END) AS late_days, "
                   + "COUNT(CASE WHEN a.status = 'EARLY_LEAVE' THEN 1 END) AS early_days, "
                   + "COUNT(CASE WHEN a.status = 'ABSENT' THEN 1 END) AS absent_days, "
                   + "COUNT(CASE WHEN a.status = 'ON_LEAVE' THEN 1 END) AS leave_days "
                   + "FROM employees e "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "LEFT JOIN attendance a ON e.id = a.employee_id "
                   + "  AND EXTRACT(MONTH FROM a.work_date) = ? "
                   + "  AND EXTRACT(YEAR FROM a.work_date) = ? "
                   + "WHERE e.status = 'ACTIVE' "
                   + "GROUP BY e.id, e.employee_code, e.full_name, d.name "
                   + "ORDER BY e.employee_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TimesheetSummary ts = new TimesheetSummary();
                    ts.setEmployeeId(rs.getInt("id"));
                    ts.setEmployeeCode(rs.getString("employee_code"));
                    ts.setEmployeeName(rs.getString("full_name"));
                    ts.setDepartmentName(rs.getString("department_name"));
                    double hours = rs.getDouble("total_hours");
                    ts.setTotalHours(hours);
                    ts.setTotalWorkDays(Math.round((hours / 8.0) * 10.0) / 10.0);
                    ts.setOnTimeDays(rs.getInt("on_time_days"));
                    ts.setLateDays(rs.getInt("late_days"));
                    ts.setEarlyLeaveDays(rs.getInt("early_days"));
                    ts.setAbsentDays(rs.getInt("absent_days"));
                    ts.setLeaveDays(rs.getInt("leave_days"));
                    list.add(ts);
                }
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.getTimesheetSummary lá»—i: " + e.getMessage());
        }
        return list;
    }

    /** Check-in cá»§a nhÃ¢n viÃªn (máº·c Ä‘á»‹nh FaceID) */
    public boolean checkIn(int employeeId, LocalDate date, LocalTime checkInTime) {
        return checkInWithMethod(employeeId, date, checkInTime, "FaceID");
    }

    /**
     * Check-out cá»§a nhÃ¢n viÃªn.
     * [F2.1 FIX] KhÃ´ng insert 4.0h giáº£ khi chÆ°a cÃ³ check-in â€” tráº£ vá» false Ä‘á»ƒ Servlet redirect error.
     */
    public boolean checkOut(int employeeId, LocalDate date, LocalTime checkOutTime) {
        Attendance existing = findByEmployeeAndDate(employeeId, date);
        String timeStr = checkOutTime.toString().length() >= 5
            ? checkOutTime.toString().substring(0, 5) : checkOutTime.toString();

        // [F2.1] Cháº·n checkout khi chÆ°a check-in â€” khÃ´ng insert dá»¯ liá»‡u giáº£
        if (existing == null || existing.getCheckIn() == null) {
            return false;
        } else {
            LocalTime checkIn = existing.getCheckIn();
            double hours = calculateWorkHours(checkIn, checkOutTime);

            // XÃ¡c Ä‘á»‹nh tráº¡ng thÃ¡i chÃ­nh xÃ¡c:
            // 1. Náº¿u buá»•i sÃ¡ng Ä‘Ã£ Ä‘i muá»™n (LATE) -> giá»¯ nguyÃªn LATE
            // 2. Náº¿u check-out trÆ°á»›c 17:00 vÃ  giá» lÃ m < 8.0 -> EARLY_LEAVE
            // 3. Náº¿u check-out tá»« 17:00 trá»Ÿ Ä‘i hoáº·c Ä‘Ã£ Ä‘á»§ 8h -> ON_TIME
            String currentStatus = existing.getStatus();
            String newStatus;
            if ("LATE".equalsIgnoreCase(currentStatus)) {
                newStatus = "LATE";
            } else if (checkOutTime.isBefore(LocalTime.of(17, 0)) && hours < 8.0) {
                newStatus = "EARLY_LEAVE";
            } else {
                newStatus = "ON_TIME";
            }

            // Báº£o vá»‡ náº¿u Ä‘Ã£ tá»«ng check-out trÆ°á»›c Ä‘Ã³ trong ngÃ y:
            // Giá»¯ giá» checkout muá»™n nháº¥t, khÃ´ng Ä‘á»ƒ giá» checkout má»›i nhá» hÆ¡n giá» checkout cÅ©
            LocalTime finalCheckOut = checkOutTime;
            if (existing.getCheckOut() != null && checkOutTime.isBefore(existing.getCheckOut())) {
                finalCheckOut = existing.getCheckOut();
                if (existing.getTotalHours() > hours) {
                    hours = existing.getTotalHours();
                    newStatus = existing.getStatus();
                }
            }

            String notes = existing.getNotes();
            if (notes == null || notes.isEmpty()) {
                notes = "Check-out ra vá» lÃºc " + timeStr;
            } else if (!notes.contains("Check-out")) {
                notes = notes + " | Check-out lÃºc " + timeStr;
            }

            String sql = "UPDATE attendance SET check_out=?, total_hours=?, status=?, notes=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setTime(1, Time.valueOf(finalCheckOut));
                ps.setDouble(2, hours);
                ps.setString(3, newStatus);
                ps.setString(4, notes);
                ps.setInt(5, existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.checkOut update lá»—i: " + e.getMessage());
            }
        }
        return false;
    }

    /** Helper tÃ­nh sá»‘ giá» lÃ m viá»‡c thá»±c táº¿ (trá»« 1h nghá»‰ trÆ°a náº¿u lÃ m tá»« 5 tiáº¿ng trá»Ÿ lÃªn, tá»‘i Ä‘a 8.0h) */
    public double calculateWorkHours(LocalTime checkIn, LocalTime checkOut) {
        if (checkIn != null && checkOut != null) {
            if (checkOut.isAfter(checkIn)) {
                long minutes = Duration.between(checkIn, checkOut).toMinutes();
                if (minutes >= 300) {
                    minutes = Math.max(0, minutes - 60);
                }
                double hours = Math.max(0.1, Math.round((minutes / 60.0) * 10.0) / 10.0);
                return Math.min(8.0, hours);
            }
            return 0.5;
        } else if (checkIn != null || checkOut != null) {
            return 4.0;
        }
        return 0.0;
    }

    /** LÆ°u cháº¥m cÃ´ng thá»§ cÃ´ng hoáº·c Ä‘iá»u chá»‰nh (Upsert) */
    public boolean upsertManual(int employeeId, LocalDate date, LocalTime checkIn, LocalTime checkOut, String status, String notes) {
        Attendance existing = findByEmployeeAndDate(employeeId, date);
        double hours = calculateWorkHours(checkIn, checkOut);

        if (existing == null) {
            String sql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes) "
                       + "VALUES (?,?,?,?,?,?,?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, employeeId);
                ps.setDate(2, Date.valueOf(date));
                ps.setTime(3, checkIn != null ? Time.valueOf(checkIn) : null);
                ps.setTime(4, checkOut != null ? Time.valueOf(checkOut) : null);
                ps.setDouble(5, hours);
                ps.setString(6, status != null ? status : "ON_TIME");
                ps.setString(7, notes);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.upsertManual insert lá»—i: " + e.getMessage());
            }
        } else {
            String sql = "UPDATE attendance SET check_in=?, check_out=?, total_hours=?, status=?, notes=? WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setTime(1, checkIn != null ? Time.valueOf(checkIn) : null);
                ps.setTime(2, checkOut != null ? Time.valueOf(checkOut) : null);
                ps.setDouble(3, hours);
                ps.setString(4, status != null ? status : existing.getStatus());
                ps.setString(5, notes);
                ps.setInt(6, existing.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.err.println("AttendanceDAO.upsertManual update lá»—i: " + e.getMessage());
            }
        }
        return false;
    }

    /** Cáº­p nháº­t cháº¥m cÃ´ng theo ID */
    public boolean update(int id, LocalTime checkIn, LocalTime checkOut, String status, String notes) {
        double hours = calculateWorkHours(checkIn, checkOut);
        String sql = "UPDATE attendance SET check_in=?, check_out=?, total_hours=?, status=?, notes=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTime(1, checkIn != null ? Time.valueOf(checkIn) : null);
            ps.setTime(2, checkOut != null ? Time.valueOf(checkOut) : null);
            ps.setDouble(3, hours);
            ps.setString(4, status);
            ps.setString(5, notes);
            ps.setInt(6, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.update lá»—i: " + e.getMessage());
        }
        return false;
    }

    /** PhÃª duyá»‡t giáº£i trÃ¬nh: chuyá»ƒn tráº¡ng thÃ¡i sang ON_TIME, cáº­p nháº­t giá» lÃ m vÃ  thÃªm ghi chÃº */
    public boolean approveExplain(int id) {
        String sql = "UPDATE attendance SET status='ON_TIME', total_hours = CASE WHEN total_hours <= 0 THEN 8.0 ELSE total_hours END, notes=COALESCE(notes, '') || ' [ÄÃ£ duyá»‡t giáº£i trÃ¬nh]' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.approveExplain lá»—i: " + e.getMessage());
        }
        return false;
    }

    /** Kiá»ƒm tra xem báº£ng cÃ´ng thÃ¡ng/nÄƒm Ä‘Ã£ bá»‹ khÃ³a chÆ°a */
    public boolean isTimesheetLocked(int month, int year) {
        String sql = "SELECT is_locked FROM timesheet_locks WHERE pay_month = ? AND pay_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("is_locked");
                }
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.isTimesheetLocked lá»—i: " + e.getMessage());
        }
        return false;
    }

    /** KhÃ³a hoáº·c má»Ÿ khÃ³a báº£ng cÃ´ng thÃ¡ng/nÄƒm cÃ³ ghi váº¿t lá»‹ch sá»­ */
    public boolean setTimesheetLocked(int month, int year, boolean locked, Integer userId, String note) {
        String sql = "INSERT INTO timesheet_locks (pay_month, pay_year, is_locked, "
                   + (locked ? "locked_by, locked_at" : "unlocked_by, unlocked_at") + ", note) "
                   + "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, ?) "
                   + "ON CONFLICT (pay_month, pay_year) DO UPDATE SET "
                   + "is_locked = EXCLUDED.is_locked, "
                   + (locked ? "locked_by = EXCLUDED.locked_by, locked_at = CURRENT_TIMESTAMP" 
                             : "unlocked_by = EXCLUDED.unlocked_by, unlocked_at = CURRENT_TIMESTAMP") + ", "
                   + "note = EXCLUDED.note";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setBoolean(3, locked);
            if (userId != null && userId > 0) {
                ps.setInt(4, userId);
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, note);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.setTimesheetLocked lá»—i: " + e.getMessage());
        }
        return false;
    }

    /** Äáº¿m sá»‘ lÆ°á»£ng Ä‘Æ¡n/báº£n ghi giáº£i trÃ¬nh Ä‘ang chá» duyá»‡t */
    public int countPendingExplains(Integer departmentId) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM attendance a "
          + "JOIN employees e ON a.employee_id = e.id "
          + "WHERE a.notes IS NOT NULL AND a.notes <> '' "
          + "AND (a.status IN ('LATE', 'EARLY_LEAVE', 'ABSENT') OR a.notes ILIKE '%giáº£i trÃ¬nh%') "
          + "AND a.notes NOT LIKE '%[ÄÃ£ duyá»‡t giáº£i trÃ¬nh]%'"
        );
        if (departmentId != null && departmentId > 0) {
            sql.append(" AND e.department_id = ?");
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (departmentId != null && departmentId > 0) {
                ps.setInt(1, departmentId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.countPendingExplains lá»—i: " + e.getMessage());
        }
        return 0;
    }

    /** XÃ³a báº£n ghi cháº¥m cÃ´ng */
    public boolean delete(int id) {
        String sql = "DELETE FROM attendance WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.delete lá»—i: " + e.getMessage());
        }
        return false;
    }

    public List<Attendance> findByMonth(int month, int year) {
        return search(null, null, null, null, month, year);
    }

    public boolean insert(Attendance att) {
        if (att == null) return false;
        String sql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, att.getEmployeeId());
            ps.setDate(2, att.getWorkDate() != null ? Date.valueOf(att.getWorkDate()) : Date.valueOf(LocalDate.now()));
            ps.setTime(3, att.getCheckIn() != null ? Time.valueOf(att.getCheckIn()) : null);
            ps.setTime(4, att.getCheckOut() != null ? Time.valueOf(att.getCheckOut()) : null);
            ps.setDouble(5, att.getTotalHours());
            ps.setString(6, att.getStatus() != null ? att.getStatus() : "ON_TIME");
            ps.setString(7, att.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.insert lá»—i: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Attendance att) {
        if (att == null) return false;
        return update(att.getId(), att.getCheckIn(), att.getCheckOut(), att.getStatus(), att.getNotes());
    }

    public int bulkDelete(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return 0;
        StringBuilder sql = new StringBuilder("DELETE FROM attendance WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.bulkDelete lá»—i: " + e.getMessage());
        }
        return 0;
    }

    public int bulkMarkStatus(List<Integer> ids, String status) {
        if (ids == null || ids.isEmpty()) return 0;
        StringBuilder sql = new StringBuilder("UPDATE attendance SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, status);
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 2, ids.get(i));
            }
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.bulkMarkStatus lá»—i: " + e.getMessage());
        }
        return 0;
    }

    public List<Attendance> findByIds(List<Integer> ids) {
        List<Attendance> list = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return list;
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE a.id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(") ORDER BY a.work_date DESC");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.findByIds lá»—i: " + e.getMessage());
        }
        return list;
    }

    public double countWorkingDays(int employeeId, int month, int year) {
        String sql = "SELECT work_date, check_in, check_out, total_hours, status "
                   + "FROM attendance "
                   + "WHERE employee_id = ? AND EXTRACT(MONTH FROM work_date) = ? AND EXTRACT(YEAR FROM work_date) = ? "
                   + "ORDER BY work_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            try (ResultSet rs = ps.executeQuery()) {
                double totalWorkDays = 0.0;
                int minorLateCount = 0;
                LocalTime standardIn = LocalTime.of(8, 30);
                LocalTime standardOut = LocalTime.of(17, 30);
                boolean hasRecords = false;

                while (rs.next()) {
                    hasRecords = true;
                    String status = rs.getString("status");
                    if (status == null) status = "ON_TIME";
                    status = status.toUpperCase();
                    double hours = rs.getDouble("total_hours");
                    Time inTime = rs.getTime("check_in");
                    Time outTime = rs.getTime("check_out");
                    LocalTime checkIn = inTime != null ? inTime.toLocalTime() : null;
                    LocalTime checkOut = outTime != null ? outTime.toLocalTime() : null;

                    switch (status) {
                        case "ON_LEAVE", "BUSINESS_TRIP", "MISSION", "WFH" -> totalWorkDays += 1.0;
                        case "HALF_DAY" -> totalWorkDays += 0.5;
                        case "ABSENT" -> {}
                        default -> {
                            // ON_TIME, COMPLETE, WORKING, LATE, EARLY_LEAVE, OVERTIME
                            double dayCredit = 1.0;
                            if (hours > 0 && hours < 3.5) {
                                dayCredit = Math.round((hours / 8.0) * 10.0) / 10.0;
                            } else if (hours >= 3.5 && hours < 6.5) {
                                dayCredit = 0.5;
                            }

                            int lateMins = 0;
                            if (checkIn != null && checkIn.isAfter(standardIn)) {
                                lateMins = (int) Duration.between(standardIn, checkIn).toMinutes();
                            }
                            int earlyMins = 0;
                            if (checkOut != null && checkOut.isBefore(standardOut)) {
                                earlyMins = (int) Duration.between(checkOut, standardOut).toMinutes();
                            }

                            int totalDiff = lateMins + earlyMins;
                            if (totalDiff <= 0 && ("LATE".equals(status) || "EARLY_LEAVE".equals(status))) {
                                totalDiff = 15;
                            }

                            // Quy chuáº©n tÃ­nh cÃ´ng tá»± Ä‘á»™ng theo chÃ­nh sÃ¡ch:
                            // - Trá»… < 15 phÃºt: Miá»…n pháº¡t tá»‘i Ä‘a 3 láº§n/thÃ¡ng. Láº§n thá»© 4 trá»Ÿ Ä‘i trá»« 0.25 cÃ´ng.
                            // - Trá»… tá»« 15 - 60 phÃºt: Kháº¥u trá»« 0.25 cÃ´ng.
                            // - Trá»…/vá» sá»›m > 60 phÃºt: Kháº¥u trá»« 0.50 cÃ´ng.
                            double penalty = 0.0;
                            if (totalDiff > 0) {
                                if (totalDiff < 15) {
                                    minorLateCount++;
                                    if (minorLateCount > 3) {
                                        penalty = 0.25;
                                    }
                                } else if (totalDiff <= 60) {
                                    penalty = 0.25;
                                } else {
                                    penalty = 0.50;
                                }
                            }

                            dayCredit = Math.max(0.0, dayCredit - penalty);
                            totalWorkDays += dayCredit;
                        }
                    }
                }
                if (!hasRecords) return 0.0;
                return Math.round(totalWorkDays * 10.0) / 10.0;
            }
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.countWorkingDays lá»—i: " + e.getMessage());
        }
        return 0.0;
    }

    /**
     * Tá»± Ä‘á»™ng ghi nháº­n/cáº­p nháº­t ngÃ y nghá»‰ phÃ©p cÃ³ lÆ°Æ¡ng (ON_LEAVE) vÃ o báº£ng attendance
     * khi Ä‘Æ¡n nghá»‰ phÃ©p Ä‘Æ°á»£c phÃª duyá»‡t thÃ nh cÃ´ng.
     */
    public boolean recordLeaveAttendance(int employeeId, LocalDate date, String leaveType, String reason) {
        String note = "Nghá»‰ phÃ©p (" + (leaveType != null ? leaveType : "ÄÃ£ duyá»‡t") + ")"
                    + (reason != null && !reason.trim().isEmpty() ? ": " + reason.trim() : "");
        String sql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes, method) "
                   + "VALUES (?, ?, '08:00:00', '17:30:00', 8.0, 'ON_LEAVE', ?, 'SYSTEM_LEAVE') "
                   + "ON CONFLICT (employee_id, work_date) "
                   + "DO UPDATE SET status = 'ON_LEAVE', notes = EXCLUDED.notes, total_hours = 8.0, method = 'SYSTEM_LEAVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, Date.valueOf(date));
            ps.setString(3, note);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.recordLeaveAttendance lá»—i: " + e.getMessage());
            return false;
        }
    }

    /** Ghi nháº­n cháº¥m cÃ´ng cho trÆ°á»ng há»£p nghá»‰ phÃ©p ná»­a ngÃ y (0.5 ngÃ y - 4 giá») */
    public boolean recordHalfDayLeave(int employeeId, LocalDate date, String session, String leaveType, String reason) {
        String sessionText = "MORNING".equalsIgnoreCase(session) ? "Buá»•i sÃ¡ng (08:00 - 12:00)" :
                             "AFTERNOON".equalsIgnoreCase(session) ? "Buá»•i chiá»u (13:30 - 17:30)" : "Ná»­a ngÃ y";
        String note = "Nghá»‰ phÃ©p ná»­a ngÃ y (" + sessionText + " - " + (leaveType != null ? leaveType : "ÄÃ£ duyá»‡t") + ")"
                    + (reason != null && !reason.trim().isEmpty() ? ": " + reason.trim() : "");
        String checkIn = "AFTERNOON".equalsIgnoreCase(session) ? "08:00:00" : "13:30:00";
        String checkOut = "AFTERNOON".equalsIgnoreCase(session) ? "12:00:00" : "17:30:00";
        String sql = "INSERT INTO attendance (employee_id, work_date, check_in, check_out, total_hours, status, notes, method) "
                   + "VALUES (?, ?, ?::TIME, ?::TIME, 4.0, 'HALF_DAY', ?, 'SYSTEM_LEAVE') "
                   + "ON CONFLICT (employee_id, work_date) "
                   + "DO UPDATE SET status = 'HALF_DAY', notes = EXCLUDED.notes, total_hours = 4.0, method = 'SYSTEM_LEAVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, Date.valueOf(date));
            ps.setString(3, checkIn);
            ps.setString(4, checkOut);
            ps.setString(5, note);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.recordHalfDayLeave lá»—i: " + e.getMessage());
            return false;
        }
    }

    /** Há»§y/thu há»“i cÃ¡c báº£n ghi cháº¥m cÃ´ng tá»± Ä‘á»™ng phÃ¡t sinh tá»« Ä‘Æ¡n nghá»‰ phÃ©p khi Ä‘Æ¡n bá»‹ tá»« chá»‘i hoáº·c há»§y bá» */
    public boolean removeSystemLeaveAttendance(int employeeId, LocalDate startDate, LocalDate endDate) {
        if (startDate == null || endDate == null) return false;
        String sql = "DELETE FROM attendance WHERE employee_id = ? AND work_date BETWEEN ? AND ? AND method = 'SYSTEM_LEAVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, Date.valueOf(startDate));
            ps.setDate(3, Date.valueOf(endDate));
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            System.err.println("AttendanceDAO.removeSystemLeaveAttendance lá»—i: " + e.getMessage());
            return false;
        }
    }

    /** Kiá»ƒm tra xem nhÃ¢n viÃªn cÃ³ Ä‘ang trong Ä‘á»£t nghá»‰ phÃ©p Ä‘Ã£ Ä‘Æ°á»£c duyá»‡t (APPROVED) vÃ o ngÃ y cá»¥ thá»ƒ hay khÃ´ng */
    public boolean isEmployeeOnLeave(int employeeId, LocalDate date) {
        String sql = "SELECT COUNT(*) FROM leave_requests "
                   + "WHERE employee_id = ? AND status = 'APPROVED' AND ? BETWEEN start_date AND end_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return true;
            }
        } catch (SQLException ignored) {}
        return false;
    }

    private Attendance mapRow(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setId(rs.getInt("id"));
        a.setEmployeeId(rs.getInt("employee_id"));
        a.setEmployeeCode(rs.getString("employee_code"));
        a.setEmployeeName(rs.getString("full_name"));
        a.setDepartmentName(rs.getString("department_name"));
        a.setPositionName(rs.getString("position_name"));
        Date wd = rs.getDate("work_date");
        if (wd != null) a.setWorkDate(wd.toLocalDate());
        Time ci = rs.getTime("check_in");
        if (ci != null) a.setCheckIn(ci.toLocalTime());
        Time co = rs.getTime("check_out");
        if (co != null) a.setCheckOut(co.toLocalTime());
        a.setTotalHours(rs.getDouble("total_hours"));
        a.setStatus(rs.getString("status"));
        a.setNotes(rs.getString("notes"));
        try {
            String m = rs.getString("method");
            if (m != null && !m.isEmpty()) a.setMethod(m);
        } catch (SQLException ignored) {}
        Timestamp cat = rs.getTimestamp("created_at");
        if (cat != null) a.setCreatedAt(cat.toLocalDateTime());
        return a;
    }

    // =====================================================================
    // [F2.4] DB-side pagination — khong load toan bo list vao JVM heap
    // =====================================================================

    /** Tim kiem phan trang tai DB (LIMIT/OFFSET). */
    public java.util.List<Attendance> searchPaged(String keyword, Integer departmentId, String status,
                                         LocalDate date, Integer month, Integer year,
                                         int page, int pageSize) {
        java.util.List<Attendance> list = new java.util.ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty())
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
        if (departmentId != null && departmentId > 0) sql.append("AND e.department_id = ? ");
        if (status != null && !status.trim().isEmpty()) sql.append("AND a.status = ? ");
        if (date != null) {
            sql.append("AND a.work_date = ? ");
        } else {
            if (month != null && month > 0) sql.append("AND EXTRACT(MONTH FROM a.work_date) = ? ");
            if (year  != null && year  > 0) sql.append("AND EXTRACT(YEAR  FROM a.work_date) = ? ");
            sql.append("AND a.work_date <= CURRENT_DATE ");
        }
        sql.append("ORDER BY a.work_date DESC, COALESCE(a.check_out, a.check_in) DESC NULLS LAST, a.check_in DESC NULLS LAST, a.id DESC LIMIT ? OFFSET ?");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, like); ps.setString(idx++, like);
            }
            if (departmentId != null && departmentId > 0) ps.setInt(idx++, departmentId);
            if (status != null && !status.trim().isEmpty()) ps.setString(idx++, status.trim());
            if (date != null) {
                ps.setDate(idx++, Date.valueOf(date));
            } else {
                if (month != null && month > 0) ps.setInt(idx++, month);
                if (year  != null && year  > 0) ps.setInt(idx++, year);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx,   Math.max(0, (page - 1) * pageSize));
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(mapRow(rs)); }
        } catch (SQLException e) { System.err.println("AttendanceDAO.searchPaged loi: " + e.getMessage()); }
        return list;
    }

    /** Dem tong ban ghi theo dieu kien search (phuc vu phan trang). */
    public int countSearch(String keyword, Integer departmentId, String status,
                            LocalDate date, Integer month, Integer year) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM attendance a JOIN employees e ON a.employee_id = e.id WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty())
            sql.append("AND (LOWER(e.full_name) LIKE ? OR LOWER(e.employee_code) LIKE ?) ");
        if (departmentId != null && departmentId > 0) sql.append("AND e.department_id = ? ");
        if (status != null && !status.trim().isEmpty()) sql.append("AND a.status = ? ");
        if (date != null) {
            sql.append("AND a.work_date = ? ");
        } else {
            if (month != null && month > 0) sql.append("AND EXTRACT(MONTH FROM a.work_date) = ? ");
            if (year  != null && year  > 0) sql.append("AND EXTRACT(YEAR  FROM a.work_date) = ? ");
            sql.append("AND a.work_date <= CURRENT_DATE ");
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, like); ps.setString(idx++, like);
            }
            if (departmentId != null && departmentId > 0) ps.setInt(idx++, departmentId);
            if (status != null && !status.trim().isEmpty()) ps.setString(idx++, status.trim());
            if (date != null) {
                ps.setDate(idx++, Date.valueOf(date));
            } else {
                if (month != null && month > 0) ps.setInt(idx++, month);
                if (year  != null && year  > 0) ps.setInt(idx++, year);
            }
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        } catch (SQLException e) { System.err.println("AttendanceDAO.countSearch loi: " + e.getMessage()); }
        return 0;
    }

    /** Kiem tra da co du du lieu cham cong cho thang/nam chua. */
    public boolean hasEnoughDataForMonth(int month, int year, int activeCount) {
        if (activeCount <= 0) return true;
        String sql = "SELECT COUNT(*) FROM attendance WHERE EXTRACT(MONTH FROM work_date) = ? AND EXTRACT(YEAR FROM work_date) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month); ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) >= Math.max(15, activeCount * 12);
            }
        } catch (SQLException e) { System.err.println("AttendanceDAO.hasEnoughDataForMonth loi: " + e.getMessage()); }
        return false;
    }
}
