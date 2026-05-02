// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_appointment_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(employeeAppointmentRemoteDatasource)
const employeeAppointmentRemoteDatasourceProvider =
    EmployeeAppointmentRemoteDatasourceProvider._();

final class EmployeeAppointmentRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          EmployeeAppointmentRemoteDatasource,
          EmployeeAppointmentRemoteDatasource,
          EmployeeAppointmentRemoteDatasource
        >
    with $Provider<EmployeeAppointmentRemoteDatasource> {
  const EmployeeAppointmentRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeAppointmentRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$employeeAppointmentRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<EmployeeAppointmentRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeAppointmentRemoteDatasource create(Ref ref) {
    return employeeAppointmentRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeAppointmentRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeAppointmentRemoteDatasource>(
        value,
      ),
    );
  }
}

String _$employeeAppointmentRemoteDatasourceHash() =>
    r'9c7f129ea9ccac3cf7289ee98c034fcaf1a7703d';
