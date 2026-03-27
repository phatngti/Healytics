import 'package:user_app/features/orders/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_app/features/orders/domain/repositories/appointment.repository.dart';

/// Concrete [AppointmentRepository] backed by a remote
/// datasource.
class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDatasource _datasource;

  AppointmentRepositoryImpl(this._datasource);

  @override
  Future<List<AppointmentEntity>> getAppointments() =>
      _datasource.getAppointments();

  @override
  Future<List<AppointmentCategory>> getCategories() =>
      _datasource.getCategories();

  @override
  Future<List<RecommendedServiceEntity>> getRecommendations() =>
      _datasource.getRecommendations();

  @override
  Future<AppointmentEntity?> getAppointmentById(String id) =>
      _datasource.getAppointmentById(id);
}
