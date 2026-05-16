import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_verification_stats.entity.freezed.dart';
part 'partner_verification_stats.entity.g.dart';

/// Statistics for the partner verification dashboard.
/// Maps to AdminPartnerStatsResponseDto from backend.
@freezed
abstract class PartnerVerificationStats
    with _$PartnerVerificationStats {
  const factory PartnerVerificationStats({
    @Default(0) int pendingReview,
    @Default(0) int highPriority,
    @Default(0) int activeToday,
    @Default(0) int avgWaitSeconds,
    @Default('0m') String avgWaitTime,
    @Default(0) int totalProviders,
    @Default(0) int requiredResubmit,
    @Default(0) int approved,
    @Default(0) int rejected,
  }) = _PartnerVerificationStats;

  factory PartnerVerificationStats.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PartnerVerificationStatsFromJson(json);
}
