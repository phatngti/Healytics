import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/profile/domain/entities/user_account.entity.dart';
import 'package:user_app/features/profile/domain/entities/profile_summary.entity.dart';
import 'package:user_openapi/api.dart';

// ─── Abstract Interface ────────────────────────────

/// Contract for fetching user profile data from
/// a remote source.
abstract class ProfileRemoteDatasource {
  /// Returns the current user's profile details.
  Future<UserAccountEntity> getAccountMe();

  Future<ProfileSummaryEntity> getProfileSummary();
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

  @override
  Future<ProfileSummaryEntity> getProfileSummary() async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/profile/summary',
      'GET',
      const [],
      null,
      {},
      {},
      null,
    );
    if (response.statusCode >= 400 || response.body.isEmpty) {
      throw Exception('Failed to load profile summary');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ProfileSummaryEntity(
      ordersCount: _toInt(json['ordersCount']),
      wishlistCount: _toInt(json['wishlistCount']),
      points: _toInt(json['points']),
      pointsLabel: json['pointsLabel']?.toString() ?? '0',
    );
  }

  int _toInt(Object? raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  UserAccountEntity _mapDtoToEntity(AccountMeResponseDto dto) {
    return UserAccountEntity(
      id: dto.id,
      email: dto.email,

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

      firstName: 'Mock',
      lastName: 'User',
      phone: '+84123456789',
      dateOfBirth: '1995-01-01',
      profileCompleted: true,
    );
  }

  @override
  Future<ProfileSummaryEntity> getProfileSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const ProfileSummaryEntity(
      ordersCount: 12,
      wishlistCount: 48,
      points: 0,
      pointsLabel: '0',
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
