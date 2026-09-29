package com.miximoi.hrm.listener;

import com.miximoi.hrm.util.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

/**
 * Scheduler quet Hop dong sap het han va tao Notification vao DB.
 *
 * Co che:
 *  - Chay 1 lan khi ung dung khoi dong (contextInitialized)
 *  - Sau do chay lap lai moi 24 gio (fixed-rate)
 *  - Tu dong tat scheduler khi ung dung shutdown (contextDestroyed)
 *
 * Hop dong "sap het han" = het han trong vong WARN_DAYS_BEFORE ngay tiep theo.
 *
 * Luong xu ly (Background Thread - khong lam cham Tomcat):
 *   ScheduledExecutorService -> checkAndNotifyExpiringContracts()
 *     -> Query PostgreSQL tim hop dong sap het han
 *     -> Insert thong bao vao bang notifications
 */
@WebListener
public class ContractExpiryListener implements ServletContextListener {

    /** So ngay truoc khi het han thi gui canh bao */
    private static final int WARN_DAYS_BEFORE = 30;

    /** Khoang cach giua cac lan chay (1 ngay = 24 gio) */
    private static final long SCHEDULE_INTERVAL_HOURS = 24;

    /** Delay truoc lan chay dau tien (0 = chay ngay khi start) */
    private static final long INITIAL_DELAY_SECONDS = 0;

    /** ScheduledExecutorService - xu ly tac vu nen, 1 thread la du */
    private ScheduledExecutorService scheduler;

    /** Tham chieu den task dang chay - can de huy khi shutdown */
    private ScheduledFuture<?> scheduledTask;

    // =========================================================================
    //  ServletContextListener Lifecycle
    // =========================================================================

    /**
     * Chay khi Tomcat khoi dong ung dung.
     * Khoi tao ScheduledExecutorService va dang ky task quet hop dong.
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[ContractExpiryListener] Khoi dong scheduler quet hop dong het han...");

        // Tao single-thread scheduler voi ten ro rang (de debug trong thread dump)
        scheduler = Executors.newSingleThreadScheduledExecutor(runnable -> {
            Thread thread = new Thread(runnable, "ContractExpiry-Scheduler");
            thread.setDaemon(true);  // Daemon thread: JVM co the thoat ma khong can cho thread nay
            return thread;
        });

        // Dang ky task: chay ngay, sau do lap lai moi 24 gio
        scheduledTask = scheduler.scheduleAtFixedRate(
                this::checkAndNotifyExpiringContracts,  // Task can thuc thi
                INITIAL_DELAY_SECONDS,                  // Delay truoc lan dau
                SCHEDULE_INTERVAL_HOURS,                // Khoang cach giua cac lan
                TimeUnit.HOURS
        );

        System.out.println("[ContractExpiryListener] Scheduler da khoi dong. "
                + "Chay ngay va sau do moi " + SCHEDULE_INTERVAL_HOURS + " gio.");
    }

    /**
     * Chay khi Tomcat shutdown ung dung.
     * Huy tac vu nen va giai phong thread pool de tranh memory/thread leak.
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[ContractExpiryListener] Dang tat scheduler...");

        // Huy task truoc de khong start them lan chay moi
        if (scheduledTask != null && !scheduledTask.isCancelled()) {
            scheduledTask.cancel(false);  // false = cho lan chay hien tai ket thuc roi moi cancel
        }

        if (scheduler != null) {
            scheduler.shutdown();  // Tat scheduler, cho cac task dang chay ket thuc
            try {
                // Cho toi da 10 giay de cac task hoan thanh
                if (!scheduler.awaitTermination(10, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();  // Ep buoc tat neu con dang chay sau 10s
                    System.err.println("[ContractExpiryListener] Scheduler bi ep tat (shutdownNow).");
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                Thread.currentThread().interrupt();  // Restore interrupted status
            }
        }

        System.out.println("[ContractExpiryListener] Scheduler da tat thanh cong.");
    }

    // =========================================================================
    //  Core Task: Quet hop dong sap het han va tao Notification
    // =========================================================================

    /**
     * Tac vu chinh chay nen moi 24 gio.
     * Quet cac hop dong sap het han trong WARN_DAYS_BEFORE ngay toi.
     * Voi moi hop dong tim duoc: tao thong bao cho nhan vien va HR.
     *
     * Su dung try-with-resources de dam bao Connection/Statement/ResultSet
     * luon duoc dong du co loi hay khong.
     */
    private void checkAndNotifyExpiringContracts() {
        LocalDate today      = LocalDate.now();
        LocalDate warnBefore = today.plusDays(WARN_DAYS_BEFORE);

        System.out.println("[ContractExpiryListener] [" + today + "] "
                + "Bat dau quet hop dong het han truoc " + warnBefore + "...");

        // SQL: Tim cac hop dong ACTIVE het han trong khoang (today, warnBefore]
        // va chua co thong bao trong ngay hom nay (tranh tao thong bao trung lap)
        String querySql =
              "SELECT c.id                AS contract_id,  "
            + "       c.employee_id,                       "
            + "       e.full_name         AS employee_name,"
            + "       e.employee_code,                     "
            + "       c.end_date,                          "
            + "       (c.end_date - CURRENT_DATE) AS days_remaining "
            + "FROM contracts c                            "
            + "JOIN employees e ON e.id = c.employee_id   "
            + "WHERE c.status = 'ACTIVE'                  "
            + "  AND c.end_date IS NOT NULL                "
            + "  AND c.end_date > CURRENT_DATE             "
            + "  AND c.end_date <= ?                       "
            + "  AND NOT EXISTS (                          "
            + "      SELECT 1 FROM notifications n         "
            + "      WHERE n.reference_id = c.id          "
            + "        AND n.reference_type = 'CONTRACT_EXPIRY' "
            + "        AND n.created_at::date = CURRENT_DATE    "
            + "  )";

        // Dung try-with-resources: Connection, PreparedStatement, ResultSet
        // tu dong dong dung thu tu: rs -> ps -> conn
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(querySql)) {

            ps.setDate(1, java.sql.Date.valueOf(warnBefore));

            try (ResultSet rs = ps.executeQuery()) {
                int notifiedCount = 0;

                while (rs.next()) {
                    int    contractId     = rs.getInt("contract_id");
                    int    employeeId     = rs.getInt("employee_id");
                    String employeeName   = rs.getString("employee_name");
                    String employeeCode   = rs.getString("employee_code");
                    LocalDate endDate     = rs.getDate("end_date").toLocalDate();
                    int    daysRemaining  = rs.getInt("days_remaining");

                    // Tao thong bao cho nhan vien va phong HR
                    String message = String.format(
                            "Hop dong cua nhan vien %s (%s) se het han vao %s (con %d ngay). "
                          + "Vui long lien he HR de gia han hoac ky hop dong moi.",
                            employeeName, employeeCode, endDate, daysRemaining
                    );

                    // Insert notification cho nhan vien
                    insertNotification(conn, employeeId, "CONTRACT_EXPIRY",
                                       "Hop dong sap het han", message, contractId);

                    // Insert notification cho tat ca HR (role_id = 2)
                    notifyHrUsers(conn, contractId, employeeId,
                                  "Hop dong sap het han - " + employeeName, message);

                    notifiedCount++;
                    System.out.println("[ContractExpiryListener] Da tao thong bao cho: "
                            + employeeCode + " - " + employeeName
                            + " (con " + daysRemaining + " ngay)");
                }

                System.out.println("[ContractExpiryListener] Ket qua: Tao " + notifiedCount
                        + " thong bao het han hop dong.");
            }

        } catch (SQLException e) {
            // Log loi nhung KHONG nem exception ra ngoai.
            // Neu nem ra ngoai, ScheduledExecutorService se HUY task cho lan sau!
            System.err.println("[ContractExpiryListener] Loi quet hop dong het han: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            // Bat moi Exception khac (NullPointer, v.v.) de bao ve scheduler
            System.err.println("[ContractExpiryListener] Loi khong mong doi: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // =========================================================================
    //  Private: DB helpers
    // =========================================================================

    /**
     * Insert 1 ban ghi thong bao vao bang notifications.
     * Su dung Connection trong cung session - khong tao Connection moi.
     *
     * @param conn          Connection dang dung trong task
     * @param recipientId   ID nguoi nhan thong bao (employee_id)
     * @param referenceType Loai doi tuong tham chieu (e.g. "CONTRACT_EXPIRY")
     * @param title         Tieu de thong bao
     * @param message       Noi dung day du
     * @param referenceId   ID doi tuong tham chieu (contract_id)
     */
    private void insertNotification(Connection conn, int recipientId,
                                    String referenceType, String title,
                                    String message, int referenceId) throws SQLException {
        String sql = "INSERT INTO notifications "
                   + "(recipient_id, title, message, reference_type, reference_id, is_read, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, false, CURRENT_TIMESTAMP)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recipientId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setString(4, referenceType);
            ps.setInt(5, referenceId);
            ps.executeUpdate();
        }
    }

    /**
     * Tao thong bao cho tat ca nhan vien co vai tro HR (role_id = 2).
     * Giup HR biet truoc de chuan bi tai lieu gia han hop dong.
     */
    private void notifyHrUsers(Connection conn, int contractId, int employeeId,
                                String title, String message) throws SQLException {
        // Lay tat ca HR user de gui thong bao
        String hrUsersSql =
                "SELECT u.employee_id FROM users u "
              + "JOIN roles r ON u.role_id = r.id "
              + "WHERE r.name = 'HR' AND u.status = 'ACTIVE' "
              + "  AND u.employee_id IS NOT NULL "
              + "  AND u.employee_id != ?";  // Khong gui cho chinh nhan vien do

        try (PreparedStatement ps = conn.prepareStatement(hrUsersSql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int hrEmployeeId = rs.getInt("employee_id");
                    insertNotification(conn, hrEmployeeId, "CONTRACT_EXPIRY",
                                       title, message, contractId);
                }
            }
        }
    }
}
