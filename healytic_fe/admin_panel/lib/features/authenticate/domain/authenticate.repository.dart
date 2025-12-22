import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';

abstract class AuthenticateRepository {
  Future<SignInResponseEntity> login(SignInRequestEntity request, String role);
}
