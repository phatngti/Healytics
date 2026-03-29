import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/profile/domain/entities/user_account.entity.dart';
import 'package:user_openapi/api.dart';

// ─── Abstract Interface ────────────────────────────

/// Contract for fetching user profile data from
/// a remote source.
abstract class ProfileRemoteDatasource {
  /// Returns the current user's profile details.
  Future<UserAccountEntity> getAccountMe();
}

// ─── Real Implementation ───────────────────────────

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final ApiService _apiService;

  ProfileRemoteDatasourceImpl(this._apiService);

  @override
  Future<UserAccountEntity> getAccountMe() async {
    try {
      final response = await _apiService.accountApi.accountControllerGetMe();

      if (response == null) {
        throw Exception('Failed to load profile');
      }

      return _mapDtoToEntity(response);
    } catch (e) {
      debugPrint('Error fetching account me: $e');
      rethrow;
    }
  }

  UserAccountEntity _mapDtoToEntity(AccountMeResponseDto dto) {
    return UserAccountEntity(
      id: dto.id,
      email: dto.email,
      username: dto.username,
      firstName: dto.userProfile?.firstName,
      lastName: dto.userProfile?.lastName,
      phone: dto.userProfile?.phone,
      dateOfBirth: dto.userProfile?.dateOfBirth,
      profileCompleted: dto.userProfile?.profileCompleted ?? false,
    );
  }
}

// ─── Mock Implementation ───────────────────────────

class ProfileRemoteDatasourceMock implements ProfileRemoteDatasource {
  @override
  Future<UserAccountEntity> getAccountMe() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Fake data mimicking the developer persona
    return const UserAccountEntity(
      id: 'mock-user-123',
      email: 'mockuser@healytics.io',
      username: 'mock_guest',
      firstName: 'Mock',
      lastName: 'User',
      phone: '+84123456789',
      dateOfBirth: '1995-01-01',
      profileCompleted: true,
    );
  }
}

// ─── Provider ──────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  final useMock = AppEnvironment.current.useMock;

  if (useMock) {
    return ProfileRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return ProfileRemoteDatasourceImpl(apiService);
});
