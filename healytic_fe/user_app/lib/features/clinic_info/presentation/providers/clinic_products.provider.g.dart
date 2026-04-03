// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_products.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches all products and categories for a clinic.
///
/// Family provider — each [clinicId] gets its own
/// cached async state with auto-dispose.

@ProviderFor(clinicProducts)
const clinicProductsProvider = ClinicProductsFamily._();

/// Fetches all products and categories for a clinic.
///
/// Family provider — each [clinicId] gets its own
/// cached async state with auto-dispose.

final class ClinicProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ClinicProductsData>,
          ClinicProductsData,
          FutureOr<ClinicProductsData>
        >
    with
        $FutureModifier<ClinicProductsData>,
        $FutureProvider<ClinicProductsData> {
  /// Fetches all products and categories for a clinic.
  ///
  /// Family provider — each [clinicId] gets its own
  /// cached async state with auto-dispose.
  const ClinicProductsProvider._({
    required ClinicProductsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clinicProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clinicProductsHash();

  @override
  String toString() {
    return r'clinicProductsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ClinicProductsData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ClinicProductsData> create(Ref ref) {
    final argument = this.argument as String;
    return clinicProducts(ref, clinicId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClinicProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clinicProductsHash() => r'959da1152db97b0abc15abeeeb6b1e65dc3a8cc4';

/// Fetches all products and categories for a clinic.
///
/// Family provider — each [clinicId] gets its own
/// cached async state with auto-dispose.

final class ClinicProductsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ClinicProductsData>, String> {
  const ClinicProductsFamily._()
    : super(
        retry: null,
        name: r'clinicProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches all products and categories for a clinic.
  ///
  /// Family provider — each [clinicId] gets its own
  /// cached async state with auto-dispose.

  ClinicProductsProvider call({required String clinicId}) =>
      ClinicProductsProvider._(argument: clinicId, from: this);

  @override
  String toString() => r'clinicProductsProvider';
}

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

/// Reactively combines raw product data with sort,
/// category, and search state to produce the final
/// list displayed in the grid.

@ProviderFor(filteredClinicProducts)
const filteredClinicProductsProvider = FilteredClinicProductsFamily._();

/// Reactively combines raw product data with sort,
/// category, and search state to produce the final
/// list displayed in the grid.

final class FilteredClinicProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClinicProductEntity>>,
          List<ClinicProductEntity>,
          FutureOr<List<ClinicProductEntity>>
        >
    with
        $FutureModifier<List<ClinicProductEntity>>,
        $FutureProvider<List<ClinicProductEntity>> {
  /// Reactively combines raw product data with sort,
  /// category, and search state to produce the final
  /// list displayed in the grid.
  const FilteredClinicProductsProvider._({
    required FilteredClinicProductsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'filteredClinicProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredClinicProductsHash();

  @override
  String toString() {
    return r'filteredClinicProductsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClinicProductEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClinicProductEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return filteredClinicProducts(ref, clinicId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredClinicProductsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredClinicProductsHash() =>
    r'6757bfef6d8e5289f07d14ea7c67ea24813965e8';

/// Reactively combines raw product data with sort,
/// category, and search state to produce the final
/// list displayed in the grid.

final class FilteredClinicProductsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<ClinicProductEntity>>, String> {
  const FilteredClinicProductsFamily._()
    : super(
        retry: null,
        name: r'filteredClinicProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Reactively combines raw product data with sort,
  /// category, and search state to produce the final
  /// list displayed in the grid.

  FilteredClinicProductsProvider call({required String clinicId}) =>
      FilteredClinicProductsProvider._(argument: clinicId, from: this);

  @override
  String toString() => r'filteredClinicProductsProvider';
}
