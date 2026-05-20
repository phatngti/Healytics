// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_detail.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches a single employee detail by [id].

@ProviderFor(employeeDetail)
const employeeDetailProvider = EmployeeDetailFamily._();

/// Fetches a single employee detail by [id].

final class EmployeeDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<EmployeeDetailEntity>,
          EmployeeDetailEntity,
          FutureOr<EmployeeDetailEntity>
        >
    with
        $FutureModifier<EmployeeDetailEntity>,
        $FutureProvider<EmployeeDetailEntity> {
  /// Fetches a single employee detail by [id].
  const EmployeeDetailProvider._({
    required EmployeeDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'employeeDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$employeeDetailHash();

  @override
  String toString() {
    return r'employeeDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EmployeeDetailEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EmployeeDetailEntity> create(Ref ref) {
    final argument = this.argument as String;
    return employeeDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$employeeDetailHash() => r'90774441b9bf01c2a2bbc65baa3622d4638a720f';

/// Fetches a single employee detail by [id].

final class EmployeeDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EmployeeDetailEntity>, String> {
  const EmployeeDetailFamily._()
    : super(
        retry: null,
        name: r'employeeDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single employee detail by [id].

  EmployeeDetailProvider call(String id) =>
      EmployeeDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'employeeDetailProvider';
}
