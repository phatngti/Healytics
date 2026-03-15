# 03 — Public Endpoints

**Status:** ✅ COMPLETED

## Context

With CRUD handlers ready (todo 02), this creates the public-facing endpoints for browsing health services. These are used by the mobile app's home screen, search, and detail pages.

## Prerequisites

- ✅ Todo 02 — CRUD handlers
- ✅ Public response DTOs

## Tasks

### 1. Create DTOs in `src/health-service/dto/public/`
- **`public-health-service-card-response.dto.ts`** — card format for listings (name, price, thumbnail, rating)
- **`public-health-service-response.dto.ts`** — full public service detail
- **`public-health-service-info-response.dto.ts`** — service info tab data
- **`public-health-service-employee-response.dto.ts`** — eligible employees for a service
- **`public-health-service-review-response.dto.ts`** — reviews list
- **`public-health-service-recommended-response.dto.ts`** — same-category recommendations

### 2. Create `HealthServiceController` (public)

| Method | Path | Auth | Response |
|---|---|---|---|
| `GET` | `/v1/health-services/premium-treatments` | Public | `PublicHealthServiceCardResponseDto[]` |
| `GET` | `/v1/health-services/home-recommend` | Public | `PublicHealthServiceCardResponseDto[]` |
| `GET` | `/v1/health-services/:id` | Public | `PublicHealthServiceResponseDto` |
| `GET` | `/v1/health-services/:id/info` | Public | `PublicHealthServiceInfoResponseDto` |
| `GET` | `/v1/health-services/:id/employees` | Public | `PublicHealthServiceEmployeeResponseDto[]` |
| `GET` | `/v1/health-services/:id/reviews` | Public | `PublicHealthServiceReviewResponseDto[]` |
| `GET` | `/v1/health-services/:id/recommended` | Public | `PublicHealthServiceRecommendedResponseDto[]` |

- Detail sub-endpoints use `@LogResponse()` for debugging
- All public, no auth required

## Completed

7 public endpoints covering home screen cards, full detail view with sub-tabs (info, employees, reviews, recommended). 6 public response DTOs with static `fromEntity()` pattern.
