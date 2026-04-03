// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_details.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches core service info by [serviceId].
///
/// Uses a family parameter so each service ID gets
/// its own cached async state.

@ProviderFor(serviceDetails)
const serviceDetailsProvider = ServiceDetailsFamily._();

/// Fetches core service info by [serviceId].
///
/// Uses a family parameter so each service ID gets
/// its own cached async state.

final class ServiceDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceDetailsEntity>,
          ServiceDetailsEntity,
          FutureOr<ServiceDetailsEntity>
        >
    with
        $FutureModifier<ServiceDetailsEntity>,
        $FutureProvider<ServiceDetailsEntity> {
  /// Fetches core service info by [serviceId].
  ///
  /// Uses a family parameter so each service ID gets
  /// its own cached async state.
  const ServiceDetailsProvider._({
    required ServiceDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceDetailsHash();

  @override
  String toString() {
    return r'serviceDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ServiceDetailsEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceDetailsEntity> create(Ref ref) {
    final argument = this.argument as String;
    return serviceDetails(ref, serviceId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceDetailsHash() => r'ac5ddaa1104d7a6c4956bc1b3556a696f426ec26';

/// Fetches core service info by [serviceId].
///
/// Uses a family parameter so each service ID gets
/// its own cached async state.

final class ServiceDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ServiceDetailsEntity>, String> {
  const ServiceDetailsFamily._()
    : super(
        retry: null,
        name: r'serviceDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches core service info by [serviceId].
  ///
  /// Uses a family parameter so each service ID gets
  /// its own cached async state.

  ServiceDetailsProvider call({required String serviceId}) =>
      ServiceDetailsProvider._(argument: serviceId, from: this);

  @override
  String toString() => r'serviceDetailsProvider';
}

/// Fetches employees (specialists) assigned to a
/// service.

@ProviderFor(serviceEmployees)
const serviceEmployeesProvider = ServiceEmployeesFamily._();

/// Fetches employees (specialists) assigned to a
/// service.

final class ServiceEmployeesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SpecialistEntity>>,
          List<SpecialistEntity>,
          FutureOr<List<SpecialistEntity>>
        >
    with
        $FutureModifier<List<SpecialistEntity>>,
        $FutureProvider<List<SpecialistEntity>> {
  /// Fetches employees (specialists) assigned to a
  /// service.
  const ServiceEmployeesProvider._({
    required ServiceEmployeesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceEmployeesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceEmployeesHash();

  @override
  String toString() {
    return r'serviceEmployeesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SpecialistEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SpecialistEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return serviceEmployees(ref, serviceId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceEmployeesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceEmployeesHash() => r'2c525260175ecf47ecbd0368b78db6d1aaccab50';

/// Fetches employees (specialists) assigned to a
/// service.

final class ServiceEmployeesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SpecialistEntity>>, String> {
  const ServiceEmployeesFamily._()
    : super(
        retry: null,
        name: r'serviceEmployeesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches employees (specialists) assigned to a
  /// service.

  ServiceEmployeesProvider call({required String serviceId}) =>
      ServiceEmployeesProvider._(argument: serviceId, from: this);

  @override
  String toString() => r'serviceEmployeesProvider';
}

/// Fetches user reviews for a service.

@ProviderFor(serviceReviews)
const serviceReviewsProvider = ServiceReviewsFamily._();

/// Fetches user reviews for a service.

final class ServiceReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReviewEntity>>,
          List<ReviewEntity>,
          FutureOr<List<ReviewEntity>>
        >
    with
        $FutureModifier<List<ReviewEntity>>,
        $FutureProvider<List<ReviewEntity>> {
  /// Fetches user reviews for a service.
  const ServiceReviewsProvider._({
    required ServiceReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceReviewsHash();

  @override
  String toString() {
    return r'serviceReviewsProvider'
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
    return serviceReviews(ref, serviceId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceReviewsHash() => r'c9a3a47037cc7024d84d9d85d15490ad747a75a8';

/// Fetches user reviews for a service.

final class ServiceReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ReviewEntity>>, String> {
  const ServiceReviewsFamily._()
    : super(
        retry: null,
        name: r'serviceReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches user reviews for a service.

  ServiceReviewsProvider call({required String serviceId}) =>
      ServiceReviewsProvider._(argument: serviceId, from: this);

  @override
  String toString() => r'serviceReviewsProvider';
}

/// Fetches reviews for a specific employee.

@ProviderFor(employeeReviews)
const employeeReviewsProvider = EmployeeReviewsFamily._();

/// Fetches reviews for a specific employee.

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
  /// Fetches reviews for a specific employee.
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
    return employeeReviews(ref, employeeId: argument);
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

String _$employeeReviewsHash() => r'4a30606901e92d68367da5a33257901fc53df9cd';

/// Fetches reviews for a specific employee.

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

  /// Fetches reviews for a specific employee.

  EmployeeReviewsProvider call({required String employeeId}) =>
      EmployeeReviewsProvider._(argument: employeeId, from: this);

  @override
  String toString() => r'employeeReviewsProvider';
}

/// Fetches recommended services for a given
/// [serviceId].

@ProviderFor(recommendedServices)
const recommendedServicesProvider = RecommendedServicesFamily._();

/// Fetches recommended services for a given
/// [serviceId].

final class RecommendedServicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecommendedServiceEntity>>,
          List<RecommendedServiceEntity>,
          FutureOr<List<RecommendedServiceEntity>>
        >
    with
        $FutureModifier<List<RecommendedServiceEntity>>,
        $FutureProvider<List<RecommendedServiceEntity>> {
  /// Fetches recommended services for a given
  /// [serviceId].
  const RecommendedServicesProvider._({
    required RecommendedServicesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recommendedServicesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recommendedServicesHash();

  @override
  String toString() {
    return r'recommendedServicesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RecommendedServiceEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecommendedServiceEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return recommendedServices(ref, serviceId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecommendedServicesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recommendedServicesHash() =>
    r'0209e7bb87e4b7871c07762f65add638ed7c6725';

/// Fetches recommended services for a given
/// [serviceId].

final class RecommendedServicesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<RecommendedServiceEntity>>,
          String
        > {
  const RecommendedServicesFamily._()
    : super(
        retry: null,
        name: r'recommendedServicesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches recommended services for a given
  /// [serviceId].

  RecommendedServicesProvider call({required String serviceId}) =>
      RecommendedServicesProvider._(argument: serviceId, from: this);

  @override
  String toString() => r'recommendedServicesProvider';
}
