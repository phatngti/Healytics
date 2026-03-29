// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate.provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticateStateData _$AuthenticateStateDataFromJson(
  Map<String, dynamic> json,
) => _AuthenticateStateData(
  authenticate: json['authenticate'] == null
      ? null
      : AuthenticateEntity.fromJson(
          json['authenticate'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AuthenticateStateDataToJson(
  _AuthenticateStateData instance,
) => <String, dynamic>{'authenticate': instance.authenticate?.toJson()};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthenticateNotifier)
const authenticateProvider = AuthenticateNotifierProvider._();

final class AuthenticateNotifierProvider
    extends
        $AsyncNotifierProvider<AuthenticateNotifier, AuthenticateStateData> {
  const AuthenticateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticateNotifierHash();

  @$internal
  @override
  AuthenticateNotifier create() => AuthenticateNotifier();
}

String _$authenticateNotifierHash() =>
    r'cedbb4da933f7a4f096e42b5a2bddd51740b93e8';

abstract class _$AuthenticateNotifier
    extends $AsyncNotifier<AuthenticateStateData> {
  FutureOr<AuthenticateStateData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<AuthenticateStateData>, AuthenticateStateData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AuthenticateStateData>,
                AuthenticateStateData
              >,
              AsyncValue<AuthenticateStateData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
