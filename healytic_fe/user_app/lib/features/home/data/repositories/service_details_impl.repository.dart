import 'package:hooks_riverpod/hooks_riverpod.dart';
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
}

/// Provider wiring the repository to its datasource.
final serviceDetailsRepositoryProvider = Provider<ServiceDetailsRepository>((
  ref,
) {
  final remoteDatasource = ref.read(serviceDetailsRemoteDatasourceProvider);
  return ServiceDetailsImplRepository(remoteDatasource: remoteDatasource);
});
