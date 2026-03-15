# 02 — Service & Endpoints

**Status:** ✅ COMPLETED

## Context

With the entity ready (todo 01), this creates the service and controller for hierarchical location queries. All endpoints are publicly accessible (reference data).

## Prerequisites

- ✅ Todo 01 — Location entity and module
- ✅ Seed data loaded into database

## Tasks

### 1. Create Response DTOs
- **`location-response.dto.ts`** — `LocationListResponseDto` wrapping array of locations

### 2. Create `LocationsService`
Methods:
- `getAllProvinces()` — Query all locations WHERE level = PROVINCE
- `getDistrictsByProvinceId(provinceId)` — Query WHERE parentId = provinceId AND level = DISTRICT
- `getWardsByDistrictId(districtId)` — Query WHERE parentId = districtId AND level = WARD

### 3. Create `LocationsController`

| Method | Path | Auth | Response |
|---|---|---|---|
| `GET` | `/v1/locations/provinces` | Public | `LocationListResponseDto` |
| `GET` | `/v1/locations/provinces/:provinceId/districts` | Public | `LocationListResponseDto` |
| `GET` | `/v1/locations/districts/:districtId/wards` | Public | `LocationListResponseDto` |

- All endpoints `@Public()` (read-only reference data)
- `ParseUUIDPipe` on ID params

### 4. Create spec files
- `locations.controller.spec.ts`
- `locations.service.spec.ts`

## Completed

3 public hierarchical query endpoints. Cascading drill-down: provinces → districts → wards. Used by partner registration for address selection. Full spec coverage.
