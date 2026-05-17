import 'package:admin_panel/features/partner/transactions/data/data/transaction_mock_data.dart';
import 'package:admin_panel/features/partner/transactions/data/transactions_impl.repository.dart';
import 'package:admin_panel/features/partner/transactions/data/transactions_remote.datasource.dart';
import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/domain/transactions.repository.dart';
import 'package:admin_panel/features/partner/transactions/presentation/providers/transaction.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'filters transactions by search query and updates workflow actions',
    () async {
      final container = ProviderContainer(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(
            TransactionsImplRepository(
              remoteDataSource: TransactionsRemoteDataSourceMock(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(transactionsManagerProvider.notifier);

      notifier.setSearchQuery('BK-240408-001');
      final filtered = await notifier.getTransactions(startingAt: 0, count: 20);
      expect(filtered, hasLength(1));
      expect(filtered.single.reference, 'BK-240408-001');

      notifier.clearFilters();

      final targetId = TransactionRecordId('txn_240315_002');
      final before = await notifier.getTransactions(startingAt: 0, count: 20);
      expect(
        before.firstWhere((item) => item.id == targetId).settlementStatus,
        SettlementStatus.unsettled,
      );

      await notifier.markTransactionSettled(targetId);
      final after = await notifier.getTransactions(startingAt: 0, count: 20);
      expect(
        after.firstWhere((item) => item.id == targetId).settlementStatus,
        SettlementStatus.settled,
      );

      await notifier.approveRefundCase('rf_240406_001');
      final refundCases = await notifier.getRefundCases(
        startingAt: 0,
        count: 20,
      );
      expect(
        refundCases
            .firstWhere((item) => item.id.value == 'rf_240406_001')
            .status,
        RefundCaseStatus.approved,
      );
    },
  );

  test('table search does not refresh summary or trend providers', () async {
    final repository = _CountingTransactionsRepository();
    final container = ProviderContainer(
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(financeSummaryProvider.future);
    await container.read(financeTrendProvider.future);

    expect(repository.summaryCalls, 1);
    expect(repository.trendCalls, 1);
    expect(repository.summaryFilters.single.searchQuery, isEmpty);
    expect(repository.trendFilters.single.searchQuery, isEmpty);

    final notifier = container.read(transactionsManagerProvider.notifier);
    notifier.setSearchQuery('BK-240408-001');

    final filtered = await notifier.getTransactions(startingAt: 0, count: 20);
    expect(filtered, hasLength(1));
    expect(filtered.single.reference, 'BK-240408-001');

    await Future<void>.delayed(Duration.zero);
    await container.read(financeSummaryProvider.future);
    await container.read(financeTrendProvider.future);

    expect(repository.summaryCalls, 1);
    expect(repository.trendCalls, 1);
    expect(repository.transactionFilters.last.searchQuery, 'BK-240408-001');
  });
}

class _CountingTransactionsRepository implements TransactionsRepository {
  int summaryCalls = 0;
  int trendCalls = 0;
  int transactionCalls = 0;
  final summaryFilters = <FinanceFilter>[];
  final trendFilters = <FinanceFilter>[];
  final transactionFilters = <FinanceFilter>[];

  @override
  Future<FinanceSummary> getFinanceSummary(
    FinanceFilter filter,
    FinancePeriod period,
  ) async {
    summaryCalls += 1;
    summaryFilters.add(filter);
    return const FinanceSummary(
      grossVolume: 1,
      netSettled: 1,
      pendingPayout: 0,
      refundExposure: 0,
      availableBalance: 1,
      pendingBalance: 0,
      currency: 'VND',
    );
  }

  @override
  Future<List<FinanceTrendPoint>> getFinanceTrend(
    FinanceFilter filter,
    FinancePeriod period,
  ) async {
    trendCalls += 1;
    trendFilters.add(filter);
    return [
      FinanceTrendPoint(
        date: DateTime(2026, 4, 9),
        grossAmount: 1,
        netAmount: 1,
        refundAmount: 0,
      ),
    ];
  }

  @override
  Future<List<TransactionRecord>> getTransactions({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) async {
    transactionCalls += 1;
    transactionFilters.add(filter);

    final query = filter.searchQuery.trim().toLowerCase();
    final records = TransactionMockData.buildTransactions().where((record) {
      if (query.isEmpty) return true;
      return record.id.value.toLowerCase().contains(query) ||
          record.reference.toLowerCase().contains(query) ||
          record.customerName.toLowerCase().contains(query);
    }).toList();

    if (startingAt >= records.length) return [];
    final end = (startingAt + count).clamp(0, records.length);
    return records.sublist(startingAt.clamp(0, records.length), end);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
