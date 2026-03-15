# 01 — Module Setup & Passport Strategies

**Status:** ✅ COMPLETED

## Context

The auth module is the foundational security layer for the entire application. It uses Passport.js with two strategies (Local for login, JWT for protected endpoints) and issues JWT access + refresh tokens.

## Prerequisites

- ✅ `Account` entity with `email`, `hashedPassword`, `role` fields
- ✅ `@nestjs/passport`, `@nestjs/jwt`, `passport-local`, `passport-jwt` installed

## Tasks

### 1. Create `src/auth/auth.module.ts`
```typescript
@Module({
  imports: [
    PassportModule.register({ session: false }),
    AccountModule,
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '3600s' },
    }),
    forwardRef(() => PartnersModule),
  ],
  controllers: [AuthController],
  providers: [AuthService, LocalStrategy, JwtStrategy],
  exports: [AuthService],
})
```

### 2. Create `src/auth/strategies/local.strategy.ts`
LocalStrategy extending `PassportStrategy(Strategy)`:
- Validates email + password via `AuthService.validateUser()`
- Returns the account on success, throws `UnauthorizedException` on failure

### 3. Create `src/auth/strategies/jwt.strategy.ts`
JwtStrategy extending `PassportStrategy(Strategy)`:
- Extracts JWT from `Authorization: Bearer` header
- Validates and returns `{ id, email, role }` payload

### 4. Create `src/auth/constants.ts`
JWT secret constant from environment variable.

### 5. Create `src/auth/constants/role-groups.ts`
```typescript
export const ADMIN_ROLES = [Role.ADMIN, Role.SUPER_ADMIN];
export const ALL_ROLES = [Role.USER, Role.HEALTH_PARTNER, ...ADMIN_ROLES];
```

## Completed

Module registered in `AppModule`. Passport configured with session-less mode. JWT tokens use 1-hour expiry.
