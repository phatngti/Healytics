// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for [GoogleSignInService].
///
/// `keepAlive: true` matches the rest of the auth data layer
/// (`authenticateRepositoryProvider`, `apiServiceProvider`) so the
/// initialised plugin singleton is reused for the entire app session.

@ProviderFor(googleSignInService)
const googleSignInServiceProvider = GoogleSignInServiceProvider._();

/// Provider for [GoogleSignInService].
///
/// `keepAlive: true` matches the rest of the auth data layer
/// (`authenticateRepositoryProvider`, `apiServiceProvider`) so the
/// initialised plugin singleton is reused for the entire app session.

final class GoogleSignInServiceProvider
    extends
        $FunctionalProvider<
          GoogleSignInService,
          GoogleSignInService,
          GoogleSignInService
        >
    with $Provider<GoogleSignInService> {
  /// Provider for [GoogleSignInService].
  ///
  /// `keepAlive: true` matches the rest of the auth data layer
  /// (`authenticateRepositoryProvider`, `apiServiceProvider`) so the
  /// initialised plugin singleton is reused for the entire app session.
  const GoogleSignInServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleSignInServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleSignInServiceHash();

  @$internal
  @override
  $ProviderElement<GoogleSignInService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleSignInService create(Ref ref) {
    return googleSignInService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleSignInService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleSignInService>(value),
    );
  }
}

String _$googleSignInServiceHash() =>
    r'5ae762cea7dcf9d33592f6ca762101c60a306324';
