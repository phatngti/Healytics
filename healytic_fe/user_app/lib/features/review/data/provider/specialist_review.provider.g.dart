// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist_review.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides [SpecialistReviewRepository] backed by
/// the current datasource (real or mock).

@ProviderFor(specialistReviewDataRepository)
const specialistReviewDataRepositoryProvider =
    SpecialistReviewDataRepositoryProvider._();

/// Provides [SpecialistReviewRepository] backed by
/// the current datasource (real or mock).

final class SpecialistReviewDataRepositoryProvider
    extends
        $FunctionalProvider<
          SpecialistReviewRepository,
          SpecialistReviewRepository,
          SpecialistReviewRepository
        >
    with $Provider<SpecialistReviewRepository> {
  /// Provides [SpecialistReviewRepository] backed by
  /// the current datasource (real or mock).
  const SpecialistReviewDataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'specialistReviewDataRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$specialistReviewDataRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpecialistReviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpecialistReviewRepository create(Ref ref) {
    return specialistReviewDataRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpecialistReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpecialistReviewRepository>(value),
    );
  }
}

String _$specialistReviewDataRepositoryHash() =>
    r'6bf3a91c0dbb8e84d6fb560aa7e16dc50468a8a7';
