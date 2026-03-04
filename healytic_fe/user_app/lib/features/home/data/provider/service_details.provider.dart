import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/home/data/datasources/remote/service_details_remote_datasource.dart';
import 'package:user_app/features/home/data/repositories/service_details_impl.repository.dart';
import 'package:user_app/features/home/domain/repositories/service_details.repository.dart';

part 'service_details.provider.g.dart';

/// Provides the [ServiceDetailsRepository] wired to the
/// active remote datasource (real or mock).
@riverpod
ServiceDetailsRepository serviceDetailsRepository(Ref ref) {
  final remoteDatasource = ref.read(serviceDetailsRemoteDatasourceProvider);
  return ServiceDetailsImplRepository(remoteDatasource: remoteDatasource);
}
