# Google Sign-In — Configuration Guide

This guide is the operator-facing companion to
`.kiro/specs/google-signin/design.md` Section 7. It lists every artifact a
developer must create or edit before "Continue with Google" can succeed
end-to-end on a fresh checkout: Google Cloud Console clients, Android
fingerprints, the `pubspec.yaml` block, native Android / iOS edits, the
backend env variable, and the `--dart-define` keys required at run time.

All values referenced (package names, bundle IDs, Flutter SDK version,
Riverpod versions) were lifted directly from `pubspec.yaml`.

> **Audience alignment (Req 12.5).** The string used by the Flutter client
> as `serverClientId` and the value of `GOOGLE_OAUTH_WEB_CLIENT_ID` on the
> backend MUST be the same string, character-for-character, with no
> surrounding whitespace. Misalignment surfaces as HTTP 401
> `GOOGLE_TOKEN_INVALID` from the backend (Req 12.7).

---

## 1. Google Cloud Console

You will create **three** OAuth 2.0 client IDs — one Web, one Android, one
iOS — under the same Google Cloud project and the same OAuth consent screen
(Reqs 12.1, 12.2, 12.3, 14.5).

### 1.1 Project and consent screen

1. Open <https://console.cloud.google.com/apis/credentials> and switch to
   the Healytics project.
2. **APIs & Services → OAuth consent screen** → ensure the app is
   configured as **External** with scopes `openid`, `email`, and `profile`
   (Req 2.2).

### 1.2 Web client (Req 12.1, 12.4)

**Credentials → + CREATE CREDENTIALS → OAuth client ID → Web application.**

- Name: `Healytics Backend (Web)`.
- Authorized JavaScript origins:
  - `http://localhost:<port>` for local Flutter Web dev. `<port>` is the
    integer in `flutter run -d chrome --web-port=<port>` (typical values:
    `5050`, `5060`).
  - One row per deployed Web environment, using the exact
    scheme-host-port (e.g., `https://app.healytics.example`).
- Authorized redirect URIs: leave empty. ID-token-only flows do not need
  redirect URIs.
- Save the **Client ID**. This is the `Google_Server_Client_ID` and the
  value to register as `GOOGLE_OAUTH_WEB_CLIENT_ID` in the backend env
  (Reqs 12.1, 12.5, 12.6, 16.1, 16.2).

### 1.3 Android clients (Req 12.2, 13.2, 13.3)

Create **one Android client per build variant** (debug + release). Both
use the same package name; only the SHA fingerprints differ.

- **Debug** — name `Healytics User App (Android — debug)`.
  - Package name: `com.example.user_app` (matches
    `android/app/build.gradle.kts > applicationId` and
    `pubspec.yaml > patrol > android > package_name`).
  - SHA-1: paste the value from §2.1 below.
- **Release** — name `Healytics User App (Android — release)`.
  - Same package name as above.
  - Paste both the **SHA-1** and **SHA-256** lines from §2.2 below
    (Req 13.2).

### 1.4 iOS client (Req 12.3, 14.4)

**Credentials → + CREATE CREDENTIALS → OAuth client ID → iOS.**

- Name: `Healytics User App (iOS)`.
- Bundle ID: `com.example.userApp` (matches
  `pubspec.yaml > patrol > ios > bundle_id`).
- Save the **Client ID** (used as `GIDClientID` in `Info.plist`).
- Copy the auto-generated **Reversed client ID** of the form
  `com.googleusercontent.apps.<digits>-<hash>` — it goes into
  `CFBundleURLSchemes` (§4.1).

The iOS client ID MUST be a distinct credential from the Web client ID
(Req 14.4) but MUST live in the same Cloud project and consent screen
(Req 14.5).

### 1.5 Misalignment troubleshooting (Req 12.7)

| Symptom                                       | Likely cause                                       | Fix                                                              |
|-----------------------------------------------|----------------------------------------------------|------------------------------------------------------------------|
| Backend returns 401 `GOOGLE_TOKEN_INVALID`    | `serverClientId` ≠ `GOOGLE_OAUTH_WEB_CLIENT_ID`     | Recopy the Web client ID character-for-character into both sides. |
| Android sign-in immediately closes            | SHA-1 (or package name) does not match the variant | Re-run `keytool` on the actual signing keystore; update Console. |
| iOS consent sheet returns "Safari can't open" | Reversed client ID missing from `CFBundleURLSchemes`| Add the URL scheme entry shown in §4.1, then `pod install`.       |
| Backend boots with HTTP 500 `GOOGLE_OAUTH_NOT_CONFIGURED` | `GOOGLE_OAUTH_WEB_CLIENT_ID` is unset in `.env` | Set the value in `backend/.env` (§5).                            |

---

## 2. SHA-1 / SHA-256 commands (Req 13.1, 13.2)

### 2.1 Debug keystore

```bash
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android
```

Paste the `SHA1:` line into the Android **debug** OAuth client.

### 2.2 Release keystore

```bash
keytool -list -v \
  -keystore /path/to/healytics-release.jks \
  -alias <release-alias>
# Enter the keystore + key passwords when prompted.
```

Paste both the `SHA1:` and `SHA-256:` lines into the Android **release**
OAuth client.

---

## 3. `pubspec.yaml` dependency block (Req 15)

`google_sign_in` major **7.x** is the current stable line and the only one
compatible with the post-deprecation Google Identity Services flow on Web.
It requires Dart `>=3.4.0` (compatible with our `sdk: ^3.9.2`) and the
Flutter embedder. Pin `^7.0.0`. Web requires the federated
`google_sign_in_web` companion at the version aligned to v7 — which is
`^1.0.0` (see "Known issues" §7).

Add to `dependencies:`:

```yaml
  google_sign_in: ^7.0.0
  google_sign_in_web: ^1.0.0   # required only when targeting Flutter Web
```

After editing pubspec, run (Req 15.4):

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 3.1 Smoke check (Req 15.5)

From any widget file, add
`import 'package:google_sign_in/google_sign_in.dart';` and reference
`GoogleSignIn.instance` (v7+ singleton). If the build succeeds and the
import resolves, the install is correct. Revert the scratch import.

### 3.2 Latest patch

To pull the latest patch on a fresh checkout:

```bash
flutter pub outdated google_sign_in google_sign_in_web
```

Bump the patch in `pubspec.yaml` if newer versions are available, then
re-run `flutter pub get`.

---

## 4. Native Android edits (Req 13.3, 13.4)

The project's `android/app/build.gradle.kts` already declares the correct
`applicationId` and a `minSdk` >= 21 — no edits are required, but verify
the values match this guide.

```kotlin
android {
    defaultConfig {
        applicationId = "com.example.user_app"   // matches Cloud Console package
        minSdk = flutter.minSdkVersion            // resolves to 24 in this project
        targetSdk = flutter.targetSdkVersion
        // ...
    }
}
```

`google_sign_in` v7 requires `minSdk >= 21`; the project is already at
`24`, so the constraint is satisfied (Req 13.3).

No additional `<intent-filter>` or `<meta-data>` is required in
`AndroidManifest.xml` for v6+ Credential Manager-based Google Sign-In —
only the standard `<uses-permission android:name="android.permission.INTERNET"/>`
which is already present in `android/app/src/main/AndroidManifest.xml`
(Req 13.4).

---

## 5. Native iOS edits (Req 14)

### 5.1 `ios/Runner/Info.plist` (Req 14.1, 14.2)

Append inside the root `<dict>`:

```xml
<key>GIDClientID</key>
<string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>

<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- Reversed iOS client ID from Cloud Console (§1.4) -->
      <string>com.googleusercontent.apps.YOUR_IOS_CLIENT_SUFFIX</string>
    </array>
  </dict>
</array>
```

Replace the two `YOUR_*` placeholders with the values copied from the iOS
OAuth client created in §1.4.

### 5.2 `ios/Podfile` (Req 14.3)

Set the deployment target:

```ruby
platform :ios, '14.0'
```

Then:

```bash
cd ios && pod install
```

> See **Known issues** (§7) — `pod install` currently fails at `'14.0'`
> because Firebase iOS pods require a newer deployment target. Bump the
> Podfile and `IPHONEOS_DEPLOYMENT_TARGET` in `Runner.xcodeproj` together
> before running `pod install`.

### 5.3 iOS verification (Req 14.6)

Before building the iOS app, confirm:

1. `Info.plist` contains both `GIDClientID` and a `CFBundleURLSchemes`
   array with the reversed client ID.
2. `ios/Podfile` `platform :ios` matches the version set in the Xcode
   project's `IPHONEOS_DEPLOYMENT_TARGET`.
3. `pod install` completes without dependency errors.

---

## 6. Backend env alignment (Req 10.12, 16)

### 6.1 `backend/.env.sample`

Append:

```dotenv
# Google Sign-In — must match the Web OAuth client ID that the Flutter
# client passes as `serverClientId`.
GOOGLE_OAUTH_WEB_CLIENT_ID=
```

### 6.2 `backend/.env`

Set the actual Web client ID from §1.2:

```dotenv
GOOGLE_OAUTH_WEB_CLIENT_ID=<paste-the-web-client-id-here>
```

The value MUST equal the `serverClientId` configured in the Flutter client
(Req 16.2). The backend MUST load this through `ConfigService` (matching
the existing `JwtStrategy` pattern) and fail fast at boot in `production`
if the variable is missing (Req 16.3). If the variable is absent at
runtime, the endpoint responds HTTP 500 with
`{ "code": "GOOGLE_OAUTH_NOT_CONFIGURED" }` on every request (Req 10.12).

### 6.3 End-to-end alignment validation (Req 16.4)

A successful call to `POST /v1/auth/user/google` with an `id_token` issued
for the configured audience returns HTTP 200 with a backend `access_token`
whose `aud` matches the existing JWT issuer. Sanity check by pasting the
returned `access_token` into <https://jwt.io>.

---

## 7. Known issues

### 7.1 `google_sign_in_web` major mismatch

The earlier draft of `tasks.md` listed `google_sign_in_web: ^0.12.0`. That
constraint pre-dates the `google_sign_in` v7 federated split and is
**incorrect** for our pinned major. The current `pubspec.yaml` correctly
uses:

```yaml
  google_sign_in: ^7.0.0
  google_sign_in_web: ^1.0.0
```

Use `^1.0.0` (or whichever current `1.x` patch `pub.dev` reports as
v7-compatible) — never `^0.12.0`. Resolution will fail with a Pub solver
error if the two majors are misaligned.

### 7.2 `pod install` fails at `platform :ios, '14.0'`

`pod install` currently fails because Firebase iOS pods (transitively
pulled in via the project's Firebase dependencies) require a deployment
target higher than the Podfile's `'14.0'`. The error shape is roughly:

```
[!] CocoaPods could not find compatible versions for pod "Firebase…":
  Specs satisfying the dependency were found, but they required a higher
  minimum deployment target.
```

**Workaround.** Bump the iOS deployment target in **both** locations in
the same change so they stay in sync, then re-run `pod install`:

1. `ios/Podfile`:

   ```ruby
   platform :ios, '15.0'   # or '16.0' if Firebase requires higher
   ```

2. `ios/Runner.xcodeproj/project.pbxproj` — every
   `IPHONEOS_DEPLOYMENT_TARGET = 13.0;` line under the Runner build
   configurations must be raised to match the Podfile (`15.0` or `16.0`).
   Open the project in Xcode (or edit the `.pbxproj` directly) and update
   each Debug, Release, and Profile configuration.

3. Then:

   ```bash
   cd ios
   pod install
   ```

This is a follow-up that should be **resolved before the iOS smoke run**
in §8 step 6. The exact target version (`15.0` vs `16.0`) is whichever
Firebase reports as its minimum at the time of the bump — match it
literally; do not pick a lower version.

> Note: design.md §7.5 still documents `platform :ios, '14.0'` because the
> design was written before the Firebase upgrade. Treat the Podfile bump
> documented here as the operative value until design.md is updated.

---

## 8. Run-time `--dart-define` keys (Req 2.3, 12.5, 12.6)

`AppEnvironment.googleServerClientId` is sourced from a build-time
`--dart-define` (Task 1.5) so the Cloud Console Web client ID is never
hard-coded in source. Pass the same string used in §1.2 / §6.2:

```bash
flutter run \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>
```

For builds:

```bash
flutter build apk \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>

flutter build ios \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>

flutter build web \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>
```

The value of `GOOGLE_SERVER_CLIENT_ID` MUST equal
`GOOGLE_OAUTH_WEB_CLIENT_ID` on the backend (Req 12.5, 16.2). CI should
inject the value from a secret store rather than commit it.

---

## 9. Verification checklist

Lifted from `design.md` §7.7. Walk through this end-to-end after every
change to client IDs, env variables, native plist/gradle settings, or the
`google_sign_in` dependency. Task 8.3 in `tasks.md` is satisfied when
every step below passes.

1. **Backend boot.** Run the backend (`docker compose up backend` or the
   project's equivalent) and inspect the logs:

   ```bash
   docker compose logs backend | grep -i google
   ```

   No `GOOGLE_OAUTH_WEB_CLIENT_ID is not set` warning is printed and the
   server reaches the "ready" line.

2. **Smoke run on Android.** With a device or emulator attached:

   ```bash
   flutter run -d <android-device> \
     --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>
   ```

   Tap "Continue with Google" → pick an account. The app navigates either
   to `/home` or `/finish_google_sign_up`. There is no
   `PlatformException(sign_in_failed, …)` in the logs.

3. **JWT audience check.** Set a breakpoint inside
   `signInWithGoogle()` in
   `lib/features/authenticate/data/repositories/authenticate_repository_impl.dart`
   and copy the `idToken` your client sends. Paste it into
   <https://jwt.io>. The decoded `aud` claim MUST equal
   `GOOGLE_OAUTH_WEB_CLIENT_ID`. Any mismatch produces 401
   `GOOGLE_TOKEN_INVALID` from the backend.

4. **Backend access-token signature check.** Copy the `access_token`
   returned by `POST /v1/auth/user/google` into <https://jwt.io>. The
   `iss` claim (or, if absent, the signature verifying with `JWT_SECRET`)
   MUST match the same issuer used by `loginUser()` (Req 16.4). The token
   shape MUST match the existing `AuthTokensDto`
   (`access_token`, `refresh_token`, optional `access_expires_in`,
   `refresh_expires_in`).

5. **Profile-completed branching.** First Google sign-in should land on
   `/finish_google_sign_up`. Complete the form, sign out, sign in again
   with the same Google account, and confirm you land on `/home` (Req 4.2,
   4.3).

6. **iOS URL scheme.** Open `ios/Runner/Info.plist`, search for the
   reversed client ID, then run on an iOS device:

   ```bash
   flutter run -d <ios-device> \
     --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>
   ```

   The Google consent screen MUST close back into the app — no
   "Safari can't open this page" dialog. Resolve §7.2 (Podfile / pbxproj
   deployment target) before attempting this step.

---

## 10. Quick reference

| Item                                  | Value / location                                                       |
|---------------------------------------|------------------------------------------------------------------------|
| Web OAuth client ID                   | `GOOGLE_OAUTH_WEB_CLIENT_ID` (backend) = `GOOGLE_SERVER_CLIENT_ID` (Flutter) |
| Android package name                  | `com.example.user_app`                                                 |
| iOS bundle ID                         | `com.example.userApp`                                                  |
| Flutter package                       | `google_sign_in: ^7.0.0`                                               |
| Flutter Web package                   | `google_sign_in_web: ^1.0.0`                                           |
| Android `minSdk`                      | `flutter.minSdkVersion` (resolves to 24, satisfies v7's >=21)          |
| iOS Podfile platform                  | `platform :ios, '14.0'` per design — bump per §7.2 before `pod install`|
| Info.plist keys                       | `GIDClientID`, `CFBundleURLTypes > CFBundleURLSchemes`                 |
| Backend env file                      | `backend/.env` and `backend/.env.sample`                               |
| Required `--dart-define`              | `GOOGLE_SERVER_CLIENT_ID=<web-client-id>`                              |
