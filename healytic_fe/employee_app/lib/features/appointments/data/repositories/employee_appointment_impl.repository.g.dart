// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_appointment_impl.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(employeeAppointmentRepository)
const employeeAppointmentRepositoryProvider =
    EmployeeAppointmentRepositoryProvider._();

final class EmployeeAppointmentRepositoryProvider
    extends
        $FunctionalProvider<
          EmployeeAppointmentRepository,
          EmployeeAppointmentRepository,
          EmployeeAppointmentRepository
        >
    with $Provider<EmployeeAppointmentRepository> {
  const EmployeeAppointmentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeAppointmentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeAppointmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmployeeAppointmentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeAppointmentRepository create(Ref ref) {
    return employeeAppointmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeAppointmentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeAppointmentRepository>(
        value,
      ),
    );
  }
}

String _$employeeAppointmentRepositoryHash() =>
    r'12cd724d65f1f8ee89e07e093e497c2a4ec0043d';
