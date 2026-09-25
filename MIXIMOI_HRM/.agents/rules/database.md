---
trigger: always_on
---

---
trigger: glob
description: PostgreSQL and JDBC database rules
globs: "**/*.sql,**/*DAO.java"
---

# Database Rules

Database:

PostgreSQL.

Application access:

JDBC.

---

# Tables

Main tables:

users
roles

employees
departments
positions
employee_types

contracts

work_shifts
attendance

leave_requests
overtime

salary_configs
allowances
bonuses
deductions

payroll
payroll_details

payments

notifications
audit_logs

---

# SQL

Always prefer:

PreparedStatement

Example:

String sql =
    "SELECT * FROM employees WHERE employee_code = ?";

PreparedStatement ps =
    connection.prepareStatement(sql);

ps.setString(1, employeeCode);

---

# Never

Do not write:

String sql =
    "SELECT * FROM employees WHERE employee_code = '"
    + employeeCode
    + "'";

---

# Transactions

Use database transactions when multiple related operations must succeed or fail together.

Example:

Payroll creation
+
Payroll details
+
Payment record

must be considered carefully for transaction boundaries.

---

# Foreign keys

Preserve existing relationships.

Do not remove constraints without explicit request.

---

# Schema changes

Before modifying schema:

1. Inspect current schema.
2. Identify dependent DAO/service code.
3. Identify dependent JSP/Servlet code.
4. Make compatible changes.
5. Update schema documentation if required.

Do not silently rename existing columns.

---

# SQL style

Prefer clear SQL.

Use aliases when helpful.

Avoid SELECT * when a specific column list is more appropriate.

---

# Database credentials

Never commit real credentials.

Use configuration/environment variables where supported.
