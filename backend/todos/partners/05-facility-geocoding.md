# 05 — Facility Geocoding on Registration

**Status:** ✅ COMPLETED

## Context

Integrate Mapbox Geocoding API into partner registration to automatically convert facility addresses to geographic coordinates (lat/lng) and store them in the partner profile.

## Prerequisites

- ✅ `04-public-endpoints.md` completed
- ✅ `MapboxModule` with `MapboxService` (Geocoding API)
- ✅ `Location` entity with `fullName` for building address strings

## Tasks

### 1. Add `latitude`/`longitude` columns to `Partner` entity
- `decimal(10, 7)`, nullable — precision for ~1.1m accuracy
- Placed after `streetAddress`

### 2. Create migration `1773500000000-AddGeoColumnsToPartnerProfile`
- Uses `IF NOT EXISTS` guard for safe idempotent execution
- `down()` drops both columns with `IF EXISTS`

### 3. Import `MapboxModule` in `PartnersModule`

### 4. Inject `MapboxService` into `RegisterPartnerHandler`
- After `validateAddress()`, compose full address: `"{streetAddress}, {ward.fullName}, {district.fullName}, {province.fullName}, Vietnam"`
- Call `mapboxService.geocode(fullAddress)` — **non-blocking**: if geocoding fails, log warning and continue with null coordinates
- Pass `latitude`/`longitude` to the `Partner.create()` call

## Completed

- Added `latitude` and `longitude` decimal(10,7) columns to `Partner` entity
- Created migration `1773500000000-AddGeoColumnsToPartnerProfile` (ran successfully)
- Imported `MapboxModule` into `PartnersModule`
- Updated `RegisterPartnerHandler` with `buildFullAddress()` + non-blocking `geocode()`
- TypeScript build clean, 14/14 partner tests pass
