# Requirements Document

## Introduction

This feature adds Google Sign-In to the existing Healytics user app sign-in
screen at `lib/features/authenticate/presentation/screens/signin.screen.dart`.
The existing screen already renders a "Continue with Google" outlined button
(`keys.signInPage.googleButton`) with an empty `onPressed` callback. This spec
turns that placeholder into a working flow that:

1. Triggers the Google OAuth flow on the device.
2. Exchanges the resulting Google ID token with the Healytics backend for a
   first-party access/refresh token pair.
3. Branches the post-sign-in navigation:
   - First-time Google sign-in (no completed Healytics user profile) →
     a profile-completion screen modeled on `FinishSignUpScreen` (no password
     fields, display name pre-filled from the Google account) → survey flow.
   - Returning Google sign-in (profile already complete) → the normal
     post-login destination (the home shell route).
4. Reuses the existing clean-architecture conventions (Riverpod 3,
   freezed entities, repository/data source pairs, GoRouter `routes.dart`).

The spec also produces a configuration guide covering the platform-side setup
required for `google_sign_in` on Android, iOS, and Web, plus the backend env
variables the new endpoint will consume.

### Scope notes for the backend dependency

An inspection of `backend/src/auth` (controller, service, strategies, DTOs,
and `.env.sample`) confirms that **no Google OAuth endpoint currently exists**.
The closest analogue is the user/login flow returning `AuthTokensDto`
(`access_token`, `refresh_token`, `access_expires_in`, `refresh_expires_in`).
The `Account` entity already has a nullable `password_hash` column, so
social-only accounts are storage-compatible. This requirements document
therefore defines both:

- The Flutter-side behavior (Sections 1–9), and
- The exact data contract the Healytics backend SHALL expose (Section 10),
  so that backend implementation can proceed in parallel.

## Glossary

- **Healytics_App**: The Flutter user app (`user_app`).
- **Sign_In_Screen**: The existing screen at
  `lib/features/authenticate/presentation/screens/signin.screen.dart`.
- **Google_Auth_Client**: The platform Google Sign-In SDK accessed through the
  `google_sign_in` Flutter package.
- **Google_ID_Token**: The signed JWT that Google issues to identify the user
  to a relying-party backend (the value returned in
  `GoogleSignInAuthentication.idToken`).
- **Google_Server_Client_ID**: The OAuth 2.0 Web client ID that the backend
  uses as the audience when verifying a `Google_ID_Token`. The Flutter client
  passes this as the `serverClientId`/`clientId` so Google issues an ID token
  with the correct `aud` claim.
- **Backend_Auth_API**: The Healytics backend authentication module at
  `backend/src/auth`.
- **Google_Auth_Endpoint**: A new POST endpoint
  `POST /v1/auth/user/google` exposed by `Backend_Auth_API`.
- **Auth_Tokens**: The pair `{access_token, refresh_token}` (plus optional
  TTL fields) returned by `Backend_Auth_API`, matching the existing
  `AuthTokensDto`.
- **Authenticate_Repository**: The existing
  `AuthenticateRepository` interface at
  `lib/features/authenticate/domain/repositories/authenticate.repository.dart`.
- **Authenticate_Notifier**: The existing
  `AuthenticateNotifier` Riverpod notifier at
  `lib/features/authenticate/presentation/providers/authenticate.provider.dart`.
- **Finish_Google_SignUp_Screen**: A new screen, modeled on `FinishSignUpScreen`
  at
  `lib/features/onboarding/sign_up/presentation/screens/finish_sign_up.dart`,
  used to collect the remaining profile data after a first-time Google sign-in.
  It SHALL omit the password section.
- **Survey_Screen**: The existing `SurveyScreenRoute` post-registration screen
  used by the regular sign-up flow.
- **Profile_Completed_Flag**: The boolean already carried in the JWT payload
  as `profileCompleted` (see `backend/src/auth/strategies/jwt.strategy.ts`),
  used to decide between first-time and returning-user navigation.
- **Token_Store**: The existing secure key/value abstraction at
  `lib/core/services/store.entity.dart` accessed via
  `Store.put(StoreKey.accessToken|refreshToken, ...)`.

## Requirements

### Requirement 1: Sign-in screen entry point

**User Story:** As a user on the sign-in screen, I want a Google sign-in button, so that I can authenticate with my Google account instead of typing an email and password.

#### Acceptance Criteria

1. THE Sign_In_Screen SHALL render a "Continue with Google" button that matches the existing `AppButton` outlined-style entry point keyed by `keys.signInPage.googleButton`.
2. WHEN the user taps the Google button and no sign-in flow is currently in progress, THE Sign_In_Screen SHALL invoke a `signInWithGoogle()` method on `Authenticate_Notifier` exactly once per tap.
3. WHILE the Google sign-in flow is in progress, THE Sign_In_Screen SHALL disable both the email/password submit button and the Google button until the flow terminates with success, failure, or cancellation, and SHALL re-enable both buttons once it terminates.
4. WHILE the Google sign-in flow is in progress, THE Sign_In_Screen SHALL display a loading indicator on the Google button in place of its label and SHALL not display a loading indicator on the email/password submit button.
5. WHEN the Google sign-in flow finishes successfully and the user has a completed profile, THE Sign_In_Screen SHALL show the toast "Signed in successfully." (re-using the existing `AppToast.success` pattern in `signin.screen.dart`).
6. WHEN the Google sign-in flow finishes successfully and the user does not have a completed profile, THE Sign_In_Screen SHALL not show the success toast and SHALL direct the user to the profile completion step.
7. IF the Google sign-in flow terminates with an authentication or network failure, THEN THE Sign_In_Screen SHALL display an error toast indicating sign-in failure (re-using the existing `AppToast.error` pattern) and SHALL leave the email/password input fields unchanged.
8. IF the user cancels the Google sign-in flow before it completes, THEN THE Sign_In_Screen SHALL not display any toast and SHALL leave the email/password input fields unchanged.

### Requirement 2: Google OAuth flow on device

**User Story:** As a user, I want the app to request my consent through
Google's official sign-in UI, so that I never type my Google password into
the Healytics app.

#### Acceptance Criteria

1. WHEN `signInWithGoogle()` is invoked, THE Healytics_App SHALL call the
   `google_sign_in` package's interactive sign-in API.
2. THE Healytics_App SHALL request the OAuth scopes `openid`, `email`, and
   `profile`.
3. THE Healytics_App SHALL configure the Google Sign-In client with the
   `Google_Server_Client_ID` so Google issues a `Google_ID_Token` whose
   `aud` claim equals that server client ID.
4. WHEN the Google sign-in flow completes successfully, THE Healytics_App
   SHALL extract the `Google_ID_Token` and the Google account profile
   (display name, email, photo URL) from the result.
5. IF the Google sign-in flow returns no `Google_ID_Token`, THEN THE
   Healytics_App SHALL treat the attempt as a failure and surface a generic
   "Could not complete Google sign-in" error to the user.
6. IF the user cancels the Google sign-in flow (closes the picker, presses
   back, or denies consent), THEN THE Healytics_App SHALL leave
   `Authenticate_Notifier` state unchanged from before the attempt and SHALL
   NOT show any error toast.

### Requirement 3: Backend exchange

**User Story:** As a security-conscious developer, I want the Google ID token to be verified server-side, so that the client cannot forge a Healytics session.

#### Acceptance Criteria

1. WHEN a non-empty `Google_ID_Token` is obtained from the Google Sign-In flow, THE Authenticate_Repository SHALL invoke `signInWithGoogle({required String idToken})` on `AuthenticateRemoteDatasource`, passing the `Google_ID_Token` value unchanged.
2. WHEN `signInWithGoogle({required String idToken})` is invoked on `AuthenticateRemoteDatasource`, THE `AuthenticateRemoteDatasource` SHALL POST to `Google_Auth_Endpoint` (`/v1/auth/user/google`) with a JSON body of the shape `{ "id_token": "<Google_ID_Token>" }` and SHALL treat the request as failed if no response is received within 30 seconds (see Requirement 10 for the full contract).
3. WHEN `Backend_Auth_API` returns HTTP 200 or 201 with a body containing non-empty `accessToken` and `refreshToken` strings and a JWT whose payload can be decoded, THE `AuthenticateRemoteDatasource` SHALL deserialize the response into an `AuthenticateEntity` containing `accessToken`, `refreshToken`, and the `BasicInfoEntity` decoded from the JWT payload (matching the existing `login()` data path).
4. IF `Backend_Auth_API` returns HTTP 4xx or 5xx, OR the response body is missing `accessToken` or `refreshToken`, OR the JWT payload cannot be decoded, OR the request fails with a network error, OR the request exceeds the 30-second timeout, THEN THE `AuthenticateRemoteDatasource` SHALL throw an `ApiException` carrying the server-provided message and status code when available, or a transport-failure indicator when no server response is available, and SHALL NOT return a partial `AuthenticateEntity`.
5. WHEN `signInWithGoogle()` returns an `AuthenticateEntity` to `Authenticate_Notifier`, THE Healytics_App SHALL persist `accessToken` to `Token_Store` under `StoreKey.accessToken` and `refreshToken` under `StoreKey.refreshToken` using the same `Store.put` calls already used by the email/password `login()` path, completing both writes before any state is emitted to listeners.
6. WHEN both `Store.put` writes for `accessToken` and `refreshToken` complete successfully, THE Authenticate_Notifier SHALL emit `AsyncData(AuthenticateStateData(authenticate: <entity>))` so the existing `ref.listen(authenticateProvider, ...)` listener on the sign-in screen fires its success branch.
7. IF `signInWithGoogle()` throws an `ApiException`, OR either of the `Store.put` calls for `accessToken` or `refreshToken` fails, THEN THE Authenticate_Notifier SHALL emit `AsyncError` carrying the originating exception, SHALL NOT emit `AsyncData`, and SHALL ensure no partially persisted token pair remains in `Token_Store`, so the existing `ref.listen(authenticateProvider, ...)` listener fires its error branch.

### Requirement 4: First-time vs returning user branching

**User Story:** As a first-time Google user, I want to finish my Healytics
profile before entering the app; as a returning user, I want to land directly
on Home.

#### Acceptance Criteria

1. THE Healytics_App SHALL read the `profileCompleted` boolean claim from
   the decoded `accessToken` JWT payload to decide branching.
2. WHEN `profileCompleted` is `false` (or the claim is missing/null), THE
   Healytics_App SHALL navigate to the new
   `Finish_Google_SignUp_Screen` route.
3. WHEN `profileCompleted` is `true`, THE Healytics_App SHALL navigate to the
   existing post-login destination `HomeRoute` using
   `const HomeRoute().go(context)`.
4. WHEN navigation to `Finish_Google_SignUp_Screen` is performed, THE
   Healytics_App SHALL pass the Google-supplied display name and email to
   the screen so they can be used to pre-fill form fields.
5. WHILE a Google sign-in attempt is in flight, THE Healytics_App SHALL NOT
   trigger any navigation; navigation SHALL only occur from the
   `ref.listen(authenticateProvider, ...)` success branch on the sign-in
   screen.

### Requirement 5: Finish-Google-SignUp screen behavior

**User Story:** As a first-time Google user, I want a short profile form (name, date of birth, address) with my name pre-filled and no password field, so that finishing sign-up is fast.

#### Acceptance Criteria

1. THE Finish_Google_SignUp_Screen SHALL render the same sections as `FinishSignUpScreen` EXCEPT the password section, displaying exactly the following sections in the same order as `FinishSignUpScreen`: legal name (first_name, last_name), date of birth, address, and terms-and-submit.
2. WHEN the Finish_Google_SignUp_Screen is opened with a non-empty Google display name, THE Finish_Google_SignUp_Screen SHALL pre-fill the `first_name` and `last_name` form fields by splitting the display name on the first whitespace character, assigning the substring before the split to `first_name` and the remainder (with leading whitespace removed) to `last_name`.
3. IF the Google display name contains no whitespace, THEN THE Finish_Google_SignUp_Screen SHALL use the entire string as `first_name` and leave `last_name` empty for the user to complete.
4. WHILE the legal name fields are pre-filled, THE Finish_Google_SignUp_Screen SHALL allow the user to edit `first_name` and `last_name` before submission, with no read-only or disabled state on either field.
5. THE Finish_Google_SignUp_Screen SHALL apply the same form validators as `FinishSignUpScreen` for the equivalent fields: `FormValidators.fullName` for legal name, `FormValidators.dateOfBirth(minAge: 16)` for date of birth, and `FormValidators.requiredField` for each address field that `FinishSignUpScreen` marks as required.
6. THE Finish_Google_SignUp_Screen SHALL NOT include a password field, a confirm-password field, or any password validators.
7. WHILE any displayed required field (first_name, last_name, date of birth, and each address field required by `FinishSignUpScreen`) fails its validator or is empty, THE Finish_Google_SignUp_Screen SHALL keep its submit button disabled, mirroring the `isFilledAll` behavior of `FinishSignUpScreen`.
8. WHEN the user taps submit on Finish_Google_SignUp_Screen and every displayed required field passes its validator, THE Healytics_App SHALL call a new `completeGoogleProfile(UserEntity profileWithoutPassword)` method on a dedicated notifier (see Requirement 6) exactly once per tap.
9. THE Finish_Google_SignUp_Screen SHALL be registered in `lib/router/routes.dart` as a typed `GoRouteData` named `FinishGoogleSignUpRoute` with `isPublic = true`, and SHALL be reachable only after a successful Google sign-in in the current session.
10. IF the Google display name is empty, null, or contains only whitespace, THEN THE Finish_Google_SignUp_Screen SHALL leave both `first_name` and `last_name` fields empty and SHALL still apply all validators defined in criterion 5.
11. IF the user taps submit while one or more displayed required fields fail validation, THEN THE Finish_Google_SignUp_Screen SHALL NOT call `completeGoogleProfile`, SHALL display a validation error indicator on each failing field, and SHALL preserve all values the user has entered.
12. IF the FinishGoogleSignUpRoute is accessed without a successful Google sign-in in the current session, THEN THE Healytics_App SHALL redirect to the Google sign-in entry point without rendering the Finish_Google_SignUp_Screen and without invoking `completeGoogleProfile`.

### Requirement 6: Profile completion exchange with backend

**User Story:** As the system, I need to send the user-entered profile fields to the backend so the account record is updated and `profileCompleted` becomes `true` on the next login.

#### Acceptance Criteria

1. WHEN `completeGoogleProfile` is invoked, THE Healytics_App SHALL submit the user's first name (1 to 100 characters), last name (1 to 100 characters), date of birth (ISO 8601 calendar date in YYYY-MM-DD form), and address subfields to a profile-update endpoint on `Backend_Auth_API` using the existing authenticated `ApiService` with the access token from `Token_Store` attached as a Bearer header, applying a request timeout of 30 seconds.
2. THE Healytics_App SHALL reuse the existing `RegisterProfileDto`-shaped fields (`firstName`, `lastName`, `dateOfBirth`, plus address subfields) when constructing the request body, so the backend can validate with the same DTOs already in use.
3. WHEN the profile-update call returns success, THE Healytics_App SHALL refresh the auth tokens by using the new `Auth_Tokens` payload if it is present in the success response body, otherwise by calling the existing `POST /v1/auth/refresh` endpoint with the stored refresh token using a request timeout of 30 seconds.
4. WHEN refreshed tokens are obtained, THE Healytics_App SHALL replace `StoreKey.accessToken` and `StoreKey.refreshToken` in `Token_Store` with the new values before performing any subsequent navigation.
5. WHEN profile completion succeeds and the refreshed tokens have been persisted in `Token_Store`, THE Healytics_App SHALL navigate to `SurveyScreenRoute` using `const SurveyScreenRoute().go(context)`, matching the navigation that `FinishSignUpScreen` performs on success.
6. IF profile completion fails with an HTTP response in the 400-499 range, THEN THE Healytics_App SHALL display `AppToast.error` with the server-provided message (or with a fallback message indicating the profile information was rejected when no server message is available) and keep the user on `Finish_Google_SignUp_Screen` with all entered field values preserved exactly as the user typed them.
7. IF profile completion fails due to a network error (request timeout exceeding 30 seconds, DNS resolution failure, connection refused, or no internet connectivity), THEN THE Healytics_App SHALL display `AppToast.error` with the message "Network error. Please check your connection and try again." and keep the user on `Finish_Google_SignUp_Screen` with all entered field values preserved exactly as the user typed them.
8. WHILE a profile-update request or its follow-up token refresh is in flight, THE Healytics_App SHALL disable the submit control on `Finish_Google_SignUp_Screen` and present a loading indicator so that no duplicate profile-update request can be issued.
9. IF profile completion fails with an HTTP response in the 500-599 range, THEN THE Healytics_App SHALL display `AppToast.error` with a message indicating a server error and asking the user to try again later, and keep the user on `Finish_Google_SignUp_Screen` with all entered field values preserved.
10. IF the post-success token refresh fails (HTTP error, network error, or timeout), THEN THE Healytics_App SHALL display `AppToast.error` with a message indicating the session could not be refreshed, leave existing `StoreKey.accessToken` and `StoreKey.refreshToken` values in `Token_Store` unchanged, and keep the user on `Finish_Google_SignUp_Screen` with all entered field values preserved.

### Requirement 7: Error handling for the Google sign-in path

**User Story:** As a user, I want clear, distinct error messages for the different things that can go wrong during Google sign-in.

#### Acceptance Criteria

1. IF the Google sign-in flow does not receive an HTTP response from `Backend_Auth_API` within 15 seconds, or fails due to a transport-level failure (DNS resolution failure, TLS handshake failure, socket disconnect, or absence of network connectivity), THEN THE Healytics_App SHALL display the toast "Network error. Please check your connection and try again."
2. IF `Backend_Auth_API` responds with HTTP 401 carrying the error code `GOOGLE_TOKEN_INVALID` (see Requirement 10), THEN THE Healytics_App SHALL display the toast "Could not verify your Google sign-in. Please try again."
3. IF `Backend_Auth_API` responds with HTTP 409 carrying the error code `EMAIL_ALREADY_REGISTERED_WITH_PASSWORD` (see Requirement 10), THEN THE Healytics_App SHALL display the toast "This email is already registered with a password. Please sign in with email and password instead."
4. IF `Backend_Auth_API` responds with HTTP 403 carrying the error code `ACCOUNT_DISABLED`, THEN THE Healytics_App SHALL display the toast "This account is disabled. Please contact support."
5. IF `Backend_Auth_API` responds with any HTTP status code outside the 2xx range that does not match criteria 2 through 4, THEN THE Healytics_App SHALL display the toast "Could not complete Google sign-in. Please try again."
6. WHEN any error path in this requirement fires, THE Healytics_App SHALL set `Authenticate_Notifier.state` to an `AsyncError<AuthenticateStateData>` wrapping an `AppException` (matching the existing `login()` error handling in `authenticate.provider.dart`).
7. WHEN any error path in this requirement fires, THE Healytics_App SHALL remove all access tokens, refresh tokens, and user identifiers written during this sign-in attempt from `Token_Store` before updating `Authenticate_Notifier.state`, such that subsequent reads from `Token_Store` for those keys return null.
8. WHEN any error path in this requirement fires, THE Healytics_App SHALL display exactly one toast for that failure attempt, with the toast remaining visible for 4 seconds before auto-dismissing.

### Requirement 8: Token storage and session lifecycle

**User Story:** As a returning user, I want my Google session to persist across app launches like a normal email/password session.

#### Acceptance Criteria

1. WHEN the `Google_Auth_Endpoint` returns a successful response containing access and refresh tokens, THE Healytics_App SHALL persist the access token under `StoreKey.accessToken` and the refresh token under `StoreKey.refreshToken` in the existing `Token_Store`, using the identical write path used by the email/password flow.
2. IF the `Google_Auth_Endpoint` response contains a token field that the existing `Token_Store` cannot represent (for example a TTL/expiry field), THEN THE Healytics_App SHALL extend the existing `Token_Store` and its `StoreKey` enum with a new key for that field rather than creating a parallel store, and SHALL NOT introduce any separate "google session" store.
3. WHEN the app launches and a non-empty value exists under `StoreKey.accessToken` in `Token_Store`, THE `app_router.dart` redirect logic SHALL apply the same redirect decision regardless of whether the token was issued by the password flow or the Google flow, with no branch in `app_router.dart` that reads any Google-specific key, flag, or claim.
4. WHEN the user triggers logout and the existing `POST /v1/auth/logout` endpoint returns a successful response, THE Healytics_App SHALL invoke `GoogleSignIn.signOut()` (or the `disconnect()` equivalent for `google_sign_in` v7+) to clear the cached Google account on the device, completing this call within 5 seconds.
5. IF the `POST /v1/auth/logout` endpoint returns a non-success response or fails to respond within 10 seconds, THEN THE Healytics_App SHALL still invoke `GoogleSignIn.signOut()` (or the v7+ `disconnect()` equivalent), clear `StoreKey.accessToken` and `StoreKey.refreshToken` from `Token_Store`, and surface an error indication to the user that logout completed locally but the server logout did not confirm.
6. WHEN the logout flow completes (whether the server call succeeded or failed), THE Healytics_App SHALL remove the values stored under `StoreKey.accessToken` and `StoreKey.refreshToken` from `Token_Store` such that a subsequent read of either key returns no value, matching the existing email/password logout behavior.

### Requirement 9: Routing and navigation wiring

**User Story:** As a developer, I want all new routes wired through the
project's `go_router_builder` typed routes, so navigation stays type-safe.

#### Acceptance Criteria

1. THE Healytics_App SHALL register a new route `FinishGoogleSignUpRoute` in
   `lib/router/routes.dart` with `path: '/finish_google_sign_up'`,
   `name: 'finish_google_sign_up'`, and `isPublic = true`.
2. THE `FinishGoogleSignUpRoute` SHALL accept the Google-supplied
   display name and email as query parameters (`name` and `email`) so a
   deep link reload re-pre-fills the form.
3. THE `FinishGoogleSignUpRoute.buildPage` SHALL always return a
   slide-transition page using the existing `_buildSlideTransitionPage`
   helper, with no conditional fallback to another transition type.
4. WHEN code generation runs, THE Healytics_App SHALL produce a working
   `routes.g.dart` (via `dart run build_runner build
   --delete-conflicting-outputs`) without analyzer errors caused by the
   new route.
5. WHEN navigating to `FinishGoogleSignUpRoute`, THE Healytics_App SHALL
   use the typed call
   `FinishGoogleSignUpRoute(name: ..., email: ...).go(context)` (preferred
   over string-based `context.go`).

### Requirement 10: Backend Google_Auth_Endpoint contract

**User Story:** As a backend engineer, I need a precise specification of the
new endpoint, so I can implement it in `backend/src/auth` consistent with
the existing controller and DTO conventions.

#### Acceptance Criteria

1. THE Backend_Auth_API SHALL expose `POST /v1/auth/user/google`, marked
   `@Public()` (no JWT required) and `@Throttle({ default: { limit: 1000,
   ttl: 60000 } })` to match the existing register/login throttling.
2. THE Backend_Auth_API SHALL accept a JSON request body validated by a new
   `GoogleSignInDto` containing exactly one required field
   `id_token: string` annotated `@IsString() @IsNotEmpty()`.
3. WHEN a request is received, THE Backend_Auth_API SHALL verify the
   `id_token` using `google-auth-library`'s `OAuth2Client.verifyIdToken`,
   passing the configured `Google_Server_Client_ID` as the audience.
4. IF `id_token` verification fails (signature, expiry, or audience
   mismatch), THEN THE Backend_Auth_API SHALL respond with HTTP 401 and a
   JSON body `{ "statusCode": 401, "message": "Invalid Google ID token",
   "code": "GOOGLE_TOKEN_INVALID" }`.
5. WHEN verification succeeds, THE Backend_Auth_API SHALL look up an
   `Account` by the verified `email` (case-insensitive).
6. WHEN no account exists, THE Backend_Auth_API SHALL create a new
   `Account` row with the verified email, `passwordHash = null`,
   `role = USER`, and create a stub `UserProfile` populated with the
   Google `given_name` (→ `firstName`) and `family_name` (→ `lastName`).
   The newly created account SHALL be considered profile-incomplete
   (i.e., the JWT issued in this response SHALL carry
   `profileCompleted: false`).
7. WHEN an account exists with `passwordHash != null` AND no prior Google
   linkage is recorded, THEN THE Backend_Auth_API SHALL respond with HTTP
   409 and JSON `{ "statusCode": 409, "message": "Email already registered
   with a password", "code": "EMAIL_ALREADY_REGISTERED_WITH_PASSWORD" }`.
8. WHEN an account exists and is eligible for Google sign-in, THE
   Backend_Auth_API SHALL issue an `Auth_Tokens` payload identical in
   shape to the existing `AuthTokensDto`
   (`access_token`, `refresh_token`, `access_expires_in?`,
   `refresh_expires_in?`).
9. THE access token issued by `Google_Auth_Endpoint` SHALL include the
   same JWT claims the existing `loginUser()` issues (`sub`, `email`,
   `role`, `firstName`, `lastName`, `profileCompleted`,
   `verificationStatus`, `verificationCompletedAt`,
   `partnerProfileCompleted`).
10. IF the matched account has `isActive = false`, THEN THE
    Backend_Auth_API SHALL respond with HTTP 403 and JSON
    `{ "statusCode": 403, "message": "Account is disabled",
    "code": "ACCOUNT_DISABLED" }`.
11. THE Backend_Auth_API SHALL log a structured audit entry
    (`logger.log("User signed in via Google: ${account.id}")`) on success,
    matching the existing audit-log style.
12. THE Backend_Auth_API SHALL read the audience client ID from a new
    environment variable `GOOGLE_OAUTH_WEB_CLIENT_ID` (added to
    `backend/.env.sample`); IF the variable is absent, THEN the endpoint
    SHALL respond HTTP 500 with `{ "code": "GOOGLE_OAUTH_NOT_CONFIGURED" }`
    on every request.

### Requirement 11: Round-trip property — JSON contract

**User Story:** As a developer maintaining the data layer, I want the
`AuthenticateEntity` JSON serialization to round-trip cleanly, so token
shapes returned by the Google endpoint cannot silently drift from the
existing email/password contract.

#### Acceptance Criteria

1. FOR ALL valid `AuthenticateEntity` values produced by the Google sign-in
   path, `AuthenticateEntity.fromJson(entity.toJson())` SHALL return an
   entity equal to the original (round-trip property).
2. THE deserialization of a `Google_Auth_Endpoint` HTTP-200 body SHALL
   produce an `AuthenticateEntity` that is `==`-equal to the entity
   produced by deserializing the equivalent `loginUser()` HTTP-200 body
   with the same `accessToken`/`refreshToken`.
3. THE `BasicInfoEntity` populated by the Google path SHALL be derivable
   purely from the JWT payload (`email`, optional `firstName`+`lastName`),
   matching the existing `login()` extraction logic in
   `authenticate_remote_datasource.dart`.

### Requirement 12: Configuration prerequisites — Google Cloud Console

**User Story:** As a developer setting up a fresh checkout, I need a clear list of cloud-console artifacts to create, so the device flow actually works end-to-end.

#### Acceptance Criteria

1. THE configuration guide SHALL document creating an OAuth 2.0 Web client in the Healytics Google Cloud project, recording its client ID as `Google_Server_Client_ID`, and registering the same string value (character-for-character) as `GOOGLE_OAUTH_WEB_CLIENT_ID` in `backend/.env`.
2. THE configuration guide SHALL document creating one OAuth 2.0 Android client for each of the `debug` and `release` build variants, using the application package name `com.example.user_app` (currently configured in `pubspec.yaml > patrol > android > package_name`) together with both the SHA-1 and SHA-256 fingerprints extracted from the keystore that signs that specific build variant.
3. THE configuration guide SHALL document creating an OAuth 2.0 iOS client using the bundle ID `com.example.userApp` (currently configured in `pubspec.yaml > patrol > ios > bundle_id`) and recording both the iOS client ID and the reversed client ID, and SHALL specify the location in the iOS app configuration where each value is consumed.
4. WHERE the app is built for Web, THE configuration guide SHALL document adding to the Web client's "Authorized JavaScript origins" the development origin `http://localhost:<port>` where `<port>` is an integer between 1 and 65535 matching the local dev-server port, plus the exact scheme-host-port of every deployed production environment from which the Web app will be served.
5. THE configuration guide SHALL state that the value used by the Flutter client as `Google_Server_Client_ID` and the value of `GOOGLE_OAUTH_WEB_CLIENT_ID` on the backend SHALL be the same string, character-for-character, with no surrounding whitespace.
6. THE configuration guide SHALL state that the Flutter client SHALL pass `Google_Server_Client_ID` as the `serverClientId` parameter when initiating Google sign-in, so that the resulting `Google_ID_Token` carries the backend's OAuth Web client as its audience.
7. IF any required OAuth client (Web, Android per build variant, or iOS) is missing, or if the Flutter `serverClientId` does not match the backend's `GOOGLE_OAUTH_WEB_CLIENT_ID`, THEN THE configuration guide SHALL describe the resulting observable failure mode (sign-in rejection or token-audience mismatch) and the corresponding remediation step so the developer can identify which artifact is misconfigured.

### Requirement 13: Configuration prerequisites — Android

**User Story:** As an Android engineer, I need to know exactly which
fingerprints and manifest entries are required for Google Sign-In to
succeed on Android.

#### Acceptance Criteria

1. THE configuration guide SHALL document obtaining the debug keystore
   SHA-1 via
   `keytool -list -v -keystore ~/.android/debug.keystore
   -alias androiddebugkey -storepass android -keypass android`.
2. THE configuration guide SHALL document obtaining the release keystore
   SHA-1 and SHA-256 via the project's release keystore using the
   equivalent `keytool` invocation, and registering both fingerprints on
   the Android OAuth client in Google Cloud Console.
3. THE configuration guide SHALL document the minimum
   `android/app/build.gradle` settings required by `google_sign_in`:
   `minSdkVersion >= 21` and an explicit `applicationId` matching the
   Google Cloud Console package name.
4. THE configuration guide SHALL document that no additional
   `AndroidManifest.xml` intent-filter is required for `google_sign_in`
   v6+ (Credential Manager based) beyond the standard internet
   permission.

### Requirement 14: Configuration prerequisites — iOS

**User Story:** As an iOS engineer, I need to know which `Info.plist` entries are required for the Google sign-in URL callback.

#### Acceptance Criteria

1. THE configuration guide SHALL document adding the iOS reversed client ID, formatted as `com.googleusercontent.apps.<CLIENT_ID_SUFFIX>`, as a URL scheme entry in `ios/Runner/Info.plist` under the `CFBundleURLTypes > CFBundleURLSchemes` array.
2. THE configuration guide SHALL document adding the `GIDClientID` key to the root dictionary of `ios/Runner/Info.plist` with its value set to the iOS OAuth client ID obtained from the Google Cloud Console.
3. THE configuration guide SHALL document the minimum iOS deployment target required by the `google_sign_in_ios` plugin version pinned in `pubspec.yaml`, including the exact version string (for example, `14.0`) that engineers must set in `ios/Podfile` via the `platform :ios, '<version>'` directive.
4. THE configuration guide SHALL state that the iOS OAuth client ID must be a distinct credential from the Web client ID.
5. THE configuration guide SHALL state that the iOS OAuth client ID and the Web client ID must both be registered under the same Google Cloud project and the same OAuth consent screen.
6. THE configuration guide SHALL document a verification procedure that confirms the URL scheme registration, the `GIDClientID` value, and the Podfile deployment target are correctly applied before building the iOS app.

### Requirement 15: Configuration prerequisites — Flutter packages

**User Story:** As a developer adding the Flutter dependency, I need a
pinned version range that is compatible with the project's existing
Flutter SDK and Riverpod 3 setup.

#### Acceptance Criteria

1. THE configuration guide SHALL specify adding `google_sign_in` to
   `pubspec.yaml > dependencies` with a version constraint compatible
   with `sdk: ^3.9.2` and the existing `flutter_riverpod: ^3.0.3` /
   `hooks_riverpod: ^3.0.3` versions.
2. THE configuration guide SHALL specify pinning a single major version
   (e.g., `google_sign_in: ^7.0.0`) and SHALL NOT use an open-ended `any`
   constraint.
3. WHERE the chosen `google_sign_in` major version requires a separate
   web implementation, THE configuration guide SHALL specify also adding
   `google_sign_in_web` with a version aligned to that major.
4. THE configuration guide SHALL document running
   `flutter pub get` and `dart run build_runner build
   --delete-conflicting-outputs` after adding the dependency, so the new
   provider/repository code generates correctly.
5. THE configuration guide SHALL document how to verify the install via
   a smoke check (e.g., import `package:google_sign_in/google_sign_in.dart`
   in an existing widget and call the version-appropriate initialization
   method without runtime errors).

### Requirement 16: Configuration prerequisites — Backend env alignment

**User Story:** As an integrator wiring frontend and backend together, I
need to know exactly which env vars must agree.

#### Acceptance Criteria

1. THE configuration guide SHALL document adding
   `GOOGLE_OAUTH_WEB_CLIENT_ID=<web-client-id>` to `backend/.env` and
   `backend/.env.sample`.
2. THE configuration guide SHALL state that
   `GOOGLE_OAUTH_WEB_CLIENT_ID` MUST equal the `serverClientId` configured
   in the Flutter `GoogleSignIn` initialization.
3. THE configuration guide SHALL document that the backend SHALL load
   `GOOGLE_OAUTH_WEB_CLIENT_ID` via `ConfigService` (consistent with the
   existing `JwtStrategy` usage) and SHALL fail fast at boot if the
   variable is missing in `production` `NODE_ENV`.
4. THE configuration guide SHALL document how to validate the alignment
   end-to-end: a successful call to `POST /v1/auth/user/google` with an
   `id_token` issued for the configured audience SHALL return HTTP 200
   with an `access_token` whose `aud` matches the backend JWT secret's
   issuer (sanity check via `jwt.io` or `JwtDecoder`).
