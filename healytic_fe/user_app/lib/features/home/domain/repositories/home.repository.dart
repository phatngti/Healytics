import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';

abstract class HomeRepository {
  Future<List<HomeCategory>> getCategories();

  /// Fetches AI-powered home recommendations via
  /// the Recommender microservice.
  Future<List<AiRecommendation>> getRecommendedProducts({
    required String userId,
    int topK,
  });

  Future<List<HomeProduct>> getPremiumTreatments({
    ServiceListFilter? filter,
    int? limit,
    int? offset,
  });
  Future<List<ServiceTag>> getServiceTags();
  Future<List<HomeSpecialist>> getFeaturedSpecialists();

  /// Fetches recent appointment activity for the
  /// home dashboard (limited to a small subset).
  Future<List<AppointmentEntity>> getRecentActivity({
    int limit,
    RecentActivityFilter? filter,
  });
}
