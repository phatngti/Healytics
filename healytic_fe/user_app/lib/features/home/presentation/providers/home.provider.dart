import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/home/data/provider/home.provider.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';

part 'home.provider.g.dart';

/// Provider for fetching categories via the repository.
@riverpod
Future<List<HomeCategory>> categories(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getCategories();
}

/// Provider for fetching home-recommend products.
@riverpod
Future<List<HomeProduct>> recommendedProducts(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getRecommendedProducts();
}

/// Provider for fetching premium treatments.
@riverpod
Future<List<HomeProduct>> premiumTreatments(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getPremiumTreatments();
}

/// Provider for fetching service tags.
@riverpod
Future<List<ServiceTag>> serviceTags(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getServiceTags();
}
