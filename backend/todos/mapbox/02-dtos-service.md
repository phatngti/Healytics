# 02 — DTOs & Service

**Status:** ✅ COMPLETED

## Context

Create the DTO layer (request validation + response shapes) and the core service wrapping Mapbox REST APIs (Geocoding v5 + Matrix API).

## Prerequisites

- ✅ `01-config-module.md` completed
- ✅ `MapboxModule` with `HttpModule` and config

## Tasks

### 1. Create Request DTOs in `src/mapbox/dto/`
- `geocode-query.dto.ts` — `address: string` with `@IsString()`, `@IsNotEmpty()`, `@MaxLength(500)`
- `reverse-geocode-query.dto.ts` — `lat: number` with `@IsLatitude()`, `lng: number` with `@IsLongitude()`, `@Type(() => Number)` for query parsing
- `distance-matrix-query.dto.ts` — `origins: string`, `destinations: string` (pipe-separated)

### 2. Create Response DTOs in `src/mapbox/dto/`
- `geocode-response.dto.ts` — `GeocodeResultDto` (`lat`, `lng`, `formattedAddress`, `placeId`), `GeocodeResponseDto` (`results[]`)
- `distance-matrix-response.dto.ts` — `DistanceMatrixElementDto`, `DistanceMatrixRowDto`, `DistanceMatrixResponseDto`
- `client-key-response.dto.ts` — `ClientKeyResponseDto` (`apiKey`)

### 3. Create `src/mapbox/mapbox.service.ts`
- `geocode(address)` → Mapbox Geocoding v5 (forward) → `GeocodeResponseDto`
- `reverseGeocode(lat, lng)` → Mapbox Geocoding v5 (reverse, `lng,lat` order) → `GeocodeResponseDto`
- `distanceMatrix(origins, destinations)` → Mapbox Matrix API → `DistanceMatrixResponseDto`
  - Converts pipe-separated `lat,lng` input to Mapbox's semicolon-separated `lng,lat` format
  - Formats raw meters/seconds into human-readable text
- `getClientApiKey()` → returns `MAPBOX_PUBLIC_TOKEN`
- Error handling: throw `BadRequestException` on API error

## Completed

- Created 3 request DTOs and 3 response DTOs in `src/mapbox/dto/`
- Created `MapboxService` with 4 methods wrapping Mapbox API via `@nestjs/axios`
- Proper error handling, logging, coordinate format conversion, and response mapping
