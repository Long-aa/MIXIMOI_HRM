---
trigger: always_on
---

---
trigger: glob
description: Java source code rules for MIXIMOI HRM
globs: "**/*.java"
---

# Java Rules

## Version

Use Java 17.

Do not use language features that require a newer Java version unless explicitly requested.

---

## Architecture

Follow:

Controller
→ Service
→ DAO
→ JDBC
→ PostgreSQL

---

## Controller

Servlet responsibilities:

- Receive HTTP request
- Read parameters
- Call Service
- Set request/session attributes
- Forward/redirect

Do not place large business logic inside Servlet.

---

## Service

Business logic belongs in Service.

Examples:

- Payroll calculation
- Attendance calculation
- Overtime calculation
- Leave approval
- Validation
- Transaction coordination

---

## DAO

DAO contains SQL/database operations.

Use:

PreparedStatement

Avoid:

String concatenation for user input.

---

## Model

Models should represent application data.

Avoid putting database access inside Model classes.

---

## Error handling

Do not silently swallow exceptions.

Bad:

try {
    ...
} catch (Exception e) {
}

Prefer meaningful handling/logging.

---

## Naming

Classes:

EmployeeService
EmployeeDAO
EmployeeServlet

Methods:

getEmployee()
getAllEmployees()
createEmployee()
updateEmployee()
deleteEmployee()

Variables should have meaningful names.

---

## Minimal change

Do not refactor unrelated classes.

Reuse existing utilities before creating new utilities.
