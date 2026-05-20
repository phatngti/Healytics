import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_service_ranking.entity.freezed.dart';
part 'admin_dashboard_service_ranking.entity.g.dart';

@freezed
abstract class AdminServiceRankingItem with _$AdminServiceRankingItem {
  const factory AdminServiceRankingItem({
    required String serviceId,
    required String serviceName,
    required String categoryName,
    required String partnerName,
    required int rank,
    @Default(0) double grossRevenue,
    @Default(0) int bookingCount,
  }) = _AdminServiceRankingItem;

  factory AdminServiceRankingItem.fromJson(Map<String, dynamic> json) =>
      _$AdminServiceRankingItemFromJson(json);
}
