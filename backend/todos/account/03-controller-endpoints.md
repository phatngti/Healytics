# 03 — Controller & Endpoints

**Status:** ✅ COMPLETED

## Context

With handlers ready (todo 02), this wires up the controller endpoints. Account endpoints are accessible to all authenticated users (ALL_ROLES).

## Prerequisites

- ✅ Todo 02 — Handlers implemented
- ✅ `JwtAuthGuard`, `RolesGuard`, `ALL_ROLES` from auth module

## Tasks

### 1. Create Request/Response DTOs
- `src/account/dto/request/survey.dto.ts` — survey JSONB payload
- `src/account/dto/response/survey-response.dto.ts` — survey data response

### 2. Wire `AccountController`

Security: `@UseGuards(JwtAuthGuard, RolesGuard)` + `@Roles(...ALL_ROLES)` at class level.

| Method | Path | Auth | Response |
|---|---|---|---|
| `GET` | `/v1/account/survey` | JWT + ALL_ROLES | `SurveyResponseDto` |
| `POST` | `/v1/account/survey` | JWT + ALL_ROLES | `SurveyResponseDto` |

- GET survey: `accountService.getSurveyResponse(userId)`
- POST survey: one-shot creation with `@Throttle({ limit: 5, ttl: 60000 })`
- Uses `@CurrentUser('id')` decorator to extract user ID from JWT
- Uses `@ClassSerializerInterceptor` for response transformation

### 3. Create spec files
- `account.controller.spec.ts` — controller unit tests
- `account.service.spec.ts` — service unit tests

## Completed

Controller wired with ALL_ROLES security. Survey endpoints support one-shot creation (ConflictException on duplicate). Spec files provide test coverage for both controller and service layers.
