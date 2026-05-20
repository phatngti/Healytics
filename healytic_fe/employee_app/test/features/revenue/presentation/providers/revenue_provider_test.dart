import 'package:employee_app/features/revenue/data/repositories/revenue_impl.repository.dart';
import 'package:employee_app/features/revenue/domain/entities/revenue.entity.dart';
import 'package:employee_app/features/revenue/domain/repositories/revenue.repository.dart';
import 'package:employee_app/features/revenue/presentation/providers/revenue.provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('reselecting the active period does not reload revenue data', () async {
    final repo = _FakeRevenueRepository();
    final container = ProviderContainer(
      overrides: [revenueRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(revenueProvider.future);
    expect(repo.summaryCalls, 1);

    container.read(revenueFilterProvider.notifier).setPeriod(RevenuePeriod.day);

    expect(repo.summaryCalls, 1);

    container
        .read(revenueFilterProvider.notifier)
        .setPeriod(RevenuePeriod.month);
    await container.read(revenueProvider.future);

    expect(repo.summaryCalls, 2);
    expect(container.read(revenueFilterProvider).period, RevenuePeriod.month);
  });
}

class _FakeRevenueRepository implements RevenueRepository {
  int summaryCalls = 0;

  @override
  Future<RevenueSummaryEntity> getSummary({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    summaryCalls += 1;
    final selectedDate = date ?? DateTime(2026);
    return RevenueSummaryEntity(
      totalRevenue: 100,
      totalCommission: 10,
      netEarnings: 90,
      completedAppointments: 1,
      canceledAppointments: 0,
      period: period,
      periodStart: selectedDate,
      periodEnd: selectedDate,
    );
  }

  @override
  Future<List<RevenueDataPoint>> getTrendData({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    return [
      RevenueDataPoint(
        date: date ?? DateTime(2026),
        amount: 100,
        label: period.displayLabel,
      ),
    ];
  }

  @override
  Future<List<RevenueBreakdownItem>> getBreakdown({
    required RevenuePeriod period,
    DateTime? date,
  }) async {
    return const [
      RevenueBreakdownItem(
        serviceName: 'Consultation',
        count: 1,
        totalAmount: 100,
      ),
    ];
  }
}
