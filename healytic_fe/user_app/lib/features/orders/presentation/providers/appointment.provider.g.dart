// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches appointments filtered by the current
/// tab (status) and category selection using
/// server-side filtering.

@ProviderFor(FilteredAppointmentsNotifier)
const filteredAppointmentsProvider = FilteredAppointmentsNotifierProvider._();

/// Fetches appointments filtered by the current
/// tab (status) and category selection using
/// server-side filtering.
final class FilteredAppointmentsNotifierProvider
    extends
        $AsyncNotifierProvider<FilteredAppointmentsNotifier, List<AppointmentEntity>> {
  /// Fetches appointments filtered by the current
  /// tab (status) and category selection using
  /// server-side filtering.
  const FilteredAppointmentsNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$filteredAppointmentsNotifierHash();

  @$internal
  @override
  FilteredAppointmentsNotifier create() => FilteredAppointmentsNotifier();
}

String _$filteredAppointmentsNotifierHash() =>
    r'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0';

/// Fetches appointments filtered by the current
/// tab (status) and category selection using
/// server-side filtering.

abstract class _$FilteredAppointmentsNotifier
    extends $AsyncNotifier<List<AppointmentEntity>> {
  FutureOr<List<AppointmentEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AppointmentEntity>>,
              List<AppointmentEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AppointmentEntity>>,
                List<AppointmentEntity>
              >,
              AsyncValue<List<AppointmentEntity>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

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
    r'c8cca837a03c63c21d59bb63555a72143906101f';

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
    r'c2c9839b2f7c9fa0552a87489de60697064b0767';

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

/// Holds the currently selected layout view mode.

@ProviderFor(SelectedViewLayoutNotifier)
const selectedViewLayoutProvider = SelectedViewLayoutNotifierProvider._();

/// Holds the currently selected layout view mode.
final class SelectedViewLayoutNotifierProvider
    extends
        $NotifierProvider<SelectedViewLayoutNotifier, AppointmentViewLayout> {
  /// Holds the currently selected layout view mode.
  const SelectedViewLayoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedViewLayoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedViewLayoutNotifierHash();

  @$internal
  @override
  SelectedViewLayoutNotifier create() => SelectedViewLayoutNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppointmentViewLayout value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppointmentViewLayout>(value),
    );
  }
}

String _$selectedViewLayoutNotifierHash() =>
    r'c71dbcea281f31b8610d5b443c8c4a2aee1c1dec';

/// Holds the currently selected layout view mode.

abstract class _$SelectedViewLayoutNotifier
    extends $Notifier<AppointmentViewLayout> {
  AppointmentViewLayout build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppointmentViewLayout, AppointmentViewLayout>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppointmentViewLayout, AppointmentViewLayout>,
              AppointmentViewLayout,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Legacy-compatible alias. Widgets that still
/// reference [appointmentsProvider] will get the
/// same filtered data.

@ProviderFor(appointments)
const appointmentsProvider = AppointmentsProvider._();

/// Legacy-compatible alias. Widgets that still
/// reference [appointmentsProvider] will get the
/// same filtered data.

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
  /// Legacy-compatible alias. Widgets that still
  /// reference [appointmentsProvider] will get the
  /// same filtered data.
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

String _$appointmentsHash() =>
    r'b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1';

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

/// Tracks the currently focused (visible) month
/// in calendar view. Updated on page swipe or
/// chevron tap.

@ProviderFor(CalendarFocusedDayNotifier)
const calendarFocusedDayProvider = CalendarFocusedDayNotifierProvider._();

/// Tracks the currently focused (visible) month
/// in calendar view. Updated on page swipe or
/// chevron tap.
final class CalendarFocusedDayNotifierProvider
    extends $NotifierProvider<CalendarFocusedDayNotifier, DateTime> {
  /// Tracks the currently focused (visible) month
  /// in calendar view. Updated on page swipe or
  /// chevron tap.
  const CalendarFocusedDayNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarFocusedDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarFocusedDayNotifierHash();

  @$internal
  @override
  CalendarFocusedDayNotifier create() => CalendarFocusedDayNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$calendarFocusedDayNotifierHash() =>
    r'efbd0cd87026fc8d2ea000ef5b712864fc839d5e';

/// Tracks the currently focused (visible) month
/// in calendar view. Updated on page swipe or
/// chevron tap.

abstract class _$CalendarFocusedDayNotifier extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Tracks the user-selected day in calendar view.
/// Defaults to today.

@ProviderFor(CalendarSelectedDayNotifier)
const calendarSelectedDayProvider = CalendarSelectedDayNotifierProvider._();

/// Tracks the user-selected day in calendar view.
/// Defaults to today.
final class CalendarSelectedDayNotifierProvider
    extends $NotifierProvider<CalendarSelectedDayNotifier, DateTime> {
  /// Tracks the user-selected day in calendar view.
  /// Defaults to today.
  const CalendarSelectedDayNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarSelectedDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarSelectedDayNotifierHash();

  @$internal
  @override
  CalendarSelectedDayNotifier create() => CalendarSelectedDayNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$calendarSelectedDayNotifierHash() =>
    r'e350a231f9711bec0e9dcb2667da7e50ee038644';

/// Tracks the user-selected day in calendar view.
/// Defaults to today.

abstract class _$CalendarSelectedDayNotifier extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Groups ALL appointments into a date-keyed map
/// for O(1) lookup by the calendar's [eventLoader].
///
/// Uses [DateUtils.dateOnly] to strip time
/// components for reliable map key matching.

@ProviderFor(appointmentsByDateMap)
const appointmentsByDateMapProvider = AppointmentsByDateMapProvider._();

/// Groups ALL appointments into a date-keyed map
/// for O(1) lookup by the calendar's [eventLoader].
///
/// Uses [DateUtils.dateOnly] to strip time
/// components for reliable map key matching.

final class AppointmentsByDateMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, List<AppointmentEntity>>>,
          Map<DateTime, List<AppointmentEntity>>,
          FutureOr<Map<DateTime, List<AppointmentEntity>>>
        >
    with
        $FutureModifier<Map<DateTime, List<AppointmentEntity>>>,
        $FutureProvider<Map<DateTime, List<AppointmentEntity>>> {
  /// Groups ALL appointments into a date-keyed map
  /// for O(1) lookup by the calendar's [eventLoader].
  ///
  /// Uses [DateUtils.dateOnly] to strip time
  /// components for reliable map key matching.
  const AppointmentsByDateMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentsByDateMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentsByDateMapHash();

  @$internal
  @override
  $FutureProviderElement<Map<DateTime, List<AppointmentEntity>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<DateTime, List<AppointmentEntity>>> create(Ref ref) {
    return appointmentsByDateMap(ref);
  }
}

String _$appointmentsByDateMapHash() =>
    r'f4201437458d172ed04c6b2acfa47be2bd2ee958';

/// Returns appointments for the currently selected
/// calendar day, derived from the date map +
/// selected day provider.

@ProviderFor(appointmentsForDay)
const appointmentsForDayProvider = AppointmentsForDayProvider._();

/// Returns appointments for the currently selected
/// calendar day, derived from the date map +
/// selected day provider.

final class AppointmentsForDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentEntity>>,
          List<AppointmentEntity>,
          FutureOr<List<AppointmentEntity>>
        >
    with
        $FutureModifier<List<AppointmentEntity>>,
        $FutureProvider<List<AppointmentEntity>> {
  /// Returns appointments for the currently selected
  /// calendar day, derived from the date map +
  /// selected day provider.
  const AppointmentsForDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentsForDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentsForDayHash();

  @$internal
  @override
  $FutureProviderElement<List<AppointmentEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppointmentEntity>> create(Ref ref) {
    return appointmentsForDay(ref);
  }
}

String _$appointmentsForDayHash() =>
    r'1d456516436955591a7c0e13b82d6e4b9b4082d4';
