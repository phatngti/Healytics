import 'package:admin_panel/features/partner/dashboard/domain/dashboard_notification.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_review.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_stats.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/dashboard/domain/employee_distribution.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/inventory_alert.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/revenue_data_point.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/service_performance.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/staff_schedule.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/upcoming_appointment.entity.dart';

/// Repository interface for all dashboard data
/// operations.
///
/// Implementations provide data from mock sources
/// or real backend APIs based on the mock flag.
abstract class DashboardRepository {
  /// Aggregated KPI statistics for [period].
  Future<DashboardStats> getDashboardStats({
    DashboardTimePeriod? period,
  });

  /// Revenue time-series data for chart rendering.
  Future<List<RevenueDataPoint>> getRevenueData(
    DashboardTimePeriod period,
  );

  /// Next upcoming appointments list.
  Future<List<UpcomingAppointment>>
      getUpcomingAppointments({int limit = 5});

  /// Service performance metrics for bar chart.
  Future<List<ServicePerformance>>
      getServicePerformance();

  /// Employee role/status distribution for donut
  /// chart.
  Future<List<EmployeeDistribution>>
      getEmployeeDistribution();

  /// Recent customer reviews.
  Future<List<DashboardReview>> getRecentReviews({
    int limit = 5,
  });

  /// Staff schedule entries for calendar grid.
  Future<List<StaffScheduleEntry>> getStaffSchedule(
    DateTime date,
  );

  /// Dashboard notifications.
  Future<List<DashboardNotification>>
      getNotifications({int limit = 10});

  /// Active inventory alerts.
  Future<List<InventoryAlert>> getInventoryAlerts();
}
