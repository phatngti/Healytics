// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_preferences_register_local_datasouce.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'50d46e3f8d9f32715d0f3efabdce724e4b2593b4';

@ProviderFor(registerLocalDatasource)
const registerLocalDatasourceProvider = RegisterLocalDatasourceProvider._();

final class RegisterLocalDatasourceProvider
    extends
        $FunctionalProvider<
          RegistrationLocalDatasource,
          RegistrationLocalDatasource,
          RegistrationLocalDatasource
        >
    with $Provider<RegistrationLocalDatasource> {
  const RegisterLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerLocalDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<RegistrationLocalDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegistrationLocalDatasource create(Ref ref) {
    return registerLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegistrationLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegistrationLocalDatasource>(value),
    );
  }
}

String _$registerLocalDatasourceHash() =>
    r'f0a85ba49357ac8a30a20f53ed8402ec4d33559a';
