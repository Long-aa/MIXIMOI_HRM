---
trigger: always_on
---

---
trigger: glob
description: Authentication, authorization and security rules
globs: "**/*.java,**/*.jsp"
---

# Security Rules

Security is required for:

- Login
- Logout
- Session
- Authorization
- Employee data
- Payroll data
- Payment data
- User management

---

# Password

Never store plaintext passwords.

Use BCrypt for password hashing if implemented.

Do not use raw password comparison against database plaintext.

---

# Authentication

After successful login:

- Create authenticated session.
- Store only required user information.
- Do not store sensitive credentials in session unnecessarily.

---

# Logout

Logout should invalidate the session.

---

# Authorization

Roles:

ADMIN
HR
ACCOUNTANT
MANAGER
EMPLOYEE

Do not rely only on hidden buttons or frontend UI for authorization.

Server-side authorization is required.

---

# Session

Protected pages should verify authentication.

Example:

HttpSession session = request.getSession(false);

if (session == null) {
    response.sendRedirect(...);
    return;
}

---

# SQL Injection

Always use PreparedStatement.

Never concatenate untrusted input into SQL.

---

# Input validation

Validate on the server.

Check:

- Required fields
- Data type
- Numeric range
- Date format
- Email format
- Business constraints

---

# Credentials

Never put real credentials into:

- JSP
- Java source
- README
- Git
- screenshots
- test data

---

# Audit Log

Important actions should be auditable:

CREATE
UPDATE
DELETE
APPROVE
REJECT
LOGIN
LOGOUT
PAYMENT

Record:

- User
- Action
- Target object
- Timestamp
- Description

---

# Error messages

Do not expose:

- SQL statements
- Stack traces
- Database credentials
- Internal paths

to normal users.
