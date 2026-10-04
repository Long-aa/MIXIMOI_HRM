package com.miximoi.hrm.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Properties;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Service gửi Email thông báo tự động (SMTP) qua Jakarta Mail & Angus Mail.
 * Vận hành bất đồng bộ (Async) thông qua Thread Pool để không làm nghẽn luồng xử lý HTTP request.
 */
public class EmailService {

    private static final String SMTP_HOST = resolveParam("SMTP_HOST", "smtp.host", "smtp.gmail.com");
    private static final String SMTP_PORT = resolveParam("SMTP_PORT", "smtp.port", "587");
    private static final String SMTP_USER = resolveParam("SMTP_USER", "smtp.user", "notification@miximoi.vn");
    private static final String SMTP_PASS = resolveParam("SMTP_PASSWORD", "smtp.password", "");
    private static final String FROM_NAME = resolveParam("SMTP_FROM_NAME", "smtp.from_name", "MIXIMOI HRM Portal");

    private static final ExecutorService EMAIL_EXECUTOR = Executors.newFixedThreadPool(3);

    private static String resolveParam(String envKey, String propKey, String defaultValue) {
        String val = System.getProperty(propKey);
        if (val != null && !val.trim().isEmpty()) return val.trim();
        val = System.getenv(envKey);
        if (val != null && !val.trim().isEmpty()) return val.trim();
        return defaultValue;
    }

    /**
     * Gửi email chung dạng HTML bất đồng bộ.
     */
    public static CompletableFuture<Boolean> sendHtmlEmailAsync(String toEmail, String subject, String htmlContent) {
        return CompletableFuture.supplyAsync(() -> sendHtmlEmail(toEmail, subject, htmlContent), EMAIL_EXECUTOR);
    }

    /**
     * Gửi email đồng bộ.
     */
    public static boolean sendHtmlEmail(String toEmail, String subject, String htmlContent) {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            return false;
        }

        // Nếu chưa cấu hình mật khẩu SMTP thật trong môi trường dev, log preview thông báo đẹp mắt
        if (SMTP_PASS == null || SMTP_PASS.trim().isEmpty()) {
            System.out.println("╔═══════════════════════════════════════════════════════════════════════╗");
            System.out.println("║ [SMTP DEV SIMULATION] Email đã sẵn sàng phát đi:                      ║");
            System.out.println("║ Đến:     " + toEmail);
            System.out.println("║ Tiêu đề: " + subject);
            System.out.println("║ (Đã thiết lập sẵn sàng: Để gửi mail thật, hãy đặt biến SMTP_PASSWORD)  ║");
            System.out.println("╚═══════════════════════════════════════════════════════════════════════╝");
            return true;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, FROM_NAME, "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[EmailService] Đã gửi thành công email tới " + toEmail + " [" + subject + "]");
            return true;
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            System.err.println("[EmailService] Lỗi gửi email tới " + toEmail + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * 1. Gửi thông báo phát hành Phiếu lương điện tử (E-Payslip)
     */
    public static void sendPayslipNotification(String recipientEmail, String employeeName, String monthYear, BigDecimal netSalary) {
        String formattedSalary = NumberFormat.getCurrencyInstance(new Locale("vi", "VN")).format(netSalary);
        String subject = "[MIXIMOI HRM] Thông báo phát hành Phiếu lương Kỳ " + monthYear;
        String html = """
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e2e8f0; border-radius: 8px;">
                <div style="background: #1d4ed8; color: #fff; padding: 16px; border-radius: 6px; text-align: center;">
                    <h2 style="margin: 0;">MIXIMOI HRM &amp; PAYROLL</h2>
                    <p style="margin: 4px 0 0 0; opacity: 0.9;">Hệ thống Quản trị Nhân sự &amp; Tiền lương Doanh nghiệp</p>
                </div>
                <div style="padding: 20px 0;">
                    <p>Kính gửi <strong>%s</strong>,</p>
                    <p>Phòng Kế toán &amp; Nhân sự xin thông báo: <strong>Phiếu lương kỳ %s</strong> của bạn đã được phê duyệt và phát hành chính thức trên Cổng thông tin nhân viên.</p>
                    <div style="background: #f8fafc; border-left: 4px solid #10b981; padding: 12px 16px; margin: 16px 0;">
                        <span style="color: #64748b; font-size: 13px;">Thực lĩnh chuyển khoản:</span><br/>
                        <strong style="color: #047857; font-size: 22px;">%s</strong>
                    </div>
                    <p style="color: #64748b; font-size: 13px;"><em>* Lưu ý: Để bảo mật thu nhập cá nhân, hệ thống sẽ yêu cầu nhập lại Mật khẩu tài khoản trước khi xem bảng kê chi tiết phụ cấp và thuế TNCN.</em></p>
                </div>
                <div style="text-align: center; border-top: 1px solid #e2e8f0; padding-top: 16px; color: #94a3b8; font-size: 12px;">
                    © 2026 MIXIMOI Corporation. Thư điện tử được tạo tự động từ hệ thống.
                </div>
            </div>
            """.formatted(employeeName, monthYear, formattedSalary);

        sendHtmlEmailAsync(recipientEmail, subject, html);
    }

    /**
     * 2. Gửi thư mời phỏng vấn ứng viên tuyển dụng
     */
    public static void sendInterviewInvitation(String candidateEmail, String candidateName, String jobTitle, String interviewTime, String locationOrLink) {
        String subject = "[MIXIMOI] Thư mời tham dự Phỏng vấn vị trí " + jobTitle;
        String html = """
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e2e8f0; border-radius: 8px;">
                <div style="background: #0f172a; color: #fff; padding: 16px; border-radius: 6px; text-align: center;">
                    <h2 style="margin: 0;">MIXIMOI TALENT ACQUISITION</h2>
                </div>
                <div style="padding: 20px 0;">
                    <p>Chào bạn <strong>%s</strong>,</p>
                    <p>Ban Tuyển dụng Công ty Cổ phần MIXIMOI rất ấn tượng với hồ sơ ứng tuyển của bạn cho vị trí <strong>%s</strong>.</p>
                    <p>Chúng tôi trân trọng mời bạn tham dự buổi phỏng vấn trực tiếp với Hội đồng chuyên môn:</p>
                    <ul style="background: #eff6ff; padding: 16px 30px; border-radius: 6px; color: #1e40af;">
                        <li><strong>Thời gian:</strong> %s</li>
                        <li><strong>Hình thức / Địa điểm:</strong> %s</li>
                    </ul>
                    <p>Vui lòng phản hồi email này để xác nhận sự có mặt của bạn.</p>
                </div>
                <div style="text-align: center; border-top: 1px solid #e2e8f0; padding-top: 16px; color: #94a3b8; font-size: 12px;">
                    Trân trọng,<br/>Phòng Nhân sự MIXIMOI.
                </div>
            </div>
            """.formatted(candidateName, jobTitle, interviewTime, locationOrLink);

        sendHtmlEmailAsync(candidateEmail, subject, html);
    }

    /**
     * 3. Gửi thông báo / cảnh báo khẩn cấp tới nhân viên
     */
    public static void sendBroadcastAlert(String recipientEmail, String employeeName, String title, String content) {
        String subject = "[THÔNG BÁO QUAN TRỌNG] " + title;
        String html = """
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #fecaca; border-radius: 8px; background: #fff;">
                <div style="background: #ef4444; color: #fff; padding: 14px; border-radius: 6px; text-align: center;">
                    <h3 style="margin: 0;">⚠️ THÔNG BÁO TỪ BAN GIÁM ĐỐC &amp; NHÂN SỰ</h3>
                </div>
                <div style="padding: 20px 0; color: #1e293b;">
                    <p>Kính gửi <strong>%s</strong>,</p>
                    <h4 style="color: #b91c1c; margin-top: 0;">%s</h4>
                    <div style="background: #fff1f2; border: 1px solid #fecdd3; padding: 14px; border-radius: 6px; line-height: 1.6;">
                        %s
                    </div>
                </div>
                <div style="border-top: 1px solid #e2e8f0; padding-top: 12px; color: #94a3b8; font-size: 12px; text-align: center;">
                    Hệ thống MIXIMOI HRM Portal — Mọi thắc mắc vui lòng liên hệ hr@miximoi.vn
                </div>
            </div>
            """.formatted(employeeName, title, content);

        sendHtmlEmailAsync(recipientEmail, subject, html);
    }
}
