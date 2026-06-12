// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for fetching categories via the repository.

@ProviderFor(categories)
const categoriesProvider = CategoriesProvider._();

/// Provider for fetching categories via the repository.

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeCategory>>,
          List<HomeCategory>,
          FutureOr<List<HomeCategory>>
        >
    with
        $FutureModifier<List<HomeCategory>>,
        $FutureProvider<List<HomeCategory>> {
  /// Provider for fetching categories via the repository.
  const CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeCategory>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'ccdbbc2a859dcec6c5184d26a13f99dd1a95991e';

/// Provider for fetching home-recommend products
/// via the Recommender AI microservice.

@ProviderFor(recommendedProducts)
const recommendedProductsProvider = RecommendedProductsProvider._();

/// Provider for fetching home-recommend products
/// via the Recommender AI microservice.

final class RecommendedProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AiRecommendation>>,
          List<AiRecommendation>,
          FutureOr<List<AiRecommendation>>
        >
    with
        $FutureModifier<List<AiRecommendation>>,
        $FutureProvider<List<AiRecommendation>> {
  /// Provider for fetching home-recommend products
  /// via the Recommender AI microservice.
  const RecommendedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recommendedProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recommendedProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<AiRecommendation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AiRecommendation>> create(Ref ref) {
    return recommendedProducts(ref);
  }
}

String _$recommendedProductsHash() =>
    r'4dd8a35b6af9b8c7a1523324df05055fcd9d8dcd';

/// Provider for the full recommendations list.

@ProviderFor(allRecommendedProducts)
const allRecommendedProductsProvider = AllRecommendedProductsProvider._();

/// Provider for the full recommendations list.

final class AllRecommendedProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AiRecommendation>>,
          List<AiRecommendation>,
          FutureOr<List<AiRecommendation>>
        >
    with
        $FutureModifier<List<AiRecommendation>>,
        $FutureProvider<List<AiRecommendation>> {
  /// Provider for the full recommendations list.
  const AllRecommendedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allRecommendedProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allRecommendedProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<AiRecommendation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AiRecommendation>> create(Ref ref) {
    return allRecommendedProducts(ref);
  }
}

String _$allRecommendedProductsHash() =>
    r'ced9649efdf86a115d8aacabfa86f695170bef36';

/// Provider for fetching premium treatments.

@ProviderFor(premiumTreatments)
const premiumTreatmentsProvider = PremiumTreatmentsProvider._();

/// Provider for fetching premium treatments.

final class PremiumTreatmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeProduct>>,
          List<HomeProduct>,
          FutureOr<List<HomeProduct>>
        >
    with
        $FutureModifier<List<HomeProduct>>,
        $FutureProvider<List<HomeProduct>> {
  /// Provider for fetching premium treatments.
  const PremiumTreatmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'premiumTreatmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$premiumTreatmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeProduct>> create(Ref ref) {
    return premiumTreatments(ref);
  }
}

String _$premiumTreatmentsHash() => r'6c8cebdb94282e56b44d9827ab91115558c36de7';

/// Accumulates the full Premium Treatments screen as pages are loaded.

@ProviderFor(PremiumTreatmentsPaginated)
const premiumTreatmentsPaginatedProvider =
    PremiumTreatmentsPaginatedProvider._();

/// Accumulates the full Premium Treatments screen as pages are loaded.
final class PremiumTreatmentsPaginatedProvider
    extends
        $AsyncNotifierProvider<
          PremiumTreatmentsPaginated,
          PremiumTreatmentsAccumulated
        > {
  /// Accumulates the full Premium Treatments screen as pages are loaded.
  const PremiumTreatmentsPaginatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'premiumTreatmentsPaginatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$premiumTreatmentsPaginatedHash();

  @$internal
  @override
  PremiumTreatmentsPaginated create() => PremiumTreatmentsPaginated();
}

String _$premiumTreatmentsPaginatedHash() =>
    r'61d4419bf8cd0f36fe72b0e36c6504b9d89e9796';

/// Accumulates the full Premium Treatments screen as pages are loaded.

abstract class _$PremiumTreatmentsPaginated
    extends $AsyncNotifier<PremiumTreatmentsAccumulated> {
  FutureOr<PremiumTreatmentsAccumulated> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PremiumTreatmentsAccumulated>,
              PremiumTreatmentsAccumulated
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PremiumTreatmentsAccumulated>,
                PremiumTreatmentsAccumulated
              >,
              AsyncValue<PremiumTreatmentsAccumulated>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Accumulates premium treatment cards directly on the Home screen.
///
/// This stays separate from the filter-aware full Premium Treatments screen.

@ProviderFor(HomePremiumTreatmentsPaginated)
const homePremiumTreatmentsPaginatedProvider =
    HomePremiumTreatmentsPaginatedProvider._();

/// Accumulates premium treatment cards directly on the Home screen.
///
/// This stays separate from the filter-aware full Premium Treatments screen.
final class HomePremiumTreatmentsPaginatedProvider
    extends
        $AsyncNotifierProvider<
          HomePremiumTreatmentsPaginated,
          PremiumTreatmentsAccumulated
        > {
  /// Accumulates premium treatment cards directly on the Home screen.
  ///
  /// This stays separate from the filter-aware full Premium Treatments screen.
  const HomePremiumTreatmentsPaginatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homePremiumTreatmentsPaginatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homePremiumTreatmentsPaginatedHash();

  @$internal
  @override
  HomePremiumTreatmentsPaginated create() => HomePremiumTreatmentsPaginated();
}

String _$homePremiumTreatmentsPaginatedHash() =>
    r'df3f18a3e97f5a8d7217050e2189d218ef9d87fa';

/// Accumulates premium treatment cards directly on the Home screen.
///
/// This stays separate from the filter-aware full Premium Treatments screen.

abstract class _$HomePremiumTreatmentsPaginated
    extends $AsyncNotifier<PremiumTreatmentsAccumulated> {
  FutureOr<PremiumTreatmentsAccumulated> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PremiumTreatmentsAccumulated>,
              PremiumTreatmentsAccumulated
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PremiumTreatmentsAccumulated>,
                PremiumTreatmentsAccumulated
              >,
              AsyncValue<PremiumTreatmentsAccumulated>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for the home preview of premium treatments.
///
/// The home dashboard should not inherit filters from the full
/// Premium Treatments list screen.

@ProviderFor(premiumTreatmentPreview)
const premiumTreatmentPreviewProvider = PremiumTreatmentPreviewProvider._();

/// Provider for the home preview of premium treatments.
///
/// The home dashboard should not inherit filters from the full
/// Premium Treatments list screen.

final class PremiumTreatmentPreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeProduct>>,
          List<HomeProduct>,
          FutureOr<List<HomeProduct>>
        >
    with
        $FutureModifier<List<HomeProduct>>,
        $FutureProvider<List<HomeProduct>> {
  /// Provider for the home preview of premium treatments.
  ///
  /// The home dashboard should not inherit filters from the full
  /// Premium Treatments list screen.
  const PremiumTreatmentPreviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'premiumTreatmentPreviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$premiumTreatmentPreviewHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeProduct>> create(Ref ref) {
    return premiumTreatmentPreview(ref);
  }
}

String _$premiumTreatmentPreviewHash() =>
    r'eccb3570f598ef3f1cda67f73f15ac0730a7b5ac';

/// Provider for fetching service tags.

@ProviderFor(serviceTags)
const serviceTagsProvider = ServiceTagsProvider._();

/// Provider for fetching service tags.

final class ServiceTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ServiceTag>>,
          List<ServiceTag>,
          FutureOr<List<ServiceTag>>
        >
    with $FutureModifier<List<ServiceTag>>, $FutureProvider<List<ServiceTag>> {
  /// Provider for fetching service tags.
  const ServiceTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceTagsHash();

  @$internal
  @override
  $FutureProviderElement<List<ServiceTag>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ServiceTag>> create(Ref ref) {
    return serviceTags(ref);
  }
}

String _$serviceTagsHash() => r'e50a3a3d971dbbf375c6738326558aaea065e7db';

/// Provider for fetching featured specialists.

@ProviderFor(featuredSpecialists)
const featuredSpecialistsProvider = FeaturedSpecialistsProvider._();

/// Provider for fetching featured specialists.

final class FeaturedSpecialistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeSpecialist>>,
          List<HomeSpecialist>,
          FutureOr<List<HomeSpecialist>>
        >
    with
        $FutureModifier<List<HomeSpecialist>>,
        $FutureProvider<List<HomeSpecialist>> {
  /// Provider for fetching featured specialists.
  const FeaturedSpecialistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredSpecialistsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredSpecialistsHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeSpecialist>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeSpecialist>> create(Ref ref) {
    return featuredSpecialists(ref);
  }
}

String _$featuredSpecialistsHash() =>
    r'eb47f7a9ea9f6ba9ad949354715b6d89f699fd5b';

/// Provider for fetching recent appointment activity
/// shown on the home dashboard.

@ProviderFor(recentActivity)
const recentActivityProvider = RecentActivityProvider._();

/// Provider for fetching recent appointment activity
/// shown on the home dashboard.

final class RecentActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentEntity>>,
          List<AppointmentEntity>,
          FutureOr<List<AppointmentEntity>>
        >
    with
        $FutureModifier<List<AppointmentEntity>>,
        $FutureProvider<List<AppointmentEntity>> {
  /// Provider for fetching recent appointment activity
  /// shown on the home dashboard.
  const RecentActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentActivityHash();

  @$internal
  @override
  $FutureProviderElement<List<AppointmentEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppointmentEntity>> create(Ref ref) {
    return recentActivity(ref);
  }
}

String _$recentActivityHash() => r'146baa436822fe074bfaa51a047da657d64224e4';

/// Provider for the full recent activity list.

@ProviderFor(allRecentActivity)
const allRecentActivityProvider = AllRecentActivityProvider._();

/// Provider for the full recent activity list.

final class AllRecentActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentEntity>>,
          List<AppointmentEntity>,
          FutureOr<List<AppointmentEntity>>
        >
    with
        $FutureModifier<List<AppointmentEntity>>,
        $FutureProvider<List<AppointmentEntity>> {
  /// Provider for the full recent activity list.
  const AllRecentActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allRecentActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allRecentActivityHash();

  @$internal
  @override
  $FutureProviderElement<List<AppointmentEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppointmentEntity>> create(Ref ref) {
    return allRecentActivity(ref);
  }
}

String _$allRecentActivityHash() => r'0ee0d2171d93667d00c6399b7f896a80af066f31';
