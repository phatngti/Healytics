import 'package:admin_panel/core/entities/role.entity.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:admin_panel/features/authenticate/datasource/repository_implement.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in.provider.g.dart';

@riverpod
class SignInProvider extends _$SignInProvider {
  @override
  FutureOr<SignInResponseEntity?> build() {
    return null;
  }

  Future<void> signIn(String email, String password, String role) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final request = SignInRequestEntity(email: email, password: password);
      final response = await ref
          .read(authenticateRepositoryProvider)
          .login(request, role);

      // Save access token to store
      await Store.put(StoreKey.accessToken, response.accessToken);

      // For health_partner role, determine verification status
      if (role == Role.health_partner.value) {
        final isVerified = response.verificationCompletedAt != null;
        UserRoleHelper.setPartnerVerified(isVerified);
      }

      return response;
    });
  }
}
