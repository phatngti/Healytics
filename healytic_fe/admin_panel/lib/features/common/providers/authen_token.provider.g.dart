// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authen_token.provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenTokenEntity _$AuthenTokenEntityFromJson(Map<String, dynamic> json) =>
    _AuthenTokenEntity(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AuthenTokenEntityToJson(_AuthenTokenEntity instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthenToken)
const authenTokenProvider = AuthenTokenProvider._();

final class AuthenTokenProvider
    extends $AsyncNotifierProvider<AuthenToken, AuthenTokenEntity?> {
  const AuthenTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenTokenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenTokenHash();

  @$internal
  @override
  AuthenToken create() => AuthenToken();
}

String _$authenTokenHash() => r'c3edd84d9f3f41ad41fa299399d7f8f2be543561';

abstract class _$AuthenToken extends $AsyncNotifier<AuthenTokenEntity?> {
  FutureOr<AuthenTokenEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<AuthenTokenEntity?>, AuthenTokenEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthenTokenEntity?>, AuthenTokenEntity?>,
              AsyncValue<AuthenTokenEntity?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
