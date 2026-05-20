import 'package:user_app/features/authenticate/domain/entities/authenticate.entity.dart';

abstract class AuthenticateRepository {
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  });

  Future<void> requestPasswordReset({required String email});

  Future<String> validatePasswordResetCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({required String token, required String password});
}
