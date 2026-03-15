# 04 — Partner & Admin Authentication

**Status:** ✅ COMPLETED

## Context

Extends the auth system (todo 03) with endpoints for partner and admin login. Partner registration is delegated to `PartnersService` (circular dependency handled with `forwardRef`).

## Prerequisites

- ✅ Todo 03 — User auth flow
- ✅ `PartnersModule` with `RegisterPartnerHandler`

## Tasks

### 1. Create additional Request DTOs
- `src/auth/dto/request/partner-login.dto.ts` — email, password (Swagger-typed for partner)
- `src/auth/dto/request/admin-login.dto.ts` — email, password (Swagger-typed for admin)

### 2. Implement `AuthService` partner/admin methods
```typescript
loginPartner(account: Account): Promise<AuthTokensDto>
loginAdmin(account: Account): Promise<AuthTokensDto>
refreshPartner(refreshToken: string): Promise<AuthTokensDto>
```
- `loginPartner` checks `role === HEALTH_PARTNER`, throws `ForbiddenException` otherwise
- `loginAdmin` checks `role in ADMIN_ROLES`
- `refreshPartner` includes partner verification status in token payload

### 3. Wire `AuthController` endpoints

| Method | Path | Auth | Response |
|---|---|---|---|
| `POST` | `/v1/auth/partner/register` | Public | `RegisterPartnerResponseDto` |
| `POST` | `/v1/auth/partner/login` | LocalAuthGuard | `AuthTokensDto` |
| `POST` | `/v1/auth/partner/refresh` | Public | `AuthTokensDto` |
| `POST` | `/v1/auth/admin/login` | LocalAuthGuard | `AuthTokensDto` |

### 4. Handle circular dependency
```typescript
@Inject(forwardRef(() => PartnersService))
private partnersService: PartnersService
```
`registerPartner()` delegates to `partnersService.registerPartner(dto)`.

## Completed

Three user types fully supported (User, Partner, Admin). Partner registration creates business entity + legal representative + account. Admin login restricted to ADMIN_ROLES. Partner refresh includes verification info in JWT payload.
