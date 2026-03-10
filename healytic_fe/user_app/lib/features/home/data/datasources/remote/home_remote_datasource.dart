import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'home_mock_data.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_openapi/api.dart';

abstract class HomeRemoteDatasource {
  Future<List<HomeCategory>> getCategories();
  Future<List<HomeProduct>> getRecommendedProducts();
  Future<List<HomeProduct>> getPremiumTreatments();
  Future<List<ServiceTag>> getServiceTags();
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
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  @override
  Future<List<HomeProduct>> getRecommendedProducts() async {
    try {
      final response = await _apiService.healthServicesApi
          .healthServiceControllerGetHomeRecommend();

      if (response == null) return [];
      return response.map(_mapDtoToProduct).toList();
    } catch (e) {
      debugPrint('Error fetching recommended products: $e');
      return [];
    }
  }

  @override
  Future<List<HomeProduct>> getPremiumTreatments() async {
    try {
      final response = await _apiService.healthServicesApi
          .healthServiceControllerGetPremiumTreatments();

      if (response == null) return [];
      return response.map(_mapDtoToProduct).toList();
    } catch (e) {
      debugPrint('Error fetching premium treatments: $e');
      return [];
    }
  }

  /// Maps a [PublicHealthServiceCardResponseDto] to a
  /// domain [HomeProduct] entity.
  HomeProduct _mapDtoToProduct(
    PublicHealthServiceCardResponseDto dto,
  ) {
    return HomeProduct(
      id: dto.id,
      name: dto.name,
      slug: dto.slug,
      imageUrl: dto.imageUrl?.toString() ?? '',
      category: dto.category,
      duration: dto.duration,
      price: dto.price,
      rating: dto.rating,
      vendorName: dto.vendorName,
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
      final response = await _apiService
          .partnerServiceTagsApi
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
  Future<List<HomeProduct>> getRecommendedProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockRecommendedProducts;
  }

  @override
  Future<List<HomeProduct>> getPremiumTreatments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockPremiumTreatments;
  }

  @override
  Future<List<ServiceTag>> getServiceTags() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockServiceTags;
  }
}

/// Uses [StoreKey.mockFlag] to switch between real and mock
/// implementations at runtime.
final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  final useMock = Store.tryGet(StoreKey.mockFlag) == 'true';

  if (useMock) {
    return HomeRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return HomeRemoteDatasourceImpl(apiService);
});
