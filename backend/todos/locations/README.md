# Locations Feature — Todo Pipeline

This folder documents the implementation history of the **Locations Module** (read-only Vietnam administrative location data: provinces, districts, wards).

## Ordering

Files are numbered `01-` through `02-`. They were executed sequentially.

## Status Convention

Each file starts with a `Status:` line:
- `🔲 TODO` — not started
- `🔄 IN PROGRESS` — currently being worked on
- `✅ COMPLETED` — done, review the **Completed** section for what was implemented

## What's Already Built

| Component | Status | Location |
|---|---|---|
| `Location` entity | ✅ | `src/common/entities/location.entity.ts` |
| `LocationLevel` enum | ✅ | `src/common/entities/location-level.enum.ts` |
| Database seed data (provinces/districts/wards) | ✅ | `seeds/` |
