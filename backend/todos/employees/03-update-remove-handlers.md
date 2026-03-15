# 03 — Update & Remove Handlers

**Status:** ✅ COMPLETED

## Context

After create handlers (todo 02), this implements update and remove operations. Both are scoped to the authenticated partner's employees.

## Prerequisites

- ✅ Todo 02 — Create handlers
- ✅ `EmployeesService` partner-scoped query methods

## Tasks

### 1. Create DTOs
- **`update-employee.dto.ts`** — PartialType of base employee fields
- **`get-employees-query.dto.ts`** — optional type filter query param

### 2. Create `src/employees/application/handlers/update-employee.handler.ts`
**Logic:**
- Loads employee by ID scoped to partner → `NotFoundException`
- Merges update fields (general and type-specific profile)
- Saves and returns updated employee

### 3. Create `src/employees/application/handlers/remove-employee.handler.ts`
**Logic:**
- Loads employee by ID scoped to partner → `NotFoundException`
- Soft deletes employee
- Cascade deletes associated profile

## Completed

Update handler supports partial updates on both base employee and type-specific profile fields. Remove uses soft delete. Both handlers enforce partner ownership.
