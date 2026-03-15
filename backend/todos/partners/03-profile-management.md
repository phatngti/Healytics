# 03 — Profile Management

**Status:** ✅ COMPLETED

## Context

After registration (todo 02), partners can view and update their business profile. Profile updates may involve re-verification for certain fields.

## Prerequisites

- ✅ Todo 02 — Registration flow
- ✅ S3Module for avatar/document uploads

## Tasks

### 1. Create `src/partners/application/handlers/update-partner-profile.handler.ts`
**Logic:**
- Loads Partner by account ID with relations
- Updates allowed fields (business name, phone, address, etc.)
- Handles address hierarchy re-resolution if address fields change
- Updates LegalRepresentative if provided
- Saves and returns updated profile

### 2. Create Response DTOs
- **`my-profile-response.dto.ts`** — comprehensive profile with legal representative, documents, verification status
- **`partner-detail-response.dto.ts`** — public partner detail
- **`partners-response.dto.ts`** — paginated list response

### 3. Create Request DTOs
- **`update-partner.dto.ts`** — partial update fields (business name, phone, address, services, etc.)
- **`get-partners-query.dto.ts`** — pagination and filter query params

## Completed

Profile management fully implemented. Partners can GET their own profile and PUT updates. `UpdatePartnerProfileHandler` handles complex nested updates including address re-resolution and legal representative changes.
