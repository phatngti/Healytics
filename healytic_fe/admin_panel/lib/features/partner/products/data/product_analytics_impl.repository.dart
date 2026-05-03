import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/products/data/product_analytics_remote.datasource.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product_analytics.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product_analytics.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_analytics_impl.repository.g.dart';

class ProductAnalyticsRepositoryImpl implements ProductAnalyticsRepository {
  ProductAnalyticsRepositoryImpl({required this.remoteDataSource});

  final ProductAnalyticsRemoteDataSource remoteDataSource;

  @override
  Future<ProductOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  }) {
    return remoteDataSource.getOverviewAnalytics(period: period);
  }

  @override
  Future<ProductDetailAnalytics> getDetailAnalytics({
    required ProductId productId,
    required DashboardTimePeriod period,
  }) {
    return remoteDataSource.getDetailAnalytics(
      productId: productId,
      period: period,
    );
  }
}

@riverpod
ProductAnalyticsRepository productAnalyticsRepository(Ref ref) {
  final remoteDataSource = ref.read(productAnalyticsRemoteDataSourceProvider);
  return ProductAnalyticsRepositoryImpl(remoteDataSource: remoteDataSource);
}
