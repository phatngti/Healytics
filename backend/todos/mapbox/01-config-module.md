# 01 — Config & Module Shell

**Status:** ✅ COMPLETED

## Context

Set up the Mapbox module with NestJS `registerAs` config, `HttpModule` for making API calls, and wire into the app module.

## Prerequisites

- ✅ `@nestjs/axios` installed
- ✅ `@nestjs/config` configured globally in `app.module.ts`

## Tasks

### 1. Create `src/config/mapbox.config.ts`
- `registerAs('mapbox')` reading `MAPBOX_ACCESS_TOKEN` and `MAPBOX_PUBLIC_TOKEN` from `.env`

### 2. Update `.env`
- Add `MAPBOX_ACCESS_TOKEN=` and `MAPBOX_PUBLIC_TOKEN=`

### 3. Create `src/mapbox/mapbox.module.ts`
- Import `HttpModule` for HTTP calls
- Register service + controller
- Export `MapboxService` for cross-module use

### 4. Wire into `src/app.module.ts`
- Import `MapboxModule`
- Load `mapboxConfig` in `ConfigModule.forRoot({ load: [...] })`

## Completed

- Created `src/config/mapbox.config.ts` with `registerAs('mapbox')`
- Created `src/mapbox/mapbox.module.ts` with `HttpModule`
- Added `MAPBOX_ACCESS_TOKEN` and `MAPBOX_PUBLIC_TOKEN` to `.env`
- Wired `MapboxModule` + `mapboxConfig` into `app.module.ts`
