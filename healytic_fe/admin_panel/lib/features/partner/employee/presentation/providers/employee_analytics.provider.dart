import 'dart:developer' as developer;

import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/employee/data/employee_analytics_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_analytics.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_analytics.provider.freezed.dart';
part 'employee_analytics.provider.g.dart';

@freezed
abstract class EmployeeOverviewAnalyticsState
    with _$EmployeeOverviewAnalyticsState {
  const factory EmployeeOverviewAnalyticsState({
    required EmployeeOverviewAnalytics analytics,
    @Default(DashboardTimePeriod.thisMonth) DashboardTimePeriod selectedPeriod,
    @Default(false) bool isRefreshing,
  }) = _EmployeeOverviewAnalyticsState;
}

@freezed
abstract class EmployeeDetailAnalyticsState
    with _$EmployeeDetailAnalyticsState {
  const factory EmployeeDetailAnalyticsState({
    required EmployeeDetailAnalytics analytics,
    @Default(DashboardTimePeriod.thisMonth) DashboardTimePeriod selectedPeriod,
    @Default(false) bool isRefreshing,
  }) = _EmployeeDetailAnalyticsState;
}

@riverpod
class EmployeeOverviewAnalyticsNotifier
    extends _$EmployeeOverviewAnalyticsNotifier {
  @override
  FutureOr<EmployeeOverviewAnalyticsState> build() async {
    final analytics = await ref
        .read(employeeAnalyticsRepositoryProvider)
        .getOverviewAnalytics(period: DashboardTimePeriod.thisMonth);

    return EmployeeOverviewAnalyticsState(analytics: analytics);
  }

  Future<void> refresh() async {
    final previous = state.value;
    final period = previous?.selectedPeriod ?? DashboardTimePeriod.thisMonth;

    if (previous != null) {
      state = AsyncData(previous.copyWith(isRefreshing: true));
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() async {
      final analytics = await ref
          .read(employeeAnalyticsRepositoryProvider)
          .getOverviewAnalytics(period: period);
      return EmployeeOverviewAnalyticsState(
        analytics: analytics,
        selectedPeriod: period,
      );
    });
  }

  Future<void> setTimePeriod(DashboardTimePeriod period) async {
    final current = state.value;
    if (current == null || current.selectedPeriod == period) {
      return;
    }

    state = AsyncData(
      current.copyWith(selectedPeriod: period, isRefreshing: true),
    );

    try {
      final analytics = await ref
          .read(employeeAnalyticsRepositoryProvider)
          .getOverviewAnalytics(period: period);
      state = AsyncData(
        current.copyWith(
          analytics: analytics,
          selectedPeriod: period,
          isRefreshing: false,
        ),
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to load employee overview analytics',
        error: error,
        stackTrace: stackTrace,
        name: 'EmployeeOverviewAnalyticsNotifier',
      );
      state = AsyncData(current.copyWith(isRefreshing: false));
    }
  }
}

@riverpod
class EmployeeDetailAnalyticsNotifier
    extends _$EmployeeDetailAnalyticsNotifier {
  @override
  FutureOr<EmployeeDetailAnalyticsState> build(String employeeId) async {
    final analytics = await ref
        .read(employeeAnalyticsRepositoryProvider)
        .getDetailAnalytics(
          employeeId: EmployeeId(employeeId),
          period: DashboardTimePeriod.thisMonth,
        );

    return EmployeeDetailAnalyticsState(analytics: analytics);
  }

  Future<void> refresh() async {
    final previous = state.value;
    if (previous == null) {
      return;
    }

    state = AsyncData(previous.copyWith(isRefreshing: true));
    state = await AsyncValue.guard(() async {
      final analytics = await ref
          .read(employeeAnalyticsRepositoryProvider)
          .getDetailAnalytics(
            employeeId: EmployeeId(employeeId),
            period: previous.selectedPeriod,
          );

      return EmployeeDetailAnalyticsState(
        analytics: analytics,
        selectedPeriod: previous.selectedPeriod,
      );
    });
  }

  Future<void> setTimePeriod(DashboardTimePeriod period) async {
    final current = state.value;
    if (current == null || current.selectedPeriod == period) {
      return;
    }

    state = AsyncData(
      current.copyWith(selectedPeriod: period, isRefreshing: true),
    );

    try {
      final analytics = await ref
          .read(employeeAnalyticsRepositoryProvider)
          .getDetailAnalytics(
            employeeId: EmployeeId(employeeId),
            period: period,
          );

      state = AsyncData(
        current.copyWith(
          analytics: analytics,
          selectedPeriod: period,
          isRefreshing: false,
        ),
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to load employee detail analytics',
        error: error,
        stackTrace: stackTrace,
        name: 'EmployeeDetailAnalyticsNotifier',
      );
      state = AsyncData(current.copyWith(isRefreshing: false));
    }
  }
}
