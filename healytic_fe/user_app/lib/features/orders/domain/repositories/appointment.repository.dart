import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Abstract repository for the appointment feature.
abstract class AppointmentRepository {
  /// Fetches appointments for the current user.
  ///
  /// Optional server-side filters:
  /// - [status]: filter by appointment status
  /// - [categoryId]: filter by category ID
  /// - [sortBy]: sort order (e.g. 'newest', 'oldest')
  Future<List<AppointmentEntity>> getAppointments({
    String? status,
    String? categoryId,
    String? sortBy,
  });

  /// Fetches available category filters.
  Future<List<AppointmentCategory>> getCategories();

  /// Fetches personalized service recommendations.
  Future<List<RecommendedServiceEntity>> getRecommendations();

  /// Fetches a single appointment by its [id].
  Future<AppointmentEntity?> getAppointmentById(String id);
}
