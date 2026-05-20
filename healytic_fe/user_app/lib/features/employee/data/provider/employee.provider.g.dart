// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [EmployeeRepository] implementation
/// wired to the active remote datasource.

@ProviderFor(employeeRepository)
const employeeRepositoryProvider = EmployeeRepositoryProvider._();

/// Provides the [EmployeeRepository] implementation
/// wired to the active remote datasource.

final class EmployeeRepositoryProvider
    extends
        $FunctionalProvider<
          EmployeeRepository,
          EmployeeRepository,
          EmployeeRepository
        >
    with $Provider<EmployeeRepository> {
  /// Provides the [EmployeeRepository] implementation
  /// wired to the active remote datasource.
  const EmployeeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmployeeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeRepository create(Ref ref) {
    return employeeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeRepository>(value),
    );
  }
}

String _$employeeRepositoryHash() =>
    r'7599711e9d12e9b40e126154e55259f2e0bf350a';
