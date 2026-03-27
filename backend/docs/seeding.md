# Database Seeding Guide

Master data (locations, document requirements) is now seeded via **TypeORM migrations** inside `migrations/master-data/`.

## How It Works

Seeds are `MigrationInterface` classes that run automatically with schema migrations:

```bash
npm run migration:run
```

This runs **all** pending migrations in order, including:
1. Schema migrations (`migrations/scripts/`)
2. Master data seeds (`migrations/master-data/`)

## Seed Migrations

| Migration Class | File | Purpose |
|:---|:---|:---|
| `SeedLocations1770100000000` | `migrations/master-data/location.seed.ts` | Seeds Vietnam administrative units (Provinces, Districts, Wards) |
| `SeedDocumentRequirements1770100000001` | `migrations/master-data/document-requirements.seed.ts` | Seeds document requirement rules per business type |

## Reverting Seeds

To revert the last migration (including seeds):

```bash
npm run migration:revert
```

## Manual Seed Endpoint

The `POST /locations/seed` endpoint is still available to re-seed locations on demand.
