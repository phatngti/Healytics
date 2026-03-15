# 01 — Entities & Module Setup

**Status:** ✅ COMPLETED

## Context

The Partners module handles the complete lifecycle of business partners — from registration through verification. Partners are health-service providers (clinics, spas, etc.) that register on the platform.

## Prerequisites

- ✅ `Account` entity and `AccountModule` (for linking partner to account)
- ✅ `Location` entity and `LocationsModule` (for address hierarchy)
- ✅ `S3Module` for document uploads

## Tasks

### 1. Create entities in `src/common/entities/`
- **`partner.entity.ts`** — business name, business type, tax code, address, verification status, account FK
- **`legal-representative.entity.ts`** — name, ID type, ID number, phone, linked to Partner
- **`partner-document.entity.ts`** — document type, file URL, status, review notes, linked to Partner
- **`partner-review-log.entity.ts`** — reviewer ID, action, notes, timestamps
- **`document-requirement.entity.ts`** — required document types per business type

### 2. Create enums in `src/partners/enum/`
- `business-type.enum.ts` — CLINIC, SPA, MASSAGE, etc. (with Vietnamese labels)
- `partner-verification-status.enum.ts` — PENDING, APPROVED, REJECTED, SUSPENDED
- `document-type.enum.ts` — business license, medical practice cert, etc.
- `document-status.enum.ts` — PENDING, APPROVED, REJECTED
- `partner-document-status.enum.ts`
- `id-type.enum.ts` — CMND, CCCD, PASSPORT

### 3. Create `src/partners/partners.module.ts`
```typescript
@Module({
  imports: [
    TypeOrmModule.forFeature([Account, Partner, LegalRepresentative, DocumentRequirement, PartnerDocument, PartnerReviewLog]),
    LocationsModule, S3Module, forwardRef(() => AuthModule),
  ],
  controllers: [PartnersController, PartnerSelfController],
  providers: [PartnersService, RegisterPartnerHandler, UpdatePartnerProfileHandler],
  exports: [PartnersService],
})
```

## Completed

All entities and enums created. Module registered with all dependencies. `forwardRef` used to handle circular dependency with `AuthModule`.
