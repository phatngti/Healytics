# Mapbox Integration — Todo Pipeline

This folder contains the implementation pipeline for the **Mapbox Module** (Geocoding + Distance Matrix + Client Key). Each file is a self-contained todo with full context so any agent can pick up from where the previous one left off.

## Ordering

Files are numbered `01-` through `04-`. Execute sequentially.

## Status Convention

Each file starts with a `Status:` line:
- `🔲 TODO` — not started
- `🔄 IN PROGRESS` — currently being worked on
- `✅ COMPLETED` — done, review the **Completed** section for what was implemented

## What's Already Built (Before This Pipeline)

| Component | Status | Location |
|---|---|---|
| Config (`mapbox.config.ts`) | ✅ | `src/config/` |
| DTOs (6 files) | ✅ | `src/mapbox/dto/` |
| Service (`MapboxService`) | ✅ | `src/mapbox/` |
| Controller (`MapboxController`) | ✅ | `src/mapbox/` |
| Module (`MapboxModule`) | ✅ | `src/mapbox/` |
| Wired in `app.module.ts` | ✅ | `src/app.module.ts` |
| `.env` vars (`MAPBOX_ACCESS_TOKEN`, `MAPBOX_PUBLIC_TOKEN`) | ✅ | `.env` |
| Unit tests (12 passing) | ✅ | `src/mapbox/*.spec.ts` |
