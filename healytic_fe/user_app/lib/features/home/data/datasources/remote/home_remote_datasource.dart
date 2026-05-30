import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';
import 'home_mock_data.dart';
import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort_helpers.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_openapi/api.dart';
import 'dart:convert';

abstract class HomeRemoteDatasource {
  Future<List<HomeCategory>> getCategories();

  /// Fetches AI-powered home recommendations via
  /// the Recommender microservice.
  Future<List<AiRecommendation>> getRecommendedProducts({
    required String userId,
    int topK,
  });

  Future<List<HomeProduct>> getPremiumTreatments({ServiceListFilter? filter});
  Future<List<ServiceTag>> getServiceTags();
  Future<List<HomeSpecialist>> getFeaturedSpecialists();

  /// Fetches AI-powered recommendations for
  /// the given [serviceIds].
  Future<List<AiRecommendation>> getAiRecommendations(List<String> serviceIds);

  /// Fetches recent appointment activity for the
  /// home dashboard.
  Future<List<AppointmentEntity>> getRecentActivity({
    int limit,
    RecentActivityFilter? filter,
  });
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final ApiService _apiService;

  HomeRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<HomeCategory>> getCategories() async {
    try {
      final response = await _apiService.categoriesApi
          .categoriesControllerFindAll(rootsOnly: true);

      if (response == null) return [];

      return response.map((category) {
        final slug = category.slug;
        final name = category.name;

        return HomeCategory(
          id: category.id,
          name: name,
          slug: slug,
          icon: _getIconForCategory(slug),
          categoryType: _getCategoryType(slug),
          parentId: category.parent?.id,
          parentName: category.parent?.name,
          children: category.children
              .map(
                (child) => HomeCategory(
                  id: child.id,
                  name: child.name,
                  slug: child.slug,
                  parentId: category.id,
                  parentName: category.name,
                  icon: _getIconForCategory(child.slug),
                  categoryType: _getCategoryType(child.slug),
                ),
              )
              .toList(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  @override
  Future<List<AiRecommendation>> getRecommendedProducts({
    required String userId,
    int topK = 5,
  }) async {
    try {
      final request = HomeRecommenderRequest(userId: userId, topK: topK);
      final response = await _apiService.recommenderApi
          .recommendHomeRecommenderHomePost(request);
      if (response == null) return [];
      return response.recommendations.map(_mapDtoToEntity).toList();
    } catch (e) {
      debugPrint('Error fetching recommended products: $e');
      return [];
    }
  }

  /// Maps an [AiRecommendationItemDto] from the
  /// Recommender API to [AiRecommendation].
  AiRecommendation _mapDtoToEntity(AiRecommendationItemDto dto) {
    final priceAmount = double.tryParse(dto.price ?? '') ?? 0;

    return AiRecommendation(
      serviceId: dto.serviceId ?? '',
      name: dto.name ?? '',
      imageUrl: dto.imageUrl ?? '',
      price: dto.price ?? '',
      priceAmount: priceAmount,
      rating: double.tryParse(dto.rating ?? '') ?? 0,
      location: dto.location ?? '',
      category: dto.category ?? '',
      vendorName: dto.vendorName ?? '',
    );
  }

  @override
  Future<List<HomeProduct>> getPremiumTreatments({
    ServiceListFilter? filter,
  }) async {
    final response = await _apiService.userHealthServicesApi
        .userHealthServiceControllerGetPremiumTreatments(
          sort: filter?.sort.apiValue,
          minPrice: filter?.minPrice,
          maxPrice: filter?.maxPrice,
          categoryId: filter?.categoryId,
          clinicId: filter?.clinicId,
          provinceId: filter?.provinceId,
          districtId: filter?.districtId,
          wardId: filter?.wardId,
        );

    if (response == null) return [];
    return response.map(_mapDtoToProduct).toList();
  }

  /// Maps a [PublicHealthServiceCardResponseDto] to a
  /// domain [HomeProduct] entity.
  HomeProduct _mapDtoToProduct(PublicHealthServiceCardResponseDto dto) {
    return HomeProduct(
      id: dto.id,
      name: dto.name,
      slug: dto.slug,
      imageUrl: dto.imageUrl?.toString() ?? '',
      category: dto.category,
      categoryId: dto.categoryId?.toString(),
      duration: dto.duration,
      price: dto.price,
      priceAmount: dto.priceAmount,
      rating: dto.rating,
      vendorName: dto.vendorName,
      clinicId: dto.clinicId?.toString(),
      location: dto.location,
      staffAvatars: dto.staffAvatars,
      type: dto.type,
    );
  }

  IconData _getIconForCategory(String slug) {
    if (slug.contains('spa')) return Symbols.spa;
    if (slug.contains('wellness')) {
      return Symbols.self_improvement;
    }
    if (slug.contains('fitness')) {
      return Symbols.fitness_center;
    }
    if (slug.contains('mental')) return Symbols.psychology;
    if (slug.contains('therapy')) {
      return Symbols.accessibility_new;
    }
    return Symbols.medical_services;
  }

  String _getCategoryType(String slug) {
    if (slug.contains('spa')) return 'primary';
    if (slug.contains('wellness')) return 'secondary';
    if (slug.contains('fitness')) return 'tertiary';
    if (slug.contains('mental')) return 'error';
    if (slug.contains('therapy')) return 'tertiary';
    return 'primary';
  }

  @override
  Future<List<ServiceTag>> getServiceTags() async {
    try {
      final response = await _apiService.partnerServiceTagsApi
          .serviceTagsControllerFindActive();
      if (response == null || response.isEmpty) return [];

      return response
          .map(
            (dto) => ServiceTag(
              id: dto.id,
              name: dto.name,
              description: dto.description?.toString(),
              colorValue: int.tryParse(dto.colorValue) ?? 0,
              usage: dto.usage.toInt(),
              isActive: dto.isActive,
              sortOrder: dto.sortOrder.toInt(),
            ),
          )
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    } catch (e) {
      debugPrint('Error fetching service tags: $e');
      return [];
    }
  }

  @override
  Future<List<HomeSpecialist>> getFeaturedSpecialists() async {
    try {
      final response = await _apiService.userEmployeesApi
          .userEmployeesControllerGetFeaturedSpecialists(limit: 10);
      if (response == null) return [];
      return response
          .map(
            (dto) => HomeSpecialist(
              id: dto.id,
              name: dto.name,
              specialty: dto.specialty,
              avatarUrl: dto.avatarUrl?.toString(),
              rating: dto.rating.toDouble(),
              soldCount: dto.soldCount.toInt(),
              clinicName: dto.clinicName,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Error fetching featured specialists: $e');
      return [];
    }
  }

  @override
  Future<List<AiRecommendation>> getAiRecommendations(
    List<String> serviceIds,
  ) async {
    try {
      final request = ChatbotRecommenderRequest(
        conversationId: '',
        query: 'recommend',
        filteredIds: serviceIds,
      );
      final response = await _apiService.recommenderApi
          .recommendChatbotRecommenderChatbotPost(request);
      if (response == null) return [];
      return response.recommendations.map(_mapDtoToEntity).toList();
    } catch (e) {
      debugPrint('Error fetching AI recommendations: $e');
      return [];
    }
  }

  @override
  Future<List<AppointmentEntity>> getRecentActivity({
    int limit = 5,
    RecentActivityFilter? filter,
  }) async {
    try {
      final response = await _apiService.userAppointmentsApi
          .userAppointmentControllerListRecentActivityWithHttpInfo(
            limit: limit,
            status: filter?.status,
            categoryId: filter?.categoryId,
            clinicId: filter?.clinicId,
            fromDate: _dateQuery(filter?.fromDate),
            toDate: _dateQuery(filter?.toDate),
            sort: filter?.sort.apiValue,
          );
      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);

        // The API returns a paginated envelope:
        // { "data": [...], "meta": {...} }
        final List<dynamic> items;
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          items = decoded['data'] as List<dynamic>;
        } else if (decoded is List) {
          items = decoded;
        } else {
          return [];
        }

        return items
            .map((item) => _mapRawToAppointment(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching recent activity: $e');
      return [];
    }
  }

  /// Defensively maps raw JSON into an
  /// [AppointmentEntity].
  ///
  /// API fields (snake_case):
  /// `id`, `title`, `scheduled_at`, `status`,
  /// `service_type_code`.
  AppointmentEntity _mapRawToAppointment(Map<String, dynamic> json) {
    final scheduledAt =
        DateTime.tryParse(json['scheduled_at']?.toString() ?? '') ??
        DateTime.now();
    final localTime = scheduledAt.toLocal();

    // Format HH:mm from the parsed timestamp.
    final hour = localTime.hour.toString().padLeft(2, '0');
    final minute = localTime.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute';

    final status = json['status']?.toString().toLowerCase() ?? 'scheduled';

    return AppointmentEntity(
      id: json['id']?.toString() ?? '',
      serviceName: json['title']?.toString() ?? '',
      healthPartnerName: json['vendor_name']?.toString() ?? '',
      healthPartnerId: json['health_partner_id']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      status: status,
      category: json['service_type_code']?.toString() ?? '',
      specialistName: json['provider_name']?.toString() ?? '',
      specialistId: json['provider_id']?.toString(),
      serviceId: json['service_id']?.toString(),
      address: json['address']?.toString() ?? '',
      date: localTime,
      checkInTime: timeStr,
      checkOutTime: json['check_out_time']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      distanceKm: _parseDistanceRaw(json['distance_km']),
    );
  }

  /// Defensively converts a raw JSON distance
  /// value into a [double?].
  double? _parseDistanceRaw(Object? raw) {
    if (raw == null) return null;
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw);
    return null;
  }

  String? _dateQuery(DateTime? value) {
    if (value == null) return null;
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}

/// Mock implementation that returns fake data after a
/// simulated network delay, useful for development/testing.
class HomeRemoteDatasourceMock implements HomeRemoteDatasource {
  @override
  Future<List<HomeCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockCategories;
  }

  @override
  Future<List<AiRecommendation>> getRecommendedProducts({
    required String userId,
    int topK = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockAiRecommendations;
  }

  @override
  Future<List<HomeProduct>> getPremiumTreatments({
    ServiceListFilter? filter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return filterServiceProducts(kMockPremiumTreatments, filter);
  }

  @override
  Future<List<ServiceTag>> getServiceTags() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockServiceTags;
  }

  @override
  Future<List<HomeSpecialist>> getFeaturedSpecialists() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockFeaturedSpecialists;
  }

  @override
  Future<List<AiRecommendation>> getAiRecommendations(
    List<String> serviceIds,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return kMockAiRecommendations;
  }

  @override
  Future<List<AppointmentEntity>> getRecentActivity({
    int limit = 5,
    RecentActivityFilter? filter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final items = filter == null
        ? kMockRecentActivities
        : filterRecentActivitiesLocally(kMockRecentActivities, filter);
    return items.take(limit).toList();
  }
}

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  final useMock = AppEnvironment.current.useMock;

  if (useMock) {
    return HomeRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return HomeRemoteDatasourceImpl(apiService);
});
