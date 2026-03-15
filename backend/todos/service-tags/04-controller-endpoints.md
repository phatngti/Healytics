# 04 — Controller & Endpoints

**Status:** ✅ COMPLETED

## Context

With all 5 handlers ready (todos 02-03), this wires up the controller. All tag endpoints are partner-scoped.

## Prerequisites

- ✅ Todo 03 — All handlers implemented
- ✅ `@PartnerApi` composite decorator

## Tasks

### 1. Create `ServiceTagsController`
Uses `@PartnerApi('service-tags')` → route prefix `/v1/partner/service-tags`.

| Method | Path | Auth | Response |
|---|---|---|---|
| `POST` | `/v1/partner/service-tags` | HEALTH_PARTNER | `ServiceTagResponseDto` |
| `GET` | `/v1/partner/service-tags` | HEALTH_PARTNER | `ServiceTagResponseDto[]` |
| `GET` | `/v1/partner/service-tags/active` | HEALTH_PARTNER | `ServiceTagResponseDto[]` |
| `GET` | `/v1/partner/service-tags/:id` | HEALTH_PARTNER | `ServiceTagResponseDto` |
| `PATCH` | `/v1/partner/service-tags/:id` | HEALTH_PARTNER | `ServiceTagResponseDto` |
| `DELETE` | `/v1/partner/service-tags/:id` | HEALTH_PARTNER | No Content (204) |
| `POST` | `/v1/partner/service-tags/:id/products/:productId` | HEALTH_PARTNER | `AttachTagResponseDto` |
| `DELETE` | `/v1/partner/service-tags/:id/products/:productId` | HEALTH_PARTNER | No Content (204) |
| `GET` | `/v1/partner/service-tags/products/:productId` | HEALTH_PARTNER | `ServiceTagResponseDto[]` |

- All write endpoints have `@Throttle({ limit: 30, ttl: 60000 })`
- Uses `@CurrentUser('id')` for ownership enforcement
- `ParseUUIDPipe` on all ID params

## Completed

9 endpoints covering full tag lifecycle + product attachment/detachment. Active tags filter for quick access. Product-level tag listing for service detail screens. Full spec test coverage.
