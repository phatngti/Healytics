# 01 — Entity & Module Setup

**Status:** ✅ COMPLETED

## Context

The Audit module provides cross-cutting audit logging infrastructure. It stores a record of admin actions (partner reviews, data changes) with actor information, timestamps, and request metadata.

## Prerequisites

- ✅ TypeORM configured in `AppModule`
- ✅ Database migration for `audit_logs` table

## Tasks

### 1. Create `src/common/entities/audit-log.entity.ts`
Fields:
- `id` (UUID, PK)
- `action` (string — e.g., 'PARTNER_REVIEW')
- `entityType` (string — e.g., 'Partner')
- `entityId` (UUID)
- `actorId` (UUID — who performed the action)
- `metadata` (JSONB — request body, changes, etc.)
- `createdAt`

### 2. Create `src/audit/audit.module.ts`
```typescript
@Module({
  imports: [TypeOrmModule.forFeature([AuditLog])],
  controllers: [AuditController],
  providers: [AuditService],
  exports: [AuditService],
})
```

## Completed

AuditLog entity with JSONB metadata for flexible audit data. Module exported for use by AdminModule.
