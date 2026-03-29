// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_review.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides [TreatmentReviewRepository] backed by
/// the current datasource (real or mock).

@ProviderFor(treatmentReviewRepository)
const treatmentReviewRepositoryProvider = TreatmentReviewRepositoryProvider._();

/// Provides [TreatmentReviewRepository] backed by
/// the current datasource (real or mock).

final class TreatmentReviewRepositoryProvider
    extends
        $FunctionalProvider<
          TreatmentReviewRepository,
          TreatmentReviewRepository,
          TreatmentReviewRepository
        >
    with $Provider<TreatmentReviewRepository> {
  /// Provides [TreatmentReviewRepository] backed by
  /// the current datasource (real or mock).
  const TreatmentReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'treatmentReviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$treatmentReviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<TreatmentReviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TreatmentReviewRepository create(Ref ref) {
    return treatmentReviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TreatmentReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TreatmentReviewRepository>(value),
    );
  }
}

String _$treatmentReviewRepositoryHash() =>
    r'c707c8f4cb1f257bbb2b0fb430ac8a1c17de16dc';
