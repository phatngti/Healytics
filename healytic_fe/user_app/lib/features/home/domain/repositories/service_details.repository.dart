import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

/// Contract for fetching service detail data.
abstract class ServiceDetailsRepository {
  /// Loads full details for the service identified by [serviceId].
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId);
}
