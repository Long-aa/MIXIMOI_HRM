package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Attendance;
import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.model.Department;
import com.miximoi.hrm.util.DatabaseInitializer;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class BiometricAndContractTest {

    private static AttendanceDAO attendanceDAO;
    private static ContractDAO contractDAO;
    private static DepartmentDAO departmentDAO;

    @BeforeAll
    public static void setUp() {
        DatabaseInitializer.initialize();
        attendanceDAO = new AttendanceDAO();
        contractDAO = new ContractDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Test
    @DisplayName("Kiểm tra chấm công phương thức FaceID và Vân tay")
    public void testBiometricAttendance() {
        LocalDate today = LocalDate.now();
        LocalTime time = LocalTime.of(8, 15);

        // Chấm công bằng FaceID
        boolean faceCheckIn = attendanceDAO.checkInWithMethod(1, today, time, "FaceID");
        assertTrue(faceCheckIn, "Check-in FaceID phải thành công");

        Attendance att = attendanceDAO.findByEmployeeAndDate(1, today);
        assertNotNull(att);
        assertEquals("FaceID", att.getMethod());
        assertEquals("ON_TIME", att.getStatus());

        // Chấm công nhân viên 2 bằng Fingerprint (Vân tay)
        boolean fpCheckIn = attendanceDAO.checkInWithMethod(2, today, time, "Fingerprint");
        assertTrue(fpCheckIn, "Check-in Fingerprint phải thành công");

        Attendance attFp = attendanceDAO.findByEmployeeAndDate(2, today);
        assertNotNull(attFp);
        assertEquals("Fingerprint", attFp.getMethod());
    }

    @Test
    @DisplayName("Kiểm tra sinh mã hợp đồng tiếp theo và lưu HĐLĐ chuẩn Bộ luật Lao động 2019")
    public void testContractCreationWithLegalFields() {
        String nextCode = contractDAO.getNextContractCode();
        assertNotNull(nextCode);
        assertTrue(nextCode.startsWith("HD"));

        Contract c = new Contract();
        c.setContractCode(nextCode);
        c.setEmployeeId(1);
        c.setContractType("INDEFINITE");
        c.setStartDate(LocalDate.now());
        c.setBaseSalary(new BigDecimal("28500000"));
        c.setStatus("ACTIVE");
        c.setSignerName("Nguyễn Văn An");
        c.setSignerTitle("Tổng Giám Đốc");
        c.setWorkLocation("Trụ sở Landmark 81, TP.HCM");
        c.setAllowanceAmount(new BigDecimal("2500000"));
        c.setIdentityNumber("001095012345");

        boolean inserted = contractDAO.insert(c);
        assertTrue(inserted, "Chèn hợp đồng mới phải thành công");

        List<Contract> list = contractDAO.findByEmployeeId(1);
        assertFalse(list.isEmpty());
        Contract saved = list.get(0); // Mới nhất theo start_date DESC
        assertEquals("Nguyễn Văn An", saved.getSignerName());
        assertEquals("Trụ sở Landmark 81, TP.HCM", saved.getWorkLocation());
        assertEquals("001095012345", saved.getIdentityNumber());
    }

    @Test
    @DisplayName("Kiểm tra danh sách phòng ban và mã code phòng ban")
    public void testDepartmentList() {
        List<Department> depts = departmentDAO.findAll();
        assertNotNull(depts);
        assertFalse(depts.isEmpty());
        assertTrue(depts.size() >= 5);

        for (Department d : depts) {
            assertNotNull(d.getName());
            assertTrue(d.getId() > 0);
        }
    }
}
