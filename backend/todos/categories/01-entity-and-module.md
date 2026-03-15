# 01 — Entity & Module Setup

**Status:** ✅ COMPLETED

## Context

Categories organize health services into a hierarchical tree. Categories have parent-child relationships, slugs for URL-friendly access, and optional icons/images.

## Prerequisites

- ✅ TypeORM configured in `AppModule`
- ✅ Database migration for `categories` table

## Tasks

### 1. Create `src/common/entities/category.entity.ts`
Fields:
- `id` (UUID, PK), `name`, `slug` (unique)
- `description`, `iconUrl`, `imageUrl`
- `parentId` (self-referencing FK, nullable)
- `parent` (ManyToOne → Category), `children` (OneToMany → Category)
- `createdAt`, `updatedAt`, `deletedAt` (soft delete)

### 2. Create `src/categories/categories.module.ts`
```typescript
@Module({
  imports: [TypeOrmModule.forFeature([Category])],
  controllers: [CategoriesController],
  providers: [CategoriesService, CreateCategoryHandler, UpdateCategoryHandler, RemoveCategoryHandler],
  exports: [CategoriesService],
})
```

## Completed

Category entity with tree structure (self-referencing FK). Soft delete support via `@DeleteDateColumn`. Module registered with all CRUD handlers.
