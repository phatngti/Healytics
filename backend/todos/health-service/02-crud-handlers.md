# 02 — CRUD Handlers

**Status:** ✅ COMPLETED

## Context

With entities and module ready (todo 01), this implements the business logic handlers for health service CRUD. Creation is the most complex — creating a product with media, definitions, resource requirements, and employee eligibility in a single transaction.

## Prerequisites

- ✅ Todo 01 — Entities and module setup
- ✅ Partner DTOs for health service creation

## Tasks

### 1. Create DTOs in `src/health-service/dto/partner/`
- **`create-partner-health-service.dto.ts`** — full creation DTO with nested media, definitions, resources, eligibility
- **`update-partner-health-service.dto.ts`** — PartialType
- **`partner-health-service-response.dto.ts`** — partner-facing list response
- **`partner-health-service-detail-response.dto.ts`** — full detail with all relations

### 2. Create `src/health-service/application/handlers/create-health-service.handler.ts`
**Logic:**
```
1. Resolve partnerId from accountId
2. Create Product entity with base fields
3. Create ProductDefinition (duration, capacity)
4. Create ProductMedia entries (images/videos)
5. Create ProductResourceRequirements
6. Create ProductEmployeeEligibility entries
7. Save all in transaction
8. Return PartnerHealthServiceResponseDto
```

### 3. Create `src/health-service/application/handlers/update-health-service.handler.ts`
- Loads product by ID scoped to partner
- Updates base fields and nested relations
- Handles media/eligibility add/remove

### 4. Create `src/health-service/application/handlers/remove-health-service.handler.ts`
- Loads product by ID scoped to partner
- Soft deletes with cascade

## Completed

Three handlers cover full CRUD lifecycle. Create handles complex multi-entity transactional creation. Update supports partial updates on nested relations. Remove uses soft delete.
