// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_details.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ServiceDetailsRepository] wired to the
/// active remote datasource (real or mock).

@ProviderFor(serviceDetailsRepository)
const serviceDetailsRepositoryProvider = ServiceDetailsRepositoryProvider._();

/// Provides the [ServiceDetailsRepository] wired to the
/// active remote datasource (real or mock).

final class ServiceDetailsRepositoryProvider
    extends
        $FunctionalProvider<
          ServiceDetailsRepository,
          ServiceDetailsRepository,
          ServiceDetailsRepository
        >
    with $Provider<ServiceDetailsRepository> {
  /// Provides the [ServiceDetailsRepository] wired to the
  /// active remote datasource (real or mock).
  const ServiceDetailsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceDetailsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceDetailsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServiceDetailsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServiceDetailsRepository create(Ref ref) {
    return serviceDetailsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServiceDetailsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServiceDetailsRepository>(value),
    );
  }
}

String _$serviceDetailsRepositoryHash() =>
    r'e6c83998e7e2183f87963cbcf04f4399cb9eeca0';
