# Implementation Plan

## Overview

This plan turns the existing "Continue with Google" placeholder on
`signin.screen.dart` into a working sign-in path: `google_sign_in` plugin →
backend `POST /v1/auth/user/google` → typed `AuthenticateEntity` → branched
navigation by `profileCompleted` JWT claim → first-time profile completion
on a new `FinishGoogleSignUpScreen`. It also wires logout to clear the
cached Google account and adds the configuration guide for Cloud Console,
Android, iOS, and backend env alignment.

Scope: Flutter `user_app` only. The backend `POST /v1/auth/user/google` and
`PATCH /v1/auth/user/profile` endpoints (Req 10, Req 6) are tracked in the
backend repo and are a parallel precondition for end-to-end smoke testing —
they are NOT implemented from this tasks.md.

## Task Dependency Graph

```json
{
  "waves": [
    {
      "wave": 1,
      "tasks": ["1.1", "1.2", "1.3", "1.5"],
      "dependencies": []
    },
    {
      "wave": 2,
      "tasks": ["1.4", "2.1"],
      "dependencies": ["1.1", "1.2", "1.3", "1.5"]
    },
    {
      "wave": 3,
      "tasks": ["2.2", "2.3", "2.5"],
      "dependencies": ["2.1", "1.5"]
    },
    {
      "wave": 4,
      "tasks": ["2.4"],
      "dependencies": ["2.2", "2.3"]
    },
    {
      "wave": 5,
      "tasks": ["3.1", "3.2", "4.1"],
      "dependencies": ["2.4", "2.5"]
    },
    {
      "wave": 6,
      "tasks": ["4.2"],
      "dependencies": ["4.1", "3.2"]
    },
    {
      "wave": 7,
      "tasks": ["5.1"],
      "dependencies": ["4.2"]
    },
    {
      "wave": 8,
      "tasks": ["3.3", "5.2", "6.1"],
      "dependencies": ["3.1", "3.2", "5.1", "2.2"]
    },
    {
      "wave": 9,
      "tasks": ["7.1", "7.2", "7.3", "7.4", "7.5", "7.6", "7.7", "7.8"],
      "dependencies": ["3.3", "4.2", "5.2", "6.1"]
    },
    {
      "wave": 10,
      "tasks": ["8.1", "8.2", "8.3"],
      "dependencies": ["7.1", "7.2", "7.3", "7.4", "7.5", "7.6", "7.7", "7.8", "1.4"]
    }
  ]
}
```

## Tasks

- [x] 1. Add and configure Google Sign-In dependencies & platform config
- [x] 1.1 Add `google_sign_in: ^7.0.0` (and `google_sign_in_web: ^0.12.0` for Web)
  to `pubspec.yaml > dependencies`, then run
  `flutter pub get` and
  `dart run build_runner build --delete-conflicting-outputs`.
  - Verify the import `package:google_sign_in/google_sign_in.dart` resolves
    and `GoogleSignIn.instance` is reachable from a scratch widget (smoke
    check; revert the scratch import).
  - _Requirements: 15.1, 15.2, 15.3, 15.4, 15.5_
- [x] 1.2 Update `android/app/build.gradle` so `defaultConfig.minSdkVersion >= 21`
  and `applicationId == "com.example.user_app"` (matches Cloud Console
  Android client). No `<intent-filter>` change needed in
  `AndroidManifest.xml` — confirm `INTERNET` permission is already present.
  - _Requirements: 13.3, 13.4_
- [x] 1.3 Update `ios/Runner/Info.plist` — add `GIDClientID` (placeholder
  `YOUR_IOS_CLIENT_ID.apps.googleusercontent.com`) plus a
  `CFBundleURLTypes`/`CFBundleURLSchemes` entry for the reversed iOS client
  ID (placeholder `com.googleusercontent.apps.YOUR_IOS_CLIENT_SUFFIX`).
  Update `ios/Podfile` to `platform :ios, '14.0'`. Run `cd ios && pod install`.
  - Document in the configuration guide where each placeholder must be
    replaced before a real iOS run.
  - _Requirements: 14.1, 14.2, 14.3, 14.4, 14.5, 14.6_
- [x] 1.4 Author the configuration guide in
  `.kiro/specs/google-signin/configuration-guide.md` covering: Google Cloud
  Console (Web/Android/iOS clients), SHA-1/SHA-256 commands, pubspec block,
  Android/iOS native edits, and `backend/.env` alignment
  (`GOOGLE_OAUTH_WEB_CLIENT_ID`). Include the verification checklist from
  Section 7.7 of the design.
  - _Requirements: 12.1, 12.2, 12.3, 12.4, 12.5, 12.6, 12.7, 13.1, 13.2,
    13.3, 13.4, 14.1-14.6, 15.1-15.5, 16.1, 16.2, 16.3, 16.4_
- [x] 1.5 Expose `googleServerClientId` on `AppEnvironment` so the value flows
  from build-time config (e.g., `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`)
  into `GoogleSignInServiceImpl` without hard-coding.
  - Document the `--dart-define` keys required for `flutter run` in the
    configuration guide created in 1.4.
  - _Requirements: 2.3, 12.5, 12.6_

- [x] 2. Build the data layer for Google sign-in
- [x] 2.1 Create
  `lib/features/authenticate/domain/entities/google_sign_in_result.entity.dart`
  as a `@Freezed(toJson: true)` entity with `idToken` (required),
  `email` (required), `displayName?`, `photoUrl?`. Run code generation.
  - Generated `.freezed.dart` and `.g.dart` must compile cleanly.
  - _Requirements: 2.4, 11.3_
- [x] 2.2 Create
  `lib/features/authenticate/data/services/google_sign_in.service.dart` with
  the abstract `GoogleSignInService` interface, `GoogleSignInServiceImpl`,
  and a `@Riverpod(keepAlive: true)` `googleSignInService(Ref)` provider.
  This is the ONLY file that imports `package:google_sign_in/google_sign_in.dart`.
  - `signIn()` requests scopes `['openid', 'email', 'profile']`, configures
    `serverClientId = AppEnvironment.googleServerClientId`, returns a
    `GoogleSignInResult` (or `null` on cancellation).
  - `signOut()` calls the v7 `disconnect()`/`signOut()` equivalent.
  - Define `GoogleSignInCancelledException` alongside the service.
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 8.4_
- [x] 2.3 Extend
  `lib/features/authenticate/data/datasources/remote/authenticate_remote_datasource.dart`:
  - Add abstract `Future<AuthenticateEntity> signInWithGoogle({required String idToken})`.
  - Implement via `apiService.apiClient.invokeAPI('/auth/user/google', 'POST', …)`
    with body `{ "id_token": idToken }`, applying
    `.timeout(const Duration(seconds: 30))`.
  - On 200/201: decode JWT (`JwtDecoder.decode`), build `BasicInfoEntity`
    (email, optional `firstName`+`lastName` joined into `name`), and
    return an `AuthenticateEntity` constructed via `fromJson({accessToken,
    refreshToken, basicInfo})` — same path as existing `login()`.
  - On non-2xx, missing `accessToken`/`refreshToken`, undecodable JWT,
    network error, or timeout: throw `ApiException` with the server message
    + status code (or transport-failure indicator). Do NOT return a partial
    entity.
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 7.1, 7.2, 7.3, 7.4, 7.5, 11.3_
- [x] 2.4 Extend
  `lib/features/authenticate/domain/repositories/authenticate.repository.dart`
  and
  `lib/features/authenticate/data/repositories/authenticate_repository_impl.dart`:
  - Add `Future<AuthenticateEntity> signInWithGoogle()` (no params) to the
    abstract repository.
  - Implementation calls `googleSignInService.signIn()`; if `null` →
    throw `GoogleSignInCancelledException`; if `idToken` empty → throw
    `AppException.unexpected('Google did not return an ID token')`;
    otherwise forward to
    `_remoteDatasource.signInWithGoogle(idToken: result.idToken)`.
  - Update the constructor + the `authenticateRepository` provider to
    inject `googleSignInServiceProvider`.
  - _Requirements: 2.5, 2.6, 3.1_
- [x] 2.5 Extend
  `lib/features/onboarding/sign_up/data/datasources/remote/register_remote_datasource.dart`
  and the matching `RegisterRepository` interface / impl with
  `Future<AuthTokensEntity?> completeProfile(UserEntity profile)`:
  - PATCH `/v1/auth/user/profile` via `apiService.apiClient.invokeAPI(...)`
    with body `{firstName, lastName, dateOfBirth (YYYY-MM-DD), street, ward,
    district, cityOrProvince}`, Bearer `accessToken` from `Token_Store`,
    `.timeout(const Duration(seconds: 30))`.
  - Parse the optional `{access_token, refresh_token}` from the response
    into an `AuthTokensEntity`-shaped value (return `null` if absent so the
    notifier knows to fall back to `/v1/auth/refresh`).
  - On 4xx / 5xx / network / timeout: throw `ApiException` mirroring 2.3.
  - _Requirements: 6.1, 6.2, 6.3, 6.6, 6.7, 6.9_

- [x] 3. Wire Google sign-in into the AuthenticateNotifier and signin screen
- [x] 3.1 Extend
  `lib/features/authenticate/presentation/providers/authenticate.provider.dart`:
  - Add `signInWithGoogle()`. Emit `AsyncLoading` on entry; on success
    persist `refreshToken` then `accessToken` (in that order — same as
    `login()`), emit `AsyncData(AuthenticateStateData(authenticate: entity))`.
  - On `GoogleSignInCancelledException`: restore previous `AsyncData`
    (no error state, no toast).
  - On `ApiException` / unexpected: call `_clearTokensIfPartial()` so no
    half-written token pair remains, then emit `AsyncError(AppException.fromError(e))`.
  - Implement private `_clearTokensIfPartial()` that removes
    `StoreKey.accessToken` and `StoreKey.refreshToken`.
  - Do NOT navigate; navigation happens in the screen's `ref.listen`.
  - _Requirements: 1.5, 1.7, 1.8, 3.5, 3.6, 3.7, 4.5, 7.6, 7.7_
- [x] 3.2 Add a `StateProvider<bool> googleSignInJustCompletedProvider` (in
  `lib/features/authenticate/presentation/providers/`). Set it to `true`
  in the sign-in screen's `ref.listen` `data` branch immediately before
  navigating to `FinishGoogleSignUpRoute`. Reset to `false` from
  `FinishGoogleSignUpScreen.dispose()`.
  - _Requirements: 4.1, 4.2, 5.12_
- [x] 3.3 Edit
  `lib/features/authenticate/presentation/screens/signin.screen.dart`:
  - Wire `keys.signInPage.googleButton.onPressed` to
    `ref.read(authenticateNotifierProvider.notifier).signInWithGoogle()`.
  - Pass `isLoading: authState.isLoading` to the Google `AppButton` (via
    `LoadingContainer`); ensure the email/password submit button reads the
    same loading flag so both buttons disable in lockstep but only the
    Google button shows a spinner.
  - Update `ref.listen(authenticateNotifierProvider, ...)`:
    - On `data` after `prev?.isLoading == true`: decode
      `accessToken.profileCompleted` (`bool` → as-is, missing/null/non-bool
      → `false`). If true → `AppToast.success("Signed in successfully.")`
      then `const HomeRoute().go(context)`. Else → set
      `googleSignInJustCompletedProvider = true` then
      `FinishGoogleSignUpRoute(name: basicInfo?.name, email: basicInfo?.email).go(context)`.
    - On `error`: call a local `_googleErrorToast(err)` helper that maps
      `NetworkException` → "Network error. Please check your connection
      and try again.", and `ServerException` codes to the toasts in the
      design's error matrix; default → "Could not complete Google sign-in.
      Please try again."
  - Toast displays for 4 seconds (already the `AppToast` default; verify).
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 4.1, 4.2, 4.3,
    4.4, 4.5, 7.1, 7.2, 7.3, 7.4, 7.5, 7.8_

- [x] 4. Build the profile completion screen and notifier
- [x] 4.1 Create
  `lib/features/onboarding/sign_up/presentation/providers/finish_google_sign_up.provider.dart`:
  - Freezed `CompleteGoogleProfileStateData({@Default(false) bool isProfileCompleted})`.
  - `@riverpod class CompleteGoogleProfileNotifier` with
    `Future<void> completeGoogleProfile(UserEntity profile)`.
  - Algorithm: emit loading → call
    `registerRepository.completeProfile(profile)`; if response includes
    new tokens, persist them; otherwise call
    `apiService.authenticateApi.authControllerRefresh(...)` with stored
    `refreshToken` (also 30s timeout). Persist refreshed
    `accessToken`/`refreshToken` to `Token_Store` BEFORE emitting success.
    On any failure: classify (4xx/5xx/network/refresh-failure) via
    `AppException.fromError`, emit `AsyncError`, leave existing tokens
    untouched (Req 6.10).
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.6, 6.7, 6.8, 6.9, 6.10_
- [x] 4.2 Create
  `lib/features/onboarding/sign_up/presentation/screens/finish_google_sign_up.dart`:
  - `FinishGoogleSignUpScreen({String? googleDisplayName, String? googleEmail})`.
  - Mirror `FinishSignUpScreen` sections in order: `LegalNameSection`,
    `DateOfBirthSection`, `AddressSection`, `TermsAndSubmitSection`. NO
    `PasswordSection`.
  - Pre-fill `first_name` / `last_name` via the splitting rule in design
    §3.3 (`_splitName`): trim → empty becomes both blank; no whitespace →
    full string in `first_name`; otherwise split on first whitespace,
    `lTrim` the remainder. Pass via `FormBuilder(initialValue: …)`.
  - Validators: `FormValidators.fullName` (first/last),
    `FormValidators.dateOfBirth(minAge: 16)` (DOB),
    `FormValidators.requiredField` (each address field). Submit disabled
    while any required field is empty/invalid (`isFilledAll`).
  - On submit: call
    `ref.read(completeGoogleProfileNotifierProvider.notifier).completeGoogleProfile(profile)`.
  - `ref.listen(completeGoogleProfileNotifierProvider, ...)`:
    - On success: `AppToast.success("Registration completed successfully.")`
      and `const SurveyScreenRoute().go(context)`.
    - On 4xx error → `AppToast.error(serverMessage ?? fallback)`; on 5xx →
      `AppToast.error("Server error. Please try again later.")`; on
      network → `AppToast.error("Network error. Please check your connection
      and try again.")`; on refresh-failure →
      `AppToast.error("We couldn't refresh your session. Please try again.")`.
      Keep entered values intact in all error cases.
  - Disable submit + show loading indicator while
    `completeGoogleProfileNotifierProvider.isLoading`.
  - In `dispose()`: set `googleSignInJustCompletedProvider = false`.
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.10, 5.11,
    6.4, 6.5, 6.6, 6.7, 6.8, 6.9, 6.10_

- [x] 5. Add the route + redirect guard
- [x] 5.1 Add `FinishGoogleSignUpRoute` to `lib/router/routes.dart`:
  - `path: '/finish_google_sign_up'`, `name: 'finish_google_sign_up'`,
    `static const bool isPublic = true`.
  - Constructor params `{this.name, this.email}` exposed as query strings.
  - `buildPage` always returns `_buildSlideTransitionPage(...)` with
    `FinishGoogleSignUpScreen(googleDisplayName: name, googleEmail: email)`.
  - Run `dart run build_runner build --delete-conflicting-outputs` and
    confirm `routes.g.dart` regenerates without analyzer errors.
  - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_
- [x] 5.2 Edit `lib/router/app_router.dart`:
  - Add `FinishGoogleSignUpRoute` to the `isPublicRoute` chain.
  - In `RouterListenable.redirect`, when
    `state.uri.path == FinishGoogleSignUpRoute.pathPattern`, redirect to
    `SignInRoute.pathPattern` unless both
    `authSessionStore.isLoggedIn == true` AND
    `ref.read(googleSignInJustCompletedProvider) == true`.
  - _Requirements: 5.9, 5.12_

- [x] 6. Update logout to clear the Google session
- [x] 6.1 Edit `lib/features/profile/presentation/screens/profile.screen.dart`
  `_handleLogout`:
  - Call `apiService.authenticateApi.authControllerLogout()` with
    `.timeout(const Duration(seconds: 10))`. Catch errors and surface
    `AppToast.warning("Logged out locally; the server did not confirm.")`.
  - After the server call (success OR failure), call
    `ref.read(googleSignInServiceProvider).signOut().timeout(const Duration(seconds: 5))`,
    then `ref.read(authSessionStoreProvider).forceLogout()` so
    `StoreKey.accessToken` + `StoreKey.refreshToken` are cleared.
  - _Requirements: 8.4, 8.5, 8.6_

- [x] 7. Tests
- [x] 7.1 Add property-based test
  `test/features/authenticate/domain/entities/authenticate_entity_property_test.dart`:
  - Add `glados: ^0.7.0` to `dev_dependencies` in `pubspec.yaml`.
  - Generator for `AuthenticateEntity` covering: ASCII access/refresh
    tokens (length 16–512), optional `BasicInfoEntity(email, name?)` with
    email regex `^[a-z0-9.]+@[a-z]+\.[a-z]+$`, `name` either `null` or
    non-empty.
  - Property: `forAll(authenticateEntityGen, (e) =>
    expect(AuthenticateEntity.fromJson(e.toJson()), equals(e)))`,
    minimum 100 iterations.
  - _Requirements: 11.1, 11.2, 11.3_
- [x] 7.2 Add data-layer unit tests
  `test/features/authenticate/data/datasources/authenticate_remote_datasource_test.dart`
  for `signInWithGoogle`:
  - Posts `{id_token}` to `/auth/user/google` (verify URL + body).
  - Applies a 30-second timeout (use `fake_async` or similar).
  - Returns `AuthenticateEntity` with decoded `BasicInfoEntity` on 200.
  - Throws `ApiException(401, GOOGLE_TOKEN_INVALID)` on that response.
  - Throws `ApiException(409, EMAIL_ALREADY_REGISTERED_WITH_PASSWORD)`.
  - Throws `ApiException(403, ACCOUNT_DISABLED)`.
  - Wraps `SocketException` and 30-s timeout as transport failures.
  - _Requirements: 3.2, 3.3, 3.4, 7.1, 7.2, 7.3, 7.4_
- [x] 7.3 Add data-layer unit tests
  `test/features/onboarding/sign_up/data/datasources/register_remote_datasource_complete_profile_test.dart`:
  - PATCHes `/auth/user/profile` with Bearer access token + correct body.
  - Times out after 30 s.
  - _Requirements: 6.1, 6.2, 6.7_
- [x] 7.4 Add notifier unit tests
  `test/features/authenticate/presentation/providers/authenticate_provider_google_test.dart`:
  - Cancellation restores previous `AsyncData` (no error).
  - Success → `AsyncData`; tokens persisted in order (refresh first, then
    access).
  - 4xx error → `AsyncError`; both tokens cleared.
  - Network error → `AsyncError(NetworkException)`; both tokens cleared.
  - Emits `AsyncLoading` before any `await`.
  - _Requirements: 1.3, 1.4, 1.5, 1.8, 2.6, 3.5, 3.6, 3.7, 7.6, 7.7_
- [x] 7.5 Add notifier unit tests
  `test/features/onboarding/sign_up/presentation/providers/finish_google_sign_up_provider_test.dart`:
  - 200 with new tokens persists tokens then emits `AsyncData`.
  - 200 without new tokens → fallback to `/auth/refresh` and persists
    those.
  - 4xx → `AsyncError`, tokens unchanged.
  - 5xx → `AsyncError`, tokens unchanged.
  - Refresh failure → `AsyncError`, tokens unchanged.
  - _Requirements: 6.3, 6.4, 6.6, 6.9, 6.10_
- [x] 7.6 Add widget tests
  `test/features/onboarding/sign_up/presentation/screens/finish_google_sign_up_screen_test.dart`
  covering: section composition (no password section); pre-fill cases
  ("John Doe", "Cher", "", `null`, "   ", "Mary Anne Smith"); submit
  disabled while invalid; submit calls notifier exactly once when valid;
  submit on invalid form does NOT call notifier and preserves values.
  - _Requirements: 5.1, 5.2, 5.3, 5.6, 5.7, 5.8, 5.10, 5.11_
- [x] 7.7 Add router redirect tests
  `test/router/finish_google_sign_up_redirect_test.dart`:
  - Direct nav without recent Google sign-in → redirect to `/signin`.
  - Direct nav after a successful Google sign-in renders the screen.
  - Logged-in user without recent Google sign-in is redirected away.
  - _Requirements: 5.12_
- [x] 7.8 Add Patrol smoke test in `patrol_test/sign_in_test.dart` that taps
  `keys.signInPage.googleButton`, stubs `GoogleSignInService`, and asserts
  navigation to `/home` (returning user) and `/finish_google_sign_up`
  (first-time user).
  - _Requirements: 1.1, 1.2, 1.5, 1.6, 4.2, 4.3_

- [x] 8. Verification
- [x] 8.1 Run `flutter analyze` and ensure zero analyzer errors introduced by
  the new code or generated files.
  - _Requirements: 9.4_
- [x] 8.2 Run the full test suite (`flutter test`) and the property test
  (Task 7.1) at minimum 100 iterations. All tests pass.
  - _Requirements: 11.1, 11.2, 11.3_
- [x] 8.3 Walk through the verification checklist in
  `.kiro/specs/google-signin/configuration-guide.md` (§7.7 of the design):
  backend boot, Android smoke run, JWT audience check, access-token
  signature check, profile-completed branching, iOS URL scheme.
  - _Requirements: 12.7, 16.4_

## Notes

- One PBT property is sufficient (Req 11.1 subsumes 11.2 and 11.3); every
  other test in §7 is example-/edge-/integration-style, per the design
  Section 8.1 deduplication rationale.
- `AuthenticateEntity` is camelCase but the wire format is snake_case. The
  remote datasource builds the entity via the same mapping `login()` already
  uses — DO NOT add `@JsonKey` overrides; that would break `login()`.
- Backend work (Req 10, Req 6.1–6.10 endpoint side) is intentionally NOT
  in this task list. Frontend tests stub the HTTP layer; end-to-end smoke
  (Task 8.3) requires the backend endpoints to be live.
- Run `dart run build_runner build --delete-conflicting-outputs` after any
  freezed/riverpod-generator change (Tasks 2.1, 2.2, 3.1, 4.1, 5.1).
