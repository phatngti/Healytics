// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_flow_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterStateData _$RegisterStateDataFromJson(
  Map<String, dynamic> json,
) => _RegisterStateData(
  stepIndex: (json['stepIndex'] as num?)?.toInt() ?? 0,
  user: json['user'] == null
      ? null
      : UserEntity.fromJson(json['user'] as Map<String, dynamic>),
  surveys:
      (json['surveys'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => SurveyEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const <String, List<SurveyEntity>>{},
  isSurveyCompleted: json['isSurveyCompleted'] as bool? ?? false,
  isRegistrationCompleted: json['isRegistrationCompleted'] as bool? ?? false,
  authTokens: json['authTokens'] == null
      ? null
      : AuthTokensEntity.fromJson(json['authTokens'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegisterStateDataToJson(_RegisterStateData instance) =>
    <String, dynamic>{
      'stepIndex': instance.stepIndex,
      'user': instance.user?.toJson(),
      'surveys': instance.surveys.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
      'isSurveyCompleted': instance.isSurveyCompleted,
      'isRegistrationCompleted': instance.isRegistrationCompleted,
      'authTokens': instance.authTokens?.toJson(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterFlowNotifier)
const registerFlowProvider = RegisterFlowNotifierProvider._();

final class RegisterFlowNotifierProvider
    extends $AsyncNotifierProvider<RegisterFlowNotifier, RegisterStateData> {
  const RegisterFlowNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerFlowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerFlowNotifierHash();

  @$internal
  @override
  RegisterFlowNotifier create() => RegisterFlowNotifier();
}

String _$registerFlowNotifierHash() =>
    r'255b3ec2b36374d9b60ed42fa4f78230d316bc1c';

abstract class _$RegisterFlowNotifier
    extends $AsyncNotifier<RegisterStateData> {
  FutureOr<RegisterStateData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<RegisterStateData>, RegisterStateData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RegisterStateData>, RegisterStateData>,
              AsyncValue<RegisterStateData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
