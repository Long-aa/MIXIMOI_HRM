---
trigger: always_on
---

---
trigger: glob
description: JSP view rules for MIXIMOI HRM
globs: "**/*.jsp"
---

# JSP Rules

JSP is the View layer.

---

## JSP responsibilities

JSP may:

- Display data
- Display forms
- Display validation messages
- Render tables
- Render Bootstrap components
- Use JSTL
- Use EL

---

## JSP must NOT

Never:

- Connect to PostgreSQL
- Create JDBC Connection
- Execute SQL
- Call DAO directly
- Contain complex business logic
- Calculate payroll
- Calculate overtime
- Validate security permissions only on the client

---

## Data flow

Servlet:

request.setAttribute("employees", employees);

JSP:

${employees}

Use JSTL/EL where possible.

---

## Security

Never expose:

- Database password
- Connection string with credentials
- Session secrets
- Internal credentials

---

## UI

Use the existing Bootstrap 5 design.

Before creating a new component:

1. Search for an existing component.
2. Reuse it if possible.
3. Only create a new component if necessary.

---

## Forms

Forms should:

- Use clear labels
- Show validation errors
- Preserve submitted values when appropriate
- Use correct input types

---

## JavaScript

Keep JavaScript separate when practical.

Prefer:

webapp/js/

rather than placing large scripts directly inside JSP.

---

## Minimal changes

Do not rewrite an entire JSP to fix a small issue.

Change only the required section.
