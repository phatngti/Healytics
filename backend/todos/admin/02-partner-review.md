# 02 — Partner Review Handler

**Status:** ✅ COMPLETED

## Context

The core business logic for admin partner management. When an admin reviews a partner, the handler updates the partner verification status, creates a review log, and optionally sends notifications.

## Prerequisites

- ✅ Todo 01 — Module setup
- ✅ `PartnerReviewLog` entity for audit trail
- ✅ `AuditModule` for request-level audit logging

## Tasks

### 1. Create DTOs in `src/admin/dto/`
- **`review-partner-profile.dto.ts`** — action (APPROVE/REJECT), notes
- **`review-partner-response.dto.ts`** — confirmation response
- **`admin-partner-detail-response.dto.ts`** — full partner detail with documents and review history
- **`total-partners-response.dto.ts`** — `{ total: number }`

### 2. Create `src/admin/application/handlers/review-partner.handler.ts`
**Logic:**
```
1. Load Partner by ID with documents
2. Validate partner is in PENDING state → BadRequestException if not
3. Update partner verification status (APPROVED/REJECTED)
4. Create PartnerReviewLog entry (reviewerId, action, notes)
5. If REJECTED: update individual document statuses
6. Save all changes
7. Return confirmation
```

## Completed

Review handler with full verification flow. Review logs provide audit trail. `BadRequestException` thrown for non-PENDING partners. Spec file covers approval and rejection paths.
