import 'package:user_app/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/domain/repositories/home.repository.dart';

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
}
