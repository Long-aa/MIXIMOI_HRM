package com.miximoi.hrm.dao;

import com.miximoi.hrm.model.WorkShift;
import com.miximoi.hrm.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO truy cập dữ liệu Ca làm việc (work_shifts).
 */
public class WorkShiftDAO {

    public List<WorkShift> findAll() {
        List<WorkShift> list = new ArrayList<>();
        String sql = "SELECT id, name, start_time, end_time, standard_hours, description FROM work_shifts ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("WorkShiftDAO.findAll error: " + e.getMessage());
        }
        return list;
    }

    public WorkShift findById(int id) {
        String sql = "SELECT id, name, start_time, end_time, standard_hours, description FROM work_shifts WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("WorkShiftDAO.findById error: " + e.getMessage());
        }
        return null;
    }

    public WorkShift findByName(String name) {
        String sql = "SELECT id, name, start_time, end_time, standard_hours, description FROM work_shifts WHERE name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("WorkShiftDAO.findByName error: " + e.getMessage());
        }
        return null;
    }

    private WorkShift mapRow(ResultSet rs) throws SQLException {
        WorkShift ws = new WorkShift();
        ws.setId(rs.getInt("id"));
        ws.setName(rs.getString("name"));
        Time st = rs.getTime("start_time");
        if (st != null) ws.setStartTime(st.toLocalTime());
        Time et = rs.getTime("end_time");
        if (et != null) ws.setEndTime(et.toLocalTime());
        ws.setStandardHours(rs.getDouble("standard_hours"));
        ws.setDescription(rs.getString("description"));
        return ws;
    }
}
