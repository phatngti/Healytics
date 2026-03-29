// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_services.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches services offered by employee [id].
///
/// Reuses [BookingRemoteDatasource.getServicesBySpecialist]
/// which calls the `/user/employees/{id}/services` API.

@ProviderFor(employeeServices)
const employeeServicesProvider = EmployeeServicesFamily._();

/// Fetches services offered by employee [id].
///
/// Reuses [BookingRemoteDatasource.getServicesBySpecialist]
/// which calls the `/user/employees/{id}/services` API.

final class EmployeeServicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingService>>,
          List<BookingService>,
          FutureOr<List<BookingService>>
        >
    with
        $FutureModifier<List<BookingService>>,
        $FutureProvider<List<BookingService>> {
  /// Fetches services offered by employee [id].
  ///
  /// Reuses [BookingRemoteDatasource.getServicesBySpecialist]
  /// which calls the `/user/employees/{id}/services` API.
  const EmployeeServicesProvider._({
    required EmployeeServicesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'employeeServicesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$employeeServicesHash();

  @override
  String toString() {
    return r'employeeServicesProvider'
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
    return employeeServices(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeServicesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$employeeServicesHash() => r'089fca6b59c6eb4f79f272fe6eaf51b9c4c92359';

/// Fetches services offered by employee [id].
///
/// Reuses [BookingRemoteDatasource.getServicesBySpecialist]
/// which calls the `/user/employees/{id}/services` API.

final class EmployeeServicesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BookingService>>, String> {
  const EmployeeServicesFamily._()
    : super(
        retry: null,
        name: r'employeeServicesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches services offered by employee [id].
  ///
  /// Reuses [BookingRemoteDatasource.getServicesBySpecialist]
  /// which calls the `/user/employees/{id}/services` API.

  EmployeeServicesProvider call(String id) =>
      EmployeeServicesProvider._(argument: id, from: this);

  @override
  String toString() => r'employeeServicesProvider';
}
