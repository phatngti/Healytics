# 03 — Controller & Endpoints

**Status:** ✅ COMPLETED

## Context

Create public API endpoints for geocoding, reverse geocoding, distance matrix, and serving the public access token.

## Prerequisites

- ✅ `02-dtos-service.md` completed
- ✅ `MapboxService` with all 4 methods

## Tasks

### 1. Create `src/mapbox/mapbox.controller.ts`
- `GET /mapbox/geocode?address=...` → `@Public()`, delegates to `service.geocode()`
- `GET /mapbox/reverse-geocode?lat=...&lng=...` → `@Public()`, delegates to `service.reverseGeocode()`
- `GET /mapbox/distance-matrix?origins=...&destinations=...` → `@Public()`, delegates to `service.distanceMatrix()`
- `GET /mapbox/client-key` → `@Public()`, returns `{ apiKey: service.getClientApiKey() }`
- All endpoints use `@ApiOperation()` + `@ApiOkResponse()` for Swagger docs
- Controller follows project pattern: `@ApiTags`, `@ApiBearerAuth`, `@UseGuards`, `@UseInterceptors`

## Completed

- Created `MapboxController` with 4 public endpoints
- All endpoints have Swagger documentation
- Follows project controller pattern with guards and serialization interceptor
