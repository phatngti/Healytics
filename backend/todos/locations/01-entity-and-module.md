# 01 — Entity & Module Setup

**Status:** ✅ COMPLETED

## Context

The Locations module provides reference data for Vietnam's administrative hierarchy (64 provinces → districts → wards). Data is seeded from official government records and is read-only.

## Prerequisites

- ✅ TypeORM configured in `AppModule`
- ✅ Database migration for `locations` table
- ✅ Seed data for Vietnam provinces/districts/wards

## Tasks

### 1. Create `src/common/entities/location.entity.ts`
Fields:
- `id` (UUID, PK), `name`, `code` (administrative code)
- `level` (enum: PROVINCE, DISTRICT, WARD)
- `parentId` (self-referencing FK, nullable)
- `parent` (ManyToOne → Location), `children` (OneToMany → Location)

### 2. Create `src/common/entities/location-level.enum.ts`
```typescript
export enum LocationLevel {
  PROVINCE = 'province',
  DISTRICT = 'district',
  WARD = 'ward',
}
```

### 3. Create `src/locations/locations.module.ts`
```typescript
@Module({
  imports: [TypeOrmModule.forFeature([Location])],
  controllers: [LocationsController],
  providers: [LocationsService],
  exports: [LocationsService],
})
```

## Completed

Location entity with hierarchical tree structure. Module exported for use by PartnersModule (address resolution).
