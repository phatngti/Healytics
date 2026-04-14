import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_booking_outcome.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_category_health.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_notification.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_overview.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_partner_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_revenue_trend_point.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_service_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_transaction_health.entity.dart';

abstract class AdminDashboardRepository {
  Future<AdminDashboardOverview> getOverview(AdminDashboardPeriod period);

  Future<List<AdminDashboardRevenueTrendPoint>> getRevenueTrend(
    AdminDashboardPeriod period,
  );

  Future<AdminDashboardBookingOutcomeSummary> getBookingOutcomeSummary(
    AdminDashboardPeriod period,
  );

  Future<AdminDashboardTransactionHealth> getTransactionHealth(
    AdminDashboardPeriod period,
  );

  Future<List<AdminPartnerRankingItem>> getTopPartners(
    AdminDashboardPeriod period,
  );

  Future<List<AdminServiceRankingItem>> getTopServices(
    AdminDashboardPeriod period,
  );

  Future<List<AdminDashboardNotificationItem>> getNotifications();

  Future<AdminCategoryHealth> getCategoryHealth();
}
