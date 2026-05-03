# Notifications — Frontend Integration Guide

> Audience: frontend team (`healytic_fe/user_app`) and backend team
> Backend status: implemented
> Frontend OpenAPI package: `/Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/user_app/openapi`
> Auth: JWT bearer token for user-authenticated routes

## Overview

The notification read APIs already exist in backend and are already present in
the generated Dart client. Frontend work should consume the existing contract
instead of creating a parallel endpoint.

The notification read flow uses these routes:

- `GET /v1/user/notifications`
- `GET /v1/user/notifications/unread-count`
- `PATCH /v1/user/notifications/{id}/read`
- `PATCH /v1/user/notifications/read-all`

## Generated Client Surface

Use:

```dart
import 'package:user_openapi/api.dart';
```

The generated client already exposes:

```dart
UserNotificationsApi.userNotificationControllerGetNotifications(
  limit: limit,
  cursor: cursor,
  type: type,
  isRead: isRead,
)

UserNotificationsApi.userNotificationControllerGetUnreadCount()

UserNotificationsApi.userNotificationControllerMarkRead(id)

UserNotificationsApi.userNotificationControllerMarkAllRead()
```

Relevant generated files:

- `user_app/openapi/lib/api/user_notifications_api.dart`
- `user_app/openapi/doc/UserNotificationsApi.md`
- `backend/openapi/openapi.json`

## Read Notification Contract

### 1. Read a single notification

- Method: `PATCH`
- Path: `/v1/user/notifications/{id}/read`
- Auth: bearer token
- Path param:
  - `id`: notification UUID
- Success response: `204 No Content`

Behavior:

- targeted notification: backend updates `notifications.isRead = true` and
  `readAt`
- broadcast notification: backend inserts a row into `notification_reads`
- operation is idempotent; reading an already-read notification should still be
  treated as success

### 2. Read all notifications

- Method: `PATCH`
- Path: `/v1/user/notifications/read-all`
- Auth: bearer token
- Success response: `200 OK`

Response body:

```json
{
  "markedCount": 3
}
```

## Notification List Payload

`GET /v1/user/notifications` returns:

```json
{
  "notifications": [
    {
      "id": "uuid",
      "type": "bookingConfirmed",
      "title": "Booking Confirmed",
      "body": "Your appointment was confirmed.",
      "data": {
        "appointmentId": "uuid",
        "conversationId": "uuid",
        "orderId": "uuid"
      },
      "isRead": false,
      "readAt": null,
      "isBroadcast": false,
      "createdAt": "2026-04-13T09:30:00.000Z"
    }
  ],
  "hasMore": false,
  "nextCursor": null
}
```

Notes:

- `data` is optional and should remain a free-form routing payload
- frontend currently uses keys such as `appointmentId`, `conversationId`, and
  `orderId`
- backend should preserve backward compatibility for these keys if notification
  taps need deep-link routing

## Unread Count Payload

`GET /v1/user/notifications/unread-count` returns:

```json
{
  "count": 5
}
```

## Frontend Implementation Notes

- notifications should be marked read optimistically in UI
- if the backend call fails, frontend must revert both the card read state and
  the unread badge count
- frontend should treat non-`200`/`204` responses as failures instead of
  silently swallowing them

## Backend Ownership

No new backend endpoint is required for the notification read task at this
time. The existing controller and OpenAPI contract already cover the feature:

- `backend/src/notification/user-notification.controller.ts`
- `backend/src/notification/application/handlers/mark-notification-read.handler.ts`
- `backend/src/notification/application/handlers/mark-all-read.handler.ts`
