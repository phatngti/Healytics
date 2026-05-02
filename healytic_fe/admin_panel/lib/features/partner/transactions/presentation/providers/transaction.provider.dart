import 'package:admin_panel/features/partner/transactions/data/transactions_impl.repository.dart';
import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsManagerState {
  const TransactionsManagerState({
    this.activeTab = FinanceWorkspaceTab.transactions,
    this.selectedPeriod = FinancePeriod.thirtyDays,
    this.selectedMetric = FinanceMetric.gross,
    this.filter = const FinanceFilter(),
    this.reloadToken = 0,
  });

  final FinanceWorkspaceTab activeTab;
  final FinancePeriod selectedPeriod;
  final FinanceMetric selectedMetric;
  final FinanceFilter filter;
  final int reloadToken;

  TransactionsManagerState copyWith({
    FinanceWorkspaceTab? activeTab,
    FinancePeriod? selectedPeriod,
    FinanceMetric? selectedMetric,
    FinanceFilter? filter,
    int? reloadToken,
  }) {
    return TransactionsManagerState(
      activeTab: activeTab ?? this.activeTab,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedMetric: selectedMetric ?? this.selectedMetric,
      filter: filter ?? this.filter,
      reloadToken: reloadToken ?? this.reloadToken,
    );
  }
}

class TransactionsManagerNotifier extends Notifier<TransactionsManagerState> {
  @override
  TransactionsManagerState build() {
    return const TransactionsManagerState();
  }

  Future<int> getTransactionsTotalRows() async {
    final items = await ref
        .read(transactionsRepositoryProvider)
        .getTransactions(startingAt: 0, count: 100, filter: state.filter);
    return items.length;
  }

  Future<int> getPayoutsTotalRows() async {
    final items = await ref
        .read(transactionsRepositoryProvider)
        .getPayouts(startingAt: 0, count: 100, filter: state.filter);
    return items.length;
  }

  Future<int> getRefundCasesTotalRows() async {
    final items = await ref
        .read(transactionsRepositoryProvider)
        .getRefundCases(startingAt: 0, count: 100, filter: state.filter);
    return items.length;
  }

  Future<List<TransactionRecord>> getTransactions({
    required int startingAt,
    required int count,
  }) {
    return ref
        .read(transactionsRepositoryProvider)
        .getTransactions(
          startingAt: startingAt,
          count: count,
          filter: state.filter,
        );
  }

  Future<List<PayoutRecord>> getPayouts({
    required int startingAt,
    required int count,
  }) {
    return ref
        .read(transactionsRepositoryProvider)
        .getPayouts(startingAt: startingAt, count: count, filter: state.filter);
  }

  Future<List<RefundCaseRecord>> getRefundCases({
    required int startingAt,
    required int count,
  }) {
    return ref
        .read(transactionsRepositoryProvider)
        .getRefundCases(
          startingAt: startingAt,
          count: count,
          filter: state.filter,
        );
  }

  void setActiveTab(FinanceWorkspaceTab value) {
    state = state.copyWith(activeTab: value);
  }

  void setSelectedPeriod(FinancePeriod value) {
    state = state.copyWith(selectedPeriod: value);
  }

  void setSelectedMetric(FinanceMetric value) {
    state = state.copyWith(selectedMetric: value);
  }

  void setSearchQuery(String value) {
    state = state.copyWith(
      filter: state.filter.copyWith(searchQuery: value),
      reloadToken: state.reloadToken + 1,
    );
  }

  void updateFilter(FinanceFilter value) {
    state = state.copyWith(filter: value, reloadToken: state.reloadToken + 1);
  }

  void clearFilters() {
    state = state.copyWith(
      filter: const FinanceFilter(),
      reloadToken: state.reloadToken + 1,
    );
  }

  Future<void> markTransactionSettled(TransactionRecordId id) async {
    await ref.read(transactionsRepositoryProvider).markTransactionSettled(id);
    _bumpReload();
  }

  Future<void> flagTransactionForReview(TransactionRecordId id) async {
    await ref.read(transactionsRepositoryProvider).flagTransactionForReview(id);
    _bumpReload();
  }

  Future<void> approveRefundCase(String caseId) async {
    await ref.read(transactionsRepositoryProvider).approveRefundCase(caseId);
    _bumpReload();
  }

  Future<void> rejectRefundCase(String caseId) async {
    await ref.read(transactionsRepositoryProvider).rejectRefundCase(caseId);
    _bumpReload();
  }

  Future<void> retryPayout(String payoutId) async {
    await ref.read(transactionsRepositoryProvider).retryPayout(payoutId);
    _bumpReload();
  }

  Future<String> buildTransactionsCsv() async {
    final records = await ref
        .read(transactionsRepositoryProvider)
        .getTransactions(startingAt: 0, count: 100, filter: state.filter);
    final buffer = StringBuffer(
      'id,created_at,type,source,reference,customer,gross,fee,net,status,settlement\n',
    );
    for (final record in records) {
      buffer.writeln(
        [
          record.id.value,
          record.createdAt.toIso8601String(),
          record.type.label,
          record.sourceType.label,
          record.reference,
          record.customerName,
          record.grossAmount.toStringAsFixed(0),
          record.feeAmount.toStringAsFixed(0),
          record.netAmount.toStringAsFixed(0),
          record.status.label,
          record.settlementStatus.label,
        ].join(','),
      );
    }
    return buffer.toString();
  }

  Future<String> buildPayoutsCsv() async {
    final records = await ref
        .read(transactionsRepositoryProvider)
        .getPayouts(startingAt: 0, count: 100, filter: state.filter);
    final buffer = StringBuffer(
      'id,period,volume,fees_adjustments,net_payout,scheduled_date,method,status\n',
    );
    for (final record in records) {
      buffer.writeln(
        [
          record.id.value,
          record.periodLabel,
          record.includedVolume.toStringAsFixed(0),
          record.feesAdjustments.toStringAsFixed(0),
          record.netPayout.toStringAsFixed(0),
          record.scheduledDate.toIso8601String(),
          record.method,
          record.status.label,
        ].join(','),
      );
    }
    return buffer.toString();
  }

  Future<String> buildRefundCasesCsv() async {
    final records = await ref
        .read(transactionsRepositoryProvider)
        .getRefundCases(startingAt: 0, count: 100, filter: state.filter);
    final buffer = StringBuffer(
      'id,transaction_id,type,requested_at,amount,owner,status,sla_hours\n',
    );
    for (final record in records) {
      buffer.writeln(
        [
          record.id.value,
          record.transactionId.value,
          record.caseType.label,
          record.requestedAt.toIso8601String(),
          record.amount.toStringAsFixed(0),
          record.owner,
          record.status.label,
          record.slaHours,
        ].join(','),
      );
    }
    return buffer.toString();
  }

  void _bumpReload() {
    state = state.copyWith(reloadToken: state.reloadToken + 1);
  }
}

final transactionsManagerProvider =
    NotifierProvider<TransactionsManagerNotifier, TransactionsManagerState>(
      TransactionsManagerNotifier.new,
    );

final financeFilterProvider = Provider<FinanceFilter>((ref) {
  return ref.watch(transactionsManagerProvider.select((state) => state.filter));
});

final financeActiveTabProvider = Provider<FinanceWorkspaceTab>((ref) {
  return ref.watch(
    transactionsManagerProvider.select((state) => state.activeTab),
  );
});

final financeSelectedPeriodProvider = Provider<FinancePeriod>((ref) {
  return ref.watch(
    transactionsManagerProvider.select((state) => state.selectedPeriod),
  );
});

final financeSelectedMetricProvider = Provider<FinanceMetric>((ref) {
  return ref.watch(
    transactionsManagerProvider.select((state) => state.selectedMetric),
  );
});

final financeReloadTokenProvider = Provider<int>((ref) {
  return ref.watch(
    transactionsManagerProvider.select((state) => state.reloadToken),
  );
});

final financeSummaryProvider = FutureProvider<FinanceSummary>((ref) async {
  final filter = ref.watch(financeFilterProvider);
  final period = ref.watch(financeSelectedPeriodProvider);
  return ref
      .read(transactionsRepositoryProvider)
      .getFinanceSummary(filter, period);
});

final financeTrendProvider = FutureProvider<List<FinanceTrendPoint>>((
  ref,
) async {
  final filter = ref.watch(financeFilterProvider);
  final period = ref.watch(financeSelectedPeriodProvider);
  return ref
      .read(transactionsRepositoryProvider)
      .getFinanceTrend(filter, period);
});
