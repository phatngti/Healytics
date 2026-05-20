import 'package:user_app/features/authenticate/domain/entities/authenticate.entity.dart';

abstract class AuthenticateRepository {
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  });

  /// Orchestrates the device-side Google Sign-In flow and exchanges the
  /// resulting ID token with the backend for an [AuthenticateEntity].
  ///
  /// Implementations are responsible for invoking the Google Sign-In
  /// service, handling user cancellation (by throwing a
  /// `GoogleSignInCancelledException`), and forwarding the obtained
  /// `idToken` to the remote datasource.
  Future<AuthenticateEntity> signInWithGoogle();

  Future<void> requestPasswordReset({required String email});

  Future<String> validatePasswordResetCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({required String token, required String password});
}
