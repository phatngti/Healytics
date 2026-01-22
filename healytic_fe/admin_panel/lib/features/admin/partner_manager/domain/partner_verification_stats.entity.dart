import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_verification_stats.entity.freezed.dart';
part 'partner_verification_stats.entity.g.dart';

/// Statistics for the partner verification dashboard
@freezed
abstract class PartnerVerificationStats with _$PartnerVerificationStats {
  const factory PartnerVerificationStats({
    @Default(0) int pendingReview,
    @Default(0) int highPriority,
    @Default(0) int activeToday,
    @Default('0h 0m') String avgWaitTime,
  }) = _PartnerVerificationStats;

  factory PartnerVerificationStats.fromJson(Map<String, dynamic> json) =>
      _$PartnerVerificationStatsFromJson(json);
}
