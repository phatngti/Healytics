// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finish_google_sign_up.provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompleteGoogleProfileStateData _$CompleteGoogleProfileStateDataFromJson(
  Map<String, dynamic> json,
) => _CompleteGoogleProfileStateData(
  isProfileCompleted: json['isProfileCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$CompleteGoogleProfileStateDataToJson(
  _CompleteGoogleProfileStateData instance,
) => <String, dynamic>{'isProfileCompleted': instance.isProfileCompleted};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(CompleteGoogleProfileNotifier)
const completeGoogleProfileProvider = CompleteGoogleProfileNotifierProvider._();

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
final class CompleteGoogleProfileNotifierProvider
    extends
        $AsyncNotifierProvider<
          CompleteGoogleProfileNotifier,
          CompleteGoogleProfileStateData
        > {
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
  const CompleteGoogleProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeGoogleProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeGoogleProfileNotifierHash();

  @$internal
  @override
  CompleteGoogleProfileNotifier create() => CompleteGoogleProfileNotifier();
}

String _$completeGoogleProfileNotifierHash() =>
    r'cd30df61b5f657c30677f657afd35e5fa72e30c0';

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

abstract class _$CompleteGoogleProfileNotifier
    extends $AsyncNotifier<CompleteGoogleProfileStateData> {
  FutureOr<CompleteGoogleProfileStateData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CompleteGoogleProfileStateData>,
              CompleteGoogleProfileStateData
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CompleteGoogleProfileStateData>,
                CompleteGoogleProfileStateData
              >,
              AsyncValue<CompleteGoogleProfileStateData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
