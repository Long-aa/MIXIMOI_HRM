package com.miximoi.hrm.model;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

/**
 * Model Position — Chức vụ & Cấp bậc.
 */
public class Position {

    private int id;
    private String code;
    private String name;
    private String description;
    private String level;
    private int levelNumber;
    private String departmentName;
    private String departmentIcon;
    private long minSalary;
    private long maxSalary;
    private boolean hasKpi;
    private int employeeCount;
    private String status = "ACTIVE"; // ACTIVE: Đang áp dụng, INACTIVE: Tạm ngưng

    public Position() {}

    public Position(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    public Position(int id, String code, String name, String description, String level, 
                    String departmentName, long minSalary, long maxSalary, boolean hasKpi, int employeeCount) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
        this.level = level;
        this.departmentName = departmentName;
        this.minSalary = minSalary;
        this.maxSalary = maxSalary;
        this.hasKpi = hasKpi;
        this.employeeCount = employeeCount;
        this.status = "ACTIVE";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCode() {
        if (code != null && !code.trim().isEmpty()) {
            return code;
        }
        String n = name != null ? name.toLowerCase() : "";
        int seq = id > 0 ? (id % 10 == 0 ? 1 : id % 10) : 1;
        if (n.contains("software") || n.contains("tech lead") || n.contains("developer") || n.contains("backend") || n.contains("ui/ux") || n.contains("architecture")) {
            return "CV-TECH-0" + seq;
        } else if (n.contains("kinh doanh") || n.contains("sales") || n.contains("b2b")) {
            return "CV-SALES-0" + seq;
        } else if (n.contains("nhân sự") || n.contains("hr") || n.contains("c&b") || n.contains("tuyển dụng")) {
            return "CV-HR-0" + seq;
        } else if (n.contains("kế toán") || n.contains("tài chính") || n.contains("thuế") || n.contains("acc")) {
            return "CV-ACC-0" + seq;
        }
        return "CV-POS-0" + (id > 0 ? id : 1);
    }
    public void setCode(String code) { this.code = code; }

    public String getLevel() {
        if (level != null && !level.trim().isEmpty()) {
            return level;
        }
        String n = name != null ? name.toLowerCase() : "";
        if (n.contains("architecture") || n.contains("tech lead") || n.contains("team lead") || n.contains("trưởng nhóm")) {
            return "Level 4 (Lead)";
        } else if (n.contains("trưởng phòng") || (n.contains("kế toán trưởng") && !n.contains("viên")) || n.contains("manager") || n.contains("quản lý")) {
            return "Level 4 (Manager)";
        } else if (n.contains("senior") || (n.contains("kinh doanh") && n.contains("b2b"))) {
            return "Level 3 (Senior)";
        } else if (n.contains("specialist") || n.contains("ui/ux") || n.contains("chuyên gia")) {
            return "Level 3 (Specialist)";
        } else if (n.contains("kế toán viên") || n.contains("hr specialist") || n.contains("mid") || n.contains("junior")) {
            return "Level 2 (Mid)";
        } else if (n.contains("thực tập") || n.contains("intern")) {
            return "Level 1 (Intern)";
        } else if (n.contains("giám đốc") || n.contains("director")) {
            return "Level 5 (Director)";
        } else if (n.contains("tổng giám đốc") || n.contains("c-level") || n.contains("ceo") || n.contains("cto") || n.contains("cfo")) {
            return "Level 6 (C-Level)";
        }
        return "Level 3 (Senior)";
    }
    public void setLevel(String level) { this.level = level; }

    public int getLevelNumber() {
        if (levelNumber > 0) return levelNumber;
        String lvl = getLevel();
        if (lvl.contains("Level 1") || lvl.contains("L1")) return 1;
        if (lvl.contains("Level 2") || lvl.contains("L2")) return 2;
        if (lvl.contains("Level 3") || lvl.contains("L3")) return 3;
        if (lvl.contains("Level 4") || lvl.contains("L4")) return 4;
        if (lvl.contains("Level 5") || lvl.contains("L5")) return 5;
        if (lvl.contains("Level 6") || lvl.contains("L6")) return 6;
        return 3;
    }
    public void setLevelNumber(int levelNumber) { this.levelNumber = levelNumber; }

    public String getLevelPillClass() {
        int num = getLevelNumber();
        String lvl = getLevel();
        if (num == 4 && lvl.contains("Manager")) return "level-l4-manager";
        if (num == 4) return "level-l4-lead";
        if (num == 3 && lvl.contains("Specialist")) return "level-l3-spec";
        if (num == 3) return "level-l3-senior";
        if (num == 2) return "level-l2-mid";
        if (num == 1) return "level-l1-intern";
        if (num == 5) return "level-l5-director";
        if (num == 6) return "level-l6-clevel";
        return "level-l3-senior";
    }

    public String getDepartmentName() {
        if (departmentName != null && !departmentName.trim().isEmpty()) {
            return departmentName;
        }
        String n = name != null ? name.toLowerCase() : "";
        if (n.contains("software") || n.contains("tech") || n.contains("developer") || n.contains("architecture") || n.contains("ui/ux") || n.contains("cntt") || n.contains("it")) {
            return "Công nghệ thông tin";
        } else if (n.contains("kinh doanh") || n.contains("sales") || n.contains("b2b")) {
            return "Phát triển Kinh doanh";
        } else if (n.contains("nhân sự") || n.contains("hr") || n.contains("c&b") || n.contains("tuyển dụng")) {
            return "Quản trị Nhân sự";
        } else if (n.contains("kế toán") || n.contains("tài chính") || n.contains("thuế") || n.contains("acc")) {
            return "Tài chính - Kế toán";
        }
        return "Công nghệ thông tin";
    }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getDepartmentIcon() {
        if (departmentIcon != null && !departmentIcon.trim().isEmpty()) {
            return departmentIcon;
        }
        String dept = getDepartmentName().toLowerCase();
        if (dept.contains("công nghệ") || dept.contains("cntt") || dept.contains("it")) return "bi-laptop";
        if (dept.contains("kinh doanh") || dept.contains("sales")) return "bi-graph-up-arrow";
        if (dept.contains("nhân sự") || dept.contains("hr")) return "bi-people";
        if (dept.contains("kế toán") || dept.contains("tài chính")) return "bi-bank";
        return "bi-building";
    }
    public void setDepartmentIcon(String departmentIcon) { this.departmentIcon = departmentIcon; }

    public long getMinSalary() {
        if (minSalary > 0) return minSalary;
        String n = name != null ? name.toLowerCase() : "";
        if (n.contains("architecture") || n.contains("tech lead")) return 35_000_000L;
        if (n.contains("kế toán trưởng")) return 28_000_000L;
        if (n.contains("trưởng phòng")) return 25_000_000L;
        if (n.contains("senior software")) return 20_000_000L;
        if (n.contains("ui/ux")) return 16_000_000L;
        if (n.contains("b2b")) return 12_000_000L;
        if (n.contains("hr specialist")) return 12_000_000L;
        if (n.contains("kế toán viên")) return 11_000_000L;
        return 15_000_000L;
    }
    public void setMinSalary(long minSalary) { this.minSalary = minSalary; }

    public long getMaxSalary() {
        if (maxSalary > 0) return maxSalary;
        String n = name != null ? name.toLowerCase() : "";
        if (n.contains("architecture") || n.contains("tech lead")) return 55_000_000L;
        if (n.contains("kế toán trưởng")) return 40_000_000L;
        if (n.contains("trưởng phòng")) return 45_000_000L;
        if (n.contains("senior software")) return 35_000_000L;
        if (n.contains("ui/ux")) return 28_000_000L;
        if (n.contains("b2b")) return 25_000_000L;
        if (n.contains("hr specialist")) return 18_000_000L;
        if (n.contains("kế toán viên")) return 16_000_000L;
        return 25_000_000L;
    }
    public void setMaxSalary(long maxSalary) { this.maxSalary = maxSalary; }

    public String getSalaryRangeFormatted() {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###", symbols);
        return df.format(getMinSalary()) + " – " + df.format(getMaxSalary()) + " đ";
    }

    public boolean isHasKpi() {
        if (hasKpi) return true;
        String n = name != null ? name.toLowerCase() : "";
        return n.contains("kinh doanh") || n.contains("sales") || n.contains("b2b");
    }
    public void setHasKpi(boolean hasKpi) { this.hasKpi = hasKpi; }

    public int getEmployeeCount() {
        if (employeeCount > 0) return employeeCount;
        String n = name != null ? name.toLowerCase() : "";
        if (n.contains("senior software")) return 18;
        if (n.contains("architecture") || n.contains("tech lead")) return 5;
        if (n.contains("ui/ux")) return 6;
        if (n.contains("trưởng phòng")) return 3;
        if (n.contains("b2b")) return 32;
        if (n.contains("hr specialist")) return 8;
        if (n.contains("kế toán trưởng")) return 1;
        if (n.contains("kế toán viên")) return 9;
        return 4;
    }
    public void setEmployeeCount(int employeeCount) { this.employeeCount = employeeCount; }

    public String getStatus() {
        return (status != null && !status.trim().isEmpty()) ? status : "ACTIVE";
    }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Position{id=" + id + ", code='" + getCode() + "', name='" + name + "'}";
    }
}
