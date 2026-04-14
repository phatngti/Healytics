import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product_analytics.entity.dart';

/// Repository for product analytics read models.
abstract class ProductAnalyticsRepository {
  Future<ProductOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  });

  Future<ProductDetailAnalytics> getDetailAnalytics({
    required ProductId productId,
    required DashboardTimePeriod period,
  });
}
