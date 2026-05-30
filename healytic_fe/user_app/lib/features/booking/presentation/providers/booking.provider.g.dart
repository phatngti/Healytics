// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches specialists for the given [categoryId].
///
/// Returns an empty list if no category is selected.

@ProviderFor(specialistsByCategory)
const specialistsByCategoryProvider = SpecialistsByCategoryFamily._();

/// Fetches specialists for the given [categoryId].
///
/// Returns an empty list if no category is selected.

final class SpecialistsByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingSpecialist>>,
          List<BookingSpecialist>,
          FutureOr<List<BookingSpecialist>>
        >
    with
        $FutureModifier<List<BookingSpecialist>>,
        $FutureProvider<List<BookingSpecialist>> {
  /// Fetches specialists for the given [categoryId].
  ///
  /// Returns an empty list if no category is selected.
  const SpecialistsByCategoryProvider._({
    required SpecialistsByCategoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'specialistsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$specialistsByCategoryHash();

  @override
  String toString() {
    return r'specialistsByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BookingSpecialist>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingSpecialist>> create(Ref ref) {
    final argument = this.argument as String;
    return specialistsByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpecialistsByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$specialistsByCategoryHash() =>
    r'372eabb6ca6c909794671ac26527c6f14f4e165c';

/// Fetches specialists for the given [categoryId].
///
/// Returns an empty list if no category is selected.

final class SpecialistsByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BookingSpecialist>>, String> {
  const SpecialistsByCategoryFamily._()
    : super(
        retry: null,
        name: r'specialistsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches specialists for the given [categoryId].
  ///
  /// Returns an empty list if no category is selected.

  SpecialistsByCategoryProvider call(String categoryId) =>
      SpecialistsByCategoryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'specialistsByCategoryProvider';
}

/// Fetches specialists assigned to the given
/// [serviceId].
///
/// Used when navigating from Service Details.

@ProviderFor(specialistsByService)
const specialistsByServiceProvider = SpecialistsByServiceFamily._();

/// Fetches specialists assigned to the given
/// [serviceId].
///
/// Used when navigating from Service Details.

final class SpecialistsByServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingSpecialist>>,
          List<BookingSpecialist>,
          FutureOr<List<BookingSpecialist>>
        >
    with
        $FutureModifier<List<BookingSpecialist>>,
        $FutureProvider<List<BookingSpecialist>> {
  /// Fetches specialists assigned to the given
  /// [serviceId].
  ///
  /// Used when navigating from Service Details.
  const SpecialistsByServiceProvider._({
    required SpecialistsByServiceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'specialistsByServiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$specialistsByServiceHash();

  @override
  String toString() {
    return r'specialistsByServiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BookingSpecialist>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingSpecialist>> create(Ref ref) {
    final argument = this.argument as String;
    return specialistsByService(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpecialistsByServiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$specialistsByServiceHash() =>
    r'569a8f4538e613b5460ff2f390ae3a57377baee2';

/// Fetches specialists assigned to the given
/// [serviceId].
///
/// Used when navigating from Service Details.

final class SpecialistsByServiceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BookingSpecialist>>, String> {
  const SpecialistsByServiceFamily._()
    : super(
        retry: null,
        name: r'specialistsByServiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches specialists assigned to the given
  /// [serviceId].
  ///
  /// Used when navigating from Service Details.

  SpecialistsByServiceProvider call(String serviceId) =>
      SpecialistsByServiceProvider._(argument: serviceId, from: this);

  @override
  String toString() => r'specialistsByServiceProvider';
}

/// Fetches services for the given [specialistId].
///
/// Returns an empty list if no specialist is selected.

@ProviderFor(servicesBySpecialist)
const servicesBySpecialistProvider = ServicesBySpecialistFamily._();

/// Fetches services for the given [specialistId].
///
/// Returns an empty list if no specialist is selected.

final class ServicesBySpecialistProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingService>>,
          List<BookingService>,
          FutureOr<List<BookingService>>
        >
    with
        $FutureModifier<List<BookingService>>,
        $FutureProvider<List<BookingService>> {
  /// Fetches services for the given [specialistId].
  ///
  /// Returns an empty list if no specialist is selected.
  const ServicesBySpecialistProvider._({
    required ServicesBySpecialistFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'servicesBySpecialistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$servicesBySpecialistHash();

  @override
  String toString() {
    return r'servicesBySpecialistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BookingService>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingService>> create(Ref ref) {
    final argument = this.argument as String;
    return servicesBySpecialist(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesBySpecialistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$servicesBySpecialistHash() =>
    r'dc5a2853174e81d31200e59183e679b4626d6a2b';

/// Fetches services for the given [specialistId].
///
/// Returns an empty list if no specialist is selected.

final class ServicesBySpecialistFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BookingService>>, String> {
  const ServicesBySpecialistFamily._()
    : super(
        retry: null,
        name: r'servicesBySpecialistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches services for the given [specialistId].
  ///
  /// Returns an empty list if no specialist is selected.

  ServicesBySpecialistProvider call(String specialistId) =>
      ServicesBySpecialistProvider._(argument: specialistId, from: this);

  @override
  String toString() => r'servicesBySpecialistProvider';
}

/// Fetches services for the given [categoryId].
///
/// Returns an empty list if no category is selected.

@ProviderFor(servicesByCategory)
const servicesByCategoryProvider = ServicesByCategoryFamily._();

/// Fetches services for the given [categoryId].
///
/// Returns an empty list if no category is selected.

final class ServicesByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingService>>,
          List<BookingService>,
          FutureOr<List<BookingService>>
        >
    with
        $FutureModifier<List<BookingService>>,
        $FutureProvider<List<BookingService>> {
  /// Fetches services for the given [categoryId].
  ///
  /// Returns an empty list if no category is selected.
  const ServicesByCategoryProvider._({
    required ServicesByCategoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'servicesByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$servicesByCategoryHash();

  @override
  String toString() {
    return r'servicesByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BookingService>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingService>> create(Ref ref) {
    final argument = this.argument as String;
    return servicesByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$servicesByCategoryHash() =>
    r'0b5075a9fbbdc8082c4e184c7dcdf253adba28f8';

/// Fetches services for the given [categoryId].
///
/// Returns an empty list if no category is selected.

final class ServicesByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BookingService>>, String> {
  const ServicesByCategoryFamily._()
    : super(
        retry: null,
        name: r'servicesByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches services for the given [categoryId].
  ///
  /// Returns an empty list if no category is selected.

  ServicesByCategoryProvider call(String categoryId) =>
      ServicesByCategoryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'servicesByCategoryProvider';
}

/// Searches services and specialists matching
/// [query] via the backend (Elasticsearch).

@ProviderFor(searchBooking)
const searchBookingProvider = SearchBookingFamily._();

/// Searches services and specialists matching
/// [query] via the backend (Elasticsearch).

final class SearchBookingProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookingSearchResult>,
          BookingSearchResult,
          FutureOr<BookingSearchResult>
        >
    with
        $FutureModifier<BookingSearchResult>,
        $FutureProvider<BookingSearchResult> {
  /// Searches services and specialists matching
  /// [query] via the backend (Elasticsearch).
  const SearchBookingProvider._({
    required SearchBookingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchBookingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchBookingHash();

  @override
  String toString() {
    return r'searchBookingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<BookingSearchResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BookingSearchResult> create(Ref ref) {
    final argument = this.argument as String;
    return searchBooking(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchBookingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchBookingHash() => r'cad4819588e1a59bd0fb7a67d602ec0bcbf8a45c';

/// Searches services and specialists matching
/// [query] via the backend (Elasticsearch).

final class SearchBookingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BookingSearchResult>, String> {
  const SearchBookingFamily._()
    : super(
        retry: null,
        name: r'searchBookingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Searches services and specialists matching
  /// [query] via the backend (Elasticsearch).

  SearchBookingProvider call(String query) =>
      SearchBookingProvider._(argument: query, from: this);

  @override
  String toString() => r'searchBookingProvider';
}

/// Fetches time-slot availability for [employeeId]
/// starting from [date] (YYYY-MM-DD).
///
/// Defaults to 7 days to match the [DatePickerRow]
/// visible range.

@ProviderFor(employeeTimeSlots)
const employeeTimeSlotsProvider = EmployeeTimeSlotsFamily._();

/// Fetches time-slot availability for [employeeId]
/// starting from [date] (YYYY-MM-DD).
///
/// Defaults to 7 days to match the [DatePickerRow]
/// visible range.

final class EmployeeTimeSlotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<EmployeeTimeSlotsEntity>,
          EmployeeTimeSlotsEntity,
          FutureOr<EmployeeTimeSlotsEntity>
        >
    with
        $FutureModifier<EmployeeTimeSlotsEntity>,
        $FutureProvider<EmployeeTimeSlotsEntity> {
  /// Fetches time-slot availability for [employeeId]
  /// starting from [date] (YYYY-MM-DD).
  ///
  /// Defaults to 7 days to match the [DatePickerRow]
  /// visible range.
  const EmployeeTimeSlotsProvider._({
    required EmployeeTimeSlotsFamily super.from,
    required (String, {String? date}) super.argument,
  }) : super(
         retry: null,
         name: r'employeeTimeSlotsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$employeeTimeSlotsHash();

  @override
  String toString() {
    return r'employeeTimeSlotsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<EmployeeTimeSlotsEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EmployeeTimeSlotsEntity> create(Ref ref) {
    final argument = this.argument as (String, {String? date});
    return employeeTimeSlots(ref, argument.$1, date: argument.date);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeTimeSlotsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$employeeTimeSlotsHash() => r'ef96a86ec08a697337117f485d439ae925223347';

/// Fetches time-slot availability for [employeeId]
/// starting from [date] (YYYY-MM-DD).
///
/// Defaults to 7 days to match the [DatePickerRow]
/// visible range.

final class EmployeeTimeSlotsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<EmployeeTimeSlotsEntity>,
          (String, {String? date})
        > {
  const EmployeeTimeSlotsFamily._()
    : super(
        retry: null,
        name: r'employeeTimeSlotsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches time-slot availability for [employeeId]
  /// starting from [date] (YYYY-MM-DD).
  ///
  /// Defaults to 7 days to match the [DatePickerRow]
  /// visible range.

  EmployeeTimeSlotsProvider call(String employeeId, {String? date}) =>
      EmployeeTimeSlotsProvider._(
        argument: (employeeId, date: date),
        from: this,
      );

  @override
  String toString() => r'employeeTimeSlotsProvider';
}
