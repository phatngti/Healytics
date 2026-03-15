# 02 — Domain Handlers

**Status:** ✅ COMPLETED

## Context

After the module shell is set up (todo 01), this implements the domain handlers that encapsulate specific business operations. The handlers follow a service-facade → handler delegation pattern.

## Prerequisites

- ✅ Todo 01 — Entities and module setup
- ✅ `Account` and `UserProfile` repositories injected

## Tasks

### 1. Create `src/account/application/handlers/create-account.handler.ts`
**Logic:**
- Receives email, password, role, and optional profile data
- Hashes password with bcrypt
- Creates `Account` entity
- Creates associated `UserProfile` entity
- Returns the created account

### 2. Create `src/account/application/handlers/set-survey.handler.ts`
**Logic:**
- Receives userId and survey JSONB data
- Loads UserProfile by accountId
- Checks if survey already exists → throws `ConflictException`
- Saves survey data to `UserProfile.survey`

### 3. Create `src/account/application/handlers/set-refresh-token.handler.ts`
**Logic:**
- Receives userId and refresh token (or null for logout)
- Hashes the refresh token with bcrypt (or sets null)
- Updates `Account.hashedRefreshToken`

## Completed

All three handlers implemented and registered as providers in `AccountModule`. `CreateAccountHandler` handles the full account+profile creation flow. `SetRefreshTokenHandler` supports both set and clear operations for logout.
