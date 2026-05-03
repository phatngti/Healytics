import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_alert.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_booking_outcome.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_category_health.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_notification.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_overview.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_partner_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_revenue_trend_point.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_section.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_service_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_transaction_health.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_state.freezed.dart';

@freezed
abstract class AdminDashboardState with _$AdminDashboardState {
  const factory AdminDashboardState({
    @Default(AdminDashboardOverview()) AdminDashboardOverview overview,
    @Default([]) List<AdminDashboardRevenueTrendPoint> revenueTrend,
    @Default(AdminDashboardBookingOutcomeSummary())
    AdminDashboardBookingOutcomeSummary bookingOutcomes,
    @Default(AdminDashboardTransactionHealth())
    AdminDashboardTransactionHealth transactionHealth,
    @Default([]) List<AdminPartnerRankingItem> topPartners,
    @Default([]) List<AdminServiceRankingItem> topServices,
    @Default([]) List<AdminDashboardNotificationItem> notifications,
    @Default(AdminCategoryHealth()) AdminCategoryHealth categoryHealth,
    @Default([]) List<AdminDashboardAlert> alerts,
    @Default(AdminDashboardPeriod.thirtyDays)
    AdminDashboardPeriod selectedPeriod,
    @Default([]) List<AdminDashboardSection> failedSections,
    required DateTime lastUpdatedAt,
    @Default(false) bool isRefreshing,
  }) = _AdminDashboardState;
}
