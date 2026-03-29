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

/// Provider for fetching home-recommend products.

@ProviderFor(recommendedProducts)
const recommendedProductsProvider = RecommendedProductsProvider._();

/// Provider for fetching home-recommend products.

final class RecommendedProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeProduct>>,
          List<HomeProduct>,
          FutureOr<List<HomeProduct>>
        >
    with
        $FutureModifier<List<HomeProduct>>,
        $FutureProvider<List<HomeProduct>> {
  /// Provider for fetching home-recommend products.
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
  $FutureProviderElement<List<HomeProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeProduct>> create(Ref ref) {
    return recommendedProducts(ref);
  }
}

String _$recommendedProductsHash() =>
    r'f216d32cb730fe3b9512239c6406e8f2f9e3efe1';

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

String _$premiumTreatmentsHash() => r'78722723dd21212290a60a3de021ddbeb0de8190';

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

/// Provider for fetching AI-powered service
/// recommendations based on a list of service IDs.

@ProviderFor(aiRecommendations)
const aiRecommendationsProvider = AiRecommendationsFamily._();

/// Provider for fetching AI-powered service
/// recommendations based on a list of service IDs.

final class AiRecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AiRecommendation>>,
          List<AiRecommendation>,
          FutureOr<List<AiRecommendation>>
        >
    with
        $FutureModifier<List<AiRecommendation>>,
        $FutureProvider<List<AiRecommendation>> {
  /// Provider for fetching AI-powered service
  /// recommendations based on a list of service IDs.
  const AiRecommendationsProvider._({
    required AiRecommendationsFamily super.from,
    required List<String> super.argument,
  }) : super(
         retry: null,
         name: r'aiRecommendationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiRecommendationsHash();

  @override
  String toString() {
    return r'aiRecommendationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AiRecommendation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AiRecommendation>> create(Ref ref) {
    final argument = this.argument as List<String>;
    return aiRecommendations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AiRecommendationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiRecommendationsHash() => r'6785c90ae51df4bdf14fd2dacb56864fa5f47717';

/// Provider for fetching AI-powered service
/// recommendations based on a list of service IDs.

final class AiRecommendationsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AiRecommendation>>,
          List<String>
        > {
  const AiRecommendationsFamily._()
    : super(
        retry: null,
        name: r'aiRecommendationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for fetching AI-powered service
  /// recommendations based on a list of service IDs.

  AiRecommendationsProvider call(List<String> serviceIds) =>
      AiRecommendationsProvider._(argument: serviceIds, from: this);

  @override
  String toString() => r'aiRecommendationsProvider';
}

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
