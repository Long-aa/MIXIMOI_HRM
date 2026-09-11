package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.Position;
import com.miximoi.hrm.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý các thao tác DB liên quan đến Position (Chức vụ).
 */
public class PositionDAO {

    public List<Position> findAll() {
        List<Position> list = new ArrayList<>();
        String sql = "SELECT id, name, description FROM positions ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("PositionDAO.findAll lỗi: " + e.getMessage());
        }
        return list;
    }

    public Position findById(int id) {
        String sql = "SELECT id, name, description FROM positions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("PositionDAO.findById lỗi: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(Position pos) {
        String sql = "INSERT INTO positions (name, description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pos.getName());
            ps.setString(2, pos.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PositionDAO.insert lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean update(Position pos) {
        String sql = "UPDATE positions SET name = ?, description = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pos.getName());
            ps.setString(2, pos.getDescription());
            ps.setInt(3, pos.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PositionDAO.update lỗi: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM positions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PositionDAO.delete lỗi: " + e.getMessage());
        }
        return false;
    }

    private Position mapRow(ResultSet rs) throws SQLException {
        Position p = new Position();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        return p;
    }
}
