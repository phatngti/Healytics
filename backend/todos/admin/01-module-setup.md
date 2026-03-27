# 01 — Module Setup

**Status:** ✅ COMPLETED

## Context

The Admin module provides administrative capabilities, starting with partner management and review. It depends on `AuditModule` for audit logging and `PartnersModule` for partner data access.

## Prerequisites

- ✅ `AuditModule` with `AuditInterceptor` and `@Audit()` decorator
- ✅ `PartnersModule` with `PartnersService`
- ✅ Partner, PartnerDocument, PartnerReviewLog entities

## Tasks

### 1. Create `src/admin/admin.module.ts`
```typescript
@Module({
  imports: [
    TypeOrmModule.forFeature([Partner, PartnerDocument, Account, PartnerReviewLog, DocumentRequirement]),
    AuditModule,
    PartnersModule,
  ],
  controllers: [AdminPartnersController],
  providers: [AdminPartnersService, ReviewPartnerHandler],
  exports: [AdminPartnersService],
})
```

### 2. Create `src/admin/services/admin-partners.service.ts`
Service facade with methods:
- `getPartners(query)` — paginated partner list
- `getTotalPartners()` — total count
- `getPartnerDetail(id)` — full partner detail with documents
- `reviewPartner(id, dto, reviewerId)` — partner review flow

## Completed

Module created with all dependencies. Service facade delegates to `ReviewPartnerHandler` for review operations.
