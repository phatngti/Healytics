import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue_data_point.entity.freezed.dart';

/// Single data point for the revenue time-series chart.
///
/// Each point represents the revenue amount at a
/// specific date, used to render area/line charts.
@freezed
abstract class RevenueDataPoint with _$RevenueDataPoint {
  const factory RevenueDataPoint({
    required DateTime date,
    required double revenue,
  }) = _RevenueDataPoint;
}
