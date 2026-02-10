// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authenticateRemoteDatasource)
const authenticateRemoteDatasourceProvider =
    AuthenticateRemoteDatasourceProvider._();

final class AuthenticateRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          AuthenticateRemoteDatasource,
          AuthenticateRemoteDatasource,
          AuthenticateRemoteDatasource
        >
    with $Provider<AuthenticateRemoteDatasource> {
  const AuthenticateRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticateRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticateRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<AuthenticateRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthenticateRemoteDatasource create(Ref ref) {
    return authenticateRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticateRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticateRemoteDatasource>(value),
    );
  }
}

String _$authenticateRemoteDatasourceHash() =>
    r'5bc675e5089826bece42ec683548b39153d8b48e';
