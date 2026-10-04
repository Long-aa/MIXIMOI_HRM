package com.miximoi.hrm.util;

import com.lowagie.text.*;
import com.lowagie.text.Font;
import com.lowagie.text.pdf.*;
import com.miximoi.hrm.model.Contract;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Payroll;

import java.awt.Color;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Tiện ích xuất văn bản định dạng PDF chuẩn doanh nghiệp sử dụng OpenPDF.
 * Hỗ trợ xuất Phiếu lương điện tử (E-Payslip) và Hợp đồng lao động tiêu chuẩn A4.
 */
public class PdfExportUtil {

    private static final NumberFormat CURRENCY_FORMAT = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private static Font getFont(float size, int style, Color color) {
        return FontFactory.getFont(FontFactory.HELVETICA, size, style, color);
    }

    /**
     * 1. Xuất file PDF Phiếu lương chi tiết (Payslip PDF)
     */
    public static void generatePayslipPdf(Payroll p, OutputStream out) throws DocumentException {
        try (Document document = new Document(PageSize.A4, 40, 40, 40, 40)) {
            PdfWriter.getInstance(document, out);
            document.open();

        // 1. Header Công ty
        Paragraph companyName = new Paragraph("CÔNG TY CỔ PHẦN CÔNG NGHỆ MIXIMOI", getFont(14, Font.BOLD, new Color(29, 78, 216)));
        Paragraph companyAddr = new Paragraph("Tòa nhà MixiMoi Tower, Phố Triều Khúc, Thanh Xuân, Hà Nội | Hotline: 1900 6868", getFont(9, Font.NORMAL, Color.GRAY));
        document.add(companyName);
        document.add(companyAddr);
        document.add(new Paragraph(" "));

        // 2. Tiêu đề Phiếu lương
        Paragraph title = new Paragraph("PHIẾU LƯƠNG ĐIỆN TỬ (E-PAYSLIP)", getFont(16, Font.BOLD, new Color(15, 23, 42)));
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);

        Paragraph period = new Paragraph("Kỳ trả lương: Tháng " + p.getPayMonth() + " / " + p.getPayYear(), getFont(11, Font.ITALIC, new Color(71, 85, 105)));
        period.setAlignment(Element.ALIGN_CENTER);
        document.add(period);
        document.add(new Paragraph(" "));

        // 3. Thông tin nhân sự (Table 2 cột)
        PdfPTable empTable = new PdfPTable(2);
        empTable.setWidthPercentage(100);
        empTable.setSpacingBefore(10f);
        empTable.setSpacingAfter(15f);

        addCell(empTable, "Mã nhân viên: " + safe(p.getEmployeeCode()), false);
        addCell(empTable, "Họ và tên: " + safe(p.getEmployeeName()), false);
        addCell(empTable, "Phòng ban: " + safe(p.getDepartmentName()), false);
        addCell(empTable, "Chức vụ: " + safe(p.getPositionName()), false);
        addCell(empTable, "Số tài khoản: " + (p.getBankAccount() != null ? p.getBankAccount() : "Chưa cập nhật"), false);
        addCell(empTable, "Ngân hàng: " + (p.getBankName() != null ? p.getBankName() : "Hệ thống nội bộ"), false);
        document.add(empTable);

        // 4. Bảng chi tiết lương & thu nhập
        PdfPTable payTable = new PdfPTable(3);
        payTable.setWidthPercentage(100);
        payTable.setWidths(new float[]{1, 5, 3});

        addHeaderCell(payTable, "STT");
        addHeaderCell(payTable, "Khoản mục thu nhập / Khấu trừ");
        addHeaderCell(payTable, "Số tiền (VNĐ)");

        int stt = 1;
        addRow(payTable, stt++, "Lương thỏa thuận / Cơ bản", formatMoney(p.getBaseSalary()), false);
        addRow(payTable, stt++, "Ngày công thực tế / Chuẩn tháng", p.getWorkingDays() + " / " + p.getStandardDays() + " ngày", false);
        addRow(payTable, stt++, "Tiền làm thêm giờ (Overtime)", formatMoney(p.getOvertimeAmount()), false);
        addRow(payTable, stt++, "Tổng phụ cấp (Ăn trưa, Xăng xe, Trách nhiệm)", formatMoney(p.getAllowance()), false);
        addRow(payTable, stt++, "Tiền thưởng hiệu suất & Thưởng nóng", formatMoney(p.getBonus()), false);

        // Khấu trừ
        addRow(payTable, stt++, "Khấu trừ Bảo hiểm bắt buộc (BHXH 8%, BHYT 1.5%, BHTN 1%)", 
                "-" + formatMoney(p.getBhxhAmount() != null ? p.getBhxhAmount().add(p.getBhytAmount() != null ? p.getBhytAmount() : BigDecimal.ZERO) : BigDecimal.ZERO), true);
        addRow(payTable, stt++, "Khấu trừ Thuế thu nhập cá nhân (TNCN)", "-" + formatMoney(p.getTncnTax()), true);
        addRow(payTable, stt++, "Các khoản giảm trừ / Tạm ứng khác", "-" + formatMoney(p.getDeduction()), true);

        // Tổng thực lĩnh
        PdfPCell totalLabel = new PdfPCell(new Phrase("THỰC LĨNH CHUYỂN KHOẢN (NET SALARY):", getFont(11, Font.BOLD, Color.WHITE)));
        totalLabel.setColspan(2);
        totalLabel.setBackgroundColor(new Color(29, 78, 216));
        totalLabel.setPadding(8);
        payTable.addCell(totalLabel);

        PdfPCell totalVal = new PdfPCell(new Phrase(formatMoney(p.getNetSalary()), getFont(12, Font.BOLD, Color.WHITE)));
        totalVal.setBackgroundColor(new Color(29, 78, 216));
        totalVal.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalVal.setPadding(8);
        payTable.addCell(totalVal);

        document.add(payTable);
        document.add(new Paragraph(" "));

        // 5. Chữ ký xác nhận (3 bên)
        PdfPTable signTable = new PdfPTable(3);
        signTable.setWidthPercentage(100);
        signTable.setSpacingBefore(20f);

        addSignCell(signTable, "Người lập phiếu", "(Ký và ghi rõ họ tên)");
        addSignCell(signTable, "Kế toán trưởng", "(Ký và ghi rõ họ tên)");
        addSignCell(signTable, "Người nhận lương", "(Đã ký điện tử)");
        document.add(signTable);
        }
    }

    /**
     * 2. Xuất file PDF Hợp đồng lao động chuẩn A4 (Contract PDF)
     */
    public static void generateContractPdf(Contract c, Employee emp, OutputStream out) throws DocumentException {
        try (Document document = new Document(PageSize.A4, 45, 45, 40, 40)) {
            PdfWriter.getInstance(document, out);
            document.open();

        // 1. Quốc hiệu tiêu ngữ
        Paragraph national = new Paragraph("CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM", getFont(11, Font.BOLD, Color.BLACK));
        national.setAlignment(Element.ALIGN_CENTER);
        document.add(national);

        Paragraph motto = new Paragraph("Độc lập - Tự do - Hạnh phúc", getFont(11, Font.BOLD, Color.BLACK));
        motto.setAlignment(Element.ALIGN_CENTER);
        document.add(motto);

        Paragraph dash = new Paragraph("-----------------o0o-----------------", getFont(9, Font.NORMAL, Color.GRAY));
        dash.setAlignment(Element.ALIGN_CENTER);
        document.add(dash);
        document.add(new Paragraph(" "));

        // 2. Tiêu đề Hợp đồng
        Paragraph title = new Paragraph("HỢP ĐỒNG LAO ĐỘNG", getFont(15, Font.BOLD, new Color(15, 23, 42)));
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);

        Paragraph code = new Paragraph("Số: " + safe(c.getContractCode()) + "/HĐLĐ-MIXIMOI", getFont(10, Font.ITALIC, Color.DARK_GRAY));
        code.setAlignment(Element.ALIGN_CENTER);
        document.add(code);
        document.add(new Paragraph(" "));

        // 3. Nội dung điều khoản
        Paragraph pIntro = new Paragraph("Hôm nay, ngày " + (c.getSignedDate() != null ? c.getSignedDate().format(DATE_FORMAT) : LocalDate.now().format(DATE_FORMAT)) + ", chúng tôi gồm:", getFont(10, Font.NORMAL, Color.BLACK));
        document.add(pIntro);
        document.add(new Paragraph(" "));

        // Bên A
        Paragraph benA = new Paragraph("BÊN A (NGƯỜI SỬ DỤNG LAO ĐỘNG): CÔNG TY CỔ PHẦN CÔNG NGHỆ MIXIMOI", getFont(10, Font.BOLD, Color.BLACK));
        document.add(benA);
        document.add(new Paragraph("• Đại diện bởi: " + (c.getSignerName() != null ? c.getSignerName() : "Đặng Vũ Hải Duy") + " — Chức vụ: " + (c.getSignerTitle() != null ? c.getSignerTitle() : "Giám đốc Nhân sự"), getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph("• Địa chỉ trụ sở: Tòa nhà MixiMoi Tower, Phố Triều Khúc, Thanh Xuân, Hà Nội", getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph(" "));

        // Bên B
        Paragraph benB = new Paragraph("BÊN B (NGƯỜI LAO ĐỘNG): " + (emp != null ? safe(emp.getFullName()).toUpperCase() : safe(c.getEmployeeName()).toUpperCase()), getFont(10, Font.BOLD, Color.BLACK));
        document.add(benB);
        document.add(new Paragraph("• Ngày sinh: " + (emp != null && emp.getDateOfBirth() != null ? emp.getDateOfBirth().format(DATE_FORMAT) : "N/A"), getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph("• Số CCCD/CMND: " + (c.getIdentityNumber() != null ? c.getIdentityNumber() : (emp != null ? safe(emp.getIdentityNumber()) : "N/A")), getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph("• Chức danh công tác: " + (emp != null && emp.getPositionName() != null ? emp.getPositionName() : "Chuyên viên"), getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph("• Phòng ban làm việc: " + safe(c.getDepartmentName()), getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph(" "));

        // Điều khoản chính
        document.add(new Paragraph("ĐIỀU 1: THỜI HẠN VÀ CÔNG VIỆC HỢP ĐỒNG", getFont(10, Font.BOLD, new Color(29, 78, 216))));
        document.add(new Paragraph("• Loại hợp đồng: " + safe(c.getContractType()) + " — Bắt đầu từ: " + (c.getStartDate() != null ? c.getStartDate().format(DATE_FORMAT) : "N/A") + (c.getEndDate() != null ? " đến ngày: " + c.getEndDate().format(DATE_FORMAT) : " (Không xác định thời hạn)"), getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph("• Địa điểm làm việc: " + (c.getWorkLocation() != null ? c.getWorkLocation() : "Trụ sở chính Công ty MixiMoi"), getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph(" "));

        document.add(new Paragraph("ĐIỀU 2: CHẾ ĐỘ TIỀN LƯƠNG VÀ ĐÃI NGỘ", getFont(10, Font.BOLD, new Color(29, 78, 216))));
        document.add(new Paragraph("• Mức lương chính: " + formatMoney(c.getBaseSalary()) + " / tháng.", getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph("• Phụ cấp đãi ngộ: " + formatMoney(c.getAllowanceAmount() != null ? c.getAllowanceAmount() : BigDecimal.ZERO) + " / tháng.", getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph("• Hình thức trả lương: Chuyển khoản qua tài khoản Ngân hàng vào ngày 05 hàng tháng.", getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph("• Chế độ BHXH, BHYT, BHTN: Đóng đầy đủ theo quy định của Luật Bảo hiểm xã hội hiện hành.", getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph(" "));

        document.add(new Paragraph("ĐIỀU 3: ĐIỀU KHOẢN THI HÀNH", getFont(10, Font.BOLD, new Color(29, 78, 216))));
        document.add(new Paragraph("Hợp đồng này được lập thành 02 bản có giá trị pháp lý như nhau, mỗi bên giữ 01 bản để thực hiện.", getFont(9, Font.NORMAL, Color.BLACK)));
        document.add(new Paragraph(" "));

        // Chữ ký 2 bên
        PdfPTable signTable = new PdfPTable(2);
        signTable.setWidthPercentage(100);
        signTable.setSpacingBefore(15f);

        addSignCell(signTable, "ĐẠI DIỆN NGƯỜI SỬ DỤNG LAO ĐỘNG", "(Ký tên, đóng dấu)");
        addSignCell(signTable, "NGƯỜI LAO ĐỘNG", "(Ký và ghi rõ họ tên)");
        document.add(signTable);
        }
    }

    // ===== Helper Formatting Methods =====

    private static void addHeaderCell(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, getFont(9, Font.BOLD, Color.WHITE)));
        cell.setBackgroundColor(new Color(30, 41, 59));
        cell.setPadding(6);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(cell);
    }

    private static void addRow(PdfPTable table, int stt, String item, String amount, boolean isDeduction) {
        PdfPCell c1 = new PdfPCell(new Phrase(String.valueOf(stt), getFont(9, Font.NORMAL, Color.BLACK)));
        c1.setHorizontalAlignment(Element.ALIGN_CENTER);
        c1.setPadding(5);

        PdfPCell c2 = new PdfPCell(new Phrase(item, getFont(9, Font.NORMAL, Color.BLACK)));
        c2.setPadding(5);

        Color valColor = isDeduction ? new Color(185, 28, 28) : Color.BLACK;
        PdfPCell c3 = new PdfPCell(new Phrase(amount, getFont(9, Font.BOLD, valColor)));
        c3.setHorizontalAlignment(Element.ALIGN_RIGHT);
        c3.setPadding(5);

        table.addCell(c1);
        table.addCell(c2);
        table.addCell(c3);
    }

    private static void addCell(PdfPTable table, String text, boolean isHeader) {
        PdfPCell cell = new PdfPCell(new Phrase(text, getFont(9, isHeader ? Font.BOLD : Font.NORMAL, Color.BLACK)));
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPadding(3);
        table.addCell(cell);
    }

    private static void addSignCell(PdfPTable table, String title, String sub) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        Paragraph p1 = new Paragraph(title, getFont(10, Font.BOLD, Color.BLACK));
        p1.setAlignment(Element.ALIGN_CENTER);
        Paragraph p2 = new Paragraph(sub, getFont(8, Font.ITALIC, Color.GRAY));
        p2.setAlignment(Element.ALIGN_CENTER);
        Paragraph space = new Paragraph("\n\n\n", getFont(8, Font.NORMAL, Color.WHITE));
        cell.addElement(p1);
        cell.addElement(p2);
        cell.addElement(space);
        table.addCell(cell);
    }

    private static String formatMoney(BigDecimal amount) {
        if (amount == null) return "0 ₫";
        return CURRENCY_FORMAT.format(amount);
    }

    private static String safe(String s) {
        return s != null ? s : "";
    }
}
