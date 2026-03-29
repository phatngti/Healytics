import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/home/data/provider/home.provider.dart';
import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';

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

/// Provider for fetching featured specialists.
@riverpod
Future<List<HomeSpecialist>> featuredSpecialists(
  Ref ref,
) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getFeaturedSpecialists();
}

/// Provider for fetching AI-powered service
/// recommendations based on a list of service IDs.
@riverpod
Future<List<AiRecommendation>> aiRecommendations(
  Ref ref,
  List<String> serviceIds,
) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getAiRecommendations(serviceIds);
}

/// Provider for fetching recent appointment activity
/// shown on the home dashboard.
@riverpod
Future<List<AppointmentEntity>> recentActivity(
  Ref ref,
) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getRecentActivity(limit: 5);
}
