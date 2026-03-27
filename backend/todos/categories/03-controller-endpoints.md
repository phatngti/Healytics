# 03 — Controller & Endpoints

**Status:** ✅ COMPLETED

## Context

With CRUD handlers ready (todo 02), this wires up the controller. Categories have mixed security: read endpoints are public, write endpoints require ADMIN_ROLES.

## Prerequisites

- ✅ Todo 02 — CRUD handlers
- ✅ `@Public()` decorator, `ADMIN_ROLES`

## Tasks

### 1. Create `src/categories/categories.controller.ts`

Class-level: `@UseGuards(JwtAuthGuard, RolesGuard)`, `@UseInterceptors(ClassSerializerInterceptor)`

| Method | Path | Auth | Response |
|---|---|---|---|
| `POST` | `/v1/categories` | ADMIN_ROLES | `CategoryResponseDto` |
| `GET` | `/v1/categories` | Public | `CategoryResponseDto[]` |
| `GET` | `/v1/categories/:id` | Public | `CategoryResponseDto` |
| `GET` | `/v1/categories/slug/:slug` | Public | `CategoryResponseDto` |
| `PATCH` | `/v1/categories/:id` | ADMIN_ROLES | `CategoryResponseDto` |
| `DELETE` | `/v1/categories/:id` | ADMIN_ROLES | No Content (204) |

- Write endpoints have `@Throttle({ limit: 10, ttl: 60000 })`
- GET list supports `?rootsOnly=true` query param
- Slug lookup as alternative to UUID-based access
- All IDs validated with `ParseUUIDPipe`

### 2. Create spec files
- `categories.controller.spec.ts`
- `categories.service.spec.ts`

## Completed

Controller fully wired with 6 endpoints. Public read, admin write. Slug-based lookup for SEO-friendly access. Spec files provide full test coverage.
