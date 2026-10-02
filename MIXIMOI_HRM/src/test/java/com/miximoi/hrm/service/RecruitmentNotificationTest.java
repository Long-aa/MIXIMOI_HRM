package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.NotificationDAO;
import com.miximoi.hrm.dao.RecruitmentDAO;
import com.miximoi.hrm.model.Notification;
import com.miximoi.hrm.model.RecruitmentRequest;
import com.miximoi.hrm.util.DatabaseInitializer;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class RecruitmentNotificationTest {

    @BeforeAll
    public static void setup() {
        DatabaseInitializer.initialize();
    }

    @Test
    public void testRecentOpenRequests() {
        RecruitmentDAO recruitmentDAO = new RecruitmentDAO();
        List<RecruitmentRequest> recent = recruitmentDAO.findRecentOpenRequests(5);
        assertNotNull(recent);
        assertFalse(recent.isEmpty(), "Danh sách vị trí tuyển dụng vừa mở không được rỗng");
        for (RecruitmentRequest r : recent) {
            assertEquals("OPEN", r.getStatus());
            assertNotNull(r.getTitle());
            System.out.println("Vị trí vừa mở: [" + r.getRequestCode() + "] " + r.getTitle() + " - " + r.getDepartmentName());
        }
    }

    @Test
    public void testRecruitmentAnnouncements() {
        NotificationDAO notificationDAO = new NotificationDAO();
        List<Notification> notices = notificationDAO.findRecentRecruitmentAnnouncements(5);
        assertNotNull(notices);
        assertFalse(notices.isEmpty(), "Danh sách thông báo tuyển dụng không được rỗng");
        for (Notification n : notices) {
            assertTrue(n.isRecruitment());
            System.out.println("Thông báo: " + n.getTitle() + " (" + n.getTimeAgo() + ")");
        }
    }

    @Test
    public void testPublishRecruitmentAnnouncement() {
        RecruitmentService service = new RecruitmentService();
        RecruitmentRequest req = new RecruitmentRequest();
        req.setTitle("Senior AI Engineer (LLM / Python)");
        req.setRequestCode("YCTD-2026-TEST");
        req.setTargetHeadcount(2);
        req.setSalaryNegotiable(true);
        req.setDeadline(java.time.LocalDate.now().plusDays(20));

        boolean ok = service.publishRecruitmentAnnouncement(req, "Công nghệ AI & R&D");
        assertTrue(ok, "Phát thông báo tuyển dụng phải thành công");

        NotificationDAO notificationDAO = new NotificationDAO();
        List<Notification> list = notificationDAO.findRecent(null, 3);
        assertNotNull(list);
        boolean found = false;
        for (Notification n : list) {
            if (n.getTitle().contains("Senior AI Engineer")) {
                found = true;
                break;
            }
        }
        assertTrue(found, "Phải tìm thấy thông báo tuyển dụng vừa phát");
    }
}
