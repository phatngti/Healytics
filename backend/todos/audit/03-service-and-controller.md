# 03 — Service & Controller

**Status:** ✅ COMPLETED

## Context

The AuditService provides programmatic access to audit logs, and the AuditController exposes query endpoints for admin audit trail viewing.

## Prerequisites

- ✅ Todo 01 — Module and entity
- ✅ Todo 02 — Interceptor and decorator

## Tasks

### 1. Create `src/audit/audit.service.ts`
Methods:
- `createLog(data)` — creates AuditLog entry
- `findAll(query)` — paginated audit log retrieval
- `findByEntity(entityType, entityId)` — logs for a specific entity

### 2. Create `src/audit/audit.controller.ts`
Endpoints for querying audit history (admin-only).

### 3. Create spec files
- `audit.controller.spec.ts`
- `audit.service.spec.ts`

## Completed

Service supports both interceptor-driven and programmatic audit log creation. Controller provides admin query access. Full spec coverage with test doubles.
