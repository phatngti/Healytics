// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_review.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides [FacilityReviewRepository] backed by
/// the current datasource (real or mock).

@ProviderFor(facilityReviewRepository)
const facilityReviewRepositoryProvider = FacilityReviewRepositoryProvider._();

/// Provides [FacilityReviewRepository] backed by
/// the current datasource (real or mock).

final class FacilityReviewRepositoryProvider
    extends
        $FunctionalProvider<
          FacilityReviewRepository,
          FacilityReviewRepository,
          FacilityReviewRepository
        >
    with $Provider<FacilityReviewRepository> {
  /// Provides [FacilityReviewRepository] backed by
  /// the current datasource (real or mock).
  const FacilityReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'facilityReviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$facilityReviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<FacilityReviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FacilityReviewRepository create(Ref ref) {
    return facilityReviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FacilityReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FacilityReviewRepository>(value),
    );
  }
}

String _$facilityReviewRepositoryHash() =>
    r'5ca632f4246643fdc5464b66a7a65e55d37acfe6';
