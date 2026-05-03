import 'dart:math';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/config/app_environment.dart';
import '../../../domain/entities/revenue.entity.dart';

part 'revenue_remote_datasource.g.dart';

abstract class RevenueRemoteDatasource {
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

class RevenueRemoteDatasourceImpl implements RevenueRemoteDatasource {
  @override
  Future<RevenueSummaryEntity> getSummary({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<List<RevenueDataPoint>> getTrendData({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<List<RevenueBreakdownItem>> getBreakdown({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    throw UnimplementedError('Real API not yet implemented');
  }
}

class RevenueRemoteDatasourceMock implements RevenueRemoteDatasource {
  final _rng = Random(42);

  @override
  Future<RevenueSummaryEntity> getSummary({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final d = date ?? DateTime.now();
    final (start, end) = _periodRange(period, d);
    final total = 500000.0 + _rng.nextDouble() * 9500000;
    final commission = total * 0.15;
    return RevenueSummaryEntity(
      totalRevenue: total,
      totalCommission: commission,
      netEarnings: total - commission,
      completedAppointments: 5 + _rng.nextInt(20),
      canceledAppointments: _rng.nextInt(4),
      period: period,
      periodStart: start,
      periodEnd: end,
    );
  }

  @override
  Future<List<RevenueDataPoint>> getTrendData({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final d = date ?? DateTime.now();
    return switch (period) {
      RevenuePeriod.day => _dailyTrend(d),
      RevenuePeriod.month => _monthlyTrend(d),
      RevenuePeriod.year => _yearlyTrend(d),
    };
  }

  List<RevenueDataPoint> _dailyTrend(DateTime d) {
    return List.generate(7, (i) {
      final day = d.subtract(Duration(days: 6 - i));
      return RevenueDataPoint(
        date: day,
        amount: 200000 + _rng.nextDouble() * 1800000,
        label: DateFormat('E').format(day),
      );
    });
  }

  List<RevenueDataPoint> _monthlyTrend(DateTime d) {
    return List.generate(12, (i) {
      final m = DateTime(d.year, i + 1);
      return RevenueDataPoint(
        date: m,
        amount: 2000000 + _rng.nextDouble() * 18000000,
        label: DateFormat('MMM').format(m),
      );
    });
  }

  List<RevenueDataPoint> _yearlyTrend(DateTime d) {
    return List.generate(5, (i) {
      final y = DateTime(d.year - 4 + i);
      return RevenueDataPoint(
        date: y,
        amount: 20000000 + _rng.nextDouble() * 180000000,
        label: '${y.year}',
      );
    });
  }

  @override
  Future<List<RevenueBreakdownItem>> getBreakdown({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return [
      RevenueBreakdownItem(
        serviceName: 'Deep Tissue Massage',
        count: 12,
        totalAmount: 10200000,
      ),
      RevenueBreakdownItem(
        serviceName: 'Facial Treatment',
        count: 8,
        totalAmount: 5200000,
      ),
      RevenueBreakdownItem(
        serviceName: 'Hot Stone Therapy',
        count: 6,
        totalAmount: 5700000,
      ),
      RevenueBreakdownItem(
        serviceName: 'Aromatherapy',
        count: 5,
        totalAmount: 3750000,
      ),
      RevenueBreakdownItem(
        serviceName: 'Swedish Massage',
        count: 4,
        totalAmount: 3200000,
      ),
      RevenueBreakdownItem(
        serviceName: 'Reflexology',
        count: 3,
        totalAmount: 1350000,
      ),
    ];
  }

  (DateTime, DateTime) _periodRange(RevenuePeriod p, DateTime d) => switch (p) {
    RevenuePeriod.day => (d, d),
    RevenuePeriod.month => (
      DateTime(d.year, d.month, 1),
      DateTime(d.year, d.month + 1, 0),
    ),
    RevenuePeriod.year => (DateTime(d.year, 1, 1), DateTime(d.year, 12, 31)),
  };
}

@Riverpod(keepAlive: true)
RevenueRemoteDatasource revenueRemoteDatasource(Ref ref) {
  if (AppEnvironment.current.useMock) return RevenueRemoteDatasourceMock();
  return RevenueRemoteDatasourceImpl();
}
