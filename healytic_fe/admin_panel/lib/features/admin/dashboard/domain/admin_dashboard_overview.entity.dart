import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_overview.entity.freezed.dart';
part 'admin_dashboard_overview.entity.g.dart';

@freezed
abstract class AdminDashboardOverview with _$AdminDashboardOverview {
  const factory AdminDashboardOverview({
    @Default(0) double grossRevenue,
    @Default(0) double netRevenue,
    @Default(0) double refundAmount,
    @Default(0) double failedPaymentAmount,
    @Default(0) double averageBookingValue,
    @Default(0) int successfulTransactions,
    @Default(0) int pendingTransactions,
    @Default(0) int refundedTransactions,
    @Default(0) int failedTransactions,
    @Default(0) int canceledTransactions,
    @Default(0) int totalPartners,
    @Default(0) int pendingPartnerReviews,
    @Default(0) double bookingSuccessRate,
    @Default(0) double bookingFailedRate,
    @Default(0) double bookingCanceledRate,
    @Default(0) int notificationVolume,
  }) = _AdminDashboardOverview;

  factory AdminDashboardOverview.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardOverviewFromJson(json);
}
