import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/features/orders/data/datasources/remote/service_manual_remote_datasource.dart';

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final serviceManualRemoteDatasourceProvider =
    Provider<ServiceManualRemoteDataSource>((ref) {
  final useMock = AppEnvironment.current.useMock;

  if (useMock) {
    return ServiceManualRemoteDataSourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return ServiceManualRemoteDataSourceImpl(apiService);
});
