import 'package:user_app/features/home/domain/entities/home.entity.dart';

abstract class HomeRepository {
  Future<List<HomeCategory>> getCategories();
  Future<List<HomeProduct>> getProducts();
}
