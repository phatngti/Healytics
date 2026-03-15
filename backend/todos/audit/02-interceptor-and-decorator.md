# 02 — Interceptor & Decorator

**Status:** ✅ COMPLETED

## Context

The audit system uses a NestJS interceptor + decorator pattern. The `@Audit()` decorator marks which endpoints should be audited, and the `AuditInterceptor` captures request/response data and persists it.

## Prerequisites

- ✅ Todo 01 — AuditLog entity and AuditService
- ✅ `Reflector` from `@nestjs/core` for metadata reading

## Tasks

### 1. Create `src/audit/decorators/audit.decorator.ts`
```typescript
export const Audit = (action: string, entityType: string) =>
  SetMetadata('audit', { action, entityType });
```
Used as: `@Audit('PARTNER_REVIEW', 'Partner')`

### 2. Create `src/audit/interceptors/audit.interceptor.ts`
**Logic:**
- Implements `NestInterceptor`
- Reads `@Audit()` metadata via `Reflector`
- Extracts actor ID from `request.user.id`
- Captures entity ID from `request.params.id`
- On successful response, creates `AuditLog` entry via `AuditService`
- Non-blocking: audit failures are logged but don't affect the response

### 3. Create spec files
- `audit.decorator.spec.ts`
- `audit.interceptor.spec.ts`

## Completed

Decorator + interceptor pattern enables declarative audit logging. Non-blocking design ensures audit failures don't impact API responses. Used by `AdminPartnersController` for partner review logging.
