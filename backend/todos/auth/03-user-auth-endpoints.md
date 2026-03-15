# 03 — User Authentication Endpoints

**Status:** ✅ COMPLETED

## Context

With guards and strategies ready (todos 01-02), this implements the user-facing auth endpoints: register, login, token refresh, and logout.

## Prerequisites

- ✅ Todo 01 — Passport strategies
- ✅ Todo 02 — Guards and decorators
- ✅ `AccountModule` with `CreateAccountHandler`

## Tasks

### 1. Create Request DTOs
- `src/auth/dto/request/register.dto.ts` — email, password, profile fields
- `src/auth/dto/request/register-profile.dto.ts` — nested profile data
- `src/auth/dto/request/login.dto.ts` — email, password
- `src/auth/dto/request/refresh-token-request.dto.ts` — refresh_token string

### 2. Create Response DTOs
- `src/auth/dto/response/auth-tokens-response.dto.ts` — `{ access_token, refresh_token }`
- `src/auth/dto/response/logout-response.dto.ts` — `{ message }`

### 3. Implement `AuthService` core methods
```typescript
register(dto: RegisterDto): Promise<AuthTokensDto>
loginUser(account: Account): Promise<AuthTokensDto>
refresh(refreshToken: string): Promise<AuthTokensDto>
logout(userId: string): Promise<LogoutResponseDto>
validateUser(email: string, password: string): Promise<Account>
```
- Password hashing with bcrypt
- JWT token pair generation (access + refresh)
- Refresh token stored in DB via `SetRefreshTokenHandler`

### 4. Wire `AuthController` endpoints

| Method | Path | Auth | Response |
|---|---|---|---|
| `POST` | `/v1/auth/user/register` | Public | `AuthTokensDto` |
| `POST` | `/v1/auth/user/login` | LocalAuthGuard | `AuthTokensDto` |
| `POST` | `/v1/auth/refresh` | Public | `AuthTokensDto` |
| `POST` | `/v1/auth/logout` | JwtAuthGuard | `LogoutResponseDto` |

All login/register endpoints have `@Throttle({ default: { limit: 5, ttl: 60000 } })`.

## Completed

User auth flow fully implemented. Register creates account + profile, hashes password, returns JWT pair. Login validates via LocalStrategy. Refresh validates stored refresh token. Logout clears refresh token.
