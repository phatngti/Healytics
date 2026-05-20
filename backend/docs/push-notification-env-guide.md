# APNs / FCM backend environment guide

This backend has two notification delivery paths:

- In-app notifications use Socket.IO namespace `/notifications` and do not need APNs or FCM.
- Device push notifications use registered rows in `device_tokens` and read credentials from `src/notification/push/push.config.ts`.

## Required `.env` block

Add this block to `backend/.env` for UAT or production. Keep real keys out of git.

```dotenv
PUSH_NOTIFICATIONS_ENABLED=true

# Firebase Cloud Messaging, used for Android device tokens
FCM_PROJECT_ID=your_firebase_project_id
FCM_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com
FCM_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY\n-----END PRIVATE KEY-----\n"
FCM_PRIVATE_KEY_PATH=
FCM_SERVICE_ACCOUNT_JSON=

# Apple Push Notification service, used for iOS device tokens
APNS_KEY_ID=YOUR_APPLE_KEY_ID
APNS_TEAM_ID=YOUR_APPLE_TEAM_ID
APNS_BUNDLE_ID=com.healytics.app
APNS_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_APNS_AUTH_KEY\n-----END PRIVATE KEY-----\n"
APNS_PRIVATE_KEY_PATH=
APNS_PRODUCTION=false
```

Use either inline private-key values or file paths:

- Inline key: keep newline escapes as `\n` inside the quoted value.
- File path: leave the inline key empty and set `FCM_PRIVATE_KEY_PATH` or `APNS_PRIVATE_KEY_PATH` to a readable file on the server.
- `FCM_SERVICE_ACCOUNT_JSON` is an alternative to the three separate FCM fields when deployment tooling already provides the whole Firebase service-account JSON as one escaped string.

## FCM setup

1. Open Firebase Console for the mobile project.
2. Go to Project settings > Service accounts.
3. Generate a private key for the Firebase Admin SDK.
4. Copy `project_id` to `FCM_PROJECT_ID`.
5. Copy `client_email` to `FCM_CLIENT_EMAIL`.
6. Copy `private_key` to `FCM_PRIVATE_KEY`, preserving newline escapes.

The Android app must register an FCM token through `POST /v1/user/devices` with platform `android`.

## APNs setup

1. Open Apple Developer > Certificates, Identifiers & Profiles > Keys.
2. Create or reuse an APNs Auth Key with Apple Push Notifications enabled.
3. Copy the Key ID to `APNS_KEY_ID`.
4. Copy the Apple Team ID to `APNS_TEAM_ID`.
5. Set `APNS_BUNDLE_ID` to the iOS app bundle id used in the release build.
6. Put the `.p8` contents in `APNS_PRIVATE_KEY` or mount the `.p8` file and set `APNS_PRIVATE_KEY_PATH`.
7. Set `APNS_PRODUCTION=true` only for App Store / TestFlight production APNs tokens. Use `false` for sandbox/dev builds.

The iOS app must register an APNs-compatible token through `POST /v1/user/devices` with platform `ios`.

## Backend checks

After editing `.env`, restart the backend and check startup logs:

- `FCM initialized for project=...` means the Firebase Admin sender is ready.
- `APNs initialized for bundle=...` means the APNs token provider is ready.
- `credentials incomplete` means at least one required value is missing.
- `disabled` means `PUSH_NOTIFICATIONS_ENABLED` is not `true`.

The current user app in-app notification path does not depend on these values; it uses the `/notifications` WebSocket namespace and the existing JWT auth handshake. APNs/FCM are only needed for device push while the app is backgrounded or offline.
