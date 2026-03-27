# 02 — Guards & Decorators

**Status:** ✅ COMPLETED

## Context

After Passport strategies are set up (todo 01), we need guards to enforce authentication and authorization. Guards are applied at controller/method level to gate access by auth status and role.

## Prerequisites

- ✅ Todo 01 — LocalStrategy, JwtStrategy registered
- ✅ `Role` enum in `src/account/enum/role.enum.ts`

## Tasks

### 1. Create `src/auth/guards/local-auth.guard.ts`
```typescript
@Injectable()
export class LocalAuthGuard extends AuthGuard('local') {}
```
Used on login endpoints to validate email/password.

### 2. Create `src/auth/guards/jwt-auth.guard.ts`
```typescript
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  // Handles @Public() decorator — skips auth for annotated endpoints
}
```
Global guard applied to all routes. Checks `@Public()` metadata to allow unauthenticated access where needed.

### 3. Create `src/auth/guards/roles.guard.ts`
```typescript
@Injectable()
export class RolesGuard implements CanActivate {
  // Reads @Roles() metadata and checks user.role
}
```
Works with `@Roles(...roles)` decorator to enforce role-based access.

### 4. Create `src/common/decorators/auth/public.decorator.ts`
`@Public()` decorator using `SetMetadata('isPublic', true)`.

### 5. Create `src/common/decorators/auth/roles.decorator.ts`
`@Roles(...roles)` decorator using `SetMetadata('roles', roles)`.

### 6. Create `src/common/decorators/auth/current-user.decorator.ts`
`@CurrentUser(field?)` — extracts user from request, optionally a specific field.

### 7. Create composite API decorators
- `@PartnerApi(path)` — combines `@Controller`, `@ApiTags`, `@ApiBearerAuth`, `@UseGuards(JwtAuthGuard, RolesGuard)`, `@Roles(HEALTH_PARTNER)`
- `@AdminApi(path)` — same pattern for admin routes

## Completed

Guards and decorators created. `JwtAuthGuard` respects `@Public()`. `RolesGuard` reads `@Roles()` metadata. Composite decorators (`@PartnerApi`, `@AdminApi`) used across partner and admin controllers.
