# Health Service Feature — Todo Pipeline

This folder documents the implementation history of the **Health Service Module** (product-backed health service management for partners and public browsing).

## Ordering

Files are numbered `01-` through `04-`. They were executed sequentially.

## Status Convention

Each file starts with a `Status:` line:
- `🔲 TODO` — not started
- `🔄 IN PROGRESS` — currently being worked on
- `✅ COMPLETED` — done, review the **Completed** section for what was implemented

## What's Already Built

| Component | Status | Location |
|---|---|---|
| `Product` entity | ✅ | `src/common/entities/product.entity.ts` |
| `ProductDefinition` entity | ✅ | `src/common/entities/product-definition.entity.ts` |
| `ProductMedia` entity | ✅ | `src/common/entities/product-media.entity.ts` |
| `ProductReview` entity | ✅ | `src/common/entities/product-review.entity.ts` |
| `ProductFacilityImage` entity | ✅ | `src/common/entities/product-facility-image.entity.ts` |
| `ResourceType` entity | ✅ | `src/common/entities/resource-type.entity.ts` |
| `ProductResourceRequirement` entity | ✅ | `src/common/entities/product-resource-requirement.entity.ts` |
| `ProductEmployeeEligibility` entity | ✅ | `src/common/entities/product-employee-eligibility.entity.ts` |
| Health service enums | ✅ | `src/health-service/enums/` |
| Database migrations | ✅ | `migrations/scripts/` |

## Design Notes

The module was refactored from the legacy "Products" module to use "Health Service" naming externally while keeping the underlying `Product` database schema. See KI: `health_service_feature_core` for full refactoring history.
