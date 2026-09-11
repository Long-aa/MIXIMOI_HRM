package com.miximoi.hrm.model;

/**
 * Model Position — Chức vụ.
 */
public class Position {

    private int id;
    private String name;
    private String description;

    public Position() {}

    public Position(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() {
        return "Position{id=" + id + ", name='" + name + "'}";
    }
}
