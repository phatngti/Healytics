// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eligibility_detail.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches the eligibility detail for the
/// given [eligibilityId].
///
/// The [eligibilityId] is the surrogate PK from
/// the `product_employee_eligibility` table,
/// carried by [BookingSpecialist.eligibilityId].

@ProviderFor(eligibilityDetail)
const eligibilityDetailProvider = EligibilityDetailFamily._();

/// Fetches the eligibility detail for the
/// given [eligibilityId].
///
/// The [eligibilityId] is the surrogate PK from
/// the `product_employee_eligibility` table,
/// carried by [BookingSpecialist.eligibilityId].

final class EligibilityDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<EligibilityDetailEntity>,
          EligibilityDetailEntity,
          FutureOr<EligibilityDetailEntity>
        >
    with
        $FutureModifier<EligibilityDetailEntity>,
        $FutureProvider<EligibilityDetailEntity> {
  /// Fetches the eligibility detail for the
  /// given [eligibilityId].
  ///
  /// The [eligibilityId] is the surrogate PK from
  /// the `product_employee_eligibility` table,
  /// carried by [BookingSpecialist.eligibilityId].
  const EligibilityDetailProvider._({
    required EligibilityDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eligibilityDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eligibilityDetailHash();

  @override
  String toString() {
    return r'eligibilityDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EligibilityDetailEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EligibilityDetailEntity> create(Ref ref) {
    final argument = this.argument as String;
    return eligibilityDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EligibilityDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eligibilityDetailHash() => r'e1192c21a07643d7878d96d7499e26e81e22637c';

/// Fetches the eligibility detail for the
/// given [eligibilityId].
///
/// The [eligibilityId] is the surrogate PK from
/// the `product_employee_eligibility` table,
/// carried by [BookingSpecialist.eligibilityId].

final class EligibilityDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EligibilityDetailEntity>, String> {
  const EligibilityDetailFamily._()
    : super(
        retry: null,
        name: r'eligibilityDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches the eligibility detail for the
  /// given [eligibilityId].
  ///
  /// The [eligibilityId] is the surrogate PK from
  /// the `product_employee_eligibility` table,
  /// carried by [BookingSpecialist.eligibilityId].

  EligibilityDetailProvider call(String eligibilityId) =>
      EligibilityDetailProvider._(argument: eligibilityId, from: this);

  @override
  String toString() => r'eligibilityDetailProvider';
}
