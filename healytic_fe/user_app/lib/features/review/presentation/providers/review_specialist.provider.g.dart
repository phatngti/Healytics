// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_specialist.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides [SpecialistReviewRepository] backed by
/// the current datasource (real or mock).

@ProviderFor(specialistReviewRepository)
const specialistReviewRepositoryProvider =
    SpecialistReviewRepositoryProvider._();

/// Provides [SpecialistReviewRepository] backed by
/// the current datasource (real or mock).

final class SpecialistReviewRepositoryProvider
    extends
        $FunctionalProvider<
          SpecialistReviewRepository,
          SpecialistReviewRepository,
          SpecialistReviewRepository
        >
    with $Provider<SpecialistReviewRepository> {
  /// Provides [SpecialistReviewRepository] backed by
  /// the current datasource (real or mock).
  const SpecialistReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'specialistReviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$specialistReviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpecialistReviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpecialistReviewRepository create(Ref ref) {
    return specialistReviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpecialistReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpecialistReviewRepository>(value),
    );
  }
}

String _$specialistReviewRepositoryHash() =>
    r'1c24251c12d44280e361e254335aa17a13d277ce';

/// Manages the specialist review form state and
/// handles submission through the repository.

@ProviderFor(ReviewSpecialistNotifier)
const reviewSpecialistProvider = ReviewSpecialistNotifierProvider._();

/// Manages the specialist review form state and
/// handles submission through the repository.
final class ReviewSpecialistNotifierProvider
    extends $NotifierProvider<ReviewSpecialistNotifier, ReviewSpecialistState> {
  /// Manages the specialist review form state and
  /// handles submission through the repository.
  const ReviewSpecialistNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewSpecialistProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewSpecialistNotifierHash();

  @$internal
  @override
  ReviewSpecialistNotifier create() => ReviewSpecialistNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewSpecialistState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewSpecialistState>(value),
    );
  }
}

String _$reviewSpecialistNotifierHash() =>
    r'57fc6f32e255bff12cc00a46b074604c62842df5';

/// Manages the specialist review form state and
/// handles submission through the repository.

abstract class _$ReviewSpecialistNotifier
    extends $Notifier<ReviewSpecialistState> {
  ReviewSpecialistState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReviewSpecialistState, ReviewSpecialistState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReviewSpecialistState, ReviewSpecialistState>,
              ReviewSpecialistState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
