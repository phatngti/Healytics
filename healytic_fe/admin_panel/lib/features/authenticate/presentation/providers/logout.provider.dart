import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/utils/browser_storage.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/features/common/providers/account_me.provider.dart';
import 'package:admin_panel/features/common/providers/authen_token.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout.provider.g.dart';

/// Handles session teardown by clearing all persisted
/// auth state and Riverpod token state.
///
/// After calling [logout], the caller is responsible
/// for navigating to the login route.
@riverpod
class LogoutProvider extends _$LogoutProvider {
  @override
  FutureOr<void> build() {}

  /// Clears tokens from both Riverpod state and
  /// persistent storage, then wipes session flags.
  ///
  /// Calls [AccountMe.clear] to synchronously reset
  /// cached user info without triggering a re-fetch.
  Future<void> logout() async {
    await ref.read(authenTokenProvider.notifier).removeToken();
    await Store.delete(StoreKey.accessToken);
    await Store.delete(StoreKey.refreshToken);
    removeBrowserItem('access_token');
    await UserRoleHelper.clearSession();
    if (!ref.mounted) return;
    ref.read(accountMeProvider.notifier).clear();
  }
}
