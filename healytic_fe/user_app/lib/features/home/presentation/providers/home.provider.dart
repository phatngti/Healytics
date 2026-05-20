import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
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

/// Provider for fetching home-recommend products
/// via the Recommender AI microservice.
@riverpod
Future<List<AiRecommendation>> recommendedProducts(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return [];
  final list = await repository.getRecommendedProducts(userId: userId);
  return list;
}

/// Provider for the full recommendations list.
@riverpod
Future<List<AiRecommendation>> allRecommendedProducts(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return [];
  return repository.getRecommendedProducts(userId: userId, topK: 20);
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
Future<List<HomeSpecialist>> featuredSpecialists(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getFeaturedSpecialists();
}

/// Provider for fetching recent appointment activity
/// shown on the home dashboard.
@riverpod
Future<List<AppointmentEntity>> recentActivity(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getRecentActivity(limit: 5);
}

/// Provider for the full recent activity list.
@riverpod
Future<List<AppointmentEntity>> allRecentActivity(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getRecentActivity(limit: 20);
}
