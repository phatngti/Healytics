import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_me.provider.g.dart';

/// Fetches the current authenticated user's account
/// details from the `/account/me` endpoint.
///
/// In mock mode, returns synthetic data to avoid
/// hitting the real API with an invalid mock token
/// (which would trigger a 401 → session clear →
/// redirect back to login).
///
/// Kept alive so the header doesn't refetch on every
/// rebuild. Invalidate manually after profile edits.
@Riverpod(keepAlive: true)
Future<AccountMeResponseDto?> accountMe(Ref ref) async {
  final isMock =
      Store.tryGet(StoreKey.mockFlag) ?? false;

  if (isMock) {
    return _buildMockAccount();
  }

  final apiService = ref.watch(apiServiceProvider);
  return apiService.accountApi
      .accountControllerGetMe();
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
