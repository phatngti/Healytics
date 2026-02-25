import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';

/// Provider for fetching categories from the API.
final categoriesProvider = FutureProvider<List<HomeCategory>>((ref) async {
  final datasource = ref.read(homeRemoteDatasourceProvider);
  return datasource.getCategories();
});

/// Provider for fetching products from the API.
final productsProvider = FutureProvider<List<HomeProduct>>((ref) async {
  final datasource = ref.read(homeRemoteDatasourceProvider);
  return datasource.getProducts();
});

/// Provider for fetching service tags from the API.
final serviceTagsProvider = FutureProvider<List<ServiceTag>>((ref) async {
  final datasource = ref.read(homeRemoteDatasourceProvider);
  return datasource.getServiceTags();
});
