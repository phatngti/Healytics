import 'dart:developer';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_openapi/api.dart';

import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/clinic_info/data/mappers/clinic_description_text.mapper.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_review.entity.dart';

import 'clinic_info_mock_data.dart';
import 'clinic_products_mock_data.dart';
import 'clinic_reviews_mock_data.dart';

/// Contract for fetching clinic detail data from a
/// remote source.
abstract class ClinicInfoRemoteDatasource {
  /// `GET /user/clinics/:id/info`
  Future<ClinicInfoEntity> getClinicInfo(String clinicId);

  /// `GET /user/clinics/:id/products`
  Future<ClinicProductsData> getClinicProducts(
    String clinicId, {
    String? categoryId,
    ClinicProductSort sort,
    String? search,
    ClinicProductFilters filters,
    int page,
    int limit,
  });

  /// `GET /user/clinics/:id/reviews`
  Future<ClinicReviewsData> getClinicReviews(
    String clinicId, {
    int page,
    int limit,
    int? starCount,
    bool? hasMedia,
  });

  Future<ClinicInfoEntity> setFollowing(String clinicId, bool isFollowing);
}

// ─────────────────────────────────────────────────────
// Real implementation
// ─────────────────────────────────────────────────────

/// Calls the backend clinic endpoints and maps the
/// response DTOs to domain entities defensively.
class ClinicInfoRemoteDatasourceImpl implements ClinicInfoRemoteDatasource {
  const ClinicInfoRemoteDatasourceImpl(this._apiService);

  final ApiService _apiService;
  UserClinicsApi get _api => _apiService.userClinicsApi;

  @override
  Future<ClinicInfoEntity> getClinicInfo(String clinicId) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/clinics/$clinicId/info',
      'GET',
      const [],
      null,
      {},
      {},
      null,
    );
    if (response.statusCode >= 400 || response.body.isEmpty) {
      throw ApiException(404, 'Clinic info not found for $clinicId');
    }
    return _mapClinicInfoJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  @override
  Future<ClinicInfoEntity> setFollowing(
    String clinicId,
    bool isFollowing,
  ) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/clinics/$clinicId/follow',
      isFollowing ? 'POST' : 'DELETE',
      const [],
      null,
      {},
      {},
      null,
    );
    if (response.statusCode >= 400 || response.body.isEmpty) {
      throw ApiException(
        response.statusCode,
        'Failed to update clinic follow state',
      );
    }
    return _mapClinicInfoJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  @override
  Future<ClinicProductsData> getClinicProducts(
    String clinicId, {
    String? categoryId,
    ClinicProductSort sort = ClinicProductSort.popular,
    String? search,
    ClinicProductFilters filters = const ClinicProductFilters(),
    int page = 1,
    int limit = 20,
  }) async {
    final dto = await _api.userClinicControllerGetClinicProducts(
      clinicId,
      categoryId: categoryId,
      sort: sort.toApiValue(),
      search: search,
      minPrice: filters.minPrice,
      maxPrice: filters.maxPrice,
      minDuration: filters.minDuration,
      maxDuration: filters.maxDuration,
      discountOnly: filters.discountOnly ? true : null,
      page: page,
      limit: limit,
    );
    if (dto == null) {
      throw ApiException(404, 'Clinic products not found for $clinicId');
    }
    return _mapProducts(dto);
  }

  @override
  Future<ClinicReviewsData> getClinicReviews(
    String clinicId, {
    int page = 1,
    int limit = 10,
    int? starCount,
    bool? hasMedia,
  }) async {
    final dto = await _api.userClinicControllerGetClinicReviews(
      clinicId,
      page: page,
      limit: limit,
      starCount: starCount,
      hasMedia: hasMedia,
    );
    if (dto == null) {
      throw ApiException(404, 'Clinic reviews not found for $clinicId');
    }
    return _mapReviews(dto);
  }

  // ── Clinic Info Mapping ───────────────────────────

  ClinicInfoEntity _mapClinicInfoJson(Map<String, dynamic> dto) {
    final trustMetrics = _asMap(dto['trustMetrics']);
    return ClinicInfoEntity(
      id: dto['id']?.toString() ?? '',
      name: dto['name']?.toString() ?? '',
      coverImageUrl: dto['coverImageUrl']?.toString(),
      logoImageUrl: dto['logoImageUrl']?.toString(),
      gallery: _stringList(dto['gallery']),
      followersLabel: dto['followersLabel']?.toString() ?? '0',
      followerCount: _toInt(dto['followerCount']),
      isFollowing: dto['isFollowing'] == true,
      chatPartnerId: dto['chatPartnerId']?.toString(),
      reviewsLabel: dto['reviewsLabel']?.toString() ?? '0',
      description: clinicDescriptionToPlainText(dto['description']),
      address: dto['address']?.toString(),
      phoneNumber: dto['phoneNumber']?.toString(),
      trustMetrics: ClinicTrustMetrics(
        rating: _toDouble(trustMetrics['rating']),
        reviewCount: _toInt(trustMetrics['reviewCount']),
        experienceLabel: trustMetrics['experienceLabel']?.toString() ?? '',
        clientsLabel: trustMetrics['clientsLabel']?.toString() ?? '',
      ),
      certifications: _listOfMaps(dto['certifications'])
          .map(
            (c) => ClinicCertification(
              title: c['title']?.toString() ?? '',
              subtitle: c['subtitle']?.toString() ?? '',
              iconName: c['iconName']?.toString() ?? '',
            ),
          )
          .toList(),
      specialists: _listOfMaps(dto['specialists'])
          .map(
            (s) => ClinicSpecialistPreview(
              id: s['id']?.toString() ?? '',
              name: s['name']?.toString() ?? '',
              role: s['role']?.toString() ?? '',
              imageUrl: s['imageUrl']?.toString(),
              experienceLabel: s['experienceLabel']?.toString(),
            ),
          )
          .toList(),
      businessTypes: _stringList(dto['businessTypes']),
      facilityImages: _stringList(
        dto['gallery'],
      ).map((url) => ClinicFacilityImage(imageUrl: url, label: '')).toList(),
    );
  }

  Map<String, dynamic> _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return raw.cast<String, dynamic>();
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _listOfMaps(Object? raw) {
    if (raw is! List) return [];
    return raw.map(_asMap).toList();
  }

  List<String> _stringList(Object? raw) {
    if (raw is! List) return [];
    return raw.map((e) => e.toString()).toList();
  }

  int _toInt(Object? raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  double _toDouble(Object? raw) {
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '') ?? 0;
  }

  // ── Products Mapping ──────────────────────────────

  ClinicProductsData _mapProducts(ClinicProductsResponseDto dto) {
    return ClinicProductsData(
      categories: dto.categories
          .map((item) => ClinicProductCategory(id: item.id, label: item.label))
          .toList(),
      products: dto.products.map(_mapProduct).toList(),
      totalCount: dto.totalCount.toInt(),
      hasMore: dto.hasMore,
    );
  }

  ClinicProductEntity _mapProduct(ClinicProductDto dto) {
    return ClinicProductEntity(
      id: dto.id,
      title: dto.title,
      imageUrl: dto.imageUrl?.toString(),
      price: dto.price,
      priceAmount: dto.priceAmount.toDouble(),
      originalPrice: dto.originalPrice?.toString(),
      discountLabel: dto.discountLabel?.toString(),
      badgeLabel: dto.badgeLabel?.toString(),
      durationLabel: dto.durationLabel?.toString(),
      specialistLabel: dto.specialistLabel?.toString(),
      categoryId: dto.categoryId,
      soldCount: dto.soldCount.toInt(),
      createdAtMs: dto.createdAtMs.toInt(),
    );
  }

  // ── Reviews Mapping ───────────────────────────────

  ClinicReviewsData _mapReviews(ClinicReviewsResponseDto dto) {
    return ClinicReviewsData(
      summary: _mapReviewSummary(dto.summary),
      filters: dto.filters.map(_mapReviewFilter).toList(),
      reviews: dto.reviews.map(_mapReview).toList(),
      totalCount: dto.totalCount.toInt(),
      hasMore: dto.hasMore,
    );
  }

  ClinicReviewSummary _mapReviewSummary(ClinicReviewSummaryDto dto) {
    return ClinicReviewSummary(
      averageRating: dto.averageRating.toDouble(),
      totalReviewCount: dto.totalReviewCount.toInt(),
      ratingLabel: dto.ratingLabel,
      starDistribution: _parseStarDistribution(dto.starDistribution),
    );
  }

  /// Defensively parses the star distribution from
  /// the API's `Object` type to `Map<int, double>`.
  Map<int, double> _parseStarDistribution(Object raw) {
    final result = <int, double>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    try {
      if (raw is Map) {
        for (final entry in raw.entries) {
          final star = int.tryParse(entry.key.toString());
          final value = double.tryParse(entry.value.toString());
          if (star != null && value != null) {
            result[star] = value;
          }
        }
      }
    } catch (e) {
      log('Failed to parse starDistribution: $e', name: 'ClinicInfoDatasource');
    }
    return result;
  }

  ClinicReviewFilter _mapReviewFilter(ClinicReviewFilterDto dto) {
    return ClinicReviewFilter(
      id: dto.id,
      label: dto.label,
      starCount: int.tryParse(dto.starCount?.toString() ?? ''),
      requiresMedia: dto.requiresMedia,
    );
  }

  ClinicReviewEntity _mapReview(ClinicReviewDto dto) {
    return ClinicReviewEntity(
      id: dto.id,
      reviewerName: dto.reviewerName,
      reviewerInitial: dto.reviewerInitial,
      starCount: dto.starCount.toInt(),
      memberBadge: dto.memberBadge?.toString(),
      dateLabel: dto.dateLabel,
      serviceName: dto.serviceName?.toString(),
      serviceIcon: dto.serviceIcon?.toString(),
      reviewText: dto.reviewText,
      mediaUrls: dto.mediaUrls,
      clinicResponse: _mapClinicResponse(dto.clinicResponse),
    );
  }

  ClinicReviewResponse? _mapClinicResponse(ClinicReviewResponseSubDto? dto) {
    if (dto == null) return null;
    final text = dto.responseText?.toString();
    if (text == null || text.isEmpty) return null;
    return ClinicReviewResponse(responseText: text);
  }
}

// ─────────────────────────────────────────────────────
// Mock implementation
// ─────────────────────────────────────────────────────

/// Returns fake data after a simulated network delay.
class ClinicInfoRemoteDatasourceMock implements ClinicInfoRemoteDatasource {
  @override
  Future<ClinicInfoEntity> getClinicInfo(String clinicId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockClinicInfoMap[clinicId] ?? kMockClinicInfo;
  }

  @override
  Future<ClinicProductsData> getClinicProducts(
    String clinicId, {
    String? categoryId,
    ClinicProductSort sort = ClinicProductSort.popular,
    String? search,
    ClinicProductFilters filters = const ClinicProductFilters(),
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var items = kMockClinicProducts.toList();

    // -- Category filter --
    if (categoryId != null && categoryId != 'all') {
      items = items.where((p) => p.categoryId == categoryId).toList();
    }

    // -- Search filter --
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      items = items.where((p) => p.title.toLowerCase().contains(q)).toList();
    }

    if (filters.minPrice != null) {
      items = items.where((p) => p.priceAmount >= filters.minPrice!).toList();
    }
    if (filters.maxPrice != null) {
      items = items.where((p) => p.priceAmount <= filters.maxPrice!).toList();
    }
    if (filters.minDuration != null) {
      items = items
          .where((p) => _durationMinutes(p) >= filters.minDuration!)
          .toList();
    }
    if (filters.maxDuration != null) {
      items = items
          .where((p) => _durationMinutes(p) <= filters.maxDuration!)
          .toList();
    }
    if (filters.discountOnly) {
      items = items.where((p) => p.hasDiscount).toList();
    }

    // -- Sort --
    switch (sort) {
      case ClinicProductSort.latest:
        items.sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
      case ClinicProductSort.topSales:
        items.sort((a, b) => b.soldCount.compareTo(a.soldCount));
      case ClinicProductSort.priceAsc:
        items.sort((a, b) => a.priceAmount.compareTo(b.priceAmount));
      case ClinicProductSort.priceDesc:
        items.sort((a, b) => b.priceAmount.compareTo(a.priceAmount));
      case ClinicProductSort.popular:
        break; // keep default order
    }

    // -- Paginate --
    final total = items.length;
    final start = (page - 1) * limit;
    final end = start + limit;
    final paged = start < total
        ? items.sublist(start, end > total ? total : end)
        : <ClinicProductEntity>[];

    return ClinicProductsData(
      categories: kMockClinicProductCategories,
      products: paged,
      totalCount: total,
      hasMore: end < total,
    );
  }

  @override
  Future<ClinicReviewsData> getClinicReviews(
    String clinicId, {
    int page = 1,
    int limit = 10,
    int? starCount,
    bool? hasMedia,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var all = kMockClinicReviews.toList();

    // -- Server-side-like filtering --
    if (starCount != null) {
      all = all.where((r) => r.starCount == starCount).toList();
    }
    if (hasMedia == true) {
      all = all.where((r) => r.hasMedia).toList();
    }

    final start = (page - 1) * limit;
    final end = start + limit;
    final paged = start < all.length
        ? all.sublist(start, end > all.length ? all.length : end)
        : <ClinicReviewEntity>[];

    return ClinicReviewsData(
      summary: kMockClinicReviewSummary,
      filters: kMockClinicReviewFilters,
      reviews: paged,
      totalCount: all.length,
      hasMore: end < all.length,
    );
  }

  @override
  Future<ClinicInfoEntity> setFollowing(
    String clinicId,
    bool isFollowing,
  ) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final current = kMockClinicInfoMap[clinicId] ?? kMockClinicInfo;
    final nextCount = (current.followerCount + (isFollowing ? 1 : -1))
        .clamp(0, 1 << 31)
        .toInt();
    return current.copyWith(
      isFollowing: isFollowing,
      followerCount: nextCount,
      followersLabel: nextCount.toString(),
    );
  }

  int _durationMinutes(ClinicProductEntity product) {
    final match = RegExp(r'\d+').firstMatch(product.durationLabel ?? '');
    return int.tryParse(match?.group(0) ?? '') ?? 0;
  }
}

// ─────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final clinicInfoRemoteDatasourceProvider = Provider<ClinicInfoRemoteDatasource>(
  (ref) {
    if (AppEnvironment.current.useMock) {
      return ClinicInfoRemoteDatasourceMock();
    }
    final apiService = ref.read(apiServiceProvider);
    return ClinicInfoRemoteDatasourceImpl(apiService);
  },
);
