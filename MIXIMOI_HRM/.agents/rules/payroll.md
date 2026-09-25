---
trigger: always_on
---

---
trigger: glob
description: Payroll business rules for MIXIMOI HRM
globs: "**/*Payroll*.java,**/*payroll*.jsp,**/*Salary*.java,**/*salary*.jsp,**/*Allowance*.java,**/*Bonus*.java,**/*Deduction*.java"
---

# Payroll Rules

Payroll business logic must remain in the Service layer.

---

# Salary components

Payroll may contain:

Basic Salary
+ Allowances
+ Bonuses
+ Overtime
- Deductions
=
Net Salary

---

# Basic salary

Basic salary may depend on:

- Employee
- Contract
- Effective date
- Payroll period

Do not assume that the current salary is always the salary applicable to historical payroll.

---

# Allowances

Examples:

- Meal allowance
- Transportation allowance
- Phone allowance
- Position allowance
- Other allowance

---

# Bonuses

Examples:

- Performance bonus
- Sales bonus
- Holiday bonus
- Tet bonus
- Other bonus

---

# Deductions

Examples:

- Social insurance
- Health insurance
- Unemployment insurance
- Personal income tax
- Other deductions

---

# Overtime

Overtime may use:

1.5x
2x
3x

The actual business rate should come from the configured business rules.

Do not hard-code rates inside JSP.

---

# Payroll calculation

Recommended flow:

Payroll period
↓
Get employees
↓
Get attendance
↓
Calculate working days
↓
Get approved overtime
↓
Calculate overtime
↓
Get allowances
↓
Get bonuses
↓
Get deductions
↓
Calculate gross salary
↓
Calculate deductions
↓
Calculate net salary
↓
Create payroll
↓
Create payroll details

---

# Payroll lifecycle

DRAFT
↓
PENDING_APPROVAL
↓
APPROVED
↓
PROCESSING_PAYMENT
↓
PAID

Do not skip status validation.

---

# Approval

Only authorized roles should approve payroll.

Expected roles:

MANAGER
ADMIN

Actual authorization must follow the implemented application rules.

---

# Historical payroll

Once payroll has been finalized/paid:

Do not automatically recalculate historical payroll because current salary/configuration changed.

Historical payroll should preserve the values used during that payroll period.

---

# Precision

Money calculations must use appropriate numeric types.

Prefer:

BigDecimal

Do not use floating point types for financial calculations.

---

# Testing

Payroll tests should cover:

- Basic salary
- Working days
- Overtime
- Allowances
- Bonuses
- Deductions
- Net salary
- Edge cases
- Invalid data
- Payroll status transitions
