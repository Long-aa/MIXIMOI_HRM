# MIXIMOI HRM & PAYROLL - AI AGENT RULES

## 1. PROJECT OVERVIEW

Project:
MIXIMOI HRM & PAYROLL

Purpose:
Web application for human resource management and payroll management.

The system manages:

- Employees
- Departments
- Positions
- Employee types
- Employment contracts
- Work shifts
- Attendance
- Leave requests
- Overtime
- Salary configuration
- Allowances
- Bonuses
- Deductions
- Payroll
- Payroll details
- Payments
- Payslips
- Reports
- Notifications
- User accounts
- Roles
- Audit logs

This is an educational Java Web project.

---

# 2. TECHNOLOGY STACK

Use only the technologies already defined by the project.

- Java 17
- JSP
- Jakarta Servlet
- JDBC
- PostgreSQL
- HTML5
- CSS3
- JavaScript ES6+
- Bootstrap 5
- Apache Tomcat 10+
- Maven
- JUnit 5
- Git / GitHub

Do NOT introduce these technologies unless the user explicitly requests them:

- Spring Boot
- Spring MVC
- Spring Data JPA
- Hibernate
- Thymeleaf
- JPA
- React
- Angular
- Vue
- Node.js backend
- MongoDB

The database access layer must use JDBC.

---

# 3. ARCHITECTURE

The project follows:

MVC + DAO + Service Layer

Architecture:

JSP
  ↓
Servlet
  ↓
Service
  ↓
DAO
  ↓
JDBC
  ↓
PostgreSQL

Responsibilities:

## JSP

JSP is the View layer.

JSP must:

- Display data
- Display forms
- Display validation messages
- Use JSTL/EL where appropriate
- Handle presentation only

JSP must NOT:

- Execute SQL
- Create JDBC connections
- Call DAO directly
- Contain complex business logic
- Contain password/database credentials

---

## Servlet

Servlet is the Controller layer.

Servlet responsibilities:

- Receive HTTP requests
- Read request parameters
- Validate basic request input
- Call Service
- Set request/session attributes
- Redirect or forward to JSP

Servlet should NOT contain large business rules.

Business logic belongs in Service.

---

## Service

Service contains business logic.

Service responsibilities:

- Business validation
- Payroll calculations
- Approval rules
- Attendance calculations
- Leave calculations
- Overtime calculations
- Transaction orchestration
- Calling one or more DAO classes

---

## DAO

DAO is responsible for database access.

DAO responsibilities:

- SQL queries
- INSERT
- UPDATE
- DELETE
- SELECT
- ResultSet mapping
- PreparedStatement
- Database transaction operations when required

DAO must NOT contain UI logic.

---

## Model

Model classes represent application data.

Examples:

- User
- Employee
- Department
- Position
- Contract
- Attendance
- LeaveRequest
- Overtime
- Payroll

Model classes should remain simple POJO/entity-style classes.

---

# 4. PROJECT STRUCTURE

Expected structure:

src/main/java/com/miximoi/hrm/

    controller/
    dao/
    model/
    service/
    util/

Web resources:

src/main/webapp/

    index.jsp
    login.jsp

    css/
    js/
    images/

    dashboard/
    employee/
    department/
    position/
    contract/
    attendance/
    leave/
    payroll/
    overtime/
    payment/
    report/
    admin/

Database:

database/
    schema.sql
    sample-data.sql

Documentation:

docs/
    use-case.md
    database-design.md
    system-design.md

---

# 5. CODING RULES

## General

- Make the smallest change necessary.
- Do not rewrite working code unnecessarily.
- Do not modify unrelated files.
- Reuse existing classes and components.
- Do not create duplicate functionality.
- Do not create duplicate DAO/service/model classes.
- Follow the existing package structure.
- Preserve existing naming conventions.

---

# 6. TOKEN / CONTEXT EFFICIENCY

The AI agent must minimize unnecessary context.

Rules:

1. Do not scan the entire repository for a small task.
2. Read only files relevant to the current task.
3. Do not open unrelated JSP files.
4. Do not inspect every DAO if only one DAO is involved.
5. Do not inspect the entire database schema unless the task requires it.
6. Do not rewrite the README unless requested.
7. Do not generate unnecessary documentation.
8. Do not repeat the same explanation multiple times.
9. Do not install dependencies unless required.
10. Do not perform unrelated refactoring.

When a task specifies files, prioritize those files.

Example:

If the user says:

"Fix allowances.jsp"

Start with:

- allowances.jsp
- related Servlet
- related Service
- related DAO
- related Model

Do not inspect unrelated modules.

---

# 7. CHANGE CONTROL

Before modifying code:

1. Identify the relevant files.
2. Understand the existing implementation.
3. Determine the root cause.
4. Make the smallest safe change.
5. Check compilation.
6. Run only relevant tests.

Do not:

- Rewrite the entire module
- Change architecture
- Rename tables unnecessarily
- Rename public methods unnecessarily
- Replace JDBC with ORM
- Replace JSP with another frontend framework

---

# 8. ERROR HANDLING

When an error occurs:

1. Read the actual error message.
2. Locate the source file.
3. Identify the root cause.
4. Fix the root cause.
5. Re-run the relevant command.

Do not blindly change multiple files.

Maximum automatic retry:

2 attempts for the same error.

If the same error remains after two attempts:

STOP.

Report:

- Error
- File
- Line if available
- Root cause
- Suggested next step

---

# 9. DATABASE RULES

Database:

PostgreSQL.

Database access:

JDBC.

Always prefer:

PreparedStatement

Never concatenate untrusted user input directly into SQL.

Bad:

String sql =
    "SELECT * FROM employees WHERE name = '" + name + "'";

Good:

String sql =
    "SELECT * FROM employees WHERE name = ?";

PreparedStatement ps =
    connection.prepareStatement(sql);

ps.setString(1, name);

---

# 10. SECURITY

Never:

- Store plaintext passwords.
- Commit database passwords.
- Expose database credentials.
- Put credentials into JSP.
- Build SQL using raw user input.

Password hashing should use BCrypt if implemented by the project.

Use:

- Session authentication
- Role authorization
- PreparedStatement
- Server-side validation
- Audit logging

---

# 11. AUTHORIZATION

Roles:

ADMIN
HR
ACCOUNTANT
MANAGER
EMPLOYEE

Expected responsibilities:

ADMIN:
- Full system administration
- Account management
- Audit log

HR:
- Employees
- Departments
- Positions
- Contracts
- Attendance
- Leave

ACCOUNTANT:
- Payroll
- Payroll calculation
- Payments
- Payroll reports

MANAGER:
- Employee monitoring
- Leave approval
- Overtime approval
- Reports

EMPLOYEE:
- Personal information
- Attendance
- Leave requests
- Overtime
- Payslips
- Notifications

Do not bypass authorization checks.

---

# 12. PAYROLL RULES

Payroll calculation must be implemented in the Service layer.

Conceptual calculation:

Basic Salary
+ Allowances
+ Bonuses
+ Overtime
- Deductions
= Net Salary

Do not put payroll calculation logic inside JSP.

Do not hard-code configurable business rates directly into JSP.

---

# 13. ATTENDANCE RULES

Attendance may contain:

- Employee
- Date
- Check-in time
- Check-out time
- Total hours
- Status
- Note

Possible statuses:

- On time
- Late
- Early leave
- Absent
- Overtime

Attendance calculations belong in Service.

---

# 14. LEAVE RULES

Leave workflow:

Employee creates request
↓
Select leave type/date/reason
↓
Submit
↓
Manager/HR reviews
↓
Approve / Reject
↓
Update attendance

Possible states:

- PENDING
- APPROVED
- REJECTED
- CANCELLED

---

# 15. OVERTIME RULES

Overtime workflow:

Create overtime request
↓
Approval
↓
Record overtime
↓
Calculate overtime pay
↓
Include in payroll

Possible multipliers:

- 1.5x
- 2x
- 3x

Do not hard-code business rules into JSP.

---

# 16. PAYROLL STATUS

Expected payroll lifecycle:

DRAFT
↓
PENDING_APPROVAL
↓
APPROVED
↓
PROCESSING_PAYMENT
↓
PAID

Do not change status transitions without understanding the business flow.

---

# 17. TESTING

Use JUnit 5 where appropriate.

Important areas:

Authentication
Employee
Attendance
Leave
Overtime
Payroll
Payment

When modifying business logic:

- Update or add relevant tests.
- Do not remove existing tests merely to make the build pass.

---

# 18. GIT

Use conventional commit prefixes:

feat:
fix:
style:
refactor:
test:
docs:
chore:

Examples:

feat: add employee management CRUD

fix: fix attendance calculation

test: add payroll service tests

docs: update payroll documentation

---

# 19. AI RESPONSE STYLE

When completing a coding task, report briefly:

1. What was changed.
2. Which files were changed.
3. Why the change was required.
4. What was tested.

Do not provide unnecessary long explanations unless requested.

---

# 20. IMPORTANT

The user's explicit request has priority over these rules.

If the user explicitly requests:

- Architecture change
- New framework
- Database migration
- Large refactor
- New module

follow the request.

Otherwise preserve the existing architecture.