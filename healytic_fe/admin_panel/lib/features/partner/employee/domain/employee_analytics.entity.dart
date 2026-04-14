import 'package:admin_panel/features/common/widgets/analytics/analytics_status_badge.widget.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_analytics.entity.freezed.dart';

@freezed
abstract class EmployeeOverviewAnalytics with _$EmployeeOverviewAnalytics {
  const factory EmployeeOverviewAnalytics({
    required int totalEmployees,
    required int activeEmployees,
    required int onLeaveEmployees,
    required int inactiveEmployees,
    required double utilizationRate,
    required double utilizationDelta,
    required double averageRating,
    required double ratingDelta,
    required int reviewCount,
    required List<EmployeeTrendPoint> trendPoints,
    required List<EmployeeRoleDistribution> roleDistribution,
    required List<EmployeePerformanceSummary> topPerformers,
    required List<EmployeeComplianceItem> complianceItems,
  }) = _EmployeeOverviewAnalytics;
}

@freezed
abstract class EmployeeDetailAnalytics with _$EmployeeDetailAnalytics {
  const factory EmployeeDetailAnalytics({
    required EmployeeId employeeId,
    required int completedSessions,
    required double sessionsDelta,
    required double contributionValue,
    required double contributionDelta,
    required double utilizationRate,
    required double utilizationDelta,
    required double averageRating,
    required int reviewCount,
    required List<EmployeeTrendPoint> trendPoints,
    required List<EmployeeMixMetric> mixMetrics,
    required List<EmployeeScheduleLoad> scheduleLoad,
    required List<EmployeeQualityMetric> qualityMetrics,
    required List<EmployeeComplianceItem> complianceItems,
  }) = _EmployeeDetailAnalytics;
}

@freezed
abstract class EmployeeTrendPoint with _$EmployeeTrendPoint {
  const factory EmployeeTrendPoint({
    required String label,
    required double sessions,
    required double contributionValue,
  }) = _EmployeeTrendPoint;
}

@freezed
abstract class EmployeeRoleDistribution with _$EmployeeRoleDistribution {
  const factory EmployeeRoleDistribution({
    required String role,
    required int count,
  }) = _EmployeeRoleDistribution;
}

@freezed
abstract class EmployeePerformanceSummary with _$EmployeePerformanceSummary {
  const factory EmployeePerformanceSummary({
    required String employeeName,
    required String roleLabel,
    required double rating,
    required double utilizationRate,
    required double contributionValue,
  }) = _EmployeePerformanceSummary;
}

@freezed
abstract class EmployeeComplianceItem with _$EmployeeComplianceItem {
  const factory EmployeeComplianceItem({
    required String title,
    required String detail,
    required AnalyticsStatusTone tone,
  }) = _EmployeeComplianceItem;
}

@freezed
abstract class EmployeeMixMetric with _$EmployeeMixMetric {
  const factory EmployeeMixMetric({
    required String label,
    required int value,
    required double share,
  }) = _EmployeeMixMetric;
}

@freezed
abstract class EmployeeScheduleLoad with _$EmployeeScheduleLoad {
  const factory EmployeeScheduleLoad({
    required String label,
    required double availableHours,
    required double bookedHours,
  }) = _EmployeeScheduleLoad;
}

@freezed
abstract class EmployeeQualityMetric with _$EmployeeQualityMetric {
  const factory EmployeeQualityMetric({
    required String label,
    required String value,
    required String detail,
    required AnalyticsStatusTone tone,
  }) = _EmployeeQualityMetric;
}
