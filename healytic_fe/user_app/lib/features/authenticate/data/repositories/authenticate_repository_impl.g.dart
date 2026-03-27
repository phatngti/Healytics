// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authenticateRepository)
const authenticateRepositoryProvider = AuthenticateRepositoryProvider._();

final class AuthenticateRepositoryProvider
    extends
        $FunctionalProvider<
          AuthenticateRepository,
          AuthenticateRepository,
          AuthenticateRepository
        >
    with $Provider<AuthenticateRepository> {
  const AuthenticateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticateRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticateRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthenticateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthenticateRepository create(Ref ref) {
    return authenticateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticateRepository>(value),
    );
  }
}

String _$authenticateRepositoryHash() =>
    r'46fe1d254679f9d73ac6d28fc9a1eeb52cc6a8b1';
