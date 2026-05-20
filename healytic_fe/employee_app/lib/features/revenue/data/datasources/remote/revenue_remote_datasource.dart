import 'dart:developer' show log;
import 'dart:math' show Random;

import 'package:employee_openapi/api.dart'
    show ApiException, EmployeeRevenuePeriod;
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/config/app_environment.dart';
import '../../../../../core/providers/api.provider.dart';
import '../../../../../core/services/api.service.dart';
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
  final ApiService apiService;
  RevenueRemoteDatasourceImpl({required this.apiService});

  // ── Mapping helpers ─────────────────────────

  EmployeeRevenuePeriod _mapPeriod(RevenuePeriod period) => switch (period) {
    RevenuePeriod.day => EmployeeRevenuePeriod.day,
    RevenuePeriod.month => EmployeeRevenuePeriod.month,
    RevenuePeriod.year => EmployeeRevenuePeriod.year,
  };

  RevenuePeriod _mapPeriodBack(EmployeeRevenuePeriod period) => switch (period) {
    EmployeeRevenuePeriod.day => RevenuePeriod.day,
    EmployeeRevenuePeriod.month => RevenuePeriod.month,
    EmployeeRevenuePeriod.year => RevenuePeriod.year,
    _ => RevenuePeriod.day,
  };

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // ── API methods ─────────────────────────────

  @override
  Future<RevenueSummaryEntity> getSummary({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    try {
      final dto = await apiService.employeeRevenueApi
          .employeeRevenueControllerGetSummary(
        period: _mapPeriod(period),
        date: _formatDate(date),
      );
      if (dto == null) {
        throw Exception('No revenue data available for the requested period');
      }
      return RevenueSummaryEntity(
        totalRevenue: dto.totalRevenue.toDouble(),
        totalCommission: dto.totalCommission.toDouble(),
        netEarnings: dto.netEarnings.toDouble(),
        completedAppointments: dto.completedAppointments.toInt(),
        canceledAppointments: dto.canceledAppointments.toInt(),
        period: _mapPeriodBack(dto.period),
        periodStart: dto.periodStart,
        periodEnd: dto.periodEnd,
      );
    } on ApiException catch (e) {
      log(
        'Failed to fetch revenue summary: ${e.code}',
        name: 'RevenueRemoteDatasource',
      );
      rethrow;
    }
  }

  @override
  Future<List<RevenueDataPoint>> getTrendData({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    try {
      final dtos = await apiService.employeeRevenueApi
          .employeeRevenueControllerGetTrend(
        period: _mapPeriod(period),
        date: _formatDate(date),
      );
      if (dtos == null || dtos.isEmpty) return [];
      return dtos
          .map((dto) => RevenueDataPoint(
                date: dto.date,
                amount: dto.amount.toDouble(),
                label: dto.label,
              ))
          .toList();
    } on ApiException catch (e) {
      log(
        'Failed to fetch revenue trend: ${e.code}',
        name: 'RevenueRemoteDatasource',
      );
      rethrow;
    }
  }

  @override
  Future<List<RevenueBreakdownItem>> getBreakdown({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    try {
      final dtos = await apiService.employeeRevenueApi
          .employeeRevenueControllerGetBreakdown(
        period: _mapPeriod(period),
        date: _formatDate(date),
      );
      if (dtos == null || dtos.isEmpty) return [];
      return dtos
          .map((dto) => RevenueBreakdownItem(
                serviceName: dto.serviceName,
                count: dto.count.toInt(),
                totalAmount: dto.totalAmount.toDouble(),
              ))
          .toList();
    } on ApiException catch (e) {
      log(
        'Failed to fetch revenue breakdown: ${e.code}',
        name: 'RevenueRemoteDatasource',
      );
      rethrow;
    }
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
  final apiService = ref.read(apiServiceProvider);
  return RevenueRemoteDatasourceImpl(apiService: apiService);
}
