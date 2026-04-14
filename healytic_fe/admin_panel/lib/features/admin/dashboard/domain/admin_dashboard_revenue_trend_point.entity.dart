import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_revenue_trend_point.entity.freezed.dart';
part 'admin_dashboard_revenue_trend_point.entity.g.dart';

@freezed
abstract class AdminDashboardRevenueTrendPoint
    with _$AdminDashboardRevenueTrendPoint {
  const factory AdminDashboardRevenueTrendPoint({
    required DateTime date,
    @Default(0) double grossRevenue,
    @Default(0) double netRevenue,
    @Default(0) double refundAmount,
    @Default(0) int transactionCount,
    @Default(0) int successfulBookingCount,
  }) = _AdminDashboardRevenueTrendPoint;

  factory AdminDashboardRevenueTrendPoint.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardRevenueTrendPointFromJson(json);
}
