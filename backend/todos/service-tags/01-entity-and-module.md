# 01 — Entity & Module Setup

**Status:** ✅ COMPLETED

## Context

Service tags allow partners to create custom feature tags (e.g., "Relaxation", "Pain Relief") and attach them to their health services. This enables rich filtering and discovery on the user-facing app.

## Prerequisites

- ✅ `Product` entity (tags attach to products)
- ✅ Database migrations for `product_feature_tags` and `product_tags` tables

## Tasks

### 1. Create entities
- **`product-feature-tag.entity.ts`** — name, slug, icon, color, description, isActive, createdByAccountId
- **`product-tag.entity.ts`** — junction table linking `ProductFeatureTag` ↔ `Product` (many-to-many)

### 2. Create `src/service-tags/service-tags.module.ts`
```typescript
@Module({
  imports: [TypeOrmModule.forFeature([ProductFeatureTag, ProductTag])],
  controllers: [ServiceTagsController],
  providers: [ServiceTagsService, CreateServiceTagHandler, UpdateServiceTagHandler, RemoveServiceTagHandler, AttachProductTagHandler, DetachProductTagHandler],
  exports: [ServiceTagsService],
})
```

## Completed

Entities created with proper many-to-many junction table. Module registered with 5 handlers covering full tag lifecycle + attachment operations.
