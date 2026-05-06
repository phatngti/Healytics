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
      await Store.put(StoreKey.refreshToken, response.refreshToken);

      // In mock mode, persist the selected role so
      // `UserRoleHelper.isLoggedIn()` returns true.
      final isMockMode =
          Store.tryGet(StoreKey.mockFlag) ?? false;
      if (isMockMode) {
        await Store.put(StoreKey.mockRole, role);
      }

      // For health_partner role, sync verification flags.
      if (role == Role.health_partner.value) {
        if (!isMockMode) {
          UserRoleHelper
              .syncPartnerFlagsFromAccessToken(
            response.accessToken,
          );
        }
        // In mock mode, partnerVerified and
        // partnerProfileCompleted are already loaded
        // from store.dev.json — no sync needed.
      }

      return response;
    });
  }
}
