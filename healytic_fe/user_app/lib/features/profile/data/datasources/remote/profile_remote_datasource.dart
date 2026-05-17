import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/providers/s3.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/core/services/s3.service.dart';
import 'package:user_app/features/profile/domain/entities/user_account.entity.dart';
import 'package:user_app/features/profile/domain/entities/profile_summary.entity.dart';

// ─── Abstract Interface ────────────────────────────

/// Contract for fetching user profile data from
/// a remote source.
abstract class ProfileRemoteDatasource {
  /// Returns the current user's profile details.
  Future<UserAccountEntity> getAccountMe();

  Future<ProfileSummaryEntity> getProfileSummary();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount({required String password});

  /// Uploads avatar image via S3 presigned URL.
  /// Returns the storage key for the uploaded file.
  Future<String> uploadAvatar({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  });

  /// Persists the S3 key as the user's avatar on
  /// the backend profile.
  Future<void> updateAvatarUrl(String avatarUrl);
}

// ─── Real Implementation ───────────────────────────

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final ApiService _apiService;
  final S3Service _s3Service;

  ProfileRemoteDatasourceImpl(this._apiService, this._s3Service);

  @override
  Future<UserAccountEntity> getAccountMe() async {
    try {
      final response =
          await _apiService.apiClient.invokeAPI(
        '/account/me',
        'GET',
        const [],
        null,
        {},
        {},
        null,
      );
      if (response.statusCode >= 400 ||
          response.body.isEmpty) {
        throw Exception('Failed to load profile');
      }
      final json = jsonDecode(response.body)
          as Map<String, dynamic>;

      return _mapJsonToEntity(json);
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

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/account/password',
      'PATCH',
      const [],
      {'currentPassword': currentPassword, 'newPassword': newPassword},
      {'Content-Type': 'application/json'},
      {},
      'application/json',
    );
    if (response.statusCode >= 400) {
      throw Exception(
        _messageFromResponse(response.body, 'Unable to change password'),
      );
    }
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/account/me',
      'DELETE',
      const [],
      {'password': password},
      {'Content-Type': 'application/json'},
      {},
      'application/json',
    );
    if (response.statusCode >= 400) {
      throw Exception(
        _messageFromResponse(response.body, 'Unable to delete account'),
      );
    }
  }

  @override
  Future<String> uploadAvatar({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    final key = await _s3Service.uploadBytes(
      fileName: fileName,
      contentType: contentType,
      bytes: Uint8List.fromList(bytes),
    );
    if (key == null) {
      throw Exception('Failed to upload avatar');
    }
    return key;
  }

  @override
  Future<void> updateAvatarUrl(
    String avatarUrl,
  ) async {
    final response =
        await _apiService.apiClient.invokeAPI(
      '/account/me/avatar',
      'PATCH',
      const [],
      {'avatarUrl': avatarUrl},
      {'Content-Type': 'application/json'},
      {},
      'application/json',
    );
    if (response.statusCode >= 400) {
      throw Exception(
        'Failed to update avatar URL',
      );
    }
  }

  int _toInt(Object? raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  UserAccountEntity _mapJsonToEntity(
    Map<String, dynamic> json,
  ) {
    final profile =
        json['userProfile'] as Map<String, dynamic>?;
    return UserAccountEntity(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: profile?['firstName'] as String?,
      lastName: profile?['lastName'] as String?,
      phone: profile?['phone'] as String?,
      dateOfBirth:
          profile?['dateOfBirth']?.toString(),
      avatarUrl:
          profile?['avatarUrl'] as String?,
      profileCompleted:
          profile?['profileCompleted'] as bool? ??
          false,
    );
  }

  String _messageFromResponse(String body, String fallback) {
    if (body.isEmpty) return fallback;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
        if (message is List && message.isNotEmpty) {
          return message.join('\n');
        }
      }
    } catch (_) {
      // Use fallback for non-JSON backend errors.
    }
    return fallback;
  }
}

// ─── Mock Implementation ───────────────────────────

class ProfileRemoteDatasourceMock
    implements ProfileRemoteDatasource {
  @override
  Future<UserAccountEntity> getAccountMe() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

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
  Future<ProfileSummaryEntity>
  getProfileSummary() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    return const ProfileSummaryEntity(
      ordersCount: 12,
      wishlistCount: 48,
      points: 0,
      pointsLabel: '0',
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }

  @override
  Future<void> deleteAccount({
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }

  @override
  Future<String> uploadAvatar({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    );
    return 'mock-avatars/$fileName';
  }

  @override
  Future<void> updateAvatarUrl(
    String avatarUrl,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
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
  final s3Service = ref.read(s3ServiceProvider);
  return ProfileRemoteDatasourceImpl(
    apiService,
    s3Service,
  );
});
