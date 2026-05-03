import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_transaction_health.entity.freezed.dart';
part 'admin_dashboard_transaction_health.entity.g.dart';

@freezed
abstract class AdminDashboardTransactionHealth
    with _$AdminDashboardTransactionHealth {
  const factory AdminDashboardTransactionHealth({
    @Default(0) int totalTransactions,
    @Default(0) int paid,
    @Default(0) int pending,
    @Default(0) int refunded,
    @Default(0) int failed,
    @Default(0) int canceled,
    @Default(0) double grossRevenue,
    @Default(0) double refundAmount,
    @Default(0) double failedAmount,
  }) = _AdminDashboardTransactionHealth;

  factory AdminDashboardTransactionHealth.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardTransactionHealthFromJson(json);
}
