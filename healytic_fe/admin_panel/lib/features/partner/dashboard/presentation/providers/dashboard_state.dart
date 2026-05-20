import 'package:admin_panel/features/partner/dashboard/domain/dashboard_notification.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_stats.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/dashboard/domain/employee_distribution.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/inventory_alert.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/revenue_data_point.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/service_performance.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/staff_schedule.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/upcoming_appointment.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_review.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

/// Freezed state class for the dashboard screen.
///
/// Contains all data needed to render every dashboard
/// section. Managed by [DashboardNotifier].
@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required DashboardStats stats,
    required List<RevenueDataPoint> revenueData,
    required List<UpcomingAppointment> upcomingAppointments,
    required List<ServicePerformance> servicePerformance,
    required List<EmployeeDistribution> employeeDistribution,
    required List<DashboardReview> recentReviews,
    required List<StaffScheduleEntry> staffSchedule,
    required List<DashboardNotification> notifications,
    required List<InventoryAlert> inventoryAlerts,
    @Default(DashboardTimePeriod.thisMonth) DashboardTimePeriod selectedPeriod,
    @Default(false) bool isRefreshing,
  }) = _DashboardState;
}
