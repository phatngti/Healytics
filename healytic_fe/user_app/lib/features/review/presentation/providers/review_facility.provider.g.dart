// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_facility.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the facility review form state and
/// handles submission through the repository.

@ProviderFor(ReviewFacilityNotifier)
const reviewFacilityProvider = ReviewFacilityNotifierProvider._();

/// Manages the facility review form state and
/// handles submission through the repository.
final class ReviewFacilityNotifierProvider
    extends $NotifierProvider<ReviewFacilityNotifier, ReviewFacilityState> {
  /// Manages the facility review form state and
  /// handles submission through the repository.
  const ReviewFacilityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewFacilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewFacilityNotifierHash();

  @$internal
  @override
  ReviewFacilityNotifier create() => ReviewFacilityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewFacilityState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewFacilityState>(value),
    );
  }
}

String _$reviewFacilityNotifierHash() =>
    r'1a456d5ddaf981325d673d338b7af06a304e87b5';

/// Manages the facility review form state and
/// handles submission through the repository.

abstract class _$ReviewFacilityNotifier extends $Notifier<ReviewFacilityState> {
  ReviewFacilityState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReviewFacilityState, ReviewFacilityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReviewFacilityState, ReviewFacilityState>,
              ReviewFacilityState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
