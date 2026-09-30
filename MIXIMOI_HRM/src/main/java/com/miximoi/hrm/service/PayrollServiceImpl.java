package com.miximoi.hrm.service;

import com.miximoi.hrm.dao.AllowanceDAO;
import com.miximoi.hrm.dao.AttendanceDAO;
import com.miximoi.hrm.dao.BonusDAO;
import com.miximoi.hrm.dao.ContractDAO;
import com.miximoi.hrm.dao.EmployeeDAO;
import com.miximoi.hrm.dao.OvertimeDAO;
import com.miximoi.hrm.dao.PayrollDAO;
import com.miximoi.hrm.dao.SalaryConfigDAO;
import com.miximoi.hrm.dao.SalaryDeductionDAO;
import com.miximoi.hrm.model.Employee;
import com.miximoi.hrm.model.Payroll;
import com.miximoi.hrm.util.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.YearMonth;
import java.util.List;

/**
 * Xu ly nghiep vu tinh luong hang thang va snapshot payroll_details.
 *
 * Luong = (Luong co ban / Ngay chuan x Ngay cong) + OT + Phu cap + Thuong
 *         - BHXH(8%) - BHYT(1.5%) - BHTN(1%) - TNCN (luy tien 7 bac)
 *
 * JDBC Transaction pattern:
 *   conn.setAutoCommit(false)
 *   -> thuc hien cac thao tac DB
 *   -> conn.commit()   (thanh cong)
 *   -> conn.rollback() (that bai - trong catch)
 *   -> conn.close()    (luon thuc hien - trong finally)
 */
public class PayrollServiceImpl {

    // =========================================================================
    //  Dependencies (DAO layer) - tuan thu Dependency Inversion Principle
    // =========================================================================
    private final PayrollDAO         payrollDAO;
    private final AttendanceDAO      attendanceDAO;
    private final OvertimeDAO        overtimeDAO;
    private final EmployeeDAO        employeeDAO;
    private final ContractDAO        contractDAO;
    private final AllowanceDAO       allowanceDAO;
    private final BonusDAO           bonusDAO;
    private final SalaryDeductionDAO deductionDAO;
    private final SalaryConfigDAO    configDAO;

    // Hang so fallback khi bang salary_configs chua co du lieu
    private static final double     BHXH_RATE_DEFAULT         = 0.08;
    private static final double     BHYT_RATE_DEFAULT         = 0.015;
    private static final double     BHTN_RATE_DEFAULT         = 0.01;
    private static final BigDecimal INSURANCE_CEILING_DEFAULT  = new BigDecimal("46800000");
    private static final BigDecimal PERSONAL_REDUCTION_DEFAULT = new BigDecimal("11000000");

    /** Constructor injection - de thay the mock trong unit test */
    public PayrollServiceImpl(PayrollDAO payrollDAO, AttendanceDAO attendanceDAO,
                              OvertimeDAO overtimeDAO, EmployeeDAO employeeDAO,
                              ContractDAO contractDAO, AllowanceDAO allowanceDAO,
                              BonusDAO bonusDAO, SalaryDeductionDAO deductionDAO,
                              SalaryConfigDAO configDAO) {
        this.payrollDAO    = payrollDAO;
        this.attendanceDAO = attendanceDAO;
        this.overtimeDAO   = overtimeDAO;
        this.employeeDAO   = employeeDAO;
        this.contractDAO   = contractDAO;
        this.allowanceDAO  = allowanceDAO;
        this.bonusDAO      = bonusDAO;
        this.deductionDAO  = deductionDAO;
        this.configDAO     = configDAO;
    }

    /** Constructor mac dinh - su dung trong production (Servlet goi new) */
    public PayrollServiceImpl() {
        this(new PayrollDAO(), new AttendanceDAO(), new OvertimeDAO(),
             new EmployeeDAO(), new ContractDAO(), new AllowanceDAO(),
             new BonusDAO(), new SalaryDeductionDAO(), new SalaryConfigDAO());
    }

    public PayrollDAO getPayrollDAO() {
        return payrollDAO;
    }

    // =========================================================================
    //  Core: Xu ly luong hang thang voi JDBC Transaction
    // =========================================================================

    /**
     * Tinh luong cho toan bo nhan vien trong mot ky va snapshot vao payroll_details.
     *
     * Quy trinh:
     *  1. Doc danh sach nhan vien dang ACTIVE
     *  2. Voi moi nhan vien: tinh Gross, BH, TNCN, Net
     *  3. Mo Transaction -> Insert/Update bang payrolls + payroll_details
     *  4. Commit neu thanh cong, Rollback neu co loi bat ky
     *  5. Dong Connection trong finally (BAT BUOC)
     *
     * @param month       Thang tinh luong (1-12)
     * @param year        Nam tinh luong
     * @param createdById ID nguoi thuc hien tinh luong (dung cho audit)
     * @return So nhan vien da duoc tinh luong thanh cong
     * @throws IllegalArgumentException neu month/year khong hop le
     */
    public int processMonthlyPayroll(int month, int year, int createdById) {
        // --- Validate input ---
        if (month < 1 || month > 12) {
            throw new IllegalArgumentException("Thang khong hop le: " + month);
        }
        if (year < 2000 || year > 2100) {
            throw new IllegalArgumentException("Nam khong hop le: " + year);
        }

        // --- Doc du lieu can thiet truoc khi mo transaction ---
        List<Employee> employees = employeeDAO.findAll();
        if (employees.isEmpty()) {
            System.out.println("[PayrollService] Khong co nhan vien nao de tinh luong.");
            return 0;
        }

        // Doc cau hinh BH & giam tru tu DB (doc 1 lan de tranh N+1 query trong transaction)
        double     bhxhRate         = configDAO.getDoubleByKey("bhxh_rate",          BHXH_RATE_DEFAULT);
        double     bhytRate         = configDAO.getDoubleByKey("bhyt_rate",          BHYT_RATE_DEFAULT);
        double     bhtnRate         = configDAO.getDoubleByKey("bhtn_rate",          BHTN_RATE_DEFAULT);
        BigDecimal insuranceCeiling = configDAO.getBigDecimalByKey("insurance_ceiling",  INSURANCE_CEILING_DEFAULT);
        BigDecimal personalReduction= configDAO.getBigDecimalByKey("personal_reduction", PERSONAL_REDUCTION_DEFAULT);

        int successCount = 0;
        Connection conn  = null;     // Khai bao ngoai try de su dung duoc trong finally

        try {
            // ==================================================================
            //  BUOC 1: Lay Connection tu HikariCP pool
            // ==================================================================
            conn = DBConnection.getConnection();

            // ==================================================================
            //  BUOC 2: Bat dau Transaction - tat AutoCommit
            //  Muc dich: Toan bo luong cho ky nay hoac thanh cong het, hoac rollback het
            // ==================================================================
            conn.setAutoCommit(false);

            // ==================================================================
            //  BUOC 3: Xoa cac ban ghi DRAFT cu cua ky nay de tinh lai
            // ==================================================================
            deleteDraftPayrollsForPeriod(conn, month, year);

            // ==================================================================
            //  BUOC 4: Tinh luong va snapshot cho tung nhan vien
            // ==================================================================
            for (Employee emp : employees) {
                try {
                    Payroll payroll = calculatePayroll(emp, month, year, createdById,
                                                       bhxhRate, bhytRate, bhtnRate,
                                                       insuranceCeiling, personalReduction);

                    // Insert ban ghi payroll chinh (bang payrolls)
                    int payrollId = insertPayrollRecord(conn, payroll);

                    // Snapshot chi tiet luong vao bang payroll_details
                    // (ghi lai gia tri tai thoi diem tinh luong - khong bi anh huong boi
                    //  thay doi cau hinh BH/luong sau nay)
                    insertPayrollSnapshot(conn, payrollId, payroll);

                    successCount++;

                } catch (SQLException | RuntimeException empEx) {
                    // Log loi cho tung nhan vien nhung KHONG break toan bo batch
                    // De dam bao cac nhan vien khac van duoc tinh luong
                    System.err.println("[PayrollService] Loi tinh luong cho NV #"
                            + emp.getId() + " (" + emp.getFullName() + "): " + empEx.getMessage());
                }
            }

            // ==================================================================
            //  BUOC 5: COMMIT - luu tat ca thay doi xuong PostgreSQL
            // ==================================================================
            conn.commit();
            System.out.println("[PayrollService] Da commit luong T" + month + "/" + year
                               + " cho " + successCount + " nhan vien.");

        } catch (SQLException e) {
            // ==================================================================
            //  ROLLBACK - hoan tac moi thay doi neu co loi JDBC cap Connection
            // ==================================================================
            System.err.println("[PayrollService] JDBC Transaction loi - dang rollback: " + e.getMessage());
            rollbackQuietly(conn);

        } finally {
            // ==================================================================
            //  DONG CONNECTION - BAT BUOC thuc hien du thanh cong hay that bai.
            //  Voi HikariCP: close() tra Connection ve pool, khong dong socket that.
            //  Neu khong close(): Connection bi giu, pool bi can kiet -> ung dung treo.
            // ==================================================================
            resetAutoCommitAndClose(conn);
        }

        return successCount;
    }

    // =========================================================================
    //  Private: Tinh luong chi tiet cho 1 nhan vien
    // =========================================================================

    /**
     * Tinh day du cac thanh phan luong cho 1 nhan vien.
     *
     * @return Payroll object da tinh day du (chua duoc insert vao DB)
     */
    private Payroll calculatePayroll(Employee emp, int month, int year, int createdById,
                                     double bhxhRate, double bhytRate, double bhtnRate,
                                     BigDecimal insuranceCeiling, BigDecimal personalReduction) {

        YearMonth ym = YearMonth.of(year, month);

        // 1. Ngay cong
        double standardDays = countStandardWorkingDays(ym);
        double actualDays   = attendanceDAO.countWorkingDays(emp.getId(), month, year);
        if (actualDays <= 0) actualDays = standardDays; // fallback: lam du ngay chuan

        // 2. Luong co ban tu hop dong active
        BigDecimal baseSalary = getBaseSalary(emp.getId());

        // 3. Luong theo thoi gian (tinh theo ngay cong thuc te)
        BigDecimal earnedSalary = standardDays > 0
                ? baseSalary.multiply(BigDecimal.valueOf(actualDays))
                             .divide(BigDecimal.valueOf(standardDays), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // 4. Tien tang ca da duyet (OT)
        BigDecimal overtimeAmount = sumOvertimeAmount(emp.getId(), month, year);

        // 5. Phu cap active trong thang
        BigDecimal allowance = allowanceDAO.sumActiveByEmployee(emp.getId(), month, year);

        // 6. Thuong trong thang
        BigDecimal bonus = bonusDAO.sumByEmployeeAndPeriod(emp.getId(), month, year);

        // 7. Gross Income = Luong + OT + Phu cap + Thuong
        BigDecimal grossIncome = earnedSalary.add(overtimeAmount).add(allowance).add(bonus);

        // 8. Khau tru bao hiem bat buoc (ap dung tran dong BH)
        BigDecimal bhBase         = baseSalary.min(insuranceCeiling);
        BigDecimal bhxhAmount     = bhBase.multiply(BigDecimal.valueOf(bhxhRate)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal bhytAmount     = bhBase.multiply(BigDecimal.valueOf(bhytRate)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal bhtnAmount     = bhBase.multiply(BigDecimal.valueOf(bhtnRate)).setScale(0, RoundingMode.HALF_UP);
        BigDecimal totalInsurance = bhxhAmount.add(bhytAmount).add(bhtnAmount);

        // 9. Khau tru them (tam ung, keu phat, v.v.)
        BigDecimal extraDeduction = deductionDAO.sumByEmployeeAndPeriod(emp.getId(), month, year);

        // 10. Thu nhap chiu thue TNCN
        BigDecimal taxableIncome = grossIncome
                .subtract(totalInsurance)
                .subtract(personalReduction)
                .subtract(extraDeduction)
                .max(BigDecimal.ZERO); // Khong am

        // 11. Thue TNCN luy tien 7 bac
        BigDecimal tncnTax = PayrollService.calculatePersonalIncomeTax(taxableIncome);

        // 12. Net = Gross - Tong khau tru
        BigDecimal totalDeduction = totalInsurance.add(tncnTax).add(extraDeduction);
        BigDecimal netSalary      = grossIncome.subtract(totalDeduction).max(BigDecimal.ZERO);

        // 13. Dong goi Payroll object
        Payroll pr = new Payroll();
        pr.setEmployeeId(emp.getId());
        pr.setPayMonth(month);
        pr.setPayYear(year);
        pr.setBaseSalary(baseSalary);
        pr.setWorkingDays(actualDays);
        pr.setStandardDays(standardDays);
        pr.setOvertimeAmount(overtimeAmount);
        pr.setAllowance(allowance);
        pr.setBonus(bonus);
        pr.setDeduction(totalDeduction);
        pr.setNetSalary(netSalary);
        pr.setCreatedById(createdById);
        pr.setStatus("DRAFT");
        // Giu them cac gia tri BH de snapshot
        pr.setBhxhAmount(bhxhAmount);
        pr.setBhytAmount(bhytAmount);
        pr.setBhtnAmount(bhtnAmount);
        pr.setTncnTax(tncnTax);
        pr.setGrossIncome(grossIncome);
        return pr;
    }

    // =========================================================================
    //  Private: JDBC operations su dung Connection tu Transaction
    // =========================================================================

    /**
     * Xoa cac ban ghi DRAFT cu trong ky de chuan bi tinh lai.
     * Khong xoa ban ghi da APPROVED hoac PAID.
     */
    private void deleteDraftPayrollsForPeriod(Connection conn, int month, int year)
            throws SQLException {
        String sql = "DELETE FROM payroll WHERE pay_month = ? AND pay_year = ? AND status = 'DRAFT'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            int deleted = ps.executeUpdate();
            System.out.println("[PayrollService] Da xoa " + deleted + " ban ghi DRAFT cu cua T"
                               + month + "/" + year);
        }
    }

    /**
     * Insert ban ghi payroll chinh vao bang payroll.
     *
     * @return ID cua ban ghi vua duoc tao (generated key)
     * @throws SQLException neu insert that bai
     */
    private int insertPayrollRecord(Connection conn, Payroll pr) throws SQLException {
        String sql = "INSERT INTO payroll "
                   + "(employee_id, pay_month, pay_year, base_salary, working_days, standard_days, "
                   + " overtime_amount, allowance, bonus, deduction, net_salary, status, created_by) "
                   + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, pr.getEmployeeId());
            ps.setInt(2, pr.getPayMonth());
            ps.setInt(3, pr.getPayYear());
            ps.setBigDecimal(4, pr.getBaseSalary());
            ps.setDouble(5, pr.getWorkingDays());
            ps.setDouble(6, pr.getStandardDays());
            ps.setBigDecimal(7, pr.getOvertimeAmount());
            ps.setBigDecimal(8, pr.getAllowance());
            ps.setBigDecimal(9, pr.getBonus());
            ps.setBigDecimal(10, pr.getDeduction());
            ps.setBigDecimal(11, pr.getNetSalary());
            ps.setString(12, pr.getStatus() != null ? pr.getStatus() : "DRAFT");
            ps.setInt(13, pr.getCreatedById());

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Insert payroll that bai - khong co hang nao duoc them.");
            }

            // Lay generated ID de lien ket voi payroll_details
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
                throw new SQLException("Khong lay duoc generated key sau insert payroll.");
            }
        }
    }

    /**
     * Snapshot chi tiet cac thanh phan luong vao bang payroll_details.
     *
     * Muc dich Snapshot Pattern:
     *  - Ghi lai gia tri tai thoi diem tinh luong (BH rate, giam tru, v.v.)
     *  - Bao ve tinh toan lich su: thay doi cau hinh sau nay khong lam sai bao cao cu
     *  - Tao co so phat sinh phieu luong (payslip) cho nhan vien
     *
     * @param conn      Connection trong cung Transaction voi payroll chinh
     * @param payrollId ID cua ban ghi payroll cha vua tao
     * @param pr        Payroll object chua tat ca gia tri da tinh
     * @throws SQLException neu insert that bai
     */
    private void insertPayrollSnapshot(Connection conn, int payrollId, Payroll pr)
            throws SQLException {
        String sql = "INSERT INTO payroll_details "
                   + "(payroll_id, component_name, component_type, amount, note) "
                   + "VALUES (?,?,?,?,?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            // --- Thanh phan TANG (income) ---
            addDetailRow(ps, payrollId, "Luong co ban",         "INCOME",     pr.getBaseSalary(),     "Snapshot tai thoi diem tinh luong");
            addDetailRow(ps, payrollId, "Tang ca (OT)",         "INCOME",     pr.getOvertimeAmount(), "OT da duyet trong thang");
            addDetailRow(ps, payrollId, "Phu cap",              "INCOME",     pr.getAllowance(),       "Tong phu cap active trong thang");
            addDetailRow(ps, payrollId, "Thuong",               "INCOME",     pr.getBonus(),          "Thuong trong thang");
            addDetailRow(ps, payrollId, "Thu nhap gop (Gross)", "SUMMARY",    pr.getGrossIncome(),    "= Luong + OT + Phu cap + Thuong");

            // --- Thanh phan GIAM (deduction) ---
            addDetailRow(ps, payrollId, "BHXH (8%)",            "DEDUCTION",  pr.getBhxhAmount(),     "Bao hiem xa hoi nguoi lao dong");
            addDetailRow(ps, payrollId, "BHYT (1.5%)",          "DEDUCTION",  pr.getBhytAmount(),     "Bao hiem y te nguoi lao dong");
            addDetailRow(ps, payrollId, "BHTN (1%)",            "DEDUCTION",  pr.getBhtnAmount(),     "Bao hiem that nghiep nguoi lao dong");
            addDetailRow(ps, payrollId, "Thue TNCN",            "DEDUCTION",  pr.getTncnTax(),        "Thue thu nhap ca nhan luy tien 7 bac");
            addDetailRow(ps, payrollId, "Tong khau tru",        "SUMMARY",    pr.getDeduction(),      "= BH + TNCN + Khau tru them");

            // --- Ket qua cuoi ---
            addDetailRow(ps, payrollId, "Luong thuc linh (Net)","RESULT",     pr.getNetSalary(),      "= Gross - Tong khau tru");

            // Thuc thi batch insert mot lan - hieu qua hon insert tung dong
            ps.executeBatch();
        }
    }

    /** Them 1 dong vao batch insert cho payroll_details */
    private void addDetailRow(PreparedStatement ps, int payrollId,
                               String componentName, String componentType,
                               BigDecimal amount, String note) throws SQLException {
        ps.setInt(1, payrollId);
        ps.setString(2, componentName);
        ps.setString(3, componentType);
        ps.setBigDecimal(4, amount != null ? amount : BigDecimal.ZERO);
        ps.setString(5, note);
        ps.addBatch();
    }

    // =========================================================================
    //  Private: Transaction helper methods
    // =========================================================================

    /** Rollback an toan, khong nem exception ra ngoai de tranh che giau loi goc */
    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
                System.out.println("[PayrollService] Da rollback transaction thanh cong.");
            } catch (SQLException rbEx) {
                System.err.println("[PayrollService] Rollback that bai: " + rbEx.getMessage());
            }
        }
    }

    /**
     * Khi du lieu la cuoi cung, reset AutoCommit ve true va dong Connection.
     * DAY LA DOAN CODE QUAN TRONG NHAT trong quan ly Transaction thu cong.
     * Phai luon duoc goi trong finally{} de tranh connection leak.
     */
    private void resetAutoCommitAndClose(Connection conn) {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);  // Reset trang thai cho lan su dung sau (HikariCP pool)
            } catch (SQLException e) {
                System.err.println("[PayrollService] Loi reset AutoCommit: " + e.getMessage());
            } finally {
                DBConnection.close(conn);  // Tra connection ve pool
            }
        }
    }

    // =========================================================================
    //  Private: Business logic helpers
    // =========================================================================

    /** So ngay lam viec chuan trong thang (tru T7 va CN) */
    private double countStandardWorkingDays(YearMonth ym) {
        int count = 0;
        for (int day = 1; day <= ym.lengthOfMonth(); day++) {
            java.time.DayOfWeek dow = ym.atDay(day).getDayOfWeek();
            if (dow != java.time.DayOfWeek.SATURDAY && dow != java.time.DayOfWeek.SUNDAY) {
                count++;
            }
        }
        return count;
    }

    /** Lay luong co ban tu hop dong active gan nhat */
    private BigDecimal getBaseSalary(int employeeId) {
        BigDecimal salary = contractDAO.findActiveContractBaseSalary(employeeId);
        return salary != null ? salary : BigDecimal.ZERO;
    }

    /** Tong tien tang ca da duyet trong thang */
    private BigDecimal sumOvertimeAmount(int employeeId, int month, int year) {
        List<com.miximoi.hrm.model.Overtime> otList =
                overtimeDAO.findByEmployeeAndMonth(employeeId, month, year);
        BigDecimal total = BigDecimal.ZERO;
        for (com.miximoi.hrm.model.Overtime ot : otList) {
            if (ot.getAmount() != null) total = total.add(ot.getAmount());
        }
        return total;
    }
}
