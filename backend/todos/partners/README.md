# Partners Feature — Todo Pipeline

This folder documents the implementation history of the **Partners Module** (business partner registration, profile management, document verification).

## Ordering

Files are numbered `01-` through `05-`. They were executed sequentially.

## Status Convention

Each file starts with a `Status:` line:
- `🔲 TODO` — not started
- `🔄 IN PROGRESS` — currently being worked on
- `✅ COMPLETED` — done, review the **Completed** section for what was implemented

## What's Already Built

| Component | Status | Location |
|---|---|---|
| `Partner` entity | ✅ | `src/common/entities/partner.entity.ts` |
| `LegalRepresentative` entity | ✅ | `src/common/entities/legal-representative.entity.ts` |
| `PartnerDocument` entity | ✅ | `src/common/entities/partner-document.entity.ts` |
| `PartnerReviewLog` entity | ✅ | `src/common/entities/partner-review-log.entity.ts` |
| `DocumentRequirement` entity | ✅ | `src/common/entities/document-requirement.entity.ts` |
| Business type, verification status, document enums | ✅ | `src/partners/enum/` |
| Database migrations | ✅ | `migrations/scripts/` |
| Geocoding integration (`latitude`/`longitude`) | ✅ | `partner.entity.ts`, `register-partner.handler.ts` |
