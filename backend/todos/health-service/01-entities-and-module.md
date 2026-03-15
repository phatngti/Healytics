# 01 — Entities & Module Setup

**Status:** ✅ COMPLETED

## Context

Health Services are the core offering of the platform. Internally backed by `Product` entities, they represent medical/wellness services offered by partners. The data model is complex — a product has media, reviews, facility images, definitions, resource requirements, and employee eligibility mappings.

## Prerequisites

- ✅ `Partner` entity (products belong to a partner)
- ✅ `Employee` entity (for eligibility mapping)
- ✅ `PartnersModule` exported
- ✅ Database migrations for 8+ related tables

## Tasks

### 1. Create entities in `src/common/entities/`
- **`product.entity.ts`** — name, description, price, duration, category, partner FK, status, type
- **`product-definition.entity.ts`** — durationMinutes, maxCapacity, preparation instructions
- **`product-media.entity.ts`** — mediaUrl, mediaType (IMAGE/VIDEO), displayOrder
- **`product-review.entity.ts`** — rating, comment, userId
- **`product-facility-image.entity.ts`** — imageUrl, caption
- **`resource-type.entity.ts`** — resource category definitions
- **`product-resource-requirement.entity.ts`** — required resources per service
- **`product-employee-eligibility.entity.ts`** — which employees can perform which service

### 2. Create enums in `src/health-service/enums/`
- `health-service-status.enum.ts` — ACTIVE, INACTIVE
- `health-service-type.enum.ts` — MEDICAL, WELLNESS
- `media-type.enum.ts` — IMAGE, VIDEO
- `staff-assignment-type.enum.ts` — MANUAL, AUTOMATIC

### 3. Create `src/health-service/health-service.module.ts`
```typescript
@Module({
  imports: [
    TypeOrmModule.forFeature([Product, ProductMedia, ProductReview, ProductFacilityImage, ProductDefinition, ResourceType, ProductResourceRequirement, ProductEmployeeEligibility, Employee]),
    PartnersModule,
  ],
  controllers: [HealthServiceController, PartnerHealthServiceController],
  providers: [HealthServiceService, CreateHealthServiceHandler, UpdateHealthServiceHandler, RemoveHealthServiceHandler],
  exports: [HealthServiceService],
})
```

## Completed

8 entities created covering the full product data model. Module registered with all relations and both public and partner controllers. Enums defined for status, type, media, and staff assignment.
