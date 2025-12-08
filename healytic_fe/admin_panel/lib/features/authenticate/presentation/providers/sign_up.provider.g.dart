// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up.provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignUpState _$SignUpStateFromJson(Map<String, dynamic> json) => _SignUpState(
  step:
      $enumDecodeNullable(_$SignupStepEnumMap, json['step']) ??
      SignupStep.email,
  request: json['request'] == null
      ? const SignUpRequestEntity(
          password: '',
          bussinessName: '',
          contractPersonName: '',
          bussinessEmail: '',
          bussinessPhone: '',
          address: '',
        )
      : SignUpRequestEntity.fromJson(json['request'] as Map<String, dynamic>),
  emailToken: json['emailToken'] as String? ?? '',
  otpToken: json['otpToken'] as String? ?? '',
);

Map<String, dynamic> _$SignUpStateToJson(_SignUpState instance) =>
    <String, dynamic>{
      'step': _$SignupStepEnumMap[instance.step]!,
      'request': instance.request.toJson(),
      'emailToken': instance.emailToken,
      'otpToken': instance.otpToken,
    };

const _$SignupStepEnumMap = {
  SignupStep.email: 'email',
  SignupStep.otp: 'otp',
  SignupStep.form: 'form',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignUpProvider)
const signUpProviderProvider = SignUpProviderProvider._();

final class SignUpProviderProvider
    extends $AsyncNotifierProvider<SignUpProvider, SignUpState> {
  const SignUpProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signUpProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signUpProviderHash();

  @$internal
  @override
  SignUpProvider create() => SignUpProvider();
}

String _$signUpProviderHash() => r'e53f4b11526af3319338a18c4f6448b8a2325323';

abstract class _$SignUpProvider extends $AsyncNotifier<SignUpState> {
  FutureOr<SignUpState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SignUpState>, SignUpState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SignUpState>, SignUpState>,
              AsyncValue<SignUpState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
