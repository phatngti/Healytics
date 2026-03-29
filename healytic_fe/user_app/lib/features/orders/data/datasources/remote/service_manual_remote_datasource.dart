// Remote data source for the service manual feature.
//
// 3-part pattern: abstract interface, implementation,
// and mock.

import 'package:logging/logging.dart';

import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/orders/data/datasources/remote/service_manual_mock_data.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';
import 'package:user_openapi/api.dart';

// ─── Abstract interface ───────────────────────────

/// Contract for fetching service manual data.
abstract class ServiceManualRemoteDataSource {
  /// Fetches the service manual for [appointmentId].
  Future<ServiceManualEntity?> fetchManual(
    String appointmentId,
  );
}

// ─── Real implementation ──────────────────────────

/// Production implementation backed by the
/// [UserAppointmentsApi].
class ServiceManualRemoteDataSourceImpl
    implements ServiceManualRemoteDataSource {
  static final _log =
      Logger('ServiceManualDatasource');
  final ApiService _apiService;

  ServiceManualRemoteDataSourceImpl(this._apiService);

  @override
  Future<ServiceManualEntity?> fetchManual(
    String appointmentId,
  ) async {
    try {
      final dto = await _apiService
          .userAppointmentsApi
          .userAppointmentControllerGetServiceManual(
            appointmentId,
          );

      if (dto == null) return null;
      return _mapManualDto(dto);
    } catch (e, s) {
      _log.severe('Error fetching service manual', e, s);
      return null;
    }
  }

  // ─── DTO → Entity mappers ──────────────────────

  ServiceManualEntity _mapManualDto(
    ServiceManualResponseDto dto,
  ) {
    return ServiceManualEntity(
      serviceName: dto.serviceName,
      vendorName: dto.vendorName,
      imageUrl: dto.imageUrl,
      preServiceGuidelines: dto.preServiceGuidelines,
      serviceRules: dto.serviceRules
          .map(_mapServiceRule)
          .toList(),
      procedureSteps: dto.procedureSteps
          .map(_mapProcedureStep)
          .toList(),
      facilities: dto.facilities
          .map(_mapFacility)
          .toList(),
      review: _mapReview(dto.review),
    );
  }

  ServiceRuleEntity _mapServiceRule(
    ServiceRuleDto dto,
  ) {
    return ServiceRuleEntity(
      iconSlug: dto.iconSlug,
      title: dto.title,
      description: dto.description,
    );
  }

  ProcedureStepEntity _mapProcedureStep(
    ProcedureStepDto dto,
  ) {
    return ProcedureStepEntity(
      stepNumber: dto.stepNumber.toInt(),
      title: dto.title,
      description: dto.description,
      isActive: dto.isActive,
    );
  }

  FacilityEntity _mapFacility(FacilityDto dto) {
    return FacilityEntity(
      imageUrl: dto.imageUrl,
      name: dto.name,
    );
  }

  ManualReviewEntity _mapReview(
    ReviewSummaryDto? dto,
  ) {
    if (dto == null) {
      return const ManualReviewEntity(
        averageRating: 0,
        reviewerName: '',
        reviewText: '',
      );
    }
    return ManualReviewEntity(
      averageRating: dto.averageRating.toDouble(),
      reviewerName: dto.reviewerName,
      reviewText: dto.reviewText,
      starCount: dto.starCount.toInt(),
    );
  }
}

// ─── Mock implementation ──────────────────────────

/// Mock data source using in-memory data with a
/// simulated network delay.
class ServiceManualRemoteDataSourceMock
    implements ServiceManualRemoteDataSource {
  @override
  Future<ServiceManualEntity?> fetchManual(
    String appointmentId,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );
    return getMockServiceManual(appointmentId);
  }
}
