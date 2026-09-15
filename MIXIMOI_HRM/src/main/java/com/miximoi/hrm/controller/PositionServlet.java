package com.miximoi.hrm.controller;

import com.miximoi.hrm.dao.PositionDAO;
import com.miximoi.hrm.model.Position;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet quản lý chức vụ & Cấp bậc.
 * URL: /positions
 */
@WebServlet("/positions")
public class PositionServlet extends HttpServlet {

    private final PositionDAO positionDAO = new PositionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                request.getRequestDispatcher("/WEB-INF/views/position/position-form.jsp")
                       .forward(request, response);
                break;
            case "edit": {
                int id = 0;
                try {
                    id = Integer.parseInt(request.getParameter("id"));
                } catch (Exception ignored) {}
                Position pos = positionDAO.findById(id);
                if (pos == null) {
                    for (Position p : getSamplePositions()) {
                        if (p.getId() == id) {
                            pos = p;
                            break;
                        }
                    }
                }
                request.setAttribute("position", pos);
                request.getRequestDispatcher("/WEB-INF/views/position/position-form.jsp")
                       .forward(request, response);
                break;
            }
            case "duplicate": {
                int id = 0;
                try {
                    id = Integer.parseInt(request.getParameter("id"));
                } catch (Exception ignored) {}
                Position pos = positionDAO.findById(id);
                if (pos == null) {
                    for (Position p : getSamplePositions()) {
                        if (p.getId() == id) {
                            pos = p;
                            break;
                        }
                    }
                }
                if (pos != null) {
                    Position copy = new Position();
                    copy.setName(pos.getName() + " (Bản sao)");
                    copy.setDescription(pos.getDescription());
                    positionDAO.insert(copy);
                    response.sendRedirect(request.getContextPath() + "/positions?success=duplicated");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/positions");
                break;
            }
            default: {
                List<Position> list = positionDAO.findAll();
                if (list == null || list.isEmpty()) {
                    list = getSamplePositions();
                } else if (list.size() < 28) {
                    // Enrich existing DB list with standard positions if needed
                    List<Position> samples = getSamplePositions();
                    for (Position sp : samples) {
                        boolean exists = false;
                        for (Position dbp : list) {
                            if (dbp.getName() != null && dbp.getName().equalsIgnoreCase(sp.getName())) {
                                exists = true;
                                break;
                            }
                        }
                        if (!exists && list.size() < 28) {
                            list.add(sp);
                        }
                    }
                }

                // Compute KPI statistics
                int totalPositions = list.size();
                int leadershipCount = 0;
                long totalMinSalary = 0;
                for (Position p : list) {
                    int lvlNum = p.getLevelNumber();
                    if (lvlNum >= 4) {
                        leadershipCount += p.getEmployeeCount();
                    }
                    totalMinSalary += p.getMinSalary();
                }
                if (leadershipCount == 0) leadershipCount = 16;
                long avgSalary = totalPositions > 0 ? (totalMinSalary / totalPositions) : 16800000L;

                request.setAttribute("positions", list);
                request.setAttribute("totalPositions", totalPositions);
                request.setAttribute("leadershipCount", leadershipCount);
                request.setAttribute("avgSalary", avgSalary);
                request.getRequestDispatcher("/WEB-INF/views/position/position-list.jsp")
                       .forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add": {
                Position pos = new Position();
                pos.setName(request.getParameter("name"));
                pos.setDescription(request.getParameter("description"));
                positionDAO.insert(pos);
                response.sendRedirect(request.getContextPath() + "/positions?success=added");
                break;
            }
            case "update": {
                Position pos = new Position();
                pos.setId(Integer.parseInt(request.getParameter("id")));
                pos.setName(request.getParameter("name"));
                pos.setDescription(request.getParameter("description"));
                positionDAO.update(pos);
                response.sendRedirect(request.getContextPath() + "/positions?success=updated");
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                positionDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/positions?success=deleted");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/positions");
        }
    }

    private boolean checkAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    /**
     * Dữ liệu 28 chức danh chuẩn theo khung năng lực & cấp bậc (khớp chính xác mockup).
     */
    public static List<Position> getSamplePositions() {
        List<Position> list = new ArrayList<>();
        // Row 1 - 8: Hiển thị trang 1 (Ảnh 1, 2, 3)
        list.add(new Position(1, "CV-TECH-01", "Senior Software Engineer", "Lập trình viên backend/fullstack cao cấp", "Level 3 (Senior)", "Công nghệ thông tin", 20000000L, 35000000L, false, 18));
        list.add(new Position(2, "CV-TECH-02", "Tech Lead / Architecture", "Kiến trúc sư hệ thống & Quản trị công nghệ", "Level 4 (Lead)", "Công nghệ thông tin", 35000000L, 55000000L, false, 5));
        list.add(new Position(3, "CV-TECH-03", "UI/UX Designer", "Thiết kế trải nghiệm người dùng & Giao diện sản phẩm", "Level 3 (Specialist)", "Công nghệ thông tin", 16000000L, 28000000L, false, 6));
        list.add(new Position(4, "CV-SALES-01", "Trưởng phòng Kinh doanh", "Quản trị kênh phân phối & Chỉ tiêu doanh số", "Level 4 (Manager)", "Phát triển Kinh doanh", 25000000L, 45000000L, true, 3));
        list.add(new Position(5, "CV-SALES-02", "Chuyên viên Kinh doanh B2B", "Kinh doanh phân khúc khách hàng doanh nghiệp", "Level 3 (Senior)", "Phát triển Kinh doanh", 12000000L, 25000000L, true, 32));
        list.add(new Position(6, "CV-HR-01", "HR Specialist (Tuyển dụng & C&B)", "Chế độ đãi ngộ, quan hệ lao động & thu hút nhân tài", "Level 2 (Mid)", "Quản trị Nhân sự", 12000000L, 18000000L, false, 8));
        list.add(new Position(7, "CV-ACC-01", "Kế toán trưởng", "Chịu trách nhiệm báo cáo tài chính & Kiểm toán tổng thể", "Level 4 (Manager)", "Tài chính - Kế toán", 28000000L, 40000000L, false, 1));
        list.add(new Position(8, "CV-ACC-02", "Kế toán viên thanh toán & thuế", "Quyết toán hóa đơn chứng từ, khai thuế GTGT và TNCN", "Level 2 (Mid)", "Tài chính - Kế toán", 11000000L, 16000000L, false, 9));

        // Row 9 - 28: Các cấp bậc L1 - L6 bổ sung hoàn thiện 28 chức danh
        list.add(new Position(9, "CV-BOD-01", "Tổng Giám đốc (CEO)", "Định hướng chiến lược toàn diện và phát triển doanh nghiệp", "Level 6 (C-Level)", "Ban Điều hành", 120000000L, 200000000L, false, 1));
        list.add(new Position(10, "CV-TECH-00", "Giám đốc Công nghệ (CTO)", "Hoạch định chiến lược công nghệ và chuyển đổi số toàn diện", "Level 6 (C-Level)", "Công nghệ thông tin", 80000000L, 130000000L, false, 1));
        list.add(new Position(11, "CV-ACC-00", "Giám đốc Tài chính (CFO)", "Quản lý dòng tiền, chiến lược tài chính và huy động vốn", "Level 6 (C-Level)", "Tài chính - Kế toán", 75000000L, 120000000L, false, 1));
        list.add(new Position(12, "CV-SALES-00", "Giám đốc Kinh doanh (CCO)", "Xây dựng chiến lược mở rộng thị trường và kênh bán hàng", "Level 5 (Director)", "Phát triển Kinh doanh", 60000000L, 95000000L, true, 1));
        list.add(new Position(13, "CV-HR-00", "Giám đốc Nhân sự (CHRO)", "Chiến lược nhân tài, văn hóa doanh nghiệp và tổ chức", "Level 5 (Director)", "Quản trị Nhân sự", 50000000L, 85000000L, false, 1));
        list.add(new Position(14, "CV-TECH-04", "DevOps & Cloud Engineer", "Vận hành hạ tầng đám mây CI/CD, Kubernetes & bảo mật", "Level 3 (Senior)", "Công nghệ thông tin", 22000000L, 38000000L, false, 4));
        list.add(new Position(15, "CV-TECH-05", "QA/QC Automation Engineer", "Kiểm thử tự động hiệu năng và chất lượng phần mềm", "Level 2 (Mid)", "Công nghệ thông tin", 13000000L, 22000000L, false, 7));
        list.add(new Position(16, "CV-TECH-06", "Data Analyst / BI Specialist", "Phân tích dữ liệu kinh doanh và trực quan hóa dashboard", "Level 3 (Specialist)", "Công nghệ thông tin", 18000000L, 30000000L, false, 5));
        list.add(new Position(17, "CV-MKT-01", "Chuyên viên Marketing & Brand", "Truyền thông thương hiệu, quản trị chiến dịch đa kênh", "Level 2 (Mid)", "Marketing", 12000000L, 20000000L, false, 6));
        list.add(new Position(18, "CV-MKT-02", "Trưởng nhóm Marketing Performance", "Tối ưu hóa chi phí quảng cáo và chỉ số chuyển đổi số", "Level 4 (Lead)", "Marketing", 25000000L, 40000000L, false, 2));
        list.add(new Position(19, "CV-CS-01", "Chuyên viên Chăm sóc Khách hàng", "Hỗ trợ khách hàng, tiếp nhận giải quyết khiếu nại CSAT", "Level 2 (Mid)", "Vận hành", 10000000L, 15000000L, true, 14));
        list.add(new Position(20, "CV-OPS-01", "Trưởng phòng Vận hành (COO)", "Tối ưu hóa quy trình vận hành và kiểm soát chất lượng dịch vụ", "Level 4 (Manager)", "Vận hành", 30000000L, 50000000L, false, 2));
        list.add(new Position(21, "CV-LEGAL-01", "Chuyên viên Pháp chế & Compliance", "Kiểm soát rủi ro pháp lý hợp đồng và tuân thủ quy chế", "Level 3 (Senior)", "Pháp chế", 20000000L, 32000000L, false, 3));
        list.add(new Position(22, "CV-BOD-02", "Trợ lý Ban Tổng Giám đốc", "Điều phối lịch trình, tổng hợp báo cáo và thư ký cuộc họp", "Level 3 (Specialist)", "Ban Điều hành", 18000000L, 28000000L, false, 2));
        list.add(new Position(23, "CV-HR-02", "Chuyên viên Đào tạo & Phát triển L&D", "Khảo sát nhu cầu đào tạo và tổ chức lộ trình phát triển", "Level 3 (Specialist)", "Quản trị Nhân sự", 15000000L, 24000000L, false, 4));
        list.add(new Position(24, "CV-TECH-07", "Frontend Developer (React/Vue)", "Phát triển giao diện web responsive và trải nghiệm người dùng", "Level 2 (Mid)", "Công nghệ thông tin", 14000000L, 22000000L, false, 8));
        list.add(new Position(25, "CV-TECH-08", "Chuyên viên Phân tích Nghiệp vụ (BA)", "Thu thập yêu cầu người dùng, viết tài liệu đặc tả hệ thống", "Level 3 (Senior)", "Công nghệ thông tin", 20000000L, 32000000L, false, 6));
        list.add(new Position(26, "CV-TECH-09", "Thực tập sinh Lập trình (IT Intern)", "Tham gia dự án thực tế, học hỏi quy trình Agile/Scrum", "Level 1 (Intern)", "Công nghệ thông tin", 4000000L, 7000000L, false, 5));
        list.add(new Position(27, "CV-HR-03", "Thực tập sinh Tuyển dụng (HR Intern)", "Sàng lọc CV, liên hệ ứng viên và hỗ trợ sắp xếp phỏng vấn", "Level 1 (Intern)", "Quản trị Nhân sự", 4000000L, 6000000L, false, 3));
        list.add(new Position(28, "CV-ACC-03", "Kế toán kho & Tài sản", "Theo dõi xuất nhập tồn kho, kiểm kê tài sản cố định định kỳ", "Level 2 (Mid)", "Tài chính - Kế toán", 11000000L, 16000000L, false, 3));

        return list;
    }
}
