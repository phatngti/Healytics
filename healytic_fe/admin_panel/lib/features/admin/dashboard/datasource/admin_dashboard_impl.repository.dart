import 'package:admin_panel/features/admin/dashboard/datasource/admin_dashboard_remote.datasource.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_booking_outcome.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_category_health.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_notification.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_overview.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_partner_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_repository.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_revenue_trend_point.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_service_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_transaction_health.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_dashboard_impl.repository.g.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  AdminDashboardRepositoryImpl({required this.dataSource});

  final AdminDashboardRemoteDataSource dataSource;

  @override
  Future<AdminCategoryHealth> getCategoryHealth() =>
      dataSource.getCategoryHealth();

  @override
  Future<AdminDashboardBookingOutcomeSummary> getBookingOutcomeSummary(
    AdminDashboardPeriod period,
  ) => dataSource.getBookingOutcomeSummary(period);

  @override
  Future<List<AdminDashboardNotificationItem>> getNotifications() =>
      dataSource.getNotifications();

  @override
  Future<AdminDashboardOverview> getOverview(AdminDashboardPeriod period) =>
      dataSource.getOverview(period);

  @override
  Future<List<AdminPartnerRankingItem>> getTopPartners(
    AdminDashboardPeriod period,
  ) => dataSource.getTopPartners(period);

  @override
  Future<List<AdminDashboardRevenueTrendPoint>> getRevenueTrend(
    AdminDashboardPeriod period,
  ) => dataSource.getRevenueTrend(period);

  @override
  Future<List<AdminServiceRankingItem>> getTopServices(
    AdminDashboardPeriod period,
  ) => dataSource.getTopServices(period);

  @override
  Future<AdminDashboardTransactionHealth> getTransactionHealth(
    AdminDashboardPeriod period,
  ) => dataSource.getTransactionHealth(period);
}

@riverpod
AdminDashboardRepository adminDashboardRepository(Ref ref) {
  final dataSource = ref.read(adminDashboardRemoteDataSourceProvider);
  return AdminDashboardRepositoryImpl(dataSource: dataSource);
}
