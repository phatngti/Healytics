import 'package:user_app/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/domain/repositories/home.repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeImplementRepository implements HomeRepository {
  final HomeRemoteDatasource remoteDatasource;

  HomeImplementRepository({required this.remoteDatasource});

  @override
  Future<List<HomeCategory>> getCategories() async {
    return await remoteDatasource.getCategories();
  }

  @override
  Future<List<HomeProduct>> getProducts() async {
    return await remoteDatasource.getProducts();
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDatasource = ref.read(homeRemoteDatasourceProvider);
  return HomeImplementRepository(remoteDatasource: remoteDatasource);
});
