import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/features/home/data/provider/home.provider.dart';
import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/domain/repositories/home.repository.dart';
import 'package:user_app/features/home/presentation/providers/list_filter.provider.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';

part 'home.provider.g.dart';

const _premiumTreatmentPageSize = 12;
const _premiumTreatmentPreviewSize = 4;
const _loadMoreErrorNotChanged = Object();

class PremiumTreatmentsAccumulated {
  const PremiumTreatmentsAccumulated({
    required this.products,
    required this.hasMore,
    required this.offset,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<HomeProduct> products;
  final bool hasMore;
  final int offset;
  final bool isLoadingMore;
  final Object? loadMoreError;

  PremiumTreatmentsAccumulated copyWith({
    List<HomeProduct>? products,
    bool? hasMore,
    int? offset,
    bool? isLoadingMore,
    Object? loadMoreError = _loadMoreErrorNotChanged,
  }) {
    return PremiumTreatmentsAccumulated(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: identical(loadMoreError, _loadMoreErrorNotChanged)
          ? this.loadMoreError
          : loadMoreError,
    );
  }
}

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
  final filter = ref.watch(premiumTreatmentFilterProvider);
  return repository.getPremiumTreatments(filter: filter);
}

/// Accumulates the full Premium Treatments screen as pages are loaded.
@riverpod
class PremiumTreatmentsPaginated extends _$PremiumTreatmentsPaginated {
  int _loadMoreGeneration = 0;

  @override
  Future<PremiumTreatmentsAccumulated> build() async {
    _loadMoreGeneration++;
    final repository = ref.read(homeRepositoryProvider);
    final filter = ref.watch(premiumTreatmentFilterProvider);
    final products = await _fetchPage(repository, filter, offset: 0);

    return PremiumTreatmentsAccumulated(
      products: products.visible,
      hasMore: products.hasMore,
      offset: products.visible.length,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );

    final repository = ref.read(homeRepositoryProvider);
    final filter = ref.read(premiumTreatmentFilterProvider);
    final generation = ++_loadMoreGeneration;
    try {
      final products = await _fetchPage(
        repository,
        filter,
        offset: current.offset,
      );
      if (generation != _loadMoreGeneration) return;

      final nextProducts = [...current.products, ...products.visible];
      state = AsyncData(
        current.copyWith(
          products: nextProducts,
          hasMore: products.hasMore,
          offset: nextProducts.length,
          isLoadingMore: false,
          loadMoreError: null,
        ),
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to load more premium treatments',
        name: 'PremiumTreatmentsPaginated',
        error: error,
        stackTrace: stackTrace,
      );
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }

  Future<_PremiumTreatmentPage> _fetchPage(
    HomeRepository repository,
    ServiceListFilter filter, {
    required int offset,
  }) async {
    final products = await repository.getPremiumTreatments(
      filter: filter,
      limit: _premiumTreatmentPageSize + 1,
      offset: offset,
    );

    return _PremiumTreatmentPage(
      visible: products.take(_premiumTreatmentPageSize).toList(),
      hasMore: products.length > _premiumTreatmentPageSize,
    );
  }
}

class _PremiumTreatmentPage {
  const _PremiumTreatmentPage({required this.visible, required this.hasMore});

  final List<HomeProduct> visible;
  final bool hasMore;
}

/// Accumulates premium treatment cards directly on the Home screen.
///
/// This stays separate from the filter-aware full Premium Treatments screen.
@riverpod
class HomePremiumTreatmentsPaginated extends _$HomePremiumTreatmentsPaginated {
  int _loadMoreGeneration = 0;

  @override
  Future<PremiumTreatmentsAccumulated> build() async {
    _loadMoreGeneration++;
    final repository = ref.read(homeRepositoryProvider);
    final products = await _fetchPage(repository, offset: 0);

    return PremiumTreatmentsAccumulated(
      products: products.visible,
      hasMore: products.hasMore,
      offset: products.visible.length,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );

    final repository = ref.read(homeRepositoryProvider);
    final generation = ++_loadMoreGeneration;
    try {
      final products = await _fetchPage(repository, offset: current.offset);
      if (generation != _loadMoreGeneration) return;

      final nextProducts = [...current.products, ...products.visible];
      state = AsyncData(
        current.copyWith(
          products: nextProducts,
          hasMore: products.hasMore,
          offset: nextProducts.length,
          isLoadingMore: false,
          loadMoreError: null,
        ),
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to load more home premium treatments',
        name: 'HomePremiumTreatmentsPaginated',
        error: error,
        stackTrace: stackTrace,
      );
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }

  Future<_PremiumTreatmentPage> _fetchPage(
    HomeRepository repository, {
    required int offset,
  }) async {
    final products = await repository.getPremiumTreatments(
      limit: _premiumTreatmentPreviewSize + 1,
      offset: offset,
    );

    return _PremiumTreatmentPage(
      visible: products.take(_premiumTreatmentPreviewSize).toList(),
      hasMore: products.length > _premiumTreatmentPreviewSize,
    );
  }
}

/// Provider for the home preview of premium treatments.
///
/// The home dashboard should not inherit filters from the full
/// Premium Treatments list screen.
@riverpod
Future<List<HomeProduct>> premiumTreatmentPreview(Ref ref) async {
  final repository = ref.read(homeRepositoryProvider);
  final products = await repository.getPremiumTreatments(
    limit: _premiumTreatmentPreviewSize,
  );
  return products.take(_premiumTreatmentPreviewSize).toList(growable: false);
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
  final filter = ref.watch(recentActivityFilterProvider);
  return repository.getRecentActivity(limit: 20, filter: filter);
}
