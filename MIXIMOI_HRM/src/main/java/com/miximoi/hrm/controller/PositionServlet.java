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

/**
 * Servlet quản lý chức vụ.
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
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("position", positionDAO.findById(id));
                request.getRequestDispatcher("/WEB-INF/views/position/position-form.jsp")
                       .forward(request, response);
                break;
            }
            default:
                request.setAttribute("positions", positionDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/position/position-list.jsp")
                       .forward(request, response);
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
}
