// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_products.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks the active sort option for the product
/// grid. Defaults to [ClinicProductSort.popular].

@ProviderFor(ClinicProductSortNotifier)
const clinicProductSortProvider = ClinicProductSortNotifierProvider._();

/// Tracks the active sort option for the product
/// grid. Defaults to [ClinicProductSort.popular].
final class ClinicProductSortNotifierProvider
    extends $NotifierProvider<ClinicProductSortNotifier, ClinicProductSort> {
  /// Tracks the active sort option for the product
  /// grid. Defaults to [ClinicProductSort.popular].
  const ClinicProductSortNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clinicProductSortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clinicProductSortNotifierHash();

  @$internal
  @override
  ClinicProductSortNotifier create() => ClinicProductSortNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClinicProductSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClinicProductSort>(value),
    );
  }
}

String _$clinicProductSortNotifierHash() =>
    r'4ff67ca7fbf36aea9e5b91cc7855f1e34cbb86ee';

/// Tracks the active sort option for the product
/// grid. Defaults to [ClinicProductSort.popular].

abstract class _$ClinicProductSortNotifier
    extends $Notifier<ClinicProductSort> {
  ClinicProductSort build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ClinicProductSort, ClinicProductSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClinicProductSort, ClinicProductSort>,
              ClinicProductSort,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Tracks the selected category chip ID.
/// Defaults to `'all'` (show everything).

@ProviderFor(ClinicProductCategoryNotifier)
const clinicProductCategoryProvider = ClinicProductCategoryNotifierProvider._();

/// Tracks the selected category chip ID.
/// Defaults to `'all'` (show everything).
final class ClinicProductCategoryNotifierProvider
    extends $NotifierProvider<ClinicProductCategoryNotifier, String> {
  /// Tracks the selected category chip ID.
  /// Defaults to `'all'` (show everything).
  const ClinicProductCategoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clinicProductCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clinicProductCategoryNotifierHash();

  @$internal
  @override
  ClinicProductCategoryNotifier create() => ClinicProductCategoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$clinicProductCategoryNotifierHash() =>
    r'b3c595a28fc154fe590445d2b803764d7c1e6f34';

/// Tracks the selected category chip ID.
/// Defaults to `'all'` (show everything).

abstract class _$ClinicProductCategoryNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Tracks the search query for title-based filtering.
/// Defaults to an empty string (no search).

@ProviderFor(ClinicProductSearchNotifier)
const clinicProductSearchProvider = ClinicProductSearchNotifierProvider._();

/// Tracks the search query for title-based filtering.
/// Defaults to an empty string (no search).
final class ClinicProductSearchNotifierProvider
    extends $NotifierProvider<ClinicProductSearchNotifier, String> {
  /// Tracks the search query for title-based filtering.
  /// Defaults to an empty string (no search).
  const ClinicProductSearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clinicProductSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clinicProductSearchNotifierHash();

  @$internal
  @override
  ClinicProductSearchNotifier create() => ClinicProductSearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$clinicProductSearchNotifierHash() =>
    r'92e582fb940f9f1c57d34d735afc4c327157e2e6';

/// Tracks the search query for title-based filtering.
/// Defaults to an empty string (no search).

abstract class _$ClinicProductSearchNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Manages server-side paginated product loading.
///
/// Watches sort, category, and search state.
/// When any of them change, fetches fresh data
/// from page 1. Supports "load more" pagination.

@ProviderFor(ClinicProductsPaginated)
const clinicProductsPaginatedProvider = ClinicProductsPaginatedFamily._();

/// Manages server-side paginated product loading.
///
/// Watches sort, category, and search state.
/// When any of them change, fetches fresh data
/// from page 1. Supports "load more" pagination.
final class ClinicProductsPaginatedProvider
    extends
        $AsyncNotifierProvider<
          ClinicProductsPaginated,
          ClinicProductsAccumulated
        > {
  /// Manages server-side paginated product loading.
  ///
  /// Watches sort, category, and search state.
  /// When any of them change, fetches fresh data
  /// from page 1. Supports "load more" pagination.
  const ClinicProductsPaginatedProvider._({
    required ClinicProductsPaginatedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clinicProductsPaginatedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clinicProductsPaginatedHash();

  @override
  String toString() {
    return r'clinicProductsPaginatedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClinicProductsPaginated create() => ClinicProductsPaginated();

  @override
  bool operator ==(Object other) {
    return other is ClinicProductsPaginatedProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clinicProductsPaginatedHash() =>
    r'19c56b1673fb310d83fc746b3368bd46823a8fcc';

/// Manages server-side paginated product loading.
///
/// Watches sort, category, and search state.
/// When any of them change, fetches fresh data
/// from page 1. Supports "load more" pagination.

final class ClinicProductsPaginatedFamily extends $Family
    with
        $ClassFamilyOverride<
          ClinicProductsPaginated,
          AsyncValue<ClinicProductsAccumulated>,
          ClinicProductsAccumulated,
          FutureOr<ClinicProductsAccumulated>,
          String
        > {
  const ClinicProductsPaginatedFamily._()
    : super(
        retry: null,
        name: r'clinicProductsPaginatedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Manages server-side paginated product loading.
  ///
  /// Watches sort, category, and search state.
  /// When any of them change, fetches fresh data
  /// from page 1. Supports "load more" pagination.

  ClinicProductsPaginatedProvider call({required String clinicId}) =>
      ClinicProductsPaginatedProvider._(argument: clinicId, from: this);

  @override
  String toString() => r'clinicProductsPaginatedProvider';
}

/// Manages server-side paginated product loading.
///
/// Watches sort, category, and search state.
/// When any of them change, fetches fresh data
/// from page 1. Supports "load more" pagination.

abstract class _$ClinicProductsPaginated
    extends $AsyncNotifier<ClinicProductsAccumulated> {
  late final _$args = ref.$arg as String;
  String get clinicId => _$args;

  FutureOr<ClinicProductsAccumulated> build({required String clinicId});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(clinicId: _$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ClinicProductsAccumulated>,
              ClinicProductsAccumulated
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ClinicProductsAccumulated>,
                ClinicProductsAccumulated
              >,
              AsyncValue<ClinicProductsAccumulated>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
