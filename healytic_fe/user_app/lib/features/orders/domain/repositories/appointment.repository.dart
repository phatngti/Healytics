import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Abstract repository for the appointment feature.
abstract class AppointmentRepository {
  /// Fetches all appointments for the current user.
  Future<List<AppointmentEntity>> getAppointments();

  /// Fetches available category filters.
  Future<List<AppointmentCategory>> getCategories();

  /// Fetches personalized service recommendations.
  Future<List<RecommendedServiceEntity>> getRecommendations();

  /// Fetches a single appointment by its [id].
  Future<AppointmentEntity?> getAppointmentById(String id);
}
