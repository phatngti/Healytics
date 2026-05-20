import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_me.provider.g.dart';

/// Manages the current authenticated user's account
/// fetched from `/account/me`.
///
/// Lifecycle:
/// - **Login**: call [refresh] after successful sign-in
///   to eagerly fetch and cache account data.
/// - **Logout**: call [clear] to reset state
///   synchronously (avoids disposed-ref crashes).
/// - **Header**: watches this provider to display
///   user name / role; kept alive so it persists
///   across rebuilds.
@Riverpod(keepAlive: true)
class AccountMe extends _$AccountMe {
  @override
  Future<AccountMeResponseDto?> build() async {
    final isMock =
        Store.tryGet(StoreKey.mockFlag) ?? false;

    if (isMock) {
      return _buildMockAccount();
    }

    final apiService = ref.watch(apiServiceProvider);
    return apiService.accountApi
        .accountControllerGetMe();
  }

  /// Re-fetches account data from the API.
  ///
  /// Call after login succeeds so the header
  /// immediately shows the new user's info.
  Future<void> refresh() async {
    state = const AsyncLoading();
    final result =
        await AsyncValue.guard(() => build());
    if (ref.mounted) {
      state = result;
    }
  }

  /// Resets state to `null` without triggering a
  /// new fetch. Safe to call even after async gaps
  /// because it only mutates local notifier state.
  void clear() {
    state = const AsyncData(null);
  }
}

/// Builds a synthetic [AccountMeResponseDto] for
/// mock mode so the Header widget can display
/// without making a real network request.
AccountMeResponseDto _buildMockAccount() {
  final isAdmin = UserRoleHelper.isAdmin();
  final now = DateTime.now();
  return AccountMeResponseDto(
    id: 'mock-account-id',
    email: isAdmin
        ? 'admin@healytics.dev'
        : 'partner@healytics.dev',
    role: isAdmin
        ? AccountMeResponseDtoRoleEnum.admin
        : AccountMeResponseDtoRoleEnum
              .healthPartner,
    isActive: true,
    createdAt: now,
    updatedAt: now,
    userProfile: UserProfileDto(
      id: 'mock-profile-id',
      firstName: isAdmin ? 'Admin' : 'Partner',
      lastName: 'Dev',
      profileCompleted: true,
    ),
  );
}
