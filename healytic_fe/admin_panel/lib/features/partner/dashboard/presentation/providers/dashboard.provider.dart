import 'dart:developer' as developer;

import 'package:admin_panel/features/partner/dashboard/datasource/dashboard_impl.repository.dart';
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
import 'package:admin_panel/features/partner/dashboard/presentation/providers/dashboard_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard.provider.g.dart';

/// Manages the state for the partner dashboard
/// screen.
///
/// Fetches all dashboard data in parallel on
/// initialization and supports time period
/// switching for revenue charts and KPI refresh.
@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  FutureOr<DashboardState> build() => _fetchAll(DashboardTimePeriod.thisMonth);

  /// Fetches all 9 dashboard data sources with
  /// individual error isolation.
  ///
  /// Each call is wrapped so a single API failure
  /// (e.g. 401) won't crash the entire dashboard.
  Future<DashboardState> _fetchAll(DashboardTimePeriod period) async {
    final repo = ref.read(dashboardRepositoryProvider);

    // Run all calls in parallel; isolate failures.
    final results = await Future.wait([
      _safeCall(() => repo.getDashboardStats(period: period)),
      _safeCall(() => repo.getRevenueData(period)),
      _safeCall(() => repo.getUpcomingAppointments()),
      _safeCall(() => repo.getServicePerformance()),
      _safeCall(() => repo.getEmployeeDistribution()),
      _safeCall(() => repo.getRecentReviews()),
      _safeCall(() => repo.getStaffSchedule(DateTime.now())),
      _safeCall(() => repo.getNotifications()),
      _safeCall(() => repo.getInventoryAlerts()),
    ]);

    return DashboardState(
      stats: results[0] as DashboardStats? ?? _emptyStats,
      revenueData: results[1] as List<RevenueDataPoint>? ?? [],
      upcomingAppointments: results[2] as List<UpcomingAppointment>? ?? [],
      servicePerformance: results[3] as List<ServicePerformance>? ?? [],
      employeeDistribution: results[4] as List<EmployeeDistribution>? ?? [],
      recentReviews: results[5] as List<DashboardReview>? ?? [],
      staffSchedule: results[6] as List<StaffScheduleEntry>? ?? [],
      notifications: results[7] as List<DashboardNotification>? ?? [],
      inventoryAlerts: results[8] as List<InventoryAlert>? ?? [],
      selectedPeriod: period,
    );
  }

  /// Wraps an async call so failures return null
  /// instead of propagating.
  Future<T?> _safeCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e, st) {
      developer.log(
        'Dashboard data fetch failed',
        error: e,
        stackTrace: st,
        name: 'DashboardNotifier',
      );
      return null;
    }
  }

  /// Zeroed-out stats used as fallback when the
  /// stats API call fails.
  static const _emptyStats = DashboardStats(
    totalAppointments: 0,
    completedAppointments: 0,
    cancelledAppointments: 0,
    pendingAppointments: 0,
    totalRevenue: 0,
    revenueGrowthPercent: 0,
    totalServices: 0,
    activeServices: 0,
    totalEmployees: 0,
    activeEmployees: 0,
    averageRating: 0,
    totalReviews: 0,
  );

  /// Refreshes all dashboard data, keeping stale
  /// data visible during loading.
  Future<void> refresh() async {
    final previous = state.value;
    final period = previous?.selectedPeriod ?? DashboardTimePeriod.thisMonth;

    state = const AsyncLoading<DashboardState>().copyWithPrevious(state);

    state = await AsyncValue.guard(() => _fetchAll(period));
  }

  /// Changes the time period and re-fetches stats
  /// and revenue data.
  Future<void> setTimePeriod(DashboardTimePeriod period) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(selectedPeriod: period, isRefreshing: true),
    );

    try {
      final repo = ref.read(dashboardRepositoryProvider);
      final newStats = await _safeCall(
        () => repo.getDashboardStats(period: period),
      );
      final newRevenue = await _safeCall(() => repo.getRevenueData(period));

      state = AsyncData(
        current.copyWith(
          selectedPeriod: period,
          stats: newStats ?? current.stats,
          revenueData: newRevenue ?? current.revenueData,
          isRefreshing: false,
        ),
      );
    } catch (e, st) {
      developer.log(
        'Failed to switch period',
        error: e,
        stackTrace: st,
        name: 'DashboardNotifier',
      );
      // Keep old data on error, revert period
      state = AsyncData(current.copyWith(isRefreshing: false));
    }
  }
}
