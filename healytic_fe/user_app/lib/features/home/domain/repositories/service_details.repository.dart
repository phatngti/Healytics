import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

/// Contract for fetching service detail data.
///
/// Each method maps to a separate API endpoint.
abstract class ServiceDetailsRepository {
  /// Core service information.
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId);

  /// Specialists assigned to this service, with
  /// their individual schedules.
  Future<List<SpecialistEntity>> getServiceEmployees(String serviceId);

  /// User reviews for this service.
  Future<List<ReviewEntity>> getServiceReviews(String serviceId);

  /// Related service recommendations.
  Future<List<RecommendedServiceEntity>> getRecommendedServices(
    String serviceId,
  );
}
