// `StateProvider` is exported from `flutter_riverpod/legacy.dart` in
// Riverpod 3.x; the main `flutter_riverpod.dart` barrel intentionally
// excludes it in favor of the generator-driven `Notifier`/`@riverpod`
// API. A simple `StateProvider<bool>` is appropriate here because the
// value is a single transient flag flipped from two well-known places.
import 'package:flutter_riverpod/legacy.dart';

/// Transient session flag indicating that a Google sign-in just succeeded
/// in the current app session and the user is in the middle of the
/// post-sign-in flow (i.e., on their way to, or currently on,
/// `FinishGoogleSignUpRoute`).
///
/// Lifecycle:
/// - Set to `true` by the sign-in screen's `ref.listen` `data` branch
///   (in `signin.screen.dart`) immediately before calling
///   `FinishGoogleSignUpRoute(...).go(context)` for a first-time Google
///   user (i.e., when the decoded access token's `profileCompleted`
///   claim is `false`).
/// - Reset to `false` from `FinishGoogleSignUpScreen.dispose()` so the
///   flag does not leak across navigation cycles or app lifecycles.
///
/// Consumed by the `app_router.dart` redirect guard (Task 5.2) to enforce
/// Requirement 5.12: a user cannot reach `/finish_google_sign_up`
/// directly (deep link, browser refresh, manual URL) without a fresh
/// successful Google sign-in in the current session — the redirect
/// sends them back to `/signin` unless this flag is `true` AND the auth
/// session is logged in.
///
/// A simple `StateProvider<bool>` is intentionally used here instead of a
/// generated `@riverpod` notifier: the value is a single transient bool
/// flipped from two well-known places, so a class notifier would be
/// overkill.
final googleSignInJustCompletedProvider = StateProvider<bool>((ref) => false);
