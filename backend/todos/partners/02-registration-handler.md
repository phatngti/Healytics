# 02 — Registration Handler

**Status:** ✅ COMPLETED

## Context

Partner registration is a multi-entity transactional operation. When a partner registers, we create an Account, Partner entity, and LegalRepresentative in a single transaction, then return auth tokens so they're immediately logged in.

## Prerequisites

- ✅ Todo 01 — Entities and module setup
- ✅ `AccountModule` with `CreateAccountHandler`
- ✅ `LocationsModule` for address validation

## Tasks

### 1. Create Request DTOs in `src/partners/dto/request/`
- **`register-partner.dto.ts`** — wraps `AccountRequestDto` + `PartnerRequestDto` + `LegalRepresentativeRequestDto`
- **`account-request.dto.ts`** — email, password
- **`partner-request.dto.ts`** — business name, business type, tax code, address fields
- **`legal-representative-request.dto.ts`** — full name, ID type, ID number, phone, address

### 2. Create Response DTOs
- **`register-partner-response.dto.ts`** — access_token, refresh_token, partnerId

### 3. Create `src/partners/application/handlers/register-partner.handler.ts`
**Logic:**
```
1. Begin DB transaction
2. Create Account (email, hashed password, role: HEALTH_PARTNER)
3. Resolve address hierarchy (province → district → ward)
4. Create Partner entity linked to account
5. Create LegalRepresentative linked to partner
6. Commit transaction
7. Generate JWT token pair
8. Return { access_token, refresh_token, partnerId }
```

### 4. Wire into `PartnersService.registerPartner()`
Called from `AuthController.registerPartner()` via `PartnersService`.

## Completed

Multi-entity registration with transactional safety. Address hierarchy validated through `LocationsService`. Auth tokens returned immediately. Called via `AuthController` partner/register endpoint.
