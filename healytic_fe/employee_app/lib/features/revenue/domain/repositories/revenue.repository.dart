import '../entities/revenue.entity.dart';

/// Domain contract for revenue data.
abstract class RevenueRepository {
  Future<RevenueSummaryEntity> getSummary({
    required RevenuePeriod period,
    DateTime? date,
  });

  Future<List<RevenueDataPoint>> getTrendData({
    required RevenuePeriod period,
    DateTime? date,
  });

  Future<List<RevenueBreakdownItem>> getBreakdown({
    required RevenuePeriod period,
    DateTime? date,
  });
}
