import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.entity.freezed.dart';

/// Aggregated KPI statistics for the partner dashboard.
///
/// All numeric values represent the totals or averages
/// for the currently selected time period.
@freezed
abstract class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    // Appointment metrics
    required int totalAppointments,
    required int completedAppointments,
    required int cancelledAppointments,
    required int pendingAppointments,

    // Revenue metrics
    required double totalRevenue,
    required double revenueGrowthPercent,

    // Service metrics
    required int totalServices,
    required int activeServices,

    // Employee metrics
    required int totalEmployees,
    required int activeEmployees,

    // Rating metrics
    required double averageRating,
    required int totalReviews,
  }) = _DashboardStats;
}
