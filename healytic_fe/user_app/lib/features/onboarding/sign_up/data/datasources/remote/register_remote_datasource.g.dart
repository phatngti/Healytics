// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(registerRemoteDatasource)
const registerRemoteDatasourceProvider = RegisterRemoteDatasourceProvider._();

final class RegisterRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          RegisterRemoteDatasource,
          RegisterRemoteDatasource,
          RegisterRemoteDatasource
        >
    with $Provider<RegisterRemoteDatasource> {
  const RegisterRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<RegisterRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegisterRemoteDatasource create(Ref ref) {
    return registerRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterRemoteDatasource>(value),
    );
  }
}

String _$registerRemoteDatasourceHash() =>
    r'a4c044a0cf7413e98bb6cc151e07ade064853a84';
