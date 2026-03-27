import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/orders/data/datasources/remote/service_manual_datasource.provider.dart';
import 'package:user_app/features/orders/data/repositories/service_manual_impl.repository.dart';
import 'package:user_app/features/orders/domain/repositories/service_manual.repository.dart';

part 'service_manual.provider.g.dart';

/// Provides the [ServiceManualRepository]
/// implementation wired to the active remote
/// datasource.
@riverpod
ServiceManualRepository serviceManualRepository(Ref ref) {
  final datasource = ref.read(serviceManualRemoteDatasourceProvider);
  return ServiceManualRepositoryImpl(datasource);
}
