# 01 — Entities & Module Setup

**Status:** ✅ COMPLETED

## Context

The Account module manages user accounts and profiles. It provides the underlying data layer that the Auth module depends on for user creation and credential management.

## Prerequisites

- ✅ TypeORM configured in `AppModule`
- ✅ Database migrations for `accounts` and `user_profiles` tables

## Tasks

### 1. Create `src/common/entities/account.entity.ts`
Fields:
- `id` (UUID, PK), `email` (unique), `hashedPassword`
- `role` (enum: USER, HEALTH_PARTNER, ADMIN, SUPER_ADMIN)
- `hashedRefreshToken` (nullable)
- `createdAt`, `updatedAt`

### 2. Create `src/common/entities/user-profile.entity.ts`
Fields:
- `id` (UUID, PK), `accountId` (FK → Account)
- `fullName`, `avatarUrl`, `dateOfBirth`, `gender`
- `survey` (JSONB, nullable)
- `createdAt`, `updatedAt`

### 3. Create `src/account/enum/role.enum.ts`
```typescript
export enum Role {
  USER = 'user',
  HEALTH_PARTNER = 'health_partner',
  ADMIN = 'admin',
  SUPER_ADMIN = 'super_admin',
}
```

### 4. Create `src/account/account.module.ts`
```typescript
@Module({
  imports: [TypeOrmModule.forFeature([Account, UserProfile])],
  controllers: [AccountController],
  providers: [AccountService, CreateAccountHandler, SetSurveyHandler, SetRefreshTokenHandler],
  exports: [AccountService],
})
```

## Completed

Entities created with proper TypeORM decorators. Module registered with all handlers and exported `AccountService` for use by `AuthModule`.
