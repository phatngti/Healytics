# Service Tags Feature — Todo Pipeline

This folder documents the implementation history of the **Service Tags Module** (custom tag management with product attachment for partners).

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
| `ProductFeatureTag` entity | ✅ | `src/common/entities/product-feature-tag.entity.ts` |
| `ProductTag` entity (junction) | ✅ | `src/common/entities/product-tag.entity.ts` |
| Database migrations | ✅ | `migrations/scripts/` |
