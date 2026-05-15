import 'package:admin_panel/core/entities/role.entity.dart';
import 'package:admin_panel/core/utils/browser_storage.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:admin_panel/features/authenticate/datasource/repository_implement.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/common/providers/account_me.provider.dart';
import 'package:admin_panel/features/common/providers/authen_token.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in.provider.g.dart';

@riverpod
class SignInProvider extends _$SignInProvider {
  @override
  FutureOr<SignInResponseEntity?> build() {
    return null;
  }

  Future<void> signIn(
    String email,
    String password,
    String role,
  ) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await _clearPreviousSession();

      final request = SignInRequestEntity(
        email: email,
        password: password,
      );
      final response = await ref
          .read(authenticateRepositoryProvider)
          .login(request, role);

      // Save tokens to store
      await Store.put(
        StoreKey.accessToken,
        response.accessToken,
      );
      await Store.put(
        StoreKey.refreshToken,
        response.refreshToken,
      );

      if (!ref.mounted) return response;

      await ref
          .read(authenTokenProvider.notifier)
          .saveToken(
            AuthenTokenEntity(
              accessToken: response.accessToken,
              refreshToken: response.refreshToken,
            ),
          );

      final isMockMode =
          Store.tryGet(StoreKey.mockFlag) ?? false;

      // Persist role for mock mode so
      // UserRoleHelper.getRole() works correctly.
      if (isMockMode) {
        await Store.put(StoreKey.mockRole, role);
      }

      // For health_partner, sync verification flags.
      if (role == Role.health_partner.value) {
        if (isMockMode) {
          await _syncFlagsFromResponse(response);
        } else {
          await UserRoleHelper
              .syncPartnerFlagsFromAccessToken(
                response.accessToken,
              );
        }
      }

      if (!ref.mounted) return response;

      await ref
          .read(accountMeProvider.notifier)
          .refresh();
      return response;
    });

    // Only update state if the provider is
    // still alive — avoids disposed-ref crash
    // after navigation.
    if (ref.mounted) {
      state = result;
    }
  }

  /// Removes stale account, token, and partner-only
  /// flags before a new login writes its session.
  Future<void> _clearPreviousSession() async {
    await ref.read(authenTokenProvider.notifier).removeToken();
    await Store.delete(StoreKey.accessToken);
    await Store.delete(StoreKey.refreshToken);
    removeBrowserItem('access_token');
    await UserRoleHelper.clearSession();
    ref.read(accountMeProvider.notifier).clear();
  }

  /// Syncs partner flags from [SignInResponseEntity]
  /// fields for mock mode (no JWT decoding needed).
  Future<void> _syncFlagsFromResponse(SignInResponseEntity response) async {
    final isVerified = response.verificationStatus?.toUpperCase() == 'APPROVED';
    final isProfileCompleted = response.verificationCompletedAt != null;

    await UserRoleHelper.setPartnerVerified(isVerified);
    await UserRoleHelper.setPartnerProfileCompleted(isProfileCompleted);
  }
}
