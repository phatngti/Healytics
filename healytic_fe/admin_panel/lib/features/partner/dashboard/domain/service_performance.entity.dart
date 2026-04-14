import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_performance.entity.freezed.dart';

/// Performance metrics for a single health service.
///
/// Used to render the bar chart showing service
/// comparison on the dashboard.
@freezed
abstract class ServicePerformance with _$ServicePerformance {
  const factory ServicePerformance({
    required String serviceName,
    required int bookingCount,
    required double revenue,
    required double averageRating,
  }) = _ServicePerformance;
}
