import '../entities/authenticate.entity.dart';

/// Domain contract for authentication.
///
/// Employee app only supports login — no registration.
abstract class AuthenticateRepository {
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  });
}
