// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authSessionStore)
const authSessionStoreProvider = AuthSessionStoreProvider._();

final class AuthSessionStoreProvider
    extends
        $FunctionalProvider<
          AuthSessionStore,
          AuthSessionStore,
          AuthSessionStore
        >
    with $Provider<AuthSessionStore> {
  const AuthSessionStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionStoreHash();

  @$internal
  @override
  $ProviderElement<AuthSessionStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthSessionStore create(Ref ref) {
    return authSessionStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSessionStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSessionStore>(value),
    );
  }
}

String _$authSessionStoreHash() => r'116a9e882024286b64e642c200acc459ad2d78d7';
