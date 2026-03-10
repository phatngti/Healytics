// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_manual.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ServiceManualRepository]
/// implementation wired to the active remote
/// datasource.

@ProviderFor(serviceManualRepository)
const serviceManualRepositoryProvider = ServiceManualRepositoryProvider._();

/// Provides the [ServiceManualRepository]
/// implementation wired to the active remote
/// datasource.

final class ServiceManualRepositoryProvider
    extends
        $FunctionalProvider<
          ServiceManualRepository,
          ServiceManualRepository,
          ServiceManualRepository
        >
    with $Provider<ServiceManualRepository> {
  /// Provides the [ServiceManualRepository]
  /// implementation wired to the active remote
  /// datasource.
  const ServiceManualRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceManualRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceManualRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServiceManualRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServiceManualRepository create(Ref ref) {
    return serviceManualRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServiceManualRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServiceManualRepository>(value),
    );
  }
}

String _$serviceManualRepositoryHash() =>
    r'52d368b4b0c19c75ef592855ab5750343d33badc';
