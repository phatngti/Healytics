import 'dart:developer' as developer;

import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/products/data/product_analytics_impl.repository.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product_analytics.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_analytics.provider.freezed.dart';
part 'product_analytics.provider.g.dart';

@freezed
abstract class ProductOverviewAnalyticsState
    with _$ProductOverviewAnalyticsState {
  const factory ProductOverviewAnalyticsState({
    required ProductOverviewAnalytics analytics,
    @Default(DashboardTimePeriod.thisMonth) DashboardTimePeriod selectedPeriod,
    @Default(false) bool isRefreshing,
  }) = _ProductOverviewAnalyticsState;
}

@freezed
abstract class ProductDetailAnalyticsState with _$ProductDetailAnalyticsState {
  const factory ProductDetailAnalyticsState({
    required ProductDetailAnalytics analytics,
    @Default(DashboardTimePeriod.thisMonth) DashboardTimePeriod selectedPeriod,
    @Default(false) bool isRefreshing,
  }) = _ProductDetailAnalyticsState;
}

@riverpod
class ProductOverviewAnalyticsNotifier
    extends _$ProductOverviewAnalyticsNotifier {
  @override
  FutureOr<ProductOverviewAnalyticsState> build() async {
    final analytics = await ref
        .read(productAnalyticsRepositoryProvider)
        .getOverviewAnalytics(period: DashboardTimePeriod.thisMonth);

    return ProductOverviewAnalyticsState(analytics: analytics);
  }

  Future<void> refresh() async {
    final previous = state.value;
    final period = previous?.selectedPeriod ?? DashboardTimePeriod.thisMonth;

    if (previous != null) {
      state = AsyncData(previous.copyWith(isRefreshing: true));
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() async {
      final analytics = await ref
          .read(productAnalyticsRepositoryProvider)
          .getOverviewAnalytics(period: period);
      return ProductOverviewAnalyticsState(
        analytics: analytics,
        selectedPeriod: period,
      );
    });
  }

  Future<void> setTimePeriod(DashboardTimePeriod period) async {
    final current = state.value;
    if (current == null || current.selectedPeriod == period) {
      return;
    }

    state = AsyncData(
      current.copyWith(selectedPeriod: period, isRefreshing: true),
    );

    try {
      final analytics = await ref
          .read(productAnalyticsRepositoryProvider)
          .getOverviewAnalytics(period: period);

      state = AsyncData(
        current.copyWith(
          analytics: analytics,
          selectedPeriod: period,
          isRefreshing: false,
        ),
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to load product overview analytics',
        error: error,
        stackTrace: stackTrace,
        name: 'ProductOverviewAnalyticsNotifier',
      );
      state = AsyncData(current.copyWith(isRefreshing: false));
    }
  }
}

@riverpod
class ProductDetailAnalyticsNotifier extends _$ProductDetailAnalyticsNotifier {
  @override
  FutureOr<ProductDetailAnalyticsState> build(String productId) async {
    final analytics = await ref
        .read(productAnalyticsRepositoryProvider)
        .getDetailAnalytics(
          productId: ProductId(productId),
          period: DashboardTimePeriod.thisMonth,
        );

    return ProductDetailAnalyticsState(analytics: analytics);
  }

  Future<void> refresh() async {
    final previous = state.value;
    if (previous == null) {
      return;
    }

    state = AsyncData(previous.copyWith(isRefreshing: true));
    state = await AsyncValue.guard(() async {
      final analytics = await ref
          .read(productAnalyticsRepositoryProvider)
          .getDetailAnalytics(
            productId: ProductId(productId),
            period: previous.selectedPeriod,
          );

      return ProductDetailAnalyticsState(
        analytics: analytics,
        selectedPeriod: previous.selectedPeriod,
      );
    });
  }

  Future<void> setTimePeriod(DashboardTimePeriod period) async {
    final current = state.value;
    if (current == null || current.selectedPeriod == period) {
      return;
    }

    state = AsyncData(
      current.copyWith(selectedPeriod: period, isRefreshing: true),
    );

    try {
      final analytics = await ref
          .read(productAnalyticsRepositoryProvider)
          .getDetailAnalytics(productId: ProductId(productId), period: period);

      state = AsyncData(
        current.copyWith(
          analytics: analytics,
          selectedPeriod: period,
          isRefreshing: false,
        ),
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to load product detail analytics',
        error: error,
        stackTrace: stackTrace,
        name: 'ProductDetailAnalyticsNotifier',
      );
      state = AsyncData(current.copyWith(isRefreshing: false));
    }
  }
}
