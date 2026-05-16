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
  int? _transactionsCacheKey;
  Future<List<TransactionRecord>>? _transactionsCache;
  int? _payoutsCacheKey;
  Future<List<PayoutRecord>>? _payoutsCache;
  int? _refundCasesCacheKey;
  Future<List<RefundCaseRecord>>? _refundCasesCache;

  @override
  TransactionsManagerState build() {
    return const TransactionsManagerState();
  }

  Future<int> getTransactionsTotalRows() async {
    return (await _getAllTransactions()).length;
  }

  Future<int> getPayoutsTotalRows() async {
    return (await _getAllPayouts()).length;
  }

  Future<int> getRefundCasesTotalRows() async {
    return (await _getAllRefundCases()).length;
  }

  Future<List<TransactionRecord>> getTransactions({
    required int startingAt,
    required int count,
  }) async {
    final records = await _getAllTransactions();
    return _page(records, startingAt, count);
  }

  Future<List<PayoutRecord>> getPayouts({
    required int startingAt,
    required int count,
  }) async {
    final records = await _getAllPayouts();
    return _page(records, startingAt, count);
  }

  Future<List<RefundCaseRecord>> getRefundCases({
    required int startingAt,
    required int count,
  }) async {
    final records = await _getAllRefundCases();
    return _page(records, startingAt, count);
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

  Future<List<TransactionRecord>> _getAllTransactions() async {
    final cacheKey = _financeRowsKey(state);
    final cached = _transactionsCache;
    if (_transactionsCacheKey == cacheKey && cached != null) {
      return cached;
    }

    final future = _loadTransactions(cacheKey);
    _transactionsCacheKey = cacheKey;
    _transactionsCache = future;
    return future;
  }

  Future<List<TransactionRecord>> _loadTransactions(int cacheKey) async {
    try {
      return await ref
          .read(transactionsRepositoryProvider)
          .getTransactions(startingAt: 0, count: 100, filter: state.filter);
    } catch (_) {
      if (_transactionsCacheKey == cacheKey) {
        _transactionsCacheKey = null;
        _transactionsCache = null;
      }
      rethrow;
    }
  }

  Future<List<PayoutRecord>> _getAllPayouts() async {
    final cacheKey = _financeRowsKey(state);
    final cached = _payoutsCache;
    if (_payoutsCacheKey == cacheKey && cached != null) {
      return cached;
    }

    final future = _loadPayouts(cacheKey);
    _payoutsCacheKey = cacheKey;
    _payoutsCache = future;
    return future;
  }

  Future<List<PayoutRecord>> _loadPayouts(int cacheKey) async {
    try {
      return await ref
          .read(transactionsRepositoryProvider)
          .getPayouts(startingAt: 0, count: 100, filter: state.filter);
    } catch (_) {
      if (_payoutsCacheKey == cacheKey) {
        _payoutsCacheKey = null;
        _payoutsCache = null;
      }
      rethrow;
    }
  }

  Future<List<RefundCaseRecord>> _getAllRefundCases() async {
    final cacheKey = _financeRowsKey(state);
    final cached = _refundCasesCache;
    if (_refundCasesCacheKey == cacheKey && cached != null) {
      return cached;
    }

    final future = _loadRefundCases(cacheKey);
    _refundCasesCacheKey = cacheKey;
    _refundCasesCache = future;
    return future;
  }

  Future<List<RefundCaseRecord>> _loadRefundCases(int cacheKey) async {
    try {
      return await ref
          .read(transactionsRepositoryProvider)
          .getRefundCases(startingAt: 0, count: 100, filter: state.filter);
    } catch (_) {
      if (_refundCasesCacheKey == cacheKey) {
        _refundCasesCacheKey = null;
        _refundCasesCache = null;
      }
      rethrow;
    }
  }

  int _financeRowsKey(TransactionsManagerState state) {
    final filter = state.filter;
    return Object.hash(
      filter.searchQuery,
      filter.startDate,
      filter.endDate,
      filter.sourceType,
      filter.transactionType,
      filter.transactionStatus,
      filter.settlementStatus,
      filter.payoutStatus,
      filter.currency,
      state.reloadToken,
    );
  }

  List<T> _page<T>(List<T> items, int startingAt, int count) {
    if (startingAt >= items.length) return [];
    final end = (startingAt + count).clamp(0, items.length);
    return items.sublist(startingAt.clamp(0, items.length), end);
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
