import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'home_mock_data.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_openapi/api.dart';

abstract class HomeRemoteDatasource {
  Future<List<HomeCategory>> getCategories();
  Future<List<HomeProduct>> getProducts();
  Future<List<ServiceTag>> getServiceTags();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final CategoriesApi _categoriesApi;
  final ProductsApi _productsApi;
  final ServiceTagsApi _serviceTagsApi;

  HomeRemoteDatasourceImpl(
    this._categoriesApi,
    this._productsApi,
    this._serviceTagsApi,
  );

  @override
  Future<List<HomeCategory>> getCategories() async {
    try {
      final response = await _categoriesApi.categoriesControllerFindAll(
        rootsOnly: true,
      );

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
  Future<List<HomeProduct>> getProducts() async {
    try {
      final response = await _productsApi.productsControllerFindAll();
      if (response == null) return [];

      return response.map((dto) {
        // Extract first media URL or fallback placeholder.
        final imageUrl = dto.media.isNotEmpty
            ? dto.media.first.url
            : 'https://via.placeholder.com/150';

        // Duration from service definition, default 30 min.
        final durationMinutes = dto.serviceDefinition?.durationMinutes;
        final duration = durationMinutes != null
            ? '${durationMinutes.toInt()} min'
            : '30 min';

        final categoryName = dto.category?.name ?? 'Treatment';
        final vendorName = dto.vendorName?.toString() ?? '';

        // Map staff avatars from eligibilities.
        final staffAvatars = dto.serviceEmployeeEligibilities
            .map((e) => e.toJson()['employee'])
            .whereType<Map<String, dynamic>>()
            .map((emp) => emp['avatarUrl'] as String?)
            .where((url) => url != null && url.isNotEmpty)
            .cast<String>()
            .toList();

        return HomeProduct(
          id: dto.id,
          name: dto.name,
          slug: dto.slug,
          imageUrl: imageUrl,
          category: categoryName,
          duration: duration,
          price: '${dto.basePrice.toInt()} ${dto.currency}',
          rating: '4.9',
          vendorName: vendorName,
          staffAvatars: staffAvatars,
          type: dto.type.value,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching products: $e');
      return [];
    }
  }

  IconData _getIconForCategory(String slug) {
    if (slug.contains('spa')) return Symbols.spa;
    if (slug.contains('wellness')) return Symbols.self_improvement;
    if (slug.contains('fitness')) return Symbols.fitness_center;
    if (slug.contains('mental')) return Symbols.psychology;
    if (slug.contains('therapy')) return Symbols.accessibility_new;
    return Symbols.medical_services;
  }

  // Note: These return category types that will map to theme colors in the UI
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
      final response = await _serviceTagsApi.serviceTagsControllerFindActive();
      if (response == null || response.isEmpty) return [];

      return response
          .map(
            (dto) => ServiceTag(
              id: dto.id,
              name: dto.name,
              description: dto.description?.toString(),
              colorValue: dto.colorValue.toInt(),
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
  Future<List<HomeProduct>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockProducts;
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
  return HomeRemoteDatasourceImpl(
    CategoriesApi(apiService.apiClient),
    ProductsApi(apiService.apiClient),
    ServiceTagsApi(apiService.apiClient),
  );
});
