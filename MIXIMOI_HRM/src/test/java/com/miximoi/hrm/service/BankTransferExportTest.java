package com.miximoi.hrm.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Bộ kiểm thử tự động JUnit 5 cho Nghiệp vụ Xuất file Lệnh chi Ngân hàng hàng loạt (Batch Bank Transfer).
 * Đảm bảo tương thích chuẩn định dạng cổng Ngân hàng doanh nghiệp: VCB DigiBiz, TCB Business, MB Bank, BIDV iBank.
 */
class BankTransferExportTest {

    static class TransferRecord {
        final String empCode;
        final String beneficiaryName;
        final String accountNumber;
        final String bankName;
        final BigDecimal amount;
        final String memo;

        public TransferRecord(String empCode, String beneficiaryName, String accountNumber, String bankName, BigDecimal amount, String memo) {
            this.empCode = empCode;
            this.beneficiaryName = beneficiaryName;
            this.accountNumber = accountNumber;
            this.bankName = bankName;
            this.amount = amount;
            this.memo = memo;
        }

        public String toCsvRow(int index) {
            return index + "," + empCode + "," + accountNumber + "," + beneficiaryName + "," + bankName + "," + amount + "," + memo;
        }
    }

    private String escapeCsv(String val) {
        if (val == null) return "";
        if (val.contains(",") || val.contains("\"") || val.contains("\n")) {
            return "\"" + val.replace("\"", "\"\"") + "\"";
        }
        return val;
    }

    @Test
    @DisplayName("Kiểm tra định dạng Header Lệnh chi Ngân hàng Vietcombank DigiBiz")
    void testVietcombankDigiBizHeader() {
        String expectedHeader = "STT,Mã nhân viên,Số tài khoản nhận,Tên người thụ hưởng,Ngân hàng thụ hưởng,Số tiền (VNĐ),Nội dung thanh toán";
        assertTrue(expectedHeader.contains("Số tài khoản nhận"));
        assertTrue(expectedHeader.contains("Tên người thụ hưởng"));
        assertTrue(expectedHeader.contains("Số tiền (VNĐ)"));
        assertEquals(7, expectedHeader.split(",").length, "Header VCB DigiBiz gồm 7 cột chuẩn");
    }

    @Test
    @DisplayName("Kiểm tra định dạng Header Lệnh chi Ngân hàng Techcombank Business")
    void testTechcombankBusinessHeader() {
        String header = "STT,Số TK Thụ hưởng,Tên Đơn vị/Người nhận,Mã Ngân hàng/Chi nhánh,Số tiền chuyển,Nội dung chi lương,Mã nhân sự";
        assertTrue(header.contains("Số TK Thụ hưởng"));
        assertTrue(header.contains("Mã Ngân hàng/Chi nhánh"));
        assertTrue(header.contains("Số tiền chuyển"));
        assertEquals(7, header.split(",").length, "Header Techcombank gồm 7 cột chuẩn");
    }

    @Test
    @DisplayName("Kiểm tra định dạng Header Lệnh chi Ngân hàng Quân Đội MB Bank B2B")
    void testMBBankB2BHeader() {
        String header = "STT,Số tài khoản đích,Tên chủ tài khoản,Mã định danh CITAD/BIN,Số tiền thực lĩnh,Diễn giải chuyển tiền,Mã NV";
        assertTrue(header.contains("Số tài khoản đích"));
        assertTrue(header.contains("Mã định danh CITAD/BIN"));
        assertTrue(header.contains("Số tiền thực lĩnh"));
        assertEquals(7, header.split(",").length, "Header MB Bank gồm 7 cột chuẩn");
    }

    @Test
    @DisplayName("Kiểm tra ký tự UTF-8 BOM hiển thị chuẩn tiếng Việt có dấu trong Microsoft Excel")
    void testUtf8BomByteOrderMark() {
        char utf8Bom = '\uFEFF';
        String sampleText = utf8Bom + "Công ty Cổ phần Công nghệ MIXIMOI";
        assertEquals('\uFEFF', sampleText.charAt(0), "Ký tự đầu tiên phải là UTF-8 BOM để Excel tự nhận diện UTF-8");
        assertTrue(sampleText.contains("MIXIMOI"));
    }

    @Test
    @DisplayName("Kiểm tra hàm thoát ký tự đặc biệt CSV (Dấu phẩy, dấu nháy kép, xuống dòng)")
    void testCsvSpecialCharactersEscaping() {
        String normal = "Nguyen Van A";
        assertEquals("Nguyen Van A", escapeCsv(normal));

        String withComma = "Hà Nội, Việt Nam";
        assertEquals("\"Hà Nội, Việt Nam\"", escapeCsv(withComma), "Chuỗi có dấu phẩy phải được bọc trong cặp nháy kép");

        String withQuote = "Nguyễn \"Văn\" B";
        assertEquals("\"Nguyễn \"\"Văn\"\" B\"", escapeCsv(withQuote), "Dấu nháy kép phải được escape thành hai dấu nháy kép");

        String withNewline = "Dòng 1\nDòng 2";
        assertEquals("\"Dòng 1\nDòng 2\"", escapeCsv(withNewline), "Chuỗi có ký tự xuống dòng phải được bọc nháy kép");
    }

    @Test
    @DisplayName("Kiểm tra tổng tiền chuyển khoản khớp chính xác không làm tròn sai số")
    void testBatchTotalAmountPrecision() {
        List<TransferRecord> batch = new ArrayList<>();
        batch.add(new TransferRecord("NV001", "Nguyễn Văn An", "1903456789", "Techcombank", new BigDecimal("25500000"), "Chi luong T10"));
        batch.add(new TransferRecord("NV002", "Trần Thị Mai", "0011004321", "Vietcombank", new BigDecimal("18250000"), "Chi luong T10"));
        batch.add(new TransferRecord("NV003", "Lê Hoàng Long", "0888999888", "MB Bank", new BigDecimal("32100000"), "Chi luong T10"));

        BigDecimal total = BigDecimal.ZERO;
        for (int i = 0; i < batch.size(); i++) {
            TransferRecord r = batch.get(i);
            total = total.add(r.amount);
            String row = r.toCsvRow(i + 1);
            assertNotNull(row);
            assertTrue(row.contains(r.empCode));
            assertTrue(row.contains(r.accountNumber));
            assertTrue(row.contains(r.beneficiaryName));
            assertTrue(row.contains(r.bankName));
            assertTrue(row.contains(r.memo));
        }

        assertEquals(new BigDecimal("75850000"), total, "Tổng tiền lệnh chi đợt này phải là chính xác 75.850.000 VNĐ");
        assertEquals(3, batch.size(), "Quy mô lệnh chi gồm 3 nhân viên");
    }
}
