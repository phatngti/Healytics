// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_treatment.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the treatment review form state and
/// handles submission through the repository.

@ProviderFor(ReviewTreatmentNotifier)
const reviewTreatmentProvider = ReviewTreatmentNotifierProvider._();

/// Manages the treatment review form state and
/// handles submission through the repository.
final class ReviewTreatmentNotifierProvider
    extends $NotifierProvider<ReviewTreatmentNotifier, ReviewTreatmentState> {
  /// Manages the treatment review form state and
  /// handles submission through the repository.
  const ReviewTreatmentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewTreatmentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewTreatmentNotifierHash();

  @$internal
  @override
  ReviewTreatmentNotifier create() => ReviewTreatmentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewTreatmentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewTreatmentState>(value),
    );
  }
}

String _$reviewTreatmentNotifierHash() =>
    r'a8618d0ccebcc04be2a9917c4e026c2ef2574f1c';

/// Manages the treatment review form state and
/// handles submission through the repository.

abstract class _$ReviewTreatmentNotifier
    extends $Notifier<ReviewTreatmentState> {
  ReviewTreatmentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReviewTreatmentState, ReviewTreatmentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReviewTreatmentState, ReviewTreatmentState>,
              ReviewTreatmentState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
