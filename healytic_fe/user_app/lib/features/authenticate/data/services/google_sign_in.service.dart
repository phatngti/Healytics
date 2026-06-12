import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/features/authenticate/domain/entities/google_sign_in_result.entity.dart';

part 'google_sign_in.service.g.dart';

/// Thrown by `AuthenticateRepository` (Task 2.4) after
/// `GoogleSignInService.signIn()` returns `null` because the user
/// cancelled the device-side sign-in flow.
///
/// Defined here so the cancellation contract is co-located with the
/// service abstraction, even though the service itself never throws it.
class GoogleSignInCancelledException implements Exception {
  const GoogleSignInCancelledException();

  @override
  String toString() => 'GoogleSignInCancelledException';
}

/// Wraps the `google_sign_in` plugin so that no other layer in the app
/// imports `package:google_sign_in/google_sign_in.dart`.
///
/// Higher layers receive a framework-neutral [GoogleSignInResult] (or
/// `null` for user cancellation) and never see plugin-specific types.
abstract class GoogleSignInService {
  /// Triggers the interactive Google Sign-In flow on the device.
  ///
  /// Returns the resulting [GoogleSignInResult] on success, or `null`
  /// if the user cancelled (closed the picker / pressed back / denied
  /// consent). Other failures (configuration, network, plugin) bubble
  /// up as [GoogleSignInException]s thrown by the plugin or as
  /// [StateError] for missing configuration.
  Future<GoogleSignInResult?> signIn();

  /// Clears any cached Google account from the device. Errors are
  /// swallowed so callers can always treat logout as having succeeded
  /// locally.
  Future<void> signOut();
}

/// Production implementation that delegates to `GoogleSignIn.instance`
/// from `google_sign_in` v7.
class GoogleSignInServiceImpl implements GoogleSignInService {
  GoogleSignInServiceImpl();

  /// Lazily-resolved future of the one-shot `initialize` call.
  ///
  /// `GoogleSignIn.instance.initialize(...)` must be awaited exactly
  /// once before any other API on the singleton is used. Caching the
  /// future here makes `signIn()` and `signOut()` safe to call in any
  /// order or concurrently.
  Future<void>? _initFuture;

  Future<void> _ensureInitialized() {
    return _initFuture ??= _initialize();
  }

  Future<void> _initialize() async {
    final serverClientId = AppEnvironment.googleServerClientId;
    if (serverClientId.isEmpty) {
      throw StateError(
        'GOOGLE_SERVER_CLIENT_ID is not configured. '
        'Pass it via --dart-define=GOOGLE_SERVER_CLIENT_ID=... '
        'so the Google Sign-In plugin can issue an ID token whose '
        'audience matches the backend GOOGLE_OAUTH_WEB_CLIENT_ID.',
      );
    }

    await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
  }

  @override
  Future<GoogleSignInResult?> signIn() async {
    await _ensureInitialized();

    try {
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['openid', 'email', 'profile'],
      );

      final idToken = account.authentication.idToken ?? '';

      // Per Task 2.2 contract: an empty idToken is forwarded to the
      // upstream repository (Task 2.4), which surfaces a clear error.
      // The service does not throw here.
      return GoogleSignInResult(
        idToken: idToken,
        email: account.email,
        displayName: account.displayName,
        photoUrl: account.photoUrl,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      // `disconnect()` also signs the user out and revokes prior
      // authorization, which is the v7+ equivalent of the v6
      // `signOut()` + revoke pair.
      await GoogleSignIn.instance.disconnect();
    } catch (_) {
      // Swallow so logout always succeeds locally. The caller has
      // already cleared first-party tokens; whether the platform
      // SDK could reach Google is best-effort.
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Best-effort fallback also failed; nothing else to do.
      }
    }
  }
}

/// Provider for [GoogleSignInService].
///
/// `keepAlive: true` matches the rest of the auth data layer
/// (`authenticateRepositoryProvider`, `apiServiceProvider`) so the
/// initialised plugin singleton is reused for the entire app session.
@Riverpod(keepAlive: true)
GoogleSignInService googleSignInService(Ref ref) => GoogleSignInServiceImpl();
