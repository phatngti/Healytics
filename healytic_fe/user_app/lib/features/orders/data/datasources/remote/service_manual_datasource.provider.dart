import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/features/orders/data/datasources/remote/service_manual_remote_datasource.dart';

/// Uses [StoreKey.mockFlag] to switch between real
/// and mock implementations at runtime.
final serviceManualRemoteDatasourceProvider =
    Provider<ServiceManualRemoteDataSource>((ref) {
      final useMock = Store.tryGet(StoreKey.mockFlag) == 'true';

      if (useMock) {
        return ServiceManualRemoteDataSourceMock();
      }

      return ServiceManualRemoteDataSourceImpl();
    });
