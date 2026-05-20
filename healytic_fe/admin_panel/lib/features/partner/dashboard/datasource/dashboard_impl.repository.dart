import 'package:admin_panel/features/partner/dashboard/datasource/dashboard_remote.datasource.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard.repository.dart';
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

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_impl.repository.g.dart';

/// Concrete implementation of [DashboardRepository].
///
/// Delegates all operations to the remote data source.
class DashboardImplRepository implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardImplRepository({required this.remoteDataSource});

  @override
  Future<DashboardStats> getDashboardStats({DashboardTimePeriod? period}) =>
      remoteDataSource.getDashboardStats(period: period);

  @override
  Future<List<RevenueDataPoint>> getRevenueData(DashboardTimePeriod period) =>
      remoteDataSource.getRevenueData(period);

  @override
  Future<List<UpcomingAppointment>> getUpcomingAppointments({int limit = 5}) =>
      remoteDataSource.getUpcomingAppointments(limit: limit);

  @override
  Future<List<ServicePerformance>> getServicePerformance() =>
      remoteDataSource.getServicePerformance();

  @override
  Future<List<EmployeeDistribution>> getEmployeeDistribution() =>
      remoteDataSource.getEmployeeDistribution();

  @override
  Future<List<DashboardReview>> getRecentReviews({int limit = 5}) =>
      remoteDataSource.getRecentReviews(limit: limit);

  @override
  Future<List<StaffScheduleEntry>> getStaffSchedule(DateTime date) =>
      remoteDataSource.getStaffSchedule(date);

  @override
  Future<List<DashboardNotification>> getNotifications({int limit = 10}) =>
      remoteDataSource.getNotifications(limit: limit);

  @override
  Future<List<InventoryAlert>> getInventoryAlerts() =>
      remoteDataSource.getInventoryAlerts();
}

/// Provides a [DashboardRepository] instance with
/// the correct data source.
@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final remoteDataSource = ref.read(dashboardRemoteDataSourceProvider);
  return DashboardImplRepository(remoteDataSource: remoteDataSource);
}
