import 'package:user_app/features/home/data/datasources/remote/service_details_remote_datasource.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';
import 'package:user_app/features/home/domain/repositories/service_details.repository.dart';

/// Concrete implementation that delegates to the remote
/// datasource for service detail data.
class ServiceDetailsImplRepository implements ServiceDetailsRepository {
  final ServiceDetailsRemoteDatasource remoteDatasource;

  ServiceDetailsImplRepository({required this.remoteDatasource});

  @override
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId) async {
    return remoteDatasource.getServiceDetails(serviceId);
  }

  @override
  Future<List<SpecialistEntity>> getServiceEmployees(String serviceId) async {
    return remoteDatasource.getServiceEmployees(serviceId);
  }

  @override
  Future<List<ReviewEntity>> getServiceReviews(String serviceId) async {
    return remoteDatasource.getServiceReviews(serviceId);
  }

  @override
  Future<List<RecommendedServiceEntity>> getRecommendedServices(
    String serviceId,
  ) async {
    return remoteDatasource.getRecommendedServices(serviceId);
  }
}
