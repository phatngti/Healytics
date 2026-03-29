import 'package:user_app/features/home/data/datasources/'
    'remote/home_remote_datasource.dart';
import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
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
  Future<List<HomeProduct>> getRecommendedProducts() async {
    return await remoteDatasource.getRecommendedProducts();
  }

  @override
  Future<List<HomeProduct>> getPremiumTreatments() async {
    return await remoteDatasource.getPremiumTreatments();
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
  Future<List<AiRecommendation>> getAiRecommendations(
    List<String> serviceIds,
  ) async {
    return await remoteDatasource.getAiRecommendations(
      serviceIds,
    );
  }

  @override
  Future<List<AppointmentEntity>> getRecentActivity({
    int limit = 5,
  }) async {
    return await remoteDatasource.getRecentActivity(
      limit: limit,
    );
  }
}
