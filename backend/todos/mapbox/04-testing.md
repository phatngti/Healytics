# 04 — Testing & Verification

**Status:** ✅ COMPLETED

## Context

Write unit tests for the Mapbox service and controller, then verify the TypeScript build.

## Prerequisites

- ✅ `03-controller.md` completed
- ✅ All module files in place

## Tasks

### 1. Unit tests for `MapboxService`
- `mapbox.service.spec.ts` — mock `HttpService` + `ConfigService`
- Test: `getClientApiKey()` returns configured public token
- Test: `geocode()` returns results for valid address (GeoJSON feature mapping), empty for no features, throws on error
- Test: `reverseGeocode()` returns results, constructs URL with `lng,lat` order (Mapbox convention)
- Test: `distanceMatrix()` returns rows/elements with formatted text, throws on error

### 2. Unit tests for `MapboxController`
- `mapbox.controller.spec.ts` — mock `MapboxService`
- Test: each method delegates to the correct service method

### 3. Verify TypeScript build
- `npx tsc --noEmit` — no new errors from mapbox module

## Completed

- Created `mapbox.service.spec.ts` — 8 tests, all passing
- Created `mapbox.controller.spec.ts` — 4 tests, all passing
- Total: **2 suites, 12 tests, all ✅**
- TypeScript build clean (no new errors)
- Run with: `npx jest --testPathPatterns='src/mapbox/' --verbose`
