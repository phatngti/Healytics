import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/features/onboarding/sign_up/data/repositories/register_repository_impl.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_openapi/api.dart';

part 'finish_google_sign_up.provider.freezed.dart';
part 'finish_google_sign_up.provider.g.dart';

final _log = Logger('CompleteGoogleProfileNotifier');

/// State carried by [CompleteGoogleProfileNotifier].
///
/// `isProfileCompleted` flips to `true` once the
/// profile-update call (and any follow-up token
/// refresh) has succeeded and the new tokens are
/// persisted to `Token_Store`.
@Freezed(toJson: true)
abstract class CompleteGoogleProfileStateData
    with _$CompleteGoogleProfileStateData {
  const factory CompleteGoogleProfileStateData({
    @Default(false) bool isProfileCompleted,
  }) = _CompleteGoogleProfileStateData;

  factory CompleteGoogleProfileStateData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CompleteGoogleProfileStateDataFromJson(json);
}

/// Drives the Google-flow profile-completion call.
///
/// Sequence (Reqs 6.1–6.10):
/// 1. Emits `AsyncLoading`.
/// 2. Calls `registerRepository.completeProfile(profile)`,
///    which returns either a fresh
///    [AuthTokensEntity] (when the backend includes
///    new tokens in the success body) or `null`.
/// 3. If `null`, falls back to
///    `POST /v1/auth/refresh` using the stored
///    `refreshToken`.
/// 4. Persists `refreshToken` then `accessToken`
///    (matching the order used by
///    `AuthenticateNotifier.login`).
/// 5. Emits
///    `AsyncData(CompleteGoogleProfileStateData(
///      isProfileCompleted: true))`.
///
/// On any failure, classifies the error via
/// [AppException.fromError] and emits `AsyncError`.
/// Existing tokens in `Token_Store` are left
/// untouched so the user can retry without being
/// signed out (Req 6.10).
@riverpod
class CompleteGoogleProfileNotifier
    extends _$CompleteGoogleProfileNotifier {
  @override
  Future<CompleteGoogleProfileStateData> build() async =>
      const CompleteGoogleProfileStateData();

  /// Submits the user-entered profile to the backend
  /// and refreshes the auth tokens stored in
  /// `Token_Store` so subsequent requests carry
  /// `profileCompleted: true`.
  Future<void> completeGoogleProfile(UserEntity profile) async {
    state = const AsyncLoading();
    try {
      final tokensFromUpdate = await ref
          .read(registerRepositoryProvider)
          .completeProfile(profile);

      final tokens = tokensFromUpdate ?? await _refreshTokens();

      // Persist refresh first, then access — same
      // order as the existing email/password login
      // path in `authenticate.provider.dart` so the
      // router redirect (which watches the access
      // token) only fires after the refresh token is
      // already on disk.
      await Store.put(StoreKey.refreshToken, tokens.refreshToken);
      await Store.put(StoreKey.accessToken, tokens.accessToken);

      state = AsyncData(
        const CompleteGoogleProfileStateData(isProfileCompleted: true),
      );
    } on ApiException catch (e) {
      _log.warning('Profile completion failed', e);
      state = AsyncError<CompleteGoogleProfileStateData>(
        AppException.fromError(e),
        e.stackTrace ?? StackTrace.current,
      );
    } catch (e, stack) {
      _log.warning('Profile completion failed unexpectedly', e);
      state = AsyncError<CompleteGoogleProfileStateData>(
        AppException.fromError(e),
        stack,
      );
    }
  }

  /// Calls `POST /v1/auth/refresh` with the stored
  /// refresh token. Used when the profile-update
  /// response did not include a fresh token pair.
  Future<AuthTokensEntity> _refreshTokens() async {
    final storedRefreshToken = Store.get(StoreKey.refreshToken, '');
    if (storedRefreshToken.isEmpty) {
      throw const AppException.unexpected(
        message:
            'No refresh token available to complete the profile update.',
      );
    }

    final apiService = ref.read(apiServiceProvider);
    final dto = await apiService.authenticateApi
        .authControllerRefresh(
          RefreshTokenRequestDto(refreshToken: storedRefreshToken),
        )
        .timeout(const Duration(seconds: 30));

    if (dto == null ||
        dto.accessToken.trim().isEmpty ||
        dto.refreshToken.trim().isEmpty) {
      throw const AppException.unexpected(
        message:
            'Refresh response did not include a valid token pair.',
      );
    }

    return AuthTokensEntity(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
  }
}
