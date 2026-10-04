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
import java.util.stream.Collectors;

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
            case "new" -> request.getRequestDispatcher("/WEB-INF/views/position/position-form.jsp")
                       .forward(request, response);
            case "edit" -> {
                int id = 0;
                try {
                    id = Integer.parseInt(request.getParameter("id"));
                } catch (NumberFormatException ignored) {}
                Position pos = positionDAO.findById(id);
                request.setAttribute("position", pos);
                request.getRequestDispatcher("/WEB-INF/views/position/position-form.jsp")
                       .forward(request, response);
            }
            case "duplicate" -> {
                int id = 0;
                try {
                    id = Integer.parseInt(request.getParameter("id"));
                } catch (NumberFormatException ignored) {}
                Position pos = positionDAO.findById(id);
                if (pos != null) {
                    Position copy = new Position();
                    copy.setName(pos.getName() + " (Bản sao)");
                    copy.setDescription(pos.getDescription());
                    positionDAO.insert(copy);
                    response.sendRedirect(request.getContextPath() + "/positions?success=duplicated");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/positions");
            }
            default -> {
                List<Position> allList = positionDAO.findAll();
                if (allList == null) {
                    allList = new ArrayList<>();
                }

                // Keyword search
                String keyword = request.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    String kw = keyword.trim().toLowerCase();
                    allList = allList.stream()
                            .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(kw))
                                      || (p.getCode() != null && p.getCode().toLowerCase().contains(kw))
                                      || (p.getLevel() != null && p.getLevel().toLowerCase().contains(kw))
                                      || (p.getDepartmentName() != null && p.getDepartmentName().toLowerCase().contains(kw)))
                            .collect(Collectors.toList());
                }

                // Compute KPI statistics (from full list)
                int totalPositions = allList.size();
                int leadershipCount = 0;
                int totalCompanyEmployees = 0;
                long totalMinSalary = 0;
                java.util.Map<String, Integer> levelMap = new java.util.LinkedHashMap<>();
                for (Position p : allList) {
                    int empCnt = p.getEmployeeCount();
                    totalCompanyEmployees += empCnt;
                    int lvlNum = p.getLevelNumber();
                    if (lvlNum >= 4) {
                        leadershipCount += empCnt;
                    }
                    totalMinSalary += p.getMinSalary();
                    String lvl = p.getLevel();
                    if (lvl != null && !lvl.isEmpty()) {
                        levelMap.put(lvl, levelMap.getOrDefault(lvl, 0) + empCnt);
                    }
                }
                long avgSalary = totalPositions > 0 ? (totalMinSalary / totalPositions) : 16800000L;
                double leadershipPct = totalCompanyEmployees > 0 ? ((double) leadershipCount * 100.0 / totalCompanyEmployees) : 0.0;

                String popularLevel = "Chuyên viên (L3)";
                int popularCount = 0;
                for (java.util.Map.Entry<String, Integer> entry : levelMap.entrySet()) {
                    if (entry.getValue() > popularCount) {
                        popularCount = entry.getValue();
                        popularLevel = entry.getKey();
                    }
                }
                double popularPct = totalCompanyEmployees > 0 ? ((double) popularCount * 100.0 / totalCompanyEmployees) : 0.0;

                // Phân trang 10/trang
                int pageSize = 10;
                int totalRecords = allList.size();
                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

                int page = 1;
                try { page = Integer.parseInt(request.getParameter("page")); } catch (NumberFormatException ignored) {}
                if (page < 1) page = 1;
                if (page > totalPages && totalPages > 0) page = totalPages;

                int fromIdx = (page - 1) * pageSize;
                int toIdx   = Math.min(fromIdx + pageSize, totalRecords);
                List<Position> pageList = (totalRecords > 0) ? allList.subList(fromIdx, toIdx) : allList;

                request.setAttribute("positions", pageList);
                request.setAttribute("totalPositions", totalPositions);
                request.setAttribute("totalRecords", totalRecords);
                request.setAttribute("totalCompanyEmployees", totalCompanyEmployees);
                request.setAttribute("leadershipCount", leadershipCount);
                request.setAttribute("leadershipPct", leadershipPct);
                request.setAttribute("popularLevel", popularLevel);
                request.setAttribute("popularCount", popularCount);
                request.setAttribute("popularPct", popularPct);
                request.setAttribute("avgSalary", avgSalary);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("keyword", keyword);
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
            case "add" -> {
                Position pos = new Position();
                pos.setName(request.getParameter("name"));
                pos.setDescription(request.getParameter("description"));
                positionDAO.insert(pos);
                response.sendRedirect(request.getContextPath() + "/positions?success=added");
            }
            case "update" -> {
                Position pos = new Position();
                pos.setId(Integer.parseInt(request.getParameter("id")));
                pos.setName(request.getParameter("name"));
                pos.setDescription(request.getParameter("description"));
                positionDAO.update(pos);
                response.sendRedirect(request.getContextPath() + "/positions?success=updated");
            }
            case "delete" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                positionDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/positions?success=deleted");
            }
            default -> response.sendRedirect(request.getContextPath() + "/positions");
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

}
