package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.NotificationDAO;
import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Notification;
import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.util.PdfExportUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Bộ kiểm thử tự động JUnit 5 cho Dịch vụ Email SMTP tự động và Xuất PDF Phiếu lương / Hợp đồng lao động.
 */
class EmailAndPdfExportTest {

    @Test
    @DisplayName("Kiểm tra EmailService gửi email mô phỏng môi trường phát triển (Dev Mode) an toàn")
    void testEmailServiceDevMode() {
        boolean sent = EmailService.sendHtmlEmail(
                "nhanvien.test@miximoi.vn",
                "[TEST] Kiểm tra kênh thông báo hệ thống",
                "<h3>Nội dung email kiểm thử tự động</h3>"
        );
        assertTrue(sent, "EmailService phải xử lý an toàn và trả về true ở chế độ mô phỏng dev");
    }

    @Test
    @DisplayName("Kiểm tra xuất file PDF Phiếu lương điện tử (E-Payslip) đạt chuẩn PDF binary")
    void testGeneratePayslipPdf() throws Exception {
        Payroll p = new Payroll();
        p.setEmployeeCode("NV-001");
        p.setEmployeeName("Nguyễn Văn An");
        p.setDepartmentName("Phòng Kỹ thuật R&D");
        p.setPositionName("Kỹ sư Phần mềm");
        p.setPayMonth(10);
        p.setPayYear(2026);
        p.setBaseSalary(new BigDecimal("25000000"));
        p.setWorkingDays(22.0);
        p.setStandardDays(22.0);
        p.setOvertimeAmount(new BigDecimal("1500000"));
        p.setAllowance(new BigDecimal("2000000"));
        p.setBonus(new BigDecimal("3000000"));
        p.setBhxhAmount(new BigDecimal("2000000"));
        p.setBhytAmount(new BigDecimal("375000"));
        p.setTncnTax(new BigDecimal("1200000"));
        p.setDeduction(new BigDecimal("3575000"));
        p.setNetSalary(new BigDecimal("27925000"));
        p.setBankAccount("19034567890123");
        p.setBankName("Techcombank");

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        PdfExportUtil.generatePayslipPdf(p, out);

        byte[] pdfBytes = out.toByteArray();
        assertNotNull(pdfBytes, "Dữ liệu PDF không được null");
        assertTrue(pdfBytes.length > 500, "File PDF phiếu lương phải có dung lượng > 500 bytes");

        // Kiểm tra PDF magic number: %PDF-
        String header = new String(pdfBytes, 0, 5);
        assertEquals("%PDF-", header, "File kết quả phải bắt đầu bằng header chuẩn PDF");
    }

    @Test
    @DisplayName("Kiểm tra xuất file PDF Hợp đồng lao động tiêu chuẩn A4 đạt chuẩn PDF binary")
    void testGenerateContractPdf() throws Exception {
        Contract c = new Contract();
        c.setContractCode("HDLD-2026-001");
        c.setEmployeeName("Trần Thị Mai");
        c.setDepartmentName("Phòng Nhân sự");
        c.setContractType("Xác định thời hạn (12 tháng)");
        c.setStartDate(LocalDate.of(2026, 1, 1));
        c.setEndDate(LocalDate.of(2026, 12, 31));
        c.setBaseSalary(new BigDecimal("18000000"));
        c.setAllowanceAmount(new BigDecimal("1500000"));
        c.setSignerName("Đặng Vũ Hải Duy");
        c.setSignerTitle("Giám đốc Nhân sự");
        c.setSignedDate(LocalDate.now());

        Employee emp = new Employee();
        emp.setFullName("Trần Thị Mai");
        emp.setDateOfBirth(LocalDate.of(1996, 5, 20));
        emp.setIdentityNumber("001196001234");
        emp.setPositionName("Chuyên viên Tuyển dụng");

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        PdfExportUtil.generateContractPdf(c, emp, out);

        byte[] pdfBytes = out.toByteArray();
        assertNotNull(pdfBytes);
        assertTrue(pdfBytes.length > 1000, "File PDF hợp đồng phải có dung lượng > 1000 bytes");

        String header = new String(pdfBytes, 0, 5);
        assertEquals("%PDF-", header, "File hợp đồng phải bắt đầu bằng header chuẩn PDF");
    }

    @Test
    @DisplayName("Kiểm tra NotificationDAO truy vấn thông báo khẩn cấp không lỗi")
    void testNotificationDaoLatestAlert() {
        NotificationDAO nDao = new NotificationDAO();
        Notification alert = nDao.getLatestActiveAlert();
        // Có thể null nếu database chưa có notification loại warning, nhưng không được ném SQLException
        if (alert != null) {
            assertNotNull(alert.getTitle(), "Tiêu đề thông báo không được null");
        } else {
            assertNull(alert, "Thông báo cảnh báo có thể chưa có trong dữ liệu mẫu");
        }
    }
}
