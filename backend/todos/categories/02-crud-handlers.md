# 02 — CRUD Handlers

**Status:** ✅ COMPLETED

## Context

With the entity and module ready (todo 01), this implements the business logic handlers for category CRUD operations.

## Prerequisites

- ✅ Todo 01 — Category entity and module setup
- ✅ DTOs: `CreateCategoryDto`, `UpdateCategoryDto`, `CategoryResponseDto`

## Tasks

### 1. Create DTOs in `src/categories/dto/`
- **`create-category.dto.ts`** — name, slug, description, iconUrl, imageUrl, parentId (optional)
- **`update-category.dto.ts`** — PartialType of CreateCategoryDto
- **`category-response.dto.ts`** — static `fromEntity()` pattern with nested children
- **`find-categories-query.dto.ts`** — `rootsOnly` boolean query param

### 2. Create `src/categories/application/handlers/create-category.handler.ts`
- Validates parent category exists (if parentId provided)
- Creates and saves new Category entity
- Returns `CategoryResponseDto.fromEntity()`

### 3. Create `src/categories/application/handlers/update-category.handler.ts`
- Loads category by ID → `NotFoundException` if not found
- Merges update fields
- Saves and returns updated category

### 4. Create `src/categories/application/handlers/remove-category.handler.ts`
- Loads category by ID → `NotFoundException` if not found
- Soft deletes the category
- Handles cascade for child categories

## Completed

All three CRUD handlers implemented. Create validates parent hierarchy. Update uses partial merge. Remove uses soft delete with cascade awareness.
