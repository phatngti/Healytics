import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_partner_ranking.entity.freezed.dart';
part 'admin_dashboard_partner_ranking.entity.g.dart';

enum AdminPartnerVerificationStatus {
  pending,
  changesRequired,
  approved,
  rejected,
}

@freezed
abstract class AdminPartnerRankingItem with _$AdminPartnerRankingItem {
  const factory AdminPartnerRankingItem({
    required String partnerId,
    required String partnerName,
    required int rank,
    @Default(0) double grossRevenue,
    @Default(0) int bookingCount,
    @Default(0) double successfulBookingRate,
    @Default(AdminPartnerVerificationStatus.approved)
    AdminPartnerVerificationStatus verificationStatus,
  }) = _AdminPartnerRankingItem;

  factory AdminPartnerRankingItem.fromJson(Map<String, dynamic> json) =>
      _$AdminPartnerRankingItemFromJson(json);
}
