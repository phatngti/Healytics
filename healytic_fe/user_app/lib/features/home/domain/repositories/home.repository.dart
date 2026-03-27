import 'package:user_app/features/home/domain/entities/home.entity.dart';

abstract class HomeRepository {
  Future<List<HomeCategory>> getCategories();
  Future<List<HomeProduct>> getRecommendedProducts();
  Future<List<HomeProduct>> getPremiumTreatments();
  Future<List<ServiceTag>> getServiceTags();
}
