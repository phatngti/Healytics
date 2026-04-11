import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_openapi/api.dart';

import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
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
  Future<ClinicInfoEntity> getClinicInfo(
    String clinicId,
  );

  /// `GET /user/clinics/:id/products`
  Future<ClinicProductsData> getClinicProducts(
    String clinicId, {
    String? categoryId,
    ClinicProductSort sort,
    String? search,
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
}

// ─────────────────────────────────────────────────────
// Real implementation
// ─────────────────────────────────────────────────────

/// Calls the backend clinic endpoints and maps the
/// response DTOs to domain entities defensively.
class ClinicInfoRemoteDatasourceImpl
    implements ClinicInfoRemoteDatasource {
  const ClinicInfoRemoteDatasourceImpl(this._api);

  final UserClinicsApi _api;

  @override
  Future<ClinicInfoEntity> getClinicInfo(
    String clinicId,
  ) async {
    final dto = await _api
        .userClinicControllerGetClinicInfo(clinicId);
    if (dto == null) {
      throw ApiException(
        404,
        'Clinic info not found for $clinicId',
      );
    }
    return _mapClinicInfo(dto);
  }

  @override
  Future<ClinicProductsData> getClinicProducts(
    String clinicId, {
    String? categoryId,
    ClinicProductSort sort = ClinicProductSort.popular,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final dto = await _api
        .userClinicControllerGetClinicProducts(
      clinicId,
      sort: sort.toApiValue(),
      search: search,
      page: page,
      limit: limit,
    );
    if (dto == null) {
      throw ApiException(
        404,
        'Clinic products not found for $clinicId',
      );
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
    final dto = await _api
        .userClinicControllerGetClinicReviews(
      clinicId,
      page: page,
      limit: limit,
      starCount: starCount,
      hasMedia: hasMedia,
    );
    if (dto == null) {
      throw ApiException(
        404,
        'Clinic reviews not found for $clinicId',
      );
    }
    return _mapReviews(dto);
  }

  // ── Clinic Info Mapping ───────────────────────────

  ClinicInfoEntity _mapClinicInfo(
    ClinicInfoResponseDto dto,
  ) {
    return ClinicInfoEntity(
      id: dto.id,
      name: dto.name,
      coverImageUrl: dto.coverImageUrl?.toString(),
      logoImageUrl: dto.logoImageUrl?.toString(),
      gallery: dto.gallery,
      followersLabel: dto.followersLabel,
      reviewsLabel: dto.reviewsLabel,
      description: dto.description?.toString(),
      address: dto.address?.toString(),
      phoneNumber: dto.phoneNumber?.toString(),
      trustMetrics: _mapTrustMetrics(dto.trustMetrics),
      certifications: dto.certifications
          .map(_mapCertification)
          .toList(),
      specialists: dto.specialists
          .map(_mapSpecialist)
          .toList(),
      businessTypes: dto.businessTypes,
      facilityImages: dto.gallery
          .map(
            (url) => ClinicFacilityImage(
              imageUrl: url,
              label: '',
            ),
          )
          .toList(),
    );
  }

  ClinicTrustMetrics _mapTrustMetrics(
    ClinicTrustMetricsDto dto,
  ) {
    return ClinicTrustMetrics(
      rating: dto.rating.toDouble(),
      reviewCount: dto.reviewCount.toInt(),
      experienceLabel: dto.experienceLabel,
      clientsLabel: dto.clientsLabel,
    );
  }

  ClinicCertification _mapCertification(
    ClinicCertificationDto dto,
  ) {
    return ClinicCertification(
      title: dto.title,
      subtitle: dto.subtitle?.toString() ?? '',
      iconName: dto.iconName,
    );
  }

  ClinicSpecialistPreview _mapSpecialist(
    ClinicSpecialistPreviewDto dto,
  ) {
    return ClinicSpecialistPreview(
      id: dto.id,
      name: dto.name,
      role: dto.role,
      imageUrl: dto.imageUrl?.toString(),
      experienceLabel:
          dto.experienceLabel?.toString(),
    );
  }

  // ── Products Mapping ──────────────────────────────

  ClinicProductsData _mapProducts(
    ClinicProductsResponseDto dto,
  ) {
    return ClinicProductsData(
      categories: const [],
      products: dto.products
          .map(_mapProduct)
          .toList(),
      totalCount: dto.totalCount.toInt(),
      hasMore: dto.hasMore,
    );
  }

  ClinicProductEntity _mapProduct(
    ClinicProductDto dto,
  ) {
    return ClinicProductEntity(
      id: dto.id,
      title: dto.title,
      imageUrl: dto.imageUrl?.toString(),
      price: dto.price,
      priceAmount: dto.priceAmount.toDouble(),
      originalPrice:
          dto.originalPrice?.toString(),
      discountLabel:
          dto.discountLabel?.toString(),
      badgeLabel: dto.badgeLabel?.toString(),
      durationLabel:
          dto.durationLabel?.toString(),
      specialistLabel:
          dto.specialistLabel?.toString(),
      categoryId: dto.categoryId,
      soldCount: dto.soldCount.toInt(),
      createdAtMs: dto.createdAtMs.toInt(),
    );
  }

  // ── Reviews Mapping ───────────────────────────────

  ClinicReviewsData _mapReviews(
    ClinicReviewsResponseDto dto,
  ) {
    return ClinicReviewsData(
      summary: _mapReviewSummary(dto.summary),
      filters: dto.filters
          .map(_mapReviewFilter)
          .toList(),
      reviews: dto.reviews
          .map(_mapReview)
          .toList(),
      totalCount: dto.totalCount.toInt(),
      hasMore: dto.hasMore,
    );
  }

  ClinicReviewSummary _mapReviewSummary(
    ClinicReviewSummaryDto dto,
  ) {
    return ClinicReviewSummary(
      averageRating: dto.averageRating.toDouble(),
      totalReviewCount:
          dto.totalReviewCount.toInt(),
      ratingLabel: dto.ratingLabel,
      starDistribution:
          _parseStarDistribution(
        dto.starDistribution,
      ),
    );
  }

  /// Defensively parses the star distribution from
  /// the API's `Object` type to `Map<int, double>`.
  Map<int, double> _parseStarDistribution(
    Object raw,
  ) {
    final result = <int, double>{
      5: 0,
      4: 0,
      3: 0,
      2: 0,
      1: 0,
    };
    try {
      if (raw is Map) {
        for (final entry in raw.entries) {
          final star = int.tryParse(
            entry.key.toString(),
          );
          final value = double.tryParse(
            entry.value.toString(),
          );
          if (star != null && value != null) {
            result[star] = value;
          }
        }
      }
    } catch (e) {
      log(
        'Failed to parse starDistribution: $e',
        name: 'ClinicInfoDatasource',
      );
    }
    return result;
  }

  ClinicReviewFilter _mapReviewFilter(
    ClinicReviewFilterDto dto,
  ) {
    return ClinicReviewFilter(
      id: dto.id,
      label: dto.label,
      starCount: int.tryParse(
        dto.starCount?.toString() ?? '',
      ),
      requiresMedia: dto.requiresMedia,
    );
  }

  ClinicReviewEntity _mapReview(
    ClinicReviewDto dto,
  ) {
    return ClinicReviewEntity(
      id: dto.id,
      reviewerName: dto.reviewerName,
      reviewerInitial: dto.reviewerInitial,
      starCount: dto.starCount.toInt(),
      memberBadge:
          dto.memberBadge?.toString(),
      dateLabel: dto.dateLabel,
      serviceName:
          dto.serviceName?.toString(),
      serviceIcon:
          dto.serviceIcon?.toString(),
      reviewText: dto.reviewText,
      mediaUrls: dto.mediaUrls,
      clinicResponse: _mapClinicResponse(
        dto.clinicResponse,
      ),
    );
  }

  ClinicReviewResponse? _mapClinicResponse(
    ClinicReviewResponseSubDto? dto,
  ) {
    if (dto == null) return null;
    final text = dto.responseText?.toString();
    if (text == null || text.isEmpty) return null;
    return ClinicReviewResponse(
      responseText: text,
    );
  }
}

// ─────────────────────────────────────────────────────
// Mock implementation
// ─────────────────────────────────────────────────────

/// Returns fake data after a simulated network delay.
class ClinicInfoRemoteDatasourceMock
    implements ClinicInfoRemoteDatasource {
  @override
  Future<ClinicInfoEntity> getClinicInfo(
    String clinicId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return kMockClinicInfoMap[clinicId] ??
        kMockClinicInfo;
  }

  @override
  Future<ClinicProductsData> getClinicProducts(
    String clinicId, {
    String? categoryId,
    ClinicProductSort sort =
        ClinicProductSort.popular,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    var items = kMockClinicProducts.toList();

    // -- Category filter --
    if (categoryId != null && categoryId != 'all') {
      items = items
          .where((p) => p.categoryId == categoryId)
          .toList();
    }

    // -- Search filter --
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      items = items
          .where(
            (p) => p.title
                .toLowerCase()
                .contains(q),
          )
          .toList();
    }

    // -- Sort --
    switch (sort) {
      case ClinicProductSort.latest:
        items.sort(
          (a, b) => b.createdAtMs
              .compareTo(a.createdAtMs),
        );
      case ClinicProductSort.topSales:
        items.sort(
          (a, b) => b.soldCount
              .compareTo(a.soldCount),
        );
      case ClinicProductSort.priceAsc:
        items.sort(
          (a, b) => a.priceAmount
              .compareTo(b.priceAmount),
        );
      case ClinicProductSort.priceDesc:
        items.sort(
          (a, b) => b.priceAmount
              .compareTo(a.priceAmount),
        );
      case ClinicProductSort.popular:
        break; // keep default order
    }

    // -- Paginate --
    final total = items.length;
    final start = (page - 1) * limit;
    final end = start + limit;
    final paged = start < total
        ? items.sublist(
            start,
            end > total ? total : end,
          )
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
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    var all = kMockClinicReviews.toList();

    // -- Server-side-like filtering --
    if (starCount != null) {
      all = all
          .where((r) => r.starCount == starCount)
          .toList();
    }
    if (hasMedia == true) {
      all = all.where((r) => r.hasMedia).toList();
    }

    final start = (page - 1) * limit;
    final end = start + limit;
    final paged = start < all.length
        ? all.sublist(
            start,
            end > all.length ? all.length : end,
          )
        : <ClinicReviewEntity>[];

    return ClinicReviewsData(
      summary: kMockClinicReviewSummary,
      filters: kMockClinicReviewFilters,
      reviews: paged,
      totalCount: all.length,
      hasMore: end < all.length,
    );
  }
}

// ─────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final clinicInfoRemoteDatasourceProvider =
    Provider<ClinicInfoRemoteDatasource>(
  (ref) {
    if (AppEnvironment.current.useMock) {
      return ClinicInfoRemoteDatasourceMock();
    }
    final apiService = ref.read(apiServiceProvider);
    return ClinicInfoRemoteDatasourceImpl(
      apiService.userClinicsApi,
    );
  },
);
