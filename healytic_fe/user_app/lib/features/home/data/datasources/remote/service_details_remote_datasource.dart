import 'package:logging/logging.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';
import 'package:user_openapi/api.dart';

import 'service_details_mock_data.dart';

/// Contract for fetching service detail data from
/// a remote source.
///
/// Each method corresponds to a separate API endpoint.
abstract class ServiceDetailsRemoteDatasource {
  /// `GET /products/:id/info` — core service info.
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId);

  /// `GET /products/:id/employees` — specialists
  /// assigned to this service, with schedules.
  Future<List<SpecialistEntity>> getServiceEmployees(String serviceId);

  /// `GET /products/:id/reviews` — user reviews.
  Future<List<ReviewEntity>> getServiceReviews(String serviceId);

  /// `GET /employees/:id/reviews` — reviews for a
  /// specific employee.
  Future<List<ReviewEntity>> getEmployeeReviews(
    String employeeId,
  );

  /// `GET /products/:id/recommended` — related
  /// service cards.
  Future<List<RecommendedServiceEntity>> getRecommendedServices(
    String serviceId,
  );
}

// ─────────────────────────────────────────────────────
// Real implementation
// ─────────────────────────────────────────────────────

/// Calls the backend [HealthServicesApi] and maps
/// DTOs to domain entities.
class ServiceDetailsRemoteDatasourceImpl
    implements ServiceDetailsRemoteDatasource {
  static final _log =
      Logger('ServiceDetailsDatasource');

  const ServiceDetailsRemoteDatasourceImpl(this._apiService);

  final ApiService _apiService;

  // ── Service Info ──────────────────────────────────

  @override
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId) async {
    final response = await _apiService.userHealthServicesApi
        .userHealthServiceControllerGetProductInfo(serviceId);
    if (response == null) {
      throw Exception('Product info not found: $serviceId');
    }

    return _mapInfoToEntity(response);
  }

  ServiceDetailsEntity _mapInfoToEntity(
    PublicHealthServiceInfoResponseDto dto,
  ) {
    return ServiceDetailsEntity(
      id: dto.id,
      title: dto.title,
      categoryId: dto.category.id,
      categoryLabel: dto.category.name,
      images: dto.images,
      rating: dto.rating.toDouble(),
      reviewCount: dto.reviewCount.toInt(),
      price: dto.price,
      isVerified: dto.isVerified,
      description: dto.description?.toString() ?? '',
      featureTags: dto.featureTags
          .map((t) => FeatureTagEntity(iconName: t.iconName, label: t.label))
          .toList(),
      clinic: ClinicEntity(name: dto.clinic.name, address: dto.clinic.address),
      facilityImages: dto.facilityImages
          .map((f) => FacilityImageEntity(imageUrl: f.imageUrl, label: f.label))
          .toList(),
    );
  }

  // ── Employees ─────────────────────────────────────

  @override
  Future<List<SpecialistEntity>> getServiceEmployees(String serviceId) async {
    try {
      _log.fine('Calling employees API...');
      final response = await _apiService.userHealthServicesApi
          .userHealthServiceControllerGetProductEmployees(
            serviceId,
          );

      _log.fine('API returned. Is null? ${response == null}');
      if (response == null) return [];

      _log.fine('Response data: $response');
      return response.map(_mapEmployeeToEntity).toList();
    } catch (e, stackTrace) {
      _log.severe('Error during API call or parsing', e, stackTrace);
      rethrow;
    }
  }

  SpecialistEntity _mapEmployeeToEntity(
    PublicHealthServiceEmployeeResponseDto dto,
  ) {
    return SpecialistEntity(
      id: dto.id,
      name: dto.name,
      role: dto.role,
      imageUrl: dto.imageUrl?.toString() ?? '',
      isSelected: dto.isSelected,
      quote: dto.quote?.toString(),
      degrees: dto.degrees?.toString(),
      languages: dto.languages?.toString(),
      experience: dto.experience?.toString(),
      specializations: dto.specializations,
      bio: dto.bio?.toString(),
      daySchedules: dto.daySchedules.map(_mapDaySchedule).toList(),
    );
  }

  DayScheduleEntity _mapDaySchedule(
    PublicHealthServiceEmployeeDayScheduleDto dto,
  ) {
    return DayScheduleEntity(
      date: DateTime.tryParse(dto.date) ?? DateTime.now(),
      isAvailable: dto.isAvailable,
      timeSlots: dto.timeSlots
          .map(
            (s) => TimeSlotEntity(label: s.label, isAvailable: s.isAvailable),
          )
          .toList(),
    );
  }

  // ── Reviews ───────────────────────────────────────

  @override
  Future<List<ReviewEntity>> getServiceReviews(String serviceId) async {
    final dtos = await _apiService.userHealthServicesApi
        .userHealthServiceControllerGetProductReviews(
          serviceId,
        );
    if (dtos == null) return [];
    return dtos.map(_mapReviewToEntity).toList();
  }

  ReviewEntity _mapReviewToEntity(
    PublicHealthServiceReviewResponseDto dto,
  ) {
    return ReviewEntity(
      reviewerName: dto.reviewerName,
      avatarUrl: dto.avatarUrl?.toString() ?? '',
      rating: dto.rating.toInt(),
      status: dto.status,
      date: DateTime.tryParse(dto.date) ?? DateTime.now(),
      text: dto.text,
      imageUrls: dto.imageUrls,
    );
  }

  // ── Employee Reviews ──────────────────────────────

  @override
  Future<List<ReviewEntity>> getEmployeeReviews(
    String employeeId,
  ) async {
    // TODO: call actual backend endpoint once
    //       available.
    return [];
  }

  // ── Recommended ───────────────────────────────────

  @override
  Future<List<RecommendedServiceEntity>> getRecommendedServices(
    String serviceId,
  ) async {
    final dtos = await _apiService.userHealthServicesApi
        .userHealthServiceControllerGetRecommendedProducts(
          serviceId,
        );
    if (dtos == null) return [];
    return dtos.map(_mapRecommendedToEntity).toList();
  }

  RecommendedServiceEntity _mapRecommendedToEntity(
    PublicHealthServiceRecommendedResponseDto dto,
  ) {
    return RecommendedServiceEntity(
      id: dto.id,
      title: dto.title,
      imageUrl: dto.imageUrl?.toString() ?? '',
      rating: dto.rating.toDouble(),
      reviewLabel: dto.reviewLabel,
      bookedLabel: dto.bookedLabel,
      price: dto.price,
    );
  }
}

// ─────────────────────────────────────────────────────
// Mock implementation
// ─────────────────────────────────────────────────────

/// Returns fake data after a simulated network delay.
class ServiceDetailsRemoteDatasourceMock
    implements ServiceDetailsRemoteDatasource {
  @override
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockServiceInfoMap[serviceId] ?? kMockServiceInfo;
  }

  @override
  Future<List<SpecialistEntity>> getServiceEmployees(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return kMockEmployeesMap[serviceId] ?? [];
  }

  @override
  Future<List<ReviewEntity>> getServiceReviews(
    String serviceId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    return kMockReviewsMap[serviceId] ?? [];
  }

  @override
  Future<List<ReviewEntity>> getEmployeeReviews(
    String employeeId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    return kMockEmployeeReviewsMap[
        employeeId] ??
        [];
  }

  @override
  Future<List<RecommendedServiceEntity>> getRecommendedServices(
    String serviceId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return kMockRecommendedMap[serviceId] ?? [];
  }
}

// ─────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final serviceDetailsRemoteDatasourceProvider =
    Provider<ServiceDetailsRemoteDatasource>((ref) {
      final useMock = AppEnvironment.current.useMock;

      if (useMock) {
        return ServiceDetailsRemoteDatasourceMock();
      }

      final apiService = ref.read(apiServiceProvider);
      return ServiceDetailsRemoteDatasourceImpl(apiService);
    });
