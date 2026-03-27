import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/home/data/provider/service_details.provider.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

part 'service_details.provider.g.dart';

/// Fetches core service info by [serviceId].
///
/// Uses a family parameter so each service ID gets
/// its own cached async state.
@riverpod
Future<ServiceDetailsEntity> serviceDetails(
  Ref ref, {
  required String serviceId,
}) async {
  final repo = ref.read(serviceDetailsRepositoryProvider);
  return repo.getServiceDetails(serviceId);
}

/// Fetches employees (specialists) assigned to a
/// service.
@riverpod
Future<List<SpecialistEntity>> serviceEmployees(
  Ref ref, {
  required String serviceId,
}) async {
  final repo = ref.read(serviceDetailsRepositoryProvider);
  return repo.getServiceEmployees(serviceId);
}

/// Fetches user reviews for a service.
@riverpod
Future<List<ReviewEntity>> serviceReviews(
  Ref ref, {
  required String serviceId,
}) async {
  final repo = ref.read(serviceDetailsRepositoryProvider);
  return repo.getServiceReviews(serviceId);
}

/// Fetches recommended services for a given
/// [serviceId].
@riverpod
Future<List<RecommendedServiceEntity>> recommendedServices(
  Ref ref, {
  required String serviceId,
}) async {
  final repo = ref.read(serviceDetailsRepositoryProvider);
  return repo.getRecommendedServices(serviceId);
}
