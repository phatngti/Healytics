// Repository implementation for the service manual.

import 'package:user_app/features/orders/data/datasources/remote/service_manual_remote_datasource.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';
import 'package:user_app/features/orders/domain/repositories/service_manual.repository.dart';

/// Concrete [ServiceManualRepository] backed by a
/// remote data source.
class ServiceManualRepositoryImpl implements ServiceManualRepository {
  final ServiceManualRemoteDataSource _dataSource;

  const ServiceManualRepositoryImpl(this._dataSource);

  @override
  Future<ServiceManualEntity?> getManualByAppointmentId(String appointmentId) =>
      _dataSource.fetchManual(appointmentId);
}
