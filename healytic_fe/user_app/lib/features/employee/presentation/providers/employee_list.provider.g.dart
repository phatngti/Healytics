// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_list.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches all employees, optionally filtered
/// by [role] (e.g. "DOCTOR", "THERAPIST").

@ProviderFor(employeeList)
const employeeListProvider = EmployeeListFamily._();

/// Fetches all employees, optionally filtered
/// by [role] (e.g. "DOCTOR", "THERAPIST").

final class EmployeeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EmployeeDetailEntity>>,
          List<EmployeeDetailEntity>,
          FutureOr<List<EmployeeDetailEntity>>
        >
    with
        $FutureModifier<List<EmployeeDetailEntity>>,
        $FutureProvider<List<EmployeeDetailEntity>> {
  /// Fetches all employees, optionally filtered
  /// by [role] (e.g. "DOCTOR", "THERAPIST").
  const EmployeeListProvider._({
    required EmployeeListFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'employeeListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$employeeListHash();

  @override
  String toString() {
    return r'employeeListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EmployeeDetailEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EmployeeDetailEntity>> create(Ref ref) {
    final argument = this.argument as String?;
    return employeeList(ref, role: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$employeeListHash() => r'8492525681e8ff33a4fbc2c2b18951089be13ecd';

/// Fetches all employees, optionally filtered
/// by [role] (e.g. "DOCTOR", "THERAPIST").

final class EmployeeListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<EmployeeDetailEntity>>,
          String?
        > {
  const EmployeeListFamily._()
    : super(
        retry: null,
        name: r'employeeListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches all employees, optionally filtered
  /// by [role] (e.g. "DOCTOR", "THERAPIST").

  EmployeeListProvider call({String? role}) =>
      EmployeeListProvider._(argument: role, from: this);

  @override
  String toString() => r'employeeListProvider';
}
