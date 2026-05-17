// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_reviews.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches public reviews for a single employee.

@ProviderFor(employeeReviews)
const employeeReviewsProvider = EmployeeReviewsFamily._();

/// Fetches public reviews for a single employee.

final class EmployeeReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReviewEntity>>,
          List<ReviewEntity>,
          FutureOr<List<ReviewEntity>>
        >
    with
        $FutureModifier<List<ReviewEntity>>,
        $FutureProvider<List<ReviewEntity>> {
  /// Fetches public reviews for a single employee.
  const EmployeeReviewsProvider._({
    required EmployeeReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'employeeReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$employeeReviewsHash();

  @override
  String toString() {
    return r'employeeReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ReviewEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReviewEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return employeeReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$employeeReviewsHash() => r'eeae97b4725a73190e1f4ea9b8d8f98595fe70d7';

/// Fetches public reviews for a single employee.

final class EmployeeReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ReviewEntity>>, String> {
  const EmployeeReviewsFamily._()
    : super(
        retry: null,
        name: r'employeeReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches public reviews for a single employee.

  EmployeeReviewsProvider call(String employeeId) =>
      EmployeeReviewsProvider._(argument: employeeId, from: this);

  @override
  String toString() => r'employeeReviewsProvider';
}
