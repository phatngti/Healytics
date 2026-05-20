import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/features/partner/bookings/data/datasources/remote/bookings_remote_datasource.dart';
import 'package:admin_panel/features/partner/bookings/data/repositories/bookings_impl.repository.dart';
import 'package:admin_panel/features/partner/bookings/domain/repositories/bookings.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookings_data.provider.g.dart';

/// Provides the [BookingsRemoteDataSource] with config-flag
/// switching between mock and real implementations.
///
/// Uses [StoreKey.mockFlag] to determine whether to return
/// [BookingsRemoteDataSourceMock] (for development without a
/// backend) or [BookingsRemoteDataSourceImpl] (backed by the
/// generated OpenAPI client).
///
/// Validates: Req 8.2, 8.5.
@riverpod
BookingsRemoteDataSource bookingsRemoteDatasource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return BookingsRemoteDataSourceMock();
  }
  return BookingsRemoteDataSourceImpl(apiService: ref.read(apiServiceProvider));
}

/// Provides the [BookingsRepository] backed by the active
/// [BookingsRemoteDataSource].
///
/// The repository applies drop-malformed and coerce-unknown
/// contracts before returning bookings to the presentation
/// layer.
///
/// Validates: Req 8.2.
@riverpod
BookingsRepository bookingsRepository(Ref ref) {
  return BookingsRepositoryImpl(
    remoteDataSource: ref.watch(bookingsRemoteDatasourceProvider),
  );
}
