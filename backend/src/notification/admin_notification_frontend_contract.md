# Admin System Notification Frontend Contract

This guide documents the backend behavior required by the simplified admin
notification creation screen in `healytic_fe/admin_panel`.

## Frontend Behavior

The admin panel now creates only immediate system-wide in-app broadcasts.
The creation form sends exactly two required user inputs:

- `title`
- `body`

The frontend no longer sends or displays creation controls for:

- drafts
- scheduling
- audience segments
- recipient roles
- push/email channel selection
- CTA label
- deep link target
- internal campaign name/note

Existing audit/list/detail screens still consume sent broadcast records.

## Required Admin API

Keep the current admin broadcast endpoint stable:

```http
POST /admin/notifications/broadcast
Authorization: Bearer <admin_jwt>
Content-Type: application/json
```

Request body:

```json
{
  "title": "Maintenance starts at 01:00 ICT",
  "body": "The platform will enter maintenance mode for approximately 60 minutes."
}
```

Expected behavior:

- Require an authenticated admin user.
- Validate `title` and `body` as non-empty strings.
- Trim or reject whitespace-only values; do not persist blank broadcast content.
- Create one `Notification` row with:
  - `recipientId = null`
  - `type = system_broadcast`
  - `isBroadcast = true`
  - `isRead = false`
  - `senderId = current admin id`
- Push the created broadcast through the notification WebSocket gateway.
- Attempt device push delivery asynchronously, without failing the HTTP request
  when push provider delivery fails.
- Return the created `NotificationResponseDto`.

Expected success response shape:

```json
{
  "id": "uuid",
  "type": "system_broadcast",
  "title": "Maintenance starts at 01:00 ICT",
  "body": "The platform will enter maintenance mode for approximately 60 minutes.",
  "data": null,
  "isRead": false,
  "readAt": null,
  "isBroadcast": true,
  "createdAt": "2026-04-25T00:00:00.000Z"
}
```

The frontend maps the response into its sent-campaign detail screen. It does
not require campaign/draft/schedule fields from the backend.

## DTO Notes

`CreateBroadcastDto` may keep optional `data` for backward compatibility, but
the simplified admin panel will not send it. Do not make `data` required.

Recommended validation:

```ts
@IsString()
@Transform(({ value }) => typeof value === 'string' ? value.trim() : value)
@IsNotEmpty()
@MaxLength(255)
title: string;

@IsString()
@Transform(({ value }) => typeof value === 'string' ? value.trim() : value)
@IsNotEmpty()
@MaxLength(5000)
body: string;
```

If transform-based trimming is not used, enforce equivalent trimming in the
controller/service/handler before persistence.

## Required Audit Listing

Keep the current audit endpoint stable:

```http
GET /admin/notifications/broadcasts
Authorization: Bearer <admin_jwt>
```

Expected behavior:

- Return sent broadcast notifications only.
- Sort newest first.
- Use the same `NotificationResponseDto[]` shape.

The admin panel uses this endpoint for the notification table and detail lookup.

## Backend Implementation Checklist

- Keep `AdminNotificationController.createBroadcast` as the only create path
  needed by the admin panel.
- Keep `NotificationService.createAndPushBroadcast` responsible for persistence,
  WebSocket fan-out, and async push fan-out.
- Keep `CreateBroadcastHandler` writing a single broadcast notification row.
- Keep `NotificationType.SYSTEM_BROADCAST = 'system_broadcast'`.
- Ensure generated OpenAPI still exposes:
  - `AdminNotificationsApi.adminNotificationControllerCreateBroadcast`
  - `CreateBroadcastDto.title`
  - `CreateBroadcastDto.body`
  - optional `CreateBroadcastDto.data`
  - `NotificationResponseDto`

## Test Cases

Add or keep backend tests for:

- `POST /admin/notifications/broadcast` returns `201` and a
  `NotificationResponseDto` for valid `title` and `body`.
- The saved notification has `recipientId = null`, `isBroadcast = true`,
  `isRead = false`, and `type = system_broadcast`.
- Whitespace-only `title` returns validation error and does not create a row.
- Whitespace-only `body` returns validation error and does not create a row.
- Missing `title` or `body` returns validation error.
- WebSocket broadcast is invoked with the created response DTO.
- Push broadcast errors are logged but do not fail the HTTP request.
- `GET /admin/notifications/broadcasts` returns only broadcasts sorted by
  `createdAt DESC`.

## Frontend Compatibility Warning

Do not rename the admin endpoints or response fields without regenerating the
admin OpenAPI client and updating the frontend. The current frontend directly
calls the generated `adminNotificationControllerCreateBroadcast` method and
expects `NotificationResponseDto.createdAt`, `id`, `title`, `body`, `type`, and
`isBroadcast`.
