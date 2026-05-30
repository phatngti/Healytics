import 'package:user_app/features/home/data/datasources/'
    'remote/home_remote_datasource.dart';
import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/domain/repositories/'
    'home.repository.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';

/// Concrete [HomeRepository] backed by a remote datasource.
class HomeImplementRepository implements HomeRepository {
  final HomeRemoteDatasource remoteDatasource;

  HomeImplementRepository({required this.remoteDatasource});

  @override
  Future<List<HomeCategory>> getCategories() async {
    return await remoteDatasource.getCategories();
  }

  @override
  Future<List<AiRecommendation>> getRecommendedProducts({
    required String userId,
    int topK = 5,
  }) async {
    return await remoteDatasource.getRecommendedProducts(
      userId: userId,
      topK: topK,
    );
  }

  @override
  Future<List<HomeProduct>> getPremiumTreatments({
    ServiceListFilter? filter,
  }) async {
    return await remoteDatasource.getPremiumTreatments(filter: filter);
  }

  @override
  Future<List<ServiceTag>> getServiceTags() async {
    return await remoteDatasource.getServiceTags();
  }

  @override
  Future<List<HomeSpecialist>> getFeaturedSpecialists() async {
    return await remoteDatasource.getFeaturedSpecialists();
  }

  @override
  Future<List<AppointmentEntity>> getRecentActivity({
    int limit = 5,
    RecentActivityFilter? filter,
  }) async {
    return await remoteDatasource.getRecentActivity(
      limit: limit,
      filter: filter,
    );
  }
}
