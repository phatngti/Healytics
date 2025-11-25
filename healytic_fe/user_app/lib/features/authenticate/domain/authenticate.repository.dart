import 'package:user_app/features/authenticate/domain/authenticate.entity.dart';

abstract class AuthenticateRepository {
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  });
}
