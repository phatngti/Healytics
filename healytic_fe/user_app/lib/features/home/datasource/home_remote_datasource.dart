import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/features/home/domain/home.entity.dart';
import 'package:user_openapi/api.dart';

abstract class HomeRemoteDatasource {
  Future<List<HomeCategory>> getCategories();
  Future<List<HomeProduct>> getProducts();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final CategoriesApi _categoriesApi;
  final ProductsApi _productsApi;

  HomeRemoteDatasourceImpl(this._categoriesApi, this._productsApi);

  @override
  Future<List<HomeCategory>> getCategories() async {
    try {
      final response = await _categoriesApi.categoriesControllerFindAll(
        rootsOnly: true,
      );

      if (response == null) return [];

      final List<dynamic> rawList = response;

      return rawList.map((item) {
        final map = item as Map<String, dynamic>;

        final slug = map['slug'] as String? ?? '';
        final name = map['name'] as String? ?? 'Service';

        return HomeCategory(
          id: map['_id'] as String? ?? '',
          name: name,
          slug: slug,
          icon: _getIconForCategory(slug),
          color: _getColorForCategory(slug),
          bgColor: _getBgColorForCategory(slug),
          borderColor: _getBorderColorForCategory(slug),
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

      final List<dynamic> rawList = response;

      return rawList.map((item) {
        final map = item as Map<String, dynamic>;

        final name = map['name'] as String? ?? 'Product';
        final slug = map['slug'] as String? ?? '';
        final price = map['basePrice']?.toString() ?? '0';
        final currency = map['currency'] as String? ?? 'VND';

        String imageUrl = '';
        final media = map['media'] as List<dynamic>?;
        if (media != null && media.isNotEmpty) {
          final first = media.first;
          if (first is Map<String, dynamic>) {
            imageUrl = first['url'] as String? ?? '';
          }
        }

        if (imageUrl.isEmpty) {
          imageUrl = 'https://via.placeholder.com/150';
        }

        String duration = '30 min';
        final serviceDefinition =
            map['serviceDefinition'] as Map<String, dynamic>?;
        if (serviceDefinition != null) {
          final mins = serviceDefinition['durationMinutes'];
          if (mins != null) {
            duration = '$mins min';
          }
        }

        String categoryName = 'Treatment';
        final category = map['category'];
        if (category is Map<String, dynamic>) {
          categoryName = category['name'] as String? ?? 'Treatment';
        }

        // Map staff avatars from serviceEmployeeEligibilities
        List<String> staffAvatars = [];
        final serviceEmployeeEligibilities =
            map['serviceEmployeeEligibilities'] as List<dynamic>?;
        if (serviceEmployeeEligibilities != null) {
          staffAvatars = serviceEmployeeEligibilities
              .map((e) {
                if (e is Map<String, dynamic>) {
                  // Check if employee object exists and has avatarUrl
                  final employee = e['employee'];
                  if (employee is Map<String, dynamic>) {
                    return employee['avatarUrl'] as String?;
                  }
                }
                return null;
              })
              .where((url) => url != null && url.isNotEmpty)
              .cast<String>()
              .toList();
        }

        return HomeProduct(
          id: map['_id'] as String? ?? '',
          name: name,
          slug: slug,
          imageUrl: imageUrl,
          category: categoryName,
          duration: duration,
          price: '$price $currency',
          rating: '4.9',
          staffAvatars: staffAvatars,
          type: map['type'] as String? ?? 'physical',
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

  Color _getColorForCategory(String slug) {
    if (slug.contains('spa')) return const Color(0xFFEC4899);
    if (slug.contains('wellness')) return const Color(0xFF16A34A);
    if (slug.contains('fitness')) return const Color(0xFF3B82F6);
    if (slug.contains('mental')) return const Color(0xFFA855F7);
    if (slug.contains('therapy')) return const Color(0xFFF97316);
    return const Color(0xFF0D9488);
  }

  Color _getBgColorForCategory(String slug) {
    if (slug.contains('spa')) return const Color(0xFFFDF2F8);
    if (slug.contains('wellness')) return const Color(0xFFF0FDF4);
    if (slug.contains('fitness')) return const Color(0xFFEFF6FF);
    if (slug.contains('mental')) return const Color(0xFFFAF5FF);
    if (slug.contains('therapy')) return const Color(0xFFFFF7ED);
    return const Color(0xFFF0FDFA);
  }

  Color _getBorderColorForCategory(String slug) {
    if (slug.contains('spa')) return const Color(0xFFFBCFE8);
    if (slug.contains('wellness')) return const Color(0xFFBBF7D0);
    if (slug.contains('fitness')) return const Color(0xFFBFDBFE);
    if (slug.contains('mental')) return const Color(0xFFE9D5FF);
    if (slug.contains('therapy')) return const Color(0xFFFED7AA);
    return const Color(0xFF99F6E4);
  }
}

final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return HomeRemoteDatasourceImpl(
    CategoriesApi(apiService.apiClient),
    ProductsApi(apiService.apiClient),
  );
});
