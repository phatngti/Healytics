// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignInProvider)
const signInProviderProvider = SignInProviderProvider._();

final class SignInProviderProvider
    extends $AsyncNotifierProvider<SignInProvider, SignInResponseEntity?> {
  const SignInProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInProviderHash();

  @$internal
  @override
  SignInProvider create() => SignInProvider();
}

String _$signInProviderHash() => r'e87c2ccc363edf892263fb14e8a6b03e392a3899';

abstract class _$SignInProvider extends $AsyncNotifier<SignInResponseEntity?> {
  FutureOr<SignInResponseEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<SignInResponseEntity?>, SignInResponseEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SignInResponseEntity?>,
                SignInResponseEntity?
              >,
              AsyncValue<SignInResponseEntity?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
