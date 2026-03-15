# 04 — Controllers

**Status:** ✅ COMPLETED

## Context

With all handlers ready (todos 02-03), this wires up two controllers: `PartnerEmployeesController` (full CRUD for partner's own employees) and `UserEmployeesController` (read-only for end users).

## Prerequisites

- ✅ Todo 03 — All handlers implemented
- ✅ `@PartnerApi` composite decorator

## Tasks

### 1. Create `PartnerEmployeesController`
Uses `@PartnerApi('employees')` → route prefix `/v1/partner/employees`.

| Method | Path | Auth | Response |
|---|---|---|---|
| `POST` | `/v1/partner/employees/doctors` | HEALTH_PARTNER | `EmployeeResponseDto` |
| `POST` | `/v1/partner/employees/spa-therapists` | HEALTH_PARTNER | `EmployeeResponseDto` |
| `POST` | `/v1/partner/employees/massage-therapists` | HEALTH_PARTNER | `EmployeeResponseDto` |
| `GET` | `/v1/partner/employees` | HEALTH_PARTNER | `EmployeeResponseDto[]` |
| `GET` | `/v1/partner/employees/:id` | HEALTH_PARTNER | `EmployeeResponseDto` |
| `PATCH` | `/v1/partner/employees/:id` | HEALTH_PARTNER | `EmployeeResponseDto` |
| `DELETE` | `/v1/partner/employees/:id` | HEALTH_PARTNER | No Content (204) |

- All endpoints resolve `partnerId` from `req.user.id` via `getPartnerIdByAccountId()`
- Write endpoints have `@Throttle({ limit: 30, ttl: 60000 })`

### 2. Create `UserEmployeesController`
Public read-only endpoints for browsing employees (used by mobile app).

### 3. Create spec files
- `partner-employees.controller.spec.ts`
- `user-employees.controller.spec.ts`
- `employees.service.spec.ts`

## Completed

Dual controller pattern: partner-scoped full CRUD and user-facing read-only. All operations scoped by partner ownership. Three type-specific creation endpoints (doctors, spa therapists, massage therapists). Comprehensive spec coverage.
