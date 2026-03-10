// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches all appointments from the repository.

@ProviderFor(appointments)
const appointmentsProvider = AppointmentsProvider._();

/// Fetches all appointments from the repository.

final class AppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentEntity>>,
          List<AppointmentEntity>,
          FutureOr<List<AppointmentEntity>>
        >
    with
        $FutureModifier<List<AppointmentEntity>>,
        $FutureProvider<List<AppointmentEntity>> {
  /// Fetches all appointments from the repository.
  const AppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<AppointmentEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppointmentEntity>> create(Ref ref) {
    return appointments(ref);
  }
}

String _$appointmentsHash() => r'0b8ce0e4372e9bfc369d17d816d0c205747fd521';

/// Fetches appointment category filters.

@ProviderFor(appointmentCategories)
const appointmentCategoriesProvider = AppointmentCategoriesProvider._();

/// Fetches appointment category filters.

final class AppointmentCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentCategory>>,
          List<AppointmentCategory>,
          FutureOr<List<AppointmentCategory>>
        >
    with
        $FutureModifier<List<AppointmentCategory>>,
        $FutureProvider<List<AppointmentCategory>> {
  /// Fetches appointment category filters.
  const AppointmentCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<AppointmentCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppointmentCategory>> create(Ref ref) {
    return appointmentCategories(ref);
  }
}

String _$appointmentCategoriesHash() =>
    r'9fd36a8b04929801e6969fe6246e578b692b8084';

/// Fetches recommended services.

@ProviderFor(appointmentRecommendations)
const appointmentRecommendationsProvider =
    AppointmentRecommendationsProvider._();

/// Fetches recommended services.

final class AppointmentRecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecommendedServiceEntity>>,
          List<RecommendedServiceEntity>,
          FutureOr<List<RecommendedServiceEntity>>
        >
    with
        $FutureModifier<List<RecommendedServiceEntity>>,
        $FutureProvider<List<RecommendedServiceEntity>> {
  /// Fetches recommended services.
  const AppointmentRecommendationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentRecommendationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentRecommendationsHash();

  @$internal
  @override
  $FutureProviderElement<List<RecommendedServiceEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecommendedServiceEntity>> create(Ref ref) {
    return appointmentRecommendations(ref);
  }
}

String _$appointmentRecommendationsHash() =>
    r'ff5a4f8c9cc865a38e9af39442fef3eee16a4530';

/// Holds the currently selected tab index.

@ProviderFor(SelectedTabNotifier)
const selectedTabProvider = SelectedTabNotifierProvider._();

/// Holds the currently selected tab index.
final class SelectedTabNotifierProvider
    extends $NotifierProvider<SelectedTabNotifier, int> {
  /// Holds the currently selected tab index.
  const SelectedTabNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTabNotifierHash();

  @$internal
  @override
  SelectedTabNotifier create() => SelectedTabNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedTabNotifierHash() =>
    r'29efbf13315f9665c3903593a2e7f39f695efe88';

/// Holds the currently selected tab index.

abstract class _$SelectedTabNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Holds the currently selected category id.

@ProviderFor(SelectedCategoryNotifier)
const selectedCategoryProvider = SelectedCategoryNotifierProvider._();

/// Holds the currently selected category id.
final class SelectedCategoryNotifierProvider
    extends $NotifierProvider<SelectedCategoryNotifier, String> {
  /// Holds the currently selected category id.
  const SelectedCategoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryNotifierHash();

  @$internal
  @override
  SelectedCategoryNotifier create() => SelectedCategoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedCategoryNotifierHash() =>
    r'95fc68f87edbc4965bbf8192d8f7bddc81f70b8e';

/// Holds the currently selected category id.

abstract class _$SelectedCategoryNotifier extends $Notifier<String> {
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

/// Derived provider that filters appointments by
/// the current tab and category selection.

@ProviderFor(filteredAppointments)
const filteredAppointmentsProvider = FilteredAppointmentsProvider._();

/// Derived provider that filters appointments by
/// the current tab and category selection.

final class FilteredAppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentEntity>>,
          List<AppointmentEntity>,
          FutureOr<List<AppointmentEntity>>
        >
    with
        $FutureModifier<List<AppointmentEntity>>,
        $FutureProvider<List<AppointmentEntity>> {
  /// Derived provider that filters appointments by
  /// the current tab and category selection.
  const FilteredAppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredAppointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredAppointmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<AppointmentEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppointmentEntity>> create(Ref ref) {
    return filteredAppointments(ref);
  }
}

String _$filteredAppointmentsHash() =>
    r'e37e0ced52d98c7109652ad3e902028aafdf8eec';

/// Fetches a single appointment by its [id].

@ProviderFor(appointmentById)
const appointmentByIdProvider = AppointmentByIdFamily._();

/// Fetches a single appointment by its [id].

final class AppointmentByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppointmentEntity?>,
          AppointmentEntity?,
          FutureOr<AppointmentEntity?>
        >
    with
        $FutureModifier<AppointmentEntity?>,
        $FutureProvider<AppointmentEntity?> {
  /// Fetches a single appointment by its [id].
  const AppointmentByIdProvider._({
    required AppointmentByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'appointmentByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appointmentByIdHash();

  @override
  String toString() {
    return r'appointmentByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AppointmentEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppointmentEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return appointmentById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appointmentByIdHash() => r'49f23200751e582bfe0b50dec3af583a789cbc26';

/// Fetches a single appointment by its [id].

final class AppointmentByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AppointmentEntity?>, String> {
  const AppointmentByIdFamily._()
    : super(
        retry: null,
        name: r'appointmentByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single appointment by its [id].

  AppointmentByIdProvider call(String id) =>
      AppointmentByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'appointmentByIdProvider';
}
