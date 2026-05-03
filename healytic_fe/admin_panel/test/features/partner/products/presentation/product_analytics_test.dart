import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_status_badge.widget.dart';
import 'package:admin_panel/features/partner/products/data/product_analytics_impl.repository.dart';
import 'package:admin_panel/features/partner/products/data/product_analytics_remote.datasource.dart';
import 'package:admin_panel/features/partner/products/data/data/product_mock_data.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product_analytics.entity.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product_analytics.provider.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_analytics/product_detail_analytics.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_analytics/product_overview_analytics.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('Product analytics providers', () {
    late ProviderContainer container;

    setUp(() {
      final repository = ProductAnalyticsRepositoryImpl(
        remoteDataSource: ProductAnalyticsRemoteDataSourceMock(),
      );

      container = ProviderContainer(
        overrides: [
          productAnalyticsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
    });

    test('loads overview analytics and keeps data on period switch', () async {
      final subscription = container.listen(
        productOverviewAnalyticsProvider,
        (_, __) {},
      );
      addTearDown(subscription.close);

      final initial = await container.read(
        productOverviewAnalyticsProvider.future,
      );

      expect(initial, isNotNull);
      expect(initial.analytics.totalProducts, greaterThan(0));
      expect(initial.analytics.bookingMetrics.totalBookings, greaterThan(0));
      expect(initial.analytics.bookingMetrics.delayThresholdMinutes, 15);
      expect(initial.analytics.bookingMetrics.delayedBookings, greaterThan(0));
      expect(
        initial.analytics.bookingMetrics.statusBreakdown.map(
          (item) => item.statusKey,
        ),
        everyElement(
          isIn(<String>['confirmed', 'cancelled', 'no_show', 'rescheduled']),
        ),
      );
      expect(initial.selectedPeriod.name, 'thisMonth');

      await container
          .read(productOverviewAnalyticsProvider.notifier)
          .setTimePeriod(DashboardTimePeriod.thisQuarter);

      final updated = await container.read(
        productOverviewAnalyticsProvider.future,
      );

      expect(updated, isNotNull);
      expect(updated.selectedPeriod, DashboardTimePeriod.thisQuarter);
      expect(updated.analytics.revenue, greaterThan(initial.analytics.revenue));
    });

    test('normalizes booking status metrics into supported order', () {
      final metrics = normalizeProductBookingStatusMetrics([
        const ProductBookingStatusMetric(
          statusKey: 'unknown',
          label: 'Unknown',
          count: 7,
          tone: AnalyticsStatusTone.neutral,
        ),
        const ProductBookingStatusMetric(
          statusKey: 'rescheduled',
          label: 'Rescheduled',
          count: 2,
          tone: AnalyticsStatusTone.warning,
        ),
        const ProductBookingStatusMetric(
          statusKey: 'confirmed',
          label: 'Confirmed',
          count: 12,
          tone: AnalyticsStatusTone.positive,
        ),
        const ProductBookingStatusMetric(
          statusKey: 'cancelled',
          label: 'Cancelled',
          count: 1,
          tone: AnalyticsStatusTone.critical,
        ),
        const ProductBookingStatusMetric(
          statusKey: 'no_show',
          label: 'No-show',
          count: 0,
          tone: AnalyticsStatusTone.critical,
        ),
      ]);

      expect(metrics.map((item) => item.statusKey).toList(), <String>[
        'confirmed',
        'cancelled',
        'rescheduled',
      ]);
    });
  });

  group('Product analytics widgets', () {
    testWidgets('renders overview analytics spotlight cards', (tester) async {
      final repository = ProductAnalyticsRepositoryImpl(
        remoteDataSource: ProductAnalyticsRemoteDataSourceMock(),
      );

      await tester.binding.setSurfaceSize(const Size(720, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productAnalyticsRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ProductOverviewAnalyticsSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Service Performance'), findsOneWidget);
      expect(find.text('Category and service leaders'), findsOneWidget);
      expect(find.text('Top services'), findsOneWidget);
      expect(find.text('Category strength'), findsOneWidget);
      expect(find.byKey(const ValueKey('top-services-grid')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('category-strength-grid')),
        findsOneWidget,
      );
      expect(find.text('Facial Treatment Deluxe'), findsOneWidget);
      expect(find.text('Hot Stone Therapy'), findsOneWidget);
      expect(find.text('Massage Therapy'), findsWidgets);
      expect(find.text('Skincare'), findsWidgets);
      expect(find.text('Booking operations'), findsOneWidget);
      expect(find.text('Total bookings'), findsOneWidget);
      expect(find.text('Delayed'), findsOneWidget);
      expect(find.text('Over 15 min'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Booking status'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('Product Management'), findsNothing);
      expect(tester.takeException(), isNull);

      final firstCardOffset = tester.getTopLeft(
        find.text('Facial Treatment Deluxe'),
      );
      final secondCardOffset = tester.getTopLeft(
        find.text('Hot Stone Therapy'),
      );

      expect(secondCardOffset.dy, greaterThan(firstCardOffset.dy));

      await tester.binding.setSurfaceSize(const Size(1900, 1600));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final wideFirstCardOffset = tester.getTopLeft(
        find.text('Facial Treatment Deluxe'),
      );
      final wideSecondCardOffset = tester.getTopLeft(
        find.text('Hot Stone Therapy'),
      );

      expect(
        (wideSecondCardOffset.dy - wideFirstCardOffset.dy).abs(),
        lessThan(4),
      );
      expect(wideSecondCardOffset.dx, greaterThan(wideFirstCardOffset.dx));
    });

    testWidgets('renders repeated trend week labels once', (tester) async {
      final repository = ProductAnalyticsRepositoryImpl(
        remoteDataSource: _RepeatedTrendLabelsDataSource(),
      );

      await tester.binding.setSurfaceSize(const Size(1900, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productAnalyticsRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ProductOverviewAnalyticsSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Wk 1'), findsOneWidget);
      expect(find.text('Wk 2'), findsOneWidget);
      expect(find.text('Wk 3'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders detail analytics without blocking product content', (
      tester,
    ) async {
      final repository = ProductAnalyticsRepositoryImpl(
        remoteDataSource: ProductAnalyticsRemoteDataSourceMock(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productAnalyticsRepositoryProvider.overrideWithValue(repository),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ProductDetailAnalyticsSection(
                  product: productMockDefault,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Performance Insights'), findsOneWidget);
      expect(find.text('Operational readiness'), findsOneWidget);
    });
  });
}

class _RepeatedTrendLabelsDataSource
    implements ProductAnalyticsRemoteDataSource {
  @override
  Future<ProductOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  }) async {
    return const ProductOverviewAnalytics(
      totalProducts: 3,
      activeProducts: 3,
      bookingMetrics: ProductBookingMetricsSummary(
        totalBookings: 12,
        delayedBookings: 1,
        delayThresholdMinutes: 15,
        pendingBookings: 2,
        completedBookings: 10,
        statusBreakdown: [
          ProductBookingStatusMetric(
            statusKey: 'confirmed',
            label: 'Confirmed',
            count: 8,
            tone: AnalyticsStatusTone.positive,
          ),
          ProductBookingStatusMetric(
            statusKey: 'cancelled',
            label: 'Cancelled',
            count: 1,
            tone: AnalyticsStatusTone.critical,
          ),
        ],
        alerts: [],
      ),
      bookings: 12,
      bookingsDelta: 0,
      revenue: 1200000,
      revenueDelta: 0,
      averageRating: 4.8,
      ratingDelta: 0,
      reviewCount: 12,
      trendPoints: [
        ProductTrendPoint(label: 'Wk 1', bookings: 2, revenue: 200000),
        ProductTrendPoint(label: 'Wk 1', bookings: 3, revenue: 300000),
        ProductTrendPoint(label: 'Wk 2', bookings: 1, revenue: 100000),
        ProductTrendPoint(label: 'Wk 2', bookings: 4, revenue: 400000),
        ProductTrendPoint(label: 'Wk 3', bookings: 2, revenue: 200000),
      ],
      categoryPerformance: [
        ProductCategoryPerformance(
          categoryName: 'Massage',
          bookings: 8,
          revenue: 800000,
          averageRating: 4.8,
        ),
      ],
      topServices: [
        ProductServicePerformance(
          name: 'Recovery Massage',
          categoryName: 'Massage',
          bookings: 8,
          revenue: 800000,
          averageRating: 4.8,
        ),
      ],
    );
  }

  @override
  Future<ProductDetailAnalytics> getDetailAnalytics({
    required ProductId productId,
    required DashboardTimePeriod period,
  }) {
    throw UnimplementedError();
  }
}
