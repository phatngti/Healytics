# 04 — Public Endpoints & Controllers

**Status:** ✅ COMPLETED

## Context

With registration and profile management done (todos 02-03), this wires up all controller endpoints. The Partners module uses two controllers: `PartnersController` (public) and `PartnerSelfController` (authenticated partner).

## Prerequisites

- ✅ Todo 03 — Profile management handler
- ✅ `@PartnerApi` composite decorator from auth module

## Tasks

### 1. Create `PartnersController` (public)

| Method | Path | Auth | Response |
|---|---|---|---|
| `GET` | `/v1/partners/business-services` | Public | `BusinessServicesResponseDto` |

Returns list of all business service types with Vietnamese labels for dropdown selection.

### 2. Create `PartnerSelfController` (authenticated)
Uses `@PartnerApi('partners')` composite decorator.

| Method | Path | Auth | Response |
|---|---|---|---|
| `GET` | `/v1/partner/partners/me` | HEALTH_PARTNER | `MyProfileResponseDto` |
| `PUT` | `/v1/partner/partners/me` | HEALTH_PARTNER | `MyProfileResponseDto` |

- GET me: Returns full profile with legal representative, documents, verification status
- PUT me: Updates profile with rate limiting `@Throttle({ limit: 10, ttl: 60000 })`

### 3. Create Response DTOs
- **`business-types-response.dto.ts`** — list of business service options
- **`document-status-response.dto.ts`** — document verification status
- **`document-url-response.dto.ts`** — signed document URLs
- **`upload-url-response.dto.ts`** — presigned upload URLs

### 4. Create spec files
- `partners.controller.spec.ts`
- `partners.service.spec.ts`

## Completed

Two controllers wired: public `PartnersController` for reference data and `PartnerSelfController` for authenticated partner self-management. 11 response DTOs cover all partner data needs. Full test coverage in spec files.
