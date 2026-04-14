import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_booking_outcome.entity.freezed.dart';
part 'admin_dashboard_booking_outcome.entity.g.dart';

@freezed
abstract class AdminOutcomeMetric with _$AdminOutcomeMetric {
  const factory AdminOutcomeMetric({
    @Default(0) int count,
    @Default(0) double rate,
  }) = _AdminOutcomeMetric;

  factory AdminOutcomeMetric.fromJson(Map<String, dynamic> json) =>
      _$AdminOutcomeMetricFromJson(json);
}

@freezed
abstract class AdminDashboardBookingOutcomeSummary
    with _$AdminDashboardBookingOutcomeSummary {
  const factory AdminDashboardBookingOutcomeSummary({
    @Default(0) int totalBookings,
    @Default(AdminOutcomeMetric()) AdminOutcomeMetric success,
    @Default(AdminOutcomeMetric()) AdminOutcomeMetric failed,
    @Default(AdminOutcomeMetric()) AdminOutcomeMetric canceled,
  }) = _AdminDashboardBookingOutcomeSummary;

  factory AdminDashboardBookingOutcomeSummary.fromJson(
    Map<String, dynamic> json,
  ) => _$AdminDashboardBookingOutcomeSummaryFromJson(json);
}
