package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.util.DBConnection;
import com.miximoi.hrm.util.DatabaseInitializer;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class AttendanceQueryInspectTest {

    @BeforeAll
    public static void setUp() {
        DatabaseInitializer.initialize();
    }

    @Test
    public void testNoFutureAttendance() throws Exception {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM attendance WHERE work_date > CURRENT_DATE");
             ResultSet rs = ps.executeQuery()) {
            assertTrue(rs.next());
            assertEquals(0, rs.getInt(1), "Không được có bản ghi chấm công có ngày trong tương lai");
        }
    }

    @Test
    public void testLatestAttendanceOnTop() {
        AttendanceDAO dao = new AttendanceDAO();
        LocalDate today = LocalDate.now();
        List<Attendance> list = dao.searchPaged(null, null, null, null, today.getMonthValue(), today.getYear(), 1, 10);
        assertNotNull(list);
        if (list.size() > 1) {
            for (int i = 0; i < list.size() - 1; i++) {
                Attendance curr = list.get(i);
                Attendance next = list.get(i + 1);
                assertFalse(curr.getWorkDate().isAfter(today), "Ngày chấm công không được ở tương lai");
                assertTrue(curr.getWorkDate().compareTo(next.getWorkDate()) >= 0, "Chấm công phải sắp xếp ngày mới nhất lên đầu");
            }
        }
    }
}
