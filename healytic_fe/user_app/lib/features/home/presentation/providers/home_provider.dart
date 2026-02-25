import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/domain/repositories/home.repository.dart';

// State class for Home Page
class HomeState {
  final bool isLoading;
  final String? error;
  final List<HomeCategory> categories;
  final List<HomeProduct> recommendedProducts;
  final List<HomeProduct> premiumProducts;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.categories = const [],
    this.recommendedProducts = const [],
    this.premiumProducts = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    List<HomeCategory>? categories,
    List<HomeProduct>? recommendedProducts,
    List<HomeProduct>? premiumProducts,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      categories: categories ?? this.categories,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      premiumProducts: premiumProducts ?? this.premiumProducts,
    );
  }
}

// Notifier to manage API calls and state
class HomeNotifier extends Notifier<HomeState> {
  late final HomeRepository _repository;

  @override
  HomeState build() {
    _repository = ref.read(homeRepositoryProvider);
    // Fetch data immediately upon creation
    Future.microtask(() => refreshData());
    return const HomeState();
  }

  Future<void> refreshData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Run fetches in parallel
      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getProducts(),
      ]);

      final categories = results[0] as List<HomeCategory>;
      final products = results[1] as List<HomeProduct>;

      // Filter products based on type
      final premium = products.where((p) => p.type == 'service').toList();
      var recommended = products.where((p) => p.type != 'service').toList();
      if (recommended.isEmpty && premium.isNotEmpty) {
        recommended = premium.take(4).toList();
      }

      state = state.copyWith(
        isLoading: false,
        categories: categories,
        recommendedProducts: recommended,
        premiumProducts: premium,
      );
    } catch (e, st) {
      debugPrint('Error loading home data: $e\n$st');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load data. Please try again.',
      );
    }
  }
}

// Provider definition
final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
