# 03 — Query Endpoints & Controller

**Status:** ✅ COMPLETED

## Context

With the review handler done (todo 02), this wires up all admin controller endpoints. Uses `@AdminApi` composite decorator for ADMIN_ROLES access and `AuditInterceptor` for request logging.

## Prerequisites

- ✅ Todo 02 — Review handler
- ✅ `@AdminApi` composite decorator
- ✅ `AuditInterceptor` from audit module

## Tasks

### 1. Create `src/admin/controllers/admin-partners.controller.ts`

Uses `@AdminApi('partners')` → route prefix `/v1/admin/partners`.
All endpoints wrapped with `@UseInterceptors(AuditInterceptor)`.

| Method | Path | Auth | Response |
|---|---|---|---|
| `GET` | `/v1/admin/partners` | ADMIN_ROLES | `PartnersResponseDto` |
| `GET` | `/v1/admin/partners/total` | ADMIN_ROLES | `TotalPartnersResponseDto` |
| `GET` | `/v1/admin/partners/:id` | ADMIN_ROLES | `AdminPartnerDetailResponseDto` |
| `PUT` | `/v1/admin/partners/:id/review` | ADMIN_ROLES | `ReviewPartnerResponseDto` |

- List partners: supports `GetPartnersQueryDto` with pagination/filters
- Review endpoint: `@Audit('PARTNER_REVIEW', 'Partner')` decorator for audit logging
- Review has `@Throttle({ limit: 30, ttl: 60000 })`
- All ID params use `ParseUUIDPipe`

## Completed

Admin controller fully wired with 4 endpoints. Audit logging on all endpoints via interceptor. Review endpoint additionally annotated with `@Audit` decorator for detailed audit trail.
