import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';

abstract class HomeRepository {
  Future<List<HomeCategory>> getCategories();
  Future<List<HomeProduct>> getRecommendedProducts();
  Future<List<HomeProduct>> getPremiumTreatments();
  Future<List<ServiceTag>> getServiceTags();
  Future<List<HomeSpecialist>> getFeaturedSpecialists();

  /// Fetches AI-powered service recommendations
  /// for the given [serviceIds].
  Future<List<AiRecommendation>> getAiRecommendations(
    List<String> serviceIds,
  );

  /// Fetches recent appointment activity for the
  /// home dashboard (limited to a small subset).
  Future<List<AppointmentEntity>> getRecentActivity({
    int limit,
  });
}
