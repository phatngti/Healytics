# Backend Guide: `POST /v1/user/devices`

## Purpose

The mobile app registers a push device token after authentication succeeds.  
Current frontend request shape:

```http
POST /v1/user/devices
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "token": "<fcm-or-apns-token>",
  "platform": "ios" | "android"
}
```

Expected behavior:

- `201 Created` on successful registration
- `204 No Content` for `DELETE /v1/user/devices/:token`
- JWT-authenticated user is taken from the access token, not from request body

---

## Current Diagnosis

The backend is not missing this feature entirely. Most of it already exists:

- Controller: `backend/src/notification/user-device.controller.ts`
- Service methods: `backend/src/notification/notification.service.ts`
- DTO: `backend/src/notification/dto/register-device.dto.ts`
- Entity: `backend/src/common/entities/device-token.entity.ts`
- Module wiring: `backend/src/notification/notification.module.ts`
- Migration/table: `backend/migrations/scripts/1776100000000-CreateNotificationTables.ts`
- Swagger path already generated: `backend/openapi/openapi.json`

So the `404 Cannot POST /v1/user/devices` is most likely an exposure/runtime issue, not a missing-domain-logic issue.

---

## Backend Contract

### 1. Register device

`POST /v1/user/devices`

Request body:

```ts
interface RegisterDeviceDto {
  token: string;
  platform: 'ios' | 'android';
}
```

Response:

```json
{
  "message": "Device registered successfully"
}
```

Status:

- `201 Created`
- `400 Bad Request` for invalid body
- `401 Unauthorized` for missing/invalid JWT
- `403 Forbidden` if role is not `USER`

Behavior:

- Extract `userId` from JWT
- Upsert by `token`
- If token already exists, reassign it to the current user and mark it active
- Persist platform as enum

### 2. Unregister device

`DELETE /v1/user/devices/:token`

Response:

- `204 No Content`

Behavior:

- Mark the token inactive
- Prefer filtering by both `userId` and `token`

---

## What Already Exists

### Controller

`backend/src/notification/user-device.controller.ts` already defines:

- `@UserApi('devices')`
- `@Post() registerDevice(...)`
- `@Delete(':token') unregisterDevice(...)`

That decorator should resolve to a user-authenticated route under the user API namespace.

### Service

`backend/src/notification/notification.service.ts` already has:

- `registerDevice(userId, token, platform)`
- `unregisterDevice(token)`

The current implementation already does token upsert behavior against `device_tokens`.

### Persistence

`backend/src/common/entities/device-token.entity.ts` and migration `1776100000000-CreateNotificationTables.ts` already define:

- `device_tokens` table
- unique token constraint
- `user_id`
- `platform`
- `is_active`

---

## Most Likely Reasons For The 404

### 1. Route versioning mismatch

`@UserApi(...)` uses:

```ts
Controller({ path: `user/${resource}`, version: '1' })
```

But `backend/src/main.ts` does not visibly enable Nest URI versioning in the current source.  
Backend team should verify one of these is true:

- `app.enableVersioning({ type: VersioningType.URI })` is active somewhere in the runtime bootstrap, or
- the reverse proxy/gateway rewrites `/v1/...` to the unversioned Nest route, or
- the API is intentionally exposed without `/v1` and the frontend base path is wrong

If URI versioning is not enabled, Nest may expose `/user/devices` while the app is calling `/v1/user/devices`.

### 2. Stale runtime build

The route exists in both:

- `backend/src/notification/user-device.controller.ts`
- `backend/dist/src/notification/user-device.controller.js`

If runtime still returns 404, verify the actual running process was restarted from the latest build.

Recommended checks:

- rebuild: `npm run build`
- restart runtime
- confirm route appears in Swagger or startup route list

### 3. API gateway / nginx / proxy routing

If other `/v1/user/*` routes work but `/v1/user/devices` does not, check upstream routing rules:

- path allowlist
- ingress route definitions
- auth proxy exclusions
- method forwarding for `POST` and `DELETE`

---

## Hardening Work Recommended Before Closing

### 1. Tighten typing in the service

Current service signature accepts `platform: string` and casts with `as any`.

Recommended:

```ts
async registerDevice(
  userId: string,
  token: string,
  platform: DevicePlatform,
): Promise<void>
```

This should remove the unsafe cast and keep DTO/service/entity aligned.

### 2. Protect `DELETE` by current user

Current controller/service flow unregisters by token only.

Recommended behavior:

- accept `@CurrentUser('id') userId`
- update only rows matching both `token` and `userId`

Reason:

- avoids deactivating another user’s token by guessing or replaying a token value

Suggested shape:

```ts
@Delete(':token')
@HttpCode(HttpStatus.NO_CONTENT)
async unregisterDevice(
  @Param('token') token: string,
  @CurrentUser('id') userId: string,
): Promise<void> {
  await this.notificationService.unregisterDevice(userId, token);
}
```

And:

```ts
async unregisterDevice(userId: string, token: string): Promise<void> {
  await this.deviceTokenRepo.update({ userId, token }, { isActive: false });
}
```

### 3. Add e2e coverage

Add tests for:

- `POST /v1/user/devices` with valid JWT returns `201`
- invalid `platform` returns `400`
- missing JWT returns `401`
- second `POST` with same token updates existing row instead of duplicating
- `DELETE /v1/user/devices/:token` returns `204`
- delete only affects the authenticated user’s token

### 4. Add OpenAPI operation IDs if frontend generation will use this later

The frontend currently calls this endpoint via raw HTTP because it is not yet part of the generated API client contract on the app side.  
If backend wants this endpoint consumable through OpenAPI codegen, ensure the route remains in Swagger and the generated spec is published consistently.

---

## Implementation Checklist

1. Confirm runtime route exposure for `POST /v1/user/devices`.
2. If needed, enable URI versioning or fix proxy rewrite for `/v1`.
3. Rebuild and restart the backend process.
4. Tighten service typing to `DevicePlatform`.
5. Scope `DELETE` by `userId + token`.
6. Verify `device_tokens` migration has been applied.
7. Add e2e tests.
8. Regenerate/publish Swagger if this endpoint is intended for OpenAPI consumers.

---

## Quick Manual Verification

Use a valid user JWT:

```bash
curl -i -X POST http://localhost:8080/v1/user/devices \
  -H "Authorization: Bearer <USER_JWT>" \
  -H "Content-Type: application/json" \
  -d '{"token":"test-ios-token-001","platform":"ios"}'
```

Expected:

```http
HTTP/1.1 201 Created
Content-Type: application/json

{"message":"Device registered successfully"}
```

Then:

```bash
curl -i -X DELETE http://localhost:8080/v1/user/devices/test-ios-token-001 \
  -H "Authorization: Bearer <USER_JWT>"
```

Expected:

```http
HTTP/1.1 204 No Content
```

---

## Acceptance Criteria

Backend is done when all of the following are true:

- `POST /v1/user/devices` no longer returns 404
- valid authenticated request returns `201`
- token is persisted or reactivated in `device_tokens`
- duplicate token requests do not create duplicate rows
- `DELETE /v1/user/devices/:token` deactivates only the caller’s token
- e2e tests cover the registration/unregistration flow
